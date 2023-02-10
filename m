Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303776929F3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjBJWSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjBJWSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F467E8F0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD4D61E8A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EF4C433D2;
        Fri, 10 Feb 2023 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067510;
        bh=BM6qpo1m5sKIJ7wffBb2lObfe3FcEJ2My8fsA71seks=;
        h=From:To:Cc:Subject:Date:From;
        b=PxE/iL66/d0PjJyThP6hjWhO1YG+OohvM23sitH3n0QwvGUzkfv8V3/dJJha39T49
         Oy+YDgkpHb26f3B8h/7bJhbDNNcFY0kquO9xeeOsmeNe7a2FmF5axG+CfQLeyJGGwI
         4dBsDwGU+/w+drtZ2YeoA/rp4FHO6CmC9hGCpHevTJBEvXxYyuUqzagm92oHf69ZdQ
         bDpS9Nv4X2tbDz5MDwlJi0mED1nxqgdBUjRrN71z9fMirdq8PPh9X9jadFBDKQasl5
         PW75SnHDUtlqBNUtv0JXz3grQQSRtR6JZndbf4gi22I5/+rgrrE/zOwOIcrhGrIJ1+
         T2RU5RmDf27/A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-02-10
Date:   Fri, 10 Feb 2023 14:18:06 -0800
Message-Id: <20230210221821.271571-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds multip port eswitch support and some devlink and
auxiliary device management improvements in mlx5.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 025a785ff083729819dc82ac81baf190cb4aee5c:

  net: skbuff: drop the word head from skb cache (2023-02-10 09:10:28 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-02-10

for you to fetch changes up to c1328578042eaa5d3f279ed636160dbac660daaa:

  net/mlx5: Suspend auxiliary devices only in case of PCI device suspend (2023-02-10 14:16:29 -0800)

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
      net/mlx5: Lag, Let user configure multiport eswitch
      net/mlx5e: TC, Add peer flow in mpesw mode
      net/mlx5: E-Switch, rename bond update function to be reused
      net/mlx5: Lag, set different uplink vport metadata in multiport eswitch mode
      net/mlx5e: Use a simpler comparison for uplink rep
      net/mlx5e: TC, Remove redundant parse_attr argument

 Documentation/networking/devlink/mlx5.rst          |   4 +
 drivers/infiniband/hw/mlx5/ib_rep.c                |  18 ++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  60 ++++++++-
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
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
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
 32 files changed, 321 insertions(+), 182 deletions(-)
