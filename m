Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1403E5F215C
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJBFN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJBFN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE45072D
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF0960DF1
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C033C433C1;
        Sun,  2 Oct 2022 05:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687635;
        bh=CX40i2STHgsF5oWnG2kQeKqA3k0maw4YBQBzy5I7uWk=;
        h=From:To:Cc:Subject:Date:From;
        b=km5hnTj76SbxfJvb5oJET7X3Wl4mcu7OF6ag7AhIx1mSEA6mnD83G3diw67ADFY9X
         ZsT8momzPrV3c4JQ1nM8spEA5++NDoC2UXYRVMrVfNCb7Lp2bF8CgIn9k9maQnvWnQ
         jfuqjpMrAufRmLqWxBJg/bxZ++zHWQSej9/AGCQsXvUO7/A0BhbNecjvzTSglFislk
         f544lvqhgmeLC0nd1HimFQIWISTpjrl4/waQF/rVNseRAdH9xiQpE3OHn2rYmOll89
         6Y7jPwKpTp2bJfH/40Gf8VwGPg4Uzt7aWRLDV9iJ4lt2u+rw1dTvjlk90EHGumuWeI
         g1csSEzwKReZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/15] ] mlx5 xsk updates part4 and more
Date:   Sat,  1 Oct 2022 21:56:17 -0700
Message-Id: <20221002045632.291612-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

1) Final part of xsk improvements, 
in this series Maxim continues to improve xsk implementation
 a) XSK Busy polling support
 b) Use KLM to avoid Frame overrun in unaligned mode
 c) Optimize unaligned more for certain frame sizes
 d) Other straight forward minor optimizations.

part 1: https://lore.kernel.org/netdev/20220927203611.244301-1-saeed@kernel.org/
part 2: https://lore.kernel.org/netdev/20220929072156.93299-1-saeed@kernel.org/
part 3: https://lore.kernel.org/netdev/20220930162903.62262-1-saeed@kernel.org/

2) Oversize packets firmware counter, from Gal.

3) Set default grace period for health reporters based on function type

4) Some minor E-Switch improvements 


Chris Mi (1):
  net/mlx5: E-switch, Don't update group if qos is not enabled

Gal Pressman (1):
  net/mlx5e: Expose rx_oversize_pkts_buffer counter

Jianbo Liu (1):
  net/mlx5: E-Switch, Return EBUSY if can't get mode lock

Maher Sanalla (1):
  net/mlx5: Set default grace period based on function type

Maxim Mikityanskiy (9):
  net/mlx5e: xsk: Flush RQ on XSK activation to save memory
  net/mlx5e: xsk: Set napi_id to support busy polling
  net/mlx5e: xsk: Include XSK skb_from_cqe callbacks in INDIRECT_CALL
  net/mlx5e: xsk: Improve need_wakeup logic
  net/mlx5e: xsk: Use umr_mode to calculate striding RQ parameters
  net/mlx5e: Improve MTT/KSM alignment
  net/mlx5e: xsk: Use KLM to protect frame overrun in unaligned mode
  net/mlx5e: xsk: Print a warning in slow configurations
  net/mlx5e: xsk: Optimize for unaligned mode with 3072-byte frames

Moshe Shemesh (1):
  net/mlx5: Start health poll at earlier stage of driver load

Roi Dayan (1):
  net/mlx5: E-Switch, Allow offloading fwd dest flow table with vport

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  18 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   | 203 ++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en/params.h   |  24 ++-
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |  18 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  57 ++++-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  14 --
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |  12 --
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 125 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   9 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  21 +-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   4 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  33 ++-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  16 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  29 ++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
 include/linux/mlx5/driver.h                   |   5 +
 include/linux/mlx5/mlx5_ifc.h                 |   8 +-
 20 files changed, 466 insertions(+), 159 deletions(-)

-- 
2.37.3

