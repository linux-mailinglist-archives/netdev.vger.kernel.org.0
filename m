Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8944A6B3B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiBBFHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiBBFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0E6C061756
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC536170E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E539C004E1;
        Wed,  2 Feb 2022 05:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778401;
        bh=W58jeZkQsvO71IN8OksndUeI6jehcQxQmgukYNE38a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4WjmA55uMlMo6wstvUADvJ3fwUtEG+JFHFikecCqY4BUOGt7Ryq68emIxiNGzfMm
         XMwwWk5xuVtTtTSlB9qv/mtbz0mfEa+fcuYdDep7tmFln7o0fEixcoFjAAIZz/aWqQ
         mLOrorvVQY1hRDb2TDUNhTUL0vByULJFD+DOwPq0ZC/7PKFMata5Ad0yTREMM73j75
         4RjgUJDiVwZz05eqbYQZD98eU2DDI7sf12QZ3rc47dBCiSGQ70MV9oMknAG5w2sddF
         qobzpQniVXdY9cHfrJ8fx/jDv9Uh/5mYnMIu0fI4ywXQnQtn1MWEMnYtaUqpsgusz5
         4ZILMaW9KBmOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 16/18] net/mlx5e: Avoid implicit modify hdr for decap drop rule
Date:   Tue,  1 Feb 2022 21:04:02 -0800
Message-Id: <20220202050404.100122-17-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Currently the driver adds implicit modify hdr action for
decap rules on tunnel devices if the port is an ovs port.
This is also done if the action is drop and makes the modify
hdr redundant and also the FW doesn't support it and will generate
a syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fix it by adding the implicit modify hdr only for fwd actions.

Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Fixes: 077cdda764c7 ("net/mlx5e: TC, Fix memory leak with rules with internal port")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4c6e3c26c1ab..2022fa4a9598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1414,7 +1414,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		if (err)
 			goto err_out;
 
-		if (!attr->chain && esw_attr->int_port) {
+		if (!attr->chain && esw_attr->int_port &&
+		    attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 			/* If decap route device is internal port, change the
 			 * source vport value in reg_c0 back to uplink just in
 			 * case the rule performs goto chain > 0. If we have a miss
-- 
2.34.1

