Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8115A1FBD25
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgFPRhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgFPRhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD96C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d66so9837069pfd.6
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=WPSbLQ681FD6gaLQ+/C+OaDfV02GtaInJMLuiNhU08E=;
        b=VAGG/zMWnp+masFFJwl3dtat7jt4KASuQdP+NPWi0DZpnQSz4cFjvXg2+NBdd4F/wF
         os/Vbry/LysjD2T2YELLRKuFKPgGBPvhjS6oP7/cBMvAtu104acIn7+bFj0YKQhaelZx
         zs7yeg6JR3rLRgLxTrYnKNfiR+gI6OGLhOhPSbsorpiEB6bX2feKgjGU5nh/K7ow6QC8
         IZOyuSctev5BXlFJ/wTBo2/KiDAW4Nb/GtRFRW93gudJUg69TBmRiWCC8x1C9aqfJ+HG
         dT78sxmdJTpAgucK2IxTY5DJzhC7sz93xXoFnbJcFpVmU2tmY2kv2C8oXRbyabe/aAv1
         4/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=WPSbLQ681FD6gaLQ+/C+OaDfV02GtaInJMLuiNhU08E=;
        b=gUU1kyTcNXvqrfqTDaWLkOvNuh2M1CF7kDHL2lEeKoZYunWeI39jawcyvuKZdRbK1y
         VWjXVGbRetWvYGzSzf+l1y+9QtsI9xDBc2AWd8tK6IZan43jbYrBafqWY9U6eO364Ar+
         Ic3gnCu2+ReJboMqO1gFVdBphlxEaXkuQQDwHUeP3Q0Uxel2hI6bDj3OJa9rhd6QHx5l
         VXm/XTJfSQl736Hdu1oBATV6yiHR1V0Nqle1pmXu/7Rp10nzqochmAE3Zu/s2Uw1T9tE
         eBK+2OXZwM4KDPE7MPbf3JTrU3nWeUVsZEuMKcWJpUuETQizAgXh0FZ5zDpfQOMt9tj8
         5EQg==
X-Gm-Message-State: AOAM5300vHB5CQygVx0EiL+0OLN3ZpoZRzXRm69ZApF2O0E1GXPdTWYo
        qV0ofHA9gi3oFnsr+KczUUXeXP28hQo=
X-Google-Smtp-Source: ABdhPJxqUhn+r0DUQ84QBKrPeedjzbLTUn/D27vfDW+Fd3aETj1FvcWVF25STxzF1onj9xvVQw3kXA==
X-Received: by 2002:a63:ae44:: with SMTP id e4mr2949469pgp.428.1592329054106;
        Tue, 16 Jun 2020 10:37:34 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b5sm17881453pfg.191.2020.06.16.10.37.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel processing with .cb_handler
Date:   Wed, 17 Jun 2020 01:36:31 +0800
Message-Id: <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
 <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to IPIP tunnel's processing, this patch is to support
IP6IP6 tunnel processing with .cb_handler.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1147f64..2161648 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -343,6 +343,17 @@ static int vti6_rcv(struct sk_buff *skb)
 	return vti6_input_proto(skb, nexthdr, 0, 0);
 }
 
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
 static int vti6_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
@@ -1218,6 +1229,13 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
+static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
+
 /**
  * vti6_tunnel_init - register protocol and reserve needed resources
  *
@@ -1243,6 +1261,10 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+	msg = "ipv6 tunnel";
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto vti_tunnel_failed;
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti6_link_ops);
@@ -1252,6 +1274,8 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+vti_tunnel_failed:
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
@@ -1270,6 +1294,7 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&vti_esp6_protocol, IPPROTO_ESP);
-- 
2.1.0

