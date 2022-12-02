Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE9A640F06
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiLBUQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiLBUQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:16:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B808C14D16
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD94FCE1FA6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0C0C433D7;
        Fri,  2 Dec 2022 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012155;
        bh=ho3tChmHAsuFJ146Qf0bzufWZ3yrZ/f6TXGNb2uEtks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYcyCQPkABEnMYHwLvQm6/T7ozXB1SF5kbhhsCSY/b+h83yUb9lb6GoZakW24CXDU
         w9uo6KvhOm/WbNgLOepXG1zeQr31w5BBBrE4FWq2swgZ2U6lwtPe16pxBLqyZPM4AF
         DkVX38iXCDU6kmLvG8fYAJUIwSUsBgaaCD2RKnkkTVaQaQh6zj6fO3jnTncyfcCuPD
         +9klx85mygn+QFRDndL1TpEp8Nv2i2JL3uoln/Js5zlQw6XXx7A98Dj+5PrC6RGhGR
         X95dNgsju26+32WBb5CGFf1c2PcaSHiRDjfCrnwKGhapSEgBZvALEOwy7UKwkyeonh
         TAes6JWKHWVHQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 10/13] net/mlx5e: Update IPsec soft and hard limits
Date:   Fri,  2 Dec 2022 22:14:54 +0200
Message-Id: <89fcfe0432d857d006c8b5f2f5082e2193dfbd1b.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Implement mlx5 IPsec callback to update current lifetime counters.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 63 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  6 ++
 .../mlx5/core/en_accel/ipsec_offload.c        | 57 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |  1 +
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index fe10f1a2a04a..8d0c605d4cdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -83,6 +83,31 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return false;
 }
 
+static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
+				    struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	struct xfrm_state *x = sa_entry->x;
+
+	attrs->hard_packet_limit = x->lft.hard_packet_limit;
+	if (x->lft.soft_packet_limit == XFRM_INF)
+		return;
+
+	/* Hardware decrements hard_packet_limit counter through
+	 * the operation. While fires an event when soft_packet_limit
+	 * is reached. It emans that we need substitute the numbers
+	 * in order to properly count soft limit.
+	 *
+	 * As an example:
+	 * XFRM user sets soft limit is 2 and hard limit is 9 and
+	 * expects to see soft event after 2 packets and hard event
+	 * after 9 packets. In our case, the hard limit will be set
+	 * to 9 and soft limit is comparator to 7 so user gets the
+	 * soft event after 2 packeta
+	 */
+	attrs->soft_packet_limit =
+		x->lft.hard_packet_limit - x->lft.soft_packet_limit;
+}
+
 static void
 mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
@@ -134,6 +159,8 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->family = x->props.family;
 	attrs->type = x->xso.type;
 	attrs->reqid = x->props.reqid;
+
+	mlx5e_ipsec_init_limits(sa_entry, attrs);
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
@@ -222,6 +249,21 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 			netdev_info(netdev, "Cannot offload without reqid\n");
 			return -EINVAL;
 		}
+
+		if (x->lft.hard_byte_limit != XFRM_INF ||
+		    x->lft.soft_byte_limit != XFRM_INF) {
+			netdev_info(netdev,
+				    "Device doesn't support limits in bytes\n");
+			return -EINVAL;
+		}
+
+		if (x->lft.soft_packet_limit >= x->lft.hard_packet_limit &&
+		    x->lft.hard_packet_limit != XFRM_INF) {
+			/* XFRM stack doesn't prevent such configuration :(. */
+			netdev_info(netdev,
+				    "Hard packet limit must be greater than soft one\n");
+			return -EINVAL;
+		}
 	}
 	return 0;
 }
@@ -415,6 +457,26 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 	queue_work(sa_entry->ipsec->wq, &modify_work->work);
 }
 
