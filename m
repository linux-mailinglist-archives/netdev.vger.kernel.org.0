Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611AA3A96D0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhFPKFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:05:19 -0400
Received: from mail-mw2nam10on2094.outbound.protection.outlook.com ([40.107.94.94]:30432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232382AbhFPKFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:05:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nM9t0WBjzMD5dDALpGAHMxDIu+Eqo1ijIgEA577kaIJCnZumvR74aQZHR+ZzIf17+I6qLZbe9m0LIH2ab9x0Wb3QwAkI4pn+/cBRMGbxqBMRuvbE+RoWMkHa9H6wnOVqATrKjBgYfGw/XHL3O4D/8/SACZBpYWqH7Wu/gZfznkujRyXx/y04IG2zHoMv/QqbfFXqd+iwav4VnnaSNAafgkjUeqmxEzxSg5jMTkwx8OMa9xtxIIjXcB7Ovd9d2+ladiqbxmYwWvePO3ZPUfLAfnqzBr7zhW/yfiCkX9NGfOFs5GwQnPbw+3vIcwr/4yUVp0ijSelBfbhAWr9OjfOkCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyGwdHklGMyTyvLY8oH+q0ulqcXgEdTgoDUI7R6BDDw=;
 b=JaQFOzjnGFER25tQULRmWzlVkq7LDM+OqvVXHJpEq90wKr3eArYceC28Zkj+WCC/zPfkWMczRBn1yjdFRadFp+tYFtxDfGHaejpuCnReEG0xsUhhGQz4NLk3yrvsFpPqs3+qyf7GKMeN4XGaYp/8TKK9Rpiv0nHbd8a0y2Xv52VOEAa909jtXUR2Md/CvwrRqnYuBhIzThrXcKkmRPA1L4qbGlIfchgzioB1F8DmDIQvTsSaJuWvlsUmyKwm/EdYWIfj8u6iuV1RfcwINvksi25YeagL3UMxu+PaWVpngIQn3Dwpgm51toRDz7knOfNy8sdteoqp38R6nrbR+fESYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyGwdHklGMyTyvLY8oH+q0ulqcXgEdTgoDUI7R6BDDw=;
 b=u7eMwyMmL/G1Vdu+0GFrAKHElIPZuJw2AirAgHFEEsr6ekD4XGmiByKk95AE3jge+RNLiwZWSNAZVGfOFnBse6HPxDWQ1+7LSH4X0rzabvH3fIqfUcHBNR8eDJuYFL+LO/Dk0GUi+fGdzHbrFVjJqGANhCFNXocucRg3/DnGVJk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 9/9] nfp: flower-ct: implement action_merge check
