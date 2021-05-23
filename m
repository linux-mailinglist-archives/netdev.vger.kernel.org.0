Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2845238DADC
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhEWKVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 06:21:52 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:54404
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231679AbhEWKVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 06:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ789qUxDS+SBSQTgk78H71hQNCHCyedA5zwFp1CG2M6+Vkc+t3xwNmRGS8aSuVqTLClWz+ArmnVA6sCDqn699juT5Lrm1leVKN1tWBaClGbZER7G+oHjw2DZx9xTeSoCBhhGJwA5pZeSzFEbpS7St8JoYzCadxYs76sasI2xsJ9XTGAGzBmmLaxtPW2dmpr+fFOAKzokBcVa46g53aV29yAuKMIs8NsHuQYkCrc31+eZ50oN+BXADvOtF+zx6wk9mKlUYCZrwfDhdHjjG/Tysy3WWTf3Sj67uRIbgdkY3hsrz1Kgxsq8blS4TWO8d+nGUBeY7Kh7dWsFIAoOHFlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKHZpCmVVrs352R36zdDRDFPgWSipm6CaaoVffD2s2I=;
 b=U4KIAQzeNksKa3rjfhWMcw2D4g0GXNXR+BDDaod4m261SOCD2XxWinlIip0kdzBSVCI7WX7KBrlSGDvpknaSFLbyf1wn/nNDL2MI7LJW7+VJFfhOtXhyqC5FJCPHO77sOIf86/wW+nAIBGHAG87+C0cQsUyHjBF3gMF4wW4LRYpibQUpbmTSqj6XNyoBHNGxNyxX+moP/D4hChoRno0qPK4Yw654W555ZcMcwB4NXrwNqC0KmWmpOE8kcTdku8cP8r9qeu3f3W7xh18KRfBxQ6FsSqJXg0ply32RL6WC2jtmr9UqgfN9BvsSQju4meKHQOTIOcEbzSFFemfjRJ6SXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKHZpCmVVrs352R36zdDRDFPgWSipm6CaaoVffD2s2I=;
 b=NJGcQiGsPYVyRABInOsfG77+6wMTJ9L5LmxVVy/tBRqDa1jVvHctho6SyxATIsXdsaPmA9+RdoTkRiLIbayxEGp7D4mZjpn3xBgTVtRDOltlLXwXVmYeQXe+t6p9T44S63vOSU/oN41nvctSly1HreaWI58N56YuMw9i5niKer4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5788.eurprd04.prod.outlook.com (2603:10a6:10:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 10:20:19 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 10:20:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [RFC net-next 1/2] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
Date:   Sun, 23 May 2021 18:20:18 +0800
Message-Id: <20210523102019.29440-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:54::17) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0053.apcprd02.prod.outlook.com (2603:1096:4:54::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sun, 23 May 2021 10:20:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4bce9b-157d-4e69-1a29-08d91dd45dbb
X-MS-TrafficTypeDiagnostic: DB8PR04MB5788:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5788C66CCE95D58B135CF5C3E6279@DB8PR04MB5788.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIz92IWXAb1u+o884gDAcef9GEc9q3VnoaNOiaqp6F0xu+Je9GueGphRPuNbNTf7Lq+OeHNhhhFCAh7Pfzar5s4Qi6vjRJbNJ9Q3LwIEF1of5YNOA3Mh1Dv4ez1iVdxc9XdEAvVk6LXGDwsjp/m9HITbI5hx3g3LC2wjgRhszQaTiaTgSiYyr5paF5iEGuVvrlX1sdQSkle2vcRV6y3qGsxdukdsS564IMOt/hcpKbys8WPf+3YR2uRzmMLi7TOsOuY7Ec1tm+ZWtK5Jmp1S7UwYSmaDSWwBAwFgLjByuyDFoSg+G1dYv/rWWJZiZXohmhAePeB/D/2WnJiLMJgW+VE6sg6NVsNw9voZaxOE/c4smcqXXg+hMFkf+6XXuJrQl5d7n6NtxXQhpMcjcT8w971t0an4PY9SGfKBcfKj0qe/GV+UtMAZ1vPyro/4YlJBErXQqePnBWeic2n3H8VtmQ2M+IR4OfLf5Bsju4YrlmTEw43B98aW9utP/Et/NJyqSjWcrwURvBHFJqOWmYn9xiK4QfJbtBIZuYib/kuu2Ckcq34IhKnwn/GWAT7qgvN3sNOoF559WenqT2XSCgDSFBD2r+MJYLQk6hvcrf1jEg4eVvUSFFr/yEbHRLLLCHegRql/H7G3zUMa5d5kfVXgmkQY0a6T4Ww8hWHvibthpImUlvnE+cZkEa2UyN3+YYzQ0pAZETKAbwj5ByOTK9rgwM6wyES5Npvn1NO7wfeq2L7H7C+kgnqfBmJyxvPGlunVw5+6DKiqaAkQIAAou3EPkCYqmoYuZ8ibqvFMIBFKz2FCGQjfVmC6wlhulKtzeEKH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(52116002)(8676002)(83380400001)(478600001)(316002)(966005)(86362001)(6486002)(66946007)(38100700002)(38350700002)(4326008)(66476007)(6512007)(16526019)(186003)(2616005)(36756003)(2906002)(6506007)(66556008)(8936002)(26005)(1076003)(956004)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TWgA1nkFEH76VbTHmOyMwad44OhzXmYePie++xk9e0QEkFrmTFwkEXI7BXN7?=
 =?us-ascii?Q?v5pvZUVE1CsT/YtNB7HIeItiHBqS8+V93srYLR4If6EXdupS7b7FZiL/3wDk?=
 =?us-ascii?Q?BFpCSlu6YGjds9Aje1T0YnLL4aTUkbRQK8KIhfeYTy2tHTL+RgubpvY35SDN?=
 =?us-ascii?Q?wv3z7egFkCXj2bpd/pc2Xo9MT9XGIwjvJeUtVbAvfn7o6sHNpW5tkcC86O3u?=
 =?us-ascii?Q?2zb2b7yZIPRA1XYuoNTKAF6UPsKbwHHdeNUGCX1OriSkPpPWZpXiB1odxsXI?=
 =?us-ascii?Q?VYyGu3tbtSUInwNHkhaF4Zb4aVJLtUyr9EyzvaibduZncRgIioLKXWMpnvqK?=
 =?us-ascii?Q?FLXYLLXGfQ4f7Sm5ZiSNrx1m3rrRhiCI2lyJh/bzijGT80kKlG1J8l0mHiBJ?=
 =?us-ascii?Q?yzy7ynzN9n8FV2DRM/YekCM4iUY/TIplj/xdxL0X7w7jJDcGZuuML7XhO6jj?=
 =?us-ascii?Q?5YHkLJ6qOpD8ae7zv4awVQwUA1iH5LJHv81tqeMmHHc42zewGeRbl+7+SMXk?=
 =?us-ascii?Q?K88unfvUv/sbbj8ASwcNZRigtMIO+C0o59aKFVROJOW1qbs9YAmW/OJrIVsZ?=
 =?us-ascii?Q?Fo0ONMEzpE74JYJnl14STCrvAcrcGGwEPwD3QHk7ESihAai8nRQD2PFMqvxZ?=
 =?us-ascii?Q?Uk+mA/q3JuY6m+UUP1COj7g08as9Maa3AGh7TbA6EmZYZlmFHDgEKGlYW0+S?=
 =?us-ascii?Q?Nltw6/BAYHnLpEHFAPFBq1eQY+Yeo/0Rx5B8JOF3HecTfOySK7LP8BSfQKEJ?=
 =?us-ascii?Q?8ZtGAReTlOKRvQlUiMFRpVud9MaVo8oLfue9NvquqxuezWy+xNmaxh3wDxgM?=
 =?us-ascii?Q?6bbnnSUcM8/VVhICllnMnxZ8l9EQNgoDTdK1T7sUmvNsIYR/J0ZH0mCEJl+6?=
 =?us-ascii?Q?errl/ewCMvmdNsR9DayztaYJPs6W8u4MoqJXH9kDoCBa/lAWS7Nj8sIaD4qt?=
 =?us-ascii?Q?keo/vKSl8GMUXvxdbjGW/g7aYDt/alKDay/iOmx5QkrWxpIfwvQ62cvqt6GG?=
 =?us-ascii?Q?HBv5la6I+BvXtEWIj7NsJBtzxHxfY+/hCZtKKsxKllBLddI96WhBHpm8GjnZ?=
 =?us-ascii?Q?iRV3/sX9uUxovDZwkLf0OnKmgExyN4LkA6X9WMNLxAzqmhSG5pmnwx5Hc6Qf?=
 =?us-ascii?Q?LLCunbeuvUegkU/BL9XEnigOpKdpnMdYvKugCBPQDRCZ74AtCGV4Wd0gCIfE?=
 =?us-ascii?Q?UIShiFQXlRf3Z96KFReGZwcMU+vQxvQwjdAwtp/W6/Fh9bxMC3s5tM79T42f?=
 =?us-ascii?Q?Lh2qFoQjBdcVSds3PBIyhR2W6LHoi9IU6OXdgcEgkk7J/H0idWZv7nakQCXf?=
 =?us-ascii?Q?J5+Ub+BBc7UAlnHlWufWtqJ5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4bce9b-157d-4e69-1a29-08d91dd45dbb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 10:20:19.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yu/aySWx3FQ0AIGx431w/WXh3e1XOCDm6iui2KvGc8xnJPQFRnreLvYzjwgACDtVjqNIVg8IIoFxksQANmLvkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5788
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
configured to Credit-based scheme, 50% bandwidth of queue 1&2.

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
represents i.MX6SX, it is safe for us remove FEC_QUIRK_HAS_AVB quirk
now.

FEC_QUIRK_HAS_AVB quirk is set by default in the driver, and users may
not know much about driver details, they would waste effort to find the
root cause, that if not we want. The following patch is a implementation
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

