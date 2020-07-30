Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A97232B8D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgG3FsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:17 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56254 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728568AbgG3FsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2AB5E20590;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8TPOJg5XxRrc; Thu, 30 Jul 2020 07:47:58 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AC5882049A;
        Thu, 30 Jul 2020 07:47:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:47:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 792F73184687;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 18/19] ip6_vti: use IS_REACHABLE to avoid some compile errors
Date:   Thu, 30 Jul 2020 07:41:29 +0200
Message-ID: <20200730054130.16923-19-steffen.klassert@secunet.com>
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

Naresh reported some compile errors:

  arm build failed due this error on linux-next 20200713 and  20200713
  net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
  ip6_vti.c:(.text+0x1d20): undefined reference to `xfrm6_tunnel_spi_lookup'

This happened when set CONFIG_IPV6_VTI=y and CONFIG_INET6_TUNNEL=m.
We don't really want ip6_vti to depend inet6_tunnel completely, but
only to disable the tunnel code when inet6_tunnel is not seen.

So instead of adding "select INET6_TUNNEL" for IPV6_VTI, this patch
is only to change to IS_REACHABLE to avoid these compile error.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 08622869ed3f ("ip6_vti: support IP6IP6 tunnel processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/ip6_vti.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 18ec4ab45be7..53f12b40528e 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1218,7 +1218,7 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 static int vti6_rcv_tunnel(struct sk_buff *skb)
 {
 	const xfrm_address_t *saddr;
@@ -1270,7 +1270,7 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	msg = "ipv6 tunnel";
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
@@ -1288,7 +1288,7 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	err = xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
@@ -1312,7 +1312,7 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 #endif
-- 
2.17.1

