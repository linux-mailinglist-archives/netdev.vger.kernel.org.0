Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0171E3502
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgE0Bud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:33 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:6191
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgE0Bua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksEl5b+bPWEjAfrqpVdMYQCD3X/l3NGJajl/KNY+yeCgyoUnDJdZUUzrFOOiLHINgAps16ei6Edux/PmcYAHd+ecNEi3LvLSEP2x5Jv8m+iXHLWFdMJc2QwszGCxZrGLIduRhcDAxei+BoY6xLcHvZ4mOeYkxBITSStrcdX+ThEHDv25is1ezFExO1VLcoQYKIMfo1OHgBKrPeb68eiUXGFX+YTXqxFbykibQ4t/pymSU3D/FCLhXAFRuUpmtfdUTj50+5Sc87LTO+a//UW0+mchhkD98MSqitkzeKxsdbv/FOrjnjW0aqdofT74VbqTgdjI6VNxv/GCopr+nB1Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=EzLi8Y83korn+HJy7gKRatr4+b7ZVuN3V4hqbYvukO6cYAZJBkS/nUbSoAFFPO6dbObLM8ZAZ5IkMhjF/Rk3PS9nS+IJLP35iYF3MWMVWa+ernMzSAAQQ1+4T8mU4AA/vRdf/dtw6UPt5vGpvOnGfbRLTF2lU373mBgDQg8V5VdcGOTZrrj0cLf44W7Xu9zTLM0gaFOZqiN0d0brxeBbXmCxiFfCN82or5Kx8Bo7CScg0ilUIxGa1j2gWlNNhAVzI34fIsemGaZp/DnJiXgcNNOIeuz+0fZEZunhqj6PdcGkgdiNu98txn0scPcdasIV9q+XgCwqTYUy99mfA2ZCpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=VTEX3z1U4D5wZrPYyo9o+wnT8roaN6C1hUKfnS38ZasBHclUl8owcTw3OfekBn+OrN9Fqx+IKE7Gq4C7p8tjsoFTjjEaNiB4BVsO88ogAPe3PWwZvkwdEI9PeFr2gwOOlqiYAadt/RY3SICzjis1u8LsxG3rwd27hHPbbT/Yob4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/16] net/mlx5e: Add bond_metadata and its slave entries
Date:   Tue, 26 May 2020 18:49:15 -0700
Message-Id: <20200527014924.278327-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59fc3616-be29-44d9-2586-08d801e049db
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB663780E0284990729F6D2D9BBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4WHlLZShjxUFLa8fvXcc1DbxgC5OK0E3V1HIc32M850Jgvnrqhx0tjEKkFEQyb8Q/XdyUxOqAOXcDEf239nmQ1PTtkV19FFqWQ8P380enGcT/2A7X2vvvNe3NX+1+1oGQg3G1tnGnMcFcp8dPwskzuQb4wyk6m2RbixRlhO0Hipl/B+hJUGOOoBgEK01XoyZx34mbKA7oWJaHimTfItnaPgHjuWDHAuLvsdqy2OgLPPxJdqeNcgG1S1XI5U9tqtBTKv9eJVnkCHpV382jP9SXiU06awTcSL5dD+Ah5SqHOvIbND/Bn6UycU86/4Dw4jrfsNAEuPuMPOXjda0ZnHsocp8GuDT5epHb6KvTAIpxONhM1sHRwydfPzu4r2SBOL6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hUyHqFu/dBLV7QP2FMusDc2wwAoujLzf4mczRsc9wY3sMrPa5rwfuhTpVlymLNEGKrTVgXprL5HTGzFC/+JDVM2J1gYfPyxt458T2gH/tn1w3EWgiqE/YF4i3OhaSfR6aIzpcwBW/5n7YudCbLEoybtb1p5Y6RCH9ns2+xihRYEBUFEkgtFigDH7VFhxOWVWjEgZOpgD+t+ELxPO2gYnsBEMD8wCFhFYkrMLYw8qMgIOl+QQa67qiIfUQne8o2f9pqac49JuC0n9phLcgyOpew3yaz+K5Ba/eFK2X+/M3V+dyNY6IlyIWvGmZZA9I0TgVTXMRrVSLqMNAlJHdrQn401TSV5NrDGRLBoecvhPqprywclf1a91S6hBcpQDIkuHa0jckkMduttFTpn44EwZgVQ6c4X+5SAvJUDQmdxKvSPGhcMU9oEec/8POn7NXauN30s5Z75PS3dsrPfVpYPoYtOdZogdraYFFOyvH3mwcLY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fc3616-be29-44d9-2586-08d801e049db
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:09.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JfEd1dGcsA28bZrKqX91ec/CkkEWdpy2A9TMNsvQnVKkS2eN1ZSdp4X/1iiiEVM8IkiqmNkgPmTRcprUACJzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

