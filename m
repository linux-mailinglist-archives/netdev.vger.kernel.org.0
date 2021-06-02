Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9A13988C3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFBMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:41 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:6496
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229818AbhFBMCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOPByxAB+8D0u5A8eZamlg+DZHUzw7erMfKHxFcf85nJMVzb7ngjb2tZs3/HAY9vYW/eI+6yzuXuxlFsrdQML1MIMwfbaLcxV69jl4OKPhMnh+xcdQwSzBXMovv/fL/LioTmsd2odsZReZ1/u8RKb8EL6/vj1kkwD6zXDs5Kjq6/p63RbL//EBFAz2QfJj5NGe4T78jq7MxAMA5N0eCK9KAsmmlOfcASf+pznoK4GyLTJ327afw5Rx0FrEkTONrZ4qbu68OK5iOaBKJPyqkSDBX57F9pXb9CqDjKg/Zut2WgIL6V4YFz33XLzacxYBU9CUl1y7flXRB3ptq2bLPSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7nsVdfJqq96wEqcxnlSgTU3TWhUWdbX7JNj8laYbRQ=;
 b=ETdIIHuIOojx+7w8G5rk6IhrMdernrm0vji16mRWaTuIALz4D1JuiNsTONj8z+tltx7bBdNhOOmWOcIcXK9zP93+d4sVxxPHuPNLRud1uD/WejN75i04ge3vGm480anU2QUCCvQSWGhe67iRi+eBaEpgzWS1XCLwqDxTl+flgvuqLTIu7hyqP6E6xfciaYUXQYk3VJneuZvXrNQzD2FwtiAtayDzVARyz06R8ncEnkhntglDqliUsDJomlfBzsubt2Zvxok6MXHJMlLOfN3N8K52FFMQh0gMqzHQFiaSzA3fS/cLcfW1U3t8rPmggQ57PMvH8y3LctdjtESZ5Zn7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7nsVdfJqq96wEqcxnlSgTU3TWhUWdbX7JNj8laYbRQ=;
 b=tKOlSOkDxzgSiTOPTSDoNBzoAimdMAlmZld/DYHCt4uJDDgHeepCIa+34dy3TKJV231b1xrw6OOFL/wjly9GChYOVwEO5ZvjbtBxHxxzfNkNxnTTOOJzWA3HStuN4JGp1r37fiNmQSVyfkDZ1BZcaVILPd473YMP5ulWL+hH/9g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:23 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 6/8] nfp: flower-ct: add a table to map flow cookies to ct flows
