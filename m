Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B6420B76E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgFZRiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:38:08 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52296 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgFZRiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:38:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 51D132A5D3D
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
Subject: [PATCH v5 00/11] Stop monitoring disabled devices
Date:   Fri, 26 Jun 2020 19:37:44 +0200
Message-Id: <20200626173755.26379-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
References: <9cbffad6-69e4-0b33-4640-fde7c4f6a6e7@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A respin of v4 with these changes:

v4..v5:

- EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL (Daniel)
- dropped unnecessary thermal_zone_device_enable() in int3400_thermal.c
and in thermal_of.c (Bartlomiej)

Andrzej Pietrasiewicz (11):
  acpi: thermal: Fix error handling in the register function
  thermal: Store thermal mode in a dedicated enum
  thermal: Add current mode to thermal zone device
  thermal: Store device mode in struct thermal_zone_device
  thermal: remove get_mode() operation of drivers
  thermal: Add mode helpers
  thermal: Use mode helpers in drivers
  thermal: Explicitly enable non-changing thermal zone devices
  thermal: core: Stop polling DISABLED thermal devices
  thermal: Simplify or eliminate unnecessary set_mode() methods
  thermal: Rename set_mode() to change_mode()

 drivers/acpi/thermal.c                        | 75 +++++----------
 .../ethernet/chelsio/cxgb4/cxgb4_thermal.c    |  8 ++
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 91 ++++---------------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c   |  9 +-
 drivers/platform/x86/acerhdf.c                | 33 +++----
 drivers/platform/x86/intel_mid_thermal.c      |  6 ++
 drivers/power/supply/power_supply_core.c      |  9 +-
 drivers/thermal/armada_thermal.c              |  6 ++
 drivers/thermal/da9062-thermal.c              | 16 +---
 drivers/thermal/dove_thermal.c                |  6 ++
 drivers/thermal/hisi_thermal.c                |  6 +-
 drivers/thermal/imx_thermal.c                 | 57 ++++--------
 .../intel/int340x_thermal/int3400_thermal.c   | 38 ++------
 .../int340x_thermal/int340x_thermal_zone.c    |  5 +
 drivers/thermal/intel/intel_pch_thermal.c     |  5 +
 .../thermal/intel/intel_quark_dts_thermal.c   | 34 ++-----
 drivers/thermal/intel/intel_soc_dts_iosf.c    |  3 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  6 ++
 drivers/thermal/kirkwood_thermal.c            |  7 ++
 drivers/thermal/rcar_thermal.c                |  9 +-
 drivers/thermal/rockchip_thermal.c            |  6 +-
 drivers/thermal/spear_thermal.c               |  7 ++
 drivers/thermal/sprd_thermal.c                |  6 +-
 drivers/thermal/st/st_thermal.c               |  5 +
 drivers/thermal/thermal_core.c                | 76 ++++++++++++++--
 drivers/thermal/thermal_of.c                  | 41 +--------
 drivers/thermal/thermal_sysfs.c               | 37 +-------
 include/linux/thermal.h                       | 19 +++-
 28 files changed, 275 insertions(+), 351 deletions(-)


base-commit: 48778464bb7d346b47157d21ffde2af6b2d39110
-- 
2.17.1

