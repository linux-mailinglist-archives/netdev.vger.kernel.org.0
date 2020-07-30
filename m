Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85023232B8C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgG3FsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56284 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgG3FsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C861205DB;
        Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4Aw-e9IqZroa; Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A6257205AA;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:47:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 550CB3184668;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
Date:   Thu, 30 Jul 2020 07:41:21 +0200
Message-ID: <20200730054130.16923-11-steffen.klassert@secunet.com>
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

Similar to ip6_vti, IP6IP6 and IP6IP tunnels processing can easily
be done with .cb_handler for xfrm interface.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index c407ecbc5d46..b9ef496d3d7c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -798,6 +798,26 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.priority	=	10,
 };
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
+{
+	const xfrm_address_t *saddr;
+	__be32 spi;
+
+	saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
+	spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
+
+	return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
+}
+
+static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
+	.handler	=	xfrmi6_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi6_err,
+	.priority	=	-1,
+};
+#endif
+
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
 	.handler	=	xfrm4_rcv,
 	.input_handler	=	xfrm_input,
@@ -866,9 +886,23 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipv6_failed;
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
+	if (err < 0)
+		goto xfrm_tunnel_ip6ip_failed;
+#endif
 
 	return 0;
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+xfrm_tunnel_ip6ip_failed:
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
+xfrm_tunnel_ipv6_failed:
+	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
+#endif
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -879,6 +913,10 @@ static int __init xfrmi6_init(void)
 
 static void xfrmi6_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
+#endif
 	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&xfrmi_esp6_protocol, IPPROTO_ESP);
-- 
2.17.1

