Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884B428586E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgJGGCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:02:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34438 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727341AbgJGGB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:01:27 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 7 Oct 2020 09:01:17 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09761HXU018860;
        Wed, 7 Oct 2020 09:01:17 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 09761HNU021783;
        Wed, 7 Oct 2020 09:01:17 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 09761HFR021782;
        Wed, 7 Oct 2020 09:01:17 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 10/16] net/mlx5: Handle sync reset abort event
Date:   Wed,  7 Oct 2020 09:00:51 +0300
Message-Id: <1602050457-21700-11-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If firmware sends sync_reset_abort to driver the driver should clear the
reset requested mode as reset is not expected any more.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fw_reset.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 26caf65e9f5f..56ae72e016f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -14,6 +14,7 @@ struct mlx5_fw_reset {
 	struct work_struct reset_request_work;
 	struct work_struct reset_reload_work;
 	struct work_struct reset_now_work;
+	struct work_struct reset_abort_work;
 	unsigned long reset_flags;
 	struct timer_list timer;
 };
@@ -271,6 +272,16 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	mlx5_load_one(dev, false);
 }
 
+static void mlx5_sync_reset_abort_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_abort_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+
+	mlx5_sync_reset_clear_reset_requested(dev, true);
+	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
+}
+
 static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct mlx5_eqe *eqe)
 {
 	struct mlx5_eqe_sync_fw_update *sync_fw_update_eqe;
@@ -285,6 +296,9 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	case MLX5_SYNC_RST_STATE_RESET_NOW:
 		queue_work(fw_reset->wq, &fw_reset->reset_now_work);
 		break;
+	case MLX5_SYNC_RST_STATE_RESET_ABORT:
+		queue_work(fw_reset->wq, &fw_reset->reset_abort_work);
+		break;
 	}
 }
 
@@ -335,6 +349,7 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
+	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
 
 	return 0;
 }
-- 
2.18.2

