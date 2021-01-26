Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268DC3050DC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbhA0E3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8454 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389820AbhA0AJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a97e0004>; Tue, 26 Jan 2021 15:45:02 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/12] net/mlx5: Fix memory leak on flow table creation error flow
Date:   Tue, 26 Jan 2021 15:43:34 -0800
Message-ID: <20210126234345.202096-2-saeedm@nvidia.com>
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
        t=1611704702; bh=OEjctEMOspF1/CB6O7DIHFR8ilRYGHk4IGBIO/gXQI0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hIoqgk0jYDlIqXDy2zr9Eoe4Lx2Zo3DtgUqqCgy5xVFr+qMhs/ueoVAF4z1XaLDpY
         VcfdamU/vUlFD75nR0RU/ef5TRiimGt52vkgRE/xFIjBdcDFLHz39DE1cNNsndYRxZ
         hL4gtztG2pW8cyYZykc6TdLoGwZt2kf597ZRqwqp1FJlEskxMAeeFgvfzQTJUIqb8Y
         j068fBQKONPJ2dUMFDlN3D20NNIi+Jl4fOpAlLT158J/RqWKKfr0AEW1ynQTTXBWl1
         d4CszQ9XFSB5HU4la4Rt9rLyzbNb2lLpZTVoWwxx99NbPYGUikn6+nb0jQGIIDhf/9
         iOZfYSsvIUhDw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When we create the ft object we also init rhltable in ft->fgs_hash.
So in error flow before kfree of ft we need to destroy that rhltable.

Fixes: 693c6883bbc4 ("net/mlx5: Add hash table for flow groups in flow tabl=
e")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index b899539a0786..0fcee702b808 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1141,6 +1141,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_tab=
le(struct mlx5_flow_namespa
 destroy_ft:
 	root->cmds->destroy_flow_table(root, ft);
 free_ft:
+	rhltable_destroy(&ft->fgs_hash);
 	kfree(ft);
 unlock_root:
 	mutex_unlock(&root->chain_lock);
--=20
2.29.2

