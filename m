Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B08417B48
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346854AbhIXSuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239455AbhIXStx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A006861265;
        Fri, 24 Sep 2021 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509299;
        bh=PT4aWBk2xiHZJGZ/O2zsoSbqJTW4TRbZy+dOtCWUTz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsW0ZTKtQCamqZn1SfSY6Xrjvvj3yG6K4YbU2qz0nO3kqXyap4TGmDmxRIVXlDYSV
         zgarL3jnQLgPZFYhWCK73sIrKqy8zpVDKlfN6C0Wz+HATChO6fJsduzu15HfKt1udk
         okuLHIe3srt6wdhmGqd4NMeRJaHX+dmFO+dj+PVNVrGRAVRRJH9aMFJ7jqRqWQDm5H
         BOmLovhLnfQ1qQKBN7c8jB+GAu3hiQZD+aU/GCbCBc/55lk8cz99DmkyTDlIrG+zUo
         62g3PCA880UElt+K6H5TS2mLZQ/qrsATlpMga6lhH33oRx1WATXltM4IURw+7Vwvl9
         4nZtd2JXUNfNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/12] net/mlx5e: Check action fwd/drop flag exists also for nic flows
Date:   Fri, 24 Sep 2021 11:48:02 -0700
Message-Id: <20210924184808.796968-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The driver should add offloaded rules with either a fwd or drop action.
The check existed in parsing fdb flows but not when parsing nic flows.
Move the test into actions_match_supported() which is called for
checking nic flows and fdb flows.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3646e88b6401..c86fc59c645f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3189,6 +3189,12 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
 	actions = flow->attr->action;
 
+	if (!(actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule must have at least one forward/drop action");
+		return false;
+	}
+
 	if (mlx5e_is_eswitch_flow(flow)) {
 		if (flow->attr->esw_attr->split_count && ct_flow &&
 		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
@@ -4077,13 +4083,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!(attr->action &
-	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Rule must have at least one forward/drop action");
-		return -EOPNOTSUPP;
-	}
-
 	if (esw_attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
-- 
2.31.1

