Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD2A2A4FE7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgKCTTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15808 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbgKCTTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad280001>; Tue, 03 Nov 2020 11:19:04 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Parav Pandit" <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/9] net/mlx5: E-switch, Avoid extack error log for disabled vport
Date:   Tue, 3 Nov 2020 11:18:28 -0800
Message-ID: <20201103191830.60151-8-saeedm@nvidia.com>
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
        t=1604431144; bh=j7LWYgUNBaxUHkIVrP5NdUjX6NIjV8mO/ie4oV5iAeA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=nYE6iHIbK5F+VQk4DE9nKcYTjnTzVOc8t9/0w/ZNL4PLqtcAuelBPh+uluPtdYgsq
         1ZnsAOI4CgYm82WP+xV4tvQoev2R5hVPM14FRIV2z8JM+5zhLgvP0A9to8CPv3o+Is
         K9d/S+qpNO/Ix9e6PN+UPqhT2FsuKasmjjTM0qJ4u/xJxS/Q27kL0Yh87V9Bn9CU6f
         TwYGJ4vgyYbBD6FOkcUIe1UnEmW5ZBxsLkGIuvBiTlEwizyUkN0vka1vjVceAGnxR3
         pweV9GXrEHcqMYwxPGOlVK0bteAYW/NJZrYAusDz0A6KLa62uNQusERWtXWACcEVcW
         wBrdI8dTHhanA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

When E-switch vport is disabled, querying its hardware address is
unsupported.
Avoid setting extack error log message in such case.

Fixes: f099fde16db3 ("net/mlx5: E-switch, Support querying port function ma=
c address")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 6e6a9a563992..e8e6294c7cca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1902,8 +1902,6 @@ int mlx5_devlink_port_function_hw_addr_get(struct dev=
link *devlink,
 		ether_addr_copy(hw_addr, vport->info.mac);
 		*hw_addr_len =3D ETH_ALEN;
 		err =3D 0;
-	} else {
-		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
 	}
 	mutex_unlock(&esw->state_lock);
 	return err;
--=20
2.26.2

