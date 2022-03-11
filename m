Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF1C4D5CA2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343653AbiCKHlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242370AbiCKHlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5D1B756A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68F86CE2644
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243B0C340E9;
        Fri, 11 Mar 2022 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984440;
        bh=EpR60H40tVvDzcxuaaeVmWvV4OyK/UAiQOU+tOjJ6Ow=;
        h=From:To:Cc:Subject:Date:From;
        b=pMZDsr8OuK4W9jzbN1ghLPETavAb+fOgW1Yc8x7EWqNNxMezXLvUh12v8fcbuDoo2
         4946zjsSeumGC3MVf1UXZ9zRVIIGIG4YbAqhe4MtUBNjL056/qktVwHzPJaDce3exh
         4hd1P9aNAe/2awIBaRjqk0oNzwy3m36ikHMPLjWCqd2iLgVcw2wPbw0OCZp8xQ9mpe
         /Jt4ZvBQ+oJeun7C8S9R2pb2305or3V2HxB0vqcuGsqzekXVskYEaqTadQL3zEddNT
         P3dnBer0+f2FbasAEj2Nv46KRBzw2berxwQeTWEHwEO5RV+3aA7Nx4a7nPamE+uNLd
         N/6p0Rg/AQi2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-03-10
Date:   Thu, 10 Mar 2022 23:40:16 -0800
Message-Id: <20220311074031.645168-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 63f13b2e879679014f42b65fb50dabde02c85726:

  Merge branch 'net-ipa-use-bulk-interconnect-interfaces' (2022-03-10 21:20:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-03-10

for you to fetch changes up to 970adfb76095fa719778d70a6b86030d2feb88dd:

  net/mlx5e: Remove overzealous validations in netlink EEPROM query (2022-03-10 23:38:25 -0800)

----------------------------------------------------------------
mlx5-updates-2022-03-10

1) Leon removes useless includes from both mlx5 and mlx4
2) Tariq adds node awareness to some object allocations
3) Gal Cleanups and improvements to EEPROM query
4) Paul adds Software steering to Connection Tracking, to speed up
   CT Rules insertion.

Paul Blakey Says:
=================
To improve insertion rate, this series allows for using software
steering API directly instead of going through the fs_core layer.
This can be done for CT because it doesn't need fs_core layer extra
facilities, such as autogroups, FTE IDs and modifications (which require
a copy of the flow key/mask). Skipping fs_core layer also allows to
create the software steering objects (dr_* objects) ahead of time and
re-use them for multiple rules, whereas software steering under fs_core
creates them on the fly and discards them. This in turn increased insertion
rate.

The series first introduces a lightweight CT flow steering provider
with the first implementations using fs_core layer, and moves CT to use it.
The next patches implement a provider using software steering directly,
bypassing fs_core, and uses it if software steering is available.

=================

----------------------------------------------------------------
Gal Pressman (3):
      net/mlx5: Query the maximum MCIA register read size from firmware
      net/mlx5: Parse module mapping using mlx5_ifc
      net/mlx5e: Remove overzealous validations in netlink EEPROM query

Leon Romanovsky (2):
      net/mlx4: Delete useless moduleparam include
      net/mlx5: Delete useless module.h include

Paul Blakey (5):
      net/mlx5: CT: Introduce a platform for multiple flow steering providers
      net/mlx5: DR, Add helper to get backing dr table from a mlx5 flow table
      net/mlx5: Add smfs lib to export direct steering API to CT
      net/mlx5: CT: Add software steering ct flow steering provider
      net/mlx5: CT: Create smfs dr matchers dynamically

Tariq Toukan (5):
      net/mlx5: Node-aware allocation for the IRQ table
      net/mlx5: Node-aware allocation for the EQ table
      net/mlx5: Node-aware allocation for the EQs
      net/mlx5: Node-aware allocation for UAR
      net/mlx5: Node-aware allocation for the doorbell pgdir

 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   1 -
 .../net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h  |  49 +++
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c |  79 +++++
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c | 372 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  53 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  10 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 -
 .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c |  68 ++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h |  36 ++
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c      |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   1 -
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/pd.c       |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  37 +-
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       |   1 -
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |   1 -
 .../mellanox/mlx5/core/steering/dr_table.c         |   5 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |   9 +-
 include/linux/mlx5/mlx5_ifc.h                      |  12 +-
 include/linux/mlx5/port.h                          |   2 -
 33 files changed, 700 insertions(+), 69 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h
