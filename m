Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85B01E52CE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgE1BSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:18:48 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:32229
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbgE1BSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:18:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mdql2P9l/rGB3RjtP4AWrGoFphZ7BANKmTCkt4uunBfKOVCRvkczbSUhW5eTRd3LVKPi2h1r2Yy4Q0EnjbfDkQtLx3V5HNk6Agj8FfxKFydIzW1cl5zGGGS3FSyqSY+Z9J37M+Rs8ln2xcqHJN5MhNxinkBJfSWsCOD/g28CqfZs0Ow8KghGcvB6qmS2xy3QgvKGOVbYQqLDwh+7DKLEA3wvCpap+fAhz8PwhNbUyZ362+Dsa01yAKa8g4+Mnye4KUei8n/LgDT4fq9JcXxUfcXB+yGcfj6UE1DC4OW9qJSubDai6v+8Ny+T88P9oee2LmENwa0L7wAhAijN6Uuniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=fkjdh80WkfKGwFvlJDBaTt+OQme4SFejeeyxLIHT91LV11mCX91R+2GAk0w99Xyi1NYF7j8wJpJYJUqNVRyOopvPz8m3JNewQk5F6BInBaI67FNJURf+0OMjQTxDqqFAiKfO5UjDuaIR+sIi0O24MaL2pzyaMLFIaaAMl609fZYQoWBNtRYu8chE+36a3KKuh4L/NzNsCxzeDNp70MDRqJo89t3EsAJkTAjD7sPpDDrw0qKBCJ1RZXWDYHKZDKJ1FhIlYWwb91f+3BhmbnAtRpqffTatcNHgsjIxxE+BpP7fMX9shUBGdH5or+h4d4f7agLykR5LqKNSsO5eTwKDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qT/4sfvmI67gLjE83pBKM0Gki2IQnf/se4ytOD11L1c=;
 b=ngOU6OmuFMbEYe0vKEc2FAtMMkN9jQ47nS8gf38t4YUpYKdB4DTo+3jg9Gm6pgtqiDNkCyk79I1NfrFIjL6hWbWFfrcD2Y7V9Cmrlph3afmmSGTzgv5UW/gA1wRR5yzE+v392aEfVALBrszpF0I2HdN7uxOke2cTU5qltfj5Ah0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 10/15] net/mlx5e: Use change upper event to setup representors' bond_metadata
Date:   Wed, 27 May 2020 18:16:51 -0700
Message-Id: <20200528011656.559914-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cc06d4a-672a-484d-0079-08d802a4ef66
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368DAA1AB4B1F31E362CB3EBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YlmYzWd2gwtEViNmx1+HNM4o0CL+ntBqubGb91Usdf+0pYGSVH2VL0wyfgSriDp0GoGaTW3NEXc8yeuY0AWF6PZta6fL+7Frn75yrMa6iur92rR5Deh9ML3bjniH8IAM9HX99C6qLU0OWcUUhkHkzDk/7hgWDZxe/0+u7Xu5PeWFvbyrrDMis9IR+Q3nyXMKw67paf2Znd6UV+lbjPDgoyx9PW/4aSmMPD7h0niYCI5XJO4+/+e8UKIDZkJrufdFiWSpaMj5bMTCr+CKYcb/DuQPl4+E8OFw+8mxSVHDuLoSeosbjShNi6zKKthLDzEfAH+wbgQTsmiM6zQiXUsAvoln5WVfKHJNK6qqoQPtT+xon2W6dhGemVetq7IHQDLv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pEGbbXDJkHU+fGlbwGcuE1aChZ0VLE0lEdodfQyBSd6YUvzH2Cx/c4Bvf1TCLgQNSdQ2pRtp1QoewAkmLDxFvqtCRI5blhyhnN1tCFB1wSZRPSr0AAwYWusp1ij2oM9FBDimLWoArufJb9009rr0yXROgyovgSJB0KSt8XWOv9YJ0kScYh/NaR2BczIrzCxHDs6nMJXb69zNoL9OeMaiqMLpqyKzIRsjYOO6DMzSZ2/mj1trGfdjCopHwmA4V2ZIV7xE/rKmZA+22kRGB2h47LTI0nFlzAXysKQxIIYA83cFuKMLaCLBZ0Q8rTnomjL6O8L9FOz6Jc0+Z3O71GKhY20fQ6fbJ1YJA+4yoHqEClH5vuO9Q2iDrICjfwP9W2gkVN3gjGkJmgvPGdS3zrUvt+zndk1pCNMA6PdBMbaM1tKYFj+ZOBAOYSM+r9fAKAaDmm33jHmd2wdGRmxNkSEJoCY7cPZjRRe5Yoi+oYuoWns=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc06d4a-672a-484d-0079-08d802a4ef66
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:48.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kR1GaR0uTfoaj5OZ4fflwzxfwhpWPEG35sA6sjr5iyxBhg29b9pYaZGdPRBfvQ2KhUKxhHzF6W6SFrdJMSobzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
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

