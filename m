Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC31BA0B1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgD0KBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:01:11 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57974 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726899AbgD0KBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:01:09 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R9w63X018349;
        Mon, 27 Apr 2020 12:00:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=xiNFv3vCloDJQgtpDQnZVA1ODOKSxtXbybkyp3RxrNc=;
 b=CZwsBzMogIcRHcwZmAW3sLm6Yp+IgGVm0sbqn6MJaTnTPLdzTpdo/btyNHa/85PL9YTa
 LHerlKJdV2GvaQfJ//UnuxlAWkgL0FLCyjlkBVEdq+ow+lMy4pzORtMo+vgnTtFWCF8U
 04XtYMtjhyLvlms2PBkdB9GDDk3NVXizLZbix6yAraN0q+sDHoD/Yy+ZwjrZ5+poYCkA
 GAoVMv6S/OBivyT/fYKdKDi5TLAx53hLZ9DGnNGB+9QJELVskyklF+amo9jPqSDir+e9
 gVwoqITyRpbxrnz1XB9p3Yk01foiFwLhl9TtYhm832OrcnnssZ2B/SgNzmKjNVzrjoGC IQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30mhjwh4u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 12:00:46 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 08F9E100039;
        Mon, 27 Apr 2020 12:00:45 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E85F92B8A33;
        Mon, 27 Apr 2020 12:00:44 +0200 (CEST)
Received: from localhost (10.75.127.46) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Apr 2020 12:00:44
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH v3 1/1] net: ethernet: stmmac: simplify phy modes management for stm32
Date:   Mon, 27 Apr 2020 12:00:38 +0200
Message-ID: <20200427100038.19252-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200427100038.19252-1-christophe.roullier@st.com>
References: <20200427100038.19252-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG2NODE2.st.com (10.75.127.5) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_05:2020-04-24,2020-04-27 signatures=0
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
Acked-by: Alexandre TORGUE <alexandre.torgue@st.com>

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 74 +++++++++++--------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index b2dc99289687..5d4df4c5254e 100644
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
@@ -155,14 +149,17 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
 		ret = clk_prepare_enable(dwmac->syscfg_clk);
 		if (ret)
 			return ret;
-		ret = clk_prepare_enable(dwmac->clk_eth_ck);
-		if (ret) {
-			clk_disable_unprepare(dwmac->syscfg_clk);
-			return ret;
+		if (dwmac->enable_eth_ck) {
+			ret = clk_prepare_enable(dwmac->clk_eth_ck);
+			if (ret) {
+				clk_disable_unprepare(dwmac->syscfg_clk);
+				return ret;
+			}
 		}
 	} else {
 		clk_disable_unprepare(dwmac->syscfg_clk);
-		clk_disable_unprepare(dwmac->clk_eth_ck);
+		if (dwmac->enable_eth_ck)
+			clk_disable_unprepare(dwmac->clk_eth_ck);
 	}
 	return ret;
 }
@@ -170,24 +167,34 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
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
@@ -195,8 +202,11 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
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
@@ -294,6 +304,9 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 	struct device_node *np = dev->of_node;
 	int err = 0;
 
+	/* Ethernet PHY have no crystal */
+	dwmac->ext_phyclk = of_property_read_bool(np, "st,ext-phyclk");
+
 	/* Gigabit Ethernet 125MHz clock selection. */
 	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
 
@@ -431,7 +444,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
 
 	clk_disable_unprepare(dwmac->clk_tx);
 	clk_disable_unprepare(dwmac->syscfg_clk);
-	clk_disable_unprepare(dwmac->clk_eth_ck);
+	if (dwmac->enable_eth_ck)
+		clk_disable_unprepare(dwmac->clk_eth_ck);
 
 	return ret;
 }
-- 
2.17.1

