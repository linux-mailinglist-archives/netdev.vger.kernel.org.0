Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDB1DF395
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgEWAld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:33 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:31363
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAlc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QF7waiuJEgbaIeVHWr76rneUyHhSsqFAeQwbwEDDZhJvx0oweUk5DGKLPjzxSJBsz5j9NoRIyw3zpKLmc1J16GxHjkdwcWuhvA4aCIYVYLgGNKK9Fr97Es0aiCSAwNR2f5V5hLCaBQQzZrrJ3P9yklhG+hv0XvxKuddFo0Zl6X0imiqlDnMrREEVNskNiPjU+qOsYy8/+L/V0c0tFPW87FOh7XVu5BjAgFTksPx5DM4mBn7/HTvNaEBPvpgNex019tN1D7p+aaU960mujka31tGCCTuJUohXAoWFAikU+mGV5bsMiBZBFmjt9Olh7OWkveEYOiM66zNyU55qByf4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZ23Z/YcTNA9TwRVwi0GHHcQLLwgnWYJCFGbYey+KPs=;
 b=B02k0VtPCWiuDgdazpweSgP7NgtsjPCmRMQ7D4mFIhAeSXaUS1u1QPa3VklnkQM2Mx0qJzktyG0oxZz/dZiH2akQeypkzqRvYMx0FMfuY6KEBNDbXU6KqHNYyrU/w7CW3EBh0RpyM6UJtINLNLSXZkWQBSsukRFq1jLNGkJAhFCnNquMFnNG1x0a47i7x1rCN9vC5Hur//lLoJtOwMWqgZN+uZ5o/v4sH+Z0R4tWepWzzQQQ7bmRASbsPpEQy6/aFddh8uivrUIHediOyVi9OYXnGLbHvlGO4lffpAI9G6I3aXwfiXpMia+bQYNbODPI7wRwucsb74Q8Zrx53DY+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZ23Z/YcTNA9TwRVwi0GHHcQLLwgnWYJCFGbYey+KPs=;
 b=q2wSoC4htq7gTzGjVn0H7o4zws704/Y6pq0gnzC1gPdi9tHcdetd3170b4VdQ9svPnzYR7x/X0wk01BmWX39bsAzg2xQpEb3kGqdr9zEbMHAK86H2oayVA/oImSbGR3S8u7iYCLWviHCJ+LKXulUzkM6cUT7Ip5x8dWVxntZdXk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3376.eurprd05.prod.outlook.com (2603:10a6:802:17::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Sat, 23 May
 2020 00:41:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/13] net/mlx5: Fix cleaning unmanaged flow tables
Date:   Fri, 22 May 2020 17:40:44 -0700
Message-Id: <20200523004049.34832-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 98b01e11-b8e3-4d78-8bdf-08d7feb20767
X-MS-TrafficTypeDiagnostic: VI1PR05MB3376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB33769028FB7348E89E065027BEB50@VI1PR05MB3376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0w5129ObFwUpQN02dq4aUhRg0UHshQUCYlsKLl1JIcx3wKVpa7uI/fz0ptG4fQdCKT6WO9viHt83Cr5WK7UPZHP6rrcYJRy3ggkqABZZTiGfBxplP8axIvuuIeM3OKxDVSz9OMbjDzorDU7lAz1g7XQURbu7xdYH9kPvKthRk7BGZmK3Tv/+IM/u0PQxL3tEiESa5GoaVatG1c8TaTG43eRCREfMGFO0kvLNSaYZSlXEsRjolUSGTPnsppdZZ0KpC8smH0/X8z60ltyjsam7GsWr6jLuU5kIM1TiaoYDI2kcDU9as70pWU7OKNJI6I6zsw0R2A4SEj7RuY3mKQbHS1NkEp7ZA2WNaTN+44k3ukzm6jZBJaK5PI7fGgU/RN5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(8676002)(6666004)(478600001)(6512007)(66946007)(16526019)(66556008)(6486002)(1076003)(186003)(2906002)(66476007)(8936002)(5660300002)(6506007)(316002)(52116002)(26005)(107886003)(54906003)(2616005)(4326008)(86362001)(36756003)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XV2uVx7qIWNVl7iw7pwV+6osE19Ov+gEaY9W7Kz2TpOTUNqYEIZG5X50NWzTnRkDmLCIlLxbZyKv2pCy5O4NWidXL7+FztAMQYEoCSlyPGCdYgoKlS5xnDnEPfLb9qzM4p3kgnNBEWRID6UPzeMrf7v5rbdXlJWrj3dGoJxU5F9nO1QxGnU/Z3oEXu01+TkyJ1ZSJDLqLadzsvJUbvKwNQuhGXKfnijLnF+O/RKxuiMfVYj/sxWPTXUzJTyfrfGNKUbGBTvm0sW6WrxIQuCXqIlt59XBnq2T/FsImnxTsm82PdTTCsJrTr/iTTdIU2Sdh+A7xZ+dgr9doy5BYLJHKnwR+RcLTaEhpPO4gm5bQUmrZi00gOJuL6GIqtlXCcO5TNm3g/cl8M0PKKuuirw7zgflosKqQ1tBu4E9YbUPe/Xj56Eu1jn5J1a2foxcZbPe29Cek4b7W2uQCr6UjpAHERvEwGc/HG+l/AmXyKW9/4Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b01e11-b8e3-4d78-8bdf-08d7feb20767
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:28.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zONO9eWlxVsmAYY2BVG6IL+3ThD1XNlNcxPLE5Xh8Y9khWBowEdmhrUH+3ldOz/5AbQLfKGUQt4gM+cbfP2gsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Unmanaged flow tables doesn't have a parent and tree_put_node()
assume there is always a parent if cleaning is needed. fix that.

Fixes: 5281a0c90919 ("net/mlx5: fs_core: Introduce unmanaged flow tables")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d5defe09339a..8f62bfcf57af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -344,14 +344,13 @@ static void tree_put_node(struct fs_node *node, bool locked)
 		if (node->del_hw_func)
 			node->del_hw_func(node);
 		if (parent_node) {
-			/* Only root namespace doesn't have parent and we just
-			 * need to free its node.
-			 */
 			down_write_ref_node(parent_node, locked);
 			list_del_init(&node->list);
 			if (node->del_sw_func)
 				node->del_sw_func(node);
 			up_write_ref_node(parent_node, locked);
+		} else if (node->del_sw_func) {
+			node->del_sw_func(node);
 		} else {
 			kfree(node);
 		}
@@ -468,8 +467,10 @@ static void del_sw_flow_table(struct fs_node *node)
 	fs_get_obj(ft, node);
 
 	rhltable_destroy(&ft->fgs_hash);
-	fs_get_obj(prio, ft->node.parent);
-	prio->num_ft--;
+	if (ft->node.parent) {
+		fs_get_obj(prio, ft->node.parent);
+		prio->num_ft--;
+	}
 	kfree(ft);
 }
 
-- 
2.25.4

