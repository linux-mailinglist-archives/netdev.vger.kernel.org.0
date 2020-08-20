Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7624B0D7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHTIO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:14:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45356 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgHTILo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:11:44 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597911101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CO4O+UG66HNt+D0j8JhkwKZPdz8JTrsuv8lWpk4iYbA=;
        b=v73sap398txe+8v7D25Nq4D/mk+amgbMTgOZmiwUzuuaxpuV9IxwMDgkVCACdaBE1pBgdt
        TvHKNXthtccV4dIK33wyddFnjaow8iBx4m2Rvauf96deZtPqLEK6FAHVF5yzvmwXjkFWB/
        Y9SpUA5+MsqEe/t8iCr2sNZ+nwhF1fE2LfLwJIq6wjwVMa4vO2tXYZyMzxSmMeuBOnMYc1
        QDu7LuTIsbkjli+G6CJ1pNbpNyctM8p/DSMi8mXWB09vm7z64gk7KhTjY0vaF2KbRHlZsb
        ShagSKcDiWcsZHPSDyrw8zoaiig4wWVdxEkrFv7ouWDAhiV05DzClPWHOeh9sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597911101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CO4O+UG66HNt+D0j8JhkwKZPdz8JTrsuv8lWpk4iYbA=;
        b=jrHtvMENWBp0HMRSxxlX+acwu8uOyrthY4xhwmrOOe8xyMzZfeASJt/rJgGdvdgg9Adaas
        3Tze1Ci/tHeoFoBA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 6/8] net: dsa: hellcreek: Add PTP status LEDs
Date:   Thu, 20 Aug 2020 10:11:16 +0200
Message-Id: <20200820081118.10105-7-kurt@linutronix.de>
In-Reply-To: <20200820081118.10105-1-kurt@linutronix.de>
References: <20200820081118.10105-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
---
 drivers/net/dsa/hirschmann/hellcreek.h     |   4 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 149 +++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h |   3 +
 3 files changed, 156 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index d3d1a1144857..c83af1af8d8a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -17,6 +17,7 @@
 #include <linux/timecounter.h>
 #include <linux/spinlock.h>
 #include <linux/hrtimer.h>
+#include <linux/leds.h>
 #include <net/dsa.h>
 
 /* Ports:
@@ -280,6 +281,8 @@ struct hellcreek {
 	struct ptp_clock_info ptp_clock_info;
 	struct hellcreek_port ports[4];
 	struct delayed_work overflow_work;
+	struct led_classdev led_is_gm;
+	struct led_classdev led_sync_good;
 	spinlock_t reg_lock;	/* Switch IP register lock */
 	spinlock_t ptp_lock;	/* PTP IP register lock */
 	void __iomem *base;
@@ -287,6 +290,7 @@ struct hellcreek {
 	u8 *vidmbrcfg;		/* vidmbrcfg shadow */
 	u64 seconds;		/* PTP seconds */
 	u64 last_ts;		/* Used for overflow detection */
+	u16 status_out;		/* ptp.status_out shadow */
 	size_t fdb_entries;
 };
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index 8c2cef2b60fb..579a38d8ad15 100644
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
+	spin_lock(&hellcreek->ptp_lock);
+
+	if (b)
+		hellcreek->status_out |= led;
+	else
+		hellcreek->status_out &= ~led;
+
+	hellcreek_ptp_write(hellcreek, hellcreek->status_out, STATUS_OUT);
+
+	spin_unlock(&hellcreek->ptp_lock);
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

