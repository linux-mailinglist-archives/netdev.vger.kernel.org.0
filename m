Return-Path: <netdev+bounces-11744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9FC5734213
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 17:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE48281646
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 15:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC5ABA3B;
	Sat, 17 Jun 2023 15:55:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F0A93D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 15:55:55 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC210C4;
	Sat, 17 Jun 2023 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=MpwCl6GoQR40Ij59jbamJI3m1CTjHUNv+tvo6pqGO24=; b=UVmxHxeCB251A2r07VOiFfEkZD
	YRY9bBAXscONmUhN67omN+iFJzmUPwV5vgqcKKp+ANmGhKwg1vYp1cIlIIYzpy0MnpVL42NJTM+lY
	+zFG8mTpJTuDjZo0SEwaDa1IqFbXAJqmEuccfy2TV+tEbmKYTh8AkX6eLunyyP5DTES4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAYHI-00Go7B-7K; Sat, 17 Jun 2023 17:55:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	ansuelsmth@gmail.com,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	stable@vger.kernel.org,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net] net: phy: Manual remove LEDs to ensure correct ordering
Date: Sat, 17 Jun 2023 17:55:00 +0200
Message-Id: <20230617155500.4005881-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If the core is left to remove the LEDs via devm_, it is performed too
late, after the PHY driver is removed from the PHY. This results in
dereferencing a NULL pointer when the LED core tries to turn the LED
off before destroying the LED.

Manually unregister the LEDs at a safe point in phy_remove.

Cc: stable@vger.kernel.org
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 01e5b728e9e4 ("net: phy: Add a binding for PHY LEDs")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..53598210be6c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3021,6 +3021,15 @@ static int phy_led_blink_set(struct led_classdev *led_cdev,
 	return err;
 }
 
+static void phy_leds_unregister(struct phy_device *phydev)
+{
+	struct phy_led *phyled;
+
+	list_for_each_entry(phyled, &phydev->leds, list) {
+		led_classdev_unregister(&phyled->led_cdev);
+	}
+}
+
 static int of_phy_led(struct phy_device *phydev,
 		      struct device_node *led)
 {
@@ -3054,7 +3063,7 @@ static int of_phy_led(struct phy_device *phydev,
 	init_data.fwnode = of_fwnode_handle(led);
 	init_data.devname_mandatory = true;
 
-	err = devm_led_classdev_register_ext(dev, cdev, &init_data);
+	err = led_classdev_register_ext(dev, cdev, &init_data);
 	if (err)
 		return err;
 
@@ -3083,6 +3092,7 @@ static int of_phy_leds(struct phy_device *phydev)
 		err = of_phy_led(phydev, led);
 		if (err) {
 			of_node_put(led);
+			phy_leds_unregister(phydev);
 			return err;
 		}
 	}
@@ -3305,6 +3315,9 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
+	if (IS_ENABLED(CONFIG_PHYLIB_LEDS))
+		phy_leds_unregister(phydev);
+
 	phydev->state = PHY_DOWN;
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
-- 
2.40.1


