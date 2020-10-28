Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277B29D6F3
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbgJ1WTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731720AbgJ1WRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:42 -0400
Received: from goober.digi.com (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC0AD20757;
        Wed, 28 Oct 2020 05:22:39 +0000 (UTC)
From:   Greg Ungerer <gerg@linux-m68k.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, fugang.duan@nxp.com, cphealy@gmail.com,
        dkarr@vyex.com, clemens.gruber@pqgruber.com,
        Greg Ungerer <gerg@linux-m68k.org>
Subject: [PATCH v2] net: fec: fix MDIO probing for some FEC hardware blocks
Date:   Wed, 28 Oct 2020 15:22:32 +1000
Message-Id: <20201028052232.1315167-1-gerg@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some (apparently older) versions of the FEC hardware block do not like
the MMFR register being cleared to avoid generation of MII events at
initialization time. The action of clearing this register results in no
future MII events being generated at all on the problem block. This means
the probing of the MDIO bus will find no PHYs.

Create a quirk that can be checked at the FECs MII init time so that
the right thing is done. The quirk is set as appropriate for the FEC
hardware blocks that are known to need this.

Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
---
 drivers/net/ethernet/freescale/fec.h      |  6 +++++
 drivers/net/ethernet/freescale/fec_main.c | 29 +++++++++++++----------
 2 files changed, 22 insertions(+), 13 deletions(-)

v2: use quirk for imx28 as well

Resending for consideration based on Andy's last comment that this fix
is enough on its own for all hardware types.

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 832a2175636d..c527f4ee1d3a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -456,6 +456,12 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_FRREG		(1 << 16)
 
+/* Some FEC hardware blocks need the MMFR cleared at setup time to avoid
+ * the generation of an MII event. This must be avoided in the older
+ * FEC blocks where it will stop MII events being generated.
+ */
+#define FEC_QUIRK_CLEAR_SETUP_MII	(1 << 17)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fb37816a74db..65784d3e54a5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -100,14 +100,14 @@ static const struct fec_devinfo fec_imx27_info = {
 static const struct fec_devinfo fec_imx28_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
 		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_FRREG,
+		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_imx6q_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-		  FEC_QUIRK_HAS_RACC,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -119,7 +119,8 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -127,7 +128,7 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
 		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static struct platform_device_id fec_devtype[] = {
@@ -2114,15 +2115,17 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	if (suppress_preamble)
 		fep->phy_speed |= BIT(7);
 
-	/* Clear MMFR to avoid to generate MII event by writing MSCR.
-	 * MII event generation condition:
-	 * - writing MSCR:
-	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
-	 *	  mscr_reg_data_in[7:0] != 0
-	 * - writing MMFR:
-	 *	- mscr[7:0]_not_zero
-	 */
-	writel(0, fep->hwp + FEC_MII_DATA);
+	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
+		/* Clear MMFR to avoid to generate MII event by writing MSCR.
+		 * MII event generation condition:
+		 * - writing MSCR:
+		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
+		 *	  mscr_reg_data_in[7:0] != 0
+		 * - writing MMFR:
+		 *	- mscr[7:0]_not_zero
+		 */
+		writel(0, fep->hwp + FEC_MII_DATA);
+	}
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
-- 
2.25.1

