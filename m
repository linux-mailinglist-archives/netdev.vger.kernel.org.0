Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0026F6DEA23
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDLEIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDLEIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4051989
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC8E262D9E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C4EC433D2;
        Wed, 12 Apr 2023 04:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272480;
        bh=rD/2NGqnKmpl6h9DCQuUT+3q/ozauY8Tm1+36yFzv08=;
        h=From:To:Cc:Subject:Date:From;
        b=RN9hiQPXyeoOXgC2xng7rZ84XLyxuhRPbtbUJlc5vpCjJVEhCa7fJwEWTfp+EKXJg
         6Ph3mAqVc7SA2O/kXWWs42fYTIsmanv613nfZF8jtFx0urPsQ8z5gpDVrMZYXXH7FY
         ms1J2XWnLoIiphQ49pTXvhNKiWG7mOqoK2qqYJ3gPs/hiVJp/o6k3ySwimtjSQni/h
         mD9jCY+Lvc0MN7FQ1Leo8yrA/yMmm8x4BZCAUAN8bJt7vYrv/8xCAYr7Uxh/h3xxPR
         wIl/wJVeqjWAtRkaIqQrccBu38TP5Cl9zaunH1G3A8cP8utIcCJkSASx/qqLdjveRi
         cKEsgJdR+APQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-04-11
Date:   Tue, 11 Apr 2023 21:07:37 -0700
Message-Id: <20230412040752.14220-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
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

This series provides some updates to mlx5 driver
For more information please see detailed tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 4de00f0acc722f43046dca06fe1336597d1250ab:

  gve: Unify duplicate GQ min pkt desc size constants (2023-04-11 15:47:14 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-04-11

for you to fetch changes up to 108ff8215b55903545abafa198f83624a20f44c8:

  net/mlx5: DR, Add modify-header-pattern ICM pool (2023-04-11 20:57:38 -0700)

----------------------------------------------------------------
mlx5-updates-2023-04-11

1) Vlad adds the support for linux bridge multicast offload support
   Patches #1 through #9
   Synopsis

Vlad Says:
==============
Implement support of bridge multicast offload in mlx5. Handle port object
attribute SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED notification to toggle multicast
offload and bridge snooping support on bridge. Handle port object
SWITCHDEV_OBJ_ID_PORT_MDB notification to attach a bridge port to MDB.

Steering architecture

Existing offload infrastructure relies on two levels of flow tables - bridge
ingress and egress. For multicast offload the architecture is extended with
additional layer of per-port multicast replication tables. Such tables filter
loopback traffic (so packets are not replicated to their source port) and pop
VLAN headers for "untagged" VLANs. The tables are referenced by the MDB rules in
egress table. MDB egress rule can point to multiple per-port multicast tables,
which causes matching multicast traffic to be replicated to all of them, and,
consecutively, to several bridge ports:

                                                                                                                            +--------+--+
                                                                                    +---------------------------------------> Port 1 |  |
                                                                                    |                                       +-^------+--+
                                                                                    |                                         |
                                                                                    |                                         |
                                       +-----------------------------------------+  |     +---------------------------+       |
                                       | EGRESS table                            |  |  +--> PORT 1 multicast table    |       |
+----------------------------------+   +-----------------------------------------+  |  |  +---------------------------+       |
| INGRESS table                    |   |                                         |  |  |  |                           |       |
+----------------------------------+   | dst_mac=P1,vlan=X -> pop vlan, goto P1  +--+  |  | FG0:                      |       |
|                                  |   | dst_mac=P1,vlan=Y -> pop vlan, goto P1  |     |  | src_port=dst_port -> drop |       |
| src_mac=M1,vlan=X -> goto egress +---> dst_mac=P2,vlan=X -> pop vlan, goto P2  +--+  |  | FG1:                      |       |
| ...                              |   | dst_mac=P2,vlan=Y -> goto P2            |  |  |  | VLAN X -> pop, goto port  |       |
|                                  |   | dst_mac=MDB1,vlan=Y -> goto mcast P1,P2 +-----+  | ...                       |       |
+----------------------------------+   |                                         |  |  |  | VLAN Y -> pop, goto port  +-------+
                                       +-----------------------------------------+  |  |  | FG3:                      |
                                                                                    |  |  | matchall -> goto port     |
                                                                                    |  |  |                           |
                                                                                    |  |  +---------------------------+
                                                                                    |  |
                                                                                    |  |
                                                                                    |  |                                    +--------+--+
                                                                                    +---------------------------------------> Port 2 |  |
                                                                                       |                                    +-^------+--+
                                                                                       |                                      |
                                                                                       |                                      |
                                                                                       |  +---------------------------+       |
                                                                                       +--> PORT 2 multicast table    |       |
                                                                                          +---------------------------+       |
                                                                                          |                           |       |
                                                                                          | FG0:                      |       |
                                                                                          | src_port=dst_port -> drop |       |
                                                                                          | FG1:                      |       |
                                                                                          | VLAN X -> pop, goto port  |       |
                                                                                          | ...                       |       |
                                                                                          |                           |       |
                                                                                          | FG3:                      |       |
                                                                                          | matchall -> goto port     +-------+
                                                                                          |                           |
                                                                                          +---------------------------+

