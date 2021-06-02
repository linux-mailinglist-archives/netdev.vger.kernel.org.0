Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463963988C8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFBMCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:02:53 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:6496
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229765AbhFBMCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrwhyMhzExZAxUpzzlIpeFcCbr0IgE/5cqVJAtUF5gA+236YnbxjRnetgRDm8X+3QmLSPAuPmHumNEiKQzlzt++kGddqvXZhgI2HPtyL+i1xyXFzVo2yHELW50a00o5sAk3gpiapON3Vgc+iuTARXMVdTm0xFklfjccH/3bYkBxa8F2lXp33E7CYd/OQQVSj5YgvTQtp+Jym5q/udYMOr6Cpn7QfHQ6HpmHxT8ojMqh9EvHsf3K80hnw/9mcKBkFffx4H5b2SXI4m13RBHjxoDhwIjsydDHesCykbfb4KxLy0qT7IGvwhVv74eIXVkBSHBV1Wze9aDyNEZfRj79vCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bZf2r92aZyzHVMYvs8+PJ0xF5cqzQmo2N0d+moaspM=;
 b=eiWq3bLMrs6zhXi1fnCUxFkGJLH1HxfMuP53OYzZn446YYswn4dKsFSULeJK3w4Fnn5vIe+5y1sJ3Vt1XIO4vLM/WN28U+MZAEKpCpu+QmUyy0080Yj+VoWFW0dP/0fFwPmVBqhI3SSjFJvtVkaEY0jMGnEG/Nny1sXXBim7YJB6XcekHLRuR+7LLaV7CLLqdw5qzjB5I0WZ+hKLurbKqtk7VfS1v1Hzmhw1lX7ps03/CQjVUgCPgCGdqKtHn7FjypVg5A7X1njOZgzaUt86h38k44T7pJSG6UFd0nQSEYFQ3Z5W2eXDV3LHgWiyKph+gEwEMSOugmZLGXfdoUOLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bZf2r92aZyzHVMYvs8+PJ0xF5cqzQmo2N0d+moaspM=;
 b=nmfCh9eCRYjBeiWa8g0hP1Sny3CZ933KjEuJpqWLUpPMp+PVAXctUpIy8eFJ2+4+SqcA3DwFcyG47hKgHdMrPV1FA8sq1GD39S0hBCqir+EjGd2fYNVt2UowemFKNdzItgDd9oJzNrkwoPXDLuVZcp6Z8WT3YkjuBoDxJa8wXcY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4986.namprd13.prod.outlook.com (2603:10b6:510:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Wed, 2 Jun
 2021 12:00:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.018; Wed, 2 Jun 2021
 12:00:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 8/8] nfp: flower-ct: add tc merge functionality
