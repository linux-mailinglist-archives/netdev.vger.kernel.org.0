Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F573A96C4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhFPKEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:04:44 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231769AbhFPKEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2nKgOZAYYK5p0sAcNIUW9LL5MiKD6vyQScdrndN1xQI5l8QtAUzMBLTRAT5mXMyXFMp7L8gfNM8QMKBF9TDNU9EctkNV22qWVdCcFxsIxF5E0W0ounGhxe2Ke0nIcyX3DzCX//sEa0Uuqi9ULmKggUkVf+WtEGz+nLRximUjars4FxKK96S6O15uZ0mNf3YVLY1h4KPaYrwEleT25Ih/gGseiIo2A/sNspdRVq85yeXpMyYfu+8wF6gQl0v1A1h52b+Lr9cNg2IpxijKZXLfsDuykGsSD15vEHvRLzgn8gcIadaSpxonNvLpEM1sOmuSWlmnuZksDHgkhjY1zkjPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOW3bSCqo2HSWwCuw7fLoHH9RZrjXOCmtmkAzdl6Kok=;
 b=jhfJ6Jp7GKfR7R1OrNpBCDkqa+aRvTYxnR/0KKTp6qd6aK4/Kmnwl5KGwciw6SdGlLwnFvLGTe2Xlz8QFjqytcO1IOoefU5mkHQOZaMwwty5mjTmCcWYTz9LRL/AodWd/7M2lP5rxSVfx2LDgtsB2TheAXxFXgfdYS9RomqbsDqrxsu1bnslgLv3QcR3SwAZmhhSROpZ3f+2xY+gbnsUiLuVkJPgmEdsxbctblm3vwfAqaARjmy51atFLcRJE23uU1UR6RdwyECNvt47nG5ZzyQ154fPcQDQLJvyAq4jhpyxrDlIiIPZjKmbPuTd6h+VQBFsrc4VyDLrR1Ik7YDIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOW3bSCqo2HSWwCuw7fLoHH9RZrjXOCmtmkAzdl6Kok=;
 b=j1EN0Tll2/I+kTBZecPeLWmbvkGiJSpFdBn5RRHjxSgACQOPhWE8zbjw0ogLsgQMtFIdFxaFSDoSwbUv4aNRjvNvuDup6F3WiHubQGiXq+zpatJlFQzwAVxmLJ/vDOmYOUusi6bztEY//jl427ABd+spzdvkZVdJ0RPuUD4WeGI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/9] nfp: flower-ct: add delete flow handling for ct
