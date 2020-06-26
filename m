Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BFB20B739
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgFZRiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgFZRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:38:16 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F9CC03E979;
        Fri, 26 Jun 2020 10:38:16 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id E33492A5E4E
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        kernel@collabora.com
Subject: [PATCH v5 06/11] thermal: Add mode helpers
Date:   Fri, 26 Jun 2020 19:37:50 +0200
Message-Id: <20200626173755.26379-7-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626173755.26379-1-andrzej.p@collabora.com>
References: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
 <20200626173755.26379-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for making the drivers not access tzd's private members.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
[EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL]
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c | 53 ++++++++++++++++++++++++++++++++++
 include/linux/thermal.h        | 13 +++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 14d3b1b94c4f..3181295075b9 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -459,6 +459,59 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
 	thermal_zone_device_init(tz);
 }
 
+int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
+				 enum thermal_device_mode mode)
+{
+	int ret = 0;
+
+	mutex_lock(&tz->lock);
+
+	/* do nothing if mode isn't changing */
+	if (mode == tz->mode) {
+		mutex_unlock(&tz->lock);
+
+		return ret;
+	}
+
+	if (tz->ops->set_mode)
+		ret = tz->ops->set_mode(tz, mode);
+
+	if (!ret)
+		tz->mode = mode;
+
+	mutex_unlock(&tz->lock);
+
+	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+
+	return ret;
+}
+
+int thermal_zone_device_enable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_enable);
+
+int thermal_zone_device_disable(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_disable);
+
+int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
+{
+	enum thermal_device_mode mode;
+
+	mutex_lock(&tz->lock);
+
+	mode = tz->mode;
+
+	mutex_unlock(&tz->lock);
+
+	return mode == THERMAL_DEVICE_ENABLED;
+}
+EXPORT_SYMBOL_GPL(thermal_zone_device_is_enabled);
+
 void thermal_zone_device_update(struct thermal_zone_device *tz,
 				enum thermal_notify_event event)
 {
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index a808f6fa2777..df013c39ba9b 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -416,6 +416,9 @@ int thermal_zone_get_offset(struct thermal_zone_device *tz);
 
 void thermal_cdev_update(struct thermal_cooling_device *);
 void thermal_notify_framework(struct thermal_zone_device *, int);
+int thermal_zone_device_enable(struct thermal_zone_device *tz);
+int thermal_zone_device_disable(struct thermal_zone_device *tz);
+int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
 #else
 static inline struct thermal_zone_device *thermal_zone_device_register(
 	const char *type, int trips, int mask, void *devdata,
@@ -463,6 +466,16 @@ static inline void thermal_cdev_update(struct thermal_cooling_device *cdev)
 static inline void thermal_notify_framework(struct thermal_zone_device *tz,
 	int trip)
 { }
+
+static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
+{ return -ENODEV; }
+
+static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
+{ return -ENODEV; }
+
+static inline int
+thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
+{ return -ENODEV; }
 #endif /* CONFIG_THERMAL */
 
 #endif /* __THERMAL_H__ */
-- 
2.17.1

