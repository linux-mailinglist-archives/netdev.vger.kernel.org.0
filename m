Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BF868E514
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBHAiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjBHAhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544CE41090
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7E761472
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E7CC4339C;
        Wed,  8 Feb 2023 00:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816651;
        bh=gtWuUzVGFyoPGlJtSdYzMqwq9/dFM/XAg271lVfpBaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvBMccE8NNlebAeUa9pvvROZinDUQ2BZONLLezhwGhEvUdPVLidcYGC/8w2hNsRlI
         RVhLbuZrLe7Lj2MF7Dpu/m1eyivaOPPXxA+EOmvx62FNZggLHqVG3XikRqM74E10He
         n8L4UY8TlqfTtAqXC/xxPIyF/6uQm3iVfvCfHL8YkkZF1FVl+gWB4upvcwYWkm6idH
         gp1gD37gYvZs79qG1c0X2PSUJaeZi3BA3mPah/QpHlAq0rf727CJc8QmyngQjO1aFm
         FkUJHYyk6m49HDkhdATXVOdwgYYi6xcG8mayIafxhnRSoP15lzZzzt8SY7vpGFC9Wk
         4r73L0mVSAfuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 14/15] net/mlx5: fw_tracer, Add support for strings DB update event
Date:   Tue,  7 Feb 2023 16:37:11 -0800
Message-Id: <20230208003712.68386-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

In case a new string DB is added to the FW, the FW publishes an event
notifying the strings DB have updated.

Add support in driver for handling this event.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 46 ++++++++++++++++---
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  8 ++++
 include/linux/mlx5/device.h                   |  1 +
 3 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index de98357dfd14..46f1e866bf64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -936,6 +936,14 @@ int mlx5_fw_tracer_get_saved_traces_objects(struct mlx5_fw_tracer *tracer,
 	return err;
 }
 
+static void mlx5_fw_tracer_update_db(struct work_struct *work)
+{
+	struct mlx5_fw_tracer *tracer =
+			container_of(work, struct mlx5_fw_tracer, update_db_work);
+
+	mlx5_fw_tracer_reload(tracer);
+}
+
 /* Create software resources (Buffers, etc ..) */
 struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 {
@@ -963,6 +971,8 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 	INIT_WORK(&tracer->ownership_change_work, mlx5_fw_tracer_ownership_change);
 	INIT_WORK(&tracer->read_fw_strings_work, mlx5_tracer_read_strings_db);
 	INIT_WORK(&tracer->handle_traces_work, mlx5_fw_tracer_handle_traces);
+	INIT_WORK(&tracer->update_db_work, mlx5_fw_tracer_update_db);
+	mutex_init(&tracer->state_lock);
 
 
 	err = mlx5_query_mtrc_caps(tracer);
@@ -1009,11 +1019,15 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	if (IS_ERR_OR_NULL(tracer))
 		return 0;
 
-	dev = tracer->dev;
-
 	if (!tracer->str_db.loaded)
 		queue_work(tracer->work_queue, &tracer->read_fw_strings_work);
 
+	mutex_lock(&tracer->state_lock);
+	if (test_and_set_bit(MLX5_TRACER_STATE_UP, &tracer->state))
+		goto unlock;
+
+	dev = tracer->dev;
+
 	err = mlx5_core_alloc_pd(dev, &tracer->buff.pdn);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Failed to allocate PD %d\n", err);
@@ -1034,6 +1048,8 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 		mlx5_core_warn(dev, "FWTracer: Failed to start tracer %d\n", err);
 		goto err_notifier_unregister;
 	}
+unlock:
+	mutex_unlock(&tracer->state_lock);
 	return 0;
 
 err_notifier_unregister:
@@ -1043,6 +1059,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
 err_cancel_work:
 	cancel_work_sync(&tracer->read_fw_strings_work);
+	mutex_unlock(&tracer->state_lock);
 	return err;
 }
 
@@ -1052,17 +1069,27 @@ void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 	if (IS_ERR_OR_NULL(tracer))
 		return;
 
+	mutex_lock(&tracer->state_lock);
+	if (!test_and_clear_bit(MLX5_TRACER_STATE_UP, &tracer->state))
+		goto unlock;
+
 	mlx5_core_dbg(tracer->dev, "FWTracer: Cleanup, is owner ? (%d)\n",
 		      tracer->owner);
 	mlx5_eq_notifier_unregister(tracer->dev, &tracer->nb);
 	cancel_work_sync(&tracer->ownership_change_work);
 	cancel_work_sync(&tracer->handle_traces_work);
