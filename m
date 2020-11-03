Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96802A4FED
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgKCTTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15833 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbgKCTTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad2f0001>; Tue, 03 Nov 2020 11:19:11 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Jianbo Liu" <jianbol@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/9] net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported
Date:   Tue, 3 Nov 2020 11:18:27 -0800
Message-ID: <20201103191830.60151-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431151; bh=ttn6I2O3banYWBczNIGmMrna65NGWUvX9UDF3+yRXxI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=dRtogKPzh/lPe6x/C+sym/2VX5ixjcGFv1L4ly/MYdubPQ7TPqyYB7hyG09wp3UXo
         WgNJ4l97010V2XuTg8HJsXE/mUXhkzbBxbQrhYEJWgfR6PGgAWuL5mrlmSuG7T+Ica
         ZhgNnnbhGtfDtZ/TfKPvhTyLZPsFkoMGUWfRtHAHbAhZGRnRlsVY0rn6wxbMC7PHBd
         s1FGpSUoZ+J4uNtMMJPfEm8otHbUmSTvMPiuE+kwQ8sD4asnJ6vsPcZAwrRcxIEUtu
         UBUO0E9BdOGTK9pEp+Kg1KuGR4yP389BXvYQx+dbvn9o38XcPEKJ2OzJo2ynd14asV
         mx4OO+7TcKQsA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

Miss path handling of tc multi chain filters (i.e. filters that are
defined on chain > 0) requires the hardware to communicate to the
driver the last chain that was processed. This is possible only when
the hardware is capable of performing the combination of modify header
and forward to table actions. Currently, if the hardware is missing
this capability then the driver only offloads rules that are defined
on tc chain 0 prio 1. However, this restriction can be relaxed because
packets that miss from chain 0 are processed through all the
priorities by tc software.

Allow the offload of all the supported priorities for chain 0 even
when the hardware is not capable to perform modify header and goto
table actions.

Fixes: 0b3a8b6b5340 ("net/mlx5: E-Switch: Fix using fwd and modify when fir=
mware doesn't support it")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c         | 6 ------
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 ---
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 2e2fa0440032..17d9ba4ac95f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1319,12 +1319,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	int err =3D 0;
 	int out_index;
=20
-	if (!mlx5_chains_prios_supported(esw_chains(esw)) && attr->prio !=3D 1) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "E-switch priorities unsupported, upgrade FW");
-		return -EOPNOTSUPP;
-	}
-
 	/* We check chain range only for tc flows.
 	 * For ft flows, we checked attr->chain was originally 0 and set it to
 	 * FDB_FT_CHAIN which is outside tc range.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 947f346bdc2d..fa61d305990c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -141,9 +141,6 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *=
chains)
=20
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
=20
--=20
2.26.2

