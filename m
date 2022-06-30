Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8D560E77
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiF3BAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiF3BAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E6123BF1
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CF3DB827C4
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205A5C34114;
        Thu, 30 Jun 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550812;
        bh=kamBPqkMmyVq7y8RF8e34bLasdLkGQIKwFlrFGyy1qI=;
        h=From:To:Cc:Subject:Date:From;
        b=dJxuQ3ldpp5SemN0dJ+P4e6K4IFTmv803msD7TgtqL9MIKINXt7P6MYljfVpoVg0X
         FCcQwDOqtNF6saylaHMInrHZR3sKG2pAj+c3MmKfqkldqIaCNVucE66hiw+uKqySB6
         2a3eUCeSPFMm5m11lof1Y4oufSZQnU3DbBGqEJsn6aeoQs26+sjUfD/R1uY7gA/MFV
         zi4Re+M0NxqiATLR9F9XLN2uQPrVZEFivX3w6sJT3T3h9GuPIJa/ZeHfKP5jRM8MsO
         CTFj+a9uJZYUWvD1ngGdkTF8vzTAKSpHS+hBwXw/Xjpfbz7WFsvzkXbPE2+9vK81Ui
         MV4vPH/3S1beA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net-next 00/15] mlx5 updates 2022-06-29
Date:   Wed, 29 Jun 2022 17:59:50 -0700
Message-Id: <20220630010005.145775-1-saeed@kernel.org>
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

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 702e70143291b09e6245deb8ab904d1c18ed4f47:

  net: prestera: acl: add support for 'egress' rules (2022-06-29 14:02:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-06-29

for you to fetch changes up to 50ea3c09a2fdcb8185e3a0cb974fc93f0c0ec515:

  net/mlx5e: TC, Support offloading police action (2022-06-29 17:56:39 -0700)

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
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  | 472 +++++++++++++++++++++
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
 27 files changed, 1562 insertions(+), 149 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
