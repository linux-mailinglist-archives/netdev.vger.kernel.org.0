Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4F430C9B
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbhJQWR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53396 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344759AbhJQWRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:53 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3628B63F0C;
        Mon, 18 Oct 2021 00:14:02 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 05/15] netfilter: Introduce egress hook
Date:   Mon, 18 Oct 2021 00:15:12 +0200
Message-Id: <20211017221522.853838-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Support classifying packets with netfilter on egress to satisfy user
requirements such as:
* outbound security policies for containers (Laura)
* filtering and mangling intra-node Direct Server Return (DSR) traffic
  on a load balancer (Laura)
* filtering locally generated traffic coming in through AF_PACKET,
  such as local ARP traffic generated for clustering purposes or DHCP
  (Laura; the AF_PACKET plumbing is contained in a follow-up commit)
* L2 filtering from ingress and egress for AVB (Audio Video Bridging)
  and gPTP with nftables (Pablo)
* in the future: in-kernel NAT64/NAT46 (Pablo)

The egress hook introduced herein complements the ingress hook added by
commit e687ad60af09 ("netfilter: add netfilter ingress hook after
handle_ing() under unique static key").  A patch for nftables to hook up
egress rules from user space has been submitted separately, so users may
immediately take advantage of the feature.

Alternatively or in addition to netfilter, packets can be classified
with traffic control (tc).  On ingress, packets are classified first by
tc, then by netfilter.  On egress, the order is reversed for symmetry.
Conceptually, tc and netfilter can be thought of as layers, with
netfilter layered above tc.

Traffic control is capable of redirecting packets to another interface
(man 8 tc-mirred).  E.g., an ingress packet may be redirected from the
host namespace to a container via a veth connection:
tc ingress (host) -> tc egress (veth host) -> tc ingress (veth container)

In this case, netfilter egress classifying is not performed when leaving
the host namespace!  That's because the packet is still on the tc layer.
If tc redirects the packet to a physical interface in the host namespace
such that it leaves the system, the packet is never subjected to
netfilter egress classifying.  That is only logical since it hasn't
passed through netfilter ingress classifying either.

Packets can alternatively be redirected at the netfilter layer using
nft fwd.  Such a packet *is* subjected to netfilter egress classifying
since it has reached the netfilter layer.

Internally, the skb->nf_skip_egress flag controls whether netfilter is
invoked on egress by __dev_queue_xmit().  Because __dev_queue_xmit() may
be called recursively by tunnel drivers such as vxlan, the flag is
reverted to false after sch_handle_egress().  This ensures that
netfilter is applied both on the overlay and underlying network.

Interaction between tc and netfilter is possible by setting and querying
skb->mark.

If netfilter egress classifying is not enabled on any interface, it is
patched out of the data path by way of a static_key and doesn't make a
performance difference that is discernible from noise:

Before:             1537 1538 1538 1537 1538 1537 Mb/sec
After:              1536 1534 1539 1539 1539 1540 Mb/sec
Before + tc accept: 1418 1418 1418 1419 1419 1418 Mb/sec
After  + tc accept: 1419 1424 1418 1419 1422 1420 Mb/sec
Before + tc drop:   1620 1619 1619 1619 1620 1620 Mb/sec
After  + tc drop:   1616 1624 1625 1624 1622 1619 Mb/sec

When netfilter egress classifying is enabled on at least one interface,
a minimal performance penalty is incurred for every egress packet, even
if the interface it's transmitted over doesn't have any netfilter egress
rules configured.  That is caused by checking dev->nf_hooks_egress
against NULL.

Measurements were performed on a Core i7-3615QM.  Commands to reproduce:
ip link add dev foo type dummy
ip link set dev foo up
modprobe pktgen
echo "add_device foo" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1

Accept all traffic with tc:
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'

Drop all traffic with tc:
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 2,'

Apply this patch when measuring packet drops to avoid errors in dmesg:
https://lore.kernel.org/netdev/a73dda33-57f4-95d8-ea51-ed483abd6a7a@iogearbox.net/

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Laura García Liébana <nevola@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ifb.c                |  3 ++
 include/linux/netdevice.h        |  4 ++
 include/linux/netfilter_netdev.h | 86 ++++++++++++++++++++++++++++++++
 include/linux/skbuff.h           |  4 ++
 include/uapi/linux/netfilter.h   |  1 +
 net/core/dev.c                   | 15 +++++-
 net/netfilter/Kconfig            | 11 ++++
 net/netfilter/core.c             | 34 +++++++++++--
 net/netfilter/nfnetlink_hook.c   | 16 ++++--
 net/netfilter/nft_chain_filter.c |  4 +-
 10 files changed, 168 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index e9258a9f3702..2c319dd27f29 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/netfilter_netdev.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 
@@ -75,8 +76,10 @@ static void ifb_ri_tasklet(struct tasklet_struct *t)
 	}
 
 	while ((skb = __skb_dequeue(&txp->tq)) != NULL) {
+		/* Skip tc and netfilter to prevent redirection loop. */
 		skb->redirected = 0;
 		skb->tc_skip_classify = 1;
+		nf_skip_egress(skb, true);
 
 		u64_stats_update_begin(&txp->tsync);
 		txp->tx_packets++;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..e9a48068f306 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1861,6 +1861,7 @@ enum netdev_ml_priv_type {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2161,6 +2162,9 @@ struct net_device {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	struct nf_hook_entries __rcu *nf_hooks_egress;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index 5812b0fb0278..b71b57a83bb4 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -50,11 +50,97 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 }
 #endif /* CONFIG_NETFILTER_INGRESS */
 
+#ifdef CONFIG_NETFILTER_EGRESS
+static inline bool nf_hook_egress_active(void)
+{
+#ifdef CONFIG_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_EGRESS]))
+		return false;
+#endif
+	return true;
+}
+
+/**
+ * nf_hook_egress - classify packets before transmission
+ * @skb: packet to be classified
+ * @rc: result code which shall be returned by __dev_queue_xmit() on failure
+ * @dev: netdev whose egress hooks shall be applied to @skb
+ *
+ * Returns @skb on success or %NULL if the packet was consumed or filtered.
+ * Caller must hold rcu_read_lock.
+ *
+ * On ingress, packets are classified first by tc, then by netfilter.
+ * On egress, the order is reversed for symmetry.  Conceptually, tc and
+ * netfilter can be thought of as layers, with netfilter layered above tc:
+ * When tc redirects a packet to another interface, netfilter is not applied
+ * because the packet is on the tc layer.
+ *
+ * The nf_skip_egress flag controls whether netfilter is applied on egress.
+ * It is updated by __netif_receive_skb_core() and __dev_queue_xmit() when the
+ * packet passes through tc and netfilter.  Because __dev_queue_xmit() may be
+ * called recursively by tunnel drivers such as vxlan, the flag is reverted to
+ * false after sch_handle_egress().  This ensures that netfilter is applied
+ * both on the overlay and underlying network.
+ */
+static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
+					     struct net_device *dev)
+{
+	struct nf_hook_entries *e;
+	struct nf_hook_state state;
+	int ret;
+
+#ifdef CONFIG_NETFILTER_SKIP_EGRESS
+	if (skb->nf_skip_egress)
+		return skb;
+#endif
+
+	e = rcu_dereference(dev->nf_hooks_egress);
+	if (!e)
+		return skb;
+
+	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
+			   NFPROTO_NETDEV, dev, NULL, NULL,
+			   dev_net(dev), NULL);
+	ret = nf_hook_slow(skb, &state, e, 0);
+
+	if (ret == 1) {
+		return skb;
+	} else if (ret < 0) {
+		*rc = NET_XMIT_DROP;
+		return NULL;
+	} else { /* ret == 0 */
+		*rc = NET_XMIT_SUCCESS;
+		return NULL;
+	}
+}
+#else /* CONFIG_NETFILTER_EGRESS */
+static inline bool nf_hook_egress_active(void)
+{
+	return false;
+}
+
+static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
+					     struct net_device *dev)
+{
+	return skb;
+}
+#endif /* CONFIG_NETFILTER_EGRESS */
+
+static inline void nf_skip_egress(struct sk_buff *skb, bool skip)
+{
+#ifdef CONFIG_NETFILTER_SKIP_EGRESS
+	skb->nf_skip_egress = skip;
+#endif
+}
+
 static inline void nf_hook_netdev_init(struct net_device *dev)
 {
 #ifdef CONFIG_NETFILTER_INGRESS
 	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	RCU_INIT_POINTER(dev->nf_hooks_egress, NULL);
+#endif
 }
 
 #endif /* _NETFILTER_NETDEV_H_ */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 841e2f0f5240..cb96f1e6460c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -652,6 +652,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_at_ingress: used within tc_classify to distinguish in/egress
  *	@redirected: packet was redirected by packet classifier
  *	@from_ingress: packet was redirected from the ingress path
