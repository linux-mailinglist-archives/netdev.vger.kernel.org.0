Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF720EFA3
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgF3Hh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3Hh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F83C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:26 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j12so9040706pfn.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=z1pyPjFm65QRVkTKyaRq57FstZhZwmJ/r6lGSnbsdZY=;
        b=W4auH3pTDUwNPRftjix2ysJ95fJmEycqJoIbYs2a5kAESSGATbFRabj0l6g3cwUjFR
         TJmcDChFrpt0q5cDLVtQuikeYNTcY9rP9AAM/1WPYwYGcd6Nih+KlMTmqLET2B881qoY
         1srm63ckYcEdDEVBTa70xmc62y4akhkYzW7zSyAZA38hVq9yJ1w7bgCfdIknbbJqcAEw
         XkEDd3Y1bEr7FiV/1AY6Gi6ng3g9JfH7TP8eAZpfAueBVOXeMy6ENLKJr5mGQyjEUnui
         ChqP7IBBE3RmUEGL5WPIhAbl8Mul2GHwz/V9myxwpXtMjvITcU8g5YKm8mA62et1rkWE
         jOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=z1pyPjFm65QRVkTKyaRq57FstZhZwmJ/r6lGSnbsdZY=;
        b=PNUzQz8ew7jbfg7yg8EvcuA0/y6ybMeMb0eMR7qaNlT/ru2BHzc+rxkxYPBCYlOdeB
         pdyiRQ62HjZL8cYmvfrkN7ZBEI6ISWAM23E8/xHDs51jnUBWHuUlsopwGqjySgUKQkTb
         5/r0r90MbCGroLCRLKxNkbKWpgDuMPrAQ3B6o7nYma5ZzW37DAPenWEGqzhRTxYqiiB3
         8PNQNdbTexm9z7uQ/0mSLlAwQZqEze1Dhwwomo0t05aQuv854PtmGfMerRR7+hP0zyZj
         Z73MTJlu4domwZbPmoxRAeCNuM7fhzk/VzirHrfy2fMb4KSMTNBxPZcyjGkBjGsFpu2c
         fv5w==
X-Gm-Message-State: AOAM533LKBDF3ddXQdQsew9v7q6Ob/A3OwPWXEBtLZ1iaX8kq6mVx84h
        s0jNOzNNy4jdvWHSE1NNnXRuSaml
X-Google-Smtp-Source: ABdhPJzV5nJKRyDMfBlWH8O42yr4gBqQqieYoX798Z2Cw5jd29m3/I0tqWN7enp68PvdVNADux5KHQ==
X-Received: by 2002:a63:fc01:: with SMTP id j1mr14185055pgi.0.1593502645724;
        Tue, 30 Jun 2020 00:37:25 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 191sm1608257pfw.150.2020.06.30.00.37.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 05/10] ip_vti: support IPIP6 tunnel processing
Date:   Tue, 30 Jun 2020 15:36:30 +0800
Message-Id: <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
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
index fd762d9..f0bd680 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -655,7 +655,12 @@ static int __init vti_init(void)
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
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti_link_ops);
@@ -665,8 +670,12 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+xfrm_tunnel_ipip6_failed:
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
-xfrm_tunnel_failed:
+xfrm_tunnel_ipip_failed:
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
@@ -682,6 +691,9 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
+#if IS_ENABLED(CONFIG_IPV6)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET6);
+#endif
 	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
-- 
2.1.0

