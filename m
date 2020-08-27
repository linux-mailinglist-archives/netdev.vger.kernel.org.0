Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF4254189
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgH0JJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0JJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:09:56 -0400
X-Greylist: delayed 886 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Aug 2020 02:09:56 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47123C061264;
        Thu, 27 Aug 2020 02:09:55 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 90D11101933F9;
        Thu, 27 Aug 2020 11:09:54 +0200 (CEST)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 461456106EDD;
        Thu, 27 Aug 2020 11:09:54 +0200 (CEST)
X-Mailbox-Line: From d2256c451876583bbbf8f0e82a5a43ce35c5cf2f Mon Sep 17 00:00:00 2001
Message-Id: <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
In-Reply-To: <cover.1598517739.git.lukas@wunner.de>
References: <cover.1598517739.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 27 Aug 2020 10:55:03 +0200
Subject: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
handle_ing() under unique static key") introduced the ability to
classify packets on ingress.

Support the same on egress.  This allows filtering locally generated
traffic such as DHCP, or outbound AF_PACKETs in general.  It will also
allow introducing in-kernel NAT64 and NAT46.  A patch for nftables to
hook up egress rules from user space has been submitted separately.

Position the hook immediately before a packet is handed to traffic
control and then sent out on an interface, thereby mirroring the ingress
order.  This order allows marking packets in the netfilter egress hook
and subsequently using the mark in tc.  Another benefit of this order is
consistency with a lot of existing documentation which says that egress
tc is performed after netfilter hooks.

To avoid a performance degradation in the default case (with neither
netfilter nor traffic control used), Daniel Borkmann suggests "a single
static_key which wraps an empty function call entry which can then be
patched by the kernel at runtime. Inside that trampoline we can still
keep the ordering [between netfilter and traffic control] intact":

https://lore.kernel.org/netdev/20200318123315.GI979@breakpoint.cc/

To this end, introduce nf_sch_egress() which is dynamically patched into
__dev_queue_xmit(), contingent on egress_needed_key.  Inside that
function, nf_egress() and sch_handle_egress() is called, each contingent
on its own separate static_key.

nf_sch_egress() is declared noinline per Florian Westphal's suggestion.
This change alone causes a speedup if neither netfilter nor traffic
control is used, apparently because it reduces instruction cache
pressure.  The same effect was previously observed by Eric Dumazet for
the ingress path:

https://lore.kernel.org/netdev/1431387038.566.47.camel@edumazet-glaptop2.roam.corp.google.com/

Overall, performance improves with this commit if neither netfilter nor
traffic control is used. However it degrades a little if only traffic
control is used, due to the "noinline", the additional outer static key
and the added netfilter code:

* Before:       4730418pps 2270Mb/sec (2270600640bps)
* After:        4759206pps 2284Mb/sec (2284418880bps)

* Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
* After  + tc:  4007728pps 1923Mb/sec (1923709440bps)

* After  + nft: 3714546pps 1782Mb/sec (1782982080bps)

Measured on a bare-metal Core i7-3615QM.

Commands to perform a measurement:
ip link add dev foo type dummy
ip link set dev foo up
modprobe pktgen
echo "add_device foo" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1

Commands to enable egress traffic control:
tc qdisc add dev foo clsact
tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'

Commands to enable egress netfilter:
nft add table netdev t
nft add chain netdev t co \{ type filter hook egress device foo priority 0 \; \}
nft add rule netdev t co ip daddr 4.3.2.1/32 drop

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
---
 include/linux/netdevice.h        |  8 +++++
 include/linux/netfilter_netdev.h | 27 +++++++++++++++++
 include/linux/rtnetlink.h        |  2 +-
 include/uapi/linux/netfilter.h   |  1 +
 net/core/dev.c                   | 52 ++++++++++++++++++++++++++++----
 net/netfilter/Kconfig            |  8 +++++
 net/netfilter/core.c             | 24 ++++++++++++---
 net/netfilter/nft_chain_filter.c |  4 ++-
 net/sched/Kconfig                |  3 ++
 9 files changed, 117 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..5d88a40aca21 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -796,6 +796,10 @@ struct xps_dev_maps {
 
 #endif /* CONFIG_XPS */
 
+#ifdef CONFIG_NET_EGRESS
+extern struct static_key_false egress_needed_key;
+#endif
+
 #define TC_MAX_QUEUE	16
 #define TC_BITMASK	15
 /* HW offloaded queuing disciplines txq count and offset maps */
@@ -1779,6 +1783,7 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2057,6 +2062,9 @@ struct net_device {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	struct nf_hook_entries __rcu *nf_hooks_egress;
+#endif
 
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index 49e26479642e..92d3611a782e 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -47,6 +47,9 @@ static inline void nf_hook_netdev_init(struct net_device *dev)
 #ifdef CONFIG_NETFILTER_INGRESS
 	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	RCU_INIT_POINTER(dev->nf_hooks_egress, NULL);
+#endif
 }
 
 #ifdef CONFIG_NETFILTER_INGRESS
@@ -72,4 +75,28 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	return 0;
 }
 #endif /* CONFIG_NETFILTER_INGRESS */
