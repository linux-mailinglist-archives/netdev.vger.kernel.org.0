Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDB86D5890
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjDDGQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjDDGQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:16:02 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AA30F6;
        Mon,  3 Apr 2023 23:15:30 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3346F6cH011935;
        Tue, 4 Apr 2023 01:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680588907;
        bh=oiYnpf0FJyd0FMoc+imR4JcVlxxtPshVC23LbW5qrpM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=M1PufJHXFpPHOJDJi20d8+oxzLkuNm9VIqFjDqbBcTfNI1UOrzIbQcIvPo2m1Rb0K
         DG5b7Z8yMU71TZ2YPeu1JOI2LAugJeZkyI46tLDHZ1AG8Xjtk0+lE5Ul41z3GKtA43
         zpel0EBEdoErJFo9kqoaP8k7QDCXWxp1qwlulT08=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3346F64n064194
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Apr 2023 01:15:06 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 4
 Apr 2023 01:15:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 4 Apr 2023 01:15:06 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3346ExN8087499;
        Tue, 4 Apr 2023 01:15:03 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v3 1/3] net: ethernet: ti: am65-cpsw: Move mode specific config to mac_config()
Date:   Tue, 4 Apr 2023 11:44:57 +0530
Message-ID: <20230404061459.1100519-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404061459.1100519-1-s-vadapalli@ti.com>
References: <20230404061459.1100519-1-s-vadapalli@ti.com>
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

Move the interface mode specific configuration to the mac_config()
callback am65_cpsw_nuss_mac_config().

Also, do not reset the MAC Control register on mac_link_down(). Only
clear those bits that can possibly be set in mac_link_up().

Let the MAC remain in IDLE state after mac_link_down(). Bring it out of
the IDLE state on mac_link_up().

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d17757ecbf42..99d18eb6bbe9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1506,9 +1506,13 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 	struct am65_cpsw_common *common = port->common;
 
 	if (common->pdata.extra_modes & BIT(state->interface)) {
-		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
 			writel(ADVERTISE_SGMII,
 			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+			cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_EXT_EN);
+		} else {
+			cpsw_sl_ctl_clr(port->slave.mac_sl, CPSW_SL_CTL_EXT_EN);
+		}
 
 		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
 		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
@@ -1523,6 +1527,7 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
 	struct am65_cpsw_common *common = port->common;
 	struct net_device *ndev = port->ndev;
+	u32 mac_control;
 	int tmo;
 
 	/* disable forwarding */
@@ -1534,7 +1539,14 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
 	dev_dbg(common->dev, "down msc_sl %08x tmo %d\n",
 		cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_MACSTATUS), tmo);
 
-	cpsw_sl_ctl_reset(port->slave.mac_sl);
+	/* All the bits that am65_cpsw_nuss_mac_link_up() can possibly set */
+	mac_control = CPSW_SL_CTL_GMII_EN | CPSW_SL_CTL_GIG | CPSW_SL_CTL_IFCTL_A |
+		      CPSW_SL_CTL_FULLDUPLEX | CPSW_SL_CTL_RX_FLOW_EN | CPSW_SL_CTL_TX_FLOW_EN;
+	/* If interface mode is RGMII, CPSW_SL_CTL_EXT_EN might have been set for 10 Mbps */
+	if (phy_interface_mode_is_rgmii(interface))
+		mac_control |= CPSW_SL_CTL_EXT_EN;
+	/* Only clear those bits that can be set by am65_cpsw_nuss_mac_link_up() */
+	cpsw_sl_ctl_clr(port->slave.mac_sl, mac_control);
 
 	am65_cpsw_qos_link_down(ndev);
 	netif_tx_stop_all_queues(ndev);
@@ -1551,10 +1563,12 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 	u32 mac_control = CPSW_SL_CTL_GMII_EN;
 	struct net_device *ndev = port->ndev;
 
+	/* Bring the port out of idle state */
+	cpsw_sl_ctl_clr(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
+
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
-	if (interface == PHY_INTERFACE_MODE_SGMII)
-		mac_control |= CPSW_SL_CTL_EXT_EN;
+	/* TODO: Verify whether in-band is necessary for 10 Mbps RGMII */
 	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
-- 
2.25.1

