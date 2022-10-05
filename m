Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128D65F542B
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 14:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJEMFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 08:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJEMFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 08:05:12 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3947427DF6
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 05:05:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso919150wmk.2
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 05:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ChX2Cf56JhEWgsWEPTBfPDBZm9CPjucsZ4lKeoQ8AzE=;
        b=FMSPvGuslzWxGUJajgjKNOmLO3wTEjYsEKpzfb1jICkBY5/h1gTehNmtiDyfMNI7bJ
         NBNHcUGBhfREWvy7ag+nA1O+fRTisdXI9DgkmhZndTA8iw0y+H32OMXmEsoCbE48fY84
         m6KWrW/nUiuq3y4PYjHYinLHjjIpDfluf2Pfid3qmS7JywB9+0h4OpTSSbRO2XRoobFA
         zkPqpCm+xHngTbwtXIRBykpVI6zFcSRATzZ7GCha7n62/krJy16PHt4blj01IPo8ftPZ
         EYxFJq4tuCqIEAPvAtNWTzZuqHoufldlNrPw4h5nE0HyH3ee5uIpXCwN1BsEWk5aur0G
         74xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ChX2Cf56JhEWgsWEPTBfPDBZm9CPjucsZ4lKeoQ8AzE=;
        b=5iFII9XzbgAsoYfZcy51sYwBQjWGBdDPnunqc13P7IynMAW6bg4AYZ/s4r6twfJzbe
         9rYdWkBS6coIck65Epf7Oeq3Q956oPjXw4BVv2AK6ve8k0sJSPRearGytE3GcJc/oZJm
         O18b1WT166OoIydbEsnYUIldPgCxHu5e2jdXDREH1ZGOdBXQKJFkIomfkOWhyUe7z0LX
         XZbDFaDxXltVWJHcwuhLDj/NoqdlnhAOSoj5PYU8YnN/Y/jbhXRt9G5v041sl0qAo4c4
         CxUydTuJ08rx7/f3HEs98eAqxE2tKs4jw5NLaS1gMUxzwfztGv4IdL3l0lHqJBzU0qhK
         IKVg==
X-Gm-Message-State: ACrzQf01vgTRvXjtssnP/NQUT+8j+4EjzYniv3o+sw4F4w37QpunVaMO
        9XYaMi8BQfLiMaBnmq8WM+33Rg==
X-Google-Smtp-Source: AMsMyM6gRWq2At8AWaXG0SXWYal7lciklKQw7/JHXuUeSwrpnSeIkV+VSuiHh7cuIFD5DwcUBRbWgg==
X-Received: by 2002:a7b:c84f:0:b0:3b4:84c1:1e7 with SMTP id c15-20020a7bc84f000000b003b484c101e7mr3132468wml.12.1664971508765;
        Wed, 05 Oct 2022 05:05:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v16-20020a5d6790000000b0022e3e7813f0sm7799583wru.107.2022.10.05.05.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 05:05:08 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, edumazet@google.com, khalasa@piap.pl,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/4] net: ethernet: xscale: fix printk issues
