Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B6B21D090
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgGMHnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgGMHnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:43:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14128C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:43:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k5so5828726pjg.3
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vHvO/3zdXncLdQrcffVsJ30qW0QBRR0ZiyWOyTGXaOE=;
        b=WFh/qh7MKLYBoEFaDIUjItCRBUwBANbENAWWa3AnosWNlJzXHme6jPNTM246azAz0N
         7Oh2vVShuzAT1sqiQyOh2p8OOFro4QSe7Fdf+IECd2Od7ERKwoT5vX/5mtjDlOQcQs3A
         zqM2o6KqMw/+lEy4DOAJ6sY3uwe6G0I821Dr3Hgob+QV8SNxkXHSZFHZtypQaDGdBQU4
         0kakDh5YCFAJbtN7Ny8sXLOONyxwRh2nuufT0F0wmn6lsLIjsn2fCir86Me4WpwGJvwt
         vRcynsyT8dG+Ni+FRdXqnhlcxXeEyBcCth50Zs/0K/oETcL5a7yX7jOjpvPBvZJJ675T
         cqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vHvO/3zdXncLdQrcffVsJ30qW0QBRR0ZiyWOyTGXaOE=;
        b=uNC86KGMwz4HvBYTJgcHOjrknn797dpq4b8/FBG1ClEB+e7A/ig5k78ruOXAJaBdi3
         yJ7LnQvR+8KcyQjtfMMRjxOwK1QTCJ58uaSlDmo3QLAEC1d+HD+xoT+GthLUHppzbeDx
         OH/4ZD20WicwKmabgvYBRn6t+UWOetbb9cMiCd0NsNFS2jcNkvbWbMWH5wsSNsKx6Q5o
         uh7AUGdlLpG35R/F38V8EmONLYK5gbfvRViYFlx90PVhDK9Kx7zNCrXTv5yoWJSLZ4QN
         87vci+ewirAefmJmbGBDXXmL7FLXFz2VwasGldxzJGmkvYUPeWW630CcAzSbmvldMH91
         AyqQ==
X-Gm-Message-State: AOAM531kFCz19PYfyfDG/mX758jdB5/uFLtdF/dcnYAz9n23JTI8S3MR
        Y5kerLpL6Clt/CAvVQC0plGlNlGB
X-Google-Smtp-Source: ABdhPJxNkzlnsOsplgaQzJYQMpA5ozOYayI2o/+yMStgNblEa8bbvdNLL8Tc59tTnK8aF2kx8Gp0MA==
X-Received: by 2002:a17:90a:304d:: with SMTP id q13mr18519432pjl.73.1594626183402;
        Mon, 13 Jul 2020 00:43:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm13442752pfh.157.2020.07.13.00.43.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 00:43:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 2/3] ip6_vti: not register vti_ipv6_handler twice
Date:   Mon, 13 Jul 2020 15:42:37 +0800
Message-Id: <46e40c0e3e7f2b2739720e3a6926293410d0fc7f.1594625993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <834afa201899677daeb9d0f33d34bca15bf45a19.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
 <834afa201899677daeb9d0f33d34bca15bf45a19.1594625993.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594625993.git.lucien.xin@gmail.com>
References: <cover.1594625993.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An xfrm6_tunnel object is linked into the list when registering,
so vti_ipv6_handler can not be registered twice, otherwise its
next pointer will be overwritten on the second time.

So this patch is to define a new xfrm6_tunnel object to register
for AF_INET.

Fixes: 2ab110cbb0c0 ("ip6_vti: support IP6IP tunnel processing")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index dfa93bc..18ec4ab 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1236,6 +1236,13 @@ static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
 	.err_handler	=	vti6_err,
 	.priority	=	0,
 };
+
+static struct xfrm6_tunnel vti_ip6ip_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
 #endif
 
 /**
@@ -1268,7 +1275,7 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
 		goto vti_tunnel_ipv6_failed;
-	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_register(&vti_ip6ip_handler, AF_INET);
 	if (err < 0)
 		goto vti_tunnel_ip6ip_failed;
 #endif
@@ -1282,7 +1289,7 @@ static int __init vti6_tunnel_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+	err = xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 vti_tunnel_ipv6_failed:
@@ -1306,7 +1313,7 @@ static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
-	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 #endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
-- 
2.1.0

