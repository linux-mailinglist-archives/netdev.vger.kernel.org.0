Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265944DE210
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbiCRUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbiCRT7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:59:55 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F6418EEB1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:58:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzAt5gZbGuOZa/S56r2PqgOi4fSYKlblItgsrJE5U7RPH09O/rveZDXm/QdKDHqhANU6fAiZt5+B+xs8VjUDK3ce/yZZHC69lfA8Sy0TnON00lDJHlXCqKjMUt+gXvxK/awa+EJu25/5bYdNwT1rI2kPpRd46V+QfW+Yrv6D05HzmOQnA2ewDPtdhqeiiEuh2TGEFVKZuSIWFVc7YNtjgRW7BFH0WCHdVrO8MUrM8XCNgTUWhIETRZqtDa+1eR3FnTOvjb9ldrLOKoo5W+mPPa4Dy/zD72jgRDQsnof6yErwhODcqs9MQgRcm+KE3omlsTIxcRjIaapdkS8+XHjzWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K7U1BioBZfkxIXsf+JQccbcI/IJ1PuT3B2wtZQF3eyo=;
 b=MK9bo7z96gONaEreaZwfWlE6yrDHkaqPN687IoRiYvd6hAuDVFhBmLAccxx12c6FQtpGVHwpQPLej9SQcIHIBIlrnmJxFbkm4Czg1s2Cs57vSDSSA5rdt26yskpyiItjJvYpsieIiawD6uUrpOxt21SW54BLWZq1eOQh2L3iitO3WFmHa1S24yCfsyUKb03iCaJftrVJrVdrRP5wVkYmNaN3dfLxzzbk91/0vUoR4CHHVVAhvOFGHalFtcJq9LSFGVpwY+cfQByPnL/KXAYqj9FZjuIfI9CGNrBvpmRpErGJDWFIcIYWbJtDv+B9SeCcYwO8qmfY2wGGgNNTcf4nEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7U1BioBZfkxIXsf+JQccbcI/IJ1PuT3B2wtZQF3eyo=;
 b=r8IZRXys99VXhUT1vnWwaaD1wXNdsSL/KiME2ArOt+rAQxv192AemoDhd3Qpw39E6PhZk4git3pHmxLL5UgNaNj3t/zk5VJhBW0am7GYS/tiAl35EmdQfKVL1BZ+/C2K6Sa5nHj3sP+HsDfw3pjywJL4qbNhVZoGbSe02NCvbVE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8110.eurprd04.prod.outlook.com (2603:10a6:102:1bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 19:58:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::de5:11ee:c7ea:1d37%7]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 19:58:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next] net: dsa: felix: allow PHY_INTERFACE_MODE_INTERNAL on port 5
