Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3221E52CD
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgE1BSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:18:12 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:6231
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbgE1BSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUF70UbQSnO2NMxzLST0cz9xLCZBy5S7YI/AfRg0h79tW+IyRQLYZfQQQopVJfR6t6mx3B8X5B4RDl0bzA9VrWBxNHSST6zwY3eYpthZI+PFLAbixL6L62I0O5ZtOOETzX2NSS7xUOU892nihbbe/ZFsO+FEp/qeSpMscyGIgGARIdC4g84sNjwBZkLUzyyTkB4tQxodf4IDBCi6QVivCoTYrYBusKwHkAXdZ4RuSp4WhfjATW6FbnqUT3LcR29s8YKjirVsXT4G88ov+yEowPXg4lizPmyJjmxwvmudxLL5aVwgiBbnpVe9ghTHsqhrYLhYaAWlYv+MnlOfuXFlhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5jv1coGLOcN4ZC3zHRB4Rb8XVO0zNaRQFJ70ZfVQLM=;
 b=az/YrIbT9CCBtZVWcqaq1q9Ajxyx8cToXQ2oRdGgdbkC+qG58wNf1WmfkrWOhyabuEsBFaHCuf/Oc70rxNr3AEcenIn/PA7dp+O/rWQ0PL7TyewlI2WtU5vijgTTDPIS/GH//yj2bkNuYkkEMz5rJaJLlfsNr5X+fyruuFmMQL7WKp7sH2n4zaLckkPUI1ba8Yeh8SfOnJ+yNhM+Ivk6vebe0P9XH1Ay62kDWJHTHc6pevLg8Y4AWN/8u0r6n4wzdJChrjnXRloWVf9lx8uaPvoLQcI0wBzPCZ5debs/ocpRcy3GVn6ThT4JdlkVmkjpCASaQpeV/7Bh5TrCguUh+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5jv1coGLOcN4ZC3zHRB4Rb8XVO0zNaRQFJ70ZfVQLM=;
 b=WEgOyrIIJstMXVRBVtTADCgbtHAk8rwzt+ELKcAwmWn28qVDcQ2b5y3sEnP2m+fUm+erun3irNUePAcJ/KQ/4ddAv1IOp2LJS65B0AVH/YhPPadnWUVd/Eqff2XtuiMJWHXIOY0vqvK2i1C3a/CMqGDWmZgGoyjaLCy45jtwjJg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 08/15] net/mlx5: E-Switch, Alloc and free unique metadata for match
Date:   Wed, 27 May 2020 18:16:49 -0700
Message-Id: <20200528011656.559914-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13089c19-e435-4396-790d-08d802a4ec91
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB436895DCE4FC256ACC9DC08DBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzUAVDyTHfxJFqW0JPDe/9wW9rpgo76peqks2a1vd7txoAtNwNnuMIsqcyW+Cn8qn8x0uFf1CvewZmb1XUozXQtLdpf5l/TEHpmETW+W2r139xKAZ/Xk3IHn2UoNjfgcjWD04zF9htB1reej8n2qYFSAGELPzUVLSPcRJNillva2SH/D0BuJJTlZyb/18zHDe4RBbfOJuw5wqIDNnzx08wKr8xkFPcDFg1MKsIiTCHbuxTm+u+Zb2hl/ZPkh+K4bK8pmHm4mIOrGcqVstX0/P3AKnEjjKxzXmJ3cTBqE/5qV6M1MvBPn1PUciTDt34byMx1Danch0Tnepa7Nzrpcu5+IxZ5880zQqNGpttS8iuAFTyOkWMQV/5w8gJ8KoI9k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lBcg9gsbIGyK3NbLDAamurmYA/4unNJD/vO7qKwW6V8JoBBCCt1C0jWL0wJ1TT0S2eT7wbWwWTnZIBLWSus7GcAM+MA+4YV0TYD5QV4o8+Ubb0IMPjnuxFad1QuPhQ5JbFbCgn6zrAI3Oc/EW+YHyOzyYTKAfV0YfLJjfh3Ja6K2roug2RLEUgxWd+R6orsxwsMA2/Fw/jfxLVQLIso0I6Pk/4nFYg1fi6txwgKYqJOV2qij8zoNCYGnoE6gW86EHVrPsL8MLtoZbSav6D3HFAR2LkeH37bzHUS9/hPEA1WnxCcbmMkyCzVd/Azh8zZ4wiw4F7fyjzkUIo6u2tdQHq8+FeDhM7UPPoB42PeqX6BmOP83Ec6fV0X522bSeS4BGicMxQfr/W1203yoIr3oCFQ9wxY70P5ldHtzUNO6avER55wcmP19GPi3LhfQfZwWFTpO2F9bKcUBdVXsMC28a3FA5v7nLiJbe7RptmkoSu8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13089c19-e435-4396-790d-08d802a4ec91
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:44.3331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5dwfOGrdlr+hUxBiGCC7wAKbQgLrw540vJMA/7sb/FWXeID2IMgpW63kI6VMzOsbb+HjG0ujkECmPswrvJxbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Introduce infrastructure to create unique metadata for match
for vport without depending on vport_num. Vport uses its
default metadata for match in standalone configuration but
will share a different unique "bond_metadata" for match with
other vports in bond configuration.

