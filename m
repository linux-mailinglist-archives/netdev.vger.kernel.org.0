Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9262A87F6
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgKEUWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:22:16 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19757 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732511AbgKEUWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:22:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45ef90000>; Thu, 05 Nov 2020 12:22:17 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:22:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Parav Pandit" <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net v2 5/7] net/mlx5: E-switch, Avoid extack error log for disabled vport
Date:   Thu, 5 Nov 2020 12:21:27 -0800
Message-ID: <20201105202129.23644-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105202129.23644-1-saeedm@nvidia.com>
References: <20201105202129.23644-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607737; bh=j7LWYgUNBaxUHkIVrP5NdUjX6NIjV8mO/ie4oV5iAeA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=aRhx4RgsHCqYt5rYyv8P6WB64bIBAA4QSlvk1trWsFVRmCLh6uicMeZclCJQvPi0G
         JvjwYdXzjDNjP0ewZz23HhomoISuKYeY/SF1qbIh6Hjm5obBP+NkezYm2fYueVQNlw
         6n+IU80be3ebGx+SvVg8e4elI20zukzlGzwsB4PQov1Wbgj5FufJZdpUjNdrqe+AnA
         h8oDCFCpQb4xyWq808cmiW2nB2CBKEUXrvONB7foTqUbcj8J3523nnDU/ODz0WyEFV
         AWgOWPeTXdhsw3qABVWC5kFwNgrOJWYr2cuA3HUGrRRJxG0eAGBWzgMWwtjcnrR05a
         QgQStmESXdnWQ==
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

