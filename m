Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B999392D93
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhE0MJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 08:09:19 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:4997
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234851AbhE0MJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 08:09:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IarW5emO6hSBGOaASrBb2AjPKbZxEZIboBtb97DHsEjdAd+BMGTaqTMVa+DID5JkVrAt18fdjucNod+fH5PjVhS+/njXUPEFbTU+V3kYaUdTJvgk4r9fruKDxHlNmS7hn3lioEJpjNOrsONy8PA70OUtcIadBgHqqTQvk31D0vObuagmYrG0ErEpy7CA7je2W2sJ0RWoskNhiXKYPze4M40eeNozYTKojZyzx2yxpVaUC0vHhH6rdv1XKoWhnTgeDPw+cVRoUsjMIgOb4aRqQN+vzGH3lJIrjDxFyG7Mz+gvKNldvxROtfRohq1a+CvUIxISXqiSe58At3/RyVM2bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEAZ0cXI8IU5liYHhVRnk3ueq7FN6HHLNq7gQFukjzo=;
 b=VWOYN2E3dvKME1E7+GPbKQxjM8/YgcfAsExV8BfWxe0ZPjHB9vjPmxaPiH11WwbEAmfHpNGpnuAMimbYhzS7SWqcoTZNXuqG9F1nAmob4LSlu1KVxuYbMQISwKWD1StKg6mcjFs6kQLsvUK4AdMaXOmOOOnEnVNjelUOPJ858J+Zizh25dELrQl5xndta0owC5B/pBPYi3TL/Tz9lr3Spxvc7RKVaFgeVSqaN1dbEBuigbe1vvCaLpogylDo/kf3VRMPXi5mvKBQTYIJ+PFouG6pjD4sIWjXWCCsQIxfpk1Kki04B/lHkZzAbo08U9YK2iDQ21hIRgzt/kyhzx/qdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEAZ0cXI8IU5liYHhVRnk3ueq7FN6HHLNq7gQFukjzo=;
 b=bwu2idZLKeOzWyAIjjWpxJbVArPNjiJN/1AIgYsjKtzoTsJ4UV8iAI7z+rY4OroxdPDh3JvKQzcwGzdQFgLH3LzcWTYHP6+OQh6A3Qyje54gjPZCA8f1sGKg5jDLeJHyJAigjWtp5ntvnIVtCqGYW7kNoQ9eh56NEAx8Sf7dCKM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 12:07:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 12:07:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V1 net-next 1/2] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
