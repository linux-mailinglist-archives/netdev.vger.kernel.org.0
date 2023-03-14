Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157EE6B8ABF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjCNFng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570D521962
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B22FB8188C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9675FC4339C;
        Tue, 14 Mar 2023 05:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772570;
        bh=CigKXATr8u+0zAVAlKqM+Z/QnQETccf+nE67rQLnx6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYZ7qj5GA+xb5BU2VWoG3AshwtN9wpvehe6DmnJsa5p/0ImKYiB9l+ihm/lpT7PHV
         FyiBcpguZiTHsUbBp4wZr1SjFFbaMRUrb6RjfXY3YttzVXQ7BhWY/LMn9VjlhGM3Sr
         UZWAYwoYIcusm2dpMqrD84uBD5TIwt4JGHG+MgKTBCGOOj0sPUdXMaVaQqLn8YKV/2
         WAnrWyuYhtPbo4Uf5Te8fab4b4XWpuhF9RY3C3leVAhWozy04sDqp+Y0UdQ1jtXisI
         tlPTwBvNN9cH/I4t2RMzsXYEvqWCuqeZZu88oENt5bX75nvjeymGzgUbDhSLEZM3qt
         zBc555KvaAckA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Stringify RQ SW state in RQ devlink health diagnostics
Date:   Mon, 13 Mar 2023 22:42:26 -0700
Message-Id: <20230314054234.267365-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adham Faris <afaris@nvidia.com>

One of the parameters that is retrieved/printed as a response to
devlink health diagnostics for rx reporter is the RQ SW state.

It's printed as a bitmap decimal number. Printing it as bitmap is
problematic and non informative.

In addition User can't count on SW state without accessing the kernel
sources (mlx5e rq state enum in en.h).

This patch prints RQ SW state in a textual representation, as a key:
value pairs, where disabled rq states will appear as '0' and enabled
ones will appear as '1'.

See below the generated output for rx health diagnostics devlink
command:

$ devlink health diagnose auxiliary/mlx5_core.eth.0/65535 reporter rx

Before:
=======================================================================
 Common config:
    RQ:
      type: 2 stride size: 2048 size: 8 ts_format: FRC
      CQ:
        stride size: 64 size: 1024
  RQs:
      channel ix: 0 rqn: 4172 HW state: 1 SW state: 37 WQE counter: 7 posted WQEs: 7 cc: 7
      CQ:
        cqn: 1033 HW status: 0 ci: 0 size: 1024
      EQ:
        eqn: 7 irqn: 32 vecidx: 0 ci: 2 size: 2048
      ICOSQ:
        sqn: 4169 HW state: 1 cc: 74 pc: 74 WQE size: 128
        CQ:
          cqn: 1030 cc: 1 size: 128
      channel ix: 1 ...
        .
        .

After:
=======================================================================
 Common config:
    RQ:
      type: 2 stride size: 2048 size: 8 ts_format: FRC
      CQ:
        stride size: 64 size: 1024
  RQs:
      channel ix: 0 rqn: 4172 HW state: 1 WQE counter: 7 posted WQEs: 7 cc: 7
        SW State:
          enabled: 1 recovering: 0 am: 1 no_csum_complete: 0 csum_full: 0 mini_cqe_hw_stridx: 1 shampo: 0 mini_cqe_enhanced: 0
      CQ:
        cqn: 1033 HW status: 0 ci: 0 size: 1024
      EQ:
        eqn: 7 irqn: 32 vecidx: 0 ci: 2 size: 2048
      ICOSQ:
        sqn: 4169 HW state: 1 cc: 74 pc: 74 WQE size: 128
        CQ:
          cqn: 1030 cc: 1 size: 128
       channel: ix: 1 ...
        .
        .

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 ++-
 .../mellanox/mlx5/core/en/reporter_rx.c       | 49 +++++++++++++++++--
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 66bca3a6a057..6c01da3bad74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -336,8 +336,11 @@ static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
 		params->mqprio.num_tc : 1;
 }
 
+/* Keep this enum consistent with the corresponding strings array
+ * declared in en/reporter_rx.c
+ */
 enum {
-	MLX5E_RQ_STATE_ENABLED,
+	MLX5E_RQ_STATE_ENABLED = 0,
 	MLX5E_RQ_STATE_RECOVERING,
 	MLX5E_RQ_STATE_DIM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
@@ -345,6 +348,7 @@ enum {
 	MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX, /* set when mini_cqe_resp_stride_index cap is used */
 	MLX5E_RQ_STATE_SHAMPO, /* set when SHAMPO cap is used */
 	MLX5E_RQ_STATE_MINI_CQE_ENHANCED,  /* set when enhanced mini_cqe_cap is used */
+	MLX5E_NUM_RQ_STATES, /* Must be kept last */
 };
 
 struct mlx5e_cq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index c462fe76495b..98c87b3df806 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -8,6 +8,18 @@
 #include "ptp.h"
 #include "lib/tout.h"
 
+/* Keep this string array consistent with the MLX5E_RQ_STATE_* enums in en.h */
+static const char * const rq_sw_state_type_name[] = {
+	[MLX5E_RQ_STATE_ENABLED] = "enabled",
+	[MLX5E_RQ_STATE_RECOVERING] = "recovering",
+	[MLX5E_RQ_STATE_DIM] = "dim",
+	[MLX5E_RQ_STATE_NO_CSUM_COMPLETE] = "no_csum_complete",
+	[MLX5E_RQ_STATE_CSUM_FULL] = "csum_full",
+	[MLX5E_RQ_STATE_MINI_CQE_HW_STRIDX] = "mini_cqe_hw_stridx",
+	[MLX5E_RQ_STATE_SHAMPO] = "shampo",
+	[MLX5E_RQ_STATE_MINI_CQE_ENHANCED] = "mini_cqe_enhanced",
+};
+
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_rq_out);
@@ -239,6 +251,35 @@ static int mlx5e_reporter_icosq_diagnose(struct mlx5e_icosq *icosq, u8 hw_state,
 	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
 }
 
+static int mlx5e_health_rq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_rq *rq)
+{
+	int err;
+	int i;
+
+	BUILD_BUG_ON_MSG(ARRAY_SIZE(rq_sw_state_type_name) != MLX5E_NUM_RQ_STATES,
+			 "rq_sw_state_type_name string array must be consistent with MLX5E_RQ_STATE_* enum in en.h");
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SW State");
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(rq_sw_state_type_name); ++i) {
+		err = devlink_fmsg_u32_pair_put(fmsg, rq_sw_state_type_name[i],
+						test_bit(i, &rq->state));
+		if (err)
+			return err;
+	}
+
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return devlink_fmsg_obj_nest_end(fmsg);
+}
+
 static int
 mlx5e_rx_reporter_build_diagnose_output_rq_common(struct mlx5e_rq *rq,
 						  struct devlink_fmsg *fmsg)
@@ -265,10 +306,6 @@ mlx5e_rx_reporter_build_diagnose_output_rq_common(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
-	err = devlink_fmsg_u8_pair_put(fmsg, "SW state", rq->state);
-	if (err)
-		return err;
-
 	err = devlink_fmsg_u32_pair_put(fmsg, "WQE counter", wqe_counter);
 	if (err)
 		return err;
@@ -281,6 +318,10 @@ mlx5e_rx_reporter_build_diagnose_output_rq_common(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
+	err = mlx5e_health_rq_put_sw_state(fmsg, rq);
+	if (err)
+		return err;
+
 	err = mlx5e_health_cq_diag_fmsg(&rq->cq, fmsg);
 	if (err)
 		return err;
-- 
2.39.2

