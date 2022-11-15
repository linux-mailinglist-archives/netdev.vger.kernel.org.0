Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608E66293A5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiKOIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiKOIyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:54:17 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D4620F46
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:08 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e189-20020a25e7c6000000b006e37f21e689so2563825ybh.10
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d1vNEfiFhEdK7Vl0raHFNncmU/PmJJBf4lJCFIJzVYk=;
        b=A73TZaDknkA0W7r1/PG4GQ0I2vj1fC6eXZnO1HaXcZ2s4Ae29C8pJbLzn20V2CjNnv
         cLYIViVaZ78QoTLrSW4ngUtVoHP+GS3TlW5EvK/XKGyLuD0X9sF6UGSUizM3TBW2w9rV
         Y9wE3f03Maa1LB4BxDK76CzBOkOLc/lETCfRt9tEGjqBX0+83Ql+wG/pvZu6JbtxyP9T
         E/oix3o4NniKBYuANDnudZtRKe0txkUSFaBRqvL/C1qUleSpEQpPOHBT/STLqVjKg3ch
         /hjboyDxHmNf86LvMqDIVPTmt5dmeeTR6k4ks36nFdraQDucVecdDP+LuN5YZN3897D1
         quYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d1vNEfiFhEdK7Vl0raHFNncmU/PmJJBf4lJCFIJzVYk=;
        b=inglrEDUF42qOw9aJ5iVtbtdBzk3KtY6SnOkGRq17WaCRjbzX2zC0JX60C9wCVev/i
         JGH14LS4Kr/nvNhg+kd7qu2tWLJt4mC4jKj4BtXoTUco94UzxqsH6DMw60Zo6DAr2nv3
         qJK9nlj3IEezIH+FdC7a4pmu3H9VjWBb5kOiiQne9K8ZCxY3k3mMjPzdSosgvYX+2wQU
         40527uVHDezwjg8Z+lAIFzXChBCrNb+nD0WcqpTwSRpMsXvibk56C0g9y7hzOqmBn1bl
         evGo1MeCbWSVAQnzm8DLDgMus3B0iJtdGjqVJ8yDlfbHaCGxftpo4fQ1Vk3c6qLGTdrK
         O/5Q==
X-Gm-Message-State: ACrzQf2WPhptaJt2J0fDTdhip+8vcnxVbPYeNMq73Fmy4fZGNw9ALdQG
        TNDuER2/vkhcxxBp5ld7jZg2tGM6cxH4GA==
X-Google-Smtp-Source: AMsMyM4wAdYoyG1b9EURGupQi0tRVdCD+zc9Lgpz6VKx7c67+0TS5HDI8bN37J+/qUGgKqVaG7l/9xVV4HO4hA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:7956:0:b0:36a:2c17:4660 with SMTP id
 u83-20020a817956000000b0036a2c174660mr63905365ywc.191.1668502446941; Tue, 15
 Nov 2022 00:54:06 -0800 (PST)
Date:   Tue, 15 Nov 2022 08:53:58 +0000
In-Reply-To: <20221115085358.2230729-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115085358.2230729-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115085358.2230729-5-edumazet@google.com>
Subject: [PATCH net-next 4/4] ipv4: tunnels: use DEV_STATS_INC()
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

Adopt SMP safe DEV_STATS_INC() to update dev->stats fields.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ip_gre.c    | 10 +++++-----
 net/ipv4/ip_tunnel.c | 32 ++++++++++++++++----------------
 net/ipv4/ip_vti.c    | 20 ++++++++++----------
 net/ipv4/ipip.c      |  2 +-
 net/ipv4/ipmr.c      | 12 ++++++------
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index d8ee5238c3954386263598fff7c7b565de348d64..a4ccef3e6935b5c1fd1885920becccba6b8a6d3f 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -510,7 +510,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 
 err_free_skb:
 	kfree_skb(skb);
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 }
 
 static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -592,7 +592,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 
 err_free_skb:
 	kfree_skb(skb);
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 }
 
 static int gre_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
