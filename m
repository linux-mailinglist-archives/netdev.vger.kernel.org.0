Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74C647E7DD
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244819AbhLWTEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37630 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbhLWTEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6EF61F6A
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF2BC36AEA;
        Thu, 23 Dec 2021 19:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286287;
        bh=u1lKtUMsa24PN+ab+pNfxV+FELqkAPd/kbI7ybJXAeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiG6PmUepjvJX5pC0Zd5uwJJ9959Xp7XExp9Nbdwls747bCNGSBEXJtPpyfR6cZS1
         gavl0KoyGBZ+BlmhZfteAQxqkf5XaahuI8UHHduUpF1kqr8fW5h8p0ixKzNel1WQ4G
         1hsTdXcdXC2SvLVVt5Sh69I+AIIQdFuENgYTY8seLqUYH9cfugJrrgYI2cix2YhSEW
         X7GqBDxMumrut0pC/R/u8Cv18T0M4uLTXuEfiNO3Y+HXBF2w6+1FtN8un90ahwActX
         75pT3Ku2oMeZWruSwFd9kdDVkinTbJekuqUrV7ggT4mzzddG4oWKe7QtlFJsV4Hice
         xTVVat0iaiYMw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 01/12] net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
Date:   Thu, 23 Dec 2021 11:04:30 -0800
Message-Id: <20211223190441.153012-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

The mlx5_get_uars_page() function  returns error pointers.
Using IS_ERR() to check the return value to fix this.

Fixes: 4ec9e7b02697 ("net/mlx5: DR, Expose steering domain functionality")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 8cbd36c82b3b..f6e6d9209766 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include <linux/mlx5/eswitch.h>
+#include <linux/err.h>
 #include "dr_types.h"
 
 #define DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, dmn_type)	\
@@ -72,9 +73,9 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 	}
 
 	dmn->uar = mlx5_get_uars_page(dmn->mdev);
-	if (!dmn->uar) {
+	if (IS_ERR(dmn->uar)) {
 		mlx5dr_err(dmn, "Couldn't allocate UAR\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(dmn->uar);
 		goto clean_pd;
 	}
 
-- 
2.33.1

