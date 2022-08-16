Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96E1595DD4
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiHPNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiHPNyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE463135D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kK1diakMxu+RaqWEQw4nMReOrgsT3v2LX0zGEb/BG/7hXGRiTpWpmJt3YlN5vz8pC66mLddA8kH+58G/96lwcbE3geZyHH7rJ+Udm5J1IVaEk5aDky4kewuS5/uo7TDzggyA6xi5yBVeGh7PrLJ/c8/sml5RIAJglyHkV954idZsDKb3YNggbq0zNiLu1EDzDBeOMYvwhidcFYELL0CnWb8+wF1UJSJ3X0JzVsrXb4Xk+zAGHjEaFeii3iRIaPN3/pTvfnhTU/hWdHUip7HH81JsY0nn2nMikz8/IgBqWaFPVxFb8HsgObFDxaZmffq5E9R6rxa0GdBRhkg0HcxN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1yrxdaGDxN/CKJelCQlOjv1A4M1iEPQ9ZFaDy93cEg=;
 b=i5V3sVY+Vcf5+77UCPi++7NCJJVZBJzJlHwi54COgzgKwGjEpw8glNflvWOkgPAAaEoU2pK1IfRELPRxWpP73mZBsdoAeX5jQIqjg7Mye1dXEn/8+fjXWPmAR9MGLJO4unoW+LA0QvLqRR3mKnl/o+dG7DV7mFEMCLPtQ/uGpRWf2jd73ayvnSa2p5Jab3FNgot6piTSj69tSD1nyWadtphJNsHyIgrUy0wUyRLHU6/t2h5BqoXmqS41Js+qfF3XK+FwmFbgfK+fRCdBLm04x25SNYy50xgYEK+0zjpjldf+M2lSquduFqM1JgVrGjAQcurrIuGZA4SyZDccK6vavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1yrxdaGDxN/CKJelCQlOjv1A4M1iEPQ9ZFaDy93cEg=;
 b=b7f2BtTdP+bhc5OHntq+ZOuZahdOxbIdsfWclPO4/yqI0Li8vE3ZtzprY7xEhznJ3amxgJAld/HHCVv4bbnvu/Hl8HuL6yNNL2SGCbJzuxOH4QEk/p7kzs+KmZNpF3x5QheZcRLI7RQLLaCHscNq01m5v59jILJl3u29tJJKm98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB2989.eurprd04.prod.outlook.com (2603:10a6:802:8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 13:54:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 1/8] net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
