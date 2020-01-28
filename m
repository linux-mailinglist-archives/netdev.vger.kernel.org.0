Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E259314B107
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 09:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgA1IkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 03:40:16 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:38999 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgA1IkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 03:40:16 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00S8WtBS008580;
        Tue, 28 Jan 2020 09:40:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=wYVLtBQDsVpHpQf/7yE70/hiuInLMKJGmpFUxExoUkk=;
 b=YjhOSP9P4lWFFyr1VBF94DHLOUzMLuRFiOnYnD5ZYvkd3f46cKSVYS8nd69wZumylxN/
 li3GFgUJB8pA6h6mWv8zX+iW5sS1FcgcHBci0jv65sqaaDEULF9NmiJZdmDNEOdOEQmR
 fFHIUKvfvPhsnhzL6rEc0LPkQ/R+j5sj+iD0hJeLICCWf7uO1ECeJnBGCXm4i8dFfRis
 Ma2/gHmdtJzR/5+7CUqUP6vo3aaI9B69fUA3GgOTgYcfr/RJ+1ADV+hemNK3ROOYiQdM
 hVMsqVlb8FLHeUgLYFjcti62DGR3/wMiJQfIoKiQNe195XoX7R+mkiSl9ypLuN6fwkBT lw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2xrcaxvrv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jan 2020 09:40:00 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C422210002A;
        Tue, 28 Jan 2020 09:39:55 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7D5A8211F3F;
        Tue, 28 Jan 2020 09:39:55 +0100 (CET)
Received: from localhost (10.75.127.44) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 28 Jan 2020 09:39:54
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <netdev@vger.kernel.org>, <christophe.roullier@st.com>
Subject: [PATCH  1/1] net: ethernet: stmmac: simplify phy modes management for stm32
Date:   Tue, 28 Jan 2020 09:39:42 +0100
Message-ID: <20200128083942.17823-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG6NODE2.st.com (10.75.127.17) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-28_02:2020-01-24,2020-01-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No new feature, just to simplify stm32 part to be easier to use.
Add by default all Ethernet clocks in DT, and activate or not in function
of phy mode, clock frequency, if property "st,ext-phyclk" is set or not.
Keep backward compatibility
-----------------------------------------------------------------------
|PHY_MODE | Normal | PHY wo crystal|   PHY wo crystal   |  No 125Mhz  |
|         |        |      25MHz    |        50MHz       |  from PHY   |
-----------------------------------------------------------------------
|  MII    |	 -    |     eth-ck    |       n/a          |	    n/a  |
|         |        | st,ext-phyclk |                    |             |
-----------------------------------------------------------------------
|  GMII   |	 -    |     eth-ck    |       n/a          |	    n/a  |
|         |        | st,ext-phyclk |                    |             |
-----------------------------------------------------------------------
| RGMII   |	 -    |     eth-ck    |       n/a          |      eth-ck  |
|         |        | st,ext-phyclk |                    |st,eth-clk-sel|
|         |        |               |                    |       or     |
|         |        |               |                    | st,ext-phyclk|
------------------------------------------------------------------------
| RMII    |	 -    |     eth-ck    |      eth-ck        |	     n/a  |
|         |        | st,ext-phyclk | st,eth-ref-clk-sel |              |
|         |        |               | or st,ext-phyclk   |              |
------------------------------------------------------------------------

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>

---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 58 +++++++++++--------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 9b7be996d07b..866251eac868 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -29,6 +29,11 @@
 #define SYSCFG_PMCR_ETH_CLK_SEL		BIT(16)
 #define SYSCFG_PMCR_ETH_REF_CLK_SEL	BIT(17)
 
