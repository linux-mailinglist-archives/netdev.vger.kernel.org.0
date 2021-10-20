Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364F543518B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhJTRo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:44:57 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:56487
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230425AbhJTRo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:44:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLwoDp+9mFHExIj+nQFC30mfPQvsjNgoEOYEVnechwRr9qyiJ2C0hs0iGoI0jNd30T3EX+iHJFKGyLMPVtyv8kJJK5m0mtIcexyaWJngKtoLmVJld5X7XvVzPWzzJQ69AX6L3fYsZFEm776dCfBG15zeGga3A+g61HXbyku5dmH2LwBNMQS4mvJn4gfNbJnkTuHdR4gLJTY9/rn5t7h0cCVA0i0W/f821NL+cB80HQruiAN/Sve3MAqFOZib9DkbkG0YTxG3sJbv70ykN2RKkCs3T0uloNIpFaqRbOe9Z/owH+2et5fv2k2KN68CEFKXfR+mm/Sk87mgkOYXyyZFzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHrtlEFaQhJSnyxwKzSOoq1mj08bauXeNEyD72Uth3w=;
 b=bs5/JdrjCWW1H2tYBlVczq38s8K+cAkEtdoo2EI+wnWIM9xJklfJVAJpXCTihK4GMVkO6kdbyVHR1env2ShI1t57bD86EQic2+CJ9hMQ/87OJMv3BN2vofZVQMa9vs3yquaIhKd551ygaAZahB4guJiREH3qCd0EjPfzbiS08CpcGwGuduB4ZHWx0s/oXKvL19qjURDa1LO6bn0gemx3Jkui2NYLsp9B8EJKgblmkvgWolHrSYe39JJ77Rw9zpz1J6Wh5WkHw+jWYDGolOrTF6foYWoa/hptyklg/Od8PjJDxz2z4RgeNR/FiIgSNQFAeeWmYBPsSv5ksz+LvxyGtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHrtlEFaQhJSnyxwKzSOoq1mj08bauXeNEyD72Uth3w=;
 b=CN+77Yryagf2TE5BCSkXJs/vbnLEk7EkD4of57vn0TF23iTfEsGQWYgEKys4s+ZJ3NC6XBE2CGnXt5exXJ1eYfZKD+kXL1F6stNLPmuNcS8sJO5REJa1UMjT8AdcLnpBCs9/xyPr0HfCrQgTO5gP7CvTBabUSRSziR0aK0+gebc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 17:42:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:42:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: use the skb variable directly in enetc_clean_tx_ring()
