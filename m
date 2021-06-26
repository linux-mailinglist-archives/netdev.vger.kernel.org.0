Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F6A3B4D7F
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFZHrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFZHrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:47:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD6261920;
        Sat, 26 Jun 2021 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693514;
        bh=hE151Rwvxv8fyh2RIoTD8BLb6s5GnQKgrDyzp83j4co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrJgM7VeO+apDWOFnICgMQG6g3yqm/j0lPAKpq6k+i0f+M4Gw1tNjzT10e738xlgs
         d4sp5yPLEHbpKBF8R40kRq5SPn5SQqg1i7DikBCIVcATxU5Oj3slmF8qpBStRzYoDV
         hTtlNM4xNzRuO0nuCCCEB8UWyLR69Vynwbd8EVm/7ibri4vWe4eHkYoPW7AFJ/j8CN
         H1835bjRN4+jdeuHmCSqq7twlqnvPubSCmVhxE2s+ALINA5dt+UObg2OyK2u/bKwvp
         xHg/sY6Whdp126PZEeQt2t5vYTXAc5+tl0IuYGFdohu9jvlmK5efzN2zgNdc0Vf3KD
         wK6+fMfc0pAIA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 6/6] net/mlx5e: Add IPsec support to uplink representor
Date:   Sat, 26 Jun 2021 00:44:17 -0700
Message-Id: <20210626074417.714833-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Add the xfrm xdo and ipsec_init/cleanup to uplink representor to
support IPsec in SRIOV switchdev mode.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c         | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 26f7fab109d9..7cab08a2f715 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -428,7 +428,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	spin_lock_init(&ipsec->sadb_rx_lock);
 	ida_init(&ipsec->halloc);
 	ipsec->en_priv = priv;
-	ipsec->en_priv->ipsec = ipsec;
 	ipsec->no_trailer = !!(mlx5_accel_ipsec_device_caps(priv->mdev) &
 			       MLX5_ACCEL_IPSEC_CAP_RX_NO_TRAILER);
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
@@ -438,6 +437,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 		return -ENOMEM;
 	}
 
+	priv->ipsec = ipsec;
 	mlx5e_accel_ipsec_fs_init(priv);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2d2cc5f3b03f..bf94bcb6fa5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -51,6 +51,7 @@
 #include "lib/mlx5.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
+#include "en_accel/ipsec.h"
 
 #define MLX5E_REP_PARAMS_DEF_LOG_SQ_SIZE \
 	max(0x7, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE)
@@ -630,6 +631,11 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 			     struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	int err;
+
+	err = mlx5e_ipsec_init(priv);
+	if (err)
+		mlx5_core_err(mdev, "Uplink rep IPsec initialization failed, %d\n", err);
 
 	mlx5e_vxlan_set_netdev_info(priv);
 	return mlx5e_init_rep(mdev, netdev);
@@ -637,6 +643,7 @@ static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
 
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
+	mlx5e_ipsec_cleanup(priv);
 }
 
 static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
-- 
2.31.1

