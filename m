Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9023BA3F7
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhGBScb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:32:31 -0400
Received: from mail-vi1eur05on2124.outbound.protection.outlook.com ([40.107.21.124]:46816
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230185AbhGBScW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:32:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiN8eNOt6VGnQkrOpx519V8RB4YpniVO4u8F5TsXE2NC/nd7Eo4kQxjZqpAaGZwe/SYv92mSMDpKoK+mqeJE0NF1k9QIiGKbEfd90UhgK1NGdlk216PcxfSjf40OnbApJAAcl/EyGSVdTzGlJhdcaAnK+kxynGHzWeypQ/1KbhxK9P9m5K/S7m8roN/JAp8IwK5IvkMNTpXzcgwMBT6g9xEwUkWIhA04Ck/PVzAHsSnLyr9CNBM/9eJQvDPPgNyWe5yrM4qY56AuGyedOJX6U+DsonJVgE12k+yy/aZYM0XBkVMqzV+Zv+jMo+puSQKvFYMNKv11i1fsxY6KpvNXjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kP9oM0zFva25BhuKewz9q/gaIkw9UA0YoJA7v8DZYo=;
 b=ibGAMwtwAnEfaYyvEMS07uvn7AubVDODrfmkQ47esjXrfBKmqngRgvEpoOPKfFPK5FKqsmNcuk8dlsICatekLPzcTWlskURxTmuwlAuc5Gcnp1kqD1SdLBogHU1R+IYJRdkXKsIRb8yid0RQslFsE0G671N9U+8Dx0PkuHbecli6APrz/LXMEo3A7VIkLpI/8VuyWVyUrQbm44r0L6b4m2zvoEtnN/MXnS+O/6ZsIo2XhUsjUAajnus3rhWVD96RZrFUNP2z2ToHQ9EW9zorZP1Ybnr3UKa+L6yOoLKVMjs9PJRj79IbK1S/USFOK9VHZ+0Lvshy30jXFP8aCDULBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kP9oM0zFva25BhuKewz9q/gaIkw9UA0YoJA7v8DZYo=;
 b=LYYb6oY/QoCMajGxDV7p828J8zAy5JOaIGf79033sDsdRNlA3YWF4O1LO+SASiV0+gpEYeA30q9V4RK0I77Kn2Yb4tMB/P6pBoRDPrAqpPGPuNLUSUNDgQP39MDHs6q0EACMoiHEqg+DB0xyNk0BAq2CjNH42sSogQWYEOd0++k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 18:29:47 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 18:29:47 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 3/4] net: sched: introduce __tc_classid_to_hwtc() helper
