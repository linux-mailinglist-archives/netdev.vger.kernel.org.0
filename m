Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82C206D36
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389477AbgFXHAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389238AbgFXHAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 03:00:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6157EC061755
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 00:00:51 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jnzOr-0006Wj-8u; Wed, 24 Jun 2020 09:00:49 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jnzOq-0002xb-IF; Wed, 24 Jun 2020 09:00:48 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de, Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/2] net: ethernet: mvneta: Add back interface mode validation
Date:   Wed, 24 Jun 2020 09:00:45 +0200
Message-Id: <20200624070045.8878-2-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200624070045.8878-1-s.hauer@pengutronix.de>
References: <20200624070045.8878-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When writing the serdes configuration register was moved to
mvneta_config_interface() the whole code block was removed from
mvneta_port_power_up() in the assumption that its only purpose was to
write the serdes configuration register. As mentioned by Russell King
its purpose was also to check for valid interface modes early so that
later in the driver we do not have to care for unexpected interface
modes.
Add back the test to let the driver bail out early on unhandled
interface modes.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c4552f868157c..c639e3a293024 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5009,10 +5009,18 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
 }
 
 /* Power up the port */
-static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
+static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 {
 	/* MAC Cause register should be cleared */
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
+
+	if (phy_mode != PHY_INTERFACE_MODE_QSGMII &&
+	    phy_mode != PHY_INTERFACE_MODE_SGMII &&
+	    !phy_interface_mode_is_8023z(phy_mode) &&
+	    !phy_interface_mode_is_rgmii(phy_mode))
+		return -EINVAL;
+
+	return 0;
 }
 
 /* Device initialization routine */
@@ -5198,7 +5206,11 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_netdev;
 
-	mvneta_port_power_up(pp, phy_mode);
+	err = mvneta_port_power_up(pp, pp->phy_interface);
+	if (err < 0) {
+		dev_err(&pdev->dev, "can't power up port\n");
+		return err;
+	}
 
 	/* Armada3700 network controller does not support per-cpu
 	 * operation, so only single NAPI should be initialized.
@@ -5352,7 +5364,11 @@ static int mvneta_resume(struct device *device)
 		}
 	}
 	mvneta_defaults_set(pp);
-	mvneta_port_power_up(pp, pp->phy_interface);
+	err = mvneta_port_power_up(pp, pp->phy_interface);
+	if (err < 0) {
+		dev_err(device, "can't power up port\n");
+		return err;
+	}
 
 	netif_device_attach(dev);
 
-- 
2.27.0

