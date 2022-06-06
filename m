Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8805A53E701
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiFFLGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiFFLGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:06:09 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0FA1AEC58;
        Mon,  6 Jun 2022 04:06:08 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 256B5sXE102741;
        Mon, 6 Jun 2022 06:05:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1654513554;
        bh=FoEHfppcBH5ypuNg8IYRoQwWEv7Ea2ouhUUYH5ejt44=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=peIJUOVZbSCz8NwHOAJEmmCXWqHj2fIEA0eVM533mB3k06gKztiYcOL76DYnMHg6m
         RjEl/71lVRqq2nQfoCTZfc9Q/7pko4RzDu5v9mTHCAtL7cbOKaEdrfkhQMBzodbaW0
         L0OSiOeB5Qc3COXHA+guUi/3PqYKidro2DMKh3mA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 256B5sip010225
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Jun 2022 06:05:54 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 6
 Jun 2022 06:05:53 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 6 Jun 2022 06:05:53 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 256B57G5072083;
        Mon, 6 Jun 2022 06:05:48 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH v3 3/3] net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct location
Date:   Mon, 6 Jun 2022 16:34:43 +0530
Message-ID: <20220606110443.30362-4-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220606110443.30362-1-s-vadapalli@ti.com>
References: <20220606110443.30362-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index db94e8cdef56..0eda6104605c 100644
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
@@ -1898,6 +1893,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
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

