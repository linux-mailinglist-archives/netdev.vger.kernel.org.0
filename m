Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7D21FBD1D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgFPRhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgFPRhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A47BC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j4so5441719plk.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=wylqK8f9emW+9fTaWurvaXqAEbgEJfZzflg9Ru2l1nY=;
        b=dn7dEWpMTeMG5m8Y5gmo52Q7l686f/x9q262WG4MgoiExDnBerbA18wU4SGOsbMhZH
         ZE9tNcvG1Ws3mczBXTLehsjV6+Q5oZTi6+FYx27Mp0c5SdyuKWiftIhR0DBzIDw8WjOa
         0QY+0gh77cF4sWI061d5UXWgEv5AvZT9dap8WG7H6y2cOw88vI8es1pNlKXhZwXI9jyy
         7hiVaKGSYyegkGIt5Ag0r7wck1Dz1SZCRROlvFt0f5O7A7VbiRopB3piOD3KPBpQMYWI
         kMTqX6Ay2qcjeliR4N1f5isO1WKeu3A0KgOWL9JJD+YJpgqEUvptdrN9ucyNfzZ4WOsQ
         K5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=wylqK8f9emW+9fTaWurvaXqAEbgEJfZzflg9Ru2l1nY=;
        b=mvAyhsa1ex+U9Rkc6yqJk2jh+AjJunY0BqOtCBRm1fgEfb4DXc43wIaGtb//U0/dFI
         KgENSPgJhOlqW2IujQMmEvoHrg3ThaivSMjLoiAYAbA/jTHq75yg49Jn1EkUOFzSpggA
         mR8ANOypezBnOrfF86V0tOyTTVW64BJjojRX2PBwq+OARXjs6dfEpCEFEdQMdcKWc2t7
         c0I2b/rAXqKybT6S+aJtG/+ob1x/Der3R70f7LxAYTaLhBRqTu6+SXZ8xfnZezpM2JNJ
         0Qfsi/lEztJjTZyluP7GdgT7lydjTQRjLCmFu8YrXxtUYy70WfwqNEAA9GuOSpZ0yYtz
         xOrg==
X-Gm-Message-State: AOAM532oap9kYR2OqvP9sFfgkRxAEMzwgrHuujiIG891bIrosF5kZuvK
        kGprJSOCv3Cw9RBknQjgUJNcG/SbCOk=
X-Google-Smtp-Source: ABdhPJw+9XP1kwlxSGZKu13UWuLsOce02bpNkQP628cUR5nX8Br1L8ttbGJxrDTer4GGneG7qrKzNw==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr2995700pls.111.1592329020383;
        Tue, 16 Jun 2020 10:37:00 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s197sm18234666pfc.188.2020.06.16.10.36.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:36:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
Date:   Wed, 17 Jun 2020 01:36:27 +0800
Message-Id: <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel4_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv4/tunnel4.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4aa118d..c69410d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1415,6 +1415,7 @@ struct xfrm6_protocol {
 /* XFRM tunnel handlers.  */
 struct xfrm_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, u32 info);
 
 	struct xfrm_tunnel __rcu *next;
diff --git a/net/ipv4/tunnel4.c b/net/ipv4/tunnel4.c
index c4b2ccb..5968d78 100644
--- a/net/ipv4/tunnel4.c
+++ b/net/ipv4/tunnel4.c
@@ -110,6 +110,30 @@ static int tunnel4_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+static int tunnel4_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm_tunnel *head, *handler;
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
@@ -231,6 +255,7 @@ static int __init tunnel4_init(void)
 		goto err;
 	}
 #endif
+	xfrm_input_register_afinfo(&tunnel4_input_afinfo);
 	return 0;
 
 err:
@@ -240,6 +265,7 @@ static int __init tunnel4_init(void)
 
 static void __exit tunnel4_fini(void)
 {
+	xfrm_input_unregister_afinfo(&tunnel4_input_afinfo);
 #if IS_ENABLED(CONFIG_MPLS)
 	if (inet_del_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS))
 		pr_err("tunnelmpls4 close: can't remove protocol\n");
-- 
2.1.0