+static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
+{
+	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
+	int err;
+
+	lockdep_assert_held(&x->lock);
+
+	if (sa_entry->attrs.soft_packet_limit == XFRM_INF)
+		/* Limits are not configured, as soft limit
+		 * must be lowever than hard limit.
+		 */
+		return;
+
+	err = mlx5e_ipsec_aso_query(sa_entry);
+	if (err)
+		return;
+
+	mlx5e_ipsec_aso_update_curlft(sa_entry, &x->curlft.packets);
+}
+
 static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x)
 {
 	struct net_device *netdev = x->xdo.real_dev;
@@ -526,6 +588,7 @@ static const struct xfrmdev_ops mlx5e_ipsec_packet_xfrmdev_ops = {
 	.xdo_dev_offload_ok	= mlx5e_ipsec_offload_ok,
 	.xdo_dev_state_advance_esn = mlx5e_xfrm_advance_esn_state,
 
+	.xdo_dev_state_update_curlft = mlx5e_xfrm_update_curlft,
 	.xdo_dev_policy_add = mlx5e_xfrm_add_policy,
 	.xdo_dev_policy_free = mlx5e_xfrm_free_policy,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 724f2df14a97..aac1e6a83631 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -78,6 +78,8 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u32 replay_window;
 	u32 authsize;
 	u32 reqid;
+	u64 hard_packet_limit;
+	u64 soft_packet_limit;
 };
 
 enum mlx5_ipsec_cap {
@@ -208,6 +210,10 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
 void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
 
+int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry);
+void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
+				   u64 *packets);
+
 void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv,
 				     void *ipsec_stats);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index fc88454aaf8d..8790558ea859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -83,6 +83,20 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 	MLX5_SET(ipsec_obj, obj, aso_return_reg, MLX5_IPSEC_ASO_REG_C_4_5);
 	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
 		MLX5_SET(ipsec_aso, aso_ctx, mode, MLX5_IPSEC_ASO_INC_SN);
+
+	if (attrs->hard_packet_limit != XFRM_INF) {
+		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_pkt_cnt,
+			 lower_32_bits(attrs->hard_packet_limit));
+		MLX5_SET(ipsec_aso, aso_ctx, hard_lft_arm, 1);
+		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_enable, 1);
+	}
+
+	if (attrs->soft_packet_limit != XFRM_INF) {
+		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_soft_lft,
+			 lower_32_bits(attrs->soft_packet_limit));
+
+		MLX5_SET(ipsec_aso, aso_ctx, soft_lft_arm, 1);
+	}
 }
 
 static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
@@ -298,3 +312,46 @@ void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
 			 DMA_BIDIRECTIONAL);
 	kfree(aso);
 }
+
+int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct mlx5e_ipsec_aso *aso = ipsec->aso;
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	struct mlx5_wqe_aso_ctrl_seg *ctrl;
+	struct mlx5e_hw_objs *res;
+	struct mlx5_aso_wqe *wqe;
+	u8 ds_cnt;
+
+	res = &mdev->mlx5e_res.hw_objs;
+
+	memset(aso->ctx, 0, sizeof(aso->ctx));
+	wqe = mlx5_aso_get_wqe(aso->aso);
+	ds_cnt = DIV_ROUND_UP(sizeof(*wqe), MLX5_SEND_WQE_DS);
+	mlx5_aso_build_wqe(aso->aso, ds_cnt, wqe, sa_entry->ipsec_obj_id,
+			   MLX5_ACCESS_ASO_OPC_MOD_IPSEC);
+
+	ctrl = &wqe->aso_ctrl;
+	ctrl->va_l =
+		cpu_to_be32(lower_32_bits(aso->dma_addr) | ASO_CTRL_READ_EN);
+	ctrl->va_h = cpu_to_be32(upper_32_bits(aso->dma_addr));
+	ctrl->l_key = cpu_to_be32(res->mkey);
+
+	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
+	return mlx5_aso_poll_cq(aso->aso, false);
+}
+
+void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
+				   u64 *packets)
+{
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct mlx5e_ipsec_aso *aso = ipsec->aso;
+	u64 hard_cnt;
+
+	hard_cnt = MLX5_GET(ipsec_aso, aso->ctx, remove_flow_pkt_cnt);
+	/* HW decresases the limit till it reaches zero to fire an avent.
+	 * We need to fix the calculations, so the returned count is a total
+	 * number of passed packets and not how much left.
+	 */
+	*packets = sa_entry->attrs.hard_packet_limit - hard_cnt;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
index c8fc3c838642..afb078bbb8ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -15,6 +15,7 @@
 #define MLX5_WQE_CTRL_WQE_OPC_MOD_SHIFT 24
 #define MLX5_MACSEC_ASO_DS_CNT (DIV_ROUND_UP(sizeof(struct mlx5_aso_wqe), MLX5_SEND_WQE_DS))
 
+#define ASO_CTRL_READ_EN BIT(0)
 struct mlx5_wqe_aso_ctrl_seg {
 	__be32  va_h;
 	__be32  va_l; /* include read_enable */
-- 
2.38.1

