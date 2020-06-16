Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6EA1FBD1E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbgFPRhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgFPRhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36BFC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:09 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so8691975plt.5
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Eh83GUpnDgPrW8AEnAz5rGdUZzVxlMeurdTlsjxiVUU=;
        b=H/v5gQunPk3Yi7JYyY8ZiTJNBAlexSQQe/Ggkvf+OBROazyy6U2yI+1g+C48hc+3D9
         ZSyG8oWekuKAIGfZtgzMatikO5AwmgHuWAeHw2dE1R6eiV00yYdEicqlJWZGHqpiuhwU
         mtyQjao2yTNflpo+xBhRPCGQ3hAZEpOk8fqLEC+LYNr8lddtTGJPkUYnhNdX2/Ie8Q06
         auwgXch2+Hh65tm90NeNnfWlyjeKKs9IEvWve/PzqWW72CwtIXGBYVfAnU9hiUJfm23+
         YRYgnFVxl4fL/MrBn01KeTAL/ZDfnfW3+LYy4vLCaNXSU7LXhBcZESjY6hQfKEoUSqTf
         8+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Eh83GUpnDgPrW8AEnAz5rGdUZzVxlMeurdTlsjxiVUU=;
        b=uUA+XPv9bpuqWOikrK8tysvMbKrytn6k5xt2jCtJxBnYtVEafAD8MxqEkSqrG1/kPh
         8d4+eExKZaPaAXDzv+Z2TMjOAS0UIcubKpWcKz8uvsLLM8228/ORBKHHf+PhVDGo7sYZ
         O+Yq6MGbMIOypn4Wbk6rY/JI9uwDFwqEqZ27sDwwwStElULAWit1d3B+QCPeY/i81N9+
         wJx6fnSZxfeobH8gcSr9KjYqf3QZ5rgRMEkE5KOZYm/GvJy2uEdXtBB3/XoXiW+zgq/n
         2c6zVO1DpDEloPkmYwvm2RMsN6AdfhJwfgI1p5ZFuWbT+rvKuPjNGT5wf5njnEzs/waq
         XbAA==
X-Gm-Message-State: AOAM530azh7hGIu7ax15p2xBsSIhCoNECq1wqQ45mITvrcUiqXn5LQpo
        u0vDh2GZPSGnucRQATT9y031sAd7dfo=
X-Google-Smtp-Source: ABdhPJyqR73neyzyBEk6RwllwiVSIxswjBRtRvcGP7mR009sdohgIp29L+5b/ieh9Mhj7JPJxw8j/w==
X-Received: by 2002:a17:902:599a:: with SMTP id p26mr3138328pli.322.1592329028886;
        Tue, 16 Jun 2020 10:37:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id oc6sm3379009pjb.43.2020.06.16.10.37.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 03/10] tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
Date:   Wed, 17 Jun 2020 01:36:28 +0800
Message-Id: <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel6_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel6 and tunnel46.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET6 and proto is IPPROTO_IPIP or IPPROTO_IPV6.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv6/tunnel6.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c69410d..ffee126 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1424,6 +1424,7 @@ struct xfrm_tunnel {
 
 struct xfrm6_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			   u8 type, u8 code, int offset, __be32 info);
 	struct xfrm6_tunnel __rcu *next;
diff --git a/net/ipv6/tunnel6.c b/net/ipv6/tunnel6.c
index 06c02eb..7bf4c27 100644
--- a/net/ipv6/tunnel6.c
+++ b/net/ipv6/tunnel6.c
@@ -155,6 +155,30 @@ static int tunnel6_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+static int tunnel6_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm6_tunnel *head, *handler;
+	int ret;
+
+	head = (proto == IPPROTO_IPV6) ? tunnel6_handlers : tunnel46_handlers;
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
+static const struct xfrm_input_afinfo tunnel6_input_afinfo = {
+	.family		=	AF_INET6,
+	.is_ipip	=	true,
+	.callback	=	tunnel6_rcv_cb,
+};
+
 static int tunnel46_rcv(struct sk_buff *skb)
 {
 	struct xfrm6_tunnel *handler;
@@ -245,11 +269,13 @@ static int __init tunnel6_init(void)
 		inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP);
 		return -EAGAIN;
 	}
+	xfrm_input_register_afinfo(&tunnel6_input_afinfo);
 	return 0;
 }
 
 static void __exit tunnel6_fini(void)
 {
+	xfrm_input_unregister_afinfo(&tunnel6_input_afinfo);
 	if (inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP))
 		pr_err("%s: can't remove protocol\n", __func__);
 	if (inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6))
-- 
2.1.0

