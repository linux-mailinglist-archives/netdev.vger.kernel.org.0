Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F64F3A96C6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhFPKEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:04:53 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232031AbhFPKEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdFzlohdjaA7qiVviwJet7j/z+5y6keXUlgprzcrsI5OzM5OIUXuw6b4XwsIQFHUV6qMAx6Fo/nkF+AhLpkH0lkxzPjks5VzxTGzbnKoL9jwCMHhY9NbGxUKGWa+capHLciVDtWif0+NNMuuQG16EKZ0GFKKSUwSf3wt8JchxopqgyXq21F/N3/fXnOu43Y1AuvY8wwcCJnVm6XyAzAHHyL2/FG2bxU6LUIjLEJjRZ9NNdmIryfMwJrHIK8sAdmK1IFzmD/P1xrjBJpcNYXrHeuWnt2T+YV4IlVzMfw9E4+oxJkDxphmHJhUjiu0n/J32JKZOFR0k+h/4YDP3kfyaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rswEvOa2EoElM3NwVAtb5NVpaNA/NZ7/n8D1ajlThU=;
 b=kRhgjPVaRSCwOfcofsW5bBQ8AAG9SP9B25zCzdeCv/du3zcBmHYsswwbSbdtDkjmhCxiRxKsyOee6iiL/vStmDNfbDp3uRi0gmKRSWALGuxxO3OicxU119o1bLB5CTFxDqQ1/7e9fZKqnqE3cHWiWHGlEWWUxXPr4n1+0X61UsBoWPOewfca4GUb/Fht0H44uWvznoHkAqxfhDaMuyzHBOBQCG3xG0QxELyPa2HSrqnD/refNsowfZLkMrqQGzn1Ai73DBvyfZYLlk/7+kBjFNbJwzG7ivEmq5ZZZ8vX1vLy18tE0qj4O3fLhHYdVXFurdvtjY5b7QsKxHfwIHuJ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rswEvOa2EoElM3NwVAtb5NVpaNA/NZ7/n8D1ajlThU=;
 b=RrRyoY495gYk5diGNmOASLbh35bzmHS/V3XAkWJzRf4iOzsmoQ50DVUbxDqosWMHOxdybiQ16k6kVgpCFvZMuKHL6Suww70CFnhMhThVu7V0UWssXqW5BTDq05aCQAUe4m4zNQnPm2HNGTvNjSpFHMP8KKR+jJmgJPODeefB5/Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/9] nfp: flower-ct: add nft flows to nft list
