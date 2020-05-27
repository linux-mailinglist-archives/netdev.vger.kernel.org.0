Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813A71E49C6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbgE0QWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:24 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:63749
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730953AbgE0QWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpdcKhX6Tn9iQO/H8arHBBj5rrjVDYrgvfUUW52Ep65Wl36ml46QAC2XU2dGGQUIWkW0b1mwGio51Anq1vTE+PTHgzAfUk8BA3bUwF7dP7tJXS6/cyLPhehq0Jx0vvHnw+5bMshtdw5Ddc4RV2Z/wHpYyg6+Wq16O8NfcmXu//4kBWNAFy01t7Kdus0cwwkJXJjS9+jMc7fGtl8xNbrr/+cuYhrRMGljkC56Pq67vqubnESEd+fzGptFtGkd9zMGdSTI+Ozed5eeWhScBHWrNR9pJUba0NQLQKZoRK4h5S8mpB2zxKDkxnO/aAaTaVORf4wd8i0JwLAX0VWZESp15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=SP4uxxiFT+uzIlhVOqXD4xkUrwQIHnXwKeviELihGbyRpxIBEto13XMO/7peCujV0/isZs90By+DkdYVEhVtF7Ye2wzbXq9fLRD4v6+U4KKg3OhdY6t296ZEnJTyI89ltK1P0WKMthoY98ZgTmM3c6hsMGiu9X0eX5pLpXw+/oUPSuHDkqFO8prQ7rHcmPYtQmAOQZoz4ziRvzYxUSuye0+U4x3DkxoTOK49C6XkYKYRA+kq85cfRoi0VcSCWP6Ruv54rmr1A6VOcb2+ks+zFSizUXPyA/HQHSpkFOGSh3rSMPcpbGNmS202JpYHwfheZdHjrvLSGIrnNM7aDStxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=HLnWP/8B+Wth+I6m8xGihOErQ/8Lz2Ya+Qz+fvoe0VINl93tVa/ggJDnhroOPFbbVEF3KKFo6kOn7G466Zgi+6vO+uBirZbgzVMf8GNI9wX1ZCcKn+UycJlPsXcnQ/r48Lz9cEUvciav7EELFINvcJlFEbdlpOq2qO5CNUCaDRk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 10/15] net/mlx5e: Use change upper event to setup representors' bond_metadata
Date:   Wed, 27 May 2020 09:21:34 -0700
Message-Id: <20200527162139.333643-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:18 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5b6ee88-4835-4552-cbe7-08d8025a213d
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7039BE3ED58CC32E90244DEEBEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lebmABqyGsxHRNliUjmCPBmDkpp53ahpPjxkLe60rBlDR4rM5VK71xr1THMZKlfCbZ0T5aizHu6mYjIUQUAm+dCDQlITcuUVpaaSQEFu1iB38i+qKG8Yv3yEKdVBYdaET6EKCLwtvjQLxtaC3+FPAGWm8316pECVmDuXkVb2elj021F2ztteg9NvHAAZ6/ZPETVNg8RjOMPSa3uO17Ek/UmonpOimO3xxstxbkaEYYtzimFKj+YXbZawg4TSKxdQjq5ej70oxG9O/dkfdTD1gRVuVtn1ErnojpX1jytD5NdY0HLNvQ9GX2/joMg0WERDmMeBmvJQx/rehLW6G2JHLRCycxW43I989VeUoS4Ws/+DssONj5+p37OiImWWwZje
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LddK3XLPsVJMaiJoM1PeK2Kb4l3l5fch4z8jtmMLWYFe8wuYMzQ88HdN3U4W3VbQBvBZ06LIZ6nuk+dq7or/GpZ4zywLdB4ceHMTEJAxx8JGqH4n8THSMLQpWhuI4yvDgzSpVDVNIHSpaL5tvQI5F8iDKMQj7j1qiGgMscV3Io+rFvXyE8vcY8ELpiFD8LuXxMLx1Y66O8gd+chtSxOHE3So2rHo9u/IarRw4WqLZ/nG0/s5hmI6M80q7v8JLLggm9qD8rbD8K92Pb/z4j0q3+Mn87hHYb/iJAwaCQhizGCLmIduhNYdM+CCNW+P373JSDJwBBGA9qD8ZVis+8YI/S++BaVA3yrRaUyk8XmBx53aBIBUNlHwI25r4RfK677Hk6dc9hj7TKUYUkRgetgyOo4/wn6/tfbD9SjO7VgaZsX0SPTdVKVrfKiN7gSo0JlsLVNNzQUZrb70e+bmtIzfEKRHBbKvo2iwS5lvz7A9ASc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b6ee88-4835-4552-cbe7-08d8025a213d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:20.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L164zj3XG/ORf8VnqPqlu0DnSsV8A15qbP7aqH+YeV5RcWxaQ6kP2HI2WY/VyKp0IIDidTJg/eUH7zrQFv+TBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Use change upper event to detect slave representor from
enslaving/unslaving to/from lag device.

On enslaving event, call mlx5_enslave_rep() API to create, add
this slave representor shadow entry to the slaves list of
bond_metadata structure representing master lag device and use
its metadata to setup ingress acl metadata header.

On unslaving event, resetting the vport of unslaved representor
to use its default ingress/egress acls and rx rules with its
default_metadata.

The last slave will free the shared bond_metadata and its
unique metadata.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 13500f60bef6..bdb71332cbf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -164,8 +164,13 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
 
+	/* Reset bond_metadata to zero first then reset all ingress/egress
+	 * acls and rx rules of unslave representor's vport
+	 */
 	mlx5_esw_acl_ingress_vport_bond_update(esw, rpriv->rep->vport, 0);
+	mlx5_esw_acl_egress_vport_unbond(esw, rpriv->rep->vport);
 	mlx5e_rep_bond_update(priv, false);
+
 	list_del(&s_entry->list);
 
 	netdev_dbg(netdev, "unslave rep vport(%d) lag_dev(%s) metadata(0x%x)\n",
@@ -253,22 +258,23 @@ static void mlx5e_rep_changeupper_event(struct net_device *netdev, void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
 	struct mlx5e_rep_priv *rpriv;
+	struct net_device *lag_dev;
 	struct mlx5e_priv *priv;
 
 	if (!mlx5e_rep_is_lag_netdev(netdev))
 		return;
 
-	/* Nothing to setup for new enslaved representor */
-	if (info->linking)
-		return;
-
 	priv = netdev_priv(netdev);
 	rpriv = priv->ppriv;
-	netdev_dbg(netdev, "Unslave, reset vport(%d) egress acl\n", rpriv->rep->vport);
+	lag_dev = info->upper_dev;
 
-	/* Reset all egress acl rules of unslave representor's vport */
-	mlx5_esw_acl_egress_vport_unbond(priv->mdev->priv.eswitch,
-					 rpriv->rep->vport);
+	netdev_dbg(netdev, "%sslave vport(%d) lag(%s)\n",
+		   info->linking ? "en" : "un", rpriv->rep->vport, lag_dev->name);
+
+	if (info->linking)
+		mlx5e_rep_bond_enslave(priv->mdev->priv.eswitch, netdev, lag_dev);
+	else
+		mlx5e_rep_bond_unslave(priv->mdev->priv.eswitch, netdev, lag_dev);
 }
 
 /* Bond device of representors and netdev events are used here in specific way
-- 
2.26.2

