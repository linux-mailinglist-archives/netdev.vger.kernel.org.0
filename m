Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313152740F7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgIVLfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:35:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45737 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726648AbgIVLfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:35:38 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 22 Sep 2020 14:35:35 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08MBZZXI014357;
        Tue, 22 Sep 2020 14:35:35 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 08MBZYTl009503;
        Tue, 22 Sep 2020 14:35:34 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08MBZRCh009499;
        Tue, 22 Sep 2020 14:35:27 +0300
From:   Aya Levin <ayal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net-next RFC v2 repost 0/3] Add devlink traps in
Date:   Tue, 22 Sep 2020 14:35:22 +0300
Message-Id: <1600774525-9461-1-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for devlink traps on per-port basis. Dropped
packets in the RX flow are related to the Ethernet port and thus
should be in port context. Traps per device should trap global
configuration which may cause drops. Devlink traps is regard as a
debug mode. Using traps per port enable debug which doesn't effect
other ports on a device.

Patchset:
Patch 1: Refactors devlink trap for easier code re-use in the coming
patches
Patch 2: Adds devlink traps under devlink port context
ports context. In a nutshell it allows enable/disable of a trap on
all related ports which registered this trap.
Patch 3: Display a use in devlink traps in port context in mlx5
ethernet driver.

Changelog:
Minor changes in cover letter
v1->v2:
Patch 1: 
-Gather only the traps lists for future code reuse. Don't
 try to reuse the traps ops.
Ptach 2: 
-Add traps lock in devlink_port
-Add devlink_port ops and in it, add the trap ops
-Add support onlty for traps and exclude groups and policy
-Add separate netlink commands for port trap get and set 
-Allow trap registration without a corresponding group
Patch 3: removed
Ptach 4: 
-Is now patch 3
-Minor changes in trap's definition
-Adjustments to trap API and ops

Aya Levin (3):
  devlink: Wrap trap related lists a trap_lists struct
  devlink: Add devlink traps under devlink_ports context
  net/mlx5e: Add devlink trap to catch oversize packets

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c |  38 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h |  14 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  48 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 include/net/devlink.h                              |  54 ++-
 include/uapi/linux/devlink.h                       |   5 +
 net/core/devlink.c                                 | 453 ++++++++++++++++++---
 9 files changed, 556 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h

-- 
2.14.1

