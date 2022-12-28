Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F6965867F
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiL1Tn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiL1Tns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD8E10B5F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60AB9615FC
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B030BC433F1;
        Wed, 28 Dec 2022 19:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256626;
        bh=o4rYaggSzANjdBmPK9JR3Z3bsacFjhTQbPSQU626tow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4/oXhG2c1GReE9dOWKvwhLHqZkHdu372HFVm9CKzLi9JIIyz3ceVcSm9IvwNs/4A
         bEXijM2NTSLgXr2T4QEVc70WSbCb6dkemIN+eIt/mf7SKk3m4vJLTPhnlJw7bm7Dur
         hHqLhimhtB1pCSOvWFQWVsBABuUy7MlwXetAzROOaKlW9lVYdL8OiZRH5NNYskNbZF
         ARbjRp5ESnCURKUqIujeznDmGqbs+dFvna97ObkoT8eu5OQBNPX5h66R88FlOokOtZ
         GUmhX+Sm0zUOXUJd9QxxdfY5/8so0OU0HCMrssVv/CjuuIL/lX9OWFZbe9OMwPi2dA
         CWLj4/Vr9s0pA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 08/12] net/mlx5e: CT: Fix ct debugfs folder name
Date:   Wed, 28 Dec 2022 11:43:27 -0800
Message-Id: <20221228194331.70419-9-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

Need to use sprintf to build a string instead of sscanf. Otherwise
dirname is null and both "ct_nic" and "ct_fdb" won't be created.
But its redundant anyway as driver could be in switchdev mode but
still add nic rules. So use "ct" as folder name.

Fixes: 77422a8f6f61 ("net/mlx5e: CT: Add ct driver counters")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a69849e0deed..313df8232db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2103,14 +2103,9 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 static void
 mlx5_ct_tc_create_dbgfs(struct mlx5_tc_ct_priv *ct_priv)
 {
-	bool is_fdb = ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB;
 	struct mlx5_tc_ct_debugfs *ct_dbgfs = &ct_priv->debugfs;
-	char dirname[16] = {};
 
-	if (sscanf(dirname, "ct_%s", is_fdb ? "fdb" : "nic") < 0)
-		return;
-
-	ct_dbgfs->root = debugfs_create_dir(dirname, mlx5_debugfs_get_dev_root(ct_priv->dev));
+	ct_dbgfs->root = debugfs_create_dir("ct", mlx5_debugfs_get_dev_root(ct_priv->dev));
 	debugfs_create_atomic_t("offloaded", 0400, ct_dbgfs->root,
 				&ct_dbgfs->stats.offloaded);
 	debugfs_create_atomic_t("rx_dropped", 0400, ct_dbgfs->root,
-- 
2.38.1

