Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2D60B63E
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiJXSwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiJXSv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:51:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4121DDA33
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA659CE189F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C990EC433D6;
        Mon, 24 Oct 2022 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630826;
        bh=yuW7el0F/awf//zpBFtIEOq8MGuS5P3ADg01i9yaQM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHDMwV3pOKiDH4Uzvn1LlBVlTl3vIQpzCZg7NClJ3J9Bk05rWQ2FLJsOTy85pxI5Z
         UZNMQHSei1ox++H4sgSXGa3QT3MSKsjt7Vj1eztcNgVO5sayDUQF8rPeNzZHXMTfMv
         CCr3vRuslUKokCai5Tj5FmhuxA+5Q5+wT0q6w0FZYr6mgjPhvc61hKKe6HKUOecJ1b
         MZXDK4AUCawkORglGP29NGoaQEDr+eDyspJKmnZrFqXZOxR7ElUp8Jd3N46MquSU6b
         yhxPiwtEHCCFBND75z2G7Wtg0bewROcN8hz95pYqK+6FZiNB83HoMY+lVtEbBZDNHk
         WW6wCxIBlxb0Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 6/6] net/mlx5e: Use read lock for eswitch get callbacks
Date:   Mon, 24 Oct 2022 19:59:59 +0300
Message-Id: <00144561cf7efd96216a1046d1887dc0fd9e1c65.1666630548.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666630548.git.leonro@nvidia.com>
References: <cover.1666630548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

