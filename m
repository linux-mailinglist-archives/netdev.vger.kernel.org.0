Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0F38874D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhESGHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238871AbhESGH3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E87613AC;
        Wed, 19 May 2021 06:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404370;
        bh=rG2ScH2XvKwESVu6AjjvASE8N5FxMnSsLrV0sntfJDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bb+kF26uBIPh1m3s9RjfOYteEN5zWHLQbAL/ZkHfydiqwjXKgHjXPMRkBpSyCu916
         ObQnPt0UkMJAgfgp2iM9MPI1WnhURrvuoPI0mERUKafUM+FjfRrW5Yzy8EQEsfb9w2
         bnLzlweNYCcMeJbDNlNYek+8ZIK0W8BuDtq9c8lcIEFoIxK4sy0m4K4Aa2V/0Qb4F+
         TLoPJCopn8Le5BXouYUJM7cq2Z/kGOMAOfZ7RGHZCxTvloT0YPYZJvSH/f0DgiOGRe
         YYCKuTQVUzkeNB/1a/aVMC64zT7QoLWSCh9kaYQXSl44bj9fJ25CgAgeELG0NZO949
         Y/4Hzu1sLV/fw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/16] net/mlx5e: Reject mirroring on source port change encap rules
Date:   Tue, 18 May 2021 23:05:18 -0700
Message-Id: <20210519060523.17875-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Rules with MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE dest flag are
translated to destination FT in eswitch. Currently it is not possible to
mirror such rules because firmware doesn't support mixing FT and Vport
destinations in single rule when one of them adds encapsulation. Since the
only use case for MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE destination is
support for tunnel endpoints on VF and trying to offload such rule with
mirror action causes either crash in fs_core or firmware error with
syndrome 0xff6a1d, reject all such rules in mlx5 TC layer.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 882bafba43f2..bccdb43a880b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1399,6 +1399,12 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->dests[out_index].mdev = out_priv->mdev;
 	}
 
+	if (vf_tun && esw_attr->out_count > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
+		err = -EOPNOTSUPP;
+		goto err_out;
+	}
+
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
 	if (err)
 		goto err_out;
-- 
2.31.1

