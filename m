Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3459232B78
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgG3Flx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:53 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56064 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgG3Flt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 34B71205B2;
        Thu, 30 Jul 2020 07:41:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Eufh7whRWUzM; Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 98E31205CF;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3A0F73184659; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 05/19] ip_vti: support IPIP tunnel processing with .cb_handler
Date:   Thu, 30 Jul 2020 07:41:16 +0200
Message-ID: <20200730054130.16923-6-steffen.klassert@secunet.com>
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

With tunnel4_input_afinfo added, IPIP tunnel processing in
ip_vti can be easily done with .cb_handler. So replace the
processing by calling ip_tunnel_rcv() with it.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 51 +++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1d9c8cff5ac3..68177f065117 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -91,32 +91,6 @@ static int vti_rcv_proto(struct sk_buff *skb)
 	return vti_rcv(skb, 0, false);
 }
 
-static int vti_rcv_tunnel(struct sk_buff *skb)
-{
-	struct ip_tunnel_net *itn = net_generic(dev_net(skb->dev), vti_net_id);
-	const struct iphdr *iph = ip_hdr(skb);
-	struct ip_tunnel *tunnel;
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-				  iph->saddr, iph->daddr, 0);
-	if (tunnel) {
-		struct tnl_ptk_info tpi = {
-			.proto = htons(ETH_P_IP),
-		};
-
-		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto drop;
-		if (iptunnel_pull_header(skb, 0, tpi.proto, false))
-			goto drop;
-		return ip_tunnel_rcv(tunnel, skb, &tpi, NULL, false);
-	}
-
-	return -EINVAL;
-drop:
-	kfree_skb(skb);
-	return 0;
-}
-
 static int vti_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
@@ -495,11 +469,22 @@ static struct xfrm4_protocol vti_ipcomp4_protocol __read_mostly = {
 	.priority	=	100,
 };
 
-static struct xfrm_tunnel ipip_handler __read_mostly = {
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+static int vti_rcv_tunnel(struct sk_buff *skb)
+{
+	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
+	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+
+	return vti_input(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr, 0, false);
+}
+
+static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
 	.handler	=	vti_rcv_tunnel,
+	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };
+#endif
 
 static int __net_init vti_init_net(struct net *net)
 {
@@ -669,10 +654,12 @@ static int __init vti_init(void)
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
 	msg = "ipip tunnel";
-	err = xfrm4_tunnel_register(&ipip_handler, AF_INET);
+	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_failed;
+#endif
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti_link_ops);
@@ -682,8 +669,10 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 xfrm_tunnel_failed:
+#endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
@@ -699,7 +688,9 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
+#endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.17.1

