Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6582E2A4FE8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgKCTTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15812 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729601AbgKCTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad2a0000>; Tue, 03 Nov 2020 11:19:06 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net 3/9] net/mlx5e: Use spin_lock_bh for async_icosq_lock
Date:   Tue, 3 Nov 2020 11:18:24 -0800
Message-ID: <20201103191830.60151-4-saeedm@nvidia.com>
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
        t=1604431146; bh=HvkJGvqSTDQgfNa66Tch1FhEJA+qstmQCWDTIJd/ODs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=eCQOwkwyuGe/f+VaO1tkmABo9/URY6FrpjGZ470oUz0O5rHi8YcDjzWPaEkDm3dBj
         i3+X0K09hKxkdse4ay/rZEEFopE7iN+VFhLhcLB4m1Wv0wQGUqi3Wuf0X6oW/i8kQC
         CBCnLCwIJiV8Htku/Pg57ByuvD4ZEHDMTsqflrOepHbsIurxiboG5kZYKBTd0z3S5v
         p0Y/7pL8IYRjtYXLME0xyAX7kmYbUWpQQ1kqi+/hBAhQqZRC2uSYdWWVow9v33VIPA
         GA1smdKEoVwoFYcVYr19WYUmR17Eh+2DRc5wTI55cWFqmRNvgz58j/8z62fYrEQ8x7
         koK1+iZm6Dp/w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

async_icosq_lock may be taken from softirq and non-softirq contexts. It
requires protection with spin_lock_bh, otherwise a softirq may be
triggered in the middle of the critical section, and it may deadlock if
it tries to take the same lock. This patch fixes such a scenario by
using spin_lock_bh to disable softirqs on that CPU while inside the
critical section.

Fixes: 8d94b590f1e4 ("net/mlx5e: Turn XSK ICOSQ into a general asynchronous=
 one")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  4 ++--
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 4e574ac73019..be3465ba38ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -122,9 +122,9 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
=20
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
 	mlx5e_trigger_irq(&c->async_icosq);
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
 }
=20
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index fb671a457129..8e96260fce1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -36,9 +36,9 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32=
 flags)
 		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.stat=
e))
 			return 0;
=20
-		spin_lock(&c->async_icosq_lock);
+		spin_lock_bh(&c->async_icosq_lock);
 		mlx5e_trigger_irq(&c->async_icosq);
-		spin_unlock(&c->async_icosq_lock);
+		spin_unlock_bh(&c->async_icosq_lock);
 	}
=20
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index ccaccb9fc2f7..7f6221b8b1f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -188,7 +188,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
=20
 	err =3D 0;
 	sq =3D &c->async_icosq;
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
=20
 	cseg =3D post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg))
@@ -199,7 +199,7 @@ static int post_rx_param_wqes(struct mlx5e_channel *c,
=20
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
 unlock:
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
=20
 	return err;
=20
@@ -265,10 +265,10 @@ resync_post_get_progress_params(struct mlx5e_icosq *s=
q,
=20
 	BUILD_BUG_ON(MLX5E_KTLS_GET_PROGRESS_WQEBBS !=3D 1);
=20
-	spin_lock(&sq->channel->async_icosq_lock);
+	spin_lock_bh(&sq->channel->async_icosq_lock);
=20
 	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, 1))) {
-		spin_unlock(&sq->channel->async_icosq_lock);
+		spin_unlock_bh(&sq->channel->async_icosq_lock);
 		err =3D -ENOSPC;
 		goto err_dma_unmap;
 	}
@@ -299,7 +299,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 	icosq_fill_wi(sq, pi, &wi);
 	sq->pc++;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
-	spin_unlock(&sq->channel->async_icosq_lock);
+	spin_unlock_bh(&sq->channel->async_icosq_lock);
=20
 	return 0;
=20
@@ -360,7 +360,7 @@ static int resync_handle_seq_match(struct mlx5e_ktls_of=
fload_context_rx *priv_rx
 	err =3D 0;
=20
 	sq =3D &c->async_icosq;
-	spin_lock(&c->async_icosq_lock);
+	spin_lock_bh(&c->async_icosq_lock);
=20
 	cseg =3D post_static_params(sq, priv_rx);
 	if (IS_ERR(cseg)) {
@@ -372,7 +372,7 @@ static int resync_handle_seq_match(struct mlx5e_ktls_of=
fload_context_rx *priv_rx
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
 	priv_rx->stats->tls_resync_res_ok++;
 unlock:
-	spin_unlock(&c->async_icosq_lock);
+	spin_unlock_bh(&c->async_icosq_lock);
=20
 	return err;
 }
--=20
2.26.2

