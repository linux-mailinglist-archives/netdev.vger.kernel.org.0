Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3885F5E7EEE
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIWPrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiIWPrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:47:03 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E8C13E7CC;
        Fri, 23 Sep 2022 08:46:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjcGj3ZSqT2Yu5sCTdLNdylq1GE/FcaOtiWTh5Yf1CYByk/jfQdWTKNQtkx5CZHKWkPxSIWLiXVcJaPf7Llj9VnOExuBEqG6MRGEL23Qwf6LIOLeldeY1k2gVpSYkVIeMf0+0QGN7tP6x/Vr9SSJowRr3dFHABsDwQ8S5E2wvLBm8q/g7OFa0zwjahgMXjKo6SApnG37HdNgTWnlkCRqMaP6jQaCTRyzbZzdE9ZODlxv9hZD39Red0IU3ObJHOiIKVdCWEJXnZ7QGkUiynSnM3yEyBleMQkulQoSiK38HNBnya4M5xI/gyAdPSOmHyIkACZaVSsAe2sGdVWZWf6NCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHbJHpBAJ8dgeuyVtluaMKejajTi4NghnRGJWzd+3jw=;
 b=HIPq/hUxlf0+phwD7fpRBolaaxGyx3xsyCUKH+1F2arWDD834nQtgHnfgrizVru8jEFbxDyJFMA6a8LWoFCIpQMRkwdoZzhqxLDAMvGPdtrbi5L1U9hIrpamxDM+5MBJAZXsK8E9wJY58BIWJQtHaDXptEAFDf/qL2LPrLAqn5L2Otc3MSpHxaPMtx0/RiffiECQM3ClfIw7VAOZM8juJ8LymWkovQQSS1+ac4wx1qv5wJswAe9ooAYN1liwqTupYmYx20KR5EtUpm8ULtBCGiC/hVjLnnG1ckme5syT4Pl2L3xNa3zZLsHPJka0KSHzDzomLb2bJ9kLY/Q5FpYqFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHbJHpBAJ8dgeuyVtluaMKejajTi4NghnRGJWzd+3jw=;
 b=MES2KgPzNCUq5w8OrR1IT943AmkiI1yrGex8fVod5YdN4Sjn1cA/uvg+cmzbiEH/vOLS3BCK7SkIup+FlLIORJSFqrsS25T5FQvjocH1mh0kKlowFdWc0ASx1M76NX7XPYKlZ4iAin7NxuzOlSp1My2f5yvBgXCqFkQ4+FOGI5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:53 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:53 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 11/12] net: dpaa2-eth: AF_XDP TX zero copy support