Using ida to generate unique metadata for match for vports
in default and bond configurations.

Introduce APIs to generate, free metadata for match.
Introduce APIs to set vport's bond_metadata and replace its
ingress acl rules with bond_metatada.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c | 29 ++++++
 .../mellanox/mlx5/core/esw/acl/ofld.h         |  2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 96 ++++++++++++-------
 5 files changed, 103 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 1bae549f3fa7..4e55d7225a26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -291,3 +291,32 @@ void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw,
 	esw_acl_ingress_ofld_groups_destroy(vport);
 	esw_acl_ingress_table_destroy(vport);
 }
+
+/* Caller must hold rtnl_lock */
+int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_num,
+					   u32 metadata)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
+	int err;
+
+	if (WARN_ON_ONCE(IS_ERR(vport))) {
+		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
+		err = PTR_ERR(vport);
+		goto out;
+	}
+
+	esw_acl_ingress_ofld_rules_destroy(esw, vport);
+
+	vport->metadata = metadata ? metadata : vport->default_metadata;
+
+	/* Recreate ingress acl rules with vport->metadata */
+	err = esw_acl_ingress_ofld_rules_create(esw, vport);
+	if (err)
+		goto out;
+
+	return 0;
+
+out:
+	vport->metadata = vport->default_metadata;
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index 90ddc5d7da46..c57869b93d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -23,5 +23,7 @@ static inline bool mlx5_esw_acl_egress_fwd2vport_supported(struct mlx5_eswitch *
 /* Eswitch acl ingress external APIs */
 int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_num,
+					   u32 metadata);
 
 #endif /* __MLX5_ESWITCH_ACL_OFLD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 20ab13ff2303..1116ab9bea6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1730,6 +1730,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	mutex_init(&esw->offloads.decap_tbl_lock);
 	hash_init(esw->offloads.decap_tbl);
 	atomic64_set(&esw->offloads.num_flows, 0);
+	ida_init(&esw->offloads.vport_metadata_ida);
 	mutex_init(&esw->state_lock);
 	mutex_init(&esw->mode_lock);
 
@@ -1768,6 +1769,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw_offloads_cleanup_reps(esw);
 	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
+	ida_destroy(&esw->offloads.vport_metadata_ida);
 	mutex_destroy(&esw->offloads.mod_hdr.lock);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 7b6b3686b666..a5175e98c0b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -149,6 +149,8 @@ struct mlx5_vport {
 
 	struct vport_ingress    ingress;
 	struct vport_egress     egress;
+	u32                     default_metadata;
+	u32                     metadata;
 
 	struct mlx5_vport_info  info;
 
@@ -224,6 +226,7 @@ struct mlx5_esw_offload {
 	u8 inline_mode;
 	atomic64_t num_flows;
 	enum devlink_eswitch_encap_mode encap;
+	struct ida vport_metadata_ida;
 };
 
 /* E-Switch MC FDB table hash node */
@@ -292,6 +295,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 
+u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw);
+void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata);
+
 int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 			       u32 rate_mbps);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 11bc9cc1d5f0..060354bb211a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/idr.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
@@ -1877,15 +1878,69 @@ static bool esw_use_vport_metadata(const struct mlx5_eswitch *esw)
 	       esw_check_vport_match_metadata_supported(esw);
 }
 
