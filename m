Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2225C22351B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGQHDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgGQHDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:03:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B69C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:03:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so4954235pfm.4
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 00:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=27Nl3OPlzhwfETzhZGCbuIEM0uupC5eTCneQHjIUtaw=;
        b=ozKLhwDZfMuHHCGQsaeU2C+UiODFOkHwOVFuI94kNb+as4xwRI26fVKJKQpkWLIXkH
         bgXSF46wBXoar/wOqZImpOl9o9GS+j0VHYe4jE/kS4uyfktk0gXbOtFf3ZacURWKTzSl
         LbeZ1C4He5X3sqXyDh/1kyi+7tXk3zgIcPh2bNbay3gPRL1k4M4BFdKAtV8L63B0atNz
         PiNkNa2siuY0OOBScH3waYO+SL/hTyz/4yIYPdpxuvu/Sy5wQRHifUsuGQsKUww7iHwi
         37DG8k0aURcOx4ca8n4T8+0QUaVLJXAjwEjooquK+vSVlML1Bwp3z4zjqVn5RvfVbRoR
         686Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=27Nl3OPlzhwfETzhZGCbuIEM0uupC5eTCneQHjIUtaw=;
        b=laebnHNpZP+pxdcnVlovnWwBrGa7mm6TVRctxzeBrDYtMX4mKc92er1ukZNNTMnh8h
         gdnGr3/rf2E5+T8JuQM4qrrnT4ensxH80ijLOy5ZeyKdrVUR1YAG+FV/NB9yrIKS997h
         xNZtHvPWxcK+HRORHVM/gTL140L5GiMdq70dPCDTnXrtl7xzr22KlWwBSbnJ25LxAmkq
         LZKRfqzBHE1bZxD2CC7f1vcl11Dg2DhL04fO83kYggxntSAh3MxgZR8jyGX6Sz6vw+20
         Vr2dZbYswtPKF6Nu/R9owuxr1WvPUPV/mr0Sub8Foewc+yQFf9JsBMPYxFZfdXWrJRTQ
         1CZA==
X-Gm-Message-State: AOAM5322AD/8rahKIPZ+a3m3m8j7Jx2uz5BMypoXN6X3xVtDrrUfuAjh
        hJsCRawVFqMtYlu3VxBSlrfZ1Rx6
X-Google-Smtp-Source: ABdhPJwCa1eHqSdlDAvqbpFH3nUM279UtLnn32/zc59cjXxFDLp+ljiN5R2pBKBzNlejUMKYvkoWZA==
X-Received: by 2002:a63:371d:: with SMTP id e29mr7516915pga.153.1594969402483;
        Fri, 17 Jul 2020 00:03:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 15sm1830429pjs.8.2020.07.17.00.03.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jul 2020 00:03:21 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH ipsec-next] ip6_vti: use IS_REACHABLE to avoid some compile errors
Date:   Fri, 17 Jul 2020 15:03:14 +0800
Message-Id: <2aabdcbf7f02d036995701b0ce48cceee4e261ee.1594969394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh reported some compile errors:

  arm build failed due this error on linux-next 20200713 and  20200713
  net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
  ip6_vti.c:(.text+0x1d20): undefined reference to `xfrm6_tunnel_spi_lookup'

This happened when set CONFIG_IPV6_VTI=y and CONFIG_INET6_TUNNEL=m.
We don't really want ip6_vti to depend inet6_tunnel completely, but
only to disable the tunnel code when inet6_tunnel is not seen.

So instead of adding "select INET6_TUNNEL" for IPV6_VTI, this patch
is only to change to IS_REACHABLE to avoid these compile error.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 08622869ed3f ("ip6_vti: support IP6IP6 tunnel processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 18ec4ab..53f12b4 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1218,7 +1218,7 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 static int vti6_rcv_tunnel(struct sk_buff *skb)
 {
 	const xfrm_address_t *saddr;
@@ -1270,7 +1270,7 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	msg = "ipv6 tunnel";
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
@@ -1288,7 +1288,7 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	err = xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
@@ -1312,7 +1312,7 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
-#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+#if IS_REACHABLE(CONFIG_INET6_XFRM_TUNNEL)
 	xfrm6_tunnel_deregister(&vti_ip6ip_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 #endif
-- 
2.1.0

