Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F16633354
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiKVC3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiKVC3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:29:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08FE2EF79
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B766661542
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F450C433C1;
        Tue, 22 Nov 2022 02:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084117;
        bh=Z1ILSTbcWmOpIOd5FbPAnvJN/RwxZMrdsOX98o7hd8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7XWxssxhi/Dx9GY9cFGroeaQHyJFBs0OD5IEwLrAGZYN0NgcLaLGmmZJvXcwf0HQ
         suHvdqce8fi0XgXv2QcGD9AhLq1Pe17kzdnAvHzYu8MXPrZwdQl6OyHgaYRAqEZvfj
         wFCuGNjM1NpuY2Y235UbSgOU/+l4WYUhbiRgWRZuaO6xOEnZWpSlZVo7beoo2azSgS
         ClqIRFA2djZ6r7zEWoGt0BL9nHdMEV83vCQquqTNN/leOGx4MamuIsszgPRCpIjbSl
         BIdAqc6F/IEqqisQT5dwguIu5EGXlm42ZLJkBds81nVV56k5+X5kxOFlrtnKBLuLRf
         dBnlcdvGyD3gA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [net 14/14] net/mlx5e: Fix possible race condition in macsec extended packet number update routine
Date:   Mon, 21 Nov 2022 18:25:59 -0800
Message-Id: <20221122022559.89459-15-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currenty extended packet number (EPN) update routine is accessing
macsec object without holding the general macsec lock hence facing
a possible race condition when an EPN update occurs while updating
or deleting the SA.
Fix by holding the general macsec lock before accessing the object.

Fixes: 4411a6c0abd3 ("net/mlx5e: Support MACsec offload extended packet number (EPN)")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 4f96c69c6cc4..3dc6c987b8da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1536,6 +1536,8 @@ static void macsec_async_event(struct work_struct *work)
 
 	async_work = container_of(work, struct mlx5e_macsec_async_work, work);
 	macsec = async_work->macsec;
+	mutex_lock(&macsec->lock);
+
 	mdev = async_work->mdev;
 	obj_id = async_work->obj_id;
 	macsec_sa = get_macsec_tx_sa_from_obj_id(macsec, obj_id);
@@ -1557,6 +1559,7 @@ static void macsec_async_event(struct work_struct *work)
 
 out_async_work:
 	kfree(async_work);
+	mutex_unlock(&macsec->lock);
 }
 
 static int macsec_obj_change_event(struct notifier_block *nb, unsigned long event, void *data)
-- 
2.38.1

