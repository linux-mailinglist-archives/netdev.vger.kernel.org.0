Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC47456B5A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhKSIN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhKSIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 03:13:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0EC061748
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 00:10:25 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637309422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u4z4KZzApJAKUjf78C7LiERGFGnsrWpuLIEte2H/AUo=;
        b=xnbMUUndcOMXIhXIk2x14+VSqwdAjEm+AjJBfOwa86kZsGK4MYb0clCJUQuuF31QtAu8iQ
        s4eIvHz8FrNbSte7WY8aR28Q2NON6q02eB+iwMozBNgBR4bh0IXh8JLqS8GSOcFGD8x8BP
        v8QGJ1bkMRblgSf8+VR0UMVwRZ/kOVlcSeJp+6Slf5pY/mkq0fEPJyODvej1sdUOHbIMDi
        tI6jfyM3qP1Sjbvb7U80Oxcp+UZHT/I4bSPWugrmKfjHOa0PV0HPabxGC13mSxW1o/zSZy
        RHVoqNTXySouerzAKVLlbODLThtj6LX0Ynwdukjio4pGjbIWFa5aCMRI7BwSKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637309422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u4z4KZzApJAKUjf78C7LiERGFGnsrWpuLIEte2H/AUo=;
        b=LQwiCwTf6e7wOVJ9L1LKhW+5InOuprsPGxeXBVonOg6KcuSlMbR1nBol8o94g2/oiopLS3
        0FQLjdYLmd/Yb2AQ==
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
Subject: [PATCH net-next v1] net: stmmac: Caclucate clock domain crossing error only once
Date:   Fri, 19 Nov 2021 09:10:10 +0100
Message-Id: <20211119081010.27084-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clock domain crossing error (CDC) is calculated at every fetch of Tx or Rx
timestamps. It includes a division. Especially on arm32 based systems it is
expensive. It also saves the two conditionals.

Therefore, move the calculation to the PTP initialization code and just use the
cached value in the timestamp retrieval functions.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Bene, would you mind to test this patch on stm32mp1 too?

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++----------
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  6 ++++++
 include/linux/stmmac.h                            |  1 +
 3 files changed, 9 insertions(+), 10 deletions(-)

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
index 580cc035536b..96b9e4175f08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -309,6 +309,12 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	if (priv->plat->ptp_max_adj)
 		stmmac_ptp_clock_ops.max_adj = priv->plat->ptp_max_adj;
 
+	/* Calculate the clock domain crossing (CDC) error if necessary */
+	priv->plat->cdc_error_adj = 0;
+	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+		priv->plat->cdc_error_adj = (2 * NSEC_PER_SEC) /
+			priv->plat->clk_ptp_rate;
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

