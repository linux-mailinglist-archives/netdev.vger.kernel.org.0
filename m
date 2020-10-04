Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28EF282A71
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgJDLaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgJDLaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:30:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE6C0613D0;
        Sun,  4 Oct 2020 04:30:20 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601811018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AEUnJ00kbj43ksygcP4Q1vyoH4yo9hyuNlS9xJe8dhM=;
        b=qX3PMlBUeKMATVMNPuVCr1egQk9DDXOu9eZFd8/VAJasRERExYyuMONZPnS0wwDShO0Od1
        kA1VqQdYKo4XVgbacmK3Yl7wOTcjXkGotyw4Gj+aOrbEaC+muom6Dm1pbI6E44EBoMknp3
        l8YyLvMjcNfayDzgZYoIiMs/wAC1KoitrCUl3Da6XF/SXgq5njpAn9A++jQmFBJrgl9VeA
        nHhmdGiobvBxB+S40ViknDFvJ8xiXiprJtlkZWLpmsugpzfIK/l9okan4gbDEU2jwvQdsS
        LS+0+Q3ybrHqrMVB6Kc/eDAQX4rsTJ105X1WmHDfWdrVPxG0rPrJxlzcJxiaSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601811018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AEUnJ00kbj43ksygcP4Q1vyoH4yo9hyuNlS9xJe8dhM=;
        b=s11xjTES3jRnobb6mc8laUDe2ahfaJeA3gyTMrv3R48cLZ7kDD47XBXbjcxj5Mi/6k90n4
        VmZMOxWJCArSubAQ==
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
Subject: [PATCH net-next v6 5/7] net: dsa: hellcreek: Add PTP status LEDs
Date:   Sun,  4 Oct 2020 13:29:09 +0200
Message-Id: <20201004112911.25085-6-kurt@linutronix.de>
In-Reply-To: <20201004112911.25085-1-kurt@linutronix.de>
References: <20201004112911.25085-1-kurt@linutronix.de>
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
index 0b42c15736ce..baf60ee69125 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -17,6 +17,7 @@
 #include <linux/timecounter.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/leds.h>
 #include <linux/platform_data/hirschmann-hellcreek.h>
 #include <net/dsa.h>
 
@@ -275,6 +276,8 @@ struct hellcreek {
 	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port *ports;
 	struct delayed_work overflow_work;
+	struct led_classdev led_is_gm;
+	struct led_classdev led_sync_good;
 	struct mutex reg_lock;	/* Switch IP register lock */
 	struct mutex ptp_lock;	/* PTP IP register lock */
 	void __iomem *base;
@@ -282,6 +285,7 @@ struct hellcreek {
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

