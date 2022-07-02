Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82746564257
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiGBTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiGBTEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE999E08A
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3598C61007
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E169C34114;
        Sat,  2 Jul 2022 19:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788668;
        bh=LUZjNxxPTOt94gqonwI1t3m3IWImho3UmXG71pvHKlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEtTDeFPDdR5xkHWPC05oV4uAAZzqyrpW9EaQaPX5lh1/aXTip+Sbd+aSW0oIWf/D
         9fa4+OiY1KZkZtReQ1C/hn0cwH1ZM/kzPdIwc+tjSbmPcA9KX/0PBVdFfF2hr+0Ef9
         9li6ZyOJGH2GiTyqJF7PGlsS/Eb1rLV8FPz2bkMnN2snwrFd5G7T94KeVTNXpPWEjW
         0JJkogOK9xo8yONr82Sr6efFXTwtQVFp3AWs0btJVGanrs11Fp8RR4geMDzEW8ZjmG
         WIQGb1oxhORnXuwLIKvV8VPt5u0OUfuQTkIBnHerML0Axa5bDu7EDYqJfWxexYrx1Q
         zoBu9KGPONZAQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next v2 08/15] net/mlx5: Implement interfaces to control ASO SQ and CQ
Date:   Sat,  2 Jul 2022 12:02:06 -0700
Message-Id: <20220702190213.80858-9-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

Add interfaces to use ASO object control channel. The channel consists
of a control SQ and CQ to which user can post ACCESS_ASO work requests
to modify ASO objects. The functions to get wqe from SQ, fill wqe,
post the request, and poll the completion of the work, are provided.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c | 97 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h | 65 +++++++++++++
 2 files changed, 162 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 4195d54d0f51..21e14507ff5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -334,3 +334,100 @@ void mlx5_aso_destroy(struct mlx5_aso *aso)
 	mlx5_aso_destroy_cq(&aso->cq);
 	kfree(aso);
 }
+
+void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
+			struct mlx5_aso_wqe *aso_wqe,
+			u32 obj_id, u32 opc_mode)
+{
+	struct mlx5_wqe_ctrl_seg *cseg = &aso_wqe->ctrl;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((opc_mode << MLX5_WQE_CTRL_WQE_OPC_MOD_SHIFT) |
+					     (aso->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_ACCESS_ASO);
+	cseg->qpn_ds     = cpu_to_be32((aso->sqn << MLX5_WQE_CTRL_QPN_SHIFT) | ds_cnt);
+	cseg->fm_ce_se   = MLX5_WQE_CTRL_CQ_UPDATE;
+	cseg->general_id = cpu_to_be32(obj_id);
+}
+
+void *mlx5_aso_get_wqe(struct mlx5_aso *aso)
+{
+	u16 pi;
+
+	pi = mlx5_wq_cyc_ctr2ix(&aso->wq, aso->pc);
+	return mlx5_wq_cyc_get_wqe(&aso->wq, pi);
+}
+
+void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
+		       struct mlx5_wqe_ctrl_seg *doorbell_cseg)
+{
+	doorbell_cseg->fm_ce_se |= MLX5_WQE_CTRL_CQ_UPDATE;
+	/* ensure wqe is visible to device before updating doorbell record */
+	dma_wmb();
+
+	if (with_data)
+		aso->pc += MLX5_ASO_WQEBBS_DATA;
+	else
+		aso->pc += MLX5_ASO_WQEBBS;
+	*aso->wq.db = cpu_to_be32(aso->pc);
+
+	/* ensure doorbell record is visible to device before ringing the
+	 * doorbell
+	 */
+	wmb();
+
+	mlx5_write64((__be32 *)doorbell_cseg, aso->uar_map);
+
+	/* Ensure doorbell is written on uar_page before poll_cq */
+	WRITE_ONCE(doorbell_cseg, NULL);
+}
+
+int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data, u32 interval_ms)
+{
+	struct mlx5_aso_cq *cq = &aso->cq;
+	struct mlx5_cqe64 *cqe;
+	unsigned long expires;
+
+	cqe = mlx5_cqwq_get_cqe(&cq->wq);
+
+	expires = jiffies + msecs_to_jiffies(interval_ms);
+	while (!cqe && time_is_after_jiffies(expires)) {
+		usleep_range(2, 10);
+		cqe = mlx5_cqwq_get_cqe(&cq->wq);
+	}
+
+	if (!cqe)
+		return -ETIMEDOUT;
+
+	/* sq->cc must be updated only after mlx5_cqwq_update_db_record(),
+	 * otherwise a cq overrun may occur
+	 */
+	mlx5_cqwq_pop(&cq->wq);
+
+	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
+		struct mlx5_err_cqe *err_cqe;
+
+		mlx5_core_err(cq->mdev, "Bad OP in ASOSQ CQE: 0x%x\n",
+			      get_cqe_opcode(cqe));
+
+		err_cqe = (struct mlx5_err_cqe *)cqe;
+		mlx5_core_err(cq->mdev, "vendor_err_synd=%x\n",
+			      err_cqe->vendor_err_synd);
+		mlx5_core_err(cq->mdev, "syndrome=%x\n",
+			      err_cqe->syndrome);
+		print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
+			       16, 1, err_cqe,
+			       sizeof(*err_cqe), false);
+	}
+
+	mlx5_cqwq_update_db_record(&cq->wq);
+
+	/* ensure cq space is freed before enabling more cqes */
+	wmb();
+
+	if (with_data)
+		aso->cc += MLX5_ASO_WQEBBS_DATA;
+	else
+		aso->cc += MLX5_ASO_WQEBBS;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index 55496513d1f9..7420df061b3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -4,10 +4,75 @@
 #ifndef __MLX5_LIB_ASO_H__
 #define __MLX5_LIB_ASO_H__
 
