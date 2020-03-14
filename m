Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6241F1853C8
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgCNBRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:20 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgCNBRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYkvstZC2f63mO/CUQqaBwM6iVMC/3zKJwZiWVgJXlL+smYTGrbPRIvmdMI3EAsIoQhBlc7f4Yr5qnkmdFhdv+TMkorblkcqIqfOAZmKogezvir1asoG/sg+SeF47sett6RIRQIlAQT1zUAl4zDf5LRD5nXQXql8eocLFAJ/HmEPO4V6mkPmC14gTNB4lWYG36HRz70oTeW6xdZnGJqPghkJeYlyEbxh2Wr6GLX5pWzom7tgM+6PxDfmYV7i6QUCPoRRtVB4vwQZie9GSIuGicT85+Rt2ob2tSKpP82MlhfLTppr1XS1lF900I+KrVDDPLexWSopNcBNzKhawu2i4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4ZcdsKfI17pgTxQNNk5ndi1tUI3edtVUlH6K+DPQ58=;
 b=BkKGYTj7pnKnUX5UmPvGgchze1P91SGUXDvaziaAWWXqeU+zPP6Umh0pULFCmAgaM15YsqwRT/OUryKwjJOpM3pj9IRC+nqAb0wKQYqpeNTfAKlj1IKtNqH48FcOLqalAlLdrbY/9keSi4QA95w3PKPXWbdV6JaBvtjfnjXdgJVUr/HA0JnQitmPaLj6CmRAwj82iXCIFebHWeSbVrLUNO3MxupqFb6w4yvEN/EcZg7RNf5kupYnPwah59kkc5l4E2chX7ja5TePoezYHSO7D2q1kSqpwNCenWeGKdJKggJMWQH9Cb8mNmTkLdZmpTxBQJvjTH0XKM4F5r8e6Tf9RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4ZcdsKfI17pgTxQNNk5ndi1tUI3edtVUlH6K+DPQ58=;
 b=FOU9WArZN8oo+navLrzGqSPZtqr07thd/CFG6YmO5W/KNh1J2qzhYSA5K2qYVJQq/dHZCc7jXXsQCpK/BbS1VYRM79VeXGkQCJkXyeVsDFZsDbFX/rZVue7PVGbec/ZE+SUgZ4VuQGZuzygHm+4XojEB9EAHGXv2iq5PKe5Q3Os=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/14] net/mlx5: DR, Add support for flow table id destination action
Date:   Fri, 13 Mar 2020 18:16:21 -0700
Message-Id: <20200314011622.64939-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:11 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6996157e-f5a0-43d7-03f8-08d7c7b56d3b
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845FD6A8C3981DC9CD8DD54BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRdm77ad91pkOmddFipub+ByjtRnLbvi4GNGg15P6aQbfn+Ovzte4n8htd6GaUKNtERBI2QCCxQbe8uFcHRLUVwEZzafSzVa3jQZJL+D9wqRevxPIWHyNtDaAEM7MSmd5W1fGZz6ZziSv61AYx4BAIx7YtZWBPOrB6wKFthhirf/BrhBvkwIDlvwqbLDzjGsSl/yfVMbmmfr/aTh0W7I8K8viA5YusJU6IBTJMfyG7qWmS9AewX8BJH5FevZn/tjM1ZuiAHutVGVoiz9qD+tAAdjXHnIm4ucAzuDiAMf3Xv0UZlcjZTyXPL02VINShhKyzZ7ikDMMkIsVkkG9zd1lqK7gHjWiiKpAdPKeGGaSePtjjvVNwNMt0FlmtFwnJcaOYXbQxWJphpsQVY2pGgzQttqAFsbw3UZW7cleJuFYQmXp+AwvUYTMjTCTr0iKWnt+dz6a4zctqyfk9VaqFKYQHRNagqWgfNLydq6BwzwtOs+ZBnhha8TCUNJrvVFfKZdqFP8TOgjwnZt23mcO2gZnX8QoyvI7N6A8TTV72wkAIc=
X-MS-Exchange-AntiSpam-MessageData: ptXkoQfDueoIkHWg3/6/A6jjK+1nP0YsxfJ8rp6hQ62Q4lMgfbl/DipHSW0hZ3QO/dL12JUxH72BaDnFsnWjbk8lhRCnTFdo6es5SEy5MJHYrqxNd1lXDg+uOgm+FkpNDQbkQck5AjC30DgNzNHOlw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6996157e-f5a0-43d7-03f8-08d7c7b56d3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:13.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJTHmsP8pcdOc+qlnG2Froz1pAOym1mqW/95WAJwtpt/bUtlYLCQ+NzJtt3sltw32/eaAa8r2X3dbqlOy0bMfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

This action allows to go to a flow table based on the table id.
Goto flow table id is required for supporting user space SW.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c    | 18 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/fs_dr.c        | 12 ++++++++++++
 .../mellanox/mlx5/core/steering/mlx5dr.h       |  3 +++
 3 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index f899da9f8488..4b323a7ae794 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -964,6 +964,24 @@ struct mlx5dr_action *mlx5dr_action_create_drop(void)
 	return dr_action_create_generic(DR_ACTION_TYP_DROP);
 }
 
+struct mlx5dr_action *
+mlx5dr_action_create_dest_table_num(struct mlx5dr_domain *dmn, u32 table_num)
+{
+	struct mlx5dr_action *action;
+
+	action = dr_action_create_generic(DR_ACTION_TYP_FT);
+	if (!action)
+		return NULL;
+
+	action->dest_tbl.is_fw_tbl = true;
+	action->dest_tbl.fw_tbl.dmn = dmn;
+	action->dest_tbl.fw_tbl.id = table_num;
+	action->dest_tbl.fw_tbl.type = FS_FT_FDB;
+	refcount_inc(&dmn->refcount);
+
+	return action;
+}
+
 struct mlx5dr_action *
 mlx5dr_action_create_dest_table(struct mlx5dr_table *tbl)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index d12d3a2d46ab..3b3f5b9d4f95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -384,6 +384,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		list_for_each_entry(dst, &fte->node.children, node.list) {
 			enum mlx5_flow_destination_type type = dst->dest_attr.type;
+			u32 ft_id;
 
 			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
 			    num_term_actions >= MLX5_FLOW_CONTEXT_ACTION_MAX) {
@@ -420,6 +421,17 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 
 				num_term_actions++;
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
+				ft_id = dst->dest_attr.ft_num;
+				tmp_action = mlx5dr_action_create_dest_table_num(domain,
+										 ft_id);
+				if (!tmp_action) {
+					err = -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+				term_actions[num_term_actions++].dest = tmp_action;
+				break;
 			default:
 				err = -EOPNOTSUPP;
 				goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index e09e4ea1b045..1ee10e3e0d52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -76,6 +76,9 @@ int mlx5dr_rule_destroy(struct mlx5dr_rule *rule);
 int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 				 struct mlx5dr_action *action);
 
+struct mlx5dr_action *
+mlx5dr_action_create_dest_table_num(struct mlx5dr_domain *dmn, u32 table_num);
+
 struct mlx5dr_action *
 mlx5dr_action_create_dest_table(struct mlx5dr_table *table);
 
-- 
2.24.1

