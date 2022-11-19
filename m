Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270386311E3
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiKSXOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiKSXO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:14:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88B13F56;
        Sat, 19 Nov 2022 15:14:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlZoeh0nLVzLzHNNSS3jrXYlJq0ye6drWv8IRRpeD/p1Qz+9nXdZNP5cC8zvzTnHLi++s5AEPM59PJX3ODep8DZZ3MR668VixGpOISFhEY7dPb6b6uRKK7udNag76WUQv5Bao9tVxvRVO6TOobxbMB/YApPmTppcf8TwdCq0QydYQhHi6wFAif3v3/V3OP4xUf7Nclb5LvBGr2bLyWOBqAUqeSEoUj8eel/Sc1iCTSB6mu7m//XJi21a92UJaHPG5wjorz8gIoEV5CSn/hi2SvIZaXgEKPnN2oT0AZCeSGw13r9r3EPwTnaAI1TPCQYfF1lT3vLe+oFGu3mJd2ZK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiXrLhsLyI2h7bBaPOAPCGnIHQNohOLEl8vvZ2jUiSU=;
 b=f8ajG9P1JxSZO+/ZRBWYKOQobRN2xllpX8aMZExcts2jG/o6cq1UXMzC+4bkGt2kWpNXnJrH80jS5xPCVbT3XVOfZLMWeiXXmSBHSBryrxUe5ZWgnP/J58zDv7aFLHdLPz39yYmzIWTA3SxBolX2WNStfX6fmpoEI6KoqcbkePkhAx3FLKCBCcbvmitc65Q5JjKDqcNUd6jwYbG49gJadIPEhX5DodZ7hzT3prJ4vCbmKjmbKOPDbZ5sB+sZcsRNWZsyRSH3jxOJP7TlwiTArd20nnvDRiqbja7kh7mLPwB7DdTkTLLr5qLxTKzkti/djtE5dw+k3vdAsczCOeEVTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiXrLhsLyI2h7bBaPOAPCGnIHQNohOLEl8vvZ2jUiSU=;
 b=paKkZg7QZr5S2KE0T3f7jUqUQ1Wp/xLawVSbisQIHAZ6rRFD8D5BU5a54SGw5Qo3HLtqMtUPtC8aKzV4pSi1sFNhJi1VNNsPew6qHKeIsf4FBZCXi50iXbMjLBdQ7pBLGac7rKnV9jETj2uRIoqdZFNSW7SO/0KH80z91tU7li8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4293.namprd10.prod.outlook.com
 (2603:10b6:610:7f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sat, 19 Nov
 2022 23:14:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 23:14:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/3] cleanup ocelot_stats exposure
