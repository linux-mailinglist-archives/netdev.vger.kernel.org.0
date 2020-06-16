Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9271FBD29
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgFPRiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbgFPRiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:38:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46B6C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:38:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 64so9826321pfv.11
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=WKu9u3hv9rVR67uUMDQunlL+aOETxRhcJUtcJ2h+N9s=;
        b=MftSNA4kGgYMmB8RmmgEPDnBmM+OpO2YOmrGz4zciaUaGtoRRpLP+JKaBAVwM4g/c2
         tlubfdSba0NR+pgX8cJyMvsswO+XCqQUKCEAhc9z573ea7NmDQGsFsVGZf0hXw2xNXnZ
         t8GYns+GVtb4EPKmQQ7WDxM3VZjt3OTPvxOciVh/zjKgVPxfS2U1HD6Xo3E12Chop+Ss
         1KZvHeW+Po1B0vZ1Vyfdge/NwlOS9L4r1a4qsTvpK0089+i634uXKmeu1FsDpfazL6WG
         W+jCrO1cSiGe72zEvGBhEy5m0+OtrDr+we2tkEhbBIr+/0+8bAZalC5nZD97bHolA4wP
         fqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=WKu9u3hv9rVR67uUMDQunlL+aOETxRhcJUtcJ2h+N9s=;
        b=JxzyhnoUcBkITbPo+2j78WQJHFK/htSPa2hII7VEQlNRu5nd52bX3iph5IyuiRpchs
         VF1Bo64VwZhxOhYJr/7Z4kmBzEQAhjNZluLgmiSDOkpqFbk+4VynzkH446HADFAKeblg
         dWTQq4ycPvF6rQ7uG0qAlC3819d6C+bFgpJmMf70/ESxWBUC/fyz/R3sr4NmoiJvkBkV
         YeuRFltm3ItXyfyJTawA+byv+b+2EfRTmogPWhSsW3zjxKOGzxipSsXgTGYAQ4ZzmgsC
         pChX1nYgXCIuTp1KsPSANbgyEAq2gDCUI1/LII4SkBLrXGW5760bULQfQdR4dsooOweA
         7Vjg==
X-Gm-Message-State: AOAM533t1z5WXxBwLmz9GaDZiJ+/e6rP7VOuRblI7Bd7kKihqt6siKD9
        Y7PuoEBILi4siCiFDdZ7FPIPTJcY8YI=
X-Google-Smtp-Source: ABdhPJyuERLkcVxxKipEF+uTaomcqCDrSNgqbs4MWI5X1ozlYZCrlnGkOVi/QG0WslriANYgIjkPZw==
X-Received: by 2002:a63:1305:: with SMTP id i5mr2881531pgl.140.1592329087944;
        Tue, 16 Jun 2020 10:38:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g19sm17491517pfo.209.2020.06.16.10.38.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:38:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 10/10] xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler
Date:   Wed, 17 Jun 2020 01:36:35 +0800
Message-Id: <f099ad86380d396cfa836c409fa55d3c7518e684.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4fce36d122e92ab4165d5b7a380c231e9abda598.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
 <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
 <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
 <870c43283bd6bd6c3b583c05ebc757879676edcd.1592328814.git.lucien.xin@gmail.com>
 <8edff44e79a29474a82406d2f2f395c1229f0993.1592328814.git.lucien.xin@gmail.com>
 <4fce36d122e92ab4165d5b7a380c231e9abda598.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to ip_vti, IPIP and IPIP6 tunnels processing can easily
be done with .cb_handler for xfrm interface.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 7be4d0d..0ddcd57 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -840,6 +840,18 @@ static struct xfrm4_protocol xfrmi_ipcomp4_protocol __read_mostly = {
 	.priority	=	10,
 };
 
+static int xfrmi4_rcv_tunnel(struct sk_buff *skb)
+{
+	return xfrm4_rcv_spi(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr);
+}
+
+static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
+	.handler	=	xfrmi4_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi4_err,
+	.priority	=	-1,
+};
+
 static int __init xfrmi4_init(void)
 {
 	int err;
@@ -853,9 +865,19 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_protocol_register(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
+	if (err < 0)
+		goto xfrm_tunnel_ipip_failed;
+	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipip6_failed;
 
 	return 0;
 
+xfrm_tunnel_ipip6_failed:
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
+xfrm_tunnel_ipip_failed:
+	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&xfrmi_ah4_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -866,6 +888,8 @@ static int __init xfrmi4_init(void)
 
 static void xfrmi4_fini(void)
 {
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&xfrmi_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&xfrmi_esp4_protocol, IPPROTO_ESP);
-- 
2.1.0

