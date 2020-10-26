Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819D7298BA3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773309AbgJZLTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771082AbgJZLTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE9222265;
        Mon, 26 Oct 2020 11:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711144;
        bh=I3M3alcIz9H62nKqMPZr4skNCtxKtg9JX4DaomofIPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZmwVYsb0PMiAitTOnAk+gQSFVNOxKPj2csjRMtKacaCDngsES89hD6KjGYNNu8r/
         qtV/qagdBdnzSXq4Fpy5jsJ20gp9qMk0bw4HuMrj+MIll3ZGWxW1pEX8rUZhhN7jd/
         TVM+awtVZp95gyCNFzxACE7/VNRI79n6K5+gb69A=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 01/11] net/mlx5: Don't skip vport check
Date:   Mon, 26 Oct 2020 13:18:39 +0200
Message-Id: <20201026111849.1035786-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Users of mlx5_eswitch_get_vport() are required to check return value
prior to passing mlx5_vport further. Fix all the places to do not skip
that check.

Fixes: c7eddc6092b4 ("net/mlx5: E-switch, Move devlink eswitch ports closer to eswitch")
Fixes: 5d9986a3947a ("net/mlx5: E-Switch, Fix the check of legal vport")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index ffff11baa3d0..88688b84513b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -120,5 +120,5 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 	struct mlx5_vport *vport;

 	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	return vport->dl_port;
+	return IS_ERR(vport) ? ERR_CAST(vport) : vport->dl_port;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6e6a9a563992..2e14bf238588 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1142,6 +1142,9 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 	struct mlx5_vport *vport;

 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
 	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);

 	return mlx5_modify_scheduling_element_cmd(esw->dev,
@@ -1276,6 +1279,8 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	int ret;

 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);

 	mutex_lock(&esw->state_lock);
 	WARN_ON(vport->enabled);
@@ -1311,6 +1316,8 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	struct mlx5_vport *vport;

 	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return;

 	mutex_lock(&esw->state_lock);
 	if (!vport->enabled)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c9c2962ad49f..429dc613530b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2159,6 +2159,9 @@ static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	struct mlx5_vport *vport;

 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
 	return esw_vport_create_offloads_acl_tables(esw, vport);
 }

@@ -2167,6 +2170,9 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 	struct mlx5_vport *vport;

 	vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
+	if (IS_ERR(vport))
+		return;
+
 	esw_vport_destroy_offloads_acl_tables(esw, vport);
 }

--
2.26.2