Date:   Wed, 16 Jun 2021 12:01:59 +0200
Message-Id: <20210616100207.14415-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210616100207.14415-1-simon.horman@corigine.com>
References: <20210616100207.14415-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86363bc9-da18-4a7b-c0ad-08d930add869
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB497171DC05C9377C620DA6C9E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KUYleprRunGYmer1lNxxNg5qyDLkhOyQ9g7NKY54fq6FzERCO0baL3Njpbxs//YyANVVdqBUvaxdRYShNBbeNwxA5sNI0QFCGhh+T+7fWTNxuwev2D5aRaAi5ilckZIKzTJwMPM9G8yY70p5/sqSoNBc+eC7Y28CWj4kJ+kj6+XFoYDok51P0eyR6w5T+caWJ5zvpwjk8CXPson2k3W0Depvq3EryvNIHZ97+si598whjiUhpYUkeQlwxFwh9BA7qgPd+ui2bZPdXIcoDxeUJevYjnZM9N/Hmy1wtMfAmVFOYusy0/vh36t7/8EWQGeK5dDVVUOyFEt37d58UxdSko5OnY/DXVNl0JEmgJF5OvfjYA0YqzMSrs0+gJ5fOogXAnfCws5EMkPGkXVuImbPTEHxXbZRiQQUjXPwj5SXWvVyJPhdJO4yLQCpuLWahMIJjVO6L12uwbZXSea4Ge3CpFpcKj9UQeQEdhrybnMx5Mk0OAt6qidVq51iSfjik/2FHhE9UhSCm4xQBdkt8+GUObrVi4sgnVJqwBwGPSQ6AyLTP4+TXPP/r4VqZUp0l9ZBaFyh+u1U2b9j5J0kE0gTpuG/hThK/T4z9NSCF7+WuyL+NvXG4U2QwKQWIHL0TCvjx/TmcAv9UET+XQlfhLCtSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wu3+L/eK9+tM768TtOhJXFosWTOGxMHhHhkINhREXjfZI4qbG33qEjYBSiSQ?=
 =?us-ascii?Q?RsV43NXHM7qy9LVWEvRAv8JAwE6XqwgIOXyzzuhVJr+8fuaWw9YuvIuGaY5k?=
 =?us-ascii?Q?lydHY4I+N3a78WahHlrZ9+I8OwrOVeg6+7maKrZCqDiOkjJOJpu4IW8Ewbq0?=
 =?us-ascii?Q?C3yQoiN5h3wBKaVL6BmF81ZQVLQW9bt40Yl3YX9bLL6oea/3F4YFRP8LUCPh?=
 =?us-ascii?Q?p0Kg2JOj1NJ6iQ05TymJT5XOYOZGsS+jqPElChRqIRWlxVOdk2hFFYXfewUX?=
 =?us-ascii?Q?XYqPcZz8xC8luvT1z41A2/Ky8A5qEZrh5L9lLAJ/8HJkiWK3VqhfxcA0j5Fh?=
 =?us-ascii?Q?wPSFerHvhEk/TyAB8W8kcOMZHPDV1bsS6p83U4X70Tez4z05JxERMcbj97xF?=
 =?us-ascii?Q?s93DbW9iB70dYEJbZdt8c3BR4AHXpNMs4ew7pvJED2AJBAliv0N6Kz1JWYdE?=
 =?us-ascii?Q?6aRkjdAtJXmIsXqyk+vNinyGWiS47Xsr4lsbMQ1dx2Xq7Pw9Eh9bS9fRc3Bt?=
 =?us-ascii?Q?gzk7CSToctIw2TPs00o9FkjoyjWJgJgzqzhpCPSjpesh4dhNi1alVMZ/jHzI?=
 =?us-ascii?Q?6/QOFngo7IMZJSl5gqFwZzOco8Ng3rp2bfD3MQgghZvAo3MjrVMO2fjMt4fC?=
 =?us-ascii?Q?TcuJ4QHKvHt/beMXVvyFxoS5SKDUyDAylnXsiaTCG+0wdhWSlh2XF9ioPSHF?=
 =?us-ascii?Q?/azMvDqjQ2oWV8uS62Ii3OhJDnt+7MmYCXD4iZu87M7V5h2FD4hTkyYlFhWP?=
 =?us-ascii?Q?WPsBgYHZCFKofg0uxuJTnnYMVc35834bfd8Nk9k23qvIvK9pOmg5feMuFiot?=
 =?us-ascii?Q?U2dZCMRymXCrqidhXIt26cAc/2RFdwOd6JZi92VVBQhl+6PE/aNmXOKmzhTL?=
 =?us-ascii?Q?RVbFRykMR6f56mTS+MLulGb6iDQ6NgACXKil0ae5ynVkhyCaGbO4Y/IeYdns?=
 =?us-ascii?Q?ehDyIzZ6O1FRQ1GxooPhqLgHrUSTj3TEyUwDu8m+nB6WD6wY0LxXw/CkfKc/?=
 =?us-ascii?Q?bHITRNsM8H/El1xv5tZQSC+s0xRSYfOznmOz0MQSTrAwi+g1HJvaNZEkRihn?=
 =?us-ascii?Q?q0LtRlZRflGb6dt7JDWcTnzuVnLrib6PM3fB9n/8VuGD+w33XDaGZQtTVjAF?=
 =?us-ascii?Q?aI/w0xjloIL/q49KUdVe1gpWPpt++oW8Jbld43OLP9n5Dbw3TP+HUGS4Ieh6?=
 =?us-ascii?Q?z/DcXnH90PlkMtQWu+nbiaq+oAe4HYHk6/76j3TODroEqEQq5SmtKjzwSN3K?=
 =?us-ascii?Q?TvTVq6yPtBi8DpRmrIqvKjEYWySt+cSlI6zHgl+u08h4Pps0zWiPk9zNO/5b?=
 =?us-ascii?Q?JVimpgt5/V3IGRkGrAJfEqUvOgROvmkqZpQstj3DB3alJOs4UbYLY/Pgman4?=
 =?us-ascii?Q?QpEYMXSIiLJ7QTmFYD5ATF5dE5NJ?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86363bc9-da18-4a7b-c0ad-08d930add869
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:27.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UuwtS9v6LUjgVFIMRLitk+Z/j5LkdqmVCQUN1B6sZ3Camn8P/BjqXQxzFqQQjo444skudTFTEpP68xAfevmM+FX2+uiJL0IYNniY8NiJoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add functions to handle delete flow callbacks for ct flows. Also
accept the flows for offloading by returning 0 instead of -EOPNOTSUPP.
Flows will still not actually be offloaded to hw, but at this point
it's difficult to not accept the flows and also exercise the cleanup
paths properly. Traffic will still be handled safely through the
fallback path.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 38 +++++++++++++++++--
 .../ethernet/netronome/nfp/flower/conntrack.h |  6 +++
 .../ethernet/netronome/nfp/flower/offload.c   |  9 +++++
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index b1709affb52d..ea70e02d170e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -424,8 +424,7 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	if (priv->ct_zone_wc)
 		nfp_ct_merge_tc_entries(ct_entry, priv->ct_zone_wc, zt);
 
