Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE66F6B8ABE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjCNFnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716C17EA35
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1068DB81896
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66DBC433D2;
        Tue, 14 Mar 2023 05:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772571;
        bh=Iku6QCdwcKpaw5si+O5NxBj310ZJZ1LRh/VgdUK/t3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtYI/GdNQgCGrbPKGPeDEawpxpWpIcaFiq7fopYDjOWiWod9a3qUJ2WKUtB9E+MjT
         EgKQnip3wg3RMgd9xbUdkspAXm8MXGLA4HTs9aq1Ebi4YggpfbAi3w0ZX/0f+dAsa6
         dFU8kxEV9319ey/0UeS1trFBehT0utNdPGVRgBWCWR8OxetTrwssV42AD4Xk9WsZJ7
         AFK3I/oV41X/LG3wAvp3h8aZPybOgH+w682QDEImlQcz2KCsrVClUtaY0U7l9zsYP6
         7cL7gJBma64YboBSEbmK7EW5w6DfstRO32uJIgnQH4HO8dqOYZGS927INsjvTXhidd
         /nD/cg2IY4+xA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Expose SQ SW state as part of SQ health diagnostics
Date:   Mon, 13 Mar 2023 22:42:27 -0700
Message-Id: <20230314054234.267365-9-saeed@kernel.org>
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

Add SQ SW state textual representation to devlink health diagnostics
for tx reporter.

SQ SW state can be retrieved by issuing the devlink command below:

$ devlink health diagnose auxiliary/mlx5_core.eth.0/65535 reporter tx

Output
=======================================================================
 Common Config:
    SQ:
      stride size: 64 size: 1024 ts_format: FRC
      CQ:
        stride size: 64 size: 1024
  SQs:
      channel ix: 0 tc: 0 txq ix: 0 sqn: 4170 HW state: 1 stopped: false cc: 0 pc: 0
        SW State:
          enabled: 1 mpwqe: 1 recovering: 0 ipsec: 0 am: 1 vlan_need_l2_inline: 1 pending_xsk_tx: 0 pending_tls_rx_resync: 0 xdp_multibuf: 0
      CQ:
        cqn: 1031 HW status: 0 ci: 0 size: 1024
      EQ:
        eqn: 7 irqn: 32 vecidx: 0 ci: 2 size: 2048

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  6 ++-
 .../mellanox/mlx5/core/en/reporter_tx.c       | 46 +++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6c01da3bad74..67f7e24d1f36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -389,8 +389,11 @@ struct mlx5e_sq_dma {
 	enum mlx5e_dma_map_type type;
 };
 
+/* Keep this enum consistent with with the corresponding strings array
+ * declared in en/reporter_tx.c
+ */
 enum {
-	MLX5E_SQ_STATE_ENABLED,
+	MLX5E_SQ_STATE_ENABLED = 0,
 	MLX5E_SQ_STATE_MPWQE,
 	MLX5E_SQ_STATE_RECOVERING,
 	MLX5E_SQ_STATE_IPSEC,
@@ -399,6 +402,7 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 	MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC,
 	MLX5E_SQ_STATE_XDP_MULTIBUF,
+	MLX5E_NUM_SQ_STATES, /* Must be kept last */
 };
 
 struct mlx5e_tx_mpwqe {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 34666e2b3871..44c1926843a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -6,6 +6,19 @@
 #include "en/devlink.h"
 #include "lib/tout.h"
 
+/* Keep this string array consistent with the MLX5E_SQ_STATE_* enums in en.h */
+static const char * const sq_sw_state_type_name[] = {
+	[MLX5E_SQ_STATE_ENABLED] = "enabled",
+	[MLX5E_SQ_STATE_MPWQE] = "mpwqe",
+	[MLX5E_SQ_STATE_RECOVERING] = "recovering",
+	[MLX5E_SQ_STATE_IPSEC] = "ipsec",
+	[MLX5E_SQ_STATE_DIM] = "dim",
+	[MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE] = "vlan_need_l2_inline",
+	[MLX5E_SQ_STATE_PENDING_XSK_TX] = "pending_xsk_tx",
+	[MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC] = "pending_tls_rx_resync",
+	[MLX5E_SQ_STATE_XDP_MULTIBUF] = "xdp_multibuf",
+};
+
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
 	struct mlx5_core_dev *dev = sq->mdev;
@@ -37,6 +50,35 @@ static void mlx5e_reset_txqsq_cc_pc(struct mlx5e_txqsq *sq)
 	sq->pc = 0;
 }
 
+static int mlx5e_health_sq_put_sw_state(struct devlink_fmsg *fmsg, struct mlx5e_txqsq *sq)
+{
+	int err;
+	int i;
+
+	BUILD_BUG_ON_MSG(ARRAY_SIZE(sq_sw_state_type_name) != MLX5E_NUM_SQ_STATES,
+			 "sq_sw_state_type_name string array must be consistent with MLX5E_SQ_STATE_* enum in en.h");
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "SW State");
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(sq_sw_state_type_name); ++i) {
+		err = devlink_fmsg_u32_pair_put(fmsg, sq_sw_state_type_name[i],
+						test_bit(i, &sq->state));
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
 static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 {
 	struct mlx5_core_dev *mdev;
@@ -190,6 +232,10 @@ mlx5e_tx_reporter_build_diagnose_output_sq_common(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
+	err = mlx5e_health_sq_put_sw_state(fmsg, sq);
+	if (err)
+		return err;
+
 	err = mlx5e_health_cq_diag_fmsg(&sq->cq, fmsg);
 	if (err)
 		return err;
-- 
2.39.2

