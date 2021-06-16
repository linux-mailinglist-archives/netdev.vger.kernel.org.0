Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFDE3A96CF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhFPKFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:05:12 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232279AbhFPKE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHwvUOwfLDP6fsPRiz/EPETcgaiJdbqW2o/wEd9FS7ecHOTP6wM1DJ7ApN5rEsZ63vnd7WZtZMaX+N2R9GLDmUw5pHzAO/P3cU0GKJn9RyFs4295Y8EMVfHYwiAZub3Bh/kPHAYX/+fJqe7St9vg4rJc9sZMKCkRulZb8nJbMoo5H+HDjwHRQGzAGPeURNGZ68ESEhGKvZke5rpH+k5fQ/w9l2ru4aAlvDBia6T8E80FXspze2i46S2lRWtSDPKgBwBXEbifK/fRORrrWQWaM5nUMCw+6QQg5lIJpfjmm08bcbCky/iv38SFk06R1aUKirOqopkibXI5QMDFGJ8JFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBkWBPXkAzdD91b6W43DLCVijcmWHOo2AMsqdXM5rRk=;
 b=cIoWSs6U9vTHD/l9UXwNPPGRqPzNzE2WAMq0/tSflZ8s5GMoiuM8jDFuK+HG+z/bcIppl7Rr/YrJMfSfwdLGGuO063xG6IlMcXOwVFWQgNdPkuzE3YSxL7XwqzbQcwy3q8Qn7jL5d3GBLF1tlpNkFi+q+8v4Ehf/6q84MtEBCDS1Q1HsXmfvU0yn//2cxc6Hc8JZ0YsiIlO1gteZU3Lx2LVjLXrkr5Z3kO7Qf9eDuaqjcXIwuw6fwUq0MhWJI5YbvIuz36+vYDmE9CKJqocAcTp0jN14rUvfoR8htPITIxfbg+Ve+IjGEnBXmF48TPToBb6ld2jOhRa97PVSew6Iqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBkWBPXkAzdD91b6W43DLCVijcmWHOo2AMsqdXM5rRk=;
 b=pJBwzIR3u1efHyX7a3ymhYbBljGyq9bG7PV++8N0w+ulGKca6uGppAmMBFl9FeEU3uEhBiSjCvGp/g1pYpGDnqeImFlQAECDc0nudZWalhimTqCPESFyljKAsp9vSEAQZRUT7cLmkrIvmMY/i16RlIAgMrrk3v1mtLDApw89YdU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 8/9] nfp: flower-ct: fill ct metadata check function
