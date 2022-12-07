Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5729C64653B
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiLGXkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiLGXkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:40:10 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9418B184
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:40:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuBV+0NJhp5K1jIVtiliWPPAyAYw17tQQFYkjBK4XBWjRSpUTzXmFpQTReZE5ok7NSdG/m0SIzVjTIA/pWWty5C/O2Ls8ibcS4ZDwIJU35FK0DSn14zgG2/Ne9UT2VIHwvQtznft/QpTk6PXu9hWzY75jC1UiuU7vXOnvMg848Z6+ZODE4op5WrluYABmspQZ2CwWHLWpiCTm/iXVNU0HzZsLzo4F/YVAsKwaxpLY88yW08W0z1GtLsbxxHFvORR7upPBfqSIaSZwfNgv3F3mhulM0k8nq0sD52uFcL0SL8VRw0gnqXhKb1BLdNkPh/CHGC8fNL8dZ8ZoprnyZiozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tj+mf3bUnNj1ZPf6vxFOCRnbTkKtUkinKRc5oK5BM9w=;
 b=FFWH0xCLfMTcYvUc982f2LEFT5Hpu9n1F/2kb4RtQCNKMrNL1igjcTbo8padUzv5R1RzHQagdkWEd52TZt4dpbR2eHd5a8tyOWzfDSs6JD1ds5QZLEWQF0wkXf9zwDxx1ZKD24BN73XziTi8bhOQNJV0J4P3Eb4Zkc2pG6Yw9TxH/wxJnLrVHO1CQ1w0Q/9Hbsogu2IwiSXLzKIAzb0RiJcdlDVGkcF9XxIEOzfN8H1thdz2FAqYEzJ2mtyfig5lZDOelhDlv/Mi8gPQhx8+x24pBCDNvNjjQlwwuY9+BdhprhjwNKFfqWi5HtLmgqwMIqL4Pjc1W13NM9Rd6Oi3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tj+mf3bUnNj1ZPf6vxFOCRnbTkKtUkinKRc5oK5BM9w=;
 b=pMbrOHqCu3Nqkd3iD/wJ5CF3H9NreBYzRqkyjbtVv5tDOd+VcBVYdzpT1Zhjo3t/j2TmgQqs6p9m+ICCrhK1bFQq5vSjW4V/QvAZaKEmLKrDmEDVToHS/lTHGrClSVveXAqiqS7vm7h7xuyK3PDJOheGWFYQA5q52R4NAIIz+28=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9659.eurprd04.prod.outlook.com (2603:10a6:10:320::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:40:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:40:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: [PATCH net-next 0/3] Trace points for mv88e6xxx
Date:   Thu,  8 Dec 2022 01:39:51 +0200
Message-Id: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: c7f8db2e-9088-4393-51c3-08dad8ac5e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgKiqYCe8M3sc/Z4vTBaWMf4C6RDW+66Hg7ClRG5AKDKh6dO3JSWKiXcc5rsSaNY0tW2NuvWlbgLBcVxfv3g1JnsWdHPHtHpSRLvc38mVXGMLvZWOvEZL4l+qXLC6y8ZwHLGdm+woKq/NA/lIBxUn6FH1dQIY26ZeatbUILZ2m/QVwUWqo3q1uPhKX0XpOHW4kn4ac0/UitoY30MGFGahFPNktohlL+eXYg007SD6k0lQD2y0HzTJ230L7P4toP8ig+wiZ50Z+wo0KiB6L8+i8ph7WJxn8eaTR7Y/JLTa8b4IhhUiCY2/pM1NKSyasPdovi5cab6Flq3uplompu0UiFT6wHiOycLu2jdWPv55K1Kp4vZB/e+PTF3j7VK4uIfZ3UV64RD41m8bDUsUg7QotbQ14xw8Wp0LbqbphO2oRTJlOWXnzpEBZng2k5cQdsHGiNOxAQfTyl8o41aaDjklEBfoT5XBdbR1ovoAZCqjjWOOVHbpGC2E8N8ZpOgM599AMHkaKZ+6pjOcbyfnkrTrwXiyFVb/m+7v0k0biY/ToXEv1SPxujpe5PutdR6dNXUf0hKxtd7Osf8JCRfSoJQZ9zQ9XteOoQN2lRuMIat+/hDFyXAAkSxystPZ/YouDGrMrVVhDMyF87JhYDmOSrTl5I8tu5LSX2gbVx3dQRRmSztg4Znr2xWzRYsW9P1QSvXMKbUirQRhSuKlB8ETyY40ynkVVVUWeTBqVFrIlI/oeERu0MKs0590xir4E7NF8k9GbzSsxdLDBpHElAYZQvIoyf1DhcY5B4HQbv7TKnFD4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(41300700001)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(8936002)(316002)(2906002)(5660300002)(6486002)(478600001)(966005)(36756003)(54906003)(26005)(186003)(6916009)(6512007)(6666004)(6506007)(52116002)(1076003)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(138113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+Umj9MpF61r6EIPFAvMxpwllYrpK14WeE9GZHHaX/5skxzuKupIUh5nGBHa?=
 =?us-ascii?Q?GT7LBYNZ7+rhqlhpS0q7778wwhXRtaFulZdWxMkt/s2SHgz+ddWlTsixdzNz?=
 =?us-ascii?Q?yGpWEUoEJ36LZ20sP/TMFOg+OX/JLMd9yqE2C7WWCCjs36IktoRhzaNazy/z?=
 =?us-ascii?Q?/CkZzEuH9/wZI0PTejCU1VOcgkna/0sJDGWIaBlnRhoXLp10X4lh0acebA5T?=
 =?us-ascii?Q?sK02hj2HKcKeUF3KHv8xYbudvpSxe7yx7Dwr/uAngiGAklP8tt7XWfzMUDss?=
 =?us-ascii?Q?3MBHE6y9X65eQSQuCpV+3bSP23p+ZgNYY9qLol1vDSkLUGRsKf0I1iJe8h5s?=
 =?us-ascii?Q?fn7dcwWJm5zNd/A8zSBWczOTL44jxvXOkvoFFSe48I3uIdF5MWec9GCM1Cpb?=
 =?us-ascii?Q?2Ok4tJUQKX2eyU3y0C65QvLlESbGsmA4pN3F2Gs5SoZUgswacUitcHEOgCHV?=
 =?us-ascii?Q?gd6tWdY9vaQeCD8/BXdpLJBIinLY2oXitM7azVavIRaBzwsm18Z4oxykiHY1?=
 =?us-ascii?Q?1pbYsCLLRkiFodFVHagEi90r0EQBKYjm66iDkMw2EcvLUnRqAOWP36ZNfox3?=
 =?us-ascii?Q?WqJGBuJT2aFeZBfDmifKmDsz/5ZKX9rBjxcRqWxS33j4OvDem367yGlT/3mS?=
 =?us-ascii?Q?2NPeBY6orM9PLr9qSgF2eRYpfkIbQtmpPlDbRtIGXKx2k4jHEiGS6eXoWyqq?=
 =?us-ascii?Q?90WKrpGDXHsnIAMJKiXzN2GYXbsj+m0WM+8o7Q4cmTQVbbDc2aTYFVeLWJ83?=
 =?us-ascii?Q?nt0wmRk0r+/m8ltXD2RrrSbcs5ERwONVpIe08JL1g3n7RVyOU0o1KWfIo4he?=
 =?us-ascii?Q?Td5XJ6ReXiYT/A6RFcpHUq0ocb/CIU5ZDm21UnboN4TBH8ayjLLUop8ZK6lZ?=
 =?us-ascii?Q?rgkl+figPhGPdF9KlfZUR1VEBNBDPaecuO+/KPUcFhkNnpK5T4/FG/tP6NBu?=
 =?us-ascii?Q?K788ej6UdFSl4MkhPTBNSMSpyqdr3Tc0nhNTJKuep/UhPf72Vh5oaHmAU2wd?=
 =?us-ascii?Q?sRfq6BatbDm/nEUVU7aj45NPqhMsu0LN4svfVxEyEcbKH53iLTNbgLH7gUC9?=
 =?us-ascii?Q?BLIZWS+u0/4nCee0zUjoep12BP6qhDxCaEGNEolxuATzlzCiB7/eTcwchWnI?=
 =?us-ascii?Q?4oHBbZmVqkqIAFtCdh9NMUit2TKo5E6p/s5tcXUvjDsOTbyKRCdSSazUQlx8?=
 =?us-ascii?Q?N99+sstzKxvb5sY7jfLTnGkx+ERNGbwGucWlysi9S+DmAeJUcIek95pxAccd?=
 =?us-ascii?Q?WUv3Fjmvs3D866ZJBDzu0z9gOWWncLMEsvl1ig4l5RcMmwy3nvyxoEdHzvU6?=
 =?us-ascii?Q?mRHHHSNA6Uk8YnBI2XupuWW6Ihg7LGpQWc8ywZu+1/Wbp826ZJxfipoqt6RG?=
 =?us-ascii?Q?YRQIU/1GtuKAqIFjNEXWvHiyd3wJPrzxAiiEHUeSC7VjFNgJ6SBdLLS+1TVv?=
 =?us-ascii?Q?+UVs6186gwO7R7Y3E3fd3hwqm3fIMnczGg456tfruR7kulpv1KlznLZsEWxd?=
 =?us-ascii?Q?D6JV0Be76+sjHvccwZ91YhofNzbt4MTyda06x+Cec42u3l6IuT0tPMNzx85s?=
 =?us-ascii?Q?0JIpzR9buxlFjGit3IRfOgY0c+DwNaW3MgMfyHj/Ect7pQ2YHsFyoQ2W6zC5?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f8db2e-9088-4393-51c3-08dad8ac5e2e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 23:40:05.6008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUFJ7HOl3ApAxMa9SJU/f31CkZGO2m9vUOSldh4fC2R10TK9lwSPjxB760Gzrd3t8KZ3/qPE37u5NVygHoR3mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing Hans Schultz' attempt at offloading MAB on mv88e6xxx:
https://patchwork.kernel.org/project/netdevbpf/cover/20221205185908.217520-1-netdev@kapio-technology.com/
I noticed that he still didn't get rid of the huge log spam caused by
ATU and VTU violations, even if we discussed about this:
https://patchwork.kernel.org/project/netdevbpf/cover/20221112203748.68995-1-netdev@kapio-technology.com/#25091076

It seems unlikely he's going to ever do this, so here is my own stab at
converting those messages to trace points. This is IMO an improvement
regardless of whether Hans' work with MAB lands or not, especially the
VTU violations which were quite annoying to me as well.

A small sample of before:

$ ./bridge_locked_port.sh lan1 lan2 lan3 lan4
[  114.465272] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  119.550508] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 34 callbacks suppressed
[  120.369586] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  120.473658] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  125.535209] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 21 callbacks suppressed
[  125.535243] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  125.981327] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  126.048694] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  126.090625] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  126.174558] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  129.400356] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2
[  130.234055] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2
[  130.338193] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2
[  134.626099] mv88e6xxx_g1_atu_prob_irq_thread_fn: 38 callbacks suppressed
[  134.626132] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2

