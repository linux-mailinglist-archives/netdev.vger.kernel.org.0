Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B632442DFD5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhJNRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:20 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233025AbhJNRFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlWrmz3BMJ+83Q7oUHvp1LRdxeRHSxAXsbJ+QtgyxvkkV0mTIN/Qm9VfwZH5wqYlLqALu8PYFWipiDJ9w3nUNyxWXhKeMpw0LQx3SE3dh4KSqlzJnOcWz9GiNZKRrPekstzJ3EY4jXO2oaLGxRRo2wvqJOX9m7hHqMDhgeoLsTPbRItoL/FGof54v2uWuGDc06B0w5zCzc38KMqMkR6kfgrXu5w+m56OvFtnFL8yPSlukg+0uDHA/2m2fIZpNBSb9CVVzZv4Mls0aAjqo1qiysFApxMhcTiFcy47XdPQroWtHunU2y6x6aY6WdV0fxxLOQF7wv1Kuokc6IBlzXcFNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO9H/PtdWRYzOjvfIswzxLjZeVAcdTaqV7EN6V/Y4QY=;
 b=cAKsdn1hEJWyVNwTw13yFGvn6XeRCZmJCGyUBsxMPm2sRXA3wIJeUZgj6HkwEr2li6cfaaJfkPAZNDLVcFN+TmZTwCWHdchSWfPswKapPt9eexFJRWc8bEFIVP/cLN1dInIWWBeg/gLUVWMe4rGcNK9I3z/US9/3NPJjlAb5vesvFSIG3rGJd5Gm//FoszEJ/WvGRlcTmWkvwurrs5t7WxXXdZhaKqf+W7T9KMfgM4PNpCO9GGngoqn7TN0UBd7Lktvng4gTrnVbynzCGc0wTPx0/d98IxvIDNAhHjJTbVWPpog0woRSRmcjdbdFT5JS0o7egu8YxjaVeE9Uoal/lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO9H/PtdWRYzOjvfIswzxLjZeVAcdTaqV7EN6V/Y4QY=;
 b=cJf9R7sLUH4eMCmyUC0BiDzypb3ba/nrlbyncl6pObSkZPwW4bo0qUWksjbfcZsDH0pZGGZnmR/Fwh5jKJehBpqRiGQZ+0EE9vyUtPzX4XPI6o+3CI+ygt4DG3u0zS+G3WMyTZ1Q+qxGtrcuRxOa6iCxX+NJPwhUiMc8nGIYuRY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:03:02 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:03:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] net: dpaa2: add adaptive interrupt coalescing
