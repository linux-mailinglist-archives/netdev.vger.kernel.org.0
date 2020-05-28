Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330631E52CC
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgE1BSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:18:05 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:6231
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgE1BSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:18:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnNI/wVUgClyp4rnWVArnz9YTV08B26RSjRAPNKpVJmT7fmO5M9lQxlfshpg471sfAPW0ZDiSqv4n++fshiuCltU9kTKF4n9cQzLpYQge8RK2zxVxpocMZaajarjeqQZ0p7hh/Akb6AsWogr/+tQaX9diBKK3zd+E5dJ0BYGQ4ZeYHRLbr/MV+7nnbE2D2krMKuq+JKpdrxqwsp+lmPSWuSKRV9x31Q0V+I0mZ0yUCNQ21FvBUFbyIHBXG/QlOdBjESRZHcPB+lqK7Jeg/QHAJu09k2x/9NraaybgUzNdvV17FOFWVNRXZCPWTb33hdB7/fyhWrZpK96CA7U1xkTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=R+93H8fOtrJSQlSgnYoviRnCbKnDUs8XBsgjYa0xLVfTn5MRGdy182VJ7NCa2IWFRgZJDOWMrByBmNa2Cf69bGtnlCZ4yC5JVX/Zv8vDRINrxC4u68RgnsV+NUJHUbxDh+k11ZqDGyAlviTnBCtHwD39howxZ3tuz6iYoIKu11mOOpCvuVVrBrWnAW9wFsehJNXIhYXvH/TohzzYcp+FnJ/j4ew1QOUEtF1XgB0ZZ43YqMWjgk5tFFRP6NH+DYyE1P7efltjUSS8i+JHwX3xRQF9FFfxOxsybUCUIP6W3nQ2bk+D+31NVQFU9X+cS4lt/bofvtjBcKnupLsHEpIPEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=mAKguCRfELgOG7WdtjGVzFf3FyPBSHDnFijPqhdNns5uO4V+yJnV6nhtsluR7XiQ9MqzPut/ihT/iwl+x1cL0phazPxyS4hZvI5vHDuVPuS76aeyKYd8jpuUr1OdN/Oqd9tUBvSfcQEOpM6uxa1ES70TnzDzRyGQ88a98Zh7oHA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 07/15] net/mlx5e: Add bond_metadata and its slave entries
Date:   Wed, 27 May 2020 18:16:48 -0700
Message-Id: <20200528011656.559914-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:39 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 215b4ab1-17ac-4bdd-26f4-08d802a4eb1c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB436876960BE5C60B46335D11BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7b9pS8S2Y6WztKdRCjuEhf8U8mc7ftgG8rbnmzm/E38ulMd2G+65T2mj6mQ3z+wVYAJCsc99CG1yN+QL8WniufwIcQP94+ZQzaUkw2P2juD+TSbHPNoRbjONkFbHwCuJjOl9XI57NIcA7Syse8TeIVzkShlxBFLczVB0GPTy8FqdMeqcktoy0xs/HCHx6y+BzABoTpQXo02oruQz+mmZI5o1eC3l0TnAxERj6jfN+aB0E9iUAgLIPpuRCWpRcCi81IJ7YjMFfZ7s1QGup8OLrfSOFdXh27eHnk+VSYr6WjO+ytrWXw7Ep3Al17CBSkSp3TYlffRYA8nnNQeKQY8/erziam7Xk7F8lL+uEwEP02tj/e4jHijlDmjapK/bUO7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eywAiqwDaaYcH40v+cumltwURcQqeJcTaQOlLjNzLoyqy+h7LGi9OISGGifUehhZM2cXVo/elvPznYFQxCuOsT0dqH2K2fspWNNBuLo+M4BDel7f6fbCCR4V0K/DTysYRA1Lz/mTg0e1rgA2jEiSyN6r3RJzzwWt8InlyoiEmK+q6SL3kvhcbZhbLHiuua6MMZhL6sf0JAuAY/bKdF+YkTHTaW3FSuwGjcaWJziYMWwO+fUF0o74Hw/It18GoMhlTtt2jhyTV8+QvDQsR+rlOej2E//zMFTcOc0DF13wQxPrEIf8AdKtRpy7TnuvTlL8p2tweELNFBEhcdq+IhJcG8UVVfTDMCouPr9xeqh+rqUOtLwKiH4Sp9NJMjAdbFL18PMf7H9Uw1+McXDJIah2jiesx5sG6+p8a3muxTeuCxk0Jq7p0uy9g5rPH2ZNvLwyQK9q65AgzYUsdxvZzajmCW/PLM6EG7TPS8E8N7h5vqo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215b4ab1-17ac-4bdd-26f4-08d802a4eb1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:41.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/tIUj62GvjKJMDKwnXAliXp1ji0m1m3vIdk5cErXdKX0jL20xsdff9pOF8BxnRfJT9eINZ0YkM9EuylYG8JfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Adding bond_metadata and its slave entries to represent a lag device
and its slaves VF representors. Bond_metadata structure includes a
unique metadata shared by slaves VF respresentors, and a list of slaves
representors slave entries.

