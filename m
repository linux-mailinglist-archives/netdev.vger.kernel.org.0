Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8002448105B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbhL2GZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbhL2GZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89310B81823
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA45AC36AF6;
        Wed, 29 Dec 2021 06:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759114;
        bh=8YpQZ9ydnzSplM66obq13BnAhyC8NKN+/vOquYZ3Ja8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRaVYp3wCiLwfWL/VIB/JnrWZO+p4zyNSG9Naf1DdVjNIh5zjZBi1qB7r+gWaYIUG
         oq1XudNecOyPIsdYKtKqWKrvEEqVVzCYYicwTwPz1NckJs96iQKvDkFWwe8lCdZzNf
         eaqXin5iZDzrACzHMCIW6SKI6/kSntkRJGk/319+cZHdanrFHthEB1CaYC61tThfID
         bEx+UR/FaIp8DwWv1bUTFNgI7YvZdB1HCBWgZIyZJTDW1/WuN1HVn7pBTLHIzWQcnj
         89cs9bA0qXkRjQ00FCMht92KnefoszZhex6ooSM2V5LgEIiOh+K8eeqyxO5DQD/bKu
         HLQVz/K5ZHKsg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  16/16] net/mlx5: Set SMFS as a default steering mode if device supports it
Date:   Tue, 28 Dec 2021 22:25:02 -0800
Message-Id: <20211229062502.24111-17-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
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
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
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

