Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CDE27F323
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgI3USd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbgI3USb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53A7C0613DA
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:29 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYV-0002Qt-Rv; Wed, 30 Sep 2020 22:18:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 11/13] can: flexcan: initialize all flexcan memory for ECC function
Date:   Wed, 30 Sep 2020 22:18:14 +0200
Message-Id: <20200930201816.1032054-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

One issue was reported at a baremetal environment, which is used for
FPGA verification. "The first transfer will fail for extended ID
format(for both 2.0B and FD format), following frames can be transmitted
and received successfully for extended format, and standard format don't
have this issue. This issue occurred randomly with high possiblity, when
it occurs, the transmitter will detect a BIT1 error, the receiver a CRC
error. According to the spec, a non-correctable error may cause this
transfer failure."

With FLEXCAN_QUIRK_DISABLE_MECR quirk, it supports correctable errors,
disable non-correctable errors interrupt and freeze mode. Platform has
ECC hardware support, but select this quirk, this issue may not come to
light. Initialize all FlexCAN memory before accessing them, at least it
can avoid non-correctable errors detected due to memory uninitialized.
The internal region can't be initialized when the hardware doesn't support
ECC.

According to IMX8MPRM, Rev.C, 04/2020. There is a NOTE at the section
11.8.3.13 Detection and correction of memory errors:
"All FlexCAN memory must be initialized before starting its operation in
order to have the parity bits in memory properly updated. CTRL2[WRMFRZ]
grants write access to all memory positions that require initialization,
ranging from 0x080 to 0xADF and from 0xF28 to 0xFFF when the CAN FD feature
is enabled. The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers need to
be initialized as well. MCR[RFEN] must not be set during memory initialization."

Memory range from 0x080 to 0xADF, there are reserved memory (unimplemented
by hardware, e.g. only configure 64 MBs), these memory can be initialized or not.
In this patch, initialize all flexcan memory which includes reserved memory.

In this patch, create FLEXCAN_QUIRK_SUPPORT_ECC for platforms which has ECC
feature. If you have a ECC platform in your hand, please select this
qurik to initialize all flexcan memory firstly, then you can select
FLEXCAN_QUIRK_DISABLE_MECR to only enable correctable errors.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20200929211557.14153-2-qiangqing.zhang@nxp.com
[mkl: wrap long lines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 53 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e86925134009..19a29618f0c0 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -239,6 +239,8 @@
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
 /* Support CAN-FD mode */
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
+/* support memory detection and correction */
+#define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -292,7 +294,16 @@ struct flexcan_regs {
 	u32 rximr[64];		/* 0x880 - Not affected by Soft Reset */
 	u32 _reserved5[24];	/* 0x980 */
 	u32 gfwr_mx6;		/* 0x9e0 - MX6 */
-	u32 _reserved6[63];	/* 0x9e4 */
+	u32 _reserved6[39];	/* 0x9e4 */
+	u32 _rxfir[6];		/* 0xa80 */
+	u32 _reserved8[2];	/* 0xa98 */
+	u32 _rxmgmask;		/* 0xaa0 */
+	u32 _rxfgmask;		/* 0xaa4 */
+	u32 _rx14mask;		/* 0xaa8 */
+	u32 _rx15mask;		/* 0xaac */
+	u32 tx_smb[4];		/* 0xab0 */
+	u32 rx_smb0[4];		/* 0xac0 */
+	u32 rx_smb1[4];		/* 0xad0 */
 	u32 mecr;		/* 0xae0 */
 	u32 erriar;		/* 0xae4 */
 	u32 erridpr;		/* 0xae8 */
@@ -305,9 +316,13 @@ struct flexcan_regs {
 	u32 fdctrl;		/* 0xc00 - Not affected by Soft Reset */
 	u32 fdcbt;		/* 0xc04 - Not affected by Soft Reset */
 	u32 fdcrc;		/* 0xc08 */
+	u32 _reserved9[199];	/* 0xc0c */
+	u32 tx_smb_fd[18];	/* 0xf28 */
+	u32 rx_smb0_fd[18];	/* 0xf70 */
+	u32 rx_smb1_fd[18];	/* 0xfb8 */
 };
 
-static_assert(sizeof(struct flexcan_regs) == 0x4 + 0xc08);
+static_assert(sizeof(struct flexcan_regs) ==  0x4 * 18 + 0xfb8);
 
 struct flexcan_devtype_data {
 	u32 quirks;		/* quirks needed for different IP cores */
@@ -1292,6 +1307,37 @@ static void flexcan_set_bittiming(struct net_device *dev)
 		return flexcan_set_bittiming_ctrl(dev);
 }
 
+static void flexcan_ram_init(struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg_ctrl2;
+
+	/* 11.8.3.13 Detection and correction of memory errors:
+	 * CTRL2[WRMFRZ] grants write access to all memory positions
+	 * that require initialization, ranging from 0x080 to 0xADF
+	 * and from 0xF28 to 0xFFF when the CAN FD feature is enabled.
+	 * The RXMGMASK, RX14MASK, RX15MASK, and RXFGMASK registers
+	 * need to be initialized as well. MCR[RFEN] must not be set
+	 * during memory initialization.
+	 */
+	reg_ctrl2 = priv->read(&regs->ctrl2);
+	reg_ctrl2 |= FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+
+	memset_io(&regs->mb[0][0], 0,
+		  offsetof(struct flexcan_regs, rx_smb1[3]) -
+		  offsetof(struct flexcan_regs, mb[0][0]) + 0x4);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		memset_io(&regs->tx_smb_fd[0], 0,
+			  offsetof(struct flexcan_regs, rx_smb1_fd[17]) -
+			  offsetof(struct flexcan_regs, tx_smb_fd[0]) + 0x4);
+
+	reg_ctrl2 &= ~FLEXCAN_CTRL2_WRMFRZ;
+	priv->write(reg_ctrl2, &regs->ctrl2);
+}
+
 /* flexcan_chip_start
  *
  * this functions is entered with clocks enabled
@@ -1316,6 +1362,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_ECC)
+		flexcan_ram_init(dev);
+
 	flexcan_set_bittiming(dev);
 
 	/* MCR
-- 
2.28.0

