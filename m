Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C852EB5CA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAEXFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhAEXFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:05:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8105A22E00;
        Tue,  5 Jan 2021 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887904;
        bh=XTthW2RmpOMWlBeMz07hvIJD62PV5K9QgmAF66AnmU4=;
        h=From:To:Cc:Subject:Date:From;
        b=LpsmZcYg7oauQPS7Zkyzu5R8RRcQ5UFmVnWXGRToMTcmvH3hen1p8yVLKuU2u/G7y
         Kt+NOYZt3eoj/wvxsLE/G5aI4blY/PDYbN1XrVLpu4UtxlMk9z08NJh/TeVpiim3Jt
         ctLeVLFNxB8fohdxk5gYWR5ap+OhnOQ6Xi8kOEm5vah55o1uOC8iz61VV+vzmQDcYz
         +v2ViXq9aTsZ1T7/mkmyz+2tkCdZkf7jM9GZPieUM7MYoy3v8vcMaLZNfTbf8c/jI9
         SmAUh8e6c0IH0wMlL3igSfFGziA+sVerWrRTWtYY0PJlgBKHhAxj62Dhj9Dhyv5fi5
         0U1OQeKu9yPxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 SW steering updates 2021-01-05
Date:   Tue,  5 Jan 2021 15:03:17 -0800
Message-Id: <20210105230333.239456-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub, Dave

This series introduces some refactoring to SW steering to support
different formats of different Hardware.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit f6e7a024bfe5e11d91ccff46bb576e3fb5a516ea:

  Merge tag 'arc-5.11-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc (2021-01-05 12:46:27 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-01-05

for you to fetch changes up to 4781df92f4dab5ca6928390c3cf4bfba9730a526:

  net/mlx5: DR, Move STEv0 modify header logic (2021-01-05 15:00:49 -0800)

----------------------------------------------------------------
mlx5-updates-2021-01-05

SW steering, Refactor to have a device specific STE layer below dr_ste

This series introduces some improvements and refactoring by adding a new layer
below dr_ste to allow support for different devices format.

It adds a struct of device specific callbacks for STE layer below dr_ste.
Each device will implement its HW-specific function, and a common logic
from the DR code will access these functions through the new ste_ctx API.

Connect-X5-style steering format is called STE_v0.
In the next patch series we bring the Connect-X6-style format - STE_v1.

----------------------------------------------------------------
Yevgeny Kliteynik (16):
      net/mlx5: DR, Add infrastructure for supporting several steering formats
      net/mlx5: DR, Move macros from dr_ste.c to header
      net/mlx5: DR, Use the new HW specific STE infrastructure
      net/mlx5: DR, Move HW STEv0 match logic to a separate file
      net/mlx5: DR, Remove unused macro definition from dr_ste
      net/mlx5: DR, Fix STEv0 source_eswitch_owner_vhca_id support
      net/mlx5: DR, Merge similar DR STE SET macros
      net/mlx5: DR, Move STEv0 look up types from mlx5_ifc_dr header
      net/mlx5: DR, Refactor ICMP STE builder
      net/mlx5: DR, Move action apply logic to dr_ste
      net/mlx5: DR, Add STE setters and getters per-device API
      net/mlx5: DR, Move STEv0 setters and getters
      net/mlx5: DR, Add STE tx/rx actions per-device API
      net/mlx5: DR, Move STEv0 action apply logic
      net/mlx5: DR, Add STE modify header actions per-device API
      net/mlx5: DR, Move STEv0 modify header logic

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    1 +
 .../mellanox/mlx5/core/steering/dr_action.c        |  579 +------
 .../mellanox/mlx5/core/steering/dr_domain.c        |    6 +
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  106 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   49 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 1592 +++----------------
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |  167 ++
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        | 1640 ++++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h         |  182 ++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |   85 -
 10 files changed, 2329 insertions(+), 2078 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
