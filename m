Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4964432C2A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJSDXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhJSDXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A9D66128B;
        Tue, 19 Oct 2021 03:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613649;
        bh=Cs8sRn/8o+XG/ELauySlS9OJB3T+Sl+oFysUxfr6qP8=;
        h=From:To:Cc:Subject:Date:From;
        b=FPLVAgsJMGpezENeW8lMuY/DWeOgF1cuiqgdqji4Z3LwrGWAt0uclCbFKyLk+bsqU
         Uiu2IQbbeGXm68WvLdyLvw8fODHEIxvGF5b2cLn0eAsmeCyL4REXAMqLeHHL2vzCKQ
         7dARp2BUW3kO51fSfwVLxGvfNgH09BwXBNFg2z5xMSaN3tcMhYecUQB+BL8TQI68HU
         xS+tW0IOiR8DRzcCJ4HyifnWhuRzFjaN/HOcptZ6g7j6OY+ScmmqOb5DeaeWsy7fIO
         hCw7Vy+Y+aakCfa5/0s7Pmlyr4RcFwBIELPCd3y6DBBKGNo5G9RMB3/W1yMic+EBd7
         Tp/rx243L0Gow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/13] mlx5 updates 2021-10-18
Date:   Mon, 18 Oct 2021 20:20:34 -0700
Message-Id: <20211019032047.55660-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series adds the support for new lag mode based on packet hash in
mlx5 driver, for more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 939a6567f976efb8b3e6d601ce35eb56b17babd0:

  qed: Change the TCP common variable - "iscsi_ooo" (2021-10-18 15:58:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-18

for you to fetch changes up to d40bfeddacd6b4c05a28e3e8f7cb18989a4e134f:

  net/mlx5: E-Switch, Increase supported number of forward destinations to 32 (2021-10-18 20:18:10 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-18

Maor Maor Gottlieb says:
========================
Use hash to select the affinity port in VF LAG

Current VF LAG architecture is based on QP association with a port.
QP must be created after LAG is enabled to allow association with non-native port.
VM Packets going on slow-path to eSwicth manager (SW path or hairpin) will be transmitted
through a different QP than the VM. This means that Different packets of the same flow might
egress from different physical ports.

This patch-set solves this issue by moving the port selection to be based on the hash function
defined by the bond.

When the device is moved to VF LAG mode, the driver creates TTC (traffic type classifier) flow
tables in order to classify the packet and steer it to the relevant hash function. Similar to what
is done in the mlx5 RSS implementation.

Each rule in the TTC table, forwards the packet to port selection flow table which has one hash
split flow group which contains two "catch all" flow table entries. Each entry point to the
relative uplink port. As shown below:

		-------------------
		| FT              |
TTC rule ->	|     ----------- |
		|   FG|   FTE --|-|-----> uplink of port #1
		|     |   FTE --|-|-----> uplink of port #2
		|     ----------- |
		-------------------

Hash split flow group is flow group that created as type of HASH_SPLIT and associated with match definer.
The match definer define the fields which included in the hash calculation.

The driver creates the match definer according to the xmit hash policy of the bond driver.

Patches overview:
========================

Minor E-Switch updates:
- Patch #12, dynamic  allocation of dest array
- Patch #13, increase number of forward destinations to 32

----------------------------------------------------------------
Maor Dickman (2):
      net/mlx5: E-Switch, Use dynamic alloc for dest array
      net/mlx5: E-Switch, Increase supported number of forward destinations to 32

Maor Gottlieb (11):
      net/mlx5: Support partial TTC rules
      net/mlx5: Introduce port selection namespace
      net/mlx5: Add support to create match definer
      net/mlx5: Introduce new uplink destination type
      net/mlx5: Lag, move lag files into directory
      net/mlx5: Lag, set LAG traffic type mapping
      net/mlx5: Lag, set match mask according to the traffic type bitmap
      net/mlx5: Lag, add support to create definers for LAG
      net/mlx5: Lag, add support to create TTC tables for LAG port selection
      net/mlx5: Lag, add support to create/destroy/modify port selection
      net/mlx5: Lag, use steering to select the affinity port in LAG

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   4 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  66 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  72 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 .../ethernet/mellanox/mlx5/core/{ => lag}/lag.c    |  98 +++-
 .../ethernet/mellanox/mlx5/core/{ => lag}/lag.h    |   9 +-
 .../mellanox/mlx5/core/{lag_mp.c => lag/mp.c}      |   4 +-
 .../mellanox/mlx5/core/{lag_mp.h => lag/mp.h}      |   0
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 611 +++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.h |  52 ++
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |   4 +
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  15 +
 include/linux/mlx5/device.h                        |  15 +
 include/linux/mlx5/fs.h                            |   9 +
 include/linux/mlx5/mlx5_ifc.h                      | 298 +++++++++-
 22 files changed, 1239 insertions(+), 64 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.c (92%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.h (89%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.c => lag/mp.c} (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.h => lag/mp.h} (100%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
