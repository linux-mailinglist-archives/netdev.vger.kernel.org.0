Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530BA5437D8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244816AbiFHPrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244792AbiFHPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BE63CFF7
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f9so7518505plg.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sLwMqlPzXnNNEKic0159pnQtK8wgFlPa/p2A5Zl72c=;
        b=ke9og9q2P2JT6fQVmAYY6+Zj5v6MsKB7wsRD3k6jKcP5FqzOP2us12GCCLqdGLhc3S
         9DWD5XvFz1ZrZXtIzv+BTUXh+OVpNpPREjk7Lo8DsZ7sJI1x5lAcJYgyYjw0Bb7zKMCn
         0rCH+JueDmX45UOnGmoxvu69yNQRH2CuW+6wVKIsw3NDjkycJPB1tkphkVossJ7bXc9O
         XFkdApalviqoumjYNZjFwb7S5OAdJCIZeQcnvptTFKudfT205iuTAxlI/2wPlOSXiAa4
         xW0zbnFLNLi2ikFWG725gyBzLMAhzMERShvHT45lR4Tcio6jnKJQesln22jrv0JyOh5z
         LSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sLwMqlPzXnNNEKic0159pnQtK8wgFlPa/p2A5Zl72c=;
        b=j7Oe4UILUENu22PSLsD6DX44TjIuWIke7o8pfQbmm34tNjKA+EiPLOtVcZd/lduJ5G
         0a6VL2V0QwIjCOmrGpBXGezdLYgr5c4ppneQPncTueLPB0oDduBeDp4iakFc7k0ZFSeF
         x/33aOYxEBwLdCTFx9fGAqs+aisLbaJrJWq9Gv84mk1J4q8nlo672ecJmoNBuViXVtQB
         o0vlKr4kwQu/4JejHmXmzApBlYtdNs3ec2h4RM7vOcRItgVJBd3vcoZIL19HShgoVtiu
         ooaWqnTCQ+tTydXEtWQz4ZXnJPTjV8DJUvClyC63++9HsUeXrV8VYogro3+pODXcfuim
         SVYA==
X-Gm-Message-State: AOAM53264JZFabEb39V2M5km/NYN4z6LkTQ615LTZY4SKwR51Q4VOKlD
        a05/GOxeMZThXw8WpGfvqfM=
X-Google-Smtp-Source: ABdhPJyfBKJf74/v6kFZ7unMiLTGaDHdr3vLdtdNNV/mYqVClnL9wMfsQct4QCOjDSH07i7v7GXPDA==
X-Received: by 2002:a17:902:8309:b0:167:9a4c:cd58 with SMTP id bd9-20020a170902830900b001679a4ccd58mr7086677plb.166.1654703212901;
        Wed, 08 Jun 2022 08:46:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:52 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 6/9] net: adopt u64_stats_t in struct pcpu_sw_netstats
Date:   Wed,  8 Jun 2022 08:46:37 -0700
Message-Id: <20220608154640.1235958-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
we should use u64_stats_t and related accessors to avoid load/store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macsec.c           |  8 ++++----
 drivers/net/usb/usbnet.c       |  8 ++++----
 drivers/net/vxlan/vxlan_core.c |  8 ++++----
 include/linux/netdevice.h      | 16 +++++++--------
 include/net/ip_tunnels.h       |  4 ++--
 net/bridge/br_netlink.c        |  8 ++++----
 net/bridge/br_vlan.c           | 36 +++++++++++++++++++---------------
 net/core/dev.c                 | 18 ++++++++---------
 net/dsa/slave.c                |  8 ++++----
 9 files changed, 59 insertions(+), 55 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 817577e713d709fb2961b3bdf195879234d08183..96e8d5fd90b2dba92b833de8b2dc7e682ef47a76 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -523,8 +523,8 @@ static void count_tx(struct net_device *dev, int ret, int len)
 		struct pcpu_sw_netstats *stats = this_cpu_ptr(dev->tstats);
 
 		u64_stats_update_begin(&stats->syncp);
