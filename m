Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED22791E0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgIYURd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgIYUPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:15:31 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEA522211;
        Fri, 25 Sep 2020 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062697;
        bh=CMi6bD5XzVGRVxBvmk69Ffarb+46/nlaaCNuUvc4DpU=;
        h=From:To:Cc:Subject:Date:From;
        b=DKLPJo6zMWAR/Q25f6SfDUoHqqHDYF57M+MjyQUN6pk6AGG+EtKkH2QQNwarjITqJ
         onOsYEyPmlmybZN+BrZgLQ2ME7L9TFjV7lUMtzU8OVMYNQwH6xKE/hBOVRUHWgnv8O
         njS5llbBr99RYt9kcFbXBfJMb+EWg+Ivfx3Raq18=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 SW steering updates 2020-09-25
Date:   Fri, 25 Sep 2020 12:37:54 -0700
Message-Id: <20200925193809.463047-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave/Jakub,

This series makes some updates to mlx5 software steering.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit aafe8853f5e2bcbdd231411aec218b8c5dc78437:

  Merge branch 'hns3-next' (2020-09-24 20:19:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-25

for you to fetch changes up to d2bbdbfbdbbeed34a15228990654f4d796fb6323:

  net/mlx5: DR, Add support for rule creation with flow source hint (2020-09-25 12:35:45 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-25

This series includes updates to mlx5 software steering component.

1) DR, Memory management improvements

This patch series contains SW Steering memory management improvements:
using buddy allocator instead of an existing bucket allocator, and
several other optimizations.

The buddy system is a memory allocation and management algorithm
that manages memory in power of two increments.

The algorithm is well-known and well-described, such as here:
https://en.wikipedia.org/wiki/Buddy_memory_allocation

Linux uses this algorithm for managing and allocating physical pages,
as described here:
https://www.kernel.org/doc/gorman/html/understand/understand009.html

In our case, although the algorithm in principal is similar to the
Linux physical page allocator, the "building blocks" and the circumstances
are different: in SW steering, buddy allocator doesn't really allocates
a memory, but rather manages ICM (Interconnect Context Memory) that was
previously allocated and registered.

The ICM memory that is used in SW steering is always power
of 2 (order), so buddy system is a good fit for this.

Patches in this series:

[PATH 1/5] net/mlx5: DR, Add buddy allocator utilities
  This patch adds a modified implementation of a well-known buddy allocator,
  adjusted for SW steering needs: the algorithm in principal is similar to
  the Linux physical page allocator, but in our case buddy allocator doesn't
  really allocate a memory, but rather manages ICM memory that was previously
  allocated and registered.

[PATH 2/5] net/mlx5: DR, Handle ICM memory via buddy allocation instead of bucket management
  This patch changes ICM management of SW steering to use buddy-system mechanism
  Instead of the previous bucket management.

[PATH 3/5] net/mlx5: DR, Sync chunks only during free
  This patch makes syncing happen only when freeing memory chunks.

[PATH 4/5] net/mlx5: DR, ICM memory pools sync optimization
  This patch adds tracking of pool's "hot" memory and makes the
  check whether steering sync is required much shorter and faster.

[PATH 5/5] net/mlx5: DR, Free buddy ICM memory if it is unused
  This patch adds tracking buddy's used ICM memory,
  and frees the buddy if all its memory becomes unused.

2) Few improvements in the DR area, such as removing unneeded checks,
  renaming to better general names, refactor in some places, etc.

3) Create SW steering rules with flow source hint, needed to determine
 rule direction (TX,RX) based on this hint rather than the meta data
 from Reg-C0.

----------------------------------------------------------------
Hamdan Igbaria (1):
      net/mlx5: DR, Add support for rule creation with flow source hint

Yevgeny Kliteynik (13):
      net/mlx5: DR, Add buddy allocator utilities
      net/mlx5: DR, Handle ICM memory via buddy allocation instead of bucket management
      net/mlx5: DR, Sync chunks only during free
      net/mlx5: DR, ICM memory pools sync optimization
      net/mlx5: DR, Free buddy ICM memory if it is unused
      net/mlx5: DR, Replace the check for valid STE entry
      net/mlx5: DR, Remove unneeded check from source port builder
      net/mlx5: DR, Remove unneeded vlan check from L2 builder
      net/mlx5: DR, Remove unneeded local variable
      net/mlx5: DR, Call ste_builder directly with tag pointer
      net/mlx5: DR, Remove unused member of action struct
      net/mlx5: DR, Rename builders HW specific names
      net/mlx5: DR, Rename matcher functions to be more HW agnostic

sunils (1):
      net/mlx5: E-switch, Use PF num in metadata reg c0

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  36 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c         | 255 +++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 501 ++++++++-------------
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 123 ++---
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  47 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 223 +++------
 .../mellanox/mlx5/core/steering/dr_types.h         | 101 +++--
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  36 +-
 include/linux/mlx5/eswitch.h                       |  15 +-
 13 files changed, 728 insertions(+), 622 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