Date:   Fri, 23 Sep 2022 18:45:55 +0300
Message-Id: <20220923154556.721511-12-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 589834dc-84ed-4594-6a02-08da9d7ad651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFGfVYYtFDypDSJhYVXr8cG0Vy3ASJlP6YpXXZiLv/3MG62zcnoskJ2zWQtEU+1+/UNJ3Jmi3e9ia9+LQpe8DQZfxYGS07kIn2nOiFzi4b0ZqKmBGwE9Kdm3IIRDg2v3BysM9lwibsSBl6FVmIiyiMCk+KYwIWK1WZjBXJOYICS7J0T6HfkfvvOp3s7pEnUffXq7KcYTLpIfs/Cs5gnQUAAXh7C4rTJcA+hJQQ5I07do5tTE/U0i32ZpCetwI3GuuwPY2JYGdtYfY3vrdQR9+LkWbnQjMBzg5EQailKsXTSp5fAo13/ZRWTsqcy1c+QJw+QsM+J5u+qzmgHvvo1RHFyYe+Msfz9PVMCpqWnYOe7YU8ttWm1m0+U3m1ofiRWqawl5y8yUogJxrdl5Gy1ERCDn+qrzC677fSoDAcaA14IAz/35vrIWzpG6kERJvZNX2fnM3J93X3pJe2h3GJ1BA8yM6B76lDYxWSrSbPKzP4G30vhoqpNax6fnj/X9ZYd1pSDNEcZ2WGZgzfcwRAuCTskzukEQC+qq7Jw5bXz64+aPS7jWaET5Q9vBjU8vRv0yJVQQ8Z1q0GPnWpxr2Nns9RT2MK8gi5GKOf5ErjDoxh4g3GuYD10TaaW0+6VZStzVSWpxw0mXAi7us4ymZUfRx6KQgBcOiAL19DnMpVik9vZS5yAvnMO2tIgCYxxYMevtijbdu+4yDmySd7jih9nAE6s+Y/H7QTK+ys/sq90iBY3yX/wsVtqqeG9M0iyOx/kRLrUCW4bHitN7O5dqhoOSKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(66476007)(41300700001)(52116002)(83380400001)(6506007)(66556008)(4326008)(66946007)(8676002)(26005)(36756003)(6512007)(38350700002)(8936002)(38100700002)(6486002)(110136005)(54906003)(316002)(478600001)(2906002)(2616005)(30864003)(44832011)(86362001)(1076003)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VmuixnR2xtcKagIFxKg1M84gHwY4zh5uPhOD/jwW08JkYzTu4mgbjbBIc59P?=
 =?us-ascii?Q?2sw7dUxvSjHvcedDhVHF5YGvNMkMeiiBOddvd8d8b+ErjJAxiKb16bkbrJFg?=
 =?us-ascii?Q?FZmHpRZ/sEDwYaq5iCmDbwxFoFGdNGe5TSuShaatj95MkILfWvi9FzbPXezw?=
 =?us-ascii?Q?KqZojMhvqmVWNP/zzE45GxmoQn7RjORCedTxWZvTVg3ttS92rlU1PgWDLK44?=
 =?us-ascii?Q?miwVndPDwk8GMij2xauy+3jsFR5lqzFjnY0dxyg9MBGlAcKX7St1mw/UgC0H?=
 =?us-ascii?Q?p9yVw2/Siopv/SR3XJW1NLZyuNZPA24ptn4Wo7+yuRmMrj0kdhrdvAomQjs9?=
 =?us-ascii?Q?k7FL86F8bpuL9RtIwbZj3qwqn3eoYq+9Dw2y2L/VuaqiLpQ+YKPy3Ij/E3Lk?=
 =?us-ascii?Q?+wXXEhr50Uru3WIjAxezYoCPTbazY8QC+uMLObZg0/YZdm0E32Cz1lZ6Pb+/?=
 =?us-ascii?Q?EA9mESzJMGOhsPb0sAzGP/C6g7+XnqWkvTkKRnmX+/vxEcq9K/4KczXsZIVx?=
 =?us-ascii?Q?S+hB1SBn3EIW6sAjAZxTMyDG2F41ZiJKOF5vOt2qA1+Em/KQ1iiuiyQDDtfL?=
 =?us-ascii?Q?mOhvIEcq7WhjCxuXSMnHGw26JqUdJ13IdLlSqwBnh5M3qu++MufJwYonDr1B?=
 =?us-ascii?Q?6iN2/ZtckT74J79FV8PviwEwTQzWWe6vIcNdD0ipViPXA6pH9Drvg/Jo1M6J?=
 =?us-ascii?Q?GBJHdTcGi9lNDAh4V8rZhY/rFPTxAFvPwvU7mk7pnxcebX721ufcsQTmzrXH?=
 =?us-ascii?Q?5wDzGTjUt9bbyCZg6D/6bgPEtmg91K2WySNzBDts5uwUF8uDiSOwElQncQYz?=
 =?us-ascii?Q?HWGlIrFL2nsrzpl3gLaVEtPcb28fCQy7DHKryNo9pqv1cim9KXeeAmM4Cih1?=
 =?us-ascii?Q?NeSTlqXniv6q1zaZT7/jS2MdMpgFfN8WnAFHQyzSNPiLIOf3HFFRyIK4oaUB?=
 =?us-ascii?Q?Xh9SrSiMHZB4S2I95LdOj6RxSyC/aTUJyxk4W8CIRfHQEpy5WWtM03A/5kMq?=
 =?us-ascii?Q?dUZ6fgzt8Lu+TfPKSnRP8xiy+/IEH4ruFy6OwpnVDQJ9ONkQi8wCU4MDwtlz?=
 =?us-ascii?Q?YrDFzMbVjcXD/6MnC7purnp1+U30Bhq3do1tZzImlwqfw8x0pm2VjqTjg7ui?=
 =?us-ascii?Q?C3IUgYM+q2mYJj3w6dN7s1y0tRpm0UL3rX7Sgb/yIebPYa4G27jnKCIxiGhE?=
 =?us-ascii?Q?rbfNOloyq1TRDWpF/Qq7fiLMX6bUoqn2Hz0SUyJ+utkv6WRvD1xEaR8sqO3s?=
 =?us-ascii?Q?uceWWnWFAhuwZN0K6u9kC33l8cUwNWPIwKGQJQ4VkVRKYCWcsowVB5w7JAMb?=
 =?us-ascii?Q?UeBko6XJTZa4aTYXOGRxT7nLBqi93qx8hxt7HVjmi8FQ08uDkGqBgFUpixDP?=
 =?us-ascii?Q?DBOLCiEvJxtHGfijzgevM5whN8zpVzBx0koDa9uGdEIMjWYZtsZ5tfqgZm9G?=
 =?us-ascii?Q?KJWJzuBXyEhA2R9hMqrh61WcNVmnbycvyHwfmsVlNqgwCNTcWX6jD0Rpf6j0?=
 =?us-ascii?Q?Na4TTkZTTbUFsVc7AhTX8MbfeBCBJ7jPDfIM+w0qE6zkUrkluvIKqnFPjTPV?=
 =?us-ascii?Q?Gxm1GS+4q7HU4Dy+4If7RTI4z65dYBB1OPZlER3zYj+HagsI9Yu0Ypa3C8HP?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 589834dc-84ed-4594-6a02-08da9d7ad651
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:53.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BV80STpgGOE9IKHpcCn/PqGHZTowyBDL2ot/TxH7cWSxkaBhsHIZThQg4AmpTcv+cxxJi0j52rxIfSfODu72Jw==
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

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  48 +++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  22 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 123 ++++++++++++++++++
 3 files changed, 183 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 1e94506bf9e6..4cfdbf644466 100644
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

