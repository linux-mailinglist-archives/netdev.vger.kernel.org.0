Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A452A4FF0
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgKCTTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4565 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729652AbgKCTTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad380001>; Tue, 03 Nov 2020 11:19:20 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:06 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net 9/9] net/mlx5e: Fix incorrect access of RCU-protected xdp_prog
Date:   Tue, 3 Nov 2020 11:18:30 -0800
Message-ID: <20201103191830.60151-10-saeedm@nvidia.com>
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
        t=1604431160; bh=Me4k3oBtLi1R1bUzXFhth6SnIPa/YVgeeB1Nn0ImP/A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jtsGutuSViqt/TjVdJiuCGlI2kp5oqv0Md4qGYPpsrTuauvUvj1mCPEKO3l+as4tF
         PghbFhofYYb8sf/zzVv+SRUIT4In8MabwEunYTrWTcUNBLlcMC2ICJ28isaClveNj6
         Cg77ZkmnQx0RRKtl2qQYxSls8QNlRX2bCw2ySdebtZKEHzVVH1PYcJDVZW0BVMBd5j
         M8z7x8o82Uc1waP8J2FksDGXBxWiXfz95qEEFuGTO8R5vojGw7sJgHnIYY0DtV71Cp
         mbmtkgyHjuAI1ZI7PIc0oLxvJ6V4O55bpNi64BQDL84BjirX6Y6UOAUg5dDAMgMn3a
         c2jLQ3kg5RpVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

rq->xdp_prog is RCU-protected and should be accessed only with
rcu_access_pointer for the NULL check in mlx5e_poll_rx_cq.

rq->xdp_prog may change on the fly only from one non-NULL value to
another non-NULL value, so the checks in mlx5e_xdp_handle and
mlx5e_poll_rx_cq will have the same result during one NAPI cycle,
meaning that no additional synchronization is needed.

Fixes: fe45386a2082 ("net/mlx5e: Use RCU to protect rq->xdp_prog")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 599f5b5ebc97..6628a0197b4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1584,7 +1584,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	} while ((++work_done < budget) && (cqe =3D mlx5_cqwq_get_cqe(cqwq)));
=20
 out:
-	if (rq->xdp_prog)
+	if (rcu_access_pointer(rq->xdp_prog))
 		mlx5e_xdp_rx_poll_complete(rq);
=20
 	mlx5_cqwq_update_db_record(cqwq);
--=20
2.26.2

