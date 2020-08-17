Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C94246378
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgHQJiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:38:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55828 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728268AbgHQJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:38:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cBsk011397;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cBcc003224;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9c8eu003223;
        Mon, 17 Aug 2020 12:38:08 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 00/13] Add devlink reload action option
Date:   Mon, 17 Aug 2020 12:37:39 +0300
Message-Id: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new option on devlink reload API to enable the user to select the
reload action required. Complete support for all actions in mlx5.
The following reload actions are supported:
  fw_live_patch: firmware live patching.
  driver_reinit: driver entities re-initialization, applying devlink-params
                 and devlink-resources values.
  fw_activate: firmware activate.

Each driver which support this command should expose the reload actions
supported.
The uAPI is backward compatible, if the reload action option is omitted
from the reload command, the driver reinit action will be used.
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities.

Patch 1 adds the new API reload action option to devlink.
Patch 2 exposes the supported reload actions on devlink dev get.
Patches 3-8 add support on mlx5 for devlink reload action fw_activate
            and handle the firmware reset events.
Patches 9-10 add devlink enable remote dev reset parameter and use it
             in mlx5.
Patches 11-12 mlx5 add devlink reload live patch support and event
              handling.
Patch 13 adds documentation file devlink-reload.rst 

Command examples:

# Run reload command with fw activate reload action:
$ devlink dev reload pci/0000:82:00.0 action fw_activate

# Run reload command with driver reload action:
$ devlink dev reload pci/0000:82:00.0 action driver_reinit

# Run reload command with fw live patch reload action:
$ devlink dev reload pci/0000:82:00.0 action fw_live_patch

v1 -> v2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
- Remove driver default level, the action driver_reinit is the default
  action for all drivers 


Moshe Shemesh (13):
  devlink: Add reload action option to devlink reload command
  devlink: Add supported reload actions to dev get
  net/mlx5: Add functions to set/query MFRL register
  net/mlx5: Set cap for pci sync for fw update event
  net/mlx5: Handle sync reset request event
  net/mlx5: Handle sync reset now event
  net/mlx5: Handle sync reset abort event
  net/mlx5: Add support for devlink reload action fw activate
  devlink: Add enable_remote_dev_reset generic parameter
  net/mlx5: Add devlink param enable_remote_dev_reset support
  net/mlx5: Add support for fw live patch event
  net/mlx5: Add support for devlink reload action live patch
  devlink: Add Documentation/networking/devlink/devlink-reload.rst

 .../networking/devlink/devlink-params.rst     |   6 +
 .../networking/devlink/devlink-reload.rst     |  54 +++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 104 +++-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 448 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   6 +-
 drivers/net/netdevsim/dev.c                   |   5 +-
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   4 +
 include/net/devlink.h                         |   9 +-
 include/uapi/linux/devlink.h                  |  20 +
 net/core/devlink.c                            |  84 +++-
 20 files changed, 812 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h

-- 
2.17.1

