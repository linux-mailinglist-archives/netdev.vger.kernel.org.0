Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5462690265
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBIIpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBIIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:45:10 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689DA4F846;
        Thu,  9 Feb 2023 00:45:08 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3198ibZ4073886;
        Thu, 9 Feb 2023 02:44:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675932277;
        bh=X8KBT8YUU3TqjxfoGmfTETRw2eKBlp+7yPK8zC+eIDk=;
        h=From:To:CC:Subject:Date;
        b=etBRxC54KCui9KKdN2CUDaOpc1Tdm/GTqQ1UmglRMA7KfOBF6w+omMb4KJ5hzMJin
         Q2xKxkthSef+0QjOPjBoNN7fDWaWyqb+enbrgaWWAIke18Jxih0VIQalRY1oJyrcgw
         iz4titjAnOiFpyKlFcjXZnDnidsDV5Dq0whQ9U4Y=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3198ibPu083062
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Feb 2023 02:44:37 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Feb 2023 02:44:36 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Feb 2023 02:44:36 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3198iWwH084507;
        Thu, 9 Feb 2023 02:44:33 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net] net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk
Date:   Thu, 9 Feb 2023 14:14:32 +0530
Message-ID: <20230209084432.189222-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In TI's AM62x/AM64x SoCs, successful teardown of RX DMA Channel raises an
interrupt. The process of servicing this interrupt involves flushing all
pending RX DMA descriptors and clearing the teardown completion marker
(TDCM). The am65_cpsw_nuss_rx_packets() function invoked from the RX
NAPI callback services the interrupt. Thus, it is necessary to wait for
this handler to run, drain all packets and clear TDCM, before calling
napi_disable() in am65_cpsw_nuss_common_stop() function post channel
teardown. If napi_disable() executes before ensuring that TDCM is
cleared, the TDCM remains set when the interfaces are down, resulting in
an interrupt storm when the interfaces are brought up again.

Since the interrupt raised to indicate the RX DMA Channel teardown is
specific to the AM62x and AM64x SoCs, add a quirk for it.

Fixes: 4f7cce272403 ("net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g")
Co-developed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 12 +++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index ecbde83b5243..6cda4b7c10cb 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -501,7 +501,15 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
 		k3_udma_glue_disable_tx_chn(common->tx_chns[i].tx_chn);
 	}
 
+	reinit_completion(&common->tdown_complete);
 	k3_udma_glue_tdown_rx_chn(common->rx_chns.rx_chn, true);
+
+	if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ) {
+		i = wait_for_completion_timeout(&common->tdown_complete, msecs_to_jiffies(1000));
+		if (!i)
+			dev_err(common->dev, "rx teardown timeout\n");
+	}
+
 	napi_disable(&common->napi_rx);
 
 	for (i = 0; i < AM65_CPSW_MAX_RX_FLOWS; i++)
@@ -721,6 +729,8 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 
 	if (cppi5_desc_is_tdcm(desc_dma)) {
 		dev_dbg(dev, "%s RX tdown flow: %u\n", __func__, flow_idx);
+		if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ)
+			complete(&common->tdown_complete);
 		return 0;
 	}
 
@@ -2672,7 +2682,7 @@ static const struct am65_cpsw_pdata j721e_pdata = {
 };
 
 static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
-	.quirks = 0,
+	.quirks = AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
 };
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 4b75620f8d28..e5f1c44788c1 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -90,6 +90,7 @@ struct am65_cpsw_rx_chn {
 };
 
 #define AM65_CPSW_QUIRK_I2027_NO_TX_CSUM BIT(0)
+#define AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ BIT(1)
 
 struct am65_cpsw_pdata {
 	u32	quirks;
-- 
2.25.1

