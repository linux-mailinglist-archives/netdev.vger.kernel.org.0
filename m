Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069791AE214
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgDQQUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:20:36 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54810 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729837AbgDQQUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:20:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id D1DB52A2AEB
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
To:     linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC v3 2/2] thermal: core: Stop polling DISABLED thermal devices
Date:   Fri, 17 Apr 2020 18:20:20 +0200
Message-Id: <20200417162020.19980-3-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417162020.19980-1-andrzej.p@collabora.com>
References: <9ac3b37a-8746-b8ee-70e1-9c876830ac83@linaro.org>
 <20200417162020.19980-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Polling DISABLED devices is not desired, as all such "disabled" devices
are meant to be handled by userspace. This patch introduces and uses
should_stop_polling() to decide whether the device should be polled or not.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
---
 drivers/thermal/thermal_core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 5ff98fcc0f6a..36abdc9ce1bb 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -305,13 +305,22 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 		cancel_delayed_work(&tz->poll_queue);
 }
 
+static inline bool should_stop_polling(struct thermal_zone_device *tz)
+{
+	return thermal_zone_device_get_mode(tz) == THERMAL_DEVICE_DISABLED;
+}
+
 static void monitor_thermal_zone(struct thermal_zone_device *tz)
 {
+	bool stop;
+
+	stop = should_stop_polling(tz);
+
 	mutex_lock(&tz->lock);
 
-	if (tz->passive)
+	if (!stop && tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
-	else if (tz->polling_delay)
+	else if (!stop && tz->polling_delay)
 		thermal_zone_device_set_polling(tz, tz->polling_delay);
 	else
 		thermal_zone_device_set_polling(tz, 0);
@@ -505,6 +514,9 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
 {
 	int count;
 
+	if (should_stop_polling(tz))
+		return;
+
 	if (atomic_read(&in_suspend))
 		return;
 
-- 
2.17.1

