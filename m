Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4725E20EFA1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 09:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbgF3HhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbgF3HhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 03:37:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF34CC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id x11so8134499plo.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 00:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=j1nGXlbqvMmXMEB+bataUUgoGnu0PT4YVOVTlEIPRZU=;
        b=Kw3weODA4nmVLFGV2xahTUVm+kuLqHTlcyTwZHtqr/qk6fOnHs6qAGex+G2/X8PvT2
         8Bfq7BF8hoWzk9KAWnOxU1Js+ThIZZFfsjJom+Rec9Q6y/Dc8tgAIAz/4ixCM79DXhjg
         sIAJoWv91M7Nk+GnqFdiA9Pa4BvYR2Udt6MI4s/wgoSJ29hdpunkP75st9HiVpnYYwvL
         2vVMKLwFYoBoygg8jW00YE0cJQEACSuon29mrKoVrPUWp6wDxeCjJMf77Y2ucbWwK5pE
         YWIkveMiIXU6kKJcQaXHNh4Hqi3Oa3r2xOgTg07SJ/ojfLPei68P4GijGz6CWHQgEmZF
         raGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=j1nGXlbqvMmXMEB+bataUUgoGnu0PT4YVOVTlEIPRZU=;
        b=rDQozfEGVMDiBmb+53z8V15WGsfOESTkJlmnPpIGfojzHxZ2Y+15SOGCSXSL/lp/P3
         Gx/fqD1+sPgYy4ofb0knpKtNhggL16Hw/iFW6L2ZRvJb5TWarwdIsp6HQQ0w7Xelxhbg
         jTrDFtJ9oLZvRWRllteTvxW43E2UZkkZzkF8JFOM5+Q/dh/OGEzc3Bpi14yOUIE/MQH8
         SREyjO+yZuGuuQD08RUWtCwBMT17D1CgCYSvZTAHcop9PU+F0KXYJUfO/QysGKPzGmxJ
         hKpz+jE95xyKnfqoHirFlg26e3E6wi4wLuMgcpJLXf6pAhtxoVHjem/8clH8+/SzuwBe
         UK5A==
X-Gm-Message-State: AOAM531qQadjIRpmImY+ZmfpYuah0dh0G+fYTmSgD92dtSRfylTTc0tH
        VxJhcXgmFNJX9RPNrdHi6gXuOT/B
X-Google-Smtp-Source: ABdhPJx1NGM1W6vd5FITRFqdhO3VmQksRnrtR/J/EM/B1M8yreKR+y80Y4KZKokFgeXOjh3lL5XPbg==
X-Received: by 2002:a17:902:a60e:: with SMTP id u14mr17366011plq.238.1593502629004;
        Tue, 30 Jun 2020 00:37:09 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i196sm1790834pgc.55.2020.06.30.00.37.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jun 2020 00:37:08 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec-next 03/10] tunnel6: add tunnel6_input_afinfo for ipip and ipv6 tunnels
Date:   Tue, 30 Jun 2020 15:36:28 +0800
Message-Id: <2bc9f58f60183a7148fad5d8bc954924f02374f8.1593502515.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
 <348f1f3d64495bde03a9ce0475f4fa7a34584e9c.1593502515.git.lucien.xin@gmail.com>
 <b660e1514219be1d3723c203c91b0a04974ddac9.1593502515.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1593502515.git.lucien.xin@gmail.com>
References: <cover.1593502515.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to register a callback function tunnel6_rcv_cb with
is_ipip set in a xfrm_input_afinfo object for tunnel6 and tunnel46.

It will be called by xfrm_rcv_cb() from xfrm_input() when family
is AF_INET6 and proto is IPPROTO_IPIP or IPPROTO_IPV6.

v1->v2:
  - Fix a sparse warning caused by the missing "__rcu", as Jakub
    noticed.
  - Handle the err returned by xfrm_input_register_afinfo() in
    tunnel6_init/fini(), as Sabrina noticed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h |  1 +
 net/ipv6/tunnel6.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c1ec629..83a532d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1425,6 +1425,7 @@ struct xfrm_tunnel {
 
 struct xfrm6_tunnel {
 	int (*handler)(struct sk_buff *skb);
+	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			   u8 type, u8 code, int offset, __be32 info);
 	struct xfrm6_tunnel __rcu *next;
diff --git a/net/ipv6/tunnel6.c b/net/ipv6/tunnel6.c
index 06c02eb..58348c9 100644
--- a/net/ipv6/tunnel6.c
+++ b/net/ipv6/tunnel6.c
@@ -155,6 +155,31 @@ static int tunnel6_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+static int tunnel6_rcv_cb(struct sk_buff *skb, u8 proto, int err)
+{
+	struct xfrm6_tunnel __rcu *head;
+	struct xfrm6_tunnel *handler;
+	int ret;
+
+	head = (proto == IPPROTO_IPV6) ? tunnel6_handlers : tunnel46_handlers;
+
+	for_each_tunnel_rcu(head, handler) {
+		if (handler->cb_handler) {
+			ret = handler->cb_handler(skb, err);
+			if (ret <= 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static const struct xfrm_input_afinfo tunnel6_input_afinfo = {
+	.family		=	AF_INET6,
+	.is_ipip	=	true,
+	.callback	=	tunnel6_rcv_cb,
+};
+
 static int tunnel46_rcv(struct sk_buff *skb)
 {
 	struct xfrm6_tunnel *handler;
@@ -229,18 +254,25 @@ static const struct inet6_protocol tunnelmpls6_protocol = {
 
 static int __init tunnel6_init(void)
 {
+	if (xfrm_input_register_afinfo(&tunnel6_input_afinfo)) {
+		pr_err("%s: can't add input afinfo\n", __func__);
+		return -EAGAIN;
+	}
 	if (inet6_add_protocol(&tunnel6_protocol, IPPROTO_IPV6)) {
 		pr_err("%s: can't add protocol\n", __func__);
+		xfrm_input_unregister_afinfo(&tunnel6_input_afinfo);
 		return -EAGAIN;
 	}
 	if (inet6_add_protocol(&tunnel46_protocol, IPPROTO_IPIP)) {
 		pr_err("%s: can't add protocol\n", __func__);
+		xfrm_input_unregister_afinfo(&tunnel6_input_afinfo);
 		inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6);
 		return -EAGAIN;
 	}
 	if (xfrm6_tunnel_mpls_supported() &&
 	    inet6_add_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS)) {
 		pr_err("%s: can't add protocol\n", __func__);
+		xfrm_input_unregister_afinfo(&tunnel6_input_afinfo);
 		inet6_del_protocol(&tunnel6_protocol, IPPROTO_IPV6);
 		inet6_del_protocol(&tunnel46_protocol, IPPROTO_IPIP);
 		return -EAGAIN;
@@ -257,6 +289,8 @@ static void __exit tunnel6_fini(void)
 	if (xfrm6_tunnel_mpls_supported() &&
 	    inet6_del_protocol(&tunnelmpls6_protocol, IPPROTO_MPLS))
 		pr_err("%s: can't remove protocol\n", __func__);
+	if (xfrm_input_unregister_afinfo(&tunnel6_input_afinfo))
+		pr_err("%s: can't remove input afinfo\n", __func__);
 }
 
 module_init(tunnel6_init);
-- 
2.1.0

