Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCF5ECEB8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiI0Ug5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiI0Ugj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BAB6050A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A883461B80
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05620C43147;
        Tue, 27 Sep 2022 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664310998;
        bh=UKBIvs41rNjmYpJDLzLHMzXzvypyCn52INH/LOHFU4A=;
        h=From:To:Cc:Subject:Date:From;
        b=o4v51YB1+0rduotWBYuFVh8hUEqDo9qkmDzfOZlUb0QYp4fKC5Vcy5+lTFmzOEqP4
         O1E8jLKeZ6PR8BQv51f5cmeHiTyJtRqEwo6T136wSPLUyf1I4KwT3U7bwmpxr7WF+e
         lXwHSldYzjdupUbovSx/pq+WGtaUGCKopLYIIY94I04kqDtFiNnn6wAQOnCvSms7I2
         c6r3RWPV7UxIbxfB29wuCfMrOA/b5VuyZfXO4XWJgSaNEaa90h1pJUJT2Y2sS8gbZo
         ZY2GiP/znhO8b7YcI04OIuOIuvUp1rrrD8Y6Hw9eY377UPA1ynlyqWB4nZxAq9UOlP
         bBiiPqH03FXeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2022-09-27
Date:   Tue, 27 Sep 2022 13:35:55 -0700
Message-Id: <20220927203611.244301-1-saeed@kernel.org>
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

XSK buffer improvements, This is part #1 of 4 parts series.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 7bcd9683e51575c72c9289c05213150245d1c186:

  selftests/net: enable io_uring sendzc testing (2022-09-27 07:59:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-09-27

for you to fetch changes up to 48670cfdb211a57b41d870098bae659be5b453f7:

  net/mlx5e: Use runtime values of striding RQ parameters in datapath (2022-09-27 13:32:42 -0700)

----------------------------------------------------------------
mlx5-updates-2022-09-27

This is Part #1 of 4 parts series to align mlx5's implementation of
XSK (AF_XDP) RX-Qs indexing and management with other vendors:

Maxim Says:
===========

xsk: Bug fixes for frame mapping on striding RQ

Striding RQ relies on the driver mapping RX buffers into the NIC's
virtual memory space. Currently, regadless of the XSK frame size, mlx5e
maps them using MTT, and each mapping's length is PAGE_SIZE. As the
result, the stride size used by striding RQ is also equal to PAGE_SIZE.

This decision has the following issues:

1. In the XSK aligned mode with frame size smaller than PAGE_SIZE, it's
suboptimal. Using 2K strides and 2K pages allows to post twice as fewer
WQEs.

2. MTT is not suitable for unaligned frames, as it requires natural
alignment theoretically, in practice at least 8-byte alignment.

3. Using mapping and stride bigger than the frame has risk of writing
over the bounds of the XSK frame upon receiving packets bigger than MTU,
which is possible in some specific configurations.

This series addresses issues 1 and 2 and alleviates issue 3. Where
possible, page and stride size will match the XSK frame size (firmware
upgrade may be needed to have effect for 2K frames). Unaligned mode will
use KSM instead of MTT, which allows to drop the partial workaround [1].

[1]: https://lore.kernel.org/netdev/YufYFQ6JN91lQbso@boxer/T/

===========

----------------------------------------------------------------
Maxim Mikityanskiy (16):
      net/mlx5: Add the log_min_mkey_entity_size capability
      net/mlx5e: Convert mlx5e_get_max_sq_wqebbs to u8
      net/mlx5e: Remove unused fields from datapath structs
      net/mlx5e: Make mlx5e_verify_rx_mpwqe_strides static
      net/mlx5e: Validate striding RQ before enabling XDP
      net/mlx5e: Let mlx5e_get_sw_max_sq_mpw_wqebbs accept mdev
      net/mlx5e: Use mlx5e_stop_room_for_max_wqe where appropriate
      net/mlx5e: Fix a typo in mlx5e_xdp_mpwqe_is_full
      net/mlx5e: Use the aligned max TX MPWQE size
      net/mlx5e: kTLS, Check ICOSQ WQE size in advance
      net/mlx5e: Simplify stride size calculation for linear RQ
      net/mlx5e: xsk: Remove dead code in validation
      net/mlx5e: xsk: Fix SKB headroom calculation in validation
      net/mlx5e: Improve the MTU change shortcut
      net/mlx5e: Make dma_info array dynamic in struct mlx5e_mpw_info
      net/mlx5e: Use runtime values of striding RQ parameters in datapath

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  37 ++----
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 141 +++++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  15 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  18 +++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  85 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  60 +++++----
 include/linux/mlx5/mlx5_ifc.h                      |   8 +-
 14 files changed, 230 insertions(+), 176 deletions(-)
