Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0FC2800D5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbgJAOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:02:55 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36620 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732339AbgJAOA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0Nsh001671;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0NMa011159;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0Lit011158;
        Thu, 1 Oct 2020 17:00:21 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 00/16] Add devlink reload action and limit options
Date:   Thu,  1 Oct 2020 16:59:03 +0300
Message-Id: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new options on devlink reload API to enable the user to select
the reload action required and constrains limits on these actions that he
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
However, if reload limit is selected, the driver should perform only if
it can do it while keeping the limit constrains.
Reload limit added:
  no_reset: No reset allowed, no down time allowed, no link flap and no
            configuration is lost.

Each driver which supports devlink reload command should expose the
reload actions and limits supported.

Add reload stats to hold the history per reload action per limit.
For example, the number of times fw_activate has been done on this
device since the driver module was added or if the firmware activation
was done with or without reset.

Change log: Preceding to this version were 5 RFC versions. The changes
applied according to comments mainly from Jakub and Jiri on RFC API
patches are listed in each patch.

Patch 1 changes devlink_reload_supported() param type to enable using
        it before allocating devlink.
Patch 2-3 add the new API reload action and reload limit options to
          devlink reload.
Patch 4-5 add reload stats and remote reload stats. These stats are
          exposed through devlink dev get.
Patches 6-11 add support on mlx5 for devlink reload action fw_activate
            and handle the firmware reset events.
Patches 12-13 add devlink enable remote dev reset parameter and use it
             in mlx5.
Patches 14-15 mlx5 add devlink reload limit no_reset support for
              fw_activate reload action.
Patch 16 adds documentation file devlink-reload.rst 

Moshe Shemesh (16):
  devlink: Change devlink_reload_supported() param type
  devlink: Add reload action option to devlink reload command
  devlink: Add devlink reload limit option
  devlink: Add reload stats
  devlink: Add remote reload stats
  net/mlx5: Add functions to set/query MFRL register
  net/mlx5: Set cap for pci sync for fw update event
  net/mlx5: Handle sync reset request event
  net/mlx5: Handle sync reset now event
  net/mlx5: Handle sync reset abort event
  net/mlx5: Add support for devlink reload action fw activate
  devlink: Add enable_remote_dev_reset generic parameter
  net/mlx5: Add devlink param enable_remote_dev_reset support
  net/mlx5: Add support for fw live patch event
  net/mlx5: Add support for devlink reload limit no reset
  devlink: Add Documentation/networking/devlink/devlink-reload.rst

 .../networking/devlink/devlink-params.rst     |   6 +
 .../networking/devlink/devlink-reload.rst     |  81 +++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c     |   9 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 114 ++++-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  52 ++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 463 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  21 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  16 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  13 +-
 drivers/net/netdevsim/dev.c                   |   8 +-
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/driver.h                   |   2 +
 include/net/devlink.h                         |  21 +-
 include/uapi/linux/devlink.h                  |  42 ++
 net/core/devlink.c                            | 318 +++++++++++-
 20 files changed, 1164 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h

-- 
2.18.2

