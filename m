Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F080263C222
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiK2OOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiK2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654FC627F3;
        Tue, 29 Nov 2022 06:13:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lajb0r5KHNEvluYY8Y6R+KLTE1ggxm20O8IUH7HYiRLejd0uDwEOPhc2WUOL4FL3C8rSrUvHcX+ROprRRPvCGWT0EaTcM6Ec3aJiSdCD/0KfPOEKBc6YZQ8jFjzAn4jOFdIEcO4m+Ka476ruqdfZhd3Sb7cBQ/m4/3FPtJ3CT0u4JaY9ssqy9jq5yVEQebgMtFuRLKMz1xyN+D+7woO/vezsUru5808/PzZ38TC545ABwWE0cZueSMWyVQJYWO/8/i+fWW1y+7wNcurt/9azcEWqmBAUTzD1LJ+D64C7DOxWDXOB+Y1PCpqWLEOxSIOE19ou9/Tg9Zui8wWZCqiVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyvZDwYSBi44mXcGWwr/hmUpK086XnRrOkzo/iUvqF0=;
 b=Rsmke3boBk7z5ZeUk+Ro19ULLCMlTpizSOSyLnwB4mFYbbenEVZ6o1SxPRhnNOfrTGo5LxUWJPpkCcNd39lNBbHdmCtOuolLGx0wtJNhHfrOhZfQ6yhqIoYvqrxY42rbeD4vmqRl3fEQAO8ji/K5Q0U4oOHCxSWjOskwe5mNXYfqt+Swdb5Wtld2RzMHSIbLzrCYfqbZPhwwhsKuQvDT+xJX+sffo1YS80lORWAQ+Jqcfe2b0EvFaSstnb7+qv7lz20YKXqlqoYOy5qa8X/4Gb8BLbPe1GRjaisVYamIFEZFSaSBm1sqLpxxSlG3hmaKxK1oQQmsuKpGKHq9kk+CDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyvZDwYSBi44mXcGWwr/hmUpK086XnRrOkzo/iUvqF0=;
 b=daULig0ZDowAUsYWU2XLfjWOaDO6QRrImjqwhjDlbKkd9aA899Iwl6sy7HUgjyvUcX/qxXPczqn7ELBXQ1Tqged/C+RoypUuNpq/D80BG7vBBlTwXeaHMipj38Ept8vVQO30jccZ5++5VQXQDubXb6CquxQOWAhD50a1OWii9yQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/12] net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect() call
