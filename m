Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEE6232B84
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgG3FsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:00 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56266 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgG3FsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7604220582;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TmNv0LBFdWpC; Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0B9462057B;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:47:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3E3C33184662;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/19] ip_vti: support IPIP6 tunnel processing
Date:   Thu, 30 Jul 2020 07:41:17 +0200
Message-ID: <20200730054130.16923-7-steffen.klassert@secunet.com>
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

For IPIP6 tunnel processing, the functions called will be the
same as that for IPIP tunnel's. So reuse it and register it
with family == AF_INET6.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 68177f065117..c0b97b8f6fbd 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -658,7 +658,12 @@ static int __init vti_init(void)
 	msg = "ipip tunnel";
 	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET);
 	if (err < 0)
-		goto xfrm_tunnel_failed;
+		goto xfrm_tunnel_ipip_failed;
+#if IS_ENABLED(CONFIG_IPV6)
+	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipip6_failed;
+#endif
 #endif
 
 	msg = "netlink interface";
@@ -670,8 +675,12 @@ static int __init vti_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+xfrm_tunnel_ipip6_failed:
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
-xfrm_tunnel_failed:
+xfrm_tunnel_ipip_failed:
 #endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
@@ -689,6 +698,9 @@ static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 #endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
-- 
2.17.1

