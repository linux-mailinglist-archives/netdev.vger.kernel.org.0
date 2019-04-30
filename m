Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61938F087
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfD3Ghi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:38 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48798 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfD3Ghf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 731142026D;
        Tue, 30 Apr 2019 08:37:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3xJR2eG6k-md; Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6D9812026B;
        Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0F66231805D7;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/18] xfrm: place af number into xfrm_mode struct
Date:   Tue, 30 Apr 2019 08:37:12 +0200
Message-ID: <20190430063727.10908-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: EE6FBCC4-9747-4D20-BBCA-D233C205F4B4
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This will be useful to know if we're supposed to decode ipv4 or ipv6.

While at it, make the unregister function return void, all module_exit
functions did just BUG(); there is never a point in doing error checks
if there is no way to handle such error.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h              |  9 +++++----
 net/ipv4/xfrm4_mode_beet.c      |  8 +++-----
 net/ipv4/xfrm4_mode_transport.c |  8 +++-----
 net/ipv4/xfrm4_mode_tunnel.c    |  8 +++-----
 net/ipv6/xfrm6_mode_beet.c      |  8 +++-----
 net/ipv6/xfrm6_mode_ro.c        |  8 +++-----
 net/ipv6/xfrm6_mode_transport.c |  8 +++-----
 net/ipv6/xfrm6_mode_tunnel.c    |  8 +++-----
 net/xfrm/xfrm_state.c           | 19 ++++++-------------
 9 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 85386becbaea..9a155063c25f 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -482,8 +482,9 @@ struct xfrm_mode {
 
 	struct xfrm_state_afinfo *afinfo;
 	struct module *owner;
-	unsigned int encap;
-	int flags;
+	u8 encap;
+	u8 family;
+	u8 flags;
 };
 
 /* Flags for xfrm_mode. */
@@ -491,8 +492,8 @@ enum {
 	XFRM_MODE_FLAG_TUNNEL = 1,
 };
 
-int xfrm_register_mode(struct xfrm_mode *mode, int family);
-int xfrm_unregister_mode(struct xfrm_mode *mode, int family);
+int xfrm_register_mode(struct xfrm_mode *mode);
+void xfrm_unregister_mode(struct xfrm_mode *mode);
 
 static inline int xfrm_af2proto(unsigned int family)
 {
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index 856d2dfdb44b..a2e3b52ae46c 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -134,19 +134,17 @@ static struct xfrm_mode xfrm4_beet_mode = {
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
+	.family = AF_INET,
 };
 
 static int __init xfrm4_beet_init(void)
 {
-	return xfrm_register_mode(&xfrm4_beet_mode, AF_INET);
+	return xfrm_register_mode(&xfrm4_beet_mode);
 }
 
 static void __exit xfrm4_beet_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm4_beet_mode, AF_INET);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm4_beet_mode);
 }
 
 module_init(xfrm4_beet_init);
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
index 1ad2c2c4e250..7c5443f797cf 100644
--- a/net/ipv4/xfrm4_mode_transport.c
+++ b/net/ipv4/xfrm4_mode_transport.c
@@ -93,19 +93,17 @@ static struct xfrm_mode xfrm4_transport_mode = {
 	.xmit = xfrm4_transport_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
+	.family = AF_INET,
 };
 
 static int __init xfrm4_transport_init(void)
 {
-	return xfrm_register_mode(&xfrm4_transport_mode, AF_INET);
+	return xfrm_register_mode(&xfrm4_transport_mode);
 }
 
 static void __exit xfrm4_transport_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm4_transport_mode, AF_INET);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm4_transport_mode);
 }
 
 module_init(xfrm4_transport_init);
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 2a9764bd1719..cfc6b6d39755 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -131,19 +131,17 @@ static struct xfrm_mode xfrm4_tunnel_mode = {
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
+	.family = AF_INET,
 };
 
 static int __init xfrm4_mode_tunnel_init(void)
 {
-	return xfrm_register_mode(&xfrm4_tunnel_mode, AF_INET);
+	return xfrm_register_mode(&xfrm4_tunnel_mode);
 }
 
 static void __exit xfrm4_mode_tunnel_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm4_tunnel_mode, AF_INET);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm4_tunnel_mode);
 }
 
 module_init(xfrm4_mode_tunnel_init);
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index 57fd314ec2b8..0d440e3a13f8 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -110,19 +110,17 @@ static struct xfrm_mode xfrm6_beet_mode = {
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
+	.family = AF_INET6,
 };
 
 static int __init xfrm6_beet_init(void)
 {
-	return xfrm_register_mode(&xfrm6_beet_mode, AF_INET6);
+	return xfrm_register_mode(&xfrm6_beet_mode);
 }
 
 static void __exit xfrm6_beet_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm6_beet_mode, AF_INET6);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm6_beet_mode);
 }
 
 module_init(xfrm6_beet_init);
