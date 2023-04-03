Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7336D42CB
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjDCLBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjDCLBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:01:33 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD44113FD;
        Mon,  3 Apr 2023 04:01:31 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 333B1Emq016885;
        Mon, 3 Apr 2023 06:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680519674;
        bh=Wnf4BjVfhzbMQx2Bis6Iz0+bTqMXHMv/UcZGWxk0XQ0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=YCpD36VBHwThu6tgBvSpMF3m37xY+cfpGoSQTQwU8L/Arm9aOF7pii3e7bUk8JbwO
         EfLeyly1P/0gK10kGsuM1Sr+sdyM8/jsXe//6w9WyPcZBQK5XU2qdf+8XWjpGV2jVz
         xT2PUlQd9Fb+BDNQzbgI6Jsj62ipif6oNgfiOFMc=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 333B1E6T013295
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Apr 2023 06:01:14 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 3
 Apr 2023 06:01:13 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 3 Apr 2023 06:01:13 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 333B17wp101591;
        Mon, 3 Apr 2023 06:01:11 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2 1/3] net: ethernet: ti: am65-cpsw: Move mode specific config to mac_config()
Date:   Mon, 3 Apr 2023 16:31:04 +0530
Message-ID: <20230403110106.983994-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230403110106.983994-1-s-vadapalli@ti.com>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
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

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d17757ecbf42..74e099828978 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1504,12 +1504,17 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
 							  phylink_config);
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
 	struct am65_cpsw_common *common = port->common;
+	u32 mac_control = 0;
 
 	if (common->pdata.extra_modes & BIT(state->interface)) {
-		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			mac_control |= CPSW_SL_CTL_EXT_EN;
 			writel(ADVERTISE_SGMII,
 			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
+		}
 
+		if (mac_control)
+			cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
 		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
 		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
 	}
@@ -1553,8 +1558,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
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

