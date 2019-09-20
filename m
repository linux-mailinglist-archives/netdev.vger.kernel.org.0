Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE31B8A8B
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 07:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404623AbfITFjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 01:39:04 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:13840 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392355AbfITFjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 01:39:04 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K5ZtCk010154;
        Fri, 20 Sep 2019 07:38:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=vyF/QISSJCb/iu6rS6wjZkpjt1WcfYY+i4OiL+tne44=;
 b=fzqM/jobMihRCtnFWd4AibkzB5Y5OczzCcrRusXKlzgyhU4KgbIot9gZx5QxUTrjUROd
 zoe2dSz5OwTEFdw+cJt4y+4acsno7+piZ6e0jZVwQ44TVNyAF++59wl1A1FxdRoG244p
 0xocaPF+ioXom7dV5BiUKII2MRAQgGeDGIjXqUIZn8Is7S/OlhOuDQDt6cCncYApWaHa
 UtdpYDWbvFYAvgFAyxOlX03xVLcdYFBOwQ4ihlx/H2JKySWqDdAgcbXmG/rRIAOCKL0V
 CMTO4J97j2PndiJLjridOgH0Ue2/jB6Wl63RheW7KqcRXBZ8WuU9e1Tppd0rYVueGaN3 iw== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx08-00178001.pphosted.com with ESMTP id 2v3va18qd8-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 20 Sep 2019 07:38:43 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 13B9351;
        Fri, 20 Sep 2019 05:38:36 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id BB7F82209B1;
        Fri, 20 Sep 2019 07:38:35 +0200 (CEST)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep
 2019 07:38:35 +0200
Received: from localhost (10.201.22.222) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 20 Sep 2019 07:38:35
 +0200
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH  1/5] net: ethernet: stmmac: Add support for syscfg clock
Date:   Fri, 20 Sep 2019 07:38:13 +0200
Message-ID: <20190920053817.13754-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190920053817.13754-1-christophe.roullier@st.com>
References: <20190920053817.13754-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional support for syscfg clock in dwmac-stm32.c
Now Syscfg clock is activated automatically when syscfg
registers are used

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 36 +++++++++++++------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 4ef041bdf6a1..7e6619868cc1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -152,23 +152,32 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
 	int ret = 0;
 
 	if (prepare) {
-		ret = clk_prepare_enable(dwmac->syscfg_clk);
-		if (ret)
-			return ret;
-
+		if (dwmac->syscfg_clk) {
+			ret = clk_prepare_enable(dwmac->syscfg_clk);
+			if (ret)
+				return ret;
+		}
 		if (dwmac->clk_eth_ck) {
 			ret = clk_prepare_enable(dwmac->clk_eth_ck);
 			if (ret) {
-				clk_disable_unprepare(dwmac->syscfg_clk);
+				if (dwmac->syscfg_clk)
+					goto unprepare_syscfg;
 				return ret;
 			}
 		}
 	} else {
-		clk_disable_unprepare(dwmac->syscfg_clk);
+		if (dwmac->syscfg_clk)
+			clk_disable_unprepare(dwmac->syscfg_clk);
+
 		if (dwmac->clk_eth_ck)
 			clk_disable_unprepare(dwmac->clk_eth_ck);
 	}
 	return ret;
+
+unprepare_syscfg:
+	clk_disable_unprepare(dwmac->syscfg_clk);
+
+	return ret;
 }
 
 static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
@@ -296,7 +305,7 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct device_node *np = dev->of_node;
-	int err = 0;
+	int err;
 
 	/* Gigabit Ethernet 125MHz clock selection. */
 	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
@@ -320,13 +329,17 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 		return PTR_ERR(dwmac->clk_ethstp);
 	}
 
-	/*  Clock for sysconfig */
+	/*  Optional Clock for sysconfig */
 	dwmac->syscfg_clk = devm_clk_get(dev, "syscfg-clk");
 	if (IS_ERR(dwmac->syscfg_clk)) {
-		dev_err(dev, "No syscfg clock provided...\n");
-		return PTR_ERR(dwmac->syscfg_clk);
+		err = PTR_ERR(dwmac->syscfg_clk);
+		if (err != -ENOENT)
+			return err;
+		dwmac->syscfg_clk = NULL;
 	}
 
+	err = 0;
+
 	/* Get IRQ information early to have an ability to ask for deferred
 	 * probe if needed before we went too far with resource allocation.
 	 */
@@ -436,7 +449,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
 		return ret;
 
 	clk_disable_unprepare(dwmac->clk_tx);
-	clk_disable_unprepare(dwmac->syscfg_clk);
+	if (dwmac->syscfg_clk)
+		clk_disable_unprepare(dwmac->syscfg_clk);
 	if (dwmac->clk_eth_ck)
 		clk_disable_unprepare(dwmac->clk_eth_ck);
 
-- 
2.17.1

