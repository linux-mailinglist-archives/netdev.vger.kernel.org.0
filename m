Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2544449
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfFMQf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:35:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:5947 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbfFMHhu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:37:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 00:37:49 -0700
X-ExtLoop1: 1
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.ger.corp.intel.com) ([10.103.211.41])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2019 00:37:44 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 2/6] xsk: add support for need_wakeup flag in AF_XDP rings
Date:   Thu, 13 Jun 2019 09:37:26 +0200
Message-Id: <1560411450-29121-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for a new flag called need_wakeup in the
AF_XDP Tx and fill rings. When this flag is set, it means that the
application has to explicitly wake up the kernel Rx (for the bit in
the fill ring) or kernel Tx (for bit in the Tx ring) processing by
issuing a syscall. Poll() can wake up both depending on the flags
submitted and sendto() will wake up tx processing only.

The main reason for introducing this new flag is to be able to
efficiently support the case when application and driver is executing
on the same core. Previously, the driver was just busy-spinning on the
fill ring if it ran out of buffers in the HW and there were none on
the fill ring. This approach works when the application is running on
another core as it can replenish the fill ring while the driver is
busy-spinning. Though, this is a lousy approach if both of them are
running on the same core as the probability of the fill ring getting
more entries when the driver is busy-spinning is zero. With this new
feature the driver now sets the need_wakeup flag and returns to the
application. The application can then replenish the fill queue and
then explicitly wake up the Rx processing in the kernel using the
syscall poll(). For Tx, the flag is only set to one if the driver has
no outstanding Tx completion interrupts. If it has some, the flag is
zero as it will be woken up by a completion interrupt anyway.

As a nice side effect, this new flag also improves the performance of
the case where application and driver are running on two different
cores as it reduces the number of syscalls to the kernel. The kernel
tells user space if it needs to be woken up by a syscall, and this
eliminates many of the syscalls.

This flag needs some simple driver support. If the driver does not
support this, the Rx flag is always zero and the Tx flag is always
one. This makes any application relying on this feature default to the
old behaviour of not requiring any syscalls in the Rx path and always
having to call sendto() in the Tx path.

For backwards compatibility reasons, this feature has to be explicitly
turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
that you always turn it on as it so far always have had a positive
performance impact.

The name and inspiration of the flag has been taken from io_uring by
Jens Axboe. Details about this feature in io_uring can be found in
http://kernel.dk/io_uring.pdf, section 8.3.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/linux/netdevice.h   |  4 ++
 include/net/xdp_sock.h      | 33 +++++++++++++++-
 include/uapi/linux/if_xdp.h | 13 +++++++
 net/xdp/xdp_umem.c          |  6 ++-
 net/xdp/xsk.c               | 93 +++++++++++++++++++++++++++++++++++++++++++--
 net/xdp/xsk_queue.h         |  1 +
 6 files changed, 143 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fd29d39..8c4320b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -876,6 +876,9 @@ struct bpf_prog_offload_ops;
 struct netlink_ext_ack;
 struct xdp_umem;
 
