Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320305744C4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiGNGAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiGNGA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:00:27 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6A2F673;
        Wed, 13 Jul 2022 23:00:26 -0700 (PDT)
X-UUID: db8c21d392b7418f8a53886a0780811e-20220714
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:aabcd249-b24b-490c-a9ab-020fbced3fb7,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:0f94e32,CLOUDID:df9c4364-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: db8c21d392b7418f8a53886a0780811e-20220714
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 231091093; Thu, 14 Jul 2022 14:00:22 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 14 Jul 2022 14:00:21 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 14 Jul 2022 14:00:19 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Subject: [PATCH net v5 3/3] net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow
Date:   Thu, 14 Jul 2022 14:00:14 +0800
Message-ID: <20220714060014.18958-4-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714060014.18958-1-biao.huang@mediatek.com>
References: <20220714060014.18958-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current stmmac driver will prepare/enable ptp_ref clock in
stmmac_init_tstamp_counter().

The stmmac_pltfr_noirq_suspend will disable it once in suspend flow.

But in resume flow,
	stmmac_pltfr_noirq_resume --> stmmac_init_tstamp_counter
	stmmac_resume --> stmmac_hw_setup --> stmmac_init_ptp --> stmmac_init_tstamp_counter
ptp_ref clock reference counter increases twice, which leads to unbalance
ptp clock when resume back.

Move ptp_ref clock prepare/enable out of stmmac_init_tstamp_counter to fix it.

Fixes: 0735e639f129d ("net: stmmac: skip only stmmac_ptp_register when resume from suspend")
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++++++++---------
 .../ethernet/stmicro/stmmac/stmmac_platform.c   |  8 +++++++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 197fac587ad5..c5f33630e771 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -834,19 +834,10 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	struct timespec64 now;
 	u32 sec_inc = 0;
 	u64 temp = 0;
-	int ret;
 
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
-	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-	if (ret < 0) {
-		netdev_warn(priv->dev,
-			    "failed to enable PTP reference clock: %pe\n",
-			    ERR_PTR(ret));
-		return ret;
-	}
-
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
@@ -3270,6 +3261,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	stmmac_mmc_setup(priv);
 
+	if (ptp_register) {
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0)
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+	}
+
 	ret = stmmac_init_ptp(priv);
 	if (ret == -EOPNOTSUPP)
 		netdev_info(priv->dev, "PTP not supported by HW\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 11e1055e8260..9f5cac4000da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -815,7 +815,13 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 		if (ret)
 			return ret;
 
-		stmmac_init_tstamp_counter(priv, priv->systime_flags);
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0) {
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+			return ret;
+		}
 	}
 
 	return 0;
-- 
2.25.1

