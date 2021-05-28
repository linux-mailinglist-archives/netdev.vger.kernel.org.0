Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D1393CE9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhE1GJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 02:09:53 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54514 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235005AbhE1GJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 02:09:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0UaL1uq9_1622182093;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UaL1uq9_1622182093)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 May 2021 14:08:14 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH bpf-next] xsk: support AF_PACKET
Date:   Fri, 28 May 2021 14:08:13 +0800
Message-Id: <20210528060813.49003-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the current
rx/tx data packets. This feature is very important in many cases. So
this patch allows AF_PACKET to obtain xsk packages.

By default, AF_PACKET is based on ptype_base/ptype_all in dev.c to
obtain data packets. But xsk is not suitable for calling these
callbacks, because it may send the packet to other protocol stacks. So
the method I used is to let AF_PACKET get the data packet from xsk
alone.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/net/xdp_sock.h |  15 +++++
 net/packet/af_packet.c |  35 +++++++++--
 net/packet/internal.h  |   7 +++
 net/xdp/Makefile       |   2 +-
 net/xdp/xsk.c          |   9 +++
 net/xdp/xsk_packet.c   | 129 +++++++++++++++++++++++++++++++++++++++++
 net/xdp/xsk_packet.h   |  44 ++++++++++++++
 7 files changed, 234 insertions(+), 7 deletions(-)
 create mode 100644 net/xdp/xsk_packet.c
 create mode 100644 net/xdp/xsk_packet.h

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 9c0722c6d7ac..b0acf0293132 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -17,6 +17,11 @@ struct net_device;
 struct xsk_queue;
 struct xdp_buff;
 
+struct xsk_packet {
+	struct list_head list;
+	struct packet_type *pt;
+};
+
 struct xdp_umem {
 	void *addrs;
 	u64 size;
@@ -79,6 +84,8 @@ struct xdp_sock {
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
 void __xsk_map_flush(void);
+void xsk_add_pack(struct xsk_packet *xpt);
+void __xsk_remove_pack(struct xsk_packet *xpt);
 
 #else
 
@@ -96,6 +103,14 @@ static inline void __xsk_map_flush(void)
 {
 }
 
+void xsk_add_pack(struct xsk_packet *xpt)
+{
+}
+
+void __xsk_remove_pack(struct xsk_packet *xpt)
+{
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_H */
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 597d798ac0a5..2720b51d13a6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -303,10 +303,14 @@ static void __register_prot_hook(struct sock *sk)
 	struct packet_sock *po = pkt_sk(sk);
 
 	if (!po->running) {
-		if (po->fanout)
+		if (po->fanout) {
 			__fanout_link(sk, po);
-		else
+		} else {
 			dev_add_pack(&po->prot_hook);
+#ifdef CONFIG_XDP_SOCKETS
+			xsk_add_pack(&po->xsk_pt);
+#endif
+		}
 
 		sock_hold(sk);
 		po->running = 1;
@@ -333,10 +337,14 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 
 	po->running = 0;
 
-	if (po->fanout)
+	if (po->fanout) {
 		__fanout_unlink(sk, po);
-	else
+	} else {
 		__dev_remove_pack(&po->prot_hook);
+#ifdef CONFIG_XDP_SOCKETS
+		__xsk_remove_pack(&po->xsk_pt);
+#endif
+	}
 
 	__sock_put(sk);
 
@@ -1483,8 +1491,12 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po)
 	rcu_assign_pointer(f->arr[f->num_members], sk);
 	smp_wmb();
 	f->num_members++;
-	if (f->num_members == 1)
+	if (f->num_members == 1) {
 		dev_add_pack(&f->prot_hook);
+#ifdef CONFIG_XDP_SOCKETS
+		xsk_add_pack(&f->xsk_pt);
+#endif
+	}
 	spin_unlock(&f->lock);
 }
 
@@ -1504,8 +1516,12 @@ static void __fanout_unlink(struct sock *sk, struct packet_sock *po)
 			   rcu_dereference_protected(f->arr[f->num_members - 1],
 						     lockdep_is_held(&f->lock)));
 	f->num_members--;
-	if (f->num_members == 0)
+	if (f->num_members == 0) {
 		__dev_remove_pack(&f->prot_hook);
+#ifdef CONFIG_XDP_SOCKETS
+		__xsk_remove_pack(&po->xsk_pt);
+#endif
+	}
 	spin_unlock(&f->lock);
 }
 
