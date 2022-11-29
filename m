Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E338E63B94D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiK2FHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiK2FHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:07:11 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6164A073;
        Mon, 28 Nov 2022 21:07:09 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2AT56jKP009092;
        Mon, 28 Nov 2022 23:06:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669698405;
        bh=iwk3oIdldhQM9vSgoDXE1DpAlk1h7MOXHjQVbNnRDM8=;
        h=From:To:CC:Subject:Date;
        b=q7yKPk7xXFfft0reaARWjDEHhQuzysWq+4zuPtm9KZgeT7MOTOTsud/xd41+F+LdM
         yBTgGZUadY0/Nj/B9Rm/Rm9d5BCIsIcflfAaq72eJ9wujI+7EwnH79Z0iVCoPo6R7K
         KQE4xK25xcfz6pO5AxcGN75dbvaCiJqnxPRQU5/U=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2AT56juT032181
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Nov 2022 23:06:45 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 28
 Nov 2022 23:06:44 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 28 Nov 2022 23:06:44 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2AT56eM8017073;
        Mon, 28 Nov 2022 23:06:41 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        <pabeni@redhat.com>, <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <spatton@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH net] net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10
Date:   Tue, 29 Nov 2022 10:36:39 +0530
Message-ID: <20221129050639.111142-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The am65-cpsw driver supports configuring all RGMII variants at interface
speed of 10 Mbps. However, in the process of shifting to the PHYLINK
framework, the support for all variants of RGMII except the
PHY_INTERFACE_MODE_RGMII variant was accidentally removed.

Fix this by using phy_interface_mode_is_rgmii() to check for all variants
of RGMII mode.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Reported-by: Schuyler Patton <spatton@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6b0458df613a..6ae802d73063 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1495,7 +1495,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
-	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
 	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
-- 
2.25.1

