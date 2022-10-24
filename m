Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B923160A900
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiJXNNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiJXNM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 09:12:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC7212631
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 05:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C74B811CF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4023C433B5;
        Mon, 24 Oct 2022 11:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612503;
        bh=a9oHvWS79KbRkeHn6OiyH8RSidxqHPuMtu0y65tLHsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hA3z/Ae+t2Li5o9kSu71OE7z9mAOXHdaQfBqRJbzInRM4hH5w41W0HXsioNTat6Js
         wcDs3kkXWjhQLDIj9jbMl/QkS4AmhJSnHtyWxbFYbCi1QoUtJl0IbL/YNcV1i9tFfK
         NTY1BlFJqkAcZ6qTcyGtUplZDTYsKG6TbFzFGnlnVHIUZYwy2HNLRts9dFBTa08YKk
         jsSuUjlaiwxLEPHMcDd8AHlyJ2mRZ2MjpIB0XkGuDp4jns/PngQo6HPSjHygmi8hYs
         /SFKoHdTyisQ4LVz6Mhzax7fe8/eAck4a0aEDzmzXp0kBTL+wZaOXCyug+7AJLpYKm
         q2bmu1kLDzBig==
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
Subject: [V3 net 12/16] net/mlx5: Fix crash during sync firmware reset
Date:   Mon, 24 Oct 2022 12:53:53 +0100
Message-Id: <20221024115357.37278-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
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

