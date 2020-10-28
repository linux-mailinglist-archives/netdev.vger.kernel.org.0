Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D744B29E180
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgJ2CB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:01:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbgJ1Vt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:29 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603870985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ajE1ZyHvPPsEFBdg1yTXB99E53lS8IRhC9AXf+IK9c=;
        b=qfU5MljQFTY8R0vKYPDpejzgNOqc8BIV/ftUl/qP+y6x3xTu9dRGwVcnJHWnLbbPGQ6qIf
        8YE3BR6jAx6XRK3kTPIoBPKPh/kzHXFJvzCPKXFCg++yQ7C9/xyLR+faYPEZUk5pXhblxP
        u6MB1M0XbK7Yst4dt4qSp8LvYOP9OhwvqpBXXqwrUJZmLEi9huxriKk+5AXevKpx8CE12m
        f/eNle66NUsFaQyQ6jwuD+N7zcnSI8GUeZv5TxtLxNZnUqp8r15IWErvDUR9DavXitB5Hd
        4cyY3BeqQVyf+QNchq+BvfV9KbxpUbMRDDhO1zQpoOeEdAEmly8OmWswzITjHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603870985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ajE1ZyHvPPsEFBdg1yTXB99E53lS8IRhC9AXf+IK9c=;
        b=FJhm5DySa+pebPeH9ZuUmnNyrTahO0aGjRl9DdF5uXATiHcMkfsjHjoUyPEs7oKInxBJHK
        eKDxSuJr2D3VrsDA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v7 6/8] net: dsa: hellcreek: Add PTP status LEDs
Date:   Wed, 28 Oct 2020 08:42:19 +0100
Message-Id: <20201028074221.29326-7-kurt@linutronix.de>
In-Reply-To: <20201028074221.29326-1-kurt@linutronix.de>
References: <20201028074221.29326-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch has two controllable I/Os which are usually connected to LEDs. This
is useful to immediately visually see the PTP status.

These provide two signals:

 * is_gm

   This LED can be activated if the current device is the grand master in that
   PTP domain.

 * sync_good

   This LED can be activated if the current device is in sync with the network
   time.

Expose these via the LED framework to be controlled via user space
e.g. linuxptp.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/hirschmann/hellcreek.h     |   4 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 149 +++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h |   3 +
 3 files changed, 156 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index e5aba055ed30..e81781ebc31c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/leds.h>
 #include <linux/platform_data/hirschmann-hellcreek.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
@@ -267,6 +268,8 @@ struct hellcreek {
 	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port *ports;
 	struct delayed_work overflow_work;
+	struct led_classdev led_is_gm;
+	struct led_classdev led_sync_good;
 	struct mutex reg_lock;	/* Switch IP register lock */
 	struct mutex vlan_lock;	/* VLAN bitmaps lock */
 	struct mutex ptp_lock;	/* PTP IP register lock */
@@ -276,6 +279,7 @@ struct hellcreek {
 	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
 	u64 seconds;		/* PTP seconds */
 	u64 last_ts;		/* Used for overflow detection */
+	u16 status_out;		/* ptp.status_out shadow */
 	size_t fdb_entries;
 };
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index 12ad956abd5c..2572c6087bb5 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -239,9 +239,148 @@ static void hellcreek_ptp_overflow_check(struct work_struct *work)
 			      HELLCREEK_OVERFLOW_PERIOD);
 }
 
