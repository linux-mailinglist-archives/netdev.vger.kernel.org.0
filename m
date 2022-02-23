Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39244C0B6F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiBWFKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbiBWFKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4C460CF5;
        Tue, 22 Feb 2022 21:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4664CB81E7F;
        Wed, 23 Feb 2022 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E57EC340E7;
        Wed, 23 Feb 2022 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593009;
        bh=hyahgmDEs7JfyMAHhJsx103v2EM+b6FqfYfVbGNLDS8=;
        h=From:To:Cc:Subject:Date:From;
        b=j1UDfcKBKYwX8RgYJO2BwLU84oAQK8q2MRFv3e56qBa+adtg9HdHh+RfcPTm+NAmF
         iyP9ahNVR4FAKPUzPdAQRUNrv6J3CIH/TtsJMK5eKAuCdZEIUNmbQwjxMf55a3mui1
         B9BsSLMm3C6QPRyDTiWXnv77iXWVKEjVcVVdrWUPqS1EqqyqeSRb+RtN/mtLW/0tpM
         pL2Nw1SGJvFe4oWF09LJCPsu/8eSHUGEPnz6oLRhXMCWAXwqIDjMR/36HhbPJ2+vxR
         Nifpeq/t0vL29F24et84yqGXxW5ZSnUcDMdBswktpvd5LVpPpVuzfzvndwuIirtWIx
         gk0CO/+OOSctg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next/rdma-next 00/17] mlx5-next updates 2022-02-22
Date:   Tue, 22 Feb 2022 21:09:15 -0800
Message-Id: <20220223050932.244668-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub and Jason,

The following PR includes updates to mlx5-next branch:

Headlines: 
==========

1) Jakub cleans up unused static inline function

2) I did some low level firmware command interface return status changes to
provide the caller with full visibility on the error/status returned by
the Firmware.

3) Use the new command interface in RDMA DEVX usecases to avoid flooding
dmesg with some "expected" user error prone use cases.

4) Moshe also uses the new command interface to grab the specific error
code from MFRL register command to provide the exact error reason for
why SW reset couldn't perform internally in FW.

5) From Mark Bloch: Lag, drop packets in hardware when possible

In active-backup mode the inactive interface's packets are dropped by the
bond device. In switchdev where TC rules are offloaded to the FDB
this can lead to packets being hit in the FDB where without offload
they would have been dropped before reaching TC rules in the kernel.

Create a drop rule to make sure packets on inactive ports are dropped
before reaching the FDB.

Listen on NETDEV_CHANGEUPPER / NETDEV_CHANGEINFODATA events and record
the inactive state and offload accordingly.

==========

Please pull and let me know if there's any problem.

The following changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:

  Linux 5.17-rc1 (2022-01-23 10:12:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 03dd4b816a528472acbf56dad06e0e284eed876b:

  net/mlx5: Add clarification on sync reset failure (2022-02-22 20:56:28 -0800)

----------------------------------------------------------------
Jakub Kicinski (1):
      mlx5: remove usused static inlines

Mark Bloch (7):
      net/mlx5: Add ability to insert to specific flow group
      net/mlx5: E-switch, remove special uplink ingress ACL handling
      net/mlx5: E-switch, add drop rule support to ingress ACL
      net/mlx5: Lag, use local variable already defined to access E-Switch
      net/mlx5: Lag, don't use magic numbers for ports
      net/mlx5: Lag, record inactive state of bond device
      net/mlx5: Lag, offload active-backup drops to hardware

Moshe Shemesh (2):
      net/mlx5: Add reset_state field to MFRL register
      net/mlx5: Add clarification on sync reset failure

Saeed Mahameed (6):
      net/mlx5: cmdif, Return value improvements
      net/mlx5: cmdif, cmd_check refactoring
      net/mlx5: cmdif, Add new api for command execution
      net/mlx5: Use mlx5_cmd_do() in core create_{cq,dct}
      net/mlx5: cmdif, Refactor error handling and reporting of async commands
      RDMA/mlx5: Use new command interface API

Sunil Rani (1):
      net/mlx5: E-Switch, reserve and use same uplink metadata across ports

 drivers/infiniband/hw/mlx5/devx.c                              |  61 +++++++++++++++++++++++-----------------
 drivers/infiniband/hw/mlx5/mr.c                                |  15 +++++++++-
 drivers/infiniband/hw/mlx5/qp.c                                |   1 +
 drivers/infiniband/hw/mlx5/qpc.c                               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                  | 328 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------
 drivers/net/ethernet/mellanox/mlx5/core/cq.c                   |  17 +++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c              |  10 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h    |   9 ------
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c |  87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h         |  15 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h              |   3 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |  93 +++++++++++++++++-------------------------------------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c              |   9 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c             |  57 ++++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h             |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c              | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h              |   2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h          |   7 -----
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |   5 ++--
 drivers/net/ethernet/mellanox/mlx5/core/port.c                 |  20 ++++++++++---
 include/linux/mlx5/cq.h                                        |   2 ++
 include/linux/mlx5/driver.h                                    |  19 +++++--------
 include/linux/mlx5/fs.h                                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                                  |  14 +++++++--
 25 files changed, 640 insertions(+), 284 deletions(-)


-- 
2.35.1

