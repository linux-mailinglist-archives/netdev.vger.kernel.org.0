Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C556DC714
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDJNIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjDJNIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE0C93C8;
        Mon, 10 Apr 2023 06:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66BCD60D37;
        Mon, 10 Apr 2023 13:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51743C433EF;
        Mon, 10 Apr 2023 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681132086;
        bh=wVQBcleMDZi2qFubbCjY6UzljtovnvgS87AJpJ4tVUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XL+RXcYt90+1igBHoCB5Mr8BKYdq88Sd+We8yd0PxhdmJ5r11tlBwzl4kYD5L+ebd
         y9f6At6xULbbQOESN2T5l8JQd2KZjy97vjcIUXYQmEV29/o+19ixx+CURKn0AaVcMo
         ntVwk+PnJXv2SdyVpRs5w9vJF484OQrFPfwMcYI4ipeehn/ZnxDcAlngTbjuq0UfV6
         1FVzYSEYHfA0Gd6JtSKFmiylpWo04ax891eOaTmrkWhN1x6s0epmrpmiedG3uXYW1C
         fWsz5+RQapRKrTGNq97aGRHFZOqwqE9fEkuv68CJhXZlXgOHIoTopB5q+0sEGl7qD9
         KzTAAZxxaKaBQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Update relaxed ordering read HCA capabilities
Date:   Mon, 10 Apr 2023 16:07:52 +0300
Message-Id: <caa0002fd8135086357dfcc368e2f5cc73b08480.1681131553.git.leon@kernel.org>
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

Rename existing HCA capability relaxed_ordering_read to
relaxed_ordering_read_pci_enabled. This is in accordance with recent PRM
change to better describe the capability, as it's set only if both the
device supports relaxed ordering (RO) read and RO is enabled in PCI
config space.

In addition, add new HCA capability relaxed_ordering_read which is set
if the device supports RO read, regardless of RO in PCI config space.
This will be used in the following patch to allow RO in VFs and VMs.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c                     | 5 +++--
 drivers/infiniband/hw/mlx5/umr.h                    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                       | 5 +++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bb8f318bd5a5..a7f0119cc959 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -72,7 +72,8 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	if (acc & IB_ACCESS_RELAXED_ORDERING) {
 		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
 			MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) &&
+		if (MLX5_CAP_GEN(dev->mdev,
+				 relaxed_ordering_read_pci_enabled) &&
 		    pcie_relaxed_ordering_enabled(dev->mdev->pdev))
 			MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
 	}
@@ -793,7 +794,7 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) &&
+	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled) &&
 	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index c9d0021381a2..e12ecd7e079c 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -62,7 +62,7 @@ static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) &&
+	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled) &&
 	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index 993af4c12d90..3c765a1f91a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -41,7 +41,7 @@ void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
 	bool ro_pci_enable = pcie_relaxed_ordering_enabled(mdev->pdev);
 	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
-	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read);
+	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled);
 
 	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_pci_enable && ro_read);
 	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e4306cd87cd7..b54339a1b1c6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1511,7 +1511,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         log_max_eq_sz[0x8];
 	u8         relaxed_ordering_write[0x1];
-	u8         relaxed_ordering_read[0x1];
+	u8         relaxed_ordering_read_pci_enabled[0x1];
 	u8         log_max_mkey[0x6];
 	u8         reserved_at_f0[0x6];
 	u8	   terminate_scatter_list_mkey[0x1];
@@ -1727,7 +1727,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_320[0x3];
 	u8         log_max_transport_domain[0x5];
-	u8         reserved_at_328[0x3];
+	u8         reserved_at_328[0x2];
+	u8	   relaxed_ordering_read[0x1];
 	u8         log_max_pd[0x5];
 	u8         reserved_at_330[0x9];
 	u8         q_counter_aggregation[0x1];
-- 
2.39.2

