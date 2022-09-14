Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38B5B858D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiINJvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiINJvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:42 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391F16567B;
        Wed, 14 Sep 2022 02:51:41 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9pGI9101288;
        Wed, 14 Sep 2022 04:51:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149076;
        bh=GBPguLYuzWpgkQWE27/xUN3UdxcXSGCcXgb3PiozCmY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=kUiSuUrDNHyeW03LAxlB5F8+W5FOPmLG0+WD+1lDn7gPT3VjNnRWO/ZFXHsj/HkxB
         SI9Rn3j7cv5Lx/Z8Pu/W7RbyU5+n9uF70SKf4dqwSsU8235WxvZZ3ZGih1cWshmula
         Kh2ER07pdRfWoJ90w72d7JrWQN562QM/9izbupMo=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9pG0W020328
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:16 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:15 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD3046564;
        Wed, 14 Sep 2022 04:51:10 -0500
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
Subject: [PATCH 3/8] net: ethernet: ti: am65-cpsw: Add mac control function
Date:   Wed, 14 Sep 2022 15:20:48 +0530
Message-ID: <20220914095053.189851-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914095053.189851-1-s-vadapalli@ti.com>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
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

Add function am65_cpsw_nuss_mac_control() corresponding to the mac
control register writes that are performed in the
am65_cpsw_nuss_mac_link_up() function and use it in the
am65_cpsw_nuss_mac_link_up() function. The newly added function will be
used in am65_cpsw_nuss_mac_config() function in a future patch, thereby
making it necessary to define a new function for the redundant mac control
operations.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 45 ++++++++++++++----------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4e06def3b0de..c7e6ad374e1a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1448,6 +1448,31 @@ static int am65_cpsw_init_phy(struct device *dev, struct device_node *port_np)
 	return ret;
 }
 
+static void am65_cpsw_nuss_mac_control(struct am65_cpsw_port *port, phy_interface_t interface,
+				       int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	u32 mac_control = CPSW_SL_CTL_GMII_EN;
+
+	if (speed == SPEED_1000)
+		mac_control |= CPSW_SL_CTL_GIG;
+	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+		/* Can be used with in band mode only */
+		mac_control |= CPSW_SL_CTL_EXT_EN;
+	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
+		mac_control |= CPSW_SL_CTL_IFCTL_A;
+	if (duplex)
+		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
+
+	/* rx_pause/tx_pause */
+	if (rx_pause)
+		mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
+
+	if (tx_pause)
+		mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
+
+	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
+}
+
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
@@ -1497,27 +1522,9 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 							  phylink_config);
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
 	struct am65_cpsw_common *common = port->common;
-	u32 mac_control = CPSW_SL_CTL_GMII_EN;
 	struct net_device *ndev = port->ndev;
 
-	if (speed == SPEED_1000)
-		mac_control |= CPSW_SL_CTL_GIG;
-	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
-		/* Can be used with in band mode only */
-		mac_control |= CPSW_SL_CTL_EXT_EN;
-	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
-		mac_control |= CPSW_SL_CTL_IFCTL_A;
-	if (duplex)
-		mac_control |= CPSW_SL_CTL_FULLDUPLEX;
-
-	/* rx_pause/tx_pause */
-	if (rx_pause)
-		mac_control |= CPSW_SL_CTL_RX_FLOW_EN;
-
-	if (tx_pause)
-		mac_control |= CPSW_SL_CTL_TX_FLOW_EN;
-
-	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
+	am65_cpsw_nuss_mac_control(port, interface, speed, duplex, tx_pause, rx_pause);
 
 	/* enable phy */
 	am65_cpsw_enable_phy(port->slave.ifphy);
-- 
2.25.1

