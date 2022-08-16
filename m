Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29295954EC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiHPIWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiHPIVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:21:47 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EE1786FB;
        Mon, 15 Aug 2022 23:02:25 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27G61t7l027052;
        Tue, 16 Aug 2022 01:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660629715;
        bh=TLaWC/x3KTfzbuqOw7zZ8+e7HXPlS1d9mqSM5aYJCJY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=XVDq8CRekELjga/5uE5u0A62gHyBmYuI+3CG8W3CWxyLtpWVSYl2Aw40ztBNudRpV
         uLHmnmAd6vegNu7YzDyHHdcyIu4Qa/YioDSSEyp9BKW7IkUtrFjoQ08EKTJbjyXQNN
         pJMxiSo8hzTzKjz0vY08BOuMsxiZhJzjd88wWSEs=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27G61tfV016719
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Aug 2022 01:01:55 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 16
 Aug 2022 01:01:54 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 16 Aug 2022 01:01:54 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27G61dq4114915;
        Tue, 16 Aug 2022 01:01:49 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH v4 2/3] net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
Date:   Tue, 16 Aug 2022 11:31:38 +0530
Message-ID: <20220816060139.111934-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816060139.111934-1-s-vadapalli@ti.com>
References: <20220816060139.111934-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPSW5G in J7200 supports additional modes like QSGMII and SGMII.
Add new compatible for J7200 and enable QSGMII mode in am65-cpsw driver.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 35 ++++++++++++++++++++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |  2 ++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index f4a6b590a1e3..033b40649308 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -74,6 +74,9 @@
 #define AM65_CPSW_PORTN_REG_TS_VLAN_LTYPE_REG	0x318
 #define AM65_CPSW_PORTN_REG_TS_CTL_LTYPE2       0x31C
 
+#define AM65_CPSW_SGMII_CONTROL_REG		0x010
+#define AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE	BIT(0)
+
 #define AM65_CPSW_CTL_VLAN_AWARE		BIT(1)
 #define AM65_CPSW_CTL_P0_ENABLE			BIT(2)
 #define AM65_CPSW_CTL_P0_TX_CRC_REMOVE		BIT(13)
@@ -1409,7 +1412,14 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
-	/* Currently not used */
+	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
+							  phylink_config);
+	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
+	struct am65_cpsw_common *common = port->common;
+
+	if (common->pdata.extra_modes & BIT(state->interface))
+		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
+		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
 }
 
 static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -1847,6 +1857,8 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		port->common = common;
 		port->port_base = common->cpsw_base + AM65_CPSW_NU_PORTS_BASE +
 				  AM65_CPSW_NU_PORTS_OFFSET * (port_id);
+		if (common->pdata.extra_modes)
+			port->sgmii_base = common->ss_base + AM65_CPSW_SGMII_BASE * (port_id);
 		port->stat_base = common->cpsw_base + AM65_CPSW_NU_STATS_BASE +
 				  (AM65_CPSW_NU_STATS_PORT_OFFSET * port_id);
 		port->name = of_get_property(port_np, "label", NULL);
@@ -1981,7 +1993,18 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.type = PHYLINK_NETDEV;
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
 
-	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
+		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
+	} else if (port->slave.phy_if == PHY_INTERFACE_MODE_RMII) {
+		__set_bit(PHY_INTERFACE_MODE_RMII,
+			  port->slave.phylink_config.supported_interfaces);
+	} else if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
+		__set_bit(PHY_INTERFACE_MODE_QSGMII,
+			  port->slave.phylink_config.supported_interfaces);
+	} else {
+		dev_err(dev, "selected phy-mode is not supported\n");
+		return -EOPNOTSUPP;
+	}
 
 	phylink = phylink_create(&port->slave.phylink_config,
 				 of_node_to_fwnode(port->slave.phy_node),
@@ -2611,10 +2634,18 @@ static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
 };
 
+static const struct am65_cpsw_pdata j7200_cpswxg_pdata = {
+	.quirks = 0,
+	.ale_dev_id = "am64-cpswxg",
+	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
+	.extra_modes = BIT(PHY_INTERFACE_MODE_QSGMII),
+};
+
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
 	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0},
 	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_pdata},
 	{ .compatible = "ti,am642-cpsw-nuss", .data = &am64x_cpswxg_pdata},
+	{ .compatible = "ti,j7200-cpswxg-nuss", .data = &j7200_cpswxg_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index ac945631bf2f..2c9850fdfcb6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -46,6 +46,7 @@ struct am65_cpsw_port {
 	const char			*name;
 	u32				port_id;
 	void __iomem			*port_base;
+	void __iomem			*sgmii_base;
 	void __iomem			*stat_base;
 	void __iomem			*fetch_ram_base;
 	bool				disabled;
@@ -88,6 +89,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	u64	extra_modes;
 	enum k3_ring_mode fdqring_mode;
 	const char	*ale_dev_id;
 };
-- 
2.25.1

