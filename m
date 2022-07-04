Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F47856540B
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiGDLqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiGDLqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:46:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ED711823;
        Mon,  4 Jul 2022 04:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656935179; x=1688471179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zfbKyBLC0mFyQIJx/KT+jhrSiCA/8O4T/yeF8thm6iM=;
  b=vEohZ2okuoWK8d48kO5MJR89H8FFykMEhBel6WsCgRmfLc59j5ctLr3C
   KBd9kUUmhZ9jl41Ky7AkudE0jve3rBuY8G2TgpKzBG3TQL2Y7IAu89lVF
   cSh47fryrb2lFHeo/7+9WUACIcZhVeD4gGgIul14iuCk5+7TZS1ev1gCt
   yvV9F0czkqGGbe5ijjfXZ1Oq0v1umeRKSi21uyvof9JILfVv1E4R22OZY
   Gzs0aM/mVUQKcDxhRzvA5tAT0fhXzK0Y+R/hZDI+3+lQSTMWsqE7+ckJ5
   0a7txDpDQnfihip+LHijaFmzWLCnBwKZt29mGMAZ6OxtA/zqmBsdZ5+5e
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="170950918"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 04:46:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 04:46:18 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 4 Jul 2022 04:46:15 -0700
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
Subject: [net-next PATCH v2 5/5] net: macb: sort init_reset_optional() with other init()s
Date:   Mon, 4 Jul 2022 12:45:12 +0100
Message-ID: <20220704114511.1892332-6-conor.dooley@microchip.com>
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

init_reset_optional() is somewhat oddly placed amidst the macb_config
struct definitions. Move it to a more reasonable location alongside
the fu540 init functions.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 68 ++++++++++++------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4423d99c72a7..36a659f2a289 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4600,6 +4600,40 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
+static int init_reset_optional(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(dev);
+	int ret;
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		/* Ensure PHY device used in SGMII mode is ready */
+		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
+
+		if (IS_ERR(bp->sgmii_phy))
+			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
+					     "failed to get SGMII PHY\n");
+
+		ret = phy_init(bp->sgmii_phy);
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed to init SGMII PHY\n");
+	}
+
+	/* Fully reset controller at hardware level if mapped in device tree */
+	ret = device_reset_optional(&pdev->dev);
+	if (ret) {
+		phy_exit(bp->sgmii_phy);
+		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
+	}
+
+	ret = macb_init(pdev);
+	if (ret)
+		phy_exit(bp->sgmii_phy);
+
+	return ret;
+}
+
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4689,40 +4723,6 @@ static const struct macb_config np4_config = {
 	.usrio = &macb_default_usrio,
 };
 
-static int init_reset_optional(struct platform_device *pdev)
-{
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct macb *bp = netdev_priv(dev);
-	int ret;
-
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
-		/* Ensure PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
-
-		if (IS_ERR(bp->sgmii_phy))
-			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
-					     "failed to get SGMII PHY\n");
-
-		ret = phy_init(bp->sgmii_phy);
-		if (ret)
-			return dev_err_probe(&pdev->dev, ret,
-					     "failed to init SGMII PHY\n");
-	}
-
-	/* Fully reset controller at hardware level if mapped in device tree */
-	ret = device_reset_optional(&pdev->dev);
-	if (ret) {
-		phy_exit(bp->sgmii_phy);
-		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
-	}
-
-	ret = macb_init(pdev);
-	if (ret)
-		phy_exit(bp->sgmii_phy);
-
-	return ret;
-}
-
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
-- 
2.36.1

