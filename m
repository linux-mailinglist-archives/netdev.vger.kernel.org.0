Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D14B637E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiBOGct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:32:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbiBOGcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A06AB45C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B41261512
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8116C340EC;
        Tue, 15 Feb 2022 06:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906756;
        bh=BxLOdr81RzCsWyKBE0xDKTLmoVtS8JK6TXsnhi8/ZTA=;
        h=From:To:Cc:Subject:Date:From;
        b=K49iONuXCNMQRYFC2tAp/TcV38Or63ln7CB+TAHhVW3S4SlYZtoWIuNJ0YFCPxfPn
         e/ef4Ef3+NXoxuIKBuARirYitDdUD2YTvELByKFEmjxek1O2MW+Nu3Yhpj6FRV45pA
         2hnxRIk1RyAFqWiSI72fu058mMU4uVHmjcylpBtNcU1XqpnQ9ftiJw0o/URgKjQySf
         qZu6Q8jQ+vINB+dFOT+gagJL5usMak11WiNXOu8vPZ+ms2N1IgtAVxqJ6haNO4rrJA
         T1NovXDP9NiDCG6NBwhYUMxmg8T8CGLbw+6EbCPam1YVIAMpC2866p7cESwMs4+OEE
         UN2P+sQE9yyWg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-02-14
Date:   Mon, 14 Feb 2022 22:32:14 -0800
Message-Id: <20220215063229.737960-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

This series TX updates for mlx5e netdev driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit d0b78ab1ca357628ffb92cf8a0af00b4ffdc4e3b:

  net: dsa: mv88e6xxx: Fix validation of built-in PHYs on 6095/6097 (2022-02-14 21:13:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-02-14

for you to fetch changes up to 71753b8ec103fd71d6ee90e522d797ccf978e4ed:

  net/mlx5e: Optimize the common case condition in mlx5e_select_queue (2022-02-14 22:30:52 -0800)

----------------------------------------------------------------
mlx5-updates-2022-02-14

mlx5 TX routines improvements

1) From Aya and Tariq, first 3 patches, Use the Max size of the TX descriptor
as advertised by the device and not the fixed value of 16 that the driver
always assumed, this is not a bug fix as all existing devices have Max value
larger than 16, but the series is necessary for future proofing the driver.

2) TX Synchronization improvements from Maxim, last 12 patches

Maxim Mikityanskiy Says:
=======================
mlx5e: Synchronize ndo_select_queue with configuration changes

The kernel can call ndo_select_queue at any time, and there is no direct
way to block it. The implementation of ndo_select_queue in mlx5e expects
the parameters to be consistent and may crash (invalid pointer, division
by zero) if they aren't.

There were attempts to partially fix some of the most frequent crashes,
see commit 846d6da1fcdb ("net/mlx5e: Fix division by 0 in
mlx5e_select_queue") and commit 84c8a87402cf ("net/mlx5e: Fix division
by 0 in mlx5e_select_queue for representors"). However, they don't
address the issue completely.

This series introduces the proper synchronization mechanism between
mlx5e configuration and TX data path:

1. txq2sq updates are synchronized properly with ndo_start_xmit
   (mlx5e_xmit). The TX queue is stopped when it configuration is being
   updated, and memory barriers ensure the changes are visible before
   restarting.

2. The set of parameters needed for mlx5e_select_queue is reduced, and
   synchronization using RCU is implemented. This way, changes are
   atomic, and the state in mlx5e_select_queue is always consistent.

3. A few optimizations are applied to the new implementation of
   mlx5e_select_queue.

=======================

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Read max WQEBBs on the SQ from firmware
      net/mlx5e: Use FW limitation for max MPW WQEBBs

Maxim Mikityanskiy (12):
      net/mlx5e: Cleanup of start/stop all queues
      net/mlx5e: Disable TX queues before registering the netdev
      net/mlx5e: Use a barrier after updating txq2sq
      net/mlx5e: Sync txq2sq updates with mlx5e_xmit for HTB queues
      net/mlx5e: Introduce select queue parameters
      net/mlx5e: Move mlx5e_select_queue to en/selq.c
      net/mlx5e: Use select queue parameters to sync with control flow
      net/mlx5e: Move repeating code that gets TC prio into a function
      net/mlx5e: Use READ_ONCE/WRITE_ONCE for DCBX trust state
      net/mlx5e: Optimize mlx5e_select_queue
      net/mlx5e: Optimize modulo in mlx5e_select_queue
      net/mlx5e: Optimize the common case condition in mlx5e_select_queue

Tariq Toukan (1):
      net/mlx5e: Remove unused tstamp SQ field

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  43 +++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |  42 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  | 231 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h  |  51 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  47 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   7 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   6 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 113 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 128 ++----------
 17 files changed, 480 insertions(+), 232 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
