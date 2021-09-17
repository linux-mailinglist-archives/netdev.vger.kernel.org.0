Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33840FCC2
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243735AbhIQPlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:41:18 -0400
Received: from mail-bn7nam10on2091.outbound.protection.outlook.com ([40.107.92.91]:34017
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243677AbhIQPko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvlzjQ0DYR6LiGTUhyqKG/NtYXAG0iHcuk9xZzKjb9XWp99ufPEK1wik54/nDhVHqWJefBgEX2iaQBFJAEC758FOhHfOKPDtBTomaloILIz9VM671YCRnkPP7cisp1WWwqwPVgbTRLUVeaIr0sahv61L25yQTVjiaZacuZS8qoMyif+S6g2o/RcGxHfLCSTp6wDs+ror+w/VOuBWbTh2kRKB2ALPdj+LUj/MAhoqCljzjzvoMt4EOZXbDfgDPhlLg18rsKSaR8TWOqsCtoR+8UVGa6l819oncU73rFPn951UsO7s66Dn7cA5gBc7uXuIUnlwXn13ljidGkQ/tGIQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qlBz1AsTK41IMxmwRHpPApShtW2URrjcS72AhQsfgdo=;
 b=bSU4WIjevhuSAIgaU1+7b3zYqBMARtqtVvjc59G34JP4bTmyo43ELzZZFx/2AilDnsRSvwYZz9s8aJGGVnWOSAHafvZA16ECHwlvpNcMDbRG1Gx73pvH2T0Hf4MHzroiKqAv+gjYadgw/I8z/XO7ULoPODfu3BnAemsOZ8LdhMtEr7EHNFHvIpFsIwa3nxJ38Zue2t1M6REs+vyDA7gL3FemIxBWPDmq0OMIMO61Sz+qdi2TNK5BVt6ZZ/FY9zz0GXWKa2ItO2TeeqCUZI6xGrV5AEElGPsg0oO8x1gDLzWH6q/MdgvB6gvWKl4PskBvZn6K4Rf3MAcrix3vkm51mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlBz1AsTK41IMxmwRHpPApShtW2URrjcS72AhQsfgdo=;
 b=nQUB8jdTMz3CrNWSnFdJfKHpAiXeqCcfFaosgZgtgCufU+mCSFN/tInEu9X2hASkEdHluev7LGGX6eULSvfzJPedXXTU3NisF34ag0QUrjx1rQChKE9mB8nMPbEhG6DGEx1X6o2gk74rx3FM+FQSflTCCNT/PwZ3FYxk0afAxG4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2221.namprd10.prod.outlook.com
 (2603:10b6:301:2c::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:39:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 15:39:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 net 2/2] net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG
Date:   Fri, 17 Sep 2021 08:39:05 -0700
Message-Id: <20210917153905.1173010-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210917153905.1173010-1-colin.foster@in-advantage.com>
References: <20210917153905.1173010-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:39:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efd92cdd-d7b8-45fd-b060-08d979f15104
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2221:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2221569127F5632CC85D7BB7A4DD9@MWHPR1001MB2221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8yHudZIGT03HVNr/BXnH6k0ZtzG0499r/8L9RkiqT1n9m7d5FIPElnfnOkXXl9SM/ZVcgfpHwbGnsHP9FDQfenceUmcw0vYn6ky4F91SfHENEwXrVJofTVQDWP0vFU9JA/5fCCVq5PLyiOCOI2uHd9vsN26MlJfaa8nssCIfYXJkeImhIeQlrUMRrtWAPvfCKX/3zFXkG43mdPdgDNxLSU9PikxeYKkM+dWPoq5r6rkL3xIo/n+7Yp+c8zIAvLa+ygGtwM+2tNciSoX/CtAopT0WV0TKLTv0NWM5m3VTJ+JVyXFuhGEbt6d85C1E4C/vGE1KnLhuCH6d4WJA3ht2joIE/P4hmA5Cc9TY5Y4/6hbGExEIvxw/Sk6q9NzY72wEL+/rp2Bmmc6uYUMtZCjHh2VwZR31YdtjvmfGEqHrckhS+KtTTCvyD1f0uNUE0G49B2pcnwkGk61U1Dn6/ry52u1gt1sXqTRfObfNbfR9TZ4JRRC8Z69xTtulEFQIFcrvBQdUfYRwkCp4kKqg13qp2jBfPpfXCRc6Gpv9d34EqGMf09p6Q3cKJeFMXeaEHNi/Y2ffotzFA2fLTZo5sgRuUwypejofPrhGEzHr4VyWITitPcIb/ZAcc3zhUtk3GgxomjzKdaqBWo1apTQWGPROaBJPPRQtG2p5jDLCy4yfLKFWHSE3WwAfKwPUpF6WcgBRokdh8S/UPjdYIJesr2GFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(376002)(39830400003)(52116002)(6506007)(5660300002)(956004)(2616005)(1076003)(4326008)(186003)(478600001)(66556008)(66476007)(26005)(44832011)(38350700002)(38100700002)(6666004)(316002)(54906003)(8936002)(2906002)(6512007)(8676002)(86362001)(6486002)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yAwztSUBYNWpcWFhgP5nDbB3xEWZSlmAiP8S8TYBaM75goCbogefNAh+dboH?=
 =?us-ascii?Q?qlj50po6JR3VWgREpLOsZJUE//D1a09I0+OiO/TeoN//8XYPEnD2FKNGdKqU?=
 =?us-ascii?Q?+ikvsBbsvVnNzCtIIpFwg5CTdMfI6xiTmvceioBKPCXBRvrKLB8Wt4yA6l19?=
 =?us-ascii?Q?VpIDkfx7OPo9VZyIqxnnXb77LcXNh7JrmmgeGedqFi/wwKE8//V83o+1nt7V?=
 =?us-ascii?Q?5ifQeyvd/d49ZGtjvIfKb3bpKfKxHpiFIK+ebP6Os+zIkHsS/DZcKRoQx9GX?=
 =?us-ascii?Q?gLCr6dCNhnj9dhpaHvniLywrIcWCZvALoYUFbW2JI6fg1SeNJQW1uVlPi+io?=
 =?us-ascii?Q?plK3ymhP886lQW8WNmndBciFXOEs2jrjeE/HAkfamBBNcArHT9v4DtvUx2R8?=
 =?us-ascii?Q?V1ITeGqhEnw0S18iJGQUAT6jMY7pHiWVxbiVWNuNQjsLq3Hk+T6S5/YapDiu?=
 =?us-ascii?Q?uOQH2SgFPh4NTdccn2XOWcFu/glzws33XWCaeYyUn5DgTaI2Js5NfR90d97B?=
 =?us-ascii?Q?ul5vv4MLV/YrsHpNJmuttN45FPX2B1MYBwG/rmISRp6aYhsiC//0tiTEyKmp?=
 =?us-ascii?Q?S0/hnZGmnoLVHFRRORrxDyOhwwu90DJ2YXCPyV2KtUuIJ8Q92iYn3AVByid/?=
 =?us-ascii?Q?V0VMVw9909Kul/dmC+J6b+lyb+2pMZd70q8F6C9wmFu5xn4NZ1NT37qOsKg1?=
 =?us-ascii?Q?bwgO/BhAZEAWXG8WCZkxr71uYNhPYbT0hlYM8+TkybQ2fFsxWXBf65bk5Alg?=
 =?us-ascii?Q?j8r+VakMTB04hfnEbJd8v2G2+DiCjYrNcT/cXqr60NFD2iokO3pAS1hfKY+L?=
 =?us-ascii?Q?pTAIVowCiuli7MVEW6epPxQMI4Zt4/I1/JfjKUwKmP3SYcTdQvw4r8P2Xijh?=
 =?us-ascii?Q?AAfz1OLG+tA+jJqhDm1Xk8A2KeGZ3nXENKPtwBgDvKEjjtJZ1n/f8wbUqRhG?=
 =?us-ascii?Q?wBuyCz/Kcz2AX7JT2Z3iiMqpEkK8GcR/8DAPjL49WdQhHbzhBUt2lBd+DXYp?=
 =?us-ascii?Q?10Hs25Lpuc4n47kC+KVfSY43uW4CiMI36x3zFu0MnSHDbB9fO9RSAtrrsil0?=
 =?us-ascii?Q?vn8zVVVCnFh25981nJMj99QdB5WFbFn20z6wZ1MYCuUuRBS7gRvuspdjwhWk?=
 =?us-ascii?Q?wB9c1hAcjLteKpiv9mfNFJt2HJZV6X+jreuhUTVwfCXRc4ziNtahASPokAwz?=
 =?us-ascii?Q?z/UYOAV76vdRGNs7CdnPJH1aSeGokg8P5XDzxjaVtWjfRmwR6T7n8rHhvMEc?=
 =?us-ascii?Q?N7DjUBTF5YqyJ8J9wGHdx1/FdPUF4l4Yr3St13/zOL4cFXWpOvjccnyU5RD/?=
 =?us-ascii?Q?LdvbWidBmDiag2kK6NzDgpKc?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd92cdd-d7b8-45fd-b060-08d979f15104
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:39:20.5695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dc9kQtsZf6HHiaajxBdsEB1eTPh/Cd8x90EnmRqkPZoYPPaP4Hr+1h1S2hWrOPAO3rYPB/8IGpIsO5PUystwXwRQYu7tNbAincadMbTFcPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating ocelot to use phylink, a second write to DEV_CLOCK_CFG was
mistakenly left in. It used the variable "speed" which, previously, would
would have been assigned a value of OCELOT_SPEED_1000. In phylink the
variable is be SPEED_1000, which is invalid for the
DEV_CLOCK_LINK_SPEED macro. Removing it as unnecessary and buggy.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 08be0440af28..729ba826ba17 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -563,12 +563,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
-	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
-	 * reset
-	 */
-	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
-			   DEV_CLOCK_CFG);
-
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-- 
2.25.1

