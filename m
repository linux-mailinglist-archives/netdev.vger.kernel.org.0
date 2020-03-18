Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62AE1892FA
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgCRAk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:29 -0400
Received: from correo.us.es ([193.147.175.20]:45612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbgCRAk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D12A27F8B0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F509DA3A3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 04E43DA3A0; Wed, 18 Mar 2020 01:39:57 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0975DA72F;
        Wed, 18 Mar 2020 01:39:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7B3B8426CCB9;
        Wed, 18 Mar 2020 01:39:54 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 29/29] netfilter: Introduce egress hook
Date:   Wed, 18 Mar 2020 01:39:56 +0100
Message-Id: <20200318003956.73573-30-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

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
This hook is also useful for NAT46/NAT64, tunneling and filtering of
locally generated af_packet traffic such as dhclient.

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 654808bfad83..15f1e32b430c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1751,6 +1751,7 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2026,6 +2027,9 @@ struct net_device {
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
index 13d562f67e9c..a2da72a77c20 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3773,6 +3773,7 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3806,11 +3807,24 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
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
@@ -3997,13 +4011,16 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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
@@ -307,6 +307,12 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 			return &dev->nf_hooks_ingress;
 	}
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	if (hooknum == NF_NETDEV_EGRESS) {
+		if (dev && dev_net(dev) == net)
+			return &dev->nf_hooks_egress;
+	}
+#endif
 	WARN_ON_ONCE(1);
 	return NULL;
 }
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
2.11.0

