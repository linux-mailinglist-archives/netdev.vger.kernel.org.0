Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE25458D41
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 12:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhKVLWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 06:22:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59100 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhKVLWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 06:22:42 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637579975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=18h7AWE82V/ymcyoQ30Rf8aLfEhY3Kk3Mvu3zde2ltM=;
        b=Hqb4lRVUCFHVpi9hFPpHek6pfnQNd1MEEDmaNVOTbVVGxWwz+1MYBzQ8eXSCet5b7+T+z/
        M74V7QpbOAJTqglw0A5GYe9hKvbb5aBTsvOnJwhMrvA8u8rRMklUnJbUeXYI6atWD6pvpo
        gUD7b5snw60u4TlBWr19PiDW7758Z85ZXhep6Av9OFFKcMEror0Q6OPwPfW5eE0C23xNIp
        k4oWxUYXijUbCS4uzzqtuHnwrMjqPnnRJKRkkQMeZgGsC02kIu4iR1UZMTkobUvNwhWmeE
        ACZ59z0ZKCTbaAfHiVsiEVeTeRriAvEjVhGHK02s/ES2ov/JQXvdCQEZo0HnSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637579975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=18h7AWE82V/ymcyoQ30Rf8aLfEhY3Kk3Mvu3zde2ltM=;
        b=z4vbqy1CcgeV9jwPmSdgX8TTZmfK7f4+ewud9RA5Kcl00rhxKCwFw2GGNGSL/8Wvc7h+pP
        552T4/+n0Ts2DjBw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Benedikt Spranger <b.spranger@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next v2] net: stmmac: Caclucate CDC error only once
Date:   Mon, 22 Nov 2021 12:19:31 +0100
Message-Id: <20211122111931.135135-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clock domain crossing error (CDC) is calculated at every fetch of Tx or Rx
timestamps. It includes a division. Especially on arm32 based systems it is
expensive. It also requires two conditionals in the hotpath.

Add a compensation value cache to struct plat_stmmacenet_data and subtract it
unconditionally in the RX/TX functions which spares the conditionals.

The value is initialized to 0 and if supported calculated in the PTP
initialization code.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Changes since v1:

 * Coding style
 * Changelog

Previous version:

 * https://lore.kernel.org/netdev/20211119081010.27084-1-kurt@linutronix.de/

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++----------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  5 +++++
 include/linux/stmmac.h                            |  1 +
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 21111df73719..340076b5bb38 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -511,14 +511,6 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 	return true;
 }
 
-static inline u32 stmmac_cdc_adjust(struct stmmac_priv *priv)
-{
-	/* Correct the clk domain crossing(CDC) error */
-	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
-		return (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
-	return 0;
-}
-
 /* stmmac_get_tx_hwtstamp - get HW TX timestamps
  * @priv: driver private structure
  * @p : descriptor pointer
@@ -550,7 +542,7 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
 	}
 
 	if (found) {
-		ns -= stmmac_cdc_adjust(priv);
+		ns -= priv->plat->cdc_error_adj;
 
 		memset(&shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamp.hwtstamp = ns_to_ktime(ns);
@@ -587,7 +579,7 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
 	if (stmmac_get_rx_timestamp_status(priv, p, np, priv->adv_ts)) {
 		stmmac_get_timestamp(priv, desc, priv->adv_ts, &ns);
 
-		ns -= stmmac_cdc_adjust(priv);
+		ns -= priv->plat->cdc_error_adj;
 
 		netdev_dbg(priv->dev, "get valid RX hw timestamp %llu\n", ns);
 		shhwtstamp = skb_hwtstamps(skb);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 580cc035536b..e14c97c04317 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -309,6 +309,11 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	if (priv->plat->ptp_max_adj)
 		stmmac_ptp_clock_ops.max_adj = priv->plat->ptp_max_adj;
 
+	/* Calculate the clock domain crossing (CDC) error if necessary */
+	priv->plat->cdc_error_adj = 0;
+	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+		priv->plat->cdc_error_adj = (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
+
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a6f03b36fc4f..89b8e208cd7b 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -241,6 +241,7 @@ struct plat_stmmacenet_data {
 	unsigned int clk_ref_rate;
 	unsigned int mult_fact_100ns;
 	s32 ptp_max_adj;
+	u32 cdc_error_adj;
 	struct reset_control *stmmac_rst;
 	struct reset_control *stmmac_ahb_rst;
 	struct stmmac_axi *axi;
-- 
2.30.2

