Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CED6D57F0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDDFWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjDDFWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238D11BF3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B20CE62E30
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8286DC4339B;
        Tue,  4 Apr 2023 05:22:27 +0000 (UTC)
From:   Greg Ungerer <gerg@linux-m68k.org>
To:     wei.fang@nxp.com
Cc:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, andrew@lunn.ch,
        Greg Ungerer <gerg@linux-m68k.org>
Subject: [PATCH] net: fec: make use of MDIO C45 quirk
Date:   Tue,  4 Apr 2023 15:22:07 +1000
Message-Id: <20230404052207.3064861-1-gerg@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all fec MDIO bus drivers support C45 mode transactions. The older fec
hardware block in many ColdFire SoCs does not appear to support them, at
least according to most of the different ColdFire SoC reference manuals.
The bits used to generate C45 access on the iMX parts, in the OP field
of the MMFR register, are documented as generating non-compliant MII
frames (it is not documented as to exactly how they are non-compliant).

Commit 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
means the fec driver will always register c45 MDIO read and write
methods. During probe these will always be accessed now generating
non-compliant MII accesses on ColdFire based devices.

Add a quirk define, FEC_QUIRK_HAS_MDIO_C45, that can be used to
distinguish silicon that supports MDIO C45 framing or not. Add this to
all the existing iMX quirks, so they will be behave as they do now (*).

(*) it seems that some iMX parts may not support C45 transactions either.
    The iMX25 and iMX50 Reference Manuals contain similar wording to
    the ColdFire Reference Manuals on this.

Fixes: 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
---
 drivers/net/ethernet/freescale/fec.h      |  5 ++++
 drivers/net/ethernet/freescale/fec_main.c | 32 ++++++++++++++---------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 5ba1e0d71c68..9939ccafb556 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -507,6 +507,11 @@ struct bufdesc_ex {
 /* i.MX6Q adds pm_qos support */
 #define FEC_QUIRK_HAS_PMQOS			BIT(23)
 
+/* Not all FEC hardware block MDIOs support accesses in C45 mode.
+ * Older blocks in the ColdFire parts do not support it.
+ */
+#define FEC_QUIRK_HAS_MDIO_C45		BIT(24)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f3b16a6673e2..160c1b3525f5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -100,18 +100,19 @@ struct fec_devinfo {
 
 static const struct fec_devinfo fec_imx25_info = {
 	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
-		  FEC_QUIRK_HAS_FRREG,
+		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx27_info = {
-	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
+	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx28_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
 		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
 		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII |
-		  FEC_QUIRK_NO_HARD_RESET,
+		  FEC_QUIRK_NO_HARD_RESET | FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx6q_info = {
@@ -119,11 +120,12 @@ static const struct fec_devinfo fec_imx6q_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII |
-		  FEC_QUIRK_HAS_PMQOS,
+		  FEC_QUIRK_HAS_PMQOS | FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
-	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx6x_info = {
@@ -132,7 +134,8 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
-		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -140,7 +143,8 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
 		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx8mq_info = {
@@ -150,7 +154,8 @@ static const struct fec_devinfo fec_imx8mq_info = {
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
 		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
-		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2,
+		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2 |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_imx8qm_info = {
@@ -160,14 +165,15 @@ static const struct fec_devinfo fec_imx8qm_info = {
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
 		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
-		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
+		  FEC_QUIRK_DELAYED_CLKS_SUPPORT | FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static const struct fec_devinfo fec_s32v234_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
-		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE,
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
 static struct platform_device_id fec_devtype[] = {
@@ -2434,8 +2440,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->name = "fec_enet_mii_bus";
 	fep->mii_bus->read = fec_enet_mdio_read_c22;
 	fep->mii_bus->write = fec_enet_mdio_write_c22;
-	fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
-	fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
+	if (fep->quirks & FEC_QUIRK_HAS_MDIO_C45) {
+		fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
+		fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
+	}
 	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;
-- 
2.25.1

