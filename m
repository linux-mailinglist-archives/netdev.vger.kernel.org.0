Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979493050DD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238845AbhA0E3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5320 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389823AbhA0AJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9850003>; Tue, 26 Jan 2021 15:45:09 -0800
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
Subject: [net 10/12] net/mlx5e: Revert parameters on errors when changing trust state without reset
Date:   Tue, 26 Jan 2021 15:43:43 -0800
Message-ID: <20210126234345.202096-11-saeedm@nvidia.com>
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
        t=1611704709; bh=YOer8oSlxx57rwgQ46zOujK87u81afpYpBHc/ScCcsA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZoIpUCwSdRs+a7s7T4tVgKnDofVJ3UptouYzoML9H9b978Z2E6qeV4MUFDXIoHlrT
         +YHmEUz4fyCjIGtPaExgfs0ZGWDnHPLm5Y6SzL4kCbUL4y7Io264IGBuO63J2u/dK0
         ffFnDmSU5IX6Yo030aAmkAqv1vVVxBrq5JBMbHx+J2fF716lcN8Iw/+aSMTSStZpAD
         6Z5o+zTJzYXQKP5++SoWey672YlZNhdYR6ioxuxGfl1OR3GZpR5mintq8hNJQiSI0v
         JFdna6N4E/CYo/wxhMqTkYcImOeaQP0KSifbttww+Gj4DPumcff79bK0h+egVQUbk3
         KrYnqn09g8prg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Trust state may be changed without recreating the channels. It happens
when the channels are closed, and when channel parameters (min inline
mode) stay the same after changing the trust state. Changing the trust
state is a hardware command that may fail. The current code didn't
restore the channel parameters to their old values if an error happened
and the channels were closed. This commit adds handling for this case.

Fixes: 6e0504c69811 ("net/mlx5e: Change inline mode correctly when changing=
 trust state")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_dcbnl.c
index d20243d6a032..f23c67575073 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -1151,6 +1151,7 @@ static int mlx5e_set_trust_state(struct mlx5e_priv *p=
riv, u8 trust_state)
 {
 	struct mlx5e_channels new_channels =3D {};
 	bool reset_channels =3D true;
+	bool opened;
 	int err =3D 0;
=20
 	mutex_lock(&priv->state_lock);
@@ -1159,22 +1160,24 @@ static int mlx5e_set_trust_state(struct mlx5e_priv =
*priv, u8 trust_state)
 	mlx5e_params_calc_trust_tx_min_inline_mode(priv->mdev, &new_channels.para=
ms,
 						   trust_state);
=20
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		priv->channels.params =3D new_channels.params;
+	opened =3D test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (!opened)
 		reset_channels =3D false;
-	}
=20
 	/* Skip if tx_min_inline is the same */
 	if (new_channels.params.tx_min_inline_mode =3D=3D
 	    priv->channels.params.tx_min_inline_mode)
 		reset_channels =3D false;
=20
-	if (reset_channels)
+	if (reset_channels) {
 		err =3D mlx5e_safe_switch_channels(priv, &new_channels,
 						 mlx5e_update_trust_state_hw,
 						 &trust_state);
-	else
+	} else {
 		err =3D mlx5e_update_trust_state_hw(priv, &trust_state);
+		if (!err && !opened)
+			priv->channels.params =3D new_channels.params;
+	}
=20
 	mutex_unlock(&priv->state_lock);
=20
--=20
2.29.2

