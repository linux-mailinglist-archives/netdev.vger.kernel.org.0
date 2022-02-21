Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDAF4BEC90
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiBUVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiBUVYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:37 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B3711A24
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBswUU079wL30uRtQLydDZd9OhGruL1E7RVuqlYGmjK2ugJ+SugtOFDwnrSQlYrG93QD/+dTSm7872iY6Qr2jZiCof62YEmsBh+k1c3ISOPqra3wyZuwRt9YiV8OJFgmw335ZszrnA0ghEWiRWeTUrpWHBZP2dUiS1I/GcBSnHakmuFYdh1toKr+h89dR0F2xho8fMpPNSYPQcx1YNH0nWgWinh4JcvkB91MdmyUlouqiBhdjwrrZj1hQ42XDB0pX+cDrfEAbxBzc3p61r0mHvUdI1OsSQaMGikca8CRqTN6dCaC6nZIYNUBT8tx3RXoZ+CeD7bUnInP2c27vcqhRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zh1sSItsS5zlzSOiv5oq68QWYeWJ2EoR8kRSBypW/g=;
 b=QUxJ/l1HwLghgqX1NkGlpKojMlW/ztVHsudBtc1svQxmPFYg8rvkTNH05b+ouSXzcR0E1q1+xQuYYhs2NrunP55m1YotDp/0jElt50WoU9UC4oCjuYTZy0QhfCcQjBLYBVqJw1U/NtDVg819ANzEmf8+ZZnv0JmNQylskm3DBK8vo7lgtgzVZlWEY/L93oWkGT90sGO2bArCUtaKBfyKML566TtYvD0wSwLQdKloSEn7tJL80OU+9GQbN7SqEqciP8DUddEM19Z7LjJIsimb5/aonpsLwjWpW78yOvER4oMPYoot8/Hg1QYLvvriYrCkAIew6wxDq3hh03yXey+7Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zh1sSItsS5zlzSOiv5oq68QWYeWJ2EoR8kRSBypW/g=;
 b=ruN0XhLeUpSRQMoBHJDq5gNeuTvTmwkLhJfXcDw7vUbXiLMvW9i3pAypjzIXGOHv7qcxeIhV42okOIlS2ZhpJbGw/4hfCc5ihJSecgoTYb7sfq1DoLJXus4ypZ8Tba9GB3q++1ZZNJtz4FzVHTyFnousar7Va/gSYl5W0OoZ1u8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 05/11] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Date:   Mon, 21 Feb 2022 23:23:31 +0200
