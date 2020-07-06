Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C832E2156FA
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgGFMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbgGFMDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:03:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD47C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:03:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k5so7357761pjg.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LkLf4onCt4X9Oy2IvifDnQwfoId68EwrX36DVug1YrY=;
        b=OXMJu1Hl0517wGxA8Xf1jsXcpLSyQ42GfcSpdHbmHiPA7z0O0Z++mGe8EJyFJHdOz5
         U1iPKwyv82uZjn/lOmpfJZJYkLQ8PUhaHXnJTZdLmIiG4yKlJDOkFrJ4UWu38YLk+Fmb
         1zGr/Kp01GSkJmOxMc2k4YIR0RDvxbw6wMA9Xul5UZR8QLJa61Ek+6VThRSddPm/4Db1
         GfE3Sh30yY+tcC9mYOQdfITkOYIsoqeBmr7F4ut2klt5HjcJgYLnuSlrpY9eK92pKNbs
         H/oo04fPIY+02txpInXL3ltwdbOcUhC4Vdiya4TYFKRwUuaPjdvUDwlvhpEUZZq05/Ug
         qVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LkLf4onCt4X9Oy2IvifDnQwfoId68EwrX36DVug1YrY=;
        b=Wf5MFhdd6sGoybcxmGRrDC7aDktcIHuO1jI21a07khDCf/yFMFDQ3Nz5Dcf8v1ny8/
         vjb4I3k23dWbaQTQCbAovQ7V2MgmEvcAN0Xv6zVnIdVdEgsejZebwgMZ7a3nqN/BpV1Y
         ii34s+CWA3EeyL2/PCslyPePFl2ox8jPdFJJYU8R/s/c4oJsUEISvZBLNxkE1TRvAwHL
         MT8LJq6qXeXjcs2SBioGpWZIuxNUJ3BPLXSoArDqfE3FQ20aZtJW6HF0vitmSOYXAk+N
         QGwXIEDBMkZFHUXz/AhZzoImJldT2r+JNJU7PqHz610N1KnYK7dNzGeRDr6GuB1nndo5
         7Img==
X-Gm-Message-State: AOAM530D9Y958zWSpTipXGLBZ/lvNqo8qHbzq2CGkvjezoGx2tFJ6uEi
        ryjJQLLHGnz7L3L3o7VMJnLRRz06pA8=
X-Google-Smtp-Source: ABdhPJwXQmIZD+MkI+DslWyl4vQ7VSn/oWY4+BkSpCXIKc1qeEst7+Enf+tnlnaa2POwnqFRTyLAOA==
X-Received: by 2002:a17:90a:454f:: with SMTP id r15mr28791559pjm.6.1594036983020;
        Mon, 06 Jul 2020 05:03:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm19103402pfx.94.2020.07.06.05.03.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:03:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 09/10] xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler
Date:   Mon,  6 Jul 2020 20:01:37 +0800
Message-Id: <1c1a7746af4695650d3980cc3f995e5a37394c17.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <06ee531a2bb8936a1e5bdbb4ac3b3d07aae4199d.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
 <35a313492a554aa64b07bb4fcbf8d577141e6ade.1594036709.git.lucien.xin@gmail.com>
 <06ee531a2bb8936a1e5bdbb4ac3b3d07aae4199d.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to ip6_vti, IP6IP6 and IP6IP tunnels processing can easily
be done with .cb_handler for xfrm interface.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index c407ecb..b9ef496 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -798,6 +798,26 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.priority	=	10,
 };
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
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
+#endif
+
 static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly = {
 	.handler	=	xfrm4_rcv,
 	.input_handler	=	xfrm_input,
@@ -866,9 +886,23 @@ static int __init xfrmi6_init(void)
 	err = xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipv6_failed;
+	err = xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
+	if (err < 0)
+		goto xfrm_tunnel_ip6ip_failed;
+#endif
 
 	return 0;
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+xfrm_tunnel_ip6ip_failed:
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
+xfrm_tunnel_ipv6_failed:
+	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
+#endif
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -879,6 +913,10 @@ static int __init xfrmi6_init(void)
 
 static void xfrmi6_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
+	xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
+#endif
 	xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&xfrmi_esp6_protocol, IPPROTO_ESP);
-- 
2.1.0

