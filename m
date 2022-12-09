Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DCE647A93
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiLIAOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIAOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5D982FBC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 025AEB826B9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB0C433EF;
        Fri,  9 Dec 2022 00:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544868;
        bh=EmK9kIx/JowLxT9yONmd2g9MXjx84lQ+m/Kx2Q2HVuY=;
        h=From:To:Cc:Subject:Date:From;
        b=fYiZgLP1OWdmmf8txuHf4WWuqrWEOD5uoDPJnEdHwRIUOrZs3odHFUYgMYNKq7OhU
         iX0W3lZHKdHbCTQfCiTeYlOwP+a5Ts6G/cLhpQl6Z04MaX6qVVTuXHsy5wVp1shg8o
         UcSDhj6bF8JwYuMfUzhG+CchdGS5L/SCKPxKb4CxHCP89GY6hbCwrG0c7Ez6G3sQSr
         3b4U0SuvIxmd0hAtG6y4tYatc4j35fTYqkuk5QXrFep4vMkVa5J9Rua0sf+1A6zHdF
         vcoadw3cTEI0DM1/RPTk4/kV3YUpnmLnwT3Alj+uD5AH3zKRUCfbh+sgy2PWUNKBe4
         hkVUAYAgx/L2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-12-08
Date:   Thu,  8 Dec 2022 16:14:05 -0800
Message-Id: <20221209001420.142794-1-saeed@kernel.org>
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

This series provides
1) steering RANGE matching hardware offloads and tc meter mtu offoad
2) multipath, support routes with more than 2 nexthops
3) vport representors counter improvements

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit ff36c447e2330625066d193a25a8f94c1408d9d9:

  Merge branch 'mlx4-better-big-tcp-support' (2022-12-08 14:27:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-12-08

for you to fetch changes up to 4fe1b3a5f8fe2fdcedcaba9561e5b0ae5cb1d15b:

  net/mlx5: Expose steering dropped packets counter (2022-12-08 16:10:56 -0800)

----------------------------------------------------------------
mlx5-updates-2022-12-08

1) Support range match action in SW steering

Yevgeny Kliteynik says:
=======================

The following patch series adds support for a range match action in
SW Steering.

SW steering is able to match only on the exact values of the packet fields,
as requested by the user: the user provides mask for the fields that are of
interest, and the exact values to be matched on when the traffic is handled.

The following patch series add new type of action - Range Match, where the
user provides a field to be matched on and a range of values (min to max)
that will be considered as hit.

There are several new notions that were implemented in order to support
Range Match:
 - MATCH_RANGES Steering Table Entry (STE): the new STE type that allows
   matching the packets' fields on the range of values instead of a specific
   value.
 - Match Definer: this is a general FW object that defines which fields
   in the packet will be referenced by the mask and tag of each STE.
   Match definer ID is part of STE fields, and it defines how the HW needs
   to interpret the STE's mask/tag values.
   Till now SW steering used the definers that were managed by FW and
   implemented the STE layout as described by the HW spec.
   Now that we're adding a new type of STE, SW steering needs to also be
   able to define this new STE's layout, and this is do

=======================

2) From OZ add support for meter mtu offload
   2.1: Refactor the code to allow both metering and range post actions as a
        pre-step for adding police mtu offload support.
   2.2: Instantiate mtu green/red flow tables with a single match-all rule.
        Add the green/red actions to the hit/miss table accordingly
   2.3: Initialize the meter object with the TC police mtu parameter.
        Use the hardware range match action feature.

3) From MaorD, support routes with more than 2 nexthops in multipath

4) Michael and Or, improve and extend vport representor counters.

----------------------------------------------------------------
Maor Dickman (1):
      net/mlx5e: multipath, support routes with more than 2 nexthops

Michael Guralnik (1):
      net/mlx5: Expose steering dropped packets counter

Or Har-Toov (1):
      net/mlx5: Refactor and expand rep vport stat group

Oz Shlomo (3):
      net/mlx5e: meter, refactor to allow multiple post meter tables
      net/mlx5e: meter, add mtu post meter tables
      net/mlx5e: TC, add support for meter mtu offload

Yevgeny Kliteynik (9):
      net/mlx5: mlx5_ifc updates for MATCH_DEFINER general object
      net/mlx5: fs, add match on ranges API
      net/mlx5: DR, Add functions to create/destroy MATCH_DEFINER general object
      net/mlx5: DR, Rework is_fw_table function
      net/mlx5: DR, Handle FT action in a separate function
      net/mlx5: DR, Manage definers with refcounts
      net/mlx5: DR, Some refactoring of miss address handling
      net/mlx5: DR, Add function that tells if STE miss addr has been initialized
      net/mlx5: DR, Add support for range match action

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   1 +
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |  16 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c | 336 +++++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |  31 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  94 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  |  22 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 ++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |  79 +++--
 .../mellanox/mlx5/core/steering/dr_action.c        | 300 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  77 +++++
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |  29 +-
 .../mellanox/mlx5/core/steering/dr_definer.c       | 151 +++++++++
 .../mellanox/mlx5/core/steering/dr_domain.c        |   7 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  27 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  10 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  69 +++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |   1 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        |   1 +
 .../mellanox/mlx5/core/steering/dr_types.h         |  43 +++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  53 +++-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h        |  35 +++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  13 +
 include/linux/mlx5/fs.h                            |  12 +
 include/linux/mlx5/mlx5_ifc.h                      |  68 ++++-
 33 files changed, 1373 insertions(+), 195 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c
