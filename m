Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA5D670E1D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjAQXw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0764F87A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+G23rMFoBQkIsBSMCPj9h9+Vom3RUkIYRVl7sih6UWnGDi5TQcsS5XYhhNI2crStOJDbPn7OiO0oLnm/MuCGax2vmT9fKzS0rt1BizTGgWb+pP/j4M744w5M9+mA2en8QzJ4+lC4wM5n6xbeWOektqQYROBd1XF9PBUYjI31r7r+3EQ2MmFiGyANIkLtKN1QgLyG9Ap+l7SqREGDwfvnhohYmXOiX7Eb90BEItxngv56Kx9bDxvuO0aGLhKGa/3b7cTQIPu4ckZMfTew3YRYQ6Tlmp5MvuMf9SYznu6pdEU0E6Ogf50vHygY1FwCuKUoZCzljGJ+5kzEX51/FrywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TwWkMG9fSjnsNr3cwNZ/iuZRp/05JLX2GEx6NsLrj0c=;
 b=BCpUzSM7xJjh213+tLlA63yDaKU+BDY5alQPU2V9vTYRDYcuCMYBI11OLhRjP2UR9afSX9ZuEAFwHvgDF523hkDMX/l3mz1sCJe/b1jcLrLYDnq0edwzO4qqr5CbXmEo/q3WxyiO5p+Xuw/VYM9Y4nXINM3ETat3/QZ9tN3+LpHxoiEzZ8U3XxozY4yMcZ3o/+b+hjEccBs85dDLeJ6Ct3JVYtOvKvB8rx3/YB5dYmedkfiTMxTIHzvKW/y4IRLGea10RRaSazzdmg513RXHh1Gz/O1WVwBu1CwbrjgaNDOqtvo9PIHyrU30nWSu6tqjkVfS0md6UWyxjucJFy+dMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwWkMG9fSjnsNr3cwNZ/iuZRp/05JLX2GEx6NsLrj0c=;
 b=XDgAtv4vCasEtOxZpNRmjpjdKFmYPDKhg3FsMhuqthXYoDW6dzVIpj9JeDyg90DJYe50dbCUcgkrOqoBHDihOc2rG58TcOvFrI5B1+YLnWciGYPHMO16wh6LkvQ9SZT7hIw83R5rsJJUxQz5pVDiyzcZ/sjyka0Ac9H0jQjgjmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 03/12] net: enetc: create enetc_dma_free_bdr()
