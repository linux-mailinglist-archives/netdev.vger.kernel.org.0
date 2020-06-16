Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245091FBD1F
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbgFPRhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgFPRhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2413DC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s23so9834134pfh.7
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ehvx/gW1K4luTZ4SExqYT0y8xnZwFcfGdr73YcfIwo8=;
        b=i2/KDRXlEFsTHhnQdlD8+v/V8qriYENGXIvBiE4C8PEc8ugq9v+isIRtdi51LZqHDT
         fNKit/OvCbUaWl4EsUfQrv0WV43H3pxVC1dhNU5e+XmW9sGoNbFxeMaHVbKWnNDMBRlH
         uLRvkyhLlV/SKQnuCqbNogzuGi956P6s7bgyAe23bwbWy6MgVz0NJ80em85nNzAOJAcd
         1bb6ANZoos/mtdfkRblvCIZbOBF6yhaYc0AHRDdzmjkGXF+//56bc1Kkgs6tbpm2lcg+
         SDMVgluCp327t8hiBN/yFTKBsEH7/TSybgUNu0KoyPc1ypY/6Zx6bOK9Hl6kZTZ9Xkvf
         eh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ehvx/gW1K4luTZ4SExqYT0y8xnZwFcfGdr73YcfIwo8=;
        b=KRD2HxJm/qhYhPeysu2UWG1IqvFJF0R1kbJwuSND3lIqhgEBjtruIZeJr8iX/tXbjI
         +hjbLFbStcxSL7qjpCq4CKlpfwbCMTXQlOWb8ByzOukRHwZCDColwNCz96ZRkAoKNea9
         oc8/cc9j8KD6sT+axgrf5EM2EWFjQbA/DwM+9bBgagtJM61SONiT5Ura4TOUoGovzd1p
         1NvdTxDtA6oOSl/GVEabZRJzQeq2givAtmQ9PFmoBT3lbMVPjlZljn4vghOR6kP/CUP9
         XRCRXKFqMzvOpzXc2Nt8kFeHRQFFxM0OOpwgdhnNFmD5aE8wowUeANtgS/B5LjGS53Qs
         wdeg==
X-Gm-Message-State: AOAM532AiGnpoeY+Bg2onFUGm5HwD7VJG4wxRxL0BKm2lUn5Ez2Nxq8v
        e2KsHjLtmLsFyZKMZn2Idmo4k+TBon0=
X-Google-Smtp-Source: ABdhPJxg8GY16TfIvcO/MS3bhFk00ruZ092tpYOBwyRTQxpAJW7ZZ1mHvIHy0yvpIJWd09cKeySbQA==
X-Received: by 2002:a63:ec44:: with SMTP id r4mr2941325pgj.11.1592329037382;
        Tue, 16 Jun 2020 10:37:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r8sm17953531pfq.16.2020.06.16.10.37.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 04/10] ip_vti: support IPIP tunnel processing with .cb_handler
Date:   Wed, 17 Jun 2020 01:36:29 +0800
Message-Id: <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With tunnel4_input_afinfo added, IPIP tunnel processing in
ip_vti can be easily done with .cb_handler. So replace the
processing by calling ip_tunnel_rcv() with it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_vti.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1d9c8cf..fd762d9 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -93,28 +93,10 @@ static int vti_rcv_proto(struct sk_buff *skb)
 
 static int vti_rcv_tunnel(struct sk_buff *skb)
 {
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
+	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
+	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
 
-	return -EINVAL;
-drop:
-	kfree_skb(skb);
-	return 0;
+	return vti_input(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr, 0, false);
 }
 
 static int vti_rcv_cb(struct sk_buff *skb, int err)
@@ -495,8 +477,9 @@ static struct xfrm4_protocol vti_ipcomp4_protocol __read_mostly = {
 	.priority	=	100,
 };
 
-static struct xfrm_tunnel ipip_handler __read_mostly = {
+static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
 	.handler	=	vti_rcv_tunnel,
+	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };
@@ -670,7 +653,7 @@ static int __init vti_init(void)
 		goto xfrm_proto_comp_failed;
 
 	msg = "ipip tunnel";
-	err = xfrm4_tunnel_register(&ipip_handler, AF_INET);
+	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_failed;
 
@@ -682,7 +665,7 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 xfrm_tunnel_failed:
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
@@ -699,7 +682,7 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.1.0

