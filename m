Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955E95B8599
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiINJw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiINJwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:52:03 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C36555A;
        Wed, 14 Sep 2022 02:51:55 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9pVXb116306;
        Wed, 14 Sep 2022 04:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149091;
        bh=cYnVCzPop8k5y+hR9tAMycNRH40pU/vGzzd88JPo2Rg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=t666gbDm9fUyWFcKwu0587tBgpCt7RSRx6w3W6BYJeSAkL/8GaJxuyG3vjWdvZt2a
         yWtzK7HYG1z3Vtlezh7UCyFNMP/0mg+uJwPej0csK58FPJcNQLtHtS3yxKMO4bdn4P
         pOsx6Pll3Y+Zu7XkAqnvi5e4djDzWiEpfAZaswsE=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9pVFx010416
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:31 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:31 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:30 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD6046564;
        Wed, 14 Sep 2022 04:51:26 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH 6/8] net: ethernet: ti: am65-cpsw: Add support for SGMII mode for J7200 CPSW5G
Date:   Wed, 14 Sep 2022 15:20:51 +0530
Message-ID: <20220914095053.189851-7-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914095053.189851-1-s-vadapalli@ti.com>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SGMII mode in both fixed-link MAC2MAC master mode and
MAC2PHY modes for CPSW5G ports.

Add SGMII mode to the list of extra_modes in j7200_cpswxg_pdata.

The MAC2PHY mode has been tested in fixed-link mode using a bootstrapped
PHY. The MAC2MAC mode has been tested by a customer with J7200 SoC on
their device.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 1739c389af20..3f40178436ff 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -75,7 +75,15 @@
 #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
 
 #define AM65_CPSW_SGMII_CONTROL_REG		0x010
+#define AM65_CPSW_SGMII_MR_ADV_ABILITY_REG	0x018
 #define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
+#define AM65_CPSW_SGMII_CONTROL_MASTER_MODE	BIT(5)
+
+#define MAC2MAC_MR_ADV_ABILITY_BASE		(BIT(15) | BIT(0))
+#define MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX	BIT(12)
+#define MAC2MAC_MR_ADV_ABILITY_1G		BIT(11)
+#define MAC2MAC_MR_ADV_ABILITY_100M		BIT(10)
+#define MAC2PHY_MR_ADV_ABILITY			BIT(0)
 
 #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
 #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
@@ -1493,6 +1501,7 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
 							  phylink_config);
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+	u32 mr_adv_ability = MAC2MAC_MR_ADV_ABILITY_BASE;
 	struct am65_cpsw_common *common = port->common;
 	struct fwnode_handle *fwnode;
 	bool fixed_link = false;
@@ -2105,8 +2114,12 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 		__set_bit(PHY_INTERFACE_MODE_RMII,
 			  port->slave.phylink_config.supported_interfaces);
 	} else if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
-		__set_bit(PHY_INTERFACE_MODE_QSGMII,
-			  port->slave.phylink_config.supported_interfaces);
+		if (port->slave.phy_if == PHY_INTERFACE_MODE_QSGMII)
+			__set_bit(PHY_INTERFACE_MODE_QSGMII,
+				  port->slave.phylink_config.supported_interfaces);
+		else
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  port->slave.phylink_config.supported_interfaces);
 	} else {
 		dev_err(dev, "selected phy-mode is not supported\n");
 		return -EOPNOTSUPP;
@@ -2744,7 +2757,7 @@ static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
-	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII) | BIT(PHY_INTERFACE_MODE_SGMII),
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
-- 
2.25.1

