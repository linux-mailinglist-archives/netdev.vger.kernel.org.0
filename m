Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6319023063B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgG1JLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:34 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728476AbgG1JLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERJFOsegWVVCB7rD1L8gUXGlwqDT2+PCYT7Q2oV/ytFzT2IE6lipsGTaVUsSVCEHCgfOqoKyYAQyQDLtvucZKCtaPOTOw0/4XFh4GyECpC/54YAft2Csg4E9r+skJowBN3auCNIJ6UMsfu0RBj4rAYSHTtCiEDOdqb1BZ60Ic78PQDtWuGvnGNnwWUenNV8+auS27e6KuQb6fEc4VKXwYHFj4c739Zb+7vnLv5+c6DLc4+29jUjW2N18chb7wJ3OLhCwKk18jp38nFLakRy45aRnttsjBcNd8WUkKYcHnvK5L4GHNp62JnyfJpnnBwvqV4sRE8YCu+le1qqgvtbE8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhaxaNKOx/o/FA4SHNwtMrUSfbIn3A/PpFldpdRVbg=;
 b=jV1haHaBVKIISrlOrstOzLOMWHjgvdEOKs3f26eVmOSEwtusZkMEy55ggdsBcnnyTsAyiOG4i3ea0rn04uD5M3eoBO8ntUB1cv/bttZjy4ZUspMaUP3y1biqM3ClPIE4MTjYCy3+CCFi5lbcF32Fi33qULfW0eCZVN/hiNMlp2WIl6dquOWYThlYhceHqUFt1b7G6l53URb2xoaBWRdw0GnI2LGUpvNFbIEZksEKR616J+PrAZkoa5kN5D80I5xW9CT8uvrYR46Ig+D7DsW3edeck4mpoXVxNlh4LYIJdzlCqhCWCFOllSME3j5BbKUSjLepUnNswBWVu6AnM6ZP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhaxaNKOx/o/FA4SHNwtMrUSfbIn3A/PpFldpdRVbg=;
 b=NjZJaPeNcwXzWQOfgPD6rSS284BIsXYs+TvOidMkoUHJNVbB5XMH2KxO8mquse69Z7QJ5s4QyEX0zfHxn/QhJOZzLVv4FvMPGzImZhshJ3ib3OWMFfs+9F74R+7EeE9OhX9KJ6AxfXRJnHUtLZejJtNhiBpr/r2pAsZ6DEK5wq0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/12] net/mlx5e: Fix slab-out-of-bounds in mlx5e_rep_is_lag_netdev
Date:   Tue, 28 Jul 2020 02:10:32 -0700
Message-Id: <20200728091035.112067-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:24 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 087b0957-2f2d-4589-ceca-08d832d63548
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4638B30245A5A6C3F842D74FBE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SofpeivuI92BJTD8HgnUSlJ0WZQvdBZVi4IsGaE8rEsKtSTNFYwqOG1Z6YKkvJZS4RNWQqj2D9ZtfU0YAqkE4xa9e/X4hTG2LGMPc4PEtRyOIvt0PcBvav+uTBk1IJmQWFrvHcgw2wxMVhu1whwURYln35u2gq9UlQ6DF3Xq2O24Gg0aUvjQ0v15PvDoOt3pO+AAXQ1BPMPgjcnMEvsk3gqr1DOyEMc2vQ5t+JdjnLZbcfi2lLjP7isizb5zxRFydu6RiovkKnq+bLfc0GQBMAk2jjivnkcyXf/lS64VnxSYhzVoyk/2an0jQdyMkwlGAEq+3nTWUDn3xKVvzzsKWl7s33JhNTD5fLPgH+cIOnGidzUvMdmKzfZAT1eJ2aNB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qy+U2TMF8noUgC84PQfdKGunRThcUho28F+fl8qR746X22+V4WlqymcJbk+qtgM2FSf+j981PacfPp6lXIojbBZWPGPmnsbaVmnX2TKEEnIKCZTYHPRxQydU79GnVzEYD+U2PcmqwfzR6SHy52y4SFyTepCOCtm4/ilxVhmGEQLZnCBlbRxHb8Qrr0IL71TS1E2zQtUgEa199aUie8t5FqGT7K5IVsP7bXWh2jYPUmI0B0LQ6AS/zImnqfOZrspSv0L/akp7SDDfvASNjnvmTX3c+7dtrlJ4mBlsh5wK2/yiS/emt9TB0RKmH3/23LGQq2ZQHiR6/hNe6J2yKhEKzXa6jdW0Xb1PJUwKVCEZ4wl1TvpsOjlWFvUtzKIm115lP+mT8gk1H/YlKVroVhuJ+Tp7eNcCHHyjQ9myOoDyp50IJ+br6Cz21kH8lzltzxmpC5MDqpwExbiwjJixHNVQbmkrjHc7g7k5KTu0toj3uQ4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 087b0957-2f2d-4589-ceca-08d832d63548
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:27.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLO5jKU/KK18M+tvdhjcOeYxMA0LV1Gqwz1LVXEEvO4e6+RSxehBgAN12gntDwkjbj6TW2UDm3L5fr0NBhK8Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

mlx5e_rep_is_lag_netdev is used as first check as part of netdev events
handler for bond device of non-uplink representors, this handler can get
any netdevice under the same network namespace of mlx5e netdevice. Current
code treats the netdev as mlx5e netdev and only later on verifies this,
hence causes the following Kasan trace:
[15402.744990] ==================================================================
[15402.746942] BUG: KASAN: slab-out-of-bounds in mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.749009] Read of size 8 at addr ffff880391f3f6b0 by task ovs-vswitchd/5347

[15402.752065] CPU: 7 PID: 5347 Comm: ovs-vswitchd Kdump: loaded Tainted: G    B      O     --------- -t - 4.18.0-g3dcc204d291d-dirty #1
[15402.755349] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[15402.757600] Call Trace:
[15402.758968]  dump_stack+0x71/0xab
[15402.760427]  print_address_description+0x6a/0x270
[15402.761969]  kasan_report+0x179/0x2d0
[15402.763445]  ? mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.765121]  mlx5e_rep_is_lag_netdev+0xcb/0xf0 [mlx5_core]
[15402.766782]  mlx5e_rep_esw_bond_netevent+0x129/0x620 [mlx5_core]

Fix by deferring the violating access to be post the netdev verify check.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index bdb71332cbf2d..3e44e4d820c51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -183,13 +183,16 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *priv;
 
 	/* A given netdev is not a representor or not a slave of LAG configuration */
 	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
 		return false;
 
+	priv = netdev_priv(netdev);
+	rpriv = priv->ppriv;
+
 	/* Egress acl forward to vport is supported only non-uplink representor */
 	return rpriv->rep->vport != MLX5_VPORT_UPLINK;
 }
-- 
2.26.2

