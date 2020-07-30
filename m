Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1E232B87
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgG3FsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:04 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56306 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgG3FsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 89C072057B;
        Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gJSndUrWHPw9; Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4759F205AA;
        Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:48:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6AD273184682;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 15/19] ip6_vti: not register vti_ipv6_handler twice
Date:   Thu, 30 Jul 2020 07:41:26 +0200
Message-ID: <20200730054130.16923-16-steffen.klassert@secunet.com>
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

An xfrm6_tunnel object is linked into the list when registering,
so vti_ipv6_handler can not be registered twice, otherwise its
next pointer will be overwritten on the second time.

So this patch is to define a new xfrm6_tunnel object to register
for AF_INET.

Fixes: 2ab110cbb0c0 ("ip6_vti: support IP6IP tunnel processing")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/ip6_vti.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index dfa93bc857d2..18ec4ab45be7 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1236,6 +1236,13 @@ static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
 	.err_handler	=	vti6_err,
 	.priority	=	0,
 };
+
+static struct xfrm6_tunnel vti_ip6ip_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
 #endif
 
 /**
@@ -1268,7 +1275,7 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto vti_tunnel_ipv6_failed;
-	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_register(&vti_ip6ip_handler, AF_INET);
 	if (err < 0)
 		goto vti_tunnel_ip6ip_failed;
 #endif
@@ -1282,7 +1289,7 @@ static int __init vti6_tunnel_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 vti_tunnel_ipv6_failed:
@@ -1306,7 +1313,7 @@ static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 #endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
-- 
2.17.1