Date:   Wed, 16 Jun 2021 12:02:07 +0200
Message-Id: <20210616100207.14415-10-simon.horman@corigine.com>
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
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48354757-ee06-4635-4391-08d930ade057
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49716EF5BAD5412931AE0780E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4TrMDFveu3YaTTC6xlZM01s1el6O02i1aOwPGMxAJasT9tWtoWgL9H+GbFI0qulxSG8/nH5N7Bz9v7vWHNwAL7B9XwbBNedMQihR6XwPQGza6uQBP+wxmFAOwy+bz+Q5m6JDQwz98+O6CSmJqrGMgiYxwcNfl/iHunRO2Dha4BuFG3WwRLQq6qntw1+RxOt+0iXX60Gx5UAR6NC9wpLAPhALRDWvhkErzuqdogV64gV7XCTB3/Lvrzs2Fk7tMedxpi0hwmFE1qclXnYkFsRHmvgpmenfO+nn5CddLPFNFv4d2wakoyYWryEIgwL7tL79DX/g1/YYQkjMI9tv8a0fonp9LhLp6d0txFcGIbeF924cNlhfVeBKV+kGBncPuNE3Opn7QWcMDj033pigQpS1z15mpOLRvU7WkNFrKeZhXmK8s8864WG5LBE183GHqKOSud7dYzaxjfMPy9wIhPwcCCy7cli4WH3noZbqa6rJYZxgsEDnPSZiyI51KFghd7//ZqCWrwnzVYg4in/DbG0saOKqg8RtgslrN+oZbbIMjHO4P+nbEDKRgOwnX7izPLUjw4uZvWzXjhMe6QvKGYc4M7wGU0jBbVW5qFYdFHiTjQS5vKMMQu6L2mFI1nloiE8lBnWUqCXSuNJk9T6OhXNzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YtPtYg+jI2WxEGG4cNQ7Rm+YrDcJmerGuj+R8ot6zg6jxdHzt1IugrZJ/x7R?=
 =?us-ascii?Q?l5GgfIV40I/Ma+Cvzt/sWisO+6I/DMLUVGlyAobnU2BNt+dZXdmsmyJqVbPg?=
 =?us-ascii?Q?vk74nMP7/qBJAI91GvuBGPBMG0NYBS9IAEdqscC1lrQLMHVjaEWQOhzX0YuG?=
 =?us-ascii?Q?LAizjpmgiuZcoqJYcJCGUtwsPTL1AWJ+GW5ste/hfcIPWDxgf5W9394cBkvZ?=
 =?us-ascii?Q?J6u+aAzXEjcN4C5lA9BHP37Ug7nI3ul3XZ/1TXRUArFeL8gpDocoEYRHvQeq?=
 =?us-ascii?Q?GPQwe1khw/m+XBO3odCMN6JFlw/t/30jmnVcf8WF3yPOLcTDt2Vza3NYczh6?=
 =?us-ascii?Q?MZxlQ9WrsretU3sJLMQ+A4ohmvC2sfw9gKoiBAHG1yB7LKGdYvM0AGVn+7H4?=
 =?us-ascii?Q?vnmgPMbGvJOU8TpnbZblk8njGPqKS5yKtktK1QS2lOx/SS+DKxvhW0J/JBmb?=
 =?us-ascii?Q?fPVU6/R6hqXnFHVNUdz/Ts2AESOxaotXc703P6KcWygwjx+64PDAF0/zhjYJ?=
 =?us-ascii?Q?lsS7mkNRyUulxBRbJAu/2Epl4jc/HW56tLiK1JRg4Wd+9Tod6CnDrrb5NZ4p?=
 =?us-ascii?Q?+N2SxIHmnvhoUqxprt0t9vdWLIunwjZ6eY4t2bE8lg0tVUV98Z0JYebd/8JP?=
 =?us-ascii?Q?U4S/2UKNlaqUFg+LWik1GltE9pyngnrV5edo+LMoARxzlStqQKr1NWp5H0nO?=
 =?us-ascii?Q?gKHaDA4w1YIECijQ56KNK5xM0riO8bjKy1GPCNnDTZXN++DGMHlcZYGncvkI?=
 =?us-ascii?Q?pVBlqD6sU60iD4hHofzmyk1dNndb+3NmripsgJNv3kZhoVSXz4ipzVcT8uJA?=
 =?us-ascii?Q?ngSLjrMrtALtAaKGX90QyMVvyZXEG6Fzrd5fPqh5zm+MQ+mQilKWRPt87iZg?=
 =?us-ascii?Q?TVs8EY1gh+kUwKEnGlFHmARPV6GkM5ZTrmXtjFiTvWiS6ny+MaQqbpEw+kPt?=
 =?us-ascii?Q?JrGkHV6RuYcKTdG4GPF1LzyW/adtGb8NVpLy68yha92uYPnQTWd+X1LeYyOh?=
 =?us-ascii?Q?sZfY3Tnn4GONt0Yt6KHCwfiTudMn750bz+x4WRITHwbVW141CY5xFS49yDh6?=
 =?us-ascii?Q?XrnQLiW3MkM28gO8V6mWEhxLrMcjaJ8D3ZfUB9nJCy7gBRyXpmQwiN8TEpFP?=
 =?us-ascii?Q?umqLnRs6egMEb6XgFD/gJk6mEPg6A1mwygfS9GKHUD+7SU1mDwvHew0H3g4k?=
 =?us-ascii?Q?r0ZMRJ1LjuNlQu7tORUtp1MA3z+DyVF1gGU4Hq72QUCyms49Q71ol2vXRACT?=
 =?us-ascii?Q?5KlFNUi+SLh5gnju8Ujlq6rM3UWJOeOGWtZ+UXFSzqOt2H4sfolB/zq+Jhey?=
 =?us-ascii?Q?akX6K2jDcWhNkDMwNtDrcYjL3dIUC44qgCk+Ia9E4v1KAqxa8KlLbBd1Es7i?=
 =?us-ascii?Q?m43XSTPIyji2ojjG5B0niqDyUly2?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48354757-ee06-4635-4391-08d930ade057
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:40.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClRcss6/jrRmVKI28ZAtq83+C1SHWWeOZR/30eFTaLgmAjAgckBQdNmk2EqXjwQKRZo+LhAoUuEoehC+/lgVtm75YJsqKx8VzXb2Js5iKDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Fill in code stub to check that the flow actions are valid for
merge. The actions of the flow X should not conflict with the
matches of flow X+1. For now this check is quite strict and
set_actions are very limited, will need to update this when
NAT support is added.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 119 ++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 6aecaf41d9cd..9ea77bb3b69c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -251,10 +251,129 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	return -EINVAL;
 }
 
