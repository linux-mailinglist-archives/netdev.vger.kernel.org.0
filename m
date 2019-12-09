Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23B11687F
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfLIIog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:44:36 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52007 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfLIIof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 03:44:35 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ieEee-0007WR-G5; Mon, 09 Dec 2019 09:44:32 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ieEed-0002y7-Ri; Mon, 09 Dec 2019 09:44:31 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v1] ARM i.MX6q: make sure PHY fixup for KSZ9031 is applied only on one board
Date:   Mon,  9 Dec 2019 09:44:30 +0100
Message-Id: <20191209084430.11107-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently all board specific fixups defined in mach-imx*.c are not
working properly. They are applied on all boards with the same iMX SoC
variant and even if:
- PHY needs different settings because of different board design
- PHY needs different settings if it is not connected directly to the SoC.
  For example, the PHY is connected to a switch and the switch is connected
  to the SoC.

Since most PHY drivers don't know about changed default settings, these
settings will not be restored by the PHY driver after reset or
suspend/resume cycle.

This patch changes the MICREL KSZ9031 fixup, which was introduced for
the "Data Modul eDM-QMX6" board in following patch, to be only activated
for this specific board.

|commit dbf6719a4a080669acb5087893704586c791aa41
|Author: Sascha Hauer <s.hauer@pengutronix.de>
|Date:   Thu Jun 20 17:34:33 2013 +0200
|
| ARM: i.MX6: add ethernet phy fixup for KSZ9031
|
| The KSZ9031 is used on the i.MX6 based Data Modul eDM-QMX6
| board. It needs the same fixup to the rx/tx delays as other
| i.MX6 boards.

If some board was working by accident with this fixup, it will probably
break and should be fixed properly by setting related device tree
properties.

To fix this properly the "eDM-QMX6" devicetree:

    arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts

should have board specific *-skew-ps properties. See:

    Documentation/devicetree/bindings/net/micrel-ksz90x1.txt

Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6q.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 6441281cf4f2..2370cb5d8501 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -162,11 +162,19 @@ static int ar8035_phy_fixup(struct phy_device *dev)
 
 static void __init imx6q_enet_phy_init(void)
 {
+	/* Warning: please do not extend this fixup list. This fixups are
+	 * applied even on boards where related PHY is not directly connected
+	 * to the ethernet controller. For example with switch in the middle.
+	 */
 	if (IS_BUILTIN(CONFIG_PHYLIB)) {
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 				ksz9021rn_phy_fixup);
-		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
-				ksz9031rn_phy_fixup);
+
+		if (of_machine_is_compatible("dmo,imx6q-edmqmx6"))
+			phy_register_fixup_for_uid(PHY_ID_KSZ9031,
+						   MICREL_PHY_ID_MASK,
+						   ksz9031rn_phy_fixup);
+
 		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
 				ar8031_phy_fixup);
 		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
-- 
2.24.0

