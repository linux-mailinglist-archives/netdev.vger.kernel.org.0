Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB7339A08
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhCLXjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235781AbhCLXi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1DC64F8D;
        Fri, 12 Mar 2021 23:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592336;
        bh=HwU31+TT0fpi7+YAkpDyUMdESnM4B0YABhIF7Uk+wg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRE2AynJvNlXDMJO+37Qnu1HHZnm0TEPEyCHnnptdKotzaU7SnsO7y0shGAobM9HF
         kHtg6Iae/GcP5mlA9Wgf1FSFhuMoZ4WokFbSjcjjzqiEL9vtzF5Uqax3WF/BqC0bRr
         X2dswG8+hOgrd2MDTNPMLH+YhwT2jQeA7AE3XXxR5bn6x1eo6loM762zVpI2awXuEW
         sCYxXGjqCvqhC6SGfVEP1Sk0/1d4QjO1YbJVYYpshvnuc+BJYL7nQmI48cWWD+CwA5
         SdOY43Ou76GUnUGayroBC1N8dNPoQnlUKx1Nd/sqeopnscIQfisLDChMqHSoQieIYv
         JC5kOjMdQTOMQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/13] net/mlx5: DR, Remove unneeded rx_decap_l3 function for STEv1
Date:   Fri, 12 Mar 2021 15:38:40 -0800
Message-Id: <20210312233851.494832-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove the dr_ste_v1_set_rx_decap_l3 function that was
replaced by another function - fixing a rebase error.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c    | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 4088d6e51508..6f368ccc428e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -437,21 +437,6 @@ static void dr_ste_v1_set_rx_decap(u8 *hw_ste_p, u8 *s_action)
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
-static void dr_ste_v1_set_rx_decap_l3(u8 *hw_ste_p,
-				      u8 *s_action,
-				      u16 decap_actions,
-				      u32 decap_index)
-{
-	MLX5_SET(ste_single_action_modify_list_v1, s_action, action_id,
-		 DR_STE_V1_ACTION_ID_MODIFY_LIST);
-	MLX5_SET(ste_single_action_modify_list_v1, s_action, num_of_modify_actions,
-		 decap_actions);
-	MLX5_SET(ste_single_action_modify_list_v1, s_action, modify_actions_ptr,
-		 decap_index);
-
-	dr_ste_v1_set_reparse(hw_ste_p);
-}
-
 static void dr_ste_v1_set_rewrite_actions(u8 *hw_ste_p,
 					  u8 *s_action,
 					  u16 num_of_actions,
@@ -571,9 +556,6 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 	bool allow_ctr = true;
 
 	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
-		dr_ste_v1_set_rx_decap_l3(last_ste, action,
-					  attr->decap_actions,
-					  attr->decap_index);
 		dr_ste_v1_set_rewrite_actions(last_ste, action,
 					      attr->decap_actions,
 					      attr->decap_index);
-- 
2.29.2

