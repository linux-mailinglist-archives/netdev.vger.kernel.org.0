Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A572620EFA4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgF3Hhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3Hhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D683BC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e9so9537182pgo.9
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=WPSbLQ681FD6gaLQ+/C+OaDfV02GtaInJMLuiNhU08E=;
        b=N/jZJthXJZ89BrhuV47Jjo/FmXgx3sOwQYpKrdn+3yfWtgzKVEdmunESs2Hhgxs5gA
         Xpfb0YYLymnzkraiaw3GSDiRYKsZmhLkx5dtYrzs1Jl1ejHQfBDuzGkAYqtuZPqCAqkf
         aDCZZa9iC4fjpeEWVRNxY+0RvCM29e7DWCmhEnP6Q5ldM8/qqF1w7ViPvLNt+HYVfTfQ
         fA7i8jeQCANmE8s0/4MmuWwAv8Sw1djDzrBtmUy7fmzB5ckwWxVn2VobLy+g1PMxQvfP
         fs/MHSd3ypBS+6OpEhozlpsMd/zE5dmmbuVUtX8EtYEFu1nj7dkfLILJbR14f1YH+Le4
         rhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=WPSbLQ681FD6gaLQ+/C+OaDfV02GtaInJMLuiNhU08E=;
        b=SQC8s9cmkthbOK12ZwqDJYycbALOHN8l/CAt4kd9WfWnfjumhrME7iL2W+EVrpCclN
         dLlSyTf+R7JTf8+YEmDOnQigpADclRu9iqpPIqOqYeuQGFJSPCr/+t9DFqI+CbrXxWfj
         AHkd/L7kKzodfWMIhNTkLOhEM61b82Y/k9+LEzc3/bYrD4w2+1Ai8R03TleCT54WSzIa
         xhlv2XDygnZc8yM7WxlaAqsTonIpW8dWXd2HdNYMt1/V/u1QVeHWJ4/WUTdqnXoNEJ2E
         xlzRoiAGjyw2cP2ulhgSdC+pw9LjT4Xe23Cr78eFv82/iutW5goZXtvcZC0ky1MqMbXn
         feQQ==
X-Gm-Message-State: AOAM533SNCLZYju8yPYxCL8p057TuQQj9XCFdqVWjw1he7KwVfM0MaUl
        buJm5SU0avnb04H3DCjEsLgYvXsf
X-Google-Smtp-Source: ABdhPJyXK0dx6D6dfD6IMxP8+ZXSuou5j4KUP8SfedoCdMM1B1Yz9gVhKiaXTYxsfnEv5Yta/pImMA==
X-Received: by 2002:a62:7e90:: with SMTP id z138mr16382870pfc.292.1593502654140;
        Tue, 30 Jun 2020 00:37:34 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l12sm1605202pff.212.2020.06.30.00.37.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel processing with .cb_handler
Date:   Tue, 30 Jun 2020 15:36:31 +0800
Message-Id: <1b18c11f965775fed2647eb78071af89177a70b5.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
 <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
 <929721f47bfba5847e39897be8aa2d1620370592.1593502515.git.lucien.xin@gmail.com>
 <b29f04cd51bc17c22e6d34714afb3e4c17137e95.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to IPIP tunnel's processing, this patch is to support
IP6IP6 tunnel processing with .cb_handler.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1147f64..2161648 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -343,6 +343,17 @@ static int vti6_rcv(struct sk_buff *skb)
 	return vti6_input_proto(skb, nexthdr, 0, 0);
 }
 
+static int vti6_rcv_tunnel(struct sk_buff *skb)
+{
+	const xfrm_address_t *saddr;
+	__be32 spi;
+
+	saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
+	spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
+
+	return vti6_input_proto(skb, IPPROTO_IPV6, spi, 0);
+}
+
 static int vti6_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
@@ -1218,6 +1229,13 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
+static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
+
 /**
  * vti6_tunnel_init - register protocol and reserve needed resources
  *
@@ -1243,6 +1261,10 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+	msg = "ipv6 tunnel";
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto vti_tunnel_failed;
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti6_link_ops);
@@ -1252,6 +1274,8 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+vti_tunnel_failed:
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
@@ -1270,6 +1294,7 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&vti_esp6_protocol, IPPROTO_ESP);
-- 
2.1.0

