Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F326846E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgINGJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:09:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59450 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgINGIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:08:24 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 14 Sep 2020 09:08:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08E68EpK020931;
        Mon, 14 Sep 2020 09:08:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08E68EZA017379;
        Mon, 14 Sep 2020 09:08:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08E68CnZ017376;
        Mon, 14 Sep 2020 09:08:12 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v4 00/15] Add devlink reload action and
Date:   Mon, 14 Sep 2020 09:07:47 +0300
Message-Id: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new options on devlink reload API to enable the user to select
the reload action required and contrains limits on these actions that he
may want to ensure. Complete support for reload actions in mlx5.
The following reload actions are supported:
  driver_reinit: driver entities re-initialization, applying devlink-param
                 and devlink-resource values.
  fw_activate: firmware activate.

The uAPI is backward compatible, if the reload action option is omitted
from the reload command, the driver reinit action will be used.
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities. Therefore, the devlink
reload command returns the actions which were actually performed.

By default reload actions are not limited and driver implementation may
include reset or downtime as needed to perform the actions.
However, if limit_level is selected, the driver should perform only if
it can do it while keeping the limit level constrains.
Reload action limit level added:
  no_reset: No reset allowed, no down time allowed, no link flap and no
            configuration is lost.

Each driver which supports devlink reload command should expose the
reload actions and limit levels supported.

Add reload action stats to hold the history per reload action per limit
level. For example, the number of times fw_activate has been done on
this device since the driver module was added or if the firmware
activation was done with or without reset.

Patch 1-2 add the new API reload action and reload action limit level
          option to devlink reload.
Patch 3 adds reload actions stats.
Patch 4 exposes the reload actions stats on devlink dev get.
Patches 5-10 add support on mlx5 for devlink reload action fw_activate
            and handle the firmware reset events.
Patches 11-12 add devlink enable remote dev reset parameter and use it
             in mlx5.
Patches 13-14 mlx5 add devlink reload action limit level no_reset
              support for fw_activate reload action.
Patch 14 adds documentation file devlink-reload.rst 

Moshe Shemesh (15):
  devlink: Add reload action option to devlink reload command
  devlink: Add reload action limit level
  devlink: Add reload action stats
  devlink: Add reload actions stats to dev get
  net/mlx5: Add functions to set/query MFRL register
  net/mlx5: Set cap for pci sync for fw update event
  net/mlx5: Handle sync reset request event
  net/mlx5: Handle sync reset now event
  net/mlx5: Handle sync reset abort event
  net/mlx5: Add support for devlink reload action fw activate
  devlink: Add enable_remote_dev_reset generic parameter
  net/mlx5: Add devlink param enable_remote_dev_reset support
  net/mlx5: Add support for fw live patch event
  net/mlx5: Add support for devlink reload action limit level no reset
  devlink: Add Documentation/networking/devlink/devlink-reload.rst

 .../networking/devlink/devlink-params.rst     |   6 +
 .../networking/devlink/devlink-reload.rst     |  80 +++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c     |  17 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 124 ++++-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 454 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  28 +-
 drivers/net/netdevsim/dev.c                   |  18 +-
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   4 +
 include/net/devlink.h                         |  20 +-
 include/uapi/linux/devlink.h                  |  39 ++
 net/core/devlink.c                            | 243 +++++++++-
 20 files changed, 1089 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h

-- 
2.17.1

