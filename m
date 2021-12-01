Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07CD464746
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbhLAGlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbhLAGku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05960C061758
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51F1ECE1C91
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90204C53FD1;
        Wed,  1 Dec 2021 06:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340646;
        bh=naeBAQ/sCdGjQjQQ2fcDNPBHCcU0KQXqqLM+z/Utg6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbfEql8PRpt9qQrTqxh3sR3FzEJpoCGmtcxBcsUSqCiGHLrfa6QgCI923boJxIQSc
         MIHwKBaKJqj1O1PHdGY63mAb7UuXRU/dXIbXYgpUAN9VMu88wf9rE9+rE0/s0lmci7
         YQUq42R53yHZq03o/aBc1A4gk0h6a2GFyiaUw9tX2LKN7KVVyOPWUTTmnSzmrfov4j
         uQYPn0tPea2QaqwRwIv+FjhauG73RaGOfbzxEtiJ6JIaBAPK2uJt+e2IxydqZ9p5yR
         tZzUh/e+RciAeGkUqNXZZolnjhkUyNIQgos5ZilXH9Rk04UxqLHdeYo7hX8yi72uqx
         XpPNMiwvdcHEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/13] net/mlx5: Fix too early queueing of log timestamp work
Date:   Tue, 30 Nov 2021 22:37:07 -0800
Message-Id: <20211201063709.229103-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
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