+u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
+{
+	u32 num_vports = GENMASK(ESW_VPORT_BITS - 1, 0) - 1;
+	u32 vhca_id_mask = GENMASK(ESW_VHCA_ID_BITS - 1, 0);
+	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	u32 start;
+	u32 end;
+	int id;
+
+	/* Make sure the vhca_id fits the ESW_VHCA_ID_BITS */
+	WARN_ON_ONCE(vhca_id >= BIT(ESW_VHCA_ID_BITS));
+
+	/* Trim vhca_id to ESW_VHCA_ID_BITS */
+	vhca_id &= vhca_id_mask;
+
+	start = (vhca_id << ESW_VPORT_BITS);
+	end = start + num_vports;
+	if (!vhca_id)
+		start += 1; /* zero is reserved/invalid metadata */
+	id = ida_alloc_range(&esw->offloads.vport_metadata_ida, start, end, GFP_KERNEL);
+
+	return (id < 0) ? 0 : id;
+}
+
+void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
+{
+	ida_free(&esw->offloads.vport_metadata_ida, metadata);
+}
+
+static int esw_offloads_vport_metadata_setup(struct mlx5_eswitch *esw,
+					     struct mlx5_vport *vport)
+{
+	if (vport->vport == MLX5_VPORT_UPLINK)
+		return 0;
+
+	vport->default_metadata = mlx5_esw_match_metadata_alloc(esw);
+	vport->metadata = vport->default_metadata;
+	return vport->metadata ? 0 : -ENOSPC;
+}
+
+static void esw_offloads_vport_metadata_cleanup(struct mlx5_eswitch *esw,
+						struct mlx5_vport *vport)
+{
+	if (vport->vport == MLX5_VPORT_UPLINK || !vport->default_metadata)
+		return;
+
+	WARN_ON(vport->metadata != vport->default_metadata);
+	mlx5_esw_match_metadata_free(esw, vport->default_metadata);
+}
+
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
 	int err;
 
+	err = esw_offloads_vport_metadata_setup(esw, vport);
+	if (err)
+		goto metadata_err;
+
 	err = esw_acl_ingress_ofld_setup(esw, vport);
 	if (err)
-		return err;
+		goto ingress_err;
 
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err = esw_acl_egress_ofld_setup(esw, vport);
@@ -1897,6 +1952,9 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 
 egress_err:
 	esw_acl_ingress_ofld_cleanup(esw, vport);
+ingress_err:
+	esw_offloads_vport_metadata_cleanup(esw, vport);
+metadata_err:
 	return err;
 }
 
@@ -1906,6 +1964,7 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 {
 	esw_acl_egress_ofld_cleanup(vport);
 	esw_acl_ingress_ofld_cleanup(esw, vport);
+	esw_offloads_vport_metadata_cleanup(esw, vport);
 }
 
 static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
@@ -2571,38 +2630,11 @@ EXPORT_SYMBOL(mlx5_eswitch_vport_match_metadata_enabled);
 u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num)
 {
-	u32 vport_num_mask = GENMASK(ESW_VPORT_BITS - 1, 0);
-	u32 vhca_id_mask = GENMASK(ESW_VHCA_ID_BITS - 1, 0);
-	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
-	u32 val;
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
 
-	/* Make sure the vhca_id fits the ESW_VHCA_ID_BITS */
-	WARN_ON_ONCE(vhca_id >= BIT(ESW_VHCA_ID_BITS));
-
-	/* Trim vhca_id to ESW_VHCA_ID_BITS */
-	vhca_id &= vhca_id_mask;
-
-	/* Make sure pf and ecpf map to end of ESW_VPORT_BITS range so they
-	 * don't overlap with VF numbers, and themselves, after trimming.
-	 */
-	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) <
-		     vport_num_mask - 1);
-	WARN_ON_ONCE((MLX5_VPORT_ECPF & vport_num_mask) <
-		     vport_num_mask - 1);
-	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) ==
-		     (MLX5_VPORT_ECPF & vport_num_mask));
-
-	/* Make sure that the VF vport_num fits ESW_VPORT_BITS and don't
-	 * overlap with pf and ecpf.
-	 */
-	if (vport_num != MLX5_VPORT_UPLINK &&
-	    vport_num != MLX5_VPORT_ECPF)
-		WARN_ON_ONCE(vport_num >= vport_num_mask - 1);
-
-	/* We can now trim vport_num to ESW_VPORT_BITS */
-	vport_num &= vport_num_mask;
+	if (WARN_ON_ONCE(IS_ERR(vport)))
+		return 0;
 
-	val = (vhca_id << ESW_VPORT_BITS) | vport_num;
-	return val << (32 - ESW_SOURCE_PORT_METADATA_BITS);
+	return vport->metadata << (32 - ESW_SOURCE_PORT_METADATA_BITS);
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
-- 
2.26.2