Date:   Wed,  5 Oct 2022 12:04:59 +0000
Message-Id: <20221005120501.3527435-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221005120501.3527435-1-clabbe@baylibre.com>
References: <20221005120501.3527435-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix all checkpatch issues about printk and co.
Some pr_xx are replaced by netdev_xxx when appropriate.
Furthermore, there are lot of typo on netdev_debug instead of
netdev_dbg; since this is ifdef-ed debug code, no need for a fixes tag.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 95 ++++++++++++------------
 1 file changed, 46 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 71d36ff7cd1b..b4539dd2cfe4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -462,7 +462,7 @@ static int ixp4xx_mdio_cmd(struct mii_bus *bus, int phy_id, int location,
 	int cycles = 0;
 
 	if (__raw_readl(&mdio_regs->mdio_command[3]) & 0x80) {
-		printk(KERN_ERR "%s: MII not ready to transmit\n", bus->name);
+		pr_err("%s: MII not ready to transmit\n", bus->name);
 		return -1;
 	}
 
@@ -482,14 +482,13 @@ static int ixp4xx_mdio_cmd(struct mii_bus *bus, int phy_id, int location,
 	}
 
 	if (cycles == MAX_MDIO_RETRIES) {
-		printk(KERN_ERR "%s #%i: MII write failed\n", bus->name,
-		       phy_id);
+		pr_err("%s #%i: MII write failed\n", bus->name, phy_id);
 		return -1;
 	}
 
 #if DEBUG_MDIO
-	printk(KERN_DEBUG "%s #%i: mdio_%s() took %i cycles\n", bus->name,
-	       phy_id, write ? "write" : "read", cycles);
+	pr_debug("%s #%i: mdio_%s() took %i cycles\n", bus->name,
+		 phy_id, write ? "write" : "read", cycles);
 #endif
 
 	if (write)
@@ -497,8 +496,7 @@ static int ixp4xx_mdio_cmd(struct mii_bus *bus, int phy_id, int location,
 
 	if (__raw_readl(&mdio_regs->mdio_status[3]) & 0x80) {
 #if DEBUG_MDIO
-		printk(KERN_DEBUG "%s #%i: MII read failed\n", bus->name,
-		       phy_id);
+		pr_debug("%s #%i: MII read failed\n", bus->name, phy_id);
 #endif
 		return 0xFFFF; /* don't return error */
 	}
@@ -516,8 +514,8 @@ static int ixp4xx_mdio_read(struct mii_bus *bus, int phy_id, int location)
 	ret = ixp4xx_mdio_cmd(bus, phy_id, location, 0, 0);
 	spin_unlock_irqrestore(&mdio_lock, flags);
 #if DEBUG_MDIO
-	printk(KERN_DEBUG "%s #%i: MII read [%i] -> 0x%X\n", bus->name,
-	       phy_id, location, ret);
+	pr_debug("%s #%i: MII read [%i] -> 0x%X\n", bus->name, phy_id,
+		 location, ret);
 #endif
 	return ret;
 }
@@ -532,8 +530,8 @@ static int ixp4xx_mdio_write(struct mii_bus *bus, int phy_id, int location,
 	ret = ixp4xx_mdio_cmd(bus, phy_id, location, 1, val);
 	spin_unlock_irqrestore(&mdio_lock, flags);
 #if DEBUG_MDIO
-	printk(KERN_DEBUG "%s #%i: MII write [%i] <- 0x%X, err = %i\n",
-	       bus->name, phy_id, location, val, ret);
+	pr_debug("%s #%i: MII write [%i] <- 0x%X, err = %i\n", bus->name,
+		 phy_id, location, val, ret);
 #endif
 	return ret;
 }
@@ -572,7 +570,7 @@ static void ixp4xx_adjust_link(struct net_device *dev)
 	if (!phydev->link) {
 		if (port->speed) {
 			port->speed = 0;
-			printk(KERN_INFO "%s: link down\n", dev->name);
+			netdev_info(dev, "link down\n");
 		}
 		return;
 	}
@@ -590,8 +588,8 @@ static void ixp4xx_adjust_link(struct net_device *dev)
 		__raw_writel(DEFAULT_TX_CNTRL0 | TX_CNTRL0_HALFDUPLEX,
 			     &port->regs->tx_control[0]);
 
-	netdev_info(dev, "%s: link up, speed %u Mb/s, %s duplex\n",
-		    dev->name, port->speed, port->duplex ? "full" : "half");
+	netdev_info(dev, "link up, speed %u Mb/s, %s duplex\n",
+		    port->speed, port->duplex ? "full" : "half");
 }
 
 static inline void debug_pkt(struct net_device *dev, const char *func,
@@ -600,30 +598,30 @@ static inline void debug_pkt(struct net_device *dev, const char *func,
 #if DEBUG_PKT_BYTES
 	int i;
 
-	netdev_debug(dev, "%s(%i) ", func, len);
+	netdev_dbg(dev, "%s(%i) ", func, len);
 	for (i = 0; i < len; i++) {
 		if (i >= DEBUG_PKT_BYTES)
 			break;
-		printk("%s%02X",
-		       ((i == 6) || (i == 12) || (i >= 14)) ? " " : "",
-		       data[i]);
+		netdev_dbg(dev, "%s%02X",
+			   ((i == 6) || (i == 12) || (i >= 14)) ? " " : "",
+			   data[i]);
 	}
-	printk("\n");
+	netdev_dbg(dev, "\n");
 #endif
 }
 
 static inline void debug_desc(u32 phys, struct desc *desc)
 {
 #if DEBUG_DESC
-	printk(KERN_DEBUG "%X: %X %3X %3X %08X %2X < %2X %4X %X"
-	       " %X %X %02X%02X%02X%02X%02X%02X < %02X%02X%02X%02X%02X%02X\n",
-	       phys, desc->next, desc->buf_len, desc->pkt_len,
-	       desc->data, desc->dest_id, desc->src_id, desc->flags,
-	       desc->qos, desc->padlen, desc->vlan_tci,
-	       desc->dst_mac_0, desc->dst_mac_1, desc->dst_mac_2,
-	       desc->dst_mac_3, desc->dst_mac_4, desc->dst_mac_5,
-	       desc->src_mac_0, desc->src_mac_1, desc->src_mac_2,
-	       desc->src_mac_3, desc->src_mac_4, desc->src_mac_5);
+	pr_debug("%X: %X %3X %3X %08X %2X < %2X %4X %X"
+		 " %X %X %02X%02X%02X%02X%02X%02X < %02X%02X%02X%02X%02X%02X\n",
+		 phys, desc->next, desc->buf_len, desc->pkt_len,
+		 desc->data, desc->dest_id, desc->src_id, desc->flags,
+		 desc->qos, desc->padlen, desc->vlan_tci,
+		 desc->dst_mac_0, desc->dst_mac_1, desc->dst_mac_2,
+		 desc->dst_mac_3, desc->dst_mac_4, desc->dst_mac_5,
+		 desc->src_mac_0, desc->src_mac_1, desc->src_mac_2,
+		 desc->src_mac_3, desc->src_mac_4, desc->src_mac_5);
 #endif
 }
 
@@ -674,7 +672,7 @@ static void eth_rx_irq(void *pdev)
 	struct port *port = netdev_priv(dev);
 
 #if DEBUG_RX
-	printk(KERN_DEBUG "%s: eth_rx_irq\n", dev->name);
+	netdev_dbg(dev, "%s\n", __func__);
 #endif
 	qmgr_disable_irq(port->plat->rxq);
 	napi_schedule(&port->napi);
@@ -688,7 +686,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 	int received = 0;
 
 #if DEBUG_RX
-	netdev_debug(dev, "eth_poll\n");
+	netdev_dbg(dev, "%s\n", __func__);
 #endif
 
 	while (received < budget) {
@@ -702,20 +700,21 @@ static int eth_poll(struct napi_struct *napi, int budget)
 
 		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
 #if DEBUG_RX
-			netdev_debug(dev, "eth_poll napi_complete\n");
+			netdev_dbg(dev, "%s napi_complete\n", __func__);
 #endif
 			napi_complete(napi);
 			qmgr_enable_irq(rxq);
 			if (!qmgr_stat_below_low_watermark(rxq) &&
 			    napi_reschedule(napi)) { /* not empty again */
 #if DEBUG_RX
-				netdev_debug(dev, "eth_poll napi_reschedule succeeded\n");
+				netdev_dbg(dev, "%s napi_reschedule succeeded\n",
+					   __func__);
 #endif
 				qmgr_disable_irq(rxq);
 				continue;
 			}
 #if DEBUG_RX
-			netdev_debug(dev, "eth_poll all done\n");
+			netdev_dbg(dev, "%s all done\n", __func__);
 #endif
 			return received; /* all work done */
 		}
@@ -760,7 +759,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 		skb_reserve(skb, NET_IP_ALIGN);
 		skb_put(skb, desc->pkt_len);
 
-		debug_pkt(dev, "eth_poll", skb->data, skb->len);
+		debug_pkt(dev, __func__, skb->data, skb->len);
 
 		ixp_rx_timestamp(port, skb);
 		skb->protocol = eth_type_trans(skb, dev);
@@ -780,7 +779,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 	}
 
 #if DEBUG_RX