Date:   Wed,  2 Jun 2021 13:59:50 +0200
Message-Id: <20210602115952.17591-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1653d7f2-801b-4e29-5b80-08d925be006c
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49861678A3148F081F9FBC6FE83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOEhReagbNEUajkZUzfpzjFUhrdF/1uRhD/gGSshaosRV+DE6YX6QknRDJ1gP4M3HtBETK5AQDJMH2yV63subKJutdZDw6rGH2Ub4LTdDyjEgDW3l+dAWhGugoXRmRupo94GI+bY7aRXn4S1cnv0vPNBPHBaeAvh0fhzKZU7g/fFm8pHUUBED97Ozl5Iec8zf0Rr+PhCcUQMTb38SYuFPl6rQdVjGXN6cgOROzpkSBblI9sRQc7uk7TuInvg9rVNUOO1SY1HgUOYvSZxBJkqpDaiJIgzcbjnct5fjzhLHUXBsnUnZNgCS4/4neam7iluuMCSEkMBJSqfoVYqK2J+l/G5VtEkcqjK57ZmtXyU4tG6ygQJqvKxFVYgF5uyzVvDQn/IYNVc/0OJQUXFcWjvJgrFe1DeCX6ChauClxw9KI1maqB4hjkn8zmLYd4PivB5qyc1N9+hja9bMkSdo7TP5tyfUgktzAOqulzfXEzFbWUpHBQg0cU70EysmR2LYIhWbjEnvDCJRXTUJbIcytml0No6+iJGQ98VHIuzl30JJ8RRSOvGldcqgyu/3IGPtOCms9+HUI/ZAVYcJBI3KsLm/vHqNrNL8kV56I1cn1/cePU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(83380400001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vn7i2+WqnQlG1qxVmDN4L1Yq9sEA6kCH/Ce4TBljIdOHb2TAoIiYqycF8ATd?=
 =?us-ascii?Q?fmr6j9RNny94WQYEEIRJVuso+BTfnFf/jt3MnEazA6JB7pfTUXNIOs2Cj3TF?=
 =?us-ascii?Q?TcX/und4BE8xBdQj52IkOsKGFrD1YkhPoSY9FLbs8xku3vM704sDeLEE5t2a?=
 =?us-ascii?Q?OkKcrXBU5Vqx2kP0GEdF23iuSXpwJojIWdH9AA41yxzO+ojaLsI86wlq1h/h?=
 =?us-ascii?Q?po0+6fm2tRKXURAoDt95IUIAmvZTTGbS2vdo+BmVqJqrgBX7wDv6pSHPw5+u?=
 =?us-ascii?Q?6qxQE/t6JOPhZChoChJxWKrCq5Bf50I3TIcQBhz54f02L5sbw/dVzGRER77e?=
 =?us-ascii?Q?yODOesgzpxTTu7oGCwh6DfMXMmkHPNLW7XSfg+eJDP/4maT1uBqj9n0RRz3k?=
 =?us-ascii?Q?0QEw0PHzDoCp+s930MCwK2+g0o7RAQjMaQu3sfWXcGC744KN9LvB4cD8Fn9g?=
 =?us-ascii?Q?rbOF5uZfVwq4qNuIbE6coop0647q5rDwA5FX3YpU1YlDluteeG/cbABAWdGk?=
 =?us-ascii?Q?Z8VJA/xhwtzY4pIR7uj+QG6ZlppZFR+KSfW0KwKFTkwVAawPwRrdb0eT15BE?=
 =?us-ascii?Q?kk7BSB/zznEuyuPq3D9CJnPdWOww8+eq1LXIFkPVMZ9Z1iCTuqgq57GJWMPa?=
 =?us-ascii?Q?K4W5Y0M3iODcz22iNNUwizMNC2nFwZGQPGXlt3Qu2yItI3myyiteKrWNaZV7?=
 =?us-ascii?Q?gwEI46DOpykEAPOSBco35/CNNQpz1XYb0ROxUt2f2epz3TwhqOvLBiJVDH8f?=
 =?us-ascii?Q?M5EtMRXeqlDHCgDohQmyr8JqTEQm6ELXt/hOuamJWlTCobMQL9gS8wMw/3S8?=
 =?us-ascii?Q?5psF8C2FpppLE+KGIqZ8i1BlJ95gSrVuYRbfdnlwVuqUXYu2I+ov/E8Cg1Z1?=
 =?us-ascii?Q?cAUR8AZuuI1svP/DMgoCgRX3jv//oGZEAAI0XVCWJorSkhlv8Dy0RV+qwaBI?=
 =?us-ascii?Q?gASKdJ6DXkpUWgMuQ+XQJzEkcgOnunpvSzOcXk57mGYdCQDRIraoPRScDato?=
 =?us-ascii?Q?YnKIsBaGYUaZE5PabpWAaTbxkAOBnva+PYgYVH+2xjSFpTYWQqJDffJB/m7K?=
 =?us-ascii?Q?IdLt4ovFJwHHcqip/E5EZSF6xggN/TJnKf2GfXjL6aaqN9lL7wR+zoSbsgMQ?=
 =?us-ascii?Q?uBxSMG8np8j8Uvy9NFKgVwIp73E82sUVTHHJ6ug5h7Yd70o8dRKG3L5yGuo7?=
 =?us-ascii?Q?/Z4+0ZejbW/C1yjXDIRpcV4FTZ/XY8uqP5/27EOpwmsRDK2PmNeIJAomDrFe?=
 =?us-ascii?Q?ynP3vYVU1Xd88AQ8b7mWuS2e4M+Dt68egvNfatXAWucgvf1HDPNg3F2/KskO?=
 =?us-ascii?Q?TNrowSzugX/CYpQ6/jDgLtNtwaA27YYSMGnKJ0/Vu5nzLkFMzAzYnny41n6k?=
 =?us-ascii?Q?LZXVHipkfrUrj39UCehQZ27TK7QC?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1653d7f2-801b-4e29-5b80-08d925be006c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:23.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhfLaVhNbxxEboGTK/5sFiz513AvI1aOE7r8h6zzS2aN3B9kJrJ0zmcjth7pshg+sr4/qB1vIb30TKIfi9uDXqUkAB6mOiPK4NZ1WlfKpOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add a hashtable which contains entries to map flow cookies to ct
flow entries. Currently the entries are added and not used, but
follow-up patches will use this for stats updates and flow deletes.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 35 +++++++++++---
 .../ethernet/netronome/nfp/flower/conntrack.h | 13 ++++++
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +
 .../ethernet/netronome/nfp/flower/metadata.c  | 46 ++++++++++++++++++-
 4 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 57a5ba5f2761..f6f97224e773 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -107,9 +107,11 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
-					 struct flow_cls_offload *flow)
+					 struct flow_cls_offload *flow,
+					 struct netlink_ext_ack *extack)
 {
 	struct nfp_fl_ct_flow_entry *entry;
+	struct nfp_fl_ct_map_entry *map;
 	struct flow_action_entry *act;
 	int err, i;
 
@@ -160,12 +162,33 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 
 	INIT_LIST_HEAD(&entry->children);
 
-	/* Creation of a ct_map_entry and adding it to a hashtable
-	 * will happen here in follow up patches.
-	 */
+	/* Now add a ct map entry to flower-priv */
+	map = get_hashentry(&zt->priv->ct_map_table, &flow->cookie,
+			    nfp_ct_map_params, sizeof(*map));
+	if (IS_ERR(map)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: ct map entry creation failed");
+		err = -ENOMEM;
+		goto err_ct_flow_insert;
+	}
+	map->cookie = flow->cookie;
+	map->ct_entry = entry;
+	err = rhashtable_insert_fast(&zt->priv->ct_map_table,
+				     &map->hash_node,
+				     nfp_ct_map_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "offload error: ct map entry table add failed");
+		goto err_map_insert;
+	}
 
 	return entry;
 
