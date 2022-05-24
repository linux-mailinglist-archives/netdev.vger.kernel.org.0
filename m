Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B281F53231D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiEXG1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiEXG06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:26:58 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4756D199;
        Mon, 23 May 2022 23:26:56 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24O6Qj3g025449;
        Tue, 24 May 2022 01:26:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653373605;
        bh=Sb45dTrApxFaeFEfp/c5MUaXF8wbmHfKv5XN2SAovx0=;
        h=From:To:CC:Subject:Date;
        b=hqiBOUCLI4dKt+jz6hysBr06tMpJM33QLUXk/8k/lgUgMNdx68kACGYHdWDjp5bZE
         woYjk8Go6lx4pA64UPZGfGZ2C+ohukriZejks0rijzhbzqGNnJ+6JaBtnXXNSjWYGD
         vwLHXB7JuOI3iScJz4Wt46taoqY2TbNzIyFGXLx8=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24O6QjV1013216
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 May 2022 01:26:45 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 24
 May 2022 01:26:44 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 24 May 2022 01:26:44 -0500
Received: from ula0492258.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24O6Qe6r053215;
        Tue, 24 May 2022 01:26:41 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: [PATCH] net: ethernet: ti: am65-cpsw: Fix fwnode passed to phylink_create()
Date:   Tue, 24 May 2022 11:55:58 +0530
Message-ID: <20220524062558.19296-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

am65-cpsw-nuss driver incorrectly uses fwnode member of common
ethernet device's "struct device_node" instead of using fwnode
member of the port's "struct device_node" in phylink_create().
This results in all ports having the same phy data when there
are multiple ports with their phy properties populated in their
respective nodes rather than the common ethernet device node.

Fix it here by using fwnode member of the port's node.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 34197c67f8d9..77bdda97b2b0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/kmemleak.h>
 #include <linux/module.h>
@@ -1981,7 +1982,9 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	phy_interface_set_rgmii(port->slave.phylink_config.supported_interfaces);
 
-	phylink = phylink_create(&port->slave.phylink_config, dev->fwnode, port->slave.phy_if,
+	phylink = phylink_create(&port->slave.phylink_config,
+				 of_node_to_fwnode(port->slave.phy_node),
+				 port->slave.phy_if,
 				 &am65_cpsw_phylink_mac_ops);
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
-- 
2.36.0

