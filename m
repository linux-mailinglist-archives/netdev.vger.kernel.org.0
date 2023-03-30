Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F86CFDA0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjC3IDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjC3IC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E823B18F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67107B8264D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AC2C433EF;
        Thu, 30 Mar 2023 08:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163372;
        bh=SKB3klSzkuaeGqEhcKpCcn9kmkwvTn2sg8JKbmrJxd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SO3ffyTID2hVFaqafWW+2K4W0Undg55EN5dqvmCg4724suxqMI3dMejQ09pDuCbeT
         OuCEQUwzo3Ur4Zd4p4rPnQKK7PCVywlvAwbRisbDh+Fa4EJ7tVGYXnZ+ckPlnc9Bmh
         mBE8ZNeGeFcMfN7j+rjpHI9Wuq5AMeocQPi2X+aVIZNdbGar6LmnCvYOi26gECuCHD
         Sf5oS4goNzPtgr4vVy/SHtk8fHevLapcUmfuvrUzb/upDhQ0Z2tiuss4XfsapM0HoA
         h/n2BwCuBQ1h8xIyQ5rvD6xs8B3cyarQ0ByA6WjdBENyfWL+vNl1fxqlMk+KTw3/7T
         NbdDNky4v0xDg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 03/10] net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard limits
Date:   Thu, 30 Mar 2023 11:02:24 +0300
Message-Id: <5a86c890b6dccb6865acf9042a8b03f899d1f3f9.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The CX7 cards which support IPsec packet offload use 32 bits to
configure soft and hard packet limits. This is not enough as the
software part using 64 bits.

The needed functionality of supporting 64 bits is implemented through
mlx5 abstraction layer, which will ensure that HW is reconfigured
on-demand every 2^31 packets.

To simulate the 64 bit IPsec soft/hard limits, we divide the soft/hard
limits to multiple interrupts (rounds). Each round counts 2^31 packets.
Once the counter is less than or equal to 2^31, the soft event is raised
and software sets the bit 31 of the counter and decrement the round
counter.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 114 +++++++++++++++--
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  17 ++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 119 ++++++++++++++++--
 3 files changed, 227 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c2e4f30d1f76..3612cdd37b5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -87,25 +87,113 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 				    struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct xfrm_state *x = sa_entry->x;
+	s64 start_value, n;
 
-	attrs->hard_packet_limit = x->lft.hard_packet_limit;
+	attrs->lft.hard_packet_limit = x->lft.hard_packet_limit;
+	attrs->lft.soft_packet_limit = x->lft.soft_packet_limit;
 	if (x->lft.soft_packet_limit == XFRM_INF)
 		return;
 
-	/* Hardware decrements hard_packet_limit counter through
-	 * the operation. While fires an event when soft_packet_limit
-	 * is reached. It emans that we need substitute the numbers
-	 * in order to properly count soft limit.
+	/* Compute hard limit initial value and number of rounds.
 	 *
-	 * As an example:
-	 * XFRM user sets soft limit is 2 and hard limit is 9 and
-	 * expects to see soft event after 2 packets and hard event
-	 * after 9 packets. In our case, the hard limit will be set
-	 * to 9 and soft limit is comparator to 7 so user gets the
-	 * soft event after 2 packeta
+	 * The counting pattern of hardware counter goes:
+	 *                value  -> 2^31-1
+	 *      2^31  | (2^31-1) -> 2^31-1
+	 *      2^31  | (2^31-1) -> 2^31-1
+	 *      [..]
+	 *      2^31  | (2^31-1) -> 0
+	 *
+	 * The pattern is created by using an ASO operation to atomically set
+	 * bit 31 after the down counter clears bit 31. This is effectively an
+	 * atomic addition of 2**31 to the counter.
+	 *
+	 * We wish to configure the counter, within the above pattern, so that
+	 * when it reaches 0, it has hit the hard limit. This is defined by this
+	 * system of equations:
+	 *
+	 *      hard_limit == start_value + n * 2^31
+	 *      n >= 0
+	 *      start_value < 2^32, start_value >= 0
+	 *
+	 * These equations are not single-solution, there are often two choices:
+	 *      hard_limit == start_value + n * 2^31
+	 *      hard_limit == (start_value+2^31) + (n-1) * 2^31
+	 *
+	 * The algorithm selects the solution that keeps the counter value
+	 * above 2^31 until the final iteration.
+	 */
+
+	/* Start by estimating n and compute start_value */
+	n = attrs->lft.hard_packet_limit / BIT_ULL(31);
+	start_value = attrs->lft.hard_packet_limit - n * BIT_ULL(31);
+
+	/* Choose the best of the two solutions: */
+	if (n >= 1)
+		n -= 1;
+
+	/* Computed values solve the system of equations: */
+	start_value = attrs->lft.hard_packet_limit - n * BIT_ULL(31);
+
+	/* The best solution means: when there are multiple iterations we must
+	 * start above 2^31 and count down to 2**31 to get the interrupt.
+	 */
+	attrs->lft.hard_packet_limit = lower_32_bits(start_value);
+	attrs->lft.numb_rounds_hard = (u64)n;
+
+	/* Compute soft limit initial value and number of rounds.
+	 *
+	 * The soft_limit is achieved by adjusting the counter's
+	 * interrupt_value. This is embedded in the counting pattern created by
+	 * hard packet calculations above.
+	 *
+	 * We wish to compute the interrupt_value for the soft_limit. This is
+	 * defined by this system of equations:
+	 *
+	 *      soft_limit == start_value - soft_value + n * 2^31
+	 *      n >= 0
+	 *      soft_value < 2^32, soft_value >= 0
+	 *      for n == 0 start_value > soft_value
+	 *
+	 * As with compute_hard_n_value() the equations are not single-solution.
+	 * The algorithm selects the solution that has:
+	 *      2^30 <= soft_limit < 2^31 + 2^30
+	 * for the interior iterations, which guarantees a large guard band
+	 * around the counter hard limit and next interrupt.
+	 */
+
+	/* Start by estimating n and compute soft_value */
+	n = (x->lft.soft_packet_limit - attrs->lft.hard_packet_limit) / BIT_ULL(31);
+	start_value = attrs->lft.hard_packet_limit + n * BIT_ULL(31) -
+		      x->lft.soft_packet_limit;
+
+	/* Compare against constraints and adjust n */
+	if (n < 0)
+		n = 0;
+	else if (start_value >= BIT_ULL(32))
+		n -= 1;
+	else if (start_value < 0)
+		n += 1;
+
+	/* Choose the best of the two solutions: */
+	start_value = attrs->lft.hard_packet_limit + n * BIT_ULL(31) - start_value;
+	if (n != attrs->lft.numb_rounds_hard && start_value < BIT_ULL(30))
+		n += 1;
+
+	/* Note that the upper limit of soft_value happens naturally because we
+	 * always select the lowest soft_value.
+	 */
+
+	/* Computed values solve the system of equations: */
+	start_value = attrs->lft.hard_packet_limit + n * BIT_ULL(31) - start_value;
+
+	/* The best solution means: when there are multiple iterations we must
+	 * not fall below 2^30 as that would get too close to the false
+	 * hard_limit and when we reach an interior iteration for soft_limit it
+	 * has to be far away from 2**32-1 which is the counter reset point
+	 * after the +2^31 to accommodate latency.
 	 */
