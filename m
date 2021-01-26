Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA03B3050DB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbhA0E3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11315 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389813AbhA0AJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9810002>; Tue, 26 Jan 2021 15:45:05 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Raed Salem" <raeds@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/12] net/mlx5e: Fix IPSEC stats
Date:   Tue, 26 Jan 2021 15:43:38 -0800
Message-ID: <20210126234345.202096-6-saeedm@nvidia.com>
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
        t=1611704705; bh=Z9Xpc1J4ryqqu/SXJiDjjqBpezlpyX3zvNfdq3uAXsU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=avZhxLggzHGg1RvfGzuVvLSmL+AatnrgG8XURQi9RzS4SlMNYtGIEpIWP84RbR8WY
         U3Wbs9qsTiDoUgaNWMgj28HGcH/5jMdHBOH8cR2+qAkfUGVfbBWtDgvTl8aQkVlVAN
         t20vyafV8AVz6n7I8uLh6mWhcdCzk6ah0nBhl+pkEVfA7C5A/CW5UzDcu0Y9ow+0Df
         rJF4cdQ4A98PjZRcMbNhexi5fV0Wsi9if0bbTx3zKVHnGrj/Iw8knXbRF/riEYhze5
         T7A2cHOYoL6bq3IT3PtSxlfiDs0ZyUdZeKCeVtlF0pSxYRzOAjSKd0iXZkEZHFLEih
         5tfAv/ZGQYzFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When IPSEC offload isn't active, the number of stats is not zero, but
the strings are not filled, leading to exposing stats with empty names.
Fix this by using the same condition for NUM_STATS and FILL_STRS.

Fixes: 0aab3e1b04ae ("net/mlx5e: IPSec, Expose IPsec HW stat only for suppo=
rting HW")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 6c5c54bcd9be..5cb936541b9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -76,7 +76,7 @@ static const struct counter_desc mlx5e_ipsec_sw_stats_des=
c[] =3D {
=20
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_sw)
 {
-	return NUM_IPSEC_SW_COUNTERS;
+	return priv->ipsec ? NUM_IPSEC_SW_COUNTERS : 0;
 }
=20
 static inline MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_sw) {}
@@ -105,7 +105,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_sw)
=20
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_hw)
 {
-	return (mlx5_fpga_ipsec_device_caps(priv->mdev)) ? NUM_IPSEC_HW_COUNTERS =
: 0;
+	return (priv->ipsec && mlx5_fpga_ipsec_device_caps(priv->mdev)) ? NUM_IPS=
EC_HW_COUNTERS : 0;
 }
=20
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_hw)
--=20
2.29.2

