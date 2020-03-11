Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D833181784
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgCKMIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:08:54 -0400
Received: from mailout3.hostsharing.net ([176.9.242.54]:55463 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgCKMIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:08:53 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 56C52101E692E;
        Wed, 11 Mar 2020 13:08:50 +0100 (CET)
Received: from localhost (unknown [87.130.102.138])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 9AD9C6005A67;
        Wed, 11 Mar 2020 13:08:49 +0100 (CET)
X-Mailbox-Line: From 14ab7e5af20124a34a50426fd570da7d3b0369ce Mon Sep 17 00:00:00 2001
Message-Id: <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
In-Reply-To: <cover.1583927267.git.lukas@wunner.de>
References: <cover.1583927267.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 11 Mar 2020 12:59:03 +0100
Subject: [PATCH nf-next 3/3] netfilter: Introduce egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
handle_ing() under unique static key") introduced the ability to
classify packets on ingress.

Allow the same on egress.  Position the hook immediately before a packet
is handed to tc and then sent out on an interface, thereby mirroring the
ingress order.  This order allows marking packets in the netfilter
egress hook and subsequently using the mark in tc.  Another benefit of
this order is consistency with a lot of existing documentation which
says that egress tc is performed after netfilter hooks.

Egress hooks already exist for the most common protocols, such as
NF_INET_LOCAL_OUT or NF_ARP_OUT, and those are to be preferred because
they are executed earlier during packet processing.  However for more
exotic protocols, there is currently no provision to apply netfilter on
egress.  A common workaround is to enslave the interface to a bridge and
use ebtables, or to resort to tc.  But when the ingress hook was
introduced, consensus was that users should be given the choice to use
netfilter or tc, whichever tool suits their needs best:
https://lore.kernel.org/netdev/20150430153317.GA3230@salvia/

There have also been occasional user requests for a netfilter egress
hook in the past, e.g.:
https://www.spinics.net/lists/netfilter/msg50038.html

Performance measurements with pktgen surprisingly show a speedup rather
than a slowdown with this commit:

* Without this commit:
  Result: OK: 34240933(c34238375+d2558) usec, 100000000 (60byte,0frags)
  2920481pps 1401Mb/sec (1401830880bps) errors: 0

* With this commit:
  Result: OK: 33997299(c33994193+d3106) usec, 100000000 (60byte,0frags)
  2941410pps 1411Mb/sec (1411876800bps) errors: 0

* Without this commit + tc egress:
  Result: OK: 39022386(c39019547+d2839) usec, 100000000 (60byte,0frags)
  2562631pps 1230Mb/sec (1230062880bps) errors: 0

* With this commit + tc egress:
  Result: OK: 37604447(c37601877+d2570) usec, 100000000 (60byte,0frags)
  2659259pps 1276Mb/sec (1276444320bps) errors: 0

* With this commit + nft egress:
  Result: OK: 41436689(c41434088+d2600) usec, 100000000 (60byte,0frags)
  2413320pps 1158Mb/sec (1158393600bps) errors: 0

Tested on a bare-metal Core i7-3615QM, each measurement was performed
three times to verify that the numbers are stable.

Commands to perform a measurement:
modprobe pktgen
echo "add_device lo@3" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i 'lo@3' -n 100000000

Commands for testing tc egress:
tc qdisc add dev lo clsact
tc filter add dev lo egress protocol ip prio 1 u32 match ip dst 4.3.2.1/32

Commands for testing nft egress:
nft add table netdev t
nft add chain netdev t co \{ type filter hook egress device lo priority 0 \; \}
nft add rule netdev t co ip daddr 4.3.2.1/32 drop

All testing was performed on the loopback interface to avoid distorting
measurements by the packet handling in the low-level Ethernet driver.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/netdevice.h        |  4 ++++
 include/linux/netfilter_netdev.h | 27 +++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h   |  1 +
 net/core/dev.c                   | 23 ++++++++++++++++++++---
 net/netfilter/Kconfig            |  8 ++++++++
 net/netfilter/core.c             | 24 ++++++++++++++++++++----
 net/netfilter/nft_chain_filter.c |  4 +++-
 7 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c3f7032e8d9..2d2606d1b1b3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1750,6 +1750,7 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2025,6 +2026,9 @@ struct net_device {
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
index 2e55d4e41517..89724a9f1bbb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3771,6 +3771,7 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3804,11 +3805,24 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
-
+#endif /* CONFIG_NET_CLS_ACT */
 	return skb;
 }
 #endif /* CONFIG_NET_EGRESS */
 
+static inline int nf_egress(struct sk_buff *skb)
+{
+	if (nf_hook_egress_active(skb)) {
+		int ret;
+
+		rcu_read_lock();
+		ret = nf_hook_egress(skb);
+		rcu_read_unlock();
+		return ret;
+	}
+	return 0;
+}
+
 #ifdef CONFIG_XPS
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 			       struct xps_dev_maps *dev_maps, unsigned int tci)
@@ -3995,13 +4009,16 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-# ifdef CONFIG_NET_EGRESS
+#endif
+#ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
+		if (nf_egress(skb) < 0)
+			goto out;
+
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
 	}
-# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 468fea1aebba..f4c68f60f241 100644
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
index 78f046ec506f..85e9c959aba7 100644
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
+		net_inc_egress_queue();
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
+			net_dec_egress_queue();
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
 
-- 
2.25.0

