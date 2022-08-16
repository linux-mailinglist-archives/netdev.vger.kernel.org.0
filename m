Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6393F595DD7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbiHPNyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiHPNy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:27 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819763335B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoHKXiAt5ARA9lXZ8v1rHUuuwAYWqO24EvD0vBWjqDgbSf7kNOceZYjNfQNhJUt4H4epgEyzb5lZScHMTcEhH+uDnVKXF+S7yvMEyaSgbBNKaL2PbH5F742GeqYE8Kq9YVTmELAY/8Kbak6jSPevCtYBeJqvENJFxlJrHBKsIW0SocKSev2BW7nGcLxGoOIMZ8fPIw1S7ExAhALZmRCm+wYsQZXQR6Iltr5pk1fJrp/j3tmu5j2HNmOi9Ieaa3msorx6F3TGcRTf9W3oj+fcbIiia6RRnPrT+ryjfxjLJUi9JNr2V/+Mo3xY/6irOlwSxU3cdHGTHqFWezRtO6PpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuth77G/NxsJDFrHgtuOIMH0hZMqzSq1YZSBM0dGw6M=;
 b=lrSo6+gnic8ClbLANc591G7TUXaE1PW60gaabJMH0CCqbsf7e5ipEsT/ZiIdqFS9xEkIX8h8KAwfLOOLCmRkIzisODZroV+Mpjyng8nHAcANiHUreistXjoTnf4lK1mLrb3ZmzF5Pos6l1TAD+VvnuPpjFoKZRkxjKtMmjFG+k69zliSNwCzxtQjFh6df2vgZsChKjmZsjTB/nWoKN2ZNrAZ/72tdP28RIrZrY8ij8d/itRdMscwXasBqCraWxxJA0M9IqK4wmaCqWN7dSBVAT62q2gLs8eU/Bn+WpCReoruqZo4CVA2lwvl+UC6EZMsIBmlzMgXKYz9mCaXXSO01w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuth77G/NxsJDFrHgtuOIMH0hZMqzSq1YZSBM0dGw6M=;
 b=AzqtpiF7wXarAEJVG8IkmWN4zCD9/WgTJ6NUHNuLfClSWLvmfFfQ1cL45sZx+rVY/4a8Lc2xTaE03Hrx5tGhnc5/rauCDESmsU95Bm6BrrMjoyVeUEPirYMjClqgGS/wJ3KBsG+S04c2o7qnxhkiEIT4jZOMIsdqSV41sK3p0aQ=
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
 13:54:14 +0000
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
Subject: [PATCH net 2/8] net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
Date:   Tue, 16 Aug 2022 16:53:46 +0300
Message-Id: <20220816135352.1431497-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8885f27d-d8aa-4cc6-4fea-08da7f8ece0a
X-MS-TrafficTypeDiagnostic: VI1PR04MB2989:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3osdmkiD0JXx5aSD70HQbmdVOu0o3vuwZ5/I3mahpKN1eiRiLmIFEg6zOajEJWqKQcNQ04OF2MXNN8CyfCcK8Z657bJaK7AEp0WqRS0mgUxytYsYzUf63TP0IENcUB4IfoIcOfg2wtflRicO6UAocOHxYpci8qluhRIwR21XW5MGVO+/QrJ28d/5qqqSG/Qx1fbMy5QpdgOtD+lEDn5pXFOfzqc0zLzVeu6SfQuFBOAxAZvnjbAj696tJyEcxqZPpyxUKeOvURTcbFeWai8+bCRpSm5Ho5DV+QLbfaoArXW4V6796wwr8WW9DfngXs72/8at8Bkp6aQAW5KfXnR89ZXdWWgBDApQTGIa3+wT06al2RM/0JywOd0X1cU9r3xqYrApKBkY9aBOw7zJYNBsR7ZF8J0lU/xLdtuLI3W7TmRca1W2gdFOFmJAo5nZF5HtfqXTV75g0AvOawKhxYuECC9s2g/N6S9h1218/1PDcCudpccVjvTelhWmmCwCEh1RTKHbVobAbnzItnVZ7NrPAnV9GkRMMlKNWaV19JbbCrvwOsJuopeR6MlHuwRqIMoqtbO5Iy6PvyOYdFrNlbRvmbt8n3lpbkPEN4EWXb/o+gzsIjWKy/OTU8BPwRENN9V5kSOQZlDyzsNqboC/RxRAbM1Bkr9gMWTOJ5nWvw6XoywvjUYFvvCzWmFNH3fKrXaFM8JsC8ytyq7H+KahXZNUv0S7wNC5dglSGS1EWFuMfNd9WkgJUQQGdtu/j+7ISS0tfi49lxgMeEF8KFAWbA//9Te+WdxvwqC09GZk0DU/x5iYLTnv/Ck2qxeXrMPXuotIglEp2k696hX78jT36OZoVQuSYvLedvzL6Vvwjqvh73w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(38350700002)(44832011)(38100700002)(2906002)(5660300002)(1076003)(2616005)(7416002)(4326008)(36756003)(8676002)(83380400001)(8936002)(66946007)(66476007)(66556008)(186003)(52116002)(6666004)(41300700001)(86362001)(6512007)(6506007)(478600001)(6916009)(316002)(26005)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFFrxxL1JIDOkoselWUS9YM+CIH+6HIR8drVyodFKhDf/01628z8j7WszH4A?=
 =?us-ascii?Q?yREJ1lkJysE+dJClTmHd3GzI1T4Bwklhd8uyFJEH9+S7Itid1m0tuO9CpWMa?=
 =?us-ascii?Q?pX5WxrTV2cqQ56ORZxLxgoDtbQU3NSHyKgBuXoX6gX2JVd+igmxitCdKHeUb?=
 =?us-ascii?Q?7prUD0nt9WZHNWtxpKwF7LdT0/5vx/2BVPcHtZ4AYyzopdbtd6s0DajpCh7V?=
 =?us-ascii?Q?izLzAW6fYFvd3BcjhyxARuCF+WKH5xMGPJ8OwoDxlQJvXj9AFLM0SMeRhH2t?=
 =?us-ascii?Q?5Fexbvg5hlW8U3Fi8vkB2Sg9XaXgisqS0inbFd0NqlSWtjzMneiils5o1fA+?=
 =?us-ascii?Q?2OgnWJQXQ1aT1nLogTpYysJK4Qso8U4beFn3aIuRgRxD7U+S/DTIvhmU+qWc?=
 =?us-ascii?Q?qu9n1SaES39ZnFqUmT83P2azop0GXqxkeiO57dTFT8ThFz2cwEvwylTJmYRa?=
 =?us-ascii?Q?FHLUEJffrzja4NyzkK9LeNZYBhOn5Lumjl1r9g7nETqsRdZhP0ecYaGA0N4b?=
 =?us-ascii?Q?HC+l3V4Q6tE7yRi1Ve7T3ybQ87SFKQ6wZ0bZ/eEcsGANs2871tTtBVU7YkTb?=
 =?us-ascii?Q?VvJlp+vNPW22bp75Bp0DdcqEqIfhijPVHzT/kymK2ExqfrfRx2neMpeUHRJP?=
 =?us-ascii?Q?NEa8vhM1rUaohaReRFMGzYEF8HPMErLTvEZHdAm4Q0srA4Nt0FCNb41CHOcA?=
 =?us-ascii?Q?tLqEMQ2KnuFUXAPj4qXzHf52AYUeFGtqxWvhKte3aJn4+e6G7A3KHV03+uL/?=
 =?us-ascii?Q?I1/QQKLzk+M0i0Hz+rDzRSxCDw8f9v87NpbABt2sc1xsPGM1M37zGMvKkq3F?=
 =?us-ascii?Q?SJpGiWZxBG4EZG2ZMM2MzKhoUd7i4PjAC49zTTfOagu6wdURlpzVBofErnsB?=
 =?us-ascii?Q?K8YPsB4/HUiKAQe6Xme7UTcjyGPL6PEXfY72TCAVRussJ7l3XELUBAj2b1V8?=
 =?us-ascii?Q?XjS0iEYrcxDBmOGF7KBUhzwAv7JRPvba09i4s4taSy62vezrC/o9QteTaUDh?=
 =?us-ascii?Q?jR2ax3likTQI3fz4RtEIGuFDGfsQ5bEe6fiEgKSQaB5V1n9yNX4vBcd4iZAr?=
 =?us-ascii?Q?0y75VvwY1yc3AEcX0rR+Z7AuCzIWFx9BRmeUpZmO9GBlyZqvyiY/Z8VBbFb1?=
 =?us-ascii?Q?Z3m87iurmD02NSpV0+ozA5Ut0UYsRaVABHvGrT61yQ/kVcspUeJauDQGp2sZ?=
 =?us-ascii?Q?Maeogpxs890i4huBZyPEFcvRQSJAjicJXmHQ/e3yGSL7Bo29Ch6BWqWLV9Ew?=
 =?us-ascii?Q?Ux42tHTRm0KeDxqKdsyfMJaTyU/2UompabaY8Xn6NnfNKMJ49U3CUIew7dw+?=
 =?us-ascii?Q?jvx/6pDVbxbnOcWmCegyxljRNDdl2Zk/7xnPlPBGTfeGaYU3wbUaDd+AowbM?=
 =?us-ascii?Q?0GpNA7uyMeyxGkqjbqXuwRd1DUuznjRm/dQWNATlcoa1/BCy5gGur3twYxM+?=
 =?us-ascii?Q?nWgXoejBLq1FDdkMN1Vx3lQpt7Qozu3GPTMGvfj8pmxFFTpfZCOybQpHtyVI?=
 =?us-ascii?Q?KvIDKGDU0v6hP4a+0VfC8Y1d2Etm3+ZpLBEJaA4DejYXNGljbkpxU+ULKFHA?=
 =?us-ascii?Q?R1x5NQSqfgva4PdLDJhI6CR02gHYZ6DmFeKe8+GxkxBXM48jgZPMYnTyebVU?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8885f27d-d8aa-4cc6-4fea-08da7f8ece0a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:14.6931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lgxm4+Nx51ZzkjA5xzRuB/ujXJMkJG8rO8FZBp6SQVppmaPbCSLCR1Wcm1m+PBnCmktS6zjJ+FkGjFhVqJ3Fg==
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