Date:   Tue, 16 Aug 2022 16:53:45 +0300
Message-Id: <20220816135352.1431497-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ebb75a3-ad0e-4feb-ce9f-08da7f8ecd84
X-MS-TrafficTypeDiagnostic: VI1PR04MB2989:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wXC8T0Z2JtZrl1OM/mYJIDfD3rE5wR+I1MrlNp5QycWpr+WLRBkR5evOabDL86mYN0jDmVxwjswGB0QKUlMt08X0cxH51naS1bqGKGuLsKjmSM/0YeILBMHSnVVuRqxCBZi1SMockreFDIL6UqjIQ8MUQwk3neAc2Up9fYfDexZNWwo7ijvQAiKhhaUN8og8nIidUWRY7opU+VFb9sYvf3FrkteWFh7HdVC/sIhGlIcnbCPqRSI453QQD5twQUI9GGSqYrncNz246Xj6TfCimXocluTTErPNcph91IfX+Toi+YJgbKBhwDuBkaeNLIR+z2Iu2B35qmOGDAxjvKUwYml8Fn6+0oOKmvsUbdnPBKdqHYdhrNOU2E5TSeJn0VcM7h4P0UahrzgQuBFzarq/ZqRq21st1FJljcckBCRbreQJzFU4dZYyDbcwxxX39gu1R0rvsyq6nZO2WditZw0GulACBDFQ5lM+DonREIha7UayeD30/Mzd9A4sd2bncSrP2YucwRwjiiLplRjqa7+I9i3CRMyv0jT3fFgtSPo4FB+A503NzMUVuU+VP6FQsZ4tD2Lc7V8z+desNae6t2cf5cQyv688U8LEnp9GmTKgY45nS3pWJy4P3ZB6Y0f/XLrOBexpd+sovEu0uH3OO+r3Pn4Kd5kXt8NyUEy/qibK83VGLlKgpVI4PQt8IXfFI7GL//5bgi+PNhXx+qMXdX0d+y6UohsZ0l+xyAyFF3zchq3iMJOJTxcLCbCYMSBmhjHv2m3vijeqKn8Sy9D1hQDTJCR639ehNhub9AohesEUvlpflYh0q3enuen8BOdl8FvXbk3snBhfF+5aChPeIz7+TJY7TGajlt9c4wq+AEfEgM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(38350700002)(44832011)(38100700002)(2906002)(5660300002)(1076003)(2616005)(7416002)(4326008)(36756003)(8676002)(83380400001)(8936002)(66946007)(66476007)(66556008)(186003)(52116002)(6666004)(41300700001)(86362001)(6512007)(6506007)(478600001)(6916009)(316002)(26005)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t0eWFn6QEBZ2Y60vERG+1EY9Fuy8+pVkFEdaw8So6itbBPQibJnUJd91v9nw?=
 =?us-ascii?Q?qjTXESsL8qZfrzR6sDxZUXoia0hxjNo2SiRamDQf+X1h2VuGyhvG8WBqTrBc?=
 =?us-ascii?Q?UlqdUcpTMN3ZnNxAceyjWfMI4lUIxIFRa6ZVYR21cpx/IzW46WbbaUYhuVMU?=
 =?us-ascii?Q?CcvmUw8eoBYpZieGHzS9amMni2bMvZzkjPvh37qsiD0vhP8NO45kblrdTkyh?=
 =?us-ascii?Q?yz/cm1owTnAYCGw50nYPxr7eeDVnh+2GyZusHFvEPKIdgn7q0wAvqp9lBs/i?=
 =?us-ascii?Q?vHxocky8e8ZL1e8D1ArcEFUDwrnpvbySfhJ7z0IV44ot4XL1qNEEX2OxrLVD?=
 =?us-ascii?Q?811/C7ZTC2u5wkEV7IdOaWlQuDZyAlpGzxr6rBHAcUyUZjXmylqYfanf0nrl?=
 =?us-ascii?Q?aRdXbj0d/C+qIl/5JlIGgmaBiQ1+HwSfudH1tlxCIWMVixxRbWEE0C5sZvoN?=
 =?us-ascii?Q?ZrclIrTTHY+NoSoaqBH6Ua8wLTGxdV0Rm6+xbjHpESr2275/+Gk0RqO9LrSg?=
 =?us-ascii?Q?mRttEoDNoaXjYCNlASoO5ggRl2wui2ayNZnauPoqiFku/baqD80ONGrhJR7F?=
 =?us-ascii?Q?y1iXc4JlrZZi2wjuElxURc4d24QAGFLD6yhjJc0UZrDkQQVvMnF+CJd6d17Y?=
 =?us-ascii?Q?XSqzTrJZ74Uw8h+H56hZ8qVk5tNgusfDIWJXv8lzxL8A5BRK61c9PraiJfGu?=
 =?us-ascii?Q?7GSBDu6Q2Lv3nxjWZRXBoZB8F4Tny2JBqVbKNMOZo+DfbrPkx7yMy+flGs3P?=
 =?us-ascii?Q?MCXmFLozG4BnOPAHW0czL4/vb+7xVM3EUFgk0oqrkbjmlq0JPHf0QHeMQtFp?=
 =?us-ascii?Q?zT5iNBXJpBfBiekn2BQVCQnYHhr7sajkZRf1ZkrOJqR0qte0ZaFr6l/ETw+f?=
 =?us-ascii?Q?n0GOGmBc/OCi1n7Lkn+naIPi07Nui1V4n1QvwJXIfDvJx7PFiXgfKwEiStd2?=
 =?us-ascii?Q?szo8ehwtpOhbL1tpMHOBXeaSAkbHjI9CeJwbwDDX+4Oue2cVf7/1FeLTK8sA?=
 =?us-ascii?Q?Z3SzqBvvMxOHMaay+mVdT95kbyH5qUn7nVZnlb7CY7VWcWcrcCpDbkEqZCU8?=
 =?us-ascii?Q?yvCIkaLHyDnlGs2WbYrYmIIEVt8sY5l3lQOdpa7alFQpW/6uPsW7oSRHOUa2?=
 =?us-ascii?Q?phjz1cBYQJXmTo35NchLRiN+Qgv4yRspLuI5VFMr54bXA8Gak0QNTwscJ/26?=
 =?us-ascii?Q?n6HDouX+9wzYEL6s7agLCr9hDmf3ayLd5xmxFi4oqnu2d0ggGEVPgM3W72SW?=
 =?us-ascii?Q?bYvMg64DpWopgYnuB/jpasHri2p8DVunTCZpmMNbrmJugicYQX9ClrdhKJJ/?=
 =?us-ascii?Q?K1l1szjH6/+Ybdf0j4LcWPCvaddwAvTDCmrvus9qcsmrbKYcHE6MRJUDis/z?=
 =?us-ascii?Q?Ul4lN6tS5jhcFt5YsDQcIkVTfXFTzlfom88sj53zYHbP2KmvGfDd1peAghBf?=
 =?us-ascii?Q?Y/QX6Rs2oARIfbEBxNhncn8LyfHqiUKAbkQxhVP1rpJi5uGFS8j0LdEC1mJn?=
 =?us-ascii?Q?RHSRsdrj601jwiN3EycaJiETK764D1xi9yJL6/2ISaNmgKz+rpFqvTsnUJfq?=
 =?us-ascii?Q?+LkcyZmtyAzWsuzXmqi0OsDbAcWDiMSqR8FfYCEBWlxTccw2FwqiwobLVBog?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ebb75a3-ad0e-4feb-ce9f-08da7f8ecd84
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:13.8337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+kkMaEPKl6B+XIEPS7toGzVz3k3Kiqu7sFWOUROiUecdaaqfmiLMyvjIKkisTa6fyyTRSUt/K1GxhnU7lJ8Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2989
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What the driver actually reports as 256-511 is in fact 512-1023, and the
TX packets in the 256-511 bucket are not reported. Fix that.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b4034b78c0ca..5859ef3b242c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -602,7 +602,8 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x87,	.name = "tx_frames_below_65_octets", },
 	{ .offset = 0x88,	.name = "tx_frames_65_to_127_octets", },
 	{ .offset = 0x89,	.name = "tx_frames_128_255_octets", },
-	{ .offset = 0x8B,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x8B,	.name = "tx_frames_512_1023_octets", },
 	{ .offset = 0x8C,	.name = "tx_frames_1024_1526_octets", },
 	{ .offset = 0x8D,	.name = "tx_frames_over_1526_octets", },
 	{ .offset = 0x8E,	.name = "tx_yellow_prio_0", },
-- 
2.34.1

