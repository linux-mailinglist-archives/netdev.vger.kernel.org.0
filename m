Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6DB172D9A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgB1Ap1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:27 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730353AbgB1Ap0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/CHFARxCsgibd9shB1tVHbO9AmjqxbVjLjjXDTrN3z+yBIZU45cSK2fONhn0hnFQi/T7MXEpWgVb4Lszt9oYNXWNVwOyVGD9OC5qf1RLkSFFocWJWPh6E4/nga7YmgJn6mwdRkBVkemCpaEyaFBZShPao6YcTHq/frI63bW5z/BSbC7j8LpZllqhtiteQL6NynoQnCQxo1iotpCyiOIjaHUeY9F7N2aF3YBuvV9EPUPK9KMy2Lo949qnaVtf3lV1iJhBsq37gXw57B5gpYYZ0kkc9gDdmD2rIomsgcUmIHMpenzLemj1aAx7Xson3oRLzYZHigNHaSny6q25KiIQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXvwjkAJdcjqCAM72RUcbixY/9mFMFbwek8KbdHCyro=;
 b=ScmGf2dBLuKTq0xAe1nIF92kqFt9hU3ZMAn4AjpF7Oss+IOKWQPiTBzS15zpLFmmItqlAmppGz+uea0dbV9SAbG3yPF3wlAWfjo27w+mH9x/UHFji40lGC5Gaj1aeJ2P45nvqAv+xJ0OnPvZoR20rTmvOYzf53VJZZqcWvU7mrdjd/ntlWNC7NMJLL3XslsQgTQlW8aGzfN9lL7qxXuvagYeDDLfiTBUxe5MOl+/h+ddz41xLZuLccQrNk+2tCZ8eAyIPnNjPd1y3tRMQgZg0fxytGkeDHyHqhb/UTLgmKaEX3Lqa1Fk4BDXDpO34/ZB6I5qkeNK4AiJvU2welpVDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXvwjkAJdcjqCAM72RUcbixY/9mFMFbwek8KbdHCyro=;
 b=DqqTVyku6uMQgXTiesbsJ37n6Oe+ioFlg0pkLoI56QGOSvANTdGGtE5IG/AbVTYDiv6ac/0mCpMUeabgy/W+GDxowqWOAveDjDR7W7qYPTxZJ0BZiO1/SuC2rfAxC/clujCEi81GfwHLWPToZ0MS/csKgwZso8vpzYsg6YAGlSs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/16] net/mlx5e: Eswitch, Use per vport tables for mirroring
Date:   Thu, 27 Feb 2020 16:44:33 -0800
Message-Id: <20200228004446.159497-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:15 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 402ec6e2-3342-47fd-dc21-08d7bbe77b16
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB418918A8877F6636DBFA28CCBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(30864003)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ycxy3Wt459GyZAHgQnqWkjLibzMSj6i8LkNoQPO4tLDa98StoadmVC18f+KVw5PVC+dzIR4ByGByLMNQtZKzp/rVrVuaEVQGTSojeTrwWre+3LSN4ZknCh84CM5nb6CLX+S/rbDveYpSSCAKwRf9/8cAH/su6mtuzGoFJkUWaiEod8mjhvQEL2fOBIV/08mF+w/4pBeivFE/j+szjO2Kyozdj2CsvHO8/Wb57EgCOVcHArLUKMb0Ja5bfP5KWxXruQWZW9cxvoR3uhtNEIzoNhnK01tSNM7z/MxZ5gIPJa6bsJNmV1DrgVogs92cEdedG2rBIuWrqqexJMlokUO4aVCIeWJJJ0/46iLwkaDdatZWOQuaMqHXLHbaog2Gadc2oq6K1GD1s1j8n1tLPfh7AQVevssbIs7f2LjndrrqJUvFK7hITz3ig60qXRBL/rE2hJM2azDwm1rMDJIS/15kTFeQ8yQmLDFDC8OguHNhFA+1XQWMGJXknN6gZ7HCuMomIy9x4fIFqKe7STU0lRJZuTMCkwKa3hQvBrVvhKYu0Wjwmwo3JTzZ6+yokTNAkTTc
X-MS-Exchange-AntiSpam-MessageData: mKumDgkA/Xp3pkW2u1gIDZqqVkWzE4FzOL9JrGmeIkMecYDX0ljGmMJYJKnrn61CfSp2PK57TgpNKNa+x9Ur8ls4icfNXoL4l1AcnzpOyxAPR4R6Sy22Xpfwf7oMuJ0glFGFKDG7KpcgWWc8aymcHQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402ec6e2-3342-47fd-dc21-08d7bbe77b16
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:17.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yf+biFks1K4SUbuuuTZqbpDDWokvT3nVzwBZnNAg7kVLBvYGJBfItR0hQa8ztyBGFNhkrNRZ9TatbLd4TWPgqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

