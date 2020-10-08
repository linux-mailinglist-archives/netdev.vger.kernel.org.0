Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B712928708E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgJHINd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgJHINd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:13:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80058C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 01:13:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s19so2398954plp.3
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TEK4mcYawZhw/E0+fVUmsyWIFs7Vb2uAkNHNOKU+Yk4=;
        b=cORl+1iOWde8DhgTWPqm1uwpN3vs5VngTzkewqRJtNemnP/92MckztMu/luRrEJnYY
         f1pXD/EdIvBG+JamuNQIZW65s1IZe83xYt8nxKwumxA7FGyvFn4zNdfnAePpTW5NUbPr
         6TPBZd1/hFvqrnYBZU1J4dFk/Qk5gGyaLXMMQeQiDzP7JSdMonufwzoe+Ne5oZ9hqiwy
         m/ZTk9Wx1XLK32DEtUBZnM3+3Va9qcAy+9SN4w0Ng/qy33lg7QgTh0fY/RnSk4seNZJc
         aXkHO7UAiM/CRqpCgPsdAvdV45O4XrlKdYnUt0smkpx3QGEDhOUj61AqCHmvi8aFY6vA
         BPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TEK4mcYawZhw/E0+fVUmsyWIFs7Vb2uAkNHNOKU+Yk4=;
        b=rW0qb1LXp2klsSP90IoQiIJozDzJtFQT5gTUrhbdj4B/GOwfTN9jPLoPNr335VOv6G
         IPDSPIa4+EV0fdd2qLNNe1ijIK7gxMROm/wm3Qzxho6NEufANXPXO/Nxax2Ptz07NvMH
         MdaRNyVHX9obyEQO6xVi7FbqEUOyjfY148RhsmZnFA4Z1L8gK0KxS8Qf+l92TgTgf5Dk
         o6ptTpq97eeNeyWHj2nA7ifVyeboXZFrcEdKNQRSWgDxdw+KOjP4/GC5iUdzkETBdKLP
         pN4m5ohG55IICotbOT/LVceTH9lyLW8mYxfoZsgzsITDKQC3DOEOPwU40UPh31hRkU8H
         VBUQ==
X-Gm-Message-State: AOAM532UQiReQViwmJKfRhHhsYDg31ZFy9UJJePCH4LT2i9b2JGYDKb1
        ElSojrfsrv0JHND/apVkdqdQxWZT2AA=
X-Google-Smtp-Source: ABdhPJwN5FyV1pSw6QGHrKxMCaQxLbFwG05iYYfx/m//PKCoTgXybAVeN8RSQEnR+c+oLHvARlL7Hw==
X-Received: by 2002:a17:902:a407:b029:d2:2113:7f8f with SMTP id p7-20020a170902a407b02900d221137f8fmr6633561plq.70.1602144812709;
        Thu, 08 Oct 2020 01:13:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q23sm6591254pfl.162.2020.10.08.01.13.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 01:13:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH ipsec] xfrm: interface: fix the priorities for ipip and ipv6 tunnels
Date:   Thu,  8 Oct 2020 16:13:24 +0800
Message-Id: <99c1ec6ed0212992474d19f4e15ef5d077fe99b3.1602144804.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Nicolas noticed in his case, when xfrm_interface module is installed
the standard IP tunnels will break in receiving packets.

This is caused by the IP tunnel handlers with a higher priority in xfrm
interface processing incoming packets by xfrm_input(), which would drop
the packets and return 0 instead when anything wrong happens.

Rather than changing xfrm_input(), this patch is to adjust the priority
for the IP tunnel handlers in xfrm interface, so that the packets would
go to xfrmi's later than the others', as the others' would not drop the
packets when the handlers couldn't process them.

Note that IPCOMP also defines its own IPIP tunnel handler and it calls
xfrm_input() as well, so we must make its priority lower than xfrmi's,
which means having xfrmi loaded would still break IPCOMP. We may seek
another way to fix it in xfrm_input() in the future.

Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
FIxes: d7b360c2869f ("xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/xfrm4_tunnel.c   | 4 ++--
 net/ipv6/xfrm6_tunnel.c   | 4 ++--
 net/xfrm/xfrm_interface.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index dc19aff..fb0648e 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -64,14 +64,14 @@ static int xfrm_tunnel_err(struct sk_buff *skb, u32 info)
 static struct xfrm_tunnel xfrm_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	3,
+	.priority	=	4,
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct xfrm_tunnel xfrm64_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	2,
+	.priority	=	3,
 };
 #endif
 
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebd..f696d46 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -303,13 +303,13 @@ static const struct xfrm_type xfrm6_tunnel_type = {
 static struct xfrm6_tunnel xfrm6_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static struct xfrm6_tunnel xfrm46_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static int __net_init xfrm6_tunnel_net_init(struct net *net)
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a8f6611..0bb7963 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -830,14 +830,14 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 
 static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
@@ -875,14 +875,14 @@ static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	3,
 };
 
 static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
-- 
2.1.0

