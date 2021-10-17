Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ED7430C96
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbhJQWRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53396 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344752AbhJQWRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:52 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9716263F04;
        Mon, 18 Oct 2021 00:14:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 04/15] netfilter: Generalize ingress hook include file
Date:   Mon, 18 Oct 2021 00:15:11 +0200
Message-Id: <20211017221522.853838-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Prepare for addition of a netfilter egress hook by generalizing the
ingress hook include file.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_netdev.h | 20 +++++++++++---------
 net/core/dev.c                   |  2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index a13774be2eb5..5812b0fb0278 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NETFILTER_INGRESS_H_
-#define _NETFILTER_INGRESS_H_
+#ifndef _NETFILTER_NETDEV_H_
+#define _NETFILTER_NETDEV_H_
 
 #include <linux/netfilter.h>
 #include <linux/netdevice.h>
@@ -38,10 +38,6 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	return ret;
 }
 
-static inline void nf_hook_ingress_init(struct net_device *dev)
-{
-	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
-}
 #else /* CONFIG_NETFILTER_INGRESS */
 static inline int nf_hook_ingress_active(struct sk_buff *skb)
 {
@@ -52,7 +48,13 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 {
 	return 0;
 }
-
-static inline void nf_hook_ingress_init(struct net_device *dev) {}
 #endif /* CONFIG_NETFILTER_INGRESS */
-#endif /* _NETFILTER_INGRESS_H_ */
+
+static inline void nf_hook_netdev_init(struct net_device *dev)
+{
+#ifdef CONFIG_NETFILTER_INGRESS
+	RCU_INIT_POINTER(dev->nf_hooks_ingress, NULL);
+#endif
+}
+
+#endif /* _NETFILTER_NETDEV_H_ */
diff --git a/net/core/dev.c b/net/core/dev.c
index 0fd3c6490e06..e4c683029c61 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10867,7 +10867,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool_ops)
 		dev->ethtool_ops = &default_ethtool_ops;
 
-	nf_hook_ingress_init(dev);
+	nf_hook_netdev_init(dev);
 
 	return dev;
 
-- 
2.30.2

