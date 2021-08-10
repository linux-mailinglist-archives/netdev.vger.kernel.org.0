Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5E53E51B3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhHJEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhHJEAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076236105A;
        Tue, 10 Aug 2021 03:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567986;
        bh=nvec1VkwFajkVSAfo8vrhwi/e1N3ORPhIZ1KaqKuLkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MK/8ui+JbUqKYt7fXYu6M7POabhYy4D02wNZT8RUIR5WMfR/wrXE0QkhnZGR2Ja9P
         jBv9YlpV6av21WmKyn8wHuba27vaE4SdzVqggaeRswQECPEvYZ4Ovd/729xgrlriy8
         Dz8SQWvjUby4eQJZKjNpnLQ8oqOOLwKrcNMhdSLuKBDA2drAduFRfnhxBXO1KPjQi8
         ZZvNOACrf2SezqvhIBpVKOtH3x1op+yL6Gs6HPzuvyqUJ+HR6gV0yfg4kfU0Mynlte
         OInfYBntH83EHqVejil7e7I/kmNxXxn0jyC6QsyKQ8CosVAFKc9C6Fac0Fz6P9h7Jp
         mm3x10Cch7vQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/12] net/mlx5: Fix return value from tracer initialization
Date:   Mon,  9 Aug 2021 20:59:23 -0700
Message-Id: <20210810035923.345745-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Check return value of mlx5_fw_tracer_start(), set error path and fix
return value of mlx5_fw_tracer_init() accordingly.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 01a1d02dcf15..3f8a98093f8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1019,12 +1019,19 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	MLX5_NB_INIT(&tracer->nb, fw_tracer_event, DEVICE_TRACER);
 	mlx5_eq_notifier_register(dev, &tracer->nb);
 
-	mlx5_fw_tracer_start(tracer);
-
+	err = mlx5_fw_tracer_start(tracer);
+	if (err) {
+		mlx5_core_warn(dev, "FWTracer: Failed to start tracer %d\n", err);
+		goto err_notifier_unregister;
+	}
 	return 0;
 
+err_notifier_unregister:
+	mlx5_eq_notifier_unregister(dev, &tracer->nb);
+	mlx5_core_destroy_mkey(dev, &tracer->buff.mkey);
 err_dealloc_pd:
 	mlx5_core_dealloc_pd(dev, tracer->buff.pdn);
+	cancel_work_sync(&tracer->read_fw_strings_work);
 	return err;
 }
 
-- 
2.31.1