and after:

$ trace-cmd record -e mv88e6xxx ./bridge_locked_port.sh lan1 lan2 lan3 lan4
$ trace-cmd report
   irq/35-moxtet-60    [000]    74.386799: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]    76.834759: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]    86.537973: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]    87.553885: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]   100.583426: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]   108.550520: mv88e6xxx_vtu_member_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]   109.054410: mv88e6xxx_vtu_member_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]   123.586896: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3
   irq/35-moxtet-60    [000]   126.315529: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3
   irq/35-moxtet-60    [000]   126.400709: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3
   irq/35-moxtet-60    [000]   126.947391: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3
   irq/35-moxtet-60    [000]   127.985090: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 port 9 vid 100
   irq/35-moxtet-60    [000]   128.059140: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3
   irq/35-moxtet-60    [000]   128.163132: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 port 2 addr 00:01:02:03:04:01 fid 3

Hans J. Schultz (1):
  net: dsa: mv88e6xxx: read FID when handling ATU violations

Vladimir Oltean (2):
  net: dsa: mv88e6xxx: replace ATU violation prints with trace points
  net: dsa: mv88e6xxx: replace VTU violation prints with trace points

 drivers/net/dsa/mv88e6xxx/Makefile      |  4 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 81 +++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |  7 +-
 drivers/net/dsa/mv88e6xxx/trace.c       |  6 ++
 drivers/net/dsa/mv88e6xxx/trace.h       | 98 +++++++++++++++++++++++++
 5 files changed, 175 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h

-- 
2.34.1

