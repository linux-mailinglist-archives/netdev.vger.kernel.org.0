Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E866293A4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiKOIyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiKOIyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:54:07 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2611C1CFF0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-377a1db4307so128531207b3.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mSU+VUoJkOXflJ+hX4Gja+X1PWXsxnzyoj0Ex3cRnms=;
        b=RtPXu5L7Cvwxpee4Nhhiu9Q8HQ4qZGfxbBOvNWwlxi5wXXTsD8wYITeCpVFiItcLNT
         2XhXWVehzSRPuSQqrsBnqVR+AFk3VPFm/ys4gNAsK+gtRV0w6Op/CYDKxyiuBoTvTCAT
         sZ8qcmmhx0EhU2wTfML4khy9d+GCfIik5/vnSzPl1VgVCSFzFkerPt1SUgSPYLMVmjSg
         CveT9jMr+jgH94/Tym9eD/L7PRJQKwswUgpJi7Hi7DXpdYraF/SppdnE0bSsvxJTOztp
         6BFLog1euKMwt/0sPNs0BlCxlhDFqRui/SDR8k5CCsmY+2iJhHyVOticPWUKcPUn2pr1
         naaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSU+VUoJkOXflJ+hX4Gja+X1PWXsxnzyoj0Ex3cRnms=;
        b=w2yL4aSYL6OdujLtvKpTKUBjZKNIh/KkanqasBBwoZfc/iYpEx4l7yyetehjpJREHd
         VS4DF6mDiG0cQQmiSn6HRhJGIi4oxjIqnPGqgyqDfmV0x1xOymHE6kATxRGCGDPEUPhP
         PHIaP8uDLUskknpyoHOPfJ9NPSjipAlqM5KGeGV7gYY75bXPMzAd3KpclM798N5C4EC9
         x/i2DXG5ELwL6dOPxTlrqkuxrnpf47675OaRTwbkl7kfzlLoT6jw88sbsQ/aTlmz4k2J
         W0FPIYY6cg3IeWYSxBgP83D3IbJe4Ysp6GXO5zWx/j/XDjF/jBcc9DgaNhfl/vZlZgmw
         i7cQ==
X-Gm-Message-State: ANoB5pmmRzJQjX5En/Gjt0olk6ao4APwf4AM6uqFMfWNcTc362k/asOO
        SutarKzPiLgM+vcxw3k1Gkfq4aYNhASLrA==
X-Google-Smtp-Source: AA0mqf7NQGZJQvdqceAM3IYAG+R3oN7W956ghOQPpmxlu+1fE6v9IpxkZl0u9JH9PtykhmMo5R2Z4VhSGyfXYA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:ba4c:0:b0:6dc:dc81:aaf4 with SMTP id
 z12-20020a25ba4c000000b006dcdc81aaf4mr14483279ybj.365.1668502445428; Tue, 15
 Nov 2022 00:54:05 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:53:57 +0000
In-Reply-To: <20221115085358.2230729-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115085358.2230729-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115085358.2230729-4-edumazet@google.com>
Subject: [PATCH net-next 3/4] ipv6: tunnels: use DEV_STATS_INC()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of code paths in tunnels are lockless (eg NETIF_F_LLTX in tx).

Adopt SMP safe DEV_STATS_{INC|ADD}() to update dev->stats fields.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_gre.c    | 11 ++++-------
 net/ipv6/ip6_tunnel.c | 26 ++++++++++++--------------
 net/ipv6/ip6_vti.c    | 16 +++++++---------
 net/ipv6/ip6mr.c      | 10 +++++-----
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 7673e1dd114796f161a513d2635fea6d51b5ee24..89f5f0f3f5d65b6aac0dae2302d8a5607a492155 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -895,7 +895,6 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 	struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct net_device_stats *stats = &t->dev->stats;
 	__be16 payload_protocol;
 	int ret;
 
@@ -925,8 +924,8 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
 
 tx_err:
 	if (!t->parms.collect_md || !IS_ERR(skb_tunnel_info_txcheck(skb)))
-		stats->tx_errors++;
-	stats->tx_dropped++;
+		DEV_STATS_INC(dev, tx_errors);
+	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -937,7 +936,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct dst_entry *dst = skb_dst(skb);
-	struct net_device_stats *stats;
 	bool truncate = false;
 	int encap_limit = -1;
 	__u8 dsfield = false;
@@ -1086,10 +1084,9 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	stats = &t->dev->stats;
 	if (!IS_ERR(tun_info))
-		stats->tx_errors++;
-	stats->tx_dropped++;
+		DEV_STATS_INC(dev, tx_errors);
+	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2fb4c6ad724321c634a4bf94f535f06bb18dbb7d..47b6607a13706ef415e0b19f38014700e673da84 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -803,8 +803,8 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 	     (tunnel->parms.i_flags & TUNNEL_CSUM)) ||
 	    ((tpi->flags & TUNNEL_CSUM) &&
 	     !(tunnel->parms.i_flags & TUNNEL_CSUM))) {
-		tunnel->dev->stats.rx_crc_errors++;
-		tunnel->dev->stats.rx_errors++;
+		DEV_STATS_INC(tunnel->dev, rx_crc_errors);
+		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
 	}
 
