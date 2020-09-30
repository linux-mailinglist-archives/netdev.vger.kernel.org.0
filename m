Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4750727EEEE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgI3QUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50515 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731304AbgI3QUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:35 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:28 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2I032498;
        Wed, 30 Sep 2020 19:20:28 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH net-next RFC v1 07/10] nvme-tcp : Recalculate crc in the end of the capsule
Date:   Wed, 30 Sep 2020 19:20:07 +0300
Message-Id: <20200930162010.21610-8-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@mellanox.com>

crc offload of the nvme capsule. Check if all the skb bits
are on, and if not recalculate the crc in SW and check it.

This patch reworks the receive-side crc calculation to always
run at the end, so as to keep a single flow for both offload
and non-offload. This change simplifies the code, but it may degrade
performance for non-offload crc calculation.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 66 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7bd97f856677..9a620d1dacb4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -94,6 +94,7 @@ struct nvme_tcp_queue {
 	size_t			data_remaining;
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
+	bool			crc_valid;
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -233,6 +234,41 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+static inline bool nvme_tcp_device_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return queue->crc_valid;
+}
+
+static inline void nvme_tcp_device_ddgst_update(struct nvme_tcp_queue *queue,
+						struct sk_buff *skb)
+{
+	if (queue->crc_valid)
+#ifdef CONFIG_TCP_DDP_CRC
+		queue->crc_valid = skb->ddp_crc;
+#else
+		queue->crc_valid = false;
+#endif
+}
+
+static void nvme_tcp_crc_recalculate(struct nvme_tcp_queue *queue,
+				     struct nvme_tcp_data_pdu *pdu)
+{
+	struct nvme_tcp_request *req;
+	struct request *rq;
+
+	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+	if (!rq)
+		return;
+	req = blk_mq_rq_to_pdu(rq);
+	crypto_ahash_init(queue->rcv_hash);
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	/* req->ddp.sg_table is allocated and filled in nvme_tcp_setup_ddp */
+	ahash_request_set_crypt(queue->rcv_hash, req->ddp.sg_table.sgl, NULL,
+				le32_to_cpu(pdu->data_length));
+	crypto_ahash_update(queue->rcv_hash);
+}
+
+
 #ifdef CONFIG_TCP_DDP
 
 bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
@@ -706,6 +742,7 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+	queue->crc_valid = true;
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -955,6 +992,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	struct nvme_tcp_request *req;
 	struct request *rq;
 
+	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
+		nvme_tcp_device_ddgst_update(queue, skb);
 	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
@@ -992,7 +1031,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest && !test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1012,7 +1051,6 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 	if (!queue->data_remaining) {
 		if (queue->data_digest) {
-			nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
 			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
 		} else {
 			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
@@ -1033,8 +1071,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	char *ddgst = (char *)&queue->recv_ddgst;
 	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
 	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
+	bool ddgst_offload_fail;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
+		nvme_tcp_device_ddgst_update(queue, skb);
 	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
 	if (unlikely(ret))
 		return ret;
@@ -1045,12 +1086,21 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	if (queue->ddgst_remaining)
 		return 0;
 
-	if (queue->recv_ddgst != queue->exp_ddgst) {
-		dev_err(queue->ctrl->ctrl.device,
-			"data digest error: recv %#x expected %#x\n",
-			le32_to_cpu(queue->recv_ddgst),
-			le32_to_cpu(queue->exp_ddgst));
-		return -EIO;
+	ddgst_offload_fail = !nvme_tcp_device_ddgst_ok(queue);
+	if (!test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) ||
+	    ddgst_offload_fail) {
+		if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags) &&
+		    ddgst_offload_fail)
+			nvme_tcp_crc_recalculate(queue, pdu);
+
+		nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
+		if (queue->recv_ddgst != queue->exp_ddgst) {
+			dev_err(queue->ctrl->ctrl.device,
+				"data digest error: recv %#x expected %#x\n",
+				le32_to_cpu(queue->recv_ddgst),
+				le32_to_cpu(queue->exp_ddgst));
+			return -EIO;
+		}
 	}
 
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-- 
2.24.1

