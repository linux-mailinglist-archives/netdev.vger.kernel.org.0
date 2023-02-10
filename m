Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E717E6929F6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjBJWS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBJWSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:18:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9C7F80E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 581EAB825FC
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D9C4339B;
        Fri, 10 Feb 2023 22:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067513;
        bh=NV29g+QWx0e+nV7lDlWL+B/ko0dPKM9oCo1TZiAezak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7C6rS0V0LI+WCxuEtmd7DlRNaSJBo1YQaML+bMzKVxRhURA9Fbt/xBfI6KjBWTb4
         mgjND6NHiCdLMRjiGCdBBHNYrv3iluDfAnTA7dLntXsZSSfbTlsB/FdjMhZ6aesPPE
         7xanBqTzRazakjPpb6ne0TUlOOpdfowgalGzTtdiTz7H7ft65Che+lgLQJTiTFBxHT
         W4aMQ5kEZ/wb5u5eeJpCu/X/sny3jiYyxKQGIH9EbGgRfAkA4PtErxPfyxqYdmWMgq
         5Sit3itqKuJDf0Yr6d14m3N/l85xTQW6Gox7wr7gcJwexkZ4h58D5pLyeQBQ4p2Tg6
         BsnXEKgT17qlA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Lag, set different uplink vport metadata in multiport eswitch mode
Date:   Fri, 10 Feb 2023 14:18:10 -0800
Message-Id: <20230210221821.271571-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

In a follow-up commit multiport eswitch mode will use a shared fdb.
In shared fdb there is a single eswitch fdb and traffic could come from any
port. to distinguish between the ports set a different metadata per uplink port.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 35 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 +
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 67 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   |  1 +
 include/linux/mlx5/driver.h                   |  1 +
 5 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8d29310c7e48..9b9203443085 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1007,8 +1007,23 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	priv->rx_res = NULL;
 }
 
+static void mlx5e_rep_mpesw_work(struct work_struct *work)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv =
+		container_of(work, struct mlx5_rep_uplink_priv,
+			     mpesw_work);
+	struct mlx5e_rep_priv *rpriv =
+		container_of(uplink_priv, struct mlx5e_rep_priv,
+			     uplink_priv);
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+
+	rep_vport_rx_rule_destroy(priv);
+	mlx5e_create_rep_vport_rx_rule(priv);
+}
+
 static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	int err;
 
 	mlx5e_create_q_counters(priv);
@@ -1018,12 +1033,17 @@ static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
 
 	mlx5e_tc_int_port_init_rep_rx(priv);
 
+	INIT_WORK(&rpriv->uplink_priv.mpesw_work, mlx5e_rep_mpesw_work);
+
 out:
 	return err;
 }
 
 static void mlx5e_cleanup_ul_rep_rx(struct mlx5e_priv *priv)
 {
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	cancel_work_sync(&rpriv->uplink_priv.mpesw_work);
 	mlx5e_tc_int_port_cleanup_rep_rx(priv);
 	mlx5e_cleanup_rep_rx(priv);
 	mlx5e_destroy_q_counters(priv);
@@ -1132,6 +1152,19 @@ static int mlx5e_update_rep_rx(struct mlx5e_priv *priv)
 	return 0;
 }
 
+static int mlx5e_rep_event_mpesw(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+
+	if (rep->vport != MLX5_VPORT_UPLINK)
+		return NOTIFY_DONE;
+
+	queue_work(priv->wq, &rpriv->uplink_priv.mpesw_work);
+
+	return NOTIFY_OK;
+}
+
 static int uplink_rep_async_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv, events_nb);