Date:   Wed, 16 Jun 2021 12:02:06 +0200
Message-Id: <20210616100207.14415-9-simon.horman@corigine.com>
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
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbc5d0de-e3f1-47b0-b1cc-08d930addf54
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB497142F57FD4E65D9F546FABE80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dS84D8dHX8oBYKnIs//F8e3DIpLFcrW/TIptFk7JaoSRnnIKs9DOdGI2IzqkVoabYJviPtEIJecrz0QyIYf5ho68XFBHQlk0hiWNHXOikufIQtmlMORpOYwn2IH215RTVX65c05A3FtcMyh/SF5jWM7NqMX3xqFgSKp3Xy2okl0SFLE4S8S0ng1rrR/bv+QuOeCdipOgqdLpTdoJoiMmvDzyD7gVQZxbDXsbh7xDL3toBYYzwLSru8H8qx9PA85XdH0yPjmZqbIORM8n8a85DN2iRu8ch0QQX/Zjy3XE960Pw9Y6Jsenv7+0O85bVSlGCT3SznSfeQihBcpjC9hmZWewihcIJGKCCXDOesK4Ui1/kN/QxxIdAE9KQT5LiRwp7Tu4BO5VynZhh5urzcbTKsZJ3qtHwCOUVm8bSRYih1NN13Rp26s+0E/cEBAC6CpEv/xO9z6XJzfpPphDIWJH9N7ho3zWGOov41wk3HpDrBx2mIcsj8geeGIADKNEMqwWbyl/nBBcd3gxoLxC6mFXauNey4RD3EzD9tAwqyEPhawzYYN08kHKmPInAFFdAvUaWSm19SLmUyKdHr1M1MBSOjDFHsbLkzB9s76DE1LvsNpv9ekvbjwOnAdF7UTHn73x7ec0TY4+mDoN2uHKqMinhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A6C6S4wdlCYuQRjSd9BpgJfGF3eVywfkC69xuIjs4/hT/k0zaa/0vB7hvZJn?=
 =?us-ascii?Q?l5EdY6C/NHUGICyDI7QW2G5Aphs2HeprgpcRuYBFenwwtBNP6i/jb9CBvEq7?=
 =?us-ascii?Q?geFGG2yOojuZl1fNnOu7Mjofk8/zyYP6kbyafviHViilKiBGB2yXw67VDZ/e?=
 =?us-ascii?Q?vRCD9w8jnG3AT4ULRiPEzoCeOUPpgeDruIcV9m/+c+BRVYbdjpCgLl8k0ZPi?=
 =?us-ascii?Q?cmO4JytQ8jr6gfHTw6zF+4vJ5WhWNAjuHvzJbt+oIHQgq26Mk4MDt7k7XqYX?=
 =?us-ascii?Q?iuPBGKgxeZXX0Lk0UT9zgdV6P3oYONHcbi0tQZ38brF3po8xBRSFxauiETeS?=
 =?us-ascii?Q?F8KThddh1Bt+Pyw7kh2cCVB5QsJtpyQKUpifUSHGJWcbM7uXeFppH701/AX5?=
 =?us-ascii?Q?I3U7YngCSEagKEWMC8dc2lYHFBz0ZUCMStxtJMxvo+GQfmmDtndbBoqHXWTV?=
 =?us-ascii?Q?lob0SPKc1v4MBA4ZFkLpUo3JWaqOzb0Y72sbhV1J+mjRouiiBeNrXe4fbkGz?=
 =?us-ascii?Q?hwHg1Oad+9EEHPQ78GeN3xESsmzea8enYAh+iEM8kW8lFTTSLiFP01XK3MRB?=
 =?us-ascii?Q?LEntiMeUHYkV8fb1EhY7o6Gj+CTjoFPeN7DrxJRs06bucYbfQExpkHyueGQ0?=
 =?us-ascii?Q?stC1ughSntuonTKgv/ekJhCOkfmPxn6LF1PuwjzesU+bSRcfJroHYH0qivZA?=
 =?us-ascii?Q?ytBkGekXT5pCxfdnx0AqpJD6Nso544sK06VF56/aKtk2mZsPtORsNyBnvFP1?=
 =?us-ascii?Q?5G5//oCfZaG0e1lMTpVXnJm5Ioh0oyicz0rPvdxDPc6ic3W8wEWIBqZtTRih?=
 =?us-ascii?Q?5CC4l7KSGMy1nSKqL5ytoUP+7vsCNvDWWmoIiL0ah6wWdfdhJm4y5pS8lXxZ?=
 =?us-ascii?Q?sbwWbdrNDgfHSZT6HBAOrL0BP+eEmoSe1JGDw3jZJMtW0k/Nlmcc04L2f6il?=
 =?us-ascii?Q?Hz3kde2hGgZEnZMAUK1IlWmpTYWmZLIjs6B8xeyCFon0AkPQSPdtQq8k8S63?=
 =?us-ascii?Q?F2qSkft1yFdw3hkK4qeNL6V0Zm1uKnfZakb047ivtylVjjoT8RT6BhicH+3M?=
 =?us-ascii?Q?CLcoBAH1O7MA3GOSK+Mb4xRbJOUR4V0vrgON/V/qjd1AQv4e31vN5gGF31AU?=
 =?us-ascii?Q?Lx3V0V1yhR9VEz56h0FK2V/D62/yLIS11oPq1URAzPkHivpcOeTfUpI32G1Q?=
 =?us-ascii?Q?1b4Bn9j0Tuj2VQvy5eLUZ9KPzLN/hZtdYuYbl+vTPegLsz3FJN8Ytknf6lnJ?=
 =?us-ascii?Q?VYQQIKKqxPi/sqabF0lmhxCIGlk4DeDvLJukLhCcVj49NdyVouGdCvKuD8DV?=
 =?us-ascii?Q?EU4bH6opqihlC6CkJnnp0UTVKN9yf3E1slngEjPWXNf+oVXP8HiWhauQwwWS?=
 =?us-ascii?Q?TX66I3AQP6PMZYnXqAqHd+qogaoI?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc5d0de-e3f1-47b0-b1cc-08d930addf54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:38.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBDhEzrew3LaRENQe4AfcHCRhQA27a+hn5ynnTBXurOmH0X8USYzuBCvYe0Q7X2FtjkKrGzW/j4F3Jdl6J5GmFoOZmrTteyescpFF/VAfcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Fill in check_meta stub to check that ct_metadata action fields in
