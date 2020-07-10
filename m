Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDD121ADA8
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgGJDr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:59 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGJDr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWls1Yom2EN47fY3aATLlf5quDpNo7ROlja77qokWrnOMZKfiOkbyNZVMJXgc04hGE6r/1vDvKc3A9yR90UUcuYAHpL2QZ+q8NCAXGB7pkUA3vpCvnpEI6u+U8f9g1bjUV/KquUJI4AV4VxfVCGver9+F0nekoxL3G75P3SmqpolHRipABZfG3qRaye3kw/FzYJ4p1cTh+kjbVYi9mPc7UzI7ggrHz11POcewqP0MGXV9tp+uTb5CBIxVQUkstjUD2AtaVdrGv1mJ7FCBwA8rBaVRRyUkqJAVqoVV/CpEv9TA9gLvwh3TakaQTJ+AvGGFZgvoFZIV5yUgpptBp35Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHjAS7Roi/0ZvVRkaSwqIomN4tH9lS4zRjPj8uTcNK4=;
 b=jS+yIZD467wEqsMUwOM8a3bfIVtLrGYptxR8SuO+3471gvAwIoeh4tNnFzXbSGti66RJPQlGJ6IXZPorLLo+UT7bOYuJ79ko3goaM++JsUYNef5OqlZQoOg6iOIOsjm4nBOBbXthzp4dCDJ8RRltAFramImjZUPk3mfz8+8AzAPItnr4idrobVc3LIDQpEUxa2SeU+VHF10pJBdYDAVUF6Y3uwbn4YJTJxL0eistr2k7MNyvdcNb6q2u2FpeV8lyPHehyt45DMZgLoZDyRxj9v0SMVeFPJNkI3FBOmz4+zQn5Pedi9jJQ0QIQl0jX2BdD3W5PSED7ODFcp2RJj7MbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHjAS7Roi/0ZvVRkaSwqIomN4tH9lS4zRjPj8uTcNK4=;
 b=gX3HvEHp5yXvhutyaPpWt5MDUaKOcFwNqZG4r8bwOpNEFi9rlqOmCHpxZN0tT6VrPPqkOW0eWeMGVjgg/337NblA1jb0YPUOHHlEbAs/17Nx3ZOTOq5ArpIftFNcoRPOlD/UkUEWcV/S3MQrVz85Ikhb+rLpwbd2JWiggCY1CTw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/13] net/mlx5e: CT: Don't offload tuple rewrites for established tuples
Date:   Thu,  9 Jul 2020 20:44:24 -0700
Message-Id: <20200710034432.112602-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19170dc5-15d0-4e88-ef4b-08d8248404d0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512BC91EB6266B671525478BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9e1twtS2N1bNSkJO54bhx6gpolXQAARaiILiCXzkjbxZzz0TRfXKXqazNrDots9FrkxQOvFzpznXCYhSQRcLuGGWl0gaVaKFi2YGH+7qA2hlvhFLc7AfZyXW3HCSCdNryW1HKJxrN4gx8g6JnMHfVjQe0jVlZbV4EKLr3l3ER1Pz7wvE/mj3y3hBtnv5ni3Rn9ZX7wXIbJi/MGvSc3bzP4sH95eDo9f1cIZf6OseSlldov1hONCarwlzTGpyhfdV/DaHdG38Lr/UcNXkhqu6+Zbj4lMExmHofxlujjqujJI5K6bUOD2660f2l3C1IQoqXkC/Z3GxyW/hMPiRU1re62U8n9vKT25S3ZjY8fdkJtmdE5iLP/KLTIxHH3ZtY6K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hucCl59GOICppCeisLTldScEKy4EqRffjD/EWNdPUt7Lo/7f8/VLkhTdIHSZFwwUoNwGNKfljZdKv9e72GJhse8bU9ycdN+d82PZZf/PKNtTW3CpBjRyzUekmh3zaeweOE61KN32JgKbjR5fn//Uz8MzoVujSrxXrUIC7hModuLvWX6eArVqbVk4K45sOJEGU8WPKNF7MZIhp5XNUIY05ZmATrKIkBsy9TNuzdI6niIwVzC7FZNGGD4luSlgmvjeu5vmp5RCE9EaBuaRIbZLvaT+m5hKyROU6gxl1RX7/R+QpzP/3L1dcq9mtsgSKlMrkai1axQTjCYuOd4jNLF3vuqGKoK1tmj0An3/Wem932niOWzcSVjm0NJcLLozxsNr83eYsHMCA6biFRWzksjxhaUX8NkarVkyIXOiTC5UgenG1bQHDrSnEw82eSHQBOK9I6AJRlh4L2fBGyI92dD/c+fW7HZWK8RjIYTYVxGc5/Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19170dc5-15d0-4e88-ef4b-08d8248404d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:51.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLQzMtbmz4ekrzz2dzIK9aA5rTxYRJKvaUoAQlCFM/bpVxtatbHQJojRZKt8kVDE8ZpGZl2u7y3b24q2HIhVDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Next patches will remove the tupleid registers that is used
to restore the ct state on miss, and instead use the tuple on
the missed packet to lookup which state to restore.
Disable tuple rewrites after connection tracking.

