Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3622960E2AE
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiJZNyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiJZNxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBC5106E1B
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C4C261F07
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1631C433D6;
        Wed, 26 Oct 2022 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792367;
        bh=a9oHvWS79KbRkeHn6OiyH8RSidxqHPuMtu0y65tLHsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yv1bQoRrNBZstYX3PD2J8v1hboT+Aj0qwgzzmh086pXAzvfwqunShDBB4ZWmxllJ3
         fyiD9aFPWhykC31XPMLTzJOBmZewN+Bxl25L1WbnegefLZ7EMM35iWg80Tq9oceliO
         WSijHyh3Dt01JAoByA3/NJJdNnwPur+8S7UiP0Rs8/PoDZRflgJWjRoAcTlLUnQ4Fo
         vhZLvmmgZij8XshPWUnhE+bkOXlnkEvDi+KRpsjOOLnvQr3NlV4L/4WD9MeJLysjQy
         8G3WMqC9zCQ/U5a/yVAtD0L4PXvonPVfKlqVHGSwSSbyQ0YiLuAgCZrZ7ITSyQnJk7
         oYsLuY0rKfzPQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Suresh Devarakonda <ramad@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [V4 net 11/15] net/mlx5: Fix crash during sync firmware reset
Date:   Wed, 26 Oct 2022 14:51:49 +0100
Message-Id: <20221026135153.154807-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suresh Devarakonda <ramad@nvidia.com>

When setting Bluefield to DPU NIC mode using mlxconfig tool +  sync
firmware reset flow, we run into scenario where the host was not
eswitch manager at the time of mlx5 driver load but becomes eswitch manager
after the sync firmware reset flow. This results in null pointer
access of mpfs structure during mac filter add. This change prevents null
pointer access but mpfs table entries will not be added.

Fixes: 5ec697446f46 ("net/mlx5: Add support for devlink reload action fw activate")
Signed-off-by: Suresh Devarakonda <ramad@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 839a01da110f..8ff16318e32d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -122,7 +122,7 @@ void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_mpfs *mpfs = dev->priv.mpfs;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return;
 
 	WARN_ON(!hlist_empty(mpfs->hash));
@@ -137,7 +137,7 @@ int mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
@@ -185,7 +185,7 @@ int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
-- 
2.37.3

