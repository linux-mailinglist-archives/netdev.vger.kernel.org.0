Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8C232B7A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgG3Fls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56014 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgG3Flr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BAFA4205E3;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RFlnaubGDi6S; Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0B05720590;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3176E3184653; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/19] tunnel4: add cb_handler to struct xfrm_tunnel
Date:   Thu, 30 Jul 2020 07:41:14 +0200
Message-ID: <20200730054130.16923-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This patch is to register a callback function tunnel4_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.

v1->v2:
  - Fix a sparse warning caused by the missing "__rcu", as Jakub
    noticed.
  - Handle the err returned by xfrm_input_register_afinfo() in
    tunnel4_init/fini(), as Sabrina noticed.
v2->v3:
  - Add "#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)" to fix the build error
    when xfrm is disabled, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h |  1 +
 net/ipv4/tunnel4.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4666bc9e59ab..c1ec6294d773 100644
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
index c4b2ccbeba04..e44aaf41a138 100644
--- a/net/ipv4/tunnel4.c
+++ b/net/ipv4/tunnel4.c
@@ -110,6 +110,33 @@ static int tunnel4_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
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
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int tunnel64_rcv(struct sk_buff *skb)
 {
@@ -230,6 +257,18 @@ static int __init tunnel4_init(void)
 #endif
 		goto err;
 	}
+#endif
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	if (xfrm_input_register_afinfo(&tunnel4_input_afinfo)) {
+		inet_del_protocol(&tunnel4_protocol, IPPROTO_IPIP);
+#if IS_ENABLED(CONFIG_IPV6)
+		inet_del_protocol(&tunnel64_protocol, IPPROTO_IPV6);
+#endif
+#if IS_ENABLED(CONFIG_MPLS)
+		inet_del_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS);
+#endif
+		goto err;
+	}
 #endif
 	return 0;
 
@@ -240,6 +279,10 @@ static int __init tunnel4_init(void)
 
 static void __exit tunnel4_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	if (xfrm_input_unregister_afinfo(&tunnel4_input_afinfo))
+		pr_err("tunnel4 close: can't remove input afinfo\n");
+#endif
 #if IS_ENABLED(CONFIG_MPLS)
 	if (inet_del_protocol(&tunnelmpls4_protocol, IPPROTO_MPLS))
 		pr_err("tunnelmpls4 close: can't remove protocol\n");
-- 
2.17.1

