Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700F7213225
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgGCD2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:28:17 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33583 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbgGCD2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:28:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 3 Jul 2020 06:28:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0633SEnp006777;
        Fri, 3 Jul 2020 06:28:14 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 0633SEk3006654;
        Fri, 3 Jul 2020 06:28:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 0633SEDZ006653;
        Fri, 3 Jul 2020 06:28:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 0/7] Add devlink-health support for devlink ports
Date:   Fri,  3 Jul 2020 06:27:31 +0300
Message-Id: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for devlink health reporters on per-port basis. First
part in the series prepares common functions parts for health reporter
implementation. Second introduces required API to devlink-health and
mlx5e ones demonstrate its usage and effectively implement the feature
for mlx5 driver.
The per-port reporter functionality is achieved by adding a list of
devlink_health_reporters to devlink_port struct in a manner similar to
existing device infrastructure. This is the only major difference and
it makes possible to fully reuse device reporters operations.
The effect will be seen in conjunction with iproute2 additions and
will affect all devlink health commands. User can distinguish between
device and port reporters by looking at a devlink handle. Port reporters
have a port index at the end of the address and such addresses can be
provided as a parameter in every place where devlink-health accepted it.
These can be obtained from devlink port show command.
For example:
$ devlink health show
pci/0000:00:0a.0:
  reporter fw
    state healthy error 0 recover 0 auto_dump true
pci/0000:00:0a.0/1:
  reporter tx
    state healthy error 0 recover 0 grace_period 500 auto_recover true auto_dump true
$ devlink health set pci/0000:00:0a.0/1 reporter tx grace_period 1000 \
auto_recover false auto_dump false
$ devlink health show pci/0000:00:0a.0/1 reporter tx
pci/0000:00:0a.0/1:
  reporter tx
    state healthy error 0 recover 0 grace_period 1000 auto_recover flase auto_dump false

Changes v1 -> v2:
Fixed functions comment to match parameters list.

Vladyslav Tarasiuk (7):
  devlink: Refactor devlink health reporter constructor
  devlink: Rework devlink health reporter destructor
  devlink: Create generic devlink health reporter search function
  devlink: Implement devlink health reporters on per-port basis
  devlink: Add devlink health port reporters API
  net/mlx5e: Move devlink port register and unregister calls
  net/mlx5e: Move devlink-health rx and tx reporters to devlink port

 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   9 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  15 +-
 include/net/devlink.h                              |  11 +
 net/core/devlink.c                                 | 244 ++++++++++++++++-----
 5 files changed, 216 insertions(+), 76 deletions(-)

-- 
1.8.3.1

