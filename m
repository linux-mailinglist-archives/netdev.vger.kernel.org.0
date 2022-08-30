Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68D5A6E02
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiH3UBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiH3UAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:32 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C2E26118;
        Tue, 30 Aug 2022 13:00:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX9fUD/AJ9Zo1yw6WH7sfiGT3mxINEgfI+iPlh/CF2s1TeR6cZqLM6r7lbz7iGwrcqmhFhROk6IPqzffLvZPlCEJGunyMQyQ3XS824mtj2cYa604kyUAsDD7eikxEDlXhHw/UfdHOo4qDn4j1FH4iPMZIORUAu+Ye82sI9nR1ubuA0pTGwpfu7uYr7lvxqgKwDhqTajyDgTJVxqMpfmYawh4GPYQfo/nt869K8KsbQS8GRqnW4ZYWBeMaOsBS9TupzMOHbA30pdsmrUxiDF/7ypJeE7sGVmb3gH2tSWHbFYWM9/XDricctoL4aFxNklgJtY0haL6SdHTXIWXyvAqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5h1VvgX8MF+zSQTU/wgwjESwnjvrwOu4/+TM8gKSDzw=;
 b=gbhHSmufoxGQgIX+NtuNqr0cuiL5/4bxjlz3XoqADt3MaJ+h1gISHGlGSd/LO3POEtdOWNy+wHInp375HMImRQlue6fjUkpoWXheBPq0KXXIyhOndWHx/EPb4HmwILt72MGLSDM8yBk+2yQXcDeyDZepsDEcDB+siC2bRVrB26hkdAvO3N/I/KVjpypnRfK+IfqgZ/hOJgZ3bNP/PCSbwUMheFrAuXeqEfDEibUzFC3QNot52xXLyNWlsHWQdA9ozjWalntWfM+jpwH2RPiEfyPov10qmJ4laUwLyScmntchX1sI1hAEZA39NuREq9DP2DYhHtDxbIQNobXLh76wcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5h1VvgX8MF+zSQTU/wgwjESwnjvrwOu4/+TM8gKSDzw=;
 b=nzxdLwJlxaz52/2/lYTwiJO6WrJcLsCVC+yIx1bWS4sc2O0gkHJ7rEpP3d6URh9dexBA35Y3zo7bjkZgXQ3zY+rydAqChavULHjibwMc0/Ar85VAgo17NCn45MaBbdOeyaKRFD6HuvdzF50cc9KCBYPY2Rl3abmTo+f7udWw8hc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:52 +0000
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
Subject: [PATCH net-next 6/9] net: dsa: suppress device links to LAG DSA masters
Date:   Tue, 30 Aug 2022 22:59:29 +0300
Message-Id: <20220830195932.683432-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2a29cc30-7549-4d07-0ca6-08da8ac233b5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7mMc6YbL2dyR5Dlgft3HDjQL1R34c02ANXzZYtQW7LaES2Qv256F/ph9lsdx63F+WHKvAUbCwh9/cBCNi2vvI3PTw0SEnYB/doY/+FgMZj90LXrlIS5COGEWZHu16RkJ2QwmsOC4Rqlb5N2a9LdKK6U46YCzQUj0lxfk3m30fqfUYQPUl0MFtwDmjr+brzTucNvHESnVSsNwqZ5rO1HuMiizDVFpumpOiAOF2OIASZoFEvs8XCt9eqsdR9M/A9LjGRezuYqTsZPjrZU+4mpsdglenDh442HfvISrxkfAneYNI1by15n82KEf2GLwMH48s6SvOT5/ceBCrG+IL9wDaaOQm8ns71Oin2vwz3rxcJBID9y+YAu3QaFxjLkev9wl8JS5GSUmdyy7CrUhNur/BQJfYTcHelinRaB4ydPD9SwlfrByGf4BiCuV8Iqe3+KqXhctKrSosn8h5iFA0C1/U9BbMLzVVm8jtf+ux2+jMP5D22tN1lFvbBe/LS/9wV4t+l6innv8doyAdeAHgktFVgJaCQmIAHpk8tkdCJEu8haeVwhKXj0/AV6uOZxpD2L0SgLtn6fuZf7acXb1IgkC4kRU7w3mBlGi/+uRvNfjBayk7igNtXDaYeVB6FplpdixkkKk2HrWOIqIspxrGQymGFBlafP7sCcpJUmKuyFDyWdiT0umt4CmJYh3OsnPG54WWb91by17f7z0O8Wr7z+VH1o2GVZGnDJfkyB86QTlgQLV0DGoKsBBgSXV1Pcd5Ao
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6LEXVcW47Vw/cPTf1OpT7bGSXlQKhSU7a1duPde37Tt8n3lTToEjJF5zasRq?=
 =?us-ascii?Q?bkQ5n8jJp4p6kt2jJ/fyT4aLdVSwmKehO7J8tJvCrewB+urEJAujlcljr3TY?=
 =?us-ascii?Q?WWInl7cyXxBqXysRlVEsytIaL9jxULi35HfnUhx34rFRLbv8fUOz81Lf0jPb?=
 =?us-ascii?Q?Ybt9EV6aVawbUuQ4/eM/TY8J9l3HcodscYbqGAS7qSJPCAe3/cavEajt4oiw?=
 =?us-ascii?Q?5wtmH70ea5zUagxgXxhjzuThUt/b1sWpaNYsvoxlgaLiQlP+uJXy6KFl1mrR?=
 =?us-ascii?Q?XIrBvg/Mg8OEv5TiXJO+y4YTtpoX2iALK/2nz7CJrvnKPYN8Wq7jVBqrCEFX?=
 =?us-ascii?Q?5SZV+fvdbbSMAKaUrRg9oseTqFe8+9rIf/rzwdUUaeVwnH4WJyOSLuPTMV/S?=
 =?us-ascii?Q?yQOs8fOTfiP6KfETXsWbeEeQDQJrpJhh3eDeJ4wwHMi7EHZ+SX9LDYB/yKTu?=
 =?us-ascii?Q?qGKGrNj0HaJwvJNQRs/NlbRCuQejU8Nz3cm9VOiIN81Rn8fLehs9+QPJmMl5?=
 =?us-ascii?Q?DZn2jkX4yEgIQmiT3CRXk+iiWLk4hgI5MWlU8unkOTP+MFMy954OrQ/+76sX?=
 =?us-ascii?Q?E8J7yHlURgg1czX8Nvwxq7x2GThoLY5mfpqCTslW0E4ymWUVE123faHU3J71?=
 =?us-ascii?Q?zpjPZGQeoWeP011o4vHA94rP9u196UYxi2jWcfn8MkTLSIFGGlwkADKAe8x+?=
 =?us-ascii?Q?NT4L4wOyp6pTpZz48E1hNoTijMTVxTww9PGZypqTxC2zusF1mbpNqDX5ial/?=
 =?us-ascii?Q?SdKJxTiAvK/44vamyQJK6uXuBzHvmmigytTZhiZEOE5j52blQtm7eaGGgNKp?=
 =?us-ascii?Q?kON53d1AknE9j7qZESIje9YCvI6istwYLhhVaVFS0fq+rKyMNhD1AWCCj2J7?=
 =?us-ascii?Q?o5jdS7zq4Qu9y5L4OdPkjfD4ghvhLBCq7MQyJMiSBS1mEeXP67pA6R4J5TP7?=
 =?us-ascii?Q?qddIwXbzBCdxTdy11119acLgPaRaCOS8b8j5+Kclxc2oPYjXKXsVGU9VF2Zg?=
 =?us-ascii?Q?ArADQid/kS/7t5xTybxEJ3z6uDbVWHs759NBXT+9fDqRK6/MZ4ZlMTpJUgH/?=
 =?us-ascii?Q?h+gffdihAJouQAB6hido5RS6FpeL6cZd2r1jIRerZoOhWESvwbqvOmIM5VDI?=
 =?us-ascii?Q?fWTg8KDhWMfyIOt346gMDeC+ANOQ3eXLoi7DDXglGWzoNjRDod+v+OD2Jmbj?=
 =?us-ascii?Q?5nOKPVzvuLOhFDy8UYPyVa912HVfVvm2+JUjaVA3Y0EZ7Ey0DbzQgXoI3OMD?=
 =?us-ascii?Q?0Aroz6pRO4cVxQXedZDyYK+lahQ8/5lIHoQghwqpH4hWGMVV/EiYuKP0ZOqi?=
 =?us-ascii?Q?3ms209BDRIWp0xRuxZvHz3Ia6o1syDagKF6eY3oAfInEGescM4/BYhIeHfFA?=
 =?us-ascii?Q?pyPuGdva+vnDmLaOykWOE1Rr62ql1guaEXHOt4Bie6y3ilCbu0nKmvLNxP5A?=
 =?us-ascii?Q?Nf/x5Th0c1TVH8l3ZnpSMVT2QKendkHG6wHzAJkqtL4xFby0EPbJhUwISuQ4?=
 =?us-ascii?Q?Xfii6nTxI+ieLyoBEEYTpfeKdvh0WIx8fYWYg5+VinSbCUtAjEtC3Q217soO?=
 =?us-ascii?Q?+S/sxzKeTdoTFHJyvBAUZBpG3mpZSGA5AtWhWrPFV3jUPr6eKLZeg5tMqfLk?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a29cc30-7549-4d07-0ca6-08da8ac233b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:52.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzOpWh0kyD9v8hKaycQliaunNsjklcCo/migVX+XlKLZN7wTFrxbHz1Z7sLHlORwqAfjdDsd8cNi4kCq2ArXfw==
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

These don't work (print a harmless error about the operation failing)
and make little sense to have anyway, because when a LAG DSA master goes
away, we will introduce logic to move our CPU port back to the first
physical DSA master. So suppress these device links in preparation for
adding support for LAG DSA masters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 99d773b24223..2176c14b97a8 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -364,12 +364,14 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
-	consumer_link = device_link_add(ds->dev, dev->dev.parent,
-					DL_FLAG_AUTOREMOVE_CONSUMER);
-	if (!consumer_link)
-		netdev_err(dev,
-			   "Failed to create a device link to DSA switch %s\n",
-			   dev_name(ds->dev));
+	if (!netif_is_lag_master(dev)) {
+		consumer_link = device_link_add(ds->dev, dev->dev.parent,
+						DL_FLAG_AUTOREMOVE_CONSUMER);
+		if (!consumer_link)
+			netdev_err(dev,
+				   "Failed to create a device link to DSA switch %s\n",
+				   dev_name(ds->dev));
+	}
 
 	/* The switch driver may not implement ->port_change_mtu(), case in
 	 * which dsa_slave_change_mtu() will not update the master MTU either,
-- 
2.34.1

