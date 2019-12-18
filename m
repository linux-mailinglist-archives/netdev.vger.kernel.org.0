Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15FC123BF8
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLRAwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:52:04 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34646 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLRAv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so274721pgf.1;
        Tue, 17 Dec 2019 16:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bC8xpGTpq9fn64v8maHj0PUZzceljBSRagYcgY19Ysc=;
        b=Ij4UyBP0+yncgWMhW9jTEDQ5mISHpRzjJO2lz81cDjg/apiem84HH34uKP6hpRent5
         hC1yVOH/oQE7I1y4PjlLqB8YUwg7cRUlYXprIxZ87QA94eF28TSaEmSBQdxSq/59wUH8
         wWgtubRYo5aOR+pBcbwuIZOULF1VpnD1pin3aN55JsSYbkvEk8GLf4NLtpdm2uIDu63n
         K/uKjzX7MHvGxRlynUjMsjSF+fbKo032g+0AdcWDIwOIwCo5E9YyppyTkBbXPcy3LrLU
         P4N99/emBUSmkrWQx2h+e/JUa8kK5WRl/E03XYlwN+0yorpugzr2N1cX4okVusAWg0PH
         agkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bC8xpGTpq9fn64v8maHj0PUZzceljBSRagYcgY19Ysc=;
        b=UjaiwkTrreR/8wt0DKJMKH3srLCvFXIYrugszv9+DK9WjYld0sy7bdzwcdtUsMKc1x
         LggjJV3V+Dks6D2QnvCd2juEzM0Aqk5XJhxQUFjNb0Bm1rF/WGe6shFN736y10rRx/8n
         Dwg4+mplKMaL7dYJUUoLeXuO2PHmFkz8bYnD3P+/z8ZoII5w8ZBsWSs5yv5+IuiQqFQU
         IXvLVZHLwbkdIFUbi0IMMrAV1WxYEQNC8OL7Sk73vOxoSwObRAiECMJXMV11MbAGojAQ
         Aj0Ek4JNT2N7I8o4jBcmlehf/E7sdAcRQ9nnxbECz+sqk49FjfpVMLDCTErp/REgAzJg
         ApMw==
X-Gm-Message-State: APjAAAVkc8MBvcivrsYCMV3K330qpqZlk8T0xcgsj/O43g448vBcxSne
        83Y/FEEFb1O8j8bq/Ufcf5k=
X-Google-Smtp-Source: APXvYqyqTWoFY8MRxUvPLlKkbLUkYwGc5QFw+1oM53gP0bvANui5aMPMfsh4NEBZGwOW0t/dROls0w==
X-Received: by 2002:a62:788a:: with SMTP id t132mr719812pfc.134.1576630288887;
        Tue, 17 Dec 2019 16:51:28 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:28 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM
Date:   Tue, 17 Dec 2019 16:51:10 -0800
Message-Id: <1576630275-17591-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit updates the Rx checksum offload behavior of the driver
to use the more generic CHECKSUM_COMPLETE method that supports all
protocols over the CHECKSUM_UNNECESSARY method that only applies
to some protocols known by the hardware.

This behavior is perceived to be superior.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 19 +++++++------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |  2 +-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index cd07b3ad1d53..13cbe5828adb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -521,7 +521,7 @@ static int bcmgenet_set_rx_csum(struct net_device *dev,
 
 	/* enable rx checksumming */
 	if (rx_csum_en)
-		rbuf_chk_ctrl |= RBUF_RXCHK_EN;
+		rbuf_chk_ctrl |= RBUF_RXCHK_EN | RBUF_L3_PARSE_DIS;
 	else
 		rbuf_chk_ctrl &= ~RBUF_RXCHK_EN;
 	priv->desc_rxchk_en = rx_csum_en;
@@ -1739,7 +1739,6 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 	unsigned int bytes_processed = 0;
 	unsigned int p_index, mask;
 	unsigned int discards;
-	unsigned int chksum_ok = 0;
 
 	/* Clear status before servicing to reduce spurious interrupts */
 	if (ring->index == DESC_INDEX) {
@@ -1790,9 +1789,15 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 				dmadesc_get_length_status(priv, cb->bd_addr);
 		} else {
 			struct status_64 *status;
+			__be16 rx_csum;
 
 			status = (struct status_64 *)skb->data;
 			dma_length_status = status->length_status;
+			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
+			if (priv->desc_rxchk_en) {
+				skb->csum = (__force __wsum)ntohs(rx_csum);
+				skb->ip_summed = CHECKSUM_COMPLETE;
+			}
 		}
 
 		/* DMA flags and length are still valid no matter how
@@ -1835,18 +1840,12 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			goto next;
 		} /* error packet */
 
-		chksum_ok = (dma_flag & priv->dma_rx_chk_bit) &&
-			     priv->desc_rxchk_en;
-
 		skb_put(skb, len);
 		if (priv->desc_64b_en) {
 			skb_pull(skb, 64);
 			len -= 64;
 		}
 
-		if (likely(chksum_ok))
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-
 		/* remove hardware 2bytes added for IP alignment */
 		skb_pull(skb, 2);
 		len -= 2;
@@ -3322,19 +3321,15 @@ static void bcmgenet_set_hw_params(struct bcmgenet_priv *priv)
 	if (GENET_IS_V5(priv) || GENET_IS_V4(priv)) {
 		bcmgenet_dma_regs = bcmgenet_dma_regs_v3plus;
 		genet_dma_ring_regs = genet_dma_ring_regs_v4;
-		priv->dma_rx_chk_bit = DMA_RX_CHK_V3PLUS;
 	} else if (GENET_IS_V3(priv)) {
 		bcmgenet_dma_regs = bcmgenet_dma_regs_v3plus;
 		genet_dma_ring_regs = genet_dma_ring_regs_v123;
-		priv->dma_rx_chk_bit = DMA_RX_CHK_V3PLUS;
 	} else if (GENET_IS_V2(priv)) {
 		bcmgenet_dma_regs = bcmgenet_dma_regs_v2;
 		genet_dma_ring_regs = genet_dma_ring_regs_v123;
-		priv->dma_rx_chk_bit = DMA_RX_CHK_V12;
 	} else if (GENET_IS_V1(priv)) {
 		bcmgenet_dma_regs = bcmgenet_dma_regs_v1;
 		genet_dma_ring_regs = genet_dma_ring_regs_v123;
-		priv->dma_rx_chk_bit = DMA_RX_CHK_V12;
 	}
 
 	/* enum genet_version starts at 1 */
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index a5659197598f..d33c0d093f82 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -251,6 +251,7 @@ struct bcmgenet_mib_counters {
 #define RBUF_CHK_CTRL			0x14
 #define  RBUF_RXCHK_EN			(1 << 0)
 #define  RBUF_SKIP_FCS			(1 << 4)
+#define  RBUF_L3_PARSE_DIS		(1 << 5)
 
 #define RBUF_ENERGY_CTRL		0x9c
 #define  RBUF_EEE_EN			(1 << 0)
@@ -663,7 +664,6 @@ struct bcmgenet_priv {
 	bool desc_rxchk_en;
 	bool crc_fwd_en;
 
-	unsigned int dma_rx_chk_bit;
 	u32 dma_max_burst_length;
 
 	u32 msg_enable;
-- 
2.7.4

