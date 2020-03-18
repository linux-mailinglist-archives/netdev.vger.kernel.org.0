Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BC18926A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCRAGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:06:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45913 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgCRAGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 20:06:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id i9so210106wrx.12;
        Tue, 17 Mar 2020 17:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ivroU4SMBO6WrLFD/DQBl+FGZj3wa8hpD1DVx5AiWIs=;
        b=TOOeKbl2u8nY6AguoTcnhYBylv0SpaztEEFOIjfXF1mk7HkYTfBx5bKoV3zaKyFqUz
         Vp1M/6lF2Xu+NKLpoeKVP6EHn7/oiCff782RmVddPY5GlNblWO6L5APCkOH+00eC4ZG+
         iLHXA/JtfwYphEqXzsgUTLF6Wk6pbyn3a+VUV6j2qIZ6h6buA06EOS/RGn4+IoBfRumB
         us4J6kwHJwz9Z/6zM4VQBtNkfRyxv0OV/ciQnhP0YED4YiMI9epCO9Ddm1cI+C2coDiT
         eNx1uLTxdNA3pfKuZDI+/fSneA9IPqRt1Q6eFGadwsFAlLRCXWWG5n2ilRUbtNNk5sf8
         8sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ivroU4SMBO6WrLFD/DQBl+FGZj3wa8hpD1DVx5AiWIs=;
        b=F3WK2ju3X7tjBfEpVnrSrZwJEfFIfitR+qB6v+wzcsk9kIhKUAPXvlHHeOzTW2cAgU
         4jlC8ipcnK2waWLGmjRQwguwfIoHq5XyGcVPNM41oth6oL4YiGuQVN4+INFTdDVYCJ6L
         rvVq/45mnAdw4Ct9bN4yKe+uhXjSHiHLu8rCWO6bgWDIj+pVG+VkjQqxG3fqAq50t9vE
         c5HtVFJz+EywUSUSQ+1kO/bmLqP2qpSAlJiyZFO3vvMmlCtxm5zaWO4+/ev2caHt1ysL
         hKPSWt8+5y4NVylTzxqvBRQzTWvJtRkxoME9D+NP2wcUXMTTUcmbAtvnq55y9CtAlDWT
         rP8w==
X-Gm-Message-State: ANhLgQ2HJXUTMwgjfsaMfVvtoQFQI+eyX1NxWoxiLbP1R9kauR0m/10N
        zSEKKTLegrrkEoTdzh1kOoVE2OlI
X-Google-Smtp-Source: ADFU+vu0MePlTQghRV0It6x3ep4eI/YVbfl6K1UAaov8pcRxHd1hzPZ3Uz04OeZ9LCXkLVjOAUPIHA==
X-Received: by 2002:adf:bc04:: with SMTP id s4mr1562716wrg.244.1584489961804;
        Tue, 17 Mar 2020 17:06:01 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u1sm6606856wrt.78.2020.03.17.17.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Mar 2020 17:06:01 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net] net: bcmgenet: always enable status blocks
Date:   Tue, 17 Mar 2020 17:05:36 -0700
Message-Id: <1584489936-26812-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware offloading of the NETIF_F_HW_CSUM and NETIF_F_RXCSUM
features requires the use of Transmit Status Blocks before transmit
frame data and Receive Status Blocks before receive frame data to
carry the checksum information.

Unfortunately, these status blocks are currently only enabled when
the NETIF_F_HW_CSUM feature is enabled. As a result NETIF_F_RXCSUM
will not actually be offloaded to the hardware unless both it and
NETIF_F_HW_CSUM are enabled. Fortunately, that is the default
configuration.

This commit addresses this issue by always enabling the use of
status blocks on both transmit and receive frames. Further, it
replaces the use of a dedicated flag within the driver private
data structure with direct use of the netdev features flags.

Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 132 +++++++------------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   3 +-
 2 files changed, 38 insertions(+), 97 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e50a15397e11..fe3a510e9d5a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -94,12 +94,6 @@ static inline void dmadesc_set_length_status(struct bcmgenet_priv *priv,
 	bcmgenet_writel(value, d + DMA_DESC_LENGTH_STATUS);
 }
 
-static inline u32 dmadesc_get_length_status(struct bcmgenet_priv *priv,
-					    void __iomem *d)
-{
-	return bcmgenet_readl(d + DMA_DESC_LENGTH_STATUS);
-}
-
 static inline void dmadesc_set_addr(struct bcmgenet_priv *priv,
 				    void __iomem *d,
 				    dma_addr_t addr)