Date:   Wed, 20 Oct 2021 20:42:20 +0300
Message-Id: <20211020174220.1093032-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
References: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:42:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc3deb9-8796-415c-0602-08d993f101c7
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB251044056A6175596D99C59BE0BE9@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWbb3fzLXCHYfzN0U8DuRGT1umkPd5gOhLz8ly0GNK07tEgQRePmfh6wWTqz2FPjDQI9aWQCjIJ9COgQHPF33PY1sfIV6JMrIsbyQ7oYunR8fqWiZBL2KL4XnY1Y5dC5kWQIHd8WjgRwtSc+Fi4sLRECAkSvm9sxQ+6GGc1lKOkIfGgmI5qYsI/yBmGCFKOfsXD+H5+9FOOHY0SHmv0n1ntNseg49SPypaU7fZNTSR2IK6FxEdca8IJMNnM9wBy6ABq7OqTOI77kwwsF2ap6JxxUT8ZefEh+7rlqRyMSxvYaK6kv/EyWhJ6WdP1P5VAAgKAL/tGuDh/Dw03dxNZJW/1D2zcmtb9GjsU7XfFs2GJok40z9Tzbh0EzKjg99OETGYGBvOeofJab5K2LuGF08uJx0zKHcqdzysfizb5JFIah8dj10/BEyNUNFaP9kLoOaU2ZLp1emyN5g5d5YjbiIsx0KHPKkGEemIrNjYtpIN6SLowm7t6AHTe0UhwQSK1QCnlVcoNGYxpF/JMwyo5jpJ0Av7V1IOUO5FyZROZKEL27t1CFG1iINGsqwXh37gjAM6cKnYwWNmq79JRQBYXO3HUEh5YI6jzhCs4UqhplKHhEAeTMXHmN0f+xNZR6ff8OW17hSIOCeo9bbwYA4RxJp9eE8j6HLMupliabyEU4KAnVUbgmWXDNQ9NmDyjYvHOkPbWaorBcxvQBoxIlNHdh8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(2906002)(8676002)(52116002)(44832011)(6666004)(5660300002)(316002)(86362001)(6512007)(1076003)(8936002)(110136005)(54906003)(186003)(2616005)(26005)(956004)(38100700002)(508600001)(38350700002)(36756003)(83380400001)(66476007)(66946007)(66556008)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YFQ1dI9pGIPM3J146V0CxgdzyjvPbiEnuKc1TSAuqU7bQxO2hU1MLuTsqqqH?=
 =?us-ascii?Q?1QmfBpLyvnKVMgr6HQqWccvbW+v8TSePPzI0boE3b0OON91E7aVmzvFBM3gg?=
 =?us-ascii?Q?SwuFmfXyr6ZaE0dDEsi3lSCo3lbO7PfhhYkid4i87Fd1HN/vobK4HyEKLfBb?=
 =?us-ascii?Q?KR4AmSrU1HW0DKytwzpp+ef8CaXJ9XJxKlPvYD8n319DgdlXQawZOY35EJ4b?=
 =?us-ascii?Q?Nf9rOBQoigiT0u6k4JSPDgTZ0Q2iIGvA9aqR7RvnRLAAvNqlf27HTn33mWHB?=
 =?us-ascii?Q?SbMy9KwUPKPJuq1RT8sCCsYJfR7WVwg8XWIYP+C30xkYhC+/r7vZwZzFYYcs?=
 =?us-ascii?Q?wdk8tz1/QDKmWOtbrHw/lPxYuxFsY0vguD4+BT8UCkmjMkBizjgI5nEpDHcU?=
 =?us-ascii?Q?7A9cDGMlKBlxCHvZyakR3EmhhXplS/fGdFFWFUcXHRLs0G330P9pBVYoj35N?=
 =?us-ascii?Q?kEpnfhYZvk5a3N/wQXzW++zTnJVkIwhQEqeCP9IA+KBas/U7dxW6tZo2AR0v?=
 =?us-ascii?Q?52KaRtLesQ11cCNc2IIFTqicHWvMgEWn2esR3/SdrtOoMKxHu21MD3hp3yCB?=
 =?us-ascii?Q?3P/SWcEufrZwf6DF2SqsxE9o64/WTrYN5n3c4Iu5r46R0hoLYzSLhrH30WTC?=
 =?us-ascii?Q?JMtLQgTdQhA6LegscQ6C0dO5y2Lyknc7dvXxDfbFR8ulu0nO2TD/etm47AhZ?=
 =?us-ascii?Q?YQipEeLt1nfLNREZDB5InaYtInd2lgzUvp5wQ0yzzAzL4R3swsIzIyTcpU49?=
 =?us-ascii?Q?C/KrOMdknAGdVmwg6qwl36a2zgDm7nXncIE4oX59WXSm8J+z7lQYSqmevget?=
 =?us-ascii?Q?wYQWzQnjid31EiU8ztLgMy2peEz7rgI2ehJEpkKp+YPF0FW8flDDDgH3oYrT?=
 =?us-ascii?Q?xuMH4+yRge1N3OdxmnK8Bn1jVmGo4ifkGD+b6vJbZYDWue/R8S43l0SRvSfv?=
 =?us-ascii?Q?lFvi8qgFpI/0nucxJST3/GErrwXtWA3i4/5zaAkaUsU3eq3Coh0ppaY58wI3?=
 =?us-ascii?Q?eSX1MzDcAndcd35tldi6fQQdXK1qWfsNpbNIIdwrRTzDJGbwLVCBstwo6wqX?=
 =?us-ascii?Q?HUh1Yb4OdjnbrEAWR7+AvJYdrrKiOtMU+kh01lVHKDI3hEY1emKld8ZTbvXO?=
 =?us-ascii?Q?ziG5EJ4CdObsbeeu562VTXgG6clGs0NH22gdY0mN9a/yWe4N/F6oRaKvlBs2?=
 =?us-ascii?Q?vGhiTrNrRflZzymZBkRFAg1vjI9TXu8a1ep54PNfAs98i028VaSHc+4ZA+c6?=
 =?us-ascii?Q?l+j30G0vPz9aZgf5H27w12SBBMbz+zBNIklhhtzJ2T3qw5VSjp/QOG+wvh7v?=
 =?us-ascii?Q?LMZMZ+pa/x8tgZXEixX/y0/G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc3deb9-8796-415c-0602-08d993f101c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:42:37.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivMA3ovEWjWHP+JFLKQox0fIzbRVVWcRT+PFygRH8nuBLzo2zS08Qv2NWuO/C9AqFuKaVSyfmdsQV/iaBD9ISg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code checks whether the skb had one-step TX timestamping enabled, in
order to schedule the work item for emptying the priv->tx_skbs queue.

That code checks for "tx_swbd->skb" directly, when we already had a skb
retrieved using enetc_tx_swbd_get_skb(tx_swbd) - a TX software BD can
also hold an XDP_TX packet or an XDP frame. But since the direct tx_swbd
dereference is in an "if" block guarded by the non-NULL quality of
"skb", accessing "tx_swbd->skb" directly is not wrong, just confusing.

Just use the local variable named "skb".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 082b94e482ce..504e12554079 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -831,8 +831,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		if (xdp_frame) {
 			xdp_return_frame(xdp_frame);
 		} else if (skb) {
-			if (unlikely(tx_swbd->skb->cb[0] &
-				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
+			if (unlikely(skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
 				/* Start work to release lock for next one-step
 				 * timestamping packet. And send one skb in
 				 * tx_skbs queue if has.
-- 
2.25.1

