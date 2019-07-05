Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3181C6028F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfGEIqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37492 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfGEIqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 495D220256;
        Fri,  5 Jul 2019 10:46:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6Jd5wYFOgv1l; Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 07C9020257;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 56D8B31808DE;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/9] xfrm: remove type and offload_type map from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:07 +0200
Message-ID: <20190705084610.3646-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only a handful of xfrm_types exist, no need to have 512 pointers for them.

Reduces size of afinfo struct from 4k to 120 bytes on 64bit platforms.

Also, the unregister function doesn't need to return an error, no single
caller does anything useful with it.

Just place a WARN_ON() where needed instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  16 +++-
 net/ipv4/ah4.c          |   3 +-
 net/ipv4/esp4.c         |   3 +-
 net/ipv4/esp4_offload.c |   4 +-
 net/ipv4/ipcomp.c       |   3 +-
 net/ipv4/xfrm4_tunnel.c |   3 +-
 net/ipv6/ah6.c          |   4 +-
 net/ipv6/esp6.c         |   3 +-
 net/ipv6/esp6_offload.c |   4 +-
 net/ipv6/ipcomp6.c      |   3 +-
 net/ipv6/mip6.c         |   6 +-
 net/xfrm/xfrm_state.c   | 179 ++++++++++++++++++++++++++++------------
 12 files changed, 150 insertions(+), 81 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 812994ad49ac..56b31676e330 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -348,8 +348,16 @@ int __xfrm_state_delete(struct xfrm_state *x);
 struct xfrm_state_afinfo {
 	u8				family;
 	u8				proto;
-	const struct xfrm_type		*type_map[IPPROTO_MAX];
-	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
+
+	const struct xfrm_type_offload *type_offload_esp;
+
+	const struct xfrm_type		*type_esp;
+	const struct xfrm_type		*type_ipip;
+	const struct xfrm_type		*type_ipip6;
+	const struct xfrm_type		*type_comp;
+	const struct xfrm_type		*type_ah;
+	const struct xfrm_type		*type_routing;
+	const struct xfrm_type		*type_dstopts;
 
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
@@ -401,7 +409,7 @@ struct xfrm_type {
 };
 
 int xfrm_register_type(const struct xfrm_type *type, unsigned short family);
-int xfrm_unregister_type(const struct xfrm_type *type, unsigned short family);
+void xfrm_unregister_type(const struct xfrm_type *type, unsigned short family);
 
 struct xfrm_type_offload {
 	char		*description;
@@ -413,7 +421,7 @@ struct xfrm_type_offload {
 };
 
 int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned short family);
-int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
+void xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
 static inline int xfrm_af2proto(unsigned int family)
 {
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 9c3afd550612..974179b3b314 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -590,8 +590,7 @@ static void __exit ah4_fini(void)
 {
 	if (xfrm4_protocol_deregister(&ah4_protocol, IPPROTO_AH) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
-	if (xfrm_unregister_type(&ah_type, AF_INET) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&ah_type, AF_INET);
 }
 
 module_init(ah4_init);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b9ae95576084..c06562aded11 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1066,8 +1066,7 @@ static void __exit esp4_fini(void)
 {
 	if (xfrm4_protocol_deregister(&esp4_protocol, IPPROTO_ESP) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
-	if (xfrm_unregister_type(&esp_type, AF_INET) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&esp_type, AF_INET);
 }
 
 module_init(esp4_init);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8edcfa66d1e5..6e5288aef71e 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -315,9 +315,7 @@ static int __init esp4_offload_init(void)
 
 static void __exit esp4_offload_exit(void)
 {
-	if (xfrm_unregister_type_offload(&esp_type_offload, AF_INET) < 0)
-		pr_info("%s: can't remove xfrm type offload\n", __func__);
-
+	xfrm_unregister_type_offload(&esp_type_offload, AF_INET);
 	inet_del_offload(&esp4_offload, IPPROTO_ESP);
 }
 
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 9119d012ba46..ee03f0a55152 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -190,8 +190,7 @@ static void __exit ipcomp4_fini(void)
 {
 	if (xfrm4_protocol_deregister(&ipcomp4_protocol, IPPROTO_COMP) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
-	if (xfrm_unregister_type(&ipcomp_type, AF_INET) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&ipcomp_type, AF_INET);
 }
 
 module_init(ipcomp4_init);
diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index 5d00e54cd319..dc19aff7c2e0 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -108,8 +108,7 @@ static void __exit ipip_fini(void)
 	if (xfrm4_tunnel_deregister(&xfrm_tunnel_handler, AF_INET))
 		pr_info("%s: can't remove xfrm handler for AF_INET\n",
 			__func__);
-	if (xfrm_unregister_type(&ipip_type, AF_INET) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&ipip_type, AF_INET);
 }
 
 module_init(ipip_init);
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 68b9e92e469e..25e1172fd1c3 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -793,9 +793,7 @@ static void __exit ah6_fini(void)
 	if (xfrm6_protocol_deregister(&ah6_protocol, IPPROTO_AH) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
 
-	if (xfrm_unregister_type(&ah6_type, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
-
+	xfrm_unregister_type(&ah6_type, AF_INET6);
 }
 
 module_init(ah6_init);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ae6a739c5f52..b6c6b3e08836 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -951,8 +951,7 @@ static void __exit esp6_fini(void)
 {
 	if (xfrm6_protocol_deregister(&esp6_protocol, IPPROTO_ESP) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
-	if (xfrm_unregister_type(&esp6_type, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&esp6_type, AF_INET6);
 }
 
 module_init(esp6_init);
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index d453cf417b03..f2c8f7103332 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -339,9 +339,7 @@ static int __init esp6_offload_init(void)
 
 static void __exit esp6_offload_exit(void)
 {
-	if (xfrm_unregister_type_offload(&esp6_type_offload, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type offload\n", __func__);
-
+	xfrm_unregister_type_offload(&esp6_type_offload, AF_INET6);
 	inet6_del_offload(&esp6_offload, IPPROTO_ESP);
 }
 
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 51fd33294c7c..3752bd3e92ce 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -206,8 +206,7 @@ static void __exit ipcomp6_fini(void)
 {
 	if (xfrm6_protocol_deregister(&ipcomp6_protocol, IPPROTO_COMP) < 0)
 		pr_info("%s: can't remove protocol\n", __func__);
-	if (xfrm_unregister_type(&ipcomp6_type, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type\n", __func__);
+	xfrm_unregister_type(&ipcomp6_type, AF_INET6);
 }
 
 module_init(ipcomp6_init);
diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 91801432878c..878fcec14949 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -499,10 +499,8 @@ static void __exit mip6_fini(void)
 {
 	if (rawv6_mh_filter_unregister(mip6_mh_filter) < 0)
 		pr_info("%s: can't remove rawv6 mh filter\n", __func__);
-	if (xfrm_unregister_type(&mip6_rthdr_type, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type(rthdr)\n", __func__);
-	if (xfrm_unregister_type(&mip6_destopt_type, AF_INET6) < 0)
-		pr_info("%s: can't remove xfrm type(destopt)\n", __func__);
+	xfrm_unregister_type(&mip6_rthdr_type, AF_INET6);
+	xfrm_unregister_type(&mip6_destopt_type, AF_INET6);
 }
 
 module_init(mip6_init);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3f0950db060a..fd51737f9f17 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -177,63 +177,132 @@ int km_query(struct xfrm_state *x, struct xfrm_tmpl *t, struct xfrm_policy *pol)
 static bool km_is_alive(const struct km_event *c);
 void km_state_expired(struct xfrm_state *x, int hard, u32 portid);
 
-static DEFINE_SPINLOCK(xfrm_type_lock);
 int xfrm_register_type(const struct xfrm_type *type, unsigned short family)
 {
 	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	const struct xfrm_type **typemap;
 	int err = 0;
 
-	if (unlikely(afinfo == NULL))
+	if (!afinfo)
 		return -EAFNOSUPPORT;
-	typemap = afinfo->type_map;
-	spin_lock_bh(&xfrm_type_lock);
 
-	if (likely(typemap[type->proto] == NULL))
-		typemap[type->proto] = type;
-	else
-		err = -EEXIST;
-	spin_unlock_bh(&xfrm_type_lock);
+#define X(afi, T, name) do {			\
+		WARN_ON((afi)->type_ ## name);	\
+		(afi)->type_ ## name = (T);	\
+	} while (0)
+
+	switch (type->proto) {
+	case IPPROTO_COMP:
+		X(afinfo, type, comp);
+		break;
+	case IPPROTO_AH:
+		X(afinfo, type, ah);
+		break;
+	case IPPROTO_ESP:
+		X(afinfo, type, esp);
+		break;
+	case IPPROTO_IPIP:
+		X(afinfo, type, ipip);
+		break;
+	case IPPROTO_DSTOPTS:
+		X(afinfo, type, dstopts);
+		break;
+	case IPPROTO_ROUTING:
+		X(afinfo, type, routing);
+		break;
+	case IPPROTO_IPV6:
+		X(afinfo, type, ipip6);
+		break;
+	default:
+		WARN_ON(1);
+		err = -EPROTONOSUPPORT;
+		break;
+	}
+#undef X
 	rcu_read_unlock();
 	return err;
 }
 EXPORT_SYMBOL(xfrm_register_type);
 
-int xfrm_unregister_type(const struct xfrm_type *type, unsigned short family)
+void xfrm_unregister_type(const struct xfrm_type *type, unsigned short family)
 {
 	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	const struct xfrm_type **typemap;
-	int err = 0;
 
 	if (unlikely(afinfo == NULL))
-		return -EAFNOSUPPORT;
-	typemap = afinfo->type_map;
-	spin_lock_bh(&xfrm_type_lock);
+		return;
 
-	if (unlikely(typemap[type->proto] != type))
-		err = -ENOENT;
-	else
-		typemap[type->proto] = NULL;
-	spin_unlock_bh(&xfrm_type_lock);
+#define X(afi, T, name) do {				\
+		WARN_ON((afi)->type_ ## name != (T));	\
+		(afi)->type_ ## name = NULL;		\
+	} while (0)
+
+	switch (type->proto) {
+	case IPPROTO_COMP:
+		X(afinfo, type, comp);
+		break;
+	case IPPROTO_AH:
+		X(afinfo, type, ah);
+		break;
+	case IPPROTO_ESP:
+		X(afinfo, type, esp);
+		break;
+	case IPPROTO_IPIP:
+		X(afinfo, type, ipip);
+		break;
+	case IPPROTO_DSTOPTS:
+		X(afinfo, type, dstopts);
+		break;
+	case IPPROTO_ROUTING:
+		X(afinfo, type, routing);
+		break;
+	case IPPROTO_IPV6:
+		X(afinfo, type, ipip6);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+#undef X
 	rcu_read_unlock();
-	return err;
 }
 EXPORT_SYMBOL(xfrm_unregister_type);
 
 static const struct xfrm_type *xfrm_get_type(u8 proto, unsigned short family)
 {
+	const struct xfrm_type *type = NULL;
 	struct xfrm_state_afinfo *afinfo;
-	const struct xfrm_type **typemap;
-	const struct xfrm_type *type;
 	int modload_attempted = 0;
 
 retry:
 	afinfo = xfrm_state_get_afinfo(family);
 	if (unlikely(afinfo == NULL))
 		return NULL;
-	typemap = afinfo->type_map;
 
-	type = READ_ONCE(typemap[proto]);
+	switch (proto) {
+	case IPPROTO_COMP:
+		type = afinfo->type_comp;
+		break;
+	case IPPROTO_AH:
+		type = afinfo->type_ah;
+		break;
+	case IPPROTO_ESP:
+		type = afinfo->type_esp;
+		break;
+	case IPPROTO_IPIP:
+		type = afinfo->type_ipip;
+		break;
+	case IPPROTO_DSTOPTS:
+		type = afinfo->type_dstopts;
+		break;
+	case IPPROTO_ROUTING:
+		type = afinfo->type_routing;
+		break;
+	case IPPROTO_IPV6:
+		type = afinfo->type_ipip6;
+		break;
+	default:
+		break;
+	}
+
 	if (unlikely(type && !try_module_get(type->owner)))
 		type = NULL;
 
@@ -253,65 +322,71 @@ static void xfrm_put_type(const struct xfrm_type *type)
 	module_put(type->owner);
 }
 
-static DEFINE_SPINLOCK(xfrm_type_offload_lock);
 int xfrm_register_type_offload(const struct xfrm_type_offload *type,
 			       unsigned short family)
 {
 	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	const struct xfrm_type_offload **typemap;
 	int err = 0;
 
 	if (unlikely(afinfo == NULL))
 		return -EAFNOSUPPORT;
-	typemap = afinfo->type_offload_map;
-	spin_lock_bh(&xfrm_type_offload_lock);
 
-	if (likely(typemap[type->proto] == NULL))
-		typemap[type->proto] = type;
-	else
-		err = -EEXIST;
-	spin_unlock_bh(&xfrm_type_offload_lock);
+	switch (type->proto) {
+	case IPPROTO_ESP:
+		WARN_ON(afinfo->type_offload_esp);
+		afinfo->type_offload_esp = type;
+		break;
+	default:
+		WARN_ON(1);
+		err = -EPROTONOSUPPORT;
+		break;
+	}
+
 	rcu_read_unlock();
 	return err;
 }
 EXPORT_SYMBOL(xfrm_register_type_offload);
 
-int xfrm_unregister_type_offload(const struct xfrm_type_offload *type,
-				 unsigned short family)
+void xfrm_unregister_type_offload(const struct xfrm_type_offload *type,
+				  unsigned short family)
 {
 	struct xfrm_state_afinfo *afinfo = xfrm_state_get_afinfo(family);
-	const struct xfrm_type_offload **typemap;
-	int err = 0;
 
 	if (unlikely(afinfo == NULL))
-		return -EAFNOSUPPORT;
-	typemap = afinfo->type_offload_map;
-	spin_lock_bh(&xfrm_type_offload_lock);
+		return;
 
-	if (unlikely(typemap[type->proto] != type))
-		err = -ENOENT;
-	else
-		typemap[type->proto] = NULL;
-	spin_unlock_bh(&xfrm_type_offload_lock);
+	switch (type->proto) {
+	case IPPROTO_ESP:
+		WARN_ON(afinfo->type_offload_esp != type);
+		afinfo->type_offload_esp = NULL;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
 	rcu_read_unlock();
-	return err;
 }
 EXPORT_SYMBOL(xfrm_unregister_type_offload);
 
 static const struct xfrm_type_offload *
 xfrm_get_type_offload(u8 proto, unsigned short family, bool try_load)
 {
+	const struct xfrm_type_offload *type = NULL;
 	struct xfrm_state_afinfo *afinfo;
-	const struct xfrm_type_offload **typemap;
-	const struct xfrm_type_offload *type;
 
 retry:
 	afinfo = xfrm_state_get_afinfo(family);
 	if (unlikely(afinfo == NULL))
 		return NULL;
-	typemap = afinfo->type_offload_map;
 
-	type = typemap[proto];
+	switch (proto) {
+	case IPPROTO_ESP:
+		type = afinfo->type_offload_esp;
+		break;
+	default:
+		break;
+	}
+
 	if ((type && !try_module_get(type->owner)))
 		type = NULL;
 
-- 
2.17.1

