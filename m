Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215FA2F345F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391605AbhALPnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:43:06 -0500
Received: from gloria.sntech.de ([185.11.138.130]:34764 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbhALPnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 10:43:05 -0500
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1kzLnL-00089O-PO; Tue, 12 Jan 2021 16:41:19 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] time64.h: Consolidated PSEC_PER_SEC definition
Date:   Tue, 12 Jan 2021 16:41:18 +0100
Message-ID: <2525970.q0ZmV6gNhb@diego>
In-Reply-To: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
References: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 12. Januar 2021, 16:37:09 CET schrieb Andy Shevchenko:
> We have currently three users of the PSEC_PER_SEC each of them defining it
> individually. Instead, move it to time64.h to be available for everyone.
> 
> There is a new user coming with the same constant in use. It will also
> make its life easier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_ptp.c           | 2 ++
>  drivers/phy/phy-core-mipi-dphy.c                 | 2 --
>  drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c | 8 ++++----

for the Rockchip-part:
Acked-by: Heiko Stuebner <heiko@sntech.de>

though not sure if that reordering of other includes should be in there
or separate. Don't have a hard opinion, and will let others decide ;-)


Heiko

>  include/soc/mscc/ocelot_ptp.h                    | 2 --
>  include/vdso/time64.h                            | 1 +
>  5 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
> index a33ab315cc6b..87ad2137ba06 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
> @@ -4,6 +4,8 @@
>   * Copyright (c) 2017 Microsemi Corporation
>   * Copyright 2020 NXP
>   */
> +#include <linux/time64.h>
> +
>  #include <soc/mscc/ocelot_ptp.h>
>  #include <soc/mscc/ocelot_sys.h>
>  #include <soc/mscc/ocelot.h>
> diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
> index 14e0551cd319..77fe65367ce5 100644
> --- a/drivers/phy/phy-core-mipi-dphy.c
> +++ b/drivers/phy/phy-core-mipi-dphy.c
> @@ -12,8 +12,6 @@
>  #include <linux/phy/phy.h>
>  #include <linux/phy/phy-mipi-dphy.h>
>  
> -#define PSEC_PER_SEC	1000000000000LL
> -
>  /*
>   * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
>   * from the valid ranges specified in Section 6.9, Table 14, Page 41
> diff --git a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
> index 8af8c6c5cc02..347dc79a18c1 100644
> --- a/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
> +++ b/drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c
> @@ -11,16 +11,16 @@
>  #include <linux/clk-provider.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
> +#include <linux/mfd/syscon.h>
>  #include <linux/module.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/reset.h>
> +#include <linux/time64.h>
> +
>  #include <linux/phy/phy.h>
>  #include <linux/phy/phy-mipi-dphy.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/mfd/syscon.h>
> -
> -#define PSEC_PER_SEC	1000000000000LL
>  
>  #define UPDATE(x, h, l)	(((x) << (l)) & GENMASK((h), (l)))
>  
> diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
> index 6a7388fa7cc5..ded497d72bdb 100644
> --- a/include/soc/mscc/ocelot_ptp.h
> +++ b/include/soc/mscc/ocelot_ptp.h
> @@ -37,8 +37,6 @@ enum {
>  
>  #define PTP_CFG_MISC_PTP_EN		BIT(2)
>  
> -#define PSEC_PER_SEC			1000000000000LL
> -
>  #define PTP_CFG_CLK_ADJ_CFG_ENA		BIT(0)
>  #define PTP_CFG_CLK_ADJ_CFG_DIR		BIT(1)
>  
> diff --git a/include/vdso/time64.h b/include/vdso/time64.h
> index 9d43c3f5e89d..b40cfa2aa33c 100644
> --- a/include/vdso/time64.h
> +++ b/include/vdso/time64.h
> @@ -9,6 +9,7 @@
>  #define NSEC_PER_MSEC	1000000L
>  #define USEC_PER_SEC	1000000L
>  #define NSEC_PER_SEC	1000000000L
> +#define PSEC_PER_SEC	1000000000000LL
>  #define FSEC_PER_SEC	1000000000000000LL
>  
>  #endif /* __VDSO_TIME64_H */
> 




