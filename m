Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8141E4BA
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350174AbhI3XW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349685AbhI3XWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C243661262;
        Thu, 30 Sep 2021 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044060;
        bh=2P4kGJVb9/cD7/W35mw7j5ekagVgcLS8PRCbASglQXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjUtCZOoOyAGQhdLyUaLbmFb75XufTRKVBIjM5LEX0wfiZg+FCF+1FbdtzyijBJDU
         WMqtzUTOnsEfCluDQoGFxQpWK3szsILMaVDr31hg4rk/dAxi/ZjtBadotXRTCC47uy
         uXAaP3ajpwPtpseQmeg7M3KIGLvZFh/++3p7A7nv8Zgy4rtNotXcWzCfr3s7J8txcY
         Pw8lsCg1ZkGZPu5xLdq8uXTZMiig0TNqLafE3uupl78kOnm7+Q8cQwOLsB6UaYg1Tj
         9c+gIYoFv4gtKvwwcGIL7hKrszclyNt5sJJ69Inb/LSSWucbE0pWucGX0YEt545E5H
         LYtyjlkN+GLTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Tolerate failures in debug features while driver load
Date:   Thu, 30 Sep 2021 16:20:47 -0700
Message-Id: <20210930232050.41779-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

FW tracer and resource dump are debug features. Although failing to
initialize them may indicate an error, don't let this stop device
loading.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 92b08fa07efa..5893fdd5aedb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1112,8 +1112,9 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	err = mlx5_fw_tracer_init(dev->tracer);
 	if (err) {
-		mlx5_core_err(dev, "Failed to init FW tracer\n");
-		goto err_fw_tracer;
+		mlx5_core_err(dev, "Failed to init FW tracer %d\n", err);
+		mlx5_fw_tracer_destroy(dev->tracer);
+		dev->tracer = NULL;
 	}
 
 	mlx5_fw_reset_events_start(dev);
@@ -1121,8 +1122,9 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	err = mlx5_rsc_dump_init(dev);
 	if (err) {
-		mlx5_core_err(dev, "Failed to init Resource dump\n");
-		goto err_rsc_dump;
+		mlx5_core_err(dev, "Failed to init Resource dump %d\n", err);
+		mlx5_rsc_dump_destroy(dev);
+		dev->rsc_dump = NULL;
 	}
 
 	err = mlx5_fpga_device_start(dev);
@@ -1192,11 +1194,9 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	mlx5_fpga_device_stop(dev);
 err_fpga_start:
 	mlx5_rsc_dump_cleanup(dev);
-err_rsc_dump:
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
 	mlx5_fw_reset_events_stop(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
-err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
 err_eq_table:
 	mlx5_irq_table_destroy(dev);
-- 
2.31.1

