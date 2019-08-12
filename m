Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD68489A3E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfHLJp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:45:28 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:50912 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727560AbfHLJo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 57EBBC2177;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603066; bh=aVo7GYlKYED6lqoZ4b0E1YBatAo6gzyUdXvv7E+gfPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=OuE8lZ7tO+QJ+Z+OAEonfeZnLcV8bAgmFJgEYo2y8GyALV3B1DdmjNsv6oi0RYzrm
         mMCQ+yPnPC+nxWPqK6cf9X6xA7t1xxaM/o1uKb+EEw2VY11uFB6t+7unRPNCi90MFg
         axyEA6mp1lsXd4C8Djpk4BQYX5CvjNcQwHQ/J7cnevXX9Hlda+fopbXeZwVA6QwpEK
         szgYIw/UBDJKKjP7z1rBPIdSm89YKP9KBG3G6tjdHngdeV7fvCQVDrK4eR8SiihR/u
         h2/axZSKBHrOoRIpSDW04EZee8wkY9kdSiiED7P76VBpBkFfGInUX5Vs0iugiMQf1M
         BEKT8z8kGdBAQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D4D89A005C;
        Mon, 12 Aug 2019 09:44:22 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 01/12] net: stmmac: Get correct timestamp values from XGMAC
Date:   Mon, 12 Aug 2019 11:44:00 +0200
Message-Id: <195f374a0b46e5e65a691742fc2dbeffacfaf148.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX Timestamp in XGMAC comes from MAC instead of descriptors. Implement
this in a new callback.

Also, RX Timestamp in XGMAC must be cheked against corruption and we need
a barrier to make sure that descriptor fields are read correctly.

Changes from v1:
	- Rework the get timestamp function (David)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c  | 15 +++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 18 +++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  9 ++++++---
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 767f3fe5efaa..ba5183f38f84 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -997,6 +997,20 @@ static int dwxgmac3_rxp_config(void __iomem *ioaddr,
 	return ret;
 }
 
+static int dwxgmac2_get_mac_tx_timestamp(struct mac_device_info *hw, u64 *ts)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	if (readl_poll_timeout_atomic(ioaddr + XGMAC_TIMESTAMP_STATUS,
+				      value, value & XGMAC_TXTSC, 100, 10000))
+		return -EBUSY;
+
+	*ts = readl(ioaddr + XGMAC_TXTIMESTAMP_NSEC) & XGMAC_TXTSSTSLO;
+	*ts += readl(ioaddr + XGMAC_TXTIMESTAMP_SEC) * 1000000000ULL;
+	return 0;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1033,6 +1047,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.rss_configure = dwxgmac2_rss_configure,
 	.update_vlan_hash = dwxgmac2_update_vlan_hash,
 	.rxp_config = dwxgmac3_rxp_config,
+	.get_mac_tx_timestamp = dwxgmac2_get_mac_tx_timestamp,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 8c5dd6a36157..2391ede97597 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -98,11 +98,17 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
 	unsigned int rdes3 = le32_to_cpu(p->des3);
 	bool desc_valid, ts_valid;
 
+	dma_rmb();
+
 	desc_valid = !(rdes3 & XGMAC_RDES3_OWN) && (rdes3 & XGMAC_RDES3_CTXT);
 	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
 
-	if (likely(desc_valid && ts_valid))
+	if (likely(desc_valid && ts_valid)) {
+		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
+			return -EINVAL;
 		return 0;
+	}
+
 	return -EINVAL;
 }
 
@@ -113,13 +119,11 @@ static int dwxgmac2_get_rx_timestamp_status(void *desc, void *next_desc,
 	unsigned int rdes3 = le32_to_cpu(p->des3);
 	int ret = -EBUSY;
 
-	if (likely(rdes3 & XGMAC_RDES3_CDA)) {
+	if (likely(rdes3 & XGMAC_RDES3_CDA))
 		ret = dwxgmac2_rx_check_timestamp(next_desc);
-		if (ret)
-			return ret;
-	}
-
-	return ret;
+	if (!ret)
+		return 1;
+	return 0;
 }
 
 static void dwxgmac2_init_rx_desc(struct dma_desc *p, int disable_rx_ic,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 52fc2344b066..7e1523c6f456 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -339,6 +339,8 @@ struct stmmac_ops {
 	/* VLAN */
 	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
 				 bool is_double);
+	/* TX Timestamp */
+	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -413,6 +415,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, rss_configure, __args)
 #define stmmac_update_vlan_hash(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, update_vlan_hash, __args)
+#define stmmac_get_mac_tx_timestamp(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, get_mac_tx_timestamp, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06a63df1c2c5..b2e5f4ecd551 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -432,6 +432,7 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
 				   struct dma_desc *p, struct sk_buff *skb)
 {
 	struct skb_shared_hwtstamps shhwtstamp;
+	bool found = false;
 	u64 ns = 0;
 
 	if (!priv->hwts_tx_en)
@@ -443,9 +444,13 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
 
 	/* check tx tstamp status */
 	if (stmmac_get_tx_timestamp_status(priv, p)) {
-		/* get the valid tstamp */
 		stmmac_get_timestamp(priv, p, priv->adv_ts, &ns);
+		found = true;
+	} else if (!stmmac_get_mac_tx_timestamp(priv, priv->hw, &ns)) {
+		found = true;
+	}
 
+	if (found) {
 		memset(&shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamp.hwtstamp = ns_to_ktime(ns);
 
@@ -453,8 +458,6 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
 		/* pass tstamp to stack */
 		skb_tstamp_tx(skb, &shhwtstamp);
 	}
-
-	return;
 }
 
 /* stmmac_get_rx_hwtstamp - get HW RX timestamps
-- 
2.7.4

