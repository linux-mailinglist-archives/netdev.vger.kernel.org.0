Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754BE256F05
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH3P2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:28:19 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42673 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726030AbgH3P17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:27:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07UFRsRX029615;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07UFRsBe027826;
        Sun, 30 Aug 2020 18:27:54 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07UFRpAE027823;
        Sun, 30 Aug 2020 18:27:51 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v3 00/14] Add devlink reload action option 
Date:   Sun, 30 Aug 2020 18:27:20 +0300
Message-Id: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new option on devlink reload API to enable the user to select the
reload action required. Complete support for all actions in mlx5.
The following reload actions are supported:
  driver_reinit: driver entities re-initialization, applying devlink-param
                 and devlink-resource values.
  fw_activate: firmware activate.
  fw_activate_no_reset: Activate new firmware image without any reset.
                        (also known as: firmware live patching).

Each driver which support this command should expose the reload actions
supported.
The uAPI is backward compatible, if the reload action option is omitted
from the reload command, the driver reinit action will be used.
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities. Therefore, the devlink
reload command returns the actions which were actually done.

Add reload actions counters to hold the history per reload action type.
For example, the number of times fw_activate has been done on this
device since the driver module was added or if the firmware activation
was done with or without reset.

Patch 1 adds the new API reload action option to devlink.
Patch 2 adds reload actions counters.
Patch 3 exposes the reload actions counters on devlink dev get.
Patches 4-9 add support on mlx5 for devlink reload action fw_activate
            and handle the firmware reset events.
Patches 10-11 add devlink enable remote dev reset parameter and use it
             in mlx5.
Patches 12-13 mlx5 add devlink reload action fw_activate_no_reset support
              and event handling.
Patch 14 adds documentation file devlink-reload.rst 

command examples:
$devlink dev reload pci/0000:82:00.0 action driver_reinit
reload_actions_done:
  driver_reinit

$devlink dev reload pci/0000:82:00.0 action fw_activate
reload_actions_done:
  driver_reinit fw_activate

$ devlink dev reload pci/0000:82:00.0 action fw_activate no_reset
reload_actions_done:
  fw_activate_no_reset

v2 -> v3:
- Replace fw_live_patch action by fw_activate_no_reset
- Devlink reload returns the actions done over netlink reply
- Add reload actions counters

v1 -> v2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
- Remove driver default level, the action driver_reinit is the default
  action for all drivers 

Moshe Shemesh (14):
  devlink: Add reload action option to devlink reload command
  devlink: Add reload actions counters
  devlink: Add reload actions counters to dev get
  net/mlx5: Add functions to set/query MFRL register
  net/mlx5: Set cap for pci sync for fw update event
  net/mlx5: Handle sync reset request event
  net/mlx5: Handle sync reset now event
  net/mlx5: Handle sync reset abort event
  net/mlx5: Add support for devlink reload action fw activate
  devlink: Add enable_remote_dev_reset generic parameter
  net/mlx5: Add devlink param enable_remote_dev_reset support
  net/mlx5: Add support for fw live patch event
  net/mlx5: Add support for devlink reload action fw activate no reset
  devlink: Add Documentation/networking/devlink/devlink-reload.rst

 .../networking/devlink/devlink-params.rst     |   6 +
 .../networking/devlink/devlink-reload.rst     |  68 +++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c     |  14 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 117 ++++-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 453 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  24 +-
 drivers/net/netdevsim/dev.c                   |  16 +-
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   4 +
 include/net/devlink.h                         |  13 +-
 include/uapi/linux/devlink.h                  |  24 +
 net/core/devlink.c                            | 174 ++++++-
 20 files changed, 967 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h

-- 
2.17.1

