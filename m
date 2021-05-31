Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44317395ADF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhEaMt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 08:49:26 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:7041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231643AbhEaMtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 08:49:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA1y3+x2LpPXT/ecYoqQn2z0FMPQa8OTe3CFmREXg1Db7/WyHUmOmgn2bhPR7xNuVvulVihUAZ7UKCOKvkhG7Xhd5zIFpdUrh3T+urMXHGWmNkDzbhdh2Afka78dlZMSKE+C8Bb1rClIN5+tHrszyJoJt/5ouzDu6cpTCRCRV68jjNcBpnxMVif+DT+ebr1PyJC04YYU2wT68rCx15qt76Z+hjfZO7mnOp0B/eu4oSjcx1J2vwxhgzceKDrqcDw28bgHCgKmp8F50WvKz0zPB7ZHTZXe7ayHKeN+sZgUGfilVFqDorlA+Fw1qqc0cf5Qle+8etbsN6MaZQOsoKJJpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zupaaJDl4+d6DZYkhCtCttDwXjiA3gL1vXzZ2Sz7EWM=;
 b=EqcKeD/lEfO1KBSWVtcVdcl+oJg82OAiE7luNIOR5zY57OJVQSD1jJafZD01Jn6UDU2kkb7ib7nZb9K9/okf6AnYUxw3xIMHIqQQHF3omG5FPZ9R2+ZHXzIIT4v2nOG1/1Mb0lsiMmL+6IBmi/sjqkJkylNDUxZxsftEtPqVWKbO3bdo3m9FkOxRaotFjGXf/XTDvrzFx1aAkO9Gbx3Tl7XIpfVnpHUmboFy/CppeKGeCZmCjPUWBhfnuuxapndn0dfu7wEhaH3uOVpxGQuFxgHEYdZMTdEgUPXdZIX+MLBoBwbElwuFdF8jDOtHztA7ahOkYceGQFpMFiM8A9srFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zupaaJDl4+d6DZYkhCtCttDwXjiA3gL1vXzZ2Sz7EWM=;
 b=YH0RS7ejesMXAYGZ58m8N+90nawJFRNRuUtCMi4lxnXfR6GvdK+itLbhj0zZUR8/HXES/pdFI+MM8KWJr5sMu2mLGBH9iCguLZzeZlhXIx0SubQFSWNzg9WTjN/wzG+aspcW8cyqVbtdQUZrxZjfEyeS/0lNNudMojADnxDWLZM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4891.namprd13.prod.outlook.com (2603:10b6:510:96::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12; Mon, 31 May
 2021 12:46:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4195.016; Mon, 31 May 2021
 12:46:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 8/8] nfp: flower-ct: add tc merge functionality