When using port mirroring, we forward the traffic to another table and
use that table to forward to the mirrored vport. Since the hardware
loses the values of reg c, and in particular reg c0, we fail the match
on the input vport which previously existed in reg c0. To overcome this
situation, we use a set of per vport tables, positioned at the lowest
priority, and forward traffic to those tables. Since these tables are
per vport, we can avoid matching on reg c0.

Fixes: c01cfd0f1115 ("net/mlx5: E-Switch, Add match on vport metadata for rule in fast path")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  10 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 206 +++++++++++++++++-
 .../mlx5/core/eswitch_offloads_chains.c       |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  11 +
 include/linux/mlx5/fs.h                       |   1 +
 5 files changed, 221 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4472710ccc9c..479d2458f872 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -49,6 +49,7 @@
 
 /* The index of the last real chain (FT) + 1 as chain zero is valid as well */
 #define FDB_NUM_CHAINS (FDB_FT_CHAIN + 1)
+#define ESW_OFFLOADS_NUM_GROUPS  4
 
 #define FDB_TC_MAX_PRIO 16
 #define FDB_TC_LEVELS_PER_PRIO 2
@@ -183,6 +184,12 @@ struct mlx5_eswitch_fdb {
 			int vlan_push_pop_refcount;
 
 			struct mlx5_esw_chains_priv *esw_chains_priv;
+			struct {
+				DECLARE_HASHTABLE(table, 8);
+				/* Protects vports.table */
+				struct mutex lock;
+			} vports;
+
 		} offloads;
 	};
 	u32 flags;
@@ -623,6 +630,9 @@ void
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport);
 
+int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw);
+void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1a57b2bd74b8..9a72c719d8f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -50,6 +50,179 @@
 #define MLX5_ESW_MISS_FLOWS (2)
 #define UPLINK_REP_INDEX 0
 
