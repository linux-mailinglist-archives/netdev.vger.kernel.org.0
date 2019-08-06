Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB19483319
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbfHFNnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:43:25 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:59138 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731743AbfHFNm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:42:57 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A7958C21CB;
        Tue,  6 Aug 2019 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565098977; bh=UMdKazi2ciy8p7Dqk2nYpbPetDS5ZYs/bBD4Obco2ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DPDKUsg/4Q2f+C9dYGmOOjoDbtfn1gmf/6XTls33zst/6XS2cnDSYiB9VJMDUanaQ
         G+cuMXQYazF0qERr9Pzgu/zbHjwzVamYVLI1/KpIrVumh6Z7zSC3ZTgyhPzgoaNvtO
         utF8EcEJ2HpbJHH/jxnvJ4Gnc8+Hz0I8F2q1ZdFNmthnJbBu6ZyVNPPfQU554n7EG8
         gaazJmJm7kCprwA+52F8l+84ROz1D5yXTQ8EbBApsw84Pe76SoUXrp3NES3YXWB5IQ
         MKVSEpiKp0gXTFEnuftCkxeGQZNieF4NBRaCnAOkaZ22hnWQ6XFX4x3Pw69t+sHb6j
         BV8mYdbHrBrAA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 64ED2A0077;
        Tue,  6 Aug 2019 13:42:55 +0000 (UTC)
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
Subject: [PATCH net-next v2 09/10] net: stmmac: Add Flexible RX Parser support in XGMAC
Date:   Tue,  6 Aug 2019 15:42:50 +0200
Message-Id: <a71314ff34b39bbfbc0c7af07a97d8d74ffef193.1565098881.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMAC cores also support the Flexible RX Parser feature. Add the support
for it in the XGMAC core.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  13 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 190 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   3 +
 3 files changed, 206 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index f31cece89d86..51ee03895e8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -110,6 +110,9 @@
 #define XGMAC_HWFEAT_RXQCNT		GENMASK(3, 0)
 #define XGMAC_HW_FEATURE3		0x00000128
 #define XGMAC_HWFEAT_ASP		GENMASK(15, 14)
+#define XGMAC_HWFEAT_FRPES		GENMASK(12, 11)
+#define XGMAC_HWFEAT_FRPPB		GENMASK(10, 9)
+#define XGMAC_HWFEAT_FRPSEL		BIT(3)
 #define XGMAC_MAC_DPP_FSM_INT_STATUS	0x00000150
 #define XGMAC_MAC_FSM_CONTROL		0x00000158
 #define XGMAC_PRTYEN			BIT(1)
@@ -142,6 +145,7 @@
 
 /* MTL Registers */
 #define XGMAC_MTL_OPMODE		0x00001000
+#define XGMAC_FRPE			BIT(15)
 #define XGMAC_ETSALG			GENMASK(6, 5)
 #define XGMAC_WRR			(0x0 << 5)
 #define XGMAC_WFQ			(0x1 << 5)
@@ -157,6 +161,15 @@
 #define XGMAC_TC_PRTY_MAP1		0x00001044
 #define XGMAC_PSTC(x)			GENMASK((x) * 8 + 7, (x) * 8)
 #define XGMAC_PSTC_SHIFT(x)		((x) * 8)
+#define XGMAC_MTL_RXP_CONTROL_STATUS	0x000010a0
+#define XGMAC_RXPI			BIT(31)
+#define XGMAC_NPE			GENMASK(23, 16)
+#define XGMAC_NVE			GENMASK(7, 0)
+#define XGMAC_MTL_RXP_IACC_CTRL_ST	0x000010b0
+#define XGMAC_STARTBUSY			BIT(31)
+#define XGMAC_WRRDN			BIT(16)
+#define XGMAC_ADDR			GENMASK(9, 0)
+#define XGMAC_MTL_RXP_IACC_DATA		0x000010b4
 #define XGMAC_MTL_ECC_CONTROL		0x000010c0
 #define XGMAC_MTL_SAFETY_INT_STATUS	0x000010c4
 #define XGMAC_MEUIS			BIT(1)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 99dc04826925..caed2f4dd7d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -739,6 +739,195 @@ static int dwxgmac3_safety_feat_dump(struct stmmac_safety_stats *stats,
 	return 0;
 }
 
