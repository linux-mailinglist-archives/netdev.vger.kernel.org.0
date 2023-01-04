Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2807465D0C3
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbjADKf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbjADKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:35:11 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5C01EEC4;
        Wed,  4 Jan 2023 02:35:10 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 304AYrFP089567;
        Wed, 4 Jan 2023 04:34:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1672828493;
        bh=JLolzC2M77GixtbG7tlUDAuwCMA/10WstQ7R0WzKE6s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=YoFgnoXMHUAFFUocgtUH6MstSHkSx75OH1zdICGA8Q+0ke5jjaP62INzKDje8CkPi
         YcAJNRLwTsCvGVkHzmd+j3s5hcLX8Fa7ghg8w5aT09j4AJvFX1AvJXZG8ivxfEPlWJ
         J0V6FDXu38j7VhwlVgFRYub+zMxfmXDjeR6z9uQk=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 304AYrUX121139
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Jan 2023 04:34:53 -0600
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 4
 Jan 2023 04:34:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 4 Jan 2023 04:34:53 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 304AYWFZ018054;
        Wed, 4 Jan 2023 04:34:48 -0600
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
Subject: [PATCH net-next v6 3/3] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
Date:   Wed, 4 Jan 2023 16:04:32 +0530
Message-ID: <20230104103432.1126403-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104103432.1126403-1-s-vadapalli@ti.com>
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
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

Add new member "serdes_phy" to struct "am65_cpsw_slave_data" to store the
SERDES PHY for each port, if it exists. Use it later while disabling the
SERDES PHY for each port.

Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
by invoking am65_cpsw_enable_serdes_phy().

Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
am65_cpsw_disable_serdes_phy().

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 68 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  1 +
 2 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 06912363d5d5..1bd11166dc28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1416,6 +1416,68 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
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
+	struct am65_cpsw_port *port;
+	struct phy *phy;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		phy = port->slave.serdes_phy;
+		if (phy)
+			am65_cpsw_disable_phy(phy);
+	}
+}
+
+static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *port_np,
+				     struct am65_cpsw_port *port)
+{
+	const char *name = "serdes-phy";
+	struct phy *phy;
+	int ret;
+
+	phy = devm_of_phy_get(dev, port_np, name);
+	if (PTR_ERR(phy) == -ENODEV)
+		return 0;
+
+	/* Serdes PHY exists. Store it. */
+	port->slave.serdes_phy = phy;
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
@@ -1959,6 +2021,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		/* Initialize the Serdes PHY for the port */
+		ret = am65_cpsw_init_serdes_phy(dev, port_np, port);
+		if (ret)
+			return ret;
+
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
 
@@ -2878,6 +2945,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	 */
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
+	am65_cpsw_disable_serdes_phy(common);
 
 	of_platform_device_destroy(common->mdio_dev, NULL);
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 4b75620f8d28..ed26768a6e51 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -32,6 +32,7 @@ struct am65_cpsw_slave_data {
 	struct device_node		*phy_node;
 	phy_interface_t			phy_if;
 	struct phy			*ifphy;
+	struct phy			*serdes_phy;
 	bool				rx_pause;
 	bool				tx_pause;
 	u8				mac_addr[ETH_ALEN];
-- 
2.25.1

