Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19EC602E3E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiJROVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiJROUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:35 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD3A9DD89;
        Tue, 18 Oct 2022 07:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MopfqO9iLV53MHneXTRQQXQbs+u7zM8jQbYaCDkIidhjBHiDdsW8gyBY5MgKaYhWPOL5Xe4m4kNHk1lmED7jVXZ+ae4UPaLs5JxfZXGoKXn3ffwuEwxQe6B35kd3Jls3p1hbMvikMnNwxstp7oWgnEdp6dkPPFp1E9Waz9dkIICjCc32U3WxG5UlZ7UcPm9sNjb7SN60kWA2yzSd/wY50Z+x9+i0AEIdUSj+p11X/clHXHXf/EDIljFZIGU48xt5ZKxUaQ0bC21vs3jr8dHysz7D3PgGL581V8u+7NGjgI5onrEZOUEpiqCia5WxGGSTdKUofO6NS4lldGFinM6UeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v640kFzbE+cYiifkU4rTRNLE+XfQm3qTTYdWcJEizsQ=;
 b=YesQjy+S9zwxhfVYPoWEfdUJRt8//fuMVyp1lJRK1lgzGxYvCszRSBHr9TjHcmyowmATSME0J6SWMOPcS9Ooeb7J+sFxWyXrKWfUmHN81+22q6yr2ZF97YHt1/a26J8nQFr/n4+b56oHh2fsxVI0XzJpacFtenCt1b9p6KfDu8qaTZ17R1AcSFiVuUJzamR+VTk3CopD8JK0u/gX8G5f2ulfYQl/9ugG7G+7XLiySKWu0z1BTkgNy5m8TXQV3jAgegoAD6cYKRhe911MyLr4eYvO6RwzV4bUHqhvlVPYVS+sXdiWUgOpMVdnmgbh/QgLVuwKsaweTc3tz5lKfID0cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v640kFzbE+cYiifkU4rTRNLE+XfQm3qTTYdWcJEizsQ=;
 b=O39P0L8/TOWJGHzJJezhGWO2B05GXHf0MuAMYC4ptfg0eWjJKZMpEoPmOqPbfowPAh9kbWrJyD6Ti9Z+O8zs5SnNi7i7Wz5w52BMUI+7UfdGY8TZxXloR6x4AHsSARXmjo8e+FEA4gsLZfYAFlabLTcz86bZumAYBTvc+TBLoVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:46 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:45 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 11/12] net: dpaa2-eth: AF_XDP TX zero copy support
