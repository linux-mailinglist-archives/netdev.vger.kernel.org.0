Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC71A2C0C
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDHWwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:12 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:65377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbgDHWwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDunQhnc7xo5wfZOEK+wUlkl43EvJsDcwb22XfyqJebsSMFDtsXo6XDWbRYH9yQmaDVj+1buhSU2LTvuD6wxqXUNGx7EQqQBS/1yjg0rb8CmlSg1SOujJ9IF83kdbD/9HnGxqcbfYzHpPZeY4fMm3LMrDKE1jOsdbdM+Y86r0TzANLciK26EPi8hjA2oUrGP1eogaxBmQn9/JjuRhWOEoracFTrV4RtIKxeDkarqFo8h/7gGkCfrYXLUrhZOotRV37dEjwpCf14Wv2A1I01b7DhwIZfxePZB7WnqadnAbcqZNPXK2LYasnb8K9E32DW8ruMTFzcL4udf6Que3UIPrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57oj1vwqwoKVvFtNAizo1++1DZvd22e5VwOpeL/fkbY=;
 b=fzJpuKKm7fCviTKxWmIcZjNxQs7W9aby5ym9boPePXOA3RMqAEbzhiKYV3XfO/IgaKYlqRnHyxfOyAcmo5uCSPpy6TaB6BvskqpaWtqOSDQEFYkqwrJt41T8xzQitRHHcoGCZHnsinokpZZr+sFVahyQX1ii8CYla8lATsRospr9TNxnKAl1NSljP+rF/9OuiB/WJCixdtLxyWsTSndhzh3lTyH9SxgRZ/tInCtPpx44L0KuDNBduxjNI2LeOEYqVL0KPdyIsSmKZRahmVFnTsMcs4G08ikiKOSAvU5ogzGaloywMYUdZGPp/SWDlezcQ0A54jF0xDeh5y9ZS6sMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57oj1vwqwoKVvFtNAizo1++1DZvd22e5VwOpeL/fkbY=;
 b=LmepUz3Gu+sWzKZ/oBLePHzIBcManr+MjcCXv5Bk+XCftKt7Awtqfd9cBCyWXAfO4c9b4rdb3CQXjbQQTeayxUB99pNTTAoHitArHvkARkdLixWDGdbWqrTi4OxyxTl3sgtUH10RPnwD4x80HN23EKwmkCvcdSCBWvZJZBbp5GQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 8/8] net/mlx5e: CT: Use rhashtable's ct entries instead of a separate list
Date:   Wed,  8 Apr 2020 15:51:24 -0700
Message-Id: <20200408225124.883292-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:56 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4fbc61ae-1c2a-48da-e319-08d7dc0f710d
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB636521098352630C04838AE7BEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlAwv6MFNIRzYMjM1WLyzOYz8B3ofn+b2jHzEHHWJyoXzwbR/+WUWgKslUBRZ942D1Gk7tZvc1IgiREnUM/RD31zrADwiU3UUB3bfitBFryE6qgJ5n1Gap96DJG1wgSnNgXm1+FkHmEVD70wpQFPUIypzegid8UOpAorRovM4EOOK/gdztX3Hb1hXb04NgQpIRx9V5FvkFv9y8GGaI8egSlq5PNlzh+rOxYRM64bqNloVqMQaNTIdj2L1wd+WSAGuXE/RucHlKIgB5EQPkj5cKKooKumP6elws3JRSE+cofyHNV8YkOotJ0BSLJi9RIuUC4FTSZ0ynleu9hr+eJ9c19Pm6iD/Gw20+jl2y6H3iqaUHZp/oiKLy49d4idkQHglKftEZZk3S9YAhLYowRelpnbiYfp+LcJTge/6y+AJXDeHFugMjyoUexWsfHiUTcHtN61rVOzZHWp2oSoRA6Id0VzXlEJMGxUBZ/YSSdcOKU=
X-MS-Exchange-AntiSpam-MessageData: XCSm3xij1XDpbyZnix/V0nJg47GAglA3Fox4szDhiF2asz09G8IDlDKjJODIpL4KY1rDCZrEShYFUreHvXorVzJ1Xm7iePqCCFflBBqAml9OWyh5j17lr8NgPiNPXUUTD8Ejxb9NaF3/zxNvbt+Axg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbc61ae-1c2a-48da-e319-08d7dc0f710d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:57.7908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r15gWeZ+PiqjriBDA2Lma3XVyly1E79G5Y1l2PAE6kzFgMEmwf7xTlSjXk6Q2QIR0ZGm3uUKytCeVP8dLfKSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Fixes CT entries list corruption.

After allowing parallel insertion/removals in upper nf flow table
layer, unprotected ct entries list can be corrupted by parallel add/del
on the same flow table.

CT entries list is only used while freeing a ct zone flow table to
go over all the ct entries offloaded on that zone/table, and flush
the table.

As rhashtable already provides an api to go over all the inserted entries,
fix the race by using the rhashtable iteration instead, and remove the list.

Fixes: 7da182a998d6 ("netfilter: flowtable: Use work entry per offload command")
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index ad3e3a65d403..16416eaac39e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -67,11 +67,9 @@ struct mlx5_ct_ft {
 	struct nf_flowtable *nf_ft;
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct rhashtable ct_entries_ht;
-	struct list_head ct_entries_list;
 };
 
 struct mlx5_ct_entry {
-	struct list_head list;
 	u16 zone;
 	struct rhash_head node;
 	struct flow_rule *flow_rule;
@@ -617,8 +615,6 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	if (err)
 		goto err_insert;
 
-	list_add(&entry->list, &ft->ct_entries_list);
-
 	return 0;
 
 err_insert:
@@ -646,7 +642,6 @@ mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
 				       &entry->node,
 				       cts_ht_params));
-	list_del(&entry->list);
 	kfree(entry);
 
 	return 0;
@@ -818,7 +813,6 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	ft->zone = zone;
 	ft->nf_ft = nf_ft;
 	ft->ct_priv = ct_priv;
-	INIT_LIST_HEAD(&ft->ct_entries_list);
 	refcount_set(&ft->refcount, 1);
 
 	err = rhashtable_init(&ft->ct_entries_ht, &cts_ht_params);
@@ -847,12 +841,12 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 }
 
 static void
-mlx5_tc_ct_flush_ft(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
+mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 {
-	struct mlx5_ct_entry *entry;
+	struct mlx5_tc_ct_priv *ct_priv = arg;
+	struct mlx5_ct_entry *entry = ptr;
 
-	list_for_each_entry(entry, &ft->ct_entries_list, list)
-		mlx5_tc_ct_entry_del_rules(ft->ct_priv, entry);
+	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 }
 
 static void
@@ -863,9 +857,10 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 
 	nf_flow_table_offload_del_cb(ft->nf_ft,
 				     mlx5_tc_ct_block_flow_offload, ft);
-	mlx5_tc_ct_flush_ft(ct_priv, ft);
 	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
-	rhashtable_destroy(&ft->ct_entries_ht);
+	rhashtable_free_and_destroy(&ft->ct_entries_ht,
+				    mlx5_tc_ct_flush_ft_entry,
+				    ct_priv);
 	kfree(ft);
 }
 
-- 
2.25.1