+static enum led_brightness hellcreek_get_brightness(struct hellcreek *hellcreek,
+						    int led)
+{
+	return (hellcreek->status_out & led) ? 1 : 0;
+}
+
+static void hellcreek_set_brightness(struct hellcreek *hellcreek, int led,
+				     enum led_brightness b)
+{
+	mutex_lock(&hellcreek->ptp_lock);
+
+	if (b)
+		hellcreek->status_out |= led;
+	else
+		hellcreek->status_out &= ~led;
+
+	hellcreek_ptp_write(hellcreek, hellcreek->status_out, STATUS_OUT);
+
+	mutex_unlock(&hellcreek->ptp_lock);
+}
+
+static void hellcreek_led_sync_good_set(struct led_classdev *ldev,
+					enum led_brightness b)
+{
+	struct hellcreek *hellcreek = led_to_hellcreek(ldev, led_sync_good);
+
+	hellcreek_set_brightness(hellcreek, STATUS_OUT_SYNC_GOOD, b);
+}
+
+static enum led_brightness hellcreek_led_sync_good_get(struct led_classdev *ldev)
+{
+	struct hellcreek *hellcreek = led_to_hellcreek(ldev, led_sync_good);
+
+	return hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
+}
+
+static void hellcreek_led_is_gm_set(struct led_classdev *ldev,
+				    enum led_brightness b)
+{
+	struct hellcreek *hellcreek = led_to_hellcreek(ldev, led_is_gm);
+
+	hellcreek_set_brightness(hellcreek, STATUS_OUT_IS_GM, b);
+}
+
+static enum led_brightness hellcreek_led_is_gm_get(struct led_classdev *ldev)
+{
+	struct hellcreek *hellcreek = led_to_hellcreek(ldev, led_is_gm);
+
+	return hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
+}
+
+/* There two available LEDs internally called sync_good and is_gm. However, the
+ * user might want to use a different label and specify the default state. Take
+ * those properties from device tree.
+ */
+static int hellcreek_led_setup(struct hellcreek *hellcreek)
+{
+	struct device_node *leds, *led = NULL;
+	const char *label, *state;
+	int ret = -EINVAL;
+
+	leds = of_find_node_by_name(hellcreek->dev->of_node, "leds");
+	if (!leds) {
+		dev_err(hellcreek->dev, "No LEDs specified in device tree!\n");
+		return ret;
+	}
+
+	hellcreek->status_out = 0;
+
+	led = of_get_next_available_child(leds, led);
+	if (!led) {
+		dev_err(hellcreek->dev, "First LED not specified!\n");
+		goto out;
+	}
+
+	ret = of_property_read_string(led, "label", &label);
+	hellcreek->led_sync_good.name = ret ? "sync_good" : label;
+
+	ret = of_property_read_string(led, "default-state", &state);
+	if (!ret) {
+		if (!strcmp(state, "on"))
+			hellcreek->led_sync_good.brightness = 1;
+		else if (!strcmp(state, "off"))
+			hellcreek->led_sync_good.brightness = 0;
+		else if (!strcmp(state, "keep"))
+			hellcreek->led_sync_good.brightness =
+				hellcreek_get_brightness(hellcreek,
+							 STATUS_OUT_SYNC_GOOD);
+	}
+
+	hellcreek->led_sync_good.max_brightness = 1;
+	hellcreek->led_sync_good.brightness_set = hellcreek_led_sync_good_set;
+	hellcreek->led_sync_good.brightness_get = hellcreek_led_sync_good_get;
+
+	led = of_get_next_available_child(leds, led);
+	if (!led) {
+		dev_err(hellcreek->dev, "Second LED not specified!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = of_property_read_string(led, "label", &label);
+	hellcreek->led_is_gm.name = ret ? "is_gm" : label;
+
+	ret = of_property_read_string(led, "default-state", &state);
+	if (!ret) {
+		if (!strcmp(state, "on"))
+			hellcreek->led_is_gm.brightness = 1;
+		else if (!strcmp(state, "off"))
+			hellcreek->led_is_gm.brightness = 0;
+		else if (!strcmp(state, "keep"))
+			hellcreek->led_is_gm.brightness =
+				hellcreek_get_brightness(hellcreek,
+							 STATUS_OUT_IS_GM);
+	}
+
+	hellcreek->led_is_gm.max_brightness = 1;
+	hellcreek->led_is_gm.brightness_set = hellcreek_led_is_gm_set;
+	hellcreek->led_is_gm.brightness_get = hellcreek_led_is_gm_get;
+
+	/* Set initial state */
+	if (hellcreek->led_sync_good.brightness == 1)
+		hellcreek_set_brightness(hellcreek, STATUS_OUT_SYNC_GOOD, 1);
+	if (hellcreek->led_is_gm.brightness == 1)
+		hellcreek_set_brightness(hellcreek, STATUS_OUT_IS_GM, 1);
+
+	/* Register both leds */
+	led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
+	led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
+
+	ret = 0;
+
+out:
+	of_node_put(leds);
+
+	return ret;
+}
+
 int hellcreek_ptp_setup(struct hellcreek *hellcreek)
 {
 	u16 status;
+	int ret;
 
 	/* Set up the overflow work */
 	INIT_DELAYED_WORK(&hellcreek->overflow_work,
@@ -288,6 +427,14 @@ int hellcreek_ptp_setup(struct hellcreek *hellcreek)
 	hellcreek_ptp_write(hellcreek, status | PR_CLOCK_STATUS_C_ENA_DRIFT,
 			    PR_CLOCK_STATUS_C);
 
+	/* LED setup */
+	ret = hellcreek_led_setup(hellcreek);
+	if (ret) {
+		if (hellcreek->ptp_clock)
+			ptp_clock_unregister(hellcreek->ptp_clock);
+		return ret;
+	}
+
 	schedule_delayed_work(&hellcreek->overflow_work,
 			      HELLCREEK_OVERFLOW_PERIOD);
 
@@ -296,6 +443,8 @@ int hellcreek_ptp_setup(struct hellcreek *hellcreek)
 
 void hellcreek_ptp_free(struct hellcreek *hellcreek)
 {
+	led_classdev_unregister(&hellcreek->led_is_gm);
+	led_classdev_unregister(&hellcreek->led_sync_good);
 	cancel_delayed_work_sync(&hellcreek->overflow_work);
 	if (hellcreek->ptp_clock)
 		ptp_clock_unregister(hellcreek->ptp_clock);
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.h b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
index e0eca1f4a494..0b51392c7e56 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.h
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.h
@@ -70,4 +70,7 @@ u64 hellcreek_ptp_gettime_seconds(struct hellcreek *hellcreek, u64 ns);
 #define dw_overflow_to_hellcreek(dw)				\
 	container_of(dw, struct hellcreek, overflow_work)
 
+#define led_to_hellcreek(ldev, led)				\
+	container_of(ldev, struct hellcreek, led)
+
 #endif /* _HELLCREEK_PTP_H_ */
-- 
2.20.1

