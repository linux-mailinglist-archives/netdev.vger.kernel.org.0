Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8A4822C1
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242800AbhLaIU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242814AbhLaIUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2CCC061757
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34527B81D55
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD21C36AE9;
        Fri, 31 Dec 2021 08:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938850;
        bh=o2khhIZamMyXsj5MPZ4TFNTNwOS3sDu6p5LvJHhAKs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoQB4XTVQgv9C8Y1CcsWKUpiX1LWzgzCOLFc4VMzdY2B7xgGMDIsgv62c6iYVJITQ
         seFAWpwqwmR3CRCOkHy/dLhtcqwMLXb6u/ZcLfLqQ/z4rWh9cLXP0rzc02H1vTm0ne
         xfy99ItcI4X5eMaRMiBKE4rgwdCzRnWMKk5zTJ5kg0rhcmIOeSRqA0XCalV4BhaE4o
         4QQ0TdM0AAhXyRwmPc1Xyb3yZ0aHG9bc4ju2pDEvfqrQifRKL8XTZXUe1E53H0Z2N2
         GK0zHNbybl6X50zHdB8FTBX0QfgtmvE3yeaOBSObErkDj5yxkUPoL1RiHfvzx1wgVc
         rLChT+IuQK+8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 16/16] net/mlx5: Set SMFS as a default steering mode if device supports it
Date:   Fri, 31 Dec 2021 00:20:38 -0800
Message-Id: <20211231082038.106490-17-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Set SMFS (SW-managed flow steering) as a default steering mode
instead of DMFS (device-managed flow steering)

In SMFS, the driver writes the STEs (Steering Table Entries) directly
to the device's ICM, which allows for a higher rule insertion rate
than through using FW command interface, as it is done in DMFS.

SMFS/DMFS steering modes can be configured through devlink param
'flow_steering_mode'. The possible values are 'smfs' or 'dmfs'.
The desired 'flow_steering_mode' param value should be set before
enabling switchdev mode.

Example:

  # devlink dev param set pci/0000:05:00.0 name flow_steering_mode smfs
  # devlink dev eswitch set pci/0000:05:00.0 mode switchdev

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index cc76ceebd208..b628917e38e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3083,6 +3083,11 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 	steering->dev = dev;
 	dev->priv.steering = steering;
 
+	if (mlx5_fs_dr_is_supported(dev))
+		steering->mode = MLX5_FLOW_STEERING_MODE_SMFS;
+	else
+		steering->mode = MLX5_FLOW_STEERING_MODE_DMFS;
+
 	steering->fgs_cache = kmem_cache_create("mlx5_fs_fgs",
 						sizeof(struct mlx5_flow_group), 0,
 						0, NULL);
-- 
2.33.1

