Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C0C20EFA5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgF3Hho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3Hhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D236C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cv18so3905716pjb.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=fan5/UZFCRvRboBAzk0Rni+XwLaisLnJjgBMZbBtGnU=;
        b=Vzwy0glByvDTckxr0NtuSVf9FhK7FV86LoN3kpsa+NxLvtQXoe6UN9g7zZqxyqsFU3
         f0ImosfDeAnsHf14rjozmfhwwCnR1INNSED8398cd+cshTHqoML/IUkMB3rJR00EfLNZ
         GxTUUOgb0FHok7EMha8apAxP8n+gV2tdIXjcP1f/6PX4VWsKFQvNBliHOmz4q61lbTbc
         GW/gsWSH4NG6gcuApdg4CuUZB6mnkXfCCvypE6IXH770TCypyPAJIfMg0j38+oerdZq8
         LLiYZ70YCHhqRnTUMbkqMK+VC76PiMMky2UZeJD5mtnJhdmBlLg8siZecbCZJW48HUQA
         fcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=fan5/UZFCRvRboBAzk0Rni+XwLaisLnJjgBMZbBtGnU=;
        b=Rw06ecemrod0I8iIZ0PrQYCTS8cqFbzolO2n3SH1YL1ZkayoAnOFbGQhUkVp4DujPk
         FDBOd/dsJtVYF+bBvFuqYj0rjO6vAWEhZHXb6XhE43bYxN9XtXUwZZQMenUju2UiKXeT
         xblmbOIbF2msAFqfqHMrgWUt3FE6cIR3nwtqjvAknraNuTThDI4qNGJWSLyZkF+k0UwD
         XSDSXZQOBUk93RT0Tv9G+X6DbsBTZ7qY33mqLo9dTOmKtMmAb1g5w8dVOTBToZjGrbH1
         QdOFq44o5lcalyQuXy8RrkgfB03GgyfZU5Gcnn2u9iKeYgYSfRBiMr9mAweYu65Lw7j7
         r+2Q==
X-Gm-Message-State: AOAM533bsRpkouWgT8BiuWQkBF2pXrZya70AO9y41VPalv2xqtSMtgoa
        Kmq44hEcaTZfBjiYk1/2tJfs0GS+
X-Google-Smtp-Source: ABdhPJxWMslwqx7sYe8TPq6UeTBplNoc7ptVylw54vtuz4Ke6MWoKHGgxvUVD3vwQHXOOP5Fj/EOmQ==
X-Received: by 2002:a17:90a:28c4:: with SMTP id f62mr21044683pjd.207.1593502662573;
        Tue, 30 Jun 2020 00:37:42 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n37sm1750766pgl.82.2020.06.30.00.37.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 07/10] ip6_vti: support IP6IP tunnel processing
Date:   Tue, 30 Jun 2020 15:36:32 +0800
Message-Id: <66b5ef2dc7245ab1707ca8119831e58c26a552a0.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
 <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
 <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IP6IP tunnel processing, the functions called will be the
same as that for IP6IP6 tunnel's. So reuse it and register it
with family == AF_INET.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 2161648..d45111d 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1264,7 +1264,10 @@ static int __init vti6_tunnel_init(void)
 	msg = "ipv6 tunnel";
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
-		goto vti_tunnel_failed;
+		goto vti_tunnel_ipv6_failed;
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET);
+	if (err < 0)
+		goto vti_tunnel_ip6ip_failed;
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti6_link_ops);
@@ -1274,8 +1277,10 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
-vti_tunnel_failed:
+vti_tunnel_ipv6_failed:
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
@@ -1294,6 +1299,7 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
-- 
2.1.0

