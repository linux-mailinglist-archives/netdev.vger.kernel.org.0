Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB31C57D698
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 00:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiGUWMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 18:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiGUWML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 18:12:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60115.outbound.protection.outlook.com [40.107.6.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70245951DB;
        Thu, 21 Jul 2022 15:12:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po+52dpfIuV3thx3eiJHKwa9zVI+RdOndIHVVnwOqz489s/o4zcfUfiuNr4p1UmPh2gPPT9NX6KhbpAtqiDbBIdOZs3GXRn9NyJPQxwzErDwWeGt9yZj3lhe66WzDfF7dWQyrly+M9XfqglfN9Ec+BBlRYsKE/i20gEAyq8Ofi1q4ZcuyuJ6XMmW8ShbKS1kvyF4UXbvXKBQGJCSBHKzCGEdsYhy/FCRncZpEVxC9KosU9p7Q/03EJT7++CnyqLtkTZNwHIRn+93ePY5RB0NKEth6DXrM+vIa9/3FRL6mMVwdvMARPVgFFqKVyNtXAdTby1Xm+53Kw6P3EKG1cnANg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxvjfJzzH4hBDt6S9ThXbSwrlORv+s2e4x6yRC2NUmc=;
 b=jkWHdW8zyF/5kupuhl0T9ZB+KHoMdRzHvia0MHZUZw8XZr+Y+9HvuCDd7ygBjhTWJWw1dRFBqmdXEkS4otnk9VBBCo2l3zl5G5N5n+G98hd9yFFVz75jBDmZttbxB8rTCxdj7HvqDYRyIgt8q295+toQS8YI8Q/lxHX1QyuAHH3FytnMXilfESmXQSS/sLjW28vUjiCA3RF8OUw5eD8tBOcphzdzyj6pyqEKYctqmI2uNivk2dShsKsMHQeDcwY0hkfAsh0sZVaT4bw1ATZq3H5jTuw98R3mGvCiu/zEvvdfauAIxDw3R2rXt9Mfz4xGUiUqdsu7Q5fQ62ebrtU52A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxvjfJzzH4hBDt6S9ThXbSwrlORv+s2e4x6yRC2NUmc=;
 b=r5cyZNyYZWdt4VCW8k6sv84QSPn5HfsQ5NP3+0GSB360K1juhdM0cwmO0R5WKMT9+qLmzuxW/gHYrB1YKFeMyrUy/hoYQ8bogvmXc23PodjHpR8NA8xaH5Yyq02TuXnn1TUlLNV+L2wF5wScWsAhgzT8NLBDddDP368/O7yEZus=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0302.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Thu, 21 Jul
 2022 22:12:06 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%4]) with mapi id 15.20.5458.019; Thu, 21 Jul 2022
 22:12:06 +0000
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
Subject: [PATCH net-next v2 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Fri, 22 Jul 2022 01:11:39 +0300
Message-Id: <20220721221148.18787-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0602CA0005.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::15) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 233a22ee-80be-4b1f-5e07-08da6b660bf9
X-MS-TrafficTypeDiagnostic: VI1P190MB0302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/cIuKCJlJM/g4ibB/spz6jxHjH5ZApvWL25R2byh/C5ebPsPfEkd++eZrTeSoU96F83Vtz1t6xrCjsqkYgCHmgJFGA76+633lrxgazPbOX9WvVJpq7e/UMxAtxys4jeGXskuzsyzPkHVQMlUzpPYfzz1b97PYWfOxY6GsTri4pk2L33deMVuAGRan4AFtGvW0OiOfwG0MFHdvloHiBhUC1NuYsofKH01OQI+YnsyxY45BfKPZCGlWq09xaoZ9j94cXtFclL6pCKzNJBgQPNu2gQ1M/mqzzYCf85j9zvrq0A7+7Z8oz7WSoRSOktQelqRCAOkQFQ10SOhWw5QXvhzyyJTD0zxK/APM8hK+ZtYL9P4b9rxnH+5mSAfI/owcZqYsImR4Uts0K0f4F7AJrTom9YgS1KZvs4PI7V+R2U22beLP8/fXu/7LMm4fHzSc93R7wvCNWnDizewxPWZasEfGONf2TFCfq2iainQ7tAd/ERcpfx1UqjDkFl2A4+VqB/QU4ndIVzI0EqGomv32lUqQDftyeJdYffb1ldb+Fthlz8Ds7hI/KzJkJSQ/f0dlYA9lqljcde64/8fgNNFTJNJNzHMwYg2rs04EH8dMErIEZERQIN5K+u3cAkGuYz04dMnOGwJYf00kx2WVBSL1f9wbzG9S+B2Id7AHEqI9C34hPgmTJsR8p4Unk+5A1cBz/mkw4bcFsoTxhGhuXCnsQlViYcc3BIVlRTcPGdOM40oOG7uUXGw1Pqslp7rrQwLVJLkS4Ro0Oqnty1DWd3nHFQn7iQVDdnsy8mg5uhbBKlhr8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(39830400003)(346002)(8936002)(86362001)(4326008)(54906003)(66556008)(66476007)(8676002)(38350700002)(38100700002)(66946007)(6916009)(36756003)(52116002)(478600001)(44832011)(7416002)(6506007)(41300700001)(26005)(107886003)(186003)(316002)(6486002)(6666004)(2616005)(1076003)(6512007)(66574015)(83380400001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QS4X3JdZa9PW+cCwmGm/4snk4rSShvXaLTqNiLk6w2TNGe4GUCheziF/qLRL?=
 =?us-ascii?Q?MEC36jXY5Vl0Pd0aI1aaaCKiZoGq7tzuIVA2u+GIz8Kkt5hmylAJW4APXd1K?=
 =?us-ascii?Q?CQgdMspIK1O65SWIuVo6DXixJcLvLv24Gw0lbrjgoBPLVfCAh2l249u3XqwJ?=
 =?us-ascii?Q?EDUS+Ff2Ifuqvtx3vvO/Zm9vTQ858YTHjZWIzwlc60MtqgTIUDRnSIaUlwT7?=
 =?us-ascii?Q?9Omt8vhEZJuwwZVtl7WLidDHbbhx2W5YzoidzQWlUDoKZtT83AVeOq0lLvwL?=
 =?us-ascii?Q?YK8IdBU7HdxKPDUralSDBwVSXqKo3ITIi05xZUGnR/jJCA9U/rEY+O+toanR?=
 =?us-ascii?Q?x6ZcwBmNdQqPByoUPzleDXKoqtrisyXr6UyNb1D2SgF7hHw9JD4oSdDkKxhc?=
 =?us-ascii?Q?Dt2SsbninDXzO5aY7oSgfWCD54HG4+Nb+fjWE9WxXYmFedLRnZQ18hBOZhY5?=
 =?us-ascii?Q?bP4wY2S/jqCPRWvsZZi40n4787Jb5uHJYf/RQYRT2Joc6wlZy5m6J94OvjtE?=
 =?us-ascii?Q?JoRgdLakpauE+mB8o2Hur1orLhxVgszwbgpl7c6oeo+ONokJpWu6L4oBZMGu?=
 =?us-ascii?Q?aPYxksoG32iLv/KmIuam8qf7s5fdDu43+2z30XLmq+KGrEAP/hMfASO0pXd3?=
 =?us-ascii?Q?eGMmANdzk4A8TPl1SSbmEdH3ijQL/p8Yd1CWzY2EDU752+bp3jH8ENAPA0LY?=
 =?us-ascii?Q?HVY9SS5oCLXr/wfowbkycLRR6Zb9LFv0gYv5FkbgU1zCZhNg7Lc3Pe0X7xYt?=
 =?us-ascii?Q?SbeHgaqb8hHiCSxsUV22S+IYflrptVcgPzug9JSvrVBhslRuOy1E1g2w7M7b?=
 =?us-ascii?Q?mbJv4YhrLeCCJ+tRZronrq6Wh9Bbe9DNjfWZJwEBi50/9pPDTMi/U8XT99+D?=
 =?us-ascii?Q?7F3aNqSJObSLGM/OEO65FYRTU4q/XBNc6ebPHNp3Ej8cznLZzoCsQ8hB/uvK?=
 =?us-ascii?Q?m4X5WioYZrSai1Jy4i7bSTAD3B+u/cuZ5V8MX3w/Owiipjv9NFOzd23XFrwD?=
 =?us-ascii?Q?UNKxF9GuLlxW0o6T3EAvtG/OmywRE9Q52LwyxFMpWKalktvlZ87oavXeVZt3?=
 =?us-ascii?Q?UjTews44yZ7oSeTH9j+bA2QkdHDHEAWTz/Mz39++K08XEgPhPvqP32cDlfMW?=
 =?us-ascii?Q?lqwZdMGGVvBCMuAD/iNDe5VsgxfRny/HR8qfmCyRGleqoDqyKcLAcQpfR9HP?=
 =?us-ascii?Q?rBMewufsut5qMh+uLO0dhPKr3rossZrlnLGlfCfmiFzidTu/vRpSwWXBDvn8?=
 =?us-ascii?Q?vPJSKxGzydGNP+CJoGiDB2mdFiurmo0+JGl6VGYAJCeBlheAE/uh5oWFVj6P?=
 =?us-ascii?Q?VHDLEfCBGX68Lj375B/X9OC5O9nzouw5YchPnGELKvqKtstyKPXvGxK5mkgZ?=
 =?us-ascii?Q?85ifJUemyyvxchEJaSN8/i4LQVN9wQIAHqOZSEGb1SzTFBGfUvkmTlIKwdKO?=
 =?us-ascii?Q?ZGolTPJdc95t4iv+PvQ9TDIQf2ASJGTdA7I5cRR0s5CarP5izIOpZ1ZtnsAy?=
 =?us-ascii?Q?zjl2rjf0U1Kq77naMcqTxPJ0nMOA/8zqK4UMwmDCNyuztnEOhWUx3VOZwk8Z?=
 =?us-ascii?Q?9wHsuVZ4/SJ5+4k0rEWXGMzq02gu/eiSOW/vluiGF7h3r8GEYCiquxSI+uZs?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 233a22ee-80be-4b1f-5e07-08da6b660bf9
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 22:12:05.9636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z06r8o60BG9Ei2YEFNlVhKxjCp9fHuLPy1wYDJbhf8z08oShI4E8LZ+ZfbOIqdnB26EYV1C8dzKQFEGm26DkDoMh3utMCBK7qFeAn484/UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for nexthop routes for Marvell Prestera driver.
Subscribe on NEIGH_UPDATE events.

Add features:
 - Support connected route adding
   e.g.: "ip address add 1.1.1.1/24 dev sw1p1"
   e.g.: "ip route add 6.6.6/24 dev sw1p1"
 - Support nexthop route adding
   e.g.: "ip route add 5.5.5/24 via 1.1.1.2"
 - Support ECMP route adding
   e.g.: "ip route add 5.5.5/24 nexthop via 1.1.1.2 nexthop via 1.1.1.3"
 - Support "offload" and "trap" flags per each nexthop
 - Support "offload" flag for neighbours

Limitations:
 - Only "local" and "main" tables supported
 - Only generic interfaces supported for router (no bridges or vlans)

Flags meaning:
  ip route add 5.5.5/24 nexthop via 2.2.2.2 nexthop via 2.2.2.3
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 trap
        nexthop via 2.2.2.3 dev sw1p31 weight 1 trap
  ...
  # When you just add route - lpm entry became occupied
  # in HW ("rt_offload" flag), but related to nexthops neighbours
  # still not resolved ("trap" flag).
  #
  # After some time...
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 offload
        nexthop via 2.2.2.3 dev sw1p31 weight 1 offload
  ...
  # You will see, that appropriate neighbours was resolved and nexthop
  # entries occupied in HW too ("offload" flag)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Add more reviewers in CC
* Check if route nexthop or direct with fib_nh_gw_family instead of fib_nh_scope
  This is needed after,
  747c14307214 ("ip: fix dflt addr selection for connected nexthop"),
  because direct route is now with the same scope as nexthop (RT_SCOPE_LINK)

Yevhen Orlov (9):
  net: marvell: prestera: Add router nexthops ABI
  net: marvell: prestera: Add cleanup of allocated fib_nodes
  net: marvell: prestera: Add strict cleanup of fib arbiter
  net: marvell: prestera: add delayed wq and flush wq on deinit
  net: marvell: prestera: Add length macros for prestera_ip_addr
  net: marvell: prestera: Add heplers to interact with fib_notifier_info
  net: marvell: prestera: add stub handler neighbour events
  net: marvell: prestera: Add neighbour cache accounting
  net: marvell: prestera: Propogate nh state from hw to kernel

 .../net/ethernet/marvell/prestera/prestera.h  |   12 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  130 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |   11 +
 .../ethernet/marvell/prestera/prestera_main.c |   11 +
 .../marvell/prestera/prestera_router.c        | 1141 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  379 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1718 insertions(+), 42 deletions(-)

-- 
2.17.1

