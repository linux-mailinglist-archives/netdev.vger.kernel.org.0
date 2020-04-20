Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C2B1B1886
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgDTVh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:37:26 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:6101
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgDTVhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:37:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbDQdHdKOK34CwfIXa90ReVyQKM57rMs4wU/gwAEqJDJispPW0SeUDRXG+HQ4Zi4vjEbUn/uhX0INQcuEM8lA6I2Y6SiiHeRipD8IS0OzG90h0x1/TGbLb5NCcIqNobOumcGov+KypH+HE53iTUMmq3S+VhcmzBjUITKD2N8NUD09M8cLfJk17uzS5p6s+eKdMiA68er5pUdifvYyGCcj/eWgZmSPoWEjGXmAayUhqKzDVzWMJ/bOTHL4to41kD/ZM1bXJdd6Ukrsk3fy7RbNPCF+iwjfdW+MqDYP0eNFTunYaEw3MJQ0cdt3riTojJ5w/2vxFGY1DQQ8OcTiz9p1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipPMhu4vp2biAjOwD1wcnv3kY4z9Wsxuh/zh3bZr1ow=;
 b=mft381/3OxuQ+1Rc0zK4amGMBtVkhCICr7wBM7BdjV5YVnaJQ+PEbZQp4b1Krma2Uf/6TEUxs56w71I2dbhyO33ohg6ck+k4VpLJzhLvUxwx2VwYjOYhYc/27+bjpyjH1x/3c2Ip4/sgKmzAkplIe4aaNvlHcAoQp0gC4BAlJbTMFzZ9wE6KIkKN9qxuoOtiFVL2ka4mO9zFnfqYBgmEVer5CS9Kk210leMJOjEGKxNn19aOVjAHBEd1eqlnOLoLW2tusjFSYGYUDULisBD+brXN++f0Nd0FRdOcushZ4+alPuLqys7nJl6VRZnvd20b5uYhiqq/GP0yCigUDiPfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipPMhu4vp2biAjOwD1wcnv3kY4z9Wsxuh/zh3bZr1ow=;
 b=b5P9Wno1itdm1jHxteP2XzUEV1gpLb1JfmWzEhYNRAF2Z14cMzIVHPUgaSSX88iiAti5Zs61gCFDgZ5uRqVQsUIupGeE9DUsUwUMAeAVsIwPt51RMXV8hVVOZAYKg9Yk0zRZKT20lVPqf1E1ewrnhp4407r9mAXpgCyyjKB9Y7Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6509.eurprd05.prod.outlook.com (2603:10a6:803:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/5] net/mlx5: CT: Change idr to xarray to protect parallel tuple id allocation
Date:   Mon, 20 Apr 2020 14:36:03 -0700
Message-Id: <20200420213606.44292-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420213606.44292-1-saeedm@mellanox.com>
References: <20200420213606.44292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:42 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: faaf607d-84ea-4693-4729-08d7e572eb7e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6509:|VI1PR05MB6509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB65096FEC9A28006CA0F5B1BEBED40@VI1PR05MB6509.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(1076003)(6486002)(66946007)(26005)(36756003)(6506007)(81156014)(66556008)(8936002)(6916009)(54906003)(2906002)(52116002)(66476007)(316002)(8676002)(5660300002)(478600001)(107886003)(4326008)(956004)(86362001)(2616005)(6666004)(6512007)(186003)(16526019)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVSDVpbPQHGCG8tcBZv6Erp7RZLm47N2mU5EzXWQHt2DHpGjgtp7HhISV+JmBeY+yUo7EjKhj3Eeu38ouyhhBNvrATvVORtKzT6D7THHsGrRKjySx1qaeJlQWOvq9zr+EYvEA0Dz71w+1uwnyGUmrihod59XCU+Fy96A7W1qgnTSPYbYboNy1FZITVebXQTkHADqXXZ2DDR3atb84gS6uji75urXW/Lf0RtMBFcomli6mXogt1NQKwWTerrs/VFbVTsqKPQgZ6Av+390rxQVir21GZVtroBbs/zJ8wz9di62e+DPyOcYCMONaz51KazwULRF2tDBBX3TC3Iu/7hwBvjSON4gOixdwhJ93+NuuQEU4Sl0Sh/VPMqHb1dEwS9OoGiXAawyK0k0JMnWDSSM7q1zzgzCt0Qz8GTGKcfdy94sohPaPXcNW7WOnIUdbZlDmHlARBY35zoBBkyiKFJGn/EoRfk3EKMhPvV9ajZ5WV6inRyGEfsK3g/1Szp9zAZi
X-MS-Exchange-AntiSpam-MessageData: bBQ/MhsvWHMqrBO/s9OVabv0llP5SQJvaUJPDb7e6X7Leerp4isHqNMJW0jE7zpZUsIfzq2e+SK0v1FXziWVVo0ijhYaypundNwfovoujaz5hXZHCW13XrnalVsb8LU12gu541Mfue0nM/OTXME0aw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faaf607d-84ea-4693-4729-08d7e572eb7e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:43.9126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fS4xENDoGnsjpYHaFMw9I3dU5cS5RSi6TRxP+bpAGIk5OZ3KQfE/zygJUq5chP26tdCk4PGz34AW9Bvz/+avfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

