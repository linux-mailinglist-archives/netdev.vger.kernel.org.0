Return-Path: <netdev+bounces-11786-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2930673474E
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB2A92810A6
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE3E6FA2;
	Sun, 18 Jun 2023 17:41:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B21386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:41:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A68E51
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=OTvQ32j/AShDo808W2UPHVi7EKD4uA69FnCWfTIBdsM=; b=DEuY4pGdPb55Nm3JeOKRkmdGby
	BBzryi1B6cOe6/At5HswI/MLZrginaso26dpt5xx1TiaF++2OIprWVg2SOmLoPhI8Yq36yYnIseg7
	0O4KU1O9YWSRH3vUGB1RJjED2/8fDr4Siw/zV1S0lFHdmu1yfWK9qibVrEaYDf77pN/w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAwOR-00Gqpy-Hj; Sun, 18 Jun 2023 19:40:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: ansuelsmth@gmail.com,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v0 2/3] net: phy: phy_device: Call into the PHY driver to set LED offload
Date: Sun, 18 Jun 2023 19:39:36 +0200
Message-Id: <20230618173937.4016322-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230618173937.4016322-1-andrew@lunn.ch>
References: <20230618173937.4016322-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Linux LEDs can be requested to perform hardware accelerated blinking
to indicate link, RX, TX etc. Pass the rules for blinking to the PHY
driver, if it implements the ops needed to determine if a given
pattern can be offloaded, to offload it, and what the current offload
is. Additionally implement the op needed to get what device the LED is
for.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 68 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 14 ++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..5397bbe418d8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3020,6 +3020,61 @@ static int phy_led_blink_set(struct led_classdev *led_cdev,
 	return err;
 }
 
+static __maybe_unused struct device *
+phy_led_hw_control_get_device(struct led_classdev *led_cdev)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+
+	if (phydev->attached_dev)
+		return &phydev->attached_dev->dev;
+	return NULL;
+}
+
+static int __maybe_unused
+phy_led_hw_control_get(struct led_classdev *led_cdev,
+		       unsigned long *rules)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_hw_control_get(phydev, phyled->index, rules);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
+static int __maybe_unused
+phy_led_hw_control_set(struct led_classdev *led_cdev,
+		       unsigned long rules)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_hw_control_set(phydev, phyled->index, rules);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
+static __maybe_unused int phy_led_hw_is_supported(struct led_classdev *led_cdev,
+						  unsigned long rules)
+{
+	struct phy_led *phyled = to_phy_led(led_cdev);
+	struct phy_device *phydev = phyled->phydev;
+	int err;
+
+	mutex_lock(&phydev->lock);
+	err = phydev->drv->led_hw_is_supported(phydev, phyled->index, rules);
+	mutex_unlock(&phydev->lock);
+
+	return err;
+}
+
 static int of_phy_led(struct phy_device *phydev,
 		      struct device_node *led)
 {
@@ -3048,6 +3103,19 @@ static int of_phy_led(struct phy_device *phydev,
 		cdev->brightness_set_blocking = phy_led_set_brightness;
 	if (phydev->drv->led_blink_set)
 		cdev->blink_set = phy_led_blink_set;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	if (phydev->drv->led_hw_is_supported &&
+	    phydev->drv->led_hw_control_set &&
+	    phydev->drv->led_hw_control_get) {
+		cdev->hw_control_is_supported = phy_led_hw_is_supported;
+		cdev->hw_control_set = phy_led_hw_control_set;
+		cdev->hw_control_get = phy_led_hw_control_get;
+		cdev->hw_control_trigger = "netdev";
+	}
+
+	cdev->hw_control_get_device = phy_led_hw_control_get_device;
+#endif
 	cdev->max_brightness = 1;
 	init_data.devicename = dev_name(&phydev->mdio.dev);
 	init_data.fwnode = of_fwnode_handle(led);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 11c1e91563d4..1db63fb905c5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1104,6 +1104,20 @@ struct phy_driver {
 	int (*led_blink_set)(struct phy_device *dev, u8 index,
 			     unsigned long *delay_on,
 			     unsigned long *delay_off);
+	/* Can the HW support the given rules. Return 0 if yes,
+	 * -EOPNOTSUPP if not, or an error code.
+	 */
+	int (*led_hw_is_supported)(struct phy_device *dev, u8 index,
+				   unsigned long rules);
+	/* Set the HW to control the LED as described by rules. */
+	int (*led_hw_control_set)(struct phy_device *dev, u8 index,
+				  unsigned long rules);
+	/* Get the rules used to describe how the HW is currently
+	 * configure.
+	 */
+	int (*led_hw_control_get)(struct phy_device *dev, u8 index,
+				  unsigned long *rules);
+
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.40.1