-	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack action not supported");
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
@@ -487,6 +486,37 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 		nfp_ct_merge_tc_entries(ct_entry, zt, zt);
 	}
 
-	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack match not supported");
-	return -EOPNOTSUPP;
+	return 0;
+}
+
+int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
+{
+	struct nfp_fl_ct_flow_entry *ct_entry;
+	struct nfp_fl_ct_zone_entry *zt;
+	struct rhashtable *m_table;
+
+	zt = ct_map_ent->ct_entry->zt;
+	ct_entry = ct_map_ent->ct_entry;
+	m_table = &zt->priv->ct_map_table;
+
+	switch (ct_entry->type) {
+	case CT_TYPE_PRE_CT:
+		zt->pre_ct_count--;
+		rhashtable_remove_fast(m_table, &ct_map_ent->hash_node,
+				       nfp_ct_map_params);
+		nfp_fl_ct_clean_flow_entry(ct_entry);
+		kfree(ct_map_ent);
+		break;
+	case CT_TYPE_POST_CT:
+		zt->post_ct_count--;
+		rhashtable_remove_fast(m_table, &ct_map_ent->hash_node,
+				       nfp_ct_map_params);
+		nfp_fl_ct_clean_flow_entry(ct_entry);
+		kfree(ct_map_ent);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index 3d7d260c6e5c..dbb18fbbae69 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -152,4 +152,10 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
  * @entry:	Flow entry to cleanup
  */
 void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry);
+
+/**
+ * nfp_fl_ct_del_flow() - Handle flow_del callbacks for conntrack
+ * @ct_map_ent:	ct map entry for the flow that needs deleting
+ */
+int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7e4ad5d58859..2406d33356ad 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1505,6 +1505,7 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 		       struct flow_cls_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_fl_ct_map_entry *ct_map_ent;
 	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *nfp_flow;
 	struct nfp_port *port = NULL;
@@ -1514,6 +1515,14 @@ nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
 	if (nfp_netdev_is_nfp_repr(netdev))
 		port = nfp_port_from_netdev(netdev);
 
+	/* Check ct_map_table */
+	ct_map_ent = rhashtable_lookup_fast(&priv->ct_map_table, &flow->cookie,
+					    nfp_ct_map_params);
+	if (ct_map_ent) {
+		err = nfp_fl_ct_del_flow(ct_map_ent);
+		return err;
+	}
+
 	nfp_flow = nfp_flower_search_fl_table(app, flow->cookie, netdev);
 	if (!nfp_flow) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot remove flow that does not exist");
-- 
2.20.1