+
+#ifdef CONFIG_NETFILTER_EGRESS
+static inline bool nf_hook_egress_active(const struct sk_buff *skb)
+{
+	return nf_hook_netdev_active(NF_NETDEV_EGRESS,
+				     skb->dev->nf_hooks_egress);
+}
+
+static inline int nf_hook_egress(struct sk_buff *skb)
+{
+	return nf_hook_netdev(skb, NF_NETDEV_EGRESS,
+			      skb->dev->nf_hooks_egress);
+}
+#else /* CONFIG_NETFILTER_EGRESS */
+static inline int nf_hook_egress_active(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_hook_egress(struct sk_buff *skb)
+{
+	return 0;
+}
+#endif /* CONFIG_NETFILTER_EGRESS */
 #endif /* _NETFILTER_INGRESS_H_ */
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..49fe4f3b8fbd 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -97,7 +97,7 @@ void net_inc_ingress_queue(void);
 void net_dec_ingress_queue(void);
 #endif
 
-#ifdef CONFIG_NET_EGRESS
+#ifdef CONFIG_NET_SCH_EGRESS
 void net_inc_egress_queue(void);
 void net_dec_egress_queue(void);
 #endif
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index ca9e63d6e0e4..d1616574c54f 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -50,6 +50,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index e1aae2df6762..ebdd2a348f38 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2099,20 +2099,30 @@ EXPORT_SYMBOL_GPL(net_dec_ingress_queue);
 #endif
 
 #ifdef CONFIG_NET_EGRESS
-static DEFINE_STATIC_KEY_FALSE(egress_needed_key);
+DEFINE_STATIC_KEY_FALSE(egress_needed_key);
+
+#ifdef CONFIG_NET_SCH_EGRESS
+static DEFINE_STATIC_KEY_FALSE(sch_egress_needed_key);
 
 void net_inc_egress_queue(void)
 {
 	static_branch_inc(&egress_needed_key);
+	static_branch_inc(&sch_egress_needed_key);
 }
 EXPORT_SYMBOL_GPL(net_inc_egress_queue);
 
 void net_dec_egress_queue(void)
 {
+	static_branch_dec(&sch_egress_needed_key);
 	static_branch_dec(&egress_needed_key);
 }
 EXPORT_SYMBOL_GPL(net_dec_egress_queue);
-#endif
+
+#define sch_egress_needed static_branch_unlikely(&sch_egress_needed_key)
+#else
+#define sch_egress_needed false
+#endif /* CONFIG_NET_SCH_EGRESS */
+#endif /* CONFIG_NET_EGRESS */
 
 static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
 #ifdef CONFIG_JUMP_LABEL
@@ -3854,9 +3864,20 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 EXPORT_SYMBOL(dev_loopback_xmit);
 
 #ifdef CONFIG_NET_EGRESS
-static struct sk_buff *
+static inline int nf_egress(struct sk_buff *skb)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = nf_hook_egress(skb);
+	rcu_read_unlock();
+	return ret;
+}
+
+static inline struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_SCH_EGRESS
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3890,6 +3911,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
+#endif /* CONFIG_NET_SCH_EGRESS */
+
+	return skb;
+}
+
+/* noinline reduces icache pressure in __dev_queue_xmit() hotpath for
+ * default case that neither netfilter nor traffic control is used.
+ */
+static noinline struct sk_buff *
+nf_sch_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
+{
+	if (nf_hook_egress_active(skb)) {
+		*ret = nf_egress(skb);
+		if (*ret < 0)
+			return NULL;
+	}
+
+	if (sch_egress_needed)
+		return sch_handle_egress(skb, ret, dev);
 
 	return skb;
 }
@@ -4081,13 +4121,13 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-# ifdef CONFIG_NET_EGRESS
+#endif
+#ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
-		skb = sch_handle_egress(skb, &rc, dev);
+		skb = nf_sch_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
 	}
-# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 25313c29d799..93a300af82b8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -10,6 +10,14 @@ config NETFILTER_INGRESS
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
 config NETFILTER_NETLINK
 	tristate
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3ac7c8c1548d..d42c8c2a7c30 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -306,6 +306,12 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
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
@@ -318,11 +324,13 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	struct nf_hook_entries __rcu **pp;
 
 	if (pf == NFPROTO_NETDEV) {
-#ifndef CONFIG_NETFILTER_INGRESS
-		if (reg->hooknum == NF_NETDEV_INGRESS)
+		if ((!IS_ENABLED(CONFIG_NETFILTER_INGRESS) &&
+		     reg->hooknum == NF_NETDEV_INGRESS) ||
+		    (!IS_ENABLED(CONFIG_NETFILTER_EGRESS) &&
+		     reg->hooknum == NF_NETDEV_EGRESS))
 			return -EOPNOTSUPP;
-#endif
-		if (reg->hooknum != NF_NETDEV_INGRESS ||
+		if ((reg->hooknum != NF_NETDEV_INGRESS &&
+		     reg->hooknum != NF_NETDEV_EGRESS) ||
 		    !reg->dev || dev_net(reg->dev) != net)
 			return -EINVAL;
 	}
@@ -348,6 +356,10 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
+		static_branch_inc(&egress_needed_key);
+#endif
 #ifdef CONFIG_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
@@ -406,6 +418,10 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
+			static_branch_dec(&egress_needed_key);
+#endif
 #ifdef CONFIG_JUMP_LABEL
 		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index c78d01bc02e9..67ce6dbb5496 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -277,9 +277,11 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
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
 
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..390b7e6b9e91 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -396,6 +396,9 @@ config NET_SCH_INGRESS
 	  To compile this code as a module, choose M here: the module will be
 	  called sch_ingress with alias of sch_clsact.
 
+config NET_SCH_EGRESS
+	def_bool NET_SCH_INGRESS
+
 config NET_SCH_PLUG
 	tristate "Plug network traffic until release (PLUG)"
 	help
-- 
2.27.0

