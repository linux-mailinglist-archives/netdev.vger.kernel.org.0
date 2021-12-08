Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030946D063
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 10:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhLHJ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:58:41 -0500
Received: from inva020.nxp.com ([92.121.34.13]:42628 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhLHJ6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 04:58:41 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B39191A05C1;
        Wed,  8 Dec 2021 10:55:08 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 50C9A1A05A5;
        Wed,  8 Dec 2021 10:55:08 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 332CE183AC4E;
        Wed,  8 Dec 2021 17:55:06 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, sonic.zhang@analog.com,
        Joao.Pinto@synopsys.com, mingkai.hu@nxp.com, leoyang.li@nxp.com,
        xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next] net: stmmac: bump tc when get underflow error from DMA descriptor
Date:   Wed,  8 Dec 2021 18:06:51 +0800
Message-Id: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In DMA threshold mode, frame underflow errors may sometimes occur when
the TC(threshold control) value is not enough. The TC value need to be
bumped up in this case.

There is no underflow interrupt bit on DMA_CH(#i)_Status of dwmac4, so
the DMA threshold cannot be bumped up in stmmac_dma_interrupt(). The
i.mx8mp board observed an underflow error while running NFS boot, the
NFS rootfs could not be mounted.

The underflow error can be got from the DMA descriptor TDES3 on dwmac4.
This patch bump up tc value once underflow error is got from TDES3.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  8 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 51 ++++++++-----------
 3 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 9160f9ed363a..6b5d96bced47 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -317,6 +317,7 @@ enum tx_frame_status {
 	tx_not_ls = 0x1,
 	tx_err = 0x2,
 	tx_dma_own = 0x4,
+	tx_err_bump_tc = 0x8,
 };
 
 enum dma_irq_status {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index cbf4429fb1d2..d3b4765c1a5b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -32,6 +32,8 @@ static int dwmac4_wrback_get_tx_status(void *data, struct stmmac_extra_stats *x,
 		return tx_not_ls;
 
 	if (unlikely(tdes3 & TDES3_ERROR_SUMMARY)) {
+		ret = tx_err;
+
 		if (unlikely(tdes3 & TDES3_JABBER_TIMEOUT))
 			x->tx_jabber++;
 		if (unlikely(tdes3 & TDES3_PACKET_FLUSHED))
@@ -53,16 +55,16 @@ static int dwmac4_wrback_get_tx_status(void *data, struct stmmac_extra_stats *x,
 		if (unlikely(tdes3 & TDES3_EXCESSIVE_DEFERRAL))
 			x->tx_deferred++;
 
-		if (unlikely(tdes3 & TDES3_UNDERFLOW_ERROR))
+		if (unlikely(tdes3 & TDES3_UNDERFLOW_ERROR)) {
 			x->tx_underflow++;
+			ret |= tx_err_bump_tc;
+		}
 
 		if (unlikely(tdes3 & TDES3_IP_HDR_ERROR))
 			x->tx_ip_header_error++;
 
 		if (unlikely(tdes3 & TDES3_PAYLOAD_ERROR))
 			x->tx_payload_error++;
-
-		ret = tx_err;
 	}
 
 	if (unlikely(tdes3 & TDES3_DEFERRED))
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4e05c1d92935..7e3e1bc0f61d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -132,6 +132,8 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data);
 static irqreturn_t stmmac_msi_intr_rx(int irq, void *data);
 static void stmmac_tx_timer_arm(struct stmmac_priv *priv, u32 queue);
 static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue);
+static void stmmac_set_dma_operation_mode(struct stmmac_priv *priv, u32 txmode,
+					  u32 rxmode, u32 chan);
 
 #ifdef CONFIG_DEBUG_FS
 static const struct net_device_ops stmmac_netdev_ops;
@@ -2466,6 +2468,21 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	return !!budget && work_done;
 }
 
+static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
+{
+	if (unlikely(priv->xstats.threshold != SF_DMA_MODE) && tc <= 256) {
+		tc += 64;
+
+		if (priv->plat->force_thresh_dma_mode)
+			stmmac_set_dma_operation_mode(priv, tc, tc, chan);
+		else
+			stmmac_set_dma_operation_mode(priv, tc, SF_DMA_MODE,
+						      chan);
+
+		priv->xstats.threshold = tc;
+	}
+}
+
 /**
  * stmmac_tx_clean - to manage the transmission completion
  * @priv: driver private structure
@@ -2531,6 +2548,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 			/* ... verify the status error condition */
 			if (unlikely(status & tx_err)) {
 				priv->dev->stats.tx_errors++;
+				if (unlikely(status & tx_err_bump_tc))
+					stmmac_bump_dma_threshold(priv, queue);
 			} else {
 				priv->dev->stats.tx_packets++;
 				priv->xstats.tx_pkt_n++;
@@ -2781,21 +2800,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	for (chan = 0; chan < tx_channel_count; chan++) {
 		if (unlikely(status[chan] & tx_hard_error_bump_tc)) {
 			/* Try to bump up the dma threshold on this failure */
-			if (unlikely(priv->xstats.threshold != SF_DMA_MODE) &&
-			    (tc <= 256)) {
-				tc += 64;
-				if (priv->plat->force_thresh_dma_mode)
-					stmmac_set_dma_operation_mode(priv,
-								      tc,
-								      tc,
-								      chan);
-				else
-					stmmac_set_dma_operation_mode(priv,
-								    tc,
-								    SF_DMA_MODE,
-								    chan);
-				priv->xstats.threshold = tc;
-			}
+			stmmac_bump_dma_threshold(priv, chan);
 		} else if (unlikely(status[chan] == tx_hard_error)) {
 			stmmac_tx_err(priv, chan);
 		}
@@ -5745,21 +5750,7 @@ static irqreturn_t stmmac_msi_intr_tx(int irq, void *data)
 
 	if (unlikely(status & tx_hard_error_bump_tc)) {
 		/* Try to bump up the dma threshold on this failure */
-		if (unlikely(priv->xstats.threshold != SF_DMA_MODE) &&
-		    tc <= 256) {
-			tc += 64;
-			if (priv->plat->force_thresh_dma_mode)
-				stmmac_set_dma_operation_mode(priv,
-							      tc,
-							      tc,
-							      chan);
-			else
-				stmmac_set_dma_operation_mode(priv,
-							      tc,
-							      SF_DMA_MODE,
-							      chan);
-			priv->xstats.threshold = tc;
-		}
+		stmmac_bump_dma_threshold(priv, chan);
 	} else if (unlikely(status == tx_hard_error)) {
 		stmmac_tx_err(priv, chan);
 	}
-- 
2.17.1

