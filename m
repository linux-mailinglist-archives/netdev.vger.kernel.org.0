Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D5CD1A9
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfJFLR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:17:29 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:50012 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbfJFLR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:17:28 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8DE90C03B0;
        Sun,  6 Oct 2019 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570360648; bh=BZ6015BjB1eg7BBekZCBGkoW/bAHRZMsHJV/RCZbzBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=e0NAGU8nphDn+L30MeA+uk54CxPCbIaojKnv5+q9StF4l4bfHxzrm1mfXqtQkbWe1
         JlHpEPZ+AVKzUg85qHVak803nFDHlnrs2u9hUu0oKTdXo9bAsAA9lOFXsrsPD3EEse
         l+kRkBgLQWe/EN6W0BIhwc29+adUg9yJPGPV2G0nYL1ceBzcni9KtcXYyrKHfP0jBi
         rLqOE9bCo+JEsEFrfmW/M20ZAFNGIIAifTRwFdOqvxW8FSeHssoyiLM8XbSPv1Ql3I
         vTy5Xr7C5QWBRwtVU6SrfPrByWRp2IupVNTADu+Yk5/siQjMIexxFj4L3Q/WVsxgCS
         pc7V8hgeLZIPw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 0DCF3A0064;
        Sun,  6 Oct 2019 11:17:26 +0000 (UTC)
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
Subject: [PATCH net-next 2/3] net: stmmac: selftests: Add tests for VLAN Perfect Filtering
Date:   Sun,  6 Oct 2019 13:17:13 +0200
Message-Id: <3a398a197311037b7b60a713a6ac9aa8630093dc.1570360411.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1570360411.git.Jose.Abreu@synopsys.com>
References: <cover.1570360411.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1570360411.git.Jose.Abreu@synopsys.com>
References: <cover.1570360411.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>

Add two new tests for VLAN Perfect Filtering. While at it, increase a
little bit the tests strings lenght so that we can have more descriptive
test names.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 114 ++++++++++++++-------
 1 file changed, 77 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index e4ac3c401432..0b5db52149bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -823,16 +823,13 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 	return 0;
 }
 
-static int stmmac_test_vlanfilt(struct stmmac_priv *priv)
+static int __stmmac_test_vlanfilt(struct stmmac_priv *priv)
 {
 	struct stmmac_packet_attrs attr = { };
 	struct stmmac_test_priv *tpriv;
 	struct sk_buff *skb = NULL;
 	int ret = 0, i;
 
-	if (!priv->dma_cap.vlhash)
-		return -EOPNOTSUPP;
-
 	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
 	if (!tpriv)
 		return -ENOMEM;
@@ -898,16 +895,32 @@ static int stmmac_test_vlanfilt(struct stmmac_priv *priv)
 	return ret;
 }
 
-static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
+static int stmmac_test_vlanfilt(struct stmmac_priv *priv)
+{
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+
+	return __stmmac_test_vlanfilt(priv);
+}
+
+static int stmmac_test_vlanfilt_perfect(struct stmmac_priv *priv)
+{
+	int ret, prev_cap = priv->dma_cap.vlhash;
+
+	priv->dma_cap.vlhash = 0;
+	ret = __stmmac_test_vlanfilt(priv);
+	priv->dma_cap.vlhash = prev_cap;
+
+	return ret;
+}
+
+static int __stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 {
 	struct stmmac_packet_attrs attr = { };
 	struct stmmac_test_priv *tpriv;
 	struct sk_buff *skb = NULL;
 	int ret = 0, i;
 
-	if (!priv->dma_cap.vlhash)
-		return -EOPNOTSUPP;
-
 	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
 	if (!tpriv)
 		return -ENOMEM;
@@ -974,6 +987,25 @@ static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 	return ret;
 }
 