@@ -663,7 +663,7 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 
 free_skb:
 	kfree_skb(skb);
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 	return NETDEV_TX_OK;
 }
 
@@ -717,7 +717,7 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
 
 free_skb:
 	kfree_skb(skb);
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 	return NETDEV_TX_OK;
 }
 
@@ -745,7 +745,7 @@ static netdev_tx_t gre_tap_xmit(struct sk_buff *skb,
 
 free_skb:
 	kfree_skb(skb);
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 	return NETDEV_TX_OK;
 }
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 019f3b0839c5225c7055f97cf15c96533fe32a2f..de90b09dfe78fc4510985dd436c017d3c46f054c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -368,23 +368,23 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 	if (ipv4_is_multicast(iph->daddr)) {
-		tunnel->dev->stats.multicast++;
+		DEV_STATS_INC(tunnel->dev, multicast);
 		skb->pkt_type = PACKET_BROADCAST;
 	}
 #endif
 
 	if ((!(tpi->flags&TUNNEL_CSUM) &&  (tunnel->parms.i_flags&TUNNEL_CSUM)) ||
 	     ((tpi->flags&TUNNEL_CSUM) && !(tunnel->parms.i_flags&TUNNEL_CSUM))) {
-		tunnel->dev->stats.rx_crc_errors++;
-		tunnel->dev->stats.rx_errors++;
+		DEV_STATS_INC(tunnel->dev, rx_crc_errors);
+		DEV_STATS_INC(tunnel->dev, rx_errors);
 		goto drop;
 	}
 
 	if (tunnel->parms.i_flags&TUNNEL_SEQ) {
 		if (!(tpi->flags&TUNNEL_SEQ) ||
 		    (tunnel->i_seqno && (s32)(ntohl(tpi->seq) - tunnel->i_seqno) < 0)) {
-			tunnel->dev->stats.rx_fifo_errors++;
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_fifo_errors);
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto drop;
 		}
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
@@ -398,8 +398,8 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 			net_info_ratelimited("non-ECT from %pI4 with TOS=%#x\n",
 					&iph->saddr, iph->tos);
 		if (err > 1) {
-			++tunnel->dev->stats.rx_frame_errors;
-			++tunnel->dev->stats.rx_errors;
+			DEV_STATS_INC(tunnel->dev, rx_frame_errors);
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto drop;
 		}
 	}
@@ -581,7 +581,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (!rt) {
 		rt = ip_route_output_key(tunnel->net, &fl4);
 		if (IS_ERR(rt)) {
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error;
 		}
 		if (use_cache)
@@ -590,7 +590,7 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 	if (rt->dst.dev == dev) {
 		ip_rt_put(rt);
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 		goto tx_error;
 	}
 
@@ -625,10 +625,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		      df, !net_eq(tunnel->net, dev_net(dev)));
 	return;
 tx_error:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	goto kfree;
 tx_dropped:
-	dev->stats.tx_dropped++;
+	DEV_STATS_INC(dev, tx_dropped);
 kfree:
 	kfree_skb(skb);
 }
@@ -662,7 +662,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		/* NBMA tunnel */
 
 		if (!skb_dst(skb)) {
-			dev->stats.tx_fifo_errors++;
+			DEV_STATS_INC(dev, tx_fifo_errors);
 			goto tx_error;
 		}
 
@@ -749,7 +749,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
 		if (IS_ERR(rt)) {
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error;
 		}
 		if (use_cache)
@@ -762,7 +762,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	if (rt->dst.dev == dev) {
 		ip_rt_put(rt);
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 		goto tx_error;
 	}
 
@@ -805,7 +805,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	if (skb_cow_head(skb, dev->needed_headroom)) {
 		ip_rt_put(rt);
-		dev->stats.tx_dropped++;
+		DEV_STATS_INC(dev, tx_dropped);
 		kfree_skb(skb);
 		return;
 	}
