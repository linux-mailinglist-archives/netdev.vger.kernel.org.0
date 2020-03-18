Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A57189426
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgCRCsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:43 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:62369
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRCsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sz4Iy1WjlN8Vz69J5QZh64gupOeRRwpeImPbFOmvvZQNPXE6eaSex5SPsRuVNeG7K8XFQgXvAIs5+PdTE+TjTwpW8yXJa4GXktnf/9Ajq2e8bLpjuMK4EyUdVjkUVHnV7fSTEtd4tv6U14r0JrOhx+wuOQMWc3m0vkbhqWIKJ786peX1OdUIWQqQWYWAbBEUIpbjNQ/6B44jAjTzpceAn4JParqiuC3dbbKrZ+SWHpHrrVpY9t8ubwhjgK2ZuZugnJFFazbxMgK/TT5pngXgVy2qXieWL/C6N01hDAUWfwMuh0Mtz2xPJi3Wni4Q57Ilw9zcKR+PFvnTGghCCUEEYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twLom/y7xxWgZw3YknjiyO4dVKvLwwDcSs2oSiDUYlA=;
 b=FVwOBH+P3+0Atn/NtVodQz3KmaH2304vP9pyysYkyG/HqB0ATg3/kjYRY6uEsUPya5ObXKK5kVvmcOrA0QRrm7kLkUfJ3sRhPLeiQUzX8NXpPUN7Pj/g6vk/pJKA00HQgQeDieRW4EsBWcfq6ed21nwUhPQLPe3s3iPuMqJmC4WP7If3CY0n4zeeqGd3lOXdY/aI2dzycSfQm/XysEDwNW8Df48unI9JN/kpEvLiFoBewJz00InNpsB5I8aLSQYXEJconbXkJ11asPPl1j4Jj7fXRwtadpzP5sMlj3VOSmO0jyheXSYP0yDpHSql5BjOLNcR+OpqZAzSAQoAf5z0Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twLom/y7xxWgZw3YknjiyO4dVKvLwwDcSs2oSiDUYlA=;
 b=Yf93v0Noas289qyXzsxBVOzDRcGOxQ8qddqEGx2kGWQLPA6lXXUno1iMMi6kw9yb+SLM5GJgpD/Co3QDYeMr/d9LXeMg/OEJZ6axmEDftbOR+dpBYrl8Sdaz7tSGGqaJ7RUrR72P8ymbODiZsAH8El3aB6rM1/Q3IbsK3UMlYso=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Eli Cohen <eli@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/14] net/mlx5e: Add support for offloading traffic from uplink to uplink
Date:   Tue, 17 Mar 2020 19:47:20 -0700
Message-Id: <20200318024722.26580-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:23 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bea4841f-d4b1-496f-428e-08d7cae6d42b
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41097B28AC8235E84E9C2D1EBEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrNhLxlx68o1x5+9pyr5iDrl0rFzi+Mn8k/DuXVjucURSYucLlH2mp4Y1+rssr4/21SCxzwC6pSEwQGY7mKuUG1TbWu030p4djJC/8POsq+fJxbOdFYcJnscsAjk4Ou3EY8v2lvoxLoTdzU5LW2WYusBueR5dHJmPRYpxNBR3FHMtnz82jFSUCf5zL6icyY8ZLrH3MJSOPrSXOfT5+9n8xhseGJqAXr8XuxhXmi8wC/iOfOMTfAnLT4XQKSCXD1+7bJltAo+e9+t+os12Sc0NbDeETMAX6FET0pE3G6b6yRp0un9s4SHlu0CzZkdw/wB2Wi2m5YV9IBXz9sxYyMg8VnxbpZvd81mDNLdBYdl7NpJYPueuPutRyMyd4Kx5aKR5foLZOXQetJx1KFvu5gb75MiVtQwlj9uzfmbTukB6JKXCdJMOYghWY9B6yooPf2lxd/EopFLsRy1GvXcdJVc2PqVDrNqRlSW6d71G99jlMzxstavBcVOzTxAtFCh41+zZxJrv8keJrVU3zXymjnf149TZoSSgYsFFuxYL4xujwU=
X-MS-Exchange-AntiSpam-MessageData: a0BNUCKcU69gpiSNaXpb2Yw6u4vvWOydy/xN2XPvcC+O2DtIAklhBGzoepx/mmsXm2IlEC7XJLinmKuxFd41pPXhtNEFeWPBzpEx53JMc7RG5+V+1ZK8FoEpVozkgWJFTTqxGzxnikLN9Gc38nAaIw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea4841f-d4b1-496f-428e-08d7cae6d42b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:24.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fbNB/UsGKKjbfe9KpFGDOs2+ylgcegUidgATh/Hj9DXHNaK6kqQXHpG/dTNxmpcM2YdZyCu6nv/DVpUzGJT2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Termination tables change the direction of a packet in hw from RX to SX
pipeline. Use that to offload hairpin flows received from uplink and
sent back to uplink.