Date:   Thu, 14 Oct 2021 20:02:15 +0300
Message-Id: <20211014170215.132687-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014170215.132687-1-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:03:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a0e1d4e-eab3-484a-c8a2-08d98f347b26
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB582565EAC4CF192BC55CAC89E0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSf7giV6MMhWW2vC8Vd8hw9528/0bv75a71Hr2gKln8+5xCYgGY+1DU9B1enf2z3iXRLwIWUdohMAIWHUTZ8qrYAiuriELdgpbFIyHziV334UR6HqHPFRxetvl+ERy1Npyfp9aMGk0UD/dBRkQxLemmWaT0kYZ5op581pfA9+bLETVbOkGAxao8QzxqTcVBPW/tud8WFCknINp45q7x5smgwJaviuTVt5nkd7aOtGCPAw+mweOeYmbCGX40JeKn7NmEHUHCO3HjgE/+LgDMFqmH5VBePy9VvN7q+q0X9XM7ZghAO7OkkM/HdOcGFbCB6dnt8iKU4QZhJO0E1UfVlcdU8ON+/B72I+zFNQfO/KO/o04/FVPEIRhPKaIRXSkmR2ji7TI/1TRVWuTGDJuKqi1Yn4CTpXPwv1m5uAMqxqBblpPSoSXcZgO8IYyUpKdeQtx0SvebVyafTLwx+08uZLJHZ3XiFLroOekzgY+UCrPkj+UeNQjm+XIUd9gQi9d1xAfqvgqVi6PDLaRNUbR1Wi7sxZh5LbM4kgSrdboVUYCflB/M0e9mk5plupRENocWjKQ5PHExNibnkDwI3vn6NVxEh1Fsj2hT5jvRRS4wsP/I4qkFA74SVIvalNZ4kM9DHBQEo/JSAR4Tk8MY8pPljfwUW6rUokQLRPRqzOZjexZXorp3j+IOKBEtiyvdB6uPpOiSggWTnKkfCf27jKfrYRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VzLLUSEzuOS8qOpgBtu51mAwRogH8CLs4/qwdOcJg6WavCH2igFO4nEH0cYg?=
 =?us-ascii?Q?P5c7g0adNYGFaDgCtFKWBF21nT98Sjf2hJ6wqToy4kHx3snGTDoBdtOnkb/d?=
 =?us-ascii?Q?VMNzpd3fV5GLV6nTmMQTO3ANzAwQqtXJQy/UQx6X/cn/NBFRze2oJBd33mB7?=
 =?us-ascii?Q?8jUcNa2d/lVFGEeSGN6uu7pRx6PDYfAsHfqNTEbJgumN1N3eVZAiY1h9StPx?=
 =?us-ascii?Q?K2uSvRU4xnu6Mexm/VkuOwbOACpg8/3hpxl0GyWwuetiGUV5ifdylztyw1df?=
 =?us-ascii?Q?QCDG/aTPAU06VG4jmF9iv2oGiWYiHVHDM1BtQVVXiw20+tl6yQZNuvdAneE9?=
 =?us-ascii?Q?U+Mja6YZuKR+YYqorjigsFQTMoOQp6u4+CGJrlX+dYQLZVUPTf7aklaAjZ/5?=
 =?us-ascii?Q?GkI1J9a50jJHhAQ9zVvc3AtiuLVV24QBY6WK6hKQN5Zk/gSaYnpvNdW8PAPv?=
 =?us-ascii?Q?u0VU4zEbnljNYxV76Rsw+K6qTCK0Q8H1jn13QAlaeG013UCgzRGNU6khWG1N?=
 =?us-ascii?Q?ejJ956AjrxQThG3GlhQpL5GTO0lE30NUpSWtamDfz2jQf5KwteyBR1sETEM0?=
 =?us-ascii?Q?kdHSdX0sLvWztw+YDxvqgs3FRzHk+8vwUG30gfdFK6FocURz+lLHl/RosFYF?=
 =?us-ascii?Q?mQl8yF+WsSxbBbXVICWUpBgVRIXv0tiwg7rvFcxnluMtQcJMrCvpVJMtwaKW?=
 =?us-ascii?Q?lbEwlNYZW1ZdMc0LM9N46F0N9Bq51C0gzhoyH0Lyus/I8+fdc7TcTeLrKsX3?=
 =?us-ascii?Q?5vZICJIRRSZuXKCsOALfoZZu1tHHey0ZzuLnKv+QNexqfcRX0KgKdWH0hz3T?=
 =?us-ascii?Q?FBgexUxsK8xgEum0bCAV8dmicgOFjUVWkAdDFTBXH+TPLvJ1PqTkj6paTZml?=
 =?us-ascii?Q?sVJLWCCgG19u1G6ObbeqtZAOUbWEcCcIqomfdupbgSvX9yzX/OTG6s9/H5Y3?=
 =?us-ascii?Q?nI8yv+0xt35DnHxgRSoLmzKwqinFd2mDlTZhyM3Rcfr+0LrhpB4D2w5res/O?=
 =?us-ascii?Q?DZh+0qtXif2UrKA62spvtICeFa/VdG9NrtX5HstFJ0XEnshGYay8khmu/PFt?=
 =?us-ascii?Q?d3RdsccIbJH51EJ2lxPQTSoz2Wp7D8vN35Hq+QUk8ZTC9SGjTEZEsH4dUP2H?=
 =?us-ascii?Q?/Ggg8ApRIUPNx9QLGnDBegKkdNrzZaHndm05qYPXIJYLnrfit4ETClphf2EN?=
 =?us-ascii?Q?KOK54pIwRvti5PXdA3tjMA4zC3oV+oIJlfJy31Tf6+mjUxdxi7LE6miqFbGB?=
 =?us-ascii?Q?8ErU7G/PeSNLeOU22iH9dWrs9K5gWXxhZgaNnvXAV1A+gFda8ezdRsvSJCUo?=
 =?us-ascii?Q?pGZLUerpiyOE82B+K7fINc0v?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0e1d4e-eab3-484a-c8a2-08d98f347b26
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:03:01.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjE9JApm/IBe5z9BG7LpXZ8FuRWWOKAMt03m56HpPipzEOltESVWY+j+mm22UfRSJXvHhdatzIDdYwq/mrRKwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for adaptive interrupt coalescing to the dpaa2-eth driver.
First of all, ETHTOOL_COALESCE_USE_ADAPTIVE_RX is defined as a supported
coalesce parameter and the requested state is configured through the
dpio APIs added in the previous patch.

