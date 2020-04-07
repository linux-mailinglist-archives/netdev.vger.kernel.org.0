Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC251A12F6
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGRth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:49:37 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42814 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:49:37 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id 086692972A7
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
Subject: [RFC 0/8] Stop monitoring disabled devices
Date:   Tue,  7 Apr 2020 19:49:18 +0200
Message-Id: <20200407174926.23971-1-andrzej.p@collabora.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current kernel behavior is to keep polling the thermal zone devices
regardless of their current mode. This is not desired, as all such "disabled"
devices are meant to be handled by userspace, so polling them makes no sense.

There was an attempt to solve this issue:

https://lkml.org/lkml/2018/2/26/498

and it ultimately has not succeeded:

https://lkml.org/lkml/2018/2/27/910

This is a new attempt addressing all the relevant drivers, and I have
identified them with:

$ git grep "thermal_zone_device_ops" | grep "= {" | cut -f1 -d: | sort | uniq

The idea is to modify thermal_zone_device_update() and monitor_thermal_zone()
in such a way that they stop polling a disabled device. To do decide what to
do they should call ->get_mode() operation of the specialized thermal zone
device in question (e.g. drivers/acpi/thermal.c's). But here comes problem:
sometimes a thermal zone device must be initially disabled and becomes enabled
only after its sensors appear on the system. If such thermal zone's
->get_mode() /* in the context of thermal_zone_device_update() or
monitor_thermal_zone() */ is called _before_ the sensors are available, it will
be reported as "disabled" and consequently polling it will be ceased. This is
a change in behavior from userspace's perspective.

To solve the above described problem I want to introduce the third mode of a
thermal_zone_device: initial. The idea is that when the device is in its
initial mode, then its polling will be handled as it is now. This is a good
thing: should the temperature be just about hitting the critical treshnold
early during the boot process, it might be too late if we wait for the
userspace to run to save the system from overheating. The initial mode should
be reported in sysfs as "enabled" to keep the userspace interface intact.
From the initial mode there will be two possible transitions: to enabled or
disabled mode, but there will be no transition back to initial. If the
transition is from initial to enabled, then keep polling. If the transition is
from initial to disabled, then stop polling. If the transition is from enabled
to disabled, then stop polling. The transition from disabled to enabled must
be handled in a special way: there must be a mandatory call to
monitor_thermal_zone(), otherwise the polling will not start. If this
transition is triggeted from sysfs, then it can be easily handled at the
thermal framework level. However, if drivers call their own ->set_mode()
operation then they must also call "monitor_thermal_zone()" afterwards.
The latter being a sensible thing anyway, so perhaps all/most of the drivers
in question do. The plan for implementation is this:

- ensure ALL users use symbolic enum names (THERMAL_DEVICE_DISABLED,
THERMAL_DEVICE_ENABLED) for thermal device mode rather than the numeric
values of enum thermal_device_mode elements
- add THERMAL_DEVICE_INITIAL to the said enum making its value 0 (so that
kzalloc() results in the initial state)
- modify thermal zone device's mode_show() (thermal framework level) so that
it reports "enabled" for THERMAL_DEVICE_INITIAL
- modify thermal zone device's mode_store() (thermal framework level) so that
it calls monitor_thermal_zone() upon mode change
- modify ALL thermal drivers so that their code is prepared to return
THERMAL_DEVICE_INITIAL before they call thermal_zone_device_register(); when
the invocation of the latter completes then polling is expected to be started
- verify ALL drivers which call their own ->set_mode() to ensure they do call
monitor_thermal_zone() afterwards
- modify thermal_zone_device_update() and monitor_thermal_zone() so that they
cancel polling for disabled thermal zone devices (but not for those in
THERMAL_DEVICE_INITIAL mode)

This RFC series does all the above steps in more or less that order.

I kindly ask for comments/suggestions/improvements.

Rebased onto v5.6.

Andrzej Pietrasiewicz (8):
  thermal: int3400_thermal: Statically initialize
    .get_mode()/.set_mode() ops
  thermal: Properly handle mode values in .set_mode()
  thermal: Store thermal mode in a dedicated enum
  thermal: core: Introduce THERMAL_DEVICE_INITIAL
  thermal: core: Monitor thermal zone after mode change
  thermal: Set initial state to THERMAL_DEVICE_INITIAL
  thermal: of: Monitor thermal zone after enabling it
  thermal: Stop polling DISABLED thermal devices

 drivers/acpi/thermal.c                        | 28 +++++-----
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 11 +++-
 drivers/platform/x86/acerhdf.c                | 17 ++++--
 drivers/thermal/da9062-thermal.c              |  2 +-
 drivers/thermal/imx_thermal.c                 |  5 +-
 .../intel/int340x_thermal/int3400_thermal.c   | 24 ++++-----
 .../thermal/intel/intel_quark_dts_thermal.c   |  6 ++-
 drivers/thermal/of-thermal.c                  |  9 +++-
 drivers/thermal/thermal_core.c                | 52 ++++++++++++++++++-
 drivers/thermal/thermal_core.h                |  2 +
 drivers/thermal/thermal_sysfs.c               | 12 +++--
 include/linux/thermal.h                       |  3 +-
 12 files changed, 123 insertions(+), 48 deletions(-)

-- 
2.17.1