Currently termination tables are used for pushing VLAN to packets
received from uplink and targeting a VF. Extend the implementation to
allow forwarding packets to uplink. These packets can either be
encapsulated or not.

In case encapsulation is needed before forwarding, move the reformat
object to the termination table as required.

Extend the hash table key to include tunnel information for the sake of
reusing reformat objects.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 97 +++++++++++++------
 1 file changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 4e76ddc4ef87..17a0d2bc102b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/fs.h>
 #include "eswitch.h"
+#include "fs_core.h"
 
 struct mlx5_termtbl_handle {
 	struct hlist_node termtbl_hlist;
@@ -28,6 +29,10 @@ mlx5_eswitch_termtbl_hash(struct mlx5_flow_act *flow_act,
 		     sizeof(dest->vport.num), hash);
 	hash = jhash((const void *)&dest->vport.vhca_id,
 		     sizeof(dest->vport.num), hash);
+	if (dest->vport.pkt_reformat)
+		hash = jhash(dest->vport.pkt_reformat,
+			     sizeof(*dest->vport.pkt_reformat),
+			     hash);
 	return hash;
 }
 
@@ -37,11 +42,19 @@ mlx5_eswitch_termtbl_cmp(struct mlx5_flow_act *flow_act1,
 			 struct mlx5_flow_act *flow_act2,
 			 struct mlx5_flow_destination *dest2)
 {
-	return flow_act1->action != flow_act2->action ||
-	       dest1->vport.num != dest2->vport.num ||
-	       dest1->vport.vhca_id != dest2->vport.vhca_id ||
-	       memcmp(&flow_act1->vlan, &flow_act2->vlan,
-		      sizeof(flow_act1->vlan));
+	int ret;
+
+	ret = flow_act1->action != flow_act2->action ||
+	      dest1->vport.num != dest2->vport.num ||
+	      dest1->vport.vhca_id != dest2->vport.vhca_id ||
+	      memcmp(&flow_act1->vlan, &flow_act2->vlan,
+		     sizeof(flow_act1->vlan));
+	if (ret)
+		return ret;
+
+	return dest1->vport.pkt_reformat && dest2->vport.pkt_reformat ?
+	       memcmp(dest1->vport.pkt_reformat, dest2->vport.pkt_reformat,
+		      sizeof(*dest1->vport.pkt_reformat)) : 0;
 }
 
 static int
@@ -62,7 +75,8 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	/* As this is the terminating action then the termination table is the
 	 * same prio as the slow path
 	 */
-	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION;
+	ft_attr.flags = MLX5_FLOW_TABLE_TERMINATION |
+			MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft_attr.prio = FDB_SLOW_PATH;
 	ft_attr.max_fte = 1;
 	ft_attr.autogroup.max_num_groups = 1;
@@ -74,7 +88,6 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 
 	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