Patches overview:

- Patch 1 adds hardware definition bits for capabilities required to replicate
  multicast packets to multiple per-port tables. These bits are used by
  following patches to only attempt multicast offload if firmware and hardware
  provide necessary support.

- Pathces 2-4 patches are preparations and refactoring.

- Patch 5 implements necessary infrastructure to toggle multicast offload
  via SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED port object attribute notification.
  This also enabled IGMP and MLD snooping.

- Patch 6 implements per-port multicast replication tables. It only supports
  filtering of loopback packets.

- Patch 7 extends per-port multicast tables with VLAN pop support for 'untagged'
  VLANs.

- Patch 8 handles SWITCHDEV_OBJ_ID_PORT_MDB port object notifications. It
  creates MDB replication rules in egress table that can replicate packets to
  multiple per-port multicast tables.

- Patch 9 adds tracepoints for MDB events.

==============

2) Parav Create a new allocation profile for SFs, to save on memory

3) Yevgeny provides some initial patches for upcoming software steering
   support new pattern/arguments type of modify_header actions.

Starting with ConnectX-6 DX, we use a new design of modify_header FW object.
The current modify_header object allows for having only limited number of
these FW objects, which means that we are limited in the number of offloaded
flows that require modify_header action.

As a preparation Yevgeny provides the following 4 patches:
 - Patch 1: Add required mlx5_ifc HW bits
 - Patch 2, 3: Add new WQE type and opcode that is required for pattern/arg
   support and adds appropriate support in dr_send.c
 - Patch 4: Add ICM pool for modify-header-pattern objects and implement
   patterns cache, allowing patterns reuse for different flows

----------------------------------------------------------------
Parav Pandit (1):
      net/mlx5: Create a new profile for SFs

Vlad Buslov (9):
      net/mlx5: Add mlx5_ifc definitions for bridge multicast support
      net/mlx5: Bridge, increase bridge tables sizes
      net/mlx5: Bridge, move additional data structures to priv header
      net/mlx5: Bridge, extract code to lookup parent bridge of port
      net/mlx5: Bridge, snoop igmp/mld packets
      net/mlx5: Bridge, add per-port multicast replication tables
      net/mlx5: Bridge, support multicast VLAN pop
      net/mlx5: Bridge, implement mdb offload
      net/mlx5: Bridge, add tracepoints for multicast

Yevgeny Kliteynik (5):
      net/mlx5: DR, Set counter ID on the last STE for STEv1 TX
      net/mlx5: Add mlx5_ifc bits for modify header argument
      net/mlx5: Add new WQE for updating flow table
      net/mlx5: DR, Prepare sending new WQE type
      net/mlx5: DR, Add modify-header-pattern ICM pool

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   16 +
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  287 +++--
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   17 +
 .../ethernet/mellanox/mlx5/core/esw/bridge_mcast.c | 1126 ++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |  181 ++++
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |   35 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    9 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 +
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |    2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    6 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |   45 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |   41 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ptrn.c |   43 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   60 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |    7 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   11 +
 include/linux/mlx5/device.h                        |    2 +
 include/linux/mlx5/driver.h                        |    1 +
 include/linux/mlx5/mlx5_ifc.h                      |   35 +-
 include/linux/mlx5/qp.h                            |   10 +
 23 files changed, 1783 insertions(+), 164 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