@@ -508,61 +502,6 @@ static int bcmgenet_set_link_ksettings(struct net_device *dev,
 	return phy_ethtool_ksettings_set(dev->phydev, cmd);
 }
 
-static void bcmgenet_set_rx_csum(struct net_device *dev,
-				 netdev_features_t wanted)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-	u32 rbuf_chk_ctrl;
-	bool rx_csum_en;
-
-	rx_csum_en = !!(wanted & NETIF_F_RXCSUM);
-
-	rbuf_chk_ctrl = bcmgenet_rbuf_readl(priv, RBUF_CHK_CTRL);
-
-	/* enable rx checksumming */
-	if (rx_csum_en)
-		rbuf_chk_ctrl |= RBUF_RXCHK_EN | RBUF_L3_PARSE_DIS;
-	else
-		rbuf_chk_ctrl &= ~RBUF_RXCHK_EN;
-	priv->desc_rxchk_en = rx_csum_en;
-
-	/* If UniMAC forwards CRC, we need to skip over it to get
-	 * a valid CHK bit to be set in the per-packet status word
-	*/
-	if (rx_csum_en && priv->crc_fwd_en)
-		rbuf_chk_ctrl |= RBUF_SKIP_FCS;
-	else
-		rbuf_chk_ctrl &= ~RBUF_SKIP_FCS;
-
-	bcmgenet_rbuf_writel(priv, rbuf_chk_ctrl, RBUF_CHK_CTRL);
-}
-
-static void bcmgenet_set_tx_csum(struct net_device *dev,
-				 netdev_features_t wanted)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-	bool desc_64b_en;
-	u32 tbuf_ctrl, rbuf_ctrl;
-
-	tbuf_ctrl = bcmgenet_tbuf_ctrl_get(priv);
-	rbuf_ctrl = bcmgenet_rbuf_readl(priv, RBUF_CTRL);
-
-	desc_64b_en = !!(wanted & NETIF_F_HW_CSUM);
-
-	/* enable 64 bytes descriptor in both directions (RBUF and TBUF) */
-	if (desc_64b_en) {
-		tbuf_ctrl |= RBUF_64B_EN;
-		rbuf_ctrl |= RBUF_64B_EN;
-	} else {
-		tbuf_ctrl &= ~RBUF_64B_EN;
-		rbuf_ctrl &= ~RBUF_64B_EN;
-	}
-	priv->desc_64b_en = desc_64b_en;
-
-	bcmgenet_tbuf_ctrl_set(priv, tbuf_ctrl);
-	bcmgenet_rbuf_writel(priv, rbuf_ctrl, RBUF_CTRL);
-}
-
 static int bcmgenet_set_features(struct net_device *dev,
 				 netdev_features_t features)
 {
@@ -578,9 +517,6 @@ static int bcmgenet_set_features(struct net_device *dev,
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	priv->crc_fwd_en = !!(reg & CMD_CRC_FWD);
 
-	bcmgenet_set_tx_csum(dev, features);
-	bcmgenet_set_rx_csum(dev, features);
-
 	clk_disable_unprepare(priv->clk);
 
 	return ret;
@@ -1475,8 +1411,8 @@ static void bcmgenet_tx_reclaim_all(struct net_device *dev)
 /* Reallocate the SKB to put enough headroom in front of it and insert
  * the transmit checksum offsets in the descriptors
  */
-static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
-					    struct sk_buff *skb)
+static struct sk_buff *bcmgenet_add_tsb(struct net_device *dev,
+					struct sk_buff *skb)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct status_64 *status = NULL;
@@ -1590,13 +1526,11 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	GENET_CB(skb)->bytes_sent = skb->len;
 
-	/* set the SKB transmit checksum */
-	if (priv->desc_64b_en) {
-		skb = bcmgenet_put_tx_csum(dev, skb);
-		if (!skb) {
-			ret = NETDEV_TX_OK;
-			goto out;
-		}
+	/* add the Transmit Status Block */
+	skb = bcmgenet_add_tsb(dev, skb);
+	if (!skb) {
+		ret = NETDEV_TX_OK;
+		goto out;
 	}
 
 	for (i = 0; i <= nr_frags; i++) {
@@ -1775,6 +1709,9 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 
 	while ((rxpktprocessed < rxpkttoprocess) &&
 	       (rxpktprocessed < budget)) {
+		struct status_64 *status;
+		__be16 rx_csum;
+
 		cb = &priv->rx_cbs[ring->read_ptr];
 		skb = bcmgenet_rx_refill(priv, cb);
 
@@ -1783,20 +1720,12 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			goto next;
 		}
 
-		if (!priv->desc_64b_en) {
-			dma_length_status =
-				dmadesc_get_length_status(priv, cb->bd_addr);
-		} else {
-			struct status_64 *status;
-			__be16 rx_csum;
-
-			status = (struct status_64 *)skb->data;
-			dma_length_status = status->length_status;
+		status = (struct status_64 *)skb->data;
+		dma_length_status = status->length_status;
+		if (dev->features & NETIF_F_RXCSUM) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
-			if (priv->desc_rxchk_en) {
-				skb->csum = (__force __wsum)ntohs(rx_csum);
-				skb->ip_summed = CHECKSUM_COMPLETE;
-			}
+			skb->csum = (__force __wsum)ntohs(rx_csum);
+			skb->ip_summed = CHECKSUM_COMPLETE;
 		}
 
 		/* DMA flags and length are still valid no matter how
@@ -1840,14 +1769,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		} /* error packet */
 
 		skb_put(skb, len);
-		if (priv->desc_64b_en) {
-			skb_pull(skb, 64);
-			len -= 64;
-		}
 
-		/* remove hardware 2bytes added for IP alignment */
-		skb_pull(skb, 2);
-		len -= 2;
+		/* remove RSB and hardware 2bytes added for IP alignment */
+		skb_pull(skb, 66);
+		len -= 66;
 
 		if (priv->crc_fwd_en) {
 			skb_trim(skb, len - ETH_FCS_LEN);
@@ -2038,11 +1963,28 @@ static void init_umac(struct bcmgenet_priv *priv)
 
 	bcmgenet_umac_writel(priv, ENET_MAX_MTU_SIZE, UMAC_MAX_FRAME_LEN);
 
-	/* init rx registers, enable ip header optimization */
+	/* init tx registers, enable TSB */
+	reg = bcmgenet_tbuf_ctrl_get(priv);
+	reg |= TBUF_64B_EN;
+	bcmgenet_tbuf_ctrl_set(priv, reg);
+
+	/* init rx registers, enable ip header optimization and RSB */
 	reg = bcmgenet_rbuf_readl(priv, RBUF_CTRL);
-	reg |= RBUF_ALIGN_2B;
+	reg |= RBUF_ALIGN_2B | RBUF_64B_EN;
 	bcmgenet_rbuf_writel(priv, reg, RBUF_CTRL);
 
+	/* enable rx checksumming */
+	reg = bcmgenet_rbuf_readl(priv, RBUF_CHK_CTRL);
+	reg |= RBUF_RXCHK_EN | RBUF_L3_PARSE_DIS;
+	/* If UniMAC forwards CRC, we need to skip over it to get
+	 * a valid CHK bit to be set in the per-packet status word
+	 */
+	if (priv->crc_fwd_en)
+		reg |= RBUF_SKIP_FCS;
+	else
+		reg &= ~RBUF_SKIP_FCS;
+	bcmgenet_rbuf_writel(priv, reg, RBUF_CHK_CTRL);
+
 	if (!GENET_IS_V1(priv) && !GENET_IS_V2(priv))
 		bcmgenet_rbuf_writel(priv, 1, RBUF_TBUF_SIZE_CTRL);
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 61a6fe9f4cec..daf8fb2c39b6 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -273,6 +273,7 @@ struct bcmgenet_mib_counters {
 #define  RBUF_FLTR_LEN_SHIFT		8
 
 #define TBUF_CTRL			0x00
+#define  TBUF_64B_EN			(1 << 0)
 #define TBUF_BP_MC			0x0C
 #define TBUF_ENERGY_CTRL		0x14
 #define  TBUF_EEE_EN			(1 << 0)
@@ -662,8 +663,6 @@ struct bcmgenet_priv {
 	unsigned int irq0_stat;
 
 	/* HW descriptors/checksum variables */
-	bool desc_64b_en;
-	bool desc_rxchk_en;
 	bool crc_fwd_en;
 
 	u32 dma_max_burst_length;
-- 
2.7.4

