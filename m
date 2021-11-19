Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18C456C00
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhKSJBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 04:01:20 -0500
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:30177
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229667AbhKSJBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 04:01:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nl1UHaI8CCJSX2aqC2OUATRwQgYvePBSMicIInSK8aim3+MKqJOqRdZJkqixCCaor3rvELydGrSBsg3BBzOhueIxd8yNFrUbuIPE02J8RUlNmj58ovL8b9bYeYcr3j1Z0C+TAZ54nyDfHVZ1o+r2+asZ9ANNKcADQjXDqTf/XnGT6gflGRm6Rl4rP1UrhyJlYnvxadq8Y9Dsg/pe/FlSesMOZr2K7r1hr69qAKDqpfSsCIsT8nhNMPdtm95t1qbIyZ0OMJdwGjcuvdd+epcrq7lghZ/WY4yc8W2CJy46rwJ8UlCkGULWBP0Sot3mzxwBrg7DCQf5jffkdNhjzH9JrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jax8HF/uA+rCvSlcpO9zy0ajuVtMocOxKBAG7y1IR1w=;
 b=MWUVlmsxH4vzo0oD0m95dYnz5IAFpN7uV8JgXOPwWU/mlLMQWAuWyouYBjbMfJZzKLRi06VkHin0gWKzm+AccH5tC6v1FI4ZPHW7DrMcsJRCuwtaIwcbxfqEopvwsXATtJqjv6FiVSpip5K1f3xlYjDhkwV7qwJ/9CSfa68H963RAOBZLjoIyOhqzsTdNym8VCXj8A2klqKPkeeWOqqqQiToLXl2tZPtCGlbX995UOwnEtf4fiTYcAZl/o5DTakvD3c6uiKHV2J1BgHDFaeKsGq1cJ4ikgE/TfLBwf6zFG9ytAHRfSWtp+bwZych+BZlhYFivxuFeu6GlsDZDuU2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jax8HF/uA+rCvSlcpO9zy0ajuVtMocOxKBAG7y1IR1w=;
 b=gQol3d2zjkiQx/2rid90GMp2A8/m3RRkcAEaKn7tOs9wQ5Qta9FJSx0V6LQpY8r5HktNXAwSd/RUnqIWBZzYw7k/vdFFAnF91bUoPvn0GLqGsdyBCHZ6lISPy/RUqsV/N9rjeJpMgniTd2gVQlGahVZHlH154SYzbKdsCyMrXA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5431.namprd13.prod.outlook.com (2603:10b6:510:139::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.15; Fri, 19 Nov
 2021 08:58:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Fri, 19 Nov 2021
 08:58:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: correction of error handling
Date:   Fri, 19 Nov 2021 09:58:01 +0100
Message-Id: <20211119085801.3879-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0108.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM0PR10CA0108.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Fri, 19 Nov 2021 08:58:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a20f1534-d214-4153-1760-08d9ab3ab9a9
X-MS-TrafficTypeDiagnostic: PH7PR13MB5431:
X-Microsoft-Antispam-PRVS: <PH7PR13MB543110F83831299459099F5BE89C9@PH7PR13MB5431.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmBIhM7mJHgAleJUISXNyoENN20GaZqtHR87YHgSQd8IlPfkjAIuWOrchn3IaVuyr6zBeoe/w0lXSkaCHZyfhBLngZuaGQijfy44IUO/VycXLAtT/UBQti87keTPwXnOv1Ubko6EEN4LKm4FTu820S0+Y9BddlI20UEliYMji+Qdp6U6D48kRyX9ZYf36dBLqTZjvogzgYBgweF8Q+gxoU0hTPoM7PkVSWzwjfuNTqYT2KFbg8YM/YUXirSts9IMvVkM63BqDE7quNLXa9ADbPwWerXDoNeR8Ck3DO4FYrj58NqJWTrBak/+aM1JX39oQBJFX8Fhka6hL7yjh3Z+nJ1WlXg4Zbj89ytRKlAqaSxd/i/V8d3s/q/xvVUJ0hmOWZncYScmBTNx3AmzBR20KGsikybaerO1kSZRonb6INU4bdVQ7affL1DCMmuau53fw4Q8I/TOxczkMEWG0vhzdw59xxkw6mdNBCbmtNWYWEqxQyb8qcrjZobmJRMcCL37T9ZU0j7dzmutyQGpvOBqJeHOovItAeYDjkfS78NU96Y8poQs1xpoH6nb3w2pb6amHMjMD/wazEw1v03fPHc+uwF2s6RrnQlKKXwDAg+/jJFsd1amRQMvsUzgqIFVZFyXsGTU2V/82/i+M0Sj4mDCRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39840400004)(396003)(366004)(136003)(1076003)(6486002)(110136005)(508600001)(6506007)(83380400001)(6666004)(8676002)(6512007)(186003)(4326008)(66946007)(66476007)(316002)(8936002)(54906003)(2906002)(44832011)(66556008)(36756003)(38100700002)(5660300002)(2616005)(107886003)(86362001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1NaNVXmxLiYXNyXO3AMc7yGQV8Du5CePbNhyy69IKjlOIpVvT7ALINdtHn4?=
 =?us-ascii?Q?fZAp5fpzcSPzeg3PPuavQWW0Qp4J7Z2u3yRvZaNKeQhhPF/5JeFaOHdKpfQA?=
 =?us-ascii?Q?6F45uRJdbM+Ueadawka3Htm6qldNCN/njRFWxam0GpYafzCtviLj2AtoXWwC?=
 =?us-ascii?Q?ufkQ73Zw+zn4RoVZ9yCZ6K8bHTGPKvt1Phpeia0Blh5M18N0F2gKxs5P5IyR?=
 =?us-ascii?Q?cqBqhT3LOiz/gA+cYQZebOKjm0Kg9MlslOJcBCyI0GFILQwgRiCsVsbqdGJv?=
 =?us-ascii?Q?Rkr+e0RxD6eUeg8NA4JngMxe37CJnXpeHQ7j1mDONKIbG7d49gENk/vEN5uZ?=
 =?us-ascii?Q?g8ML6yBQdZ30B3r2NoE01TFHB2IE8ukrpqHrAhOwb+Ch37WaCH16NcqaQNcE?=
 =?us-ascii?Q?GqlMNWSVWkt4OhDQHUFKMqmz7cWl6tbjtt4j46o57ehuFv1X3tk797NHRkbb?=
 =?us-ascii?Q?kgiwBOgwpfbH422NJYYo7yaYXbv2rh8Mv7Je0/HZ1o1fPt1C/Z3qVS1hlY6/?=
 =?us-ascii?Q?CNuhW2TQlJBqSUhOG8deIwaAZKPsovZHBK7QmL5LIrymKXpdeKkpDRoYJ8PC?=
 =?us-ascii?Q?CFJFQqKyw258pQN5yZkLuCaXWL4hroLEY6+ItAEDFBJNvoVq8vs7SKYx8I4s?=
 =?us-ascii?Q?1x9La6KT+5o689qz4w52AFzEJH/dOTSnevC99LJK+UYTq7zw5AYRmN8CeoEj?=
 =?us-ascii?Q?iKLf/jkLVAdgizBWg03DmOky/jAYC+CKzH8FDKZUXeg2ydYAEWh/kfY2M0QC?=
 =?us-ascii?Q?gZHQ4LdwRFa/iUgcHUnLbTLnHbxET5THSs70uDPpPYn+fb8n6k5z39gHK0MJ?=
 =?us-ascii?Q?vxz1mooqYlCBwHMfA5mvQLfdx/Tup8b7GxDfGb2AHdOmkPM73XaQEd5a9xF/?=
 =?us-ascii?Q?0+iz3q200YiRTN2brXv0m7A+XXKW750/QzLP64tei+rT+KkLVFzrM8W2vr7/?=
 =?us-ascii?Q?vu1fooWNU1+b/7c4zBuf8vJqayFM/7AZNjFxOtbm4KBUZqhzqVI4swKOGMa4?=
 =?us-ascii?Q?xpICVt1e+UVLlTP+f4WKkrE9oT0H9OhG3fjJFEzvc0JZKMG7kE/RVzb1ppS3?=
 =?us-ascii?Q?+qiTvt+sH/9j8ber9Z84WdhWkYZ6kxfEaEDTsAmsCy0FSCWEmteNBBT8ccql?=
 =?us-ascii?Q?XbC9W02oNIVRZlZgqaF7sDeSrvXId4IjnO03SCE/ni4gLQ1RVL77HdLTfzwW?=
 =?us-ascii?Q?EgSz0C7FUjJZWcbYysk+8TFtY+w0mq/6HW/3d2DQz77n5KmwC7rWC1hmlr2I?=
 =?us-ascii?Q?Msk5tW7j1aPPJmWszNHI1iaUWWUFF8Hc0hDwsLoFhhoyz/y/VSb7MCQmeOhW?=
 =?us-ascii?Q?uDd2BpJ5Kr3myHsZ509JObb3ZcxscH/bYtFA+dYs+SAVq9EBb9OnE5UA+YOE?=
 =?us-ascii?Q?/Vt5ZAzbTQfTIv7TKT9cgS+XKDsQQFdEI2V3K3lMuQ0aG7l74gLw8RqogIXC?=
 =?us-ascii?Q?jdXIM2UPEgYeynN732xPvnA+cFCOaIiFjdv+98btI7PpHeNegQxw4KGbaktQ?=
 =?us-ascii?Q?API9AVniKiV6+xlpIS/G8JWV8rD2rwY0BbRr3/h52Qi+laeU8+h/YHd7uElt?=
 =?us-ascii?Q?XKZ8cbnNVzz94kmBe12SltjIwjtyo8CEdhlXr3KYqvFuQlU0QosBUCodaWgt?=
 =?us-ascii?Q?jw3u9h/w8OOIg8uwD+Xcdj24XdJ6j1UCMR+RU6e8FiYulDhyS5cJ0eY2TEag?=
 =?us-ascii?Q?loC731632Mfsoz49GXVxQD2JL4wAWSI3WjIkJn8iOMoV3iiQdqX+QNAYLlof?=
 =?us-ascii?Q?GV8ZY+ZiFNs+SYkCZxksbizA9gOdxXg=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a20f1534-d214-4153-1760-08d9ab3ab9a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 08:58:16.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYwNudvvvXC58SYT2u7TzZKWqWDIWJD3eonMW7Lj/EvjckZ+yahoBoC4oPhoyP0fEk9P8qv/fc1ZjFCPVBIKwQ5qSf0Doq6sgxulKKS+W/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Removing reduplicated error handling when running into error path
of `nfp_compile_flow_metadata`.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/metadata.c  | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 2af9faee96c5..0c60a436a8f2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -338,11 +338,6 @@ int nfp_compile_flow_metadata(struct nfp_app *app, u32 cookie,
 				nfp_flow->meta.mask_len,
 				&nfp_flow->meta.flags, &new_mask_id)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot allocate a new mask id");
-		if (nfp_release_stats_entry(app, stats_cxt)) {
-			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release stats context");
-			err = -EINVAL;
-			goto err_remove_rhash;
-		}
 		err = -ENOENT;
 		goto err_remove_rhash;
 	}
@@ -359,21 +354,6 @@ int nfp_compile_flow_metadata(struct nfp_app *app, u32 cookie,
 	check_entry = nfp_flower_search_fl_table(app, cookie, netdev);
 	if (check_entry) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot offload duplicate flow entry");
-		if (nfp_release_stats_entry(app, stats_cxt)) {
-			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release stats context");
-			err = -EINVAL;
-			goto err_remove_mask;
-		}
-
-		if (!nfp_flow->pre_tun_rule.dev &&
-		    !nfp_check_mask_remove(app, nfp_flow->mask_data,
-					   nfp_flow->meta.mask_len,
-					   NULL, &new_mask_id)) {
-			NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot release mask id");
-			err = -EINVAL;
-			goto err_remove_mask;
-		}
-
 		err = -EEXIST;
 		goto err_remove_mask;
 	}
-- 
2.20.1

