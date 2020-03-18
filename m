Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F171897F9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgCRJdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:33:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:48324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgCRJdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:33:55 -0400
Received: from 192.42.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.42.192] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEV59-000296-C5; Wed, 18 Mar 2020 10:33:47 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net-next] netfilter: revert introduction of egress hook
Date:   Wed, 18 Mar 2020 10:33:22 +0100
Message-Id: <bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts the following commits:

  8537f78647c0 ("netfilter: Introduce egress hook")
  5418d3881e1f ("netfilter: Generalize ingress hook")
  b030f194aed2 ("netfilter: Rename ingress hook include file")

From the discussion in [0], the author's main motivation to add a hook
in fast path is for an out of tree kernel module, which is a red flag
to begin with. Other mentioned potential use cases like NAT{64,46}
is on future extensions w/o concrete code in the tree yet. Revert as
suggested [1] given the weak justification to add more hooks to critical
fast-path.

  [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.de/
  [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.davem@davemloft.net/

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Miller <davem@davemloft.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/netdevice.h         |   4 --
 include/linux/netfilter_ingress.h |  58 +++++++++++++++++
 include/linux/netfilter_netdev.h  | 102 ------------------------------
 include/uapi/linux/netfilter.h    |   1 -
 net/core/dev.c                    |  27 ++------
 net/netfilter/Kconfig             |   8 ---
 net/netfilter/core.c              |  24 ++-----
 net/netfilter/nft_chain_filter.c  |   4 +-
 8 files changed, 68 insertions(+), 160 deletions(-)
 create mode 100644 include/linux/netfilter_ingress.h
 delete mode 100644 include/linux/netfilter_netdev.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 15f1e32b430c..654808bfad83 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1751,7 +1751,6 @@ enum netdev_priv_flags {
  *	@xps_maps:	XXX: need comments on this one
  *	@miniq_egress:		clsact qdisc specific data for
  *				egress processing
- *	@nf_hooks_egress:	netfilter hooks executed for egress packets
  *	@qdisc_hash:		qdisc hash table
  *	@watchdog_timeo:	Represents the timeout that is used by
  *				the watchdog (see dev_watchdog())
@@ -2027,9 +2026,6 @@ struct net_device {
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
-#ifdef CONFIG_NETFILTER_EGRESS
-	struct nf_hook_entries __rcu *nf_hooks_egress;
-#endif
 
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
new file mode 100644
index 000000000000..a13774be2eb5
--- /dev/null
+++ b/include/linux/netfilter_ingress.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NETFILTER_INGRESS_H_
+#define _NETFILTER_INGRESS_H_
+
+#include <linux/netfilter.h>
+#include <linux/netdevice.h>
+
+#ifdef CONFIG_NETFILTER_INGRESS
+static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
+{
+#ifdef CONFIG_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_INGRESS]))
+		return false;
+#endif
+	return rcu_access_pointer(skb->dev->nf_hooks_ingress);
+}
+
+/* caller must hold rcu_read_lock */
+static inline int nf_hook_ingress(struct sk_buff *skb)
+{
+	struct nf_hook_entries *e = rcu_dereference(skb->dev->nf_hooks_ingress);
+	struct nf_hook_state state;
+	int ret;
+
+	/* Must recheck the ingress hook head, in the event it became NULL
+	 * after the check in nf_hook_ingress_active evaluated to true.
+	 */
+	if (unlikely(!e))
+		return 0;
+
+	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
+			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
+			   dev_net(skb->dev), NULL);
+	ret = nf_hook_slow(skb, &state, e, 0);
+	if (ret == 0)
+		return -1;
+
+	return ret;
+}
+
+static inline void nf_hook_ingress_init(struct net_device *dev)
+{
+	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
+}
+#else /* CONFIG_NETFILTER_INGRESS */
+static inline int nf_hook_ingress_active(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_hook_ingress(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline void nf_hook_ingress_init(struct net_device *dev) {}
+#endif /* CONFIG_NETFILTER_INGRESS */
+#endif /* _NETFILTER_INGRESS_H_ */
diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
deleted file mode 100644
index 92d3611a782e..000000000000
--- a/include/linux/netfilter_netdev.h
+++ /dev/null
@@ -1,102 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NETFILTER_NETDEV_H_
-#define _NETFILTER_NETDEV_H_
-
-#include <linux/netfilter.h>
-#include <linux/netdevice.h>
-
-#ifdef CONFIG_NETFILTER
-static __always_inline bool nf_hook_netdev_active(enum nf_dev_hooks hooknum,
-					  struct nf_hook_entries __rcu *hooks)
-{
-#ifdef CONFIG_JUMP_LABEL
-	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][hooknum]))
-		return false;
-#endif
-	return rcu_access_pointer(hooks);
-}
-
-/* caller must hold rcu_read_lock */
-static __always_inline int nf_hook_netdev(struct sk_buff *skb,
-					  enum nf_dev_hooks hooknum,
-					  struct nf_hook_entries __rcu *hooks)
-{
-	struct nf_hook_entries *e = rcu_dereference(hooks);
-	struct nf_hook_state state;
-	int ret;
-
-	/* Must recheck the hook head, in the event it became NULL
-	 * after the check in nf_hook_netdev_active evaluated to true.
-	 */
-	if (unlikely(!e))
-		return 0;
-
-	nf_hook_state_init(&state, hooknum,
-			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
-			   dev_net(skb->dev), NULL);
-	ret = nf_hook_slow(skb, &state, e, 0);
-	if (ret == 0)
-		return -1;
-
-	return ret;
-}
-#endif /* CONFIG_NETFILTER */
-
-static inline void nf_hook_netdev_init(struct net_device *dev)
-{
-#ifdef CONFIG_NETFILTER_INGRESS
-	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
-#endif
-#ifdef CONFIG_NETFILTER_EGRESS
-	RCU_INIT_POINTER(dev->nf_hooks_egress, NULL);
-#endif
-}
-
-#ifdef CONFIG_NETFILTER_INGRESS
-static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
-{
-	return nf_hook_netdev_active(NF_NETDEV_INGRESS,
-				     skb->dev->nf_hooks_ingress);
-}
-
-static inline int nf_hook_ingress(struct sk_buff *skb)
-{
-	return nf_hook_netdev(skb, NF_NETDEV_INGRESS,
-			      skb->dev->nf_hooks_ingress);
-}
-#else /* CONFIG_NETFILTER_INGRESS */
-static inline int nf_hook_ingress_active(struct sk_buff *skb)
-{
-	return 0;
-}
-
-static inline int nf_hook_ingress(struct sk_buff *skb)
-{
-	return 0;
-}
-#endif /* CONFIG_NETFILTER_INGRESS */
-
-#ifdef CONFIG_NETFILTER_EGRESS
-static inline bool nf_hook_egress_active(const struct sk_buff *skb)
-{
-	return nf_hook_netdev_active(NF_NETDEV_EGRESS,
-				     skb->dev->nf_hooks_egress);
-}
-
-static inline int nf_hook_egress(struct sk_buff *skb)
-{
-	return nf_hook_netdev(skb, NF_NETDEV_EGRESS,
-			      skb->dev->nf_hooks_egress);
-}
-#else /* CONFIG_NETFILTER_EGRESS */
-static inline int nf_hook_egress_active(struct sk_buff *skb)
-{
-	return 0;
-}
-
-static inline int nf_hook_egress(struct sk_buff *skb)
-{
-	return 0;
-}
-#endif /* CONFIG_NETFILTER_EGRESS */
-#endif /* _NETFILTER_INGRESS_H_ */
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index d1616574c54f..ca9e63d6e0e4 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -50,7 +50,6 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
-	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index aeb8ccbbe93b..021e18251465 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -135,7 +135,7 @@
 #include <linux/if_macvlan.h>
 #include <linux/errqueue.h>
 #include <linux/hrtimer.h>
-#include <linux/netfilter_netdev.h>
+#include <linux/netfilter_ingress.h>
 #include <linux/crash_dump.h>
 #include <linux/sctp.h>
 #include <net/udp_tunnel.h>
@@ -3773,7 +3773,6 @@ EXPORT_SYMBOL(dev_loopback_xmit);
 static struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
-#ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3807,24 +3806,11 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
-#endif /* CONFIG_NET_CLS_ACT */
+
 	return skb;
 }
 #endif /* CONFIG_NET_EGRESS */
 
-static inline int nf_egress(struct sk_buff *skb)
-{
-	if (nf_hook_egress_active(skb)) {
-		int ret;
-
-		rcu_read_lock();
-		ret = nf_hook_egress(skb);
-		rcu_read_unlock();
-		return ret;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_XPS
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb,
 			       struct xps_dev_maps *dev_maps, unsigned int tci)
@@ -4011,16 +3997,13 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	qdisc_pkt_len_init(skb);
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_at_ingress = 0;
-#endif
-#ifdef CONFIG_NET_EGRESS
+# ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
-		if (nf_egress(skb) < 0)
-			goto out;
-
 		skb = sch_handle_egress(skb, &rc, dev);
 		if (!skb)
 			goto out;
 	}
+# endif
 #endif
 	/* If device/qdisc don't need skb->dst, release it right now while
 	 * its hot in this cpu cache.
@@ -9867,7 +9850,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool_ops)
 		dev->ethtool_ops = &default_ethtool_ops;
 
-	nf_hook_netdev_init(dev);
+	nf_hook_ingress_init(dev);
 
 	return dev;
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f4c68f60f241..468fea1aebba 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -10,14 +10,6 @@ config NETFILTER_INGRESS
 	  This allows you to classify packets from ingress using the Netfilter
 	  infrastructure.
 
-config NETFILTER_EGRESS
-	bool "Netfilter egress support"
-	default y
-	select NET_EGRESS
-	help
-	  This allows you to classify packets before transmission using the
-	  Netfilter infrastructure.
-
 config NETFILTER_NETLINK
 	tristate
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 85e9c959aba7..78f046ec506f 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -306,12 +306,6 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 		if (dev && dev_net(dev) == net)
 			return &dev->nf_hooks_ingress;
 	}
-#endif
-#ifdef CONFIG_NETFILTER_EGRESS
-	if (hooknum == NF_NETDEV_EGRESS) {
-		if (dev && dev_net(dev) == net)
-			return &dev->nf_hooks_egress;
-	}
 #endif
 	WARN_ON_ONCE(1);
 	return NULL;
@@ -324,13 +318,11 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	struct nf_hook_entries __rcu **pp;
 
 	if (pf == NFPROTO_NETDEV) {
-		if ((!IS_ENABLED(CONFIG_NETFILTER_INGRESS) &&
-		     reg->hooknum == NF_NETDEV_INGRESS) ||
-		    (!IS_ENABLED(CONFIG_NETFILTER_EGRESS) &&
-		     reg->hooknum == NF_NETDEV_EGRESS))
+#ifndef CONFIG_NETFILTER_INGRESS
+		if (reg->hooknum == NF_NETDEV_INGRESS)
 			return -EOPNOTSUPP;
-		if ((reg->hooknum != NF_NETDEV_INGRESS &&
-		     reg->hooknum != NF_NETDEV_EGRESS) ||
+#endif
+		if (reg->hooknum != NF_NETDEV_INGRESS ||
 		    !reg->dev || dev_net(reg->dev) != net)
 			return -EINVAL;
 	}
@@ -356,10 +348,6 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
-#ifdef CONFIG_NETFILTER_EGRESS
-	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
-		net_inc_egress_queue();
-#endif
 #ifdef CONFIG_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
@@ -418,10 +406,6 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
 #endif
-#ifdef CONFIG_NETFILTER_EGRESS
-		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
-			net_dec_egress_queue();
-#endif
 #ifdef CONFIG_JUMP_LABEL
 		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 67ce6dbb5496..c78d01bc02e9 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -277,11 +277,9 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_NETDEV,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS) |
-			  (1 << NF_NETDEV_EGRESS),
+	.hook_mask	= (1 << NF_NETDEV_INGRESS),
 	.hooks		= {
 		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
-		[NF_NETDEV_EGRESS]	= nft_do_chain_netdev,
 	},
 };
 
-- 
2.21.0