Date:   Wed,  2 Jun 2021 13:59:52 +0200
Message-Id: <20210602115952.17591-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM9P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM9P192CA0012.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 12:00:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0535b9d5-9da5-4a4b-84bd-08d925be0263
X-MS-TrafficTypeDiagnostic: PH0PR13MB4986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4986BE95F163371DADDB3AF4E83D9@PH0PR13MB4986.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdNfuhGiKM12uNgF9RIAuJRbtI7nW8ql5UEu5VRJ3QF3Hq6qiihxf7PU05celPt3bhTR6lURaRNQK2l1jvERR2eqEbz2pmUJop9amCEPlNgCO5qykMP3MV/DIvDu4TXEP5fZh5qEV+izXB6iFM7VKT926teGvB6PHP19eEw4qReYAyWXA52N2KehBb48bo4P+Z2ytU6Mt2so5hMOns0h5PoeJnNMoTHd6gzXl/0LgGYHujpDqQ3iXHG24aN8S/uY/1CWeW/GKVzxG0b7Ypg7LUYhb17fQuAoxlU8ARKhMHxadvdHzoUHp3Vceabm7kbjEPTVv0dK4qFDuQMr6Jq+dUYeBQ0bWXKMluJYKOJbsQbbQd6u3m5JkPEUFGpKCgXVuT4gCUXV1OI3HxVICn4RudHYW6wyr2ciplhAhnlTJOGQkr7R/S26mxuSCVUjTQaTHQCusxNlZH6YJm6EWxa84Aj7In7guH0+a4ih9HdPD13SZvYyHch5+DYIF2CtgbgA4iopriBnmdiqrXC5Lrk/ZA2ZGfivGGysKvYJ+4YriQW4zK/4u5Ke/FsVe3EegGTKrkHHLHjcsB3ss2+vz//jLRQb/9W4Yp5Ef2I4yA6bvV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(376002)(136003)(346002)(396003)(5660300002)(44832011)(36756003)(66556008)(6486002)(107886003)(66946007)(38100700002)(1076003)(8676002)(52116002)(6512007)(6666004)(16526019)(4326008)(66476007)(86362001)(83380400001)(2906002)(8936002)(478600001)(186003)(2616005)(54906003)(110136005)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ejfqAH9fnr5vX/lzXinwrKT7+m8yIiFBtVLtd56mR9Bnxd0Fh2lik3APmyxw?=
 =?us-ascii?Q?5SBhAZyd3m8EzE2vxWo5+TjCPZ0ty/n4IK+LHNV7z8CA3AOlQ+btqif33m9G?=
 =?us-ascii?Q?W6xNugPjCcNfqU1ItIlqHJKM6KrtCcyOdscC6ivc13Aqph3iWS/uqFHNLqo9?=
 =?us-ascii?Q?2vWRKYwr7+/LpnNYdN+qcIKS+5B6Ug7ZOCvB7Wf+Nf4/bdwkD8r4pHHkwIbt?=
 =?us-ascii?Q?Q5tf9EIwP5upc3gdy4N37z2Mt0uzx2nNBOBxUhVrKQdIj3ntXV2T2a4QOpHW?=
 =?us-ascii?Q?6kmVSeisHxKtGvp2/XcjercOlGFmukTxqCMNxrQ/tqzw/pMsVHzwUqAEypwH?=
 =?us-ascii?Q?ogQ/ijd7P+OgPwX4dpFBHAG34KyvNPxzu0wafndJn3TQwetw84izzlq2zxnu?=
 =?us-ascii?Q?npAYLJNlGEvDhosqqLYXymTZPOyX0UJ1XhjTzegVYCsUA4hG8byOFeNGtrWe?=
 =?us-ascii?Q?6Lmb7+C1MFSYy0Y40h+HM0wfTrYbvvVYJOPXCwUgEv4/rn6DI07ZWgThhijs?=
 =?us-ascii?Q?Po/umLPWyqWXz0yArQH0KdM3OIQE+y+qGjlcLMBUz9f2PEIrFZkDSW3jjV4d?=
 =?us-ascii?Q?MzFigB6FTxVluQ15wcd9+Vg71ppnS1alna39XzEvLBotqt7qfOtUgRBK5o3c?=
 =?us-ascii?Q?uSUP0SYDFMHBEEE1cil+7ej1hE0FafJWrJZX6t52ooLH5EyjVwmDLlHNh3zx?=
 =?us-ascii?Q?FSw99X/hJsynpKEI8FJKNSFoz3flD+pA3hnsbp9xojIwc9nN/TGHyx5BcHc6?=
 =?us-ascii?Q?8xBiHwfVusC4c3Aj1k8mmcKdfGrSsYfLhBBzj2hnoA4VHfMyTVToK83AcvKd?=
 =?us-ascii?Q?tY/WzlCZ9IqjShf+icjJGWiumlqPVIehKFoPX336ySepsUgnoeM2kj5/SCq4?=
 =?us-ascii?Q?5Ih1E8huM3e+eOupijd+TZ0VN70kzA5poBuALkoauHj4i1c3NpLO50zFA+5p?=
 =?us-ascii?Q?OJZxWukaFUIR+VYf72WVyEsUEcFQGHWZK7WevjjCrawCTrnD8KZVTmbgngQb?=
 =?us-ascii?Q?1Yxd1tq6+qujFt1Jim8L1jycSrk9SQcbA+v9PVBgCCCjRmVSEuqokecFZgFf?=
 =?us-ascii?Q?zUEpqnZP/RLZJW+WPHPqCSV4zGj0sDGayy5zok+FgDRhb0TCMKmRJJMDUrc8?=
 =?us-ascii?Q?Xkas4FxTPkrM3JdTW/9L+k/he/fLMjkAGzqPPTwawM8Agx0r/2HSLIUwxn2H?=
 =?us-ascii?Q?SvuSEbk4/TELMFFDXK3k51r/iQbXtyACDEUawoAB8HFH3fsOhmaZOiMbaeGS?=
 =?us-ascii?Q?aAhGBraJd6+RyZiD6yLkH278yS1xHOjfOoDZnyG/lqI7pOLbmu8FI2C3Vn9c?=
 =?us-ascii?Q?FXVmiuohoSa3UB1PgXUclaDq2ESRtundGQqPSdD0qoxBdrNjT34yPi9rIXf1?=
 =?us-ascii?Q?t7zyiOTEncuf/8rTexT/K6sTeNTG?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0535b9d5-9da5-4a4b-84bd-08d925be0263
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:00:26.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vm3XyUhHaB5kWVoKKk7Eu94cdK0Zy4vYU/Zt+vK1TJ4FxrMLVJ2k2irNEwNNs3x4o3TBlw/L6yE15BpzSyKgbo2ny/i2Dp+ZddcX8B9fIN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add merging of pre/post_ct flow rules into the tc_merge table.
Pre_ct flows needs to be merge with post_ct flows and vice versa.