Date:   Tue, 29 Nov 2022 16:12:15 +0200
Message-Id: <20221129141221.872653-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: fdecfd36-03b2-4412-763a-08dad213c512
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4kWf/IjJYXSygQq2CxKMafeZc0ypVIyP6ON+6SoeQH1uHy1UkRlyAJH3cUPhQfFbAXx/Dn2g2uCdaQ6w7a/QgXlkA+EkDulN7cSCjAiBqrTIEndGVGr7au/4nyyvZ/jujgjSekIrsWcwb7LhdOS2AD93g8REXAFU8ijbLEhJo/wtKEHWFKpCheX6C5sASUIk/mSQaVxUsxVaGSyNIN3fbFUhfZ7xIMEilsoXCSgmkh0hrR89SFyL1zJJW2nq3rCjCx2JBjWxTByKPCvivyrIf5SA15KM4q2J8v6xtqZiLLFn83VP1IHNtE3EHCIZYOBGO/l+M8MrDWSwo4etVixAJIiTj4h+EX6ubOxpCl/tdsV9YxSKxDuFQ4enKfrMPhibTboMZo7Ik3Y+zwgrAT17VZmzskNIlVCvdOJxuxu/uoEkDz4+AOo94HycnJmg0O0ULPcbfo+hiZ/XBqJ4ukDSzif+mi5vcPgTlKombJrFpka2nQUpiPz5XXxtybGdBoL/DxFv6pUAjBEZmerkS/9Xk2mb8Ct0JjmUvgIcxAoThdyeIXrE3EYtrfBCK3cjybDWGzNqVPV1jyRvTJ7fPnQyZPfzbG0STM/Wo1C/aad8V5IYV7uPFqBOVQ3OHq+XW54izepYiQlXtC7eH7iI/uwQGAsSBNT/64AB7MBsW4ORRV5xhRbTR1bnYi07C5z2sVxXXi06SskohQ3Ph7ZPU83Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Twgu0C16xMJVlx4xyt39DxVVq9LcXu7ZGl+gk1pdwqSQgPcWQsZKZkYab3Sj?=
 =?us-ascii?Q?kUJWZZ4PxIo/9kFS1Jtfzxwin10D6eliRwyHZaZcD5Q0TIaR5Wv03RSyB5UX?=
 =?us-ascii?Q?kmiTnk6rr4y600bFRV1otfoWZVBOnd9Iu1nKBoE7QuWwWUVaiURpxtIrYlpx?=
 =?us-ascii?Q?HTfp3TjhvSIXmY0jc4EaMnrToAlZr/5AD8ck+Irap82Ji5QnSpQpcGwJk67l?=
 =?us-ascii?Q?Dl7ecxnl4u6JmEU5Gsde+t1clCTDnyZlYB6Un1D7433zKg1M2sKa9NRZQjAm?=
 =?us-ascii?Q?SnPE3hp1pt0t9CpmS+8oYoZ6gC8B9i+p8Jf0/Sn1qnIWRhJQM+Z2fceDAjFm?=
 =?us-ascii?Q?7yAPcjDoDb+JXqwTdzZPaP0AkFVRDf5a4tCouATZs6iHglZrPguvxKokmqsp?=
 =?us-ascii?Q?lABROAKhETYwMSlHt9Mez9n3EvUpKTii2fIATprMHd09jJldXIx6BPavYmGC?=
 =?us-ascii?Q?4/3+X3g6R0zxOe4+xd+jC+gbrDzKUaguWrX0xNDqUXY92V7ZWMPYMR9vuOJE?=
 =?us-ascii?Q?bUbnUR2Rj1CPSmuh+OxanHQRCxcwc3xpKjgHL/Vbjfqu/eKvBG5DhJCLeFmM?=
 =?us-ascii?Q?IWC3ja3N5Qvje2ZildKMbVleXHTdO3aepyD2yLTo88Gar7a7lPgXrBbzpICM?=
 =?us-ascii?Q?65d5Oii9F5uAKAPRKJ6libWOtVdFO5LYg8MlbqSZuFuKTZx60SRjW3YWh5Ra?=
 =?us-ascii?Q?obsZAKdoZpMtUgW9dAOGNw+SFAd2Qmv7mwOYRylrrG3qtha58w5N3vcKwnoV?=
 =?us-ascii?Q?UwMboI2iTzvKxIcDLVsiPa8T8e6BxILsvzD9hoGanvDEsFMsBOzQKD0Q1lPN?=
 =?us-ascii?Q?vBB0ULKiQ3PV0QrlufKNuYLgvvtEQ9xDpyZuoM/UeJQWvOCGUQ8NHt0KxRCN?=
 =?us-ascii?Q?r4hLrd3Ndmo2QfZvAUlzlAH++/K4aLADsfq30XaXxJs3BFIP+jwfZAgc7NJT?=
 =?us-ascii?Q?hL+ovYjmsiCwb1my4I6rgtybfqmNYTdYI2ErSIU4CmTRFKgJkrA+qSjCu34L?=
 =?us-ascii?Q?Z7VLHLLmV7Mty/CZgJXlWUMN+VGAivOyI63cf0e5rjJSSH0YU5we6fotx3kG?=
 =?us-ascii?Q?A3a6WBGiK2cxAXkhwHejYfHw4VkDFbTu8KZUQnVwYqmfe4YcJV8719/hzbYV?=
 =?us-ascii?Q?D501QJHWPskuV67Nh7RhYo5e0pOEOa/KwAXkINwNYVvuAXzPIp+nwX8z7HHH?=
 =?us-ascii?Q?5iyXMoyXsdWubAlT/cpTPAkrVQWqB1wgs7YuwVchB6/2vhh4Sg1e9lUTzhC2?=
 =?us-ascii?Q?PFI7ZxH2aTINwasc3VVJmoqzN6Fn0yPIaxzcX8vUuLZv4ojYsQhNQr1imCYL?=
 =?us-ascii?Q?k+YlE9i/QANUwOxSJWRbEXhdP3HmiW04sZJZ9jo7kLT+D5RyQQ/KUv8/W+GO?=
 =?us-ascii?Q?qRhd6R3Pskd1tW0eoTSlNUsJeIDXkKWTSXZ9DNdllWkuGEb7n5Ky1ERTzJt1?=
 =?us-ascii?Q?KpZZuoX9HEInAgPjeLkAUqIexQjxsWm1wBO6UJ2mzzykSH7iacoFm0t2nUUc?=
 =?us-ascii?Q?MkIihKpFC/G4uO4G0RuA9PcEBZjnM8ZCtFcd24JmIH6DpITDvT8w4JZVeg8z?=
 =?us-ascii?Q?2/noa6Zj6BnHsvYwD4Ki7msoPiFMJa6llOGiHHKK/V9/99H/dve4PtpZCXRt?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdecfd36-03b2-4412-763a-08dad213c512
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:38.0441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TbMh+H0PbgH4pjbkmHnXuIl4H1Hdvd/9CkfBnpln9wpIN/HRxyGt8/PdIaB1zOf2SyuoWmmdxghr6ITqcnCxcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-switch has the exact same locking requirements when connected
to a DPMAC, so it needs port_priv->mac to always point either to NULL,
or to a DPMAC with a fully initialized phylink instance.

Make the same preparatory change in the dpaa2-switch driver as in the
dpaa2-eth one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 42d3290ccd8b..3b0963d95f67 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1449,9 +1449,8 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
-	port_priv->mac = mac;
 
-	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+	if (dpaa2_mac_is_type_phy(mac)) {
 		err = dpaa2_mac_connect(mac);
 		if (err) {
 			netdev_err(port_priv->netdev,
@@ -1461,11 +1460,12 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 		}
 	}
 
+	port_priv->mac = mac;
+
 	return 0;
 
 err_close_mac:
 	dpaa2_mac_close(mac);
-	port_priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
 	return err;
@@ -1473,15 +1473,18 @@ static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
 
 static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
 {
-	if (dpaa2_switch_port_is_type_phy(port_priv))
-		dpaa2_mac_disconnect(port_priv->mac);
+	struct dpaa2_mac *mac = port_priv->mac;
 
-	if (!dpaa2_switch_port_has_mac(port_priv))
+	port_priv->mac = NULL;
+
+	if (!mac)
 		return;
 
-	dpaa2_mac_close(port_priv->mac);
-	kfree(port_priv->mac);
-	port_priv->mac = NULL;
+	if (dpaa2_mac_is_type_phy(mac))
+		dpaa2_mac_disconnect(mac);
+
+	dpaa2_mac_close(mac);
+	kfree(mac);
 }
 
 static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
-- 
2.34.1

