Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A25560B17F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiJXQ0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiJXQ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C43ADF83
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49F661290
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B03C433B5;
        Mon, 24 Oct 2022 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620008;
        bh=Nn95pCdy02rwGmegWbPaejloYS1SV380lGFVHPlVmM8=;
        h=From:To:Cc:Subject:Date:From;
        b=T3bucdvwy/09mglhJkYG7JwXBnlpp3QMgWNT4h523wteE0kOoLeaYhG4blCIBHqqn
         VIwRkt3KwuIN2qdh+22GE623eUNb2zcVughMxwAqJ/e6iXzacvTlytxtxZsU9Iu1Qv
         1KENCwUxmk/f666WNAAm4HQWI5tBP4N5boxD3eQKQ8W+dS1vup7NuzVXZeRd5mGq1Y
         EC5Zv+LooR5LZb0yzyfVKfhKyAA+O9TMFWAQLLytGplzjB36vkJ+w2TsJwlfRlpI06
         LhRxKCSK5otC3sXP0EyN1itBAh+5MwDGKFytjBHd2bM9zEdh0NtI7Xs4vzaXgzy2JA
         ujiggPy1zoscQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2022-10-24
Date:   Mon, 24 Oct 2022 14:57:20 +0100
Message-Id: <20221024135734.69673-1-saeed@kernel.org>
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

This series provides optimizations to mlx5 SW steering.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 86d6f77a3cce1189ab7c31e52e4d47ca58e7a601:

  Merge branch 'ptp-ocxp-Oroli-ART-CARD' (2022-10-24 13:10:40 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-10-24

for you to fetch changes up to 3f940390fcb2fc8a14268e23933466f83c81e46e:

  net/mlx5: DR, Remove the buddy used_list (2022-10-24 14:52:05 +0100)

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
      net/mlx5: DR, Allocate ste_arr on stack instead of dynamically
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
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  61 ++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 141 ++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  12 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   2 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  16 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   9 +-
 10 files changed, 380 insertions(+), 133 deletions(-)
