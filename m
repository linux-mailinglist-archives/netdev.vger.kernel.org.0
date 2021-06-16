Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CAA3A96CA
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhFPKFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:05:05 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:37984
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231931AbhFPKEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0XClGCTSAbuO3oo48+dWFtmW8wxR012caGFxRrZaMnahE/9LxMRhQmDRWAZ+pXqIOnqgfyV6daO8DJPGP+v3pqVM6fUms0OsEJ2PoCCNiXZU14wBJ97Zjhg5G0FJndNjX5wTOHdIRaw58bMzZLVADQi2PYx8GRc6qQVFt+RGBCfG87miHHyWkIy68DbPG4wHgj7x4Jdi4zo/vFHscnwSnwYfWoik/YRUlBfsnYIc/YdHJQ9BlrRIpoLMBx8RwUeLmCn6Mrm//VJPPJvAUR1S4Otwh4Psuds4LAJS8Jov+euZzQaflXSTsjgmmHVrpumUnVkN/N5NvJPJ0uU4dcg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bc91i0xtuHqREnaM/aV4kk6GdZxHUp2FJJ7EM/j6CD4=;
 b=ZcwmwXUk9Ucs0NgaILj9yk0ZfyAiXSjERLuhekJxle1oZweR2zLQV5I241q181/bWygXZINcFkg3gr2v4qn8QMNYlcLxKjQ2B9ezX1JC6CVqb1gCHRWPM7UMCb5GbzkPdKuIVwp6PZ6izc1FwNIpWbopXIZ0gND4RsFXT51otU+qUAcqqs1IDjd8OPxiSgMZJkEWnJ3++FtVA//R68PlW2ahfZHBSuGshjaqWrkPsynxdxmWx4DTIG1jMoev45EaQb1b6aCwKgZMyp+pmbrdhvcB1ue0Iink6D6d1MTUhD+ThP7h9k7kMaYTStsDWzRCsl2pg1/KUa5aH1e31fIv5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bc91i0xtuHqREnaM/aV4kk6GdZxHUp2FJJ7EM/j6CD4=;
 b=jgLu1VOmuOUIRfVwJrgMzcICv50SqEvS890PfGKceUk1ydlWu1sw6XVUNg/VA89Bv9AZT2KP8EGvtvXtHtG6uFFxIBh+sCvYsjngblLw0lm/QudlXOdvwQSe80TjMTJAaVGmJutgsYeMpNFDhd7HoRBUCYCAZXFtPW5EX/lcYPg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 6/9] nfp: flower-ct: implement code to save merge of tc and nft flows
