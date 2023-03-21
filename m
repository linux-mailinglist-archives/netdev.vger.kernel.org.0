Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08536C3036
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCULUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCULUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:20:42 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA9130289;
        Tue, 21 Mar 2023 04:20:23 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32LBK6Il127860;
        Tue, 21 Mar 2023 06:20:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1679397606;
        bh=sA5WPt7hqmI71j0RcfE7aJp3jEnVUd4Dp5NXf/LOYxc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=w1D61zYKNATROdXVJ0omKaXrychowTw0thICdPIYMld8poYbkIaebSHgIe5r+2dl0
         1SY9OD/CWLwwURBNxSJl21xUTVlqdC7xxgfb6QosWBVnthFwTxHpkmn5IILD0/ASwT
         mW8MVTc4SMViOQdTfw0dMI6kaiFvYc//ALjAATa8=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32LBK6f9091404
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Mar 2023 06:20:06 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 21
 Mar 2023 06:20:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 21 Mar 2023 06:20:06 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32LBJxVn088542;
        Tue, 21 Mar 2023 06:20:03 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 1/4] net: ethernet: ti: am65-cpsw: Simplify setting supported interface
Date:   Tue, 21 Mar 2023 16:49:55 +0530
Message-ID: <20230321111958.2800005-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230321111958.2800005-1-s-vadapalli@ti.com>
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the existing IF/ELSE statement based approach of setting the
supported_interfaces member of struct "phylink_config", to SWITCH
statements. This will help scale to newer PHY-MODES as well as newer
compatibles.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 27 ++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4cfbc1c2b1c4..cba8db14e160 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2143,15 +2143,30 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->slave.phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100 | MAC_1000FD;
 	port->slave.phylink_config.mac_managed_pm = true; /* MAC does PM */
 
-	if (phy_interface_mode_is_rgmii(port->slave.phy_if)) {
+	switch (port->slave.phy_if) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
-	} else if (port->slave.phy_if == PHY_INTERFACE_MODE_RMII) {
+		break;
+
+	case PHY_INTERFACE_MODE_RMII:
 		__set_bit(PHY_INTERFACE_MODE_RMII,
 			  port->slave.phylink_config.supported_interfaces);
-	} else if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
-		__set_bit(PHY_INTERFACE_MODE_QSGMII,
-			  port->slave.phylink_config.supported_interfaces);
-	} else {
+		break;
+
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (common->pdata.extra_modes & BIT(port->slave.phy_if)) {
+			__set_bit(port->slave.phy_if,
+				  port->slave.phylink_config.supported_interfaces);
+		} else {
+			dev_err(dev, "selected phy-mode is not supported\n");
+			return -EOPNOTSUPP;
+		}
+		break;
+
+	default:
 		dev_err(dev, "selected phy-mode is not supported\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.25.1

