Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705E820EFA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731102AbgF3HhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3HhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:18 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1709AC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:18 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w2so8744324pgg.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ehvx/gW1K4luTZ4SExqYT0y8xnZwFcfGdr73YcfIwo8=;
        b=Vc3D1svu7neztQn7TcG5NMCwLyt2RsjUGO4abQk+1HxBlfJ3Puqq8RGn1bqEpBGlYY
         jcrmPv3Xq4HjEd3KfiRYp8XOQOLIcj5TSwpLBAcAe4zXM/WXfCWK8aTMtrhrsabZddOR
         V+6vytoXs0RqbWSYmWkKAefsLyEYDpE6+31S4qlq8AmVJu/41Ph0GLFhinriwJGOd/iQ
         AgeUuGpE/zjDX+EpN36HjKo/E73qV8SjiL08eKygePsG8uWFRM/Ft3qvgS9bIj4hifWe
         FCP0wzW9BMrfNGmFVRqmOpODoTEbncS0DIsuC3fr80qx5qGf6CqMaUrU78jjCVp2SGfJ
         YTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ehvx/gW1K4luTZ4SExqYT0y8xnZwFcfGdr73YcfIwo8=;
        b=lI+vfGO6j+jRTR9rTPTRT3yvwLy93YvZGRjV7td9s811uOyuPrn6oo1+FtU61E4/Cn
         /X+/GChmADiv0CegkD2yI8sQ/3UFoHZjIEHdSePAIJJbb5LN3q/zaSc1r9KYhCK+K9j+
         O3NwZ3MHCxtW/p9uK799ylaf5VDvXVNRCXipUePpw3H+6tUUHPTutGdOoEjf0Zjtv0ws
         zlLlKhE4twT0MjXvPFHxOOYpGNAYTsuN0H2Z4olja88XdFeuOeRyH32j/ln+Uwef9NM3
         65cAEX3Ef6MwXU0M9A+zp32SMkdbqWKSbimoHYckW4KCXAw26QfROw1j6G24Bb9/1jjU
         nmNQ==
X-Gm-Message-State: AOAM530tvwe89f2DPlHiKlVuVh7l7cbcpox0r3YsDxxHEuf58d7dmm8R
        ciLCf4oJQLHw9r7VdD+BY6R2kGJK
X-Google-Smtp-Source: ABdhPJxE8FXM4DWNrxN3UhXxqT0Fux6xL8+wfxlNslWONAAkRVk2Y7S2AglTy2yVwNJsEQzwliwqoA==
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr13624401pge.209.1593502637399;
        Tue, 30 Jun 2020 00:37:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y80sm1691353pfb.165.2020.06.30.00.37.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 04/10] ip_vti: support IPIP tunnel processing with .cb_handler
Date:   Tue, 30 Jun 2020 15:36:29 +0800
Message-Id: <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
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

