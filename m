Return-Path: <netdev+bounces-9761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A49372A79C
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E98832818D0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE1115C2;
	Sat, 10 Jun 2023 01:43:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C3139E
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D67C433D2;
	Sat, 10 Jun 2023 01:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361384;
	bh=ILqQ1TWZhr+O4yNK5aUK2DurCy2jPuER/swFDGOcbGI=;
	h=From:To:Cc:Subject:Date:From;
	b=d2e6PZHBdVzdNMBOloJKpNp+XyLsrW9B0TUquf/ewINZTlK4JH1bvUBV1adZzmCk6
	 UUyt0r0U2HsmpCXfTskCNL7aviIj02U8ouxAJdTDa2RXmZybN7Q7PwROKa7F4gyPvu
	 vN0qyGAAumO/U2Lkj0u5pL4Q+3V/g5QQzzd/LI9H7kdDFKIrhkyrndYF0jvnmB5OBN
	 cjvb9Ai6E9UPysODExaPaDxkDdIRKMHh6CRf/swJAZ1opdu2HqNlMtpE8+PZt77WtM
	 PH02XfXfNQCpfM856CSnC6/V+RJONAVxR4RCWgSy7I0trUTnJWtLjPCBj9701mLlLR
	 okXfojAVNg0QQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-06-09
Date: Fri,  9 Jun 2023 18:42:39 -0700
Message-Id: <20230610014254.343576-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This pull adds the following to mlx5 features:
1) Embedded CPU Virtual Functions
2) Lightweight local SFs

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit ded5c1a16ec69bb815f2b7d9ea4028913ebffca4:

  Merge branch 'tools-ynl-gen-code-gen-improvements-before-ethtool' (2023-06-09 14:40:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-06-09

for you to fetch changes up to 978015f7ef9240acfb078f4c1c0d79459b42f951:

  net/mlx5e: Remove a useless function call (2023-06-09 18:40:53 -0700)

----------------------------------------------------------------
mlx5-updates-2023-06-09

1) Embedded CPU Virtual Functions
2) Lightweight local SFs

Daniel Jurgens says:
====================
Embedded CPU Virtual Functions

This series enables the creation of virtual functions on Bluefield (the
embedded CPU platform). Embedded CPU virtual functions (EC VFs). EC VF
creation, deletion and management interfaces are the same as those for
virtual functions in a server with a Connect-X NIC.

When using EC VFs on the ARM the creation of virtual functions on the
host system is still supported. Host VFs eswitch vports occupy a range
of 1..max_vfs, the EC VF vport range is max_vfs+1..max_ec_vfs.

Every function (PF, ECPF, VF, EC VF, and subfunction) has a function ID
associated with it. Prior to this series the function ID and the eswitch
vport were the same. That is no longer the case, the EC VF function ID
range is 1..max_ec_vfs. When querying or setting the capabilities of an
EC VF function an new bit must be set in the query/set HCA cap
structure.

This is a high level overview of the changes made:
	- Allocate vports for EC VFs if they are enabled.
	- Create representors and devlink ports for the EC VF vports.
	- When querying/setting HCA caps by vport break the assumption
	  that function ID is the same a vport number and adjust
	  accordingly.
	- Create a new type of page, so that when SRIOV on the ARM is
	  disabled, but remains enabled on the host, the driver can
	  wait for the correct pages.
	- Update SRIOV code to support EC VF creation/deletion.

===================

Lightweight local SFs:

Last 3 patches form Shay Drory:

SFs are heavy weight and by default they come with the full package of
ConnectX features. Usually users want specialized SFs for one specific
purpose and using devlink users will almost always override the set of
advertises features of an SF and reload it.

Shay Drory says:
================
In order to avoid the wasted time and resources on the reload, local SFs
will probe without any auxiliary sub-device, so that the SFs can be
configured prior to its full probe.

The defaults of the enable_* devlink params of these SFs are set to
false.

Usage example:
Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Enable ETH auxiliary device:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_eth value true cmode driverinit

Now, in order to fully probe the SF, use devlink reload:
$ devlink dev reload auxiliary/mlx5_core.sf.1

At this point the user have SF devlink instance with auxiliary device
for the Ethernet functionality only.

================

----------------------------------------------------------------
Christophe JAILLET (1):
      net/mlx5e: Remove a useless function call

Daniel Jurgens (11):
      net/mlx5: Simplify unload all rep code
      net/mlx5: mlx5_ifc updates for embedded CPU SRIOV
      net/mlx5: Enable devlink port for embedded cpu VF vports
      net/mlx5: Update vport caps query/set for EC VFs
      net/mlx5: Add management of EC VF vports
      net/mlx5: Add/remove peer miss rules for EC VFs
      net/mlx5: Add new page type for EC VF pages
      net/mlx5: Use correct vport when restoring GUIDs
      net/mlx5: Query correct caps for min msix vectors
      net/mlx5: Update SRIOV enable/disable to handle EC/VFs
      net/mlx5: Set max number of embedded CPU VFs

Shay Drory (3):
      net/mlx5: Split function_setup() to enable and open functions
      net/mlx5: Move esw multiport devlink param to eswitch code
      net/mlx5: Light probe local SFs

 .../ethernet/mellanox/mlx5/switchdev.rst           |  20 ++
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  16 ++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  54 ++----
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 174 +++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  13 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 102 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  24 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 209 +++++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  35 +++-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  16 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  46 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  19 +-
 include/linux/mlx5/driver.h                        |   7 +
 include/linux/mlx5/mlx5_ifc.h                      |  11 +-
 include/linux/mlx5/vport.h                         |   2 +-
 20 files changed, 610 insertions(+), 177 deletions(-)

