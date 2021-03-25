Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D740348829
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhCYFE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCYFEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C63C61A21;
        Thu, 25 Mar 2021 05:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648684;
        bh=J3rhXXr+ZN5GHRqjsnwyBxKeuRUTirpRcOy37nkZgMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+Ru7i/JeeibrbaYCJH+zEmbm5rTvGPfgtGcb6dH35uxRFws2mFOaHG6Nmc5Zk6I8
         Jp05ehQa45q2sF6UVjElkQpIIQWQbNPkUX1BsJAG/WRkxiIjUbm7EYx2mcN2PKN8uI
         golkYALwx4PBq+eTQbHpyQDhq+WREEnUTARDEb5xehoZeF4n7hwMZUjH/lxEE1P/Uc
         4jpHXPxQQxkaF3wsyU4lU2ehc2Vx9F/RSMELTNPBu45etpUAMWeOrcWevrCmc2X2LR
         l0xv+NLoyImNlP8hJihkHLJH7do0enw/KEvze5ylbZxrG4c9YN8Yml76dzDtt4LVex
         8lV+QuIBw8tew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter
Date:   Wed, 24 Mar 2021 22:04:25 -0700
Message-Id: <20210325050438.261511-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Fix 32-bit variable shift wrapping in dr_ste_v1_get_miss_addr.

Fixes: a6098129c781 ("net/mlx5: DR, Add STEv1 setters and getters")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 815951617e7c..616ebc38381a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -264,8 +264,8 @@ static void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 static u64 dr_ste_v1_get_miss_addr(u8 *hw_ste_p)
 {
 	u64 index =
-		(MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6) |
-		 MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32) << 26);
+		((u64)MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6) |
+		 ((u64)MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32)) << 26);
 
 	return index << 6;
 }
-- 
2.30.2