Date:   Wed, 16 Jun 2021 12:02:01 +0200
Message-Id: <20210616100207.14415-4-simon.horman@corigine.com>
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
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b87b713-c927-4773-2b90-08d930adda71
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4971327DFF0D0FEC87C9D06DE80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6RROcBnt7PyOEJ62WyvY/ve1PMxYGcV5NcuRMMjGA34qC9w5i9hnWTfUjqLDtj3WDQ3q+yG5cDv6qhQZ9yNfgnCEfT6vX2k/pDbEecTCMugY4vgDo7HGsPCRBkev/o/yv6YCobSflcd7MOUCSRK8crVjSXwU8O63EI1/jSCDic/J/OHCe5STzmi2ZUubZpsF7J84Hq7G/caHf73BBBqVaDOg2ZpCiRfEAyKa3L+NfTYvgnIx84b/BCfrNgmRRBRTvB0bg2kRr8a/cirS3wybagIEmKyAqpk8JaA4heEXSilVmxgOzcfu+COGKZ2W2j+9w5wKS6lNkuc4I5jeG4Idi0TQtUCJOKWHV3EadWpwJUUg6uyxYAXJ5t9h0EvZCSKSQOeCIL4e9ObHDLboEy5oujt7lN/3XoaSZXkz0Z4YnL+sY1lpd1U/QHnH+9o8CSw7VKZxQGucsPr2ZifXA/+UYE2lSPpQv4uQLTHox4O1JXsx2S+kOfxj9U2n2LxXRMTe5QN9xGP2dNnW9U6Kaz23DD923Vk0CB4wrIBRLH65FZdsfXd9fXpQNJuIsVunnMzkr/7h9Hd9kprlcIV+LVcCmSItJxV2hxQz9qw1b+DoAUSp5c67TZ3OnGc4D+YCZ0LFM2AWKeQ88NP/i3529V/sKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nThvSlFpF3yVBK2q0pzP7X/UH+k2UDmOHOxK/BB3CJrgykpYB2o+YxhANKKE?=
 =?us-ascii?Q?4fPys0DD+lDPrkzuN9cu/BNLw9hJ1m3QkJugXoNFP5Qt2Yfz5PUOcloqDIc5?=
 =?us-ascii?Q?0bUdvg4hXWjPb4lBtGxmqjYTxNL0NzPy0j3nR8OdLHNBhiYdIlLHYxmoKEdN?=
 =?us-ascii?Q?0Kex8F/ve7YK/8FH9skbT6/uGlztof/1/RPvEq0c+T31Asv4a2tVDsvKndVg?=
 =?us-ascii?Q?SlpFitD5GLQnqoYN55cT0FC3Oj/ZeSGYGXaDtut6io/MsJRSZzYZUrnWQORu?=
 =?us-ascii?Q?ze5Wr1KAXl7jBIy+h06Wz8OJXmExkG7qSiaS/ea34IC5basqvHyomDe59LxB?=
 =?us-ascii?Q?i3QViHn33QIsrzjebbaj+ZIJtmYXi+Hf+w1E9sQpceVxXOiu4IMngFO9EdUc?=
 =?us-ascii?Q?2LNvUEM1DJAi9/RES2ZKYahc6a8qOczbXqsorjlSkpD/khjYvrxOZ8bl6n99?=
 =?us-ascii?Q?IyMeDu5YQai4sF6+3RBQx21c3CXHxok7EIaCRFr0bmUCBAGsPodNIKIYCPAe?=
 =?us-ascii?Q?NZo1o3aqIihaZUGGqmOjSCwWc9mEjc1EqOWfstS/QMktjiTPfOvk6Rc/BAd5?=
 =?us-ascii?Q?rxxb6SKmgTzlTugiVVCWGPrKTFDowZZyzjwQ045D1Bv5eldmccnPrRhwcn1b?=
 =?us-ascii?Q?BOlBe8GYr37QhTUKwcdErlnd/gIxABp7FpwrvYYoscMekfidsblZ3ZCyn736?=
 =?us-ascii?Q?JS5NYTEpmse6/aOcbCWUQdeA17e32aIBWuMMZM22WOc/YHj7RhkDfkO9W/VC?=
 =?us-ascii?Q?DLw6i5VQxQkSHWn8gGsEZgXKjLbjfeJCHtuPWrCRaKUZ3AJxlqbgcHtG+F3a?=
 =?us-ascii?Q?nP2PNmn0oBqDPaE35OfuVh4OfKRkBT2KT3riq8kLf2P6XWY5PFu1xkfqN7Mi?=
 =?us-ascii?Q?i3NvI0+jBv+xzO4LZnTuuTnB6vNkCTfV5JKhc5GKNXd6ZJWOcew9uFZ8EHNU?=
 =?us-ascii?Q?8Ad2S6ax9GENGhUNrvEBc3xuSc4ERhCcAwMm0kAVClJhKtHV8X8byG1XI3jC?=
 =?us-ascii?Q?oAoS6QDeqyBL0NlHtUS9XITP5D9pCwoeqlvtta2cx1GobVPvvvT005Kysl0R?=
 =?us-ascii?Q?YzblRxqiNeIeyskbDJ+a0/fLV4ioA9WA9ss87MW6ouVPKI2LZdINAXxVLQkG?=
 =?us-ascii?Q?wQwuHMOVsfHIdqwIzYMKt2bTdYpeFCAvLW3nHsyCqtt005vsPHCmv7UitA5f?=
 =?us-ascii?Q?1IRgFg2eM+O7EV5KFUuDbMHw08P/em0LC0k4IYTcZaON701W32DZ7tBEjBWB?=
 =?us-ascii?Q?yCZQjuX8cA93wd/GdnyAte7sWWnbzhM3EflMSXApsSQEQff9ShtcYPgBQVQH?=
 =?us-ascii?Q?nOlNxaTrx6Zb4HC1dia2PfCtkTirpCfzg+emzDbNlrCez88/nArW+BhQ2p0e?=
 =?us-ascii?Q?7n9n5GBUp4vtyY8vOKjc4MCoTHqR?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b87b713-c927-4773-2b90-08d930adda71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:30.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEdG+7ECMOt+gAvCcr+vnHK6uX3tGZ1H5t2k1UT0oPlKt9D5gLzCuON5hlt58pgMCweN/Q1CtjK/b9VBN4YFd81GY/79pL8RkJv1rwO32wI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Implement code to add and remove nft flows to the relevant list.
