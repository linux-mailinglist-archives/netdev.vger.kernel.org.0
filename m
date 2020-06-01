Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3781EA2DF
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgFALh6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jun 2020 07:37:58 -0400
Received: from piie.net ([80.82.223.85]:41364 "EHLO piie.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgFALh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 07:37:57 -0400
Received: from mail.piie.net (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by piie.net (Postfix) with ESMTPSA id 2577E260F;
        Mon,  1 Jun 2020 13:37:52 +0200 (CEST)
Mime-Version: 1.0
Date:   Mon, 01 Jun 2020 11:37:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.11.3
From:   "=?utf-8?B?UGV0ZXIgS8Okc3RsZQ==?=" <peter@piie.net>
Message-ID: <05b890834efb5714a67a91afeabcd95d@piie.net>
Subject: Re: [PATCH v4 07/11] thermal: Use mode helpers in drivers
To:     "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <lenb@kernel.org>,
        "Vishal Kulkarni" <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Luca Coelho" <luciano.coelho@intel.com>,
        "Intel Linux Wireless" <linuxwifi@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Darren Hart" <dvhart@infradead.org>,
        "Andy Shevchenko" <andy@infradead.org>,
        "Sebastian Reichel" <sre@kernel.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Amit Kucheria" <amit.kucheria@verdurent.com>,
        "Support Opensource" <support.opensource@diasemi.com>,
        "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "=?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?=" 
        <niklas.soderlund@ragnatech.se>,
        "Heiko Stuebner" <heiko@sntech.de>,
        "Orson Zhai" <orsonzhai@gmail.com>,
        "Baolin Wang" <baolin.wang7@gmail.com>,
        "Chunyan Zhang" <zhang.lyra@gmail.com>,
        "Zhang Rui" <rui.zhang@intel.com>,
        "Allison Randal" <allison@lohutok.net>,
        "Enrico Weigelt" <info@metux.net>,
        "Gayatri Kammela" <gayatri.kammela@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        kernel@collabora.com
In-Reply-To: <20200528192051.28034-8-andrzej.p@collabora.com>
References: <20200528192051.28034-8-andrzej.p@collabora.com> <Message-ID:
 <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

28. Mai 2020 21:22, "Andrzej Pietrasiewicz" <andrzej.p@collabora.com> schrieb:

> Use thermal_zone_device_{en|dis}able() and thermal_zone_device_is_enabled().
> 
> Consequently, all set_mode() implementations in drivers:
> 
> - can stop modifying tzd's "mode" member,
> - shall stop taking tzd's lock, as it is taken in the helpers
> - shall stop calling thermal_zone_device_update() as it is called in the
> helpers
> - can assume they are called when the mode truly changes, so checks to
> verify that can be dropped
> 
> Not providing set_mode() by a driver no longer prevents the core from
> being able to set tzd's mode, so the relevant check in mode_store() is
> removed.
> 
> Other comments:
> 
> - acpi/thermal.c: tz->thermal_zone->mode will be updated only after we
> return from set_mode(), so use function parameter in thermal_set_mode()
> instead, no need to call acpi_thermal_check() in set_mode()
> - thermal/imx_thermal.c: regmap writes and mode assignment are done in
> thermal_zone_device_{en|dis}able() and set_mode() callback
> - thermal/intel/intel_quark_dts_thermal.c: soc_dts_{en|dis}able() are a
> part of set_mode() callback, so they don't need to modify tzd->mode, and
> don't need to fall back to the opposite mode if unsuccessful, as the return
> value will be propagated to thermal_zone_device_{en|dis}able() and
> ultimately tzd's member will not be changed in thermal_zone_device_set_mode().
> - thermal/of-thermal.c: no need to set zone->mode to DISABLED in
> of_parse_thermal_zones() as a tzd is kzalloc'ed so mode is DISABLED anyway
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---

[...]

> drivers/platform/x86/acerhdf.c | 17 +++++----

Acked-by: Peter Kaestle <peter@piie.net>
