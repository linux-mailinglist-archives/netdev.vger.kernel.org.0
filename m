Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3811C55DF23
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345568AbiF1MSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345537AbiF1MSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:18:38 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2131.outbound.protection.outlook.com [40.107.223.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A3A2D1D7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHjywws6j/buaziDvZHbAhXlowmM38YqDoqu1XOagrVxO5dGi49LIWSgAmAFca+zz7umJYMehA2ULHnHiSNFUirY0qHdZsD4fNzptZwtM07CBerOOdI6qW8Dj9U8SH8295O3W5Txxu4syGkOoEu7IR5jNtWLs8/HMidYvWIyKHJyfCTLbK62Mou7wym3zw48pKN3Hyz9QKdQrqaZDX5A823AUl6uwY7GVIHBPA2jfadYIqcJ8Rqwb/mXOz+41n29sdlAIrn3rJoQpGcvdcYeWmQQv+NFONfOizpYycFIchQHpUJXhkQLwwvT6ngiXdA/HZElmKyKHEDhTz93c9JTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyeIbK1irTYYamUy6U66Zl7SHwFgqQrkMi3EXVsNL3Y=;
 b=Zz/hxMqVDuQCHpbbV5gB33du+v531tvZVBgBt68cBrWJmcmNCwFmD0U7QdUDAsjXkazkOMfN3fY+VW1cDjLM/X5FkSvhHnMFk7TPEHFqHwyRK9gwnKSjOn/UGYfjKyxm3h2V3Bq1QOxlISe2DLtjLewsOrHcnptMyZvB4Ic2TkZMdhmZAZGPaznbvncxClqCY8BsVu5wMHqGzXIWnK+VO1iNGiko+BI9MkFlR4EPli0i4D4Mj+IwsLIl5Hp4//I6UhaZpZla5srxuIrtpxzEpWB8FRCWIEoZLAVPov9FLpvJZegpbWlyPY7cqdEHUKiny9Q4F1+lsgAmGeka7JER0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyeIbK1irTYYamUy6U66Zl7SHwFgqQrkMi3EXVsNL3Y=;
 b=GCllmsTkLEZHhZdDsWvlONI7unHJOgGj0fVjc0auX//dFFk6+cnOlDriyXcKByCRTtoXHT5vCHOzrPMucFS4eMjSzBD2h5bj8WHEmqMzP2OBADoGPRy2T3SuTHErwGF9NJDaB9DznrrT3Cn7MPrGSIUFGKuwyZsK31C5zadZAuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3250.namprd13.prod.outlook.com (2603:10b6:405:7c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 12:18:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 12:18:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>
Subject: [PATCH net-next] nfp: flower: fix comment typos and formatting
Date:   Tue, 28 Jun 2022 14:18:02 +0200
Message-Id: <20220628121802.450999-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0001.eurprd04.prod.outlook.com
 (2603:10a6:208:122::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 789d3557-2bd9-4a7a-a56c-08da59005121
X-MS-TrafficTypeDiagnostic: BN6PR13MB3250:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mjdx6c3Z+JBeGPJ+7pFwPQOKNrqcmYuQG48tWdI5CqnGjQEi1PqU2Mh0q9XE6wWUCA8kko3zyTWh0RV20H/bZ7+aFpNSd6vuQ+sR9EXyMECj0JfTkHmOsT/fBdwwxYGVSUqmlmaHWhkMHHOeOKDHSG21E+8b7JTkUQSBgx6g6Steaua0FWn3zUTblHvch1UC/b3HOVSXsPR5PJU2GmuQo9E4GjPANWkQte9pJO05jg4VRNqiV4VmWjoNYEaSdukU03QMG/hJ0yPPeb7bvB8v1HddUCg6DI0oKrWZGMU2lxqvmEQAjva8U8rt9LQiXS94SCfO/KojqhIQEBwTwnCoKMgrmpulWHCfbR/sBBTwdDtum3QVc6UBJ+D1oAdI2NnD8X5RqXj3rplTR+CkLI5bZV4SpHE3DX9PvBqnk6l/EoVl/8AtZe8r9ogv/ETnhyCxTm041dngwHXEPvNOoHOwtUZDNxQBOpj3EX4WQISglJTVKlFXW1UyIxnqllvuFK3MhynpO0sWnUz8ASC4k8mNl8nN9rSomNzt5NKcc5qyYDyFHnqa2hcuUF56eKCLNBz+EyNpFQ1YQL0Z6jCtOqPaJBJe2znWyKt5MfH8uB3ovul81pliHvvSF9NdSUridrq3+kNsnJFn018OaEZ74ab4niWlH7a93ZnAw2n+BH/0qaRVrmIjyhn3EOj/+ACRONe0pvkco4xUa3N7s85A8gamGbpULOAweDu6YeSjHsZkwe0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(346002)(376002)(136003)(396003)(366004)(66556008)(86362001)(66946007)(8676002)(83380400001)(6512007)(6666004)(186003)(4326008)(52116002)(6506007)(2906002)(2616005)(66476007)(107886003)(38100700002)(41300700001)(44832011)(6486002)(1076003)(478600001)(316002)(36756003)(110136005)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6btczzAnvQn771eqNREm0WDw6Twn7hsuJ4mirdFYfEKFFOXYTfyMDJcirzU0?=
 =?us-ascii?Q?bhdI2LazR2GW3NacRyYqWXI542bw6u0/YpsIDfyb9cRn3Bmu+fl9leDi6u9o?=
 =?us-ascii?Q?RcLeLbX6jG5YaD68tMTQA1uqzmMcdhBvTqxZfnpNUEPY+T+bHMm16+4nDGZ0?=
 =?us-ascii?Q?/nss/1xyslXAwl/UiOQz6l/OndBw0yA6sjVLCHi/vhfnS/L1slCrnbLTc9gd?=
 =?us-ascii?Q?iN5hSu3utPj5oE6fpKdhfGuhSX855UWDIvOCICMRzazm+bw0r7a5AazD6e1T?=
 =?us-ascii?Q?FFJ7vSlvDoGlDEuNkHxkWprw/KjG2Vtq1e9+oTEoejtQnM7lNRbKt5z/sWr+?=
 =?us-ascii?Q?K1eRhV94G7NC8qYyGa2kB6XJohQ22B/ketIwro0cmENQ55C1E6umc7fvpPUk?=
 =?us-ascii?Q?2i5CYO7kjJw9xA8jrwawhdKmxjc7/zY3dnB61PqP1xElLI1Y6YtVTtypOn4D?=
 =?us-ascii?Q?pgJ2Govwi4BhYMXPI+mHT8AN1r/5gBP638jse5hwchGpyFm9k07TejkK7GT7?=
 =?us-ascii?Q?diT1oQRBLwNpwPvxBpQFNDxcFctr1XZ+LjjlzBuxtr3uKugqhsOw9Bt2nnT+?=
 =?us-ascii?Q?mL2mEqnNWPkipHhgLBUWSw/GMhz7CLMGhe1JHCEeoD/xQNjdCIiONrqjWnF/?=
 =?us-ascii?Q?g1qq6chtT/1f289av/g3FXv8YU1cHO/FiYxvF2o17BXmfEbATevAYeZDTfZt?=
 =?us-ascii?Q?i5rqaOTZzc59SkKUpfBzCusDcNTtX1+k/NowHjb7m7ocpyczma2N0EHz6u3M?=
 =?us-ascii?Q?m8LDsZtDkLt4M+tmg1r0D9IpajqUmJLtNsucGvknsLPJ8xy3wMj8VfKzCBE8?=
 =?us-ascii?Q?fbFgKU2aqTN9Eibiapbjbv1SFynX/y59nu8fyU5bmhB/79gfQq6jOPf7kSBt?=
 =?us-ascii?Q?x0TUEG1+LK29tcVqgqa/SoPDNbCLPHZsDhf+84ebMz+UtK/6gj+zVmsyOk4E?=
 =?us-ascii?Q?IGXzZTwWJKSl3mMqIVHKixwsbTiuFcsMVuzL0PdkkG3ohTgecXMjnCAoBipF?=
 =?us-ascii?Q?L+y2Dx1iF3G3yCX8PjsXtHPYWPwOxtGoGMUbMRZqN7sZezP0S2ZBpr8IIP2s?=
 =?us-ascii?Q?xQCQofceHawJhOTcA9pcOHSZuvXyY7diM0/Q7TXk4iD3rpbm3Lm7zP+ltAoG?=
 =?us-ascii?Q?43bbj+QJdbLYdqV5nC9vCNnfHntcRan0aNHdyxXH0Q/cqRttC6u5uyK213wA?=
 =?us-ascii?Q?KReWo4bjyZqAJxsMGoXxhMYxRFFIMybguCJCf+a7m95fWqCklpOGEwBx4HoH?=
 =?us-ascii?Q?BzdpDJFwpG/gQY+B8eF+buDVkrZBtTfmyU7AyF5eQzfSmErpbHrHTEmQNrIO?=
 =?us-ascii?Q?JRahiiectOWlg47rXa6poqG1b7lXUocGAuV2yzJVB/ehz9xl/5SzvDKM4zn4?=
 =?us-ascii?Q?31FhzpYU6QhF6HuzxukK6TsBQoN94p1AajuQYtM56Ss0GpRbW1ph8/5Q3C8/?=
 =?us-ascii?Q?4kIsxGWCzGfrRwU2qT+KiFlTyUpLGDL6lzmJ3oofzXEQxElrVZTSKt8oB18U?=
 =?us-ascii?Q?YWTdnEWW6li7nux6W6FHd+9N2Cvft28i+HFwuZyAItTx653faqarGgP13xZ0?=
 =?us-ascii?Q?IFvDmzp65daU/kF3fSGP9WYE4gEBnhECVOl4Z6/TsJKdOJTCGC7pZyuV/dh3?=
 =?us-ascii?Q?DY2sGMas0sjJfniTCdX/4hKxGBhNxTI9jyDnoMlR2hr0laOu9n9ezLbOZ1Ed?=
 =?us-ascii?Q?EIZE8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 789d3557-2bd9-4a7a-a56c-08da59005121
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 12:18:32.5502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNPkQnz7gDChsvF3ujsQEfYK7V61gSJPielPDt2ZrhF97YkBbludBVOcMxd9G5U14Yq4e8uMXX7jaw5XsYrrJF4WJKxt0vBcdHlg+hDpTSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3250
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Walter Heymans <walter.heymans@corigine.com>

A number of spelling and language mistakes in the flower section are
fixed. The spacing between the text inside some comments and the comment
symbols are also updated for consistency.

Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c |  2 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  | 14 +++++++-------
 .../net/ethernet/netronome/nfp/flower/lag_conf.c   |  4 ++--
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  4 ++--
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |  6 +++---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index b456e81a73a4..7453cc5ba832 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -149,7 +149,7 @@ nfp_fl_pre_lag(struct nfp_app *app, const struct flow_action_entry *act,
 	}
 
 	/* Pre_lag action must be first on action list.
-	 * If other actions already exist they need pushed forward.
+	 * If other actions already exist they need to be pushed forward.
 	 */
 	if (act_len)
 		memmove(nfp_flow->action_data + act_size,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 7c31a46195b2..b3b2a23b8d89 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -182,7 +182,7 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	u8 ip_proto = 0;
 	/* Temporary buffer for mangling keys, 64 is enough to cover max
 	 * struct size of key in various fields that may be mangled.
-	 * Supported fileds to mangle:
+	 * Supported fields to mangle:
 	 * mac_src/mac_dst(struct flow_match_eth_addrs, 12B)
 	 * nw_tos/nw_ttl(struct flow_match_ip, 2B)
 	 * nw_src/nw_dst(struct flow_match_ipv4/6_addrs, 32B)
@@ -194,7 +194,7 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	    entry1->netdev != entry2->netdev)
 		return -EINVAL;
 
-	/* check the overlapped fields one by one, the unmasked part
+	/* Check the overlapped fields one by one, the unmasked part
 	 * should not conflict with each other.
 	 */
 	if (ovlp_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL)) {
@@ -563,7 +563,7 @@ static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 		if (flow_rule_match_key(rules[j], FLOW_DISSECTOR_KEY_BASIC)) {
 			struct flow_match_basic match;
 
-			/* ip_proto is the only field that needed in later compile_action,
+			/* ip_proto is the only field that is needed in later compile_action,
 			 * needed to set the correct checksum flags. It doesn't really matter
 			 * which input rule's ip_proto field we take as the earlier merge checks
 			 * would have made sure that they don't conflict. We do not know which
@@ -1013,7 +1013,7 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	nft_m_entry->tc_m_parent = tc_m_entry;
 	nft_m_entry->nft_parent = nft_entry;
 	nft_m_entry->tc_flower_cookie = 0;
-	/* Copy the netdev from one the pre_ct entry. When the tc_m_entry was created
+	/* Copy the netdev from the pre_ct entry. When the tc_m_entry was created
 	 * it only combined them if the netdevs were the same, so can use any of them.
 	 */
 	nft_m_entry->netdev = pre_ct_entry->netdev;
@@ -1143,7 +1143,7 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	zt->priv = priv;
 	zt->nft = NULL;
 
-	/* init the various hash tables and lists*/
+	/* init the various hash tables and lists */
 	INIT_LIST_HEAD(&zt->pre_ct_list);
 	INIT_LIST_HEAD(&zt->post_ct_list);
 	INIT_LIST_HEAD(&zt->nft_flows_list);
@@ -1346,7 +1346,7 @@ static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
 	 */
 
 	if (is_nft_flow) {
-		/* Need to iterate through list of nft_flow entries*/
+		/* Need to iterate through list of nft_flow entries */
 		struct nfp_fl_ct_flow_entry *ct_entry = entry;
 
 		list_for_each_entry_safe(m_entry, tmp, &ct_entry->children,
@@ -1354,7 +1354,7 @@ static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
 			cleanup_nft_merge_entry(m_entry);
 		}
 	} else {
-		/* Need to iterate through list of tc_merged_flow entries*/
+		/* Need to iterate through list of tc_merged_flow entries */
 		struct nfp_fl_ct_tc_merge *ct_entry = entry;
 
 		list_for_each_entry_safe(m_entry, tmp, &ct_entry->children,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index ede90e086b28..e92860e20a24 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
@@ -234,7 +234,7 @@ nfp_fl_lag_config_group(struct nfp_fl_lag *lag, struct nfp_fl_lag_group *group,
 	}
 
 	/* To signal the end of a batch, both the switch and last flags are set
-	 * and the the reserved SYNC group ID is used.
+	 * and the reserved SYNC group ID is used.
 	 */
 	if (*batch == NFP_FL_LAG_BATCH_FINISHED) {
 		flags |= NFP_FL_LAG_SWITCH | NFP_FL_LAG_LAST;
@@ -576,7 +576,7 @@ nfp_fl_lag_changeupper_event(struct nfp_fl_lag *lag,
 	group->dirty = true;
 	group->slave_cnt = slave_count;
 
-	/* Group may have been on queue for removal but is now offloable. */
+	/* Group may have been on queue for removal but is now offloadable. */
 	group->to_remove = false;
 	mutex_unlock(&lag->lock);
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 74e1b279c13b..0f06ef6e24bf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -339,7 +339,7 @@ int nfp_compile_flow_metadata(struct nfp_app *app, u32 cookie,
 		goto err_free_ctx_entry;
 	}
 
-	/* Do net allocate a mask-id for pre_tun_rules. These flows are used to
+	/* Do not allocate a mask-id for pre_tun_rules. These flows are used to
 	 * configure the pre_tun table and are never actually send to the
 	 * firmware as an add-flow message. This causes the mask-id allocation
 	 * on the firmware to get out of sync if allocated here.
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 9d65459bdba5..83c97154c0c7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -359,7 +359,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			flow_rule_match_enc_opts(rule, &enc_op);
 
 		if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
-			/* check if GRE, which has no enc_ports */
+			/* Check if GRE, which has no enc_ports */
 			if (!netif_is_gretap(netdev) && !netif_is_ip6gretap(netdev)) {
 				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: an exact match on L4 destination port is required for non-GRE tunnels");
 				return -EOPNOTSUPP;
@@ -1016,7 +1016,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	    nfp_flower_is_merge_flow(sub_flow2))
 		return -EINVAL;
 
-	/* check if the two flows are already merged */
+	/* Check if the two flows are already merged */
 	parent_ctx = (u64)(be32_to_cpu(sub_flow1->meta.host_ctx_id)) << 32;
 	parent_ctx |= (u64)(be32_to_cpu(sub_flow2->meta.host_ctx_id));
 	if (rhashtable_lookup_fast(&priv->merge_table,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 3206ba83b1aa..4e5df9f2c372 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -534,7 +534,7 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 	}
 }
 
-/* offload tc action, currently only for tc police */
+/* Offload tc action, currently only for tc police */
 
 static const struct rhashtable_params stats_meter_table_params = {
 	.key_offset	= offsetof(struct nfp_meter_entry, meter_id),
@@ -690,7 +690,7 @@ nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
 
 	for (i = 0 ; i < action_num; i++) {
-		/*set qos associate data for this interface */
+		/* Set qos associate data for this interface */
 		action = paction + i;
 		if (action->id != FLOW_ACTION_POLICE) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -736,7 +736,7 @@ nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
 	u32 meter_id;
 	bool pps;
 
-	/*delete qos associate data for this interface */
+	/* Delete qos associate data for this interface */
 	if (fl_act->id != FLOW_ACTION_POLICE) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "unsupported offload: qos rate limit offload requires police action");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 6bf3ec448e7e..0af5541c6eaf 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -1064,7 +1064,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		return 0;
 
 	entry->ref_count--;
-	/* If del is part of a mod then mac_list is still in use elsewheree. */
+	/* If del is part of a mod then mac_list is still in use elsewhere. */
 	if (nfp_netdev_is_nfp_repr(netdev) && !mod) {
 		repr = netdev_priv(netdev);
 		repr_priv = repr->app_priv;
-- 
2.30.2

