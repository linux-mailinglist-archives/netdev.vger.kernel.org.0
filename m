Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A805B29AE
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiIHWye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIHWxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:53:51 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05hn2223.outbound.protection.outlook.com [52.100.20.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A4A13B563;
        Thu,  8 Sep 2022 15:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blcM7Hwpkg6CxnbyCRdBDGzXxNAGHUQ2g1i+kDql4KKeVfpAXMm+tpm2oWsI0ADPGiAyb4i27GHQOmzQdizGzhfyMFUiOuOPp8y+s8E4kZ+ryOBkHhskDmEyRmt/6mBNdR8OlodHYsfJPtcOEf+jGR4LIMBJHPyG7X5eI12ixvKmQFWybUwlN4A6Nwaz+LkdvzjDg5wxX2CJrLNIGXJRELYPT9utuDdB35tvO8YXn14/hRzsREYidt4VsgDUBlgqcoXhNNvitTGbZ89jmyd9H/nGg4MAU9YLqNw8DKtWgUxgvh8/e+ht1KoB6S+Y+lCwUgbBl/B4RkeZmafMXMDorw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=F3ganFBMQ3dU6n5du4D9W/YnLFlTNj6ELHzddAJYqesjEjf79UjPE2VxBf8POu3u/A0iCnNqqGimxb6ko/6WXEDUqJHbTzZaocByXqFajoz9gEtoTRHRih1Wp5bCRxIdxtbnXQjqWfuP/UN1BXMpRZ3BCkOutljPQ+hVjTaY+P4dAk/QFCVeoFAaWRxszbfEtNl1qdY24KY/KGFLvonqNEx7rJ8wm2n3jG6I1i1djkoD9Hh9k7Bf3r97Vdyr7Jth4rUInwu4sC0lGpMd8H1Mc7bqhNazyQrjsgp3E8/xTV21Iqd3QS/1T+an//S7dyQ1EFmQIF/TdIYe5Ss8tpfpow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=hSLpF/dhlsydY3OsGFKX7id6Fn51QdiEOx5Wl9sAODepaCL8zGhXaofwUhFopq2L1bP7neGX5WYpVS4hfcvwonMCNmGeMqe5WxvyJsshuEEfCd64ACGyneQ5G3dwtzJga9bueXqH42MBnrCf2F1Cuffn8fdkO5GpPHd1fuERO5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 22:53:36 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::e8ee:18d2:8c59:8ae%9]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 22:53:36 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v5 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Fri,  9 Sep 2022 01:52:07 +0300
Message-Id: <20220908225211.31482-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
References: <20220908225211.31482-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::19) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ff2d4c6-5f5e-4a8b-5c47-08da91ecf6b8
X-MS-TrafficTypeDiagnostic: AM0P190MB0737:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(346002)(34036004)(366004)(39830400003)(396003)(136003)(376002)(38100700002)(41320700001)(86362001)(38350700002)(66476007)(508600001)(66556008)(4326008)(8936002)(107886003)(5660300002)(6666004)(41300700001)(8676002)(66946007)(26005)(54906003)(6486002)(6916009)(316002)(66574015)(2616005)(186003)(1076003)(52116002)(2906002)(6512007)(7416002)(6506007)(44832011)(36756003)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RHfVTSaKnqEZ59lmzxEGncE/3qGmb0w4BvN9otPsuiNWoGjih9lV4fo3UnJ1?=
 =?us-ascii?Q?93xFdt97mSPIHn29wL3KewD2MiABAZ8dW3x3Vz694/yi/0u0znsA1Ft4NXXb?=
 =?us-ascii?Q?wLhQC9dzbaOfNWkxtVm9k4Ad3a4EIVoG0LV/j18LrERjgYyhSXY1jvwF0HTu?=
 =?us-ascii?Q?Zz5l5e4arp2bEwCsHlS23l8g24fb/py2cVqnQindGraXaggrTw+HgPQ3XQhR?=
 =?us-ascii?Q?z92QJTwKvLoP7g6UdI6f/8tbkzXRKQxMMrMUghMK3cNSMfjCkkiaSFI42TUR?=
 =?us-ascii?Q?jPCCHjY4Y0g+7/J5UoaaSAy2Kj8kVOScy5BwekxfEFjnYngoa/uQ6T+j/4h3?=
 =?us-ascii?Q?vREBkRZ/o0ozUkV0vmTrGP92SUix2GeAra1UlK9hEfbsbUUuko87rtoMCWxU?=
 =?us-ascii?Q?ybuVpXVd/I6+WYXYqtvDIQTnqjfRd2ShTv+t0GfXcs/bejL5Iy0znewTt4wI?=
 =?us-ascii?Q?bFEyKj8ODyCmRY2Oesh/tWKAx/vrl147HrcGcz8rOgXJv75s2olGjcgWwS36?=
 =?us-ascii?Q?ymqcbpNZV8lUrPEUrnvfAAtPyEbzgSnF0wrcMN9lyWI8pIXsOMRnlyJeKvY8?=
 =?us-ascii?Q?LCGbQ4PR93AM+FpEeMePtJNx3YtpJDdeN2idB+bSVb458OTNccrEAMLBnczu?=
 =?us-ascii?Q?GucB+eDsJB3QYaqJpAMLSDPlNtP/4lddcUHI7vxgBcSbGiw4qjjCIHpm+cXI?=
 =?us-ascii?Q?MsoVoJf2OBv83IsFbxLj8IOqMormuB5tEE/0gAetkNUX5HZ2UnzdLsB0uq7L?=
 =?us-ascii?Q?vzTeKi5AxDSER4LWZCAqf5/O4S7k9K7/9OeH5BwugQLBdSRl3gixn6IPcpLz?=
 =?us-ascii?Q?EdgxXOJDerdrWE7OU1yJ6VPEk78PPO6lwtsc/LNbRS4Z9/PROaTMZlV8zOGT?=
 =?us-ascii?Q?LoLYghnGSI1Ns8xVab6PsGtI2HKv/cUwtb8rgO3IbtcsfwNwnotTFl2xTngo?=
 =?us-ascii?Q?r+s5TfU0R3wNCLxoazgaJ5dkjKsMRKMq8UW6clj2mKzHPQ7xH3a7R/LpOo/T?=
 =?us-ascii?Q?FAS5QMMzWQe91wg7v/sy/hSMwB+5lO0YTE2JLRu7IhqRJapNIbbNq+iw/7sv?=
 =?us-ascii?Q?3F581H+O4s31ucvUneWYd2PKHO6lvR3epHuocaWtUJTWaVYMIRpl54ij0bBO?=
 =?us-ascii?Q?sAkuG+7HmDBhJM5hIJYAQmfY5rCkEwvGT897oWXYR/ZoKJn8PcoylZI=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9jfDXN6IBZ5OOj0NbDeGjfBz8FRUR1//MAg67N8fcapWrnwqKgy0rAcklrXY?=
 =?us-ascii?Q?FtBgo9w/mDjwFnTKRQCoExVLAc5YK+BWBSC0I/TznSascrIdqLpqbvGP3FiI?=
 =?us-ascii?Q?R6hVxVg5LJCzIPCYNag+cc/LyD1SCUeJ8NUSu4rNUXpGGLhscP9QxWPm8NJK?=
 =?us-ascii?Q?vHiozG2gBbpsNBOU/mdf7X5/Z4o+1ATt2mHtcDs0RbsmdMz66xIi/LRs26Pl?=
 =?us-ascii?Q?qVPIViDer9QLCzyH/b+CSM+Y/FzPI1qAKAk0/ySNLbeCf7PUGnox/bmbkV0A?=
 =?us-ascii?Q?N+T0FI05CqnGranXMf0m6dGkORlT1ZWymlF/MdjZfqQlpiRnglOf7u3YEpET?=
 =?us-ascii?Q?CMfmjrnOtpinPldg9fmaYv5XKFFZVgM7j/KL5lrYB/vqgK7zr6E8NQ2bbcx0?=
 =?us-ascii?Q?0INsI5LCr5GhHuNSaFoQn3LGp0iK8eVEetZHzEI5mNbLssTkJeK+7EGb1TtM?=
 =?us-ascii?Q?FoW7S8EOH35zQLeQD44oo/601oMLIjhvJ2Vsd2D89GShV/x4yDDfVj85Kq/K?=
 =?us-ascii?Q?kBY5nFbL1nGwQH9TLBpVR2zPnwWdMk7QIKRZHAujsdmLzlPDWyLq3IJfB2Pa?=
 =?us-ascii?Q?IklARec1R8FnkR21Hic3Te+9UgEi9y/me1qd9hieJH2RzSiZORFvoObbGvGJ?=
 =?us-ascii?Q?k7XjAxu/Q0x5r+9FObtt50d5Xoq12D+faFORi2UK7EwAmuZb1RxX7ke1aqab?=
 =?us-ascii?Q?xnqs28ESQZJ7YxvjVb52QkVsubJpQWqM8y3fTlIwvfivlxZ0RKZ0ji06t7lD?=
 =?us-ascii?Q?o43BLkUe3ugdj+rVz5PMamIMO1ZCIwPrbBYJmkLR6noKIbsHP/HqORfPc9zI?=
 =?us-ascii?Q?gGBFN7GZ4tR2lP5DrVncNB6FQyxBH3rBZoB+xZIqZXhVRmqXzbNPJ+fo0DrI?=
 =?us-ascii?Q?Te+viiJexZKYU2W37IsOvNkdiXaJIz6OUONdpNE1h/T4YHLy7p5iem7+sn/s?=
 =?us-ascii?Q?Y5qBsCV8g+W1MuvFcYkN4DtLGTvCPSTCH/TsOy7RVgYDpQsChGAgMOrGuZNs?=
 =?us-ascii?Q?sasNDuaVGbPfUnipRvP5Vj8NdGORThAUC1lE2Nkm4LcDkjX4yhfrkpuCNHNo?=
 =?us-ascii?Q?UmIvPuqMakr4+d8uwVWFaN7ImFS+3o8nDnNVvz1PJDw22HZF1Z2aYoWRl8Xx?=
 =?us-ascii?Q?hcyoIHGjDHlcimSUnmXpTo6qgX7p9/hkeN3O7RZztSVvlrlMrK6UVEc9DRBB?=
 =?us-ascii?Q?9GttAv1j277v4UY+sPjOkNsbvz8pjUGpPeyhlpBxmGSKGMF+SwdHvQ38UIvS?=
 =?us-ascii?Q?e34HyJAJuAI/nymg42iI5E72sK7R1G+hh6AaPo22xDkPxtY/x2ZolrAP3daB?=
 =?us-ascii?Q?nHmVSkWbBSskmYr4Y/3F2d9mBGtwW5/4RI/TzKAK8bT9kKtUCUFEvLu88AZl?=
 =?us-ascii?Q?QObDVzgr1Krq1VM6R+XZhfiKVmucxoPehi+9hde7q/k64+Syi40kCt87fycd?=
 =?us-ascii?Q?lOKvXPrRvpKBfWb+4TuPFBoGPS2M+JA8azf2EzaBqzrKcsXbsWiPbhhTEh3p?=
 =?us-ascii?Q?lKZ9Z1ost5FItCQxHpeMok6eNBrWa26JEFSbdLDol8g+iyzH0kIA4y0n9yy6?=
 =?us-ascii?Q?AOa5UPeAI5Nu2++aOALx/FRy0p0r32obEOXYFwZMsS95DStsjR+JIMP5jv9S?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff2d4c6-5f5e-4a8b-5c47-08da91ecf6b8
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 22:53:36.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKNxjIFdUENHl3cWoujDIoT9zb3iUUXx7eeJiLCawM3VDE+MgV1wOz3OHodu52dRSXynSjcLJxUqnMOzA8sxJWojU8OVpSAIelfdNROZL/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
X-Spam-Status: No, score=-0.0 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

