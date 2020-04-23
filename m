Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37CA1B615E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgDWQ5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:57:16 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59600 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbgDWQ5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:57:16 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 303362A0661
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
Subject: [PATCH v3 0/2] Stop monitoring disabled devices
Date:   Thu, 23 Apr 2020 18:57:03 +0200
Message-Id: <20200423165705.13585-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a3998ad2-19bc-0893-a10d-2bb5adf7d99f@samsung.com>
References: <a3998ad2-19bc-0893-a10d-2bb5adf7d99f@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third iteration of this PATCH series (not counting RFCs).
It addresses comments from Bartlomiej - thanks, Bartlomiej!

The first patch makes all the drivers store their mode in struct
thermal_zone_device. Such a move has consequences: driver-specific
variables for storing mode are not necessary. Consequently get_mode()
methods become obsolete. Then sysfs "mode" attribute stops depending
on get_mode() being provided, because it is always provided from now on.

The first patch also introduces the initial mode to be optionally passed
to thermal_zone_device_register().

Given all the groundwork done in patch 1/2 patch 2/2 becomes very simple.

I incorrectly named PATCH v2 a PATCH RESEND 1/2, so now I'm counting that
as PATCH v2, hence this series is PATCH v3.

PATCH v2..PATCH v3:
- removed redundant regmap_write() in imx_thermal_suspend() and
imx_thermal_resume() (Bartlomiej)
- removed unnecessary call to soc_dts_enable() (now called indirectly
from thermal_zone_device_register()->set_mode()) (Bartlomiej)
- removed defensive-style checks for non-existent enum values in
thermal_zone_device_set_mode() (Bartlomiej)
- change mode only if driver's set_mode() succeeded in
thermal_zone_device_set_mode() (Bartlomiej)
- don't set tz->need_update in thermal_zone_device_register() - this
was supposed to be part of PATCH v1, but was omitted (Bartlomiej)

PATCH..PATCH v2:

- fixed typo (missing semicolon in dummy thermal_zone_device_set_mode()
implementation) (kbuild test robot)
- fixed misspelled enum value in int3400_thermal_params.initial_mode

RFCv3..this PATCH:

- export thermal_zone_device_{enable|disable}() for drivers (Bartlomiej)
- don't check provided enum values in acpi's thermal_zet_mode()
and in int3400_thermal_set_mode() (Bartlomiej)
- use thermal_zone_device_enable() in of_thermal instead of open coding it
(Bartlomiej)
- use thermal_zone_device_{enable|disable}() in hisi_thermal, rockchip_thermal
and sprd_thermal (Bartlomiej)
- assume THERMAL_DEVICE_ENABLED is thermal_zone_params not provided at
tzd's register time (Bartlomiej)
- eliminated tzp-s which contain only .initial_mode = THERMAL_DEVICE_ENABLED,
(Bartlomiej)
- don't set tz->need_update and don't call thermal_zone_device_update()
at the end of thermal_zone_device_register() (Bartlomiej)
- used .initial_mode in int340x_thermal_zone, x86_pkg_temp_thermal and
int3400_thermal (Bartlomiej)

Andrzej Pietrasiewicz (2):
  thermal: core: Let thermal zone device's mode be stored in its struct
  thermal: core: Stop polling DISABLED thermal devices

 drivers/acpi/thermal.c                        | 35 ++--------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 42 ------------
 drivers/platform/x86/acerhdf.c                | 17 +----
 drivers/thermal/da9062-thermal.c              | 11 ----
 drivers/thermal/hisi_thermal.c                |  6 +-
 drivers/thermal/imx_thermal.c                 | 36 ++--------
 .../intel/int340x_thermal/int3400_thermal.c   | 31 ++-------
 .../int340x_thermal/int340x_thermal_zone.c    |  1 +
 .../thermal/intel/intel_quark_dts_thermal.c   | 30 ++-------
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  1 +
 drivers/thermal/of-thermal.c                  | 24 +------
 drivers/thermal/rockchip_thermal.c            |  6 +-
 drivers/thermal/sprd_thermal.c                |  6 +-
 drivers/thermal/thermal_core.c                | 65 +++++++++++++++----
 drivers/thermal/thermal_core.h                |  3 +
 drivers/thermal/thermal_sysfs.c               | 29 +--------
 include/linux/thermal.h                       | 22 ++++++-
 17 files changed, 119 insertions(+), 246 deletions(-)


base-commit: 79799562bf087b30d9dd0fddf5bed2d3b038be08
-- 
2.17.1