@@ -812,8 +812,8 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		if (!(tpi->flags & TUNNEL_SEQ) ||
 		    (tunnel->i_seqno &&
 		     (s32)(ntohl(tpi->seq) - tunnel->i_seqno) < 0)) {
-			tunnel->dev->stats.rx_fifo_errors++;
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_fifo_errors);
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto drop;
 		}
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
@@ -824,8 +824,8 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 	/* Warning: All skb pointers will be invalidated! */
 	if (tunnel->dev->type == ARPHRD_ETHER) {
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
-			tunnel->dev->stats.rx_length_errors++;
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_length_errors);
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto drop;
 		}
 
@@ -849,8 +849,8 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 					     &ipv6h->saddr,
 					     ipv6_get_dsfield(ipv6h));
 		if (err > 1) {
-			++tunnel->dev->stats.rx_frame_errors;
-			++tunnel->dev->stats.rx_errors;
+			DEV_STATS_INC(tunnel->dev, rx_frame_errors);
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto drop;
 		}
 	}
@@ -1071,7 +1071,6 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 {
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct net *net = t->net;
-	struct net_device_stats *stats = &t->dev->stats;
 	struct ipv6hdr *ipv6h;
 	struct ipv6_tel_txoption opt;
 	struct dst_entry *dst = NULL, *ndst = NULL;
@@ -1166,7 +1165,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	tdev = dst->dev;
 
 	if (tdev == dev) {
-		stats->collisions++;
+		DEV_STATS_INC(dev, collisions);
 		net_warn_ratelimited("%s: Local routing loop detected!\n",
 				     t->parms.name);
 		goto tx_err_dst_release;
@@ -1265,7 +1264,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	ip6tunnel_xmit(NULL, skb, dev);
 	return 0;
 tx_err_link_failure:
-	stats->tx_carrier_errors++;
+	DEV_STATS_INC(dev, tx_carrier_errors);
 	dst_link_failure(skb);
 tx_err_dst_release:
 	dst_release(dst);
@@ -1408,7 +1407,6 @@ static netdev_tx_t
 ip6_tnl_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct net_device_stats *stats = &t->dev->stats;
 	u8 ipproto;
 	int ret;
 
@@ -1438,8 +1436,8 @@ ip6_tnl_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_err:
-	stats->tx_errors++;
-	stats->tx_dropped++;
+	DEV_STATS_INC(dev, tx_errors);
+	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 151337d7f67b43ed930cc14f679be95764d645bc..10b222865d46a8b7d51028f89ca10208031b8700 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -317,7 +317,7 @@ static int vti6_input_proto(struct sk_buff *skb, int nexthdr, __be32 spi,
 
 		ipv6h = ipv6_hdr(skb);
 		if (!ip6_tnl_rcv_ctl(t, &ipv6h->daddr, &ipv6h->saddr)) {
-			t->dev->stats.rx_dropped++;
+			DEV_STATS_INC(t->dev, rx_dropped);
 			rcu_read_unlock();
 			goto discard;
 		}
@@ -359,8 +359,8 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 	dev = t->dev;
 
 	if (err) {
-		dev->stats.rx_errors++;
-		dev->stats.rx_dropped++;
+		DEV_STATS_INC(dev, rx_errors);
+		DEV_STATS_INC(dev, rx_dropped);
 
 		return 0;
 	}
@@ -446,7 +446,6 @@ static int
 vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct net_device_stats *stats = &t->dev->stats;
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *tdev;
 	struct xfrm_state *x;
@@ -506,7 +505,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	tdev = dst->dev;
 
 	if (tdev == dev) {
-		stats->collisions++;
+		DEV_STATS_INC(dev, collisions);
 		net_warn_ratelimited("%s: Local routing loop detected!\n",
 				     t->parms.name);
 		goto tx_err_dst_release;
@@ -544,7 +543,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 	return 0;
 tx_err_link_failure:
-	stats->tx_carrier_errors++;
+	DEV_STATS_INC(dev, tx_carrier_errors);
 	dst_link_failure(skb);
 tx_err_dst_release:
 	dst_release(dst);
@@ -555,7 +554,6 @@ static netdev_tx_t
 vti6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct net_device_stats *stats = &t->dev->stats;
 	struct flowi fl;
 	int ret;
 
@@ -591,8 +589,8 @@ vti6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_err:
-	stats->tx_errors++;
-	stats->tx_dropped++;
+	DEV_STATS_INC(dev, tx_errors);
+	DEV_STATS_INC(dev, tx_dropped);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index facdc78a43e5c67103a31d642254b94b106193c9..23e766597f362410e68ede7416892dbbff8c95ff 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -608,8 +608,8 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
 		goto tx_err;
 
-	dev->stats.tx_bytes += skb->len;
-	dev->stats.tx_packets++;
+	DEV_STATS_ADD(dev, tx_bytes, skb->len);
+	DEV_STATS_INC(dev, tx_packets);
 	rcu_read_lock();
 	ip6mr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
 			   MRT6MSG_WHOLEPKT);
@@ -618,7 +618,7 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -2044,8 +2044,8 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	if (vif->flags & MIFF_REGISTER) {
 		WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
 		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
-		vif_dev->stats.tx_bytes += skb->len;
-		vif_dev->stats.tx_packets++;
+		DEV_STATS_ADD(vif_dev, tx_bytes, skb->len);
+		DEV_STATS_INC(vif_dev, tx_packets);
 		ip6mr_cache_report(mrt, skb, vifi, MRT6MSG_WHOLEPKT);
 		goto out_free;
 	}
-- 
2.38.1.431.g37b22c650d-goog

