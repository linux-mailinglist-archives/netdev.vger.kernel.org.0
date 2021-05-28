Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB7394467
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhE1Opi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:45:38 -0400
Received: from mail-dm6nam10on2097.outbound.protection.outlook.com ([40.107.93.97]:62452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235898AbhE1Opa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:45:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE6Hj0DEGQ6x/DAFNpOMEfb8DXX9ajsUno2fBy4MFUBKw0qwoBC31Qy5TN6UXMZE3CvR+Kbyi1vwEbHSgOzORD6nQo/brr7TEYjf/9vCHoJs/zmO90VNKJFqME54FwIfWX/mcCZGkXqzeCGsLU0jkD66Mkyw4UhpFrMAtmjrP6u2ToGDmTk6c8m/E99w8i+hKq6oYEw6Nb5bZmPL7bi0BzsyXx7iXkhLoJWbSQ15HY6p7CkoCAFJi4tqWXa+brHGg4zn1dUfJY46U9vLicwux0sC9Xdr9sXZPzbDsTgZyrbaW0S7U6jQ8N7CLg7W3sVeG9ZhHkk8SD2GvEDML5xGeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zupaaJDl4+d6DZYkhCtCttDwXjiA3gL1vXzZ2Sz7EWM=;
 b=Wv6G+FcP83GE4cl/meaMl4FAABCbaETU8DUMncrUXjDejfvv+2bl3Ua1P+4PWmcocZmUNaTBef3fzVLGyzhlcKAMefvVB/YnqBHPMeE4OuAfjTdz0M4djpkoI90fzne+bNVucjCD4lpswqkmyY1bUriUzqdA6RMee0uLPCT8BvgS5Jz02ZLMiguMg+vX5jjTXEYA5iSlJ0Ttaf+zEPZ6hwZfSh6ejjcL1ZPKEFsThZ9Y0yNlUCzhhnLnFDW4ncKhrku9qA6AWjhCi7SP925YMltVaxY2srm7OOakP+sTYH8temhmU4+lSSTiNjD9SwV4nOD5PmkvPzA8sAzdkizbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zupaaJDl4+d6DZYkhCtCttDwXjiA3gL1vXzZ2Sz7EWM=;
 b=Y9lvG7dvaqMJcWNev4RR+1WUNjCX1wk2SbPjhWQ8E0bPMXjSHcSO1kklZLPCMGdB1EL36/fQMETpZWgSxJuPSW0ce1/iucnjTmvSWN1LqwkTQpTwhRX5VSZfLjkxvSufpkvkfuP1PuZUpqJgy/AOppBwgk4I/D2gjShXxet8XGg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5033.namprd13.prod.outlook.com (2603:10b6:510:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11; Fri, 28 May
 2021 14:43:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 14:43:14 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 8/8] nfp: flower-ct: add tc merge functionality
Date:   Fri, 28 May 2021 16:42:46 +0200
Message-Id: <20210528144246.11669-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210528144246.11669-1-simon.horman@corigine.com>
References: <20210528144246.11669-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM0PR01CA0164.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM0PR01CA0164.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 14:43:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 663bd3c7-a014-4ba9-0e51-08d921e6ec4a
X-MS-TrafficTypeDiagnostic: PH0PR13MB5033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB5033FBE200863180C8EED065E8229@PH0PR13MB5033.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rb72OoL5rMLT9UXn690tlA4XnHDj8S9/Op34XCed3eTy/muncs22UHt9eKgbNi7e8NgfU7oESN3yDrtOEcBUt4BiQSXdPH/ZSJdtYhDfRT7uN7KzS5Qt+5pbidHiRj94P365bBAAvRS0DE6hfJTXyI0Gh47b957DHMN0bHeFg4Z0q5qnKmP4Ju6d52hKsUOIOfWW1aLFgdQTaqdi5wEI7KgZ8hUbf1DUlxFcpOJ8iiz6LtA6wSy5jYiAaZSGlDUq7oQKXF/35N7s0WfGioAi/js8/jujbD0bFOfsVddDHXob8k0NFucqwj0Xmklmp/7LXh1qxNG84RFSKAxoppVNyq7/+qLcUsvek98wnKJdhlN4/VLRAUnwunnXdQmWfHjwaUNNhIzDY3Hs5BVuxq1T3M1xoKrQ8UkwnseUdnAtX+hgu4ZE+dTJhIvRNnK5A2BdBuoiT7RrKWLIFHLisxwVxfpCkd8uZAHW4eKi+VXXHcP2JgpCvPLFVHMab0sGJlUSXIZnYuefcjKU1+g+C0kLyuSX3mCoIgtKfxg27AD6vxMcijzhof6U83XPfZgBHSKh6D+aOdsy33Ueor384mxqVjE0zwZ5I0C99LaUb+STv4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(16526019)(44832011)(186003)(5660300002)(6666004)(8936002)(6506007)(86362001)(36756003)(4326008)(107886003)(6512007)(8676002)(66476007)(83380400001)(66556008)(2616005)(316002)(54906003)(110136005)(52116002)(478600001)(6486002)(2906002)(66946007)(38100700002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3Z/id2UI3TvdsWE1+xF6estuUmvdCLXM8fB8+c0S8badYtbnt/R7AocrNnOp?=
 =?us-ascii?Q?SEobnYYtgCsZ4klph4zZCXrPVsbeT47vL5O+R7Qy3FaxRX+KhCcI5gA/FsgS?=
 =?us-ascii?Q?xuvgVnxdUuwCGBTYh96g+36C5DTI+NH53PeB7wsIgbkIZq0VdAlbHtM4MLbz?=
 =?us-ascii?Q?lcv3DCfuMHivn0QaBxAmlmL2YQISkDC1wHDTOS+E1Evs4oJJ6k1e61KO1Z+v?=
 =?us-ascii?Q?xHm2ZCa5soqPAcGibxW6iuI4SPH8rCYxaCMrFQcDsTiirY0YRSOpkOx1iJ62?=
 =?us-ascii?Q?9eErvmwWoi6xmW611EAzn73KugMLFPvCoIW9Z6xkefWqKIEPTCZQe68XWjCL?=
 =?us-ascii?Q?3yF2uFeK6cWgtBNlgLibDbgZxOz1TyrpCJUY6ObyBYLF3Hdm2OmZVJeFkv4h?=
 =?us-ascii?Q?6r3RmkbEUgeRdcdCWr3mr+EDdD9jsAPxEIDnj2LUSC9eaMx5eFzP9rtdfWcQ?=
 =?us-ascii?Q?GovAERKY2GdMPxdjrLTpzr0cU8PPHSxkJMcesxjXwi60equSBe8//PCGs6Ss?=
 =?us-ascii?Q?bO3V01o/lD/JCyASO4yim9xxBl8TRxpQuswaYKuWe+Qagf2e6SWV9ft4Qx4g?=
 =?us-ascii?Q?I/707UWNRAsim2GbU0LVhxaGssrlshZp4r4xfCBhvBm0cY+dqQ5nMZBHCpzU?=
 =?us-ascii?Q?8ewjBGmDC2xlegl+AZbrSplwr+wBMfoY0Jf0PnqS97kfmz4MtfAqorDhRaJJ?=
 =?us-ascii?Q?8zSa8UibqkWRRlTN/CtoWRIddvqTKj3QtYY1dHbHjcguMmIQz29YtkRp6ibm?=
 =?us-ascii?Q?Qv1cOAZGRDmH3YccNMyfMfek3FOiggGgo+cbOjDzLlovJpbcJEsbp9yNoxRl?=
 =?us-ascii?Q?9txHynWw+ySBaJvoYTEApGMo/nFXdGn152G/WxYSGx1RHAle2AiVC6iyJE1+?=
 =?us-ascii?Q?vINZDWWbru3pDR4RR5qkDwj2K7/tku3FTqVv3ZIo5pKqKq4UyQBRPA7aKYtr?=
 =?us-ascii?Q?q2yAOASPcIkrsY5zNKMg6xZHubrj5vu95WGux9ErvZB8PMB3WlQVmyvsfDsn?=
 =?us-ascii?Q?V+RDe1pGpw5+g7PIWVnL8h1UHHq1tYyTxqXo2DsTGLmvHI8Qm+fFoBNTORPJ?=
 =?us-ascii?Q?8G1qUduTYtrmwMVkh0SRkHJmMSrdjN9L1pSUF2F5XkdRq+v25VxlDUkL+IMI?=
 =?us-ascii?Q?hWqrKj3eDvxxp+Pi9NBvJd0fhNtOctUmqgwyefOQaGtyuLuYvWG6Vu9XlIdP?=
 =?us-ascii?Q?EjxM8Ykyq/VN161aGlLuQz/g19l5RwLS4LW+Xl0zTKsjAfMZUYBy/+Pwh0Z1?=
 =?us-ascii?Q?sjKSATt4/Ie0Z+qe3BH5GERLZWV/1yC8E6o5ioHAgh1E6GJXFUFZItIqQ7om?=
 =?us-ascii?Q?kOxBGcrbGgzaj48WeXazL2ZGfjZyZziwkYbDJSHLHCgWCFnAy+sgzEHDECyR?=
 =?us-ascii?Q?Bx81f5ydn80DMKdkQwfxIbDXUCKd?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663bd3c7-a014-4ba9-0e51-08d921e6ec4a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:43:14.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZb3GbH3X3uH7veb8gWDhvOcDSsjTEoXpyNXDTApqIKWqx5t3wgsITL14LVj5h/eAYfYqUDtYGbrm7HrXsM0Yl95aYE2trKUipPwBSlEzjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5033
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

