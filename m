Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D09322B7C0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgGWUaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:30:11 -0400
Received: from mta11.srv.hcvlny.cv.net ([167.206.4.220]:12459 "EHLO
        mta11.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgGWUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:30:11 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jul 2020 16:30:11 EDT
X-Content-Analysis: v=2.3 cv=FbesOK26 c=1 sm=1 tr=0 a=9FIXUFnz80d826bVJLDMVQ==:117 a=9FIXUFnz80d826bVJLDMVQ==:17 a=XYAwZIGsAAAA:8 a=uwFs3qsJmY0nFq-2H_YA:9 a=E8ToXWR_bxluHZ7gmE-Z:22
Received: from [68.195.34.108] ([68.195.34.108:49146] helo=localhost.localdomain)
        by mta3.srv.hcvlny.cv.net (envelope-from <Bryan.Whitehead@microchip.com>)
        (ecelerity 3.6.9.48312 r(Core:3.6.9.0)) with ESMTP
        id 94/D5-19531-1AEE91F5; Thu, 23 Jul 2020 16:10:10 -0400
From:   Bryan Whitehead <Bryan.Whitehead@microchip.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy drivers
Date:   Thu, 23 Jul 2020 16:09:57 -0400
Message-Id: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
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

Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
---
 drivers/net/phy/mscc/mscc_main.c | 90 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index a4fbf3a..f2fa221 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -929,6 +929,90 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
 }
 
 /* bus->mdio_lock should be locked when using this function */
+/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
+static int vsc8574_wait_for_micro_complete(struct phy_device *phydev)
+{
+	u16 timeout = 500;
+	u16 reg18g = 0;
+
+	reg18g = phy_base_read(phydev, 18);
+	while (reg18g & 0x8000) {
+		timeout--;
+		if (timeout == 0)
+			return -1;
+		usleep_range(1000, 2000);
+		reg18g = phy_base_read(phydev, 18);
+	}
+
+	return 0;
+}
+
+/* bus->mdio_lock should be locked when using this function */
+static int vsc8574_reset_lcpll(struct phy_device *phydev)
+{
+	u16 reg_val = 0;
+	int ret = 0;
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_EXTENDED_GPIO);
+
+	/* Read LCPLL config vector into PRAM */
+	phy_base_write(phydev, 18, 0x8023);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	/* Set Address to Poke */
+	phy_base_write(phydev, 18, 0xd7d5);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	/* Poke to reset PLL Start up State Machine,
+	 * set disable_fsm:bit 119
+	 */
+	phy_base_write(phydev, 18, 0x8d06);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	/* Rewrite PLL config vector */
+	phy_base_write(phydev, 18, 0x80c0);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	usleep_range(10000, 20000);
+
+	/* Poke to deassert Reset of PLL State Machine,
+	 * clear disable_fsm:bit 119
+	 */
+	phy_base_write(phydev, 18, 0x8506);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	/* Rewrite PLL config vector */
+	phy_base_write(phydev, 18, 0x80c0);
+	ret = vsc8574_wait_for_micro_complete(phydev);
+	if (ret)
+		goto done;
+
+	usleep_range(10000, 20000);
+
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+		       MSCC_PHY_PAGE_EXTENDED_3);
+	reg_val = phy_base_read(phydev, 20);
+	reg_val = phy_base_read(phydev, 20);
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
@@ -1002,6 +1086,12 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
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

