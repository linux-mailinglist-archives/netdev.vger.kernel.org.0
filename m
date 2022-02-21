Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454204BEA28
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiBUSFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:05:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiBUSDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:03:01 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140047.outbound.protection.outlook.com [40.107.14.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AAF15A39
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoVJZ0Lw9dGT0HIl89Ypc0jfCzqIQOB+C6Mm1UZ3JIh8fAMzxSSTQ2G+TocVysWOB7YYDhYqSz91oovfKqVh7t05nYpo/QQh8Ovs2ocO/nl8nDU5olcUNLaHasHAnDRk7hbZKP+Wwh4pDu7b4vD/skJIPTqgDkQoFymsBOLFMp/mhfapY6AuaHGO3OuTBPNYCoRq5YkvACNZ6N/UZB3Kr1Cv3AGCoB4dYmETaNVx8Sl8ptRr+18VSkjB7H2eMqPpZSHsMtaFyyb4KVbImjEy33zamnh08XlnFY3OAVydPEuKHzJkDKo/zJLJf4lbu1O0203ZlyaEBo0DLpIZqLQu9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31g6q4mXJ/0zAc+7Ony5Mm444e7jBnbG8Qpeisy4IAY=;
 b=Snc4Ar+oNWmS1AKA5KyyUT13tP5RvCN3TrrRZfgCsQLmYqL4JhIJcdIxWVBHxj8QYzi8EBH1Cx69D6t5WFFA06YqF/JbYDFwzQ/aA1de0sX/S45u4GJsyCQWWf2SdFh5mUL91slWcFWlLPdUb5+QLCfgokFuAxq+3NW9Ifv0wtn2UoMHYa2SIhmP18JBYRTmvG8f4GSjxwwvJuLUVLQo8G+ovWha9uqjWVhsnIOWHN0yG55Dshx4fv4iClEmO3aB4hCHQ9PpsH8lfsS3wldNDnOIGhKqGs+sBsyddj17+KkAbmvfBMwrattIvt5yRQE9rA9QoFLHAtM5xuZQE0glAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31g6q4mXJ/0zAc+7Ony5Mm444e7jBnbG8Qpeisy4IAY=;
 b=ojuwSjGiulCWNnDOosIm/gmVz5nxAAmIxBexrNLd7BVTvK+lFb20css4eglKUq6GK4KSvOVWSTlBrEfYFqO2Jey/d3ihPGCOIfPNN+J3UtcsAIP/a1mySFa2SW7A7WzPdNSCscZitH1Rqo/wTyF9e3kAQO7btJ8aXtUnl51oEqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:11 +0000
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
Subject: [PATCH v3 net-next 05/11] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Date:   Mon, 21 Feb 2022 19:53:50 +0200
Message-Id: <20220221175356.1688982-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
References: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91c5e402-5a84-4290-a7aa-08d9f5632a6a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB369385EC14991F732963750CE03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/MWHX8AFS0a9gRGLoMLzuqnr7ho9wpl/W5Lr+It5TIly3flgkp8OYXq5BBUDq1DKqD3ZI/AGWPWRc+Gfas8swSTm6+r0IuiPO0I6OJWl22CNBwiE9Jgt19Cb/JLi4HipxXM672gKPI5yEtVLK+nKXoFbi+52w4WGcX6RjcvWQfSqQNbu3hUkayD/HA768LAZVJBlfkGstBk0Mlu97eNzuPcxjbjLoAoHeVRSpWHlXdGUJeV1AYwmlRXyIax2WJEvDToyOtMqYxxRoUkqd0M4ABwLyNMagdDouIE7C/tECNlgmXus5I2iDlkvsCawNYtC0gdJe9H1qKe5ONWdBvLQPVQ74LghiamnqiRtRGAQIvPF9N8HZoaAGcs4yli6Ll6DLWQBRJY4ZoLT3bC9L3jJLKXJTeOzshMoSsY/zdtAtlnbZ37UqhgFlmDxsHCqIc6slQ3hjSxtlJlzYGGX9kmMC0W0NRYEN6AIDixeYjVWqD8lbV9QxPNa0+Ed9JoU2XVMAA4WvXIK+mD41SU9vThkokXhBya6m1LCETHSbsRynZUndY8rtnIldqwyJYk3T88TxgGtcQAkHy5+2s2z1guFXwq0wYBsW4rUk/BH+K8rVAdqhUB2Sh1hiSmtbRkFlP0c9HXMuKK2HmDJO20F6bhtVPM4caqX/UU1s9oobrbM9C2XiKhwwsMLgysnI4d5xJwbrRsys8ZBiNTF3A4gPmgpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(4744005)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kFzrYok9Fz+mu6gTijY7qq1g1I+56Nkjlx3E1UvWUr00zE60peQdHoGCaYUe?=
 =?us-ascii?Q?NmI8HbHa7cl6agLEcV6Ehn7ioQUA5lyvfMIWXPBd7Q261yC+DQHxF2vudg2Z?=
 =?us-ascii?Q?0pGo0Vuzqgx9pSmnBU3JjrdHqh+7WKs2aMhgVZGj+NLg7Xpb7wUw4V6lACKP?=
 =?us-ascii?Q?95OpjWtH0eSWNo4t7RYy7aGtaU1pLcBni+nx2NWdXEQQecIUZbDIviStmEaz?=
 =?us-ascii?Q?7wCK1dsxj4L/oXHMKDlSxjBb7WPGMjidWLH3o7i9iOKU5Zms93+bSqpHduiW?=
 =?us-ascii?Q?oKc7Op1JiDTEI97q3UTWxiEmpXIHXcAK6TDsPRkTKy1X4ymr2rfBg3XFn1EU?=
 =?us-ascii?Q?802M3STUBIhbwOqrh2JqEIrWBsXG69v9ZGfsTiLowTWBn9LRHCXqkhhT8Pv2?=
 =?us-ascii?Q?ZwUVvoLu9w/+txxUiX4OfEQOTRiQdS6nuLvcpZnl7UAhDggW1k4Lk6bR9vGz?=
 =?us-ascii?Q?SoaqKLuowyqD1Q2PIcqtDpElc3U+G4HogHngWFEXM0WRM9bRtPvgmJArdgSS?=
 =?us-ascii?Q?TyZ8geTZYpNiFeurZ+5w8ETG5s4X0pSWhDVK/HlHHaRdG7IELZl9Ni8aU82w?=
 =?us-ascii?Q?BAwtpGQvBLW+cysVKFxD9jye7vzbPFEtGcxYxJDthZozWQdYFwzV+5EpaamT?=
 =?us-ascii?Q?4OssjNT42QjhbXgnnByn4hB0uUjN2Q8iR+seJsSREB8IwXsM+M/Byisxg0CQ?=
 =?us-ascii?Q?Yj08sTB1Lk8DN7+9JWk+OA6EuP8Resn9g3sL8EQ3RRx20W9PgooNnV8Q1fcT?=
 =?us-ascii?Q?8o7GPyuPwYweq3c6gOYXr7sC18pHyQ+wGZ7EjmzOZ2LWXcuWRdr/EzrwgDlu?=
 =?us-ascii?Q?zHMxnxpDcdNcwQJuFJy6o+T+URZWrtWgcWCBsmQ7nKNheGv7UOdhtCJvVSYn?=
 =?us-ascii?Q?Ty53jflkX2ysoFU6cxaYAiZBVpiUkmUGpQn35z09SmGH20+wYgO39ty+24iC?=
 =?us-ascii?Q?N6mRvqq6s2CQFs75GQyg2FZWuUS72uPcnPlE7AG8uqjpqRxpK28q2zDglwHY?=
 =?us-ascii?Q?QhDp/Yf2uSIOhxWhfPdiUNx1AjyHQHBUiTelktAWGPNySzhHkpDF8whCie7P?=
 =?us-ascii?Q?JJ4HzBBR1mpQX4kSt1v7/zOGVAae0JzN/ewm2mEea1+91sBEZTTzQ2pu65wq?=
 =?us-ascii?Q?hee8NSeYOjis4M9dWBERKvaRHBBLSqoapksBgq8mvDFAVJRJF1XMb3E7XUal?=
 =?us-ascii?Q?AKlp0b3Is7+tXOGyHuC0ewO3XXkpqKNgwOWHHPqJfNbo9aO7oLEFb768afW/?=
 =?us-ascii?Q?car8mCMGtIhX79IKKrkiWGasgJe9BQmTriIb9IPz8E0HvcDGFTTt/yfI1b7k?=
 =?us-ascii?Q?zx/6kpAlGexfCHHjdSXsFEMyxcXRK1qz9sLtJUf4h1NmoJh1XbZkETBJEbbx?=
 =?us-ascii?Q?/801KAzucRsr69oGYDo4HvnjJOHzo9vg/q/36uMhNFeu+ki2ihkCbMSs97uk?=
 =?us-ascii?Q?fa/tBO7Hn3u0HVQUrQyU2Blu4ms19xarbu0xclE2E2TCMZ9G5e0alHSq8AuS?=
 =?us-ascii?Q?gAxRway/x464iQ8HjeqKI2xbtVMcU0WZqH7wQl9u2QemYsHAxmVAfa6NDu5k?=
 =?us-ascii?Q?S0mJXRLkXyz9kJ5EmLRiOUMEr6XvVnVwschxx0+mARTBD+u1of+a1Zo20WGq?=
 =?us-ascii?Q?RlJlFvxdgzD+u8a9HvXReTA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c5e402-5a84-4290-a7aa-08d9f5632a6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:11.3398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wc0IztdiYgF7FJMCMkjursBFb8ym5s9k4C8bcASXboE5t90l6mvnI+owSOPdBQ+hO3DTgisISCkTZ2FTVNKwxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
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
v1->v3: none

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

