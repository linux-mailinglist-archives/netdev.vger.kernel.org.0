Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CDA232B89
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgG3FsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:08 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56300 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgG3FsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2ACB6205CF;
        Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AyffeQh8UxMc; Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78AE22057B;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:47:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 743EC3184685;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 17/19] xfrm: interface: use IS_REACHABLE to avoid some compile errors
Date:   Thu, 30 Jul 2020 07:41:28 +0200
Message-ID: <20200730054130.16923-18-steffen.klassert@secunet.com>
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

kernel test robot reported some compile errors:

  ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_fini':
  net/xfrm/xfrm_interface.c:900: undefined reference to `xfrm4_tunnel_deregister'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:901: undefined reference to `xfrm4_tunnel_deregister'
  ia64-linux-ld: net/xfrm/xfrm_interface.o: in function `xfrmi4_init':
  net/xfrm/xfrm_interface.c:873: undefined reference to `xfrm4_tunnel_register'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:876: undefined reference to `xfrm4_tunnel_register'
  ia64-linux-ld: net/xfrm/xfrm_interface.c:885: undefined reference to `xfrm4_tunnel_deregister'

This happened when set CONFIG_XFRM_INTERFACE=y and CONFIG_INET_TUNNEL=m.
We don't really want xfrm_interface to depend inet_tunnel completely,
but only to disable the tunnel code when inet_tunnel is not seen.

So instead of adding "select INET_TUNNEL" for XFRM_INTERFACE, this patch
is only to change to IS_REACHABLE to avoid these compile error.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 63a52b4b6ea9..4c904d332007 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -812,7 +812,7 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.priority	=	10,
 };
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
 {
 	const xfrm_address_t *saddr;
@@ -863,7 +863,7 @@ static struct xfrm4_protocol xfrmi_ipcomp4_protocol __read_mostly = {
 	.priority	=	10,
 };
 
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 static int xfrmi4_rcv_tunnel(struct sk_buff *skb)
 {
 	return xfrm4_rcv_spi(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr);
@@ -897,7 +897,7 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_protocol_register(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_ipip_failed;
@@ -908,7 +908,7 @@ static int __init xfrmi4_init(void)
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 xfrm_tunnel_ipip6_failed:
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 xfrm_tunnel_ipip_failed:
@@ -924,7 +924,7 @@ static int __init xfrmi4_init(void)
 
 static void xfrmi4_fini(void)
 {
-#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET_XFRM_TUNNEL)
 	xfrm4_tunnel_deregister(&xfrmi_ipip6_handler, AF_INET6);
 	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 #endif
@@ -946,7 +946,7 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipv6_failed;
@@ -957,7 +957,7 @@ static int __init xfrmi6_init(void)
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 xfrm_tunnel_ip6ip_failed:
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 xfrm_tunnel_ipv6_failed:
@@ -973,7 +973,7 @@ static int __init xfrmi6_init(void)
 
 static void xfrmi6_fini(void)
 {
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	xfrm6_tunnel_deregister(&xfrmi_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 #endif
-- 
2.17.1