-
 	if (IS_ERR(tt->rule)) {
 		esw_warn(dev, "Failed to create termination table rule\n");
 		goto add_flow_err;
@@ -92,7 +105,8 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 static struct mlx5_termtbl_handle *
 mlx5_eswitch_termtbl_get_create(struct mlx5_eswitch *esw,
 				struct mlx5_flow_act *flow_act,
-				struct mlx5_flow_destination *dest)
+				struct mlx5_flow_destination *dest,
+				struct mlx5_esw_flow_attr *attr)
 {
 	struct mlx5_termtbl_handle *tt;
 	bool found = false;
@@ -100,7 +114,6 @@ mlx5_eswitch_termtbl_get_create(struct mlx5_eswitch *esw,
 	int err;
 
 	mutex_lock(&esw->offloads.termtbl_mutex);
-
 	hash_key = mlx5_eswitch_termtbl_hash(flow_act, dest);
 	hash_for_each_possible(esw->offloads.termtbl_tbl, tt,
 			       termtbl_hlist, hash_key) {
@@ -122,6 +135,7 @@ mlx5_eswitch_termtbl_get_create(struct mlx5_eswitch *esw,
 	tt->dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	tt->dest.vport.num = dest->vport.num;
 	tt->dest.vport.vhca_id = dest->vport.vhca_id;
+	tt->dest.vport.flags = dest->vport.flags;
 	memcpy(&tt->flow_act, flow_act, sizeof(*flow_act));
 
 	err = mlx5_eswitch_termtbl_create(esw->dev, tt, flow_act);
@@ -156,25 +170,44 @@ mlx5_eswitch_termtbl_put(struct mlx5_eswitch *esw,
 	}
 }
 
+static bool mlx5_eswitch_termtbl_is_encap_reformat(struct mlx5_pkt_reformat *rt)
+{
+	switch (rt->reformat_type) {
+	case MLX5_REFORMAT_TYPE_L2_TO_VXLAN:
+	case MLX5_REFORMAT_TYPE_L2_TO_NVGRE:
+	case MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL:
+	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static void
 mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_act *src,
 				  struct mlx5_flow_act *dst)
 {
-	if (!(src->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH))
-		return;
-
-	src->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
-	dst->action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
-	memcpy(&dst->vlan[0], &src->vlan[0], sizeof(src->vlan[0]));
-	memset(&src->vlan[0], 0, sizeof(src->vlan[0]));
-
-	if (!(src->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2))
-		return;
+	if (src->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
+		src->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		dst->action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		memcpy(&dst->vlan[0], &src->vlan[0], sizeof(src->vlan[0]));
+		memset(&src->vlan[0], 0, sizeof(src->vlan[0]));
+
+		if (src->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
+			src->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
+			dst->action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
+			memcpy(&dst->vlan[1], &src->vlan[1], sizeof(src->vlan[1]));
+			memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
+		}
+	}
 
-	src->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
-	dst->action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
-	memcpy(&dst->vlan[1], &src->vlan[1], sizeof(src->vlan[1]));
-	memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
+	if (src->action & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
+	    mlx5_eswitch_termtbl_is_encap_reformat(src->pkt_reformat)) {
+		src->action &= ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		dst->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		dst->pkt_reformat = src->pkt_reformat;
+		src->pkt_reformat = NULL;
+	}
 }
 
 static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
@@ -199,13 +232,23 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
+	int i;
+
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table) ||
-	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
+	    attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH ||
+	    !mlx5_eswitch_offload_is_uplink_port(esw, spec))
 		return false;
 
 	/* push vlan on RX */
-	return (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) &&
-		mlx5_eswitch_offload_is_uplink_port(esw, spec);
+	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)
+		return true;
+
+	/* hairpin */
+	for (i = attr->split_count; i < attr->out_count; i++)
+		if (attr->dests[i].rep->vport == MLX5_VPORT_UPLINK)
+			return true;
+
+	return false;
 }
 
 struct mlx5_flow_handle *
@@ -235,7 +278,7 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 
 		/* get the terminating table for the action list */
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
-						     &dest[i]);
+						     &dest[i], attr);
 		if (IS_ERR(tt)) {
 			esw_warn(esw->dev, "Failed to create termination table\n");
 			goto revert_changes;
-- 
2.24.1

