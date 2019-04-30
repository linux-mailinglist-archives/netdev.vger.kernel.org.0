Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67639F085
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfD3Ghg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48790 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfD3Ghe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 59DCB2026C;
        Tue, 30 Apr 2019 08:37:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GTRBCA-KJRXE; Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7050B2026D;
        Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0B90E31805C7;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/18] vti4: eliminated some duplicate code.
Date:   Tue, 30 Apr 2019 08:37:11 +0200
Message-ID: <20190430063727.10908-3-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: CD8AF8CD-4386-4864-955F-F9C82401FA52
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The ipip tunnel introduced in commit dd9ee3444014 ("vti4: Fix a ipip
packet processing bug in 'IPCOMP' virtual tunnel") largely duplicated
the existing vti_input and vti_recv functions.  Refactored to
deduplicate the common code.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 60 +++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 38 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 68a21bf75dd0..a8474799fb79 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -50,7 +50,7 @@ static unsigned int vti_net_id __read_mostly;
 static int vti_tunnel_init(struct net_device *dev);
 
 static int vti_input(struct sk_buff *skb, int nexthdr, __be32 spi,
-		     int encap_type)
+		     int encap_type, bool update_skb_dev)
 {
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -65,6 +65,9 @@ static int vti_input(struct sk_buff *skb, int nexthdr, __be32 spi,
 
 		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = tunnel;
 
+		if (update_skb_dev)
+			skb->dev = tunnel->dev;
+
 		return xfrm_input(skb, nexthdr, spi, encap_type);
 	}
 
@@ -74,47 +77,28 @@ static int vti_input(struct sk_buff *skb, int nexthdr, __be32 spi,
 	return 0;
 }
 
-static int vti_input_ipip(struct sk_buff *skb, int nexthdr, __be32 spi,
-		     int encap_type)
+static int vti_input_proto(struct sk_buff *skb, int nexthdr, __be32 spi,
+			   int encap_type)
 {
-	struct ip_tunnel *tunnel;
-	const struct iphdr *iph = ip_hdr(skb);
-	struct net *net = dev_net(skb->dev);
-	struct ip_tunnel_net *itn = net_generic(net, vti_net_id);
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-				  iph->saddr, iph->daddr, 0);
-	if (tunnel) {
-		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto drop;
-
-		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = tunnel;
-
-		skb->dev = tunnel->dev;
-
-		return xfrm_input(skb, nexthdr, spi, encap_type);
-	}
-
-	return -EINVAL;
-drop:
-	kfree_skb(skb);
-	return 0;
+	return vti_input(skb, nexthdr, spi, encap_type, false);
 }
 
-static int vti_rcv(struct sk_buff *skb)
+static int vti_rcv(struct sk_buff *skb, __be32 spi, bool update_skb_dev)
 {
 	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
 	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
 
-	return vti_input(skb, ip_hdr(skb)->protocol, 0, 0);
+	return vti_input(skb, ip_hdr(skb)->protocol, spi, 0, update_skb_dev);
 }
 
-static int vti_rcv_ipip(struct sk_buff *skb)
+static int vti_rcv_proto(struct sk_buff *skb)
 {
-	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
-	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+	return vti_rcv(skb, 0, false);
+}
 
-	return vti_input_ipip(skb, ip_hdr(skb)->protocol, ip_hdr(skb)->saddr, 0);
+static int vti_rcv_tunnel(struct sk_buff *skb)
+{
+	return vti_rcv(skb, ip_hdr(skb)->saddr, true);
 }
 
 static int vti_rcv_cb(struct sk_buff *skb, int err)
@@ -447,31 +431,31 @@ static void __net_init vti_fb_tunnel_init(struct net_device *dev)
 }
 
 static struct xfrm4_protocol vti_esp4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm4_protocol vti_ah4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm4_protocol vti_ipcomp4_protocol __read_mostly = {
-	.handler	=	vti_rcv,
-	.input_handler	=	vti_input,
+	.handler	=	vti_rcv_proto,
+	.input_handler	=	vti_input_proto,
 	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	100,
 };
 
 static struct xfrm_tunnel ipip_handler __read_mostly = {
-	.handler	=	vti_rcv_ipip,
+	.handler	=	vti_rcv_tunnel,
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };
-- 
2.17.1

