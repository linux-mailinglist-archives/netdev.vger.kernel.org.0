Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 843CC6DF65
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 06:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfGSEec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 00:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729693AbfGSEBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 00:01:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D5A321851;
        Fri, 19 Jul 2019 04:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508912;
        bh=+hCM6REWCGyOM6ATFUsntBdajWBPV6AdXDvS2mwE8Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzWYcQuMN9EAw0u2vd5/2Q+4CK1ltGJPIP/ygvB+bUP4cS38CHYs0xHZa3UzNPY5O
         GSqqkvR9NRCzYGPKYvqmFrMz4OzZD1/zF0YCUOlENOw8xzOBLY51cDvPPQpYk6/tYH
         A/nO+OMQjzuiiUYOXPD9q+zxuJzw6NmeliD7AY0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maor Gottlieb <maorg@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 155/171] net/mlx5: E-Switch, Fix default encap mode
Date:   Thu, 18 Jul 2019 23:56:26 -0400
Message-Id: <20190719035643.14300-155-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 9a64144d683a4395f57562d90247c61a0bf5105f ]

Encap mode is related to switchdev mode only. Move the init of
the encap mode to eswitch_offloads. Before this change, we reported
that eswitch supports encap, even tough the device was in non
SRIOV mode.

Fixes: 7768d1971de67 ('net/mlx5: E-Switch, Add control for encapsulation')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 5 -----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6a921e24cd5e..e9339e7d6a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1882,11 +1882,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->enabled_vports = 0;
 	esw->mode = SRIOV_NONE;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
-	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
-	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
-	else
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 
 	dev->priv.eswitch = esw;
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 47b446d30f71..c2beadc41c40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1840,6 +1840,12 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int vf_nvports,
 {
 	int err;
 
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
+	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
+	else
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+
 	err = esw_offloads_steering_init(esw, vf_nvports, total_nvports);
 	if (err)
 		return err;
@@ -1901,6 +1907,7 @@ void esw_offloads_cleanup(struct mlx5_eswitch *esw)
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw, num_vfs);
 	esw_offloads_steering_cleanup(esw);
+	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 
 static int esw_mode_from_devlink(u16 mode, u16 *mlx5_mode)
-- 
2.20.1

