Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14575A6DFC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiH3UAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiH3UA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:28 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A7F13EA8;
        Tue, 30 Aug 2022 13:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m54WL4FiihAuMpUQWEL9jpzcPFGsc3KlqCBTKS/fEesa/YqT3v+T6pUxiIqT+1TTbIXmjqOKjVErvxLIZKrpexoQT1TU4Rzw8BzSCWny0PGm9z7Z6OkQmARgGBjhEJtlvbPUy+XDPbV51JPfa6IhezJEWvAe+mqpSfdEyYYj85W0CtHKNtUwrn0SQrV/nWzx1viY+2INHyXKsGV+skD0e7T/oqPduqHXmg03ZdoQggTVkdjGVc0L1vkBLdeyI1sciuQ7WbmAn0c8TVmUUIK+0h8WiUDmvOBT62pRe6tFAHFVrHVzNs02ZOH1LEKvmlQtwdGq5HqtZbiQfDdaJSVPaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mL5mjKBRvIY70vaSvhVtmMzpXm5fpwReo5FvIBE7zf0=;
 b=VQQ90FDo7bvy0wB4S4bOMPvExVNpB3+uEPI0zymYzogRgP2fR7394wj8BodZQOtYH2SGIcnWuK70o+KQuPd0pKDhzESDuETeCbYUDC6M2xaTbk8VzYnEJsxJw10Yc/E9Z5sP/O4tbcOcraSsUbePMD3pSkcCmyMx73PByJ+ZJ829B91xhJD04N6Zu5dXph1UlixtoD2bbFILBwBix8FTXK4r52KZPkPSO0E3OhIFBcZsarCksy1m8Thzo77e2/4bteRQxUnPeLPYpcE2auyOpazFrUH/AJ+kP3iUBa72O9OMPWeUOXzSwIjVvGDiOHE7uEQljLv9zocG/EP7FvUSKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL5mjKBRvIY70vaSvhVtmMzpXm5fpwReo5FvIBE7zf0=;
 b=VP1qxZQ5a6TTgj77rjfPeeJitDsL4M/4w26+9zTcTT16DA0n+X8WDB3OPvl7WBIm8ojGcAbB6Jp8IB5xYVY70pLxezHHcVy4QQwVb2oRM5h/ApaW52dFoY8ognG+k+W9jFmr+NHzyre96eX8cZ+X1dTLsEeU+lA3CDRC1iXHuiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 4/9] net: dsa: don't keep track of admin/oper state on LAG DSA masters