Message-Id: <20220221212337.2034956-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb4a060b-45bb-4270-db77-08d9f5807ee2
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5645EF092BF47AD69F2A9981E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnMXZzAgFqcKo/Omm3bq89SJ2uVYppnA9j5SRWNo8c9vsOeyWSKn+bLHQI22VXXc1ZLlqJSgAkfCtYYlwDglwlYAuVyIpQ6ads7ncPbZpu+kcmnMYbK2iMZjjQ/lWEQbA7TLx5AODI3EPUu2WBXG5L6SqMH4WPEWUEEOh6uCdbJxkL+5F0NkFlk/yR/i6P0Pj+LAcRyjd9meYzAimDgwFLxoG+znYx6zIP+i4Fho34CJqoBVw4ZztGiQqnd16mH9M8K6C9ZBwAkHF47S5yRCV7FYSqeCtbjrCajbfc7tVpm8XaSBvBy/Y5IlcU6mC99STPx5k9s1ClDOgkUPc5yhKOelLtOoDWeYdwcYojovDDssOWB+MmUf8uYt/jSS/FjbygcJTCWAXHZVV1N7ABEZQHHqOF2/zpp5qkXAV3Rh+uldv7NVjWQ5pNSEhNHrVcfVqj59Gth5uaNWM3B33cZeLLZotkCjC5J7JF2lycmCZVxGSq00vhObglMY6B1F1PDfFQlKvJPkSqKv2BKbFxAW6ccVIFOoXuQHTwl6hsF9X0iJ9cpB9zDR11ebqWG66hLc1wbga20RDVLIoWwr1r9WLZ54T192xcvfr0pIEQatEFHsbhelBBFIcYJxeL02B/k+raNO854/x/a5T7Cz/5IUHI/SbBW4VxFpM5IYImKjcRgzle3tokwHyEPC3k/taEhZxToh+bMmet51RxhPQVZdbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(8936002)(5660300002)(36756003)(52116002)(4744005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mbkdTp0GClyyc66zdXTiV+kbdu2T831m72i44Bx58ZYFsOXh4IU8uD8FHh6?=
 =?us-ascii?Q?hToPXpHc9a1psYZ6i/w8Y6F05cweS34/rV8gEL0ZJycOE/SgLmS+HtelrVON?=
 =?us-ascii?Q?VJgez/VW/cT69E1XRWTbAxts5ntz1AOboKdAC/f6epyLuN9XaCV2CDY13pID?=
 =?us-ascii?Q?qhB3Ba6V7dj4otxM1XNzk0zPmJaiAz2tmP6GGDlJ6hMmnn+qYWwnFtGHvkbv?=
 =?us-ascii?Q?5bYJ8jMCHFWb5Z3AvvOS6PrYbV9PTfGmYHUXREt0RLV+Z95AigFW9ArNc1VR?=
 =?us-ascii?Q?N0LOcJMHOpMZ2hH801bkryxJlUyjeJSssVJmAt6n1eli0hMkKcMt4sE3AdTo?=
 =?us-ascii?Q?QpPL6SDPSOYBjXxcVtx4wfZSbgpWlaHn6hZpOrmQjcBtS/X9DpeGrijs/at6?=
 =?us-ascii?Q?sPnFHQKbKJgP+W+sTpz71txLCj7KTBJhx9xtG/ZB3mQwqPNHd6enqE3sKj82?=
 =?us-ascii?Q?4BAuML9AQIrQRT++8fXvlWZHqBhXOTACCjVrqS/VbxYTsVt2W92cSPtA0cVp?=
 =?us-ascii?Q?HQ4mUReXIP4wR5aPo7vJzhc3isO+6QWC6wyqlysExx5UrlXDSngNfuYsynja?=
 =?us-ascii?Q?aKNG4LRVv8mEB/USPnNINw4c9LZHmu8YXDwAG0NXz1AvHzpItrLlQLL6zUCT?=
 =?us-ascii?Q?zlXGdQWxUuBBkkhAPXXkjn50RxqYD3+SsiA8Ya8+VQCItux+z1ZrzJzzhZVc?=
 =?us-ascii?Q?ca/dVX9LaXh3lw5QYtFFCjALv52tr8HbontciRBOHKJ0jl+HhBmP2oiS1afp?=
 =?us-ascii?Q?lymyLZQKDsOonjuz0bDwjSluK9P72IsOqZ/fvVJZz+o8T+e3sQ58f/OGdGsM?=
 =?us-ascii?Q?FvjAdY4VXfS7wR6N2bb+6Itzhe+MmuBtqqV7TQMzzgk1YfwUA6UWCE8IFEPl?=
 =?us-ascii?Q?fqo4CCh6RVXG6HaG15kPBJbLd4waJWMhSHITflfTlvh9bX6ls87B44XPbgac?=
 =?us-ascii?Q?N6DiZaBVcbt6iQcc2sGi51H5eq9n6XuvG7vAZeWkgTCduPu5AzFC7YY8jN6l?=
 =?us-ascii?Q?IhmBfmnNlbYjRIoorvla5S9vQIsoVQo2MorqNPZIJB0hJZTFN+GFGo07/1rh?=
 =?us-ascii?Q?640tJ3jthO+j/8q7w9itO+oLfetg5LmYr7yNyhCIyBsV2fdQtsdEvEK9qqds?=
 =?us-ascii?Q?1nc2U6lhpeYMAXU4e6cbQ15Cu0pFX4C2WRP/aivDt8Xall5BPxQ1JpFihdK4?=
 =?us-ascii?Q?02424fTQ65tI6Oroc5gczVi+drdsChAC//vlHoQg+oWWDc8TjOGAepC4IOia?=
 =?us-ascii?Q?pszwVmIATUK0Zx+sjwjbDko/lMJRuFlzWPtfM7bA9EhOnp2cubx9w1H6QZ4k?=
 =?us-ascii?Q?eSuJkXexNidLlqdwd3ZyI8AAat5y1ZWyNH+ZZ8FMw59hHLhVWsfSoNk2bv2W?=
 =?us-ascii?Q?7j+9Yznovzps5/g89gSdH77cfH93QtZDOXIBKTWghC+aHnfh/HrNXTpBcgNK?=
 =?us-ascii?Q?cCro8SZVt1Sl2TSpnwvQ3gUkrH2fTBAmbu2XHshNcg8VDO76begzUE0i2BsW?=
 =?us-ascii?Q?mh3XdENjCyALQ7xgqrLBQnsVoIQwxpU09fzwkG6cZ7xz55pgWQBiGU8dfKk0?=
 =?us-ascii?Q?9/WcPqpZGM00a8CwnBhub5eSUUsleobQxCFqazuFDCrgM4SuV8ldVHDrDas1?=
 =?us-ascii?Q?QuUsbevJyUg0ZuURIfTG4Bg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4a060b-45bb-4270-db77-08d9f5807ee2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:08.5394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDn/QkgNdsrzsIZuKUfelN9MYR244SDuVGCFDlfM0r3UZ32GNIE4hvRHo3ih4E07oGrsIoFPLCaMfM6KISC2Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the intent of the code more clear by using the dedicated helper for
iterating over the ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a4f2e9b65d4e..d96db9825033 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6273,8 +6273,8 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (!dp->lag_dev || dp->ds != ds)
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dp->lag_dev)
 			continue;
 
 		ivec &= ~BIT(dp->index);
-- 
2.25.1

