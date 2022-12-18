Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D172E65021F
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLRQmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiLRQlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:41:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B7F017;
        Sun, 18 Dec 2022 08:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 877DAB80B43;
        Sun, 18 Dec 2022 16:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058FFC433F0;
        Sun, 18 Dec 2022 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380084;
        bh=Qs8z/eMb9zZap8vuy7TCJ7fXrIA0nWBv7Nf/yamGJUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEXCKHct0Y+tmardnYbvkbTFeUJCdQqWBFEiadA99Yop3cIJHF64hzhV2wi9LUGyD
         EHlhsO4UMqfC4JlK/lyPfdQyl2mTZ8hL5xnpwoMzJjj5Xb/Cil7FGNo8tjo9zqEe93
         MioVkpYIkC+0i5Z8E4H4HxXmm/xYh4AQtKPDlU1oJ/4bwjySSvb9AZqZQe9gROiPgE
         aWo3WjOlAbZTD4NqSaOSHYAAXm2/luedcGRcVl2w43T4Ve1bxhTCXVX0b8Oq7IQuYi
         0CCir76uG54+Cxooihi7MRlYq/zNL+DLrYzbw0/gCtbEfwS5f5jWxGkEx6G9Ecydpy
         EudLgyniNAxVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/46] ipv6/sit: use DEV_STATS_INC() to avoid data-races
Date:   Sun, 18 Dec 2022 11:12:27 -0500
Message-Id: <20221218161244.930785-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb34b7cf17ecf33499c9298943f85af247abc1e9 ]

syzbot/KCSAN reported that multiple cpus are updating dev->stats.tx_error
concurrently.

This is because sit tunnels are NETIF_F_LLTX, meaning their ndo_start_xmit()
is not protected by a spinlock.

While original KCSAN report was about tx path, rx path has the same issue.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 946871741f12..d4cdc2b1b468 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -696,7 +696,7 @@ static int ipip6_rcv(struct sk_buff *skb)
 		skb->dev = tunnel->dev;
 
 		if (packet_is_spoofed(skb, iph, tunnel)) {
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto out;
 		}
 
@@ -716,8 +716,8 @@ static int ipip6_rcv(struct sk_buff *skb)
 				net_info_ratelimited("non-ECT from %pI4 with TOS=%#x\n",
 						     &iph->saddr, iph->tos);
 			if (err > 1) {
-				++tunnel->dev->stats.rx_frame_errors;
-				++tunnel->dev->stats.rx_errors;
+				DEV_STATS_INC(tunnel->dev, rx_frame_errors);
+				DEV_STATS_INC(tunnel->dev, rx_errors);
 				goto out;
 			}
 		}
@@ -948,7 +948,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	if (!rt) {
 		rt = ip_route_output_flow(tunnel->net, &fl4, NULL);
 		if (IS_ERR(rt)) {
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error_icmp;
 		}
 		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
@@ -956,14 +956,14 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 
 	if (rt->rt_type != RTN_UNICAST) {
 		ip_rt_put(rt);
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 		goto tx_error_icmp;
 	}
 	tdev = rt->dst.dev;
 
 	if (tdev == dev) {
 		ip_rt_put(rt);
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 		goto tx_error;
 	}
 
@@ -976,7 +976,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - t_hlen;
 
 		if (mtu < IPV4_MIN_MTU) {
-			dev->stats.collisions++;
+			DEV_STATS_INC(dev, collisions);
 			ip_rt_put(rt);
 			goto tx_error;
 		}
@@ -1015,7 +1015,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
 		if (!new_skb) {
 			ip_rt_put(rt);
-			dev->stats.tx_dropped++;
+			DEV_STATS_INC(dev, tx_dropped);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
@@ -1045,7 +1045,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	dst_link_failure(skb);
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1064,7 +1064,7 @@ static netdev_tx_t sit_tunnel_xmit__(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1093,7 +1093,7 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 
-- 
2.35.1

