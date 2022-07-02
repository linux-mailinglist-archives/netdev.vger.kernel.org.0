Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F27C56424B
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbiGBTE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGBTEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123515FF1
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4C4160BB5
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D53C34114;
        Sat,  2 Jul 2022 19:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788661;
        bh=vUrRpWSN1tFLKBoc+fpLYLgyo/sFG9B/qnlCWm5u4nQ=;
        h=From:To:Cc:Subject:Date:From;
        b=pBjwW06SM0WhOf4r63yTwLKOd0Ac8x7tP1CnOGJn0BkMKu2M9VY6zMqP2mP4FpD6I
         yF3drDUZTprUmsI9Q4vOjIly0t0Zddx07X2jkMAqGqFzLoL51VRpzZ6VOq9M8eqAfw
         VQyYpurGsSDC45BECetBUHQsKixd4e5fbjPtzzEGXroGCueTd/1FW8KP7QR3sxcciA
         G79lW0K3yP12oN7c7KeNe4z/Z13Mf+rSITdJLk900s8YL7BCff5p+AjKfzhlqF2Elg
         EAeG4c1q/9anzxfD6prWt4Y8xlX8cAXGP5k1pBcHnAJzhe4AD2P/C/aolktkTD8tcR
         2n3TDdVC684UQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net-next v2 00/15] mlx5 updates 2022-06-29
Date:   Sat,  2 Jul 2022 12:01:58 -0700
Message-Id: <20220702190213.80858-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds provides two sets of updates to mlx5 driver:

1) Remove dependency between sriov and eswitch mode.
   Disabling/Enabling SRIOV won't affect eswitch mode.
2) Support offloading TC police meter action

v1->v2:
 - Fix build break cause by patch #9.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 8e60a041e4782189486bab8e0f542325b8f4b7d5:

  Merge branch 'lan937x-dsa-driver' (2022-07-02 16:34:05 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-06-29

for you to fetch changes up to a8d52b024d6d39bb1c3caf8f2b4cf7ca94b4e2ec:

  net/mlx5e: TC, Support offloading police action (2022-07-02 11:58:29 -0700)

----------------------------------------------------------------
mlx5-updates-2022-06-29

Chris Mi Says:
==============
Remove dependency between sriov and eswitch mode

Currently, there are three eswitch modes, none, legacy and
switchdev. None is the default mode. And when disabling sriov,
current eswitch mode will be changed to none. This patchset
removes eswitch mode none and also removes dependency between
sriov and eswitch mode. With this patchset, there are two
behavior changes:

Original behavior
-----------------
 - When driver is loaded without sriov enabled, none is the default
   mode. But actually eswitch mode should be either legacy or
   switchdev, so devlink will return unsupported when showing
   eswitch mode.
 - When disabling sriov in either legacy or switchdev mode, eswitch
   mode will be changed to none.

New behavior
------------
 - When driver is loaded, legacy will be the default mode.
 - When disabling sriov in either legacy or switchdev mode, eswitch
   mode will not be changed.

Jianbo Liu Says:
================
Add support offloading police action

This patchset supports offloading police action by flow meter ASO
object in hardware.

The first part is to add interfaces to create and destroy flow meter
ASO object, and modify meter parameters by ACCESS_ASO WQE. As multiple
objects are created at a time, and two meters are in one object,
bitmaps are used manage these meters in one creation.

Then the police action can be mapped to a meter by the action index.
After mlx5e tc action refactoring was merged and post_act table was
added, a simple tc flow with one police action is broken down into two
rules in hardware. One rule with the original match in the original
table, which performs a metadata rewrite and do metering, then jumps
to post_meter table. The second rule is placed in the post_act table
with all the actions left.

The rules in post_meter table match on the meter outcome. If the
outcome is GREEN, we merely jump back to the post_act table for
further processing. Otherwise, the outcome is RED, and we drop the
packet.

The last part is to support flow meter ASO object in sw steering.

----------------------------------------------------------------
Chris Mi (4):
      net/mlx5: E-switch, Introduce flag to indicate if vport acl namespace is created
      net/mlx5: E-switch, Introduce flag to indicate if fdb table is created
      net/mlx5: E-switch, Remove dependency between sriov and eswitch mode
      net/mlx5: E-switch: Change eswitch mode only via devlink command

Dan Carpenter (1):
      net/mlx5: delete dead code in mlx5_esw_unlock()

Jianbo Liu (9):
      net/mlx5: Add support to create SQ and CQ for ASO
      net/mlx5: Implement interfaces to control ASO SQ and CQ
      net/mlx5e: Prepare for flow meter offload if hardware supports it
      net/mlx5e: Add support to modify hardware flow meter parameters
      net/mlx5e: Get or put meter by the index of tc police action
      net/mlx5e: Add generic macros to use metadata register mapping
      net/mlx5e: Add post meter table for flow metering
      net/mlx5e: Add flow_action to parse state
      net/mlx5e: TC, Support offloading police action

Leon Romanovsky (1):
      net/mlx5: Delete ipsec_fs header file as not used

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   7 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  61 +++
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  | 473 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |  60 +++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c | 198 +++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |  27 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   6 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |  21 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  71 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 113 +++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  21 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  69 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  | 433 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |  87 ++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   3 +-
 include/linux/mlx5/eswitch.h                       |   8 +-
 27 files changed, 1563 insertions(+), 149 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
