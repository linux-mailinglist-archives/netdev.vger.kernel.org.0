Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F625AF0B
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgIBPdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:33:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52310 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728379AbgIBPcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:32:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 2 Sep 2020 18:32:28 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 082FWSaN014692;
        Wed, 2 Sep 2020 18:32:28 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 082FWSrs026687;
        Wed, 2 Sep 2020 18:32:28 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 082FWPW4026686;
        Wed, 2 Sep 2020 18:32:25 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v1 0/4] Add devlink traps in devlink port context
Date:   Wed,  2 Sep 2020 18:32:10 +0300
Message-Id: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for devlink traps on per-port basis.
Dropped packets in the RX flow are related to the Ethernet port and
thus should be in port context. Traps per device should trap global
configuration which can cause drops. On top of that, enabling a trap
on a device level should trigger this trap on its siblings ports.
In addition, when devlink traps is enabled, it may cause a degradation
in performance. Hence devlink traps should be regard as a debug mode.
Considering that, it is preferred to encapsulate the debug mode as
much as possible and not to effect all the device.

Patchset:
Patch 1: Refactors devlink trap for easier code re-use in the coming
patches
Patch 2: Adds devlink traps under devlink port context
Patch 3: Adds a relation between traps in device context and traps in
ports context. In a nutshell it allows enable/disable of a trap on
all related ports which registered this trap.
Patch 4: Display a use in devlink traps in port context in mlx5
ethernet driver.

Aya Levin (4):
  devlink: Wrap trap related lists and ops in trap_mngr
  devlink: Add devlink traps under devlink_ports context
  devlink: Add hiererchy between traps in device level and port level
  net/mlx5e: Add devlink trap to catch oversize packets

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c |  32 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h |  13 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  41 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   5 +
 include/net/devlink.h                              |  84 ++-
 net/core/devlink.c                                 | 616 +++++++++++++++++----
 9 files changed, 665 insertions(+), 141 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h

-- 
2.14.1