+#include <linux/mlx5/qp.h>
 #include "mlx5_core.h"
 
+#define MLX5_ASO_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5_aso_wqe), MLX5_SEND_WQE_BB))
+#define MLX5_ASO_WQEBBS_DATA \
+	(DIV_ROUND_UP(sizeof(struct mlx5_aso_wqe_data), MLX5_SEND_WQE_BB))
+#define MLX5_WQE_CTRL_WQE_OPC_MOD_SHIFT 24
+
+struct mlx5_wqe_aso_ctrl_seg {
+	__be32  va_h;
+	__be32  va_l; /* include read_enable */
+	__be32  l_key;
+	u8      data_mask_mode;
+	u8      condition_1_0_operand;
+	u8      condition_1_0_offset;
+	u8      data_offset_condition_operand;
+	__be32  condition_0_data;
+	__be32  condition_0_mask;
+	__be32  condition_1_data;
+	__be32  condition_1_mask;
+	__be64  bitwise_data;
+	__be64  data_mask;
+};
+
+struct mlx5_wqe_aso_data_seg {
+	__be32  bytewise_data[16];
+};
+
+struct mlx5_aso_wqe {
+	struct mlx5_wqe_ctrl_seg      ctrl;
+	struct mlx5_wqe_aso_ctrl_seg  aso_ctrl;
+};
+
+struct mlx5_aso_wqe_data {
+	struct mlx5_wqe_ctrl_seg      ctrl;
+	struct mlx5_wqe_aso_ctrl_seg  aso_ctrl;
+	struct mlx5_wqe_aso_data_seg  aso_data;
+};
+
+enum {
+	MLX5_ASO_ALWAYS_FALSE,
+	MLX5_ASO_ALWAYS_TRUE,
+	MLX5_ASO_EQUAL,
+	MLX5_ASO_NOT_EQUAL,
+	MLX5_ASO_GREATER_OR_EQUAL,
+	MLX5_ASO_LESSER_OR_EQUAL,
+	MLX5_ASO_LESSER,
+	MLX5_ASO_GREATER,
+	MLX5_ASO_CYCLIC_GREATER,
+	MLX5_ASO_CYCLIC_LESSER,
+};
+
+enum {
+	MLX5_ASO_DATA_MASK_MODE_BITWISE_64BIT,
+	MLX5_ASO_DATA_MASK_MODE_BYTEWISE_64BYTE,
+	MLX5_ASO_DATA_MASK_MODE_CALCULATED_64BYTE,
+};
+
 struct mlx5_aso;
 
+void *mlx5_aso_get_wqe(struct mlx5_aso *aso);
+void mlx5_aso_build_wqe(struct mlx5_aso *aso, u8 ds_cnt,
+			struct mlx5_aso_wqe *aso_wqe,
+			u32 obj_id, u32 opc_mode);
+void mlx5_aso_post_wqe(struct mlx5_aso *aso, bool with_data,
+		       struct mlx5_wqe_ctrl_seg *doorbell_cseg);
+int mlx5_aso_poll_cq(struct mlx5_aso *aso, bool with_data, u32 interval_ms);
+
 struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn);
 void mlx5_aso_destroy(struct mlx5_aso *aso);
 #endif /* __MLX5_LIB_ASO_H__ */
-- 
2.36.1

