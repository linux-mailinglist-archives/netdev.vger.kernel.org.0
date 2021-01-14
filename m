Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7BD2F63ED
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbhANPMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:12:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38728 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729246AbhANPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:11:39 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 14 Jan 2021 17:10:44 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EFAh07000835;
        Thu, 14 Jan 2021 17:10:44 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, dsahern@gmail.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v2 net-next 07/21] nvme-tcp: Add DDP data-path
Date:   Thu, 14 Jan 2021 17:10:19 +0200
Message-Id: <20210114151033.13020-8-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210114151033.13020-1-borisp@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the NVMe-TCP DDP data-path offload.
Using this interface, the NIC hardware will scatter TCP payload directly
to the BIO pages according to the command_id in the PDU.
To maintain the correctness of the network stack, the driver is expected
to construct SKBs that point to the BIO pages.

The data-path interface contains two routines: tcp_ddp_setup/teardown.
The setup provides the mapping from command_id to the request buffers,
while the teardown removes this mapping.

For efficiency, we introduce an asynchronous nvme completion, which is
split between NVMe-TCP and the NIC driver as follows:
NVMe-TCP performs the specific completion, while NIC driver performs the
generic mq_blk completion.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 141 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 131 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 31bf9e3ea236..9a43bd31ec15 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -57,6 +57,11 @@ struct nvme_tcp_request {
 	size_t			offset;
 	size_t			data_sent;
 	enum nvme_tcp_send_state state;
+
+	bool			offloaded;
+	struct tcp_ddp_io	ddp;
+	__le16			status;
+	union nvme_result	result;
 };
 
 enum nvme_tcp_queue_flags {
@@ -231,10 +236,74 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 #ifdef CONFIG_TCP_DDP
 
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
 	.resync_request		= nvme_tcp_resync_request,
+	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
 };
 
+static
+int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+			  u16 command_id,
+			  struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	int ret;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return -EINVAL;
+	}
+
+	ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
+						    &req->ddp, rq);
+	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+	req->offloaded = false;
+	return ret;
+}
+
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
+{
+	struct request *rq = ddp_ctx;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (!nvme_try_complete_req(rq, cpu_to_le16(req->status << 1), req->result))
+		nvme_complete_rq(rq);
+}
+
+static
+int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
+		       u16 command_id,
+		       struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	int ret;
+
+	req->offloaded = false;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return -EINVAL;
+	}
+
+	req->ddp.command_id = command_id;
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
+				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
+	if (ret)
+		return -ENOMEM;
+	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
+
+	ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
+						 queue->sock->sk,
+						 &req->ddp);
+	if (!ret)
+		req->offloaded = true;
+	return ret;
+}
+
 static
 int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
@@ -375,6 +444,25 @@ bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
+static
+int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
+		       u16 command_id,
+		       struct request *rq)
+{
+	return -EINVAL;
+}
+
+static
+int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+			  u16 command_id,
+			  struct request *rq)
+{
+	return -EINVAL;
+}
+
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
+{}
+
 static
 int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
@@ -653,6 +741,7 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
+	struct nvme_tcp_request *req;
 	struct request *rq;
 
 	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), cqe->command_id);
@@ -664,8 +753,15 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		return -EINVAL;
 	}
 
-	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
-		nvme_complete_rq(rq);
+	req = blk_mq_rq_to_pdu(rq);
+	if (req->offloaded) {
+		req->status = cqe->status;
+		req->result = cqe->result;
+		nvme_tcp_teardown_ddp(queue, cqe->command_id, rq);
+	} else {
+		if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
+			nvme_complete_rq(rq);
+	}
 	queue->nr_cqe++;
 
 	return 0;
@@ -859,9 +955,18 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 {
 	union nvme_result res = {};
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 
-	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
-		nvme_complete_rq(rq);
+	if (req->offloaded) {
+		req->status = cpu_to_le16(status << 1);
+		req->result = res;
+		nvme_tcp_teardown_ddp(queue, pdu->command_id, rq);
+	} else {
+		if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
+			nvme_complete_rq(rq);
+	}
 }
 
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
@@ -908,12 +1013,22 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
-			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
-				&req->iter, recv_len, queue->rcv_hash);
-		else
-			ret = skb_copy_datagram_iter(skb, *offset,
-					&req->iter, recv_len);
+		if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
+			if (queue->data_digest)
+				ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset,
+						&req->iter, recv_len, queue->rcv_hash);
+			else
+				ret = skb_ddp_copy_datagram_iter(skb, *offset,
+						&req->iter, recv_len);
+		} else {
+			if (queue->data_digest)
+				ret = skb_copy_and_hash_datagram_iter(skb, *offset,
+						&req->iter, recv_len, queue->rcv_hash);
+			else
+				ret = skb_copy_datagram_iter(skb, *offset,
+						&req->iter, recv_len);
+		}
+
 		if (ret) {
 			dev_err(queue->ctrl->ctrl.device,
 				"queue %d failed to copy request %#x data",
@@ -1137,6 +1252,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	bool inline_data = nvme_tcp_has_inline_data(req);
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) + hdgst - req->offset;
+	struct request *rq = blk_mq_rq_from_pdu(req);
 	int flags = MSG_DONTWAIT;
 	int ret;
 
@@ -1145,6 +1261,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	else
 		flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
+	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
+		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
@@ -2447,6 +2567,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	req->data_len = blk_rq_nr_phys_segments(rq) ?
 				blk_rq_payload_bytes(rq) : 0;
 	req->curr_bio = rq->bio;
+	req->offloaded = false;
 
 	if (rq_data_dir(rq) == WRITE &&
 	    req->data_len <= nvme_tcp_inline_data_size(queue))
-- 
2.24.1

