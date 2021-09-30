Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CB141E4B6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350331AbhI3XWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349127AbhI3XWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0695D61A3F;
        Thu, 30 Sep 2021 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044058;
        bh=505aAtPc7hivMXNvbWLirdpFo8YJfhl87epT8pYJEm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJvTUBzbKNCFfEr2qtJlhu8zhHYxXv4lpTr48owBRfoeud7mk3Iis5FQt2kiqcMog
         ZDR9ATB5OBNDWxVBRyTq47qR7ipjIkMLmIsdNjbS8LNdtoQyVmork8wIhLEm6Pinkv
         HRy9kxtb5ioCJ5CH5KA+SxYtWHOHYYgNbI2ttHa8DjEyLExsT5eVM2S8VdNWzx+64L
         t5W2606z5Vmu+tsKrzFrGzpXydIDoyuVWECJmMVYnQAbuR5H4nm0rVnTcXcd/gqD8r
         /ktesXm8601jfWDCEoBGVvSFeoi8sxykrbauUk61aQgEPdAlkJGXpiI0YrRLTjCL03
         fW/NeOSohblRA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, init_next_match only if needed
Date:   Thu, 30 Sep 2021 16:20:44 -0700
Message-Id: <20210930232050.41779-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Allocate next steering table entry only if the remaining space requires to.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c  | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 3497c2cf3118..cb9cf67b0a02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -586,9 +586,11 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 	} else if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]) {
 		u8 *d_action;
 
-		dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
-		action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
-		action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		if (action_sz < DR_STE_ACTION_TRIPLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
 		d_action = action + DR_STE_ACTION_SINGLE_SZ;
 
 		dr_ste_v1_set_encap_l3(last_ste,
-- 
2.31.1

