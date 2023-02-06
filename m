Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7968BDA3
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjBFNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBFNRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6E3234C1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N0-0007R8-A9
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1CFBD171510
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 37A3F1712C2;
        Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1ba8a7bb;
        Mon, 6 Feb 2023 13:16:22 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/47] can: ems_pci: Initialize BAR registers
Date:   Mon,  6 Feb 2023 14:15:50 +0100
Message-Id: <20230206131620.2758724-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>

Fix the base register defines and their usage for all three card versions

Signed-off-by: Gerhard Uttenthaler <uttenthaler@ems-wuensche.com>
Link: https://lore.kernel.org/all/20230120112616.6071-4-uttenthaler@ems-wuensche.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/sja1000/ems_pci.c | 37 +++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/sja1000/ems_pci.c b/drivers/net/can/sja1000/ems_pci.c
index 80fa5e4c5eac..5748c24dd137 100644
--- a/drivers/net/can/sja1000/ems_pci.c
+++ b/drivers/net/can/sja1000/ems_pci.c
@@ -87,12 +87,23 @@ struct ems_pci_card {
  */
 #define EMS_PCI_CDR             (CDR_CBP | CDR_CLKOUT_MASK)
 
-#define EMS_PCI_V1_BASE_BAR     1
-#define EMS_PCI_V1_CONF_SIZE    4096 /* size of PITA control area */
-#define EMS_PCI_V2_BASE_BAR     2
-#define EMS_PCI_V2_CONF_SIZE    128 /* size of PLX control area */
-#define EMS_PCI_CAN_BASE_OFFSET 0x400 /* offset where the controllers starts */
-#define EMS_PCI_CAN_CTRL_SIZE   0x200 /* memory size for each controller */
+#define EMS_PCI_V1_BASE_BAR 1
+#define EMS_PCI_V1_CONF_BAR 0
+#define EMS_PCI_V1_CONF_SIZE 4096 /* size of PITA control area */
+#define EMS_PCI_V1_CAN_BASE_OFFSET 0x400 /* offset where the controllers start */
+#define EMS_PCI_V1_CAN_CTRL_SIZE 0x200 /* memory size for each controller */
+
+#define EMS_PCI_V2_BASE_BAR 2
+#define EMS_PCI_V2_CONF_BAR 0
+#define EMS_PCI_V2_CONF_SIZE 128 /* size of PLX control area */
+#define EMS_PCI_V2_CAN_BASE_OFFSET 0x400 /* offset where the controllers start */
+#define EMS_PCI_V2_CAN_CTRL_SIZE 0x200 /* memory size for each controller */
+
+#define EMS_PCI_V3_BASE_BAR 0
+#define EMS_PCI_V3_CONF_BAR 5
+#define EMS_PCI_V3_CONF_SIZE 128 /* size of ASIX control area */
+#define EMS_PCI_V3_CAN_BASE_OFFSET 0x00 /* offset where the controllers starts */
+#define EMS_PCI_V3_CAN_CTRL_SIZE 0x100 /* memory size for each controller */
 
 #define EMS_PCI_BASE_SIZE  4096 /* size of controller area */
 
@@ -225,7 +236,7 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 	struct sja1000_priv *priv;
 	struct net_device *dev;
 	struct ems_pci_card *card;
-	int max_chan, conf_size, base_bar;
+	int max_chan, conf_size, base_bar, conf_bar;
 	int err, i;
 
 	/* Enabling PCI device */
@@ -247,20 +258,28 @@ static int ems_pci_add_card(struct pci_dev *pdev,
 
 	card->channels = 0;
 
-	if (pdev->vendor == PCI_VENDOR_ID_PLX) {
+	if (pdev->vendor == PCI_VENDOR_ID_ASIX) {
+		card->version = 3; /* CPC-PCI v3 */
+		max_chan = EMS_PCI_V3_MAX_CHAN;
+		base_bar = EMS_PCI_V3_BASE_BAR;
+		conf_bar = EMS_PCI_V3_CONF_BAR;
+		conf_size = EMS_PCI_V3_CONF_SIZE;
+	} else if (pdev->vendor == PCI_VENDOR_ID_PLX) {
 		card->version = 2; /* CPC-PCI v2 */
 		max_chan = EMS_PCI_V2_MAX_CHAN;
 		base_bar = EMS_PCI_V2_BASE_BAR;
+		conf_bar = EMS_PCI_V2_CONF_BAR;
 		conf_size = EMS_PCI_V2_CONF_SIZE;
 	} else {
 		card->version = 1; /* CPC-PCI v1 */
 		max_chan = EMS_PCI_V1_MAX_CHAN;
 		base_bar = EMS_PCI_V1_BASE_BAR;
+		conf_bar = EMS_PCI_V1_CONF_BAR;
 		conf_size = EMS_PCI_V1_CONF_SIZE;
 	}
 
 	/* Remap configuration space and controller memory area */
-	card->conf_addr = pci_iomap(pdev, 0, conf_size);
+	card->conf_addr = pci_iomap(pdev, conf_bar, conf_size);
 	if (!card->conf_addr) {
 		err = -ENOMEM;
 		goto failure_cleanup;
-- 
2.39.1


