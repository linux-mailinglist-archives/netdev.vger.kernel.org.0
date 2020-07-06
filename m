Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51902156F6
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgGFMCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgGFMC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:29 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E36C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:29 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id o13so15314557pgf.0
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=73ES3hQsObj8fvoM1TL4nZ7fBgYdaDlFMOTWlaDG/1U=;
        b=FGF5jCmirkLvqMaXZp/QFVNXsH42vxq6cT9iaA174heCRzWIF+IFcJosPlh18XVUpb
         uude+N3Og4bo8z/tLvYUAruGtgPs9CdIloGc98lnDKDPwNGK9E9cuWJwcGpbdwTSYM9P
         zaJMSLdjMgrARcRzKemC8JLiWV+guFuHNRNUkXE7VhlGJwv2AAjK1E+c1rLTaydK+dFB
         W9H5hXFPE5e8dG3KNXw2xvc3JM8xY8HrJWANpWJt2JsrtaEPACyV9ET1jsdbrg1pZDyP
         QhGpUtV53HPbDHF+VyoeStLSk10IB5uKS9Q8RjK0TvCldczfzhYmEp34tiAMfRZU4Z9X
         DjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=73ES3hQsObj8fvoM1TL4nZ7fBgYdaDlFMOTWlaDG/1U=;
        b=cSto0E23NUbGHdb2jSsUc6P4PX64ge7ICzhP/wh1ceHt5JutrlmeJgvftsKYdHQjPE
         0h5xw0Ar9P/Po0FdXF69HAlL6t2pCdLVcPpM+ILGbxlwEE5xT4Xn2fE8bE7UxyhlCwDb
         6BmNnb9RUytoeqoZLRgk5jcxseVC5YLYFGbh8ycC6pgBLtP4P/HGNV07UtK9uQfG89lk
         9isyJKUXbF8cJiBJhg+w0H4a/wiWoqcVVZapLYK6lvCwocqWmZJIMAnZckb714EmEjkg
         CTRRLHsgDs6pGbgEgEQ5Ib/JssowLmKyBqrYyH/W8jnNxKjco32OkICKOoob2RwVnXzm
         qDRg==
X-Gm-Message-State: AOAM530VzbIynwz4+Gy5d+izYDFzH80g7u0CUQFrqqQMqOkp//EAbKNY
        zQSypDwr75NnqaBU/WBJMS0c+oOE/C8=
X-Google-Smtp-Source: ABdhPJzHWPnWHC4GFV7p/d56FKASReHn6x7ktvstwLd0HNl6h94swyaISVsUcDx0IDc8yRvLRE3Aiw==
X-Received: by 2002:a63:9dcd:: with SMTP id i196mr39211040pgd.378.1594036948987;
        Mon, 06 Jul 2020 05:02:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l134sm18682418pga.50.2020.07.06.05.02.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 05/10] ip_vti: support IPIP6 tunnel processing
Date:   Mon,  6 Jul 2020 20:01:33 +0800
Message-Id: <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPIP6 tunnel processing, the functions called will be the
same as that for IPIP tunnel's. So reuse it and register it
with family == AF_INET6.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_vti.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 68177f0..c0b97b8f 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -658,7 +658,12 @@ static int __init vti_init(void)
 	msg = "ipip tunnel";
 	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET);
 	if (err < 0)
-		goto xfrm_tunnel_failed;
+		goto xfrm_tunnel_ipip_failed;
+#if IS_ENABLED(CONFIG_IPV6)
+	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipip6_failed;
+#endif
 #endif
 
 	msg = "netlink interface";
@@ -670,8 +675,12 @@ static int __init vti_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+xfrm_tunnel_ipip6_failed:
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
-xfrm_tunnel_failed:
+xfrm_tunnel_ipip_failed:
 #endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
@@ -689,6 +698,9 @@ static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
 #if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 #endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
-- 
2.1.0

