Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCF4DCE2B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbiCQSzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiCQSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D071637F1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06C961744
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26E5C340E9;
        Thu, 17 Mar 2022 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543268;
        bh=zmADk2Qcu0bG158GcZCItX80BAQK0XtiVslaRoDBBzo=;
        h=From:To:Cc:Subject:Date:From;
        b=Y+G+hOSQ98RcbjneeXm5oNhl5lbYVFmKVihTNu2Bby3EWq6KS3bccKhsAQuddjv39
         wz3a8Ee0zdFufN3U9N/fL3zwlAIN+Zoqs1bGkxKCEajM0V0xey7YHQmrreZM+Oz+WL
         W8lmm5oo/aJCbk6gbTvGxlukEoc0VGTw3GHmGdoh2gbKchgFpdCSiTh4+VmBnd5YXy
         KNGf7rTKkmqp3h38PB84f81pRGz/dhBRFGzCNODddWHxmhxWP8Q0fsnezhNe1A5gLc
         pQypEMsBBuqN6dUeDA/Yb1hF+/CS8xj0czouKtyWh6x3KhuZhMcVpfJX7KvT+lF+73
         106lOksjH/dcQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-03-17
Date:   Thu, 17 Mar 2022 11:54:09 -0700
Message-Id: <20220317185424.287982-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series adds some updates to mlx5 driver:
 1) Preparation for XDP Multi-buffer support
 2) Memory consumption reduction in SW steering component of the driver

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 1abea24af42c35c6eb537e4402836e2cde2a5b13:

  selftests: net: fix array_size.cocci warning (2022-03-17 15:21:16 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-03-17

for you to fetch changes up to 770c9a3a01af178a90368a78c75eb91707c7233c:

  net/mlx5: Remove unused fill page array API function (2022-03-17 11:51:58 -0700)

----------------------------------------------------------------
mlx5-updates-2022-03-17

1) From Maxim Mikityanskiy,
   Datapath improvements in preparation for XDP multi buffer

   This series contains general improvements for the datapath that are
   useful for the upcoming XDP multi buffer support:

   a. Non-linear legacy RQ: validate MTU for robustness, build the linear
      part of SKB over the first hardware fragment (instead of copying the
      packet headers), adjust headroom calculations to allow enabling headroom
      in the non-linear mode (useful for XDP multi buffer).

   b. XDP: do the XDP program test before function call, optimize
      parameters of mlx5e_xdp_handle.

2) From Rongwei Liu, DR, reduce steering memory usage
   Currently, mlx5 driver uses mlx5_htbl/chunk/ste to organize
   steering logic. However there is a little memory waste.

   This update targets to reduce steering memory footprint by:
   a. Adjust struct member layout.
   b. Remove duplicated indicator by using simple functions call.

   With 500k TX rules(3 ste) plus 500k RX rules(6 stes), these patches
   can save around 17% memory.

3) Three cleanup commits at the end of this series.

----------------------------------------------------------------
Maxim Mikityanskiy (5):
      net/mlx5e: Validate MTU when building non-linear legacy RQ fragments info
      net/mlx5e: Add headroom only to the first fragment in legacy RQ
      net/mlx5e: Build SKB in place over the first fragment in non-linear legacy RQ
      net/mlx5e: Drop the len output parameter from mlx5e_xdp_handle
      net/mlx5e: Drop cqe_bcnt32 from mlx5e_skb_from_cqe_mpwrq_linear

Paul Blakey (1):
      net/mlx5: CT: Remove extra rhashtable remove on tuple entries

Rongwei Liu (6):
      net/mlx5: DR, Adjust structure member to reduce memory hole
      net/mlx5: DR, Remove mr_addr rkey from struct mlx5dr_icm_chunk
      net/mlx5: DR, Remove icm_addr from mlx5dr_icm_chunk to reduce memory
      net/mlx5: DR, Remove num_of_entries byte_size from struct mlx5_dr_icm_chunk
      net/mlx5: DR, Remove 4 members from mlx5dr_ste_htbl to reduce memory
      net/mlx5: DR, Remove hw_ste from mlx5dr_ste to reduce memory

Tariq Toukan (3):
      net/mlx5e: RX, Test the XDP program existence out of the handler
      net/mlx5: Remove unused exported contiguous coherent buffer allocation API
      net/mlx5: Remove unused fill page array API function

 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |  60 -----------
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  69 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  16 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 111 ++++++++++++---------
 .../mellanox/mlx5/core/steering/dr_action.c        |  12 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |  14 ++-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |  57 ++++++++---
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  18 ++--
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  71 +++++++------
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  34 ++++---
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 105 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_table.c         |  18 ++--
 .../mellanox/mlx5/core/steering/dr_types.h         |  31 +++---
 include/linux/mlx5/driver.h                        |   4 -
 17 files changed, 338 insertions(+), 292 deletions(-)
