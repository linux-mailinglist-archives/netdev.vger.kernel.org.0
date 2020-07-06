Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAD72156F7
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgGFMCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGFMCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92112C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:38 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so7357298pjg.3
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=9YdHduHNMUMP2GTQhHhxL/r7tKKzarkw7/jHOzwulAw=;
        b=NBV7E/TxuSBopkmR7usWrMijubE2f8eZ3QxBmxtsUuQg3rLjV9RFRQmUwUDQoi+Dp0
         TfbpHB5LcILSijsW+z7io3aKsmujHq1Csc2yK7fOD+0tDPlrGjJpfua2pQ9IOI5HLGye
         ei5lCsjKpC8bmqg57RtFXCuWGlRZ4OADh/+/2yjqvI1eqPB/se9aY5sZP7hyzBvRt7Fv
         Zfn4GmGmrkAg3CvM+N+xO8UhtRCJuI3N77m4cBGVadZO7xL1H7dZy+V3v1LuaeGX8c2n
         cbCvbpqeifoSediVLeINKFTpAgB2SyR3tiuHDYqwq2JDh73oaNt0qqVd9yqbZQomKXJ8
         qa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=9YdHduHNMUMP2GTQhHhxL/r7tKKzarkw7/jHOzwulAw=;
        b=kMTp+vNTQpExeHqtcTU1cacjRF1y9gtEsAh8cjmdcmhhWpBe0nPJ9Kst33GQceV/K7
         4CZdpQu7fklnpocAFaoMOybdQ2Y8BY/juewpXD4+CgVlAGmE2uocHWp/Rw05v+tuEnNo
         7daLxCuijamc5u613ZVsWV5N8zqMuky1c0cvFOqT8FeBmD7HSGlHJ2kKRhRpqH3HsR3j
         7c6Tjb5ndTZF7g7bXtlxmYHrCv+eVM6wzzQE1mVtQs/3xM7vB2KJ9p/e78G3Xf3+hwvn
         fIADo06gFVk1A3P4hpEMoH4PJhang3dYM0t4UBH3W0BEfOpzdani73DbWwRDOQwrzUTF
         8pvA==
X-Gm-Message-State: AOAM530J0SRQ+I8HbzR+WDarx76Ta9QnaPob1l1p537wYDos4Kd6mWM7
        +MT2UnOLrUzl8xYUYrtyquH3TK02du0=
X-Google-Smtp-Source: ABdhPJxi0xS3Puyuz95cSn0jwltrHo/t0eMqF3xtWdCG3GnFyE80FENkIIMKjRXYYw0qAdA3W4nezQ==
X-Received: by 2002:a17:90a:2427:: with SMTP id h36mr26781444pje.229.1594036957568;
        Mon, 06 Jul 2020 05:02:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h6sm19238231pfg.25.2020.07.06.05.02.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel processing with .cb_handler
Date:   Mon,  6 Jul 2020 20:01:34 +0800
Message-Id: <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to IPIP tunnel's processing, this patch is to support
IP6IP6 tunnel processing with .cb_handler.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_vti.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1147f64..39efe41 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1218,6 +1218,26 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.priority	=	100,
 };
 
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
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
+static struct xfrm6_tunnel vti_ipv6_handler __read_mostly = {
+	.handler	=	vti6_rcv_tunnel,
+	.cb_handler	=	vti6_rcv_cb,
+	.err_handler	=	vti6_err,
+	.priority	=	0,
+};
+#endif
+
 /**
  * vti6_tunnel_init - register protocol and reserve needed resources
  *
@@ -1243,6 +1263,12 @@ static int __init vti6_tunnel_init(void)
 	err = xfrm6_protocol_register(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	msg = "ipv6 tunnel";
+	err = xfrm6_tunnel_register(&vti_ipv6_handler, AF_INET6);
+	if (err < 0)
+		goto vti_tunnel_failed;
+#endif
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti6_link_ops);
@@ -1252,6 +1278,10 @@ static int __init vti6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	err = xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+vti_tunnel_failed:
+#endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
@@ -1270,6 +1300,9 @@ static int __init vti6_tunnel_init(void)
 static void __exit vti6_tunnel_cleanup(void)
 {
 	rtnl_link_unregister(&vti6_link_ops);
+#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
+	xfrm6_tunnel_deregister(&vti_ipv6_handler, AF_INET6);
+#endif
 	xfrm6_protocol_deregister(&vti_ipcomp6_protocol, IPPROTO_COMP);
 	xfrm6_protocol_deregister(&vti_ah6_protocol, IPPROTO_AH);
 	xfrm6_protocol_deregister(&vti_esp6_protocol, IPPROTO_ESP);
-- 
2.1.0

