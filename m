Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B970F539849
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347782AbiEaUzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbiEaUzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1749CF71
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41E4EB816C5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E415BC3411E;
        Tue, 31 May 2022 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030510;
        bh=erDxHPUna1RJgRiVlJXVPWys+11srRfuFK/gWtgqaQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAJ68lYcC5HNI9AdpFlXXzW4jhmf1lR911y4LiDFJgJLfLjAWkyaopiVIXGsz7m5c
         HPT/YNm7ODd3usAxT4z7u/zXFOAwfYF8GGc7bdddVkjO3rxdSVJAzRGSl7SwOsmk4s
         hr3X0JP/YcGjNf262ecadMXu2ZefHM6zuO+2yGBcHwd2yhfzuHfv7PfldJC6Zt9WCi
         RLzNMGGjMgtKoFRsr8vyUit4fnlD7J41Q6BrZ3Up/ny++7hhTcexiy/VvmjEdehXlP
         YQHxBz1kXLd/zbnywGZcl8RxJQToo+vSw8lrC0pFpWzCgqCS839axdjmeHthpDJHYh
         ksI+Z5XvuxvKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net 7/7] net/mlx5: Fix mlx5_get_next_dev() peer device matching
Date:   Tue, 31 May 2022 13:54:47 -0700
Message-Id: <20220531205447.99236-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

In some use-cases, mlx5 instances will need to search for their peer
device (the other port on the same HCA). For that, mlx5 device matching
mechanism relied on auxiliary_find_device() to search, and used a bad matching
callback function.

This approach has two issues:

1) next_phys_dev() the matching function, assumed all devices are
   of the type mlx5_adev (mlx5 auxiliary device) which is wrong and
   could lead to crashes, this worked for a while, since only lately
   other drivers started registering auxiliary devices.

2) using the auxiliary class bus (auxiliary_find_device) to search for
   mlx5_core_dev devices, who are actually PCIe device instances, is wrong.
   This works since mlx5_core always has at least one mlx5_adev instance
   hanging around in the aux bus.

As suggested by others we can fix 1. by comparing device names prefixes
if they have the string "mlx5_core" in them, which is not a best practice !
but even with that fixed, still 2. needs fixing, we are trying to
match pcie device peers so we should look in the right bus (pci bus),
hence this fix.

The fix:
1) search the pci bus for mlx5 peer devices, instead of the aux bus
2) to validated devices are the same type "mlx5_core_dev" compare if
   they have the same driver, which is bulletproof.

   This wouldn't have worked with the aux bus since the various mlx5 aux
   device types don't share the same driver, even if they share the same device
   wrapper struct (mlx5_adev) "which helped to find the parent device"

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reported-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 11f7c03ae81b..0eb9d74547f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -571,18 +571,32 @@ static int _next_phys_dev(struct mlx5_core_dev *mdev,
 	return 1;
 }
 
+static void *pci_get_other_drvdata(struct device *this, struct device *other)
+{
+	if (this->driver != other->driver)
+		return NULL;
+
+	return pci_get_drvdata(to_pci_dev(other));
+}
+
 static int next_phys_dev(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
+
+	mdev = pci_get_other_drvdata(this->device, dev);
+	if (!mdev)
+		return 0;
 
 	return _next_phys_dev(mdev, data);
 }
 
 static int next_phys_dev_lag(struct device *dev, const void *data)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
+	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
+
+	mdev = pci_get_other_drvdata(this->device, dev);
+	if (!mdev)
+		return 0;
 
 	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
 	    !MLX5_CAP_GEN(mdev, lag_master) ||
@@ -596,19 +610,17 @@ static int next_phys_dev_lag(struct device *dev, const void *data)
 static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
 					       int (*match)(struct device *dev, const void *data))
 {
-	struct auxiliary_device *adev;
-	struct mlx5_adev *madev;
+	struct device *next;
 
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
 
-	adev = auxiliary_find_device(NULL, dev, match);
-	if (!adev)
+	next = bus_find_device(&pci_bus_type, NULL, dev, match);
+	if (!next)
 		return NULL;
 
-	madev = container_of(adev, struct mlx5_adev, adev);
-	put_device(&adev->dev);
-	return madev->mdev;
+	put_device(next);
+	return pci_get_drvdata(to_pci_dev(next));
 }
 
 /* Must be called with intf_mutex held */
-- 
2.36.1