+static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
+{
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+
+	return __stmmac_test_dvlanfilt(priv);
+}
+
+static int stmmac_test_dvlanfilt_perfect(struct stmmac_priv *priv)
+{
+	int ret, prev_cap = priv->dma_cap.vlhash;
+
+	priv->dma_cap.vlhash = 0;
+	ret = __stmmac_test_dvlanfilt(priv);
+	priv->dma_cap.vlhash = prev_cap;
+
+	return ret;
+}
+
 #ifdef CONFIG_NET_CLS_ACT
 static int stmmac_test_rxp(struct stmmac_priv *priv)
 {
@@ -1648,119 +1680,127 @@ static const struct stmmac_test {
 	int (*fn)(struct stmmac_priv *priv);
 } stmmac_selftests[] = {
 	{
-		.name = "MAC Loopback         ",
+		.name = "MAC Loopback               ",
 		.lb = STMMAC_LOOPBACK_MAC,
 		.fn = stmmac_test_mac_loopback,
 	}, {
-		.name = "PHY Loopback         ",
+		.name = "PHY Loopback               ",
 		.lb = STMMAC_LOOPBACK_NONE, /* Test will handle it */
 		.fn = stmmac_test_phy_loopback,
 	}, {
-		.name = "MMC Counters         ",
+		.name = "MMC Counters               ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_mmc,
 	}, {
-		.name = "EEE                  ",
+		.name = "EEE                        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_eee,
 	}, {
-		.name = "Hash Filter MC       ",
+		.name = "Hash Filter MC             ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_hfilt,
 	}, {
-		.name = "Perfect Filter UC    ",
+		.name = "Perfect Filter UC          ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_pfilt,
 	}, {
-		.name = "MC Filter            ",
+		.name = "MC Filter                  ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_mcfilt,
 	}, {
-		.name = "UC Filter            ",
+		.name = "UC Filter                  ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_ucfilt,
 	}, {
-		.name = "Flow Control         ",
+		.name = "Flow Control               ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_flowctrl,
 	}, {
-		.name = "RSS                  ",
+		.name = "RSS                        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_rss,
 	}, {
-		.name = "VLAN Filtering       ",
+		.name = "VLAN Filtering             ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_vlanfilt,
 	}, {
-		.name = "Double VLAN Filtering",
+		.name = "VLAN Filtering (perf)      ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_vlanfilt_perfect,
+	}, {
+		.name = "Double VLAN Filter         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_dvlanfilt,
 	}, {
-		.name = "Flexible RX Parser   ",
+		.name = "Double VLAN Filter (perf)  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_dvlanfilt_perfect,
+	}, {
+		.name = "Flexible RX Parser         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_rxp,
 	}, {
-		.name = "SA Insertion (desc)  ",
+		.name = "SA Insertion (desc)        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_desc_sai,
 	}, {
-		.name = "SA Replacement (desc)",
+		.name = "SA Replacement (desc)      ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_desc_sar,
 	}, {
-		.name = "SA Insertion (reg)  ",
+		.name = "SA Insertion (reg)         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_reg_sai,
 	}, {
-		.name = "SA Replacement (reg)",
+		.name = "SA Replacement (reg)       ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_reg_sar,
 	}, {
-		.name = "VLAN TX Insertion   ",
+		.name = "VLAN TX Insertion          ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_vlanoff,
 	}, {
-		.name = "SVLAN TX Insertion  ",
+		.name = "SVLAN TX Insertion         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_svlanoff,
 	}, {
-		.name = "L3 DA Filtering     ",
+		.name = "L3 DA Filtering            ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l3filt_da,
 	}, {
-		.name = "L3 SA Filtering     ",
+		.name = "L3 SA Filtering            ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l3filt_sa,
 	}, {
-		.name = "L4 DA TCP Filtering ",
+		.name = "L4 DA TCP Filtering        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l4filt_da_tcp,
 	}, {
-		.name = "L4 SA TCP Filtering ",
+		.name = "L4 SA TCP Filtering        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l4filt_sa_tcp,
 	}, {
-		.name = "L4 DA UDP Filtering ",
+		.name = "L4 DA UDP Filtering        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l4filt_da_udp,
 	}, {
-		.name = "L4 SA UDP Filtering ",
+		.name = "L4 SA UDP Filtering        ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l4filt_sa_udp,
 	}, {
-		.name = "ARP Offload         ",
+		.name = "ARP Offload                ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_arpoffload,
 	}, {
-		.name = "Jumbo Frame         ",
+		.name = "Jumbo Frame                ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_jumbo,
 	}, {
-		.name = "Multichannel Jumbo  ",
+		.name = "Multichannel Jumbo         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_mjumbo,
 	}, {
-		.name = "Split Header        ",
+		.name = "Split Header               ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_sph,
 	},
-- 
2.7.4

