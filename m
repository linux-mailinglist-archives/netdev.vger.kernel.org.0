Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB95F29AA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbfKGIs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:48:57 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:20714 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733228AbfKGIso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:48:44 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA78l9gv010906;
        Thu, 7 Nov 2019 09:48:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=ybkcAM5LsQb8gc2xuJG0a/Fx63v9jUphoWie5360mak=;
 b=lVwllBubjnKEEMR9vCKj8OGNj9b+uJ87wkg4Im62bCWgsS2qFRzrhkrq2Yf3U+LRBoF+
 QZpaZxoidQM42ktvLqqLhdbvYwj7RuFY7o788hY4vQ59z15RNKBmJzUhYSFDkSQW08vV
 TjWwhp+EjXnTLY+DTHUXXn6+EKzbuLVHdG57pUgc9YAoNFoLcVHmvn4j4VdxLRgQvRR5
 cSA/4xB59kQAvP8H1IdnkBOs9R8AoOOzEgTFadoBbklCh0MFJpiWeJWg6qnPYuCAsjvI
 6DF4MHm7yzZY7eXz1zprJbug/Suaai1htVzjz8UDBRGoq9OUDZPFNaAZQ7PLMdbhy2rs 6A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w41vduy7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 09:48:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D1AA110006A;
        Thu,  7 Nov 2019 09:48:03 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C2C2A2AA977;
        Thu,  7 Nov 2019 09:48:03 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 7 Nov 2019
 09:48:03 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 7 Nov 2019 09:48:03
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V4 net-next 1/4] net: ethernet: stmmac: Add support for syscfg clock
Date:   Thu, 7 Nov 2019 09:47:54 +0100
Message-ID: <20191107084757.17910-2-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107084757.17910-1-christophe.roullier@st.com>
References: <20191107084757.17910-1-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_02:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add optional support for syscfg clock in dwmac-stm32.c
Now Syscfg clock is activated automatically when syscfg
registers are used

Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 23 +++++++------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
index 4ef041bdf6a1..9e4180e1683f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
@@ -155,18 +155,14 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
 		ret = clk_prepare_enable(dwmac->syscfg_clk);
 		if (ret)
 			return ret;
-
-		if (dwmac->clk_eth_ck) {
-			ret = clk_prepare_enable(dwmac->clk_eth_ck);
-			if (ret) {
-				clk_disable_unprepare(dwmac->syscfg_clk);
+		ret = clk_prepare_enable(dwmac->clk_eth_ck);
+		if (ret) {
+			clk_disable_unprepare(dwmac->syscfg_clk);
 				return ret;
-			}
 		}
 	} else {
 		clk_disable_unprepare(dwmac->syscfg_clk);
-		if (dwmac->clk_eth_ck)
-			clk_disable_unprepare(dwmac->clk_eth_ck);
+		clk_disable_unprepare(dwmac->clk_eth_ck);
 	}
 	return ret;
 }
@@ -320,12 +316,10 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
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
@@ -437,8 +431,7 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
 
 	clk_disable_unprepare(dwmac->clk_tx);
 	clk_disable_unprepare(dwmac->syscfg_clk);
-	if (dwmac->clk_eth_ck)
-		clk_disable_unprepare(dwmac->clk_eth_ck);
+	clk_disable_unprepare(dwmac->clk_eth_ck);
 
 	return ret;
 }
-- 
2.17.1

