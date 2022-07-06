Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6EB568428
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiGFJwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiGFJwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:52:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2773248C5;
        Wed,  6 Jul 2022 02:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657101127; x=1688637127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ixTEFBBCmvimE/C5V7LJETD7sFfJnFOViWRROURSZYU=;
  b=Kq3MQx2h+2ezWp0W8oP7EAtoY3pCtmxfR5uAZUhaaKR8Fpvbq2Q2Aq2v
   KMaears63GfdBnR3SsxYIIqv6ciPEtNe2dkiH5IxGzm+u++HcI0nXk5GM
   C7jBi1RoNm0zBzr53vug/WYNbbUOstTfEK05qg8GgmWCHe2EeMZrG7czB
   pQzFmYTzLpVo0s4LXuw/1CU8Y0aPJsQp0BrmBhdmt9nFGcfqc6DmS/Egv
   55b72BhlCHISCKCO8espI2JyFnIUq+k3ELg6NwtdnsB7qHcdXvMB6cYoB
   6ivDSMDWUpaSMd/3Aqe+jq55z5Kv0bo63RSmo4ATR1nr5yut6aTk0ODIi
   w==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="163537865"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 02:52:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 02:52:05 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 6 Jul 2022 02:52:02 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH v3 4/5] net: macb: simplify error paths in init_reset_optional()
Date:   Wed, 6 Jul 2022 10:51:28 +0100
Message-ID: <20220706095129.828253-5-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706095129.828253-1-conor.dooley@microchip.com>
References: <20220706095129.828253-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling paths in init_reset_optional() can all be
simplified to return dev_err_probe(). Do so.

Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 85a2e1ea7826..4423d99c72a7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4699,27 +4699,21 @@ static int init_reset_optional(struct platform_device *pdev)
 		/* Ensure PHY device used in SGMII mode is ready */
 		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
 
-		if (IS_ERR(bp->sgmii_phy)) {
-			ret = PTR_ERR(bp->sgmii_phy);
-			dev_err_probe(&pdev->dev, ret,
-				      "failed to get SGMII PHY\n");
-			return ret;
-		}
+		if (IS_ERR(bp->sgmii_phy))
+			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
+					     "failed to get SGMII PHY\n");
 
 		ret = phy_init(bp->sgmii_phy);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to init SGMII PHY: %d\n",
-				ret);
-			return ret;
-		}
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed to init SGMII PHY\n");
 	}
 
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
-		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
 		phy_exit(bp->sgmii_phy);
-		return ret;
+		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
 	}
 
 	ret = macb_init(pdev);
-- 
2.36.1

