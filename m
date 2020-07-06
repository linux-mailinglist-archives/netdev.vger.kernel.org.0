Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7C2156F5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgGFMCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgGFMCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:02:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08855C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:02:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w2so17477579pgg.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=w53TPZNSHS8/mY8h2BvobcIqB2iPrMJYYDNKXI9sDwE=;
        b=U5MxSXWKl2v3aIXuN46PSXJy/LtCb6D812lUOpdPYNzgemMteg1PufpdufWmuvLP5Q
         f66mgP4FhLzBjh21FQnSyGefoLnLmgQlD7kCdT6wpWpwiYcmRPJkiO5LgXA6Zz3Qk3XU
         vmLKcQB2CqzQpUdwfNCD3G29OTjkdVUMPi1zZZOb/E+apVWHESkatgIxYMEpRpHSxLe8
         7s0W7L+weCPk8exFejXPfaEYrbXsKXnG1Yhv3Wc7xq/cV5UfMEMJekWiyPBaPVx36+eN
         Yt4HXcPzUSaIJVxTkdFb1C19shiCjRqsRtWpT8PfOX1wDTToqijAtPB3UhnzBesrypDI
         8Rtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=w53TPZNSHS8/mY8h2BvobcIqB2iPrMJYYDNKXI9sDwE=;
        b=eXkgvdLHH5/8RbtwDiWJzuRCwdWxdpx8BvhMzb36v5qVpqu0XnVy4+s7GcsxcYwoth
         beMxODGBdWvxTXmflYfB7/zpdpYih4r5bdgDLuZiSqRn0g6vcZETdDO+gUYYtM+aflty
         fdLa3wkhxgWhIneVwsa/cN4dLIP6Pla4Scb1xko48KB50U2mrtoCDF5asmHw7UdoTnpo
         oT566cE3R3TdMqjAhEPJIJzSipgqjqyrDVafDvbtWEkUvzuTy6EITJpqVdYRfD2TSdIk
         R5A+i1duWraSI9evAWlqZm/tiqaxjVlNsYERx6unEtZDkVsww9X6b6mOcy/c31PdDhXv
         ZiVw==
X-Gm-Message-State: AOAM533Hb6dNgTAmVbwkMyEjfYOURHLHQ61WR7Zhjkf9HQUEXAHOrAyR
        AFSNIwzr/HeBvMe6UNCp4/jxE6cLbU8=
X-Google-Smtp-Source: ABdhPJzFI429Ol2TRE5RFwCyPmIO0c2hBJaYHjIILzsnexeEpCHsEVOY9KXPreZeg0tXBLuSFv4Izg==
X-Received: by 2002:a63:d605:: with SMTP id q5mr4303480pgg.344.1594036940290;
        Mon, 06 Jul 2020 05:02:20 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m31sm19223510pjb.52.2020.07.06.05.02.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 05:02:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv3 ipsec-next 04/10] ip_vti: support IPIP tunnel processing with .cb_handler
Date:   Mon,  6 Jul 2020 20:01:32 +0800
Message-Id: <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
 <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1594036709.git.lucien.xin@gmail.com>
References: <cover.1594036709.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With tunnel4_input_afinfo added, IPIP tunnel processing in
ip_vti can be easily done with .cb_handler. So replace the
processing by calling ip_tunnel_rcv() with it.

v1->v2:
  - no change.
v2-v3:
  - enable it only when CONFIG_INET_XFRM_TUNNEL is defined, to fix
    the build error, reported by kbuild test robot.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_vti.c | 51 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1d9c8cf..68177f0 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -91,32 +91,6 @@ static int vti_rcv_proto(struct sk_buff *skb)
 	return vti_rcv(skb, 0, false);
 }
 
-static int vti_rcv_tunnel(struct sk_buff *skb)
-{
-	struct ip_tunnel_net *itn = net_generic(dev_net(skb->dev), vti_net_id);
-	const struct iphdr *iph = ip_hdr(skb);
-	struct ip_tunnel *tunnel;
-
-	tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex, TUNNEL_NO_KEY,
-				  iph->saddr, iph->daddr, 0);
-	if (tunnel) {
-		struct tnl_ptk_info tpi = {
-			.proto = htons(ETH_P_IP),
-		};
-
-		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
-			goto drop;
-		if (iptunnel_pull_header(skb, 0, tpi.proto, false))
-			goto drop;
-		return ip_tunnel_rcv(tunnel, skb, &tpi, NULL, false);
-	}
-
-	return -EINVAL;
-drop:
-	kfree_skb(skb);
-	return 0;
-}
-
 static int vti_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
@@ -495,11 +469,22 @@ static struct xfrm4_protocol vti_ipcomp4_protocol __read_mostly = {
 	.priority	=	100,
 };
 
-static struct xfrm_tunnel ipip_handler __read_mostly = {
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+static int vti_rcv_tunnel(struct sk_buff *skb)
+{
+	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
+	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
+
+	return vti_input(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr, 0, false);
+}
+
+static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
 	.handler	=	vti_rcv_tunnel,
+	.cb_handler	=	vti_rcv_cb,
 	.err_handler	=	vti4_err,
 	.priority	=	0,
 };
+#endif
 
 static int __net_init vti_init_net(struct net *net)
 {
@@ -669,10 +654,12 @@ static int __init vti_init(void)
 	if (err < 0)
 		goto xfrm_proto_comp_failed;
 
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
 	msg = "ipip tunnel";
-	err = xfrm4_tunnel_register(&ipip_handler, AF_INET);
+	err = xfrm4_tunnel_register(&vti_ipip_handler, AF_INET);
 	if (err < 0)
 		goto xfrm_tunnel_failed;
+#endif
 
 	msg = "netlink interface";
 	err = rtnl_link_register(&vti_link_ops);
@@ -682,8 +669,10 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
 xfrm_tunnel_failed:
+#endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
@@ -699,7 +688,9 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
-	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+#if IS_ENABLED(CONFIG_INET_XFRM_TUNNEL)
+	xfrm4_tunnel_deregister(&vti_ipip_handler, AF_INET);
+#endif
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.1.0