+/* CLOCK feed to PHY*/
+#define ETH_CK_F_25M	25000000
+#define ETH_CK_F_50M	50000000
+#define ETH_CK_F_125M	125000000
+
 /*  Ethernet PHY interface selection in register SYSCFG Configuration
  *------------------------------------------
  * src	 |BIT(23)| BIT(22)| BIT(21)|BIT(20)|
@@ -58,33 +63,20 @@
  *|         |        |      25MHz    |        50MHz       |                  |
  * ---------------------------------------------------------------------------
  *|  MII    |	 -   |     eth-ck    |	      n/a	  |	  n/a        |
- *|         |        |		     |                    |		     |
+ *|         |        | st,ext-phyclk |                    |		     |
  * ---------------------------------------------------------------------------
  *|  GMII   |	 -   |     eth-ck    |	      n/a	  |	  n/a        |
- *|         |        |               |                    |		     |
+ *|         |        | st,ext-phyclk |                    |		     |
  * ---------------------------------------------------------------------------
- *| RGMII   |	 -   |     eth-ck    |	      n/a	  |  eth-ck (no pin) |
- *|         |        |               |                    |  st,eth-clk-sel  |
+ *| RGMII   |	 -   |     eth-ck    |	      n/a	  |      eth-ck      |
+ *|         |        | st,ext-phyclk |                    | st,eth-clk-sel or|
+ *|         |        |               |                    | st,ext-phyclk    |
  * ---------------------------------------------------------------------------
  *| RMII    |	 -   |     eth-ck    |	    eth-ck        |	  n/a        |
- *|         |        |		     | st,eth-ref-clk-sel |		     |
+ *|         |        | st,ext-phyclk | st,eth-ref-clk-sel |		     |
+ *|         |        |               | or st,ext-phyclk   |		     |
  * ---------------------------------------------------------------------------
  *
- * BIT(17) : set this bit in RMII mode when you have PHY without crystal 50MHz
- * BIT(16) : set this bit in GMII/RGMII PHY when you do not want use 125Mhz
- * from PHY
- *-----------------------------------------------------
- * src	 |         BIT(17)       |       BIT(16)      |
- *-----------------------------------------------------
- * MII   |           n/a	 |         n/a        |
- *-----------------------------------------------------
- * GMII  |           n/a         |   st,eth-clk-sel   |
- *-----------------------------------------------------
- * RGMII |           n/a         |   st,eth-clk-sel   |
- *-----------------------------------------------------
- * RMII  |   st,eth-ref-clk-sel	 |         n/a        |
- *-----------------------------------------------------
- *
  */
 
 struct stm32_dwmac {
@@ -93,6 +85,8 @@ struct stm32_dwmac {
 	struct clk *clk_eth_ck;
 	struct clk *clk_ethstp;
 	struct clk *syscfg_clk;
+	int ext_phyclk;
+	int enable_eth_ck;
 	int eth_clk_sel_reg;
 	int eth_ref_clk_sel_reg;
 	int irq_pwr_wakeup;
@@ -170,24 +164,34 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
 static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 {
 	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
-	u32 reg = dwmac->mode_reg;
+	u32 reg = dwmac->mode_reg, clk_rate;
 	int val;
 
+	clk_rate = clk_get_rate(dwmac->clk_eth_ck);
+	dwmac->enable_eth_ck = false;
 	switch (plat_dat->interface) {
 	case PHY_INTERFACE_MODE_MII:
+		if (clk_rate == ETH_CK_F_25M && dwmac->ext_phyclk)
+			dwmac->enable_eth_ck = true;
 		val = SYSCFG_PMCR_ETH_SEL_MII;
 		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_MII\n");
 		break;
 	case PHY_INTERFACE_MODE_GMII:
 		val = SYSCFG_PMCR_ETH_SEL_GMII;
-		if (dwmac->eth_clk_sel_reg)
+		if (clk_rate == ETH_CK_F_25M &&
+		    (dwmac->eth_clk_sel_reg || dwmac->ext_phyclk)) {
+			dwmac->enable_eth_ck = true;
 			val |= SYSCFG_PMCR_ETH_CLK_SEL;
+		}
 		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_GMII\n");
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		val = SYSCFG_PMCR_ETH_SEL_RMII;
-		if (dwmac->eth_ref_clk_sel_reg)
+		if ((clk_rate == ETH_CK_F_25M || clk_rate == ETH_CK_F_50M) &&
+		    (dwmac->eth_ref_clk_sel_reg || dwmac->ext_phyclk)) {
+			dwmac->enable_eth_ck = true;
 			val |= SYSCFG_PMCR_ETH_REF_CLK_SEL;
+		}
 		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_RMII\n");
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
@@ -195,8 +199,11 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		val = SYSCFG_PMCR_ETH_SEL_RGMII;
-		if (dwmac->eth_clk_sel_reg)
+		if ((clk_rate == ETH_CK_F_25M || clk_rate == ETH_CK_F_125M) &&
+		    (dwmac->eth_clk_sel_reg || dwmac->ext_phyclk)) {
+			dwmac->enable_eth_ck = true;
 			val |= SYSCFG_PMCR_ETH_CLK_SEL;
+		}
 		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_RGMII\n");
 		break;
 	default:
@@ -294,6 +301,9 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 	struct device_node *np = dev->of_node;
 	int err = 0;
 
+	/* Ethernet PHY have no crystal */
+	dwmac->ext_phyclk = of_property_read_bool(np, "st,ext-phyclk");
+
 	/* Gigabit Ethernet 125MHz clock selection. */
 	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
 
-- 
2.17.1

