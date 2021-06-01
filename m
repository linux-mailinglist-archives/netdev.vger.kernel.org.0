Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C15396A83
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhFAAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhFAAyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D21D61370;
        Tue,  1 Jun 2021 00:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508741;
        bh=mwIRJpoT9nxq/Jlz5btqtXLukWmNDZNHqD6M4t/09rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7hN7PVHzWelGSDpy3tfDIimEoakerbx2lkvZg1Sx5HVnVNG167yt6zlch0xUcW5B
         ewtzyO7tgiXu+8cEi6tFT/5V1qRhOhT28/xXv38jrIsDcl6Fnvu/CEeidjJgHRncLg
         sKjItdBOOHA52L+69M6uENyS5MiRp6kfUSaksw3DHIh/ZmgkMlZ3XXuBkoGPN2o1Hp
         VFDp846SrHZBQ7HYoITX2YKgZ2HOjGvjiz7xhlL/wZ1GLWbZfVyA2HPzIAsEpTt6iP
         QovjQdCh2jqUKBg6UJ3ptUf4FnGG9RWS1lCQ/TbWMnIFdlxGWjhe0qYvn66J75vjif
         e/HtuBftMZmRw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v2 10/10] leds: turris-omnia: support offloading netdev trigger for WAN LED
Date:   Tue,  1 Jun 2021 02:51:55 +0200
Message-Id: <20210601005155.27997-11-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading netdev trigger for WAN LED.

Support for LAN LEDs will be added later, because it needs changes in
the mv88e6xxx driver.

Here is a simplified schema of how the corresponding chips are connected
on Turris Omnia:

                       [eth2]    +-----+   [eth0 & eth1]
                     /-----------< SOC >-----------------\
                     |           +--v--+                 |
                     |              |    [i2c]           |
                     |              \-------------\      |
   [MOD_DEF0] +------v--------+                   |      |
    /---------> SerDes switch |    [LED0_pin]  +--v--+   |  +----------+
    |         +--v-------v----+  /-------------> MCU >---|--> RGB LEDs |
    |    [srds0] |       |       |             +--^--+   |  +----------+
    |    /-------/       |       |                |      |
    |    |        [srds1]|       |      [LED_pins]|      |
  +-^----v---+       +---v-------^---+    +-------^------v-+
  | SFP cage |       |  88E1512 PHY  |    | 88E6176 Swtich |
  +----------+       | with WAN port |    | with LAN ports |
                     +---------------+    +----------------+

The RGB LEDs are controlled by the MCU and can be configured into the
following modes:
- SW mode - both color and whether the LED is on/off is controlled via
            I2C
- HW mode - color is controlled via I2C, on/off state is controlled by
            HW depending on LED:
  - WAN LED on/off state reflects LED0_pin from the 88E1512 PHY
  - LAN LED on/off states reflect corresponding LED_pins from 88E6176
    switch [1]
  - PCIe on/off states reflect the corresponding WWAN/WLAN/MSATA LED
    pins from the MiniPCIe ports [1]
  - Power LED is always on in HW mode
  - User LEDs are always off in HW mode

Adding netdev trigger offload support for the WAN LED therefore
requires:
- checking whether the netdevice for which the netdev trigger should
  trigger is indeed the WAN device
- checking whether SFP cage is empty. If there is a SFP module in the
  cage, the 88E1512 PHY is not used and we have to trigger in SW.
  Currently this is done by simply checking if sfp_bus is NULL, because
  phylink does not yet have support for how the SFP cage is wired on
  Omnia (via SerDes switch)
- configuring the behaviour of LED0_pin of the Marvell 88E1512 PHY
  according to requested netdev trigger settings
- putting the WAN LED into HW mode

