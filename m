Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693E86487B7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiLIR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLIR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:28:33 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDFE5BD62
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:28:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVuSXLqJI3y4PzoH9ZF/RAwAPzumdjPJrA0JsbvkqM71T0Mp01toM5lB12LbwQ1rpoSu0psUjQcujbimzkQamYpdSHeL6jSdcz+6FE0chgCaY7h8mebZ5IH/l5Fy7kLaDQ/3s3v82u2c3nPCiy3v6uiLEFEfh/+3lR2OceIRIjqEydzHnRZarFhy0kQHR5ITOb2XsOKIo5pwTDgoh6u31E180UNYp/I/z/pQfA70XQ0wiJOw/bPeyyDSr4Ix8UHNmcfyAEUoHefQC8nuOpEYv2s9LDG97NZ96szPF9/4OVFvK9Rbrsim67JzcC2AkTkV3eSbDKW8jZxzz3LaNtbTjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ri1VcTN1QYtDQ2O0vOS+5xOwb84MG3xOqWun7SuZpXM=;
 b=EnTZgHqIj6jyqipPsiONE9iapkcu55AaHA2f04eeWgHTFb+IC/QmMuTTIAjMbSxUPXAEPRO+QZTHR0DtaWGtymHEIufe/XXX7zHW0KiAXDVBPSR6+OSNElz25jUnHEUhVUE9rCMJf8dPSqavtASUIN/EKS+QLNpZNVoCukkkMXvY27u/CTxQEZntpbrYCtbnpsgSsGI5KDx+Rmkw+hAfvfDhyGooXy5VWzOobuwLdri3GZfIaNhuoZh2HHjq196pI/dZhl1kqhTZ8E6Q4AKxELEnMft/0QKCqcxgLz2e8QTrQL+omoERx4CCuSTPAp7+ONjo2m0bJVRRaY8x5uTlig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ri1VcTN1QYtDQ2O0vOS+5xOwb84MG3xOqWun7SuZpXM=;
 b=svZj6P+UoVpFQi+WkC46kzqO0Yp2cZPYqy/CPi+kzCVsg3ADFZoL0hQ/sqGZybX/tlpbkssnu6nIV3OiCOBxPhNBR6kxeUBejVG0xaUHf1P+y9Joab//yK5pTeu2enWRO1QWGyE3enCzs52cjwfFWVVMsYH3sfVVJAm1YJXcT1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7253.eurprd04.prod.outlook.com (2603:10a6:10:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 17:28:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:28:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next 0/4] Trace points for mv88e6xxx
