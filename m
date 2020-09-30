Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0831527EEEC
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgI3QUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:20:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50485 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731307AbgI3QUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:20:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 30 Sep 2020 19:20:28 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08UGKR2G032498;
        Wed, 30 Sep 2020 19:20:27 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH net-next RFC v1 05/10] nvme-tcp: Add DDP offload control path
Date:   Wed, 30 Sep 2020 19:20:05 +0300
Message-Id: <20200930162010.21610-6-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200930162010.21610-1-borisp@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake
using the tcp_ddp_sk_add/del NDOs.

Additionally, a resynchronization routine is used to assist
hardware recovery from TCP OOO, and continue the offload.
Resynchronization operates as follows:
1. TCP OOO causes the NIC HW to stop the offload
2. NIC HW identifies a PDU header at some TCP sequence number,
and asks NVMe-TCP to confirm it.
This request is delivered from the NIC driver to NVMe-TCP by first
finding the socket for the packet that triggered the request, and
then fiding the nvme_tcp_queue that is used by this routine.
Finally, the request is recorded in the nvme_tcp_queue.
3. When NVMe-TCP observes the requested TCP sequence, it will compare
it with the PDU header TCP sequence, and report the result to the
NIC driver (tcp_ddp_resync), which will update the HW,
and resume offload when all is successful.

Furthermore, we let the offloading driver advertise what is the max hw
sectors/segments via tcp_ddp_limits.

A follow-up patch introduces the data-path changes required for this
offload.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c  | 188 +++++++++++++++++++++++++++++++++++++++
 include/linux/nvme-tcp.h |   2 +
 2 files changed, 190 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8f4f29f18b8c..06711ac095f2 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -62,6 +62,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	= 0,
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
+	NVME_TCP_Q_OFFLOADS     = 3,
 };
 
 enum nvme_tcp_recv_state {
@@ -110,6 +111,8 @@ struct nvme_tcp_queue {
 	void (*state_change)(struct sock *);
 	void (*data_ready)(struct sock *);
 	void (*write_space)(struct sock *);
+
+	atomic64_t  resync_req;
 };
 
 struct nvme_tcp_ctrl {
@@ -129,6 +132,8 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device       *offloading_netdev;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -223,6 +228,159 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_TCP_DDP
+
+bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops __read_mostly = {
+	.resync_request		= nvme_tcp_resync_request,
+};
+
+static
+int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
+			    struct nvme_tcp_config *config)
+{
+	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
+	struct tcp_ddp_config *ddp_config = (struct tcp_ddp_config *)config;
+	int ret;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!(netdev->features & NETIF_F_HW_TCP_DDP)) {
+		dev_put(netdev);
+		return -EINVAL;
+	}
+
+	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
+						 queue->sock->sk,
+						 ddp_config);
+	if (!ret)
+		inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
+	else
+		dev_put(netdev);
+	return ret;
+}
+
+static
+void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return;
+	}
+
+	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* put the queue_init get_netdev_for_sock() */
+}
+
+static
+int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+			    struct tcp_ddp_limits *limits)
+{
+	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
+	int ret = 0;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return -EINVAL;
+	}
+
+	if (netdev->features & NETIF_F_HW_TCP_DDP &&
+	    netdev->tcp_ddp_ops &&
+	    netdev->tcp_ddp_ops->tcp_ddp_limits)
+			ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, limits);
+	else
+			ret = -EOPNOTSUPP;
+
+	if (!ret) {
+		queue->ctrl->offloading_netdev = netdev;
+		pr_info("%s netdev %s offload limits: max_ddp_sgl_len %d\n",
+			__func__, netdev->name, limits->max_ddp_sgl_len);
+		queue->ctrl->ctrl.max_segments = limits->max_ddp_sgl_len;
+		queue->ctrl->ctrl.max_hw_sectors =
+			limits->max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
+	} else {
+		queue->ctrl->offloading_netdev = NULL;
+	}
+
+	dev_put(netdev);
+
+	return ret;
+}
+
+static
+void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+			      unsigned int pdu_seq)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	u64 resync_val;
+	u32 resync_seq;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return;
+	}
+
+	resync_val = atomic64_read(&queue->resync_req);
+	if ((resync_val & TCP_DDP_RESYNC_REQ) == 0)
+		return;
+
+	resync_seq = resync_val >> 32;
+	if (before(pdu_seq, resync_seq))
+		return;
+
+	if (atomic64_cmpxchg(&queue->resync_req, resync_val, (resync_val - 1)))
+		netdev->tcp_ddp_ops->tcp_ddp_resync(netdev, queue->sock->sk, pdu_seq);
+}
+
+bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
+{
+	struct nvme_tcp_queue *queue = sk->sk_user_data;
+
+	atomic64_set(&queue->resync_req,
+		     (((uint64_t)seq << 32) | flags));
+
+	return true;
+}
+
+#else
+
+static
+int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue,
+			    struct nvme_tcp_config *config)
+{
+	return -EINVAL;
+}
+
+static
+void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{}
+
+static
+int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
+			    struct tcp_ddp_limits *limits)
+{
+	return -EINVAL;
+}
+
+static
+void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+			      unsigned int pdu_seq)
+{}
+
+bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
+{
+	return false;
+}
+
+#endif
+
 static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
 		unsigned int dir)
 {
@@ -628,6 +786,11 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	u64 pdu_seq = TCP_SKB_CB(skb)->seq + *offset - queue->pdu_offset;
+
+	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
+		nvme_tcp_resync_response(queue, pdu_seq);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1370,6 +1533,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
+	struct nvme_tcp_config config;
+	struct tcp_ddp_limits limits;
 	int ret, rcv_pdu_size;
 
 	queue->ctrl = ctrl;
@@ -1487,6 +1652,26 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 #endif
 	write_unlock_bh(&queue->sock->sk->sk_callback_lock);
 
+	if (nvme_tcp_queue_id(queue) != 0) {
+		config.cfg.type		= TCP_DDP_NVME;
+		config.pfv		= NVME_TCP_PFV_1_0;
+		config.cpda		= 0;
+		config.dgst		= queue->hdr_digest ?
+						NVME_TCP_HDR_DIGEST_ENABLE : 0;
+		config.dgst		|= queue->data_digest ?
+						NVME_TCP_DATA_DIGEST_ENABLE : 0;
+		config.queue_size	= queue->queue_size;
+		config.queue_id		= nvme_tcp_queue_id(queue);
+		config.io_cpu		= queue->io_cpu;
+
+		ret = nvme_tcp_offload_socket(queue, &config);
+		if (!ret)
+			set_bit(NVME_TCP_Q_OFFLOADS, &queue->flags);
+	} else {
+		ret = nvme_tcp_offload_limits(queue, &limits);
+	}
+	/* offload is opportunistic - failure is non-critical */
+
 	return 0;
 
 err_init_connect:
@@ -1519,6 +1704,9 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+
+	if (test_bit(NVME_TCP_Q_OFFLOADS, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 959e0bd9a913..65df64c34ecd 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -8,6 +8,8 @@
 #define _LINUX_NVME_TCP_H
 
 #include <linux/nvme.h>
+#include <net/sock.h>
+#include <net/tcp_ddp.h>
 
 #define NVME_TCP_DISC_PORT	8009
 #define NVME_TCP_ADMIN_CCSZ	SZ_8K
-- 
2.24.1