-	attrs->soft_packet_limit =
-		x->lft.hard_packet_limit - x->lft.soft_packet_limit;
+	attrs->lft.soft_packet_limit = lower_32_bits(start_value);
+	attrs->lft.numb_rounds_soft = (u64)n;
 }
 
 void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 68ae5230eb75..0c58c3583b0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -60,6 +60,13 @@ struct upspec {
 	u8 proto;
 };
 
+struct mlx5_ipsec_lft {
+	u64 hard_packet_limit;
+	u64 soft_packet_limit;
+	u64 numb_rounds_hard;
+	u64 numb_rounds_soft;
+};
+
 struct mlx5_accel_esp_xfrm_attrs {
 	u32   esn;
 	u32   spi;
@@ -85,8 +92,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u32 replay_window;
 	u32 authsize;
 	u32 reqid;
-	u64 hard_packet_limit;
-	u64 soft_packet_limit;
+	struct mlx5_ipsec_lft lft;
 };
 
 enum mlx5_ipsec_cap {
@@ -170,6 +176,12 @@ struct mlx5e_ipsec_modify_state_work {
 	struct mlx5_accel_esp_xfrm_attrs attrs;
 };
 
+struct mlx5e_ipsec_limits {
+	u64 round;
+	u8 soft_limit_hit : 1;
+	u8 fix_limit : 1;
+};
+
 struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_esn_state esn_state;
 	struct xfrm_state *x;
@@ -181,6 +193,7 @@ struct mlx5e_ipsec_sa_entry {
 	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
 	struct mlx5e_ipsec_modify_state_work modify_work;
+	struct mlx5e_ipsec_limits limits;
 };
 
 struct mlx5_accel_pol_xfrm_attrs {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 43cfa4df1311..684de9739e69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -8,6 +8,7 @@
 
 enum {
 	MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET,
+	MLX5_IPSEC_ASO_REMOVE_FLOW_SOFT_LFT_OFFSET,
 };
 
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
@@ -100,15 +101,15 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
 		MLX5_SET(ipsec_aso, aso_ctx, mode, MLX5_IPSEC_ASO_INC_SN);
 
-	if (attrs->hard_packet_limit != XFRM_INF) {
+	if (attrs->lft.hard_packet_limit != XFRM_INF) {
 		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_pkt_cnt,
-			 lower_32_bits(attrs->hard_packet_limit));
+			 attrs->lft.hard_packet_limit);
 		MLX5_SET(ipsec_aso, aso_ctx, hard_lft_arm, 1);
 	}
 
-	if (attrs->soft_packet_limit != XFRM_INF) {
+	if (attrs->lft.soft_packet_limit != XFRM_INF) {
 		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_soft_lft,
-			 lower_32_bits(attrs->soft_packet_limit));
+			 attrs->lft.soft_packet_limit);
 
 		MLX5_SET(ipsec_aso, aso_ctx, soft_lft_arm, 1);
 	}
