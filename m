Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B192F2FFF39
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbhAVJal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbhAVJK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:10:27 -0500
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67535C06178B;
        Fri, 22 Jan 2021 01:08:27 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 141B8102A88BC;
        Fri, 22 Jan 2021 10:05:29 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id ADD516017D32;
        Fri, 22 Jan 2021 10:05:28 +0100 (CET)
X-Mailbox-Line: From 05223ee20770fad62abe3898541fe873733f83c0 Mon Sep 17 00:00:00 2001
Message-Id: <05223ee20770fad62abe3898541fe873733f83c0.1611304190.git.lukas@wunner.de>
In-Reply-To: <cover.1611304190.git.lukas@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 22 Jan 2021 09:47:03 +0100
Subject: [PATCH nf-next v4 3/5] netfilter: Generalize ingress hook include
 file
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for addition of a netfilter egress hook by generalizing the
ingress hook include file.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
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
index 98c5abf22e63..931149bd654a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10602,7 +10602,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool_ops)
 		dev->ethtool_ops = &default_ethtool_ops;
 
-	nf_hook_ingress_init(dev);
+	nf_hook_netdev_init(dev);
 
 	return dev;
 
-- 
2.29.2

