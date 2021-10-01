Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60F41F0FF
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354994AbhJAPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:32 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354824AbhJAPRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZ3j7yfIjZ68yJ7hytIf3EFq4YB4H7uIcZIwm2FvyHk6vNXnG3YNatK0z924CfFb6Fiwbpg/++YpsdLdgpzO+QswAvZi+f880J6/Sg+b9NkHGW719W5UyCyhGjRhJ69+gUCOlTH+QOk6CcIwoWzK9NXmjM/EvSl7bsNMgLegOV9/TrExfkKKNOxh+PK4N16Js4TTv5Qip6SDYuzpmcBVYBG2Iu7YMdMwKNNAjxg95IK7c9IgYymw1QE2QtCVNjHOjpPN/wqX1A/Ypp1xdsB5Zewap+N4Ok83GsZ6tHJ/ZYcyyOU8XN45g19sdqOk1kb/tWFzij995hfn5cYYP94oyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJeEWU2qwzwfsohwJ2haKv3Hk1x11Hev9huBR1wci/s=;
 b=b+pB7AQGpgM/VQPd+iSa2KDS68lNayPpy7lXO0N327sQoveSqLJbLyGCsnXIjm2zamCoi+Mlz2cxJaYSnasXICvQK6YORaaBW4xE+gTvVF0x5J2WnM/XRHDp2h0h/8oU5Dwxj1XVviO4HxP0R6SEYN3shFYchzki1Cy++izEHtwb+cPewIrS3N8ykbigT/RZHQeNlZ/bXjuc5Yfh62p6H4t8Odd+Ldu25cRKdouZUuatkv6/BhKUEu37gfxMGLznjHOzjTTMSDhXrscIw0SBJnDPVXmukq9BPnn4Mqoc1u8LNNo3xga+DpqVEzLM9OhOUlXUOiOYaLCommL4DYeLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJeEWU2qwzwfsohwJ2haKv3Hk1x11Hev9huBR1wci/s=;
 b=bauZXvkgVQf7Ce9U5WVkPY6agOixsiPsxHxOUKMG46zb28g6ngWudvQOuQaKOB6ETRfTCQNWIcDWydlkEeS0/BX9+dpkjwG2jIDYNlSWhjr7x9JyFpCPRzWHOhmd9h85R2bjx/QUyKF+ehcU2xw6s9Abs6moXgki2oU8j0ZDUJ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 2/6] net: mscc: ocelot: write full VLAN TCI in the injection header