Date:   Tue, 18 Oct 2022 17:19:00 +0300
Message-Id: <20221018141901.147965-12-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f8d836c-d6d6-45e0-0598-08dab113ce32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VB79TgBLUehPYtH17N0NA+bx+3mWticd8MrhvVaJ1kaIhNrIiFaLoeISYZyCbNq6cDEJ6Tnaizd9gfaq9sUm/dFW0Zof4L1b4Orf+PboxRNiL/CVohGf/EgcWawh72wptkl47/U7CnrXuGAymFowIRu7EWCz8AQmE3O5w5qgTjckoT9facqEIrqzEK+JtlsncsCVVh+2cbdMm0brBjFUesW3SnPp+Qb0SWJYqASJWLJAJQgxTgJzNm1HizArcr2Qj2aWqfei0112GsDPYvVGZobl/8XNUjseT2Pfkp0X/1lk+LhXSNR0vtUWWvJ2BS4J3gj6ehF9VsF/Ilg5BaK2/su/+FTIT8nIwlyJin3UE0N+/mpv2pdVJhsoZeSAfUwSsHtaGz5czyioQ160nkqd+8ujkhTL8mdS3pRuVEajonzjDN0s+p5FxtslMWeMcNV4yQ9QdQrCz2PwxgHeebeKLORi+42aIZYtNT70Y8AVJqeTOnOuXlV38tqOD1SIn5dHPwTsCkZO8aIC7NRKEt6S2/lpNX0Bx/hRbU86OawIiKIItSnadDjsL0ztwq5O4heQqU5aeGIePRpZ84OJyzdk4PPW60iK94Cfaarqcy4BhdWCtq8525XsMW72+fPl4GCd87BWTnk0fVNrt9RjZyN4rzuWXgWCugv15W0Z0l9qdS6uDgakImPwMSKQ4LEB6ckoRbkgZjjPhWl8ldTAAHtH9u0Ta1CD5iavfE7YKSfRZlgFZxuIzvCLnuwHVt46pPrCvfScJCMAxIOgwVuS6eeXdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(30864003)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?py44sqT4qgM8Lisx+XiFyLsqR6+sRtAslh1pW2G8eLIOH7WlZvOyiiXJU6o3?=
 =?us-ascii?Q?CwDaUmJi5/bYDPRofOL1EYYKEA/VANZFo1pwfXEiMB1jWY+nQZmBk5BUuIWm?=
 =?us-ascii?Q?VcO9TJnm4lC8lFWV+NcCcJaWYO4OQaJUlR36j8YclRD6/zSuizABkPHkDbbe?=
 =?us-ascii?Q?0ECChlIYwjXCXuMFZd1rDfXXlKp7bKX58S0zc6xSpVsbMANHb3/DdT70RvFI?=
 =?us-ascii?Q?ZYodTzsuPaXuudQVDGr3Bt8Ro59RJpcMYJYjtxHSjTIAsRz0xds1spB9MfjW?=
 =?us-ascii?Q?iu0+0d0aeb8XUMwTqOCF5QYSu5yihQ24dTVjuKn2rxRPV8fkwP3cSlAVC8lt?=
 =?us-ascii?Q?kMb+UQvB3QULK2m1zmYaSJRO//Igafb7Rh8O7LsQxhI6OqCtW77mLhVdvaW+?=
 =?us-ascii?Q?CQreBtw9oOGXywlR7E8bXo5RD8nUEo0B+ba9rrba97uk2xbWs5o58M2QTBHQ?=
 =?us-ascii?Q?sceHyG6YDfBPspPiIEp97bUC0QHWfVPz9dXGVHSgobaSfAWk+ydCeugy8NYy?=
 =?us-ascii?Q?eCZStVfDZvGFBVnW2W0Lg5XASlmL0TiYCjNHc8H03yGpnnfl5tnQOg5MsdS0?=
 =?us-ascii?Q?XTQ7heWsVk20jHPMlHvERMcz/K5Wod680Ou7Jvy+7SmymH+dwX+H1irJ6BAr?=
 =?us-ascii?Q?928Bou55+fvmTFizmQxIvrBrAqyJs4SV2qYgoxOAM9uFOX7EzEGRiBmARbD/?=
 =?us-ascii?Q?6F/F73wVu5RAjTR0HVVCKrwRlFH0ySVJAnSNXkdjp3qk0KmvZ+2p83DYuojJ?=
 =?us-ascii?Q?E203BOfKo5sVp3oQpPxbtbvl7TIOK63IWy9x6pBbvUL+Lv6Uz0u2CaSG2sZu?=
 =?us-ascii?Q?MAjfFZDJtQdPMWKUjrofpcztBYl98kCenalysH/Y0vUO5yHQna6UkL/RikIK?=
 =?us-ascii?Q?oFll/y3WK5SwREx/kcdqZdTOproCFZLQBYWxRMOJme8FIhrstvMdgAwi6UKZ?=
 =?us-ascii?Q?OcekIkwW8c1gN7UhDgoWlyXypmnbSThP2xzmAZ3zYPRlVCYXTv9Mt/RCUPil?=
 =?us-ascii?Q?BelfoQk3GHVvD9sQ6PBervFmsx4ueXKKAHRVRUDc8YUp0lXM4euSdc3EPX1r?=
 =?us-ascii?Q?FlYGuySOY6duC+Z2irBwpZTcgKoxGjeQnQVWU4dfa6yYUQg5mOkDUQQSwETR?=
 =?us-ascii?Q?MOiUFVLMQGwAAQu7cPQ7u8hE49SAN7qr7qk5Y/FVlwEBtsHoPomT12NH6Lcq?=
 =?us-ascii?Q?Rqo9vMiyZ2xnYAgimuzm+UwkGYa5IeNgsgyzegX1aJyjOOxIpHW47uJ/+BXw?=
 =?us-ascii?Q?njJwmPQPPwxoVeprJZE1LDmPpIZHhFKgJKEuP4/nIvK8zJBS3Dz9RM7K6X0I?=
 =?us-ascii?Q?6Tif9XUGatan9VItsk9dNdIg8l3YrUlNmgrToncfd3bstwKxnbOnhY7XYjmZ?=
 =?us-ascii?Q?ZbnsCmyS2l5pvz9VYX3bYNyWWC80Kt0pIntVAxQVBkVWj9wtW9hbqFcHbJOl?=
 =?us-ascii?Q?l6EsaQTqqGuHQOXkAjJgheLQBIp9hWf1n22TrdK1nx4yOeNl0gSyJ4TCDY8i?=
 =?us-ascii?Q?rb9usKyl6WDiBoFxSjECG21k+wt5WjWJT3X/b0VtHgJjFg8asQ+F2Uo1Ezeu?=
 =?us-ascii?Q?XYkA00bxO1s+Q4hWl+460Gn3g95s0DEONOLhfzAKaovz2/XzbLsJ+ibEh5Ef?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8d836c-d6d6-45e0-0598-08dab113ce32
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:45.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdlbEus2lMtBJpIZRBFCU3V77+Vx/lDVMP4PPSVZZKK1Tib0qbdzkiTToh+Hg6GHWiNO5HlBzPut//yZZO4RIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