+err_map_insert:
+	kfree(map);
+err_ct_flow_insert:
+	if (entry->tun_offset != NFP_FL_CT_NO_TUN)
+		kfree(entry->rule->action.entries[entry->tun_offset].tunnel);
 err_pre_ct_tun_cp:
 	kfree(entry->rule);
 err_pre_ct_act:
@@ -245,7 +268,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 		zt->nft = ct_act->ct.flow_table;
 
 	/* Add entry to pre_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 	ct_entry->type = CT_TYPE_PRE_CT;
@@ -286,7 +309,7 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	}
 
 	/* Add entry to post_ct_list */
-	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow);
+	ct_entry = nfp_fl_ct_add_flow(zt, netdev, flow, extack);
 	if (IS_ERR(ct_entry))
 		return PTR_ERR(ct_entry);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 46437de4d75f..a7f0d7c76b72 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -9,6 +9,7 @@
 #define NFP_FL_CT_NO_TUN	0xff
 
 extern const struct rhashtable_params nfp_zone_table_params;
+extern const struct rhashtable_params nfp_ct_map_params;
 
 /**
  * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
@@ -69,6 +70,18 @@ struct nfp_fl_ct_flow_entry {
 	u8 tun_offset;		// Set to NFP_FL_CT_NO_TUN if no tun
 };
 
+/**
+ * struct nfp_fl_ct_map_entry - Map between flow cookie and specific ct_flow
+ * @cookie:	Flow cookie, same as original TC flow, used as key
+ * @hash_node:	Used by the hashtable
+ * @ct_entry:	Pointer to corresponding ct_entry
+ */
+struct nfp_fl_ct_map_entry {
+	unsigned long cookie;
+	struct rhash_head hash_node;
+	struct nfp_fl_ct_flow_entry *ct_entry;
+};
+
 bool is_pre_ct_flow(struct flow_cls_offload *flow);
 bool is_post_ct_flow(struct flow_cls_offload *flow);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 060c6de36c02..0fbd682ccf72 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -195,6 +195,7 @@ struct nfp_fl_internal_ports {
  * @merge_table:	Hash table to store merged flows
  * @ct_zone_table:	Hash table used to store the different zones
  * @ct_zone_wc:		Special zone entry for wildcarded zone matches
+ * @ct_map_table:	Hash table used to referennce ct flows
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -231,6 +232,7 @@ struct nfp_flower_priv {
 	struct rhashtable merge_table;
 	struct rhashtable ct_zone_table;
 	struct nfp_fl_ct_zone_entry *ct_zone_wc;
+	struct rhashtable ct_map_table;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 062e963a8838..7654cf6a3222 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -504,6 +504,13 @@ const struct rhashtable_params nfp_zone_table_params = {
 	.automatic_shrinking	= false,
 };
 
+const struct rhashtable_params nfp_ct_map_params = {
+	.head_offset		= offsetof(struct nfp_fl_ct_map_entry, hash_node),
+	.key_len		= sizeof(unsigned long),
+	.key_offset		= offsetof(struct nfp_fl_ct_map_entry, cookie),
+	.automatic_shrinking	= true,
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -528,6 +535,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_merge_table;
 
+	err = rhashtable_init(&priv->ct_map_table, &nfp_ct_map_params);
+	if (err)
+		goto err_free_ct_zone_table;
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -535,7 +546,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_ct_zone_table;
+		goto err_free_ct_map_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -572,6 +583,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_ct_map_table:
+	rhashtable_destroy(&priv->ct_map_table);
 err_free_ct_zone_table:
 	rhashtable_destroy(&priv->ct_zone_table);
 err_free_merge_table:
@@ -589,22 +602,40 @@ static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
 		return;
 
 	if (!list_empty(&zt->pre_ct_list)) {
+		struct rhashtable *m_table = &zt->priv->ct_map_table;
 		struct nfp_fl_ct_flow_entry *entry, *tmp;
+		struct nfp_fl_ct_map_entry *map;
 
 		WARN_ONCE(1, "pre_ct_list not empty as expected, cleaning up\n");
 		list_for_each_entry_safe(entry, tmp, &zt->pre_ct_list,
 					 list_node) {
+			map = rhashtable_lookup_fast(m_table,
+						     &entry->cookie,
+						     nfp_ct_map_params);
+			WARN_ON_ONCE(rhashtable_remove_fast(m_table,
+							    &map->hash_node,
+							    nfp_ct_map_params));
 			nfp_fl_ct_clean_flow_entry(entry);
+			kfree(map);
 		}
 	}
 
 	if (!list_empty(&zt->post_ct_list)) {
+		struct rhashtable *m_table = &zt->priv->ct_map_table;
 		struct nfp_fl_ct_flow_entry *entry, *tmp;
+		struct nfp_fl_ct_map_entry *map;
 
 		WARN_ONCE(1, "post_ct_list not empty as expected, cleaning up\n");
 		list_for_each_entry_safe(entry, tmp, &zt->post_ct_list,
 					 list_node) {
+			map = rhashtable_lookup_fast(m_table,
+						     &entry->cookie,
+						     nfp_ct_map_params);
+			WARN_ON_ONCE(rhashtable_remove_fast(m_table,
+							    &map->hash_node,
+							    nfp_ct_map_params));
 			nfp_fl_ct_clean_flow_entry(entry);
+			kfree(map);
 		}
 	}
 	kfree(zt);
@@ -617,6 +648,16 @@ static void nfp_free_zone_table_entry(void *ptr, void *arg)
 	nfp_zone_table_entry_destroy(zt);
 }
 
+static void nfp_free_map_table_entry(void *ptr, void *arg)
+{
+	struct nfp_fl_ct_map_entry *map = ptr;
+
+	if (!map)
+		return;
+
+	kfree(map);
+}
+
 void nfp_flower_metadata_cleanup(struct nfp_app *app)
 {
 	struct nfp_flower_priv *priv = app->priv;
@@ -633,6 +674,9 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 	rhashtable_free_and_destroy(&priv->ct_zone_table,
 				    nfp_free_zone_table_entry, NULL);
 	nfp_zone_table_entry_destroy(priv->ct_zone_wc);
+
+	rhashtable_free_and_destroy(&priv->ct_map_table,
+				    nfp_free_map_table_entry, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
-- 
2.20.1