Date:   Wed, 16 Jun 2021 12:02:04 +0200
Message-Id: <20210616100207.14415-7-simon.horman@corigine.com>
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
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d7501c9-c03a-45fd-1a16-08d930addd5b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB497119AC9D3C870CFC409273E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDA16UFyfn40u+W16deDjnxpinkp6FPHEFQpOpvepS67X5be7PSvX/oJGbXGDqAhPXuE4E9xQmarGbkXbIOn/QkYySXtYSNi8P09EAOKWXSBCzvj4HdmVEYoB1dj4itIc1egSaLKItnUniS5jMi2TIGo1vkCFkE3K0YFkXll0L2wzzSWXWj1u8/Cb9Y8xd3Vhw85MBpBvurzJl+yDCGIL2vFjmn1OE1Tmz6U3reJkd9GWNTaOo0vtEwJm8tpPYj9KojTimhbNgd42Iyy7bVyO4ajRCy1KKVh4HiwK0su/IhNizh9VsHCsj5AiV0PKrUZns3C+IX6tOtv9kaL01eZl/4wmUw4bpSoSn9VFSGGXQgrI7rSgw1QU3E4gqHX9HC2lgadBK9Xb6jAO2CtwkTsZc/BL9O+yiTxP4tw6EfAiP4PjgMQG1Eu1SooSwFnyrNQr4ytcJqoHPZkKBaTJ77JK5ToFxzCtz+vnX6QCUEASvlWGgqj4FsyQ6WxUYcz4K5IXSSy+2HXFrL8teawXkX/fsLCBMCRxuPR1+wALT0x17SPBtv6tJbQ869Q/J9Xc0UNctDJLls4i4/Xfn1OimjR7muE/XXYOTXzy3YrL3mcEbbimGNZ4QNz2gEgJZ2k7bg4Bq755VVYoMXkUhSJKs9ayg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(83380400001)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qicpwqeHxjg45Pat+x4kPPpVVNbOexHBMIBTUL76uozvaaUtNw7D46gGjO/N?=
 =?us-ascii?Q?CGcoFPMjyPwAEOE/R3lzz4amaoNHSYrBoEYT14fTIc1m6PiOTBSY3RV45SuO?=
 =?us-ascii?Q?m6JX75xSLAj4uVl/89x1NvpRHFsvt3YOD4qNNR0Zx5GiGPeUqgxfdZx6f6rm?=
 =?us-ascii?Q?h2waYoKAXD8dWhpCTb3m4Re3XXWhk7svkuJZJMR6myTeNX5i6NeiaROTfqN3?=
 =?us-ascii?Q?HzLc6ocKUjZh7KDb1UqSIGwygeuTPrY/6GqPUN5RQBLKIKPGbROqzK4JyRsV?=
 =?us-ascii?Q?gCK9tC8/tCPCMSExiI2AbRA+q6HscFzNYDLO+U5DafVk8ZC5zw5BmQct65TG?=
 =?us-ascii?Q?Vx2SpiFHzpW5x8LOkYpZ/rWBFyrxZoLhu9Yxm3hJ/GyW3OA0xMlFBtey188D?=
 =?us-ascii?Q?6EyKRxx5LBqJzS3agFnuT/T7tGfyFYZe2UI1UsxEA5FRwEgrhomXWcXVWNKN?=
 =?us-ascii?Q?Vyas6kXfFSyKGERrds8t5eBiGi9e3VY6MlOkVM+oMch2tlhVQsN6nQKxp/MT?=
 =?us-ascii?Q?KdDT+qvbeGPOevcXsYgc8Iedoxsnvq5GhCKShUsSf87dEo2kkBDsuId8sCXg?=
 =?us-ascii?Q?aAB5xVBE31K/UKGdcV7ZqjHbjf00NIxMjb6Zrj6LkIryYnf1CWlal2vB7Aur?=
 =?us-ascii?Q?J7qWT1HjWnA9DM8uoi9upc2EtamxKdcsOoi1CqmPyroLQEgsvpAmy2otHA0k?=
 =?us-ascii?Q?XDWeO3ew2hh+5cPpQPuyPkUDYq5lcFcwb1+AyI8XZHPbzpwiPNGjsO6C7uv7?=
 =?us-ascii?Q?R0aqfLtsmzuuHsLCNNdbHyJidy9BLFG9GbOBQqvsVzaF3BT37ZTki4GVNdiU?=
 =?us-ascii?Q?L4MeyenNUzfrTU70Ci7ZjlFG1iTfbxXlzRB/BU0mAy1I22SyI2ZqMokDqzlO?=
 =?us-ascii?Q?JH92dfbJq3UntUIKYaB4r8vUI60EQ2+p53EcQunnRngBDSJKiQFvhlJ6B15a?=
 =?us-ascii?Q?80QQ3yeXLj1feNyDUs2MoNAG26ZGPxhRqlz2ph2v5H/BLyylf6xwPyS7GJbA?=
 =?us-ascii?Q?AhybDj70a3c3TmM8ijBlerToFS96N9cIkvB/6+0uQBrgqsxGx7fRLgYhNmen?=
 =?us-ascii?Q?eNZAQQXEdBHBixIKmlrHd9CY7tA6aZ2LLibvo6k/eea+gLHWQUF9wUYtiUmF?=
 =?us-ascii?Q?zrIDmDCr8r6bgsW766Hx9QZGkHOV4+i/rhgh1KQUvPJFvl2vWlE9Bo4LjSgs?=
 =?us-ascii?Q?ge5s+TdU7XUb5f72c5q1KzSq21i9AHvwUJjDAmvNPTWFEefM3mrv3tpDaEvQ?=
 =?us-ascii?Q?qW4iFZFWZUVk+/s4VSU6Tg9vHnb1yxVIicQbyiYOCfoDvGYxoVOM/a7mH5JM?=
 =?us-ascii?Q?Rsp9QQwOGEJxhMqiHm0Pkmi1xRX4OazS86A79//tWx2zH7Qvf2e0OJuy/EGJ?=
 =?us-ascii?Q?VpZG1HLjsLR0OTPjGxwudI7MEbmD?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7501c9-c03a-45fd-1a16-08d930addd5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:35.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBwbHzsm8Mla5fWbmzKqOWrVD1bklEvjxp11Iz+pFxIP76x7VcNeXDBfBj3X5p3QwTR0yalBfe78Z+HH0FlPXFPRm6dC2YA9CY4ZdTdkM9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add in the code to merge the tc_merge objects with the flows