Reading stats using the SYS_COUNT_* register definitions is only used by
ocelot_get_stats64() from the ocelot switchdev driver, however,
currently the bucket definitions are incorrect.

Separately, on both RX and TX, we have the following problems:
- a 256-1023 bucket which actually tracks the 256-511 packets
- the 1024-1526 bucket actually tracks the 512-1023 packets
- the 1527-max bucket actually tracks the 1024-1526 packets

=> nobody tracks the packets from the real 1527-max bucket

Additionally, the RX_PAUSE, RX_CONTROL, RX_LONGS and RX_CLASSIFIED_DROPS
all track the wrong thing. However this doesn't seem to have any
consequence, since ocelot_get_stats64() doesn't use these.

Even though this problem only manifests itself for the switchdev driver,
we cannot split the fix for ocelot and for DSA, since it requires fixing
the bucket definitions from enum ocelot_reg, which makes us necessarily
adapt the structures from felix and seville as well.

Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 20 ++++++++++++--------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 16 +++++++++-------
 drivers/net/ethernet/mscc/ocelot_net.c   |  6 ++++--
 drivers/net/ethernet/mscc/vsc7514_regs.c | 24 +++++++++++++-----------
 include/soc/mscc/ocelot.h                |  6 ++++--
 5 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5859ef3b242c..e1ebe21cad00 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -281,19 +281,23 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
