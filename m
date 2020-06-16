Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE61FBD26
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbgFPRhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730621AbgFPRhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3820C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so7283767pge.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=fan5/UZFCRvRboBAzk0Rni+XwLaisLnJjgBMZbBtGnU=;
        b=jzohcR9t3+Snb/y2Ko3iftSNbajiTIf4zbOU8oj8+bNXzYnl1I/Mk5w1wOjAYDERzG
         1wDl0qlmbxib7X2I15G9PRn3TKLmOO5hr0Ui9v6ua5B/WSfjBq6D13oJDro1haLXErZ7
         8J9YdrFip9wBWQPq3/Eu3whUeX9DXiAwcLNPjauzCionzTYyMZ25U2bRQ5E6waBt81hN
         nsKS2c9h/BFlPncIQH+jNqn1GBZReTo5IcA+PaFwmX4qb1P421aarAg2Ft0zxoMuJ5P0
         7j/2JEhEPV5f3nXOmddkIcuHYFVAbpBSQFI1kbpus9O1jRFfwK4/nUxpC77BvKKfWhu1
         6icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=fan5/UZFCRvRboBAzk0Rni+XwLaisLnJjgBMZbBtGnU=;
        b=bpPXGoa6zn6sCvFOnjn3YlUpeQ2d5ByvA/hNPPg5PoLXR3zl42A01W8j5vd1mHYgDP
         InITFq/eE8V8r9OVXMTcT7p3fV3bDzk1iyEMs8kidCViz51Aza7j7VOjDmFr7y0swFAa
         Y525+Cs/bp1GrKFAnnlKeEito1HAmxCI2+Wdga6JykpH8LhtN77D/lBX/QmJnVlqYU6D
         VedJA3QgUFngOC3etynXRRB5PxUMX0xgdIHixWSiUA5CP76UvCd+cYcpA0iLHuMPJzud
         68FAa0DaULSWjafxF/4/Yg5ktx6UeDOPa5Yfbnzg5uAER55JJrO86aAcD6vy73eCIgFH
         rHkQ==
X-Gm-Message-State: AOAM53321VvnG1T41sYd61EC9F1iPmmcSydDMouwPLnkYl6gY4WRPGz3
        wCmwhMDspnHAAj6oMWW1OOpd3D5rDYU=
X-Google-Smtp-Source: ABdhPJwuPLcWZdAygmV2AFIa0ySUF86xE2EEnkP60uXGBT68HiWNNw+822FMTqLVvUSI97dOSXEKDg==
X-Received: by 2002:a63:3d85:: with SMTP id k127mr2711561pga.29.1592329062490;
        Tue, 16 Jun 2020 10:37:42 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15sm17509144pfh.175.2020.06.16.10.37.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 07/10] ip6_vti: support IP6IP tunnel processing
Date:   Wed, 17 Jun 2020 01:36:32 +0800
Message-Id: <870c43283bd6bd6c3b583c05ebc757879676edcd.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
 <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
 <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
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