This needs to be done for all flows in the same zone table, as well
as with the wc_zone_table, which is for flows masking out ct_zone
info.

Cleanup is happening when all the tables are cleared up and prints
a warning traceback as this is not expected in the final version.
At this point we are not actually returning success for the offload,
so we do not get any delete requests for flows, so we can't delete
them that way yet. This means that cleanup happens in what would
usually be an exception path.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 162 +++++++++++++++++-
 1 file changed, 158 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index afa024971c08..b1709affb52d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -64,6 +64,77 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
 	return false;
 }
 
+static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
+			      struct nfp_fl_ct_flow_entry *entry2)
+{
+	return 0;
+}
+
+static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
+			      struct nfp_fl_ct_flow_entry *ct_entry1,
+			      struct nfp_fl_ct_flow_entry *ct_entry2)
+{
+	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
+	struct nfp_fl_ct_tc_merge *m_entry;
+	unsigned long new_cookie[2];
+	int err;
+
+	if (ct_entry1->type == CT_TYPE_PRE_CT) {
+		pre_ct_entry = ct_entry1;
+		post_ct_entry = ct_entry2;
+	} else {
+		post_ct_entry = ct_entry1;
+		pre_ct_entry = ct_entry2;
+	}
+
+	if (post_ct_entry->netdev != pre_ct_entry->netdev)
+		return -EINVAL;
+	/* Checks that the chain_index of the filter matches the
+	 * chain_index of the GOTO action.
+	 */
+	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
+		return -EINVAL;
+
+	err = nfp_ct_merge_check(post_ct_entry, pre_ct_entry);
+	if (err)
+		return err;
+
+	new_cookie[0] = pre_ct_entry->cookie;
+	new_cookie[1] = post_ct_entry->cookie;
+	m_entry = get_hashentry(&zt->tc_merge_tb, &new_cookie,
+				nfp_tc_ct_merge_params, sizeof(*m_entry));
+	if (IS_ERR(m_entry))
+		return PTR_ERR(m_entry);
+
+	/* m_entry already present, not merging again */
+	if (!memcmp(&new_cookie, m_entry->cookie, sizeof(new_cookie)))
+		return 0;
+
+	memcpy(&m_entry->cookie, &new_cookie, sizeof(new_cookie));
+	m_entry->zt = zt;
+	m_entry->post_ct_parent = post_ct_entry;
+	m_entry->pre_ct_parent = pre_ct_entry;
+
+	/* Add this entry to the pre_ct and post_ct lists */
+	list_add(&m_entry->post_ct_list, &post_ct_entry->children);
+	list_add(&m_entry->pre_ct_list, &pre_ct_entry->children);
+	INIT_LIST_HEAD(&m_entry->children);
+
+	err = rhashtable_insert_fast(&zt->tc_merge_tb, &m_entry->hash_node,
+				     nfp_tc_ct_merge_params);
+	if (err)
+		goto err_ct_tc_merge_insert;
+	zt->tc_merge_count++;
+
+	return 0;
+
+err_ct_tc_merge_insert:
+	list_del(&m_entry->post_ct_list);
+	list_del(&m_entry->pre_ct_list);
+	kfree(m_entry);
+	return err;
+}
+
 static struct
 nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 					 u16 zone, bool wildcarded)
@@ -210,12 +281,48 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 	return ERR_PTR(err);
 }
 
-static void nfp_free_tc_merge_children(struct nfp_fl_ct_flow_entry *entry)
+static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
 {
 }
 
