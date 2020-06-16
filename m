Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B311FBD22
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbgFPRh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgFPRh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:37:27 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F37DC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:26 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jz3so1752139pjb.0
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=z1pyPjFm65QRVkTKyaRq57FstZhZwmJ/r6lGSnbsdZY=;
        b=UJa56e8FV19GK3aLScMSOBGCAwfvNeAQiwJioOtloyJYjPX11AtJsD7weteXID0OwF
         20CbKl1DwlvboaYiRsy9TaKOpsNvtXXdFNsf5tFccwntjXlpU9hgacNlecOkJSK+NVlG
         pxQHxnov0+c6061LWGcn/7Bc9GZ8bTRc1j1UWGu85FUFpNEN3PgukDjmB2x+S63guEmS
         U/u6/Dro6bEQbIwyk7b5FVW/ifc40btHYbFUS8s1OWLWL0gFyilLl2J9thJ58oE3otYO
         kk08DkKd0LxXXmF0qKU6lyPAW9a2zo+4f2oifKXwuO2c5S5NQDw0qgzCho05dnaTL0T+
         U1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=z1pyPjFm65QRVkTKyaRq57FstZhZwmJ/r6lGSnbsdZY=;
        b=acSfOs3FP7kTr0+21Tq5CjdQncJsgoV0zHDrha6xgYKrHgh4c7+nHCnmzcxsVBdX2/
         cZZtBi2NyDBGVNA1RgUSuAHKS4YyEqDIKfjoDp/Y9JipNGZtcAPO9tahTLNJj45jbD3F
         Ou0bPtzPVyoYtb9AO8ZYNVOB1qiMgmshRJ4Is1M4IiTQDlRIlpZJ5AMOenRknPbxh4RU
         y9XdMhJeY0+OotmcYlFWJz7e8b7NjrL3FtXiexGx3MwE5FjnObm2motimSo02ZQBY65U
         9ijRmJXkq+Tr8Ka+ZTwcn7B8sOpq2vIc7pliwKcZMr8xbO2Ray+uNDFVWKFt9Ou3jwQX
         lTog==
X-Gm-Message-State: AOAM532Vyj33n/guWAHIbA6eRUfXET9ByQSi3GanluX0b7Hm6nE8PwGA
        Oy5+yrNWTcneannPkccaCUdfwZPQk+8=
X-Google-Smtp-Source: ABdhPJzPkgrB5z3on4k7ZVnheGvON5cSCI50VOe8MN8tmkfauMyRJnLG34657romvdM57OrxR7X5qA==
X-Received: by 2002:a17:90b:3691:: with SMTP id mj17mr3478331pjb.152.1592329045663;
        Tue, 16 Jun 2020 10:37:25 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l63sm18210303pfd.122.2020.06.16.10.37.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 05/10] ip_vti: support IPIP6 tunnel processing
Date:   Wed, 17 Jun 2020 01:36:30 +0800
Message-Id: <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
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

