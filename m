Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3C62A360
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbiKOUu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiKOUuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:50:13 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259D3B866;
        Tue, 15 Nov 2022 12:50:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiNLXQrdgjLD1Felt3Lsn2GwV3epsFWtWYqGoP44b6DFLWzc/fiaS3VIYbYBrbTWG9Hj5pvsiFhj6EfgmG0+Bs608/+A4dMU4p2JgREujxWXVF4jFmUGFpnfFeIVf3u/o9xWNxWhw8noqxNXgcqTEGyUpAppwt1wHi9WuIITLcWD7kEruiFzyaMEeLdUAK11ngu+iHLj9wPumczaM9SXWE03RiXpFSccCb5cKsm67sxwZ5S8Coi2TtpWZ+7pHiPf/J0CjKNUowsJE5EECLhOmwCu+hBANw70w1Q41zJqg8qcv6pgQvIrz742zxUdn02iuhF7mp7OkErdpv9tmBsBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVeZBtalcc2PXkHGZTLwZ6gwpE7uWotjeys7jAPOtDg=;
 b=eyzXkZTOzwqnBRPNP3vLa5T58EmulhBoh+MLdycFp08l4JJSVgPDi/FjbImwQFCIHX0JmeaSzASt58Q4oJnTbs91c7kcLv4X1jCWnxsHjlwM93tjhvGjRreeXORJL+AugxTMSlFH76Ikz3LMPUqvjPWS+akPuhtXKImr9h1cxu0+0FNTZTUupSp20HW923ohg458cUF/fsUF/raGy2lvRPgGpVxqw66N/TqsmehKz//PW1VJ7md3f6Qx+lAnZDaHZHOAJDD4yrNL3n10i6xrt4VPIi4PdmhsLsaukyPcfrdA4EVcHRUrM6nXNv5iHTxOxZKthPPD+bNmr7CZAd94UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVeZBtalcc2PXkHGZTLwZ6gwpE7uWotjeys7jAPOtDg=;
 b=nPeLHTlafoS4hKnbipHIQvjzIW4/dqRbqmfgH7m/WKxvOhlewT4L+aqDLcuLPqWOMaIeJwQy145joOhCBuII7JBHIqJiUK65I9z7yzAHGRdz3UI5IXrHSGkbgzXs256QoQCWcezX20velC5yRj3Ms0r05gjyWhXe4OM3kZDouoQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 20:50:11 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 20:50:11 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v5 1/3] net: page_pool: export page_pool_stats definition
