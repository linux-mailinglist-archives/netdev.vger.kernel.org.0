Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE33A96C8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhFPKFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:05:01 -0400
Received: from mail-mw2nam10on2094.outbound.protection.outlook.com ([40.107.94.94]:30432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232223AbhFPKEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 06:04:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDRQ738bSD57fO5REYbW6sJHIvJ6FIJhpTeRRThyxrjvqO53nPuOfP3KmicaLrp/WhMQAofV6KmH8ljvdJbMuPa8giCh++khgr6KU0FvP3+3o6oUHbSnxkAUZEXQoezjNfnYvgWHR5wymcAPZhIBJ0as7QlaeJO+e9T1hJdURPLHEgDcZ3mEjMI8scVRH3xk/tqdSd2WgAoZZCN6ZXKvxlRAoTuBSxjo49RvIOM0Me+4WNIpvCseqXrAygUuOsIgOM3FkQIe13TwhlrRbFUvtXySO0DDA10BZk3+O8dmwRW80oc2N1gAqevW5bi4M9VFqS+iNo2vULAz+lbQRvRqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYMYoYCHUGr1nNeM7orHEPc7JMHLQ0fMYA7u/ktE9MY=;
 b=XOAg+aTafHkmNQ0g2bZWufIQkgr9WAHGMrgkwm3YsBA1OHSgvioGSL1WvJhQruxzc7wBX5PrIe1udDxapqIJExF1ZGe4t+HJgWE9YG/grmzk62b9jm5G/FWFqjjy+Xw7ziweySCf4P8GJW5e6Ca7uoyPxFndtcco9H7XWZzA5KambbE57/jFA2hLVwBFxqXSiAQ2V3/Wm1kUNjy1gvlLTtNibK+wkr8i+mhOL3oNv84zExdMmaiu2uvK3px5VYAxdpcGKLdYlVWB1x6XJguRnyoizp2+jaVfObFD7eLsxbH0+sUZUJ8b5eumg9Smib90Cb2MvLxkR6r+98qRURwIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYMYoYCHUGr1nNeM7orHEPc7JMHLQ0fMYA7u/ktE9MY=;
 b=cvbn7s8jkAHtEf2gEWGXWA99sjwdHy1vKKjJh95D4aCxv+DKO0rR4xk4Aoe2PMYKlzheiPEnvADybOF5qVFuPA0rYhWr9DVqt5yh5hWjUwA4ik9TXsjWHg1wbEWouZgfXpntcDg93GXOivw6k/ghum6YOl1aK5dF7oFli0YDRxQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4971.namprd13.prod.outlook.com (2603:10b6:510:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7; Wed, 16 Jun
 2021 10:02:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 10:02:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/9] nfp: flower-ct: add nft_merge table
Date:   Wed, 16 Jun 2021 12:02:03 +0200
Message-Id: <20210616100207.14415-6-simon.horman@corigine.com>
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
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR10CA0022.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:02:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72228aa2-17bf-4be4-ac3b-08d930addc5f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49715588575E67D9D5C66BD0E80F9@PH0PR13MB4971.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /83iLAbZuuYp0bWTrlCdCeh92Pg/vYmP/IDju5UeC3vguIE+gDiTlspSbJz3ShaH7+9vvW+z9RNYlevzhgskB2J4TuoRh3/07uEaIHUql6EwtQLpyZ/XCFIf4LYwujqvzpLp8OgCReFkW8ncGdyzjpaAmh7HilgNplbKtoixJ0HvaHfCRZ7AlfI1V6CbxX4BZ8CG2AnsxdR0dd0CcaVtgQA2u6sfyYvLVbtmPEuXPWQYoqiRxO43MXYshWnk/RwtwiKre3llD86lHIpA80ZywrQLzzGIxx30P/2xYuzj/6K5KXrcQuw/jRwK2caP+kxKs4bpfTTxzHCbqWTLu9FAgjT8YiC35w3V5TRRIpTGQb7oO3x54XgIkaurOX9MN7vwVRaGvok9CIc0zkorxyRjDKLiK0Mhx3Pqjc11XG1lfK5IPBQvSdBEdQaBGAN8nrc4Ol2Ouvpwx/W7LpYCCiYZC7qBaZREwhd+rOj+LTOiL4ozgRsA+Ib8B/R104NJovXD7SJObns7W9FWY/yCZssfFPbgSOTlIbEAUPc8wIrh3/EwMm4qDd9u2joM/pECszxnUUPPQUfFHo6StNEvqXgmDsZBq+g/iulPva6WECio++0pU6GAPehI3xd7Q/ijVAA8wGeCYrpIstrycyXU9S2lqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39830400003)(66476007)(6512007)(8936002)(66556008)(66946007)(38100700002)(4326008)(86362001)(2616005)(6666004)(6506007)(5660300002)(8676002)(478600001)(1076003)(110136005)(2906002)(316002)(54906003)(16526019)(186003)(107886003)(52116002)(6486002)(36756003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBP1xhCbSCkw73aFRuI4WK/klK/EfRqJlWVV63rkNgvn7nbvIiRUH9thPoF4?=
 =?us-ascii?Q?BwEj0p7lKzrSEph6s9eOzx5CFuan/YIjwJIuFMbMs6YfmQZ4JU4crGMsQ2mB?=
 =?us-ascii?Q?mjjNblhLHjEpjewJYt0XlJuyaiG1EJic9RUwUJgu3swaZVUsJN498lwgBHu0?=
 =?us-ascii?Q?UJmGwj/epFh8Vei/9jfmPxPCSjBPIKEgcEDmjIvthK/nrwlvcz20nfsEMzFd?=
 =?us-ascii?Q?jSoPLzdPxaeIMyyyI2JO/kOH788gBCVewnpQD4jT0cT2VAvb6FO6Peam7k41?=
 =?us-ascii?Q?/hXKezeJorK/uto6rvJHLNCV6m2JznVQzJi9bsXgZWjPBk5Eq9qfBUmzv9Su?=
 =?us-ascii?Q?eFPl7EkZo/r4ukPkB4KbIqn9KonwbG5997l7tPfCgEflg63EKEaKEFpIN6vC?=
 =?us-ascii?Q?u+P5vCiV1/jXT2meFtl3wOgeFFmNS9u0tocGMIdOt8PXkdgD237W9EU7w88l?=
 =?us-ascii?Q?YHLJCtciVazxJxWtn058+U3NCpvCnFFMoaOa4u9oBoRXrurnDT5HmbOWmK1j?=
 =?us-ascii?Q?FjPvgxwiqzzBe2MoSy1qaVce7g7S3ksBkoebqbANH7bkiukzQsvws24CloYz?=
 =?us-ascii?Q?SsFwtr2YWI8qhUZARWUeBNva52ltGNz0ndMIcrJNsWPXhf3DbgB6Sc+Undx8?=
 =?us-ascii?Q?GNe5f4mO1Qkmw4XdRle2W/aYF6r4OGU6JXrj6UTm5wk5ZUixd5lM/pSUJwVE?=
 =?us-ascii?Q?phRK9j45JU5ELikbcjkKhvfHAiTgkaf+ydYWF6HHUPZqKLMrsRQMaEi+Y/nz?=
 =?us-ascii?Q?ZkEOtDwsV3RIyH+nAPUxWT/k6LNMeobxFX9RZ/OZaK+O215qKME3Qll/s5DG?=
 =?us-ascii?Q?gpu3AULaA0xZvk6Hls8SiLVpmuohxLEwcCo253+bPjixkNET3YTdwKLRdQNA?=
 =?us-ascii?Q?/tu1Jpnlw9iQR7uhTG2Xlp8hcDom+xuI/u5Z2Ern9RwGCO1cOv9suWSYqKEU?=
 =?us-ascii?Q?p/aPo/ouLhHh+C6b05cQJeEDlJcRf0n1uwX8MMxzXs7JXNAk9eufW/XBU+Tj?=
 =?us-ascii?Q?WLlOYqpHcT4RaOfZ/wgdFhhfcQ3PcfZEYM3n2jQW4FvRKMhpp5L1pMZlWAKc?=
 =?us-ascii?Q?FDFUjvaJ7v3M9nAuQEM8c+yyym+HJuFQ9oGpLIGPugeIEOyBii5Tyk1kZRy5?=
 =?us-ascii?Q?pw387IUbZtnH36t8KBtsTsZ11MP4XLSY4DWlVZUWbLGFp04mo2P3fZIDP2NE?=
 =?us-ascii?Q?Ku5fV3vaAU9SHDlWJqQIXSNHbbgykbozqbpvdZhmCI6AERMTLBQ/75eM8voi?=
 =?us-ascii?Q?rTgQkgLJel876fOq9BeWAJg1Y9pYCV8VQRtbWkX2ZMt/1tw1ePjKTlyIY0Ao?=
 =?us-ascii?Q?rjAUk71/FJBa6ARG9jpqUcyQGzY6r/lZK0SDvHk7+bS5gWjluk6m4CUNPcM8?=
 =?us-ascii?Q?i5ctl6GsURmw33W36bPB6MnTumzc?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72228aa2-17bf-4be4-ac3b-08d930addc5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:02:33.5663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEwOqvGfMOrXBMAEw4U0Q5NMAniFVPmGwe+M0jaT28DmBEuZnYtUQgRmvo8jNzo8XX6VKbpkf12qWfZCLhlCYEbh5bDgT5xRlMY6Gu8Bu1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Add table and struct to save the result of the three-way merge
between pre_ct,post_ct, and nft flows. Merging code is to be
added in follow-up patches.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 14 ++++++++
 .../ethernet/netronome/nfp/flower/conntrack.h | 33 +++++++++++++++++++
 .../ethernet/netronome/nfp/flower/metadata.c  |  2 ++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 2c636f8490e1..3ab09d040d4c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -11,6 +11,14 @@ const struct rhashtable_params nfp_tc_ct_merge_params = {
 	.automatic_shrinking	= true,
 };
 
+const struct rhashtable_params nfp_nft_ct_merge_params = {
+	.head_offset		= offsetof(struct nfp_fl_nft_tc_merge,
+					   hash_node),
+	.key_len		= sizeof(unsigned long) * 3,
+	.key_offset		= offsetof(struct nfp_fl_nft_tc_merge, cookie),
+	.automatic_shrinking	= true,
+};
+
 /**
  * get_hashentry() - Wrapper around hashtable lookup.
  * @ht:		hashtable where entry could be found
@@ -171,6 +179,10 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	if (err)
 		goto err_tc_merge_tb_init;
 
+	err = rhashtable_init(&zt->nft_merge_tb, &nfp_nft_ct_merge_params);
+	if (err)
+		goto err_nft_merge_tb_init;
+
 	if (wildcarded) {
 		priv->ct_zone_wc = zt;
 	} else {
@@ -184,6 +196,8 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	return zt;
 
 err_zone_insert:
+	rhashtable_destroy(&zt->nft_merge_tb);
+err_nft_merge_tb_init:
 	rhashtable_destroy(&zt->tc_merge_tb);
 err_tc_merge_tb_init:
 	kfree(zt);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
index def95c3e8bb7..753a9eea5952 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.h
@@ -12,6 +12,7 @@
 extern const struct rhashtable_params nfp_zone_table_params;
 extern const struct rhashtable_params nfp_ct_map_params;
 extern const struct rhashtable_params nfp_tc_ct_merge_params;
+extern const struct rhashtable_params nfp_nft_ct_merge_params;
 
 /**
  * struct nfp_fl_ct_zone_entry - Zone entry containing conntrack flow information
@@ -31,6 +32,9 @@ extern const struct rhashtable_params nfp_tc_ct_merge_params;
  *
  * @nft_flows_list:	The list of nft relatednfp_fl_ct_flow_entry entries
  * @nft_flows_count:	Keep count of the number of nft_flow entries
+ *
+ * @nft_merge_tb:	The table of merged tc+nft flows
+ * @nft_merge_count:	Keep count of the number of merged tc+nft entries
  */
 struct nfp_fl_ct_zone_entry {
 	u16 zone;
@@ -50,6 +54,9 @@ struct nfp_fl_ct_zone_entry {
 
 	struct list_head nft_flows_list;
 	unsigned int nft_flows_count;
+
+	struct rhashtable nft_merge_tb;
+	unsigned int nft_merge_count;
 };
 
 enum ct_entry_type {
@@ -106,6 +113,32 @@ struct nfp_fl_ct_tc_merge {
 	struct list_head children;
 };
 
+/**
+ * struct nfp_fl_nft_tc_merge - Merge of tc_merge flows with nft flow
+ * @netdev:		Ingress netdev name
+ * @cookie:		Flow cookie, combination of tc_merge and nft cookies
+ * @hash_node:		Used by the hashtable
+ * @zt:	Reference to the zone table this belongs to
+ * @nft_flow_list:	This entry is part of a nft_flows_list
+ * @tc_merge_list:	This entry is part of a ct_merge_list
+ * @tc_m_parent:	The tc_merge parent
+ * @nft_parent:	The nft_entry parent
+ * @tc_flower_cookie:	The cookie of the flow offloaded to the nfp
+ * @flow_pay:	Reference to the offloaded flow struct
+ */
+struct nfp_fl_nft_tc_merge {
+	struct net_device *netdev;
+	unsigned long cookie[3];
+	struct rhash_head hash_node;
+	struct nfp_fl_ct_zone_entry *zt;
+	struct list_head nft_flow_list;
+	struct list_head tc_merge_list;
+	struct nfp_fl_ct_tc_merge *tc_m_parent;
+	struct nfp_fl_ct_flow_entry *nft_parent;
+	unsigned long tc_flower_cookie;
+	struct nfp_fl_payload *flow_pay;
+};
+
 /**
  * struct nfp_fl_ct_map_entry - Map between flow cookie and specific ct_flow
  * @cookie:	Flow cookie, same as original TC flow, used as key
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index a0a0242567a6..621113650a9b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -667,6 +667,8 @@ static void nfp_zone_table_entry_destroy(struct nfp_fl_ct_zone_entry *zt)
 
 	rhashtable_free_and_destroy(&zt->tc_merge_tb,
 				    nfp_check_rhashtable_empty, NULL);
+	rhashtable_free_and_destroy(&zt->nft_merge_tb,
+				    nfp_check_rhashtable_empty, NULL);
 
 	kfree(zt);
 }
-- 
2.20.1

