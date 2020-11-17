Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123412B6FA1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbgKQUHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5778 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731593AbgKQUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d850001>; Tue, 17 Nov 2020 12:07:33 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:42 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/9] net/mlx5: Disable QoS when min_rates on all VFs are zero
Date:   Tue, 17 Nov 2020 11:57:00 -0800
Message-ID: <20201117195702.386113-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643653; bh=FTafn31vGPZm0S+4M4uI8jmTSqQSaVldC7RqaAe+Hug=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Type:Content-Transfer-Encoding:
         X-Originating-IP:X-ClientProxiedBy;
        b=TIF6jfwqkjjYTvE0RgmPTFjmf/gJwZ33cesTtd8Ia3HcWO4yI/ORVDtE7rpcU+enV
         GI+COsr+U0RNwz0LY/YGInkNq1DJmn9nBJpmXS8oyBg/jFEGd1mUt2sU+rdkOLox7h
         viGbZAt9iJOZcoiPqxnFuHE2Dwc2FJcFA9YvL5ge4ABSz2ykNGpDRNn8/VoqBiniHr
         eoFOoFzzyniC0tntCbemLgkZ4B2a66zmd3WNEasR4NuiJgcx7BieFDu1/AymxvlYkb
         1YKP0dSL6Oxm5/FdfdvvJFVTFeOyp8aMTClvHIKIak7qTnfmAiKUZij2BKttVmQK3v
         DlJUEKIpoe8Cg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Currently when QoS is enabled for VF and any min_rate is configured,
the driver sets bw_share value to at least 1 and doesn=E2=80=99t allow to s=
et
it to 0 to make minimal rate unlimited. It means there is always a
minimal rate configured for every VF, even if user tries to remove it.

In order to make QoS disable possible, check whether all vports have
configured min_rate =3D 0. If this is true, set their bw_share to 0 to
disable min_rate limitations.

Fixes: c9497c98901c ("net/mlx5: Add support for setting VF min rate")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 6562f4d484e6..5ad2308a2a6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2222,12 +2222,15 @@ static u32 calculate_vports_min_rate_divider(struct=
 mlx5_eswitch *esw)
 		max_guarantee =3D evport->info.min_rate;
 	}
=20
-	return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+	if (max_guarantee)
+		return max_t(u32, max_guarantee / fw_max_bw_share, 1);
+	return 0;
 }
=20
-static int normalize_vports_min_rate(struct mlx5_eswitch *esw, u32 divider=
)
+static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 {
 	u32 fw_max_bw_share =3D MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
+	u32 divider =3D calculate_vports_min_rate_divider(esw);
 	struct mlx5_vport *evport;
 	u32 vport_max_rate;
 	u32 vport_min_rate;
@@ -2240,9 +2243,9 @@ static int normalize_vports_min_rate(struct mlx5_eswi=
tch *esw, u32 divider)
 			continue;
 		vport_min_rate =3D evport->info.min_rate;
 		vport_max_rate =3D evport->info.max_rate;
-		bw_share =3D MLX5_MIN_BW_SHARE;
+		bw_share =3D 0;
=20
-		if (vport_min_rate)
+		if (divider)
 			bw_share =3D MLX5_RATE_TO_BW_SHARE(vport_min_rate,
 							 divider,
 							 fw_max_bw_share);
@@ -2267,7 +2270,6 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *=
esw, u16 vport,
 	struct mlx5_vport *evport =3D mlx5_eswitch_get_vport(esw, vport);
 	u32 fw_max_bw_share;
 	u32 previous_min_rate;
-	u32 divider;
 	bool min_rate_supported;
 	bool max_rate_supported;
 	int err =3D 0;
@@ -2292,8 +2294,7 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *=
esw, u16 vport,
=20
 	previous_min_rate =3D evport->info.min_rate;
 	evport->info.min_rate =3D min_rate;
-	divider =3D calculate_vports_min_rate_divider(esw);
-	err =3D normalize_vports_min_rate(esw, divider);
+	err =3D normalize_vports_min_rate(esw);
 	if (err) {
 		evport->info.min_rate =3D previous_min_rate;
 		goto unlock;
--=20
2.26.2

