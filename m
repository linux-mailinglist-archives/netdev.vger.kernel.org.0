Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A336C1DB802
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgETPV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:21:57 -0400
Received: from novek.ru ([213.148.174.62]:60460 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgETPV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:21:56 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 882FF50297D;
        Wed, 20 May 2020 18:21:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 882FF50297D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589988112; bh=zFckVKpNfefQcyqhsOEx/xuHwkgKa2mb2+CBnGm8j5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c55oQoDGhWaqXrWQcAQJ1Nn6drJlnDD/BE4ER75vpy2zfGiJHgUid4NiASi7DerEx
         0OjiPb6MiiatcJaTsaPcTKU4DaQnppS6c96aBlJ4eOcqFQsso3c86YdY4o6QXRi4d/
         kB16WOMT/psBeSkot+IDB36Xf40WI5PGgUzIIj00=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next v2 3/5] tunnel6: support for IPPROTO_MPLS
Date:   Wed, 20 May 2020 18:21:37 +0300
Message-Id: <1589988099-13095-4-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
References: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=1.7 required=5.0 tests=UNPARSEABLE_RELAY,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is just preparation for MPLS support in ip6_tunnel

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/tunnel6.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/tunnel6.c b/net/ipv6/tunnel6.c
index 21e7b95..06c02eb 100644
--- a/net/ipv6/tunnel6.c
+++ b/net/ipv6/tunnel6.c
@@ -21,8 +21,14 @@
 
 static struct xfrm6_tunnel __rcu *tunnel6_handlers __read_mostly;
 static struct xfrm6_tunnel __rcu *tunnel46_handlers __read_mostly;
+static struct xfrm6_tunnel __rcu *tunnelmpls6_handlers __read_mostly;
 static DEFINE_MUTEX(tunnel6_mutex);
 
+static inline int xfrm6_tunnel_mpls_supported(void)
+{
+	return IS_ENABLED(CONFIG_MPLS);
+}
+
 int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family)
 {
 	struct xfrm6_tunnel __rcu **pprev;
@@ -32,8 +38,21 @@ int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family)
 
 	mutex_lock(&tunnel6_mutex);
 
-	for (pprev = (family == AF_INET6) ? &tunnel6_handlers : &tunnel46_handlers;
-	     (t = rcu_dereference_protected(*pprev,
+	switch (family) {
+	case AF_INET6:
+		pprev = &tunnel6_handlers;
+		break;
+	case AF_INET:
+		pprev = &tunnel46_handlers;
+		break;
+	case AF_MPLS:
+		pprev = &tunnelmpls6_handlers;
+		break;
+	default:
+		goto err;
+	}
+
+	for (; (t = rcu_dereference_protected(*pprev,
 			lockdep_is_held(&tunnel6_mutex))) != NULL;
 	     pprev = &t->next) {
 		if (t->priority > priority)
@@ -62,8 +81,21 @@ int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family)
 
 	mutex_lock(&tunnel6_mutex);
 
-	for (pprev = (family == AF_INET6) ? &tunnel6_handlers : &tunnel46_handlers;
-	     (t = rcu_dereference_protected(*pprev,
+	switch (family) {
+	case AF_INET6:
+		pprev = &tunnel6_handlers;
+		break;
+	case AF_INET:
+		pprev = &tunnel46_handlers;
+		break;
+	case AF_MPLS:
+		pprev = &tunnelmpls6_handlers;
+		break;
+	default:
+		goto err;
+	}
+
+	for (; (t = rcu_dereference_protected(*pprev,
 			lockdep_is_held(&tunnel6_mutex))) != NULL;
 	     pprev = &t->next) {
 		if (t == handler) {
@@ -73,6 +105,7 @@ int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family)
 		}
 	}
 
+err:
 	mutex_unlock(&tunnel6_mutex);
 
 	synchronize_net();
@@ -86,6 +119,24 @@ int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family)
 	     handler != NULL;				\
 	     handler = rcu_dereference(handler->next))	\
 
+static int tunnelmpls6_rcv(struct sk_buff *skb)
+{
+	struct xfrm6_tunnel *handler;
+
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		goto drop;
+
+	for_each_tunnel_rcu(tunnelmpls6_handlers, handler)
+		if (!handler->handler(skb))
+			return 0;
+
+	icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
+
+drop:
+	kfree_skb(skb);
+	return 0;
+}
+
 static int tunnel6_rcv(struct sk_buff *skb)
 {
 	struct xfrm6_tunnel *handler;
@@ -146,6 +197,18 @@ static int tunnel46_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return -ENOENT;
 }
 
+static int tunnelmpls6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+			   u8 type, u8 code, int offset, __be32 info)
+{
+	struct xfrm6_tunnel *handler;
+
+	for_each_tunnel_rcu(tunnelmpls6_handlers, handler)
+		if (!handler->err_handler(skb, opt, type, code, offset, info))
+			return 0;
+
+	return -ENOENT;
+}
+
 static const struct inet6_protocol tunnel6_protocol = {
 	.handler	= tunnel6_rcv,
 	.err_handler	= tunnel6_err,
@@ -158,6 +221,12 @@ static int tunnel46_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	.flags          = INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
 };
 
+static const struct inet6_protocol tunnelmpls6_protocol = {
+	.handler	= tunnelmpls6_rcv,
+	.err_handler	= tunnelmpls6_err,
+	.flags          = INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
+};
+
 static int __init tunnel6_init(void)
 {
 	if (inet6_add_protocol(&tunnel6_protocol, IPPROTO_IPV6)) {
@@ -169,6 +238,13 @@ static int __init tunnel6_init(void)
 		inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6);
 		return -EAGAIN;
 	}
+	if (xfrm6_tunnel_mpls_supported() &&
+	    inet6_add_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS)) {
+		pr_err("%s: can't add protocol\n", __func__);
+		inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6);
+		inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP);
+		return -EAGAIN;
+	}
 	return 0;
 }
 
@@ -178,6 +254,9 @@ static void __exit tunnel6_fini(void)
 		pr_err("%s: can't remove protocol\n", __func__);
 	if (inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6))
 		pr_err("%s: can't remove protocol\n", __func__);
+	if (xfrm6_tunnel_mpls_supported() &&
+	    inet6_del_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS))
+		pr_err("%s: can't remove protocol\n", __func__);
 }
 
 module_init(tunnel6_init);
-- 
1.8.3.1

