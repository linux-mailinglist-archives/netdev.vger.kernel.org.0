Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87465F0D6F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiI3OWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiI3OVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6E51A408B
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90A1F62362
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882E0C433C1;
        Fri, 30 Sep 2022 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547688;
        bh=rbWwCPmNJdNswhMrz9VTEo7cqkwc8jjsZedU18YhKxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGqyolhh+6LCtcPCSeMwsdP1NNduCMJEC9sHx/tSSfe9tEtzDUvJE804KTS9KizyK
         eaSjThhiMz9Ry4dj4H3qThumo3KmrPz7n3iHGhwJq/JSE+4uuuc4c5lfk3Jplc3Iv8
         1S5DSRYLHXkDU8+UwCqnIgWzqht9mB7riG9WulNUx3ZVts6ls6dhxPUgc+mVOgIaFB
         8NO9wKljyBJ914x0hPTJOIVizgOrwW45C+bok1V6b0XJ+Xg09t0Cxg+9NdGU3282s5
         3oC/PknJeX4Jyvo2PjNBtwZHtdMaulcBRP6wYzZTR/TFm3XYwR++DT2AoJTp4A3v8u
         hELEqUF4TofPg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 07/12] net: phy: marvell10g: select host interface configuration
Date:   Fri, 30 Sep 2022 16:21:05 +0200
Message-Id: <20220930142110.15372-8-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Select the host interface configuration according to the capabilities of
the host if the host provided them. This is currently provided only when
connecting PHY that is inside a SFP.

The PHY supports several configurations of host communication:
- always communicate with host in 10gbase-r, even if copper speed is
  lower (rate matching mode),
- the same as above but use xaui/rxaui instead of 10gbase-r,
- switch host SerDes mode between 10gbase-r, 5gbase-r, 2500base-x and
  sgmii according to copper speed,
- the same as above but use xaui/rxaui instead of 10gbase-r.

This mode of host communication, called MACTYPE, is by default selected
by strapping pins, but it can be changed in software.

This adds support for selecting this mode according to which modes are
supported by the host.

This allows the kernel to:
- support SFP modules with 88X33X0 or 88E21X0 inside them

Note: we use mv3310_select_mactype() for both 88X3310 and 88X3340,
although 88X3340 does not support XAUI. This is not a problem because
88X3340 does not declare XAUI in it's supported_interfaces, and so this
function will never choose that MACTYPE.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
[ rebase, updated, also added support for 88E21X0 ]
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 112 +++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 06d0fe4b76c3..383a9c9f36e5 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -96,6 +96,11 @@ enum {
 	MV_PCS_PORT_INFO_NPORTS_MASK	= 0x0380,
 	MV_PCS_PORT_INFO_NPORTS_SHIFT	= 7,
 
+	/* SerDes reinitialization 88E21X0 */
+	MV_AN_21X0_SERDES_CTRL2	= 0x800f,
+	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
+	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
+
 	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
 	 * registers appear to set themselves to the 0x800X when AN is
 	 * restarted, but status registers appear readable from either.
@@ -140,6 +145,8 @@ struct mv3310_chip {
 	bool (*has_downshift)(struct phy_device *phydev);
 	void (*init_supported_interfaces)(unsigned long *mask);
 	int (*get_mactype)(struct phy_device *phydev);
+	int (*set_mactype)(struct phy_device *phydev, int mactype);
+	int (*select_mactype)(unsigned long *interfaces);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
 
 #ifdef CONFIG_HWMON
@@ -594,6 +601,49 @@ static int mv2110_get_mactype(struct phy_device *phydev)
 	return mactype & MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
 }
 
+static int mv2110_set_mactype(struct phy_device *phydev, int mactype)
+{
+	int err, val;
+
+	mactype &= MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
+	err = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL,
+			     MV_PMA_21X0_PORT_CTRL_SWRST |
+			     MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK,
+			     MV_PMA_21X0_PORT_CTRL_SWRST | mactype);
+	if (err)
+		return err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
+			       MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS |
+			       MV_AN_21X0_SERDES_CTRL2_RUN_INIT);
+	if (err)
+		return err;
+
+	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_AN,
+					MV_AN_21X0_SERDES_CTRL2, val,
+					!(val &
+					  MV_AN_21X0_SERDES_CTRL2_RUN_INIT),
+					5000, 100000, true);
+	if (err)
+		return err;
+
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
+				  MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS);
+}
+
+static int mv2110_select_mactype(unsigned long *interfaces)
+{
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 !test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
+	else
+		return -1;
+}
+
 static int mv3310_get_mactype(struct phy_device *phydev)
 {
 	int mactype;
@@ -605,6 +655,46 @@ static int mv3310_get_mactype(struct phy_device *phydev)
 	return mactype & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
 }
 
+static int mv3310_set_mactype(struct phy_device *phydev, int mactype)
+{
+	int ret;
+
+	mactype &= MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				     MV_V2_33X0_PORT_CTRL_MACTYPE_MASK,
+				     mactype);
+	if (ret <= 0)
+		return ret;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				MV_V2_33X0_PORT_CTRL_SWRST);
+}
+
+static int mv3310_select_mactype(unsigned long *interfaces)
+{
+	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
+		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
+		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
+		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
+	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
+		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
+	else
+		return -1;
+}
+
 static int mv2110_init_interface(struct phy_device *phydev, int mactype)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
@@ -688,6 +778,20 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	/* If host provided host supported interface modes, try to select the
+	 * best one
+	 */
+	if (!phy_interface_empty(phydev->host_interfaces)) {
+		mactype = chip->select_mactype(phydev->host_interfaces);
+		if (mactype >= 0) {
+			phydev_info(phydev, "Changing MACTYPE to %i\n",
+				    mactype);
+			err = chip->set_mactype(phydev, mactype);
+			if (err)
+				return err;
+		}
+	}
+
 	mactype = chip->get_mactype(phydev);
 	if (mactype < 0)
 		return mactype;
@@ -1050,6 +1154,8 @@ static const struct mv3310_chip mv3310_type = {
 	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
+	.set_mactype = mv3310_set_mactype,
+	.select_mactype = mv3310_select_mactype,
 	.init_interface = mv3310_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1061,6 +1167,8 @@ static const struct mv3310_chip mv3340_type = {
 	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3340_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
+	.set_mactype = mv3310_set_mactype,
+	.select_mactype = mv3310_select_mactype,
 	.init_interface = mv3340_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1071,6 +1179,8 @@ static const struct mv3310_chip mv3340_type = {
 static const struct mv3310_chip mv2110_type = {
 	.init_supported_interfaces = mv2110_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
+	.set_mactype = mv2110_set_mactype,
+	.select_mactype = mv2110_select_mactype,
 	.init_interface = mv2110_init_interface,
 
 #ifdef CONFIG_HWMON
@@ -1081,6 +1191,8 @@ static const struct mv3310_chip mv2110_type = {
 static const struct mv3310_chip mv2111_type = {
 	.init_supported_interfaces = mv2111_init_supported_interfaces,
 	.get_mactype = mv2110_get_mactype,
+	.set_mactype = mv2110_set_mactype,
+	.select_mactype = mv2110_select_mactype,
 	.init_interface = mv2110_init_interface,
 
 #ifdef CONFIG_HWMON
-- 
2.35.1

