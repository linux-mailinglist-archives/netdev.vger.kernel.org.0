Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36DE69E70E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjBUSJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjBUSIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:08:40 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3D52F798
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 10:08:05 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j3so1971312wms.2
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 10:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxOjXV0BQvNs4//4eyybGdilzG1LzEaF0NAq/aqNM8Q=;
        b=JT/vx6hFSQYN4c2jk7Stt6InjzZQMM0mhvzlKkKPuYT9DPtfKOsHXrx+sSqzXKmhV4
         HN9xhbOFiCrS189gTkrTh3E/RW3s6hpY+u7m940QJwtr7wmvT2sHJgPehcPVIAtCT9Ar
         UvMyL2S1IWn42TvYQkGPwwU2DBDYMgEKb20wEvg9ToEv2NoLp3mQIxqQuWfeiY3V5b/I
         2zg1mNJz3D0JZ/hfVvnCeFQxlgDbwpf4fEKFFTn1Cai6l+oQ4gBe3C4iqhC5UlQd3siB
         bXcwe4EyQwybr4voCX90kNGpz+328NTLLnNegXxxDf/8Vb5ETwX+XfqbHLZlVLoRRRe5
         z12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxOjXV0BQvNs4//4eyybGdilzG1LzEaF0NAq/aqNM8Q=;
        b=L2WVPCBGdxA32r4mmARbew+EN8KiiMn+G1JATy+4G2Hw6yqBky0BF+3G56Sc2IOQiY
         b2hcHM+WXJFxNZP/rls+Ybzl11+f9dv2i1ICiCmNwQfDuRRIKGz9dvjXnNL98Eiwfxk0
         yvS8VYU62OGH38kj+zh9h/MmsymIS5V+pnV7pAgRmYX+lNZryNd904oiBr5j2kYkUQ5v
         rhnSL8iDTMwauS5EdzIZFffCgA3I/MBHfu/rVlXC1vVia2fq5uAtPlUoQVJRmwFpLsU0
         u5dv0YVPi9jVrxW9dpwcpUyuv1CM5pON4+Pr7Qpbc4T6mQ2PQr3HM0H9Tb5c5jCsn08l
         jORg==
X-Gm-Message-State: AO0yUKVu8JgY+D4mraYXw9LoI/HpmKvBZxkwBirIgivBVJt5i1M2HDAb
        njXStME++laR+wd6xksDMxFMHw==
X-Google-Smtp-Source: AK7set+UvfuNbt1xzTlvl99AbwSUpW97o8x8EsfSehdVbZk/s/8pp5dlcoJQQ7YQr9U5gVjvwA4sTg==
X-Received: by 2002:a05:600c:16d3:b0:3dc:5950:b358 with SMTP id l19-20020a05600c16d300b003dc5950b358mr10858363wmn.14.1677002883410;
        Tue, 21 Feb 2023 10:08:03 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:1e9:315c:bb40:e382])
        by smtp.gmail.com with ESMTPSA id c128-20020a1c3586000000b003e21558ee9dsm5107815wma.2.2023.02.21.10.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 10:08:03 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amit Kucheria <amitk@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        linux-acpi@vger.kernel.org (open list:ACPI THERMAL DRIVER),
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS),
        linux-omap@vger.kernel.org (open list:TI BANDGAP AND THERMAL DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v2 09/16] thermal: Do not access 'type' field, use the tz id instead
Date:   Tue, 21 Feb 2023 19:07:03 +0100
Message-Id: <20230221180710.2781027-10-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221180710.2781027-1-daniel.lezcano@linaro.org>
References: <20230221180710.2781027-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'type' field is used as a name in the message. However we can have
multiple thermal zone with the same type. The information is not
accurate.

Moreover, the thermal zone device structure is directly accessed while
we want to improve the self-encapsulation of the code.

Replace the 'type' in the message by the thermal zone id.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw
---
 drivers/acpi/thermal.c                             | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 4 ++--
 drivers/thermal/mediatek/lvts_thermal.c            | 5 +----
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 4 ++--
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 392b73b3e269..b55a3b0ad9ed 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -842,7 +842,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		goto acpi_bus_detach;
 
 	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
-		 tz->thermal_zone->id);
+		 thermal_zone_device_get_id(tz->thermal_zone));
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 722e4a40afef..a997fca211ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -176,8 +176,8 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	}
 
 	if (crit_temp > emerg_temp) {
-		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
-			 tz->tzdev->type, crit_temp, emerg_temp);
+		dev_warn(dev, "tz id %d: Critical threshold %d is above emergency threshold %d\n",
+			 thermal_zone_device_get_id(tz->tzdev), crit_temp, emerg_temp);
 		return 0;
 	}
 
diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index beb835d644e2..155cef8ed3f5 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -304,10 +304,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	if (low != -INT_MAX) {
-		pr_debug("%s: Setting low limit temperature interrupt: %d\n", tz->type, low);
+	if (low != -INT_MAX)
 		writel(raw_low, LVTS_H2NTHRE(base));
-	}
 
 	/*
 	 * Hot temperature threshold
@@ -318,7 +316,6 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	pr_debug("%s: Setting high limit temperature interrupt: %d\n", tz->type, high);
 	writel(raw_high, LVTS_HTHRE(base));
 
 	return 0;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 060f46cea5ff..488b08fc20e4 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -43,8 +43,8 @@ static void ti_thermal_work(struct work_struct *work)
 
 	thermal_zone_device_update(data->ti_thermal, THERMAL_EVENT_UNSPECIFIED);
 
-	dev_dbg(data->bgp->dev, "updated thermal zone %s\n",
-		data->ti_thermal->type);
+	dev_dbg(data->bgp->dev, "updated thermal zone id %d\n",
+		thermal_zone_device_get_id(data->ti_thermal));
 }
 
 /**
-- 
2.34.1