@@ -1737,6 +1753,10 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 		match->prot_hook.af_packet_priv = match;
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
+#ifdef CONFIG_XDP_SOCKETS
+		match->xsk_pt.pt = &match->prot_hook;
+#endif
+
 		list_add(&match->list, &fanout_list);
 	}
 	err = -EINVAL;
@@ -3315,6 +3335,9 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+#ifdef CONFIG_XDP_SOCKETS
+	po->xsk_pt.pt = &po->prot_hook;
+#endif
 
 	if (proto) {
 		po->prot_hook.type = proto;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b1aed2..d224b926588a 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -3,6 +3,7 @@
 #define __PACKET_INTERNAL_H__
 
 #include <linux/refcount.h>
+#include <net/xdp_sock.h>
 
 struct packet_mclist {
 	struct packet_mclist	*next;
@@ -94,6 +95,9 @@ struct packet_fanout {
 	spinlock_t		lock;
 	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
+#ifdef CONFIG_XDP_SOCKETS
+	struct xsk_packet	xsk_pt;
+#endif
 	struct sock	__rcu	*arr[];
 };
 
@@ -136,6 +140,9 @@ struct packet_sock {
 	struct net_device __rcu	*cached_dev;
 	int			(*xmit)(struct sk_buff *skb);
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
+#ifdef CONFIG_XDP_SOCKETS
+	struct xsk_packet	xsk_pt;
+#endif
 	atomic_t		tp_drops ____cacheline_aligned_in_smp;
 };
 
diff --git a/net/xdp/Makefile b/net/xdp/Makefile
index 30cdc4315f42..bcac0591879b 100644
--- a/net/xdp/Makefile
+++ b/net/xdp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o
+obj-$(CONFIG_XDP_SOCKETS) += xsk.o xdp_umem.o xsk_queue.o xskmap.o xsk_packet.o
 obj-$(CONFIG_XDP_SOCKETS) += xsk_buff_pool.o
 obj-$(CONFIG_XDP_SOCKETS_DIAG) += xsk_diag.o
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cd62d4ba87a9..fc97e7f9e4cb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -28,6 +28,7 @@
 
 #include "xsk_queue.h"
 #include "xdp_umem.h"
+#include "xsk_packet.h"
 #include "xsk.h"
 
 #define TX_BATCH_SIZE 32
@@ -156,6 +157,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	int err;
 
 	addr = xp_get_handle(xskb);
+	xsk_rx_packet_deliver(xs, addr, len);
 	err = xskq_prod_reserve_desc(xs->rx, addr, len);
 	if (err) {
 		xs->rx_queue_full++;
@@ -347,6 +349,8 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 		if (xskq_prod_reserve_addr(pool->cq, desc->addr))
 			goto out;
 
+		xsk_tx_zc_packet_deliver(xs, desc);
+
 		xskq_cons_release(xs->tx);
 		rcu_read_unlock();
 		return true;
@@ -576,6 +580,8 @@ static int xsk_generic_xmit(struct sock *sk)
 		}
 		spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 
+		xsk_tx_packet_deliver(xs, &desc, skb);
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
@@ -1467,6 +1473,9 @@ static int __init xsk_init(void)
 
 	for_each_possible_cpu(cpu)
 		INIT_LIST_HEAD(&per_cpu(xskmap_flush_list, cpu));
+
+	INIT_LIST_HEAD(&xsk_pt);
+
 	return 0;
 
 out_pernet:
diff --git a/net/xdp/xsk_packet.c b/net/xdp/xsk_packet.c
new file mode 100644
index 000000000000..41005f214d6d
--- /dev/null
+++ b/net/xdp/xsk_packet.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/* XDP sockets packet api
+ *
+ * Author: Xuan Zhuo <xuanzhuo.dxf@linux.alibaba.com>
+ */
+
+#include <net/xdp_sock.h>
+#include <net/xdp_sock_drv.h>
+#include "xsk.h"
+#include "xsk_packet.h"
+
+struct list_head xsk_pt __read_mostly;
+static DEFINE_SPINLOCK(pt_lock);
+
+static struct sk_buff *xsk_pt_alloc_skb(struct xdp_sock *xs,
+					struct xdp_desc *desc)
+{
+	struct sk_buff *skb;
+	void *buffer;
+	int err;
+
+	skb = alloc_skb(desc->len, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+
+	skb_put(skb, desc->len);
+
+	buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
+	err = skb_store_bits(skb, 0, buffer, desc->len);
+	if (unlikely(err)) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	return skb;
+}
+
+static struct sk_buff *xsk_pt_get_skb(struct xdp_sock *xs,
+				      struct xdp_desc *desc,
+				      struct sk_buff *skb,
+				      bool rx)
+{
+	struct net_device *dev = xs->dev;
+
+	/* We must copy the data, because skb may exist for a long time
+	 * on AF_PACKET. If the buffer of the xsk is used by skb, the
+	 * release of xsk and the reuse of the buffer will be affected.
+	 */
+	if (!skb || (dev->priv_flags & IFF_TX_SKB_NO_LINEAR))
+		skb = xsk_pt_alloc_skb(xs, desc);
+	else
+		skb = skb_clone(skb, GFP_ATOMIC);
+
+	if (!skb)
+		return NULL;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	skb_reset_network_header(skb);
+	skb->transport_header = skb->network_header;
+	__net_timestamp(skb);
+
+	if (!rx)
+		skb->pkt_type = PACKET_OUTGOING;
+
+	return skb;
+}
+
+void __xsk_pt_deliver(struct xdp_sock *xs, struct sk_buff *skb,
+		      struct xdp_desc *desc, bool rx)
+{
+	struct packet_type *pt_prev = NULL;
+	struct packet_type *ptype;
+	struct xsk_packet *xpt;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(xpt, &xsk_pt, list) {
+		ptype = xpt->pt;
+
+		if (!rx && ptype->ignore_outgoing)
+			continue;
+
+		if (pt_prev) {
+			refcount_inc(&skb->users);
+			pt_prev->func(skb, skb->dev, pt_prev, skb->dev);
+			pt_prev = ptype;
+			continue;
+		}
+
+		skb = xsk_pt_get_skb(xs, desc, skb, rx);
+		if (unlikely(!skb))
+			goto out_unlock;
+
+		pt_prev = ptype;
+	}
+
+	if (pt_prev)
+		pt_prev->func(skb, skb->dev, pt_prev, skb->dev);
+
+out_unlock:
+	rcu_read_unlock();
+}
+
+void xsk_add_pack(struct xsk_packet *xpt)
+{
+	if (xpt->pt->type != htons(ETH_P_ALL))
+		return;
+
+	spin_lock(&pt_lock);
+	list_add_rcu(&xpt->list, &xsk_pt);
+	spin_unlock(&pt_lock);
+}
+
+void __xsk_remove_pack(struct xsk_packet *xpt)
+{
+	struct xsk_packet *xpt1;
+
+	spin_lock(&pt_lock);
+
+	list_for_each_entry(xpt1, &xsk_pt, list) {
+		if (xpt1 == xpt) {
+			list_del_rcu(&xpt1->list);
+			goto out;
+		}
+	}
+
+	pr_warn("xsk_remove_pack: %p not found\n", xpt);
+out:
+	spin_unlock(&pt_lock);
+}
diff --git a/net/xdp/xsk_packet.h b/net/xdp/xsk_packet.h
new file mode 100644
index 000000000000..55d30fa8828b
--- /dev/null
+++ b/net/xdp/xsk_packet.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __XSK_PACKET_H__
+#define __XSK_PACKET_H__
+extern struct list_head xsk_pt __read_mostly;
+
+void __xsk_pt_deliver(struct xdp_sock *xs, struct sk_buff *skb,
+		      struct xdp_desc *desc, bool rx);
+
+static inline void xsk_tx_packet_deliver(struct xdp_sock *xs,
+					 struct xdp_desc *desc,
+					 struct sk_buff *skb)
+{
+	if (likely(list_empty(&xsk_pt)))
+		return;
+
+	local_bh_disable();
+	__xsk_pt_deliver(xs, skb, desc, false);
+	local_bh_enable();
+}
+
+static inline void xsk_tx_zc_packet_deliver(struct xdp_sock *xs,
+					    struct xdp_desc *desc)
+{
+	if (likely(list_empty(&xsk_pt)))
+		return;
+
+	__xsk_pt_deliver(xs, NULL, desc, false);
+}
+
+static inline void xsk_rx_packet_deliver(struct xdp_sock *xs, u64 addr, u32 len)
+{
+	struct xdp_desc desc;
+
+	if (likely(list_empty(&xsk_pt)))
+		return;
+
+	desc.addr = addr;
+	desc.len = len;
+
+	__xsk_pt_deliver(xs, NULL, &desc, true);
+}
+
+#endif /* __XSK_PACKET_H__ */
-- 
2.31.0

