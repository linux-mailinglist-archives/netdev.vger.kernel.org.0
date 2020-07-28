Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F8C230633
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgG1JLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:17 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728451AbgG1JLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7supIg8fIGTf66C9vnsaw5C2/pUuD2eyST5K9SqdnegmpLa8Q39ZbTJ/r4QvYhdDtlwrvFgv+GEuwTPEOpn/3JO8mTAbZmr2Kja/1s8bj0Xoa9eCJfDVcFwtEPavsaVEW0RpefAmG+MIdHDDCeTWqsVuJj1utWaxo3RTTkV3aPXLfeeB2bjjtlJ9wvqhkqYyje1t5IgqRs5P2ODA2h7A7Fn3V3HAqBYa9Mso/6yPzstatRrEED5auuN7c5rfX8mwZQDtHpBpxUibgRI/tAlF2TF2hRsD0hPJg934/XaDuysP2SqjqfexG8FDcONlAO9ei7rCkzwijXtGW1r+wV28g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8EwSVx2YsOzHa0mWr3FT/EvFj9ZeD3uENoUnVK0Log=;
 b=GcL4/zLR57gbRtfv95x/ZdZoyZlaYsCX7T5/7y/fs0iw5jhn/hLbR5bgKZxE48eyy3uNvqMw3aghGq0WkQzpSRYjzUy7/YDTZn/O91KLCblh7Y7rPqAcpvNcJgVbYYgdyc3yV1fh8emh4GI2zbTTNU2LwFu7YkMnS5utXI04FSFzbvbluPJC0zdk6P8chAQD0v9e8xcuNaLa/wGlKri7PlS4QnZA4Q+XtjyZem3QWFTaKmx/EIanzkR+gCcYw/HkqjhguddcSwKZ3xEyMyz0WbpEI/li3ixKwcFOATaIeBvDY0wooQzMXv7vShSFLH6BtTyzVF321kGO5nfEl7yEWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8EwSVx2YsOzHa0mWr3FT/EvFj9ZeD3uENoUnVK0Log=;
 b=moXLk0ZRub0VrBUCuI1/TBpU8BDZTo9/zdAxbxNydh2rFnGxOROBLRFBOC6vviH9Olp/6xo7EDe3E8awaHzc7cJIkPn7c6fLXY5ECnO+TrlER6NnQ0xvJgHtIttcloHvKuAyN1UmAmuK5cr3YFrQEzaIibejW6tN8q4d8QCx/+E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/12] net/mlx5: Fix forward to next namespace
Date:   Tue, 28 Jul 2020 02:10:27 -0700
Message-Id: <20200728091035.112067-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cf70638-19aa-4586-72cb-08d832d62a61
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46388F84E38E5CE020392A03BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KA5yKFE4RyOqCpNikzCPdh5ZJXuh5jnnS4xE0nRL5hILg4CReRwpzoryEPtUFj07eFaRp6y+shrFA7vu5x+wg2JQglxYve/mhukNRN3HgSpbSPmHO5LfO2QbHUU5xDp4MVKdsq2v2wqXXKWBwIcdPaziLfxHzrJpo7oHRl3LTJ5R/BoGImt24eP6irA+7YN45zF64DXs5r/RVTcKBgDTEzccT4sHwO5D0Z6o59KcWBL8fJD+/MNClfTbuQY+4DQd1gCNiO8AFwYFJfOy4MJT1zT3G5qvQkDhvTQBuLMqlMbvgYoXbxp541yg11rUI07oHRcjPB/krc07xR/Wrucj9zTIYRGJyxBb7aqBE3DIWF4TRrSu3phPyPRsdOcZbx/Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UGE1UHOdTEmhkoSh8JpdAppsRqsdo8OuhTK/RAqbk8i90S6RmJstaGuPhKMaYvE0Ea5tU3XMlg2R0S04kou5SlQMzl+NA+iXiBz0tDCNB/pEK7tYgk8QIBR/eAMUExKNSX7y6DGXFvsezHYoAAwxUewYLJ9CVIYjXFGsbtLrDez3sLKDsc+Y5bf2dFcxPjGbsUTmBo+W/IvhpgbBAeNRLxPV8jIEiJsfXQq2Say5nR5e4w2dL6Em3/EWyk39O7tHax/q5b6cryobcwtyKbUmolO2WY5pV5cbfKPLtGhhAeMEADIYmyCugtLId160mOXytr0QuBAPx7pKQQIasKUG9qW7d4zwOg3ZOKNMpX158/j8bPA2bjpglr8SopnbJIrL4f1xueKrUa87I6YR+YX3zGxJQ84crjhEL7oL/uaGZogqYX9JzHNab2paS+wmIAbsY8bW5lA9iwjn6K9wd41dsVcuHPbJXaPrlj8WJXZzYGI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf70638-19aa-4586-72cb-08d832d62a61
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:09.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOK9mNqaaFLw1JVmq6PpZ4ONt5P7MOfCDS0MiSl8ARU77EuOAXvc1o8QEPBv2wQSzIZX+2gmd/SETu0L19LtHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