Date:   Thu, 27 May 2021 20:07:21 +0800
Message-Id: <20210527120722.16965-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0110.apcprd02.prod.outlook.com (2603:1096:4:92::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 12:07:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2c56aa1-6791-4788-8b53-08d9210801be
X-MS-TrafficTypeDiagnostic: DB9PR04MB8429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB8429686D0D9A81A6FE8D5CF4E6239@DB9PR04MB8429.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aiuapcQATexLoNpciJeBV+qZGTJ6AN3CaZyesKF7BnrOuRD/yeqvJov6RGYGR+rJ6sPU/LfStb8TWrmo5P36seQerWcTRedFP05kEUn/Rte8KxAXu7JDYL3zvx/vsbcQ1Sla9wkXZJnm6EaJtoecshmq9Fyc6vg1p6a8OqbFH8+4Iq/2iREcnV0gcdUIzw0alMxnMG1mC+sYgfGtWw7Joi0ojGAbQuTFHEzbkAESukIB+8Hk2PZkgLmcuZvVbrz7jJbc2eaPwxbl6vfeAa3RIABsSrTKISLnxPp8GB7r3OpneNcM+Ekz1o1hF9JgFjQY/bzCvk+8azumumEd0v5aZYkz8djSU0QpqzbCPqI9sZB7U9NS+0pv34K3UxNwe4H0Bi76d9n4AEu7Z3p8WYUs6FQ1L+3zoly5lgjdehVneZigfifAKeyQHLJI5OT0a9/p810OMJ4bhbKLwLK4zG1KrPbbnbcrF2O0PA/wsUMtlVlnhMP0ezKspQ45huEbS41zB3wrWsqvd+eCXvA4kPiV4MCOt66JvbvsFsgIvzzI7cUFC2nkgPQ7hqA6dfIM9Pr75XIjgV4O6FybuxL8/BW9qHG48NhwEtt7whoj4uJy3UADvMNHFTImieXv85RC94AT9lBDT1qI/Jhuf2CwIo4JCrcNowEItaCoIg1bDwPJuNwDSAUiYLkV58JAmNii+SRaYaBrgrze13Ca671ZBdiVC8Hzs2p29iMA4/wWnVH2mytKwRjVqnsEwKQl96Du+f9Z8BIomwuM7TtuiuKusT663jQVfabcmxcA/nUbKoJ74ToJgTw2aEyfVMeSWt5JgAtx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39850400004)(136003)(26005)(6512007)(83380400001)(38350700002)(38100700002)(186003)(16526019)(2906002)(86362001)(8936002)(8676002)(4326008)(6506007)(6486002)(966005)(52116002)(6666004)(66556008)(66476007)(316002)(1076003)(66946007)(2616005)(956004)(5660300002)(36756003)(478600001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?44Yq2pK5NjFzYKaiX61AEUvV5fPG10GAI4GqTQX/5r9os6fDYYJIG3XOpj+q?=
 =?us-ascii?Q?7CNbXARh12DPcw/0h15mY36ZFpQLa3ULGz6/3x5fiVrDqEtmpJ0Q3JLNYtDP?=
 =?us-ascii?Q?M+7RnQyQHo/Fsxpn0pAgUspPp/NVyPrnn8AzWFYYBqVFCFHB/loeeCc1p9qm?=
 =?us-ascii?Q?lQ208yY3pi7jugzKpqERgnryh+w1MMGgr8nx+kZOSCJak684sQn+KflJfx5q?=
 =?us-ascii?Q?KEK/vRTpoyHIVMtVH4T84t0ugN5uR1PZi2VGbsqM4k0uDw7wIKRZ7pGWS9gs?=
 =?us-ascii?Q?G0ss6mqjKgN6IYRLp9zXyn4L4yLQfD7NY1i33oJULeDO+7IwjkLGn9GSpirI?=
 =?us-ascii?Q?yPKlgKcD2UTv6uUONS/87w85FY4FXub3pssIfUK6CZnN7uSB/9HOr6S0/Dl8?=
 =?us-ascii?Q?QJfIQk04pp5JwmzS6Xc5NS0llG2UK4vZUoaA5nXeb4jd4I9jKVTK2oWoF67Y?=
 =?us-ascii?Q?+4PG5QAVjMqhEasv6E3IPijbrxJEoUdJnY3OMGdr8VU62w7tlJU00aANgzxM?=
 =?us-ascii?Q?9kRX9N15L1jr0CVBd6WtgnUj7fqKPC9eb30un5KXY4R4p0hQ9eOA4x1VhBtZ?=
 =?us-ascii?Q?tRrk/dbwVokiZlVBFDKYzZ6rRjrAioJYRzl+g6QuSTR1Cfe7qAbF/VwDdeuJ?=
 =?us-ascii?Q?di5lLYd+UudBVajrV7paJje4CPmh9ckj8RBKNWuvUUjXZuBcDXDxq2YY3KY2?=
 =?us-ascii?Q?NUCXkcQXKBAxRVWUNeh2RFfF0xSctVzit+aGCvqgHp8rseNzun9/2nnDY6MA?=
 =?us-ascii?Q?93WpaYA8o5bX0+1Lrn7v6I+RGV2HcI5+5MFkpM32QcF4sV3jxS8Z3O0x/Bkh?=
 =?us-ascii?Q?+rbjnWYtPqZYc75tkBNHLth5JwFaDU+/FdjSDpPRmdQ1wticoGO8f292DU7c?=
 =?us-ascii?Q?+wkN9LhiC7R/qvilKOf9K8NYrmKvj7RLhH1bcvNFdI/QwjBHcjkJl9YYPlHx?=
 =?us-ascii?Q?qntNhAaG0HTY5uLcB/f/2RBZYAcSPyoK0G5XPp5WvKuGYxDt1BDFl2KtZ/II?=
 =?us-ascii?Q?WbyDwK5nxOBHKdU4dSY+Ss20ToCAtek7y3oI+PRfJBMmDMsHaufloVNZwzn9?=
 =?us-ascii?Q?6L+yNqUxEhVrkrlsSVYwI+GxUk0v7rHusTEXQGvBbYFr4Cohi2HcRAj8txvn?=
 =?us-ascii?Q?4QqLHcwt8FDZW/pv2g0kRbMQr14IZVerrn/8X5k5kH+jbvzLIFA58TugN5B6?=
 =?us-ascii?Q?anIrMDn/DxyWNPVjpjWp5KFRMgx1Mv1esQ0Uoxv1RUgdRCjPnLsVlGgZwdMA?=
 =?us-ascii?Q?fuyYB0VuW0ov88S8F7ZaJ6bc3sUzR4QM8qKommnskq5bfmUXFm+v/FFZpS19?=
 =?us-ascii?Q?pAhd2qunstnjvs7UzD+MSwO1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c56aa1-6791-4788-8b53-08d9210801be
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:07:32.4297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxryIUsiJNgChLVr8k+Hm2GfL4wwbTMoiM4vu3dI0HE6nMWLzdgvDyiXAQUp50juZoc7bkrXVWElHXTQT0a3fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frieder Schrempf reported a TX throuthput issue [1], it happens quite often
that the measured bandwidth in TX direction drops from its expected/nominal
value to something like ~50% (for 100M) or ~67% (for 1G) connections.

[1] https://lore.kernel.org/linux-arm-kernel/421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de/

The issue becomes clear after digging into it, Net core would select
queues when transmitting packets. Since FEC have not impletemented
ndo_select_queue callback yet, so it will call netdev_pick_tx to select
queues randomly.

For i.MX6SX ENET IP with AVB support, driver default enables this
feature. According to the setting of QOS/RCMRn/DMAnCFG registers, AVB
configured to Credit-based scheme, 50% bandwidth of each queue 1&2.

With below tests let me think more:
1) With FEC_QUIRK_HAS_AVB quirk, can reproduce TX bandwidth fluctuations issue.
2) Without FEC_QUIRK_HAS_AVB quirk, can't reproduce TX bandwidth fluctuations issue.

