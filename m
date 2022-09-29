Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FD35EEED1
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiI2HWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbiI2HWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AEA115BF7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7D22B8232C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81968C433C1;
        Thu, 29 Sep 2022 07:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436157;
        bh=6ucE9oIZlM3D5cf+bT8g+oT0UmQqRQgMJ8SMJgc3IXs=;
        h=From:To:Cc:Subject:Date:From;
        b=D1VIeovmnpZKlUJELVgp8tgcbzn2t9xx8Hhv9SpW/rALAku0qXRTEuSxhxQdPI4bt
         ieEatm8XXH4g4FpR9qbmp06OW1q8vTx5przLyLhBbia7yVmSH4bKLoXQW9hExiHatT
         mg+6pykcTMwy5a1ERoGRcdjiNeZqQ1thEvLBp7UwRflX7JM8Fkx+x4QCkIGKQAW/Nm
         fyvblDyAnXxJYxEhEY5ldG3RT/cyAqYbTEMJGp8jg2eRwQSuqM4UAkMKv74G59M/lC
         YGMk3LEQMLBHWeVhRKtOnkpGgF4QDAKNkDjDZUInZJ0tDMoX55YeHYMijBzb9KoOyY
         G0vorVgjlAjzg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/16] mlx5 xsk updates part2 2022-09-28
Date:   Thu, 29 Sep 2022 00:21:40 -0700
Message-Id: <20220929072156.93299-1-saeed@kernel.org>
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

XSK buffer improvements, This is part #2 of 4 parts series.

 1) Expose xsk min chunk size to drivers, to allow the driver to adjust to a
   better buffer stride size

 2) Adjust MTT page size to the XSK frame size, to avoid umem overrun in
  certain situations.

 3) Use xsk frame size as the striding RQ page size for XSK RQs

 4) KSM for unaligned XSK, KSM allows arbitrary buffer chunk lengths
    registration in HW, which makes more sense for unaligned XSK.

 4) More cleanups and optimizations in preparation for next improvements
    in part3

part 1: https://lore.kernel.org/netdev/20220927203611.244301-1-saeed@kernel.org/

Thanks,
Saeed.

Maxim Mikityanskiy (16):
  xsk: Expose min chunk size to drivers
  net/mlx5e: Use runtime page_shift for striding RQ
  net/mlx5e: xsk: Use XSK frame size as striding RQ page size
  net/mlx5e: Keep a separate MKey for striding RQ
  net/mlx5: Add MLX5_FLEXIBLE_INLEN to safely calculate cmd inlen
  net/mlx5e: xsk: Use KSM for unaligned XSK
  xsk: Remove unused xsk_buff_discard
  net/mlx5e: Fix calculations for ICOSQ size
  net/mlx5e: Optimize the page cache reducing its size 2x
  net/mlx5e: Rename mlx5e_dma_info to prepare for removal of DMA address
  net/mlx5e: Remove DMA address from mlx5e_alloc_unit
  net/mlx5e: Convert struct mlx5e_alloc_unit to a union
  net/mlx5e: xsk: Remove mlx5e_xsk_page_alloc_pool
  net/mlx5e: Split out channel (de)activation in rx_res
  net/mlx5e: Move repeating clear_bit in
    mlx5e_rx_reporter_err_rq_cqe_recover
  net/mlx5e: Clean up and fix error flows in mlx5e_alloc_rq

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  72 +++--
 .../ethernet/mellanox/mlx5/core/en/params.c   | 299 +++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/params.h   |  17 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |   7 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 106 +++----
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  31 --
 .../mellanox/mlx5/core/en/xsk/setup.c         |  13 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 188 +++++++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 253 +++++++++------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  30 ++
 include/linux/mlx5/qp.h                       |   8 +
 include/net/xdp_sock_drv.h                    |  10 +-
 net/xdp/xdp_umem.c                            |   2 -
 16 files changed, 683 insertions(+), 366 deletions(-)

-- 
2.37.3