+ *	@nf_skip_egress: packet shall skip nf egress - see netfilter_netdev.h
  *	@peeked: this packet has been seen already, so stats have been
  *		done for it, don't do them again
  *	@nf_trace: netfilter packet trace flag
@@ -868,6 +869,9 @@ struct sk_buff {
 #ifdef CONFIG_NET_REDIRECT
 	__u8			from_ingress:1;
 #endif
+#ifdef CONFIG_NETFILTER_SKIP_EGRESS
+	__u8			nf_skip_egress:1;
+#endif
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index ef9a44286e23..53411ccc69db 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -51,6 +51,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index e4c683029c61..09d74798b440 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3920,6 +3920,7 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3955,6 +3956,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
+#endif /* CONFIG_NET_CLS_ACT */
 
 	return skb;
 }
@@ -4148,13 +4150,20 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-# ifdef CONFIG_NET_EGRESS
+#endif
+#ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
+		if (nf_hook_egress_active()) {
+			skb = nf_hook_egress(skb, &rc, dev);
+			if (!skb)
+				goto out;
+		}
+		nf_skip_egress(skb, true);
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
+		nf_skip_egress(skb, false);
 	}
-# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
@@ -5296,6 +5305,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	if (static_branch_unlikely(&ingress_needed_key)) {
 		bool another = false;
 
+		nf_skip_egress(skb, true);
 		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev,
 					 &another);
 		if (another)
