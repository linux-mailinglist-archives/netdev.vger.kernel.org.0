Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073564C2003
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbiBWXkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243095AbiBWXkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7B05B3C8;
        Wed, 23 Feb 2022 15:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AB1661A09;
        Wed, 23 Feb 2022 23:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942CBC340E7;
        Wed, 23 Feb 2022 23:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659577;
        bh=OItCKh58/aajz/pTnTukWCWzM/ikpHZ0lMD9+lTG2jc=;
        h=From:To:Cc:Subject:Date:From;
        b=IqPaiVFZ4YwhriP9WHFhCPxSbtCj/NphtRNO2ccHshrR2f1H6g9dveT0GijOmnwNL
         MlDTeyotSNGWqpjUaiJBDfF5qV9Hfkpb92IOKq+XLp6aDBXKyIqD1G8HJm7pkZMLGp
         cGHKeXPjTb0r63i3AwQyin7cjjJSCW6g5BQQtWkkkFoRDRfH023Cw7D/8e+SwjrqhO
         P19Eb6i6C7gx3xiDYXmVksBuVppr2Uk2aNn+gwz4N/OXdj6gdvnZWEffF2Rs14jVOW
         zNrVPNU+bHW2Px8TZE+blPfkF5EZ+masPe0xHl++N+7R9NcL4evjTDHRFza7YcNVkm
         jYtfTJ5KV+Z4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][for-next v2 00/17] mlx5-next 2022-22-02
Date:   Wed, 23 Feb 2022 15:39:13 -0800
Message-Id: <20220223233930.319301-1-saeed@kernel.org>
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

v1->v2:
 - Fix typo in the 1st patch's title

The following PR includes updates to mlx5-next branch:

Headlines: 
==========

1) Jakub cleans up unused static inline functions

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

for you to fetch changes up to 45fee8edb4b333af79efad7a99de51718ebda94b:

  net/mlx5: Add clarification on sync reset failure (2022-02-23 15:21:59 -0800)

----------------------------------------------------------------
Jakub Kicinski (1):
      mlx5: remove unused static inlines

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

 drivers/infiniband/hw/mlx5/devx.c                              |  61 +++++++------
 drivers/infiniband/hw/mlx5/mr.c                                |  15 +++-
 drivers/infiniband/hw/mlx5/qp.c                                |   1 +
 drivers/infiniband/hw/mlx5/qpc.c                               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                  | 328 +++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/net/ethernet/mellanox/mlx5/core/cq.c                   |  17 +++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c              |  10 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h    |   9 --
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c |  87 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h         |  15 ++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h              |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |  93 ++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c              |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c             |  57 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h             |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c              | 142 +++++++++++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h              |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h          |   7 --
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c                 |  20 ++++-
 include/linux/mlx5/cq.h                                        |   2 +
 include/linux/mlx5/driver.h                                    |  19 ++--
 include/linux/mlx5/fs.h                                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                                  |  14 ++-
 25 files changed, 640 insertions(+), 284 deletions(-)

-- 
2.35.1