Date:   Sat, 19 Nov 2022 15:14:03 -0800
Message-Id: <20221119231406.3167852-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: 05cdc468-90d0-41ea-e40e-08daca83cb3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9fnmg9YzQJP9MD4P5ZldZQqP1/OXYT5+Y318bgRXkLPDGR2BNlwCXR1ibCCFQVUVv5/jFqUedRq6lk70UrYWxhK+BjgbqxDGQs7r0Q8E+My9g1unSiX2XLJbLWIeDunN9GUaJOG+SzynMPPTcOnHNBqxVYkWjlVpF4uEOzX+K+9ZzihGb8UPwIv50/UaGvbU11LT/5GRmdmqxc1bWbborOiA2CYOo7qUf87Z3T2/qZtLVceZCYxFyRvBKdmf+/5OLmPJ03rbZdd5u7IQJACtx94DIrqdi2/irfkMfS2mCTXGkNV9x1Lw19x08wfiIUFILKwwF1pIk1W50ZBnmg/pARyJNBzXFjsnI4jCkBi9EZ4zMq/6y/m7M+GRKyS5+QpOqqxcwU4Fc4zOE9gL75AH8KrRggH+ab21ieZgNqsveRRGeR5fwjTtxZuoAEi5DRSoz4iTEtghf9bAr+aAMm8sCzrAhWwcQG8FDmO0jkaXui8yMDsO+qu9fu/5RctTeGRms2UdKLO2KxDRims2ANXgGpkFgJBkq+uh/7ajlrt0pZ070TWOieC1rHNAo4SxNtv68sDnkYkWq6aiy8Kg5HALhaNGsp/5BqxtbEVXsUioQKy5qPwbgONZJTmK0GBY9vs10HfJuJo0QXvnRqQqb7SjrJVnagLT8jLiNrt/aN5mnTLmdKjOha+5sv8gcTzZlkc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39830400003)(346002)(451199015)(2906002)(26005)(86362001)(83380400001)(6512007)(4326008)(8676002)(66476007)(66556008)(66946007)(38350700002)(38100700002)(36756003)(41300700001)(44832011)(54906003)(8936002)(5660300002)(316002)(186003)(7416002)(52116002)(478600001)(1076003)(6666004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKF0hpL+nd+BHPinVveiUiS+Gyy8aO1mFY0KRSQxIfKO9/gzaszqUD3kxE5/?=
 =?us-ascii?Q?Nj1yV9UxOnOLy7TEnGwCrRrSY9+c92ssrRrkKfdHDYrJEhF8nPb1IikvI7w8?=
 =?us-ascii?Q?yl4jUBe9Ykd+MG6hZrT9y+9//7Oo0WExOm8AEXATlADkAstoYDt7ojvKD5BF?=
 =?us-ascii?Q?zVk9jwdu/za2Xf+P9ZmiQS3EmmPnJJ+r9gAHD0fcS8VY8pVXCQ/Yvu9+KmWN?=
 =?us-ascii?Q?LSebTVLXMFqli3tMLrw1Wsv/to8TjITTnj5sURcqSRtFhrznEbE//9lwbICf?=
 =?us-ascii?Q?DgAkKEErLL8aDOhsKyV42m51t6Yz3OOeR5EQLaXrUpumpKSowjAJKNU8CYOD?=
 =?us-ascii?Q?ck7GGfa6XvySQY+z4hlWDfKRRJ99HJ1f2yLkrk8N7tYmlKLTVOxLbRP4mHNk?=
 =?us-ascii?Q?aPA/DUmuvwDC3VuIfF2PgVM6cemWm91X/nzm7oYdUd3pYj8/EdsrgmealZ2o?=
 =?us-ascii?Q?V/I0yan6QQLG7vi1BT5DhVgfn6Nig5vhXLGIq1nM2yHwsCklN57PfQZVy2fk?=
 =?us-ascii?Q?bsfbvswCsSdJMup9zeSjVaF9sWII7qN5SgCYNERn/4o2ICpjb08TsT8JDc0E?=
 =?us-ascii?Q?YezvQqApEeguDZgUm1uWpzAxMOboXpeBF/DdeauosDbiTzyiyk3r1Dmbu8+S?=
 =?us-ascii?Q?HS81O7ItbdX+WzpjelRZbNFCtG+bzUGNwzfOwik+mgGU0JVdwzB4mx7UTUVe?=
 =?us-ascii?Q?oe+SpWm8jU2EClQYtOilKvWqvieCDRKxpONm968RVR/0iR0ntBZms+pMU3M9?=
 =?us-ascii?Q?3Ejsrb3A6uXdjCBzr81BBBjdETF2jDnZGVZZo7dwaHYZrrP6D4cR7lfr9G5r?=
 =?us-ascii?Q?2NeqvKsu+PNFUsrUWRmBQ76ciawgi1m1juO0c+SZw46IzJSZGjraJ/MJJrGS?=
 =?us-ascii?Q?ZFXYrrm9IgNHk2VsQOJE+HUdleI1My4jzblCU1QvuwSP5oHT/lxIlpODgR4k?=
 =?us-ascii?Q?fo9JX8OaVEV4HEd9wfhe2DNHogwX9/4e5g+rV8hxda6mTt7yZWqkfNTm3pwg?=
 =?us-ascii?Q?2G+yfw1djgAtI94R9w8QarairBiwIjZfZNRasgTCD0gv+fRhLKeJR8ic2pOd?=
 =?us-ascii?Q?B7mCie55I1YzL4BdAptU5kQYHc+KJtMxURUHDrww0ixcR3aA7B8pRGAAqz8i?=
 =?us-ascii?Q?nVQ39ZRNQwd1+SjVcBTLMJc7igvt2ZOPxc5luqJOfY7t67a4kEz+ZOTIP5l0?=
 =?us-ascii?Q?EZi7Re9tFoB7on0Blit1+pcLIcMGE74yDDXtOqickOwPfqbKpVj+hlkHhkub?=
 =?us-ascii?Q?AXUebeuFvv0X0G63V7B9WFVKRqcUJk+Zzkkwp9mPJsMN3aUupj6yZUGb1TlM?=
 =?us-ascii?Q?E2SLMFxk02jzdLiUeMV72tn1G5Rt8lALXio53a0NN5/79V//UoHlHdgtPTs3?=
 =?us-ascii?Q?qN6q8b8JHgbLL7CDf8JnlPvPIg0raBBoQzn/QeJh5H0icYRgYdyWoBL7o52H?=
 =?us-ascii?Q?2nEg/VR/w/+Qgbz4jOVYAMLMMzv+mc90hYmvmI8bqCXXHzum0JrnTbNzCChu?=
 =?us-ascii?Q?b4EB0hsyYZElb+0rr9D0vMwN4uD/rdnyCJ5zBpSunMEXYA7jlGHulw9+KrYf?=
 =?us-ascii?Q?ly7h9vPUbG0JsPcXCP77q2LG/w8k9IJeLW9gH4CvwOCBCzyqeAz/nOywXvO6?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05cdc468-90d0-41ea-e40e-08daca83cb3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 23:14:22.7553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRkfxaghndxKzP5r3UUXEtMYILd0xwFBEJ8Ylr8luFmv4a5xIGM1uSKLHoH21RzEfIUiu5Suuv6lirNSHl5WAV6C2d3C9HkBTvRF4U8KkvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats structures became redundant across all users. Replace
this redundancy with a static const struct. After doing this, several
definitions inside include/soc/mscc/ocelot.h no longer needed to be
shared. Patch 2 removes them.

Checkpatch throws an error for a complicated macro not in parentheses. I
understand the reason for OCELOT_COMMON_STATS was to allow expansion, but
interestingly this patch set is essentially reverting the ability for
expansion. I'm keeping the macro in this set, but am open to remove it,
since it doesn't _actually_ provide any immediate benefits anymore.


v1->v2
    * Fix unused variable warning from v1 (patch 1)
    * Pick up forgotten stats patch (patch 3)

Colin Foster (3):
  net: mscc: ocelot: remove redundant stats_layout pointers
  net: mscc: ocelot: remove unnecessary exposure of stats structures
  net: mscc: ocelot: issue a warning if stats are incorrectly ordered

 drivers/net/dsa/ocelot/felix.c             |   1 -
 drivers/net/dsa/ocelot/felix.h             |   1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   5 -
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   5 -
 drivers/net/ethernet/mscc/ocelot_stats.c   | 244 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   5 -
 include/soc/mscc/ocelot.h                  | 216 ------------------
 7 files changed, 235 insertions(+), 242 deletions(-)

-- 
2.25.1