The related difference with or w/o FEC_QUIRK_HAS_AVB quirk is that, whether we
program FTYPE field of TxBD or not. As I describe above, AVB feature is
enabled by default. With FEC_QUIRK_HAS_AVB quirk, frames in queue 0
marked as non-AVB, and frames in queue 1&2 marked as AVB Class A&B. It's
unreasonable if frames in queue 1&2 are not required to be time-sensitive.
So when Net core select tx queues ramdomly, Credit-based scheme would work
and lead to TX bandwidth fluctuated. On the other hand, w/o
FEC_QUIRK_HAS_AVB quirk, frames in queue 1&2 are all marked as non-AVB, so
Credit-based scheme would not work.

Till now, how can we fix this TX throughput issue? Yes, please remove
FEC_QUIRK_HAS_AVB quirk if you suffer it from time-nonsensitive networking.
However, this quirk is used to indicate i.MX6SX, other setting depends
on it. So this patch adds a new quirk FEC_QUIRK_HAS_MULTI_QUEUES to
represent i.MX6SX, it is safe for us remove FEC_QUIRK_HAS_AVB quirk
now.

FEC_QUIRK_HAS_AVB quirk is set by default in the driver, and users may
not know much about driver details, they would waste effort to find the
root cause, that is not we want. The following patch is a implementation
to fix it and users don't need to modify the driver.

Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0602d5d5d2ee..2e002e4b4b4a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -467,6 +467,11 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_NO_HARD_RESET		(1 << 18)
 
+/* i.MX6SX ENET IP supports multiple queues (3 queues), use this quirk to
+ * represents this ENET IP.
+ */
+#define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f2065f9d02e6..053a0e547e4f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -122,7 +122,7 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
-		  FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -421,6 +421,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 				estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
+
 			ebdp->cbd_bdu = 0;
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
@@ -954,7 +955,7 @@ fec_restart(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (fep->quirks & FEC_QUIRK_HAS_AVB ||
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
 	    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
@@ -1165,7 +1166,7 @@ fec_stop(struct net_device *ndev)
 	 * instead of reset MAC itself.
 	 */
 	if (!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 			writel(0, fep->hwp + FEC_ECNTRL);
 		} else {
 			writel(1, fep->hwp + FEC_ECNTRL);
@@ -2566,7 +2567,7 @@ static void fec_enet_itr_coal_set(struct net_device *ndev)
 
 	writel(tx_itr, fep->hwp + FEC_TXIC0);
 	writel(rx_itr, fep->hwp + FEC_RXIC0);
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		writel(tx_itr, fep->hwp + FEC_TXIC1);
 		writel(rx_itr, fep->hwp + FEC_RXIC1);
 		writel(tx_itr, fep->hwp + FEC_TXIC2);
@@ -3361,7 +3362,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		fep->tx_align = 0;
 		fep->rx_align = 0x3f;
 	}
-- 
2.17.1

