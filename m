Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C560EB21C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfJaOGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:06:19 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:60955 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfJaOGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:06:18 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 22DBC101933FD;
        Thu, 31 Oct 2019 15:06:16 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id D5548613C8DC;
        Thu, 31 Oct 2019 15:06:15 +0100 (CET)
X-Mailbox-Line: From de461181e53bcec9a75a9630d0d998d555dc8bf5 Mon Sep 17 00:00:00 2001
Message-Id: <de461181e53bcec9a75a9630d0d998d555dc8bf5.1572528497.git.lukas@wunner.de>
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:05 +0100
Subject: [PATCH nf-next,RFC 5/5] netfilter: Introduce egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
handle_ing() under unique static key") introduced the ability to
classify packets on ingress.

Allow the same on egress.

The need for this arose because I had to filter egress packets which do
not match a specific ethertype.  The most common solution appears to be
to enslave the interface to a bridge and use ebtables, but that's
cumbersome to configure and comes with a (small) performance penalty.
An alternative approach is tc, but that doesn't afford equivalent
matching options as netfilter.  A bit of googling reveals that more
people have expressed a desire for egress filtering in the past:

https://www.spinics.net/lists/netfilter/msg50038.html
https://unix.stackexchange.com/questions/512371

An egress hook therefore seems like an obvious addition.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/netdevice.h        |  4 ++++
 include/linux/netfilter_netdev.h | 27 +++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h   |  1 +
 net/core/dev.c                   | 25 ++++++++++++++++++++-----
 net/netfilter/Kconfig            |  8 ++++++++
 net/netfilter/core.c             | 24 ++++++++++++++++++++----
 net/netfilter/nft_chain_filter.c |  4 +++-
 7 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bc6914ea3faf..111107aed50b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1720,6 +1720,7 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
+ *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
  *	@watchdog_timer:	List of timers
@@ -1981,6 +1982,9 @@ struct net_device {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
+#ifdef CONFIG_NETFILTER_EGRESS
+	struct nf_hook_entries __rcu *nf_hooks_egress;
+#endif
 
 	/* These may be needed for future network-power-down code. */
 	struct timer_list	watchdog_timer;
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
index e4976f68f2dd..d1e48fc4ae5c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3811,10 +3811,10 @@ int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(dev_loopback_xmit);
 
-#ifdef CONFIG_NET_EGRESS
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
+#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3848,10 +3848,22 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
-
+#endif /* CONFIG_NET_CLS_ACT */
 	return skb;
 }
-#endif /* CONFIG_NET_EGRESS */
+
+static int nf_egress(struct sk_buff *skb)
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
 
 #ifdef CONFIG_XPS
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
@@ -4039,13 +4051,16 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-# ifdef CONFIG_NET_EGRESS
+#endif
+#ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
+
+		if (nf_egress(skb) < 0)
+			goto out;
 	}
-# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..a6ae141ec77e 100644
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
2.23.0