@@ -5303,6 +5313,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		if (!skb)
 			goto out;
 
+		nf_skip_egress(skb, false);
 		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
 			goto out;
 	}
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 54395266339d..49c9fae9c62c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -10,6 +10,17 @@ config NETFILTER_INGRESS
 	  This allows you to classify packets from ingress using the Netfilter
 	  infrastructure.
 
+config NETFILTER_EGRESS
+	bool "Netfilter egress support"
+	default y
+	select NET_EGRESS
+	help
+	  This allows you to classify packets before transmission using the
+	  Netfilter infrastructure.
+
+config NETFILTER_SKIP_EGRESS
+	def_bool NETFILTER_EGRESS && (NET_CLS_ACT || IFB)
+
 config NETFILTER_NETLINK
 	tristate
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 63d032191e62..3a32a813fcde 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -316,6 +316,12 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 		if (dev && dev_net(dev) == net)
 			return &dev->nf_hooks_ingress;
 	}
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (hooknum == NF_NETDEV_EGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_egress;
+	}
 #endif
 	WARN_ON_ONCE(1);
 	return NULL;
@@ -344,6 +350,11 @@ static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
 	return false;
 }
 
+static inline bool nf_egress_hook(const struct nf_hook_ops *reg, int pf)
+{
+	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS;
+}
+
 static void nf_static_key_inc(const struct nf_hook_ops *reg, int pf)
 {
 #ifdef CONFIG_JUMP_LABEL
@@ -383,9 +394,18 @@ static int __nf_register_net_hook(struct net *net, int pf,
 
 	switch (pf) {
 	case NFPROTO_NETDEV:
-		err = nf_ingress_check(net, reg, NF_NETDEV_INGRESS);
-		if (err < 0)
-			return err;
+#ifndef CONFIG_NETFILTER_INGRESS
+		if (reg->hooknum == NF_NETDEV_INGRESS)
+			return -EOPNOTSUPP;
+#endif
+#ifndef CONFIG_NETFILTER_EGRESS
+		if (reg->hooknum == NF_NETDEV_EGRESS)
+			return -EOPNOTSUPP;
+#endif
+		if ((reg->hooknum != NF_NETDEV_INGRESS &&
+		     reg->hooknum != NF_NETDEV_EGRESS) ||
+		    !reg->dev || dev_net(reg->dev) != net)
+			return -EINVAL;
 		break;
 	case NFPROTO_INET:
 		if (reg->hooknum != NF_INET_INGRESS)
@@ -417,6 +437,10 @@ static int __nf_register_net_hook(struct net *net, int pf,
 #ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_ingress_hook(reg, pf))
 		net_inc_ingress_queue();
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (nf_egress_hook(reg, pf))
+		net_inc_egress_queue();
 #endif
 	nf_static_key_inc(reg, pf);
 
@@ -474,6 +498,10 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 #ifdef CONFIG_NETFILTER_INGRESS
 		if (nf_ingress_hook(reg, pf))
 			net_dec_ingress_queue();
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+		if (nf_egress_hook(reg, pf))
+			net_dec_egress_queue();
 #endif
 		nf_static_key_dec(reg, pf);
 	} else {
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index f554e2ea32ee..d5c719c9e36c 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -185,7 +185,7 @@ static const struct nf_hook_entries *
 nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *dev)
 {
 	const struct nf_hook_entries *hook_head = NULL;
-#ifdef CONFIG_NETFILTER_INGRESS
+#if defined(CONFIG_NETFILTER_INGRESS) || defined(CONFIG_NETFILTER_EGRESS)
 	struct net_device *netdev;
 #endif
 
@@ -221,9 +221,9 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
 		break;
 #endif
-#ifdef CONFIG_NETFILTER_INGRESS
+#if defined(CONFIG_NETFILTER_INGRESS) || defined(CONFIG_NETFILTER_EGRESS)
 	case NFPROTO_NETDEV:
-		if (hook != NF_NETDEV_INGRESS)
+		if (hook >= NF_NETDEV_NUMHOOKS)
 			return ERR_PTR(-EOPNOTSUPP);
 
 		if (!dev)
@@ -233,7 +233,15 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 		if (!netdev)
 			return ERR_PTR(-ENODEV);
 
-		return rcu_dereference(netdev->nf_hooks_ingress);
+#ifdef CONFIG_NETFILTER_INGRESS
+		if (hook == NF_NETDEV_INGRESS)
+			return rcu_dereference(netdev->nf_hooks_ingress);
+#endif
+#ifdef CONFIG_NETFILTER_EGRESS
+		if (hook == NF_NETDEV_EGRESS)
+			return rcu_dereference(netdev->nf_hooks_egress);
+#endif
+		fallthrough;
 #endif
 	default:
 		return ERR_PTR(-EPROTONOSUPPORT);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..680fe557686e 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -310,9 +310,11 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_NETDEV,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hook_mask	= (1 << NF_NETDEV_INGRESS) |
+			  (1 << NF_NETDEV_EGRESS),
 	.hooks		= {
 		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+		[NF_NETDEV_EGRESS]	= nft_do_chain_netdev,
 	},
 };
 
-- 
2.30.2