@@ -1153,6 +1186,8 @@ static int uplink_rep_async_event(struct notifier_block *nb, unsigned long event
 
 	if (event == MLX5_DEV_EVENT_PORT_AFFINITY)
 		return mlx5e_rep_tc_event_port_affinity(priv);
+	else if (event == MLX5_DEV_EVENT_MULTIPORT_ESW)
+		return mlx5e_rep_event_mpesw(priv);
 
 	return NOTIFY_DONE;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index b4e691760da9..a0891caf464e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -100,6 +100,7 @@ struct mlx5_rep_uplink_priv {
 	struct mlx5e_tc_int_port_priv *int_port_priv;
 
 	struct mlx5e_flow_meters *flow_meters;
+	struct work_struct mpesw_work;
 };
 
 struct mlx5e_rep_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index dd3cb9aa06fd..2f7f2af312d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -5,8 +5,66 @@
 #include <net/nexthop.h>
 #include "lag/lag.h"
 #include "eswitch.h"
+#include "esw/acl/ofld.h"
 #include "lib/mlx5.h"
 
+static void mlx5_mpesw_metadata_cleanup(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev;
+	struct mlx5_eswitch *esw;
+	u32 pf_metadata;
+	int i;
+
+	for (i = 0; i < ldev->ports; i++) {
+		dev = ldev->pf[i].dev;
+		esw = dev->priv.eswitch;
+		pf_metadata = ldev->lag_mpesw.pf_metadata[i];
+		if (!pf_metadata)
+			continue;
+		mlx5_esw_acl_ingress_vport_metadata_update(esw, MLX5_VPORT_UPLINK, 0);
+		mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_MULTIPORT_ESW,
+					 (void *)0);
+		mlx5_esw_match_metadata_free(esw, pf_metadata);
+		ldev->lag_mpesw.pf_metadata[i] = 0;
+	}
+}
+
+static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
+{
+	struct mlx5_core_dev *dev;
+	struct mlx5_eswitch *esw;
+	u32 pf_metadata;
+	int i, err;
+
+	for (i = 0; i < ldev->ports; i++) {
+		dev = ldev->pf[i].dev;
+		esw = dev->priv.eswitch;
+		pf_metadata = mlx5_esw_match_metadata_alloc(esw);
+		if (!pf_metadata) {
+			err = -ENOSPC;
+			goto err_metadata;
+		}
+
+		ldev->lag_mpesw.pf_metadata[i] = pf_metadata;
+		err = mlx5_esw_acl_ingress_vport_metadata_update(esw, MLX5_VPORT_UPLINK,
+								 pf_metadata);
+		if (err)
+			goto err_metadata;
+	}
+
+	for (i = 0; i < ldev->ports; i++) {
+		dev = ldev->pf[i].dev;
+		mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_MULTIPORT_ESW,
+					 (void *)0);
+	}
+
+	return 0;
+
+err_metadata:
+	mlx5_mpesw_metadata_cleanup(ldev);
+	return err;
+}
+
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
@@ -21,6 +79,10 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	    !mlx5_lag_check_prereq(ldev))
 		return -EOPNOTSUPP;
 
+	err = mlx5_mpesw_metadata_set(ldev);
+	if (err)
+		return err;
+
 	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
 	if (err) {
 		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
@@ -30,13 +92,16 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	return 0;
 
 out_err:
+	mlx5_mpesw_metadata_cleanup(ldev);
 	return err;
 }
 
 static void disable_mpesw(struct mlx5_lag *ldev)
 {
-	if (ldev->mode == MLX5_LAG_MODE_MPESW)
+	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
+		mlx5_mpesw_metadata_cleanup(ldev);
 		mlx5_disable_lag(ldev);
+	}
 }
 
 static void mlx5_mpesw_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index d857ea988bf2..02520f27a033 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -9,6 +9,7 @@
 
 struct lag_mpesw {
 	struct work_struct mpesw_work;
+	u32 pf_metadata[MLX5_MAX_PORTS];
 };
 
 enum mpesw_op {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ecd3b5448fe9..a4bb5842a948 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -217,6 +217,7 @@ struct mlx5_rsc_debug {
 enum mlx5_dev_event {
 	MLX5_DEV_EVENT_SYS_ERROR = 128, /* 0 - 127 are FW events */
 	MLX5_DEV_EVENT_PORT_AFFINITY = 129,
+	MLX5_DEV_EVENT_MULTIPORT_ESW = 130,
 };
 
 enum mlx5_port_status {
-- 
2.39.1