+static int dwxgmac3_rxp_disable(void __iomem *ioaddr)
+{
+	u32 val = readl(ioaddr + XGMAC_MTL_OPMODE);
+
+	val &= ~XGMAC_FRPE;
+	writel(val, ioaddr + XGMAC_MTL_OPMODE);
+
+	return 0;
+}
+
+static void dwxgmac3_rxp_enable(void __iomem *ioaddr)
+{
+	u32 val;
+
+	val = readl(ioaddr + XGMAC_MTL_OPMODE);
+	val |= XGMAC_FRPE;
+	writel(val, ioaddr + XGMAC_MTL_OPMODE);
+}
+
+static int dwxgmac3_rxp_update_single_entry(void __iomem *ioaddr,
+					    struct stmmac_tc_entry *entry,
+					    int pos)
+{
+	int ret, i;
+
+	for (i = 0; i < (sizeof(entry->val) / sizeof(u32)); i++) {
+		int real_pos = pos * (sizeof(entry->val) / sizeof(u32)) + i;
+		u32 val;
+
+		/* Wait for ready */
+		ret = readl_poll_timeout(ioaddr + XGMAC_MTL_RXP_IACC_CTRL_ST,
+					 val, !(val & XGMAC_STARTBUSY), 1, 10000);
+		if (ret)
+			return ret;
+
+		/* Write data */
+		val = *((u32 *)&entry->val + i);
+		writel(val, ioaddr + XGMAC_MTL_RXP_IACC_DATA);
+
+		/* Write pos */
+		val = real_pos & XGMAC_ADDR;
+		writel(val, ioaddr + XGMAC_MTL_RXP_IACC_CTRL_ST);
+
+		/* Write OP */
+		val |= XGMAC_WRRDN;
+		writel(val, ioaddr + XGMAC_MTL_RXP_IACC_CTRL_ST);
+
+		/* Start Write */
+		val |= XGMAC_STARTBUSY;
+		writel(val, ioaddr + XGMAC_MTL_RXP_IACC_CTRL_ST);
+
+		/* Wait for done */
+		ret = readl_poll_timeout(ioaddr + XGMAC_MTL_RXP_IACC_CTRL_ST,
+					 val, !(val & XGMAC_STARTBUSY), 1, 10000);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct stmmac_tc_entry *
+dwxgmac3_rxp_get_next_entry(struct stmmac_tc_entry *entries,
+			    unsigned int count, u32 curr_prio)
+{
+	struct stmmac_tc_entry *entry;
+	u32 min_prio = ~0x0;
+	int i, min_prio_idx;
+	bool found = false;
+
+	for (i = count - 1; i >= 0; i--) {
+		entry = &entries[i];
+
+		/* Do not update unused entries */
+		if (!entry->in_use)
+			continue;
+		/* Do not update already updated entries (i.e. fragments) */
+		if (entry->in_hw)
+			continue;
+		/* Let last entry be updated last */
+		if (entry->is_last)
+			continue;
+		/* Do not return fragments */
+		if (entry->is_frag)
+			continue;
+		/* Check if we already checked this prio */
+		if (entry->prio < curr_prio)
+			continue;
+		/* Check if this is the minimum prio */
+		if (entry->prio < min_prio) {
+			min_prio = entry->prio;
+			min_prio_idx = i;
+			found = true;
+		}
+	}
+
+	if (found)
+		return &entries[min_prio_idx];
+	return NULL;
+}
+
+static int dwxgmac3_rxp_config(void __iomem *ioaddr,
+			       struct stmmac_tc_entry *entries,
+			       unsigned int count)
+{
+	struct stmmac_tc_entry *entry, *frag;
+	int i, ret, nve = 0;
+	u32 curr_prio = 0;
+	u32 old_val, val;
+
+	/* Force disable RX */
+	old_val = readl(ioaddr + XGMAC_RX_CONFIG);
+	val = old_val & ~XGMAC_CONFIG_RE;
+	writel(val, ioaddr + XGMAC_RX_CONFIG);
+
+	/* Disable RX Parser */
+	ret = dwxgmac3_rxp_disable(ioaddr);
+	if (ret)
+		goto re_enable;
+
+	/* Set all entries as NOT in HW */
+	for (i = 0; i < count; i++) {
+		entry = &entries[i];
+		entry->in_hw = false;
+	}
+
+	/* Update entries by reverse order */
+	while (1) {
+		entry = dwxgmac3_rxp_get_next_entry(entries, count, curr_prio);
+		if (!entry)
+			break;
+
+		curr_prio = entry->prio;
+		frag = entry->frag_ptr;
+
+		/* Set special fragment requirements */
+		if (frag) {
+			entry->val.af = 0;
+			entry->val.rf = 0;
+			entry->val.nc = 1;
+			entry->val.ok_index = nve + 2;
+		}
+
+		ret = dwxgmac3_rxp_update_single_entry(ioaddr, entry, nve);
+		if (ret)
+			goto re_enable;
+
+		entry->table_pos = nve++;
+		entry->in_hw = true;
+
+		if (frag && !frag->in_hw) {
+			ret = dwxgmac3_rxp_update_single_entry(ioaddr, frag, nve);
+			if (ret)
+				goto re_enable;
+			frag->table_pos = nve++;
+			frag->in_hw = true;
+		}
+	}
+
+	if (!nve)
+		goto re_enable;
+
+	/* Update all pass entry */
+	for (i = 0; i < count; i++) {
+		entry = &entries[i];
+		if (!entry->is_last)
+			continue;
+
+		ret = dwxgmac3_rxp_update_single_entry(ioaddr, entry, nve);
+		if (ret)
+			goto re_enable;
+
+		entry->table_pos = nve++;
+	}
+
+	/* Assume n. of parsable entries == n. of valid entries */
+	val = (nve << 16) & XGMAC_NPE;
+	val |= nve & XGMAC_NVE;
+	writel(val, ioaddr + XGMAC_MTL_RXP_CONTROL_STATUS);
+
+	/* Enable RX Parser */
+	dwxgmac3_rxp_enable(ioaddr);
+
+re_enable:
+	/* Re-enable RX */
+	writel(old_val, ioaddr + XGMAC_RX_CONFIG);
+	return ret;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -774,6 +963,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.set_mac_loopback = dwxgmac2_set_mac_loopback,
 	.rss_configure = dwxgmac2_rss_configure,
 	.update_vlan_hash = dwxgmac2_update_vlan_hash,
+	.rxp_config = dwxgmac3_rxp_config,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index e4a1c877f2e1..18cbf4ab4ad2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -403,6 +403,9 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	/* MAC HW feature 3 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE3);
 	dma_cap->asp = (hw_cap & XGMAC_HWFEAT_ASP) >> 14;
+	dma_cap->frpes = (hw_cap & XGMAC_HWFEAT_FRPES) >> 11;
+	dma_cap->frpbs = (hw_cap & XGMAC_HWFEAT_FRPPB) >> 9;
+	dma_cap->frpsel = (hw_cap & XGMAC_HWFEAT_FRPSEL) >> 3;
 }
 
 static void dwxgmac2_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 nchan)
-- 
2.7.4

