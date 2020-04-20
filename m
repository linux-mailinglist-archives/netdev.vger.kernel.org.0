Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A8C1B1431
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgDTSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgDTSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:17:52 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FCC061A0C;
        Mon, 20 Apr 2020 11:17:52 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 16DD62A0FEB
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
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 0/2] Stop monitoring disabled devices
Date:   Mon, 20 Apr 2020 20:17:39 +0200
Message-Id: <20200420181741.13167-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <d7efa7dd-6a07-beff-e3d1-8797dd203105@samsung.com>
References: <d7efa7dd-6a07-beff-e3d1-8797dd203105@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After 3 revisions of an RFC I'm sending this as a PATCH series.

The first patch makes all the drivers store their mode in struct
thermal_zone_device. Such a move has consequences: driver-specific
variables for storing mode are not necessary. Consequently get_mode()
methods become obsolete. Then sysfs "mode" attribute stops depending
on get_mode() being provided, because it is always provided from now on.

The first patch also introduces the initial mode to be optionally passed
to thermal_zone_device_register().

Given all the groundwork done in patch 1/2 patch 2/2 becomes very simple.

Compared to RFC v3 this series addresses comments from Bartlomiej,
thank you Bartlomiej for your review!

RFCv3..this PATCH:

- export thermal_zone_device_{enable|disable}() for drivers
- don't check provided enum values in acpi's thermal_zet_mode()
and in int3400_thermal_set_mode()
- use thermal_zone_device_enable() in of_thermal instead of open coding it
- use thermal_zone_device_{enable|disable}() in hisi_thermal, rockchip_thermal
and sprd_thermal
- assume THERMAL_DEVICE_ENABLED is thermal_zone_params not provided at
tzd's register time
- eliminated tzp-s which contain only .initial_mode = THERMAL_DEVICE_ENABLED,
- don't set tz->need_update and don't call thermal_zone_device_update()
at the end of thermal_zone_device_register()
- used .initial_mode in int340x_thermal_zone, x86_pkg_temp_thermal and
int3400_thermal

Andrzej Pietrasiewicz (2):
  thermal: core: Let thermal zone device's mode be stored in its struct
  thermal: core: Stop polling DISABLED thermal devices

 drivers/acpi/thermal.c                        | 35 ++--------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 42 ------------
 drivers/platform/x86/acerhdf.c                | 17 +----
 drivers/thermal/da9062-thermal.c              | 11 ----
 drivers/thermal/hisi_thermal.c                |  6 +-
 drivers/thermal/imx_thermal.c                 | 24 ++-----
 .../intel/int340x_thermal/int3400_thermal.c   | 31 ++-------
 .../int340x_thermal/int340x_thermal_zone.c    |  1 +
 .../thermal/intel/intel_quark_dts_thermal.c   | 22 ++-----
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  1 +
 drivers/thermal/of-thermal.c                  | 24 +------
 drivers/thermal/rockchip_thermal.c            |  6 +-
 drivers/thermal/sprd_thermal.c                |  6 +-
 drivers/thermal/thermal_core.c                | 65 ++++++++++++++++---
 drivers/thermal/thermal_core.h                |  3 +
 drivers/thermal/thermal_sysfs.c               | 29 +--------
 include/linux/thermal.h                       | 22 ++++++-
 17 files changed, 121 insertions(+), 224 deletions(-)


base-commit: 79799562bf087b30d9dd0fddf5bed2d3b038be08
-- 
2.17.1

