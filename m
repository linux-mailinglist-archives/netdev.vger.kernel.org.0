Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F155347D891
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhLVVMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbhLVVMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621EDC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 13:12:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69A3EB81E6C
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8BCC36AE5;
        Wed, 22 Dec 2021 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207524;
        bh=DV/8MJ/07A9x25l6SbXkB5m3ARGxqH/KwHCZ+aVhWgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amzfEfIBa6yZT/G8YCdbMs1TUwpujkztVSmWeuUhFp9zVLTQcoGQ1NMgRxmtPtrai
         GOMcj/ZkMVOwBmRtYhuHnFpwWligzEDf97jKi8U6s8elL3Kycp4z6fO9WCPKIHrejR
         wBnpeLuNzMtyYe85WavefQUmGhvJUMyf68z/jlCrZWdJ6Afzndh96iyf5iS9bFBRoM
         1PZyIjoZq/xcDRY24EljaTPU0lYDg8JuS5VslchozGg/hVuOr6jL0d/erzUZ9kVJZY
         iCkFUtokrfFO5XobIFOqLZpxjIEP8BFW7YHieHk3flVBfZ2f6o6Sn44a3n5zEIUS51
         P+o9XRAEHTyww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/11] net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
Date:   Wed, 22 Dec 2021 13:11:51 -0800
Message-Id: <20211222211201.77469-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

The mlx5_get_uars_page() function  returns error pointers.
Using IS_ERR() to check the return value to fix this.

Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain functionality")
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

