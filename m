Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC325614C5
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58836 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726344AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLn031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 00/16] mlx5e devlink health reporters
Date:   Sun,  7 Jul 2019 14:52:52 +0300
Message-Id: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I'm submitting this series myself as Saeed is on vacation.

This series from Aya to the mlx5e driver introduces changes in
devlink health reporters.
Most noticeable is adding a new reporter, RX reporter, which
reports and recovers from timeout and completion errors in the
receive path.

In patches 1-6, we  perform TX reporter cleanup. In order to maintain
the code flow as similar as possible between RX and TX reporters.
In patch 7, we prepare for code sharing, generalize and move shared
functionality.
Patches 8-10 refactor and extend TX reporter diagnostics information
to align the TX reporter diagnostics output with the RX reporter's
diagnostics output.
Patch 11 adds RX reporter, initially supports only the diagnostics
call back.
In patch 12 we split ICOSQ open/close functions into two stages, to call
specific parts from the recover flow.
Patches 13-16 introduce recovery flows for: RX timeout on ICOSQ, completion
error on receive path.

Series generated against net-next commit:
23f30c41c732 Merge branch 'mlx5-TLS-TX-HW-offload-support'

Regards,
Tariq


Aya Levin (15):
  Revert "net/mlx5e: Fix mlx5e_tx_reporter_create return value"
  net/mlx5e: Fix error flow in tx reporter diagnose
  net/mlx5e: Set tx reporter only on successful creation
  net/mlx5e: TX reporter cleanup
  net/mlx5e: Rename reporter header file
  net/mlx5e: Change naming convention for reporter's functions
  net/mlx5e: Generalize tx reporter's functionality
  net/mlx5e: Extend tx diagnose function
  net/mlx5e: Extend tx reporter diagnostics output
  net/mlx5e: Add cq info to tx reporter diagnose
  net/mlx5e: Add support to rx reporter diagnose
  net/mlx5e: Split open/close ICOSQ into stages
  net/mlx5e: Recover from CQE error on ICOSQ
  net/mlx5e: Recover from rx timeout
  net/mlx5e: Recover from CQE with error on RQ

Saeed Mahameed (1):
  net/mlx5e: RX, Handle CQE with error at the earliest stage

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  32 ++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 205 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  53 +++
 .../net/ethernet/mellanox/mlx5/core/en/reporter.h  |  15 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 390 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 226 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  84 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  62 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   1 +
 13 files changed, 883 insertions(+), 200 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c

-- 
1.8.3.1

