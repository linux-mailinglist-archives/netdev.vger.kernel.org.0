Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832076D42CD
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjDCLBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjDCLBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:01:35 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451F9EB7C;
        Mon,  3 Apr 2023 04:01:34 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333B1Kow089198;
        Mon, 3 Apr 2023 06:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680519680;
        bh=Gq892BO5Nd7eJ/TYJ42yvxXpfOxGBtiDTJO8KV3Uvx8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=vJ/PpNoIJ53PoED8WuQjupEHSNVgKjhXzoURaqpo90MKSSFFE3MCKNNveY90UB40Z
         lPW1l4RaCxd9f+yqbkjH9JqiuTTyxkeMbx1P9j6ygtvHq6J8zl9UMa7pHjUeFnUpcV
         qKQspohs5dKlMNT2NIWDbjp7zZbl2UkN/1byjFRw=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333B1Kcx013344
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:01:20 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:01:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:01:20 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333B17wr101591;
        Mon, 3 Apr 2023 06:01:17 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 3/3] net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G
Date:   Mon, 3 Apr 2023 16:31:06 +0530
Message-ID: <20230403110106.983994-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230403110106.983994-1-s-vadapalli@ti.com>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
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

TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
extra_modes member of the J784S4 SoC data.

Additionally, convert the IF statement in am65_cpsw_nuss_mac_config() to
SWITCH statement to scale for new modes. Configure MAC control register
for supporting USXGMII mode and add MAC_5000FD in the "mac_capabilities"
member of struct "phylink_config".

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6c118a9abb2f..f4d4f987563c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1507,10 +1507,20 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 	u32 mac_control = 0;
 
 	if (common->pdata.extra_modes & BIT(state->interface)) {
-		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+		switch (state->interface) {
+		case PHY_INTERFACE_MODE_SGMII:
 			mac_control |= CPSW_SL_CTL_EXT_EN;
 			writel(ADVERTISE_SGMII,
 			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+			break;
+
+		case PHY_INTERFACE_MODE_USXGMII:
+			mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
+			break;
+
+		default:
+			/* No special configuration is required for other modes */
+			break;
 		}
 
 		if (mac_control)
@@ -2161,7 +2171,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	/* Configuring Phylink */
 	port->slave.phylink_config.dev = &port->ndev->dev;
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
-	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
+	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 |
+						      MAC_1000FD | MAC_5000FD;
 	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
 	switch (port->slave.phy_if) {
@@ -2179,6 +2190,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	case PHY_INTERFACE_MODE_QSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
 		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
 			__set_bit(port->slave.phy_if,
 				  port->slave.phylink_config.supported_interfaces);
@@ -2804,7 +2816,7 @@ static const struct am65_cpsw_pdata j784s4_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_USXGMII),
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-- 
2.25.1

