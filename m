Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69636DC716
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjDJNIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDJNIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:08:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BAC8A48;
        Mon, 10 Apr 2023 06:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F19D61BFB;
        Mon, 10 Apr 2023 13:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DBBC433EF;
        Mon, 10 Apr 2023 13:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681132090;
        bh=sMV/A2TujUcyuHApI+uvfzJpsNr+uQyDBLlsO5Clx6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+tfqksk67YDdTtmuMAhDY03HNm/YmHpjQKUQgiYGEmciB3mlZBMYX72YdzZGHHDf
         7QPIQfMOPub4qFZ/i8gv6wDbbBBdxCXa4UPvL9BSW9a77ypXRrQLVVnKAF7Q8VnBbt
         21I+6nVghJwJbUPypbWzl6/B3V+iKj6HXjKmxn7lTHpoejmemdxwkRTcRGMKou/b/M
         OSbqzspmIQV96BCd9bF2iLUDW4VXzGbACwzODhm9yRuelB8L3Llayhhqaym6EUJcup
         q5p+3ekTq8C7zdCnpdVX3aRiD8QQg0ZJ9O1P5Ykf5DcbKTL+jRKQvIdlKOpCaKfDt8
         GBt3BZ1enyLGA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 4/4] RDMA/mlx5: Allow relaxed ordering read in VFs and VMs
Date:   Mon, 10 Apr 2023 16:07:53 +0300
Message-Id: <e7048640d66c341a8fa0465e099926e7989184bc.1681131553.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681131553.git.leon@kernel.org>
References: <cover.1681131553.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

According to PCIe spec, Enable Relaxed Ordering value in the VF's PCI
config space is wired to 0 and PF relaxed ordering (RO) setting should
be applied to the VF. In QEMU (and maybe others), when assigning VFs,
the RO bit in PCI config space is not emulated properly and is always
set to 0.

Therefore, pcie_relaxed_ordering_enabled() always returns 0 for VFs and
VMs and thus MKeys can't be created with RO read even if the PF supports
it.

pcie_relaxed_ordering_enabled() check was added to avoid a syndrome when
creating a MKey with relaxed ordering (RO) enabled when the driver's
relaxed_ordering_read_pci_enabled HCA capability is out of sync with FW.
With the new relaxed_ordering_read capability this can't happen, as it's
set regardless of RO value in PCI config space and thus can't change
during runtime.

Hence, to allow RO read in VFs and VMs, use the new HCA capability
relaxed_ordering_read without checking pcie_relaxed_ordering_enabled().
The old capability checks are kept for backward compatibility with older
FWs.

Allowing RO in VFs and VMs is valuable since it can greatly improve
performance on some setups. For example, testing throughput of a VF on
an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
improvement.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c                     | 11 +++++++----
 drivers/infiniband/hw/mlx5/umr.c                    |  3 ++-
 drivers/infiniband/hw/mlx5/umr.h                    |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c |  7 ++++---
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index a7f0119cc959..1ce48e485c5b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -72,9 +72,11 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	if (acc & IB_ACCESS_RELAXED_ORDERING) {
 		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
 			MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
-		if (MLX5_CAP_GEN(dev->mdev,
-				 relaxed_ordering_read_pci_enabled) &&
-		    pcie_relaxed_ordering_enabled(dev->mdev->pdev))
+
+		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+		    (MLX5_CAP_GEN(dev->mdev,
+				  relaxed_ordering_read_pci_enabled) &&
+		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
 			MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
 	}
 
@@ -794,7 +796,8 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled) &&
+	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
 	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index c9e176e8ced4..234bf30db731 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -381,7 +381,8 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       unsigned int access_flags)
 {
 	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       pcie_relaxed_ordering_enabled(dev->mdev->pdev);
+		       (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
 
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index e12ecd7e079c..3799bb758e49 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -62,7 +62,8 @@ static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled) &&
+	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
 	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 3c765a1f91a5..1f90594499c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -39,11 +39,12 @@
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
-	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
 	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
-	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled);
+	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+		       (pcie_relaxed_ordering_enabled(mdev->pdev) &&
+			MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled));
 
-	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_pci_enable && ro_read);
+	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
 	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
 }
 
-- 
2.39.2

