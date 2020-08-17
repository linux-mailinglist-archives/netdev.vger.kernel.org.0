Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84AC246394
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHQJjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:39:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55842 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728477AbgHQJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:38:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cDnx011420;
        Mon, 17 Aug 2020 12:38:13 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cCZD003239;
        Mon, 17 Aug 2020 12:38:12 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9cCjq003238;
        Mon, 17 Aug 2020 12:38:12 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 07/13] net/mlx5: Handle sync reset abort event
Date:   Mon, 17 Aug 2020 12:37:46 +0300
Message-Id: <1597657072-3130-8-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
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
index f9e293de9de3..61237f4836cc 100644
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
@@ -266,6 +267,16 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
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
@@ -280,6 +291,9 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	case MLX5_SYNC_RST_STATE_RESET_NOW:
 		queue_work(fw_reset->wq, &fw_reset->reset_now_work);
 		break;
+	case MLX5_SYNC_RST_STATE_RESET_ABORT:
+		queue_work(fw_reset->wq, &fw_reset->reset_abort_work);
+		break;
 	}
 }
 
@@ -317,6 +331,7 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
+	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
 
 	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
 	mlx5_eq_notifier_register(dev, &fw_reset->nb);
-- 
2.17.1