+/* Flags for the flags field in XDP_SETUP_XSK_UMEM */
+#define XSK_DRV_CAN_SLEEP (1 << 0) /* The driver is alowed to sleep. */
+
 struct netdev_bpf {
 	enum bpf_netdev_command command;
 	union {
@@ -898,6 +901,7 @@ struct netdev_bpf {
 		/* XDP_SETUP_XSK_UMEM */
 		struct {
 			struct xdp_umem *umem;
+			u32 flags;
 			u16 queue_id;
 		} xsk;
 	};
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index ae0f368..4d894a5 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -27,6 +27,9 @@ struct xdp_umem_fq_reuse {
 	u64 handles[];
 };
 
+/* Flags for the umem flags field. */
+#define XDP_UMEM_MIGHT_SLEEP (1 << 0)
+
 struct xdp_umem {
 	struct xsk_queue *fq;
 	struct xsk_queue *cq;
@@ -41,10 +44,12 @@ struct xdp_umem {
 	struct work_struct work;
 	struct page **pgs;
 	u32 npgs;
+	u16 queue_id;
+	u8 need_wakeup;
+	u8 flags;
 	int id;
 	struct net_device *dev;
 	struct xdp_umem_fq_reuse *fq_reuse;
-	u16 queue_id;
 	bool zc;
 	spinlock_t xsk_list_lock;
 	struct list_head xsk_list;
@@ -87,6 +92,11 @@ struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
 					  struct xdp_umem_fq_reuse *newq);
 void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq);
 struct xdp_umem *xdp_get_umem_from_qid(struct net_device *dev, u16 queue_id);
+void xsk_set_rx_need_wakeup(struct xdp_umem *umem);
+void xsk_set_tx_need_wakeup(struct xdp_umem *umem);
+void xsk_clear_rx_need_wakeup(struct xdp_umem *umem);
+void xsk_clear_tx_need_wakeup(struct xdp_umem *umem);
+bool xsk_umem_uses_might_sleep(struct xdp_umem *umem);
 
 static inline char *xdp_umem_get_data(struct xdp_umem *umem, u64 addr)
 {
@@ -213,6 +223,27 @@ static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
 {
 }
 
+static inline void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
+{
+}
+
+static inline bool xsk_umem_uses_might_sleep(struct xdp_umem *umem)
+{
+	return false;
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index caed8b1..3aa958e 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -16,6 +16,15 @@
 #define XDP_SHARED_UMEM	(1 << 0)
 #define XDP_COPY	(1 << 1) /* Force copy-mode */
 #define XDP_ZEROCOPY	(1 << 2) /* Force zero-copy mode */
+/* If this option is set, the driver might go sleep and in that case
+ * the XDP_RING_NEED_WAKEUP flag in the fill and/or Tx rings will be
+ * set. If it is set, the application need to explicitly wake up the
+ * driver with a poll() (Rx and Tx) or sendto() (Tx only). If you are
+ * running the driver and the application on the same core, you should
+ * use this option so that the kernel will yield to the user space
+ * application.
+ */
+#define XDP_USE_NEED_WAKEUP (1 << 3)
 
 struct sockaddr_xdp {
 	__u16 sxdp_family;
@@ -25,10 +34,14 @@ struct sockaddr_xdp {
 	__u32 sxdp_shared_umem_fd;
 };
 
+/* XDP_RING flags */
+#define XDP_RING_NEED_WAKEUP (1 << 0)
+
 struct xdp_ring_offset {
 	__u64 producer;
 	__u64 consumer;
 	__u64 desc;
+	__u64 flags;
 };
 
 struct xdp_mmap_offsets {
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 2b18223..15d7c53 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -105,12 +105,14 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 
 	umem->dev = dev;
 	umem->queue_id = queue_id;
+	if (flags & XDP_USE_NEED_WAKEUP)
+		umem->flags |= XDP_UMEM_MIGHT_SLEEP;
+
 	if (force_copy)
 		/* For copy-mode, we are done. */
 		goto out_rtnl_unlock;
 
-	if (!dev->netdev_ops->ndo_bpf ||
-	    !dev->netdev_ops->ndo_xsk_async_xmit) {
+	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_umem;
 	}
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e886..e9b9c98 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -49,6 +49,66 @@ void xsk_umem_discard_addr(struct xdp_umem *umem)
 }
 EXPORT_SYMBOL(xsk_umem_discard_addr);
 
+void xsk_set_rx_need_wakeup(struct xdp_umem *umem)
+{
+	if (umem->need_wakeup & XDP_WAKEUP_RX)
+		return;
+
+	umem->fq->ring->flags |= XDP_RING_NEED_WAKEUP;
+	umem->need_wakeup |= XDP_WAKEUP_RX;
+}
+EXPORT_SYMBOL(xsk_set_rx_need_wakeup);
+
+void xsk_set_tx_need_wakeup(struct xdp_umem *umem)
+{
+	struct xdp_sock *xs;
+
+	if (umem->need_wakeup & XDP_WAKEUP_TX)
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+		xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
+	}
+	rcu_read_unlock();
+
+	umem->need_wakeup |= XDP_WAKEUP_TX;
+}
+EXPORT_SYMBOL(xsk_set_tx_need_wakeup);
+
+void xsk_clear_rx_need_wakeup(struct xdp_umem *umem)
+{
+	if (!(umem->need_wakeup & XDP_WAKEUP_RX))
+		return;
+
+	umem->fq->ring->flags &= ~XDP_RING_NEED_WAKEUP;
+	umem->need_wakeup &= ~XDP_WAKEUP_RX;
+}
+EXPORT_SYMBOL(xsk_clear_rx_need_wakeup);
+
+void xsk_clear_tx_need_wakeup(struct xdp_umem *umem)
+{
+	struct xdp_sock *xs;
+
+	if (!(umem->need_wakeup & XDP_WAKEUP_TX))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
+		xs->tx->ring->flags &= ~XDP_RING_NEED_WAKEUP;
+	}
+	rcu_read_unlock();
+
+	umem->need_wakeup &= ~XDP_WAKEUP_TX;
+}
+EXPORT_SYMBOL(xsk_clear_tx_need_wakeup);
+
+bool xsk_umem_uses_might_sleep(struct xdp_umem *umem)
+{
+	return umem->flags & XDP_UMEM_MIGHT_SLEEP;
+}
+EXPORT_SYMBOL(xsk_umem_uses_might_sleep);
+
 static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 {
 	void *to_buf, *from_buf;
@@ -198,7 +258,8 @@ static int xsk_zc_xmit(struct sock *sk)
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev = xs->dev;
 
-	return dev->netdev_ops->ndo_xsk_async_xmit(dev, xs->queue_id);
+	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
+					       XDP_WAKEUP_TX);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
@@ -308,6 +369,12 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 	unsigned int mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
+	struct net_device *dev = xs->dev;
+	struct xdp_umem *umem = xs->umem;
+
+	if (umem->need_wakeup)
+		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
+						umem->need_wakeup);
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))
 		mask |= POLLIN | POLLRDNORM;