-		stats->tx_packets++;
-		stats->tx_bytes += len;
+		u64_stats_inc(&stats->tx_packets);
+		u64_stats_add(&stats->tx_bytes, len);
 		u64_stats_update_end(&stats->syncp);
 	}
 }
@@ -825,8 +825,8 @@ static void count_rx(struct net_device *dev, int len)
 	struct pcpu_sw_netstats *stats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += len;
+	u64_stats_inc(&stats->rx_packets);
+	u64_stats_add(&stats->rx_bytes, len);
 	u64_stats_update_end(&stats->syncp);
 }
 
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 36b24ec1165043def00bfd151eb1b60929995deb..4409d6b24101075cb2c3a2eaaefe260b50cb36ad 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -337,8 +337,8 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 		skb->protocol = eth_type_trans (skb, dev->net);
 
 	flags = u64_stats_update_begin_irqsave(&stats64->syncp);
-	stats64->rx_packets++;
-	stats64->rx_bytes += skb->len;
+	u64_stats_inc(&stats64->rx_packets);
+	u64_stats_add(&stats64->rx_bytes, skb->len);
 	u64_stats_update_end_irqrestore(&stats64->syncp, flags);
 
 	netif_dbg(dev, rx_status, dev->net, "< rx, len %zu, type 0x%x\n",
@@ -1258,8 +1258,8 @@ static void tx_complete (struct urb *urb)
 		unsigned long flags;
 
 		flags = u64_stats_update_begin_irqsave(&stats64->syncp);
-		stats64->tx_packets += entry->packets;
-		stats64->tx_bytes += entry->length;
+		u64_stats_add(&stats64->tx_packets, entry->packets);
+		u64_stats_add(&stats64->tx_bytes, entry->length);
 		u64_stats_update_end_irqrestore(&stats64->syncp, flags);
 	} else {
 		dev->net->stats.tx_errors++;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 265d4a0245e7fcb31f469061eaaf46baa47ebbab..8b0710b576c2109c135e86515ded416360383535 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2385,15 +2385,15 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 		vxlan_snoop(dev, &loopback, eth_hdr(skb)->h_source, 0, vni);
 
 	u64_stats_update_begin(&tx_stats->syncp);
-	tx_stats->tx_packets++;
-	tx_stats->tx_bytes += len;
+	u64_stats_inc(&tx_stats->tx_packets);
+	u64_stats_add(&tx_stats->tx_bytes, len);
 	u64_stats_update_end(&tx_stats->syncp);
 	vxlan_vnifilter_count(src_vxlan, vni, NULL, VXLAN_VNI_STATS_TX, len);
 
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
 		u64_stats_update_begin(&rx_stats->syncp);
-		rx_stats->rx_packets++;
-		rx_stats->rx_bytes += len;
+		u64_stats_inc(&rx_stats->rx_packets);
+		u64_stats_add(&rx_stats->rx_bytes, len);
 		u64_stats_update_end(&rx_stats->syncp);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL, VXLAN_VNI_STATS_RX,
 				      len);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f615a66c89e98b5d58e1b23d6674fa142106fb6e..a07fae3ef10817c77bdec59660fa0feb7cdeb406 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2636,10 +2636,10 @@ struct packet_offload {
 
 /* often modified stats are per-CPU, other are shared (netdev->stats) */
 struct pcpu_sw_netstats {
-	u64     rx_packets;
-	u64     rx_bytes;
-	u64     tx_packets;
-	u64     tx_bytes;
+	u64_stats_t		rx_packets;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		tx_packets;
+	u64_stats_t		tx_bytes;
 	struct u64_stats_sync   syncp;
 } __aligned(4 * sizeof(u64));
 
@@ -2656,8 +2656,8 @@ static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int l
 	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_bytes += len;
-	tstats->rx_packets++;
+	u64_stats_add(&tstats->rx_bytes, len);
+	u64_stats_inc(&tstats->rx_packets);
 	u64_stats_update_end(&tstats->syncp);
 }
 
