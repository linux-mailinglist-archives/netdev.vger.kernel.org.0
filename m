Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52642CFE37
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgLETVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:21:19 -0500
Received: from mail-am6eur05on2131.outbound.protection.outlook.com ([40.107.22.131]:50144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbgLETUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT4sLkbCqCotYnAnXT4zw1CaW9BSg7yPQxnJty/hK/oyCEAQjVNycfGQIz1cXUNwj/dXigrN4M5ZUYQs1T9NkO6faxmYj85JdX6I054V32TPX77GEjcBBoDNvFe3mwPNaWT6LQwVdqfxM68odLjpHrpcEYLXR40EzIdMjzwKvSjotJuShYJ+ZWupQloq0SCicZQpXgwekDjLhRHPQhuEDqth1Sr7h8gimGOqPpvyRuRLxkoCc89VFhaT1oH/5vVFlUipn2XWHc90aw7k7RBnaNB0OOKOjVEf51dU2Oke7d1uLkqdsc4PY71xukvlI5x/sF08tzG6THcCffjzF/DsuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ4sPbbjyo9slA0ImQ87wTmVnC8Pn7/hnGEqYEL7IjY=;
 b=NsxhfMiEa7hTgMGfD0sk9W6mPPszJQO54Axt/X4t7kIa34DW5eVHXRioNuauuU2Zc7WAHXumg8apjvBauYYIjF3W+NFF4mL9VEPLRtZP/QTkuVk6ge+SSP/YOkUDRXIftdtmHYrrfJK0ZGLZF5GiXRc5GJ+AJbcJyF8g5TFql9VU1KEmX2ucVAMXcWluknteSimQv+D7GQRToV9o+wJrd9AUx85tMGDt92Gtye8PERPlB3t6radEQgvIxjCjZCBAVLzv//s6xloMMv2KcIijfZbi8iICY0BG7Scr2JWCPfiiuracgMX8Tj/b6X9ZnA6aYTzluIy05krZnVXWUBs7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ4sPbbjyo9slA0ImQ87wTmVnC8Pn7/hnGEqYEL7IjY=;
 b=I+A0wtOdZUTSix1SDtHy+CVPxRH6XWAA4T74D5ZUca4tu3Z53z1fU45ve00UpqhJz3JL+JMsmMVd1BBdDgl6VLdU7bCXSCqjaIDQSNmRt0/JNcIDSe0RUqbQskDjt7GhVA/bb6lXRT5g1v8Xnpod41+aYVA18Gxfo30nMgPF1Cg=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:31 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:31 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
Date:   Sat,  5 Dec 2020 20:17:40 +0100
Message-Id: <20201205191744.7847-18-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed4a984-a6d8-477f-401c-08d899528dbb
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1363C75DF7339C6FD3E17A3593F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i5SX06HBixAY9iOgPO9T0Ukfhl5JE4k57DEiH0fG5KQxKjkWY2flFl1xR7ap7ixdIusL/hvUp0k/ExvLd3KIqiNFJpB/xhKwioWg2Z0W1Ih7EhjlA2s7o8XxX8z5GnLWyrFJlISokO/gkB1mNsIXIvTtUJCP9C4pJD+1zR8rIssO0+T6x5+kUaST9ByA6np9M/V8VmPjVa0JY1i+hPZDQ3fYIEnXQ/+uNWN4RQWQ7mHHLo5OFxXZwf2/TmtxwDRXCrsvXLmuqfSE7I5IAATck/7ofFCAJWHlSrv9VVne9Bir0ofjY39AL7+dpwr13YSN7UbVBNA1+yIE91AqL4bJ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xr5enkF2jNltvO/n6qy5wAFaCiGJTTE4WfRIEetifIq2rpWYN7RrT69iby8V?=
 =?us-ascii?Q?NZERGXeY+61hPtGIeXv1IPmMuBuCC4JUaIqs36s3Kv+0ZVKV+bmq/7wEYGT7?=
 =?us-ascii?Q?T7u/dE8sjgySkHRlvt1gHbcuO9ORzqi2pzxvBWR0pdx9fGGFHddWwa/2vl6K?=
 =?us-ascii?Q?PBRJFqaDRA1prlHAIFWTHOi9TFNq5kiHwDsJzG2Krj/uL6KzE6qyTaJjmNgT?=
 =?us-ascii?Q?agH4rGW9/Y6VVpqeom4Extqcw3+7j6Q330aHaTxIUMuMuLAFRm5VD6wy9xDg?=
 =?us-ascii?Q?gY/IV1AILUwu5n4uBacuAqetYAyJfrOFRx6TDO/SdJGakNl6dFk6igP/CrHo?=
 =?us-ascii?Q?mv/3UbUQSG594elh72Fx/j6XMkAZcpCpqLt3+vckMnX8vqzaOO1UV0cy/h6d?=
 =?us-ascii?Q?QxOfPE6L1endo2gd6xOAmFucJdvQ2jBMYdGytImPD/IwEaI4kmrLKp1iUFSo?=
 =?us-ascii?Q?P9M90dHdXtAcqVm8bWOcB1PvjOnmSIFkONMs3URDSfeSnWZbhDznmT4+G5Dv?=
 =?us-ascii?Q?ggvAKRviYoxoj961XeGi6smu1ymLNR63JTheeOZ4/YAvJ0ewCp819ZchWfSw?=
 =?us-ascii?Q?dNL3s/IPrqWZhDyTA3RHoxaBb75F0DrerHlqW1eNvU0Z/qrQ7ysRxk1uOTnY?=
 =?us-ascii?Q?sKwc+mfrNm/d96207Q/MhPMcekNbEEcq93mPGZ+h+63dVvyyM0NJMTArmqFn?=
 =?us-ascii?Q?tyIlZ7KUSfjQt0rVMARBsYk0zMQnG6q9yuUxJZaxFeS8deNcnzdU77t5scq3?=
 =?us-ascii?Q?/aAUEPF/Is0mZvvicbrztI2/3NTLetFJEP29FfjYyPvYkeprPQ/wIew4bym+?=
 =?us-ascii?Q?TEdhrvVIC6RAcjEPmH2Cb6YHHLZi8FGNZhHCaR/7N6/KrtdNLe9Jswqk7FRo?=
 =?us-ascii?Q?pvB+V1BMIrg/yyrU6ZYHIGz3dBM7UVLQkCffjIRE5ULVMTDxCO7LHGsHXnE4?=
 =?us-ascii?Q?+s2h8CLmfNO7j/fcG23EMqcy43PJpnd4JUeCkP1LzH2tIX306+qu7m/8cCfZ?=
 =?us-ascii?Q?+VTB?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed4a984-a6d8-477f-401c-08d899528dbb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:31.8661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcLdPfrTiX6Fm4b4Yo31GCT72wjApuSBfxzUl8bZ0px3OvaDxhcdaT0O8g/N6xkNYcqZ92XvHCpCbO47EG4CJ8/hiXYTMHyknFCaYJYBoFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index c9f619908561..3aebea191b52 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2203,8 +2203,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesTx; j++) {
 		/* Setup the skbuff rings */
 		ugeth->tx_skbuff[j] =
-			kmalloc_array(ugeth->ug_info->bdRingLenTx[j],
-				      sizeof(struct sk_buff *), GFP_KERNEL);
+			kcalloc(ugeth->ug_info->bdRingLenTx[j],
+				sizeof(struct sk_buff *), GFP_KERNEL);
 
 		if (ugeth->tx_skbuff[j] == NULL) {
 			if (netif_msg_ifup(ugeth))
@@ -2212,9 +2212,6 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 
-		for (i = 0; i < ugeth->ug_info->bdRingLenTx[j]; i++)
-			ugeth->tx_skbuff[j][i] = NULL;
-
 		ugeth->skb_curtx[j] = ugeth->skb_dirtytx[j] = 0;
 		bd = ugeth->confBd[j] = ugeth->txBd[j] = ugeth->p_tx_bd_ring[j];
 		for (i = 0; i < ug_info->bdRingLenTx[j]; i++) {
@@ -2266,8 +2263,8 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
 		/* Setup the skbuff rings */
 		ugeth->rx_skbuff[j] =
-			kmalloc_array(ugeth->ug_info->bdRingLenRx[j],
-				      sizeof(struct sk_buff *), GFP_KERNEL);
+			kcalloc(ugeth->ug_info->bdRingLenRx[j],
+				sizeof(struct sk_buff *), GFP_KERNEL);
 
 		if (ugeth->rx_skbuff[j] == NULL) {
 			if (netif_msg_ifup(ugeth))
@@ -2275,9 +2272,6 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 			return -ENOMEM;
 		}
 
-		for (i = 0; i < ugeth->ug_info->bdRingLenRx[j]; i++)
-			ugeth->rx_skbuff[j][i] = NULL;
-
 		ugeth->skb_currx[j] = 0;
 		bd = ugeth->rxBd[j] = ugeth->p_rx_bd_ring[j];
 		for (i = 0; i < ug_info->bdRingLenRx[j]; i++) {
-- 
2.23.0

