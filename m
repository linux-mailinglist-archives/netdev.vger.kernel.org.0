Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA40A50B4
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfIBICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:18 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51366 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729899AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A4D97C0437;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=vkwFXbNgXpcsWIBymeTdbdI0d7HHjr+O5myQC7lgDrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=LIEnTSagSCBwmxKnAPXp3O0++ZlCBB8FAMf9sL7S3+HmictbEZ8LqxS6T2Ph8gRg7
         guM54HwcNUMsx6cllR+BT/c9JRS8CaGf97xe1CALRL926Ph0/PqoN6ZlfaL6OqNh5j
         WWkgGYrQeY6vll0IELIw8IcMnSSx9ImN8S3aOKVyOYb+OF8OgzwzA38zshR8KN5Fzo
         CxCByPHCSViOc7FEbNt9kzpSp7pK6M6oNyImGdnQaysq/8b9tTFNmz6nYPnYPp8kqO
         WzZvGMMg9AI2WFQckTseD4fEj33mh3LZKSUpg7ed718nClB8pM26ysRADTChWwLHYJ
         kNlU+f/FwYVkw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5F5B6A0073;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
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
Subject: [PATCH net-next 06/13] net: stmmac: xgmac: Implement ARP Offload
Date:   Mon,  2 Sep 2019 10:01:48 +0200
Message-Id: <91017a44b200aa4596947679f428fd00fefff2fd.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ARP Offload feature in XGMAC cores.

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
 drivers/net/ethernet/stmicro/stmmac/common.h        |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 17 +++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |  3 +++
 4 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 19538057c24e..912bbb6515b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -361,6 +361,7 @@ struct dma_features {
 	unsigned int vlins;
 	unsigned int dvlan;
 	unsigned int l3l4fnum;
+	unsigned int arpoffsel;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 9f568b54b339..36262ef8b70a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1338,6 +1338,22 @@ static int dwxgmac2_config_l4_filter(struct mac_device_info *hw, u32 filter_no,
 	return 0;
 }
 
+static void dwxgmac2_set_arp_offload(struct mac_device_info *hw, bool en,
+				     u32 addr)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	writel(addr, ioaddr + XGMAC_ARP_ADDR);
+
+	value = readl(ioaddr + XGMAC_RX_CONFIG);
+	if (en)
+		value |= XGMAC_CONFIG_ARPEN;
+	else
+		value &= ~XGMAC_CONFIG_ARPEN;
+	writel(value, ioaddr + XGMAC_RX_CONFIG);
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1380,6 +1396,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.enable_vlan = dwxgmac2_enable_vlan,
 	.config_l3_filter = dwxgmac2_config_l3_filter,
 	.config_l4_filter = dwxgmac2_config_l4_filter,
+	.set_arp_offload = dwxgmac2_set_arp_offload,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index fb0283b15c77..fd60bf5e0a72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -370,6 +370,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->atime_stamp = (hw_cap & XGMAC_HWFEAT_TSSEL) >> 12;
 	dma_cap->av = (hw_cap & XGMAC_HWFEAT_AVSEL) >> 11;
 	dma_cap->av &= (hw_cap & XGMAC_HWFEAT_RAVSEL) >> 10;
+	dma_cap->arpoffsel = (hw_cap & XGMAC_HWFEAT_ARPOFFSEL) >> 9;
 	dma_cap->rmon = (hw_cap & XGMAC_HWFEAT_MMCSEL) >> 8;
 	dma_cap->pmt_magic_frame = (hw_cap & XGMAC_HWFEAT_MGKSEL) >> 7;
 	dma_cap->pmt_remote_wake_up = (hw_cap & XGMAC_HWFEAT_RWKSEL) >> 6;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 47c8ad9ec671..ddb851d99618 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -370,6 +370,7 @@ struct stmmac_ops {
 	int (*config_l4_filter)(struct mac_device_info *hw, u32 filter_no,
 				bool en, bool udp, bool sa, bool inv,
 				u32 match);
+	void (*set_arp_offload)(struct mac_device_info *hw, bool en, u32 addr);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -454,6 +455,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, config_l3_filter, __args)
 #define stmmac_config_l4_filter(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, config_l4_filter, __args)
+#define stmmac_set_arp_offload(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, set_arp_offload, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
-- 
2.7.4