On enslaving event, create a bond_metadata structure representing
the upper lag device of this slave representor if it has not been
created yet. Create and add entry for the slave representor to the
slaves list.

On unslaving event, free the slave entry of the slave representor.
On the last unslave event, free the bond_metadata structure and its
resources.

Introduce APIs to create and remove bond_metadata and its resources,
enslave and unslave VF representor slave entries.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/bond.c | 128 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   5 +
 2 files changed, 133 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index d0aab36f1947..932e94362ceb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
 
+#include <linux/netdevice.h>
+#include <linux/list.h>
 #include <net/lag.h>
 
 #include "mlx5_core.h"
@@ -11,8 +13,132 @@
 struct mlx5e_rep_bond {
 	struct notifier_block nb;
 	struct netdev_net_notifier nn;
+	struct list_head metadata_list;
 };
 
+struct mlx5e_rep_bond_slave_entry {
+	struct list_head list;
+	struct net_device *netdev;
+};
+
+struct mlx5e_rep_bond_metadata {
+	struct list_head list; /* link to global list of rep_bond_metadata */
+	struct mlx5_eswitch *esw;
+	 /* private of uplink holding rep bond metadata list */
+	struct net_device *lag_dev;
+	u32 metadata_reg_c_0;
+
+	struct list_head slaves_list; /* slaves list */
+	int slaves;
+};
+
+static struct mlx5e_rep_bond_metadata *
+mlx5e_lookup_rep_bond_metadata(struct mlx5_rep_uplink_priv *uplink_priv,
+			       const struct net_device *lag_dev)
+{
+	struct mlx5e_rep_bond_metadata *found = NULL;
+	struct mlx5e_rep_bond_metadata *cur;
+
+	list_for_each_entry(cur, &uplink_priv->bond->metadata_list, list) {
+		if (cur->lag_dev == lag_dev) {
+			found = cur;
+			break;
+		}
+	}
+
+	return found;
+}
+
+static struct mlx5e_rep_bond_slave_entry *
+mlx5e_lookup_rep_bond_slave_entry(struct mlx5e_rep_bond_metadata *mdata,
+				  const struct net_device *netdev)
+{
+	struct mlx5e_rep_bond_slave_entry *found = NULL;
+	struct mlx5e_rep_bond_slave_entry *cur;
+
+	list_for_each_entry(cur, &mdata->slaves_list, list) {
+		if (cur->netdev == netdev) {
+			found = cur;
+			break;
+		}
+	}
+
+	return found;
+}
+
+static void mlx5e_rep_bond_metadata_release(struct mlx5e_rep_bond_metadata *mdata)
+{
+	netdev_dbg(mdata->lag_dev, "destroy rep_bond_metadata(%d)\n",
+		   mdata->metadata_reg_c_0);
+	list_del(&mdata->list);
+	WARN_ON(!list_empty(&mdata->slaves_list));
+	kfree(mdata);
+}
+
+/* This must be called under rtnl_lock */
+int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
+			   struct net_device *lag_dev)
+{
+	struct mlx5e_rep_bond_slave_entry *s_entry;
+	struct mlx5e_rep_bond_metadata *mdata;
+	struct mlx5e_rep_priv *rpriv;
+
+	ASSERT_RTNL();
+
+	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	mdata = mlx5e_lookup_rep_bond_metadata(&rpriv->uplink_priv, lag_dev);
+	if (!mdata) {
+		/* First netdev becomes slave, no metadata presents the lag_dev. Create one */
+		mdata = kzalloc(sizeof(*mdata), GFP_KERNEL);
+		if (!mdata)
+			return -ENOMEM;
+
+		mdata->lag_dev = lag_dev;
+		mdata->esw = esw;
+		INIT_LIST_HEAD(&mdata->slaves_list);
+		list_add(&mdata->list, &rpriv->uplink_priv.bond->metadata_list);
+
+		netdev_dbg(lag_dev, "create rep_bond_metadata(%d)\n",
+			   mdata->metadata_reg_c_0);
+	}
+
+	s_entry = kzalloc(sizeof(*s_entry), GFP_KERNEL);
+	if (!s_entry)
+		return -ENOMEM;
+
+	s_entry->netdev = netdev;
+	mdata->slaves++;
+	list_add_tail(&s_entry->list, &mdata->slaves_list);
+
+	return 0;
+}
+
+/* This must be called under rtnl_lock */
+void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
+			    const struct net_device *netdev,
+			    const struct net_device *lag_dev)
+{
+	struct mlx5e_rep_bond_slave_entry *s_entry;
+	struct mlx5e_rep_bond_metadata *mdata;
+	struct mlx5e_rep_priv *rpriv;
+
+	ASSERT_RTNL();
+
+	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	mdata = mlx5e_lookup_rep_bond_metadata(&rpriv->uplink_priv, lag_dev);
+	if (!mdata)
+		return;
+
+	s_entry = mlx5e_lookup_rep_bond_slave_entry(mdata, netdev);
+	if (!s_entry)
+		return;
+
+	list_del(&s_entry->list);
+	if (--mdata->slaves == 0)
+		mlx5e_rep_bond_metadata_release(mdata);
+	kfree(s_entry);
+}
+
 static bool mlx5e_rep_is_lag_netdev(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -133,6 +259,7 @@ int mlx5e_rep_bond_init(struct mlx5e_rep_priv *rpriv)
 		goto out;
 	}
 
+	INIT_LIST_HEAD(&uplink_priv->bond->metadata_list);
 	uplink_priv->bond->nb.notifier_call = mlx5e_rep_esw_bond_netevent;
 	ret = register_netdevice_notifier_dev_net(netdev,
 						  &uplink_priv->bond->nb,
@@ -142,6 +269,7 @@ int mlx5e_rep_bond_init(struct mlx5e_rep_priv *rpriv)
 		kvfree(uplink_priv->bond);
 		uplink_priv->bond = NULL;
 	}
+
 out:
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 7e56787aa224..ed741b6e6af2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -217,6 +217,11 @@ void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev);
 void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev);
 int mlx5e_rep_bond_init(struct mlx5e_rep_priv *rpriv);
 void mlx5e_rep_bond_cleanup(struct mlx5e_rep_priv *rpriv);
+int mlx5e_rep_bond_enslave(struct mlx5_eswitch *esw, struct net_device *netdev,
+			   struct net_device *lag_dev);
+void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
+			    const struct net_device *netdev,
+			    const struct net_device *lag_dev);
 
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
-- 
2.26.2

