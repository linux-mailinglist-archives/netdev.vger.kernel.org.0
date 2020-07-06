Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623B82156FB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgGFMDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGFMDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:03:12 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6B9C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:03:12 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w17so795790ply.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OW56BcBKRzQmxXIVzyvR5AhxWFM4wme0wTTPxQ+qR7M=;
        b=kaISpfV622wiDX3wTw/pzQY4jbosru61dzepTCczHWq/eQAXAIsKln2BYiGPg95WxA
         q1oNh1CABwIQ5PjGPiSmwBRYtzA5/nABviLUI7jtibNyabv86uKCviTekB708xS1IM5J
         IQw7Nv+FeRBm+aEQV75ch3L40X5xtjkNcGJHxOkbkB4X/KXcTO6s9TxAKpwoQu9EI6hF
         tKPX+QFC5vCYa0DK9wgcuPjPSVdvngHtTNQ2gR9hG3ynwaVOMdX4nAJSFoNNmW8tCoJ6
         cGCwEC5k+tuABmpeNkGA2V5K7anrSsd+2W+jfQWFQYgsohJNIekzhuzxpD13giUtzk+S
         BaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OW56BcBKRzQmxXIVzyvR5AhxWFM4wme0wTTPxQ+qR7M=;
        b=Y4pO1WTp9zZXFPW/CwaJgKqDXm0BKxOWyFcPkHYNs9nxTea0UJnlhG3m8rni5Gnu8Y
         kz7ETXX8muivAkHk7ilz10oSPT+hZsv7f5VWtDHq9/01gF4b2iY/GTbv77VlPsBX+W3E
         qBoy5eVEeVFa68jlK7CxCsd11QQ0tkRH0LvgJT9Rqvp2SDWPiLKATYBUuiPMDfuuBNeD
         QuICiwPZy1meXzHH7zxEykMcr+sGteVLlyhZ4vcF6CHJZtn4ihHzrDRnCd9dEDQ4t0D+
         pWvq7TGZ6vvpk53sBdaEFc1YD/qPCys4edfFQJ6TinMfo0M4fAfC3P/x1Nwf3JQCeINU
         cv0w==
X-Gm-Message-State: AOAM530REq/bGBlex0PFOp39jdQGJ+pc50e89rPz0z/v4hRfM4z1mv41
        NiZiBWTsljRw4C627fsgB/+IQ130YrA=
X-Google-Smtp-Source: ABdhPJyyPRDkZ14uLYnDUU84fBOoMBlnyF9gIimWOcvA0lAzl5aPi9EZ1M0UwUASR9BBwrUXyfh7AA==
X-Received: by 2002:a17:90a:35c:: with SMTP id 28mr40193085pjf.63.1594036991768;
        Mon, 06 Jul 2020 05:03:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ng12sm18550427pjb.15.2020.07.06.05.03.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:03:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 10/10] xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler
Date:   Mon,  6 Jul 2020 20:01:38 +0800
Message-Id: <3df63a4d55257604fe5bb9e2ab01269b59e05ba4.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1c1a7746af4695650d3980cc3f995e5a37394c17.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
 <35a313492a554aa64b07bb4fcbf8d577141e6ade.1594036709.git.lucien.xin@gmail.com>
 <06ee531a2bb8936a1e5bdbb4ac3b3d07aae4199d.1594036709.git.lucien.xin@gmail.com>
 <1c1a7746af4695650d3980cc3f995e5a37394c17.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to ip_vti, IPIP and IPIP6 tunnels processing can easily
be done with .cb_handler for xfrm interface.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET_XFRM_TUNNEL is defined, to fix the
    build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index b9ef496..a79eb49 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -842,6 +842,20 @@ static struct xfrm4_protocol xfrmi_ipcomp4_protocol __read_mostly = {
 	.priority	=	10,
 };
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
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
+#endif
+
 static int __init xfrmi4_init(void)
 {
 	int err;
@@ -855,9 +869,23 @@ static int __init xfrmi4_init(void)
 	err = xfrm4_protocol_register(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET);
+	if (err < 0)
+		goto xfrm_tunnel_ipip_failed;
+	err = xfrm4_tunnel_register(&xfrmi_ipip_handler, AF_INET6);
+	if (err < 0)
+		goto xfrm_tunnel_ipip6_failed;
+#endif
 
 	return 0;
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+xfrm_tunnel_ipip6_failed:
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
+xfrm_tunnel_ipip_failed:
+	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
+#endif
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&xfrmi_ah4_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -868,6 +896,10 @@ static int __init xfrmi4_init(void)
 
 static void xfrmi4_fini(void)
 {
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET6);
+	xfrm4_tunnel_deregister(&xfrmi_ipip_handler, AF_INET);
+#endif
 	xfrm4_protocol_deregister(&xfrmi_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&xfrmi_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&xfrmi_esp4_protocol, IPPROTO_ESP);
-- 
2.1.0

