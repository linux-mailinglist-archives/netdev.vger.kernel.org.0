Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20635231F1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiEKLjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiEKLjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:39:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6A92415D9
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFvaVusNnoqqc9xzF0ZnCPI3ksNCVnVOWVhE3HTOJx7kANdeG+t/iK2mnwdJSummnrmWUNPNKJUhTRR49YZerX2K/vH6ZuF1cn6WnaALHkKe2u1In2IZAuiST+y9ZCXTpCsB/9Bnv/M5Poe9WyEaJjwBaC/Ovr6VPwH1TqD2rFMAsRKFmyuni4bXKLYpYjcgxlHqsrdjRSRzuL3OYWOLCkDMiLl41sqpVpCz4/1JkSW9dkv8PjXfQZJRG9Gp79jSZfx6hrOj8KJtUbib8RpprKxwFJWCaXMrLoGVYfEpl6ezlDc1ffc4s0lfrxqNPpHUkF80g/oU1AICQvK4I6iMZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UD8JUBXtuOzT442mdVYvqQBcI0P85Hw7Wue1ZWqEB/E=;
 b=NMwjcljBz51Jceb0cG40U8YvqoAYG9nZFty+xCWLJ55Ka2dl0MWkkIitir/JyH1mqc/GLjofn9EwQQEWV4jrK6a9N+9kIIrc0Z6NfRvU603PMyDS3xjjYnQgjwwvRwsqk47y5gkaR0/PK7klEgNqBgCbNSDOjGIzlOlNWVIKVH6JBgKpbROKX3ijRM/GnCmdblu/N3s83IGX7HlOVlZDq1BjiYTi+ZojBgCQ/AxBZV7FiuVU4LC6OJ6SKC4L3M1ceCO1aeAyJZUoR/1AsBF4XYPgVytvmbYyLGtLVdkTumgRt2e+GuEEou0P2yIz6oT47tLcVMgTrjbwb/QElmrqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UD8JUBXtuOzT442mdVYvqQBcI0P85Hw7Wue1ZWqEB/E=;
 b=B0QLXM+YHMpE91/y6am25onCrlRWEr+m0DuRPuUG+J+YYoqP1HyuoN1QBc/L2q9SAokc2E3VIghvwu+xzp/9f8RMdDCMlcXH9lVNprOs8j8jAX3k6n9o2KMEHpEHu1+/+lpFvpg0XvxpRtv1oY0py5uOUAmH/e7JIofUba5oTAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB2972.namprd13.prod.outlook.com (2603:10b6:5:19a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Wed, 11 May
 2022 11:39:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5250.012; Wed, 11 May 2022
 11:39:46 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Bin Chen <bin.chen@corigine.com>
Subject: [PATCH v2 net-next 1/2] rtnetlink: verify rate parameters for calls to ndo_set_vf_rate
Date:   Wed, 11 May 2022 13:39:31 +0200
Message-Id: <20220511113932.92114-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220511113932.92114-1-simon.horman@corigine.com>
References: <20220511113932.92114-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1f89618-c9e6-4ff8-ad77-08da3342f2d2
X-MS-TrafficTypeDiagnostic: DM6PR13MB2972:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB2972E48055E48D8246F37E57E8C89@DM6PR13MB2972.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TJvui7Q8x8TwJ/bNs/OU44Nasse/WE45pYd2qk6oFNkIOvCOodL6U9INi5lygXr6+PAHVqhYq4viLk0cEYfzsdnqzJYwfByoC8GkaV5GgMBoY5BFKNdX5ZFxluiteuOrOC3k2qeEg740+zqM2vsoE2fBsD7YUP9jP0Iu8lHbUXYSLuLlt8LKaZ688Zweoe6dqi2m4ysqKbFyGYNh+jNwANCoUNJDaFuDYJ8PniXdCGgPLZMqv3F/0SGDpHl9DwwMfQ7+hDU2x11ngotORuNp2oOUisPbseEf6f8c5b7ELdDMKiTVuK4rKya4troVqVvngD7xrwhiN06pA/YnekkFAlGw8zgZck2QzTg9O9FjHsd4W1G1aMlBaCCJ0V/QGbs0bjxcSNMygskayIK+dC2iRBNueHB5UeozppzDw+v7noTjliykY+grrlPS+8KjObvsB+E6pBOFE4LQCL8fYVOsNoCA4KE4E3KeTTyqvPdvQrFd5tu5SVnhpk+OUnKW+0JOBhxMFKQ3/Md7eI3WxHmq1yEabIyh/sph++xUdX2MoX6t4/qd4N/tUrki+ombvnlyXeK/3xYqYgePnWNOxo8WuGu4k+PvpbYXRYc8RVLNCTPxC613ZKHvtQBT1+NN+0txMGeuuZXVXWSjAB/pLQ2tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(136003)(396003)(39840400004)(15650500001)(38100700002)(1076003)(508600001)(107886003)(6486002)(83380400001)(110136005)(316002)(186003)(8676002)(52116002)(6666004)(6506007)(36756003)(2906002)(6512007)(66556008)(66476007)(44832011)(66946007)(2616005)(5660300002)(86362001)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DMyJRQgy/D/ST0IhKsiKZHVHP3LhW72w7PD3L/XrVXW89slwCNE4c+FYWr7g?=
 =?us-ascii?Q?ujgR3Uzv8ax4Crt1Cq3vQb5QqAnFkiPYecriUhs1yqnCCjwBOaCSYKAeC0ar?=
 =?us-ascii?Q?VHff9gfclTwrNC59k2gSYXXas0k6jP8hSLoztfLR2rjWDzkW5o1mfhz4aZmf?=
 =?us-ascii?Q?0HQN1bSTaE7qPEt6imJv2bMWfhLPp1axiDD0aYvIVeM9lI4P38m2eP6WHv5V?=
 =?us-ascii?Q?9xiquOwN27NrqgqeNUTxX4VZVOR3dpifWTuoVZRfJu6Fn4odc1JUa9j9Q5hv?=
 =?us-ascii?Q?tfmwr2k2PWLVJ+qDcQwyyfI+O2O3n+SjLAswMZcI5Y8q3Z0eRZ/N3S8lWq2j?=
 =?us-ascii?Q?yuC0OV1bqi/4QHVwn9t07rQToIDwQYeaaGmU58+VMloyMYlFlMY+hFeXrshO?=
 =?us-ascii?Q?EonY6KiqWeHnMcGMDuVKEii7oogUivYGJFQHH84k9mGuleCaf4baiicC62V4?=
 =?us-ascii?Q?H/skoFOZAoIgHFdIj150XpY8dkGxNXHPDymMqxCg61bJ50FiHFFW+M9l0de8?=
 =?us-ascii?Q?wwwnTsGcIGIgAgqoo2Tvswh+q7sWY2okuPwgoOFppDNc5y0PzA2ibgzMBHhY?=
 =?us-ascii?Q?TMsIFNMlW62FPIThnQ8o86p9xay/FlRkksxts5OoP0UuHj70mkGO6uJ7ca/p?=
 =?us-ascii?Q?rTCLUmUdeBIiUWcVdRFBalVTJwsYaXPfmvwQA406eHGULD27YCAEnqkhaqAd?=
 =?us-ascii?Q?H7gjxG0oF9k3S/HxYx+oux3HjjDDfPrFdIGROfAyDdJaN0zT6dXK5pON4/IZ?=
 =?us-ascii?Q?QB75+xFmTI3g+nxF9M+OPKoy4o4dTuuQ8QhxQYI3pq/E/BsFIkiU07FGlU06?=
 =?us-ascii?Q?waC91ZsgrgF4IIFwAosYt/6JWHM77iVtXFLynLTfTCyaCSkpvy2ol+OohdDl?=
 =?us-ascii?Q?T4vs3MOTtVAQs1IN5URlm8Qb7mCyiIQe2sNMSeSdKY9qVsSZiiRiePRaC5lp?=
 =?us-ascii?Q?YtyLF6i6kjBZasl8xqCw9eUScLPmd1/ZLvxFMrN1oLfOF7cxFRHnS4ANbo2m?=
 =?us-ascii?Q?A7n+JswsdhF0UKiD6nxwksOaTF/h/kL3EtJz24u6vrWFGRbU30S63I7tPJp/?=
 =?us-ascii?Q?E4WwnkE5gGpVeVt9AgHB+OMoDwLABVj8E3R2mB6jnhWXqE3DPoBIh/Tbf/dr?=
 =?us-ascii?Q?q9KT2xvqdE7ze6PgeGPKzor0jtKn2mL5nyV0PlctHRPWDOte/Big29I4kf4+?=
 =?us-ascii?Q?XkdJSoP/sGmEyU5nxWzy+pv7fzqVd6iuuufmMczBjP+SLzsLD54vrTEiBkCc?=
 =?us-ascii?Q?2rJsemBf3LltL1Q/McZHOeYNp/qOan4i4ogHNpsjgfVvh5J2sKRBzYCc2apo?=
 =?us-ascii?Q?0DVjfThEtXwOrVWdpOPnoTE9gyCCc8lCGTWkGJYBx9gVAm165MWM73U3SLry?=
 =?us-ascii?Q?chkyB0LogLCGUaQwDBybvwUYmxo40fBmTIKbKw/XistPk4Eg54FQngSwa5XL?=
 =?us-ascii?Q?vEL29RRPZpUdgL9hjIPXbOczYLre+QFiF1A6kBuKaAQ6r2vrGAAumRl8qa4C?=
 =?us-ascii?Q?HXsGpVds1sMIB7hybNEuVUmjkMgK35880qI9QsWRbL34VW6EPCgYcufWxp1B?=
 =?us-ascii?Q?pCStMT+zXOW7R8oF05BBQfmcIIiDTz3BmOcDInCLYjsGM1U0Vv1afdaAe5Zn?=
 =?us-ascii?Q?Xj7MnqHhVMeInXSyKjvjDnW+Ly8QhUvtyeX52RUy8cdjPv4AWOhIuy5u0j1r?=
 =?us-ascii?Q?X8tKOmPJoMbYajIM5QvFtiJytF37E8fzTOoqBhJLs3EP7+JgoR2LRULuI8vR?=
 =?us-ascii?Q?wesTMM7IjMr/UbRqIF+0rSwgvpdHEYtSGTLRJJyianHy5gPuTW4xJKOl6fix?=
X-MS-Exchange-AntiSpam-MessageData-1: ZiyKlzIZYo4gYwQDGq54GFsecyRRq+0na74=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f89618-c9e6-4ff8-ad77-08da3342f2d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 11:39:46.3771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bj1NwwKCZWyOV5AbKOmFECRUh/Z5a8B8VSEoXCPyDZzEi5s7BLkoq84zeW2cvG2YwOw+LfqZtZzYP4am1//ioq8TIoKW0ksB1oN4KEuti6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bin Chen <bin.chen@corigine.com>

When calling ndo_set_vf_rate() the max_tx_rate parameter may be zero,
in which case the setting is cleared, or it must be greater or equal to
min_tx_rate.

Enforce this requirement on all calls to ndo_set_vf_rate via a wrapper
which also only calls ndo_set_vf_rate() if defined by the driver.

Based on work by Jakub Kicinski <kuba@kernel.org>

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/core/rtnetlink.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6aff02df9ba5..bdc891326102 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2306,6 +2306,19 @@ static int rtnl_ensure_unique_netns(struct nlattr *tb[],
 	return -EINVAL;
 }
 
+static	int rtnl_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate,
+			     int max_tx_rate)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_set_vf_rate)
+		return -EOPNOTSUPP;
+	if (max_tx_rate && max_tx_rate < min_tx_rate)
+		return -EINVAL;
+
+	return ops->ndo_set_vf_rate(dev, vf, min_tx_rate, max_tx_rate);
+}
+
 static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 			    struct netlink_ext_ack *extack)
 {
@@ -2443,11 +2456,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		if (err < 0)
 			return err;
 
-		err = -EOPNOTSUPP;
-		if (ops->ndo_set_vf_rate)
-			err = ops->ndo_set_vf_rate(dev, ivt->vf,
-						   ivf.min_tx_rate,
-						   ivt->rate);
+		err = rtnl_set_vf_rate(dev, ivt->vf,
+				       ivf.min_tx_rate, ivt->rate);
 		if (err < 0)
 			return err;
 	}
@@ -2457,11 +2467,9 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		if (ivt->vf >= INT_MAX)
 			return -EINVAL;
-		err = -EOPNOTSUPP;
-		if (ops->ndo_set_vf_rate)
-			err = ops->ndo_set_vf_rate(dev, ivt->vf,
-						   ivt->min_tx_rate,
-						   ivt->max_tx_rate);
+
+		err = rtnl_set_vf_rate(dev, ivt->vf,
+				       ivt->min_tx_rate, ivt->max_tx_rate);
 		if (err < 0)
 			return err;
 	}
-- 
2.30.2

