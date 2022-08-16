Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2E6595DD1
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiHPNyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiHPNy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:29 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587BF3DBFB
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIf4PplLKxxz9QdtPAQI1cc/vzRYx72uHrLdALRjTF5/WzSWs8qePld/rMWSpyOjS5CNJnJrzkVzLV4PNPzSRKVF5Dpx6M2BzGlqbvoIzBA10afKX4Te2IlZtnMr4mf7qdYxsYqt5VEYA/LCUVpkqmFnt9Tx/eoUzMZgO1FpaRjU4w4BrnYJgBjw3DWCrRUry86hTnkqTO0QhI0wEJeIlJHeikB5PnUyyar8eoTGdVSF2zwmcptwu7CejB+47FkrIyWmK4mmTSh6PyLekzYTYoU45y0EWvJCr+mzUcXDPB15f8AgwN4lPilL64n6feoe5Cuseg4kybKWRq3pYcYLFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wm7VLlLQmA+IGL2dN7PLRU6qU46DqmXf7JzIj6myjM=;
 b=kiQdXlt/pBl/LOFJ+q0wiK50zO3lxTeQATSHwStUJfLbTpy1GJAmTH0xOISC7VmXp3IDg2nfqXydeVZBrotOytrl1+KHlB+FWHzOo3JZRbRVaGVANIuPhMSzXCINIQVVsWhY6jb4L/PfQYfN872MnwGpWIANvk++K4LQPeAD9L2lEFgy30Us7PxBARfADG1W7jiT3HpTv5rECKA44EkxOyEZMWA36TdV3/N9ZgviMmtmkZ//r+ReNlNPJPXiNMvGqhQGTAaDXD1olYOJgJ1ZkNomZphhoxflUCHXYznDJ/QaBPgSW/yjV+w8bvGP4SDP4APCHeVnXbLLxI+BP0EctQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wm7VLlLQmA+IGL2dN7PLRU6qU46DqmXf7JzIj6myjM=;
 b=ZQXFPMQfeonR36NdpJNGsgXzp+XMpaZljbvAY0BzvhFbZ3gwKDIqahzDM0RQXqdcMGldzLlh3RaZH8seVS/128Fbuujn8KX2g8KwqHcYCwbzfgVBb+DNqRxIo7bM99Psymca4RMroCLXajPbAhO7bQXy/etFlaU5w8CiyltilF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB2989.eurprd04.prod.outlook.com (2603:10a6:802:8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 13:54:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:15 +0000
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
Subject: [PATCH net 3/8] net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
Date:   Tue, 16 Aug 2022 16:53:47 +0300
Message-Id: <20220816135352.1431497-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: eba02135-8911-4f48-0c91-08da7f8ece8b
X-MS-TrafficTypeDiagnostic: VI1PR04MB2989:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3t2+Xxkh+ibrz7vJ21r3MWh25WQ+X5DZy7yeptkDJx4avCN289Pdts3ltqPRcV/6j/YpEJdTgtmOi8PD5qZND9Uxg+laIbn7ZiBZPhuewJ7kerWhQu7YKb4XuiPDXjqw3XvHZ3tt9YvCstaQx6oIlwVBq5IE4zq0H3dWffCeGyzCWrWsWf8+sq+TulqZudBOz7uRFPsQ+i4Vd5fdbyeEXkQLbv0O6ZbeM8cfvpj6y37UZQUgbsVN1Mv/rvB/nOkOvmgJtGSVOUPQ3PHLHyy0zCZKTDVCCjpS79taRn01Gdp2EQeLK+BSTmCrrwbNEwDHltVEbfNhCi5Aca+T+FjL+YExH3Tzds4KnX4qixEOgI/o/b26DCQ0/2PpgX1wfOBVJJETCZEcMZhOocXcSjdUHc5+IT5yyrubFquY3CnGJFlQu0IyVikcOSOjJesg50K2EqrO5OIQPX0I64t23GATv1T2R2u/Bd4qL+b/NBElOO6l17nOtCFfcLe1i720va/lFqBaAt0pJ3te49aSHxmIZfyOLL5TBVXL1JvLA9N8cRcufLcYtnph80+sinyVD+VskkOcTQGd+zglqmYU1toDZqmuTY5BCKR/gkSY0CPxnYa/m+NACPm/5a/xRwNk1a0pgk8h+D5CzKo5kvXEczMtOp43v3kQAdZbqBvBS8YGe1CC0QfFXwRK41JkE5W0P83W4JBJdm+9ZDW04eoFck7Cjef6vJtbGqHzv5fujxPAE9kvO+XEBwFN8r2WkBpD1Vx8ckqu2ZPgkQVm/2QnEU803D3NwEaUp70Y/NfSeGlQf2VjEkcSpWUGA2AyKwsz9wKZKqduzWCGbH10QexysaQwWrHdDiQsYhDhJ3KKBoTaTUU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(38350700002)(44832011)(38100700002)(2906002)(5660300002)(1076003)(2616005)(7416002)(4326008)(36756003)(8676002)(4744005)(83380400001)(8936002)(66946007)(66476007)(66556008)(186003)(52116002)(6666004)(41300700001)(86362001)(6512007)(6506007)(478600001)(6916009)(316002)(26005)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kKOk0U2un+NPV1mJzUYYG/Q5MFnAeTWGaXCajJJA3RMxX5dX6L/VdfoehCs5?=
 =?us-ascii?Q?xi/M08ogGVA+Vhx7jP9uAg4BNe9BJvAFVBH31PArTHuLOUOfzrTmG+agcCkX?=
 =?us-ascii?Q?DZJUQlJRtwsI83HU2MKM4VPqnj9sJEPaoMsLgR/tLhlDAi6fyQ6N5M4jjahB?=
 =?us-ascii?Q?ld319rIiyFfJrDiTX1r9gFbobsA1sqJn0IBRFqCTTy5SWTm6mrzt3BoR8s20?=
 =?us-ascii?Q?hvbXvOiDEhBBLc73lsinsUcQ5dR41zSbOtCdrbMj/bdGfIR0KFZ7x0dgBIkN?=
 =?us-ascii?Q?WLkbKmp6EFIIWmGLCiydDKDck3tWgWC26BZCjV5ElhcczbOjGp2/C3ici6yB?=
 =?us-ascii?Q?tY8GUBSe2P7PWrbb+N+0kX6tQ97FLV1rdK7mdDJ2YO+VE7NzQ3tImgJ1dISH?=
 =?us-ascii?Q?pcFOroGSTjNt9EOeSOZouIE9JKuu6FI3pRUKKBWrQIDm1TIMIBIBsjHV+BnL?=
 =?us-ascii?Q?7RTEdEKrTzWvSULmkhmfF2T8YE/X33QFjyfTBYcLPCuaI9nQuKCD/2beYdov?=
 =?us-ascii?Q?0EXM8BFDT4Z5+TZNySIgIUiEYf1cLpEAG48rOrjxLBenx+9rb2KSrf/jyncX?=
 =?us-ascii?Q?biy7tRurxG3y1WeFXPBkqaA3LUZ6m1hlszxwXjspKDUFUPaZPMiT6itJtZrV?=
 =?us-ascii?Q?8u5PYUhJ/KkZA/30/7zH9bqt7JsntXbxI8t/ZUX3AYCJ3bhn/2Z8UorBjwcW?=
 =?us-ascii?Q?YCRlrCZe1lcAwL0YBXz0WWc+KLPzLbYJTjkO/rTEDU19OmYPfUSV2RQARKwy?=
 =?us-ascii?Q?6wp/+qcEmM0CS+G/cHAb30U+RSCpYYCH2ltTNJo40+1qCddmc1RTkXkVp9Z0?=
 =?us-ascii?Q?rTbUSfe6B4rctxt6nQN1lFqdpzTrULzGVcNtz/VcsexFjBgY4J5sCzrKzUQZ?=
 =?us-ascii?Q?CGTWBBrmKDZIObW9hvD/68Pqs4ggJLlidAxmDJyenlGIVeOl5Lvi2rzV2SSf?=
 =?us-ascii?Q?q74UMwTDn5OmaXc8GpUp9WRaujLP1m7mUrHs+CMTFs8TI8gsxEKpoIthe6Qs?=
 =?us-ascii?Q?wSYQKpvssIgsm7y17n0qi6VQD3PI+4R9tfvrn8MRU93KHUSwd+6e62lExXKG?=
 =?us-ascii?Q?w25ihnAqGsSbMjsHdPSfYPujU/2jOaJePaXQItXsjo6oJrqlqpCvmUuIX8Qi?=
 =?us-ascii?Q?nXrBXQaDQUPFxdxN0B0ascx4lX/rCESqQr1arHkv5yDAruOjKq0d2Jme9fG1?=
 =?us-ascii?Q?VT1BMhVtRXl+yawEiSL06AwwisGA2FPuPhsWtjz+AQNf4hoNN2Dz6lzMYuLS?=
 =?us-ascii?Q?FY8vk5s8u4jTmQ0S7w3QtsoZ9W2l+5QHHwsTbApbN3ZZ0aUidhIT7IMTe6oD?=
 =?us-ascii?Q?l4PM+TjuVuauGOfRXbpF5j95CgtFAW7SlAGgwkj38GV2tlvt9AqFhTxeVVid?=
 =?us-ascii?Q?30eBcNCsJ1OG2ILsNtOKjHFEpXszvNbwXBXQaKEclZW1gf9g5Fw0elHeNsHy?=
 =?us-ascii?Q?DJQMe/f1rXvGZuPJgjjR2HieDYE1/pTc4MEl6P2zU93CccMXqeCLJlKAbJ2D?=
 =?us-ascii?Q?aGd/OV6MEXb1Rm7iRKcCvPHTD9q93grRS3RH/8/AHdR80Oz2Q09kZI27Umoe?=
 =?us-ascii?Q?6wq8cbo5KEj6XBSOcAWTuvECmbBaG+1v/5WXe9IvfkCDCOMMXnmgZURFEb76?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba02135-8911-4f48-0c91-08da7f8ece8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:15.5211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tge37SYRCVJe6d78fVR+UgrbX7xUBT8ZPljk168EFgEvAGHxeXtc4LsTGd0eADgIANx62sKOCTXcnpQnl37TrQ==
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

This register, used as part of stats->tx_dropped in
ocelot_get_stats64(), has a wrong address. At the address currently
given, there is actually the c_tx_green_prio_6 counter.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/vsc7514_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 38ab20b48cd4..8ff935f7f150 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -202,7 +202,7 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_512_1023,			0x00012c),
 	REG(SYS_COUNT_TX_1024_1526,			0x000130),
 	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
-	REG(SYS_COUNT_TX_AGING,				0x000170),
+	REG(SYS_COUNT_TX_AGING,				0x000178),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
 	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
-- 
2.34.1

