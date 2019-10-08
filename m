Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6754CFBF0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 16:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfJHOGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 10:06:15 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:38648 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbfJHOGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 10:06:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 6FB7823F5D5;
        Tue,  8 Oct 2019 16:06:11 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.093
X-Spam-Level: 
X-Spam-Status: No, score=-3.093 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.193, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Go2Nt7ldw4fB; Tue,  8 Oct 2019 16:06:10 +0200 (CEST)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPA id 292E123F5D7;
        Tue,  8 Oct 2019 16:06:10 +0200 (CEST)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Lars Poeschel <poeschel@lemonage.de>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Winslow <swinslow@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        netdev@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PATCH v9 3/7] nfc: pn533: Add dev_up/dev_down hooks to phy_ops
Date:   Tue,  8 Oct 2019 16:05:40 +0200
Message-Id: <20191008140544.17112-4-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008140544.17112-1-poeschel@lemonage.de>
References: <20191008140544.17112-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds hooks for dev_up and dev_down to the phy_ops. They are
optional.
The idea is to inform the phy driver when the nfc chip is really going
to be used. When it is not used, the phy driver can suspend it's
interface to the nfc chip to save some power. The nfc chip is considered
not in use before dev_up and after dev_down.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v9:
- Rebased the patch series on v5.4-rc2

Changes in v6:
- Rebased the patch series on v5.3-rc5

Changes in v5:
- (dev->phy_ops->dev_up) instead (dev->phy_ops)

Changes in v4:
- This patch is new in v4

 drivers/nfc/pn533/pn533.c | 12 +++++++++++-
 drivers/nfc/pn533/pn533.h |  9 +++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index a172a32aa9d9..64836c727aee 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2458,6 +2458,9 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 {
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 
+	if (dev->phy_ops->dev_up)
+		dev->phy_ops->dev_up(dev);
+
 	if (dev->device_type == PN533_DEVICE_PN532) {
 		int rc = pn532_sam_configuration(nfc_dev);
 
@@ -2470,7 +2473,14 @@ static int pn533_dev_up(struct nfc_dev *nfc_dev)
 
 static int pn533_dev_down(struct nfc_dev *nfc_dev)
 {
-	return pn533_rf_field(nfc_dev, 0);
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+	int ret;
+
+	ret = pn533_rf_field(nfc_dev, 0);
+	if (dev->phy_ops->dev_down && !ret)
+		dev->phy_ops->dev_down(dev);
+
+	return ret;
 }
 
 static struct nfc_ops pn533_nfc_ops = {
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index 8bf9d6ece0f5..570ee0a3e832 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -207,6 +207,15 @@ struct pn533_phy_ops {
 			  struct sk_buff *out);
 	int (*send_ack)(struct pn533 *dev, gfp_t flags);
 	void (*abort_cmd)(struct pn533 *priv, gfp_t flags);
+	/*
+	 * dev_up and dev_down are optional.
+	 * They are used to inform the phy layer that the nfc chip
+	 * is going to be really used very soon. The phy layer can then
+	 * bring up it's interface to the chip and have it suspended for power
+	 * saving reasons otherwise.
+	 */
+	void (*dev_up)(struct pn533 *priv);
+	void (*dev_down)(struct pn533 *priv);
 };
 
 
-- 
2.23.0