@@ -819,7 +819,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	dst_link_failure(skb);
 #endif
 tx_error:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_xmit);
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 8c2bd1d9ddce3891998ce82417bd8c535ee20246..53bfd8af69203619cd775171c2e8b43cca3449b1 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -107,8 +107,8 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 	dev = tunnel->dev;
 
 	if (err) {
-		dev->stats.rx_errors++;
-		dev->stats.rx_dropped++;
+		DEV_STATS_INC(dev, rx_errors);
+		DEV_STATS_INC(dev, rx_dropped);
 
 		return 0;
 	}
@@ -183,7 +183,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 			fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
 			rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
 			if (IS_ERR(rt)) {
-				dev->stats.tx_carrier_errors++;
+				DEV_STATS_INC(dev, tx_carrier_errors);
 				goto tx_error_icmp;
 			}
 			dst = &rt->dst;
@@ -198,14 +198,14 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 			if (dst->error) {
 				dst_release(dst);
 				dst = NULL;
-				dev->stats.tx_carrier_errors++;
+				DEV_STATS_INC(dev, tx_carrier_errors);
 				goto tx_error_icmp;
 			}
 			skb_dst_set(skb, dst);
 			break;
 #endif
 		default:
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error_icmp;
 		}
 	}
@@ -213,7 +213,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	dst_hold(dst);
 	dst = xfrm_lookup_route(tunnel->net, dst, fl, NULL, 0);
 	if (IS_ERR(dst)) {
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 		goto tx_error_icmp;
 	}
 
@@ -221,7 +221,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto xmit;
 
 	if (!vti_state_check(dst->xfrm, parms->iph.daddr, parms->iph.saddr)) {
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 		dst_release(dst);
 		goto tx_error_icmp;
 	}
@@ -230,7 +230,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	if (tdev == dev) {
 		dst_release(dst);
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 		goto tx_error;
 	}
 
@@ -267,7 +267,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 tx_error_icmp:
 	dst_link_failure(skb);
 tx_error:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -304,7 +304,7 @@ static netdev_tx_t vti_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	return vti_xmit(skb, dev, &fl);
 
 tx_err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 180f9daf5bec577b8f6062185ea13f7af9e5fe33..abea77759b7e4a6b2736d936db387abbf9db1515 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -310,7 +310,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb,
 tx_error:
 	kfree_skb(skb);
 
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index e04544ac4b4545f5beb1fc7c5dc864aefc1b7324..b58df3c1bf7dcf0d68585ef984a7327930273fa8 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -506,8 +506,8 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 		return err;
 	}
 
-	dev->stats.tx_bytes += skb->len;
-	dev->stats.tx_packets++;
+	DEV_STATS_ADD(dev, tx_bytes, skb->len);
+	DEV_STATS_INC(dev, tx_packets);
 	rcu_read_lock();
 
 	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
@@ -1839,8 +1839,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 	if (vif->flags & VIFF_REGISTER) {
 		WRITE_ONCE(vif->pkt_out, vif->pkt_out + 1);
 		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
-		vif_dev->stats.tx_bytes += skb->len;
-		vif_dev->stats.tx_packets++;
+		DEV_STATS_ADD(vif_dev, tx_bytes, skb->len);
+		DEV_STATS_INC(vif_dev, tx_packets);
 		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
 		goto out_free;
 	}
@@ -1898,8 +1898,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 	if (vif->flags & VIFF_TUNNEL) {
 		ip_encap(net, skb, vif->local, vif->remote);
 		/* FIXME: extra output firewall step used to be here. --RR */
-		vif_dev->stats.tx_packets++;
-		vif_dev->stats.tx_bytes += skb->len;
+		DEV_STATS_INC(vif_dev, tx_packets);
+		DEV_STATS_ADD(vif_dev, tx_bytes, skb->len);
 	}
 
 	IPCB(skb)->flags |= IPSKB_FORWARDED;
-- 
2.38.1.431.g37b22c650d-goog

