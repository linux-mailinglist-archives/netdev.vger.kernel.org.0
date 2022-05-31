Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E2853984D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245239AbiEaUzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244520AbiEaUzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE5F9CF6E
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040D7612CA
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E80DC3411C;
        Tue, 31 May 2022 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030507;
        bh=NSsUPTsYy/ThbFtlt4jcyEWoJFxDWMdT3Y8mBYI7KsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p62p84VrReU0/BpgUahWiz5NrmbKLu1tURBsyQRmW6Du95sxe/6StNHWcVdo9+WnJ
         pgK1VfBho/8n4c3HPhufAsl6rG9vcZWd2AB+ZF6NZrfbGx4YhM0QqZSfqfhQi8jKuZ
         lNv1MUhFLQxEzHDNBR+GuX6ZOtKRIPWgeXIDB3pBOdEt3hFRQ7xzQYlCCFwjc49iKs
         H10cekJiwO48AwPSoYHe2hD/PW/YHLStttH10TO4/fZuB3wx6lX2mVZOPSSiirY9nh
         eDCIejSZpBTOJLLFwkFflx1WnV7k9i1YMADAw0HW22Q3g85YUI3M2FHPJ5kZ6IR4Mu
         G/JuEa2JQb8tQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Karsten Nielsen <karsten@foo-bar.dk>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/7] net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition
Date:   Tue, 31 May 2022 13:54:44 -0700
Message-Id: <20220531205447.99236-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

When the driver activates the channels, it assumes NAPI isn't running
yet. mlx5e_activate_rq posts a NOP WQE to ICOSQ to trigger a hardware
interrupt and start NAPI, which will run mlx5e_alloc_rx_mpwqe and post
UMR WQEs to ICOSQ to be able to receive packets with striding RQ.

Unfortunately, a race condition is possible if NAPI is triggered by
something else (for example, TX) at a bad timing, before
mlx5e_activate_rq finishes. In this case, mlx5e_alloc_rx_mpwqe may post
UMR WQEs to ICOSQ, and with the bad timing, the wqe_info of the first
UMR may be overwritten by the wqe_info of the NOP posted by
mlx5e_activate_rq.

The consequence is that icosq->db.wqe_info[0].num_wqebbs will be changed
from MLX5E_UMR_WQEBBS to 1, disrupting the integrity of the array-based
linked list in wqe_info[]. mlx5e_poll_ico_cq will hang in an infinite
loop after processing wqe_info[0], because after the corruption, the
next item to be processed will be wqe_info[1], which is filled with
zeros, and `sqcc += wi->num_wqebbs` will never move further.

This commit fixes this race condition by using async_icosq to post the
NOP and trigger the interrupt. async_icosq is always protected with a
spinlock, eliminating the race condition.

Fixes: bc77b240b3c5 ("net/mlx5e: Add fragmented memory support for RX multi packet WQE")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reported-by: Karsten Nielsen <karsten@foo-bar.dk>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  6 +++++
 .../net/ethernet/mellanox/mlx5/core/en/trap.c |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |  1 +
 .../mellanox/mlx5/core/en/xsk/setup.c         |  5 +---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++++++------
 7 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 65d3c4865abf..b6c15efe92ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -764,6 +764,7 @@ struct mlx5e_rq {
 	u8                     wq_type;
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
+	struct mlx5e_channel  *channel;
 	u32  umr_mkey;
 	struct mlx5e_dma_info  wqe_overflow;
 
@@ -1076,6 +1077,9 @@ void mlx5e_close_cq(struct mlx5e_cq *cq);
 int mlx5e_open_locked(struct net_device *netdev);
 int mlx5e_close_locked(struct net_device *netdev);
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c);
+void mlx5e_trigger_napi_sched(struct napi_struct *napi);
+
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs);
 void mlx5e_close_channels(struct mlx5e_channels *chs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 335b20b6383b..047f88f09203 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -736,6 +736,7 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_ptp_rx_set_fs(c->priv);
 		mlx5e_activate_rq(&c->rq);
+		mlx5e_trigger_napi_sched(&c->napi);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 2684e9da9f41..fc366e66d0b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -123,6 +123,8 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		xskrq->stats->recover++;
 	}
 
+	mlx5e_trigger_napi_icosq(icosq->channel);
+
 	mutex_unlock(&icosq->channel->icosq_recovery_lock);
 
 	return 0;
@@ -166,6 +168,10 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
+	if (rq->channel)
+		mlx5e_trigger_napi_icosq(rq->channel);
+	else
+		mlx5e_trigger_napi_sched(rq->cq.napi);
 	return 0;
 out:
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index 857840ab1e91..11f2a7fb72a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -179,6 +179,7 @@ static void mlx5e_activate_trap(struct mlx5e_trap *trap)
 {
 	napi_enable(&trap->napi);
 	mlx5e_activate_rq(&trap->rq);
+	mlx5e_trigger_napi_sched(&trap->napi);
 }
 
 void mlx5e_deactivate_trap(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 279cd8f4e79f..2c520394aa1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -117,6 +117,7 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 		goto err_remove_pool;
 
 	mlx5e_activate_xsk(c);
+	mlx5e_trigger_napi_icosq(c);
 
 	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
 	 * any Fill Ring entries at the setup stage.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 3ad7f1301fa8..98ed9ef3a6bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -64,6 +64,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -179,10 +180,6 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	mlx5e_reporter_icosq_resume_recovery(c);
 
 	/* TX queue is created active. */
-
-	spin_lock_bh(&c->async_icosq_lock);
-	mlx5e_trigger_irq(&c->async_icosq);
-	spin_unlock_bh(&c->async_icosq_lock);
 }
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 05c015515cce..930a5402c817 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -475,6 +475,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -1066,13 +1067,6 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	if (rq->icosq) {
-		mlx5e_trigger_irq(rq->icosq);
-	} else {
-		local_bh_disable();
-		napi_schedule(rq->cq.napi);
-		local_bh_enable();
-	}
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
@@ -2227,6 +2221,20 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	return 0;
 }
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+{
+	spin_lock_bh(&c->async_icosq_lock);
+	mlx5e_trigger_irq(&c->async_icosq);
+	spin_unlock_bh(&c->async_icosq_lock);
+}
+
+void mlx5e_trigger_napi_sched(struct napi_struct *napi)
+{
+	local_bh_disable();
+	napi_schedule(napi);
+	local_bh_enable();
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2308,6 +2316,8 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
+
+	mlx5e_trigger_napi_icosq(c);
 }
 
 static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
-- 
2.36.1