For tuple rewrites, inject a ct_state=-trk match so it won't
change the tuple for established flows (+trk) that passed connection
tracking, and instead miss to software.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 18 +++++
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    | 10 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 74 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  5 ++
 4 files changed, 95 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 55402b1739ae..08ebce35b2fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -894,6 +894,24 @@ mlx5_tc_ct_block_flow_offload(enum tc_setup_type type, void *type_data,
 	return -EOPNOTSUPP;
 }
 
+int
+mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
+			    struct mlx5_flow_spec *spec)
+{
+	u32 ctstate = 0, ctstate_mask = 0;
+
+	mlx5e_tc_match_to_reg_get_match(spec, CTSTATE_TO_REG,
+					&ctstate, &ctstate_mask);
+	if (ctstate_mask)
+		return -EOPNOTSUPP;
+
+	ctstate_mask |= MLX5_CT_STATE_TRK_BIT;
+	mlx5e_tc_match_to_reg_match(spec, CTSTATE_TO_REG,
+				    ctstate, ctstate_mask);
+
+	return 0;
+}
+
 int
 mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 626f6c04882e..94f74cf71ce4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -91,6 +91,9 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f,
 		       struct netlink_ext_ack *extack);
 int
+mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
+			    struct mlx5_flow_spec *spec);
+int
 mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 			struct mlx5_esw_flow_attr *attr,
 			const struct flow_action_entry *act,
@@ -140,6 +143,13 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+mlx5_tc_ct_add_no_trk_match(struct mlx5e_priv *priv,
+			    struct mlx5_flow_spec *spec)
+{
+	return 0;
+}
+
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 			struct mlx5_esw_flow_attr *attr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a6cb5d81f08b..fd984ef234b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -219,6 +219,28 @@ mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 }
 
+void
+mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
+				enum mlx5e_tc_attr_to_reg type,
+				u32 *data,
+				u32 *mask)
+{
+	int soffset = mlx5e_tc_attr_to_reg_mappings[type].soffset;
+	int match_len = mlx5e_tc_attr_to_reg_mappings[type].mlen;
+	void *headers_c = spec->match_criteria;
+	void *headers_v = spec->match_value;
+	void *fmask, *fval;
+
+	fmask = headers_c + soffset;
+	fval = headers_v + soffset;
+
+	memcpy(mask, fmask, match_len);
+	memcpy(data, fval, match_len);
+
+	*mask = be32_to_cpu((__force __be32)(*mask << (32 - (match_len * 8))));
+	*data = be32_to_cpu((__force __be32)(*data << (32 - (match_len * 8))));
+}
+
 int
 mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