Besides the ethtool API interaction, we keep track of how many bytes and
frames are dequeued per CDAN (Channel Data Availability Notification)
and update the Net DIM instance through the dpaa2_io_update_net_dim()
API.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     | 11 ++++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     |  2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c |  9 ++++++++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 34f189271ef2..714e961e7a77 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -533,6 +533,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 
 	percpu_stats->rx_packets++;
 	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
+	ch->stats.bytes_per_cdan += dpaa2_fd_get_len(fd);
 
 	list_add_tail(&skb->list, ch->rx_list);
 
@@ -641,6 +642,7 @@ static int dpaa2_eth_consume_frames(struct dpaa2_eth_channel *ch,
 
 	fq->stats.frames += cleaned;
 	ch->stats.frames += cleaned;
+	ch->stats.frames_per_cdan += cleaned;
 
 	/* A dequeue operation only pulls frames from a single queue
 	 * into the store. Return the frame queue as an out param.
@@ -1264,7 +1266,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 
 /* Tx confirmation frame processing routine */
 static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
-			      struct dpaa2_eth_channel *ch __always_unused,
+			      struct dpaa2_eth_channel *ch,
 			      const struct dpaa2_fd *fd,
 			      struct dpaa2_eth_fq *fq)
 {
@@ -1279,6 +1281,7 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 	percpu_extras->tx_conf_frames++;
 	percpu_extras->tx_conf_bytes += fd_len;
+	ch->stats.bytes_per_cdan += fd_len;
 
 	/* Check frame errors in the FD field */
 	fd_errors = dpaa2_fd_get_ctrl(fd) & DPAA2_FD_TX_ERR_MASK;
@@ -1601,6 +1604,12 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		}
 	} while (store_cleaned);
 
+	/* Update NET DIM with the values for this CDAN */
+	dpaa2_io_update_net_dim(ch->dpio, ch->stats.frames_per_cdan,
+				ch->stats.bytes_per_cdan);
+	ch->stats.frames_per_cdan = 0;
+	ch->stats.bytes_per_cdan = 0;
+
 	/* We didn't consume the entire budget, so finish napi and
 	 * re-enable data availability notifications
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 628d2d45f045..2085844227fe 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -384,6 +384,8 @@ struct dpaa2_eth_ch_stats {
 	__u64 xdp_redirect;
 	/* Must be last, does not show up in ethtool stats */
 	__u64 frames;
+	__u64 frames_per_cdan;
+	__u64 bytes_per_cdan;
 };
 
 /* Maximum number of queues associated with a DPNI */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 69a6860e11fa..adb8ce5306ee 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -829,6 +829,7 @@ static int dpaa2_eth_get_coalesce(struct net_device *dev,
 	struct dpaa2_io *dpio = priv->channel[0]->dpio;
 
 	dpaa2_io_get_irq_coalescing(dpio, &ic->rx_coalesce_usecs);
+	ic->use_adaptive_rx_coalesce = dpaa2_io_get_adaptive_coalescing(dpio);
 
 	return 0;
 }
@@ -840,17 +841,21 @@ static int dpaa2_eth_set_coalesce(struct net_device *dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(dev);
 	struct dpaa2_io *dpio;
+	int prev_adaptive;
 	u32 prev_rx_usecs;
 	int i, j, err;
 
 	/* Keep track of the previous value, just in case we fail */
 	dpio = priv->channel[0]->dpio;
 	dpaa2_io_get_irq_coalescing(dpio, &prev_rx_usecs);
+	prev_adaptive = dpaa2_io_get_adaptive_coalescing(dpio);
 
 	/* Setup new value for rx coalescing */
 	for (i = 0; i < priv->num_channels; i++) {
 		dpio = priv->channel[i]->dpio;
 
+		dpaa2_io_set_adaptive_coalescing(dpio,
+						 ic->use_adaptive_rx_coalesce);
 		err = dpaa2_io_set_irq_coalescing(dpio, ic->rx_coalesce_usecs);
 		if (err)
 			goto restore_rx_usecs;
@@ -863,13 +868,15 @@ static int dpaa2_eth_set_coalesce(struct net_device *dev,
 		dpio = priv->channel[j]->dpio;
 
 		dpaa2_io_set_irq_coalescing(dpio, prev_rx_usecs);
+		dpaa2_io_set_adaptive_coalescing(dpio, prev_adaptive);
 	}
 
 	return err;
 }
 
 const struct ethtool_ops dpaa2_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.nway_reset = dpaa2_eth_nway_reset,
 	.get_link = ethtool_op_get_link,
-- 
2.31.1

