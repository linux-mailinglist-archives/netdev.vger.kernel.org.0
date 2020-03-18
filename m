Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1520189300
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCRAkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:36 -0400
Received: from correo.us.es ([193.147.175.20]:45678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgCRAkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EDBA227F8A1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFCB9DA3A1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4F60DA39F; Wed, 18 Mar 2020 01:39:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0729DDA736;
        Wed, 18 Mar 2020 01:39:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D4B77426CCB9;
        Wed, 18 Mar 2020 01:39:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 28/29] netfilter: Generalize ingress hook
Date:   Wed, 18 Mar 2020 01:39:55 +0100
Message-Id: <20200318003956.73573-29-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Prepare for addition of a netfilter egress hook by generalizing the
ingress hook introduced by commit e687ad60af09 ("netfilter: add
netfilter ingress hook after handle_ing() under unique static key").

In particular, rename and refactor the ingress hook's static inlines
such that they can be reused for an egress hook.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_netdev.h | 45 +++++++++++++++++++++++++++-------------
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
index b1ce1c942b54..13d562f67e9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9846,7 +9846,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool_ops)
 		dev->ethtool_ops = &default_ethtool_ops;
 
-	nf_hook_ingress_init(dev);
+	nf_hook_netdev_init(dev);
 
 	return dev;
 
-- 
2.11.0