-	netdev_debug(dev, "eth_poll(): end, not all work done\n");
+	netdev_dbg(dev, "%s: end, not all work done\n", __func__);
 #endif
 	return received;		/* not all work done */
 }
@@ -790,7 +789,7 @@ static void eth_txdone_irq(void *unused)
 	u32 phys;
 
 #if DEBUG_TX
-	printk(KERN_DEBUG DRV_NAME ": eth_txdone_irq\n");
+	pr_debug(DRV_NAME ": %s\n", __func__);
 #endif
 	while ((phys = qmgr_get_entry(TXDONE_QUEUE)) != 0) {
 		u32 npe_id, n_desc;
@@ -814,8 +813,8 @@ static void eth_txdone_irq(void *unused)
 
 			dma_unmap_tx(port, desc);
 #if DEBUG_TX
-			printk(KERN_DEBUG "%s: eth_txdone_irq free %p\n",
-			       port->netdev->name, port->tx_buff_tab[n_desc]);
+			netdev_dbg(port->netdev, "%s free %p\n", __func__,
+				   port->tx_buff_tab[n_desc]);
 #endif
 			free_buffer_irq(port->tx_buff_tab[n_desc]);
 			port->tx_buff_tab[n_desc] = NULL;
@@ -825,8 +824,7 @@ static void eth_txdone_irq(void *unused)
 		queue_put_desc(port->plat->txreadyq, phys, desc);
 		if (start) { /* TX-ready queue was empty */
 #if DEBUG_TX
-			printk(KERN_DEBUG "%s: eth_txdone_irq xmit ready\n",
-			       port->netdev->name);
+			netdev_dbg(port->netdev, "%s xmit ready\n", __func__);
 #endif
 			netif_wake_queue(port->netdev);
 		}
@@ -843,7 +841,7 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct desc *desc;
 
 #if DEBUG_TX
-	netdev_debug(dev, "eth_xmit\n");
+	netdev_dbg(dev, "%s\n", __func__);
 #endif
 
 	if (unlikely(skb->len > MAX_MRU)) {
@@ -852,7 +850,7 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	debug_pkt(dev, "eth_xmit", skb->data, skb->len);
+	debug_pkt(dev, __func__, skb->data, skb->len);
 
 	len = skb->len;
 #ifdef __ARMEB__
@@ -898,21 +896,21 @@ static netdev_tx_t eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (qmgr_stat_below_low_watermark(txreadyq)) { /* empty */
 #if DEBUG_TX
-		netdev_debug(dev, "eth_xmit queue full\n");
+		netdev_dbg(dev, "%s queue full\n", __func__);
 #endif
 		netif_stop_queue(dev);
 		/* we could miss TX ready interrupt */
 		/* really empty in fact */
 		if (!qmgr_stat_below_low_watermark(txreadyq)) {
 #if DEBUG_TX
-			netdev_debug(dev, "eth_xmit ready again\n");
+			netdev_dbg(dev, "%s ready again\n", __func__);
 #endif
 			netif_wake_queue(dev);
 		}
 	}
 
 #if DEBUG_TX
-	netdev_debug(dev, "eth_xmit end\n");
+	netdev_dbg(dev, "%s end\n", __func__);
 #endif
 
 	ixp_tx_timestamp(port, skb);
@@ -1077,8 +1075,7 @@ static int request_queues(struct port *port)
 	qmgr_release_queue(port->plat->rxq);
 rel_rxfree:
 	qmgr_release_queue(RXFREE_QUEUE(port->id));
-	printk(KERN_DEBUG "%s: unable to request hardware queues\n",
-	       port->netdev->name);
+	netdev_dbg(port->netdev, "unable to request hardware queues\n");
 	return err;
 }
 
@@ -1327,7 +1324,7 @@ static int eth_close(struct net_device *dev)
 			    " left in NPE\n", buffs);
 #if DEBUG_CLOSE
 	if (!buffs)
-		netdev_debug(dev, "draining RX queue took %i cycles\n", i);
+		netdev_dbg(dev, "draining RX queue took %i cycles\n", i);
 #endif
 
 	buffs = TX_DESCS;
@@ -1347,7 +1344,7 @@ static int eth_close(struct net_device *dev)
 			    "left in NPE\n", buffs);
 #if DEBUG_CLOSE
 	if (!buffs)
-		netdev_debug(dev, "draining TX queues took %i cycles\n", i);
+		netdev_dbg(dev, "draining TX queues took %i cycles\n", i);
 #endif
 
 	msg.byte3 = 0;
-- 
2.35.1

