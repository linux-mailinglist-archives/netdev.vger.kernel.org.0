Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E078F42ED09
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhJOJEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:04:04 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236270AbhJOJED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:04:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuzPSf1xJ2fKOJ0JrFUubjOTnUXQju7bgPWCxWJUpGRCN8RRsm0+DguN4PjfdgNUmwHuhqLzsKS5BaH5/Jnx6Q9vobuPI0OSYpZlvChk1naBpRXsem8vST2PcW5AebbPdH9ArjWSdLQ5c+eKzhZT+azv4T2GIVCIq0Iz5GKxPsqBAWmAdSP1cPTp0Q+s7UcEwVi0S4QEIubWteNUfPf83Z9gQrcTY76646D8TAkY5SYHMm6E6bPPcHWgJEXO16yNHCC/jwk+25r8NT9k3bbAo1YOStDsKCCNgnSGLJDeiei73rFZN9yaSCS7niF1fpxCrheBhUI43tFPnPenH4ABOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GkzHajnUFWD8Kol8RdavNCyXiAZa84dTjB2UwttgEA=;
 b=lILfjy2yp15TRvMkKwvWeB43Wa8u5kq0pnk3bp90Twn7CZyGkIgIaMvKy+vqMkiHG8sYE6lglUFav62RUEASgvph/lsrL7Nlq4Cms34PV9C7vxBDYF/rNU5xQ8Ci1gFKcJiYOgIKgaYH8YU/EUYeB0Pc6R0UNJkqv2RHqGfRNM0FhErbURWkok5CMlohYqms+lwKEEBUGha/V2fdypgMtg6smbZBsW/pXdyCnikaaVBicFBLBEvZpALCJvJB8PcE4HDxBfe3kduXVQB45wKVIME4EubWqJrHm99QnK2S7Jw4uGFi81EvVc+iX6GKTyIBteUzVSZ3uy7aXIPbS9uuIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GkzHajnUFWD8Kol8RdavNCyXiAZa84dTjB2UwttgEA=;
 b=gPyyAGT9LRzoga1Z9bIowvxSdN0wCtm+qOgPOfoA9ScPp2v7rv0A96zJ70U4LSQUOv74rW/urCKb/193idoMDBUJYWIQ6TpW10x0vwYjEoxyFiqDcvs/Uqm050+FIv7sAtO/z/S5vjzb2OUJMRsAj9SJ88bthYhnVAzQkzAndbs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:51 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:51 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 5/5] net: dpaa2: add adaptive interrupt coalescing
