Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C23449A68
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbhKHRI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239399AbhKHRI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CE261406;
        Mon,  8 Nov 2021 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391144;
        bh=HciqKbXqqAmrcI8U2GuzHXUrionnRkzZt4vfLGja0tw=;
        h=From:To:Cc:Subject:Date:From;
        b=UM4/hAF5aGLQfqBcNHpxK8vVCDvuf8l+8WJfLNYADGoJ0MAFpxS0hJCAIiES/IwYT
         CYp7/raOmyWyY/eg6yCtBBYUdla8pRW8A6cXDK3IdeZ0Iw4UTeFMIwQbKS1uqsfs2K
         YnhUJx6+Mw88i7wJnPjMm66llmD9eI7IZDaK4pUKpGZqBtEJA3mC0t3ibz233PDd1z
         gWgP8mSo1OH3NckQdLbsadIf/ER691qQazjX+OnSZWRlRCc5B27JC3F2h/e0G/a7H6
         IilBENd7JH2wo3K6B27TZlFqyBjy8Gj+bQ1M1GkNXBRf/306SKQqKTirV2pv9lRUu3
         TM51VYRwvPFaQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 00/16] Allow parallel devlink execution
Date:   Mon,  8 Nov 2021 19:05:22 +0200
Message-Id: <cover.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Jakub, this is RFC, not fully tested and not reviewed yet.
I'm sending it to show that first we need to fix internal devlink
locking before even thinking of exporting it to the drivers.

-------------------------------------------------------------------
Hi,

This is final piece of devlink locking puzzle, where I remove global
mutex lock (devlink_mutex) and reduce scope of devlink->lock. The last
change allows us to make sure that devlink commands are called while
devlink_reload is executed and protected at the same time.

All of the changes mentioned above are limited to devlink.c without any
need to update drivers or expose internal details of devlink implementation.

The diffstat is misleading here, because of initial cleanup of overly
engineered interfaces.

BTW, I have one extra patch that documents devlink locking.

Thanks

Leon Romanovsky (16):
  devlink: Remove misleading internal_flags from health reporter dump
  devlink: Delete useless checks of holding devlink lock
  devlink: Simplify devlink resources unregister call
  devlink: Clean registration of devlink port
  devlink: Be explicit with devlink port protection
  devlink: Reshuffle resource registration logic
  devlink: Inline sb related functions
  devlink: Protect resource list with specific lock
  devlink: Protect all traps lists with specialized lock
  devlink: Separate region list protection to be done with specialized
    lock
  devlink: Protect all rate operations with specialized lock
  devlink: Protect all sb operations with specialized lock
  devlink: Convert dpipe to use dpipe_lock
  devlink: Require devlink lock during device reload
  devlink: Use xarray locking mechanism instead big devlink lock
  devlink: Open devlink to parallel operations

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   7 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |   7 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  18 +-
 .../marvell/prestera/prestera_devlink.c       |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   7 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   4 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   4 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  14 +-
 drivers/net/netdevsim/dev.c                   |  11 +-
 include/net/devlink.h                         |   9 +-
 net/core/devlink.c                            | 938 ++++++++++--------
 net/dsa/dsa.c                                 |   2 +-
 net/dsa/dsa2.c                                |   9 +-
 20 files changed, 561 insertions(+), 523 deletions(-)

-- 
2.33.1

