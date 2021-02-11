Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ECE3194F2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhBKVN2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 16:13:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18884 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhBKVMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:12:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60259d870001>; Thu, 11 Feb 2021 13:11:35 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 21:11:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 21:11:23 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v4 net-next  07/21] nvme-tcp: Add DDP data-path
Date:   Thu, 11 Feb 2021 23:10:30 +0200
Message-ID: <20210211211044.32701-8-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
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
 drivers/nvme/host/tcp.c | 158 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 146 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 36de4391ba76..188e26ab7116 100644
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
@@ -229,13 +234,82 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
+{
+	int ret;
+
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ret = sg_alloc_table_chained(&req->ddp.sg_table, blk_rq_nr_phys_segments(rq),
+				     req->ddp.sg_table.sgl, SG_CHUNK_SIZE);
+	if (ret)
+		return -ENOMEM;
+	req->ddp.nents = blk_rq_map_sg(rq->q, rq, req->ddp.sg_table.sgl);
+	return 0;
+}
+
 #ifdef CONFIG_TCP_DDP
 
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
 	.resync_request		= nvme_tcp_resync_request,
+	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
 };
 
+static int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+				 u16 command_id,
+				 struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	int ret;
+
+	if (unlikely(!netdev)) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		return -EINVAL;
+	}
+
+	ret = netdev->tcp_ddp_ops->tcp_ddp_teardown(netdev, queue->sock->sk,
+						    &req->ddp, rq);
+	sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+	return ret;
+}
+
+static void nvme_tcp_ddp_teardown_done(void *ddp_ctx)
+{
+	struct request *rq = ddp_ctx;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (!nvme_try_complete_req(rq, req->status, req->result))
+		nvme_complete_rq(rq);
+}
+
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
+			      u16 command_id,
+			      struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	int ret;
+
+	if (unlikely(!netdev)) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		return -EINVAL;
+	}
+
+	req->ddp.command_id = command_id;
+	ret = nvme_tcp_req_map_sg(req, rq);
+	if (ret)
+		return -ENOMEM;
+
+	ret = netdev->tcp_ddp_ops->tcp_ddp_setup(netdev,
+						 queue->sock->sk,
+						 &req->ddp);
+	if (!ret)
+		req->offloaded = true;
+	return ret;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
@@ -343,7 +417,7 @@ static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
 		return;
 
 	if (unlikely(!netdev)) {
-		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
 		return;
 	}
 
@@ -368,6 +442,20 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
+static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue,
+			      u16 command_id,
+			      struct request *rq)
+{
+	return -EINVAL;
+}
+
+static int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
+				 u16 command_id,
+				 struct request *rq)
+{
+	return -EINVAL;
+}
+
 static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	return -EINVAL;
@@ -643,6 +731,24 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
 	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
+static void nvme_tcp_complete_request(struct request *rq,
+				      __le16 status,
+				      union nvme_result result,
+				      __u16 command_id)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+
+	if (req->offloaded) {
+		req->status = status;
+		req->result = result;
+		nvme_tcp_teardown_ddp(queue, command_id, rq);
+	} else {
+		if (!nvme_try_complete_req(rq, status, result))
+			nvme_complete_rq(rq);
+	}
+}
+
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
@@ -657,10 +763,8 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		return -EINVAL;
 	}
 
-	if (!nvme_try_complete_req(rq, cqe->status, cqe->result))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, cqe->status, cqe->result, cqe->command_id);
 	queue->nr_cqe++;
-
 	return 0;
 }
 
@@ -849,10 +953,39 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
 {
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+	struct nvme_tcp_data_pdu *pdu = (void *)queue->pdu;
 	union nvme_result res = {};
 
-	if (!nvme_try_complete_req(rq, cpu_to_le16(status << 1), res))
-		nvme_complete_rq(rq);
+	nvme_tcp_complete_request(rq, cpu_to_le16(status << 1), res, pdu->command_id);
+}
+
+
+static int nvme_tcp_consume_skb(struct nvme_tcp_queue *queue, struct sk_buff *skb,
+				unsigned int *offset, struct iov_iter *iter, int recv_len)
+{
+	int ret;
+
+#ifdef CONFIG_TCP_DDP
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
+		if (queue->data_digest)
+			ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
+					queue->rcv_hash);
+		else
+			ret = skb_ddp_copy_datagram_iter(skb, *offset, iter, recv_len);
+	} else {
+#endif
+		if (queue->data_digest)
+			ret = skb_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
+					queue->rcv_hash);
+		else
+			ret = skb_copy_datagram_iter(skb, *offset, iter, recv_len);
+#ifdef CONFIG_TCP_DDP
+	}
+#endif
+
+	return ret;
 }
 
 static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
@@ -899,12 +1032,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
-			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
-				&req->iter, recv_len, queue->rcv_hash);
-		else
-			ret = skb_copy_datagram_iter(skb, *offset,
-					&req->iter, recv_len);
+		ret = nvme_tcp_consume_skb(queue, skb, offset, &req->iter, recv_len);
 		if (ret) {
 			dev_err(queue->ctrl->ctrl.device,
 				"queue %d failed to copy request %#x data",
@@ -1128,6 +1256,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	bool inline_data = nvme_tcp_has_inline_data(req);
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) + hdgst - req->offset;
+	struct request *rq = blk_mq_rq_from_pdu(req);
 	int flags = MSG_DONTWAIT;
 	int ret;
 
@@ -1136,6 +1265,10 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	else
 		flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) &&
+	    blk_rq_nr_phys_segments(rq) && rq_data_dir(rq) == READ)
+		nvme_tcp_setup_ddp(queue, pdu->cmd.common.command_id, rq);
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
@@ -2441,6 +2574,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	req->data_len = blk_rq_nr_phys_segments(rq) ?
 				blk_rq_payload_bytes(rq) : 0;
 	req->curr_bio = rq->bio;
+	req->offloaded = false;
 
 	if (rq_data_dir(rq) == WRITE &&
 	    req->data_len <= nvme_tcp_inline_data_size(queue))
-- 
2.24.1

