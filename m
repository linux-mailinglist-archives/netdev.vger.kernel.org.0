Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8179133E25C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCPXv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCPXvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D637764F0C;
        Tue, 16 Mar 2021 23:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938676;
        bh=fbhkgjjs/XzaMmmmxYe9w5a0A/QEp5hx3ZJlK7hSyu4=;
        h=From:To:Cc:Subject:Date:From;
        b=CVa5iJwhhI3odPFBRHR0R8vsqNFDUFxsfHsrLAHoe4p+ucqBj3ByVeIvRkwIAAFFY
         71aMEAR4swO2c1HpnSn5wPqsOoxdcaQFG7NRlbzYrLTslUtt7Yrw0ooiU1p83WK7nx
         DY1yLipR4XijcZfrgRKS9OtfQscZllZZ8dc/gzOc+BKkFsg5zG2sV8eZo9t0OQ4t9c
         iBGqokhLDpPij81+lq25HA/Jzj/pHLpI0wzv2t/kHLWxpxfp/rPs3kfb6s2JOL5RrO
         nQkZ8XecVfLifwPoie1HJqG6KDk0XK8OpqlYLkx8J8C/Rcmpj9Sateb3+yR/S+TMqC
         rSQFpf82FJOHA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-03-16
Date:   Tue, 16 Mar 2021 16:50:57 -0700
Message-Id: <20210316235112.72626-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This patchset refactors mlx5 Switchdev uplink representor to use the
same netdev as the NIC native mode.

Please note there is one trivial non-mlx5 patch in this series:
net: Change dev parameter to const in netif_device_present()
all the others are pure mlx5 changes.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 5a30833b9a16f8d1aa15de06636f9317ca51f9df:

  net: dsa: mt7530: support MDB and bridge flag operations (2021-03-16 11:54:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-16

for you to fetch changes up to 7dc84de98babc709910947b24e8cd1c2e01c7857:

  net/mlx5: E-Switch, Protect changing mode while adding rules (2021-03-16 16:48:43 -0700)

----------------------------------------------------------------
mlx5-updates-2021-03-16

mlx5 uplink representor netdev persistence.

Before this patchset we used to have separate netdevs for Native NIC mode
and Switchdev mode (uplink representor netdev), meaning that if user
switches modes between Native to Switchdev and vice versa, the driver
would cleanup the current netdev representor and create a new one for the
new mode, such behavior created an administrative nightmare for users,
where users need to be aware of such loss of both data path and control
path configurations, e.g. netdev attributes and arp/route tables,
where the later is more painful.

A simple solution for this is not to replace the netdev in first place
and use a single netdev to serve the uplink/physical port whether it is
in switchdev mode or native mode.

We already have different HW profiles for each netdev mode, in this series
we just replace the HW profile on the fly and we keep the same netdev
attached.

Refactoring: Some refactoring has been made to overcome some technical
difficulties
1) The netdev is created with the maximum amount of tx/rx queues to serve
the two profiles.

2) Some ndos are not supported in some modes, so we added a mode check for
   such cases, e.g legacy sriov ndos must be blocked in switchdev mode.

3) Some mlx5 netdev private attributes need to be moved out of profiles
   and kept in a persistent place, where the netdev is created
   e.g devlink port and other global HW resources

4) The netdev devlink port is now always registered with the switch id

Implementation: the last three patches implement the mechanism now as the
netdev can be shared.

5) Don't recreate the netdev on switchdev mode changes
6) Prevent changing switchdev mode when some netdev operations
are active, mostly when TC rules are being processed.
This is required since the netdev is kept registered while switchdev mode
can be changed.

----------------------------------------------------------------
Roi Dayan (14):
      net: Change dev parameter to const in netif_device_present()
      net/mlx5e: Allow legacy vf ndos only if in legacy mode
      net/mlx5e: Distinguish nic and esw offload in tc setup block cb
      net/mlx5e: Add offload stats ndos to nic netdev ops
      net/mlx5e: Use nic mode netdev ndos and ethtool ops for uplink representor
      net/mlx5e: Verify dev is present in some ndos
      net/mlx5e: Move devlink port register and unregister calls
      net/mlx5e: Register nic devlink port with switch id
      net/mlx5: Move mlx5e hw resources into a sub object
      net/mlx5: Move devlink port from mlx5e priv to mlx5e resources
      net/mlx5e: Unregister eth-reps devices first
      net/mlx5e: Do not reload ethernet ports when changing eswitch mode
      net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore
      net/mlx5: E-Switch, Protect changing mode while adding rules

Saeed Mahameed (1):
      net/mlx5e: Same max num channels for both nic and uplink profiles

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |  38 ++-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   6 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 114 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 286 ++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 138 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  18 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  51 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   9 +
 include/linux/mlx5/driver.h                        |  12 +-
 include/linux/netdevice.h                          |   2 +-
 25 files changed, 502 insertions(+), 276 deletions(-)
