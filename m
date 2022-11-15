Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6A46293A3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiKOIyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiKOIyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:54:05 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C081C1A07E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:04 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36bf9c132f9so128632837b3.8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9S5WjlUm/6RJlr22fS6U7+PLemNCGw2oUaxn9EgBdf8=;
        b=m/9bV3wPRYGxEX2K75wsmhJqfW4YQT7fJ9iTEDC4aDGYINrpQ1xf2g0ryY1qGtcRq+
         7OUGi9ZUHNsmCi2KZREFd2DlfRWbPYT4QPZpb9fbB7Y3NSocLvofvnJvMAuXIrUdi3eA
         67eOaGLUfSA8oJcFJHrV51Ew5urvUjiN8ri9XydcxYfxq5LifV9+Oyp/Wi5pShEfG+6J
         uyzfmzOx60xwYBdjFVqMEqU+DC0qRJui6EGNrJMm5R5x2E0oXip8sANsvwuMkW+PEIht
         /ceISSArB3BgnmZA/AVStt3eR0aSAzqyBablb7pvI/JyH0VEdEzTxypsrrKxe7BJvRRg
         O7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9S5WjlUm/6RJlr22fS6U7+PLemNCGw2oUaxn9EgBdf8=;
        b=c93m6wKSSICAFbBe/sfmXcjK7d2TV3oe1O1mgxTtn1bUIfRmRGFxfX8e//7ZMPl0NU
         hSxJX/lNiKJ7di5YMiveLiyd+yiSaQwoAUD3SKawiRcLvtiSMeoSJAaWSYfwbhCjSAhe
         h0ORBrMLmqvoRNWabsA/diDq1TYfp0a2RQN4HqQo/BWT/KtbVkJo4AGoAMWNJaOMf8vr
         QOCPeGw9FZAg0YRidKiJ7aG7JwkFS7THswnT6KVClSczM4PlEwD9fUd71z24YtnUNh6j
         JaCwIelMqeowSpebvfxecBcSd4UHc5c+GU/qU41+JfbF3DxAqi5EjBQMwjap2I5+BRW/
         8RtQ==
X-Gm-Message-State: ANoB5plBXMbIKxvPgODgpX9MCTkFuEMeWu4DJahBBNXEtYthWhtE9g8H
        dw+IUfDtwzb98U6GdHl6casfFDzqCj2tMA==
X-Google-Smtp-Source: AA0mqf4fP/keg9mVdxr/eBQ5TH5n87VwI1O5Nm2Rb67FgzH+hqr5Z9aE7TeKnbx+ydHskoyqnTfx9dj3QjWYXg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:3803:0:b0:380:c83a:35a5 with SMTP id
 f3-20020a813803000000b00380c83a35a5mr1ywa.496.1668502443666; Tue, 15 Nov 2022
 00:54:03 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:53:56 +0000
In-Reply-To: <20221115085358.2230729-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115085358.2230729-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115085358.2230729-3-edumazet@google.com>
Subject: [PATCH net-next 2/4] ipv6/sit: use DEV_STATS_INC() to avoid data-races
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

syzbot/KCSAN reported that multiple cpus are updating dev->stats.tx_error
concurrently.

This is because sit tunnels are NETIF_F_LLTX, meaning their ndo_start_xmit()
is not protected by a spinlock.

While original KCSAN report was about tx path, rx path has the same issue.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/sit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5703d3cbea9ba669c21d3f40bca347652077e6f0..70d81bba509390e29bd8c8ad1061ab81f92560dd 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -694,7 +694,7 @@ static int ipip6_rcv(struct sk_buff *skb)
 		skb->dev = tunnel->dev;
 
 		if (packet_is_spoofed(skb, iph, tunnel)) {
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto out;
 		}
 
@@ -714,8 +714,8 @@ static int ipip6_rcv(struct sk_buff *skb)
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
@@ -942,7 +942,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	if (!rt) {
 		rt = ip_route_output_flow(tunnel->net, &fl4, NULL);
 		if (IS_ERR(rt)) {
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error_icmp;
 		}
 		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
@@ -950,14 +950,14 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 
 	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
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
 
@@ -970,7 +970,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - t_hlen;
 
 		if (mtu < IPV4_MIN_MTU) {
-			dev->stats.collisions++;
+			DEV_STATS_INC(dev, collisions);
 			ip_rt_put(rt);
 			goto tx_error;
 		}
@@ -1009,7 +1009,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
 		if (!new_skb) {
 			ip_rt_put(rt);
-			dev->stats.tx_dropped++;
+			DEV_STATS_INC(dev, tx_dropped);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
@@ -1039,7 +1039,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	dst_link_failure(skb);
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1058,7 +1058,7 @@ static netdev_tx_t sit_tunnel_xmit__(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1087,7 +1087,7 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 
-- 
2.38.1.431.g37b22c650d-goog