After allowing parallel tuple insertion, we get the following trace:

[ 5505.142249] ------------[ cut here ]------------
[ 5505.148155] WARNING: CPU: 21 PID: 13313 at lib/radix-tree.c:581 delete_node+0x16c/0x180
[ 5505.295553] CPU: 21 PID: 13313 Comm: kworker/u50:22 Tainted: G           OE     5.6.0+ #78
[ 5505.304824] Hardware name: Supermicro Super Server/X10DRT-P, BIOS 2.0b 03/30/2017
[ 5505.313740] Workqueue: nf_flow_table_offload flow_offload_work_handler [nf_flow_table]
[ 5505.323257] RIP: 0010:delete_node+0x16c/0x180
[ 5505.349862] RSP: 0018:ffffb19184eb7b30 EFLAGS: 00010282
[ 5505.356785] RAX: 0000000000000000 RBX: ffff904ac95b86d8 RCX: ffff904b6f938838
[ 5505.365190] RDX: 0000000000000000 RSI: ffff904ac954b908 RDI: ffff904ac954b920
[ 5505.373628] RBP: ffff904b4ac13060 R08: 0000000000000001 R09: 0000000000000000
[ 5505.382155] R10: 0000000000000000 R11: 0000000000000040 R12: 0000000000000000
[ 5505.390527] R13: ffffb19184eb7bfc R14: ffff904b6bef5800 R15: ffff90482c1203c0
[ 5505.399246] FS:  0000000000000000(0000) GS:ffff904c2fc80000(0000) knlGS:0000000000000000
[ 5505.408621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5505.415739] CR2: 00007f5d27006010 CR3: 0000000058c10006 CR4: 00000000001626e0
[ 5505.424547] Call Trace:
[ 5505.428429]  idr_alloc_u32+0x7b/0xc0
[ 5505.433803]  mlx5_tc_ct_entry_add_rule+0xbf/0x950 [mlx5_core]
[ 5505.441354]  ? mlx5_fc_create+0x23c/0x370 [mlx5_core]
[ 5505.448225]  mlx5_tc_ct_block_flow_offload+0x874/0x10b0 [mlx5_core]
[ 5505.456278]  ? mlx5_tc_ct_block_flow_offload+0x63d/0x10b0 [mlx5_core]
[ 5505.464532]  nf_flow_offload_tuple.isra.21+0xc5/0x140 [nf_flow_table]
[ 5505.472286]  ? __kmalloc+0x217/0x2f0
[ 5505.477093]  ? flow_rule_alloc+0x1c/0x30
[ 5505.482117]  flow_offload_work_handler+0x1d0/0x290 [nf_flow_table]
[ 5505.489674]  ? process_one_work+0x17c/0x580
[ 5505.494922]  process_one_work+0x202/0x580
[ 5505.500082]  ? process_one_work+0x17c/0x580
[ 5505.505696]  worker_thread+0x4c/0x3f0
[ 5505.510458]  kthread+0x103/0x140
[ 5505.514989]  ? process_one_work+0x580/0x580
[ 5505.520616]  ? kthread_bind+0x10/0x10
[ 5505.525837]  ret_from_fork+0x3a/0x50
[ 5505.570841] ---[ end trace 07995de9c56d6831 ]---

