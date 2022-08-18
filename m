Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D38598624
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245611AbiHROi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbiHROiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:38:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60073.outbound.protection.outlook.com [40.107.6.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EB5DEB9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:38:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Glh7//Hq/LD9y6NIhVdofpEvIYZIz0JsGRm6F/Ae9N6CkcM6tY9GARr8gmBaTLOe09udndW1LgEySIEUGhWCsfiDlc7f8fvwonSRrmk7oTh8WBIkxdgU21U/RXOR2PUqO7ALvvHw5U+xXsle9m+EdtXJ3Uh6zKYMjGMYFAx8GdV/UUD8lOCGWF/+BqwWgQtI3ejAxNB36uCpIQyxXIvR1lIBR2IKAlLvuXTA74Pu07LGUfZf3dceuEKMoALjwlMyjMAiTr+070R3YmjjHY65r1u5NSjoloGHMffteorBhG699XNSbewl0ND8kgt1aKXIQwLPfQd7ZB0IFH09X4GmWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Uu5/cWSbcC9L+bmV8kzgZVP+GtjiTYqHJjtlJQol1A=;
 b=Hi2Z/L45pab71mIP/aqJlXqjASAldST34Zje25kljEwboO3NGmy1PNZzZsBCLKFOux3G5qVCia2CUuQ3ViOcDEEnxAIIFV7JrQbcCEuhMH+7Wi9Ru2KjfSoYg2tvyi9qIR/2QzjlYR3LCpHkqiPBZnjzEt1hdzK4f9G98BQt6HPzifQNhmLLr7znJWlLRdWu5j0zCtPGEA/ZKPV9M7UewsC1QSq5USUVvhNMAMCd3XvmInCN5DrpIf387Up5KPlBQ6rUfT5CRQZxdHSTVIknwckwrDDtvFgGUIopiZAYgd9tWPvAAfRWyJP6NaicM1fE3o54k9W2EIIvm5O2rmxoDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Uu5/cWSbcC9L+bmV8kzgZVP+GtjiTYqHJjtlJQol1A=;
 b=CopOI6iDXvoCBiTz8CODr7M2HeVWhI/cHmCOCdOjjgyw5jh5v+37ozEQ0kXcYfsZaamSPGbDyF6KJsiRavoLWKTQ2gDjXH6teSWI/QpvJ9YPCITlCHBQa84bQLSLY0u271Do0j8lZ/eBj/Z+o0gXFTUcJWiAgsFQzN6CDsawI0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4805.eurprd04.prod.outlook.com (2603:10a6:20b:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 14:38:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:38:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: dsa: tag_8021q: remove old comment regarding dsa_8021q_netdev_ops
Date:   Thu, 18 Aug 2022 17:38:08 +0300
Message-Id: <20220818143808.2808393-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4cfcd4-ba87-4d6d-e22a-08da81274abc
X-MS-TrafficTypeDiagnostic: AM6PR04MB4805:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLE3u/YOnvPixoZLApep/rkRiEPqSmyeUSxymeW+ItEllVcwzgCH4sSqFtCp0CXXHayt1jBpbJlQ7ZoUGwZyF31+e9o8qQ6sYjfreKPawy0Hpmdh9/yI3mw9cTP/s83XDkB3cdYpKHJIhCoDAS2b1U1FuoR8eG5hjYzxWR4PrcpablQRpKaGgURqRooqo0Mt4mg0KuZ8i0DUd1FPL9iCeztR2ysLp4JDQfhDvU20uiIOVIdLn40P/Cs+WBbFZ41MM3BY1U4woMSYUR2mL8VT0twFntwR6K1diLFAdVOTgmHmwIclOeh2PNd+wdXbViBSqCwPVcnKdU4Qsn/9s73awpJQLMzbUkqe1KpYKZGq0Fdmly+g5Mi0TW8+6JSBFpNJKUUd9Ado4Wa88uZ9m8Dsb0w2w3qwHERhWeWEgVQLjGG6VOrqd0O5oF0B1XWcxsto+GzflJUaiqKuRLv+bIhuRULePxpJ8zTnBRhK+02ithKsUXGEEuaqMAF2obHXC0t3v9o0E60tb0wVT0xwpOXF4Y0Z9U541rpJ/msvWEclLTQ5fwPkwgLMZKEUe9e2jSPdq9IZ8lK/YviLIWiEDm0r/tsUx6uc1NkyBgJbbXVU1wlhDf/I94Kpf+fKBnSqMjpAmisK2hFJ3aKosaep+08eRMfG72CQl8t0Y8uQwBFS9r/b7z2Ed5e8dXeRkHcbBRMHUblyWrLP2kXwwD2YBamveqv6NrOwZVL9KKxXk/9+fqFG44wffdUp5HhY00CWyv/A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(54906003)(38100700002)(41300700001)(1076003)(2616005)(186003)(478600001)(6486002)(38350700002)(6916009)(316002)(26005)(86362001)(6666004)(83380400001)(66556008)(6506007)(8936002)(6512007)(4326008)(52116002)(2906002)(44832011)(66946007)(8676002)(5660300002)(4744005)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4kYd68U1vDGFKoaeDIAadXO7lQk6aAVytkphcKF5XTlKuSSXyQTaVJIv3WW?=
 =?us-ascii?Q?tijeoopTQHV/QOFZl03aupdNZQQgObGuXmjvlIN1s5egzXZTfgU3qAWNLheN?=
 =?us-ascii?Q?LY8BvVIVvJR7fZK2dC+Hbn75h0j/Y0laUV0E8o8kwes6ccpnWA6jQCJ6Q0MH?=
 =?us-ascii?Q?asE8RtOAFvHm7M/RsdoulRn4l0YvoPkH167vTlBI+69Gj09RgAZpZQE9sGqR?=
 =?us-ascii?Q?DqEVlK286sKSDP3SOQxL/8MYLuPLtdUQXbDK/RixPyrjXpAlqub8oQtL0vTh?=
 =?us-ascii?Q?QrXCjONlvGtTs39rYrvAmzgNxmZEQylwXYJhdt4A5H7C39W+vdkBeXd7Pvly?=
 =?us-ascii?Q?VftUIPTZmEaa3RVyIr1hneQpV2Ysy+jZEevMSO9T1hVNNuxv8kwra7gXjb4q?=
 =?us-ascii?Q?sOX/1y6LdWjfirI/lydgmU1LNTyfBa9LQ/zmSaRAG8fmPOceThY/N+pCqPN8?=
 =?us-ascii?Q?s1qvhcqGiHmfq5ftd+8oYavPXV7Qu35Juo/wbV7qOwLoF2Dip4gMJOh7rkqu?=
 =?us-ascii?Q?5X68mIkrLY4rU1v6O3pkagx1JFSc4m6xOjpmLQpIYXHumq0GQEeo15uMiKMM?=
 =?us-ascii?Q?rd7ocRkpuJsZslChp6tLdd0JWjY+NA6au5OAblCDKs/rx/O3eYdv+7DVTX7u?=
 =?us-ascii?Q?g1SESz3yjC19pEQW/6n01KsRUowgffGz5KghxxBSqgCkzQ6LHHk/UiIWJ/X4?=
 =?us-ascii?Q?UdPCBxcTgrBBUQylVjZ1fmjbvzqeLypiJIBfrQ22NWFpNaiwu1QDkcEjijcb?=
 =?us-ascii?Q?EE2yuZKSmAKXdABauxTMUXQbq5U6p+GfI1WArlUHaE/2ssF1souH614qxypA?=
 =?us-ascii?Q?LPT0UPkOoyohDG09Anm+yki7J2aZz4H9R/f9HqC8HTKOn6JtnPusjJPhAhWx?=
 =?us-ascii?Q?ZU/F1yf6pJAG1Z2SZkDCCQnTtuXgJlLsiMPVS6dYIfT8cyzGIms+vbA6osVo?=
 =?us-ascii?Q?CMJUz4FaZxQpbWrD65gG+YGyXT34uOY2hwhOjMLKKmIHKCT9M/X1KStrMBp3?=
 =?us-ascii?Q?ecyatgAfUC+LSScuoRQqsYgRv2GCPrFvOW3rb8A6xVrJeEis9s8vaWhd0k6Y?=
 =?us-ascii?Q?JDGvzKSouxWZdPZxNJnYU0OJd/H3JRCrdMzyhqZ1nY8tH7q8V/YuqXVOzw1V?=
 =?us-ascii?Q?muJEoXhMhn+LxbINUcm8NHHOJh3DG0cCfu6yG/cUNvi7hG7Rm8P2Q4ibvXAY?=
 =?us-ascii?Q?N2NEnJgw1EGxF6rkyfTjEqZVFF4Z/yvqUnPNr1cFq0HCn9wKmQbbldpEpNqS?=
 =?us-ascii?Q?PXFtl2KFQfiKnZO0UDK7kuk6DQeoruVIo5jiUNsORrc5iOyqn+sT9jIZxR++?=
 =?us-ascii?Q?c7gm4we4l8Of4Nw5nQFxxMrdvYnYSTkBmA02fvpbtxowNXMzU8PnGrjDfwRs?=
 =?us-ascii?Q?waIKb5Cw5nIvV5B9ltFX6AgVJHvJd0kPjjrNokg9NF/WxBXIWmQpGRKKLmhk?=
 =?us-ascii?Q?WcdD3EDXi9YqIvvRJw0LBtxvQvPQcZ0BrQhTq9o9whDvbHdOmzQuMq2GHmQr?=
 =?us-ascii?Q?XgrF9l1MtA/luJbJBX3eCoIBIaaCdvDScpdlAoajNhtCYEBYj2aFqjAwhOiI?=
 =?us-ascii?Q?PuemhEpF+IwBssZPQtc8k92g7VrKGVAlgpVO+yCUJx+MN2Gv4+9KyZThmVMO?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4cfcd4-ba87-4d6d-e22a-08da81274abc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:38:18.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5a0yy9RW/VguPqeI+Dop4+468ct+rsQAA0IqvTiQfWC5ROtJam+jti5MUZcqBEXwoZQ2k7yN+EaFLtPayfjcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4805
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 129bd7ca8ac0 ("net: dsa: Prevent usage of NET_DSA_TAG_8021Q
as tagging protocol"), dsa_8021q_netdev_ops no longer exists, so remove
the comment that talks about it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b91c2894b6fd..34e5ec5d3e23 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -2,9 +2,7 @@
 /* Copyright (c) 2019, Vladimir Oltean <olteanv@gmail.com>
  *
  * This module is not a complete tagger implementation. It only provides
- * primitives for taggers that rely on 802.1Q VLAN tags to use. The
- * dsa_8021q_netdev_ops is registered for API compliance and not used
- * directly by callers.
+ * primitives for taggers that rely on 802.1Q VLAN tags to use.
  */
 #include <linux/if_vlan.h>
 #include <linux/dsa/8021q.h>
-- 
2.34.1

