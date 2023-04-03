Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790116D3FAD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjDCJDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCJDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:03:40 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295435275;
        Mon,  3 Apr 2023 02:03:38 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33393PK4064865;
        Mon, 3 Apr 2023 04:03:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680512605;
        bh=fFKF9EDZaeeQCsF9iF+AfZbQfvLxnFEKa7QmJZTumqM=;
        h=From:To:CC:Subject:Date;
        b=LkebCC8R6ZdgmxShYH328e7ENEmpT4bF7tx0gfUwayfU4kEk/UngctpkhFQDbgoga
         xyxXxHS4BvIWKzfB0IHjgSifOQwMQMkqvF7ZaQtM/MKoF1xfgB1q8AT8FV9E/Qd5wM
         M6lDvkqJJaR7qG8De3ItZKBM1qOmFtqGr/xaohx0=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33393Puk098920
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 04:03:25 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 04:03:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 04:03:24 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33393LOM028016;
        Mon, 3 Apr 2023 04:03:22 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
Date:   Mon, 3 Apr 2023 14:33:21 +0530
Message-ID: <20230403090321.835877-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the am65_cpsw_nuss_probe() function's cleanup path, the call to
of_platform_device_destroy() for the common->mdio_dev device is invoked
unconditionally. It is possible that either the MDIO node is not present
in the device-tree, or the MDIO node is disabled in the device-tree. In
both these cases, the MDIO device is not created, resulting in a NULL
pointer dereference when the of_platform_device_destroy() function is
invoked on the common->mdio_dev device on the cleanup path.

Fix this by ensuring that the common->mdio_dev device exists, before
attempting to invoke of_platform_device_destroy().

Fixes: a45cfcc69a25 ("net: ethernet: ti: am65-cpsw-nuss: use of_platform_device_create() for mdio")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4e3861c47708..bcea87b7151c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2926,7 +2926,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2956,7 +2957,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpts_release(common->cpts);
 	am65_cpsw_disable_serdes_phy(common);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.25.1

