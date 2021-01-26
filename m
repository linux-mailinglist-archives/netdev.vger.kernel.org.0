Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC533054C7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhA0Hgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:36:52 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7588 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317436AbhA0AA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:00:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9840002>; Tue, 26 Jan 2021 15:45:08 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:08 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/12] net/mlx5e: Correctly handle changing the number of queues when the interface is down
Date:   Tue, 26 Jan 2021 15:43:42 -0800
Message-ID: <20210126234345.202096-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704708; bh=c0lkCEjOLopgMfEvBeluGWI+RLW5kbfck2gi0J2ijy8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=mYvM7/rtlhPxdcmi66yV85mmOSaFFUhEHJ7b9TwLT5NNyAT0Gs3XppHgq1I6v7rCP
         On9jAF+bykyKb1k8fSkKuNM8Igyxjr+TWCw4KRks387WPHWlEm74kJ7SGFSHwoo9cn
         BGn2g3I58fPVwwNw3+qCmEKIZ5iHNvVv1IBH2iztjkVTyPLU5UpJgX8cj/xsNS0mfj
         hkIB0SA32VyXZkmB4RvscdZ3Nja4h67mCxowpuig57BbZSivuBKgikp30yrKc0TUaX
         /uBGRZ/nAEWDrPWl8v5OVmAOtdf8cuB9CKETuK1vI1mDZw2AtNVq+o59FT4ELI0qYt
         X2x5rKszUKzAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit addresses two issues related to changing the number of
queues when the channels are closed:

1. Missing call to mlx5e_num_channels_changed to update
real_num_tx_queues when the number of TCs is changed.

2. When mlx5e_num_channels_changed returns an error, the channel
parameters must be reverted.

Two Fixes: tags correspond to the first commits where these two issues
were introduced.

Fixes: 3909a12e7913 ("net/mlx5e: Fix configuration of XPS cpumasks and netd=
ev queues in corner cases")
Fixes: fa3748775b92 ("net/mlx5e: Handle errors from netif_set_real_num_{tx,=
rx}_queues")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 7 +++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2d37742a888c..302001d6661e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -447,12 +447,18 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *pri=
v,
 		goto out;
 	}
=20
-	new_channels.params =3D priv->channels.params;
+	new_channels.params =3D *cur_params;
 	new_channels.params.num_channels =3D count;
=20
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params =3D *cur_params;
 		*cur_params =3D new_channels.params;
 		err =3D mlx5e_num_channels_changed(priv);
+		if (err)
+			*cur_params =3D old_params;
+
 		goto out;
 	}
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 300e0e9f96b6..ac76d32bad7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3614,7 +3614,14 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *=
priv,
 	new_channels.params.num_tc =3D tc ? tc : 1;
=20
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
+		struct mlx5e_params old_params;
+
+		old_params =3D priv->channels.params;
 		priv->channels.params =3D new_channels.params;
+		err =3D mlx5e_num_channels_changed(priv);
+		if (err)
+			priv->channels.params =3D old_params;
+
 		goto out;
 	}
=20
--=20
2.29.2

