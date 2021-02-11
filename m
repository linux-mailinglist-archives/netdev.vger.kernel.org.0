Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7E3194F3
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhBKVNm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Feb 2021 16:13:42 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9245 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhBKVMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:12:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60259d870000>; Thu, 11 Feb 2021 13:11:35 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 21:11:22 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 21:11:18 +0000
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
Subject: [PATCH v4 net-next  06/21] nvme-tcp: Add DDP offload control path
Date:   Thu, 11 Feb 2021 23:10:29 +0200
Message-ID: <20210211211044.32701-7-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces direct data placement offload to NVME
TCP. There is a context per queue, which is established after the
handshake using the tcp_ddp_sk_add/del NDOs.

Additionally, a resynchronization routine is used to assist
hardware recovery from TCP OOO, and continue the offload.
Resynchronization operates as follows:

1. TCP OOO causes the NIC HW to stop the offload

2. NIC HW identifies a PDU header at some TCP sequence number,
and asks NVMe-TCP to confirm it.
This request is delivered from the NIC driver to NVMe-TCP by first
finding the socket for the packet that triggered the request, and
then finding the nvme_tcp_queue that is used by this routine.
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
 drivers/nvme/host/tcp.c | 177 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 175 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 881d28eb15e9..36de4391ba76 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -14,6 +14,7 @@
 #include <linux/blk-mq.h>
 #include <crypto/hash.h>
 #include <net/busy_poll.h>
+#include <net/tcp_ddp.h>
 
 #include "nvme.h"
 #include "fabrics.h"
