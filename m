Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E496046E4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJSNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiJSNVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:21:55 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DAEF9A9D0;
        Wed, 19 Oct 2022 06:07:04 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="137159777"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 19 Oct 2022 17:51:10 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id AD56F400BC17;
        Wed, 19 Oct 2022 17:51:10 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, kabel@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH RFC 3/3] net: renesas: rswitch: Pass host parameters to phydev
Date:   Wed, 19 Oct 2022 17:50:52 +0900
Message-Id: <20221019085052.933385-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of_phy_connect_with_host_params() to pass host parameters to
phydev. Otherwise, connected PHY cannot work correctly.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index c604331bfd88..bb2f1e667210 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -16,6 +16,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/phy.h>
 #include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -1234,11 +1235,19 @@ static void rswitch_phy_remove_link_mode(struct rswitch_device *rdev,
 
 static int rswitch_phy_init(struct rswitch_device *rdev, struct device_node *phy)
 {
+	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
 	struct phy_device *phydev;
 	int err = 0;
 
-	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
-				rdev->etha->phy_interface);
+	phy_interface_zero(host_interfaces);
+	if (rdev->etha->phy_interface == PHY_INTERFACE_MODE_SGMII)
+		__set_bit(PHY_INTERFACE_MODE_SGMII, host_interfaces);
+
+	phydev = of_phy_connect_with_host_params(rdev->ndev, phy,
+						 rswitch_adjust_link, 0,
+						 rdev->etha->phy_interface,
+						 host_interfaces,
+						 rdev->etha->speed);
 	if (!phydev) {
 		err = -ENOENT;
 		goto out;
-- 
2.25.1

