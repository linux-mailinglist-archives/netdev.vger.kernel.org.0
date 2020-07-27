Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4522F672
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgG0RSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:18:54 -0400
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:61070 "EHLO
        mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgG0RSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:18:54 -0400
X-Content-Analysis: v=2.3 cv=eKiIcEh1 c=1 sm=1 tr=0 a=9FIXUFnz80d826bVJLDMVQ==:117 a=9FIXUFnz80d826bVJLDMVQ==:17 a=XYAwZIGsAAAA:8 a=uwFs3qsJmY0nFq-2H_YA:9 a=E8ToXWR_bxluHZ7gmE-Z:22
Received: from [68.195.34.108] ([68.195.34.108:50538] helo=localhost.localdomain)
        by mta1.srv.hcvlny.cv.net (envelope-from <Bryan.Whitehead@microchip.com>)
        (ecelerity 3.6.9.48312 r(Core:3.6.9.0)) with ESMTP
        id 57/62-13745-B7C0F1F5; Mon, 27 Jul 2020 13:18:52 -0400
From:   Bryan Whitehead <Bryan.Whitehead@microchip.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: [PATCH v2 net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy drivers
Date:   Mon, 27 Jul 2020 13:18:28 -0400
Message-Id: <1595870308-19041-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LCPLL Reset sequence is added to the initialization path
of the VSC8574 Family of phy drivers.

The LCPLL Reset sequence is known to reduce hardware inter-op
issues when using the QSGMII MAC interface.

This patch is submitted to net-next to avoid merging conflicts that
may arise if submitted to net.

V2 Updates:
Make use of read_poll_timeout for micro command completion.
Combine command starter and timeout into helper function
	vsc8574_micro_command
Removed unused variable reg_val from vsc8574_reset_lcpll

Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
---
 drivers/net/phy/mscc/mscc_main.c | 77 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index a4fbf3a..db34faac 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -929,6 +929,77 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
 }
 
 /* bus->mdio_lock should be locked when using this function */
+/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
+static int vsc8574_micro_command(struct phy_device *phydev, u16 command)
+{
+	u16 reg18g = 0;
+
+	phy_base_write(phydev, 18, command);
+
+	return read_poll_timeout(phy_base_read, reg18g,
+		!(reg18g & 0x8000),
+		4000, 500000, 0, phydev, 18);
+}
+
+/* bus->mdio_lock should be locked when using this function */
+static int vsc8574_reset_lcpll(struct phy_device *phydev)
+{
+	int ret = 0;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_EXTENDED_GPIO);
+
+	/* Read LCPLL config vector into PRAM */
+	ret = vsc8574_micro_command(phydev, 0x8023);
+	if (ret)
+		goto done;
+
+	/* Set Address to Poke */
+	ret = vsc8574_micro_command(phydev, 0xd7d5);
+	if (ret)
+		goto done;
+
+	/* Poke to reset PLL Start up State Machine,
+	 * set disable_fsm:bit 119
+	 */
+	ret = vsc8574_micro_command(phydev, 0x8d06);
+	if (ret)
+		goto done;
+
+	/* Rewrite PLL config vector */
+	ret = vsc8574_micro_command(phydev, 0x80c0);
+	if (ret)
+		goto done;
+
+	usleep_range(10000, 20000);
+
+	/* Poke to deassert Reset of PLL State Machine,
+	 * clear disable_fsm:bit 119
+	 */
+	ret = vsc8574_micro_command(phydev, 0x8506);
+	if (ret)
+		goto done;
+
+	/* Rewrite PLL config vector */
+	ret = vsc8574_micro_command(phydev, 0x80c0);
+	if (ret)
+		goto done;
+
+	usleep_range(10000, 20000);
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_EXTENDED_3);
+	phy_base_read(phydev, 20);
+	phy_base_read(phydev, 20);
+
+	usleep_range(110000, 200000);
+
+done:
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+	return ret;
+}
+
+/* bus->mdio_lock should be locked when using this function */
 static int vsc8574_config_pre_init(struct phy_device *phydev)
 {
 	static const struct reg_val pre_init1[] = {
@@ -1002,6 +1073,12 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
 	bool serdes_init;
 	int ret;
 
+	ret = vsc8574_reset_lcpll(phydev);
+	if (ret) {
+		dev_err(dev, "failed lcpll reset\n");
+		return ret;
+	}
+
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
 	/* all writes below are broadcasted to all PHYs in the same package */
-- 
2.7.4

