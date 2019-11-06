Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC05F138A
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfKFKMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:12:45 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:29140 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727239AbfKFKMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:12:44 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6AC4Qg022141;
        Wed, 6 Nov 2019 11:12:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=ZE5EHY9r5E8wwKp2B+vrmo3u31wmEuBrC/3bKOYK1gg=;
 b=dk9GfzGxgJnH/+LGcJaQRky3btuB2/bmemD0T9011yYuhtbyhJQ3Nh0A4svwuhGeYntM
 EYrCog9LZMPg7U2lUjBWQMSntVun+q4Yg+OS+1gAeQISdW1sqtQP0o9xpqG1iODOrFmm
 lY0zQV6pgGqVnTtuRqoIkFbCuw/OqxjDcH/WVUClfFfZO0xZhVcW810qyu/ltmPLugKt
 3838HMI/7Pp1w4r8+UIkYI1l4mLdl3DbXgTmosT+OECHO4FY/yuyPhsDD/ndItcKjX3D
 /9m/shbTb4qgXwveDCUA8riNsWK17h+zbrtczPIy+DUgKljcqbcDplJa7M0DxBUUNRlf QQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w0ytcwf2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 11:12:28 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C6851100038;
        Wed,  6 Nov 2019 11:12:23 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas22.st.com [10.75.90.92])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B6E462AD343;
        Wed,  6 Nov 2019 11:12:23 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas22.st.com
 (10.75.90.92) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019
 11:12:23 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019 11:12:23
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V3 net-next 1/4] net: ethernet: stmmac: Add support for syscfg clock
Date:   Wed, 6 Nov 2019 11:12:17 +0100
Message-ID: <20191106101220.12693-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191106101220.12693-1-christophe.roullier@st.com>
References: <20191106101220.12693-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_02:2019-11-06,2019-11-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional support for syscfg clock in dwmac-stm32.c
Now Syscfg clock is activated automatically when syscfg
registers are used

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 28 +++++++++++--------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 4ef041bdf6a1..be7d58d83cfa 100644
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
@@ -320,12 +325,10 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
 		return PTR_ERR(dwmac->clk_ethstp);
 	}
 
-	/*  Clock for sysconfig */
+	/*  Optional Clock for sysconfig */
 	dwmac->syscfg_clk = devm_clk_get(dev, "syscfg-clk");
-	if (IS_ERR(dwmac->syscfg_clk)) {
-		dev_err(dev, "No syscfg clock provided...\n");
-		return PTR_ERR(dwmac->syscfg_clk);
-	}
+	if (IS_ERR(dwmac->syscfg_clk))
+		dwmac->syscfg_clk = NULL;
 
 	/* Get IRQ information early to have an ability to ask for deferred
 	 * probe if needed before we went too far with resource allocation.
@@ -436,7 +439,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
 		return ret;
 
 	clk_disable_unprepare(dwmac->clk_tx);
-	clk_disable_unprepare(dwmac->syscfg_clk);
+	if (dwmac->syscfg_clk)
+		clk_disable_unprepare(dwmac->syscfg_clk);
 	if (dwmac->clk_eth_ck)
 		clk_disable_unprepare(dwmac->clk_eth_ck);
 
-- 
2.17.1