Date:   Tue, 15 Nov 2022 14:49:49 -0600
Message-Id: <20221115204951.370217-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115204951.370217-1-shenwei.wang@nxp.com>
References: <20221115204951.370217-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:a03:338::7) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 353def32-2a4a-4398-c2b3-08dac74afcca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5AtrRN2DTzZCY+wxUDKk+pxSTIrVm2GZ1L/ckjw1vGkjriz2eEAX5gQ5IY7V7TJDoqHo/nxAK3PhMhK9KwWXgjQUD0nbBlptiunO2Rb+UO6haUJRIlY3CvLjZjAeUE9gs+1YaRCavVf8miLLt/Pu5pqrP45LoxR8jI0YPFzXY6lbx22xLIpr9EJLfrBtbI/Ul/N5AlYELQB/ZpEbpNwQr9Bq8c+FuEke5W8mTej2kFzyDsHRlV007hfZJcStXW5hsmPgIGFwyBDD3L8MmRJMo3hLiLLijIiuXaq2gm1IPpgtx/LP6rO3q8bGaAx9dIOiNZmWtJ3ataYPx+qyuBVf6Xkspu3cMKnrLFa23ho0WFQ9/dshtlY5uJo7pJHEyB25id4zUmyDDGhfFjfW0xoSvdZkEdYFn/o5BSnyrqj5wzIenVgPWsAALN61Nh/cuANGyinlnAxZL9Kl41PwipxUl67aL3R7/XecuanESUlRH5uM8IAstyKY8mf0HAH0rwvEMgVX9QoWzD5NMmyMjviWxc0CCaUEyW/wKh2m110m6KIyoNvAwJ9mb0GaTmdINgQndtKN6eHCGi+5TdqsAomzGNFz9fOXU4RmFjbO2SM9Bc6fQ3hrtzbIY9l0Sj3oE6BxqsJF8Yv4/gZY9p0snpAbF9YnF+UIJue+dwgONQIB6kATWB8MlSne/aWvFxZcsXcgMMHwvBwlDHmPlQABKHXhIOw1m0OMAXBG0bl6Am5C566sT6vb8tQJUWj4z15U1MBTFxaDiXdsfhmtBX2i7P3O0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(66556008)(5660300002)(2616005)(66946007)(66476007)(6486002)(478600001)(86362001)(44832011)(7416002)(186003)(4744005)(110136005)(2906002)(36756003)(8936002)(1076003)(6512007)(6506007)(6666004)(54906003)(316002)(38100700002)(41300700001)(52116002)(55236004)(8676002)(4326008)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iR8TtnJpvT7nH2UvOi6fOaAHPvAGKJdR3v4aBV+cb4R1qdOW22Pn8CcBs4/3?=
 =?us-ascii?Q?lLq5jidrlbr2+ALMsYg65Ef3hEq5RuvTg+aIadjt835JeG1kW6Kfp5Kbyj2C?=
 =?us-ascii?Q?pNfPYeFg2R5UTFCf6j19rYLBzv0SrdHLDU+iJpBqDmEyLVFo7z6+eP1c0XKy?=
 =?us-ascii?Q?kIhxZPytpCXcf1fVSKmbcMAH03I7NXwB8o+0eozY0+7icrK1tUHRmLEaAtfZ?=
 =?us-ascii?Q?LZUaMNjKx5cMBc5gDlQlRDw8wqCGIIJGKBePgx5kpfbkEtC0HqCGYjYpid3s?=
 =?us-ascii?Q?rlZmlk27RZBVZbKKahzeST8MmH5+knHACgoALnZMoQrgaQxNwwQ6emlbzGSE?=
 =?us-ascii?Q?hSq553BJzC5+qJDAVTUFWYMNcpHmIcUz/j2oABpvCVr2qAxW/JtR9YpbK3a1?=
 =?us-ascii?Q?pwe7Ie+dz3qo2JIMRdoWCCrtgnmq+gXOetNSVaG+lcdUJV9JR7fyLZZlUbpr?=
 =?us-ascii?Q?iA/kQVF2gYuPGO0leClQ7rNKlJkSvT4ppqUvuQX0suN6pzmKu7DU9oBw+tPv?=
 =?us-ascii?Q?ydIsOJrASWDhxg8Qb+9LAXuh1jqQ1tsB8z+OTuWGfDyJlfs2o65pnIg1bT1e?=
 =?us-ascii?Q?VM15/XFe6DoVh+a57BFRCcqQZX8gv7yZJIrL5uoalMSGv+p6bxyiFELmBsmh?=
 =?us-ascii?Q?FXbAsSbJcL2+LqhBfV7XR3/RabQsTb0Fk2MWgsz1z/9nxXxTm89ZudCcS9si?=
 =?us-ascii?Q?KpfPN8JXs9YV9K22QuDvAnYZvjKED2R2vAKC4hA5+DcKbVrsdcx5sGIbOh/+?=
 =?us-ascii?Q?8qfcRBEeQ3+IULOVfQhYmENspgUvpSL0CxO7EyMg39HjhjfC4dA/Q6pAS4rl?=
 =?us-ascii?Q?XG1XYghiAtWJkhYIQCoqqTuPtq+K/alwcS9Nj/1U+QM7rU3iRtJoIgVu+2wN?=
 =?us-ascii?Q?ETwmhT3rIGE8PYJXZMd/wZQIJW0+BBL5j4tJkCtQoo/emEK4CQjEwTnDmLmW?=
 =?us-ascii?Q?TFmaHTZWue7M8AhQMSLlqqVd3kvt7bGlVqzIr5m0s0lu6YNQepe+zTFUDj6B?=
 =?us-ascii?Q?WjnBGb5Z7tQ3sdogy5YPAUYIupMTq+rkDL3gQwBsy2Mv/WuMorkpgcmt3waZ?=
 =?us-ascii?Q?2EOPtLkQYy/8A/sKH0dczbimphcI7ZCLKAR2/Wf8AIMR3AYDlq0J3/v06I8T?=
 =?us-ascii?Q?CRRHpGm2PNvu1iZc0UqsgjMdzuGFoYNhh76+0gDhsScOqG2yU8P4Yhi4dbCA?=
 =?us-ascii?Q?1DyHE8KzimIH88k78tSWrdGd/7GSRa1gTPlxz4t8vIKscfCLkfopUF9wSoYL?=
 =?us-ascii?Q?qQ5RaljRSzbxb50NRkRUhw0xpsp3OuDQC+JqwEvDX1coCmJEwo6WMOZ5ExK1?=
 =?us-ascii?Q?xETz06nIF3aE5Vzh3aI6C+RzLoqY5AspPRv7ahBjFAlkM3A2uOt+raCkTaeJ?=
 =?us-ascii?Q?euOVFHCfWEJLJ4j3FzIT4zRwNfeN4buOjEg3KiEv9MDxEO/vEXHNe67q2l18?=
 =?us-ascii?Q?D2Vkq8dTsxF/4v3jk1Oof1Y2LPY0EBIf40XUHv9GGxOHEVWhmh+YYgINdQ3/?=
 =?us-ascii?Q?holdvI1BkFDSwGGQ+NG0qQ4iwRc1mErifeLCSji8jUYlBb+HZTdnHZGIT8yX?=
 =?us-ascii?Q?BYrMl2puSvK6DbOsh+AxfwyLlDcsJ6URGuH6eO4d?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353def32-2a4a-4398-c2b3-08dac74afcca
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 20:50:11.1344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyOhY1mDu6TF3Ky6UtZZZGYQiMDy1xbjAZQmpABcA5s1EYzYEI/a4qNRi4TNKLYnCKIh3vwO2sktrqAgM4W3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of the 'struct page_pool_stats' is required even when
the CONFIG_PAGE_POOL_STATS is not defined. Add an empty page_pool_stats
stub, Otherwise it would require the drivers to handle the case of
CONFIG_PAGE_POOL_STATS undefined.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 include/net/page_pool.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..516d943bc1eb 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -129,6 +129,8 @@ u64 *page_pool_ethtool_stats_get(u64 *data, void *stats);
 bool page_pool_get_stats(struct page_pool *pool,
 			 struct page_pool_stats *stats);
 #else
+struct page_pool_stats {
+};
 
 static inline int page_pool_ethtool_stats_get_count(void)
 {
-- 
2.34.1