received from nft. At the moment flows are just merged blindly
as the validity check functions are stubbed out, this will
be populated in follow-up patches.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 187 ++++++++++++++++++
 1 file changed, 187 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 3ab09d040d4c..e5d5ce7f0ead 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -78,11 +78,122 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 	return 0;
 }
 
+static int nfp_ct_merge_act_check(struct nfp_fl_ct_flow_entry *pre_ct_entry,
+				  struct nfp_fl_ct_flow_entry *post_ct_entry,
+				  struct nfp_fl_ct_flow_entry *nft_entry)
+{
+	return 0;
+}
+
+static int nfp_ct_check_meta(struct nfp_fl_ct_flow_entry *post_ct_entry,
+			     struct nfp_fl_ct_flow_entry *nft_entry)
+{
+	return 0;
+}
+
+static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
+{
+	return 0;
+}
+
+static int nfp_fl_ct_del_offload(struct nfp_app *app, unsigned long cookie,
+				 struct net_device *netdev)
+{
+	return 0;
+}
+
+static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
+			       struct nfp_fl_ct_flow_entry *nft_entry,
+			       struct nfp_fl_ct_tc_merge *tc_m_entry)
+{
+	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
+	struct nfp_fl_nft_tc_merge *nft_m_entry;
+	unsigned long new_cookie[3];
+	int err;
+
+	pre_ct_entry = tc_m_entry->pre_ct_parent;
+	post_ct_entry = tc_m_entry->post_ct_parent;
+
+	err = nfp_ct_merge_act_check(pre_ct_entry, post_ct_entry, nft_entry);
+	if (err)
+		return err;
+
+	/* Check that the two tc flows are also compatible with
+	 * the nft entry. No need to check the pre_ct and post_ct
+	 * entries as that was already done during pre_merge.
+	 * The nft entry does not have a netdev or chain populated, so
+	 * skip this check.
+	 */
+	err = nfp_ct_merge_check(pre_ct_entry, nft_entry);
+	if (err)
+		return err;
+	err = nfp_ct_merge_check(post_ct_entry, nft_entry);
+	if (err)
+		return err;
+	err = nfp_ct_check_meta(post_ct_entry, nft_entry);
+	if (err)
+		return err;
+
+	/* Combine tc_merge and nft cookies for this cookie. */
+	new_cookie[0] = tc_m_entry->cookie[0];
+	new_cookie[1] = tc_m_entry->cookie[1];
+	new_cookie[2] = nft_entry->cookie;
+	nft_m_entry = get_hashentry(&zt->nft_merge_tb,
+				    &new_cookie,
+				    nfp_nft_ct_merge_params,
+				    sizeof(*nft_m_entry));
+
+	if (IS_ERR(nft_m_entry))
+		return PTR_ERR(nft_m_entry);
+
+	/* nft_m_entry already present, not merging again */
+	if (!memcmp(&new_cookie, nft_m_entry->cookie, sizeof(new_cookie)))
+		return 0;
+
+	memcpy(&nft_m_entry->cookie, &new_cookie, sizeof(new_cookie));
+	nft_m_entry->zt = zt;
+	nft_m_entry->tc_m_parent = tc_m_entry;
+	nft_m_entry->nft_parent = nft_entry;
+	nft_m_entry->tc_flower_cookie = 0;
+	/* Copy the netdev from one the pre_ct entry. When the tc_m_entry was created
+	 * it only combined them if the netdevs were the same, so can use any of them.
+	 */
+	nft_m_entry->netdev = pre_ct_entry->netdev;
+
+	/* Add this entry to the tc_m_list and nft_flow lists */
+	list_add(&nft_m_entry->tc_merge_list, &tc_m_entry->children);
+	list_add(&nft_m_entry->nft_flow_list, &nft_entry->children);
+
+	/* Generate offload structure and send to nfp */
+	err = nfp_fl_ct_add_offload(nft_m_entry);
+	if (err)
+		goto err_nft_ct_offload;
+
+	err = rhashtable_insert_fast(&zt->nft_merge_tb, &nft_m_entry->hash_node,
+				     nfp_nft_ct_merge_params);
+	if (err)
+		goto err_nft_ct_merge_insert;
+
+	zt->nft_merge_count++;
+
+	return err;
+
+err_nft_ct_merge_insert:
+	nfp_fl_ct_del_offload(zt->priv->app, nft_m_entry->tc_flower_cookie,
+			      nft_m_entry->netdev);
+err_nft_ct_offload:
+	list_del(&nft_m_entry->tc_merge_list);
+	list_del(&nft_m_entry->nft_flow_list);
+	kfree(nft_m_entry);
+	return err;
+}
+
 static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 			      struct nfp_fl_ct_flow_entry *ct_entry1,
 			      struct nfp_fl_ct_flow_entry *ct_entry2)
 {
 	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
+	struct nfp_fl_ct_flow_entry *nft_entry, *nft_tmp;
 	struct nfp_fl_ct_tc_merge *m_entry;
 	unsigned long new_cookie[2];
 	int err;
@@ -134,6 +245,12 @@ static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 		goto err_ct_tc_merge_insert;
 	zt->tc_merge_count++;
 
+	/* Merge with existing nft flows */
+	list_for_each_entry_safe(nft_entry, nft_tmp, &zt->nft_flows_list,
+				 list_node) {
+		nfp_ct_do_nft_merge(zt, nft_entry, m_entry);
+	}
+
 	return 0;
 
 err_ct_tc_merge_insert:
@@ -321,8 +438,57 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 	return ERR_PTR(err);
 }
 
