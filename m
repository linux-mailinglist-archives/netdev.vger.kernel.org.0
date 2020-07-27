Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6622EADD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgG0LHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40694 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728539AbgG0LGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:16 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6Dg9022237;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6Dfs002396;
        Mon, 27 Jul 2020 14:06:13 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6DUe002395;
        Mon, 27 Jul 2020 14:06:13 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 07/13] net/mlx5: Handle sync reset abort event
Date:   Mon, 27 Jul 2020 14:02:27 +0300
Message-Id: <1595847753-2234-8-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If firmware sends sync_reset_abort to driver the driver should clear the
reset requested mode as reset is not expected any more.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fw_reset.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 87f2b24f4aaa..e665080e9a4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -9,6 +9,7 @@ struct mlx5_fw_reset {
 	struct workqueue_struct *wq;
 	struct work_struct reset_request_work;
 	struct work_struct reset_now_work;
+	struct work_struct reset_abort_work;
 	struct completion done;
 	int ret;
 };
@@ -192,6 +193,16 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	complete(&fw_reset->done);
 }
 
+static void mlx5_sync_reset_abort_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_abort_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+
+	mlx5_health_clear_reset_requested_mode(dev);
+	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
+}
+
 static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct mlx5_eqe *eqe)
 {
 	struct mlx5_eqe_sync_fw_update *sync_fw_update_eqe;
@@ -206,6 +217,9 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	case MLX5_SYNC_RST_STATE_RESET_NOW:
 		queue_work(fw_reset->wq, &fw_reset->reset_now_work);
 		break;
+	case MLX5_SYNC_RST_STATE_RESET_ABORT:
+		queue_work(fw_reset->wq, &fw_reset->reset_abort_work);
+		break;
 	}
 }
 
@@ -242,6 +256,7 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
+	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
 
 	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
 	mlx5_eq_notifier_register(dev, &fw_reset->nb);
-- 
2.17.1

