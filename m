Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866FE6A57ED
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjB1LYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjB1LYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:24:12 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2617712F01
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:23:43 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az36so6168176wmb.1
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677583416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dexA46MbFD/1LJf//eW76xTgHB+gKrlRAfZ8jnkaOvM=;
        b=D7degXSLzdHyyuLQSEez+rs6OoplckklX0y3yoGvzMO+5YqTBk/bkHm2mQ/ivXNeYn
         lBJBIkAZMz0AuuAE6FxYOQ0bRdPYrEnl0df5rs6DhgYUh5u7gLvmcwEaI34LezA0l8KQ
         xZ77ztBIa8JhuumE7fBQfx+YWQJoc/P2QIOm8KuT0OKc4ldLXhQs+q6mY4qBJSNux6Oq
         I4ZHZEAownLfC+fI/GvQCjOJL/heOBr7Z1nzpFnF6lF2RvcWgdLYaPpQGLFnuCk8tQDX
         eoBlkmPVM0bUl4tnXttpCRBxR3e050yQszSgWxgc3rev6xCmFM6jEItkfQjocVW3fi1Z
         uFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677583416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dexA46MbFD/1LJf//eW76xTgHB+gKrlRAfZ8jnkaOvM=;
        b=AaEFt8TUH8wTedv7DGNUNsSdpmebE7GZiJJnOtqz8bOt9iy5hY2UklzYnoVKdviAji
         +egO06b3D7h+XII1cOB++jl5G9qJLXjojS+gIMYMoF5A+xuJpzw/ibNughoW38L91wif
         8h7blYz9ambNWgU+BhiT5m8j7q5Ti0YBoc4J8OnyCMXUEJ6acZEiFqHkNuu0iOz5mbXX
         W6hDUKwi2YY/AZTcv9pTxkJSmdF+faCJhb96hZtRnA3MTh4Qlh0GpjucbfUr9CLo8Qwk
         0VFGZWf/GxmOk3PcFZX/63M/1sVzZVRiIq37cBGfjOeybIxF2RwrgrvtnUqJohE3ait2
         Tzfg==
X-Gm-Message-State: AO0yUKXXpyddOZvMypVtAU10gDqaaAJVvikiDrLXjeKS1yubS/d/2qSn
        IsDM0PLkUyunGRpelSM/E2W4GQ==
X-Google-Smtp-Source: AK7set8k5v1pMbP5E0MJG27rjohqibwn3NPj8ECtbmF9Uu/FsnlKLUs/jpmcAcpNDG7Ctk2/Y3aExA==
X-Received: by 2002:a05:600c:1f0e:b0:3e7:95ba:e1c7 with SMTP id bd14-20020a05600c1f0e00b003e795bae1c7mr1982176wmb.32.1677583416101;
        Tue, 28 Feb 2023 03:23:36 -0800 (PST)
Received: from mai.box.freepro.com ([2a05:6e02:1041:c10:6830:6390:2815:b6a5])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6545000000b002c5501a5803sm9598130wrv.65.2023.02.28.03.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:23:35 -0800 (PST)
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
To:     rafael@kernel.org, daniel.lezcano@linaro.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Balsam CHIHI <bchihi@baylibre.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        netdev@vger.kernel.org (open list:MELLANOX ETHERNET SWITCH DRIVERS),
        linux-omap@vger.kernel.org (open list:TI BANDGAP AND THERMAL DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v4 13/19] thermal: Use thermal_zone_device_type() accessor
Date:   Tue, 28 Feb 2023 12:22:32 +0100
Message-Id: <20230228112238.2312273-14-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230228112238.2312273-1-daniel.lezcano@linaro.org>
References: <20230228112238.2312273-1-daniel.lezcano@linaro.org>
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

Replace the accesses to 'tz->type' by its accessor version in order to
self-encapsulate the thermal_zone_device structure.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> #MediaTek LVTS
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 2 +-
 drivers/thermal/mediatek/lvts_thermal.c            | 6 ++++--
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 722e4a40afef..b0a169e68df9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -177,7 +177,7 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 
 	if (crit_temp > emerg_temp) {
 		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
-			 tz->tzdev->type, crit_temp, emerg_temp);
+			 thermal_zone_device_type(tz->tzdev), crit_temp, emerg_temp);
 		return 0;
 	}
 
diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index beb835d644e2..216f53eb1385 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -305,7 +305,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 * 14-0 : Raw temperature for threshold
 	 */
 	if (low != -INT_MAX) {
-		pr_debug("%s: Setting low limit temperature interrupt: %d\n", tz->type, low);
+		pr_debug("%s: Setting low limit temperature interrupt: %d\n",
+			 thermal_zone_device_type(tz), low);
 		writel(raw_low, LVTS_H2NTHRE(base));
 	}
 
@@ -318,7 +319,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
 	 *
 	 * 14-0 : Raw temperature for threshold
 	 */
-	pr_debug("%s: Setting high limit temperature interrupt: %d\n", tz->type, high);
+	pr_debug("%s: Setting high limit temperature interrupt: %d\n",
+		 thermal_zone_device_type(tz), high);
 	writel(raw_high, LVTS_HTHRE(base));
 
 	return 0;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 060f46cea5ff..0c8914017c18 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -44,7 +44,7 @@ static void ti_thermal_work(struct work_struct *work)
 	thermal_zone_device_update(data->ti_thermal, THERMAL_EVENT_UNSPECIFIED);
 
 	dev_dbg(data->bgp->dev, "updated thermal zone %s\n",
-		data->ti_thermal->type);
+		thermal_zone_device_type(data->ti_thermal));
 }
 
 /**
-- 
2.34.1