Date:   Fri, 18 Mar 2022 21:58:12 +0200
Message-Id: <20220318195812.276276-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ef9569-e5de-4640-491d-08da0919acd6
X-MS-TrafficTypeDiagnostic: PAXPR04MB8110:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8110EA762D56CBD6FD9D4CECE0139@PAXPR04MB8110.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWPI6HNtr3dDInw7+UbHXHG6ay1e+YGspI9zjkPU+Y7vIzzZAc8kgN4ZFI/YSXBfeiI4A0SZ0yUshElw+iO3Xgqb8+ltNSZj4anPCw4l1dUlbklw1YHOLC0AoQCXMKoBGrAz7rexHQybdrU9BtkPkvqKX/IBV9YeFNYz0iu6F+q/BhUzZQsqSp/PBhQlvFZy3RvPFErDdYxVrxshRZ+iOnOyAj5vt822Ufx6UaitpXgtlevrr1QZtQG8Dpn9RP10SGN2V02i5zcNSWONiszZv4MnJpCVlOSDMi9OG+pW7kNlM8RI+N69o/j9GEaAXa4PvWbpj4FdINUw6jBYSYoqxJ5nyi2nhFDhFq6ZUMwqgCquvxUfl5f7+ZkrPyVNTue+MZwrDYT4qMziDGhCJpBw9MP5zrgDD8J8ax41Vvx/5l1SZ1auLlOliym5gx/030f0KpbHRFetTvo3c5E60YIEgNcxxsI2E7FaID9w0aTcHHmbQj3AG8mGbSYM+AAzdG6hNLo3gtwy1OUR27Ie1KGZcuuXcrCk9eGICnSN0buBayZl221m5ec4/m+DNFIjBIPdcMlkYUeJ/lsBDb804JdpewfYw75p06QIjRqp7qhNFz3cQZMHTGyIpWwm24bA9mIy5EC835kCk3aDG31289YvS/QXo5dD9hFwJ+TvJzGnUWPUPDYv1BqDl0zfaZSTtyjYNrMbYV9irri1XwLDJSvs3dedGF3lyxLGMrRbsonOrqkvleNDxsWHRqCPhuQHsJ0eIpr2YxeMH8VYc7Mxc2SKMkSvu9oavDxUlG4Yz9DAxog=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(2906002)(66946007)(86362001)(44832011)(316002)(54906003)(6916009)(8676002)(6486002)(508600001)(966005)(6666004)(52116002)(6506007)(6512007)(83380400001)(2616005)(1076003)(26005)(186003)(36756003)(8936002)(5660300002)(7416002)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qGFYvVCWr1zDl66zNyee687HTQs4EwzPAfiWdVvhAPYcG2theMoKwcFoqgw5?=
 =?us-ascii?Q?U2m/qp9qR6nc22K99iLmoaI9pOIth7Y8eaeDVCc8lvWwnFdvDmp7PduWfo5e?=
 =?us-ascii?Q?wFtfk5yWjV20I5bLorubJVROxMS96bHZUbNaGQB6bixETG6tRMXaSvOeDOXC?=
 =?us-ascii?Q?GOTp5M0QYuKN0CM7eq1j9Io3o11x6JNw+vAJxzyF+SxUg5z0okJFbXrkIWdx?=
 =?us-ascii?Q?gu74g9LhrBdV/vxMoTKTJ310//Ipfi4R651M6p+awAgJxNPYHhivtJ4coYVs?=
 =?us-ascii?Q?6mB9yEDXLuF5cGe2zzS45hZZj4y5zzjnCtcUMVE8Kf3s5kbVLytkrImxWKO8?=
 =?us-ascii?Q?2GNzGYu4tCRBriJlfjPS9UO5dMQ05wmW3adH5xud+DcVaW4TOGPxH8l9WiWu?=
 =?us-ascii?Q?gDEJly+JxMW3alPSByzHi88Ebw6KtQwEqYUhtjB5+rC7LaRUtl9Ephidf3Wt?=
 =?us-ascii?Q?HOmp1qvZv0S9ZChHoe01VK0g8/ALfMhiSoBqc8Ql1t3lYVAnxcO4Zo4p44/F?=
 =?us-ascii?Q?Azj6dy8J3Uy/HTMNUOVJ3AjSvykkW20Ji2WA7oisYPYfa+MMUR8GHmi5TDJ6?=
 =?us-ascii?Q?YDAD0I5+gb36h4VGaYBSpVtZr70whf0NctVUmYz7FFqMjQvg0JXN0lckO3pc?=
 =?us-ascii?Q?cLLGuAQl5SrV7wHxnkLfMRWA23cRdkZsubs6Z2U4hmWrYM8IV+cWkTynnHPV?=
 =?us-ascii?Q?KcPfA5MEKMEHEh3QwNrpwcO1p5EK+zr+uLnb8Ih3fOESP5m2ml7D3ju6j4t5?=
 =?us-ascii?Q?/fmpZDE2ETCEblkEbaayz1YPh1mLzh1XTWh/vPUcYETQA4Fzwe9bggZRwbtQ?=
 =?us-ascii?Q?nMYrqSZFuwOYjAPuzGFLpeYhua9uCom3dyFw2kFNMRuRo/8W9mKOXPfpTT6n?=
 =?us-ascii?Q?HlmU4+oA8+OaPEJ+T5W+Bac4N3oimMPDOPxtEzzPj7pv0REcoLRoVALCehSS?=
 =?us-ascii?Q?aNyocZuhChkxChAm6rPbtTm5IE4rTOwcSmNduE9SfTnln11JiYil9uHVP8zT?=
 =?us-ascii?Q?SBtv18bR6yUL5DAT1iPp0+FNKMiunKVH47tfAPE1DuC7d496m8PQMxM0mifs?=
 =?us-ascii?Q?mlq/rPNqu5Mr6rbtJyFUrSO8cRU5sLK7yU5AxPc/3D4+GnFQUXY4rHK3SYZT?=
 =?us-ascii?Q?P8CC4vyWeS7l1OGrdB5bGSvvr86lQfV7sxwqe+6RO9/dPg+8afm4uwhyw52m?=
 =?us-ascii?Q?um+DiGrroJv87buO7YepaMEY6q9QqO0dn4AeB5q2/3z+RKmEwdup8HUH8qPc?=
 =?us-ascii?Q?Jl1KEOpg5DMCDdczbCmGy8Fg2DeqMqHQXsXK+ZDnfJjhktKI+2VpPU9TB+FX?=
 =?us-ascii?Q?KHQzP3xyocxMCrPqmSDCSiSUO2shKwv2w4VjHISm7TftGgQv8Nfkgz/roP0b?=
 =?us-ascii?Q?Vwpv6IIEHWkGYBOahyxy+W/wz4WGEgnLsiQpRJaiOujoSyXlYhp3EYy3O7wG?=
 =?us-ascii?Q?Lc8ETl8YzI4YHqKHKgFKa/GsFIrVLSivvSZ21JpkalahPfsYIlPXYA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ef9569-e5de-4640-491d-08da0919acd6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 19:58:30.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6hen96RsqDVA5Kr9Fl6tN8nXr9ZHTtOjCeGuSNHWgmxV3g/SU9zO98j7EK9Q9xuMQwZjX/xgElxdXvaTuJV+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix switch has 6 ports, 2 of which are internal.
Due to some misunderstanding, my initial suggestion for
vsc9959_port_modes[]:
https://patchwork.kernel.org/project/netdevbpf/patch/20220129220221.2823127-10-colin.foster@in-advantage.com/#24718277

got translated by Colin into a 5-port array, leading to an all-zero port
mode mask for port 5.

Fixes: acf242fc739e ("net: dsa: felix: remove prevalidate_phy_mode interface")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ead3316742f6..62d52e0874e9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -37,6 +37,7 @@ static const u32 vsc9959_port_modes[VSC9959_NUM_PORTS] = {
 	VSC9959_PORT_MODE_SERDES,
 	VSC9959_PORT_MODE_SERDES,
 	OCELOT_PORT_MODE_INTERNAL,
+	OCELOT_PORT_MODE_INTERNAL,
 };
 
 static const u32 vsc9959_ana_regmap[] = {
-- 
2.25.1

