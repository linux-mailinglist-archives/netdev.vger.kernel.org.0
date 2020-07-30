Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7173F232B7D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgG3Fl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56062 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgG3Flt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9F528205AA;
        Thu, 30 Jul 2020 07:41:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Vj9fIHe-miAu; Thu, 30 Jul 2020 07:41:47 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1110C205B2;
        Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 463A23184664; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/19] ip6_vti: support IP6IP6 tunnel processing with .cb_handler
Date:   Thu, 30 Jul 2020 07:41:18 +0200
Message-ID: <20200730054130.16923-8-steffen.klassert@secunet.com>
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

Similar to IPIP tunnel's processing, this patch is to support
IP6IP6 tunnel processing with .cb_handler.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/ip6_vti.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1147f647b9a0..39efe41f7b48 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1218,6 +1218,26 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+static int vti6_rcv_tunnel(struct sk_buff *skb)
+{
+	const xfrm_address_t *saddr;
+	__be32 spi;
+
+	saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
+	spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
+
+	return vti6_input_proto(skb, IPPROTO_IPV6, spi, 0);
+}
+
+static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
+#endif
+
 /**
  * vti6_tunnel_init - register protocol and reserve needed resources
  *
@@ -1243,6 +1263,12 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	msg = "ipv6 tunnel";
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto vti_tunnel_failed;
+#endif
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti6_link_ops);
@@ -1252,6 +1278,10 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+vti_tunnel_failed:
+#endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
@@ -1270,6 +1300,9 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+#endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&vti_esp6_protocol, IPPROTO_ESP);
-- 
2.17.1