@@ -408,7 +475,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		return -EINVAL;
 
 	flags = sxdp->sxdp_flags;
-	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY))
+	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY |
+		      XDP_USE_NEED_WAKEUP))
 		return -EINVAL;
 
 	mutex_lock(&xs->mutex);
@@ -434,7 +502,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		struct xdp_sock *umem_xs;
 		struct socket *sock;
 
-		if ((flags & XDP_COPY) || (flags & XDP_ZEROCOPY)) {
+		if ((flags & XDP_COPY) || (flags & XDP_ZEROCOPY) ||
+		    (flags & XDP_USE_NEED_WAKEUP)) {
 			/* Cannot specify flags for shared sockets. */
 			err = -EINVAL;
 			goto out_unlock;
@@ -522,6 +591,9 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		mutex_lock(&xs->mutex);
 		q = (optname == XDP_TX_RING) ? &xs->tx : &xs->rx;
 		err = xsk_init_queue(entries, q, false);
+		if (!err && optname == XDP_TX_RING)
+			/* Tx needs to be explicitly woken up the first time */
+			xs->tx->ring->flags |= XDP_RING_NEED_WAKEUP;
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
@@ -618,9 +690,12 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 	case XDP_MMAP_OFFSETS:
 	{
 		struct xdp_mmap_offsets off;
+		bool flags_supported = true;
 
-		if (len < sizeof(off))
+		if (len < sizeof(off) - sizeof(off.rx.flags))
 			return -EINVAL;
+		else if (len < sizeof(off))
+			flags_supported = false;
 
 		off.rx.producer = offsetof(struct xdp_rxtx_ring, ptrs.producer);
 		off.rx.consumer = offsetof(struct xdp_rxtx_ring, ptrs.consumer);
@@ -635,6 +710,16 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 		off.cr.producer = offsetof(struct xdp_umem_ring, ptrs.producer);
 		off.cr.consumer = offsetof(struct xdp_umem_ring, ptrs.consumer);
 		off.cr.desc	= offsetof(struct xdp_umem_ring, desc);
+		if (flags_supported) {
+			off.rx.flags = offsetof(struct xdp_rxtx_ring,
+						ptrs.flags);
+			off.tx.flags = offsetof(struct xdp_rxtx_ring,
+						ptrs.flags);
+			off.fr.flags = offsetof(struct xdp_umem_ring,
+						ptrs.flags);
+			off.cr.flags = offsetof(struct xdp_umem_ring,
+						ptrs.flags);
+		}
 
 		len = sizeof(off);
 		if (copy_to_user(optval, &off, len))
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 88b9ae2..e438eeb 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -16,6 +16,7 @@
 struct xdp_ring {
 	u32 producer ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
+	u32 flags;
 };
 
 /* Used for the RX and TX queues for packets */
-- 
2.7.4