Date:   Wed, 18 Jan 2023 01:02:25 +0200
Message-Id: <20230117230234.2950873-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d990eb4-6973-411a-4ecf-08daf8df01af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKhAHs/2mygGxQMCvnuURWoiokHOxPtub5F0o/yZKch8JlbaUpQBoGCOOGBaQpeT65i//wAJ5epu8xV8kOUjQxf9F2XY/rXHkgHYhvBjKuuQNME4lQ3yHqFaaZqf3Geqzl3r43rT9AgP4Hoj4CSJjYptDbPq9I4WRO0QfuNA37vQaLtH9KakKKz0LUvC2i7Zrf7/sItPshS7kOejRnvsF7uGhi6olJCz1H1aoLDolBcpCaV0oMyJwsW95lD5+bs5y4M3Hf8YjaM91u1EATqyE+5PR3nKLk0reEZIU7RYWavR2WTV4UrAm3E43AxP2pFY0QjXTFmMw/j3iWWY8bjW74Uhl5Q2IplMg/dVZfc3L4OTM+Fv27E94Wqka7XGppqsiEvr97RkIaeDgGYfY+Tmdrd0ZjhIZ3BYeDdlTGxuaoAm6EC/lzMJ7F22kmRJGhWOUoxlvuFpPZaD3VUnUlBA3YNtUsseAs+gL2rnqIxQ5MmmRvwx1gK39I8dTX4Q3VsUOybHWYVCK3Ar933S5+BU4As2gjV1aTtOFac/2I/5BZa1hf1s9sqGAzgBd1kXa5tlwXp1WxkB4Dy4H9Cf2DotLo6c+sIABLPBd4mm/UMApo/tre1x2SM0bjBMrzUypAO4Vff5rb+luQjo6/xvl6ZcCg0hrm5zYw0amapDbtMrtG/7PhOUfl2jBGk/klAvdynFYbZmh8gbtftgWRZ/mH1n7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jYUienNwIcmK03Kz1kUSRWXA/6dCIrI9cysmZvpzIDHZgZPkUmZiSMXWjGmf?=
 =?us-ascii?Q?5Q5LW6OX/byaCx3fayVKWMkyBhFMUM601ZaU29lAkTyoZpu/saSkZaNAMyjX?=
 =?us-ascii?Q?J7sPB6GKayL2F8NHiB/7egx+l93fI00f5P3ZFHz+s8knOtzY2GpMWmil24nX?=
 =?us-ascii?Q?M3EG+EqTsh+0jZm6ic8dgNOJOtp6jJAhc7vG0GCRAbTH2Q4rKXkbYgjBcfX0?=
 =?us-ascii?Q?5OGrE2YGxVWXV9Wfw/8sfMwyKA4gAcugt/r6JhBgXykTROL2p7y0ufBKA9cp?=
 =?us-ascii?Q?tsIV+45XRBRxYmeXzJpsq3mIANAOJuoe3DQmSmLk//Oqg5IZ1Aw2sFLLEdj4?=
 =?us-ascii?Q?FhIBc0/PTw9oFhzVVsBQAxovPKy9IGfWGLRuUmYGqEwFTeFYRsf+/L17Jpv0?=
 =?us-ascii?Q?ydrRN70OqXcTFS6y7Xm2w6evIiZkkWGhKty+uOmMC0fOLZr3n07X6VlS5xZL?=
 =?us-ascii?Q?wJEaEdv2LWOoPCjqo5Z8+XdQqIW3kWRRug33RQPwDJDpPdBUEtSZOTAPBmD7?=
 =?us-ascii?Q?kd19/U2b7olDVYnf/HLNBKkA1f+84LhyFRgfdos3cqug7KQTGHXBvnQt2/iM?=
 =?us-ascii?Q?jZg80VA+ZmQ1+olz5iiYs9ILr/nWoD0PHIp25WEL0b+8fghZP/QSLA8IXPDm?=
 =?us-ascii?Q?QDjLGFURxjxq6lUZ+LcVJFGL6TeYzs1DzZRrCHT2cqXPc1Sek9NjgImlTMpJ?=
 =?us-ascii?Q?JvHBxnAXPh5URORxCET9qTBQhxyA7Sdx7KUk3SAKNXYYDIhXrxL0RMvAdY0M?=
 =?us-ascii?Q?zav6mXDNr/4+LuTEotTvo/owpIL5dUfUltndleXCYow2InHikI7bEL9wQKOl?=
 =?us-ascii?Q?srDp1z6aZejZqXvU+qHBPXXjxUzJzDClD4OCP+gDFKelZm4iJxaLZrkC7ANc?=
 =?us-ascii?Q?HQTWlbcsRAwngvPl2gUVi6Cm/BWfc1hR7WKJLEmLmPVAu4l7xKNwpHKCfiQd?=
 =?us-ascii?Q?GkfVhG2p/ob8xcf073o1/gHV09FmEZd0v5IybhAC2+70TbmTgd+sa+ROepNJ?=
 =?us-ascii?Q?PqHkqBGe6OxzbjCYhzba2tcP/gbyWpOop3teIiL5096EPImJC6GGSgGqKl2K?=
 =?us-ascii?Q?dAgKRIIqzgnQATXrSU3SCw25XrFC9YAY1sdpM9EhnxXls6X/NxQ7QxwBbFdS?=
 =?us-ascii?Q?1Hip/5XswvuXDBYA15Yjm2QcXsy6clh81AWO8Vz1eKExRoxpq+o8kypyV1Le?=
 =?us-ascii?Q?JFsVmn9Z+tttlkcNF2x0chXlBctIQiSAanBGbnUT7XMzMPwIUp2zAXYSLM+B?=
 =?us-ascii?Q?4qx5Of6RcT6kerb4rq7ZsLr4epMpy6ppTTKoevLh2Vo/SGW0mus/Ra9uS168?=
 =?us-ascii?Q?++8BxRc2l2dUP9u4jXtkzaVJPUND62mA0v48XDbsroDza3w3Vd8AzSXVMIEo?=
 =?us-ascii?Q?0BnIVW25IsCpwa+uNDqMrfgkJALI8F9/jc/F5IaYbBcaVwqymc7py62oC3bs?=
 =?us-ascii?Q?o+ivzV12TYFEn8rWOwDTSNTUIdQMG5Oy0YZgokbT1Zovsp5w9F7y/JuTY4/f?=
 =?us-ascii?Q?oZ7+G+QWJKvAy0Yqi3w8S/W2wlYjiVBwDgBH187+5Vw9i//F3wYPWBU/IYRW?=
 =?us-ascii?Q?FPUdmKYlI+P3g5mI+/yEYxX/KKWaTg0QniQ3/EsQrhT2bVULyj74LOmYMBfu?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d990eb4-6973-411a-4ecf-08daf8df01af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:11.8195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWL0RIQM/5fV/BYdrFNAwUFV+P59hHryiHy9PVk3cXdCh7qlbiO0voLJInigvT38haCVvLGjePAog80nvU3vZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a refactoring change which introduces the opposite function of