the nft flow matches the ct_match data of the post_ct flow.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 37 ++++++++++++++++---
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 8bab890390cf..6aecaf41d9cd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -19,6 +19,9 @@ const struct rhashtable_params nfp_nft_ct_merge_params = {
 	.automatic_shrinking	= true,
 };
 
+static struct flow_action_entry *get_flow_act(struct flow_rule *rule,
+					      enum flow_action_id act_id);
+
 /**
  * get_hashentry() - Wrapper around hashtable lookup.
  * @ht:		hashtable where entry could be found
@@ -258,7 +261,31 @@ static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
 static int nfp_ct_check_meta(struct nfp_fl_ct_flow_entry *post_ct_entry,
 			     struct nfp_fl_ct_flow_entry *nft_entry)
 {
-	return 0;
+	struct flow_dissector *dissector = post_ct_entry->rule->match.dissector;
+	struct flow_action_entry *ct_met;
+	struct flow_match_ct ct;
+	int i;
+
+	ct_met = get_flow_act(nft_entry->rule, FLOW_ACTION_CT_METADATA);
+	if (ct_met && (dissector->used_keys & BIT(FLOW_DISSECTOR_KEY_CT))) {
+		u32 *act_lbl;
+
+		act_lbl = ct_met->ct_metadata.labels;
+		flow_rule_match_ct(post_ct_entry->rule, &ct);
+		for (i = 0; i < 4; i++) {
+			if ((ct.key->ct_labels[i] & ct.mask->ct_labels[i]) ^
+			    (act_lbl[i] & ct.mask->ct_labels[i]))
+				return -EINVAL;
+		}
+
+		if ((ct.key->ct_mark & ct.mask->ct_mark) ^
+		    (ct_met->ct_metadata.mark & ct.mask->ct_mark))
+			return -EINVAL;
+
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
 static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
@@ -727,13 +754,13 @@ void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry)
 	kfree(entry);
 }
 
-static struct flow_action_entry *get_flow_act(struct flow_cls_offload *flow,
+static struct flow_action_entry *get_flow_act(struct flow_rule *rule,
 					      enum flow_action_id act_id)
 {
 	struct flow_action_entry *act = NULL;
 	int i;
 
-	flow_action_for_each(i, act, &flow->rule->action) {
+	flow_action_for_each(i, act, &rule->action) {
 		if (act->id == act_id)
 			return act;
 	}
@@ -791,14 +818,14 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	struct nfp_fl_ct_zone_entry *zt;
 	int err;
 
-	ct_act = get_flow_act(flow, FLOW_ACTION_CT);
+	ct_act = get_flow_act(flow->rule, FLOW_ACTION_CT);
 	if (!ct_act) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "unsupported offload: Conntrack action empty in conntrack offload");
 		return -EOPNOTSUPP;
 	}
 
-	ct_goto = get_flow_act(flow, FLOW_ACTION_GOTO);
+	ct_goto = get_flow_act(flow->rule, FLOW_ACTION_GOTO);
 	if (!ct_goto) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "unsupported offload: Conntrack requires ACTION_GOTO");
-- 
2.20.1

