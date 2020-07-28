Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B92231357
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgG1UA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:28 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729088AbgG1UAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ild2QpRcx3Q53FiXX9QwH5E0Oy2GsPQ7tp4Kl5zU3dayP0DUpY5gUsMHg4kPBkX7aX0T2DM5AWmUfOzohB4alCBCH3leS/5T0s0vuyvAmFfPiaFNpOvh5INecKg17ejYBhknj36bxxTMPERe4pD6z0sbbvY582C3Rez+vr/ORabRdpAJXqHp/SbTIbgXzcaLBJTgif8/ths2u5PlbqFRO40Qy1/MzPEzX/vjQBTKqbNwBDTJUTiUtDqVhHOjUMlcEImo50q0TnUWf9F9MM5ErQ+3X9IkpyUmP2Pbufq+wj2VLz0l5htWCFQcPb6usBPqPIh9W6Vq17XKrfyggB19zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8EwSVx2YsOzHa0mWr3FT/EvFj9ZeD3uENoUnVK0Log=;
 b=T5kGxXBWrVEhNDii/mDhQMlQED/1KZ5OxBeErbilmHVJGAIIVJeo40NjA4DAy+jLJayw06e2v4UU42V7N/nHNAlBJRxk2aHwQd8HZm2rMpqMqAE0oxg4aGMV2rOL3/QpPVEpv249dH/ADQtmZU7HY3vPeHMoZ0KmwbLMyhnDHDlglX4lpA2RSYABirbGjPtMLR+eKs/Mu235shds3gU9bTHYIQvZRpeKqPbhYIuYw62KVpCgYIu6qY0Owr/P4abQ2kwqhV4tQan+YikjApujKp/rtJVwyviRCIzDc684DBrjx7HE+pMhFSxGXrcmjDL3engFfic/uGgHgA9Dc0EYoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8EwSVx2YsOzHa0mWr3FT/EvFj9ZeD3uENoUnVK0Log=;
 b=mjM7+M67cHh4MHvFin6gSyqFuIn1O5UxYPfB6jF0B3I8SI35ce++SjMQkBxgfnf8a+Sn8zRt2rs+psLF/gd0s0IKLAQgJ6Hfrp0vVLMv5yTf8+As0LK/+gCEgNzjPJ2dF6elRzzSP8rXASMIDYSN+MjYD9spwLJdEeMKWofsbMo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 03/11] net/mlx5: Fix forward to next namespace
Date:   Tue, 28 Jul 2020 12:59:27 -0700
Message-Id: <20200728195935.155604-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b48665de-a606-4f3b-acd8-08d83330d9b0
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB259240B1AF71A8E1B09D9E17BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iy3d5KhDnJ8I5NsxQ3uC0L+tzP5vLWZeNSZBAw31fDTOupd1p3Vn7BB72PSxnqb8V/wbkwgJQ8hvd4A74kJmik69x1ZjeJWlewT+xNnuwtr6g58/AsikvnxZjOxqVUuySHF55fZXEOzFuA2BEF5a92qnS+Yxz8wXXxZkAVky3fLQs5GM6jFiVbiGtdFExxQIo9B7pLQQVvQ3AhKtgjbzN+9MvzQ98AiD6nSEIoSsV3/XWZkq9dBj1khjhu2y/QivRbBZb2qOVyRlYbQ/yZ77bS18Ruo5Xp3NTirQGtBH050hLOiAJRvil3lNcgyqw3I2Sfp0K0Bcw0be70yYbPoVnPBD4khk0BS80+HvQprDxSAp5gGRmiax8gEfNKbGKTyq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7Oz03M/bJcjBIwahsaQrrJNODuujB49qHNyNhNbUKkyWpi+U79jolhwWm0JNXe/Nlp72fP7l2ZlCiorMJJiXf5Cdto+ymP9FasfD4OeLr8+zCXTs62jD9J3SSc+Ht4MVMSd+T6A2xjsFTaEwxRNXH6ieF5VpGEiOMEw7QDtpafvgzxNyGwq5u+WV16oC2I21z0fBb5HE9xkMiw17nsDkl67pxYPJRDdodd7rE5znypE5x/aMMuIidWa20doHTPOq0kLrgG7hpetC4kYohe/5QvNTjXRri7hwyZLH1B/bqtFv/Ht2djDHEKHs5+EOaCF20m0Oy9JA7OCwiSzle5bit6F5Um7xmmgZHvdVsJY3yzRHjfEI/Iggcn42KSkfh9ey5zluDLJezsj2j+kMhYskfYuGeKFza+s7qPfTsHG+2wj0GVI6qdGvCUrdYFMH5/JhGbSyJxrYuOi1gU2iyva1hx5KA0DCSoVc8EN3Qg2f5Hw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48665de-a606-4f3b-acd8-08d83330d9b0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:20.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZhVRQNKGHSpB+DzmFFG2sj+8mNXCKmQzhi4aEJmFAk0UA1jff+PdSUGEJ26Q4ZcAoofQDziYcxqEQElwmOWHEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
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