-static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
+static void nfp_del_tc_merge_entry(struct nfp_fl_ct_tc_merge *m_ent)
+{
+	struct nfp_fl_ct_zone_entry *zt;
+	int err;
+
+	zt = m_ent->zt;
+	err = rhashtable_remove_fast(&zt->tc_merge_tb,
+				     &m_ent->hash_node,
+				     nfp_tc_ct_merge_params);
+	if (err)
+		pr_warn("WARNING: could not remove merge_entry from hashtable\n");
+	zt->tc_merge_count--;
+	list_del(&m_ent->post_ct_list);
+	list_del(&m_ent->pre_ct_list);
+
+	if (!list_empty(&m_ent->children))
+		nfp_free_nft_merge_children(m_ent, false);
+	kfree(m_ent);
+}
+
+static void nfp_free_tc_merge_children(struct nfp_fl_ct_flow_entry *entry)
 {
+	struct nfp_fl_ct_tc_merge *m_ent, *tmp;
+
+	switch (entry->type) {
+	case CT_TYPE_PRE_CT:
+		list_for_each_entry_safe(m_ent, tmp, &entry->children, pre_ct_list) {
+			nfp_del_tc_merge_entry(m_ent);
+		}
+		break;
+	case CT_TYPE_POST_CT:
+		list_for_each_entry_safe(m_ent, tmp, &entry->children, post_ct_list) {
+			nfp_del_tc_merge_entry(m_ent);
+		}
+		break;
+	default:
+		break;
+	}
 }
 
 void nfp_fl_ct_clean_flow_entry(struct nfp_fl_ct_flow_entry *entry)
@@ -248,6 +355,27 @@ static struct flow_action_entry *get_flow_act(struct flow_cls_offload *flow,
 	return NULL;
 }
 
+static void
+nfp_ct_merge_tc_entries(struct nfp_fl_ct_flow_entry *ct_entry1,
+			struct nfp_fl_ct_zone_entry *zt_src,
+			struct nfp_fl_ct_zone_entry *zt_dst)
+{
+	struct nfp_fl_ct_flow_entry *ct_entry2, *ct_tmp;
+	struct list_head *ct_list;
+
+	if (ct_entry1->type == CT_TYPE_PRE_CT)
+		ct_list = &zt_src->post_ct_list;
+	else if (ct_entry1->type == CT_TYPE_POST_CT)
+		ct_list = &zt_src->pre_ct_list;
+	else
+		return;
+
+	list_for_each_entry_safe(ct_entry2, ct_tmp, ct_list,
+				 list_node) {
+		nfp_ct_do_tc_merge(zt_dst, ct_entry2, ct_entry1);
+	}
+}
+
 int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct net_device *netdev,
 			    struct flow_cls_offload *flow,
@@ -290,8 +418,13 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 	list_add(&ct_entry->list_node, &zt->pre_ct_list);
 	zt->pre_ct_count++;
 
+	nfp_ct_merge_tc_entries(ct_entry, zt, zt);
+
+	/* Need to check and merge with tables in the wc_zone as well */
+	if (priv->ct_zone_wc)
+		nfp_ct_merge_tc_entries(ct_entry, priv->ct_zone_wc, zt);
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack action not supported");
-	nfp_fl_ct_clean_flow_entry(ct_entry);
 	return -EOPNOTSUPP;
 }
 
@@ -332,7 +465,28 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
 	list_add(&ct_entry->list_node, &zt->post_ct_list);
 	zt->post_ct_count++;
 
+	if (wildcarded) {
+		/* Iterate through all zone tables if not empty, look for merges with
+		 * pre_ct entries and merge them.
+		 */
+		struct rhashtable_iter iter;
+		struct nfp_fl_ct_zone_entry *zone_table;
+
+		rhashtable_walk_enter(&priv->ct_zone_table, &iter);
+		rhashtable_walk_start(&iter);
+		while ((zone_table = rhashtable_walk_next(&iter)) != NULL) {
+			if (IS_ERR(zone_table))
+				continue;
+			rhashtable_walk_stop(&iter);
+			nfp_ct_merge_tc_entries(ct_entry, zone_table, zone_table);
+			rhashtable_walk_start(&iter);
+		}
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+	} else {
+		nfp_ct_merge_tc_entries(ct_entry, zt, zt);
+	}
+
 	NL_SET_ERR_MSG_MOD(extack, "unsupported offload: Conntrack match not supported");
-	nfp_fl_ct_clean_flow_entry(ct_entry);
 	return -EOPNOTSUPP;
 }
-- 
2.20.1

