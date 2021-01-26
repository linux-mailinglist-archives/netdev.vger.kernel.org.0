Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141BA3050DE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhA0E31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8559 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389849AbhA0AK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:10:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a97f0000>; Tue, 26 Jan 2021 15:45:03 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/12] net/mlx5e: E-switch, Fix rate calculation for overflow
Date:   Tue, 26 Jan 2021 15:43:35 -0800
Message-ID: <20210126234345.202096-3-saeedm@nvidia.com>
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
        t=1611704703; bh=achVT2JcHwQLOd03GYb7JlkKk1FD3N1yavZxHsCtSFc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lOrpY5rqzWROcu+URva/I4niDmn8ZHhbkFnvGiMEsn2FrwB2SeYWQSnz2gsG4CmUq
         dPTOGHf1/xaik/Bbjt8Gk0JjbM1e2GdaaL303hTXluIyMUS7a2WcLqPfNEeZ7sGTOc
         CYLr0+a/IIEZo2KS+eYGIVa8k6LJipQ0Yk6gnF33cPSbyHOt4e0dwHCuH2HCdhSTW0
         8/53bw8nQZYFS9yg0B5bdWMbJNCh2b5Soexit7jR2xUYSD8TVuSbMhajRpaIpeDm/m
         ZVhU0pSvAEPejKXkr6O4vurmfGCBc82uRHw7ONUz6fGzcBw6C8l8cb7kAtM7yfe7kE
         2I7ZYWLYhItQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

rate_bytes_ps is a 64-bit field. It passed as 32-bit field to
apply_police_params(). Due to this when police rate is higher
than 4Gbps, 32-bit calculation ignores the carry. This results
in incorrect rate configurationn the device.

Fix it by performing 64-bit calculation.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 4cdf834fa74a..661235027b47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -67,6 +67,7 @@
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
+#include <asm/div64.h>
=20
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
@@ -5007,13 +5008,13 @@ int mlx5e_stats_flower(struct net_device *dev, stru=
ct mlx5e_priv *priv,
 	return err;
 }
=20
-static int apply_police_params(struct mlx5e_priv *priv, u32 rate,
+static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	struct mlx5_eswitch *esw;
+	u32 rate_mbps =3D 0;
 	u16 vport_num;
-	u32 rate_mbps;
 	int err;
=20
 	vport_num =3D rpriv->rep->vport;
@@ -5030,7 +5031,11 @@ static int apply_police_params(struct mlx5e_priv *pr=
iv, u32 rate,
 	 * Moreover, if rate is non zero we choose to configure to a minimum of
 	 * 1 mbit/sec.
 	 */
-	rate_mbps =3D rate ? max_t(u32, (rate * 8 + 500000) / 1000000, 1) : 0;
+	if (rate) {
+		rate =3D (rate * BITS_PER_BYTE) + 500000;
+		rate_mbps =3D max_t(u32, do_div(rate, 1000000), 1);
+	}
+
 	err =3D mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "failed applying action to hardware");
--=20
2.29.2

