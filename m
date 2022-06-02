Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CA153B813
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiFBLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiFBLrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:47:15 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0856250683;
        Thu,  2 Jun 2022 04:47:08 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 252BkwRX102346;
        Thu, 2 Jun 2022 06:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654170418;
        bh=f0yqobML3CnwNdY+Qy6SB8ntB5oYAsWJPwB1gkDv2D8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mToPto9RxamrvzDuzmXvxaSDyBTtL+zsIk9fdiHVW8KO1XVLaxT7L5dFT9sfgE6JT
         XhE5HyPlaOmKIeozwNRdYH6GtGfsMWpO+hyq15ql9vmPm1mcFOtDNh6I6YpgFl5Bo8
         bLJ5s5G9buTdYYJwdZKn9dJPaa/R+cB5/AfPCT8w=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 252Bkwm8004417
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jun 2022 06:46:58 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 2
 Jun 2022 06:46:57 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 2 Jun 2022 06:46:57 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 252BkDxi035959;
        Thu, 2 Jun 2022 06:46:52 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v2 3/3] net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct location
Date:   Thu, 2 Jun 2022 17:15:58 +0530
Message-ID: <20220602114558.6204-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220602114558.6204-1-s-vadapalli@ti.com>
References: <20220602114558.6204-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In TI's J7200 SoC CPSW5G ports, each of the 4 ports can be configured
as a QSGMII main or QSGMII-SUB port. This configuration is performed
by phy-gmii-sel driver on invoking the phy_set_mode_ext() function.

It is necessary for the QSGMII main port to be configured before any of
the QSGMII-SUB interfaces are brought up. Currently, the QSGMII-SUB
interfaces come up before the QSGMII main port is configured.

Fix this by moving the call to phy_set_mode_ext() from
am65_cpsw_nuss_ndo_slave_open() to am65_cpsw_nuss_init_slave_ports(),
thereby ensuring that the QSGMII main port is configured before any of
the QSGMII-SUB ports are brought up.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8a8dabf824f1..877880ec5f5b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -593,11 +593,6 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
 	/* mac_sl should be configured via phy-link interface */
 	am65_cpsw_sl_ctl_reset(port);
 
-	ret = phy_set_mode_ext(port->slave.ifphy, PHY_MODE_ETHERNET,
-			       port->slave.phy_if);
-	if (ret)
-		goto error_cleanup;
-
 	ret = phylink_of_phy_connect(port->slave.phylink, port->slave.phy_node, 0);
 	if (ret)
 		goto error_cleanup;
@@ -1897,6 +1892,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 		}
 
+		ret = phy_set_mode_ext(port->slave.ifphy, PHY_MODE_ETHERNET, port->slave.phy_if);
+		if (ret)
+			goto of_node_put;
+
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
 		if (ret) {
 			am65_cpsw_am654_get_efuse_macid(port_np,
-- 
2.36.1