Registering and deregistering the callback function for the nft
table is quite complicated. The safest is to delete the callback
on the removal of the last pre_ct flow. This is because if this
is also the latest pre_ct flow in software it means that this
specific nft table will be freed, so there will not be a later
opportunity to do this. Another place where it looks possible
to delete the callback is when the last nft_flow is deleted,
but this happens under the flow_table lock, which is also taken
when deregistering the callback, leading to a deadlock situation.

This means the final solution here is to delete the callback
when removing the last pre_ct flow, and then clean up any
remaining nft_flow entries which may still be present, since
there will never be a callback now to do this, leaving them
orphaned if not cleaned up here as well.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 46 ++++++++++++++++++-
 .../ethernet/netronome/nfp/flower/conntrack.h |  6 +++
 .../ethernet/netronome/nfp/flower/metadata.c  | 26 +++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 7fb51e13faea..1b527f0660a7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -165,6 +165,7 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	/* init the various hash tables and lists*/
 	INIT_LIST_HEAD(&zt->pre_ct_list);
 	INIT_LIST_HEAD(&zt->post_ct_list);
+	INIT_LIST_HEAD(&zt->nft_flows_list);
 
 	err = rhashtable_init(&zt->tc_merge_tb, &nfp_tc_ct_merge_params);
 	if (err)
@@ -500,13 +501,31 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
+	struct nfp_fl_ct_map_entry *ct_map_ent;
+	struct nfp_fl_ct_flow_entry *ct_entry;
+	struct netlink_ext_ack *extack = NULL;
+
 	ASSERT_RTNL();
 
+	extack = flow->common.extack;
 	switch (flow->command) {
 	case FLOW_CLS_REPLACE:
+		/* Netfilter can request offload multiple times for the same
+		 * flow - protect against adding duplicates.
+		 */
+		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table, &flow->cookie,
+						    nfp_ct_map_params);
+		if (!ct_map_ent) {
+			ct_entry = nfp_fl_ct_add_flow(zt, NULL, flow, extack);
+			ct_entry->type = CT_TYPE_NFT;
+			list_add(&ct_entry->list_node, &zt->nft_flows_list);
+			zt->nft_flows_count++;
+		}
 		return 0;
 	case FLOW_CLS_DESTROY:
-		return 0;
+		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table, &flow->cookie,
+						    nfp_ct_map_params);
+		return nfp_fl_ct_del_flow(ct_map_ent);
 	case FLOW_CLS_STATS:
 		return 0;
 	default:
@@ -533,12 +552,30 @@ int nfp_fl_ct_handle_nft_flow(enum tc_setup_type type, void *type_data, void *cb
 	return err;
 }
 
