Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0351C232B75
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgG3Flr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56006 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgG3Flq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5CEA22057B;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MdacNMMicGQO; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D9D4E20573;
        Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3637E3184656; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/19] tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
Date:   Thu, 30 Jul 2020 07:41:15 +0200
Message-ID: <20200730054130.16923-5-steffen.klassert@secunet.com>
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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h |  1 +
 net/ipv6/tunnel6.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c1ec6294d773..83a532dda1bd 100644
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
index 06c02ebe6b9b..00e8d8b1c9a7 100644
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
2.17.1

