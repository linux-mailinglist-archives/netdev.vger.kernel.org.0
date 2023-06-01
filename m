Return-Path: <netdev+bounces-6996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 179AE7192E5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84C891C20F11
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06952748E;
	Thu,  1 Jun 2023 06:01:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660485C85
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1ACC433EF;
	Thu,  1 Jun 2023 06:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685599291;
	bh=iqJKYz7g6AkjTQg/OLioQ6HUfbQWKLmZ0jZKEbNrNz4=;
	h=From:To:Cc:Subject:Date:From;
	b=QCMMs2VcNX9wDjnDZ/aGUwPWkEiyec4rjio90DuQ5Hpz4MKXM5qvieIApEUaOuY89
	 F7CAC44/RbTsNbKwge7j8E4abq7L6gk35atqzJsCcbxCNiQA2+czSBninkiZTv9OF7
	 DPGhyAwgTuRfL9tvRn5nkORSRPwWWqRnRACUBz6biPCExr8y6Lyalu/E9aB47JYJEE
	 VomQlmI8Yr+PeyCXPQUCHqd1Y2raDp690f8dUD8Dv9jRKEYs5LYWNavg3ypMyslmV3
	 GGDQD+p038R1LJvgnNcyJjOYb9Wd/kpg+3cdJamTrJeS43TDJXCdklCwiOmZ6NfaOq
	 3QwaiN+mkJZVg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2023-05-31
Date: Wed, 31 May 2023 23:01:04 -0700
Message-Id: <20230601060118.154015-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series is part 1 of 2 part series to add 4 port lag support in
mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 60cbd38bb0ad9e4395fba9c6994f258f1d6cad51:

  Merge branch 'xstats-for-tc-taprio' (2023-05-31 10:00:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-05-31

for you to fetch changes up to 053540c77f58313451481890336d63ab49d7e1cb:

  net/mlx5: Devcom, extend mlx5_devcom_send_event to work with more than two devices (2023-05-31 22:15:40 -0700)

----------------------------------------------------------------
mlx5-updates-2023-05-31

net/mlx5: Support 4 ports VF LAG, part 1/2

This series continues the series[1] "Support 4 ports HCAs LAG mode"
by Mark Bloch. This series adds support for 4 ports VF LAG (single FDB
E-Switch).

This series of patches focuses on refactoring different sections of the
code that make assumptions about VF LAG supporting only two ports. For
instance, it assumes that each device can only have one peer.

Patches 1-5:
- Refactor ETH handling of TC rules of eswitches with peers.
Patch 6:
- Refactors peer miss group table.
Patches 7-9:
- Refactor single FDB E-Switch creation.
Patch 10:
- Refactor the DR layer.
Patches 11-14:
- Refactors devcom layer.

Next series will refactor LAG layer and enable 4 ports VF LAG.
This series specifically allows HCAs with 4 ports to create a VF LAG
with only 4 ports. It is not possible to create a VF LAG with 2 or 3
ports using HCAs that have 4 ports.

Currently, the Merged E-Switch feature only supports HCAs with 2 ports.
However, upcoming patches will introduce support for HCAs with 4 ports.

In order to activate VF LAG a user can execute:

devlink dev eswitch set pci/0000:08:00.0 mode switchdev
devlink dev eswitch set pci/0000:08:00.1 mode switchdev
devlink dev eswitch set pci/0000:08:00.2 mode switchdev
devlink dev eswitch set pci/0000:08:00.3 mode switchdev
ip link add name bond0 type bond
ip link set dev bond0 type bond mode 802.3ad
ip link set dev eth2 master bond0
ip link set dev eth3 master bond0
ip link set dev eth4 master bond0
ip link set dev eth5 master bond0

Where eth2, eth3, eth4 and eth5 are net-interfaces of pci/0000:08:00.0
pci/0000:08:00.1 pci/0000:08:00.2 pci/0000:08:00.3 respectively.

User can verify LAG state and type via debugfs:
/sys/kernel/debug/mlx5/0000\:08\:00.0/lag/state
/sys/kernel/debug/mlx5/0000\:08\:00.0/lag/type

[1]
https://lore.kernel.org/netdev/20220510055743.118828-1-saeedm@nvidia.com/

----------------------------------------------------------------
Mark Bloch (3):
      net/mlx5e: en_tc, Extend peer flows to a list
      net/mlx5e: rep, store send to vport rules per peer
      net/mlx5e: en_tc, re-factor query route port

Shay Drory (11):
      net/mlx5e: tc, Refactor peer add/del flow
      net/mlx5e: Handle offloads flows per peer
      net/mlx5: E-switch, enlarge peer miss group table
      net/mlx5: E-switch, refactor FDB miss rule add/remove
      net/mlx5: E-switch, Handle multiple master egress rules
      net/mlx5: E-switch, generalize shared FDB creation
      net/mlx5: DR, handle more than one peer domain
      net/mlx5: Devcom, Rename paired to ready
      net/mlx5: E-switch, mark devcom as not ready when all eswitches are unpaired
      net/mlx5: Devcom, introduce devcom_for_each_peer_entry
      net/mlx5: Devcom, extend mlx5_devcom_send_event to work with more than two devices

 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 137 ++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 183 +++++++++++++--------
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |  25 ++-
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |   1 +
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  30 +++-
 .../ethernet/mellanox/mlx5/core/esw/bridge_mcast.c |  21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  32 +++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 176 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  39 ++++-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   | 124 +++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |  35 ++--
 .../mellanox/mlx5/core/steering/dr_action.c        |   5 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  13 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   9 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   9 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +-
 24 files changed, 603 insertions(+), 271 deletions(-)

