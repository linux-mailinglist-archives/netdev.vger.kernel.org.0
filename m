Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB962560E74
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiF3BAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiF3BAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE12D403D2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B1A9B827C4
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BEEC341CE;
        Thu, 30 Jun 2022 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550818;
        bh=MO1BjhmrH0reu0hT0rwYhFFuq73CMLj0b3DuHAXl0u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baymEdWpAxH0g7qpQet1cViLptmXyA7mt+v8YDa3Pocrdfs1vwejg4kBCJ235+fpx
         CxzYepXof/IlxjjX1mqtdKntJdKF3TCpvGwudrxLpRwyTOWrrD9devo7aZEC/Jlz+O
         bGDn/9jFJeK171x3oHnArjg41TFhzgtryMumKNwLN9ARyYWC2XFnKZpgnaouW0VpVx
         Kao0NgVydPigdQiz1RtEl/L53bM972owUI1m9BhbyfJVa1y+WZeei2WNmfo3oV/P2Y
         uTVKm4ju6mW0KGoNmilNpxoDjpMdD9wr8eYwa/sbx5EBpphnngE/+LrQfg88yD5W3K
         EKMpHQfcJWbAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Add support to modify hardware flow meter parameters
Date:   Wed, 29 Jun 2022 18:00:00 -0700
Message-Id: <20220630010005.145775-11-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

The policing rate and burst from user are converted to flow meter
parameters in hardware. These parameters are set or modified by
ACCESS_ASO WQE, add function to support it.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 161 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  22 +++
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |   9 +
 3 files changed, 192 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index e146064757e9..cb65d36909ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -5,6 +5,22 @@
 #include "en/tc/post_act.h"
 #include "meter.h"
 