Date:   Tue, 30 Aug 2022 22:59:27 +0300
Message-Id: <20220830195932.683432-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e90047a-8d31-4cc1-4119-08da8ac231b9
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Mzz6JPZ6IPIYWypeFccDohEqmfMdFlDyuPPEvqkQgXBkh3rCUgDt5+0iAUEupUXjQiSe8MdbBc3zzq/x+4JaIRSErfGtq1jjaXjcBEl5M1tS4pp4mpe98OLz2rwiOX7mzDtzbqVv3O8UlypqQI8sTIll4T1COwx3na+K0SAk02xoO4z2ZxfHb+umCPcNp/Dw4/QnnlTKedJPWWQhAG4lf0PYyLPw7ZdIPmqo2XiUc3TNYp7B82IFytAw3GH7alAd5jHaDzaSfxkSUc0bC2LprERDfjMxo3aTijlT3MPttPAd8/h0We7g/SHbszdP7MujwsyVCirEX+5phVixoGglcs42gW79Sij5RwfnxERIbAIsDDhFzvOnoDOFEMPp+lROR27ILCmsADGt1W8WPN+xnxlR5fGjVGGNj7tTJ2pUGq6wWkWrdRwFHOldoIgfz0re0uWhADblj/r6a5+pXfpluRsN1+yPPJMBrroNSUZg9GBF07oXpdsfL1wySJ6YVNcf92Yn01WVY6545LarEFyMnFQ6zoMkPeUSgxG6d6o+BCnPkaY+3UeitIQv82ilqEMABLPo/pPZX3mFwgrWbOntr0yOjPBibA+aJlQTf1DnIvOKft4a43D5DIB4RpuELovhQUPy9BC8KbiwKwELNOVoIyI+E7YENi2CyQvY8P6qDWDn1aJo2mSnihdQZboc44cNQhJcc1sxaSWoGH4Akx7gD+8BHDfxzW4PeNzWtEP+VwFPaIawJedwHUvbZTIjjBys5iMaU3j9AROxzX5LghJxkh4JeV06LFMPX1vYsQzJoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(966005)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w5RL+irn59uD+uKNSNEsuJzdisaakogbHgylqcboHhNQPhbSfA9p5cHzhgx7?=
 =?us-ascii?Q?gWGlp71WdKfeT1TW0Lg4NRIFfSNXHGppP2gQJ0ZyaKtdNh5Tms7qDhi3Jw+w?=
 =?us-ascii?Q?RXFk8O8es4mpfUX65DGX81wXFPz3wy5+J6SjldtIkCmCrnxppsnz67cy6Kqg?=
 =?us-ascii?Q?aBL27rvgh5qY1fv+4n147DCtpsR2G0pxJUte+8fzvHd1cSqLoQ/gkpcc0VuR?=
 =?us-ascii?Q?DPd+JYFDT7eZCwTPdtHUIdlAJr0ajqsnfTk7E/um6jw+x3WvMsQANLqeu8a2?=
 =?us-ascii?Q?0bSZv0D3UVAlIY08kaBKZ3fcPtUifLVykmO5cfRNfvrWkgrGe0W3iYC8WIIL?=
 =?us-ascii?Q?+qI6zvLLocVT+Lw7ZWVdwvQ3MGTiRLUrfOfRkK7VttTIymSoMtReQlN6NqbW?=
 =?us-ascii?Q?yovv41C8H+7azSgyNyja6Vwbyn0zpPYOO9ZWkxm9iLhv+n4vn9DF5WtMT5SS?=
 =?us-ascii?Q?HFNsiZuyTQnXSSVxhD0aO0AOdnWRwUkZIKJ80SRW67MG6x4kHZ492qIWxxRX?=
 =?us-ascii?Q?r1mBb2SA/I2Khrg3H3hYjoYHJpJ4o8JXh78173k5ShFlebDSC8KOB+VDkcAp?=
 =?us-ascii?Q?52n+eSGr+tFW33dlUHYK+64ENXBD2ELyCFlPYUh8LaSy4tpq64EULzxPll7o?=
 =?us-ascii?Q?yAxLEa/Im01rVggIqrylHEi8jKBo+H1tgb+d9ie64EUXb/UCMxAiv0fBY0n5?=
 =?us-ascii?Q?BnQZOk9yEyv3JtPCARTlWUDGvzvvJ1MplXfNjw4uBFk7Yo6qzjMPuqGdu9nN?=
 =?us-ascii?Q?M44FCnB55aYA7uA9G+fI0VEI5o/MpvlttZKCtzs1WtyHz23h35uNb5puh8/5?=
 =?us-ascii?Q?t09k9J1EFGCjWaKnm/jeXih6L763tq40qsZu7HKYtBlJ+HBiKOcMyGMJoGQY?=
 =?us-ascii?Q?oXbb97GkUej+kqbI/SHp9XwibuEX9u0JKzfuhMYVaMPhhr4MHBp8P11nGtt/?=
 =?us-ascii?Q?kxCCEwEQ43Tpds8X7tFCn2sLaBFkzobedzhE/rPPk1apVey+AWgmtwp/jnk1?=
 =?us-ascii?Q?zadc7MPGromYA8JcozSawmi0Z3eIwzIjwXvLkBpC/SpIkvfvxrrdV6VE0Qat?=
 =?us-ascii?Q?PZe6rkwe4rMmlET53FFhaOSOD08X6VEs/gY1b6PpmBmBAxT9kW6YCnXOcVPM?=
 =?us-ascii?Q?IymphZJnpq1bRu1u6BKV5wSuIqbvHWbZ9Jize3ObJnWFGK9AYdHZ5q2NCGI/?=
 =?us-ascii?Q?5+78FEX3X30IKMLZNbMTLtx0cmM/47ri7JAKB6M9oNPAnuRr8u+rVOsuCFM9?=
 =?us-ascii?Q?OieMjRgo6pfSmkjJTWYpUCXWqBXKDje7a/yNP3P8QjIYhc6xwMm5mI8+0gSt?=
 =?us-ascii?Q?GO5z36hDmVYrR41w+XG0YBYlC+U+VR9dZ2pqx6OiSomhCJ5jdZWA26mBv9wr?=
 =?us-ascii?Q?Df+q5YiH3GlYZ/AlDZ/SuxnII0FRlS0S1mJCwjRJOgV083xS9FMC3czx83KD?=
 =?us-ascii?Q?h+Vo1jZLqANLsgvQGnlJYr/pR/4SLZelGv8/qW8u6RsC26Lh7n2CT2OGHsAc?=
 =?us-ascii?Q?FoauDSUcDOHWH1N1EVAQxKAwJLTK22G0gULAbLQKAeagBmxlOb2/KlL73Aix?=
 =?us-ascii?Q?rK2JYxwSulaPq1ep+ftl7C8WHcUeOh3X912/xVhq6IqW2HvZz7BH21u/6TSP?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e90047a-8d31-4cc1-4119-08da8ac231b9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:49.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8czUwkcxeEXg6edZTYJZt826udHGh8i53EiRj920wTblsV545XuZDu574Gl9bFMBpwxZfIb9OLWCJnCCYuXggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We store information about the DSA master's state in