Date:   Fri,  9 Dec 2022 19:28:13 +0200
Message-Id: <20221209172817.371434-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: 7268de76-5809-4ab7-f31c-08dada0ac927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H802RlIJv9iDVJ8ccxQH0+7KUSNbtsz0JVSOZqxh9KnI3jcHIMmDcKbKYArkNSX44KHyALs4sUIruFv9ojTDaoKOZAAAnBaikJ8WZRoY7QkPkhty3xOfTZMqfjYovrsr5Si8u4Quq8N+oD8upcxw6q5FejcJsIgOC7ISKVG9qtEVqpxsKu+fgbr5uspo6NpjBbxOmCMhol3l+EwHxzN11WmSvhskgE6U6vyry/+bElhQxovTgPfvp00XDhWq1TyPH+j5tr/eZDYM27I7OCKuIKwQBImUAOzYCU3fejtAmhAD3PI5B0/+JtEN445mCMB2D3iIjiRUilVnIolZzip9X/niTpaSDkNtyBVMI42b+hNsEPOhiBUqaHA5dDCH2VniExbr5axV5a93/58zStaKI3qpcYzxwCyewvuBBfxSqqHXlpwkafxjR2RVnUul51Y27sgcrieKhaofAPFJmUBWnaRzF8kGLbrEJbILLKBjvLWOkQhQ0ku2TjX0qJQ4f0UE7Pt78b36+9d6SROxfAp+MppDF/qp+hO72ooztMUe08cVyTD2gBG/rq9/GXYdbVw7SYEEx3zIyF2nG+0Wt7BLlz9PWiGQaAf1ChS7IAlPwwTkHMpI7QLlST9uHs/jSHwdOyT2v1hC915CWKugSrsuVg8IrU2NJIt6a/Bj+1/BP9Zf9VxYe0rajxDCXzLsVs03NmnTP1MBgYCnFLAW3RIMa5zLNECrGirbrXOKLRSXk9bB7GhpHjLXxiV5VkR3nTCEcVT9lVg8NjM/rXv5H5KKB3pY6ZYwgmXQlB63slVHwnM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(86362001)(8676002)(6512007)(26005)(6506007)(6486002)(6666004)(8936002)(52116002)(966005)(36756003)(66556008)(66476007)(66946007)(83380400001)(38100700002)(4326008)(54906003)(6916009)(316002)(5660300002)(41300700001)(38350700002)(44832011)(2616005)(478600001)(186003)(2906002)(1076003)(138113003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mn2ntTEUqbM6qIr95XNWwI6pqu8X+SWbxtHmOxn86VaEda0NYpsE3ikKYls1?=
 =?us-ascii?Q?b3j8YzVzRcE5pLCzu0IijPNzcU+h/IMeXgubgwEld3Er0Nt6Nahb41+Jocrq?=
 =?us-ascii?Q?n4cmOtKE1W3mmBp+T/hLPhXyGBDC10KjsJW8azVA1HeabhLfi72CU76X3M5B?=
 =?us-ascii?Q?rFoPEWHk5dnnZFxNFJU5nepuBlcKXlUql5aC+krVSKZauXwVXwKen3Lwq4kv?=
 =?us-ascii?Q?bj7IE8pRfMR8AgYLrUJPunz+sHLI98jHtmE0Muin/V2jdBz94Qax1Dl/7j70?=
 =?us-ascii?Q?v914dEyyJ6ewSRV5PvzWqUCG9rrVO2J12x0DTCsATKYnUTX1iPtZauOgZrLB?=
 =?us-ascii?Q?NLaSdpbuHJkwPWlX64t8BZ9XF5XT2EsXzMVA/6WUGBXXxL5aznNWqGAHyPL+?=
 =?us-ascii?Q?vXJ2BR5a/Ko1drCZU+ON2sdirHRynxn3PduEoFvnc2VdJNfxrZ28YcBu+WBA?=
 =?us-ascii?Q?yCuR5My0sN7temfX84zR4qsYh0skdPH4vdIvCjb2Jyw9toKlNrHi90uDhdWs?=
 =?us-ascii?Q?/Ksxy3M5PF+qKTbFUXl1fKCYkSDqMBOS6cmQ5S1SDe6iB1v3IDZwN2TcELjX?=
 =?us-ascii?Q?BCyZhr/KrO3Y9juw4Jk3G586lSBlLzyIyabRIQd2/RcMIzy6jCcsdViyPdwH?=
 =?us-ascii?Q?zombOem6Db6lE5ffIgMF7jeXrUFGnloEqIp2qty6PGEP29wDscYxB6oAFud0?=
 =?us-ascii?Q?RUeA9LW28iBR8FsZUu+aTHr9IWNEXenReqI21+2mJ+PmL9DaHUYNUPdTH58K?=
 =?us-ascii?Q?JjmmYhS5wDAwAMup5cJ8jW6nwYc6H035QPetmdT+hq3ps0SfLVP78LLPCm9y?=
 =?us-ascii?Q?0pFRmzxSBf0vM/KlM6AMqe5KmtZTyJosVfure6kytHS6akTI6ZMj63Tl4di2?=
 =?us-ascii?Q?kqDEjlTdiksMMYTa7lxOw+Fk16uDn7jd9keTv7soaNs/D8+6bWY62rMmnrRq?=
 =?us-ascii?Q?72Mx27gTTi9SMnAEwN6ZBJMzWEDo7SRthUCgIN2UsD+RK0vts7C2+zofOhUq?=
 =?us-ascii?Q?/nPovihAd6+7ANWFyQm2xViBp8wsaqmBtpPuGM8x5N5aE8o6I4844eOrfgts?=
 =?us-ascii?Q?Hb8LgT6SrYUA5cTMpxBrqfyyej7+gd8rhFcRDzNVXzN5og2z4dB+lWq0qq0F?=
 =?us-ascii?Q?J8BKHf+3yey4M3rYcQaHgFmEcC8byBaHWk+BhmddiPJzW/aCa1SV+fgvug9I?=
 =?us-ascii?Q?jAEgMvn7byFMGArF7cOOBNsezxomC474uYoxNm3vs+uJ7nZ0ml8hqlWQvVPM?=
 =?us-ascii?Q?qFmZZ5kDuUJoEixK99/l3nS3AT2R22ZU1JUp4gWlx9n7sKgkPfm3gC4XPgBl?=
 =?us-ascii?Q?PPKcNJg18KXUlf/jUH+YRT2NPfHkJtuDv3ll985KByMEqynhXdwM0CM+UAYu?=
 =?us-ascii?Q?h+lpQ/X5EQj0AQz7kEc9/hvWTI/6WANXfghxa178AptknMorjraOTAw0EYn7?=
 =?us-ascii?Q?obhXgIm6NYroHR4tyZHnqAM/0qyGCV9ujFRD6heZBBsCam6NXUepDI/CNBrZ?=
 =?us-ascii?Q?lH3LbAYLHGnj28YZ/cVuKimM1jchQHMQuZqxLCVz5Wpz2JFEOUiAPDxdWMUR?=
 =?us-ascii?Q?zXoQiIft+BPwBQPgq2bcnS2O/AefPQrP/lq4OwPmoaOQ1ex4D0T6e9ueiZd/?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7268de76-5809-4ab7-f31c-08dada0ac927
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:28:28.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DChNCHBKHnsuoiuqWl2nK2fc0DIsEtOX8rXGpx9W/8O/ig26WOcIroEFtFVTzQKVufGlc7zyqtiNI9hO+ad7fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7253
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
[  126.174558] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[  130.234055] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2
[  130.338193] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2
[  134.626099] mv88e6xxx_g1_atu_prob_irq_thread_fn: 38 callbacks suppressed
[  134.626132] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 fid 3 portvec 4 spid 2

and after:

$ trace-cmd record -e mv88e6xxx ./bridge_locked_port.sh lan1 lan2 lan3 lan4
$ trace-cmd report
   irq/35-moxtet-60    [001]    93.929734: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 spid 9 vid 100
   irq/35-moxtet-60    [001]    94.183209: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 spid 9 vid 100
   irq/35-moxtet-60    [001]   101.865545: mv88e6xxx_vtu_miss_violation: dev d0032004.mdio-mii:10 spid 9 vid 100
   irq/35-moxtet-60    [001]   121.831261: mv88e6xxx_vtu_member_violation: dev d0032004.mdio-mii:10 spid 9 vid 100
   irq/35-moxtet-60    [001]   122.371238: mv88e6xxx_vtu_member_violation: dev d0032004.mdio-mii:10 spid 9 vid 100
   irq/35-moxtet-60    [001]   148.452932: mv88e6xxx_atu_miss_violation: dev d0032004.mdio-mii:10 spid 2 portvec 0x4 addr 00:01:02:03:04:01 fid 0

v1 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20221207233954.3619276-1-vladimir.oltean@nxp.com/

Change log in patches.

Hans J. Schultz (1):
  net: dsa: mv88e6xxx: read FID when handling ATU violations

Vladimir Oltean (3):
  net: dsa: mv88e6xxx: remove ATU age out violation print
  net: dsa: mv88e6xxx: replace ATU violation prints with trace points
  net: dsa: mv88e6xxx: replace VTU violation prints with trace points

 drivers/net/dsa/mv88e6xxx/Makefile      |  4 ++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 85 ++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |  7 +-
 drivers/net/dsa/mv88e6xxx/trace.c       |  6 ++
 drivers/net/dsa/mv88e6xxx/trace.h       | 96 +++++++++++++++++++++++++
 5 files changed, 174 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h

-- 
2.34.1

