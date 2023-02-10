Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB566929FC
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjBJWTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjBJWS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744557F833
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10F0461E8A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B87EC433D2;
        Fri, 10 Feb 2023 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067517;
        bh=evgRh+61lue7YFeF6708B1XFrgzsX80NceZrj5JCt1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0RarUS9ZxnotH2ZD3GNNF5sNPyYadkB8ozTZOjfIEFa9iW1YYSXPR6cH5loQ0LsW
         Uoe23yzAzga3PI64+D5hw7qgtG8+2AHeyFuRHYnueGRm2UHpResXOW0WQLdCmPp31r
         bz1sMOLdx7Pgy8pdCFx7sPqTiJq7WlBIy4+fFycrf9MPWGUKQcoebV5bp+f4hejLcy
         NCT0fqUjrZcciWT7iAL6APssrj58Ud8V0HeIdwajW8HfBHwXvS+SEJC/nBBP7KaJJ+
         QIwtpr+7dyJG4ep4hWcTWEFUMFsdOkbnQJaWSyniAdavd32B8OEnThoMOYJFYnLv4y
         8m8l+R3WNAs4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: Replace usage of mlx5e_devlink_get_dl_port() by netdev->devlink_port
Date:   Fri, 10 Feb 2023 14:18:16 -0800
Message-Id: <20230210221821.271571-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

On places where netdev pointer is available, access related devlink_port
pointer by netdev->devlink_port instead of using
mlx5e_devlink_get_dl_port() which is going to be removed.

Move SET_NETDEV_DEVLINK_PORT() call right after devlink port
registration to make sure netdev->devlink_port is valid.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c          | 6 ++----
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 95edab4a1732..c462fe76495b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -736,10 +736,10 @@ static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 
 void mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
-	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_rx_reporter_ops,
+	reporter = devlink_port_health_reporter_create(priv->netdev->devlink_port,
+						       &mlx5_rx_reporter_ops,
 						       MLX5E_REPORTER_RX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 41e356d9d785..34666e2b3871 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -594,10 +594,10 @@ static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
 
 void mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
-	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_tx_reporter_ops,
+	reporter = devlink_port_health_reporter_create(priv->netdev->devlink_port,
+						       &mlx5_tx_reporter_ops,
 						       MLX5_REPORTER_TX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8c541d5055ef..18b2fe658d20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5915,6 +5915,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 		goto err_destroy_netdev;
 	}
+	SET_NETDEV_DEVLINK_PORT(netdev, mlx5e_devlink_get_dl_port(priv));
 
 	err = profile->init(mdev, netdev);
 	if (err) {
@@ -5928,7 +5929,6 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 		goto err_profile_cleanup;
 	}
 
-	SET_NETDEV_DEVLINK_PORT(netdev, mlx5e_devlink_get_dl_port(priv));
 	err = register_netdev(netdev);
 	if (err) {
 		mlx5_core_err(mdev, "register_netdev failed, %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a9473a51edc1..b2c7ec4692f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2570,10 +2570,8 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 
 static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
-	struct mlx5e_priv *priv = netdev_priv(rq->netdev);
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
-	struct devlink_port *dl_port;
 	struct sk_buff *skb;
 	u32 cqe_bcnt;
 	u16 trap_id;
@@ -2596,8 +2594,8 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	skb_push(skb, ETH_HLEN);
 
-	dl_port = mlx5e_devlink_get_dl_port(priv);
-	mlx5_devlink_trap_report(rq->mdev, trap_id, skb, dl_port);
+	mlx5_devlink_trap_report(rq->mdev, trap_id, skb,
+				 rq->netdev->devlink_port);
 	dev_kfree_skb_any(skb);
 
 free_wqe:
-- 
2.39.1

