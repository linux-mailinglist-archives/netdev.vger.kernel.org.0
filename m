Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375806EA11A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjDUBja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbjDUBj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140E40D2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 168DD64202
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002F7C433D2;
        Fri, 21 Apr 2023 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041159;
        bh=QiBHCG7zi0jr0+KBlg/t8sF0c6el+FCn/YMkkFnC3p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7zXlyBYZ5BrAMkKQEnp0PHl+12zkFy8ZrXSggPnbYz6ipQYONaXzhBGdmp1HABW4
         3A4yxj3BH0VCl3405vH+CMRovRf0FHz7RtVpWsADHELBu5gUJDkIm1Cs35akoeXNSn
         Zp87t8uIgaQbI+K1+SUPRmwJHeBqZ37fdkehFDzg9PLCgx/J/6i4sLgTlFo/cv3ap2
         EowZReIsT/Xwv/STildFDhjUjsRQXYzzpRE48nDbxL2aT74BuMeEf5nZcL3gDAxDB7
         k+MdZumQ52VCcN1ksEWWyX9zywa6DLIWtJwhCye11nNRH5aA79KlZ/qJUnpI7TYZ7r
         guzOZVMNE6tmQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>
Subject: [net-next 05/15] Revert "net/mlx5: Expose steering dropped packets counter"
Date:   Thu, 20 Apr 2023 18:38:40 -0700
Message-Id: <20230421013850.349646-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

This reverts commit 4fe1b3a5f8fe2fdcedcaba9561e5b0ae5cb1d15b, which
exposes the steering dropped packets counter via debugfs. The upcoming
series will expose the counter via devlink health reporter instead
of debugfs.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/esw/debugfs.c | 22 +++----------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
index 3d0bbcca1cb9..2db13c71e88c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
@@ -12,11 +12,10 @@ enum vnic_diag_counter {
 	MLX5_VNIC_DIAG_CQ_OVERRUN,
 	MLX5_VNIC_DIAG_INVALID_COMMAND,
 	MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND,
-	MLX5_VNIC_DIAG_RX_STEERING_DISCARD,
 };
 
 static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_counter counter,
-				    u64 *val)
+				    u32 *val)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vnic_env_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
@@ -58,10 +57,6 @@ static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_cou
 	case MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND:
 		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, quota_exceeded_command);
 		break;
-	case MLX5_VNIC_DIAG_RX_STEERING_DISCARD:
-		*val = MLX5_GET64(vnic_diagnostic_statistics, vnic_diag_out,
-				  nic_receive_steering_discard);
-		break;
 	}
 
 	return 0;
@@ -70,14 +65,14 @@ static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_cou
 static int __show_vnic_diag(struct seq_file *file, struct mlx5_vport *vport,
 			    enum vnic_diag_counter type)
 {
-	u64 val = 0;
+	u32 val = 0;
 	int ret;
 
 	ret = mlx5_esw_query_vnic_diag(vport, type, &val);
 	if (ret)
 		return ret;
 
-	seq_printf(file, "%llu\n", val);
+	seq_printf(file, "%d\n", val);
 	return 0;
 }
 
@@ -117,11 +112,6 @@ static int quota_exceeded_command_show(struct seq_file *file, void *priv)
 	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND);
 }
 
-static int rx_steering_discard_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_RX_STEERING_DISCARD);
-}
-
 DEFINE_SHOW_ATTRIBUTE(total_q_under_processor_handle);
 DEFINE_SHOW_ATTRIBUTE(send_queue_priority_update_flow);
 DEFINE_SHOW_ATTRIBUTE(comp_eq_overrun);
@@ -129,7 +119,6 @@ DEFINE_SHOW_ATTRIBUTE(async_eq_overrun);
 DEFINE_SHOW_ATTRIBUTE(cq_overrun);
 DEFINE_SHOW_ATTRIBUTE(invalid_command);
 DEFINE_SHOW_ATTRIBUTE(quota_exceeded_command);
-DEFINE_SHOW_ATTRIBUTE(rx_steering_discard);
 
 void mlx5_esw_vport_debugfs_destroy(struct mlx5_eswitch *esw, u16 vport_num)
 {
@@ -190,9 +179,4 @@ void mlx5_esw_vport_debugfs_create(struct mlx5_eswitch *esw, u16 vport_num, bool
 	if (MLX5_CAP_GEN(esw->dev, quota_exceeded_count))
 		debugfs_create_file("quota_exceeded_command", 0444, vnic_diag, vport,
 				    &quota_exceeded_command_fops);
-
-	if (MLX5_CAP_GEN(esw->dev, nic_receive_steering_discard))
-		debugfs_create_file("rx_steering_discard", 0444, vnic_diag, vport,
-				    &rx_steering_discard_fops);
-
 }
-- 
2.39.2

