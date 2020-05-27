Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2218F1E3504
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgE0Bui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:38 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:61537
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727920AbgE0Buf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfAvEWci7ywbH0qAYoXkh/bn1D9VoOa6/izLEHN2KJyN/dUaeSmI5zDcbDCj379M21Vc1ggusM2CnOaXJ3ce31LExTsT5tS1bh8k/yqbJeMwFWHKD3odA7XJ0t/vvZ954CfmJfzr2CITuji/sFvZfkk/VYfty7JR1sIp+gHDiTy1Cabb/T6+3Sq2INMSnylk6a6gvE+28x1rZC8vNCs08H1Xs3dL9N2aR5xfGy5brZ7zjXasq2pmMLiTrYrTYrHZM0SllPbLpfv+pTxJV1tVWQ3An3XT0BzV+FmpqXIHuUFZAlZv7gUak6/lamUHx1n6G1jFnLUXx7Upu1HOyZ2Uwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5jv1coGLOcN4ZC3zHRB4Rb8XVO0zNaRQFJ70ZfVQLM=;
 b=TlRY4pYLaRawDitM/6jcbFUDPWGeHMBqCQbGMHQh90SA+ztBifVgMcW6Mt8uW/RgJsc6nyhn0tAF3ymKOPp7wtakbmsz6xbW/9jys1B2AwEHTDMIoWAhiBm13r8JfVEGnJbKW1bsdrnfQlhMiJFA1rKvK2tYAwdvszwEC0nIrkipkPti1aZogKCrtxkoOdOC1vUHCkHWXw8YO/sl2535IiCrQ7HURh4kav24GckQfjB4RvqGRwe5ovillhX8pTSTzkDc0TGYGYKq0DRkOlmU3IbS9yeR/e5PNGMEU9ZzfiBYGxrKcH5FLmZnrmK2kSvNAproFOdpX1FLjcqSJytP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5jv1coGLOcN4ZC3zHRB4Rb8XVO0zNaRQFJ70ZfVQLM=;
 b=jBO0u92/MracFU39Sqnd7jPXSgba2dQm4DVbdnQjUpurcuV5BiQ1wTMNBeM69HGjGERFOVW/B8Brq2acvyeetET+LwnIV/8vW0spK/m282CgUpHX5SwgJe9Uo0FCpEF+OVLbE690VGx9/oWZA6R4JQXKX+0gM9u5mExUQUIOmHU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/16] net/mlx5: E-Switch, Alloc and free unique metadata for match
Date:   Tue, 26 May 2020 18:49:16 -0700
Message-Id: <20200527014924.278327-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dde5efb9-9382-4f65-9e16-08d801e04b59
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6637109DE77A98063F82CF6EBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kjt5huN9dkTB5SLOwqSMADj9lZmMq12NqRYOXeXisQGlzMLhPnYnfQng4pzPWe/qUKv6lrNoE4F5vHzgqoP25NzkszsQzzUYp54uoHhp9dAoJ6sHEoSH5El/qQgsDsDnFNCv5uwHCC5JC1Sjf/bIbZAKOVtBq3lEex5VksyTDEasWKv8OohaSqQqHGYcBDZrRU7M4RnDNSspaTmxl7teqHcl2YWIsG8Yc2aMnHzQDYayXEGnXZV7QQyCPDqd1pBZEEEsWg5OdOyuLoydlVfVkoBqYyhuKKOaJcfzqmQH3MXzeZMOPXOTbvQCud2gj/ULxDiql8zPW85HPXgIvJbSvYpbNjuC+1S1hyareulIL+KZlNCZiMFIpmL3ZnU5idxr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0OvQ3MhG13AQjKDHPh47dLDux4cYz85QSg7/qC+JWlSlw6Yqocj/l38NuZO1kPIXspSX48vhSZ2+UymqgaiGv8wHuXBapfrQt4vKSZwEjfpLPO/DaMccz+2kcoMo7N5/EjtNA07o+wyp6DZJz2p5bZcqJEFDv7Gb2CxUhc+hNVq6bNv76BJ+KOS9BXF5yxIxNPtBfYBxJdLlHVu09xa94pBQdWERyJWb40wemti20v98xWbG8mUe3m4xEEA3tV48sv0dDGR4D5hJ/IWmRuFryZwjh+PeRm4SSS6Zk0zLhRVgwbOydUb0tNE2FcEaJ2uMr8y04pWUqKXa+NRD0HencYtVxIpoJqv2mgPB65TZ26wlnqDWYSUangFMhAPhT3zzmPlaV8vN4DjTbN2uoijo/2zr3ZJ64TiJSDMsBsElO1G8J39yNL3zi5gyVhirh1xJ9ekfgluKoiqesXxYFPPwz7O8wirKu2bTLgmlHsQrz3s=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde5efb9-9382-4f65-9e16-08d801e04b59
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:12.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Md9OLyrhevzpM2gSzUtHLEHnDkBC2WJszFN5SDbOQp7oeI4WZMWbNlJgf1Rt4YCx9k6t3nVc4mxv3i+ElDDwjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