@@ -2668,8 +2668,8 @@ static inline void dev_sw_netstats_tx_add(struct net_device *dev,
 	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
-	tstats->tx_bytes += len;
-	tstats->tx_packets += packets;
+	u64_stats_add(&tstats->tx_bytes, len);
+	u64_stats_add(&tstats->tx_packets, packets);
 	u64_stats_update_end(&tstats->syncp);
 }
 
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index c24fa934221dde1c59ae6519cee783233d19af48..70cbc4a726691de160e89e92dfb0700c77d3097b 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -456,8 +456,8 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 		struct pcpu_sw_netstats *tstats = get_cpu_ptr(dev->tstats);
 
 		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += pkt_len;
-		tstats->tx_packets++;
+		u64_stats_add(&tstats->tx_bytes, pkt_len);
+		u64_stats_inc(&tstats->tx_packets);
 		u64_stats_update_end(&tstats->syncp);
 		put_cpu_ptr(tstats);
 	} else {
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bb01776d2d88c46ac29ba94c2647fe26ff3468df..1ef14a099c6b023dcf2b54e8ef8c9eeb6820e0e4 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1770,10 +1770,10 @@ static int br_fill_linkxstats(struct sk_buff *skb,
 			if (v->vid == pvid)
 				vxi.flags |= BRIDGE_VLAN_INFO_PVID;
 			br_vlan_get_stats(v, &stats);
-			vxi.rx_bytes = stats.rx_bytes;
-			vxi.rx_packets = stats.rx_packets;
-			vxi.tx_bytes = stats.tx_bytes;
-			vxi.tx_packets = stats.tx_packets;
+			vxi.rx_bytes = u64_stats_read(&stats.rx_bytes);
+			vxi.rx_packets = u64_stats_read(&stats.rx_packets);
+			vxi.tx_bytes = u64_stats_read(&stats.tx_bytes);
+			vxi.tx_packets = u64_stats_read(&stats.tx_packets);
 
 			if (nla_put(skb, BRIDGE_XSTATS_VLAN, sizeof(vxi), &vxi))
 				goto nla_put_failure;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0f5e75ccac7957184b18acb8dc53876c12663dc0..6e53dc991409429f26316d2c407e01c50c47c664 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -505,8 +505,8 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 	if (br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 		stats = this_cpu_ptr(v->stats);
 		u64_stats_update_begin(&stats->syncp);
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+		u64_stats_add(&stats->tx_bytes, skb->len);
+		u64_stats_inc(&stats->tx_packets);
 		u64_stats_update_end(&stats->syncp);
 	}
 
@@ -624,8 +624,8 @@ static bool __allowed_ingress(const struct net_bridge *br,
 	if (br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 		stats = this_cpu_ptr(v->stats);
 		u64_stats_update_begin(&stats->syncp);
-		stats->rx_bytes += skb->len;
-		stats->rx_packets++;
+		u64_stats_add(&stats->rx_bytes, skb->len);
+		u64_stats_inc(&stats->rx_packets);
 		u64_stats_update_end(&stats->syncp);
 	}
 
@@ -1379,16 +1379,16 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 		cpu_stats = per_cpu_ptr(v->stats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			rxpackets = cpu_stats->rx_packets;
-			rxbytes = cpu_stats->rx_bytes;
-			txbytes = cpu_stats->tx_bytes;
-			txpackets = cpu_stats->tx_packets;
+			rxpackets = u64_stats_read(&cpu_stats->rx_packets);
+			rxbytes = u64_stats_read(&cpu_stats->rx_bytes);
+			txbytes = u64_stats_read(&cpu_stats->tx_bytes);
+			txpackets = u64_stats_read(&cpu_stats->tx_packets);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->rx_packets += rxpackets;
-		stats->rx_bytes += rxbytes;
-		stats->tx_bytes += txbytes;
-		stats->tx_packets += txpackets;
+		u64_stats_add(&stats->rx_packets, rxpackets);
+		u64_stats_add(&stats->rx_bytes, rxbytes);
+		u64_stats_add(&stats->tx_bytes, txbytes);
+		u64_stats_add(&stats->tx_packets, txpackets);
 	}
 }
 
@@ -1779,14 +1779,18 @@ static bool br_vlan_stats_fill(struct sk_buff *skb,
 		return false;
 
 	br_vlan_get_stats(v, &stats);
-	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_RX_BYTES, stats.rx_bytes,
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_RX_BYTES,
+			      u64_stats_read(&stats.rx_bytes),
 			      BRIDGE_VLANDB_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_RX_PACKETS,
-			      stats.rx_packets, BRIDGE_VLANDB_STATS_PAD) ||
-	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_TX_BYTES, stats.tx_bytes,
+			      u64_stats_read(&stats.rx_packets),
+			      BRIDGE_VLANDB_STATS_PAD) ||
+	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_TX_BYTES,
+			      u64_stats_read(&stats.tx_bytes),
 			      BRIDGE_VLANDB_STATS_PAD) ||
 	    nla_put_u64_64bit(skb, BRIDGE_VLANDB_STATS_TX_PACKETS,
-			      stats.tx_packets, BRIDGE_VLANDB_STATS_PAD))
+			      u64_stats_read(&stats.tx_packets),
+			      BRIDGE_VLANDB_STATS_PAD))
 		goto out_err;
 
 	nla_nest_end(skb, nest);