-	REG(SYS_COUNT_RX_256_1023,		0x000030),
-	REG(SYS_COUNT_RX_1024_1526,		0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,		0x000038),
-	REG(SYS_COUNT_RX_LONGS,			0x000044),
+	REG(SYS_COUNT_RX_256_511,		0x000030),
+	REG(SYS_COUNT_RX_512_1023,		0x000034),
+	REG(SYS_COUNT_RX_1024_1526,		0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,		0x00003c),
+	REG(SYS_COUNT_RX_PAUSE,			0x000040),
+	REG(SYS_COUNT_RX_CONTROL,		0x000044),
+	REG(SYS_COUNT_RX_LONGS,			0x000048),
 	REG(SYS_COUNT_TX_OCTETS,		0x000200),
 	REG(SYS_COUNT_TX_COLLISION,		0x000210),
 	REG(SYS_COUNT_TX_DROPS,			0x000214),
 	REG(SYS_COUNT_TX_64,			0x00021c),
 	REG(SYS_COUNT_TX_65_127,		0x000220),
-	REG(SYS_COUNT_TX_128_511,		0x000224),
-	REG(SYS_COUNT_TX_512_1023,		0x000228),
-	REG(SYS_COUNT_TX_1024_1526,		0x00022c),
-	REG(SYS_COUNT_TX_1527_MAX,		0x000230),
+	REG(SYS_COUNT_TX_128_255,		0x000224),
+	REG(SYS_COUNT_TX_256_511,		0x000228),
+	REG(SYS_COUNT_TX_512_1023,		0x00022c),
+	REG(SYS_COUNT_TX_1024_1526,		0x000230),
+	REG(SYS_COUNT_TX_1527_MAX,		0x000234),
 	REG(SYS_COUNT_TX_AGING,			0x000278),
 	REG(SYS_RESET_CFG,			0x000e00),
 	REG(SYS_SR_ETYPE_CFG,			0x000e04),
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ea0649211356..ebe9ddbbe2b7 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -277,19 +277,21 @@ static const u32 vsc9953_sys_regmap[] = {
 	REG(SYS_COUNT_RX_64,			0x000024),
 	REG(SYS_COUNT_RX_65_127,		0x000028),
 	REG(SYS_COUNT_RX_128_255,		0x00002c),
-	REG(SYS_COUNT_RX_256_1023,		0x000030),
-	REG(SYS_COUNT_RX_1024_1526,		0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,		0x000038),
+	REG(SYS_COUNT_RX_256_511,		0x000030),
+	REG(SYS_COUNT_RX_512_1023,		0x000034),
+	REG(SYS_COUNT_RX_1024_1526,		0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,		0x00003c),
 	REG(SYS_COUNT_RX_LONGS,			0x000048),
 	REG(SYS_COUNT_TX_OCTETS,		0x000100),
 	REG(SYS_COUNT_TX_COLLISION,		0x000110),
 	REG(SYS_COUNT_TX_DROPS,			0x000114),
 	REG(SYS_COUNT_TX_64,			0x00011c),
 	REG(SYS_COUNT_TX_65_127,		0x000120),
-	REG(SYS_COUNT_TX_128_511,		0x000124),
-	REG(SYS_COUNT_TX_512_1023,		0x000128),
-	REG(SYS_COUNT_TX_1024_1526,		0x00012c),
-	REG(SYS_COUNT_TX_1527_MAX,		0x000130),
+	REG(SYS_COUNT_TX_128_255,		0x000124),
+	REG(SYS_COUNT_TX_256_511,		0x000128),
+	REG(SYS_COUNT_TX_512_1023,		0x00012c),
+	REG(SYS_COUNT_TX_1024_1526,		0x000130),
+	REG(SYS_COUNT_TX_1527_MAX,		0x000134),
 	REG(SYS_COUNT_TX_AGING,			0x000178),
 	REG(SYS_RESET_CFG,			0x000318),
 	REG_RESERVED(SYS_SR_ETYPE_CFG),
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5e6136e80282..9d8cea16245e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -739,7 +739,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_256_1023) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_256_511) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_512_1023) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
 			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
 	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
