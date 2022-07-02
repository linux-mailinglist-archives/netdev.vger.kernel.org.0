Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF356424C
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGBTEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiGBTE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA9BBC1A
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30A57B808C1
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF5CC34114;
        Sat,  2 Jul 2022 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788663;
        bh=BaJsDAH7CMNafJB3kvKUM0GvZDrlJ2Q2BFbT62JYv20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+zs4vqc5kHYa0N6pYY1oOoerxixdmprMRmyOJC1m6uv+FoQZe5Zrcw5BW+C9H+n6
         pzCC6axV490B5VHKpD+rd/9NgJobmIm01w+x8+t4sjmSGiPndG4OlJkAUVIRLG1+Zh
         OMsHypR5mX63HA/4sQeaKJL676IPj4cX5f4eimJNiiVxV3/EfT4l0atrGC98vMAZ1H
         a/QxTudXfdTHzZqv7s0nH6YLRj27C0nOq1r7SQkSoW8we2Wd5icNW2Kide64RMc5b7
         YdPU8eXGD/tY3l2ncVy2/Pb1IRtEOAMosUblMI2zZoYh5Sux9cTz6DWd1fx8jCBcDa
         JXQZC/nEjW+FQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Chris Mi <cmi@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next v2 03/15] net/mlx5: E-switch, Introduce flag to indicate if vport acl namespace is created
Date:   Sat,  2 Jul 2022 12:02:01 -0700
Message-Id: <20220702190213.80858-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
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

