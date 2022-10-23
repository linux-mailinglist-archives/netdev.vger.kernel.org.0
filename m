Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F3A609523
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJWRXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJWRXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF10174E3B
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 10:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76F37B80D62
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 17:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E9C433D6;
        Sun, 23 Oct 2022 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545810;
        bh=yuW7el0F/awf//zpBFtIEOq8MGuS5P3ADg01i9yaQM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RowVB+LSA449/fk0fodewSJZqwN+xn2e+weHScws2nBZ7p9qHSPrbX5f9ePDU4EVT
         awel8PGr535+euRAw/NGkG60s25hIuKuDvLIlBsGJl+uRme4+9c6IVVLfKg6Bn4spM
         9FNyke6g/hxl3aHdFjC9aPjzlsm7qGdxgGQUu7NJVV2ApWjhGsXCsLrWTdESXq+Jdv
         lLs+rW6+jLQEsOt8tRas8lRPS0CENzovmIjUVFNKsgffSob9PIHndpHWRKbTx+0VuM
         z+CgRzHDKUwIoJJgWA3VZ9jRmKa0TV+6X8zX4YQXjjUuQxrvBnf3Tuak+xlu7zLzju
         mcKR/PnYr2KGg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 6/6] net/mlx5e: Use read lock for eswitch get callbacks
Date:   Sun, 23 Oct 2022 20:22:58 +0300
Message-Id: <65ac0feba98470e18a12cb732f8b6aefb058c1f1.1666545480.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666545480.git.leonro@nvidia.com>
References: <cover.1666545480.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

In commit 367dfa121205 ("net/mlx5: Remove devl_unlock from
mlx5_eswtich_mode_callback_enter") all functions were converted
to use write lock without relation to their actual purpose.

Change the devlink eswitch getters to use read and not write locks.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4e50df3139c6..23ada3a71c60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3553,9 +3553,9 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	down_read(&esw->mode_lock);
 	err = esw_mode_to_devlink(esw->mode, mode);
-	up_write(&esw->mode_lock);
+	up_read(&esw->mode_lock);
 	return err;
 }
 
@@ -3653,9 +3653,9 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	down_read(&esw->mode_lock);
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
-	up_write(&esw->mode_lock);
+	up_read(&esw->mode_lock);
 	return err;
 }
 
@@ -3727,9 +3727,9 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
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
2.37.3