Date:   Fri,  2 Jul 2021 21:29:14 +0300
Message-Id: <20210702182915.1035-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702182915.1035-1-vadym.kochan@plvision.eu>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:20b:31e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 18:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58b7ca91-2354-4846-51ca-08d93d875ef4
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB039411CEDB7803EF7353E8B6951F9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t7bVH+SrmmUftatcVCQ6W+3SnhW6zMz7Lt4HXvLM8WXzk7Fe3sgug1BC7dRznk8XG0LoevZLpL4YV+Gdw02zq/k8RiiZoZoSi7f3blPnqsHEK4bUXWVngtJLdrd4O/O3IAZWSTelK7MjOVv+ljWVylvB5LlKv+Xy5+WYIxF8wjvZNFQEzI84Jqer3mAs8y2x9gZ8dEBek5I7bx843v2gDQoMWZSRAEoi+DtCCSc6ym9o+FrhiRe46V0BVQ7GiY/PhZBohyLFsmTa6Jcc6eeF0Z8LanVcAwmwboIxhPEBklBOFuD5jrUJFtXFUqbTUXay6+Xn4jyMvKnIxGFVXzWQNgrYObN8zM/p6YfIOBidQBkL2URrfeaZIsQGfaz9W5ZeaY6iI4/SDgeyyIwEffNeumKj4eJQEBJ2QHo0fMJ+roBLcU+NUQ6GKPTh+RKA867G9cMeBkJAGRsOXESz2e0hD/gqpwLFFmNdKccPf6hfUSeKV2MX2hRxt5DW1mF3Ru63lqsdkaBPoF0w0XA83g3+oRTm4zY7fzmJnhV4l+H3udlTtczx63njuF3Ql6d6qzUg3EpkbkyQcINgwhIjYVJY2+WqvGQ4E5uB9bJFyhfT6pcXBj8XUwv8rjtDWjmci6K7IgmXx3G68e62Qa1CmNTgPwJKtsRYT7fhKLsQvjdbWJIS09yvn+/GESfCRH63GFw+WV50DyeYp01W58j0HZPbVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6636002)(7416002)(2906002)(316002)(110136005)(54906003)(44832011)(2616005)(956004)(38350700002)(83380400001)(86362001)(6666004)(36756003)(38100700002)(66476007)(4326008)(1076003)(6506007)(8676002)(8936002)(5660300002)(52116002)(16526019)(66556008)(6486002)(26005)(478600001)(66946007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?57lsg2waCyZLmhlNs8xZIbON9U/j2/T4zo8/nvktpn1gj8foIlw396bKbO9C?=
 =?us-ascii?Q?TSnmx4CaonKlWKwt3QnvwsyTX2DMzGaQT9E8rB8/XuxWVQ6gbLU11C11yIBf?=
 =?us-ascii?Q?F1lPTAXiotr86xNCqXutwdZLkhCy//BnHEF1XPR/ZYkLUlmUWCEHHSqegpXx?=
 =?us-ascii?Q?Fyu8QptOPdYUi9i5HRtigNhOAH7+4JA3XInnQJVOc+LP94n+BR2tgQkZEpkw?=
 =?us-ascii?Q?tmTAc13dtkPjBsi1Do8/S/fBxGSUG4Q/OK1quie/Q0A529S2ZscBSQr/aq/P?=
 =?us-ascii?Q?8kuhDAnopCur1kiHndgrSD+gqA543+RBGCwdlSrHmqEG/Q+nwg9Nlo8oyt3s?=
 =?us-ascii?Q?neRlNOQ6WH/OC4MllONpcFPOxJXVjAO6zcCNSqLKE+WQPQsgDNoavAglY3Re?=
 =?us-ascii?Q?uGLayNFj32Cbj0ZEdEcf2uRqg1Ar1tn0jkbnxb5OIaLdgzkUNSygukA2qmKH?=
 =?us-ascii?Q?80Q7d0jrL/BY+HOgzdKdy2c4jRSqLdQSahAsLOyoxEg5WIoJm4X9taA6Qh/I?=
 =?us-ascii?Q?YlTOECL5GEqYhr34JNEIwj6S9hk+B/F/KbLtNsZvhrmXRVcwIZ2q250F0tW3?=
 =?us-ascii?Q?RfqL57IYIcLCGX8ooWIWRv/4Lj1b4ONghpgOn/EdpqhdBvpPrFBRQu8OCCHY?=
 =?us-ascii?Q?jyiSixVNBtXBTukz4a/K15U99e52VC9ah3jFHrsYLhKhSTWgqjjcVV6iBkCd?=
 =?us-ascii?Q?YSGq2GKvKcG2oyeHHfZMymS8TKX/kt/6Gtllub6tilRLUz1OS60YqiDKTTMg?=
 =?us-ascii?Q?CsqOfHOP50wycg5oEtvqMThXFxNbgJt/A3z5S69hRANqwlh/TnhocB3MDDgb?=
 =?us-ascii?Q?+gf85f0caNX8NOmAJ6Dhoiz4iHOD0nBlu6NVlXCji7TCxZAzE+MrvTaePmPR?=
 =?us-ascii?Q?TzYARgXiAJmfPURVrhNmzN+3U3MUGXnG0XK1dVoOea84psjvqqSQEwH/lRGu?=
 =?us-ascii?Q?WmpXSdf30H64wwuqyPdz6EMOOAbb8PNyQeHSj76qClAUsG2UawM3CLIayP1T?=
 =?us-ascii?Q?pFBX5s6WWaEp0ar/DPbSgAxEOVmrs1tMVPdhRcG+fzxRG+SbfG3ftwFD3hK1?=
 =?us-ascii?Q?MIV1W76hF758pQxP05jm+8bmBlM360QmdnMuDVBwFGjI8UBTMymLANjlS7ls?=
 =?us-ascii?Q?nTwIPMW0KCD6XJG7dCwJVSvUB4RbCbLTm159uEJ+Nx/HhnErIIpycTUibTcX?=
 =?us-ascii?Q?PJ8yGwgpq3aOu1Nt6HOJlWBdRb3GpyMfyIoRxOV8d5ROM+FEVKzB6/18Ry72?=
 =?us-ascii?Q?QxDO55C9HrLoSxV1UYtZ6yW55YI7yytCtud569GO1tcIyb1u0K6GA1++bgbH?=
 =?us-ascii?Q?cngZmywJjt2l2KU8EXc42bIl?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b7ca91-2354-4846-51ca-08d93d875ef4
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 18:29:47.4364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49LVlUR1BEKuXDPwBbjnh4H8V85wEcbTrX2fRRPnvnlt5AMg3Eb85hTuNqzTFiuwHAHeQsUaIsvKup2DKSYvkSOCqEy5aHdRqhonluNE+5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There might be a case when the ingress HW queues are globally shared in
ASIC and are not per port (netdev). So add a __tc_classid_to_hwtc()
version which accepts number of tc instead of netdev.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 include/net/sch_generic.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9ed33e6840bd..b6e65658b0d8 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -668,11 +668,16 @@ qdisc_class_find(const struct Qdisc_class_hash *hash, u32 id)
 	return NULL;
 }
 
-static inline int tc_classid_to_hwtc(struct net_device *dev, u32 classid)
+static inline int __tc_classid_to_hwtc(u32 tc_num, u32 classid)
 {
 	u32 hwtc = TC_H_MIN(classid) - TC_H_MIN_PRIORITY;
 
-	return (hwtc < netdev_get_num_tc(dev)) ? hwtc : -EINVAL;
+	return (hwtc < tc_num) ? hwtc : -EINVAL;
+}
+
+static inline int tc_classid_to_hwtc(struct net_device *dev, u32 classid)
+{
+	return __tc_classid_to_hwtc(netdev_get_num_tc(dev), classid);
 }
 
 int qdisc_class_hash_init(struct Qdisc_class_hash *);
-- 
2.17.1

