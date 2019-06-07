Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92FE39262
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbfFGQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:42:50 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:8458 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbfFGQmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:42:49 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x57GggfM018934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 10:42:43 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x57GgeOl030818
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Jun 2019 10:42:42 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 1/2 v2] net: sfp: Stop SFP polling and interrupt handling during shutdown
Date:   Fri,  7 Jun 2019 10:42:35 -0600
Message-Id: <1559925756-29593-2-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
References: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP device polling can cause problems during the shutdown process if the
parent devices of the network controller have been shut down already.
This problem was seen on the iMX6 platform with PCIe devices, where
accessing the device after the bus is shut down causes a hang.

Free any acquired GPIO interrupts and stop all delayed work in the SFP
driver during the shutdown process, so that we ensure that no pending
operations are still occurring after the SFP shutdown completes.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---

Changed since v1: Free interrupts during shutdown to avoid need for shutdown
state flag.

 drivers/net/phy/sfp.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 554acc8..01af080 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -185,6 +185,7 @@ struct sfp {
 	int (*write)(struct sfp *, bool, u8, void *, size_t);
 
 	struct gpio_desc *gpio[GPIO_MAX];
+	int gpio_irq[GPIO_MAX];
 
 	bool attached;
 	unsigned int state;
@@ -1786,7 +1787,7 @@ static int sfp_probe(struct platform_device *pdev)
 	struct i2c_adapter *i2c;
 	struct sfp *sfp;
 	bool poll = false;
-	int irq, err, i;
+	int err, i;
 
 	sfp = sfp_alloc(&pdev->dev);
 	if (IS_ERR(sfp))
@@ -1885,19 +1886,22 @@ static int sfp_probe(struct platform_device *pdev)
 		if (gpio_flags[i] != GPIOD_IN || !sfp->gpio[i])
 			continue;
 
-		irq = gpiod_to_irq(sfp->gpio[i]);
-		if (!irq) {
+		sfp->gpio_irq[i] = gpiod_to_irq(sfp->gpio[i]);
+		if (!sfp->gpio_irq[i]) {
 			poll = true;
 			continue;
 		}
 
-		err = devm_request_threaded_irq(sfp->dev, irq, NULL, sfp_irq,
+		err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
+						NULL, sfp_irq,
 						IRQF_ONESHOT |
 						IRQF_TRIGGER_RISING |
 						IRQF_TRIGGER_FALLING,
 						dev_name(sfp->dev), sfp);
-		if (err)
+		if (err) {
+			sfp->gpio_irq[i] = 0;
 			poll = true;
+		}
 	}
 
 	if (poll)
@@ -1928,9 +1932,26 @@ static int sfp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void sfp_shutdown(struct platform_device *pdev)
+{
+	struct sfp *sfp = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < GPIO_MAX; i++) {
+		if (!sfp->gpio_irq[i])
+			continue;
+
+		devm_free_irq(sfp->dev, sfp->gpio_irq[i], sfp);
+	}
+
+	cancel_delayed_work_sync(&sfp->poll);
+	cancel_delayed_work_sync(&sfp->timeout);
+}
+
 static struct platform_driver sfp_driver = {
 	.probe = sfp_probe,
 	.remove = sfp_remove,
+	.shutdown = sfp_shutdown,
 	.driver = {
 		.name = "sfp",
 		.of_match_table = sfp_of_match,
-- 
1.8.3.1

