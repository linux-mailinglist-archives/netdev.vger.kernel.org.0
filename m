Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4F69FC72
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjBVTsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjBVTsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:48:05 -0500
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3194BDFD;
        Wed, 22 Feb 2023 11:48:03 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id s26so34987193edw.11;
        Wed, 22 Feb 2023 11:48:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xirph8ZaZs/FfoVibB+3ZRkHICfPfH3p+X5lk5hXus=;
        b=mhL3N6NRu/FNewS10bPBfhxUcxGE+YghjQr90o4UGo9fnQKRUId8N9xgBenzzgFziy
         xfbTsZ2k3CUTqGI42rMwM4J5qqlRA0kqGuVw1hJjoD9x4sS7gS4esXJ5ppRtGAjdddnC
         Q40SARBAV1vpTaY9xlXyMKNKIQzIst0gqe70OhDydUrVTnKt3BKKtjT37Skbzjm0NYVS
         8FnTMKg/wnXrmquX8OBt9DsHIWCCQ3eUFTd1YEJhiSdMH+CgELcr715jcHQQ7ewfSmAI
         e+W72taRg9U+Z2FLVFfMDcujx5unkzAwwAP55nqTIBKY2KcczyJa+IDXiTK/FuiieUWY
         W7ZA==
X-Gm-Message-State: AO0yUKWq3OlgDC2iQQs85pyW/KCH8+LT9eYAggvOqXpnBC+PbwSpjN4B
        j7qLGBMJBEcgUwWo3N3t+5zad2R21NGT+CCqmpQ=
X-Google-Smtp-Source: AK7set9kCY98R+CyM0V7JuOsXpiSKOjZhntRws2CYg4MiPUEc2u4pqQFZKOHMs/+YLxV0+q4CvfwqG60Wm+gmXE9Z/8=
X-Received: by 2002:a17:907:2076:b0:8b1:788d:1fbf with SMTP id
 qp22-20020a170907207600b008b1788d1fbfmr10129118ejb.5.1677095282047; Wed, 22
 Feb 2023 11:48:02 -0800 (PST)
MIME-Version: 1.0
References: <20230221180710.2781027-1-daniel.lezcano@linaro.org> <20230221180710.2781027-10-daniel.lezcano@linaro.org>
In-Reply-To: <20230221180710.2781027-10-daniel.lezcano@linaro.org>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Feb 2023 20:47:50 +0100
Message-ID: <CAJZ5v0idDA74D3paCmbFdb2R3Ce77Mmn5xh9Sg3smoTy6j_Mag@mail.gmail.com>
Subject: Re: [PATCH v2 09/16] thermal: Do not access 'type' field, use the tz
 id instead
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
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
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>,
        "open list:TI BANDGAP AND THERMAL DRIVER" 
        <linux-omap@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 7:08 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> The 'type' field is used as a name in the message. However we can have
> multiple thermal zone with the same type. The information is not
> accurate.
>
> Moreover, the thermal zone device structure is directly accessed while
> we want to improve the self-encapsulation of the code.
>
> Replace the 'type' in the message by the thermal zone id.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com> #mlxsw

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/thermal.c                             | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 4 ++--
>  drivers/thermal/mediatek/lvts_thermal.c            | 5 +----
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 4 ++--
>  4 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 392b73b3e269..b55a3b0ad9ed 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -842,7 +842,7 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
>                 goto acpi_bus_detach;
>
>         dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
> -                tz->thermal_zone->id);
> +                thermal_zone_device_get_id(tz->thermal_zone));
>
>         return 0;
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index 722e4a40afef..a997fca211ba 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -176,8 +176,8 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
>         }
>
>         if (crit_temp > emerg_temp) {
> -               dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
> -                        tz->tzdev->type, crit_temp, emerg_temp);
> +               dev_warn(dev, "tz id %d: Critical threshold %d is above emergency threshold %d\n",
> +                        thermal_zone_device_get_id(tz->tzdev), crit_temp, emerg_temp);
>                 return 0;
>         }
>
> diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
> index beb835d644e2..155cef8ed3f5 100644
> --- a/drivers/thermal/mediatek/lvts_thermal.c
> +++ b/drivers/thermal/mediatek/lvts_thermal.c
> @@ -304,10 +304,8 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
>          *
>          * 14-0 : Raw temperature for threshold
>          */
> -       if (low != -INT_MAX) {
> -               pr_debug("%s: Setting low limit temperature interrupt: %d\n", tz->type, low);
> +       if (low != -INT_MAX)
>                 writel(raw_low, LVTS_H2NTHRE(base));
> -       }
>
>         /*
>          * Hot temperature threshold
> @@ -318,7 +316,6 @@ static int lvts_set_trips(struct thermal_zone_device *tz, int low, int high)
>          *
>          * 14-0 : Raw temperature for threshold
>          */
> -       pr_debug("%s: Setting high limit temperature interrupt: %d\n", tz->type, high);
>         writel(raw_high, LVTS_HTHRE(base));
>
>         return 0;
> diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> index 060f46cea5ff..488b08fc20e4 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
> @@ -43,8 +43,8 @@ static void ti_thermal_work(struct work_struct *work)
>
>         thermal_zone_device_update(data->ti_thermal, THERMAL_EVENT_UNSPECIFIED);
>
> -       dev_dbg(data->bgp->dev, "updated thermal zone %s\n",
> -               data->ti_thermal->type);
> +       dev_dbg(data->bgp->dev, "updated thermal zone id %d\n",
> +               thermal_zone_device_get_id(data->ti_thermal));
>  }
>
>  /**
> --
> 2.34.1
>
