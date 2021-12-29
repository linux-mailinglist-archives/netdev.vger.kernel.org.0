Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87D348108E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhL2GyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:54:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39754 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbhL2Gx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:53:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24289B817B0
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A30C36AED;
        Wed, 29 Dec 2021 06:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640760837;
        bh=syRdA+K+fG4njL3iKGkpzvHueeU12xKipgXFPdQV6uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muHX6UtjLm/LM3VE5Z8yZzR+ZUS3yr/OSdzbNnAx1H9W0P9wvy21APdGle169LHWE
         QpquIPt+a+D4IqnxixZcoSMOm3MK1kevZ2jDuY5m2azU9eTteQdpIXozUD6fTSRUMP
         H4g3eSYQbt36PoZhYNgxzOC9eBKVRupK1ErvtvQyLLMTYojCTAelouPqvXaNxeJXUG
         BksW2fbPYATlUePAf2ZacixxnH+JMGFkRpLd/TMi9/IFKRHWCC/e/haS78qJICrB+9
         vLVUitaHvUxLNQGNy5kW55HE8pOJgEGoN/z39UoVTkdDfxpC88nOk1ACaEyakCE6fU
         mrJwnFm3VzfkQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/2] net/mlx5e: Fix wrong features assignment in case of error
Date:   Tue, 28 Dec 2021 22:53:52 -0800
Message-Id: <20211229065352.30178-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229065352.30178-1-saeed@kernel.org>
References: <20211229065352.30178-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

In case of an error in mlx5e_set_features(), 'netdev->features' must be
updated with the correct state of the device to indicate which features
were updated successfully.
To do that we maintain a copy of 'netdev->features' and update it after
successful feature changes, so we can assign it to back to
'netdev->features' if needed.

However, since not all netdev features are handled by the driver (e.g.
GRO/TSO/etc), some features may not be updated correctly in case of an
error updating another feature.

For example, while requesting to disable TSO (feature which is not
handled by the driver) and enable HW-GRO, if an error occurs during
HW-GRO enable, 'oper_features' will be assigned with 'netdev->features'
and HW-GRO turned off. TSO will remain enabled in such case, which is a
bug.

To solve that, instead of using 'netdev->features' as the baseline of
'oper_features' and changing it on set feature success, use 'features'
instead and update it in case of errors.

Fixes: 75b81ce719b7 ("net/mlx5e: Don't override netdev features field unless in error flow")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3b0f3a831216..41379844eee1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3741,12 +3741,11 @@ static int set_feature_arfs(struct net_device *netdev, bool enable)
 
 static int mlx5e_handle_feature(struct net_device *netdev,
 				netdev_features_t *features,
-				netdev_features_t wanted_features,
 				netdev_features_t feature,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ netdev->features;
-	bool enable = !!(wanted_features & feature);
+	netdev_features_t changes = *features ^ netdev->features;
+	bool enable = !!(*features & feature);
 	int err;
 
 	if (!(changes & feature))
@@ -3754,22 +3753,22 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 
 	err = feature_handler(netdev, enable);
 	if (err) {
+		MLX5E_SET_FEATURE(features, feature, !enable);
 		netdev_err(netdev, "%s feature %pNF failed, err %d\n",
 			   enable ? "Enable" : "Disable", &feature, err);
 		return err;
 	}
 
-	MLX5E_SET_FEATURE(features, feature, enable);
 	return 0;
 }
 
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t oper_features = netdev->features;
+	netdev_features_t oper_features = features;
 	int err = 0;
 
 #define MLX5E_HANDLE_FEATURE(feature, handler) \
-	mlx5e_handle_feature(netdev, &oper_features, features, feature, handler)
+	mlx5e_handle_feature(netdev, &oper_features, feature, handler)
 
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_GRO_HW, set_feature_hw_gro);
-- 
2.33.1