+	/* It is valid to get here from update_db_work. Hence, don't wait for
+	 * update_db_work to finished.
+	 */
+	cancel_work(&tracer->update_db_work);
 
 	if (tracer->owner)
 		mlx5_fw_tracer_ownership_release(tracer);
 
 	mlx5_core_destroy_mkey(tracer->dev, tracer->buff.mkey);
 	mlx5_core_dealloc_pd(tracer->dev, tracer->buff.pdn);
+unlock:
+	mutex_unlock(&tracer->state_lock);
 }
 
 /* Free software resources (Buffers, etc ..) */
@@ -1079,6 +1106,7 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	mlx5_fw_tracer_clean_saved_traces_array(tracer);
 	mlx5_fw_tracer_free_strings_db(tracer);
 	mlx5_fw_tracer_destroy_log_buf(tracer);
+	mutex_destroy(&tracer->state_lock);
 	destroy_workqueue(tracer->work_queue);
 	kvfree(tracer);
 }
@@ -1088,6 +1116,8 @@ static int mlx5_fw_tracer_recreate_strings_db(struct mlx5_fw_tracer *tracer)
 	struct mlx5_core_dev *dev;
 	int err;
 
+	if (test_and_set_bit(MLX5_TRACER_RECREATE_DB, &tracer->state))
+		return 0;
 	cancel_work_sync(&tracer->read_fw_strings_work);
 	mlx5_fw_tracer_clean_ready_list(tracer);
 	mlx5_fw_tracer_clean_print_hash(tracer);
@@ -1098,17 +1128,18 @@ static int mlx5_fw_tracer_recreate_strings_db(struct mlx5_fw_tracer *tracer)
 	err = mlx5_query_mtrc_caps(tracer);
 	if (err) {
 		mlx5_core_dbg(dev, "FWTracer: Failed to query capabilities %d\n", err);
-		return err;
+		goto out;
 	}
 
 	err = mlx5_fw_tracer_allocate_strings_db(tracer);
 	if (err) {
 		mlx5_core_warn(dev, "FWTracer: Allocate strings DB failed %d\n", err);
-		return err;
+		goto out;
 	}
 	mlx5_fw_tracer_init_saved_traces_array(tracer);
-
-	return 0;
+out:
+	clear_bit(MLX5_TRACER_RECREATE_DB, &tracer->state);
+	return err;
 }
 
 int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
@@ -1148,6 +1179,9 @@ static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void
 	case MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE:
 		queue_work(tracer->work_queue, &tracer->handle_traces_work);
 		break;
+	case MLX5_TRACER_SUBTYPE_STRINGS_DB_UPDATE:
+		queue_work(tracer->work_queue, &tracer->update_db_work);
+		break;
 	default:
 		mlx5_core_dbg(dev, "FWTracer: Event with unrecognized subtype: sub_type %d\n",
 			      eqe->sub_type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 4762b55b0b0e..873c1eb38e49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -63,6 +63,11 @@ struct mlx5_fw_trace_data {
 	char msg[TRACE_STR_MSG];
 };
 
+enum mlx5_fw_tracer_state {
+	MLX5_TRACER_STATE_UP = BIT(0),
+	MLX5_TRACER_RECREATE_DB = BIT(1),
+};
+
 struct mlx5_fw_tracer {
 	struct mlx5_core_dev *dev;
 	struct mlx5_nb        nb;
@@ -104,6 +109,9 @@ struct mlx5_fw_tracer {
 	struct work_struct handle_traces_work;
 	struct hlist_head hash[MESSAGE_HASH_SIZE];
 	struct list_head ready_strings_list;
+	struct work_struct update_db_work;
+	struct mutex state_lock; /* Synchronize update work with reload flows */
+	unsigned long state;
 };
 
 struct tracer_string_format {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index bc531bd9804f..70b3eacf2bbb 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -367,6 +367,7 @@ enum mlx5_driver_event {
 enum {
 	MLX5_TRACER_SUBTYPE_OWNERSHIP_CHANGE = 0x0,
 	MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE = 0x1,
+	MLX5_TRACER_SUBTYPE_STRINGS_DB_UPDATE = 0x2,
 };
 
 enum {
-- 
2.39.1

