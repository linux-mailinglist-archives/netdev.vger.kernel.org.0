Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F9DFB1C8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfKMNvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:51:53 -0500
Received: from smtp2.goneo.de ([85.220.129.33]:46438 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfKMNvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 08:51:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 3941123FC29;
        Wed, 13 Nov 2019 14:51:49 +0100 (CET)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.07
X-Spam-Level: 
X-Spam-Status: No, score=-3.07 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.170, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VWH12606cqcp; Wed, 13 Nov 2019 14:51:48 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 2BF0B23F40C;
        Wed, 13 Nov 2019 14:51:47 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Lars Poeschel <poeschel@lemonage.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Winslow <swinslow@gmail.com>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     coverity-bot <keescook+coverity-bot@chromium.org>
Subject: [PATCH net-next] nfc: pn533: pn533_phy_ops dev_[up,down] return int
Date:   Wed, 13 Nov 2019 14:50:22 +0100
Message-Id: <20191113135039.32086-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change dev_up and dev_down functions of struct pn533_phy_ops to return
int. This way the pn533 core can report errors in the phy layer to upper
layers.
The only user of this is currently uart.c and it is changed to report
the error of a possibly failing call to serdev_device_open.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1487395 ("Error handling issues")
Fixes: c656aa4c27b1 ("nfc: pn533: add UART phy driver")
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/pn533/pn533.c | 12 ++++++++----
 drivers/nfc/pn533/pn533.h |  4 ++--
 drivers/nfc/pn533/uart.c  | 13 ++++++++++---
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index aa766e7ece70..346e084387f7 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2643,13 +2643,17 @@ static int pn532_sam_configuration(struct nfc_dev *nfc_dev)
 static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	int rc;
 
-	if (dev->phy_ops->dev_up)
-		dev->phy_ops->dev_up(dev);
+	if (dev->phy_ops->dev_up) {
+		rc = dev->phy_ops->dev_up(dev);
+		if (rc)
+			return rc;
+	}
 
 	if ((dev->device_type == PN533_DEVICE_PN532) ||
 		(dev->device_type == PN533_DEVICE_PN532_AUTOPOLL)) {
-		int rc = pn532_sam_configuration(nfc_dev);
+		rc = pn532_sam_configuration(nfc_dev);
 
 		if (rc)
 			return rc;
@@ -2665,7 +2669,7 @@ static int pn533_dev_down(struct nfc_dev *nfc_dev)
 
 	ret = pn533_rf_field(nfc_dev, 0);
 	if (dev->phy_ops->dev_down && !ret)
-		dev->phy_ops->dev_down(dev);
+		ret = dev->phy_ops->dev_down(dev);
 
 	return ret;
 }
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index b66f02a53167..5f94f38a2a08 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -224,8 +224,8 @@ struct pn533_phy_ops {
 	 * bring up it's interface to the chip and have it suspended for power
 	 * saving reasons otherwise.
 	 */
-	void (*dev_up)(struct pn533 *priv);
-	void (*dev_down)(struct pn533 *priv);
+	int (*dev_up)(struct pn533 *priv);
+	int (*dev_down)(struct pn533 *priv);
 };
 
 
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 46e5ff16f699..a0665d8ea85b 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -100,20 +100,27 @@ static void pn532_uart_abort_cmd(struct pn533 *dev, gfp_t flags)
 	pn533_recv_frame(dev, NULL, -ENOENT);
 }
 
-static void pn532_dev_up(struct pn533 *dev)
+static int pn532_dev_up(struct pn533 *dev)
 {
 	struct pn532_uart_phy *pn532 = dev->phy;
+	int ret = 0;
+
+	ret = serdev_device_open(pn532->serdev);
+	if (ret)
+		return ret;
 
-	serdev_device_open(pn532->serdev);
 	pn532->send_wakeup = PN532_SEND_LAST_WAKEUP;
+	return ret;
 }
 
-static void pn532_dev_down(struct pn533 *dev)
+static int pn532_dev_down(struct pn533 *dev)
 {
 	struct pn532_uart_phy *pn532 = dev->phy;
 
 	serdev_device_close(pn532->serdev);
 	pn532->send_wakeup = PN532_SEND_WAKEUP;
+
+	return 0;
 }
 
 static struct pn533_phy_ops uart_phy_ops = {
-- 
2.24.0

