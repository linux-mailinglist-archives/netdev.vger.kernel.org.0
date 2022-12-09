Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4554647AA1
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLIAPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLIAPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:15:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582EB8F726
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF25620F6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D68C433F0;
        Fri,  9 Dec 2022 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544888;
        bh=ceRSfQXVNHlR9CV1E8V68at3rLAq7NWycSS7AAyyuH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyTzPhn7RqM89gOL3OP7g0D61ozbpoVGqgghnpSz53+mByD5gMMEYIX7uEMv14U0z
         sjyIF9lwyDS854FcMNJS2MYWYs3Nd0+vV1WOeaf7LRonb/BrQzLuAY4xSJky+wqdZ6
         6I6Ck0u589u7jKTWsvL5Ms6tdNiKT0Z6NAlcgVD/t/T6I8F+OefKbjhugQwLz4jps1
         EcGZRu++ws3keTedYhFUz6DGxzRJ/dVPpsdib0Fj5441JmmOcAWsPho2PuiKr0X+h1
         VaQ9nDEacIhYRPGWiDB/q8qIQxn0459v3Ae8yTIuQXJgtLB6iy7skrC95679QLpOFc
         6yPzaTN0OkqHA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Expose steering dropped packets counter
Date:   Thu,  8 Dec 2022 16:14:20 -0800
Message-Id: <20221209001420.142794-16-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Michael Guralnik <michaelgur@nvidia.com>

Add rx steering discarded packets counter to the vnic_diag debugfs.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/debugfs.c | 22 ++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
index 2db13c71e88c..3d0bbcca1cb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
@@ -12,10 +12,11 @@ enum vnic_diag_counter {
 	MLX5_VNIC_DIAG_CQ_OVERRUN,
 	MLX5_VNIC_DIAG_INVALID_COMMAND,
 	MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND,
+	MLX5_VNIC_DIAG_RX_STEERING_DISCARD,
 };
 
 static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_counter counter,
-				    u32 *val)
+				    u64 *val)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vnic_env_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
@@ -57,6 +58,10 @@ static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_cou
 	case MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND:
 		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, quota_exceeded_command);
 		break;
+	case MLX5_VNIC_DIAG_RX_STEERING_DISCARD:
+		*val = MLX5_GET64(vnic_diagnostic_statistics, vnic_diag_out,
+				  nic_receive_steering_discard);
+		break;
 	}
 
 	return 0;
@@ -65,14 +70,14 @@ static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_cou
 static int __show_vnic_diag(struct seq_file *file, struct mlx5_vport *vport,
 			    enum vnic_diag_counter type)
 {
-	u32 val = 0;
+	u64 val = 0;
 	int ret;
 
 	ret = mlx5_esw_query_vnic_diag(vport, type, &val);
 	if (ret)
 		return ret;
 
-	seq_printf(file, "%d\n", val);
+	seq_printf(file, "%llu\n", val);
 	return 0;
 }
 
@@ -112,6 +117,11 @@ static int quota_exceeded_command_show(struct seq_file *file, void *priv)
 	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND);
 }
 
+static int rx_steering_discard_show(struct seq_file *file, void *priv)
+{
+	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_RX_STEERING_DISCARD);
+}
+
 DEFINE_SHOW_ATTRIBUTE(total_q_under_processor_handle);
 DEFINE_SHOW_ATTRIBUTE(send_queue_priority_update_flow);
 DEFINE_SHOW_ATTRIBUTE(comp_eq_overrun);
@@ -119,6 +129,7 @@ DEFINE_SHOW_ATTRIBUTE(async_eq_overrun);
 DEFINE_SHOW_ATTRIBUTE(cq_overrun);
 DEFINE_SHOW_ATTRIBUTE(invalid_command);
 DEFINE_SHOW_ATTRIBUTE(quota_exceeded_command);
+DEFINE_SHOW_ATTRIBUTE(rx_steering_discard);
 
 void mlx5_esw_vport_debugfs_destroy(struct mlx5_eswitch *esw, u16 vport_num)
 {
@@ -179,4 +190,9 @@ void mlx5_esw_vport_debugfs_create(struct mlx5_eswitch *esw, u16 vport_num, bool
 	if (MLX5_CAP_GEN(esw->dev, quota_exceeded_count))
 		debugfs_create_file("quota_exceeded_command", 0444, vnic_diag, vport,
 				    &quota_exceeded_command_fops);
+
+	if (MLX5_CAP_GEN(esw->dev, nic_receive_steering_discard))
+		debugfs_create_file("rx_steering_discard", 0444, vnic_diag, vport,
+				    &rx_steering_discard_fops);
+
 }
-- 
2.38.1

