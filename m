Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8416D697075
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjBNWOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBNWOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EDE46B7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF8E61941
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC8AC433D2;
        Tue, 14 Feb 2023 22:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412846;
        bh=5O8b3gTTUdCbt47gbbmbX0fzuSpRgUSop6MntukwIYA=;
        h=From:To:Cc:Subject:Date:From;
        b=clmDZD8MuTAzHiutMpOx0+4SKPpPnev5F4+bEMmYLck+UXPRfGnef+sXHk3s4lF5L
         dUNk6V0ULiO5h194ZZo823XsQ9dU34Zf2kdKyuWLa4U8FvbncJSNpGlMYeGYJZsNT1
         A9W2WI0jB2SvzafVtoVC0kvh84NrppmlqdsFgBgY4anIqlvMn/y7xhwJmDxNdBNcrX
         BvRpB6GGugOIfGSu28hcUl3D5cWECrrF42f3Txv5hl0275cVh/w9cN5xeODxnGdQhH
         E1ceu3IvQQ23ZVaYQlaatymdVUBG/dJ90PZV1eIofsAHyleST6JnoHdxVvrZBvW26C
         h3mYzm2j0VJ/A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next V2 00/15] mlx5 updates 2023-02-10
Date:   Tue, 14 Feb 2023 14:12:24 -0800
Message-Id: <20230214221239.159033-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds multi port shared eswitch support and some devlink
and auxiliary device management improvements in mlx5.

V1->V2:
 - improved documentation as suggested by Jakub.
 - Early return in mlx5_devlink_esw_multiport_set, per Alex Lobakin's
   comment.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 2edd92570441dd33246210042dc167319a5cf7e3:

  devlink: don't allow to change net namespace for FW_ACTIVATE reload action (2023-02-14 14:04:21 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-10

for you to fetch changes up to 72ed5d5624af384eaf74d84915810d54486a75e2:

  net/mlx5: Suspend auxiliary devices only in case of PCI device suspend (2023-02-14 14:08:27 -0800)

----------------------------------------------------------------
mlx5-updates-2023-02-10

1) From Roi and Mark: MultiPort eswitch support

MultiPort E-Switch builds on newer hardware's capabilities and introduces
a mode where a single E-Switch is used and all the vports and physical
ports on the NIC are connected to it.

The new mode will allow in the future a decrease in the memory used by the
driver and advanced features that aren't possible today.

This represents a big change in the current E-Switch implantation in mlx5.
Currently, by default, each E-Switch manager manages its E-Switch.
Steering rules in each E-Switch can only forward traffic to the native
physical port associated with that E-Switch. While there are ways to target
non-native physical ports, for example using a bond or via special TC
rules. None of the ways allows a user to configure the driver
to operate by default in such a mode nor can the driver decide
to move to this mode by default as it's user configuration-driven right now.

While MultiPort E-Switch single FDB mode is the preferred mode, older
generations of ConnectX hardware couldn't support this mode so it was never
implemented. Now that there is capable hardware present, start the
transition to having this mode by default.

Introduce a devlink parameter to control MultiPort Eswitch single FDB mode.
This will allow users to select this mode on their system right now
and in the future will allow the driver to move to this mode by default.

2) From Jiri: Improvements and fixes for mlx5 netdev's devlink logic
 2.1) Cleanups related to mlx5's devlink port logic
 2.2) Move devlink port registration to be done before netdev alloc
 2.3) Create auxdev devlink instance in the same ns as parent devlink
 2.4) Suspend auxiliary devices only in case of PCI device suspend

----------------------------------------------------------------
Jiri Pirko (8):
      net/mlx5: Remove outdated comment
      net/mlx5e: Pass mdev to mlx5e_devlink_port_register()
      net/mlx5e: Replace usage of mlx5e_devlink_get_dl_port() by netdev->devlink_port
      net/mlx5e: Move dl_port to struct mlx5e_dev
      net/mlx5e: Move devlink port registration to be done before netdev alloc
      net/mlx5e: Create auxdev devlink instance in the same ns as parent devlink
      net/mlx5: Remove "recovery" arg from mlx5_load_one() function
      net/mlx5: Suspend auxiliary devices only in case of PCI device suspend

Mark Bloch (1):
      net/mlx5: Lag, Add single RDMA device in multiport mode

Roi Dayan (6):
      net/mlx5: Lag, Control MultiPort E-Switch single FDB mode
      net/mlx5e: TC, Add peer flow in mpesw mode
      net/mlx5: E-Switch, rename bond update function to be reused
      net/mlx5: Lag, set different uplink vport metadata in multiport eswitch mode
      net/mlx5e: Use a simpler comparison for uplink rep
      net/mlx5e: TC, Remove redundant parse_attr argument

 Documentation/networking/devlink/mlx5.rst          |  18 +++
 drivers/infiniband/hw/mlx5/ib_rep.c                |  18 ++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  58 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |  34 +++--
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   9 --
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  26 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  35 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  32 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   6 -
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    | 144 ++++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |  15 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  25 ++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   8 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   2 +-
 include/linux/mlx5/driver.h                        |   3 +-
 32 files changed, 334 insertions(+), 182 deletions(-)
