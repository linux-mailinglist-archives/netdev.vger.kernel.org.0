Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD5EFD8D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388826AbfKEMp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:45:29 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:21774 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388782AbfKEMp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:45:28 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ChDML012679;
        Tue, 5 Nov 2019 13:45:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=zf3XGUa3PY05aBrAv1+hk5KNmpH4NJCoQ8znpcyR/Jw=;
 b=rux6/Zzpne89E3SkWis/F1hkU0rsjTzR2eyQdhSpEAeJ2eP5Z9R9b4Ic1B5N6+6eSQ48
 51pIueIujhiT2mr9pEUI06WQ8NmAG2gqLn7mgjfLg0NTwcSQlNmo6DapeFLCCpnSD09E
 3mNbODHWgEbVcwNYM3YNpy/PuO7b1ubulCY87wVzrqnd+t+AjaIBBeOmR49EdcxhXyYL
 lZf5tgPrIBI55Zyyauvfoq+8UEtaiq2YodFwKNvKYNDTc8n/yeB0pUg54pKi1hZjiV1I
 bkaeR/pDx6tiJwnm4RbeaTGPm+FMLV42FzYfI3WmLp+Afxed8WkKRD3BlhttvzCBT7ei XA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w0ytcqy31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 13:45:10 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 3EB2D100038;
        Tue,  5 Nov 2019 13:45:10 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 301CD2B97DA;
        Tue,  5 Nov 2019 13:45:10 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 5 Nov 2019
 13:45:10 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 5 Nov 2019 13:45:08
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V2 net-next 1/4] net: ethernet: stmmac: Add support for syscfg clock
Date:   Tue, 5 Nov 2019 13:45:02 +0100
Message-ID: <20191105124505.4738-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191105124505.4738-1-christophe.roullier@st.com>
References: <20191105124505.4738-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_04:2019-11-05,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional support for syscfg clock in dwmac-stm32.c
Now Syscfg clock is activated automatically when syscfg
registers are used

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 4ef041bdf6a1..df7e9e913041 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -152,19 +152,24 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
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
+					clk_disable_unprepare
+						(dwmac->syscfg_clk);
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
@@ -296,7 +301,7 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct device_node *np = dev->of_node;
-	int err = 0;
+	int err;
 
 	/* Gigabit Ethernet 125MHz clock selection. */
 	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
@@ -320,13 +325,17 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
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
@@ -436,7 +445,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
 		return ret;
 
 	clk_disable_unprepare(dwmac->clk_tx);
-	clk_disable_unprepare(dwmac->syscfg_clk);
+	if (dwmac->syscfg_clk)
+		clk_disable_unprepare(dwmac->syscfg_clk);
 	if (dwmac->clk_eth_ck)
 		clk_disable_unprepare(dwmac->clk_eth_ck);
 
-- 
2.17.1

