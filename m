Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BFF42FF7F
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhJPAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhJPAlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7101A61213;
        Sat, 16 Oct 2021 00:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344749;
        bh=3JEkdsaOUEzDd/M/5dKcG+GBHXr93rWbc67zRnpZMPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGofDhAAYS2pTRc4OqGYRJZoQ7sZR6CxKWup+D39bqBDvoHIQLVKug60iQLmV/9p4
         GbPKTBxExoWWfsKn3fBtyf8rMLTO4PfoJBz/ffmLvEhC1j6uua9tzSs6GwArrKtWam
         HdhzXIJnLpD7yi2ERqRVU9O9QWyYYhDIwqPlWmtqAZz2BbD7Enu8Ydqob6rKQLqKla
         V5K8rDXak37GKuY5k5XIqJJvHxbjUh/04ITEGjTg1ZVLSeTO+5k+9X2Og7Lp0nW7FR
         MwhtOrOMRlijwJcj4mGTFwQnjUi/AIL6VSPAs93vzAlo8QohDBjvwfYRTNqkyVRdDD
         0myoJzhDu4O3A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/13] net/mlx5: Use system_image_guid to determine bonding
Date:   Fri, 15 Oct 2021 17:39:02 -0700
Message-Id: <20211016003902.57116-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

With specific NICs, the PFs may have different PCIe ids like
0001:01:00.0/1 and 0002:02:00:00/1.

For PFs with the same system_image_guid, driver should consider
them under the same physical NIC and they are legal to bond together.

If firmware doesn't support system_image_guid, set it to zero and
fallback to use PCIe ids.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index e8093c4e09d4..a8b84d53dfb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -33,6 +33,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eswitch.h>
 #include <linux/mlx5/mlx5_ifc_vdpa.h>
+#include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 
 /* intf dev list mutex */
@@ -537,6 +538,16 @@ int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 	return add_drivers(dev);
 }
 
+static bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev)
+{
+	u64 fsystem_guid, psystem_guid;
+
+	fsystem_guid = mlx5_query_nic_system_image_guid(dev);
+	psystem_guid = mlx5_query_nic_system_image_guid(peer_dev);
+
+	return (fsystem_guid && psystem_guid && fsystem_guid == psystem_guid);
+}
+
 static u32 mlx5_gen_pci_id(const struct mlx5_core_dev *dev)
 {
 	return (u32)((pci_domain_nr(dev->pdev->bus) << 16) |
@@ -556,7 +567,8 @@ static int next_phys_dev(struct device *dev, const void *data)
 	if (mdev == curr)
 		return 0;
 
-	if (mlx5_gen_pci_id(mdev) != mlx5_gen_pci_id(curr))
+	if (!mlx5_same_hw_devs(mdev, (struct mlx5_core_dev *)curr) &&
+	    mlx5_gen_pci_id(mdev) != mlx5_gen_pci_id(curr))
 		return 0;
 
 	return 1;
-- 
2.31.1