+static void cleanup_nft_merge_entry(struct nfp_fl_nft_tc_merge *m_entry)
+{
+	struct nfp_fl_ct_zone_entry *zt;
+	int err;
+
+	zt = m_entry->zt;
+
+	/* Flow is in HW, need to delete */
+	if (m_entry->tc_flower_cookie) {
+		err = nfp_fl_ct_del_offload(zt->priv->app, m_entry->tc_flower_cookie,
+					    m_entry->netdev);
+		if (err)
+			return;
+	}
+
+	WARN_ON_ONCE(rhashtable_remove_fast(&zt->nft_merge_tb,
+					    &m_entry->hash_node,
+					    nfp_nft_ct_merge_params));
+	zt->nft_merge_count--;
+	list_del(&m_entry->tc_merge_list);
+	list_del(&m_entry->nft_flow_list);
+
+	kfree(m_entry);
+}
+
 static void nfp_free_nft_merge_children(void *entry, bool is_nft_flow)
 {
+	struct nfp_fl_nft_tc_merge *m_entry, *tmp;
+
+	/* These post entries are parts of two lists, one is a list of nft_entries
+	 * and the other is of from a list of tc_merge structures. Iterate
+	 * through the relevant list and cleanup the entries.
+	 */
+
+	if (is_nft_flow) {
+		/* Need to iterate through list of nft_flow entries*/
+		struct nfp_fl_ct_flow_entry *ct_entry = entry;
+
+		list_for_each_entry_safe(m_entry, tmp, &ct_entry->children,
+					 nft_flow_list) {
+			cleanup_nft_merge_entry(m_entry);
+		}
+	} else {
+		/* Need to iterate through list of tc_merged_flow entries*/
+		struct nfp_fl_ct_tc_merge *ct_entry = entry;
+
+		list_for_each_entry_safe(m_entry, tmp, &ct_entry->children,
+					 tc_merge_list) {
+			cleanup_nft_merge_entry(m_entry);
+		}
+	}
 }
 
 static void nfp_del_tc_merge_entry(struct nfp_fl_ct_tc_merge *m_ent)
@@ -425,6 +591,26 @@ nfp_ct_merge_tc_entries(struct nfp_fl_ct_flow_entry *ct_entry1,
 	}
 }
 
+static void
+nfp_ct_merge_nft_with_tc(struct nfp_fl_ct_flow_entry *nft_entry,
+			 struct nfp_fl_ct_zone_entry *zt)
+{
+	struct nfp_fl_ct_tc_merge *tc_merge_entry;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(&zt->tc_merge_tb, &iter);
+	rhashtable_walk_start(&iter);
+	while ((tc_merge_entry = rhashtable_walk_next(&iter)) != NULL) {
+		if (IS_ERR(tc_merge_entry))
+			continue;
+		rhashtable_walk_stop(&iter);
+		nfp_ct_do_nft_merge(zt, nft_entry, tc_merge_entry);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 int nfp_fl_ct_handle_pre_ct(struct nfp_flower_priv *priv,
 			    struct net_device *netdev,
 			    struct flow_cls_offload *flow,
@@ -568,6 +754,7 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 			ct_entry->type = CT_TYPE_NFT;
 			list_add(&ct_entry->list_node, &zt->nft_flows_list);
 			zt->nft_flows_count++;
+			nfp_ct_merge_nft_with_tc(ct_entry, zt);
 		}
 		return 0;
 	case FLOW_CLS_DESTROY:
-- 
2.20.1

