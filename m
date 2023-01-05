Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48B065E492
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjAEESs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjAEES2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71A53D9EC;
        Wed,  4 Jan 2023 20:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81EB1B819AD;
        Thu,  5 Jan 2023 04:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F9EC433F0;
        Thu,  5 Jan 2023 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892294;
        bh=M6HqaU7IB8nFsL897y0FbVJKk1wvmmD+LY057J/xZ2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnQ1wLmECyGQ7ZHnymEHibZP+neUBRvIwv7MuiIjdhLMen8m6RkauO/hrsq6Mf80H
         Aj/QrSMjxBczDhb2Fy/OYLE/99XGlAzCUVatK6GRptrePWxQXpX1bHSu5W5VuIU02C
         nrFr7EBFZZY0anhRgeZHKQ4XzOVTfg2cLCCyA+fQ3XJQyE25BM6CFrgy4u7GkY7CcF
         RHVvZaQg/jffcwr2K/KIc+vffXbEz2EYg/9b12HR3usroNUBcWPQAhRJj4B+rTZyJc
         BVDGfTpeRa8sFeFkXLZB5BN0iQJRQ85+R/hvddKXfpQBQhosaafVXBXp57YDm+M6Qd
         voIor81s+NtHQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH mlx5-next 1/8] net/mlx5e: Fix trap event handling
Date:   Wed,  4 Jan 2023 20:17:49 -0800
Message-Id: <20230105041756.677120-2-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

Current code does not return correct return value from event handler.
Fix it by returning NOTIFY_* and propagate err over newly introduce ctx
structure.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ddb197970c22..6af1e219a9e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -263,6 +263,7 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_devlink_trap_event_ctx trap_event_ctx;
 	enum devlink_trap_action action_orig;
 	struct mlx5_devlink_trap *dl_trap;
 	int err = 0;
@@ -289,10 +290,14 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 
 	action_orig = dl_trap->trap.action;
 	dl_trap->trap.action = action;
+	trap_event_ctx.trap = &dl_trap->trap;
+	trap_event_ctx.err = 0;
 	err = mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_TYPE_TRAP,
-						&dl_trap->trap);
-	if (err)
+						&trap_event_ctx);
+	if (err == NOTIFY_BAD) {
 		dl_trap->trap.action = action_orig;
+		err = trap_event_ctx.err;
+	}
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index fd033df24856..b84cb70eb3ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -24,6 +24,11 @@ struct mlx5_devlink_trap {
 	struct list_head list;
 };
 
+struct mlx5_devlink_trap_event_ctx {
+	struct mlx5_trap_ctx *trap;
+	int err;
+};
+
 struct mlx5_core_dev;
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
 			      struct devlink_port *dl_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8d36e2de53a9..a07f13dc4495 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -179,17 +179,21 @@ static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 static int blocking_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv, blocking_events_nb);
+	struct mlx5_devlink_trap_event_ctx *trap_event_ctx = data;
 	int err;
 
 	switch (event) {
 	case MLX5_DRIVER_EVENT_TYPE_TRAP:
-		err = mlx5e_handle_trap_event(priv, data);
+		err = mlx5e_handle_trap_event(priv, trap_event_ctx->trap);
+		if (err) {
+			trap_event_ctx->err = err;
+			return NOTIFY_BAD;
+		}
 		break;
 	default:
-		netdev_warn(priv->netdev, "Sync event: Unknown event %ld\n", event);
-		err = -EINVAL;
+		return NOTIFY_DONE;
 	}
-	return err;
+	return NOTIFY_OK;
 }
 
 static void mlx5e_enable_blocking_events(struct mlx5e_priv *priv)
-- 
2.38.1

