Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40836027B0
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJRI6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiJRI6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:58:43 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230553A7D;
        Tue, 18 Oct 2022 01:58:41 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29I8wTXO042014;
        Tue, 18 Oct 2022 03:58:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666083509;
        bh=YkULLNGYTCiKKV3uTi6aQb+TYdDAV94MFgivkAOeMeU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=M/k2ew09yjWhkh2bjwGbP16KWzPey6WbuksRdUqnWjIzpyfyMU7++7AcB6bGo8/9e
         Jl5zc7JOmlc8kJefWYTRLiIYldaOoVYu+I8nr+f1+oSu7nucd3UvqhqKQDn08k26Cj
         rMkxPLfdqeapLRLrkavCAsoo0/AWF06o2XFT++6E=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29I8wTaI030340
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Oct 2022 03:58:29 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 18
 Oct 2022 03:58:28 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 18 Oct 2022 03:58:29 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29I8wAcR010100;
        Tue, 18 Oct 2022 03:58:24 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <s-vadapalli@ti.com>
Subject: [PATCH v2 3/3] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
Date:   Tue, 18 Oct 2022 14:28:10 +0530
Message-ID: <20221018085810.151327-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018085810.151327-1-s-vadapalli@ti.com>
References: <20221018085810.151327-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PHY framework APIs to initialize the SERDES PHY connected to CPSW MAC.

Define the functions am65_cpsw_disable_phy(), am65_cpsw_enable_phy(),
am65_cpsw_disable_serdes_phy() and am65_cpsw_init_serdes_phy().

Power on and initialize the SerDes PHY in am65_cpsw_nuss_init_slave_ports()
by invoking am65_cpsw_init_serdes_phy().

Power off the SerDes PHY in am65_cpsw_nuss_remove() by invoking
am65_cpsw_disable_serdes_phy().

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 65 ++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 91e294afc3ad..519ebd371dd8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1403,6 +1403,65 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
 	.ndo_get_devlink_port   = am65_cpsw_ndo_get_devlink_port,
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
@@ -1880,6 +1939,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		/* Initialize the phy for the port */
+		ret = am65_cpsw_init_serdes_phy(dev, port_np);
+		if (ret)
+			return ret;
+
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
 
@@ -2833,6 +2897,7 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpsw_unregister_devlink(common);
+	am65_cpsw_disable_serdes_phy(common);
 	am65_cpsw_unregister_notifiers(common);
 
 	/* must unregister ndevs here because DD release_driver routine calls
-- 
2.25.1

