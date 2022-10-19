Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11562604526
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJSMWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbiJSMWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:22:17 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8D431C3E5F;
        Wed, 19 Oct 2022 04:56:39 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,195,1661785200"; 
   d="scan'208";a="139552393"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 19 Oct 2022 17:51:10 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9388A400BC17;
        Wed, 19 Oct 2022 17:51:10 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, kabel@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed configuration
Date:   Wed, 19 Oct 2022 17:50:51 +0900
Message-Id: <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
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

Add support for selecting host speed mode. For now, only support
1000M bps.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 383a9c9f36e5..daf3242c6078 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -101,6 +101,10 @@ enum {
 	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
 	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
 
+	MV_MOD_CONF		= 0xf000,
+	MV_MOD_CONF_SPEED_MASK	= 0x00c0,
+	MV_MOD_CONF_SPEED_1000	= BIT(7),
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -147,6 +151,7 @@ struct mv3310_chip {
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*set_mactype)(struct phy_device *phydev, int mactype);
 	int (*select_mactype)(unsigned long *interfaces);
+	int (*set_macspeed)(struct phy_device *phydev, int macspeed);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
 
 #ifdef CONFIG_HWMON
@@ -644,6 +649,16 @@ static int mv2110_select_mactype(unsigned long *interfaces)
 		return -1;
 }
 
+static int mv2110_set_macspeed(struct phy_device *phydev, int macspeed)
+{
+	if (macspeed != SPEED_1000)
+		return -EOPNOTSUPP;
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_MOD_CONF,
+			      MV_MOD_CONF_SPEED_MASK,
+			      MV_MOD_CONF_SPEED_1000);
+}
+
 static int mv3310_get_mactype(struct phy_device *phydev)
 {
 	int mactype;
@@ -778,6 +793,13 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	/* If host provided host mac speed, try to set the mac speed */
+	if (phydev->host_speed && chip->set_macspeed) {
+		err = chip->set_macspeed(phydev, phydev->host_speed);
+		if (err)
+			return err;
+	}
+
 	/* If host provided host supported interface modes, try to select the
 	 * best one
 	 */
@@ -1181,6 +1203,7 @@ static const struct mv3310_chip mv2110_type = {
 	.get_mactype = mv2110_get_mactype,
 	.set_mactype = mv2110_set_mactype,
 	.select_mactype = mv2110_select_mactype,
+	.set_macspeed = mv2110_set_macspeed,
 	.init_interface = mv2110_init_interface,
 
 #ifdef CONFIG_HWMON
-- 
2.25.1

