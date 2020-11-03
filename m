Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2122A5055
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgKCTr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:47:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7294 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgKCTr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:47:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b3f10000>; Tue, 03 Nov 2020 11:48:01 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:47:57 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net-next 00/12] mlx5 updates-2020-11-03
Date:   Tue, 3 Nov 2020 11:47:26 -0800
Message-ID: <20201103194738.64061-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432881; bh=0iEULZRQOduIDL9m7A192UR+zD+znsauGpsAt6wvQUc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=AfoFAW3P5SCBPOokP0T+vKcMF3h5F7kQVeHAz0dBR3Z5TyJMFq6LbWh7U/hsBZ7MZ
         jbS2ulb5xmoPIQGiRm+NkPps8Ol0pHmrNteBGT8DrTaIMMiSyBuGSxjDv39ljBJpxW
         exvNrLhNWX7VtfPbiAw2BQvLVjgUqb7hsSqSWe0nOzTgTEcxr9lV2nDS7efrjhJFss
         R67RmrSOEQ8IvEnQ53O276uoCsDCfvSPNyQGd2ecvC7Ai4r+9PC2WQsAaL6l20TKyy
         H3DGzcxyhWhUWR38ytsnwzi7WChnmhclnnamr4N4DgAVt4R5VHadOI0kwkggO9fw2V
         VTRV6EgmOknoQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

This series makes some updates to mlx5 software steering.
and some other misc trivial changes.

For more information please see tag log below.

For the DR memory buddy allocator series, Yevgeny has updated
the implementation according to Dave's request [1] and got rid of
the bit array optimization and moved back to standard buddy
allocator implementation.

[1] https://patchwork.ozlabs.org/project/netdev/patch/20200925193809.463047=
-2-saeed@kernel.org/

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 6d89076e6ef09337a29a7b1ea4fdf2d892be9650=
:

  Merge branch 'net-mac80211-kernel-enable-kcov-remote-coverage-collection-=
for-802-11-frame-handling' (2020-11-02 18:01:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-11-03

for you to fetch changes up to 1c4cdf9aca10e949829ae56f4ab2f7dfa8098096:

  net: mlx5: Replace in_irq() usage (2020-11-03 11:40:03 -0800)

----------------------------------------------------------------
mlx5-updates-2020-11-03

This series includes updates to mlx5 software steering component.

1) Few improvements in the DR area, such as removing unneeded checks,
  renaming to better general names, refactor in some places, etc.

2) Software steering (DR) Memory management improvements

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

[PATH 4] net/mlx5: DR, Add buddy allocator utilities
  This patch adds a modified implementation of a well-known buddy allocator=
,
  adjusted for SW steering needs: the algorithm in principal is similar to
  the Linux physical page allocator, but in our case buddy allocator doesn'=
t
  really allocate a memory, but rather manages ICM memory that was previous=
ly
  allocated and registered.

[PATH 5] net/mlx5: DR, Handle ICM memory via buddy allocation instead of bu=
cket management
  This patch changes ICM management of SW steering to use buddy-system mech=
anism
  Instead of the previous bucket management.

[PATH 6] net/mlx5: DR, Sync chunks only during free
  This patch makes syncing happen only when freeing memory chunks.

[PATH 7] net/mlx5: DR, ICM memory pools sync optimization
  This patch adds tracking of pool's "hot" memory and makes the
  check whether steering sync is required much shorter and faster.

[PATH 8] net/mlx5: DR, Free buddy ICM memory if it is unused
  This patch adds tracking buddy's used ICM memory,
  and frees the buddy if all its memory becomes unused.

3) Misc code cleanups

----------------------------------------------------------------
Saeed Mahameed (2):
      net/mlx4: Cleanup kernel-doc warnings
      net/mlx5: Cleanup kernel-doc warnings

Sebastian Andrzej Siewior (1):
      net: mlx5: Replace in_irq() usage

Vladyslav Tarasiuk (1):
      net/mlx5e: Validate stop_room size upon user input

Yevgeny Kliteynik (8):
      net/mlx5: DR, Remove unused member of action struct
      net/mlx5: DR, Rename builders HW specific names
      net/mlx5: DR, Rename matcher functions to be more HW agnostic
      net/mlx5: DR, Add buddy allocator utilities
      net/mlx5: DR, Handle ICM memory via buddy allocation instead of bucke=
ts
      net/mlx5: DR, Sync chunks only during free
      net/mlx5: DR, ICM memory pools sync optimization
      net/mlx5: DR, Free unused buddy ICM memory

 drivers/net/ethernet/mellanox/mlx4/fw_qos.h        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  34 ++
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   4 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   8 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |   2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   6 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h |   8 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c         | 170 +++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 501 ++++++++---------=
----
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 107 +++--
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  42 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  79 ++--
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  32 ++
 19 files changed, 591 insertions(+), 467 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_bud=
dy.c