@@ -3086,6 +3108,7 @@ struct ipv6_hoplimit_word {
 
 static int is_action_keys_supported(const struct flow_action_entry *act,
 				    bool ct_flow, bool *modify_ip_header,
+				    bool *modify_tuple,
 				    struct netlink_ext_ack *extack)
 {
 	u32 mask, offset;
@@ -3108,7 +3131,10 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 			*modify_ip_header = true;
 		}
 
-		if (ct_flow && offset >= offsetof(struct iphdr, saddr)) {
+		if (offset >= offsetof(struct iphdr, saddr))
+			*modify_tuple = true;
+
+		if (ct_flow && *modify_tuple) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't offload re-write of ipv4 address with action ct");
 			return -EOPNOTSUPP;
@@ -3123,16 +3149,22 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 			*modify_ip_header = true;
 		}
 
-		if (ct_flow && offset >= offsetof(struct ipv6hdr, saddr)) {
+		if (ct_flow && offset >= offsetof(struct ipv6hdr, saddr))
+			*modify_tuple = true;
+
+		if (ct_flow && *modify_tuple) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't offload re-write of ipv6 address with action ct");
 			return -EOPNOTSUPP;
 		}
-	} else if (ct_flow && (htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP ||
-			       htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload re-write of transport header ports with action ct");
-		return -EOPNOTSUPP;
+	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP ||
+		   htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP) {
+		*modify_tuple = true;
+		if (ct_flow) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "can't offload re-write of transport header ports with action ct");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
@@ -3142,10 +3174,11 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 					  struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
 					  u32 actions, bool ct_flow,
+					  bool ct_clear,
 					  struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry *act;
-	bool modify_ip_header;
+	bool modify_ip_header, modify_tuple;
 	void *headers_c;
 	void *headers_v;
 	u16 ethertype;
@@ -3162,17 +3195,32 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 		goto out_ok;
 
 	modify_ip_header = false;
+	modify_tuple = false;
 	flow_action_for_each(i, act, flow_action) {
 		if (act->id != FLOW_ACTION_MANGLE &&
 		    act->id != FLOW_ACTION_ADD)
 			continue;
 
 		err = is_action_keys_supported(act, ct_flow,
-					       &modify_ip_header, extack);
+					       &modify_ip_header,
+					       &modify_tuple, extack);
 		if (err)
 			return err;
 	}
 
+	/* Add ct_state=-trk match so it will be offloaded for non ct flows
+	 * (or after clear action), as otherwise, since the tuple is changed,
+	 *  we can't restore ct state
+	 */
+	if (!ct_clear && modify_tuple &&
+	    mlx5_tc_ct_add_no_trk_match(priv, spec)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can't offload tuple modify header with ct matches");
+		netdev_info(priv->netdev,
+			    "can't offload tuple modify header with ct matches");
+		return false;
+	}
+
 	ip_proto = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol);
 	if (modify_ip_header && ip_proto != IPPROTO_TCP &&
 	    ip_proto != IPPROTO_UDP && ip_proto != IPPROTO_ICMP) {
@@ -3216,7 +3264,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		return modify_header_match_supported(priv, &parse_attr->spec,
 						     flow_action, actions,
-						     ct_flow, extack);
+						     ct_flow, ct_clear,
+						     extack);
 
 	return true;
 }
@@ -4483,11 +4532,12 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack, filter_dev);
+	/* actions validation depends on parsing the ct matches first */
+	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f, extack);
 	if (err)
 		goto err_free;
 
-	err = mlx5_tc_ct_parse_match(priv, &parse_attr->spec, f, extack);
+	err = parse_tc_fdb_actions(priv, &rule->action, flow, extack, filter_dev);
 	if (err)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1561eaa89ffd..68d49b945184 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -164,6 +164,11 @@ void mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 				 u32 data,
 				 u32 mask);
 
+void mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
+				     enum mlx5e_tc_attr_to_reg type,
+				     u32 *data,
+				     u32 *mask);
+
 int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  int namespace,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
-- 
2.26.2