Date:   Fri, 15 Oct 2021 12:01:27 +0300
Message-Id: <20211015090127.241910-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015090127.241910-1-ioana.ciornei@nxp.com>
References: <20211015090127.241910-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf885cbf-5a05-415f-3b0d-08d98fba6d1e
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB598853FD66D7EFD17A63FAC3E0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7VB82V45d3yhpjkUL0ehIWBMFV+zktbLvdS0w7ezcRNm7ch6M0Y7UcTRYAKI0XZX0WNNWlQ2VKhDcYQomgPu6P5SPVbtgKmIi5diolHLcCDa1wzCuUHmr7bfXE2+pW4YH+ybe0q/GBxWH0to059F+S4nsdEqBRt4tfCdgZcKx8/3jgE4XcjoxdRQoxhYL3edihOJTVknl5OsCr8Dhm9oI0snbYSO5vAeMfNtjoLaN5rHe5fNbIjMObP4ZaEVaNbsG27LT7Y0E158tyEXur+LOstB/2DklcWEBUtsEw1xfZDa93TBZguMoDw0QI9g10McM2AHxOB4u+Kfoy/GPwm7fFjLDZxhOp/1uI3gDN71jKGf8So9n4IuMX5dYrEK9YAZ9TFD1JXqFv6wkU11UilfO8ZzjqmWU8GIGwtcEPOUznUFnCgvfjNA3LnfKNrH49cXGkPozuP8KIaivcI6RwIZuzIcyF3UsgP7s+P38UHSC3NPNL/bZrRTUEcCxD61M3GTrRuhYQipxBXtYIaXb3mIlVCGKfvjABbiCV2ShYoaEc5bIAdDZlTEAwwNa3I5GjVWRRgGhirSFTW3lGYjhQxG4/MGzlKV/PMUgryOI4empn2npMInhuQMhLFVbDauYPzqCQxR0DzRTLAey02ntqYp8Vc7wvCskfP1LVF8sGgYmQVz5ox7UUish2jgu3EPUtrXXIuEuveT0YARY3ntB6BYRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?evDIlcQcQoj6sY5SRpjTXlAXPR5uu9e1AHkdqwny7Sp+oeV4HAXFaWQ8kzOV?=
 =?us-ascii?Q?O9EABxFbXB5xAqszBNKjKoSk6+AwSkGAi3PgEHpPp9CG7iNtrPTRGiEcQMlE?=
 =?us-ascii?Q?0vHTJci9/H5JkDTB/0cIOCsGldKLLEqJ1ErCp0vvPpRi0q9EIBGJk+S9hUs3?=
 =?us-ascii?Q?2JDkgpV94UMlkylSe+DMYSJAk0rBcH0XiF03Yit5hKmRAQEf/lt5NH4uQqEF?=
 =?us-ascii?Q?6CaVTw9uV/IhLARFozOQfAm1eaYnh5Qhws4p28Sh6PZ1h66q8Ax2RSd5YYCK?=
 =?us-ascii?Q?rczwdvpzW0adlZQkfa87vm7SSHovtors/A/boVPSZBkTs4mKiqWtlQOMKP9h?=
 =?us-ascii?Q?FYb9wQ6dmUEnRnuK9j34qdXrUxwqERmiWBXXYroMFd2QSiGM9lpqB2fVRT+J?=
 =?us-ascii?Q?RCmqUwXAdi284sABF0HIYcBmCOgkx774RbqWoiekrQCPzb8HQ2qiETnxtev1?=
 =?us-ascii?Q?DD9pp6mK9lLla3mOFOeqECB+eox3om/n1Od9HHSLPtnXntWdY/KkOB9Bea5z?=
 =?us-ascii?Q?ivuJwisTITlPjXcwNslWxxuhm3cXfk7t2qXXHQ8A8IjGPVV9LARuTLLit1es?=
 =?us-ascii?Q?K9XcPbHRDqKzgS25PHC2NdlVH2OkCcrl3224PwfRkHOlgN1h55A1SJbNUezd?=
 =?us-ascii?Q?Q6equLYTMIeVN/89pBdjXar8iWnYL1IhfdpCrliTd9m253gnGrj0zWAWyPJb?=
 =?us-ascii?Q?xFUqNPd//KigjbheyffULU8tuEGnaVJBmoE9XqsPEqpxvJPYI8wCbzjDNZof?=
 =?us-ascii?Q?Ce6wGeSeBS/R6n/DeylzeiiGAogkGSg/jGX6qgWqBWdwvARv0nVstHEMxzsT?=
 =?us-ascii?Q?Jwg46ehBk21qc4KRldgxxf8KlZ7FOfrvON9pvIHnqiKc0fDoDq416Cl+W5q2?=
 =?us-ascii?Q?4kAyPllHR7JUdcLBcnQjqOxcuT82jJOx4tME9EnqugkenTV2YNyhJf0F7hCd?=
 =?us-ascii?Q?uUzebFFn3vKqSgpwBQzd+ttAoU6KpSNlIm26E8WTM6BSTDAsLiDJSvGTzppe?=
 =?us-ascii?Q?xgjYJSHjFX9RlVmp3Z/36K5xuT/OL8/Mm5/+Ch4w0vrXf+141tNXjLUUQds1?=
 =?us-ascii?Q?7dvRYXg6xNum/MSsfwI/r6NK91BJvvPW5E5a8htK8lOCI42MXFutrXpoq1uL?=
 =?us-ascii?Q?QMKO63MGJ0/CMoOje84iwGUAIZwq0Mg5cU1fRiSh9fh5/g3WW2fV/MZsDIMD?=
 =?us-ascii?Q?JUR4JyCk+dzXsLJtDpWTAwQOATaM7hnKbL9Y2KRkBM7OZrLlQHaUSB+Xjx74?=
 =?us-ascii?Q?T6J3ORXEqH1MI3Jjfi/7gj1wTSEeGgTgd5fyuTv2FMvQ1o4z1kUBqYTu9zC3?=
 =?us-ascii?Q?iyGS920eAAXrlxhNZ3qEEToy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf885cbf-5a05-415f-3b0d-08d98fba6d1e
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:50.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtfEQm8sk5TB4gZT5KikJGXPuFtrmEreyNcbW22vfSl5voGYZZh03BJ0hvuvETXbx+rg+fpXQfu/3Dd5g8daqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
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
Changes in v2:
 - none

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

