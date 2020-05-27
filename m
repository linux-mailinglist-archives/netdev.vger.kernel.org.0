Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154F11E49CD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390956AbgE0QWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:46 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:46308
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389823AbgE0QWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSDoQLHWzv/2g/W3ZwfCZk9iwYm0xp6rCP49nPsKnG2sG16E9OvDCw0dtdv+z9ZR+IRBaX+TsPTwz/B3dX9xDDHB42xz9EtqMzB3VDOB0H5ZXPUTUmFEG6WTP5GhZXPDxQzJ+03abFap+4ORNo8oeLdErSloeFIwsw8V3O5OVM8L8o6+pHz0gYAL/8YNoHtv0i9vuVOVg1jQio8DzYhgnimG/8jtFe5H89Ss1nWIdnPU+vCp3rKaNj8+s2WskAFmPKqDaNRPv8aizYxrcPHtjOJh9gnSsU38z3OwmY+qwniq9CXpUIf7f7eKsvr5pZfGAq7za1XLM2TdHnne7p8rRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=KpDnDHzAtpCc1y+bkrsoPSNE9mypkIEaHvx2fC0VIkACBrlTz/lg7YYNoYYyKAOk24tk9G/wvxtHOYzTrVxPJQ8rZcR8h8F7IS9+em0M48inSOSNjPgoMW3Vp0upRnMFUPJxudI0iCdLoWxaQo5PZ4KB6Dm9YXPwqKDcYFESzir6gAOWE9luwO6O6FIFu1bB1E4Ljmph2rAi7RQIRh29JrA6mtXkcmaTzc8dTpUiou054sngwRj0BjWbwyOn8oNZiqLkXLe8cXtN/R+YbVo0ekHRXvdVHtNav3BVG1KWqAswZfxoutwk7WwIMFrlusktNx2jJPRPuWTA+/JzVn2NRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfSckdmHtmnlCd+A90fYSwXkozT7ksq6RQGX0M2vkN4=;
 b=OpNWmP4dp1y1BGLYSchMIeVKzIFdlkKhZanB8xT2WzQVZiVslv1yUZlYDfHc6Sz+rdya5NHDbOTMfFlxr/eLnh6X+9E6ajtKfaNG71lCP/yU9uVwvLKKx3sltkgKEgXQCtMH++9WGvQyxtj8ReZRXozZMqS8c5BViNyX8WzWFdQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 27 May
 2020 16:22:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 07/15] net/mlx5e: Add bond_metadata and its slave entries
Date:   Wed, 27 May 2020 09:21:31 -0700
Message-Id: <20200527162139.333643-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1a48043-b690-4823-2510-08d8025a1d46
X-MS-TrafficTypeDiagnostic: VI1PR05MB5054:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50540A7C67DD006ADA7B6998BEB10@VI1PR05MB5054.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+3Ts0Y+opw1RAEwsTXeqtHHE4J8o80xCV4VtvuMJrQiIYhCCn71WAgZB2U9ETnk5aOPj8k9uWTfZll0A6f4H8uw/ubVN9bvpzg/6GYHvNzMXbGuZhPdogWh9HSapc7Yb+sKf+gJA6xLxLMvQJG+ztcAOz4BOomGDORlPNZAj5/9N+wL7V3MQdlFuodD7TLRiYuj10vF9ZYhrX+OYujtxHpkzhodnrYq+gjIypMUgYDWTsp/0m2vedBgGe4gORz+AbEHsAG2CruEjc10OWLGM5OzhFw+gUTq4VoeqKAsbhf4I7o1TiDp8/GQ0LqZeAQlZGARLAvs4ABt9zjJcxi3B+hIUG5f6e+feovolw9fR7PrFcEPpM29jDX+7jpBs/mH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(6512007)(107886003)(66476007)(66946007)(66556008)(52116002)(956004)(2616005)(6506007)(5660300002)(6666004)(8676002)(26005)(1076003)(86362001)(8936002)(478600001)(2906002)(4326008)(186003)(6486002)(16526019)(316002)(54906003)(36756003)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2cc9qe0aAqwWKobiw7O9HYxBFFyAiuRi7Wkce5uCKAlAWzIlLYDSHxc7TReVPQokMiKeGMdnny9iPToMcc1ESFvLguoCvlbXECYLQmGlhdEBtzuFRBRT5JKoy9nZESZm1OzbykhCdxVRXJ1mjbqbtGjrjSDZg0nPM1E/ve5klxe3bxxP+JCm/RF1AxKVikkKglvqQe3hEePNCuDdV7WWX+rgf3gmmJY82U9axOmpECUcmO6YvxBHlVVkmQyuMHI1/hB5WTzMxCtuCzmuRTiTYpwbHe9JULGbVcU1U+QbsgiDAmVnKc5Wl4zBPWvvUUXqgYJp+GGL1+YiFXrCBH52F6UCGobXEQC3n7BPk/W2CnFIbPwBgXPF978ToXgc+agHwY8Dla2Hedx8+1D3UyqdTbRUKrnAZ9DgH75L+Mgtkgz7wDlLkipV6JhfDZdS6qnK3ctZLbvwmXFyc5I0xIDyxLFjYyxtkOlOxVR208ig9f4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a48043-b690-4823-2510-08d8025a1d46
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:13.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1hsnVHnl9nFRyMTaTMJjaktphD9A5CjtBbAHqKYzcXSOhAKZSXCpD+bzxStvxda0OcusD5ooZoUUuD7fWwZ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
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

