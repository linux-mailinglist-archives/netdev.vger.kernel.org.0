Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284C92A5061
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgKCTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18841 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbgKCTsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b4020001>; Tue, 03 Nov 2020 11:48:18 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:17 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/12] net: mlx5: Replace in_irq() usage
Date:   Tue, 3 Nov 2020 11:47:38 -0800
Message-ID: <20201103194738.64061-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432898; bh=tYBWU2IyxwrCdASESpmKvCDGl/9PVUjCt8yXH4B3SZA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ah6bB22hiwNKxHhqgEo1EW8eH9Asz2GMRThEcpt835/tn3gbUqAiiS894W0qA1X8C
         SKTErgqgP6PgPQWFfy3kyVmqyLgdozF6UKP3ljQdovxu71HuoVWjbuLJ8qXrbfza8g
         6p/fYhfqdnfRZk07aSf4/ycbpLIwGIp+EmKwQTHliml7fx5yjIBSZdGl2ZoREvVBtV
         vbjl7hv22AgG7cC6+k7zOCtOgNGfmcRu5OnOV/jcxdDEwWK2RPKNk+rOysBdhpVUYz
         Eucfb1txXH6Xyf/lMpJ5lMMWlg/Eg44E4FFH/99lxxoGDQHr/2NHL8FGEYV/5E3C/R
         PoQiNl9B9NM1A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

mlx5_eq_async_int() uses in_irq() to decide whether eq::lock needs to be
acquired and released with spin_[un]lock() or the irq saving/restoring
variants.

The usage of in_*() in drivers is phased out and Linus clearly requested
that code which changes behaviour depending on context should either be
seperated or the context be conveyed in an argument passed by the caller,
which usually knows the context.

mlx5_eq_async_int() knows the context via the action argument already so
using it for the lock variant decision is a straight forward replacement
for in_irq().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 8ebfe782f95e..4ea5d6ddf56a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -189,19 +189,21 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq=
)
 	return count_eqe;
 }
=20
-static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, unsigned long=
 *flags)
+static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, bool recovery=
,
+				   unsigned long *flags)
 	__acquires(&eq->lock)
 {
-	if (in_irq())
+	if (!recovery)
 		spin_lock(&eq->lock);
 	else
 		spin_lock_irqsave(&eq->lock, *flags);
 }
=20
-static void mlx5_eq_async_int_unlock(struct mlx5_eq_async *eq, unsigned lo=
ng *flags)
+static void mlx5_eq_async_int_unlock(struct mlx5_eq_async *eq, bool recove=
ry,
+				     unsigned long *flags)
 	__releases(&eq->lock)
 {
-	if (in_irq())
+	if (!recovery)
 		spin_unlock(&eq->lock);
 	else
 		spin_unlock_irqrestore(&eq->lock, *flags);
@@ -223,11 +225,13 @@ static int mlx5_eq_async_int(struct notifier_block *n=
b,
 	struct mlx5_eqe *eqe;
 	unsigned long flags;
 	int num_eqes =3D 0;
+	bool recovery;
=20
 	dev =3D eq->dev;
 	eqt =3D dev->priv.eq_table;
=20
-	mlx5_eq_async_int_lock(eq_async, &flags);
+	recovery =3D action =3D=3D ASYNC_EQ_RECOVER;
+	mlx5_eq_async_int_lock(eq_async, recovery, &flags);
=20
 	eqe =3D next_eqe_sw(eq);
 	if (!eqe)
@@ -249,9 +253,9 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
=20
 out:
 	eq_update_ci(eq, 1);
-	mlx5_eq_async_int_unlock(eq_async, &flags);
+	mlx5_eq_async_int_unlock(eq_async, recovery, &flags);
=20
-	return unlikely(action =3D=3D ASYNC_EQ_RECOVER) ? num_eqes : 0;
+	return unlikely(recovery) ? num_eqes : 0;
 }
=20
 void mlx5_cmd_eq_recover(struct mlx5_core_dev *dev)
--=20
2.26.2

