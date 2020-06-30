Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077F520EFA7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbgF3HiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3HiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:38:00 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C73AC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:38:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so5624519pje.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=fFbwu3WnOzX8ze6qDG9nzUYaHNDx6hz0Hk1ubojYqiE=;
        b=jyv1aWhzimC6326JyUvIW2Ee+7hCLoH/QtKkH8wRR4wjqehOCFguvKT1MJxUHbRzWA
         EdI2OIAIjeqqiAIRe+LPfld8YO8UutYOy4KhYuLVeX11eyI3Lbh7LwEOoLkYjuxQu6fd
         7+s2bFbCWVm/Qk03eUxjW7HTxZ5yhab/Xx/QVaG9fzlnQGzgDLmFBT7mvCLC9y2rvcd6
         UGCOhgXt5mBk7dyUFUvSUq8B0ElA/rSdc1fCOex/iDHFHSY54ldTeEcWl6Lbl0Nfpvlh
         UHzf4R0KPDWaIfYzh4dpkUWxFzwi113CVJ05gdI81H05VnCLikSgvX/BtWHtyatwrgwK
         J97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=fFbwu3WnOzX8ze6qDG9nzUYaHNDx6hz0Hk1ubojYqiE=;
        b=e/oolM3rYUrDeGC9xk1r4ebS8FbxM9+urOMXEwl09m4uWh1A7DaP+Jqvb+vFLMMSD9
         MVSWh/w5WnZc7wxeEXrmuxacOpcqgFrReS5roVi0J+uH+iEVWmcu8OZMbfCfykwIXX+D
         0PeMT4sFj0+KyAypsh0YHjlEqvCPXlPt2XdVvsmkBw2rPtgS97INisiHsKeKRjahZKWE
         X5EGTjasnLCZOrJM5kqOyiUDEufQdNX3bWk+1aepenEkqwMpdPC871iyUC7592FomnNK
         avebLQnkBBqo2JGdgWOQrBKbMsriMu01XTvQEMZPQdMt3HrKdxKc0JSR1p7GeJpMyVKq
         3YIA==
X-Gm-Message-State: AOAM5323aV08oQF0l4+WXf2kqgovBh8p0eqcijT1LSl5gaeVqOB261tI
        ckSMc+0Pl18BYiYLWerfchhTSMu4
X-Google-Smtp-Source: ABdhPJyH8+iST47KOwH/wez5NJ3YKPIrkAsBV26uXAZAg2j8WJEHTGMfkcD8fU9PwEslEa11eDX59g==
X-Received: by 2002:a17:902:968b:: with SMTP id n11mr16282538plp.331.1593502679395;
        Tue, 30 Jun 2020 00:37:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n4sm1728373pfq.9.2020.06.30.00.37.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 09/10] xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
Date:   Tue, 30 Jun 2020 15:36:34 +0800
Message-Id: <c13ffdfb739d487a415897b72bf8eee6981830c6.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <088d28eeaf2ba1d7d24cd112a813c57583c5547b.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
 <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
 <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
 <66b5ef2dc7245ab1707ca8119831e58c26a552a0.1593502515.git.lucien.xin@gmail.com>
 <088d28eeaf2ba1d7d24cd112a813c57583c5547b.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to ip6_vti, IP6IP6 and IP6IP tunnels processing can easily
be done with .cb_handler for xfrm interface.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index c407ecb..7be4d0d 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -798,6 +798,24 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.priority	=	10,
 };
 
+static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
+{
+	const xfrm_address_t *saddr;
+	__be32 spi;
+
+	saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
+	spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
+
+	return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
+}
+
+static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
+	.handler	=	xfrmi6_rcv_tunnel,
+	.cb_handler	=	xfrmi_rcv_cb,
+	.err_handler	=	xfrmi6_err,
+	.priority	=	-1,
+};
+
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
 	.handler	=	xfrm4_rcv,
 	.input_handler	=	xfrm_input,
@@ -866,9 +884,19 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipv6_failed;
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
+	if (err < 0)
+		goto xfrm_tunnel_ip6ip_failed;
 
 	return 0;
 
+xfrm_tunnel_ip6ip_failed:
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
+xfrm_tunnel_ipv6_failed:
+	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -879,6 +907,8 @@ static int __init xfrmi6_init(void)
 
 static void xfrmi6_fini(void)
 {
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
 	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&xfrmi_esp6_protocol, IPPROTO_ESP);
-- 
2.1.0

