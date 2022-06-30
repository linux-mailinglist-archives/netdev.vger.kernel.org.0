Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC04560E78
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiF3BAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiF3BAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617012657B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB9BF61F5F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29645C34114;
        Thu, 30 Jun 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550814;
        bh=BaJsDAH7CMNafJB3kvKUM0GvZDrlJ2Q2BFbT62JYv20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5b+rl1usO4hccuGKFkw5rgbXyadIBALT53efejtCa0E82l6QDbD6JOChGotMbpFw
         /cTK15KnaA5gQYnaQ/MYqYiOyw5oG3ykr2QXU+2oZbYqwgS871hIsrI0Wps1xJwNRn
         FtnPB4j1D6qDHSI0NlrrOu34+WK1K20ZQPQPii35CQNw5aKyD1jlBE9t2bbc8SXbYd
         hhtozmdf6J6de/ZVM0/bw0dyRWd5Bf3Im+AFBgcg9jsVgDBeIMftX4iOZ/ItBXue/3
         or76RKf6Y3779pLw4U+IdI98tJkejALISSh6FEhZUimAfgy1FFKJf/LtHUK7EXUydp
         O7iS1PCMM7erw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Chris Mi <cmi@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 03/15] net/mlx5: E-switch, Introduce flag to indicate if vport acl namespace is created
Date:   Wed, 29 Jun 2022 17:59:53 -0700
Message-Id: <20220630010005.145775-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Eswitch vport acl namespace is needed when loading vfs. There is
no need to free and reallocate it when switching eswitch mode.
Introduce flag to indicate if it is created or not. When needed,
create it. Only free it when the driver is unloaded or in bare
metal mode.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3e662e389be4..823bfcff7846 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1186,6 +1186,9 @@ static int mlx5_esw_acls_ns_init(struct mlx5_eswitch *esw)
 	int total_vports;
 	int err;
 
+	if (esw->flags & MLX5_ESWITCH_VPORT_ACL_NS_CREATED)
+		return 0;
+
 	total_vports = mlx5_eswitch_get_total_vports(dev);
 
 	if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support)) {
@@ -1203,6 +1206,7 @@ static int mlx5_esw_acls_ns_init(struct mlx5_eswitch *esw)
 	} else {
 		esw_warn(dev, "ingress ACL is not supported by FW\n");
 	}
+	esw->flags |= MLX5_ESWITCH_VPORT_ACL_NS_CREATED;
 	return 0;
 
 err:
@@ -1215,6 +1219,7 @@ static void mlx5_esw_acls_ns_cleanup(struct mlx5_eswitch *esw)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 
+	esw->flags &= ~MLX5_ESWITCH_VPORT_ACL_NS_CREATED;
 	if (MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support))
 		mlx5_fs_ingress_acls_cleanup(dev);
 	if (MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2754a732914d..a08f5315d768 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -282,6 +282,7 @@ struct mlx5_esw_functions {
 enum {
 	MLX5_ESWITCH_VPORT_MATCH_METADATA = BIT(0),
 	MLX5_ESWITCH_REG_C1_LOOPBACK_ENABLED = BIT(1),
+	MLX5_ESWITCH_VPORT_ACL_NS_CREATED = BIT(2),
 };
 
 struct mlx5_esw_bridge_offloads;
-- 
2.36.1

