Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29736DC718
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjDJNIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjDJNIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879586BF;
        Mon, 10 Apr 2023 06:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77AD960F55;
        Mon, 10 Apr 2023 13:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63147C433EF;
        Mon, 10 Apr 2023 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681132094;
        bh=WMRsTNuhJXYmIoY4hiVBFzSXG5imY3zKDMApu1L1yZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5kVBltc15hXuNexhhzD3x7R8JfieNEvZAv0JurPVPWCrmDmp1olUvVk2UUALEKEa
         GI3OsHULJwhQlZEN1cY2Gvy7WW2eCSzPtqCGPh2t2U9uqUbolNvNjxli1gKCAOL+77
         XIXZUTXcKXW71Axw7f9jMDMbYouGyWVmRAZkZv/fehIRmWlDZUYaHm2iZr0sPYzqw2
         FSg7sFMoZcGmemBCrDZ97eZU1aFqQAPzdgZ233BvBIf5uyxTJq8CV1G3tBNncYiHor
         /fnY2IPakHjYL6FiV5bv0SASLwCuk4V771ebllsbMj8D5iFEE7cuTsF62ImzELtNfi
         Em2OGTXQeH+bQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-next 2/4] RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
Date:   Mon, 10 Apr 2023 16:07:51 +0300
Message-Id: <8d39eb8317e7bed1a354311a20ae707788fd94ed.1681131553.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681131553.git.leon@kernel.org>
References: <cover.1681131553.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

relaxed_ordering_read HCA capability is set if both the device supports
relaxed ordering (RO) read and RO is set in PCI config space.

RO in PCI config space can change during runtime. This will change the
value of relaxed_ordering_read HCA capability in FW, but the driver will
not see it since it queries the capabilities only once.

This can lead to the following scenario:
1. RO in PCI config space is enabled.
2. User creates MKey without RO.
3. RO in PCI config space is disabled.
   As a result, relaxed_ordering_read HCA capability is turned off in FW
   but remains on in driver copy of the capabilities.
4. User requests to reconfig the MKey with RO via UMR.
5. Driver will try to reconfig the MKey with RO read although it
   shouldn't (as relaxed_ordering_read HCA capability is really off).

To fix this, check pcie_relaxed_ordering_enabled() before setting RO
read in UMR.

Fixes: 896ec9735336 ("RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7")
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/umr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 55f4e048d947..c9e176e8ced4 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -380,6 +380,9 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
+	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
+		       pcie_relaxed_ordering_enabled(dev->mdev->pdev);
+
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
@@ -387,8 +390,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, lr, 1);
 	MLX5_SET(mkc, seg, relaxed_ordering_write,
 		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, relaxed_ordering_read,
-		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
+	MLX5_SET(mkc, seg, relaxed_ordering_read, ro_read);
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
-- 
2.39.2