+static int nfp_ct_check_mangle_merge(struct flow_action_entry *a_in,
+				     struct flow_rule *rule)
+{
+	enum flow_action_mangle_base htype = a_in->mangle.htype;
+	u32 offset = a_in->mangle.offset;
+
+	switch (htype) {
+	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS))
+			return -EOPNOTSUPP;
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+			struct flow_match_ip match;
+
+			flow_rule_match_ip(rule, &match);
+			if (offset == offsetof(struct iphdr, ttl) &&
+			    match.mask->ttl)
+				return -EOPNOTSUPP;
+			if (offset == round_down(offsetof(struct iphdr, tos), 4) &&
+			    match.mask->tos)
+				return -EOPNOTSUPP;
+		}
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
+			struct flow_match_ipv4_addrs match;
+
+			flow_rule_match_ipv4_addrs(rule, &match);
+			if (offset == offsetof(struct iphdr, saddr) &&
+			    match.mask->src)
+				return -EOPNOTSUPP;
+			if (offset == offsetof(struct iphdr, daddr) &&
+			    match.mask->dst)
+				return -EOPNOTSUPP;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+			struct flow_match_ip match;
+
+			flow_rule_match_ip(rule, &match);
+			if (offset == round_down(offsetof(struct ipv6hdr, hop_limit), 4) &&
+			    match.mask->ttl)
+				return -EOPNOTSUPP;
+			/* for ipv6, tos and flow_lbl are in the same word */
+			if (offset == round_down(offsetof(struct ipv6hdr, flow_lbl), 4) &&
+			    match.mask->tos)
+				return -EOPNOTSUPP;
+		}
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
+			struct flow_match_ipv6_addrs match;
+
+			flow_rule_match_ipv6_addrs(rule, &match);
+			if (offset >= offsetof(struct ipv6hdr, saddr) &&
+			    offset < offsetof(struct ipv6hdr, daddr) &&
+			    memchr_inv(&match.mask->src, 0, sizeof(match.mask->src)))
+				return -EOPNOTSUPP;
+			if (offset >= offsetof(struct ipv6hdr, daddr) &&
+			    offset < sizeof(struct ipv6hdr) &&
+			    memchr_inv(&match.mask->dst, 0, sizeof(match.mask->dst)))
+				return -EOPNOTSUPP;
+		}
+		break;
+	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+		/* currently only can modify ports */
+		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 				  struct nfp_fl_ct_flow_entry *post_ct_entry,
 				  struct nfp_fl_ct_flow_entry *nft_entry)
 {
+	struct flow_action_entry *act;
+	int err, i;
+
+	/* Check for pre_ct->action conflicts */
+	flow_action_for_each(i, act, &pre_ct_entry->rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_MANGLE:
+			err = nfp_ct_check_mangle_merge(act, nft_entry->rule);
+			if (err)
+				return err;
+			err = nfp_ct_check_mangle_merge(act, post_ct_entry->rule);
+			if (err)
+				return err;
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_MANGLE:
+		case FLOW_ACTION_MPLS_PUSH:
+		case FLOW_ACTION_MPLS_POP:
+		case FLOW_ACTION_MPLS_MANGLE:
+			return -EOPNOTSUPP;
+		default:
+			break;
+		}
+	}
+
+	/* Check for nft->action conflicts */
+	flow_action_for_each(i, act, &nft_entry->rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_MANGLE:
+			err = nfp_ct_check_mangle_merge(act, post_ct_entry->rule);
+			if (err)
+				return err;
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+		case FLOW_ACTION_VLAN_POP:
+		case FLOW_ACTION_VLAN_MANGLE:
+		case FLOW_ACTION_MPLS_PUSH:
+		case FLOW_ACTION_MPLS_POP:
+		case FLOW_ACTION_MPLS_MANGLE:
+			return -EOPNOTSUPP;
+		default:
+			break;
+		}
+	}
 	return 0;
 }
 
-- 
2.20.1

