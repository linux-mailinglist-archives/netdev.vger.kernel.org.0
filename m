Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CC860FAE9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiJ0O5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiJ0O5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83FCB40F1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 667466236C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6046DC433D6;
        Thu, 27 Oct 2022 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882624;
        bh=m0NhJ4p/OcjkekmH+JRoLhgJWTxvM71OnQHQWauhrNQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QOLsLa2qCZLWCew107EIEjCphgKO8+fd0Wy9rJukhjk1kZ0wlSP2eXsj1VPkUfXAj
         0DRlUUH0rep/Fn9Fi93WRvk4OnZbIm7uOyGixgYnX1XNVdSjLLd+SZkl7MmD+8Pb93
         9dxGxwG1vl3j5fLxpT+mEByvGtKyVJb8Gk4vUtYLtyWhaBbph9eDgNhuK39DFNkmKg
         iI6gHRrYIf/Ta13OqFzAxvimFxjYrp4XhETHGii3ZCRHoMaIoTLnDThxeSDpAsJOnz
         L8zevT042mAHB491hg7IkEez/uVyT2xFr2ykaRrSC6cwu89Wf/8jM2o3TQngHyVYwj
         at1MWbsXp/GDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next V2 00/14] mlx5 updates 2022-10-24
Date:   Thu, 27 Oct 2022 15:56:29 +0100
Message-Id: <20221027145643.6618-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

v1-v2:
 - fix 32bit x86 -Wframe-larger-than

This series provides optimizations to mlx5 SW steering.                         
For more information please see tag log below.                                  
                                                                                
Please pull and let me know if there is any problem.                            
                                                        
Thanks,
Saeed.


The following changes since commit 12d6c1d3a2ad0c199ec57c201cdc71e8e157a232:

  skbuff: Proactively round up to kmalloc bucket size (2022-10-27 15:48:19 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-10-24

for you to fetch changes up to edaea001442a792e4b14c7523072b9687700585e:

  net/mlx5: DR, Remove the buddy used_list (2022-10-27 15:50:40 +0100)

----------------------------------------------------------------
mlx5-updates-2022-10-24

SW steering updates from Yevgeny Kliteynik:

1) 1st Four patches: small fixes / optimizations for SW steering:

 - Patch 1: Don't abort destroy flow if failed to destroy table - continue
   and free everything else.
 - Patches 2 and 3 deal with fast teardown:
    + Skip sync during fast teardown, as PCI device is not there any more.
    + Check device state when polling CQ - otherwise SW steering keeps polling
      the CQ forever, because nobody is there to flush it.
 - Patch 4: Removing unneeded function argument.

2) Deal with the hiccups that we get during rules insertion/deletion,
which sometimes reach 1/4 of a second. While insertion/deletion rate
improvement was not the focus here, it still is a by-product of removing these
hiccups.

Another by-product is the reduced standard deviation in measuring the duration
of rules insertion/deletion bursts.

In the testing we add K rules (warm-up phase), and then continuously do
insertion/deletion bursts of N rules.
During the test execution, the driver measures hiccups (amount and duration)
and total time for insertion/deletion of a batch of rules.

Here are some numbers, before and after these patches:

+--------------------------------------------+-----------------+----------------+
|                                            |   Create rules  |  Delete rules  |
|                                            +--------+--------+--------+-------+
|                                            | Before |  After | Before | After |
+--------------------------------------------+--------+--------+--------+-------+
| Max hiccup [msec]                          |    253 |     42 |    254 |    68 |
+--------------------------------------------+--------+--------+--------+-------+
| Avg duration of 10K rules add/remove [msec]| 140.07 | 124.32 | 106.99 | 99.51 |
+--------------------------------------------+--------+--------+--------+-------+
| Num of hiccups per 100K rules add/remove   |   7.77 |   7.97 |  12.60 | 11.57 |
+--------------------------------------------+--------+--------+--------+-------+
| Avg hiccup duration [msec]                 |  36.92 |  33.25 |  36.15 | 33.74 |
+--------------------------------------------+--------+--------+--------+-------+

 - Patch 5: Allocate a short array on stack instead of dynamically- it is
   destroyed at the end of the function.
 - Patch 6: Rather than cleaning the corresponding chunk's section of
   ste_arrays on chunk deletion, initialize these areas upon chunk creation.
   Chunk destruction tend to come in large batches (during pool syncing),
   so instead of doing huge memory initialization during pool sync,
   we amortize this by doing small initsializations on chunk creation.
 - Patch 7: In order to simplifies error flow and allows cleaner addition
   of new pools, handle creation/destruction of all the domain's memory pools
   and other memory-related fields in a separate init/uninit functions.
 - Patch 8: During rehash, write each table row immediately instead of waiting
   for the whole table to be ready and writing it all - saves allocations
   of ste_send_info structures and improves performance.
 - Patch 9: Instead of allocating/freeing send info objects dynamically,
   manage them in pool. The number of send info objects doesn't depend on
   number of rules, so after pre-populating the pool with an initial batch of
   send info objects, the pool is not expected to grow.
   This way we save alloc/free during writing STEs to ICM, which by itself can
   sometimes take up to 40msec.
 - Patch 10: Allocate icm_chunks from their own slab allocator, which lowered
   the alloc/free "hiccups" frequency.
 - Patch 11: Similar to patch 9, allocate htbl from its own slab allocator.
 - Patch 12: Lower sync threshold for ICM hot memory - set the threshold for
   sync to 1/4 of the pool instead of 1/2 of the pool. Although we will have
   more syncs, each     sync will be shorter and will help with insertion rate
   stability. Also, notice that the overall number of hiccups wasn't increased
   due to all the other patches.
 - Patch 13: Keep track of hot ICM chunks in an array instead of list.
   After steering sync, we traverse the hot list and finally free all the
   chunks. It appears that traversing a long list takes unusually long time
   due to cache misses on many entries, which causes a big "hiccup" during
   rule insertion. This patch replaces the list with pre-allocated array that
   stores only the bookkeeping information that is needed to later free the
   chunks in its buddy allocator.
 - Patch 14: Remove the unneeded buddy used_list - we don't need to have the
   list of used chunks, we only need the total amount of used memory.

----------------------------------------------------------------
Yevgeny Kliteynik (14):
      net/mlx5: DR, In destroy flow, free resources even if FW command failed
      net/mlx5: DR, Fix the SMFS sync_steering for fast teardown
      net/mlx5: DR, Check device state when polling CQ
      net/mlx5: DR, Remove unneeded argument from dr_icm_chunk_destroy
      net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically
      net/mlx5: DR, Initialize chunk's ste_arrays at chunk creation
      net/mlx5: DR, Handle domain memory resources init/uninit separately
      net/mlx5: DR, In rehash write the line in the entry immediately
      net/mlx5: DR, Manage STE send info objects in pool
      net/mlx5: DR, Allocate icm_chunks from their own slab allocator
      net/mlx5: DR, Allocate htbl from its own slab allocator
      net/mlx5: DR, Lower sync threshold for ICM hot memory
      net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list
      net/mlx5: DR, Remove the buddy used_list

 .../mellanox/mlx5/core/steering/dr_buddy.c         |   2 -
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   7 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |  89 ++++++++---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 174 ++++++++++++---------
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  92 +++++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 141 ++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  12 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   2 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  16 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   9 +-
 10 files changed, 406 insertions(+), 138 deletions(-)