cpu_dp->master_admin_up and cpu_dp->master_oper_up, and this assumes a
bijective association between a CPU port and a DSA master.

However, when we have CPU ports in a LAG (and DSA masters in a LAG too),
the way in which we set up things is that the physical DSA masters still
have dev->dsa_ptr pointing to our cpu_dp, but the bonding/team device
itself also has its dev->dsa_ptr pointing towards one of the CPU port
structures (the first one).

So logically speaking, that first cpu_dp can't keep track of both the
physical master's admin/oper state, and of the bonding master's state.

This isn't even needed; the reason why we keep track of the DSA master's
state is to know when it is available for Ethernet-based register access.
For that use case, we don't even need LAG; we just need to decide upon
one of the physical DSA masters (if there is more than 1 available) and
use that.

This change suppresses dsa_tree_master_{admin,oper}_state_change() calls
on LAG DSA masters (which will be supported in a future change), to
allow the tracking of just physical DSA masters.

Link: https://lore.kernel.org/netdev/628cc94d.1c69fb81.15b0d.422d@mx.google.com/
Suggested-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 42422ddea59b..7024e2120de1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1326,6 +1326,12 @@ void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
 	struct dsa_port *cpu_dp = master->dsa_ptr;
 	bool notify = false;
 
+	/* Don't keep track of admin state on LAG DSA masters,
+	 * but rather just of physical DSA masters
+	 */
+	if (netif_is_lag_master(master))
+		return;
+
 	if ((dsa_port_master_is_operational(cpu_dp)) !=
 	    (up && cpu_dp->master_oper_up))
 		notify = true;
@@ -1343,6 +1349,12 @@ void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
 	struct dsa_port *cpu_dp = master->dsa_ptr;
 	bool notify = false;
 
+	/* Don't keep track of oper state on LAG DSA masters,
+	 * but rather just of physical DSA masters
+	 */
+	if (netif_is_lag_master(master))
+		return;
+
 	if ((dsa_port_master_is_operational(cpu_dp)) !=
 	    (cpu_dp->master_admin_up && up))
 		notify = true;
-- 
2.34.1

