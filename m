Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F055B8592
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiINJv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiINJvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:47 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF64F6525A;
        Wed, 14 Sep 2022 02:51:45 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9pQOM076001;
        Wed, 14 Sep 2022 04:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149086;
        bh=FdVUnDFp16ezDHMqnlWq9HVXxMiIkhGZNGfWC+wvPoQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=DnVITB5m+mXawnsBLRCWXotexkE41BX609dO9nVAKCDR7JBSRmddmwy55mZaRs3Ys
         xqZr7w3GLGZYRi+YZsUkqrsenJ4G9LfyH2jA/sfqRw7tfdNW/rdnGu8clpWyUWvPMp
         pcODLdIrR/W9hsQkjMBuC8iCgZyBc3uNVlV1GSTQ=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9pQ9U010396
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:26 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:25 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD5046564;
        Wed, 14 Sep 2022 04:51:21 -0500
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
Subject: [PATCH 5/8] net: ethernet: ti: am65-cpsw: Add support for fixed-link configuration
Date:   Wed, 14 Sep 2022 15:20:50 +0530
Message-ID: <20220914095053.189851-6-s-vadapalli@ti.com>
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

Check for fixed-link in am65_cpsw_nuss_mac_config() using struct
am65_cpsw_slave_data's phy_node property to obtain fwnode. Since
am65_cpsw_nuss_mac_link_up() is not invoked in fixed-link mode, perform
the relevant operations in am65_cpsw_nuss_mac_config() itself.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 40 ++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 72b1df12f320..1739c389af20 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1494,10 +1494,50 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 							  phylink_config);
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
 	struct am65_cpsw_common *common = port->common;
+	struct fwnode_handle *fwnode;
+	bool fixed_link = false;
 
 	if (common->pdata.extra_modes & BIT(state->interface))
 		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
 		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
+
+	/* Detecting fixed-link */
+	fwnode = of_node_to_fwnode(port->slave.phy_node);
+	if (fwnode)
+		fixed_link = !!fwnode_get_named_child_node(fwnode, "fixed-link");
+
+	if (fixed_link) {
+		/* In fixed-link mode, mac_link_up is not invoked.
+		 * Therefore, the relevant mac_link_up operations
+		 * have to be moved to mac_config.
+		 */
+		am65_cpsw_nuss_mac_control(port, state->interface, state->speed,
+					   state->duplex, state->pause & MLO_PAUSE_TX,
+					   state->pause & MLO_PAUSE_RX);
+
+		if (state->speed == SPEED_1000)
+			mr_adv_ability |= MAC2MAC_MR_ADV_ABILITY_1G;
+		if (state->speed == SPEED_100)
+			mr_adv_ability |= MAC2MAC_MR_ADV_ABILITY_100M;
+		if (state->duplex)
+			mr_adv_ability |= MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX;
+
+		if (state->interface == PHY_INTERFACE_MODE_SGMII &&
+		    (common->pdata.extra_modes & BIT(state->interface))) {
+			writel(mr_adv_ability,
+			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+			writel((AM65_CPSW_SGMII_CONTROL_MASTER_MODE |
+			       AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE),
+			       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
+		}
+
+		am65_cpsw_nuss_mac_enable_link(port, state->speed, state->duplex);
+	} else {
+		if (state->interface == PHY_INTERFACE_MODE_SGMII &&
+		    (common->pdata.extra_modes & BIT(state->interface)))
+			writel(MAC2PHY_MR_ADV_ABILITY,
+			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+	}
 }
 
 static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned int mode,
-- 
2.25.1

