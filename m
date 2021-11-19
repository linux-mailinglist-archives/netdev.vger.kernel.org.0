Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EB245776F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhKSUBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234637AbhKSUBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B587461B44;
        Fri, 19 Nov 2021 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351900;
        bh=naeBAQ/sCdGjQjQQ2fcDNPBHCcU0KQXqqLM+z/Utg6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5heJs8Pq2TfiJhjTipNYtDHjFc6Nf5SkVZZQf5J0664iuYVeZVWiXCNWtkDjz2Bn
         Xk1ZATBOv0wttc5mwrVgPPR9cmnNMbYbs3Rb4q0MN01jWtqA2qs8f9eyAu7SaY2r99
         UBWoXO/JV7qgiAaWNF+d9PHdyTFBsXHXH+euPg7QkZAacxJTphNPWFRF9ljrIT/YRW
         MdTlod1740bWq2GiwMZ4wOF8G0BK8AAr/VlWo+t+sZ4ByQYpv49NTJqi/SAcc+5BNl
         MyfG8AJGtBf6Uf/fnpLcPGbU89y1IvaRvP7dHNI5bHn8uoOOKbyqr7scl6Otw4K7Y+
         DtaN9AYz2Zw8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/10] net/mlx5: Fix too early queueing of log timestamp work
Date:   Fri, 19 Nov 2021 11:58:06 -0800
Message-Id: <20211119195813.739586-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The log timestamp work should not be queued before the command interface
is initialized, move it to a later stage in the init flow.

Fixes: 5a1023deeed0 ("net/mlx5: Add periodic update of host time to firmware")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 64f1abc4dc36..380f50d5462d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -835,6 +835,9 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev)
 
 	health->timer.expires = jiffies + msecs_to_jiffies(poll_interval_ms);
 	add_timer(&health->timer);
+
+	if (mlx5_core_is_pf(dev))
+		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
 }
 
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)
@@ -902,8 +905,6 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	INIT_WORK(&health->fatal_report_work, mlx5_fw_fatal_reporter_err_work);
 	INIT_WORK(&health->report_work, mlx5_fw_reporter_err_work);
 	INIT_DELAYED_WORK(&health->update_fw_log_ts_work, mlx5_health_log_ts_update);
-	if (mlx5_core_is_pf(dev))
-		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
 
 	return 0;
 
-- 
2.31.1

