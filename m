Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5820950ABA0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358827AbiDUWru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383069AbiDUWrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:47:49 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBDB389E;
        Thu, 21 Apr 2022 15:44:57 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id i14so4752848qvk.13;
        Thu, 21 Apr 2022 15:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iOIhIPNmCk/T4f7tkkMq/Hw/5KDac50Wb6SdQ/sXMho=;
        b=D3qEQWoI5ipzPt8tVGychinTAl6Xg4ByEAZaKtrukV6oOyPC/FavFQMt5jSPL7luMR
         aW2jKMBbCI8gb9qPTwEVUwRusAujGADZg5czb55USZt4SKj58hgOfBXA4jM++HTQoeKk
         GaZO6DdP1d7aga1XRF464+P3NOZshb425eMQLjuxPClVwZj3aKX6x2mFoIdSO/B7vTII
         NknuVuVptY46BuRp3UzxWGXQhZKgLlQKpvWcwukx8ad1kW47H3nru83sOBBvAyzSRJJv
         y5H6n5zdxsmV/tmFLXue1ceArfmCFgoYob+BRXWHDPhLO/xO7QbwUAoEnY7pgoPmaxnA
         fUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iOIhIPNmCk/T4f7tkkMq/Hw/5KDac50Wb6SdQ/sXMho=;
        b=KeaI57TxsZ6gI5PgNvDax8y1zS2JmbU3bcQSFHbTrdmJ1TdVoqttxrQ5EnFPddu267
         UIN4eYrAahHKY2TcjJRJFDX5TORI/6GriAZFxlCZ2zoeDtSRjbEnwiZj2UYtXz5lJX5z
         xZYlbTNsctsgMrzKxBhnM5lwgfHsyQ4KYnOskH9YPQ/QTg3NTIT8snZlRypr6RRiKmA3
         fGBIBym8w6597EFPjOL0pboH0EcC2wkSCLRCe4R/0QnPaRkMJqS7yrUbFOiZcD39PnEh
         QxOu2s0sbSWec/O74y0117Rf/3MpirEjConwixXUsLffIF3h/+4sAGzHbR9QU+gyvZgR
         zFEw==
X-Gm-Message-State: AOAM531/9dTxvKpyc3BkzeongReRAjC8wPBbEniELrz1KX86RUGLx9Rs
        2nwqN/z23xeWZUf01jV/0w==
X-Google-Smtp-Source: ABdhPJyt/7WW6DQCS0AVCE+Nwpiqy4d53CZcArKGepU9TbKy6chzM9r4vjxbptZ8Qqf5GVbiddYdxg==
X-Received: by 2002:a05:6214:27cb:b0:444:4b5e:4274 with SMTP id ge11-20020a05621427cb00b004444b5e4274mr1608959qvb.51.1650581096340;
        Thu, 21 Apr 2022 15:44:56 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id p5-20020ae9f305000000b0069e6dcc4188sm120283qkg.57.2022.04.21.15.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:44:55 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 1/2] ip_gre: Make GRE and GRETAP devices always NETIF_F_LLTX
Date:   Thu, 21 Apr 2022 15:44:43 -0700
Message-Id: <9898b5249aa3c188cb02179aa7d6d4e7e831cbf9.1650580763.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1650580763.git.peilin.ye@bytedance.com>
References: <cover.1650580763.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we made o_seqno atomic_t.  Stop special-casing TUNNEL_SEQ, and
always mark GRE[TAP] devices as NETIF_F_LLTX, since we no longer need
the TX lock (&txq->_xmit_lock).

Depends on patch "ip_gre, ip6_gre: Fix race condition on o_seqno in
collect_md mode".

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv4/ip_gre.c | 50 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 8cf86e42c1d1..a81c2964f70b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -748,6 +748,7 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
+	__be16 flags;
 	int len;
 
 	len = tunnel->tun_hlen;
@@ -763,19 +764,15 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	if (set_mtu)
 		dev->mtu = max_t(int, dev->mtu - len, 68);
 
-	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
-		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
-		    tunnel->encap.type == TUNNEL_ENCAP_NONE) {
-			dev->features |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		} else {
-			dev->features &= ~NETIF_F_GSO_SOFTWARE;
-			dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-		}
-		dev->features |= NETIF_F_LLTX;
-	} else {
+	flags = tunnel->parms.o_flags;
+
+	if (flags & TUNNEL_SEQ ||
+	    (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)) {
+		dev->features &= ~NETIF_F_GSO_SOFTWARE;
 		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-		dev->features &= ~(NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE);
+	} else {
+		dev->features |= NETIF_F_GSO_SOFTWARE;
+		dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 	}
 }
 
@@ -949,6 +946,7 @@ static void ipgre_tunnel_setup(struct net_device *dev)
 static void __gre_tunnel_init(struct net_device *dev)
 {
 	struct ip_tunnel *tunnel;
+	__be16 flags;
 
 	tunnel = netdev_priv(dev);
 	tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);
@@ -957,25 +955,21 @@ static void __gre_tunnel_init(struct net_device *dev)
 	tunnel->hlen = tunnel->tun_hlen + tunnel->encap_hlen;
 	dev->needed_headroom = tunnel->hlen + sizeof(tunnel->parms.iph);
 
-	dev->features		|= GRE_FEATURES;
+	dev->features		|= GRE_FEATURES | NETIF_F_LLTX;
 	dev->hw_features	|= GRE_FEATURES;
 
-	if (!(tunnel->parms.o_flags & TUNNEL_SEQ)) {
-		/* TCP offload with GRE SEQ is not supported, nor
-		 * can we support 2 levels of outer headers requiring
-		 * an update.
-		 */
-		if (!(tunnel->parms.o_flags & TUNNEL_CSUM) ||
-		    (tunnel->encap.type == TUNNEL_ENCAP_NONE)) {
-			dev->features    |= NETIF_F_GSO_SOFTWARE;
-			dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-		}
+	flags = tunnel->parms.o_flags;
 
-		/* Can use a lockless transmit, unless we generate
-		 * output sequences
-		 */
-		dev->features |= NETIF_F_LLTX;
-	}
+	/* TCP offload with GRE SEQ is not supported, nor can we support 2
+	 * levels of outer headers requiring an update.
+	 */
+	if (flags & TUNNEL_SEQ)
+		return;
+	if (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)
+		return;
+
+	dev->features |= NETIF_F_GSO_SOFTWARE;
+	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
-- 
2.20.1

