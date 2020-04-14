Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09CD1A8829
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503183AbgDNSBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:01:23 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46626 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730908AbgDNSBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:01:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 5A7222A1BDC
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
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Subject: [RFC v2 0/9] Stop monitoring disabled devices
Date:   Tue, 14 Apr 2020 20:00:56 +0200
Message-Id: <20200414180105.20042-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second iteration of this RFC.

The series now focuses on cleaning up the code in the first place.

After the cleanups in patches 1-3 struct thermal_zone_device is extended
so that it contains a "mode" member (patch 4/9).

The next patch (5/9) makes all thermal zone devices use the "mode" member.
This patch makes drivers' ->get_mode() methods redundant, so the next one
(6/9) removes the method altogether.

Patches 7-8/9 ensure that after changing thermal zone device's mode
an attempt will be made to monitor the device.

And finally patch 9/9 prevents DISABLED devices from being monitored.
It also adds THERMAL_DEVICE_INITIAL to accommodate the devices, which
should be monitored but cannot be initially ENABLED.

Andrzej Pietrasiewicz (9):
  thermal: int3400_thermal: Statically initialize
    .get_mode()/.set_mode() ops
  thermal: Eliminate an always-false condition
  thermal: Properly handle mode values in .set_mode()
  thermal: core: Let thermal zone device's mode be stored in its struct
  thermal: Store mode in thermal_zone_device
  thermal: Remove get_mode() method
  thermal: core: Monitor thermal zone after mode change
  thermal: of: Monitor thermal zone after enabling it
  thermal: core: Stop polling DISABLED thermal devices

 drivers/acpi/thermal.c                        | 44 +++++----------
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 43 ++++-----------
 drivers/platform/x86/acerhdf.c                | 28 +++++-----
 drivers/thermal/da9062-thermal.c              | 12 +---
 drivers/thermal/imx_thermal.c                 | 30 ++++------
 .../intel/int340x_thermal/int3400_thermal.c   | 39 +++----------
 .../thermal/intel/intel_quark_dts_thermal.c   | 27 ++++-----
 drivers/thermal/of-thermal.c                  | 28 ++++------
 drivers/thermal/thermal_core.c                | 40 ++++++++++++--
 drivers/thermal/thermal_core.h                |  2 +
 drivers/thermal/thermal_sysfs.c               | 40 ++++----------
 include/linux/thermal.h                       | 55 ++++++++++++++++++-
 12 files changed, 180 insertions(+), 208 deletions(-)

-- 
2.17.1

