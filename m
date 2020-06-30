Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7C20EF9F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgF3HhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731084AbgF3HhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:01 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF6C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f2so8136888plr.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=lxTPN3o8HbcFbnlgDRluhb24sEeZGZmHsCdtaa0XQZA=;
        b=hw2cz92npJ53lRi0ODFswFp54HabVye0N5dJre9sKxaOpc+q0qELAsfNQeFtEaYc/G
         EGGXRt+jwndbu1KHQgbJPLR+MeUhdM4v98G+sfXQotD+woiAsnDHbqw+no6klUscCX7p
         jvF0REmfhrw4G2dB1rpaFBBLFw8SEPjNXV3LFmlSK8xxt9VnyDyObjm8zAewRitsQDA4
         LVp5gjN3FjY1a/XA6wioLrvbEPWKC7+wuV/h1xrwFJ0yZrFr438uklioV0pXEhQXwWGI
         dZ/s0mfAo4tdUSdqUmCdn0nlGteJQc9YN13+U7JBsaE27084QzC49ZFunWpbC9t5qbu2
         Jq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=lxTPN3o8HbcFbnlgDRluhb24sEeZGZmHsCdtaa0XQZA=;
        b=PLFdfKUEoVczqM79oMJLllqHouggiJnZyKkZ2XkNPjmvqkN/fWZnFxr/OZMNt0BGuf
         2wllmIZqC7wD0c+TCbZ59QU09K1YpSx1PIsPBb7TpZkK/gRDvS87KFnZHuKWEPWHpQ2V
         dhyq+kDAEUsMEy9ohaUrK025Mm6i6HDRwlly7SoKmLBdcGwQXpLzy+ZxWk8c/IqTO5jw
         ppv3GwCKFGoxs67MeL6Y3T36wRyXlw+wIj2EplwVrH3dn6eQTXxJaL9rf0JLccosgiT5
         6f8FB6kFyhqxXJLZBmwADkdGavd2HSi+/aQLolUcO41v57/wJ7GixwavNg0+M06T140Z
         nOVA==
X-Gm-Message-State: AOAM533VT8Sk/oCuc1Wb870HwnAG+zZ2cKqvVOD57hYUKQJhRijxlyjp
        AmKcvuKKU+viFeX1fJ4+nQijyA8p
X-Google-Smtp-Source: ABdhPJyf098yqdLNni78/NuSO+55Fd/V4nIptnLgK21MctsZha5lsfBEossQviWSjBEaivlHwc9/ZQ==
X-Received: by 2002:a17:90b:94f:: with SMTP id dw15mr8972262pjb.209.1593502620580;
        Tue, 30 Jun 2020 00:37:00 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a17sm1410440pjh.31.2020.06.30.00.36.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:36:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
Date:   Tue, 30 Jun 2020 15:36:27 +0800
Message-Id: <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel4_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.

v1->v2:
  - Fix a sparse warning caused by the missing "__rcu", as Jakub
    noticed.
  - Handle the err returned by xfrm_input_register_afinfo() in
    tunnel4_init/fini(), as Sabrina noticed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv4/tunnel4.c | 35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4666bc9..c1ec629 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1416,6 +1416,7 @@ struct xfrm6_protocol {
 /* XFRM tunnel handlers.  */
 struct xfrm_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, u32 info);
 
 	struct xfrm_tunnel __rcu *next;
diff --git a/net/ipv4/tunnel4.c b/net/ipv4/tunnel4.c
index c4b2ccb..5d98f49 100644
--- a/net/ipv4/tunnel4.c
+++ b/net/ipv4/tunnel4.c
@@ -110,6 +110,31 @@ static int tunnel4_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+static int tunnel4_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm_tunnel __rcu *head;
+	struct xfrm_tunnel *handler;
+	int ret;
+
+	head = (proto == IPPROTO_IPIP) ? tunnel4_handlers : tunnel64_handlers;
+
+	for_each_tunnel_rcu(head, handler) {
+		if (handler->cb_handler) {
+			ret = handler->cb_handler(skb, err);
+			if (ret <= 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct xfrm_input_afinfo tunnel4_input_afinfo = {
+	.family		=	AF_INET,
+	.is_ipip	=	true,
+	.callback	=	tunnel4_rcv_cb,
+};
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int tunnel64_rcv(struct sk_buff *skb)
 {
@@ -214,16 +239,22 @@ static const struct net_protocol tunnelmpls4_protocol = {
 
 static int __init tunnel4_init(void)
 {
-	if (inet_add_protocol(&tunnel4_protocol, IPPROTO_IPIP))
+	if (xfrm_input_register_afinfo(&tunnel4_input_afinfo))
+		goto err;
+	if (inet_add_protocol(&tunnel4_protocol, IPPROTO_IPIP)) {
+		xfrm_input_unregister_afinfo(&tunnel4_input_afinfo);
 		goto err;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (inet_add_protocol(&tunnel64_protocol, IPPROTO_IPV6)) {
+		xfrm_input_unregister_afinfo(&tunnel4_input_afinfo);
 		inet_del_protocol(&tunnel4_protocol, IPPROTO_IPIP);
 		goto err;
 	}
 #endif
 #if IS_ENABLED(CONFIG_MPLS)
 	if (inet_add_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS)) {
+		xfrm_input_unregister_afinfo(&tunnel4_input_afinfo);
 		inet_del_protocol(&tunnel4_protocol, IPPROTO_IPIP);
 #if IS_ENABLED(CONFIG_IPV6)
 		inet_del_protocol(&tunnel64_protocol, IPPROTO_IPV6);
@@ -250,6 +281,8 @@ static void __exit tunnel4_fini(void)
 #endif
 	if (inet_del_protocol(&tunnel4_protocol, IPPROTO_IPIP))
 		pr_err("tunnel4 close: can't remove protocol\n");
+	if (xfrm_input_unregister_afinfo(&tunnel4_input_afinfo))
+		pr_err("tunnel4 close: can't remove input afinfo\n");
 }
 
 module_init(tunnel4_init);
-- 
2.1.0

