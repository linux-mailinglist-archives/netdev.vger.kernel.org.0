Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EAE620AE7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiKHIG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiKHIGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:06:50 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380A71DF0E;
        Tue,  8 Nov 2022 00:06:49 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A886QHN088111;
        Tue, 8 Nov 2022 02:06:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667894786;
        bh=k79QrKMzw8vOLjRUHHb3Q9iyIHV7a762b3HCdbhRf9M=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=g5CdU1jRXbCFhXjQ7mBp9CNX1GGmI/Sebxl73G4wE4RnBX20TRGVufQEPYUIh8XTx
         e/X+DHUlQp5+gEt+UGN3erMFzepDh+fKBN0Gvj5yBcmvWJhSJrmiH8bK26ahEGppqC
         ylHV3x0lBWaAoRr/d5SXs7l03cAOb3M4aFUio6AQ=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A886QKs037261
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Nov 2022 02:06:26 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 8 Nov
 2022 02:06:25 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 8 Nov 2022 02:06:25 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A8866mF033956;
        Tue, 8 Nov 2022 02:06:21 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v4 3/3] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
Date:   Tue, 8 Nov 2022 13:36:06 +0530
Message-ID: <20221108080606.124596-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108080606.124596-1-s-vadapalli@ti.com>
References: <20221108080606.124596-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.

Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
am65_cpsw_disable_serdes_phy() and am65_cpsw_enable_serdes_phy().

Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
by invoking am65_cpsw_enable_serdes_phy().

Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
am65_cpsw_disable_serdes_phy().

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 65 ++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4d4e1c8bd715..1234681c035a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1395,6 +1395,65 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 };
 
+static void am65_cpsw_disable_phy(struct phy *phy)
+{
+	phy_power_off(phy);
+	phy_exit(phy);
+}
+
+static int am65_cpsw_enable_phy(struct phy *phy)
+{
+	int ret;
+
+	ret = phy_init(phy);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_power_on(phy);
+	if (ret < 0) {
+		phy_exit(phy);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void am65_cpsw_disable_serdes_phy(struct am65_cpsw_common *common)
+{
+	struct device_node *node, *port_np;
+	struct device *dev = common->dev;
+	const char *name = "serdes-phy";
+	struct phy *phy;
+
+	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
+
+	for_each_child_of_node(node, port_np) {
+		phy = devm_of_phy_get(dev, port_np, name);
+		am65_cpsw_disable_phy(phy);
+	}
+}
+
+static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np)
+{
+	const char *name = "serdes-phy";
+	struct phy *phy;
+	int ret;
+
+	phy = devm_of_phy_get(dev, port_np, name);
+	if (PTR_ERR(phy) == -ENODEV)
+		return 0;
+
+	ret =  am65_cpsw_enable_phy(phy);
+	if (ret < 0)
+		goto err_phy;
+
+	return 0;
+
+err_phy:
+	devm_phy_put(dev, phy);
+	return ret;
+}
+
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
@@ -1872,6 +1931,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		/* Initialize the phy for the port */
+		ret = am65_cpsw_init_serdes_phy(dev, port_np);
+		if (ret)
+			return ret;
+
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
 
@@ -2822,6 +2886,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 		return ret;
 
 	am65_cpsw_unregister_devlink(common);
+	am65_cpsw_disable_serdes_phy(common);
 	am65_cpsw_unregister_notifiers(common);
 
 	/* must unregister ndevs here because DD release_driver routine calls
-- 
2.25.1

