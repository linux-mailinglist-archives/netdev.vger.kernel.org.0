Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27687622317
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKIEXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKIEXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:23:01 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122891FF8F;
        Tue,  8 Nov 2022 20:22:47 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A94MNgs075081;
        Tue, 8 Nov 2022 22:22:23 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667967743;
        bh=RBnzGDITsnmgAmda1HLuNmjSC20+kjgG18pJ0qrLfgs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=U8vjFU1VZCE4U+c4kIx0kOZjTuwF87sEsEbHg2D05NZcBOU7byU6C1P/d4aU+abtO
         YhxUYUB4hf7H51cUDjiSE9x7zbhsjQ5qk9KZ//ndaZ3kVZ2S/USDGOAl88M5lh0f1h
         MqCSJovuCj2dfz2vnOEc6Cs6vfUoau2qoX/p4JSE=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A94MNbI032611
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 8 Nov 2022 22:22:23 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 8 Nov
 2022 22:22:23 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 8 Nov 2022 22:22:23 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A94M4RA111905;
        Tue, 8 Nov 2022 22:22:19 -0600
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
Subject: [PATCH net-next v5 3/3] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
Date:   Wed, 9 Nov 2022 09:52:03 +0530
Message-ID: <20221109042203.375042-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109042203.375042-1-s-vadapalli@ti.com>
References: <20221109042203.375042-1-s-vadapalli@ti.com>
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
index bc9f29d10c22..83349d24a0e6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1444,6 +1444,65 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
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
@@ -1941,6 +2000,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		/* Initialize the phy for the port */
+		ret = am65_cpsw_init_serdes_phy(dev, port_np);
+		if (ret)
+			return ret;
+
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
 
@@ -2868,6 +2932,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
+	am65_cpsw_disable_serdes_phy(common);
 	am65_cpsw_unregister_notifiers(common);
 
 	/* must unregister ndevs here because DD release_driver routine calls
-- 
2.25.1

