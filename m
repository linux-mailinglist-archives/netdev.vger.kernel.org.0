Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433A568A95B
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjBDKJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjBDKJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F3E6952E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B1E60BEA
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC34C433D2;
        Sat,  4 Feb 2023 10:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505370;
        bh=j+M0NEd5P5lmV/U9Ni9txg+9At/ITzblwN7dCnZVPN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlYVRGANJwThGmutqOfMb0cDJFEnw/QJETbbr6fRwsL5NkevsYgxQZflxlMi5OyhM
         1GLLlXYEp3ipDU1ZCBaga1pR2NKZjQc1P8L33gaKgRUyV0HPwgTOqY7Q50sa6xtl9e
         Hj+YWXYscbkOnFJpYEF0u5N24Bw4r2EHo7JTS1+3Kb6x0Bk0sfaQ+I6VPU4PdY3B2R
         Jw87y5nHpWLdvzGDmpy+i1poWzOeQL6ljreHyO3Fdhw2Guo5fX/UFYNF3PezTXTlfn
         T2axRGspZAo9eVvbOd3d9jneNpyjYKUHkYkJd3EbOxCHj827n5xEammQ51d2PGI4CD
         Q7uekdxvYwsPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Trigger NAPI after activating an SQ
Date:   Sat,  4 Feb 2023 02:08:54 -0800
Message-Id: <20230204100854.388126-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

If an SQ is deactivated and reactivated again, some packets could be
sent after MLX5E_SQ_STATE_ENABLED is cleared, but before
netif_tx_stop_queue, meaning that NAPI might miss some completions. In
order to handle them, make sure to trigger NAPI after SQ activation in
all cases where it can be relevant. Regular SQs, XDP SQs and XSK SQs are
good. Missing cases added: after recovery, after activating HTB SQs and
after activating PTP SQs.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c  |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++++++++------
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6f8723cc6874..125c7cb7d839 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -454,6 +454,7 @@ struct mlx5e_txqsq {
 	struct mlx5_clock         *clock;
 	struct net_device         *netdev;
 	struct mlx5_core_dev      *mdev;
+	struct mlx5e_channel      *channel;
 	struct mlx5e_priv         *priv;
 
 	/* control path */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8469e9c38670..9a1bc93b7dc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -771,8 +771,8 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_ptp_rx_set_fs(c->priv);
 		mlx5e_activate_rq(&c->rq);
-		mlx5e_trigger_napi_sched(&c->napi);
 	}
+	mlx5e_trigger_napi_sched(&c->napi);
 }
 
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b195dbbf6c90..41e356d9d785 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -81,6 +81,10 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	sq->stats->recover++;
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
 	mlx5e_activate_txqsq(sq);
+	if (sq->channel)
+		mlx5e_trigger_napi_icosq(sq->channel);
+	else
+		mlx5e_trigger_napi_sched(sq->cq.napi);
 
 	return 0;
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e87432ec6f1..27f90baac768 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1470,6 +1470,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->mkey_be   = c->mkey_be;
 	sq->netdev    = c->netdev;
 	sq->mdev      = c->mdev;
+	sq->channel   = c;
 	sq->priv      = c->priv;
 	sq->ch_ix     = c->ix;
 	sq->txq_ix    = txq_ix;
@@ -2482,8 +2483,6 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_xsk(c);
 	else
 		mlx5e_activate_rq(&c->rq);
-
-	mlx5e_trigger_napi_icosq(c);
 }
 
 static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
@@ -2575,13 +2574,19 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 	return err;
 }
 
-static void mlx5e_activate_channels(struct mlx5e_channels *chs)
+static void mlx5e_activate_channels(struct mlx5e_priv *priv, struct mlx5e_channels *chs)
 {
 	int i;
 
 	for (i = 0; i < chs->num; i++)
 		mlx5e_activate_channel(chs->c[i]);
 
+	if (priv->htb)
+		mlx5e_qos_activate_queues(priv);
+
+	for (i = 0; i < chs->num; i++)
+		mlx5e_trigger_napi_icosq(chs->c[i]);
+
 	if (chs->ptp)
 		mlx5e_ptp_activate_channel(chs->ptp);
 }
@@ -2888,9 +2893,7 @@ static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 {
 	mlx5e_build_txq_maps(priv);
-	mlx5e_activate_channels(&priv->channels);
-	if (priv->htb)
-		mlx5e_qos_activate_queues(priv);
+	mlx5e_activate_channels(priv, &priv->channels);
 	mlx5e_xdp_tx_enable(priv);
 
 	/* dev_watchdog() wants all TX queues to be started when the carrier is
-- 
2.39.1