@@ -749,7 +750,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
 	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_128_511) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_128_255) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_256_511) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index c2af4eb8ca5d..38ab20b48cd4 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -180,13 +180,14 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_RX_64,				0x000024),
 	REG(SYS_COUNT_RX_65_127,			0x000028),
 	REG(SYS_COUNT_RX_128_255,			0x00002c),
-	REG(SYS_COUNT_RX_256_1023,			0x000030),
-	REG(SYS_COUNT_RX_1024_1526,			0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
-	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
-	REG(SYS_COUNT_RX_CONTROL,			0x000040),
-	REG(SYS_COUNT_RX_LONGS,				0x000044),
-	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
+	REG(SYS_COUNT_RX_256_511,			0x000030),
+	REG(SYS_COUNT_RX_512_1023,			0x000034),
+	REG(SYS_COUNT_RX_1024_1526,			0x000038),
+	REG(SYS_COUNT_RX_1527_MAX,			0x00003c),
+	REG(SYS_COUNT_RX_PAUSE,				0x000040),
+	REG(SYS_COUNT_RX_CONTROL,			0x000044),
+	REG(SYS_COUNT_RX_LONGS,				0x000048),
+	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x00004c),
 	REG(SYS_COUNT_TX_OCTETS,			0x000100),
 	REG(SYS_COUNT_TX_UNICAST,			0x000104),
 	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
@@ -196,10 +197,11 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_PAUSE,				0x000118),
 	REG(SYS_COUNT_TX_64,				0x00011c),
 	REG(SYS_COUNT_TX_65_127,			0x000120),
-	REG(SYS_COUNT_TX_128_511,			0x000124),
-	REG(SYS_COUNT_TX_512_1023,			0x000128),
-	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
-	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
+	REG(SYS_COUNT_TX_128_255,			0x000124),
+	REG(SYS_COUNT_TX_256_511,			0x000128),
+	REG(SYS_COUNT_TX_512_1023,			0x00012c),
+	REG(SYS_COUNT_TX_1024_1526,			0x000130),
+	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
 	REG(SYS_COUNT_TX_AGING,				0x000170),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ac151ecc7f19..e7e5b06deb2d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -335,7 +335,8 @@ enum ocelot_reg {
 	SYS_COUNT_RX_64,
 	SYS_COUNT_RX_65_127,
 	SYS_COUNT_RX_128_255,
-	SYS_COUNT_RX_256_1023,
+	SYS_COUNT_RX_256_511,
+	SYS_COUNT_RX_512_1023,
 	SYS_COUNT_RX_1024_1526,
 	SYS_COUNT_RX_1527_MAX,
 	SYS_COUNT_RX_PAUSE,
@@ -351,7 +352,8 @@ enum ocelot_reg {
 	SYS_COUNT_TX_PAUSE,
 	SYS_COUNT_TX_64,
 	SYS_COUNT_TX_65_127,
-	SYS_COUNT_TX_128_511,
+	SYS_COUNT_TX_128_255,
+	SYS_COUNT_TX_256_511,
 	SYS_COUNT_TX_512_1023,
 	SYS_COUNT_TX_1024_1526,
 	SYS_COUNT_TX_1527_MAX,
-- 
2.34.1

