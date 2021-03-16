Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE433E261
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCPXve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCPXvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A820364F0C;
        Tue, 16 Mar 2021 23:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938677;
        bh=Km7N3b4/DTCRA5/RzHWqfL7NVYQOFWo/O2Ke0X+5l80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDWwBpntqYm1EKdQ7a2iab9h6m+UMCSyenaXtive58Dz9ihXSaAjJq1CHy16fcjjA
         Tmlvz7qfkhsQb28yRoetb3sH2hKhStj1w6EOM8O9FT6MAuGvJo75Yltsuq6b0HDaxg
         i3RJbieEGjMO6rPl5Cc/7ACSsL9Fswbv4yJ97s6UZ74WDXcbrvCaBkpR0WjEXCkmmQ
         SyzpsAmewkCfvOMkqcRnb7GOgiTZDXQX7HOvKeavJMUSNIRvCIF/A5hbltwcCutsND
         cKyexmU6EFW0m8bWFSfb30FpUL7Y607hGOd6VEU6ElHKGxk9Az4YFItYRsY4c8xqCx
         VkuzUiaeWgQ8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Distinguish nic and esw offload in tc setup block cb
Date:   Tue, 16 Mar 2021 16:51:01 -0700
Message-Id: <20210316235112.72626-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We will re-use the native NIC port net device instance for the Uplink
representor, hence same ndos will be used.
Now we need to distinguish in the TC callback if the mode is legacy or
switchdev and set the proper flag.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 78fc27fc4e37..8a3b2d76cc82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4892,9 +4892,14 @@ static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
 int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 			    void *cb_priv)
 {
-	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(NIC_OFFLOAD);
+	unsigned long flags = MLX5_TC_FLAG(INGRESS);
 	struct mlx5e_priv *priv = cb_priv;
 
+	if (mlx5e_is_uplink_rep(priv))
+		flags |= MLX5_TC_FLAG(ESW_OFFLOAD);
+	else
+		flags |= MLX5_TC_FLAG(NIC_OFFLOAD);
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return mlx5e_setup_tc_cls_flower(priv, type_data, flags);
-- 
2.30.2