@@ -62,6 +63,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	= 0,
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
+	NVME_TCP_Q_OFF_DDP	= 3,
 };
 
 enum nvme_tcp_recv_state {
@@ -111,6 +113,8 @@ struct nvme_tcp_queue {
 	void (*state_change)(struct sock *);
 	void (*data_ready)(struct sock *);
 	void (*write_space)(struct sock *);
+
+	atomic64_t  resync_req;
 };
 
 struct nvme_tcp_ctrl {
@@ -129,6 +133,8 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct net_device       *offloading_netdev;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -223,6 +229,164 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+#ifdef CONFIG_TCP_DDP
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
+static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
+	.resync_request		= nvme_tcp_resync_request,
+};
+
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	struct nvme_tcp_ddp_config config = {};
+	int ret;
+
+	if (!(netdev->features & NETIF_F_HW_TCP_DDP))
+		return -EOPNOTSUPP;
+
+	config.cfg.type		= TCP_DDP_NVME;
+	config.pfv		= NVME_TCP_PFV_1_0;
+	config.cpda		= 0;
+	config.dgst		= queue->hdr_digest ?
+		NVME_TCP_HDR_DIGEST_ENABLE : 0;
+	config.dgst		|= queue->data_digest ?
+		NVME_TCP_DATA_DIGEST_ENABLE : 0;
+	config.queue_size	= queue->queue_size;
+	config.queue_id		= nvme_tcp_queue_id(queue);
+	config.io_cpu		= queue->io_cpu;
+
+	dev_hold(netdev); /* put by unoffload_socket */
+	ret = netdev->tcp_ddp_ops->tcp_ddp_sk_add(netdev,
+						  queue->sock->sk,
+						  &config.cfg);
+	if (ret) {
+		dev_put(netdev);
+		return ret;
+	}
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
+	if (netdev->features & NETIF_F_HW_TCP_DDP)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+
+	return ret;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+
+	if (!netdev) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		return;
+	}
+
+	netdev->tcp_ddp_ops->tcp_ddp_sk_del(netdev, queue->sock->sk);
+
+	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
+	dev_put(netdev); /* held by offload_socket */
+}
+
+static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
+{
+	struct net_device *netdev = get_netdev_for_sock(queue->sock->sk, true);
+	struct tcp_ddp_limits limits;
+	int ret = 0;
+
+	if (!netdev) {
+		dev_info_ratelimited(queue->ctrl->ctrl.device, "netdev not found\n");
+		queue->ctrl->offloading_netdev = NULL;
+		return -ENODEV;
+	}
+
+	if (netdev->features & NETIF_F_HW_TCP_DDP &&
+	    netdev->tcp_ddp_ops &&
+	    netdev->tcp_ddp_ops->tcp_ddp_limits)
+		ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
+	else
+		ret = -EOPNOTSUPP;
+
+	if (!ret) {
+		queue->ctrl->offloading_netdev = netdev;
+		dev_dbg_ratelimited(queue->ctrl->ctrl.device,
+				    "netdev %s offload limits: max_ddp_sgl_len %d\n",
+				    netdev->name, limits.max_ddp_sgl_len);
+		queue->ctrl->ctrl.max_segments = limits.max_ddp_sgl_len;
+		queue->ctrl->ctrl.max_hw_sectors =
+			limits.max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
+	} else {
+		queue->ctrl->offloading_netdev = NULL;
+	}
+
+	/* release the device as no offload context is established yet. */
+	dev_put(netdev);
+
+	return ret;
+}
+
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{
+	u64 pdu_seq = TCP_SKB_CB(skb)->seq + offset - queue->pdu_offset;
+	struct net_device *netdev = queue->ctrl->offloading_netdev;
+	u64 resync_val;
+	u32 resync_seq;
+
+	resync_val = atomic64_read(&queue->resync_req);
+	/* Lower 32 bit flags. Check validity of the request */
+	if ((resync_val & TCP_DDP_RESYNC_REQ) == 0)
+		return;
+
+	/* Obtain and check requested sequence number: is this PDU header before the request? */
+	resync_seq = resync_val >> 32;
+	if (before(pdu_seq, resync_seq))
+		return;
+
+	if (unlikely(!netdev)) {
+		pr_info_ratelimited("%s: netdev not found\n", __func__);
+		return;
+	}
+
+	/**
+	 * The atomic operation gurarantees that we don't miss any NIC driver
+	 * resync requests submitted after the above checks.
+	 */
+	if (atomic64_cmpxchg(&queue->resync_req, resync_val,
+			     resync_val & ~TCP_DDP_RESYNC_REQ))
+		netdev->tcp_ddp_ops->tcp_ddp_resync(netdev, queue->sock->sk, pdu_seq);
+}
+
+static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
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
+static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
+{
+	return -EINVAL;
+}
+
+static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
+{}
+
+static int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue)
+{
+	return -EINVAL;
+}
+
+static void nvme_tcp_resync_response(struct nvme_tcp_queue *queue,
+				     struct sk_buff *skb, unsigned int offset)
+{}
+
+#endif
+
 static void nvme_tcp_init_iter(struct nvme_tcp_request *req,
 		unsigned int dir)
 {
@@ -638,6 +802,9 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_resync_response(queue, skb, *offset);
+
 	ret = skb_copy_bits(skb, *offset,
 		&pdu[queue->pdu_offset], rcv_len);
 	if (unlikely(ret))
@@ -1532,6 +1699,9 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
+
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+		nvme_tcp_unoffload_socket(queue);
 }
 
 static void nvme_tcp_stop_queue(struct nvme_ctrl *nctrl, int qid)
@@ -1550,10 +1720,13 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	int ret;
 
-	if (idx)
+	if (idx) {
 		ret = nvmf_connect_io_queue(nctrl, idx, false);
-	else
+		nvme_tcp_offload_socket(&ctrl->queues[idx]);
+	} else {
 		ret = nvmf_connect_admin_queue(nctrl);
+		nvme_tcp_offload_limits(&ctrl->queues[idx]);
+	}
 
 	if (!ret) {
 		set_bit(NVME_TCP_Q_LIVE, &ctrl->queues[idx].flags);
-- 
2.24.1

