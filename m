Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A692156F8
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgGFMCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbgGFMCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FB7C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mn17so3399774pjb.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=4GqZ/MEcuhlQ02sPT572yEZBKuavleWrR9uu29ltT7E=;
        b=IMztWi+yq/UWzgLxoSXmbgBdOG0V9ZEJEcZH0FgoQuOh6J4+/yYHOEihWXJbb2jCp9
         M6SgnzUvnSGojbwHhgcBXtoUBezW5qHrOqJrEJYJLbeiw5P7vrMUzB7by9GEsNjetmq6
         8nQG8pjWhU404SdEz2WSkZe2gKcLoyMpyXZ3CDnzega5QlJW006MafqDtFibRjyTlDBl
         lNH1yBcuhBIOYf10R1Q+OjAbNgSVtP5uAQPnBCOWUtkCXM/VGhXnYvJmGvena9HwvJ+G
         Jwm2elAmS6O5t4QfHMcZsmu3HniNuoCODk89AeiNnmhJee/89u5cw/7VgEHL6zGuQRTK
         Vu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=4GqZ/MEcuhlQ02sPT572yEZBKuavleWrR9uu29ltT7E=;
        b=g5s/acKavRlcz1KHcy9OZKxMmeu2gzcRILEeNGEql6uMLzk9J5yOXnLZU7259NIqvn
         vihKQzVqi+VRmOCrAI6tEAjY5Fiv2OPw7RO8zkFANr5k8943nwoulsK1xp6AAyKXzeoZ
         OXlduCi+M4prBSMzqItswW6wXXfCKkAGtjFafNqrV4EzJXZ1gsgnGmaBDmDDOpk0bOro
         Ap5RZoF37/x4pyCebrJILiTUU4XyW/Lc6zccna/b3N5Q8BRUQ+KKj6tuOKEx8iFF/51n
         0cSCfc+58CsF1X4AUeap30ZmJlNrCTIUTvKpIi8SRs64H55s0OqhoH1aZWRvqwp8rUpD
         ErQg==
X-Gm-Message-State: AOAM53052Gsad0RRTR9SxpZZUqGUby8WdIPkDr9h8iBtRqNdCOzrf8r/
        NdCugoAlxg2eOEmKkCdMZIUoVurVC10=
X-Google-Smtp-Source: ABdhPJzEz6RvlM+IJE9//Nt/s+2dlQE5pRATzJzmuKsRsvhHmo/cHPyYuDdfbz3l2nSU3i6KBByXqw==
X-Received: by 2002:a17:902:b187:: with SMTP id s7mr37642641plr.188.1594036966182;
        Mon, 06 Jul 2020 05:02:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w18sm18982205pgj.31.2020.07.06.05.02.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 07/10] ip6_vti: support IP6IP tunnel processing
Date:   Mon,  6 Jul 2020 20:01:35 +0800
Message-Id: <35a313492a554aa64b07bb4fcbf8d577141e6ade.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
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
index 39efe41..dfa93bc 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1267,7 +1267,10 @@ static int __init vti6_tunnel_init(void)
 	msg = "ipv6 tunnel";
 	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
 	if (err < 0)
-		goto vti_tunnel_failed;
+		goto vti_tunnel_ipv6_failed;
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET);
+	if (err < 0)
+		goto vti_tunnel_ip6ip_failed;
 #endif
 
 	msg = "netlink interface";
@@ -1279,8 +1282,10 @@ static int __init vti6_tunnel_init(void)
 
 rtnl_link_failed:
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
+vti_tunnel_ip6ip_failed:
 	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
-vti_tunnel_failed:
+vti_tunnel_ipv6_failed:
 #endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
@@ -1301,6 +1306,7 @@ static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
 #if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET);
 	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 #endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
-- 
2.1.0

