Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62113232B88
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgG3FsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:07 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56314 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgG3FsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0771B205B4;
        Thu, 30 Jul 2020 07:48:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id k3eSxBMJ8qe5; Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B05822049A;
        Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:48:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:59 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6ED8A3184684;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 16/19] xfrm: interface: not xfrmi_ipv6/ipip_handler twice
Date:   Thu, 30 Jul 2020 07:41:27 +0200
Message-ID: <20200730054130.16923-17-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

As we did in the last 2 patches for vti(6), this patch is to define a
new xfrm_tunnel object 'xfrmi_ipip6_handler' to register for AF_INET6,
and a new xfrm6_tunnel object 'xfrmi_ip6ip_handler' to register for
AF_INET.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 96496fdfe3ce..63a52b4b6ea9 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -830,6 +830,13 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
 	.err_handler	=	xfrmi6_err,
 	.priority	=	-1,
 };
+
+static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
+	.handler	=	xfrmi6_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi6_err,
+	.priority	=	-1,
+};
 #endif
 
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
@@ -868,6 +875,13 @@ static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
 	.err_handler	=	xfrmi4_err,
 	.priority	=	-1,
 };
+
+static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly = {
+	.handler	=	xfrmi4_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi4_err,
+	.priority	=	-1,
+};
 #endif
 
 static int __init xfrmi4_init(void)
@@ -887,7 +901,7 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ipip_failed;
-	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET6);
+	err = xfrm4_tunnel_register(&xfrmi_ipip6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipip6_failed;
 #endif
@@ -911,7 +925,7 @@ static int __init xfrmi4_init(void)
 static void xfrmi4_fini(void)
 {
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
-	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&xfrmi_ipip6_handler, AF_INET6);
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 #endif
 	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
@@ -936,7 +950,7 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipv6_failed;
-	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_register(&xfrmi_ip6ip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ip6ip_failed;
 #endif
@@ -960,7 +974,7 @@ static int __init xfrmi6_init(void)
 static void xfrmi6_fini(void)
 {
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&xfrmi_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 #endif
 	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
-- 
2.17.1

