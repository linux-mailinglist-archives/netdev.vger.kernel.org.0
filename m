Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF9964195C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiLCWNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCWNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCFF2627
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E309660B9B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2107BC433C1;
        Sat,  3 Dec 2022 22:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105622;
        bh=OiZ7x2Hl4Y8/+49bcvFB2LX6Gww1E0V/cIRIcp0vg6E=;
        h=From:To:Cc:Subject:Date:From;
        b=SN0E/J5Jb43Rvf6gjO3nlOjOW/4eiUCfyZJ23Sj7ivHUF9WhYFpMBO+odAMs0laGP
         oC9B95YLeY1t5naSzTbPHnnQt6eaw3OIM8p0YbS/+5/fI38xsvZTNwzARRNjOc6hGT
         zhQL8KLJxeFOalqweo2iv/CHbK/HoYTMawS9GUy85y+VRJtAPoMkaPRz57CbvQ5+MD
         CHXW9pJA/7bPNo0VF2XruK+5PxXiSlucJihdupPAUjtdWRfd2Ik0Kro4HMWLeTf2oP
         3x0OPTqrj2UePNXYxR8QJ0mxFNgBTyBdgQRuP3M1pRxTPovixNeUmSB2ctL1rLpOex
         JGxrZ5AtrQEAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-12-03
Date:   Sat,  3 Dec 2022 14:13:22 -0800
Message-Id: <20221203221337.29267-1-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Two updates to mlx5 driver:
  1) Support tc police jump conform-exceed attribute
  2) Support 802.1ad in SRIOV VST

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 65e6af6cebefbf7d8d8ac52b71cd251c2071ad00:

  net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill (2022-12-02 21:23:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-12-03

for you to fetch changes up to aab2e7ac34c563f9f580458956799e281cf3ad48:

  net/mlx5: SRIOV, Allow ingress tagged packets on VST (2022-12-03 14:10:44 -0800)

----------------------------------------------------------------
mlx5-updates-2022-12-03

1) Support tc police jump conform-exceed attribute

The tc police action conform-exceed option defines how to handle
packets which exceed or conform to the configured bandwidth limit.
One of the possible conform-exceed values is jump, which skips over
a specified number of actions.
This series adds support for conform-exceed jump action.

The series adds platform support for branching actions by providing
true/false flow attributes to the branching action.
This is necessary for supporting police jump, as each branch may
execute a different action list.

The first five patches are preparation patches:
- Patches 1 and 2 add support for actions with no destinations (e.g. drop)
- Patch 3 refactor the code for subsequent function reuse
- Patch 4 defines an abstract way for identifying terminating actions
- Patch 5 updates action list validations logic considering branching actions

The following three patches introduce an interface for abstracting branching actions:
- Patch 6 introduces an abstract api for defining branching actions
- Patch 7 generically instantiates the branching flow attributes using the abstract API

Patch 8 adds the platform support for jump actions, by executing the following sequence:
  a. Store the jumping flow attr
  b. Identify the jump target action while iterating the actions list.
  c. Instantiate a new flow attribute after the jump target action.
     This is the flow attribute that the branching action should jump to.
  d. Set the target post action id on:
    d.1. The jumping attribute, thus realizing the jump functionality.
    d.2. The attribute preceding the target jump attr, if not terminating.

The next patches apply the platform's branching attributes to the police action:
- Patch 9 is a refactor patch
- Patch 10 initializes the post meter table with the red/green flow attributes,
           as were initialized by the platform
- Patch 11 enables the offload of meter actions using jump conform-exceed value.

2) Support 802.1ad in SRIOV VST
  2.1) Refactor ACL table creation and layout to support the new vlan mode
  2.2)  Implement 802.1ad VST when device supports push vlan and pop vlan
    steering actions on vport ACLs. In case device doesn't support these
    steering actions, fall back to setting eswitch vport context, which
    supports only 802.1q.

----------------------------------------------------------------
Moshe Shemesh (4):
      net/mlx5: SRIOV, Remove two unused ingress flow group
      net/mlx5: SRIOV, Recreate egress ACL table on config change
      net/mlx5: SRIOV, Add 802.1ad VST support
      net/mlx5: SRIOV, Allow ingress tagged packets on VST

Oz Shlomo (11):
      net/mlx5e: E-Switch, handle flow attribute with no destinations
      net/mlx5: fs, assert null dest pointer when dest_num is 0
      net/mlx5e: TC, reuse flow attribute post parser processing
      net/mlx5e: TC, add terminating actions
      net/mlx5e: TC, validate action list per attribute
      net/mlx5e: TC, set control params for branching actions
      net/mlx5e: TC, initialize branch flow attributes
      net/mlx5e: TC, initialize branching action with target attr
      net/mlx5e: TC, rename post_meter actions
      net/mlx5e: TC, init post meter rules with branching attributes
      net/mlx5e: TC, allow meter jump control action

 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  12 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   7 +
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  66 +++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |  24 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |  98 +++--
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   4 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 428 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  93 +++--
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   5 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |  20 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.h   |   5 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      | 218 +++++------
 .../net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h |   8 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  46 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  33 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   3 +
 include/linux/mlx5/device.h                        |   7 +
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 29 files changed, 761 insertions(+), 373 deletions(-)
