Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAD9514370
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 09:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiD2HzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 03:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiD2HzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 03:55:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2137.outbound.protection.outlook.com [40.107.92.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08B878FFE
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 00:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5ymVzW7V7Zq5MTI6mZyKAKoDnruRMpd/AJg2mbQa9fkdjswja2SiGmmR3YPbaq8ro5Zt/TsExoU+gGoLxo6W3gIHlVSmVJAC/W6BUWTm7vej7FrlEwJDNtRD4oIg0Z57ezpakv6XYgvvp6xCGX4Dud/K4/3LHYgxagnB3/XkqHW9SlvWP6YxaTz73hAO++nBAEA3bse6RJ9T1XScTG9QtkEcwDkRz4NLlKYdLotWZl2psYbo2hnN1jbmDlrJ2+1sOsriN7l6oAnbp3wBQ7+jhQjQ++XhlxhCzpYsCfJ0IOdfWWuT8hb9tbd978zBDUwPB1IdoqNCusfYFRyAYQXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVWbduNuRIT9Q1C0YCliy7GYkATVUAVZSSKpRlFlGpc=;
 b=CE+oqYH1L/BHh3clm72Bc3YKYtknt/rebTH6bGdabPPOMnWa0iJi0UYbeRI1XE4khKLM1OOUx4+PQ/PWXMVj9Mb6Xub5gikvNzqY/H4UVKcU6YpChxH5E1o9a4Ijn1/6tu4CvTtXyynAqoC+EIrczcyh1Z8QNTHddSrDxlBsQ9S1pY09bDzJRZ8jj5d3uP5F7dOGRi1HMHl+/NSri5f6Avtlbg6/IO5c07Cdr0eFVPl+oqdh1U+y8M2RQEfxBjI7jg8gVUKv8IZh926aBsI/QW/G9IOKy/VgO/Dyi4y26wQFe8KYMKYG2kzHZ6WsvYNodqLv7IS8+YKPtgC+BhPRbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVWbduNuRIT9Q1C0YCliy7GYkATVUAVZSSKpRlFlGpc=;
 b=LIyY9hajPPFW/rFYQqg02XLp8Mj9cROtNMK/D2Pel4tJIcdO/wQbdPJlCOErwGTYV8S9lKa2B3dd6LA2Clc8uViCeLwAtaUSvBnRc0hmdj1LKrT7WGuPHH9oESVl90RgY9cjmF32kaje54pn7/G8C1ez8MzOblmTD/M1pB+cCFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4982.namprd13.prod.outlook.com (2603:10b6:303:da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6; Fri, 29 Apr
 2022 07:51:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Fri, 29 Apr 2022
 07:51:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH v2 net-next] nfp: flower: utilize the tuple iifidx in offloading ct flows
Date:   Fri, 29 Apr 2022 09:51:24 +0200
Message-Id: <20220429075124.128589-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0080.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaef986d-3200-4793-6ec4-08da29b51840
X-MS-TrafficTypeDiagnostic: CO1PR13MB4982:EE_
X-Microsoft-Antispam-PRVS: <CO1PR13MB4982CBA36933D7B9F82A59D0E8FC9@CO1PR13MB4982.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2ZimZ+JDaYqK8L0FI9ubNuSZ5oZ2QoFOGSEy0Q0HW0hTtTv7L/xzjPMN1I8W15pePaS8I+yO3X0MH7bJlYyYB/GOz+F0at7tptNNbDqrojG0kd+LSnyvwUrKuhKZggeQMTd6A0KKVAjWvRqDJqlDfkoqufBx+VCGPu6aYF07nnp18e54rq2bL8/E7lcVHQPTKqzFFSHeYTjDwOcg+0oePXBe2U0ahwKRL9IU/++FFsXRUOFpg6IK3fVp6bUCRYvJjWEG3jF1hm/t+DAZ3y1E7Fbrac99/z6EtC+YfZGEBq3akuhFr5xmDLTo0J16mTjcG22Eu9apG/ZROw3KXr/jB3bm4eqwoBlhZlxcVJ5xdcFicNuWZXSk7T9s5fX/PqE4nDZh1NO2hHFEQYI6qJdMTplteNp96rrl6v3xivDIhvIxJAyVhLbSQ6FAJOF7Ur3aSlGfwDm1Kup659F3J2PUOMRzekIllfz+55WD4ogpDNBuuSL9U8vL+slq6za7v01qS0UFNGYPcsIRghctzRKYTMqVE0y1Kv3sk5I6OsxIakv6n4/ZQi3ZSCjvHw1KrU3TykiI1tXRn2r2ihzbKc7SOj0jTGBqBx28AtWXR+l+5eD9ITVY0q+tjlH4MtQ5T3d5F2vzXXsergzIgq3iikIOdXrwGsH/E9E9N+u3l76QQRWTsFnHFY/ch3Knu/f58FQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(376002)(366004)(396003)(39830400003)(2906002)(38100700002)(66946007)(66476007)(52116002)(66556008)(8936002)(8676002)(44832011)(5660300002)(4326008)(2616005)(1076003)(107886003)(186003)(6666004)(6512007)(6506007)(83380400001)(6486002)(508600001)(316002)(36756003)(110136005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YTT8u7WzdkzM1wTx4ZKlmOuUZtIeFDh9xjt6iG34dujbaCCAT89zqiDvhTqy?=
 =?us-ascii?Q?v+NcqiGoCVs5VxanJpNfIv21BuADuEjCLFMmN/ddPgqPoMv8trbE4U0J5wwh?=
 =?us-ascii?Q?n9uPWmH47J4COF5dZPCqdguF7EZDIvjfI+QFHT71q0tNinzdMPmfGntU9TGx?=
 =?us-ascii?Q?KbADyxVVOGVLVf0C6ncYL7zaUhLZLQAclmNYCU8AGKxnJKXqEE9rUFVhX3ng?=
 =?us-ascii?Q?yt/npCh2tfWNnBVe6KYoZuSFpzJcMMFIUJ+Tz3YbWW3m2q8/4gRalmgPe7NZ?=
 =?us-ascii?Q?68lLGhE1NKJZPNqvUPjLde0F6c8LbmVK949U/m5wh5H6JGqDSmWKkZEwf6Xq?=
 =?us-ascii?Q?WWR3rhGKoH972RS9FKSGc5tSvPYCokD5CyXpu5qimKVvIT4HRiw/9TfZ4rBu?=
 =?us-ascii?Q?0NIiM5v1E0ZFS/K9ivAH1bIdsAvag/ZVO4VfFJcYfxl/ltDxLO3qAKWW6ZQ2?=
 =?us-ascii?Q?8gEjCN1Y7PGZC6sX+4eYWPiN2uz6PG4H+QCfXmoYo8HW8+Xv+uCpgOrqujWm?=
 =?us-ascii?Q?1PKbjCbbFFGgq6H6QEcsN+ME7ppnHNtEwjc1VR+QRO7zrJcCX3j4fiyLSnlY?=
 =?us-ascii?Q?VJmyB3w2z3JhRfEw4JOhWn7VkOsRKBNNeY3hACS4j0W6EkYJ6lpcGoZmg8bW?=
 =?us-ascii?Q?t9WXOXG8MqDSN8btdrzUEUuuJq/sUkYQBcHRmeVitm/LMvtGeEeU0gKmhVqz?=
 =?us-ascii?Q?LiZED6dnQOik+wHLBUYvLnkTkp3ihEQAZyLbCBewtqL9qpCGRHDV0DJXLf8v?=
 =?us-ascii?Q?4Kz7aNU4/Vaqni115sHLWD0Bv9v/O+u/x1MfCy5we+gnY4LhJ2LzNwhF2zaP?=
 =?us-ascii?Q?9kH064vgjkp7tIAEh5ARzErBFRgu+QWBLBk8IErufEc5DwiyRmnWzIwPk1IK?=
 =?us-ascii?Q?IfxyM86QO1Mg3cS3jbRopemGOYaGo8OMb6jFBDQ05uAMvVbztmlYH/iqgHHG?=
 =?us-ascii?Q?LiV42rGm5F5hAULYBwyIGc73g4AJu3hYnYC4Izs0qTbQhTfpOYZTDKE+t1gv?=
 =?us-ascii?Q?SInpq5bYlF0enWJoFxNMnq0turbMfQNfYtzzCNlUnCDTqMOsvW+TKuNf09lD?=
 =?us-ascii?Q?Yrz29umj0x5913a2naTd8wvNnlyCsnsGG8ZBeEPhI4t1ZxAmDtFUSieX2y+j?=
 =?us-ascii?Q?SQLerqVE2zcG6FCv1j1cP9RBtgwqbM8FeVpc9BcN5iuGS0nqIDxlL6qw6ldv?=
 =?us-ascii?Q?ytBvouhw3ep5XmPwlAHvqrxBZJIeSWL/j0bC59LBXRoZ+b+LYDz6P2nhJKwm?=
 =?us-ascii?Q?fNebNNDclH8NU3JDmOjInhtwZ7cjffUiYs/RjL0H5PCQhGNEsdbxWMFsksnV?=
 =?us-ascii?Q?KG+tl0+Qx3evABhUNUt6gJs3jgNs79GT73oclyypAZe55l0OostszGbPAioa?=
 =?us-ascii?Q?6BWdkLqSQ3IGbigQE1nOi9vcTUDclo9M78YN5EWK8Kl/fQgrASGqIVsAyVoy?=
 =?us-ascii?Q?UoZZag8wYTPIZC2B+ycH2xv7eN5K7sZ0D/ZC7wWPFuYBOf9ize/73wg72KC+?=
 =?us-ascii?Q?4HeZY6dlgmtupJLt2/p3kgwODxFEMGZzQu1foW9/rlKC+ww3Vigq8xDfbmkW?=
 =?us-ascii?Q?SfafO5vaHNR3/mb1LSYixd8SNpoWlAP4BeCsnoev6k6gWWaBSYyAl+zlez6j?=
 =?us-ascii?Q?a9271RXUy4yxGrCgqqjBPLjggl6h5rUgoL8iQRwP5v8iTxcFKU08/Ht+39Jk?=
 =?us-ascii?Q?UFNxQPltT62KM/7LdBYzLKcHyVIwrGZS4jeYoMYrP/ytW6QnFYhJPr0GIKJB?=
 =?us-ascii?Q?oi7ki20CX4LfkraHvECuPjBT85UJXNdxW9HVXjAuzA1tPcHUkeevtGcduDIZ?=
X-MS-Exchange-AntiSpam-MessageData-1: Y9c7aCLA7zBUughxfMUgRgyA4GFF/HrrxK4=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaef986d-3200-4793-6ec4-08da29b51840
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 07:51:40.1228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt5YEhrb7ZWo2wpe8UZWaJdC+9NbrdoUGo2PsAFraUUG30q7T2+Qq1xp18QWPjuiLPhu0fzi4jKuH/nKyjwl76jne6nnwQdfn8X5RNM2wGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4982
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The device info from which conntrack originates is stored in metadata
field of the ct flow to offload now, driver can utilize it to reduce
the number of offloaded flows.

v2: Drop inline keyword from get_netdev_from_rule() signature.
    The compiler can decide.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index bfd7d1c35076..1edcd9f86c9c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -83,6 +83,10 @@ static int nfp_ct_merge_check(struct nfp_fl_ct_flow_entry *entry1,
 				 entry2->rule->match.dissector->used_keys;
 	bool out;
 
+	if (entry1->netdev && entry2->netdev &&
+	    entry1->netdev != entry2->netdev)
+		return -EINVAL;
+
 	/* check the overlapped fields one by one, the unmasked part
 	 * should not conflict with each other.
 	 */
@@ -914,7 +918,7 @@ static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
 	/* Check that the two tc flows are also compatible with
 	 * the nft entry. No need to check the pre_ct and post_ct
 	 * entries as that was already done during pre_merge.
-	 * The nft entry does not have a netdev or chain populated, so
+	 * The nft entry does not have a chain populated, so
 	 * skip this check.
 	 */
 	err = nfp_ct_merge_check(pre_ct_entry, nft_entry);
@@ -999,8 +1003,6 @@ static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
 		pre_ct_entry = ct_entry2;
 	}
 
-	if (post_ct_entry->netdev != pre_ct_entry->netdev)
-		return -EINVAL;
 	/* Checks that the chain_index of the filter matches the
 	 * chain_index of the GOTO action.
 	 */
@@ -1114,6 +1116,20 @@ nfp_fl_ct_zone_entry *get_nfp_zone_entry(struct nfp_flower_priv *priv,
 	return ERR_PTR(err);
 }
 
+static struct net_device *get_netdev_from_rule(struct flow_rule *rule)
+{
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
+		struct flow_match_meta match;
+
+		flow_rule_match_meta(rule, &match);
+		if (match.key->ingress_ifindex & match.mask->ingress_ifindex)
+			return __dev_get_by_index(&init_net,
+						  match.key->ingress_ifindex);
+	}
+
+	return NULL;
+}
+
 static struct
 nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 					 struct net_device *netdev,
@@ -1154,6 +1170,9 @@ nfp_fl_ct_flow_entry *nfp_fl_ct_add_flow(struct nfp_fl_ct_zone_entry *zt,
 		entry->rule->match.dissector = &nft_match->dissector;
 		entry->rule->match.mask = &nft_match->mask;
 		entry->rule->match.key = &nft_match->key;
+
+		if (!netdev)
+			netdev = get_netdev_from_rule(entry->rule);
 	} else {
 		entry->rule->match.dissector = flow->rule->match.dissector;
 		entry->rule->match.mask = flow->rule->match.mask;
-- 
2.30.2