+#define MLX5_START_COLOR_SHIFT 28
+#define MLX5_METER_MODE_SHIFT 24
+#define MLX5_CBS_EXP_SHIFT 24
+#define MLX5_CBS_MAN_SHIFT 16
+#define MLX5_CIR_EXP_SHIFT 8
+
+/* cir = 8*(10^9)*cir_mantissa/(2^cir_exponent)) bits/s */
+#define MLX5_CONST_CIR 8000000000ULL
+#define MLX5_CALC_CIR(m, e)  ((MLX5_CONST_CIR * (m)) >> (e))
+#define MLX5_MAX_CIR ((MLX5_CONST_CIR * 0x100) - 1)
+
+/* cbs = cbs_mantissa*2^cbs_exponent */
+#define MLX5_CALC_CBS(m, e)  ((m) << (e))
+#define MLX5_MAX_CBS ((0x100ULL << 0x1F) - 1)
+#define MLX5_MAX_HW_CBS 0x7FFFFFFF
+
 struct mlx5e_flow_meters {
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5_aso *aso;
@@ -16,6 +32,151 @@ struct mlx5e_flow_meters {
 	struct mlx5e_post_act *post_act;
 };
 
+static void
+mlx5e_flow_meter_cir_calc(u64 cir, u8 *man, u8 *exp)
+{
+	s64 _cir, _delta, delta = S64_MAX;
+	u8 e, _man = 0, _exp = 0;
+	u64 m;
+
+	for (e = 0; e <= 0x1F; e++) { /* exp width 5bit */
+		m = cir << e;
+		if ((s64)m < 0) /* overflow */
+			break;
+		m /= MLX5_CONST_CIR;
+		if (m > 0xFF) /* man width 8 bit */
+			continue;
+		_cir = MLX5_CALC_CIR(m, e);
+		_delta = cir - _cir;
+		if (_delta < delta) {
+			_man = m;
+			_exp = e;
+			if (!_delta)
+				goto found;
+			delta = _delta;
+		}
+	}
+
+found:
+	*man = _man;
+	*exp = _exp;
+}
+
+static void
+mlx5e_flow_meter_cbs_calc(u64 cbs, u8 *man, u8 *exp)
+{
+	s64 _cbs, _delta, delta = S64_MAX;
+	u8 e, _man = 0, _exp = 0;
+	u64 m;
+
+	for (e = 0; e <= 0x1F; e++) { /* exp width 5bit */
+		m = cbs >> e;
+		if (m > 0xFF) /* man width 8 bit */
+			continue;
+		_cbs = MLX5_CALC_CBS(m, e);
+		_delta = cbs - _cbs;
+		if (_delta < delta) {
+			_man = m;
+			_exp = e;
+			if (!_delta)
+				goto found;
+			delta = _delta;
+		}
+	}
+
+found:
+	*man = _man;
+	*exp = _exp;
+}
+
+int
+mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
+		      struct mlx5e_flow_meter_handle *meter,
+		      struct mlx5e_flow_meter_params *meter_params)
+{
+	struct mlx5_wqe_aso_ctrl_seg *aso_ctrl;
+	struct mlx5_wqe_aso_data_seg *aso_data;
+	struct mlx5e_flow_meters *flow_meters;
+	u8 cir_man, cir_exp, cbs_man, cbs_exp;
+	struct mlx5_aso_wqe *aso_wqe;
+	struct mlx5_aso *aso;
+	u64 rate, burst;
+	u8 ds_cnt;
+	int err;
+
+	rate = meter_params->rate;
+	burst = meter_params->burst;
+
+	/* HW treats each packet as 128 bytes in PPS mode */
+	if (meter_params->mode == MLX5_RATE_LIMIT_PPS) {
+		rate <<= 10;
+		burst <<= 7;
+	}
+
+	if (!rate || rate > MLX5_MAX_CIR || !burst || burst > MLX5_MAX_CBS)
+		return -EINVAL;
+
+	/* HW has limitation of total 31 bits for cbs */
+	if (burst > MLX5_MAX_HW_CBS) {
+		mlx5_core_warn(mdev,
+			       "burst(%lld) is too large, use HW allowed value(%d)\n",
+			       burst, MLX5_MAX_HW_CBS);
+		burst = MLX5_MAX_HW_CBS;
+	}
+
+	mlx5_core_dbg(mdev, "meter mode=%d\n", meter_params->mode);
+	mlx5e_flow_meter_cir_calc(rate, &cir_man, &cir_exp);
+	mlx5_core_dbg(mdev, "rate=%lld, cir=%lld, exp=%d, man=%d\n",
+		      rate, MLX5_CALC_CIR(cir_man, cir_exp), cir_exp, cir_man);
+	mlx5e_flow_meter_cbs_calc(burst, &cbs_man, &cbs_exp);
+	mlx5_core_dbg(mdev, "burst=%lld, cbs=%lld, exp=%d, man=%d\n",
+		      burst, MLX5_CALC_CBS((u64)cbs_man, cbs_exp), cbs_exp, cbs_man);
+
+	if (!cir_man || !cbs_man)
+		return -EINVAL;
+
+	flow_meters = meter->flow_meters;
+	aso = flow_meters->aso;
+
+	mutex_lock(&flow_meters->aso_lock);
+	aso_wqe = mlx5_aso_get_wqe(aso);
+	ds_cnt = DIV_ROUND_UP(sizeof(struct mlx5_aso_wqe_data), MLX5_SEND_WQE_DS);
+	mlx5_aso_build_wqe(aso, ds_cnt, aso_wqe, meter->obj_id,
+			   MLX5_ACCESS_ASO_OPC_MOD_FLOW_METER);
+
+	aso_ctrl = &aso_wqe->aso_ctrl;
+	memset(aso_ctrl, 0, sizeof(*aso_ctrl));
+	aso_ctrl->data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BYTEWISE_64BYTE << 6;
+	aso_ctrl->condition_1_0_operand = MLX5_ASO_ALWAYS_TRUE |
+					  MLX5_ASO_ALWAYS_TRUE << 4;
+	aso_ctrl->data_offset_condition_operand = MLX5_ASO_LOGICAL_OR << 6;
+	aso_ctrl->data_mask = cpu_to_be64(0x80FFFFFFULL << (meter->idx ? 0 : 32));
+
+	aso_data = (struct mlx5_wqe_aso_data_seg *)(aso_wqe + 1);
+	memset(aso_data, 0, sizeof(*aso_data));
+	aso_data->bytewise_data[meter->idx * 8] = cpu_to_be32((0x1 << 31) | /* valid */
+					(MLX5_FLOW_METER_COLOR_GREEN << MLX5_START_COLOR_SHIFT));
+	if (meter_params->mode == MLX5_RATE_LIMIT_PPS)
+		aso_data->bytewise_data[meter->idx * 8] |=
+			cpu_to_be32(MLX5_FLOW_METER_MODE_NUM_PACKETS << MLX5_METER_MODE_SHIFT);
+	else
+		aso_data->bytewise_data[meter->idx * 8] |=
+			cpu_to_be32(MLX5_FLOW_METER_MODE_BYTES_IP_LENGTH << MLX5_METER_MODE_SHIFT);
+
+	aso_data->bytewise_data[meter->idx * 8 + 2] = cpu_to_be32((cbs_exp << MLX5_CBS_EXP_SHIFT) |
+								  (cbs_man << MLX5_CBS_MAN_SHIFT) |
+								  (cir_exp << MLX5_CIR_EXP_SHIFT) |
+								  cir_man);
+
+	mlx5_aso_post_wqe(aso, true, &aso_wqe->ctrl);
+
+	/* With newer FW, the wait for the first ASO WQE is more than 2us, put the wait 10ms. */
+	err = mlx5_aso_poll_cq(aso, true, 10);
+	mutex_unlock(&flow_meters->aso_lock);
+
+	return err;
+}
+
 struct mlx5e_flow_meters *
 mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		       enum mlx5_flow_namespace_type ns_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index 53dc6c840ffc..0153509e729e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -6,6 +6,28 @@
 
 struct mlx5e_flow_meters;
 