The steering tree is as follow (nic RX as example):
		   ---------
                   |root_ns|
		   ---------
			|
      	--------------------------------
    	|		|	       |
   ---------- 	   ----------      ---------
   |p(prio)0|	   |   p1   |      |   pn  |
   ----------	   ----------	   ---------
        |		|
 ----------------  ---------------
 |ns(e.g bypass)|  |ns(e.g. lag) |
 ----------------  ---------------
  |     |    |
----  ----  ----
|p0|  |p1|  |pn|
----  ----  ----
 |
----
|FT|
----

find_next_chained_ft(prio) returns the first flow table in the next
priority. If prio is a parent of a flow table then it returns the first
flow table in the next priority in the same namespace, else if prio
is parent of namespace, then it should return the first flow table
in the next namespace. Currently if the user requests to forward to
next namespace, the code calls to find_next_chained_ft with the prio
of the next namespace and not the prio of the namesapce itself.

Fixes: 9254f8ed15b6 ("net/mlx5: Add support in forward to namespace")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 28 ++++---------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 13e2fb79c21ae..2569bb6228b65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -797,7 +797,7 @@ static struct mlx5_flow_table *find_closest_ft_recursive(struct fs_node  *root,
 	return ft;
 }
 
-/* If reverse if false then return the first flow table in next priority of
+/* If reverse is false then return the first flow table in next priority of
  * prio in the tree, else return the last flow table in the previous priority
  * of prio in the tree.
  */
@@ -829,34 +829,16 @@ static struct mlx5_flow_table *find_prev_chained_ft(struct fs_prio *prio)
 	return find_closest_ft(prio, true);
 }
 
-static struct fs_prio *find_fwd_ns_prio(struct mlx5_flow_root_namespace *root,
-					struct mlx5_flow_namespace *ns)
-{
-	struct mlx5_flow_namespace *root_ns = &root->ns;
-	struct fs_prio *iter_prio;
-	struct fs_prio *prio;
-
-	fs_get_obj(prio, ns->node.parent);
-	list_for_each_entry(iter_prio, &root_ns->node.children, node.list) {
-		if (iter_prio == prio &&
-		    !list_is_last(&prio->node.children, &iter_prio->node.list))
-			return list_next_entry(iter_prio, node.list);
-	}
-	return NULL;
-}
-
 static struct mlx5_flow_table *find_next_fwd_ft(struct mlx5_flow_table *ft,
 						struct mlx5_flow_act *flow_act)
 {
-	struct mlx5_flow_root_namespace *root = find_root(&ft->node);
 	struct fs_prio *prio;
+	bool next_ns;
 
-	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS)
-		prio = find_fwd_ns_prio(root, ft->ns);
-	else
-		fs_get_obj(prio, ft->node.parent);
+	next_ns = flow_act->action & MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS;
+	fs_get_obj(prio, next_ns ? ft->ns->node.parent : ft->node.parent);
 
-	return (prio) ? find_next_chained_ft(prio) : NULL;
+	return find_next_chained_ft(prio);
 }
 
 static int connect_fts_in_prio(struct mlx5_core_dev *dev,
-- 
2.26.2

