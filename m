Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868AE5649C8
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiGCUyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGCUyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127D02649;
        Sun,  3 Jul 2022 13:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A18D5611CE;
        Sun,  3 Jul 2022 20:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B29C341C6;
        Sun,  3 Jul 2022 20:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881662;
        bh=X96i+ZVuGkRMM3XLkWiEvrgq+9S0LeFYUv9hPYYtdIA=;
        h=From:To:Cc:Subject:Date:From;
        b=jZxEsmMRAVeB3Bwr3Krkjl9u0zpyfHvwAKdxbBwhZdrkiWSfWr5KoNlBRq+n4Vkfb
         H1OkyA+PFJvR5LU98XMT3jWqPYoHd4d2Ys62sW2sjZWMZFhXh3l66eoJ4bd1lzqzQC
         yKpMaTZOKaTyxFRRMzi6oqTrSIPwo74On40PyGGMeAeDDSKLhdpNdTq8yuhyliNt0Q
         DdXQPONJzvO0oPGUuk12rT3UXSgZzXuCPdojohy1UocUMqpxWBLblAMPAlhY6/4Y2k
         KlIT7N1LNk2uX8pImJvXz0J8O/egPp2A4iJNo2rTwmtisYsBTpEdc0jEJvd+XBQOBM
         XTct1FWQyIZcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/5] mlx5-next updates 2022-07-03
Date:   Sun,  3 Jul 2022 13:54:02 -0700
Message-Id: <20220703205407.110890-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Mark Bloch Says:
================
Expose steering anchor

Expose a steering anchor per priority to allow users to re-inject
packets back into default NIC pipeline for additional processing.

MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
a user can use to re-inject packets at a specific priority.

A FTE (flow table entry) can be created and the flow table ID
used as a destination.

When a packet is taken into a RDMA-controlled steering domain (like
software steering) there may be a need to insert the packet back into
the default NIC pipeline. This exposes a flow table ID to the user that can
be used as a destination in a flow table entry.

With this new method priorities that are exposed to users via
MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.

As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
thus it's impossible to point to a NIC core flow table (core driver flow tables
are created with UID value of zero) from userspace.
Create flow tables that are exposed to users with the shared UID, this
allows users to point to default NIC flow tables.

Steering loops are prevented at FW level as FW enforces that no flow
table at level X can point to a table at level lower than X. 

===============

Mark Bloch (5):
  net/mlx5: Expose the ability to point to any UID from shared UID
  net/mlx5: fs, expose flow table ID to users
  net/mlx5: fs, allow flow table creation with a UID
  RDMA/mlx5: Refactor get flow table function
  RDMA/mlx5: Expose steering anchor to userspace

 drivers/infiniband/hw/mlx5/fs.c               | 159 ++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   6 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  16 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   8 +-
 .../mellanox/mlx5/core/steering/dr_cmd.c      |   1 +
 .../mellanox/mlx5/core/steering/dr_table.c    |   8 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |   1 +
 .../mellanox/mlx5/core/steering/fs_dr.c       |   7 +-
 .../mellanox/mlx5/core/steering/mlx5dr.h      |   3 +-
 include/linux/mlx5/fs.h                       |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |   6 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |  17 ++
 13 files changed, 204 insertions(+), 32 deletions(-)

-- 
2.36.1