[1] For more info look at
    https://wiki.turris.cz/doc/_media/rtrom01-schema.pdf

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/Kconfig             |   3 +
 drivers/leds/leds-turris-omnia.c | 232 +++++++++++++++++++++++++++++++
 2 files changed, 235 insertions(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 49d99cb084db..e2950636f093 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -182,6 +182,9 @@ config LEDS_TURRIS_OMNIA
 	depends on I2C
 	depends on MACH_ARMADA_38X || COMPILE_TEST
 	depends on OF
+	depends on PHYLIB
+	select LEDS_TRIGGERS
+	select LEDS_TRIGGER_NETDEV
 	help
 	  This option enables basic support for the LEDs found on the front
 	  side of CZ.NIC's Turris Omnia router. There are 12 RGB LEDs on the
diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index b3581b98c75d..b9ea0ce261eb 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -7,9 +7,11 @@
 
 #include <linux/i2c.h>
 #include <linux/led-class-multicolor.h>
+#include <linux/ledtrig-netdev.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/phy.h>
 #include "leds.h"
 
 #define OMNIA_BOARD_LEDS	12
@@ -27,10 +29,20 @@
 #define CMD_LED_SET_BRIGHTNESS	7
 #define CMD_LED_GET_BRIGHTNESS	8
 
+#define MII_MARVELL_LED_PAGE		0x03
+#define MII_PHY_LED_CTRL		0x10
+#define MII_PHY_LED_TCR			0x12
+#define MII_PHY_LED_TCR_PULSESTR_MASK	0x7000
+#define MII_PHY_LED_TCR_PULSESTR_SHIFT	12
+#define MII_PHY_LED_TCR_BLINKRATE_MASK	0x0700
+#define MII_PHY_LED_TCR_BLINKRATE_SHIFT	8
+
 struct omnia_led {
 	struct led_classdev_mc mc_cdev;
 	struct mc_subled subled_info[OMNIA_LED_NUM_CHANNELS];
 	int reg;
+	struct device_node *trig_src_np;
+	struct phy_device *phydev;
 };
 
 #define to_omnia_led(l)		container_of(l, struct omnia_led, mc_cdev)
@@ -38,6 +50,7 @@ struct omnia_led {
 struct omnia_leds {
 	struct i2c_client *client;
 	struct mutex lock;
+	int count;
 	struct omnia_led leds[];
 };
 
@@ -91,6 +104,208 @@ static int omnia_led_set_sw_mode(struct i2c_client *client, int led, bool sw)
 					 (sw ? CMD_LED_MODE_USER : 0));
 }
 
+static int wan_led_round_blink_rate(unsigned long *period)
+{
+	/* Each interval is (0.7 * p, 1.3 * p), where p is the period supported
+	 * by the chip. Should we change this so that there are no holes between
+	 * these intervals?
+	 */
+	switch (*period) {
+	case 29 ... 55:
+		*period = 42;
+		return 0;
+	case 58 ... 108:
+		*period = 84;
+		return 1;
+	case 119 ... 221:
+		*period = 170;
+		return 2;
+	case 238 ... 442:
+		*period = 340;
+		return 3;
+	case 469 ... 871:
+		*period = 670;
+		return 4;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int omnia_led_trig_offload_wan(struct omnia_leds *leds,
+				      struct omnia_led *led,
+				      struct led_netdev_data *trig)
+{
+	unsigned long period;
+	int ret, blink_rate;
+	bool link, rx, tx;
+	u8 fun;
+
+	/* HW offload on WAN port is supported only via internal PHY */
+	if (trig->net_dev->sfp_bus || !trig->net_dev->phydev)
+		return -EOPNOTSUPP;
+
+	link = test_bit(NETDEV_LED_LINK, &trig->mode);
+	rx = test_bit(NETDEV_LED_RX, &trig->mode);
+	tx = test_bit(NETDEV_LED_TX, &trig->mode);
+
+	if (link && rx && tx)
+		fun = 0x1;
+	else if (!link && rx && tx)
+		fun = 0x4;
+	else
+		return -EOPNOTSUPP;
+
+	period = jiffies_to_msecs(atomic_read(&trig->interval)) * 2;
+	blink_rate = wan_led_round_blink_rate(&period);
+	if (blink_rate < 0)
+		return blink_rate;
+
+	mutex_lock(&leds->lock);
+
+	if (!led->phydev) {
+		led->phydev = trig->net_dev->phydev;
+		get_device(&led->phydev->mdio.dev);
+	}
+
+	/* set PHY's LED[0] pin to blink according to trigger setting */
+	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
+			       MII_PHY_LED_TCR,
+			       MII_PHY_LED_TCR_PULSESTR_MASK |
+			       MII_PHY_LED_TCR_BLINKRATE_MASK,
+			       (0 << MII_PHY_LED_TCR_PULSESTR_SHIFT) |
+			       (blink_rate << MII_PHY_LED_TCR_BLINKRATE_SHIFT));
+	if (ret)
+		goto unlock;
+
+	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
+			       MII_PHY_LED_CTRL, 0xf, fun);
+	if (ret)
+		goto unlock;
+
+	/* put the LED into HW mode */
+	ret = omnia_led_set_sw_mode(leds->client, led->reg, false);
+	if (ret)
+		goto unlock;
+
+	/* set blinking brightness according to led_cdev->blink_brighness */
+	ret = omnia_led_brightness_set(leds->client, led,
+				       led->mc_cdev.led_cdev.blink_brightness);
+	if (ret)
+		goto unlock;
+
+	atomic_set(&trig->interval, msecs_to_jiffies(period / 2));
+
+unlock:
+	mutex_unlock(&leds->lock);
+
+	if (ret)
+		dev_err(led->mc_cdev.led_cdev.dev,
+			"Error offloading trigger: %d\n", ret);
+
+	return ret;
+}
+
+static int omnia_led_trig_offload_off(struct omnia_leds *leds,
+				      struct omnia_led *led)
+{
+	int ret;
+
+	if (!led->phydev)
+		return 0;
+
+	mutex_lock(&leds->lock);
+
+	/* set PHY's LED[0] pin to default values */
+	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
+			       MII_PHY_LED_TCR,
+			       MII_PHY_LED_TCR_PULSESTR_MASK |
+			       MII_PHY_LED_TCR_BLINKRATE_MASK,
+			       (4 << MII_PHY_LED_TCR_PULSESTR_SHIFT) |
+			       (1 << MII_PHY_LED_TCR_BLINKRATE_SHIFT));
+
+	ret = phy_modify_paged(led->phydev, MII_MARVELL_LED_PAGE,
+			       MII_PHY_LED_CTRL, 0xf, 0xe);
+
+	/*
+	 * Return to software controlled mode, but only if we aren't being
+	 * called from led_classdev_unregister.
+	 */
+	if (!(led->mc_cdev.led_cdev.flags & LED_UNREGISTERING))
+		ret = omnia_led_set_sw_mode(leds->client, led->reg, true);
+
+	put_device(&led->phydev->mdio.dev);
+	led->phydev = NULL;
+
+	mutex_unlock(&leds->lock);
+
+	return 0;
+}
+
+static int omnia_led_trig_offload(struct led_classdev *cdev, bool enable)
+{
+	struct omnia_leds *leds = dev_get_drvdata(cdev->dev->parent);
+	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(cdev);
+	struct omnia_led *led = to_omnia_led(mc_cdev);
+	struct led_netdev_data *trig;
+	int ret = -EOPNOTSUPP;
+
+	if (!enable)
+		return omnia_led_trig_offload_off(leds, led);
+
+	if (!led->trig_src_np)
+		goto end;
+
+	/* only netdev trigger offloading is supported currently */
+	if (strcmp(cdev->trigger->name, "netdev"))
+		goto end;
+
+	trig = led_get_trigger_data(cdev);
+
+	if (!trig->net_dev)
+		goto end;
+
+	if (dev_of_node(trig->net_dev->dev.parent) != led->trig_src_np)
+		goto end;
+
+	ret = omnia_led_trig_offload_wan(leds, led, trig);
+
+end:
+	/*
+	 * if offloading failed (parameters not supported by HW), ensure any
+	 * previous offloading is disabled
+	 */
+	if (ret)
+		omnia_led_trig_offload_off(leds, led);
+
+	return ret;
+}
+
+static int read_trigger_sources(struct omnia_led *led, struct device_node *np)
+{
+	struct of_phandle_args args;
+	int ret;
+
+	ret = of_count_phandle_with_args(np, "trigger-sources",
+					 "#trigger-source-cells");
+	if (ret < 0)
+		return ret == -ENOENT ? 0 : ret;
+
+	if (!ret)
+		return 0;
+
+	ret = of_parse_phandle_with_args(np, "trigger-sources",
+					 "#trigger-source-cells", 0, &args);
+	if (ret)
+		return ret;
+
+	if (of_device_is_compatible(args.np, "marvell,armada-370-neta"))
+		led->trig_src_np = args.np;
+	else
+		of_node_put(args.np);
+
+	return 0;
+}
+
 static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 			      struct device_node *np)
 {
@@ -115,6 +330,13 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 		return 0;
 	}
 