+/* Per vport tables */
+
+#define MLX5_ESW_VPORT_TABLE_SIZE 128
+
+/* This struct is used as a key to the hash table and we need it to be packed
+ * so hash result is consistent
+ */
+struct mlx5_vport_key {
+	u32 chain;
+	u16 prio;
+	u16 vport;
+	u16 vhca_id;
+} __packed;
+
+struct mlx5_vport_table {
+	struct hlist_node hlist;
+	struct mlx5_flow_table *fdb;
+	u32 num_rules;
+	struct mlx5_vport_key key;
+};
+
+static struct mlx5_flow_table *
+esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_table *fdb;
+
+	ft_attr.autogroup.max_num_groups = ESW_OFFLOADS_NUM_GROUPS;
+	ft_attr.max_fte = MLX5_ESW_VPORT_TABLE_SIZE;
+	ft_attr.prio = FDB_PER_VPORT;
+	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(fdb)) {
+		esw_warn(esw->dev, "Failed to create per vport FDB Table err %ld\n",
+			 PTR_ERR(fdb));
+	}
+
+	return fdb;
+}
+
+static u32 flow_attr_to_vport_key(struct mlx5_eswitch *esw,
+				  struct mlx5_esw_flow_attr *attr,
+				  struct mlx5_vport_key *key)
+{
+	key->vport = attr->in_rep->vport;
+	key->chain = attr->chain;
+	key->prio = attr->prio;
+	key->vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	return jhash(key, sizeof(*key), 0);
+}
+
+/* caller must hold vports.lock */
+static struct mlx5_vport_table *
+esw_vport_tbl_lookup(struct mlx5_eswitch *esw, struct mlx5_vport_key *skey, u32 key)
+{
+	struct mlx5_vport_table *e;
+
+	hash_for_each_possible(esw->fdb_table.offloads.vports.table, e, hlist, key)
+		if (!memcmp(&e->key, skey, sizeof(*skey)))
+			return e;
+
+	return NULL;
+}
+
+static void
+esw_vport_tbl_put(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
+{
+	struct mlx5_vport_table *e;
+	struct mlx5_vport_key key;
+	u32 hkey;
+
+	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	hkey = flow_attr_to_vport_key(esw, attr, &key);
+	e = esw_vport_tbl_lookup(esw, &key, hkey);
+	if (!e || --e->num_rules)
+		goto out;
+
+	hash_del(&e->hlist);
+	mlx5_destroy_flow_table(e->fdb);
+	kfree(e);
+out:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+}
+
+static struct mlx5_flow_table *
+esw_vport_tbl_get(struct mlx5_eswitch *esw, struct mlx5_esw_flow_attr *attr)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_flow_table *fdb;
+	struct mlx5_vport_table *e;
+	struct mlx5_vport_key skey;
+	u32 hkey;
+
+	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	hkey = flow_attr_to_vport_key(esw, attr, &skey);
+	e = esw_vport_tbl_lookup(esw, &skey, hkey);
+	if (e) {
+		e->num_rules++;
+		goto out;
+	}
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e) {
+		fdb = ERR_PTR(-ENOMEM);
+		goto err_alloc;
+	}
+
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
+	if (!ns) {
+		esw_warn(dev, "Failed to get FDB namespace\n");
+		fdb = ERR_PTR(-ENOENT);
+		goto err_ns;
+	}
+
+	fdb = esw_vport_tbl_create(esw, ns);
+	if (IS_ERR(fdb))
+		goto err_ns;
+
+	e->fdb = fdb;
+	e->num_rules = 1;
+	e->key = skey;
+	hash_add(esw->fdb_table.offloads.vports.table, &e->hlist, hkey);
+out:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+	return e->fdb;
+
+err_ns:
+	kfree(e);
+err_alloc:
+	mutex_unlock(&esw->fdb_table.offloads.vports.lock);
+	return fdb;
+}
+
+int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_flow_attr attr = {};
+	struct mlx5_eswitch_rep rep = {};
+	struct mlx5_flow_table *fdb;
+	struct mlx5_vport *vport;
+	int i;
+
+	attr.prio = 1;
+	attr.in_rep = &rep;
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		attr.in_rep->vport = vport->vport;
+		fdb = esw_vport_tbl_get(esw, &attr);
+		if (!fdb)
+			goto out;
+	}
+	return 0;
+
+out:
+	mlx5_esw_vport_tbl_put(esw);
+	return PTR_ERR(fdb);
+}
+
+void mlx5_esw_vport_tbl_put(struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_flow_attr attr = {};
+	struct mlx5_eswitch_rep rep = {};
+	struct mlx5_vport *vport;
+	int i;
+
+	attr.prio = 1;
+	attr.in_rep = &rep;
+	mlx5_esw_for_all_vports(esw, i, vport) {
+		attr.in_rep->vport = vport->vport;
+		esw_vport_tbl_put(esw, &attr);
+	}
+}
+
+/* End: Per vport tables */
+
 static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 						     u16 vport_num)
 {
@@ -191,8 +364,6 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		i++;
 	}
 
-	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
-
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 	if (attr->inner_match_level != MLX5_MATCH_NONE)
@@ -201,8 +372,13 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
 
-	fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
-					!!split);
+	if (split) {
+		fdb = esw_vport_tbl_get(esw, attr);
+	} else {
+		fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
+						0);
+		mlx5_eswitch_set_rule_source_port(esw, spec, attr);
+	}
 	if (IS_ERR(fdb)) {
 		rule = ERR_CAST(fdb);
 		goto err_esw_get;
@@ -221,7 +397,10 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	return rule;
 
 err_add_rule:
-	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, !!split);
+	if (split)
+		esw_vport_tbl_put(esw, attr);
+	else
+		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 err_esw_get:
 	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) && attr->dest_chain)
 		mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
@@ -247,7 +426,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 		goto err_get_fast;
 	}
 