diff --git a/net/ipv6/xfrm6_mode_ro.c b/net/ipv6/xfrm6_mode_ro.c
index da28e4407b8f..0408547d01ab 100644
--- a/net/ipv6/xfrm6_mode_ro.c
+++ b/net/ipv6/xfrm6_mode_ro.c
@@ -64,19 +64,17 @@ static struct xfrm_mode xfrm6_ro_mode = {
 	.output = xfrm6_ro_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_ROUTEOPTIMIZATION,
+	.family = AF_INET6,
 };
 
 static int __init xfrm6_ro_init(void)
 {
-	return xfrm_register_mode(&xfrm6_ro_mode, AF_INET6);
+	return xfrm_register_mode(&xfrm6_ro_mode);
 }
 
 static void __exit xfrm6_ro_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm6_ro_mode, AF_INET6);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm6_ro_mode);
 }
 
 module_init(xfrm6_ro_init);
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
index 3c29da5defe6..66ae79218bdf 100644
--- a/net/ipv6/xfrm6_mode_transport.c
+++ b/net/ipv6/xfrm6_mode_transport.c
@@ -100,19 +100,17 @@ static struct xfrm_mode xfrm6_transport_mode = {
 	.xmit = xfrm6_transport_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
+	.family = AF_INET6,
 };
 
 static int __init xfrm6_transport_init(void)
 {
-	return xfrm_register_mode(&xfrm6_transport_mode, AF_INET6);
+	return xfrm_register_mode(&xfrm6_transport_mode);
 }
 
 static void __exit xfrm6_transport_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm6_transport_mode, AF_INET6);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm6_transport_mode);
 }
 
 module_init(xfrm6_transport_init);
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index de1b0b8c53b0..6cf12e961ea5 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -130,19 +130,17 @@ static struct xfrm_mode xfrm6_tunnel_mode = {
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
+	.family = AF_INET6,
 };
 
 static int __init xfrm6_mode_tunnel_init(void)
 {
-	return xfrm_register_mode(&xfrm6_tunnel_mode, AF_INET6);
+	return xfrm_register_mode(&xfrm6_tunnel_mode);
 }
 
 static void __exit xfrm6_mode_tunnel_exit(void)
 {
-	int err;
-
-	err = xfrm_unregister_mode(&xfrm6_tunnel_mode, AF_INET6);
-	BUG_ON(err);
+	xfrm_unregister_mode(&xfrm6_tunnel_mode);
 }
 
 module_init(xfrm6_mode_tunnel_init);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 1bb971f46fc6..c32394b59776 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -331,7 +331,7 @@ static void xfrm_put_type_offload(const struct xfrm_type_offload *type)
 }
 
 static DEFINE_SPINLOCK(xfrm_mode_lock);
-int xfrm_register_mode(struct xfrm_mode *mode, int family)
+int xfrm_register_mode(struct xfrm_mode *mode)
 {
 	struct xfrm_state_afinfo *afinfo;
 	struct xfrm_mode **modemap;
@@ -340,7 +340,7 @@ int xfrm_register_mode(struct xfrm_mode *mode, int family)
 	if (unlikely(mode->encap >= XFRM_MODE_MAX))
 		return -EINVAL;
 
-	afinfo = xfrm_state_get_afinfo(family);
+	afinfo = xfrm_state_get_afinfo(mode->family);
 	if (unlikely(afinfo == NULL))
 		return -EAFNOSUPPORT;
 
@@ -365,31 +365,24 @@ int xfrm_register_mode(struct xfrm_mode *mode, int family)
 }
 EXPORT_SYMBOL(xfrm_register_mode);
 
-int xfrm_unregister_mode(struct xfrm_mode *mode, int family)
+void xfrm_unregister_mode(struct xfrm_mode *mode)
 {
 	struct xfrm_state_afinfo *afinfo;
 	struct xfrm_mode **modemap;
-	int err;
-
-	if (unlikely(mode->encap >= XFRM_MODE_MAX))
-		return -EINVAL;
 
-	afinfo = xfrm_state_get_afinfo(family);
-	if (unlikely(afinfo == NULL))
-		return -EAFNOSUPPORT;
+	afinfo = xfrm_state_get_afinfo(mode->family);
+	if (WARN_ON_ONCE(!afinfo))
+		return;
 
-	err = -ENOENT;
 	modemap = afinfo->mode_map;
 	spin_lock_bh(&xfrm_mode_lock);
 	if (likely(modemap[mode->encap] == mode)) {
 		modemap[mode->encap] = NULL;
 		module_put(mode->afinfo->owner);
-		err = 0;
 	}
 
 	spin_unlock_bh(&xfrm_mode_lock);
 	rcu_read_unlock();
-	return err;
 }
 EXPORT_SYMBOL(xfrm_unregister_mode);
 
-- 
2.17.1

