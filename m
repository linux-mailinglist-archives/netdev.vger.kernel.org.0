Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC55057A856
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiGSUgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239767AbiGSUft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22D75004C
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE01B81D41
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270D4C341CA;
        Tue, 19 Jul 2022 20:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262946;
        bh=DVxesPckPATl7vAXJ4YxeFv3v680FxDJ2zthKZN1Rwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7+P92GM4kCEyGNUo83ql8tyBNkurvrTMfxaNGTLDw9QEwcxTdX9jPfI8otN7Fu5e
         QMM5P7yubgCbn4aM8Qux/jUtbJZrsX7xMw25C305X3Bknxr+b1nFA1fPh7kQWTiRmi
         usXt6SRv/hWDy0LtKlId0orUNlBFaDPpstI4fcLCLGf0IZCf3prA7ZWfHEN8rDHc7y
         SF+9zk1IjZjrD9ZHrEXDYgSReGDAOi693YP2PyFhtCxrVFJZYIvCkogEQA8YMKNJWN
         yCvC9kmwsERT6XPyEPjR7N/SSJCQHei1kHp/JlGIXOarsXSa3iSf96eXHRqIykqjsW
         aqYd4DvZ7QlOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 13/13] net/mlx5: CT: Remove warning of ignore_flow_level support for non PF
Date:   Tue, 19 Jul 2022 13:35:29 -0700
Message-Id: <20220719203529.51151-14-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

ignore_flow_level isn't supported for SFs, and so it causes
post_act and ct to warn about it per SF.
Apply the warning only for PF.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 2093cc2b0d48..33c1411ed8db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -36,7 +36,7 @@ mlx5e_tc_post_act_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 	int err;
 
 	if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev, ignore_flow_level, table_type)) {
-		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+		if (priv->mdev->coredev_type == MLX5_COREDEV_PF)
 			mlx5_core_warn(priv->mdev, "firmware level support is missing\n");
 		err = -EOPNOTSUPP;
 		goto err_check;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a6d84ff3a0e7..864ce0c393e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2062,7 +2062,7 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 		/* Ignore_flow_level support isn't supported by default for VFs and so post_act
 		 * won't be supported. Skip showing error msg.
 		 */
-		if (priv->mdev->coredev_type != MLX5_COREDEV_VF)
+		if (priv->mdev->coredev_type == MLX5_COREDEV_PF)
 			err_msg = "post action is missing";
 		err = -EOPNOTSUPP;
 		goto out_err;
-- 
2.36.1