Date:   Fri,  1 Oct 2021 18:15:27 +0300
Message-Id: <20211001151531.2840873-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b7fc55-2ebb-463c-6a6e-08d984ee5704
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42249027B5A4CB52C5EAB92EE0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5OvPRHz1o0PXwJXf8xaTiiFG0EuPKwmQQiUzh59fQexfn6yEgY2UGpw4txdwI6bebLw6yNrzBBzVJYWzzFZi4YVvgOtmYab8WdPeIQRqCs9ksPqUT7gInJnExuSwZP3y03ZQKm2MAFpVnmxxcmjAAPr5WX9L5YBx2ZFZA5h37a731t4qF3+PZgNc3OkputMe8arPqSTpNJZUAajRciSCatYfrd3u7eesmE6ExPQUF6zybggSI+YFObrxm7I/xvP45Mo/MDgxfxX6Qq266NXNZlEuXJtp8LXlxJxVsjnyqLb7Pz2eh91LcjNdIJr11tZ9IOrCvqbDLUkYppZgPeIngsYxli+0ocJbGWaorxAi/lua55MpEbY9dbdI/p+836KsngjdzRc5RMyx7tYHQwzYXq9M49GtlcPoU+x87RVuhrFdWIaz+GxfiuamarQE3pbXvr+psLp3KfuXmM9xDpoSOpcE9Kn5/DJ6b65lGN/FUtUXmUGdDMivHNut/s2vQ4itooPIPF98NWlTNmf56poJiTP4pAO5b8HtrqtjeJ0LuDCBUO2gdOky8yELRnZvta/ITawcaI23U8LsgJEUy4nvQUEkf6StsU5a4Jwx9ckYCjjXdyPJZ6fxGtAIUs9aatoXQLTPWEIkPAFX/HMzPaMVqsdNjEoZc2RU0XXQnfquO6TUHmyc5yIVW6sPevLNHWWkWQs/2C6bE9AQ58dNsDKbhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EmHhWPU2gPmWXwFX9D7Bt3czYWE5oSsWYP4PuUapmjiQBdUGo7Uaezy0ace9?=
 =?us-ascii?Q?YO84MpP9aULoWMx3HEnoLHfQT4jTjanFAlRfnuRM2jm6OgMf5cz4+oYaCKAQ?=
 =?us-ascii?Q?GCrRqyhLzgmUOXl9GcrWCDHis4eaKi4deND91godz5vmz/uRIqfSo1drpWtT?=
 =?us-ascii?Q?jAdq6pwB5wsL2wu7yILbwTcgvB71+7HsEeFku9VnAy93Z55gppL4OjOOzQYz?=
 =?us-ascii?Q?p3Dr8uWDH1hnePbsQzxXt0/Z4NHfxycICraZHyWGNjkiY2fJaW42v7FxOvaj?=
 =?us-ascii?Q?SZK4laoaGIgpgLVbGA09/KbmLEHtGSr9DIM36U67Mio1eXPgZICxag68dfPG?=
 =?us-ascii?Q?J7edL+SNkrjg6LsMMNmjWCO0ms3cQUcBbtbzQFTLB/5q2C0/RZ9kH2IJvW/P?=
 =?us-ascii?Q?DRtrqIpz699oZfdWPDfB3cfTaRicpyrezoMlrm/+xrPPQqeC9wRFIrINOgYC?=
 =?us-ascii?Q?DBNp0M9IZXJpHlrorJmRcpEefmLGNIkpRb5e+SV0ypTUeK9ckAG+KcJxAj8U?=
 =?us-ascii?Q?R4EtuuiELD7RWyxmOM1gggVUzdV9kDdGcRog8RjlzywvP6M8seF1IaAu4tu9?=
 =?us-ascii?Q?BhXEXLCCmVCeAUU1VcHh7xhKHP+PT8m5nYTNZJH39fxVrW35gwz1rqHRGyZu?=
 =?us-ascii?Q?Q45br/lGTX4R4kAf7VJWj2QEkyn8CAitITAcwxEMUJqQGcRT3t1tkR7OHPjJ?=
 =?us-ascii?Q?luZNzXr4nXVdj1TZYJ7HuZ3GzpVL2p+erLajXUDD3bKZ1YugZqGjTbegTH6W?=
 =?us-ascii?Q?xaCJodu5JEwYzycChTOAuC5G/CCvu3LlL1ImlCGvrXdhZjLSSTj978cumUcV?=
 =?us-ascii?Q?6X4CKA5cjrmedrYRyhFm6/B+dMgxHFvuDERN6FM5s6ywwiO6asVwU77wwSjw?=
 =?us-ascii?Q?4Lvi/D0LufEixJE5auKs6A/H+Gj/X8O/qWL2VYFOqPOVI2ESNpe7+hidq0P7?=
 =?us-ascii?Q?IYqG0YHc/uo3qVRT4+QAX/cx6PjBRgRX+2uL6JXt/ujLwfwsJlYYE1GWU514?=
 =?us-ascii?Q?KXy55VumyAmaZVCjnsdGEZqrSvZKhri8zeaeW/M5p1ksT9M8EpZBR7HbZJfQ?=
 =?us-ascii?Q?tfnqK4CyHAC1bkV5BQSutO0nKAC4ipFOPeJEuDULWVQ5MIC1BVsxAAzmmljR?=
 =?us-ascii?Q?shkTmOg7E3CPGH2PXPpam0rJr6Ob5BdEB84YIWDWCC8IbyPki406M80zDoft?=
 =?us-ascii?Q?9xAuJW78CoMPAf5+1I36qAgNT4T+pPwvxsGk1KvjBuB/fb2c+yi3evkFCZHA?=
 =?us-ascii?Q?ZFlqTX5W4YUATC6Vg89TFbuHtd5E6dIRx0oBrePY/ROOwP6iGgmr8reij7hD?=
 =?us-ascii?Q?YlGGpjcYVxXPD1SRNLVV1neF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b7fc55-2ebb-463c-6a6e-08d984ee5704
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:44.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POMgg53ciPfqTCZarGf/W9XQEr48J9nkOR3j+CID9yczIT2S/GgYHZjLgm065FqfFJ9CaPfIJP3gU3jtkQxyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN TCI contains more than the VLAN ID, it also has the VLAN PCP
and Drop Eligibility Indicator.

If the ocelot driver is going to write the VLAN header inside the DSA
tag, it could just as well write the entire TCI.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 include/linux/dsa/ocelot.h         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 559177e6ded4..05c456dbdd72 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -916,7 +916,7 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 	ocelot_ifh_set_bypass(ifh, 1);
 	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
 	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
-	ocelot_ifh_set_vid(ifh, skb_vlan_tag_get(skb));
+	ocelot_ifh_set_vlan_tci(ifh, skb_vlan_tag_get(skb));
 	ocelot_ifh_set_rew_op(ifh, rew_op);
 
 	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 435777a0073c..0fe101e8e190 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -210,9 +210,9 @@ static inline void ocelot_ifh_set_tag_type(void *injection, u64 tag_type)
 	packing(injection, &tag_type, 16, 16, OCELOT_TAG_LEN, PACK, 0);
 }
 
-static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
+static inline void ocelot_ifh_set_vlan_tci(void *injection, u64 vlan_tci)
 {
-	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &vlan_tci, 15, 0, OCELOT_TAG_LEN, PACK, 0);
 }
 
 #endif
-- 
2.25.1

