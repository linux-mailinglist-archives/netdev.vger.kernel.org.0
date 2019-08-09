Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406E6882AF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436818AbfHISgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:36:50 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:38438 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407213AbfHISgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:36:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 826D9C0AAC
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565375790; bh=xX1Ao9NHmWWlk+Hi0zB/aQRKHxlAAJRCtlk/pEMuzu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=W3VE+lMdD2eB5Bi/j1GYw5hjsPc5RJYuI1dUQr9DHtVtLrP/5B2uSHogVH/jI36O9
         cxmuOQ5KA99ktgPE5eFEIPt4X4dY8iyzJQsaAvnn7RCcnDP8Oe6/WyrHbLVDcj4Pdg
         fRsDlUxqL+xoAg0Aczq6ofLYYj89Ghg1m+aGu+DzWfqmAcKdWFf+IDzN1xQcudpHzA
         zGsU7wEo+7/cJXdhKcLRiF/KXazvZ6mmlsEoYF0YzmVYqr/Uw+3s6b2cm5brYtfoub
         C7v7Jb7QFpVNlAstfker+rd46psYFV7prBzwGMY/6H7BFoeafZeWlDrymtC55PyrbN
         X1iv6hMR7bS+A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 17BADA005D;
        Fri,  9 Aug 2019 18:36:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next 01/12] net: stmmac: Get correct timestamp values from XGMAC
Date:   Fri,  9 Aug 2019 20:36:09 +0200
Message-Id: <7acdee903b01dd5462f687c31163628cefa0e372.1565375521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX Timestamp in XGMAC comes from MAC instead of descriptors. Implement
this in a new callback.

Also, RX Timestamp in XGMAC must be cheked against corruption and we need
a barrier to make sure that descriptor fields are read correctly.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 22 ++++++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   | 18 +++++++++++-------
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  4 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  9 ++++++---
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 767f3fe5efaa..1161287d3a62 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -997,6 +997,27 @@ static int dwxgmac3_rxp_config(void __iomem *ioaddr,
 	return ret;
 }
 
+static int dwxgmac2_get_mac_tx_timestamp(struct mac_device_info *hw, u64 *ts)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	int count = 0;
+	u32 value;
+
+	do {
+		if (readl_poll_timeout_atomic(ioaddr + XGMAC_TIMESTAMP_STATUS,
+					      value, value & XGMAC_TXTSC,
+					      100, 10000))
+			break;
+
+		*ts = readl(ioaddr + XGMAC_TXTIMESTAMP_NSEC) & XGMAC_TXTSSTSLO;
+		*ts += readl(ioaddr + XGMAC_TXTIMESTAMP_SEC) * 1000000000ULL;
+	} while (count++);
+
+	if (count)
+		return 0;
+	return -EBUSY;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1033,6 +1054,7 @@ const struct stmmac_ops dwxgmac210_ops = {
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
index 2274bb58eefa..46e240b219fc 100644
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

