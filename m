Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56356540F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiGDLqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiGDLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:46:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663EB11824;
        Mon,  4 Jul 2022 04:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656935176; x=1688471176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ut5r7XOY+8r4BHR6rDG4F4J/JbNW2GuxLXfnNQpRYeY=;
  b=QcW5WupH6cUrA40YqclWBi4A4gaeDR+C/MPwtr1alTrOvjaBA/w5O2vD
   PlDZ7REfSJFwhKtYohDD+sQlhyYlgHopqmkbabl9OysA89AV3h/oU4SZL
   xYoQswU2oNZ/XwGE6tvT8CTHnV5+yb0Np6SUUMSZZMTkOGb8ij0brzM23
   YYh+DlSj0BbQ4EZloowTQGCy2H98xm2NuY6WjNPB1X+A6+7pm994aBQhw
   LzIG/pVAZqyS5GO6DSuSaAnbqwdIKQzPO1o0XP5ozqGSuMl6RUvv7Hsny
   Y7rwR47leSzhdPj5FH9g9IlQ4eclFLGbEpsIxusho25jcrBH3pTZpSDGh
   g==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="170950913"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 04:46:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 04:46:15 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 4 Jul 2022 04:46:12 -0700
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
Subject: [net-next PATCH v2 4/5] net: macb: simplify error paths in init_reset_optional()
Date:   Mon, 4 Jul 2022 12:45:11 +0100
Message-ID: <20220704114511.1892332-5-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704114511.1892332-1-conor.dooley@microchip.com>
References: <20220704114511.1892332-1-conor.dooley@microchip.com>
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

