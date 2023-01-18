Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24E67272A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjARShA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjARSgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BAD599A8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA55B6199B
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B00C433D2;
        Wed, 18 Jan 2023 18:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066982;
        bh=lh1+lfCRa6yI0FOWaRQKT1djMPHRGo/eTIxxeUIlBSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHkwJjqLTHvYEoKZ8wkJb+2RjQIEFU5H8Rce5lMMcekZCOx6VlDfaHX5+afXdp0wY
         Dwoa/nugZrPXhQs1rOnPOINFh4BO55sII35bMEcoG92DV9DYzkIK0o6yuJNCDUyjv4
         dClw4T3Fb54bJRZQA4QmGOR/UgKM2ZA9ki5blLQRTTdpdM2V8aVthq11xZJRS2iS3s
         1OGZVW89KLq0oYEtsScyZagTP2V/ScBl4QbAxPGqqqc80S43pzCZl7b5Oi1hKbHTdS
         SP3zzFHSBYOEO0pQj6PdESPbwCiR94MBGqnUKTzlgFioujjslwffq2P34PVLHn6esw
         cCpk/eddBANwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Use read lock for eswitch get callbacks
Date:   Wed, 18 Jan 2023 10:36:02 -0800
Message-Id: <20230118183602.124323-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In commit 367dfa121205 ("net/mlx5: Remove devl_unlock from
mlx5_eswtich_mode_callback_enter") all functions were converted
to use write lock without relation to their actual purpose.

Change the devlink eswitch getters to use read and not write locks.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4eeb2dcbfc0f..5fb9d5e99734 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3572,9 +3572,9 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	down_read(&esw->mode_lock);
 	err = esw_mode_to_devlink(esw->mode, mode);
-	up_write(&esw->mode_lock);
+	up_read(&esw->mode_lock);
 	return err;
 }
 
@@ -3672,9 +3672,9 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	down_read(&esw->mode_lock);
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
-	up_write(&esw->mode_lock);
+	up_read(&esw->mode_lock);
 	return err;
 }
 
@@ -3746,9 +3746,9 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	down_read(&esw->mode_lock);
 	*encap = esw->offloads.encap;
-	up_write(&esw->mode_lock);
+	up_read(&esw->mode_lock);
 	return 0;
 }
 
-- 
2.39.0

