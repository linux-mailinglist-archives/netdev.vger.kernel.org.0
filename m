Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97E6EB1BD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfJaN7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:59:11 -0400
Received: from mailout2.hostsharing.net ([83.223.78.233]:44937 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbfJaN7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 09:59:10 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 8670F10189C8E;
        Thu, 31 Oct 2019 14:59:08 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 37A36613C8DC;
        Thu, 31 Oct 2019 14:59:08 +0100 (CET)
X-Mailbox-Line: From 9da2050c3bce81730e58eda7888e5f8eb4a96d56 Mon Sep 17 00:00:00 2001
Message-Id: <9da2050c3bce81730e58eda7888e5f8eb4a96d56.1572528497.git.lukas@wunner.de>
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:04 +0100
Subject: [PATCH nf-next,RFC 4/5] netfilter: Generalize ingress hook
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

Prepare for addition of a netfilter egress hook by generalizing the
ingress hook introduced by commit e687ad60af09 ("netfilter: add
netfilter ingress hook after handle_ing() under unique static key").

In particular, rename and refactor the ingress hook's static inlines
such that they can be reused for an egress hook.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/netfilter_netdev.h | 45 ++++++++++++++++++++++----------
 net/core/dev.c                   |  2 +-
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index a13774be2eb5..49e26479642e 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -1,34 +1,37 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NETFILTER_INGRESS_H_
-#define _NETFILTER_INGRESS_H_
+#ifndef _NETFILTER_NETDEV_H_
+#define _NETFILTER_NETDEV_H_
 
 #include <linux/netfilter.h>
 #include <linux/netdevice.h>
 
-#ifdef CONFIG_NETFILTER_INGRESS
-static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
+#ifdef CONFIG_NETFILTER
+static __always_inline bool nf_hook_netdev_active(enum nf_dev_hooks hooknum,
+					  struct nf_hook_entries __rcu *hooks)
 {
 #ifdef CONFIG_JUMP_LABEL
-	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_INGRESS]))
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][hooknum]))
 		return false;
 #endif
-	return rcu_access_pointer(skb->dev->nf_hooks_ingress);
+	return rcu_access_pointer(hooks);
 }
 
 /* caller must hold rcu_read_lock */
-static inline int nf_hook_ingress(struct sk_buff *skb)
+static __always_inline int nf_hook_netdev(struct sk_buff *skb,
+					  enum nf_dev_hooks hooknum,
+					  struct nf_hook_entries __rcu *hooks)
 {
-	struct nf_hook_entries *e = rcu_dereference(skb->dev->nf_hooks_ingress);
+	struct nf_hook_entries *e = rcu_dereference(hooks);
 	struct nf_hook_state state;
 	int ret;
 
-	/* Must recheck the ingress hook head, in the event it became NULL
-	 * after the check in nf_hook_ingress_active evaluated to true.
+	/* Must recheck the hook head, in the event it became NULL
+	 * after the check in nf_hook_netdev_active evaluated to true.
 	 */
 	if (unlikely(!e))
 		return 0;
 
-	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
+	nf_hook_state_init(&state, hooknum,
 			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
 			   dev_net(skb->dev), NULL);
 	ret = nf_hook_slow(skb, &state, e, 0);
@@ -37,10 +40,26 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 
 	return ret;
 }
+#endif /* CONFIG_NETFILTER */
 
-static inline void nf_hook_ingress_init(struct net_device *dev)
+static inline void nf_hook_netdev_init(struct net_device *dev)
 {
+#ifdef CONFIG_NETFILTER_INGRESS
 	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
+#endif
+}
+
+#ifdef CONFIG_NETFILTER_INGRESS
+static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
+{
+	return nf_hook_netdev_active(NF_NETDEV_INGRESS,
+				     skb->dev->nf_hooks_ingress);
+}
+
+static inline int nf_hook_ingress(struct sk_buff *skb)
+{
+	return nf_hook_netdev(skb, NF_NETDEV_INGRESS,
+			      skb->dev->nf_hooks_ingress);
 }
 #else /* CONFIG_NETFILTER_INGRESS */
 static inline int nf_hook_ingress_active(struct sk_buff *skb)
@@ -52,7 +71,5 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 {
 	return 0;
 }
-
-static inline void nf_hook_ingress_init(struct net_device *dev) {}
 #endif /* CONFIG_NETFILTER_INGRESS */
 #endif /* _NETFILTER_INGRESS_H_ */
diff --git a/net/core/dev.c b/net/core/dev.c
index c698a0fcfa02..e4976f68f2dd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9478,7 +9478,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool_ops)
 		dev->ethtool_ops = &default_ethtool_ops;
 
-	nf_hook_ingress_init(dev);
+	nf_hook_netdev_init(dev);
 
 	return dev;
 
-- 
2.23.0

