Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3057588B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 02:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbiGOAMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 20:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiGOAMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 20:12:49 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00139.outbound.protection.outlook.com [40.107.0.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C14571703;
        Thu, 14 Jul 2022 17:12:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/oWiLg+2eAuywEP39inSDkBXyJfE3rJ+7XFzxByk+f/M3+ZaXKdIOdTS4pJJ8M9KedNQv/jChSZ5HT05yDoHZ86uy9fvZ0otUeqmwX0xlEdTLbd97skjodOpPbkBIzkRXK02CTje3Vhr9K5zkLyQQN4+CLh4Xkwv2n7T5P4OfYqNTIEFp7nbUY3BpJDUpWTnU6asj1o+9zZLoB2IRy/6M3g9yvljFEGbqym00KmtEGjGRqxH961vWQElXp2yyJ2mLhPbKYVOWoqL76tuGDR9zuJNaXBWpJPKQHnlboKOOxwrVQZaGmgaQR+HMoT4kPRadlS48hQbuSBqQyPXnFkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XgRV4uZ7BuVfr4/TyEyt6y2r4XtKemE4kzcvRVv3LY=;
 b=J4YiBq8vi6q0T+yJVhOEAni+equACofSO0Q/SLKjL4gHv/z90wQb7fjPlKZDgYHAlH+CymKvSkCnT96X5mfoZIbIEFncnYaytm77+0IjkfjYqT8M9VmHW5jEjVbzTwfzn8zrrnfd22HAtNe4lEuNqGLFZ0/qnQs5T/kSj4/bo9C6TPkmrFCStEkN+t+EaBbjpEk+VQWig2HJ9xZ2Xb6BDpVayYUbMrBZXkB1w/WH807GMymNZqXz1M0SOfy6X96F5gNcVlSSruLs3D7fOV1qLUTr5mpQyEJ7Ry7/5pTm4fXTJJBQbAau/JxxG3deyaykGp/Cr7l0iZm4pheRv0QPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ml-pa.com; dmarc=pass action=none header.from=ml-pa.com;
 dkim=pass header.d=ml-pa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MLPAConsultingGmbH.onmicrosoft.com;
 s=selector2-MLPAConsultingGmbH-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XgRV4uZ7BuVfr4/TyEyt6y2r4XtKemE4kzcvRVv3LY=;
 b=QB4898kow/5XcieOdHpY/nYQnctap5Q6GBRuxgR5OpckVKWaKD8Ft+HLu8eHIy662+GB05NRBzp2EsKRyCTtVROrJdFqxDHyxFBti5SllHpjMhiEJ8ZB1T00tXj+qTnifysdhs4A0OKeVadZbABpFfszzt9eCsi7LpSSqYUuZUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ml-pa.com;
Received: from PR3PR01MB7970.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:171::11) by AM7PR01MB7155.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:1b4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 00:12:44 +0000
Received: from PR3PR01MB7970.eurprd01.prod.exchangelabs.com
 ([fe80::bc5c:fd53:b754:5bb6]) by PR3PR01MB7970.eurprd01.prod.exchangelabs.com
 ([fe80::bc5c:fd53:b754:5bb6%7]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 00:12:44 +0000
Date:   Fri, 15 Jul 2022 02:12:42 +0200
From:   Benjamin Valentin <benjamin.valentin@ml-pa.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] ipv6/addrconf: allow to use SLAAC with prefixes < /64
Message-ID: <20220715021242.4abdade0@rechenknecht2k11>
Organization: ML!PA Consulting GmbH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::6) To PR3PR01MB7970.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:171::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ab78a9c-6868-451f-af12-08da65f6bd9e
X-MS-TrafficTypeDiagnostic: AM7PR01MB7155:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jk3OHxNNhjh+8pHyqaNvSP4MjkrhjJBXtWojsAB2w77sWnlXbxfO/tRtqdFfhNPfHLHqkQDP2IUpBUWS4S1WRBclMTrPJkZrHv+SNday0wx0qIZ34E8M/HcBbvHo4WCMWedhOwNJuOK4HhK6UGTUWKqKg0Zjkik6H41mG8bvtrPPIXlKkpBCZ66yq2cjKROFvB5nNfonOIqJtcl00JPldGv+kg7ndzyQh3z6pZUeSbUO8ncu/qkpQ3LwEAYtJznSxPjYaRbTn+IPp9SNT97jy/pFW+/g2/zMeNskDBPH4QTsqpiAuhj7kRrdNSy1n6bGgwCRhXlMkBYsFL3rWgTqLdyTvuQnFlZdRl7KMiss6Ds/nmH64OKRbAjoJmb7WE7ihrkN4Z4D9ONeMlP2CoxFxUwcy5ZGq+P6S36UuiKEU4G/hB6NKd8CTm2i7T8JrAKiCjnACiIL4yJ7OvtuTWSW0Jss1VRv21nIY1zlcnnwq8sO+jnqBidJ8keCL4meOris6lVSgYfN9jWxzhSJcVZFEehzqZCbvBU0TUlrwRjn1UXXhPjgL6x/aKZiHTUORJnIdCcSTJSFpDTFTJ3tsMu9kuz/Vot7iiBc1UhXZHWrSkzELumkRzLQDFO+KEHsN666XbRZxr+8g/ajLWiBPR2FhAAWQbuSxzpNCjiwaEMx9ZSGzhRrJ45QG45loW4dypE2BAiY1JxZR0V6WjiLNdQGLNPTbzubJ2pte/JUbZtaUWbRVWYXUo1KFCBV9dZryO++9YN4CgOMo4LGBJbDIgHQ/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR01MB7970.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(136003)(366004)(346002)(39830400003)(396003)(6486002)(66946007)(66556008)(54906003)(8676002)(966005)(316002)(66476007)(478600001)(6916009)(4326008)(38100700002)(1076003)(186003)(86362001)(83380400001)(9686003)(36916002)(6512007)(41300700001)(52116002)(6506007)(44832011)(8936002)(2906002)(5660300002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIhBiZPlP95cAGlMeX58Jx1dz9a4SnbTO8SA5XKnmyBMqKkWfRUi9QUe2uaV?=
 =?us-ascii?Q?aDC2pk7Ld2T7F5G5Rh+orxZ4hxRkWzlJAIV6EnKGR/98Bo96AsNk62qR50HY?=
 =?us-ascii?Q?xSD5nZel6lCUnSwFOilLhsHSqcIllWLqDwpPbUNVyiwT3zrU3ZlUq7eMcJ+Y?=
 =?us-ascii?Q?d2nFP5ImEYRXa5ZTQjfj6tybrnrNVD1VbQQz4UT0tcuATgbFMaOU/y5lahv6?=
 =?us-ascii?Q?a0yGjXCSK4H9nLL7xqdSqFYGICcxVrk3DBR9kT8h/hXhxCSgThshAcXDBmsZ?=
 =?us-ascii?Q?efs5xvKRsE7997uWFQsoPZwzi4oUyNjdzxGS3Redqcwaocvox0xH7/hBHlGI?=
 =?us-ascii?Q?hbEmWWzv8g6o0jRNhwdw0hY2IMoYum7WqGP8JhihdKMksk8LXB3rkQ1FKcaj?=
 =?us-ascii?Q?P/gxl+pyquUuUdHzR6SRK7LpuVbZqPCFcDuRY25nzKmBIAKX0VsvJpmIGeX4?=
 =?us-ascii?Q?PdPoUkc8WD29SidQ4ZkMpSrJxz301dlUhiDVYf4o44vXYHKcQkaYmJz9mUMc?=
 =?us-ascii?Q?XsNJIODEZNwzYusJ/qpPXz2Li59YANBvKSEzOsp6Yr6tAjMJ5YSFxP67VRq2?=
 =?us-ascii?Q?VQIRx23WnVQ8ZyVhJ1uDO46Ic7PIg5Vg26NgzWTVyw4MpNiUEw9f7NgQaiO8?=
 =?us-ascii?Q?lNOt78cRZ4nMrW3PvbwmOUAQ+TebKa8/rB7KbX90eUbmy+rTIMp9zxJqkWCT?=
 =?us-ascii?Q?QBreKBQ9zhhnFCJ4SlsQEkVakfp2hI3U7vtLht2Bf8AETO84s5HJf/GNoHnQ?=
 =?us-ascii?Q?RzgCrRKD4OtU7USObVzeQajHAeY/SGt4PInr3szgrrAUoR98SBRz74jBQuz+?=
 =?us-ascii?Q?UPtpwK7GbvV3fOYQvDRXjZLFbH6ApDiFG7jOBn+J7WIN4BEVF+y91JxDPce0?=
 =?us-ascii?Q?OwVDK5xONSUXRPIjmMBJ4mvbZi0qTQ/UcL8gMzmOQj3kc3JGvT/ZQnmwIPY8?=
 =?us-ascii?Q?RI/4Z8EJ5IwR81FhMye57dMLNyg2p9USr5EC/pL5dbYQIhBBNbqOF5IvwBwp?=
 =?us-ascii?Q?uzQ1qAbKdFFOCVwNWSlnJGop8l2S4JQe5semHY2yf/m7xkgpEpjFkXMKw0EZ?=
 =?us-ascii?Q?xqkrVUUUmCCg4tgYP+L3oUaSZLxotJEtsTLo0w2o+IlFjPkDcHQYHFr7Pntk?=
 =?us-ascii?Q?+bOZoDpMxGVmMn2v9Jj7OQhGft+bYXOyavsNf8rMbWQM2olZLK944zlNl21T?=
 =?us-ascii?Q?bgKcjwkiH7eo5KzolRwRKw4Z+GGIm+HElz3dDLm6UNxw+zOvoQAyIbSwlV7p?=
 =?us-ascii?Q?eKDMKIByevF1AWPKisEU1YnpjxvT6srPRdTHTRR3UC07CItixxNKV7l5amCa?=
 =?us-ascii?Q?ohb08qglxQdB+JiUtl5J4smyTzyjA+7HAqh27pB+Hm1o+H8CqULKZqu/skPz?=
 =?us-ascii?Q?J5m29sOyQeGUx+6xWgmPr8aQiOuO2T+Ao5NnAV5QIYBB75ClefJFGSuO0tP4?=
 =?us-ascii?Q?5Ol1RJHHhi6UfoHErRvWfWDboXZX/q+rS16LHav8SCf//tcPU3SNcseomyOu?=
 =?us-ascii?Q?JwJ4Z1+VyCAl2r4dsDfkXflgKsTlowJc5LT4hyErWDTWbWyhvdsAVcnoiYj8?=
 =?us-ascii?Q?pAK6SOTQxziPLiyDr7ppTGV9nLRYkUUb7nmjwjaUNmhPhqYexOnf9CMriD/Z?=
 =?us-ascii?Q?wv4WRg9V4XqfxxVLrUuaNMnattZVWL9gi+6RZOYEV7MvE1i/HrPq9p3E3Pd2?=
 =?us-ascii?Q?6+rrsg=3D=3D?=
X-OriginatorOrg: ml-pa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab78a9c-6868-451f-af12-08da65f6bd9e
X-MS-Exchange-CrossTenant-AuthSource: PR3PR01MB7970.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 00:12:44.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23090d33-f0df-44f5-9356-137a7bdfe69c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nqbkx2XRAeCSkpIu1F4TCYqBHyJEMRTXBYltn3Rpe7c5JZpYVnE6rDR3TkJ5z2gFlomL9QGmwfA4y+EnyPvhXqvBAlYgC2HRWUDjvkOmjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR01MB7155
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables SLAAC with prefixes smaller than /64.
SLAAC is performed as usual using only the lower 64 bit of the address
for the interface identifier.
The bits not used by the prefix are simply considered 0 (and must be
considered 0 as they will be set by downstream subnets).

The idea is to being able to advertise a larger subnet, that can then
be autonomously split in a hierarchical fashion by downstream routers. [0]

[0] https://github.com/RIOT-OS/RIOT/blob/master/sys/net/gnrc/routing/ipv6_auto_subnets/gnrc_ipv6_auto_subnets.c

Signed-off-by: Benjamin Valentin <benjamin.valentin@ml-pa.com>
---
 net/ipv6/addrconf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 49cc6587dd77..aacf01d8cdb6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2787,8 +2787,9 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 		struct in6_addr addr;
 		bool tokenized = false, dev_addr_generated = false;
 
-		if (pinfo->prefix_len == 64) {
-			memcpy(&addr, &pinfo->prefix, 8);
+		if (pinfo->prefix_len <= 64) {
+			memset(&addr, 0, 8);
+			memcpy(&addr, &pinfo->prefix, (pinfo->prefix_len + 7) / 8);
 
 			if (!ipv6_addr_any(&in6_dev->token)) {
 				read_lock_bh(&in6_dev->lock);
