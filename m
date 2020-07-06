Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E682156F4
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgGFMCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbgGFMCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85A8C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u5so16882332pfn.7
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=IFT67pLWzi8Kk0RUeSymsU+cDkBPWc0PbfSACkDdVwM=;
        b=cUEyfUDaHeAPyqo1uS99PbdWUiIXAmTPyX5CU8WunGmle2e69yifOY2+nzOPkEmBhf
         zJ0lBN6JX5nqLKQ9mKqUDkaToYG0qZSgHObohcb19OZfb2zAy/Tr+mhAqKpH9NgYkRoT
         PQWhIEXzJqidDbWlA18P09XuYbnCfLWDUg5Jznta4RwrUJi+Ta6F+hWrq1hXjG0Lky40
         rTWoYQ5rBE6BZohMdvCIGCoKnQNEefzOVBU+H2prJs4m+0PxpOw6GY7XUgrTu1xxUM/f
         KkUf0/z4SdCAo8nsot4YlW1KOxfR7xtkUxZig8bjI2+8T8rcg0gZ8uteEmecfOBJwqU9
         TU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=IFT67pLWzi8Kk0RUeSymsU+cDkBPWc0PbfSACkDdVwM=;
        b=f74F70RXeHA7EAWWGIc+n66LOCzJkP0iwBmrdl2xl/tihCJNG9WDptKLiKyNKseQ/p
         RKXXKDD3luzLMwwAyKVaF6mA8DBfKz1k19ivBkXhKOvzrHitD1/K6zqjeAcVkoyC1bWj
         DSm5+p49r6P6C3Ewd37QR1lF2p8v6YV1XdMhA3rxEDEDaVjpDVFaOIuKyB2rGcqoA+nt
         7B7vpKuN5WOBjf65vdTXW+2o7VAQ023zAhH3m3EOYBK02SyYy90rBf+b5w5KCX4tIMey
         jDOo5h9D4H+orTU8p2++SR8fbycmrC2QdE7/xGUkAAT1jgpOUaHPtrN1rp+d3QBKgrG5
         cE2A==
X-Gm-Message-State: AOAM5311fTxiXX2aGvUn/qNpyTY+8FQP82J/RmtrvFvaIze1VGJHl0P2
        AU78X3xgcw/gBQXtbGXKlvsXMtGWZiE=
X-Google-Smtp-Source: ABdhPJw3OFe4Az1Q2E8OnTi1Nx4rVI9UeBqwnuCHEsoLjgn3+yU8Kv5BZ0lRzw6EiUP6zMneePZzFg==
X-Received: by 2002:a62:27c4:: with SMTP id n187mr10260073pfn.208.1594036931920;
        Mon, 06 Jul 2020 05:02:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w9sm10355675pja.39.2020.07.06.05.02.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:11 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 03/10] tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
Date:   Mon,  6 Jul 2020 20:01:31 +0800
Message-Id: <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel6_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel6 and tunnel46.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET6 and proto is IPPROTO_IPIP or IPPROTO_IPV6.

v1->v2:
  - Fix a sparse warning caused by the missing "__rcu", as Jakub
    noticed.
  - Handle the err returned by xfrm_input_register_afinfo() in
    tunnel6_init/fini(), as Sabrina noticed.
v2->v3:
  - Add "#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)" to fix the build error
    when xfrm is disabled, reported by kbuild test robot

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv6/tunnel6.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c1ec629..83a532d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1425,6 +1425,7 @@ struct xfrm_tunnel {
 
 struct xfrm6_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			   u8 type, u8 code, int offset, __be32 info);
 	struct xfrm6_tunnel __rcu *next;
diff --git a/net/ipv6/tunnel6.c b/net/ipv6/tunnel6.c
index 06c02eb..00e8d8b 100644
--- a/net/ipv6/tunnel6.c
+++ b/net/ipv6/tunnel6.c
@@ -155,6 +155,33 @@ static int tunnel6_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+static int tunnel6_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm6_tunnel __rcu *head;
+	struct xfrm6_tunnel *handler;
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
+#endif
+
 static int tunnel46_rcv(struct sk_buff *skb)
 {
 	struct xfrm6_tunnel *handler;
@@ -245,11 +272,25 @@ static int __init tunnel6_init(void)
 		inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP);
 		return -EAGAIN;
 	}
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	if (xfrm_input_register_afinfo(&tunnel6_input_afinfo)) {
+		pr_err("%s: can't add input afinfo\n", __func__);
+		inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6);
+		inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP);
+		if (xfrm6_tunnel_mpls_supported())
+			inet6_del_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS);
+		return -EAGAIN;
+	}
+#endif
 	return 0;
 }
 
 static void __exit tunnel6_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	if (xfrm_input_unregister_afinfo(&tunnel6_input_afinfo))
+		pr_err("%s: can't remove input afinfo\n", __func__);
+#endif
 	if (inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP))
 		pr_err("%s: can't remove protocol\n", __func__);
 	if (inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6))
-- 
2.1.0