Add support in dpaa2-eth for packet processing on the Tx path using
AF_XDP zero copy mode.

The newly added dpaa2_xsk_tx() function will handle enqueuing AF_XDP Tx
packets into the appropriate queue and update any necessary statistics.

On a more detailed note, the dpaa2_xsk_tx_build_fd() function handles
creating a Scatter-Gather frame descriptor with only one data buffer.
This is needed because otherwise we would need to impose a headroom in
the Tx buffer to store our software annotation structures.
This tactic is already used on the normal data path of the dpaa2-eth
driver, thus we are reusing the dpaa2_eth_sgt_get/dpaa2_eth_sgt_recycle
functions in order to allocate and recycle the Scatter-Gather table
buffers.

In case we have reached the maximum number of Tx XSK packets to be sent
in a NAPI cycle, we'll exit the dpaa2_eth_poll() and hope to be
rescheduled again.

On the XSK Tx confirmation path, we are just unmapping the SGT buffer
and recycle it for further use.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  48 +++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  22 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 123 ++++++++++++++++++
 3 files changed, 183 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4c340f70f50e..31eebeae5d95 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -858,7 +858,7 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 	}
 }
 
-static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
+void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_sgt_cache *sgt_cache;
 	void *sgt_buf = NULL;
@@ -880,7 +880,7 @@ static void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv)
 	return sgt_buf;
 }
 
-static void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf)
+void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf)
 {
 	struct dpaa2_eth_sgt_cache *sgt_cache;
 
@@ -1115,9 +1115,10 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
  * This can be called either from dpaa2_eth_tx_conf() or on the error path of
  * dpaa2_eth_tx().
  */
-static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
-				 struct dpaa2_eth_fq *fq,
-				 const struct dpaa2_fd *fd, bool in_napi)
+void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
+			  struct dpaa2_eth_channel *ch,
+			  struct dpaa2_eth_fq *fq,
+			  const struct dpaa2_fd *fd, bool in_napi)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	dma_addr_t fd_addr, sg_addr;
@@ -1184,6 +1185,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 
 			if (!swa->tso.is_last_fd)
 				should_free_skb = 0;
