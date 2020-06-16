Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255101FBD28
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbgFPRiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 13:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbgFPRiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 13:38:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D765C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:38:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id jz3so1752744pjb.0
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 10:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=fFbwu3WnOzX8ze6qDG9nzUYaHNDx6hz0Hk1ubojYqiE=;
        b=a7txWt3X+Dhrk5wOoM8Ei2dAVUkL/kW0HR4/p4Pok+K02osqyZzWIwj1HmY06pVjd5
         GObhIVDhYH0mWTMCfRbaJazYybZgMvgoTlMctFdAaz+ZFdTc1pvRNF7p6buGYAcCLOkj
         5xh8YyNvp5V9Er8yH6cMIquy/pQ1kbiP7rB3gn3GIPMIL/JQ9Qoz6ENyh2p4wmlesaxo
         vltczcydUPriuA/rf7D+GUMwuXuPqZlHMDiPZjaE2u528acDgXayNNtmqrWRKBS3/3Bf
         xNvSzoPMQbG9cr6Y7Jflcq4P/FwFTEa69klsHMlRdt28ud2v5kcxXVUSvTwNNoga4Aun
         XQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=fFbwu3WnOzX8ze6qDG9nzUYaHNDx6hz0Hk1ubojYqiE=;
        b=CKyvAoH+UogMXnMActXxTNvsRQvlzDG2MZ4tULKWsNMdwhWlMG8jRyrbrFZ0iJNAUN
         sCxdvDVmAOxFVkERywVzeCEgF2PTfVeYGEovNkMkbUabC0VI2gRCtWEehlsQuriabfoB
         ssICfUrSigxtNkFQnOFeZxee16y4uy5w3BGNbCGGp5spwaoybLIAncea0QZa18JPiqjU
         4ccfPRnsrUzpqJ2z7h2J7xAVGLbl1C3RqM/Ssj/M1Sude9ZZuXaDWF0H7czGuv8o9qeV
         UhwVxqknPIn44g/5NEaAyVHrbh+cCp3T6AQl+YKwnTaqfK/U4vXfCOM2yAu3Y92a60eM
         BYWw==
X-Gm-Message-State: AOAM53100Og3lAQGHsGKn6xENG4+na2Q3nGYltRjc3kEv7nrOM5XbZlo
        NVBo6NfQrn8/rgC+0xnKb5WB0ICCitk=
X-Google-Smtp-Source: ABdhPJwNmTWFfbSNtU622euLEdPvtKMjhcUdgcr6Rn58q9OavcYZF9V1hVZEXU6LSe/5kY7KyBHkDA==
X-Received: by 2002:a17:902:d902:: with SMTP id c2mr3199019plz.194.1592329079583;
        Tue, 16 Jun 2020 10:37:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a3sm17608683pfi.77.2020.06.16.10.37.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jun 2020 10:37:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 09/10] xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
Date:   Wed, 17 Jun 2020 01:36:34 +0800
Message-Id: <4fce36d122e92ab4165d5b7a380c231e9abda598.1592328814.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8edff44e79a29474a82406d2f2f395c1229f0993.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <4ad2ff7658148645d2e1947d659d11061013c336.1592328814.git.lucien.xin@gmail.com>
 <cf734a0499457870c5d0fe493a83760aa1bf76c1.1592328814.git.lucien.xin@gmail.com>
 <af54ae84fe9a806e40050e815c975a36cf8e2db9.1592328814.git.lucien.xin@gmail.com>
 <870c43283bd6bd6c3b583c05ebc757879676edcd.1592328814.git.lucien.xin@gmail.com>
 <8edff44e79a29474a82406d2f2f395c1229f0993.1592328814.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
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