+	ret = read_trigger_sources(led, np);
+	if (ret) {
+		dev_warn(dev, "Node %pOF: failed reading trigger sources: %d\n",
+			 np, ret);
+		return 0;
+	}
+
 	led->subled_info[0].color_index = LED_COLOR_ID_RED;
 	led->subled_info[0].channel = 0;
 	led->subled_info[0].intensity = 255;
@@ -133,6 +355,8 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 	cdev = &led->mc_cdev.led_cdev;
 	cdev->max_brightness = 255;
 	cdev->brightness_set_blocking = omnia_led_brightness_set_blocking;
+	if (led->trig_src_np)
+		cdev->trigger_offload = omnia_led_trig_offload;
 
 	/* put the LED into software mode */
 	ret = omnia_led_set_sw_mode(client, led->reg, true);
@@ -256,6 +480,7 @@ static int omnia_leds_probe(struct i2c_client *client,
 		}
 
 		led += ret;
+		++leds->count;
 	}
 
 	if (devm_device_add_groups(dev, omnia_led_controller_groups))
@@ -266,8 +491,15 @@ static int omnia_leds_probe(struct i2c_client *client,
 
 static int omnia_leds_remove(struct i2c_client *client)
 {
+	struct omnia_leds *leds = i2c_get_clientdata(client);
+	struct omnia_led *led;
 	u8 buf[5];
 
+	/* put away trigger source OF nodes */
+	for (led = &leds->leds[0]; led < &leds->leds[leds->count]; ++led)
+		if (led->trig_src_np)
+			of_node_put(led->trig_src_np);
+
 	/* put all LEDs into default (HW triggered) mode */
 	omnia_led_set_sw_mode(client, OMNIA_BOARD_LEDS, false);
 
-- 
2.26.3

