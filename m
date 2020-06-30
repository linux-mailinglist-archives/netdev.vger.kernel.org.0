Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C7320EFA8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgF3HiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3HiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:38:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C22C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:38:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 67so4982239pfg.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=WKu9u3hv9rVR67uUMDQunlL+aOETxRhcJUtcJ2h+N9s=;
        b=LP7C0K13m4I5eeTH1bs8C0LEILfMRT/+STSd8m5A57rNmF8Sia+VEfDEEsjbZXzQyD
         Ikql/PSJS1pCBd7s8tIbbP2MJcC1Tv8V+7mKHrLraI1meG3OzGTvrYGzzXTuGboFWxsm
         hDOuPToqAFsDbuR/NigwPyIJ60EiupxjbiCdL376sjQiF81q+oHtnnwabRoUx8ksYcR5
         9fCgGNIFvCiw/LMqyMiy2XphosWi7zvxrNf0an7p+Y06V9EtXZcVEspjHaoBqQ/B7FRA
         CG69Gax/qRbMSCgOCO5S/7lmNeEQitpzo6iQIpx0q38qGu4Q6XaKMyaP+ymLkELz6EnU
         rAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=WKu9u3hv9rVR67uUMDQunlL+aOETxRhcJUtcJ2h+N9s=;
        b=Yg1jpnnpiYOKwrr3dSKXBKQU7ynluTNOO7DgaXVOx0H7pZf04co//QEaG/xWDPW+19
         WdSaWN5C7B8u8oTbdrRakgK3w7osp7gLwHup1oNniWsknGmyouErlsZQ4DWchkPhC+fE
         rd7A/e2BJ+LdnN6aMboCGR4j71YWKrRd3PnvqWrC98x6+9lE8Mwvx0tZzI0GipWeIfYV
         +bhwkWYQpjFYAZoFd9lEsT5kReF1X8Sv9KGSoi9ok5wF4HD8zTOcmb6004KoK0/qzECE
         OXyNshs9/wR2hlg5yqgS7LIjypP6Vkp5QP7cb5fALRM6Jp82QUpj3UK5q+kQwBBa4dA/
         h/zA==
X-Gm-Message-State: AOAM531CKDoJFZ9M7WQGCWfRaA+raA3ZLzVEMYA0v0q//X2BgwI83Bxq
        7uCCCiBpaisAaICh6n4DqQJPF5Qv
X-Google-Smtp-Source: ABdhPJxWRbQ0WbSl9HopXBbIyIbxr95U5ey4C0nBQ68uz3QRy8gXpMO8HG8jvlcFr8r2/hHaTKZcww==
X-Received: by 2002:a63:d143:: with SMTP id c3mr13627518pgj.306.1593502687845;
        Tue, 30 Jun 2020 00:38:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w135sm1713033pfc.106.2020.06.30.00.38.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:38:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 10/10] xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler
Date:   Tue, 30 Jun 2020 15:36:35 +0800
Message-Id: <6fe4c44a598a64b55e08947851995e6d0aec6a93.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c13ffdfb739d487a415897b72bf8eee6981830c6.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
 <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
 <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
 <66b5ef2dc7245ab1707ca8119831e58c26a552a0.1593502515.git.lucien.xin@gmail.com>
 <088d28eeaf2ba1d7d24cd112a813c57583c5547b.1593502515.git.lucien.xin@gmail.com>
 <c13ffdfb739d487a415897b72bf8eee6981830c6.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
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

