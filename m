Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC735B858A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiINJvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiINJvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:41 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1591C6564B;
        Wed, 14 Sep 2022 02:51:38 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9pLvM101296;
        Wed, 14 Sep 2022 04:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149081;
        bh=bxRmlv6CKHRPXNNeAzFSCgP9txXfJvzZ4l0TXlSS8Ig=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=eFN5dR8821LmeB+NrlOQwkF/VFiBsJYTOjJXEeIfXoO3XTDu79GiPpWzXKd3aSXA2
         L/Zy9EmCtYsTFAKQ/gtoSFkYmdXTFPj5BhPQSqNBUdg3SMScPGW1S35kXOkRkAtvBh
         ssBd+PrwPo6Fu1/ERlo+ieVCvLWbaJ/uX2ZS31cs=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9pLmd010367
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:21 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:20 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:20 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD4046564;
        Wed, 14 Sep 2022 04:51:16 -0500
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
Subject: [PATCH 4/8] net: ethernet: ti: am65-cpsw: Add mac enable link function
Date:   Wed, 14 Sep 2022 15:20:49 +0530
Message-ID: <20220914095053.189851-5-s-vadapalli@ti.com>
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

Add function am65_cpsw_nuss_mac_enable_link() to invoke
am65_cpsw_enable_phy(), cpsw_ale_control_set(), am65_cpsw_qos_link_up()
and netif_tx_wake_all_queues() to prevent duplicate code. The above
set of function calls are currently invoked by the
am65_cpsw_nuss_mac_link_up() function. In a later patch in this series
meant for adding fixed-link support, even the am65_cpsw_nuss_mac_config()
function will invoke the same set of functions.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 25 ++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c7e6ad374e1a..72b1df12f320 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1473,6 +1473,20 @@ static void am65_cpsw_nuss_mac_control(struct am65_cpsw_port *port, phy_interfac
 	cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
 }
 
+static void am65_cpsw_nuss_mac_enable_link(struct am65_cpsw_port *port, int speed, int duplex)
+{
+	struct am65_cpsw_common *common = port->common;
+	struct net_device *ndev = port->ndev;
+	/* enable phy */
+	am65_cpsw_enable_phy(port->slave.ifphy);
+
+	/* enable forwarding */
+	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
+
+	am65_cpsw_qos_link_up(ndev, speed);
+	netif_tx_wake_all_queues(ndev);
+}
+
 static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned int mode,
 				      const struct phylink_link_state *state)
 {
@@ -1521,19 +1535,10 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
 							  phylink_config);
 	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
-	struct am65_cpsw_common *common = port->common;
-	struct net_device *ndev = port->ndev;
 
 	am65_cpsw_nuss_mac_control(port, interface, speed, duplex, tx_pause, rx_pause);
 
-	/* enable phy */
-	am65_cpsw_enable_phy(port->slave.ifphy);
-
-	/* enable forwarding */
-	cpsw_ale_control_set(common->ale, port->port_id, ALE_PORT_STATE, ALE_PORT_STATE_FORWARD);
-
-	am65_cpsw_qos_link_up(ndev, speed);
-	netif_tx_wake_all_queues(ndev);
+	am65_cpsw_nuss_mac_enable_link(port, speed, duplex);
 }
 
 static const struct phylink_mac_ops am65_cpsw_phylink_mac_ops = {
-- 
2.25.1