-	fwd_fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio, 1);
+	fwd_fdb = esw_vport_tbl_get(esw, attr);
 	if (IS_ERR(fwd_fdb)) {
 		rule = ERR_CAST(fwd_fdb);
 		goto err_get_fwd;
@@ -285,7 +464,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	return rule;
 add_err:
-	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 1);
+	esw_vport_tbl_put(esw, attr);
 err_get_fwd:
 	mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 err_get_fast:
@@ -312,11 +491,14 @@ __mlx5_eswitch_del_rule(struct mlx5_eswitch *esw,
 	atomic64_dec(&esw->offloads.num_flows);
 
 	if (fwd_rule)  {
-		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 1);
+		esw_vport_tbl_put(esw, attr);
 		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio, 0);
 	} else {
-		mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
-					  !!split);
+		if (split)
+			esw_vport_tbl_put(esw, attr);
+		else
+			mlx5_esw_chains_put_table(esw, attr->chain, attr->prio,
+						  0);
 		if (attr->dest_chain)
 			mlx5_esw_chains_put_table(esw, attr->dest_chain, 1, 0);
 	}
@@ -1923,6 +2105,9 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_fg_err;
 
+	mutex_init(&esw->fdb_table.offloads.vports.lock);
+	hash_init(esw->fdb_table.offloads.vports.table);
+
 	return 0;
 
 create_fg_err:
@@ -1939,6 +2124,7 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 
 static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 {
+	mutex_destroy(&esw->fdb_table.offloads.vports.lock);
 	esw_destroy_vport_rx_group(esw);
 	esw_destroy_offloads_table(esw);
 	esw_destroy_offloads_fdb_tables(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 4276194b633f..883c9e6ff0b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -21,8 +21,6 @@
 #define fdb_ignore_flow_level_supported(esw) \
 	(MLX5_CAP_ESW_FLOWTABLE_FDB((esw)->dev, ignore_flow_level))
 
-#define ESW_OFFLOADS_NUM_GROUPS  4
-
 /* Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
  * and a virtual memory region of 16M (ESW_SIZE), this region is duplicated
  * for each flow table pool. We can allocate up to 16M of each pool,
@@ -704,12 +702,9 @@ mlx5_esw_chains_open(struct mlx5_eswitch *esw)
 
 	/* Open level 1 for split rules now if prios isn't supported  */
 	if (!mlx5_esw_chains_prios_supported(esw)) {
-		ft = mlx5_esw_chains_get_table(esw, 0, 1, 1);
-
-		if (IS_ERR(ft)) {
-			err = PTR_ERR(ft);
+		err = mlx5_esw_vport_tbl_get(esw);
+		if (err)
 			goto level_1_err;
-		}
 	}
 
 	return 0;
@@ -725,7 +720,7 @@ static void
 mlx5_esw_chains_close(struct mlx5_eswitch *esw)
 {
 	if (!mlx5_esw_chains_prios_supported(esw))
-		mlx5_esw_chains_put_table(esw, 0, 1, 1);
+		mlx5_esw_vport_tbl_put(esw);
 	mlx5_esw_chains_put_table(esw, 0, 1, 0);
 	mlx5_esw_chains_put_table(esw, mlx5_esw_chains_get_ft_chain(esw), 1, 0);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 9dc24241dc91..5826fd43d530 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2700,6 +2700,17 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 		goto out_err;
 	}
 
+	/* We put this priority last, knowing that nothing will get here
+	 * unless explicitly forwarded to. This is possible because the
+	 * slow path tables have catch all rules and nothing gets passed
+	 * those tables.
+	 */
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_PER_VPORT, 1);
+	if (IS_ERR(maj_prio)) {
+		err = PTR_ERR(maj_prio);
+		goto out_err;
+	}
+
 	set_prio_attrs(steering->fdb_root_ns);
 	return 0;
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 4cae16016b2b..a5cf5c76f348 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -84,6 +84,7 @@ enum {
 	FDB_TC_OFFLOAD,
 	FDB_FT_OFFLOAD,
 	FDB_SLOW_PATH,
+	FDB_PER_VPORT,
 };
 
 struct mlx5_pkt_reformat;
-- 
2.24.1