This happens from parallel deletes/adds to idr, as idr isn't protected.
Fix that by using xarray as the tuple_ids allocator instead of idr.

Fixes: 7da182a998d6 ("netfilter: flowtable: Use work entry per offload command")
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 16416eaac39e..a172c5e39710 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -12,6 +12,7 @@
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 
 #include "esw/chains.h"
 #include "en/tc_ct.h"
@@ -35,7 +36,7 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_eswitch *esw;
 	const struct net_device *netdev;
 	struct idr fte_ids;
-	struct idr tuple_ids;
+	struct xarray tuple_ids;
 	struct rhashtable zone_ht;
 	struct mlx5_flow_table *ct;
 	struct mlx5_flow_table *ct_nat;
@@ -238,7 +239,7 @@ mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	mlx5_eswitch_del_offloaded_rule(esw, zone_rule->rule, attr);
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
-	idr_remove(&ct_priv->tuple_ids, zone_rule->tupleid);
+	xa_erase(&ct_priv->tuple_ids, zone_rule->tupleid);
 }
 
 static void
@@ -483,7 +484,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec *spec = NULL;
-	u32 tupleid = 1;
+	u32 tupleid;
 	int err;
 
 	zone_rule->nat = nat;
@@ -493,12 +494,12 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 		return -ENOMEM;
 
 	/* Get tuple unique id */
-	err = idr_alloc_u32(&ct_priv->tuple_ids, zone_rule, &tupleid,
-			    TUPLE_ID_MAX, GFP_KERNEL);
+	err = xa_alloc(&ct_priv->tuple_ids, &tupleid, zone_rule,
+		       XA_LIMIT(1, TUPLE_ID_MAX), GFP_KERNEL);
 	if (err) {
 		netdev_warn(ct_priv->netdev,
 			    "Failed to allocate tuple id, err: %d\n", err);
-		goto err_idr_alloc;
+		goto err_xa_alloc;
 	}
 	zone_rule->tupleid = tupleid;
 
@@ -539,8 +540,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 err_rule:
 	mlx5_modify_header_dealloc(esw->dev, attr->modify_hdr);
 err_mod_hdr:
-	idr_remove(&ct_priv->tuple_ids, zone_rule->tupleid);
-err_idr_alloc:
+	xa_erase(&ct_priv->tuple_ids, zone_rule->tupleid);
+err_xa_alloc:
 	kfree(spec);
 	return err;
 }
@@ -1299,7 +1300,7 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	}
 
 	idr_init(&ct_priv->fte_ids);
-	idr_init(&ct_priv->tuple_ids);
+	xa_init_flags(&ct_priv->tuple_ids, XA_FLAGS_ALLOC1);
 	mutex_init(&ct_priv->control_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
 
@@ -1334,7 +1335,7 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
-	idr_destroy(&ct_priv->tuple_ids);
+	xa_destroy(&ct_priv->tuple_ids);
 	idr_destroy(&ct_priv->fte_ids);
 	kfree(ct_priv);
 
@@ -1352,7 +1353,7 @@ mlx5e_tc_ct_restore_flow(struct mlx5_rep_uplink_priv *uplink_priv,
 	if (!ct_priv || !tupleid)
 		return true;
 
-	zone_rule = idr_find(&ct_priv->tuple_ids, tupleid);
+	zone_rule = xa_load(&ct_priv->tuple_ids, tupleid);
 	if (!zone_rule)
 		return false;
 
-- 
2.25.3

