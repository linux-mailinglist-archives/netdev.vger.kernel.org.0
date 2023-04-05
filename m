Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0B6D7853
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbjDEJbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbjDEJa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:30:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87B7527A
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:29:50 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ7-0004pA-RV; Wed, 05 Apr 2023 11:27:11 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:27:00 +0200
Subject: [PATCH 09/12] net: phy: nxp-tja11xx: make use of
 phy_device_atomic_register()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-9-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new atomic API to setup and register the phy accordingly.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 2a4c0f6d74eb..af9cb5e1a7ee 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -561,6 +561,8 @@ static void tja1102_p1_register(struct work_struct *work)
 			/* Real PHY ID of Port 1 is 0 */
 			.phy_id = PHY_ID_TJA1102,
 			.phy_id_broken = true,
+			.parent_mdiodev = dev,
+			.fwnode = of_fwnode_handle(child),
 		};
 		struct phy_device *phy;
 
@@ -583,30 +585,11 @@ static void tja1102_p1_register(struct work_struct *work)
 			continue;
 		}
 
-		phy = phy_device_create(&config);
-		if (IS_ERR(phy)) {
-			dev_err(dev, "Can't create PHY device for Port 1: %i\n",
-				config.phy_addr);
-			continue;
-		}
-
-		/* Overwrite parent device. phy_device_create() set parent to
-		 * the mii_bus->dev, which is not correct in case.
-		 */
-		phy->mdio.dev.parent = dev;
-
-		ret = of_mdiobus_phy_device_register(bus, phy, child,
-						     config.phy_addr);
-		if (ret) {
-			/* All resources needed for Port 1 should be already
-			 * available for Port 0. Both ports use the same
-			 * interrupt line, so -EPROBE_DEFER would make no sense
-			 * here.
-			 */
-			dev_err(dev, "Can't register Port 1. Unexpected error: %i\n",
-				ret);
-			phy_device_free(phy);
-		}
+		phy = phy_device_atomic_register(&config);
+		if (IS_ERR(phy))
+			dev_err_probe(dev, PTR_ERR(phy),
+				      "Can't create PHY device for Port 1: %i\n",
+				      config.phy_addr);
 	}
 }
 

-- 
2.39.2