+static void
+nfp_fl_ct_clean_nft_entries(struct nfp_fl_ct_zone_entry *zt)
+{
+	struct nfp_fl_ct_flow_entry *nft_entry, *ct_tmp;
+	struct nfp_fl_ct_map_entry *ct_map_ent;
+
+	list_for_each_entry_safe(nft_entry, ct_tmp, &zt->nft_flows_list,
+				 list_node) {
+		ct_map_ent = rhashtable_lookup_fast(&zt->priv->ct_map_table,
+						    &nft_entry->cookie,
+						    nfp_ct_map_params);
+		nfp_fl_ct_del_flow(ct_map_ent);
+	}
+}
+
 int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 {
 	struct nfp_fl_ct_flow_entry *ct_entry;
 	struct nfp_fl_ct_zone_entry *zt;
 	struct rhashtable *m_table;
 
+	if (!ct_map_ent)
+		return -ENOENT;
+
 	zt = ct_map_ent->ct_entry->zt;
 	ct_entry = ct_map_ent->ct_entry;
 	m_table = &zt->priv->ct_map_table;
@@ -566,6 +603,7 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 						     nfp_fl_ct_handle_nft_flow,
 						     zt);
 			zt->nft = NULL;
+			nfp_fl_ct_clean_nft_entries(zt);
 		}
 		break;
 	case CT_TYPE_POST_CT:
@@ -575,6 +613,12 @@ int nfp_fl_ct_del_flow(struct nfp_fl_ct_map_entry *ct_map_ent)
 		nfp_fl_ct_clean_flow_entry(ct_entry);
 		kfree(ct_map_ent);
 		break;
+	case CT_TYPE_NFT:
+		zt->nft_flows_count--;
+		rhashtable_remove_fast(m_table, &ct_map_ent->hash_node,
+				       nfp_ct_map_params);
+		nfp_fl_ct_clean_flow_entry(ct_map_ent->ct_entry);
+		kfree(ct_map_ent);
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index b6e750dad929..def95c3e8bb7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -28,6 +28,9 @@ extern const struct rhashtable_params nfp_tc_ct_merge_params;
  *
  * @tc_merge_tb:	The table of merged tc flows
  * @tc_merge_count:	Keep count of the number of merged tc entries
+ *
+ * @nft_flows_list:	The list of nft relatednfp_fl_ct_flow_entry entries
+ * @nft_flows_count:	Keep count of the number of nft_flow entries
  */
 struct nfp_fl_ct_zone_entry {
 	u16 zone;
@@ -44,6 +47,9 @@ struct nfp_fl_ct_zone_entry {
 
 	struct rhashtable tc_merge_tb;
 	unsigned int tc_merge_count;
+
+	struct list_head nft_flows_list;
+	unsigned int nft_flows_count;
 };
 
 enum ct_entry_type {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 8658c5cedf91..a0a0242567a6 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -639,6 +639,32 @@ static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
 		}
 	}
 
+	if (zt->nft) {
+		nf_flow_table_offload_del_cb(zt->nft,
+					     nfp_fl_ct_handle_nft_flow,
+					     zt);
+		zt->nft = NULL;
+	}
+
+	if (!list_empty(&zt->nft_flows_list)) {
+		struct rhashtable *m_table = &zt->priv->ct_map_table;
+		struct nfp_fl_ct_flow_entry *entry, *tmp;
+		struct nfp_fl_ct_map_entry *map;
+
+		WARN_ONCE(1, "nft_flows_list not empty as expected, cleaning up\n");
+		list_for_each_entry_safe(entry, tmp, &zt->nft_flows_list,
+					 list_node) {
+			map = rhashtable_lookup_fast(m_table,
+						     &entry->cookie,
+						     nfp_ct_map_params);
+			WARN_ON_ONCE(rhashtable_remove_fast(m_table,
+							    &map->hash_node,
+							    nfp_ct_map_params));
+			nfp_fl_ct_clean_flow_entry(entry);
+			kfree(map);
+		}
+	}
+
 	rhashtable_free_and_destroy(&zt->tc_merge_tb,
 				    nfp_check_rhashtable_empty, NULL);
 
-- 
2.20.1