diff --git a/net/core/dev.c b/net/core/dev.c
index 08ce317fcec89609f6f8e9335b3d9f57e813024d..6ed775459f45e8df1d14233aed92b90d1a84cca2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10459,23 +10459,23 @@ void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
+		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
 		const struct pcpu_sw_netstats *stats;
-		struct pcpu_sw_netstats tmp;
 		unsigned int start;
 
 		stats = per_cpu_ptr(netstats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			tmp.rx_packets = stats->rx_packets;
-			tmp.rx_bytes   = stats->rx_bytes;
-			tmp.tx_packets = stats->tx_packets;
-			tmp.tx_bytes   = stats->tx_bytes;
+			rx_packets = u64_stats_read(&stats->rx_packets);
+			rx_bytes   = u64_stats_read(&stats->rx_bytes);
+			tx_packets = u64_stats_read(&stats->tx_packets);
+			tx_bytes   = u64_stats_read(&stats->tx_bytes);
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
-		s->rx_packets += tmp.rx_packets;
-		s->rx_bytes   += tmp.rx_bytes;
-		s->tx_packets += tmp.tx_packets;
-		s->tx_bytes   += tmp.tx_bytes;
+		s->rx_packets += rx_packets;
+		s->rx_bytes   += rx_bytes;
+		s->tx_packets += tx_packets;
+		s->tx_bytes   += tx_bytes;
 	}
 }
 EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 801a5d445833c0f6b0328fc1adb9508d79244e90..2e1ac638d135e8b83cd80f83a67736e31f387afa 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -935,10 +935,10 @@ static void dsa_slave_get_ethtool_stats(struct net_device *dev,
 		s = per_cpu_ptr(dev->tstats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&s->syncp);
-			tx_packets = s->tx_packets;
-			tx_bytes = s->tx_bytes;
-			rx_packets = s->rx_packets;
-			rx_bytes = s->rx_bytes;
+			tx_packets = u64_stats_read(&s->tx_packets);
+			tx_bytes = u64_stats_read(&s->tx_bytes);
+			rx_packets = u64_stats_read(&s->rx_packets);
+			rx_bytes = u64_stats_read(&s->rx_bytes);
 		} while (u64_stats_fetch_retry_irq(&s->syncp, start));
 		data[0] += tx_packets;
 		data[1] += tx_bytes;
-- 
2.36.1.255.ge46751e96f-goog