enetc_dma_alloc_bdr().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 25 +++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4f8c94957a8e..ca1dacccf9fe 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1732,6 +1732,13 @@ static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
 	return 0;
 }
 
+static void enetc_dma_free_bdr(struct enetc_bdr *r, size_t bd_size)
+{
+	dma_free_coherent(r->dev, r->bd_count * bd_size, r->bd_base,
+			  r->bd_dma_base);
+	r->bd_base = NULL;
+}
+
 static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 {
 	int err;
@@ -1756,9 +1763,7 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 	return 0;
 
 err_alloc_tso:
-	dma_free_coherent(txr->dev, txr->bd_count * sizeof(union enetc_tx_bd),
-			  txr->bd_base, txr->bd_dma_base);
-	txr->bd_base = NULL;
+	enetc_dma_free_bdr(txr, sizeof(union enetc_tx_bd));
 err_alloc_bdr:
 	vfree(txr->tx_swbd);
 	txr->tx_swbd = NULL;
@@ -1768,19 +1773,16 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 
 static void enetc_free_txbdr(struct enetc_bdr *txr)
 {
-	int size, i;
+	int i;
 
 	for (i = 0; i < txr->bd_count; i++)
 		enetc_free_tx_frame(txr, &txr->tx_swbd[i]);
 
-	size = txr->bd_count * sizeof(union enetc_tx_bd);
-
 	dma_free_coherent(txr->dev, txr->bd_count * TSO_HEADER_SIZE,
 			  txr->tso_headers, txr->tso_headers_dma);
 	txr->tso_headers = NULL;
 
-	dma_free_coherent(txr->dev, size, txr->bd_base, txr->bd_dma_base);
-	txr->bd_base = NULL;
+	enetc_dma_free_bdr(txr, sizeof(union enetc_tx_bd));
 
 	vfree(txr->tx_swbd);
 	txr->tx_swbd = NULL;
@@ -1839,12 +1841,7 @@ static int enetc_alloc_rxbdr(struct enetc_bdr *rxr, bool extended)
 
 static void enetc_free_rxbdr(struct enetc_bdr *rxr)
 {
-	int size;
-
-	size = rxr->bd_count * sizeof(union enetc_rx_bd);
-
-	dma_free_coherent(rxr->dev, size, rxr->bd_base, rxr->bd_dma_base);
-	rxr->bd_base = NULL;
+	enetc_dma_free_bdr(rxr, sizeof(union enetc_rx_bd));
 
 	vfree(rxr->rx_swbd);
 	rxr->rx_swbd = NULL;
-- 
2.34.1