Date:   Mon, 31 May 2021 14:46:07 +0200
Message-Id: <20210531124607.29602-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531124607.29602-1-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM4PR05CA0029.eurprd05.prod.outlook.com (2603:10a6:205::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:46:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde533a8-bf69-4d33-a6c2-08d924322320
X-MS-TrafficTypeDiagnostic: PH0PR13MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48914451F05DB786955BD98EE83F9@PH0PR13MB4891.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBtUszoqQXxJFgXhjQQ7g7mwD7bNXz5gp8PgH0zd6Hz/rcQtn7n1maO7ytQfOIRs9fPrle+PHHlSmq0gvye2BHbwPAZfmqWfurOrXB7bfopXKZm2ndyKAz0bAKUZC+zierYWe3NrwYPpO2iBM19H+NZIGGkFFmiYdJv5CFWSsX5LpuT+M+QwWByQvLXKNLXA2aHzfBKDYwZKqaSmh6UIvcRoTtomdMAhVWXb2v7SEBXQjhi5Uk7fx+UUxWmzlRae7ZNGtvqTEeTLXNfn6zxgIL/TLj7lNU3KUVZRMsW7lEzSg7LUNNnZ1jahUqDDQ5jhxaU1z6x/8gzOL/92MqoyT2kAkrRLbiZfFxrBxfkfBLSUoj6NneISncRM1ue8QAtwq1iZqXydKpp0uc/rUqLw2ZQP/vQi8dhlx6J9VP4+arc1juF2KqvFHXdXOh/w25bCDQCEmvE1uAwAuTvy8z3OAvpObTNFa0Dsvp7K+nkNTko0D4wjYqQSyBwTbXwOJ60zeSb6Ll6QIioXZoox6cPTNRXjT5JRl9NXnsfyP0mUh4cx4VdB3Ow47Dzi98EddNSaKlngH9Ksrk9jypJuvTs4MDjS+KqbvCibYsuKA49yQRE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(39830400003)(376002)(107886003)(2906002)(66946007)(66476007)(66556008)(36756003)(38100700002)(6512007)(186003)(16526019)(4326008)(86362001)(8936002)(8676002)(83380400001)(6666004)(44832011)(1076003)(6506007)(54906003)(110136005)(6486002)(478600001)(2616005)(316002)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sAPlhHS1NykJbBRh0WaCBsx7e1MXU7/RGtScH4rx16s/irzBn5wCV7sD7pTe?=
 =?us-ascii?Q?9bxCVqx7HfpvavgZw/AutdeUqq2j+1VbKXGAF3qyyyQO/FAELY9WjEr3iguH?=
 =?us-ascii?Q?tnMuQOYPAEm/zgH0XtfZhtIrMsuzaw3LyS4C/p1TboC4tX8Zg2v6BMYuyxaF?=
 =?us-ascii?Q?KJfyRM73Pz0WhRiYRlrj+UunphJzVZHwjuW/HKp+GHQdZYbPsKH/1F+iwUMY?=
 =?us-ascii?Q?xkL0Hu6lm2ubCPZKLZf3WrJTHaJK1vnLejZvkTlNSPNlO7NNd4HtCz9aaImM?=
 =?us-ascii?Q?8RWlKBdlK7K1mVELEyJbpoOh5pBsGSfx+KdOaa3HxrHmSS0MgclDSt2hvLAJ?=
 =?us-ascii?Q?VYjjjwLsjBil4SNCXo2ERinhHZGoS8PU0/AqM3m+wampRhP52RJYndP8Iq1q?=
 =?us-ascii?Q?MXQMFo0WBfg2jU5mbN2HCX9oJqVNxT6Fl3B80g0fPsnZ9Pb2qplMpAI+/pIb?=
 =?us-ascii?Q?rlVWLQYuDSczfYPb6KIz2W9AM0MZNzmfEjwdTV/M3KeIzda1yBWGclIXmHY+?=
 =?us-ascii?Q?t/V4eOURxQy5gpzlZQW02RPjhze+1W7NyF/6KHLnH9t2qZL91uzEAPz3G5NC?=
 =?us-ascii?Q?IVi3iTyOC0n7AMDZeFXQIKyNY5xO7CrMHj8nCxmNM7sM3RPBMbr2YruaPJaY?=
 =?us-ascii?Q?4eDqCp+AMYWMaV0gu5mA2/54FU1b3MwGFlBpzA0CjJJQN2bd3VSfU6N9Z7cy?=
 =?us-ascii?Q?XwS8ckVCQDskiZfUVxr0DiVs6HjnxbulfFyTG1Cp00+i70kGwr6Fou0ozB/g?=
 =?us-ascii?Q?PjtMUt7EV5k4R0u+YbKZXHL7CzG2fgj59uNhsnAC9GuBQbyGwwGR6VxTDlye?=
 =?us-ascii?Q?Qyj+l0MbBZ6rbRIs4LiEZRlXfvvdyPC84auflEFHqGTRlg0lBoN1oPn3X/CA?=
 =?us-ascii?Q?cnHiDGBljsxQmxt7tIDVA1YBsEhQ/yhbZuO9men1nY1NrDdZfJ6PDAmjlMuZ?=
 =?us-ascii?Q?QjypqeFzv7HmrOqrKn8An4JA55ae8/wNFSPSxK4yIG0wniBsdTvvz9HO68l9?=
 =?us-ascii?Q?Eci9TlbPiulXRXnFXkgFzC+BydiXrR1Wpb8VJM5gbNHKYmMeBPgmwOoUFys4?=
 =?us-ascii?Q?HyluDTSN352lREVFfEjhpUP/mdxmP+Zs0BjcLEsIp4fxCtl0OXmajw/vET76?=
 =?us-ascii?Q?K9Estf09p7tHu9I2FrhttnXEoQODCA7+Oi5rVxj8EBc0HJWuGtFFhNEQvymk?=
 =?us-ascii?Q?l8T1mhqufkjvk6eGfLiWc0myu45ipXsgUFQe/+Uy6BBgzxhea0x/mtClVw7v?=
 =?us-ascii?Q?UeYE+rswDjJojV0q0c+QWDBNnBwMvYvaoRVj58JtkLqMxcOe1ulOfAd1Mzf6?=
 =?us-ascii?Q?YZfLR+7ML6p+7ZC8n46wP4c1Bx7m9OO969ai4Jf4gghfF+06gy+jttw44u+N?=
 =?us-ascii?Q?9XI+3Y6aS+FNBwJg7XrcXS9JHAWP?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde533a8-bf69-4d33-a6c2-08d924322320
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:46:40.7167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuotwyXYWCaOs54n4RKOHO9Z+QH+/lsIeaAi3q9uLdZyIK4aU/k5Ytz7rFGMJ8v84i0awvq1MEyOtoqRLgzY4ScKV6Y88KuOP07qyeSu7nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4891
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
 .../ethernet/netronome/nfp/flower/conntrack.c | 157 +++++++++++++++++-
 1 file changed, 153 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index cf17c9510fbb..ff262d04a73b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -63,6 +63,74 @@ bool is_post_ct_flow(struct flow_cls_offload *flow)
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
@@ -209,12 +277,48 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 	return ERR_PTR(err);
 }
 
-static void nfp_free_tc_merge_children(struct nfp_fl_ct_flow_entry *entry)
+static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
 {
 }
 
-static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
+static void nfp_del_tc_merge_entry(struct nfp_fl_ct_tc_merge *m_ent)
 {
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
+{
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
@@ -247,6 +351,25 @@ static struct flow_action_entry *get_flow_act(struct flow_cls_offload *flow,
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
@@ -289,8 +412,13 @@ int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
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
 
@@ -331,7 +459,28 @@ int nfp_fl_ct_handle_post_ct(struct nfp_flower_priv *priv,
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

