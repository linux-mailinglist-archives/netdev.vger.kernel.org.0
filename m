Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD44E21D08F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgGMHnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgGMHmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:42:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88CAC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:42:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k5so5141600plk.13
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=BE3qQfNkAMNQTJHo7w+zHDsRVY4ZP6SZjRNPRH06Q6M=;
        b=Fl/uPEBOc9mNn2alMFO/ARO7c1g0vY0ryBS0Pd0GJaLOTw9+IBlyL/OEQHyajNTXg3
         Bk4CkaNaHyWyPTPacwVPiHpIYUI1b/ofbX/rZK0Kf99ECcj25AbuLvWztVeUboYI7F2J
         +eM39MZ4rIgp1iq14RDIHSZSiyBod2iCv4iphvGxIZlJzbhxPZXQI/g5RqycO+GMAf2d
         P9PQkqlbbKQpTVOc1fjnx1OBOQiDwZs/fHcBNwItCP7w8qIJiU86lDNGoSszGDos+SML
         fqJzXB8jRDvO+upRYq+U9JqFrs+byJMge8HLP0UhXE/TFP/pEvRvx6DhnHchx8bXwwPm
         Ebjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=BE3qQfNkAMNQTJHo7w+zHDsRVY4ZP6SZjRNPRH06Q6M=;
        b=Ixd7Vpm2ymKmBsJzoxl+tkNM4RNxbBDf9cYdDaZbl18olHz0gsZj29MzxDKOr/u4Om
         6BWR7lskVuls7wi7VKLCOjN3nj/6/ELD+Ozy2ZWcFwfyBr3GjsrKW1KxvsV140MUTv1Q
         dgSMTlRxEdox42wPOTRJK7t0JhNGyOb9w/eCgoOTsLP+w0kdvQNyi2QzcHwCj0L7Xlz/
         90rpTacsW97Z24IG7QzHfU//Im7+itf9cMmOyb3v7h94+ytmIu1UI/ssamaebUvaulKg
         HBtYqK8Z+wYqMVZct9p6OGGnJsuor2vUu89E5ir+6zBpKKOXT7sEbGWlvBEQfwEVWd4J
         A9wg==
X-Gm-Message-State: AOAM533+XqfLLzAijRcUYKXQPJ0vcUxbQlGQGim4lf4YO2Y/khzE7fHh
        jQacfHIUEkwKygcsNFivuoPwNscw
X-Google-Smtp-Source: ABdhPJzSgC9+HUTe7VLlI3/0CbEvRFR2Qzl7k1TzaL4tGgVWblpERQ/aMO3SCfuP6EKf9bo79LohLg==
X-Received: by 2002:a17:902:7e8e:: with SMTP id z14mr45131461pla.52.1594626175014;
        Mon, 13 Jul 2020 00:42:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cv3sm13442657pjb.45.2020.07.13.00.42.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 00:42:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/3] ip_vti: not register vti_ipip_handler twice
Date:   Mon, 13 Jul 2020 15:42:36 +0800
Message-Id: <834afa201899677daeb9d0f33d34bca15bf45a19.1594625993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An xfrm_tunnel object is linked into the list when registering,
so vti_ipip_handler can not be registered twice, otherwise its
next pointer will be overwritten on the second time.

So this patch is to define a new xfrm_tunnel object to register
for AF_INET6.

Fixes: e6ce64570f24 ("ip_vti: support IPIP6 tunnel processing")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_vti.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index c0b97b8f..3e5d545 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -484,6 +484,13 @@ static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };
+
+static struct xfrm_tunnel vti_ipip6_handler __read_mostly = {
+	.handler	=	vti_rcv_tunnel,
+	.cb_handler	=	vti_rcv_cb,
+	.err_handler	=	vti4_err,
+	.priority	=	0,
+};
 #endif
 
 static int __net_init vti_init_net(struct net *net)
@@ -660,7 +667,7 @@ static int __init vti_init(void)
 	if (err < 0)
 		goto xfrm_tunnel_ipip_failed;
 #if IS_ENABLED(CONFIG_IPV6)
-	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET6);
+	err = xfrm4_tunnel_register(&vti_ipip6_handler, AF_INET6);
 	if (err < 0)
 		goto xfrm_tunnel_ipip6_failed;
 #endif
@@ -676,7 +683,7 @@ static int __init vti_init(void)
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
 #if IS_ENABLED(CONFIG_IPV6)
-	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&vti_ipip6_handler, AF_INET6);
 xfrm_tunnel_ipip6_failed:
 #endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
@@ -699,7 +706,7 @@ static void __exit vti_fini(void)
 	rtnl_link_unregister(&vti_link_ops);
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
 #if IS_ENABLED(CONFIG_IPV6)
-	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&vti_ipip6_handler, AF_INET6);
 #endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 #endif
-- 
2.1.0