+enum mlx5e_flow_meter_mode {
+	MLX5_RATE_LIMIT_BPS,
+	MLX5_RATE_LIMIT_PPS,
+};
+
+struct mlx5e_flow_meter_params {
+	enum mlx5e_flow_meter_mode mode;
+	u64 rate;
+	u64 burst;
+};
+
+struct mlx5e_flow_meter_handle {
+	struct mlx5e_flow_meters *flow_meters;
+	u32 obj_id;
+	u8 idx;
+};
+
+int
+mlx5e_tc_meter_modify(struct mlx5_core_dev *mdev,
+		      struct mlx5e_flow_meter_handle *meter,
+		      struct mlx5e_flow_meter_params *meter_params);
+
 struct mlx5e_flow_meters *
 mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		       enum mlx5_flow_namespace_type ns_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index 7420df061b3b..b3bbf284fe71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -44,6 +44,11 @@ struct mlx5_aso_wqe_data {
 	struct mlx5_wqe_aso_data_seg  aso_data;
 };
 
+enum {
+	MLX5_ASO_LOGICAL_AND,
+	MLX5_ASO_LOGICAL_OR,
+};
+
 enum {
 	MLX5_ASO_ALWAYS_FALSE,
 	MLX5_ASO_ALWAYS_TRUE,
@@ -63,6 +68,10 @@ enum {
 	MLX5_ASO_DATA_MASK_MODE_CALCULATED_64BYTE,
 };
 
+enum {
+	MLX5_ACCESS_ASO_OPC_MOD_FLOW_METER = 0x2,
+};
+
 struct mlx5_aso;
 
 void *mlx5_aso_get_wqe(struct mlx5_aso *aso);
-- 
2.36.1

