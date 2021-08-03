Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443633DF850
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHCXU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhHCXU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6840E60F94;
        Tue,  3 Aug 2021 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032817;
        bh=d8kPQtpEDWa7ruFUa66axHhNxg8jU01djjvXvM4H2o0=;
        h=From:To:Cc:Subject:Date:From;
        b=dLTjapW7kEsIziaAAyezPi+y9yXxfnam/dxvcriN0kjY9zH9UFdZ7tcqEE5bXIBHl
         DQq/NuK0MMI3+dOWqJMF3y8uH2LRvC+OVgBFQvo7/QDa2CQbvo25rDXgwsSFf8/Rom
         0oj0wZ/7rDjAQtZ4zIz3P134mlH2MHnCK2lfIrD/l92Mcb9xHAdDQk+3dw1lug1CDc
         rmPLuciFPV97itbFZlt3BDUjxekmB605bZvZy+050yKKFZcBexU8IqAOoYmmAhFoHJ
         S5G8x2T0O0bJITCITONLZx02cpouqEJcFP63TEOXJVqbP20Qhn1vmz3AqxGsc1oAuk
         zem3wXcrM0A7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 00/14] mlx5 single FDB for lag
Date:   Tue,  3 Aug 2021 16:19:45 -0700
Message-Id: <20210803231959.26513-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series is aimed at mlx5-next branch to be pulled later by both
rdma and netdev subsystems as it contains patches to both trees.

The series provides support for single shared FDB table for lag:

Shared FDB allows to direct traffic from all the vports in the HCA to a
single E-Switch, as opposed to an E-Switch per up-link, a single E-switch
will improve the lag logic as the traffic will be handled by a single point
on the device, which allows more flexibility and natural management of FDB
rules when lag is ON.

Before shared FDB in order to control traffic from a vport when lag was
ON a FDB rule had to be duplicated (on both E-switches), with single FDB
duplication is not required.

To achieve single FDB:

1) Point the ingress ACL of the slave uplink to that of the master.
   With this, wire traffic from both uplinks will reach the same eswitch
   with the same metadata where a single steering rule can catch traffic
   from both ports.
    
2) Set the FDB root flow table of the slave's eswitch to that of the
   master. As this flow table can change dynamically make sure to
   sync it on any set root flow table FDB command.
   This will make sure traffic from SFs, VFs, ECPFs and PFs reach the
   master eswitch.
    
3) Split wire traffic at the eswitch manager egress ACL so that it's
   directed to the native eswitch manager. We only treat wire traffic
   from both ports the same at the eswitch level. If such traffic wasn't
   handled in the eswitch it needs to reach the right representor to be
   processed by software. For example LACP packets should *always*
   reach the right uplink representor for correct operation.

---

Ariel Levkovich (1):
  net/mlx5: E-Switch, set flow source for send to uplink rule

Mark Bloch (11):
  net/mlx5: Return mdev from eswitch
  net/mlx5: Lag, add initial logic for shared FDB
  RDMA/mlx5: Fill port info based on the relevant eswitch
  {net, RDMA}/mlx5: Extend send to vport rules
  RDMA/mlx5: Add shared FDB support
  net/mlx5: E-Switch, Add event callback for representors
  net/mlx5: Add send to vport rules on paired device
  net/mlx5: Lag, properly lock eswitch if needed
  net/mlx5: Lag, move lag destruction to a workqueue
  net/mlx5/ E-Switch, add logic to enable shared FDB
  net/mlx5: Lag, Create shared FDB when in switchdev mode

Roi Dayan (2):
  net/mlx5e: Add an option to create a shared mapping
  net/mlx5e: Use shared mappings for restoring from metadata

 drivers/infiniband/hw/mlx5/ib_rep.c           |  77 +++-
 drivers/infiniband/hw/mlx5/main.c             |  44 +-
 drivers/infiniband/hw/mlx5/std_types.c        |  10 +-
 .../ethernet/mellanox/mlx5/core/en/mapping.c  |  45 ++
 .../ethernet/mellanox/mlx5/core/en/mapping.h  |   5 +
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  88 +++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  21 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |  16 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  36 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  38 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 383 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  58 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 267 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/eswitch.h                  |  16 +
 23 files changed, 1043 insertions(+), 93 deletions(-)

-- 
2.31.1