+		} else if (swa->type == DPAA2_ETH_SWA_XSK) {
+			/* Unmap the SGT Buffer */
+			dma_unmap_single(dev, fd_addr, swa->xsk.sgt_size,
+					 DMA_BIDIRECTIONAL);
 		} else {
 			skb = swa->single.skb;
 
@@ -1201,6 +1206,12 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 		return;
 	}
 
+	if (swa->type == DPAA2_ETH_SWA_XSK) {
+		ch->xsk_tx_pkts_sent++;
+		dpaa2_eth_sgt_recycle(priv, buffer_start);
+		return;
+	}
+
 	if (swa->type != DPAA2_ETH_SWA_XDP && in_napi) {
 		fq->dq_frames++;
 		fq->dq_bytes += fd_len;
@@ -1375,7 +1386,7 @@ static int dpaa2_eth_build_gso_fd(struct dpaa2_eth_priv *priv,
 err_sgt_get:
 	/* Free all the other FDs that were already fully created */
 	for (i = 0; i < index; i++)
-		dpaa2_eth_free_tx_fd(priv, NULL, &fd_start[i], false);
+		dpaa2_eth_free_tx_fd(priv, NULL, NULL, &fd_start[i], false);
 
 	return err;
 }
@@ -1491,7 +1502,7 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	if (unlikely(err < 0)) {
 		percpu_stats->tx_errors++;
 		/* Clean up everything, including freeing the skb */
-		dpaa2_eth_free_tx_fd(priv, fq, fd, false);
+		dpaa2_eth_free_tx_fd(priv, NULL, fq, fd, false);
 		netdev_tx_completed_queue(nq, 1, fd_len);
 	} else {
 		percpu_stats->tx_packets += total_enqueued;
@@ -1584,7 +1595,7 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 
 	/* Check frame errors in the FD field */
 	fd_errors = dpaa2_fd_get_ctrl(fd) & DPAA2_FD_TX_ERR_MASK;
-	dpaa2_eth_free_tx_fd(priv, fq, fd, true);
+	dpaa2_eth_free_tx_fd(priv, ch, fq, fd, true);
 
 	if (likely(!fd_errors))
 		return;
@@ -1929,6 +1940,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	struct dpaa2_eth_fq *fq, *txc_fq = NULL;
 	struct netdev_queue *nq;
 	int store_cleaned, work_done;
+	bool work_done_zc = false;
 	struct list_head rx_list;
 	int retries = 0;
 	u16 flowid;
@@ -1941,6 +1953,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 	INIT_LIST_HEAD(&rx_list);
 	ch->rx_list = &rx_list;
 
+	if (ch->xsk_zc) {
+		work_done_zc = dpaa2_xsk_tx(priv, ch);
+		/* If we reached the XSK Tx per NAPI threshold, we're done */
+		if (work_done_zc) {
+			work_done = budget;
+			goto out;
+		}
+	}
+
 	do {
 		err = dpaa2_eth_pull_channel(ch);
 		if (unlikely(err))
@@ -1993,6 +2014,11 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 out:
 	netif_receive_skb_list(ch->rx_list);
 
+	if (ch->xsk_tx_pkts_sent) {
+		xsk_tx_completed(ch->xsk_pool, ch->xsk_tx_pkts_sent);
+		ch->xsk_tx_pkts_sent = 0;
+	}
+
 	if (txc_fq && txc_fq->dq_frames) {
 		nq = netdev_get_tx_queue(priv->net_dev, txc_fq->flowid);
 		netdev_tx_completed_queue(nq, txc_fq->dq_frames,
@@ -2989,7 +3015,11 @@ static void dpaa2_eth_cdan_cb(struct dpaa2_io_notification_ctx *ctx)
 	/* Update NAPI statistics */
 	ch->stats.cdan++;
 
-	napi_schedule(&ch->napi);
+	/* NAPI can also be scheduled from the AF_XDP Tx path. Mark a missed
+	 * so that it can be rescheduled again.
+	 */
+	if (!napi_if_scheduled_mark_missed(&ch->napi))
+		napi_schedule(&ch->napi);
 }
 
 /* Allocate and configure a DPCON object */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 38f67b98865f..5d0fc432e5b2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -53,6 +53,12 @@
  */
 #define DPAA2_ETH_TXCONF_PER_NAPI	256
 
+/* Maximum number of Tx frames to be processed in a single NAPI
+ * call when AF_XDP is running. Bind it to DPAA2_ETH_TXCONF_PER_NAPI
+ * to maximize the throughput.
+ */
+#define DPAA2_ETH_TX_ZC_PER_NAPI	DPAA2_ETH_TXCONF_PER_NAPI
+
 /* Buffer qouta per channel. We want to keep in check number of ingress frames
  * in flight: for small sized frames, congestion group taildrop may kick in
  * first; for large sizes, Rx FQ taildrop threshold will ensure only a
@@ -154,6 +160,7 @@ struct dpaa2_eth_swa {
 		} xdp;
 		struct {
 			struct xdp_buff *xdp_buff;
+			int sgt_size;
 		} xsk;
 		struct {
 			struct sk_buff *skb;
@@ -495,6 +502,7 @@ struct dpaa2_eth_channel {
 	int recycled_bufs_cnt;
 
 	bool xsk_zc;
+	int xsk_tx_pkts_sent;
 	struct xsk_buff_pool *xsk_pool;
 	struct dpaa2_eth_bp *bp;
 };
@@ -531,7 +539,7 @@ struct dpaa2_eth_trap_data {
 
 #define DPAA2_ETH_DEFAULT_COPYBREAK	512
 
-#define DPAA2_ETH_ENQUEUE_MAX_FDS	200
+#define DPAA2_ETH_ENQUEUE_MAX_FDS	256
 struct dpaa2_eth_fds {
 	struct dpaa2_fd array[DPAA2_ETH_ENQUEUE_MAX_FDS];
 };
@@ -836,4 +844,16 @@ void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
 int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
 int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid);
 
+void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
+			  struct dpaa2_eth_channel *ch,
+			  struct dpaa2_eth_fq *fq,
+			  const struct dpaa2_fd *fd, bool in_napi);
+bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch);
+
+/* SGT (Scatter-Gather Table) cache management */
+void *dpaa2_eth_sgt_get(struct dpaa2_eth_priv *priv);
+
+void dpaa2_eth_sgt_recycle(struct dpaa2_eth_priv *priv, void *sgt_buf);
+
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
index 2df7bffec5a7..731318842054 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -196,6 +196,7 @@ static int dpaa2_xsk_disable_pool(struct net_device *dev, u16 qid)
 
 	ch->xsk_zc = false;
 	ch->xsk_pool = NULL;
+	ch->xsk_tx_pkts_sent = 0;
 	ch->bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 
 	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_eth_rx);
@@ -325,3 +326,125 @@ int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 
 	return 0;
 }
+
+static int dpaa2_xsk_tx_build_fd(struct dpaa2_eth_priv *priv,
+				 struct dpaa2_eth_channel *ch,
+				 struct dpaa2_fd *fd,
+				 struct xdp_desc *xdp_desc)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpaa2_sg_entry *sgt;
+	struct dpaa2_eth_swa *swa;
+	void *sgt_buf = NULL;
+	dma_addr_t sgt_addr;
+	int sgt_buf_size;
+	dma_addr_t addr;
+	int err = 0;
+
+	/* Prepare the HW SGT structure */
+	sgt_buf_size = priv->tx_data_offset + sizeof(struct dpaa2_sg_entry);
+	sgt_buf = dpaa2_eth_sgt_get(priv);
+	if (unlikely(!sgt_buf))
+		return -ENOMEM;
+	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
+
+	/* Get the address of the XSK Tx buffer */
+	addr = xsk_buff_raw_get_dma(ch->xsk_pool, xdp_desc->addr);
+	xsk_buff_raw_dma_sync_for_device(ch->xsk_pool, addr, xdp_desc->len);
+
+	/* Fill in the HW SGT structure */
+	dpaa2_sg_set_addr(sgt, addr);
+	dpaa2_sg_set_len(sgt, xdp_desc->len);
+	dpaa2_sg_set_final(sgt, true);
+
+	/* Store the necessary info in the SGT buffer */
+	swa = (struct dpaa2_eth_swa *)sgt_buf;
+	swa->type = DPAA2_ETH_SWA_XSK;
+	swa->xsk.sgt_size = sgt_buf_size;
+
+	/* Separately map the SGT buffer */
+	sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, sgt_addr))) {
+		err = -ENOMEM;
+		goto sgt_map_failed;
+	}
+
+	/* Initialize FD fields */
+	memset(fd, 0, sizeof(struct dpaa2_fd));
+	dpaa2_fd_set_offset(fd, priv->tx_data_offset);
+	dpaa2_fd_set_format(fd, dpaa2_fd_sg);
+	dpaa2_fd_set_addr(fd, sgt_addr);
+	dpaa2_fd_set_len(fd, xdp_desc->len);
+	dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
+
+	return 0;
+
+sgt_map_failed:
+	dpaa2_eth_sgt_recycle(priv, sgt_buf);
+
+	return err;
+}
+
+bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch)
+{
+	struct xdp_desc *xdp_descs = ch->xsk_pool->tx_descs;
+	struct dpaa2_eth_drv_stats *percpu_extras;
+	struct rtnl_link_stats64 *percpu_stats;
+	int budget = DPAA2_ETH_TX_ZC_PER_NAPI;
+	int total_enqueued, enqueued;
+	int retries, max_retries;
+	struct dpaa2_eth_fq *fq;
+	struct dpaa2_fd *fds;
+	int batch, i, err;
+
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+	percpu_extras = this_cpu_ptr(priv->percpu_extras);
+	fds = (this_cpu_ptr(priv->fd))->array;
+
+	/* Use the FQ with the same idx as the affine CPU */
+	fq = &priv->fq[ch->nctx.desired_cpu];
+
+	batch = xsk_tx_peek_release_desc_batch(ch->xsk_pool, budget);
+	if (!batch)
+		return false;
+
+	/* Create a FD for each XSK frame to be sent */
+	for (i = 0; i < batch; i++) {
+		err = dpaa2_xsk_tx_build_fd(priv, ch, &fds[i], &xdp_descs[i]);
+		if (err) {
+			batch = i;
+			break;
+		}
+	}
+
+	/* Enqueue all the created FDs */
+	max_retries = batch * DPAA2_ETH_ENQUEUE_RETRIES;
+	total_enqueued = 0;
+	enqueued = 0;
+	retries = 0;
+	while (total_enqueued < batch && retries < max_retries) {
+		err = priv->enqueue(priv, fq, &fds[total_enqueued], 0,
+				    batch - total_enqueued, &enqueued);
+		if (err == -EBUSY) {
+			retries++;
+			continue;
+		}
+
+		total_enqueued += enqueued;
+	}
+	percpu_extras->tx_portal_busy += retries;
+
+	/* Update statistics */
+	percpu_stats->tx_packets += total_enqueued;
+	for (i = 0; i < total_enqueued; i++)
+		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
+	for (i = total_enqueued; i < batch; i++) {
+		dpaa2_eth_free_tx_fd(priv, ch, fq, &fds[i], false);
+		percpu_stats->tx_errors++;
+	}
+
+	xsk_tx_release(ch->xsk_pool);
+
+	return total_enqueued == budget ? true : false;
+}
-- 
2.25.1