@@ -309,6 +310,110 @@ static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_aso_update(sa_entry, &data);
 }
 
+static void mlx5e_ipsec_aso_update_hard(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5_wqe_aso_ctrl_seg data = {};
+
+	data.data_offset_condition_operand =
+		MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
+	data.bitwise_data = cpu_to_be64(BIT_ULL(57) + BIT_ULL(31));
+	data.data_mask = data.bitwise_data;
+	mlx5e_ipsec_aso_update(sa_entry, &data);
+}
+
+static void mlx5e_ipsec_aso_update_soft(struct mlx5e_ipsec_sa_entry *sa_entry,
+					u32 val)
+{
+	struct mlx5_wqe_aso_ctrl_seg data = {};
+
+	data.data_offset_condition_operand =
+		MLX5_IPSEC_ASO_REMOVE_FLOW_SOFT_LFT_OFFSET;
+	data.bitwise_data = cpu_to_be64(val);
+	data.data_mask = cpu_to_be64(U32_MAX);
+	mlx5e_ipsec_aso_update(sa_entry, &data);
+}
+
+static void mlx5e_ipsec_handle_limits(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
+	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct mlx5e_ipsec_aso *aso = ipsec->aso;
+	bool soft_arm, hard_arm;
+	u64 hard_cnt;
+
+	lockdep_assert_held(&sa_entry->x->lock);
+
+	soft_arm = !MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm);
+	hard_arm = !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm);
+	if (!soft_arm && !hard_arm)
+		/* It is not lifetime event */
+		return;
+
+	hard_cnt = MLX5_GET(ipsec_aso, aso->ctx, remove_flow_pkt_cnt);
+	if (!hard_cnt || hard_arm) {
+		/* It is possible to see packet counter equal to zero without
+		 * hard limit event armed. Such situation can be if packet
+		 * decreased, while we handled soft limit event.
+		 *
+		 * However it will be HW/FW bug if hard limit event is raised
+		 * and packet counter is not zero.
+		 */
+		WARN_ON_ONCE(hard_arm && hard_cnt);
+
+		/* Notify about hard limit */
+		xfrm_state_check_expire(sa_entry->x);
+		return;
+	}
+
+	/* We are in soft limit event. */
+	if (!sa_entry->limits.soft_limit_hit &&
+	    sa_entry->limits.round == attrs->lft.numb_rounds_soft) {
+		sa_entry->limits.soft_limit_hit = true;
+		/* Notify about soft limit */
+		xfrm_state_check_expire(sa_entry->x);
+
+		if (sa_entry->limits.round == attrs->lft.numb_rounds_hard)
+			goto hard;
+
+		if (attrs->lft.soft_packet_limit > BIT_ULL(31)) {
+			/* We cannot avoid a soft_value that might have the high
+			 * bit set. For instance soft_value=2^31+1 cannot be
+			 * adjusted to the low bit clear version of soft_value=1
+			 * because it is too close to 0.
+			 *
+			 * Thus we have this corner case where we can hit the
+			 * soft_limit with the high bit set, but cannot adjust
+			 * the counter. Thus we set a temporary interrupt_value
+			 * at least 2^30 away from here and do the adjustment
+			 * then.
+			 */
+			mlx5e_ipsec_aso_update_soft(sa_entry,
+						    BIT_ULL(31) - BIT_ULL(30));
+			sa_entry->limits.fix_limit = true;
+			return;
+		}
+
+		sa_entry->limits.fix_limit = true;
+	}
+
+hard:
+	if (sa_entry->limits.round == attrs->lft.numb_rounds_hard) {
+		mlx5e_ipsec_aso_update_soft(sa_entry, 0);
+		attrs->lft.soft_packet_limit = XFRM_INF;
+		return;
+	}
+
+	mlx5e_ipsec_aso_update_hard(sa_entry);
+	sa_entry->limits.round++;
+	if (sa_entry->limits.round == attrs->lft.numb_rounds_soft)
+		mlx5e_ipsec_aso_update_soft(sa_entry,
+					    attrs->lft.soft_packet_limit);
+	if (sa_entry->limits.fix_limit) {
+		sa_entry->limits.fix_limit = false;
+		mlx5e_ipsec_aso_update_soft(sa_entry, BIT_ULL(31) - 1);
+	}
+}
+
 static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 {
 	struct mlx5e_ipsec_work *work =
@@ -339,10 +444,8 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		mlx5e_ipsec_update_esn_state(sa_entry, mode_param);
 	}
 
-	if (attrs->soft_packet_limit != XFRM_INF)
-		if (!MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm) ||
-		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm))
-			xfrm_state_check_expire(sa_entry->x);
+	if (attrs->lft.soft_packet_limit != XFRM_INF)
+		mlx5e_ipsec_handle_limits(sa_entry);
 
 unlock:
 	spin_unlock(&sa_entry->x->lock);
-- 
2.39.2

