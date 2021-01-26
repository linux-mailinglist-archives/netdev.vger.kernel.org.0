Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391733050DA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhA0E3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5319 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389808AbhA0AJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9800000>; Tue, 26 Jan 2021 15:45:04 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Pan Bian <bianpan2016@163.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/12] net/mlx5e: free page before return
Date:   Tue, 26 Jan 2021 15:43:36 -0800
Message-ID: <20210126234345.202096-4-saeedm@nvidia.com>
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
        t=1611704704; bh=52Wt/haiOVdVZVlHDBBITKgpkaBKfvsltefgrNvEml4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Hbg2wiFLTe59xDmpJ8YIa5tJfFUwPK8HjtddCEYfM6kylDHBlX/jTOhIuJb2CEmOK
         yCLJ8hY3LkMc62XAKU1IO0gRX0xDZAnP+D6WFVGFhpIKAmm4ZBZzM4zVelFKTUMN5q
         +e4VeQ5HrSl0GDEIqYl5uMJsx0DlY+MgFiNu2+Tdszn5xwnhmmCUN6cGC90ZvrIAsh
         CTB8LGPDwURB5cab3OluC8+6zwnakeTqvcd6piAeha5EEf5wzHoqMfOoPC3Pwg1lnb
         2GfLQFRIn5xhmA2vu1GX5+O626g3yIR3+xH4lZgItELyCcGKu7mUbsNCK0nmrQRcie
         cfjUQvLcYES0w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

Instead of directly return, goto the error handling label to free
allocated page.

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 718f8c0a4f6b..84e501e057b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -273,7 +273,7 @@ int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv,=
 struct mlx5_rsc_key *key
=20
 	err =3D devlink_fmsg_binary_pair_nest_start(fmsg, "data");
 	if (err)
-		return err;
+		goto free_page;
=20
 	cmd =3D mlx5_rsc_dump_cmd_create(mdev, key);
 	if (IS_ERR(cmd)) {
--=20
2.29.2

