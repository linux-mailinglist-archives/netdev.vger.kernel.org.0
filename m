Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018526E88E7
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjDTD5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDTD5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD310D8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 20:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B5B7644A0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3568EC433EF;
        Thu, 20 Apr 2023 03:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681963020;
        bh=eyxJJ205C8kwvJ/EMckvx6qIq7dij8QGo5Er5FozDdw=;
        h=From:To:Cc:Subject:Date:From;
        b=bLuVY3k6GDzQC/84CRIsEatgEomx/QBWhVwUsJyv4U3iJX8E6W/iWxmuUD9R8ZNy4
         qymu833LciY9lliNKL+k+1/ss0RpRIUvdV6XpsfgaSvYcS+JRuSKq2w/0rZ+6MR9lc
         BDF/wA2OeXrCgjgxzMjMqkasFaHgr2+lUVMTRqM6Vx5Y5ZeECbLoPjgUmdK2bvjuKH
         H20j/TfTvFCKpqEkCdo6tQ01EQ9w8blndidSPfAVWHAn9Pr+Wrci34BaZArnkKtox9
         qqnmMH9yTdCEOnFdI/M/OFG4zgYwE50C6FNhr1OCQkFlvbCutSdJ+2wfofAvo0wNPF
         0l3F2HIj71htw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, shayd@nvidia.com,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH net] net/mlx5: Fix management PF condition
Date:   Wed, 19 Apr 2023 20:56:52 -0700
Message-Id: <20230420035652.295680-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Paul reports that it causes a regression with IB on CX4 and FW 12.18.1000

Management PF capabilities can be set on old FW due to the use of old
reserved bits, to avoid such issues, explicitly check for new Bluefield
devices as well as for management PF capabilities, since management PF
is a minimal eth device that is meant to communicate between the ARM cores
of the Bluefield chip and the BMC node.

This should Fix the issue since Bluefield devices have relatively new
firmwares that don't have this bug.

Fixes: fe998a3c77b9 ("net/mlx5: Enable management PF initialization")
Reported-by: Paul Moore <paul@paul-moore.com>
Link: https://lore.kernel.org/all/CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com/
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---

Notes:
    This patch has a couple of TOODs, since this is a fix, this is the
    shortest path to a solution, will do the refactoring later on net-next.

    I hope Paul can test it before tomorrow's net PR, and I will ask Shay to
    test internally if he could today.

 drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++++++---
 include/linux/mlx5/driver.h                    |  7 ++++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f1de152a6113..95818c5a132b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1737,8 +1737,13 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->device = &pdev->dev;
 	dev->pdev = pdev;
 
+	/** TODO: don't maintain both coredev_type and has_mpf fields, just copy
+	 * the value from id->driver_data into a new instance dev->driver_data
+	 * and use it as is in the helper functions.
+	 */
 	dev->coredev_type = id->driver_data & MLX5_PCI_DEV_IS_VF ?
 			 MLX5_COREDEV_VF : MLX5_COREDEV_PF;
+	dev->priv.has_mpf = id->driver_data & MLX5_DD_HAS_MPF;
 
 	dev->priv.adev_idx = mlx5_adev_idx_alloc();
 	if (dev->priv.adev_idx < 0) {
@@ -2026,9 +2031,12 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
-	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
-	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7 network controller */
-	{ PCI_VDEVICE(MELLANOX, 0xa2df) },			/* BlueField-4 integrated ConnectX-8 network controller */
+	/* BlueField-2 integrated ConnectX-6 Dx network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2d6), MLX5_DD_HAS_MPF},
+	/* BlueField-3 integrated ConnectX-7 network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2dc), MLX5_DD_HAS_MPF},
+	/* BlueField-4 integrated ConnectX-8 network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2df), MLX5_DD_HAS_MPF},
 	{ 0, }
 };
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f33389b42209..149e7e5a2cf7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -633,6 +633,7 @@ struct mlx5_priv {
 
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
+	bool has_mpf; /* TODO: Merge with mdev->coredev_type */
 #ifdef CONFIG_MLX5_SF
 	struct mlx5_vhca_state_notifier *vhca_state_notifier;
 	struct mlx5_sf_dev_table *sf_dev_table;
@@ -1197,8 +1198,9 @@ int mlx5_rdma_rn_get_params(struct mlx5_core_dev *mdev,
 			    struct ib_device *device,
 			    struct rdma_netdev_alloc_params *params);
 
-enum {
+enum { /* Per Device data */
 	MLX5_PCI_DEV_IS_VF		= 1 << 0,
+	MLX5_DD_HAS_MPF			= 1 << 1, /* Device has a management PF */
 };
 
 static inline bool mlx5_core_is_pf(const struct mlx5_core_dev *dev)
@@ -1213,6 +1215,9 @@ static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
 
 static inline bool mlx5_core_is_management_pf(const struct mlx5_core_dev *dev)
 {
+	if (!dev->priv.has_mpf) /* This device can support management PF ? */
+		return false;
+	/* is this an MPF function ? */
 	return MLX5_CAP_GEN(dev, num_ports) == 1 && !MLX5_CAP_GEN(dev, native_port_num);
 }
 
-- 
2.39.2

