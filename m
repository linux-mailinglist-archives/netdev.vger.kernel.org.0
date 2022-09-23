Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2485E7ED9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiIWPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIWPqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:50 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994ADFFA7A;
        Fri, 23 Sep 2022 08:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmPkj6FDb9QwL639DagB/RtcHIst1UEm0aFtQ9XS3GQsjS3uMvdaJLcl6eqOBH+MFSOpZm1CqBzBTJD2v5jRRftHFLWMC+aCPZusmwsRYHPVxASI6+2GzhWFiCptOA2aoC3/AAFPDhGG60ek1o1xNMcMNob1/5JFcXSgV4i8jCKd4qBwoQNencNOnWEErPukc9W7W/cwK/vrLb3lt7XDRissLU0cI9EPqcGqGoFZcd+/P5nQ/p8n2hPGnS03NuGUQ+IcXW5wmy7hIzhstsg4EbBNY27pnb3m6XZspxMvkiEEoIYAAWNr2joKMAO35OSrQf16+zLxQZ9R4B/7SjZUUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5CeeY5y75eSQhyFQdAOYz6TiGhA0XQ6y1I5vR1H9cI=;
 b=ItT6vQ2yPCJxabt00oDnwTvUZIPZnJJMmc8ICJ7PfzIlLHyj0bI8mt72fZuJWGKRvTGgV7wMeUJJVceUDmBMqrfN+8FVxS3/8pu6r9FJ5n9YbkKEa4+DLIkVNAfA0+R9jNE5/CeN9+LGzR2F5VybsoaR/jcYhyr+pt+jZlpkvzhMDdPVkJ77Dmw4HcYjG38ofBT0gYAoNOychpy900CfR9/L1/2DF9yMbZxP7CHGyS8G7m0IhBm8pnu6xhRbIwZgoUPhpuKon4bUnd7G6UphCPPef25InBtXcEGwNkMCrcRf4LqU8dazusj2th6wMrSlLkGOS2Cce+eTc0NS5KALRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5CeeY5y75eSQhyFQdAOYz6TiGhA0XQ6y1I5vR1H9cI=;
 b=FivG8NbogQGEKG7SkcOyZmBoD0tUC7fapa7jeEA3b6UDSlNX8dT0tn/mJFuUFpt9Y4a5nhRxdGpz+QAcj6uukQJWMt7VCQFvREYwToV0KmZ4n70AlGPEUXkf888JliOeOFATPdn8ZCf03tkNqRc7/kfiaojPvrzD7nR4VvenWgI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:42 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:42 +0000
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
Subject: [PATCH net-next v2 03/12] net: dpaa2-eth: add support for multiple buffer pools per DPNI
Date:   Fri, 23 Sep 2022 18:45:47 +0300
Message-Id: <20220923154556.721511-4-ioana.ciornei@nxp.com>
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
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: b7cf0deb-0384-406a-7f7d-08da9d7acfb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AwrtsBOHqrS4QlQbG7MLEh7m+6OoXklT0aus15BkN9Y5h8F0SCHPxGlRpO670H8zQoZtTJsqzAvRMSX8OVHqLQ6PLxXZ1ShgTK+5Zr4SE/e7kn+xsXZL537OkXr77Gd21gfTKPsmHkSIbXKPIzKKJv3T8OUXDoeVPO1LE1fPNjCKkSHiISHjZUzwVP7a27cgG9jUtoWrwx1PWEN9lpDu5zD2m/HynV7NwuuORZdvxj6IUZD34ilJGIHEiQ2AkGzcA5o12Gfhrq0N/HaciXRACvCwltXHRj/YuWUP+62nAJR3u+E9fnohYgENUg6jGerN20Gbkx4MMx1SN8826wSRX+gKXRDD97ZqDjTzS3bPU8t2fLa+cYIFTnKfVLxt/JZRslTjb8f0RsAei3ziJYqwpt7NaI4x9t6nrY+qW6xYiKTcQ27hL8VgRD+R08SPyog84gK98hw7KNlCReSXLu9gRrHa7HF39hCE6BgqcN43sPitNAK+mvVVOdKS2WfaQ2lBps0s3Ki5vBZ/Si25aiBydUCR2kUYruISW5W++v8ooSqUMO94tHH2pQ5eYbv3yy/+wcwZ+7M8GM45wVX6gYkL844HDZbE0zBkkQecoe7CNdQqoGyPK03lKLEn8Z8BihjTYM/0gbfO7asFOptgDQP/cJMZPovIfe/V5li5HrQTmLaGryepPmYxXxM0ZO7RNUW2oHolJ3j1yC0Q47vPQKua8SN3IoTUk1pT1hcICpz0kB9wVsEtWbJTltyUXkWj0ESX2+pBys6hgd7iD0qqX4rgZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(30864003)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eXXmFwZ16/RmGrlGdGm+6VnmCFEXwqCPpHoOe5Q9DK0hOko1ouyCAfhU5Iqj?=
 =?us-ascii?Q?Su5oY1E18f0tLGbB41rlIQaQ6pGSDTURoSCyTy5ATba3x/jlZf71hGHGj91M?=
 =?us-ascii?Q?kzoHkyh48mR6h4TuMfqMyipuLMMEjfdnOFq6YTNu2fCO+KNI3hurokqpcHci?=
 =?us-ascii?Q?s6qiftz1yqZkalI4hN9wqsgLqRtvm3lGCT+mDI50+z0wz6K9g7RJNMdKuOe6?=
 =?us-ascii?Q?0xd6vwXMUkNHRAupaUmRcGIIU1Xg0hBB+O2KzuQYPfzeAa6g9Fv2Gy+6Tcws?=
 =?us-ascii?Q?+iRSsEcUEqR9N5IZwatJzvr7Y9ZcUim9z0tj28gqQLC3h9Z4j3Q7jfcQ6300?=
 =?us-ascii?Q?GgRp88rqTMFjseDUbvt/jju2FHC5SiOAJZc6htSbjoztFTZ5IimRICB3eZh3?=
 =?us-ascii?Q?5SqtCm0oyEYbonqhDwFnesHmdaXSA/HcEPst258haWLoIM9hg9Ji9zllCNEa?=
 =?us-ascii?Q?Aa6gXjm7J+JxnXNqqMEeK8mX9HMT/wHTAfEdWcKC6rxzIjQMDYbhoDUe3AxO?=
 =?us-ascii?Q?SLYOw64Vzt2vW0R1pYRgxi4AzYxZ67KF+yCRyZ4U/BIYngO9m1osgxt4msAi?=
 =?us-ascii?Q?Memai/vCptseaz7iXQD+Zm1oxr4ZzvK4cRjTVQ60ktdu4LHYbWsg04LzjC/4?=
 =?us-ascii?Q?B7Fgy/9lRqh/rXPAVtnFiA+2Yx46zAoNJJZbklMic49Xjc+JQIP12z5OSsTe?=
 =?us-ascii?Q?p6fmcQ25/9Nx0jmLL2CHYPnZ7O00piACkNLHoybO1gW3Syfz+RvnmdyupCl6?=
 =?us-ascii?Q?WLEnYFsu3VkBsVW29jmOv45M1ynEXNknADflkCG53XVbeRjEbWburuyckUQY?=
 =?us-ascii?Q?OZtUMrqMWV7SFyvbqCd/Pc1uxjgZI96ZWxLgAY8FGKEY25zHBZvgZLkcCt0H?=
 =?us-ascii?Q?RFwRY1bBymCda/oET1mfiMg/qdSHsnALo10T195wSCRW5k4u38V43X4tVf5N?=
 =?us-ascii?Q?oxRSiwjPCKjlR/+oEG4nOFErtPHN10VPLrgCVBriLqGTxfL7g3mmcfG/icPs?=
 =?us-ascii?Q?IddA+uuS3rayaZKu1rVvUTt+dWYnUqUwhCkAKB7JOzafWSAo30Jqg/tSXG1q?=
 =?us-ascii?Q?HPIxO0r53+UVLTRsjpYQh0+QLs8Kq3GDdY1nDOjtF8iY52RVOquToVrzgy2E?=
 =?us-ascii?Q?wthz/i0T0VucYKpSAre31ks4JJzdKglPH9H74Sfzm4DKf0Ctc+UmfVqqmhBD?=
 =?us-ascii?Q?ndNSRt1/vD3rk+BacoVP8zmEZpODtlt5jgg1Kr7JItofFfsbxVe1gTrOtHa0?=
 =?us-ascii?Q?qlG8NqseVu9jH4ujLMVsVDKZ9xbxL2S1wbBgVBoqjiE2tCY4QgQINLNLGrVU?=
 =?us-ascii?Q?E/eN/tLD9vqCKckjbNeyaNRxENlUdUKFZDoFEvgfB7nDW3pY9trQrx8dGRUM?=
 =?us-ascii?Q?bCqSQIiIsQe3Abc2LET8ZSbLEQTDFLED1UrZ7zQTt40/ce21O91K3gpYBhNV?=
 =?us-ascii?Q?2afEmbXozTQIY1wbDNS/DXNohhfHiRzkZQ2UnrVK1S8wksagf8X0e4Ei7RAj?=
 =?us-ascii?Q?E4BTqloP946k6LcqA4GN8Tu6aHyjxlJAQ4ltrTpM6Rjos43rZZprDyN653QF?=
 =?us-ascii?Q?t99latKRpITlPxYQTmcJKKHQhPeWkxW9apJY+TKy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cf0deb-0384-406a-7f7d-08da9d7acfb8
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:42.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5vBqmphIkLDVGmkfK1CiirFZ3t1DwxbDn5cA6r7jM14yUaZpDtwVADGKmcPgw0ZgKnxjJEUtA67jIPzZTa4KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
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

This patch allows the configuration of multiple buffer pools associated
with a single DPNI object, each distinct DPBP object not necessarily
shared among all queues.
The user can interogate both the number of buffer pools and the buffer
count in each buffer pool by using the .get_ethtool_stats() callback.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Export dpaa2_eth_allocate_dpbp/dpaa2_eth_free_dpbp in this patch to
   avoid a build warning. The functions will be used in next patches.

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 188 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  26 ++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  15 +-
 3 files changed, 162 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 75d51572693d..aa93ed339b63 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2020 NXP
+ * Copyright 2016-2022 NXP
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -304,7 +304,7 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
 	if (ch->recycled_bufs_cnt < DPAA2_ETH_BUFS_PER_CMD)
 		return;
 
-	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
+	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
 					       ch->recycled_bufs,
 					       ch->recycled_bufs_cnt)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
@@ -1631,7 +1631,7 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
  * to the specified buffer pool
  */
 static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
-			      struct dpaa2_eth_channel *ch, u16 bpid)
+			      struct dpaa2_eth_channel *ch)
 {
 	struct device *dev = priv->net_dev->dev.parent;
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
@@ -1663,12 +1663,12 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
 					 DPAA2_ETH_RX_BUF_RAW_SIZE,
 					 addr, priv->rx_buf_size,
-					 bpid);
+					 ch->bp->bpid);
 	}
 
 release_bufs:
 	/* In case the portal is busy, retry until successful */
-	while ((err = dpaa2_io_service_release(ch->dpio, bpid,
+	while ((err = dpaa2_io_service_release(ch->dpio, ch->bp->bpid,
 					       buf_array, i)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
 			break;
@@ -1697,39 +1697,59 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
-static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
+static int dpaa2_eth_seed_pool(struct dpaa2_eth_priv *priv,
+			       struct dpaa2_eth_channel *ch)
 {
-	int i, j;
+	int i;
 	int new_count;
 
-	for (j = 0; j < priv->num_channels; j++) {
-		for (i = 0; i < DPAA2_ETH_NUM_BUFS;
-		     i += DPAA2_ETH_BUFS_PER_CMD) {
-			new_count = dpaa2_eth_add_bufs(priv, priv->channel[j], bpid);
-			priv->channel[j]->buf_count += new_count;
+	for (i = 0; i < DPAA2_ETH_NUM_BUFS; i += DPAA2_ETH_BUFS_PER_CMD) {
+		new_count = dpaa2_eth_add_bufs(priv, ch);
+		ch->buf_count += new_count;
 
-			if (new_count < DPAA2_ETH_BUFS_PER_CMD) {
-				return -ENOMEM;
-			}
-		}
+		if (new_count < DPAA2_ETH_BUFS_PER_CMD)
+			return -ENOMEM;
 	}
 
 	return 0;
 }
 
+static void dpaa2_eth_seed_pools(struct dpaa2_eth_priv *priv)
+{
+	struct net_device *net_dev = priv->net_dev;
+	struct dpaa2_eth_channel *channel;
+	int i, err = 0;
+
+	for (i = 0; i < priv->num_channels; i++) {
+		channel = priv->channel[i];
+
+		err = dpaa2_eth_seed_pool(priv, channel);
+
+		/* Not much to do; the buffer pool, though not filled up,
+		 * may still contain some buffers which would enable us
+		 * to limp on.
+		 */
+		if (err)
+			netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
+				   channel->bp->dev->obj_desc.id,
+				   channel->bp->bpid);
+	}
+}
+
 /*
- * Drain the specified number of buffers from the DPNI's private buffer pool.
+ * Drain the specified number of buffers from one of the DPNI's private buffer
+ * pools.
  * @count must not exceeed DPAA2_ETH_BUFS_PER_CMD
  */
-static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
+static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
+				 int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
 	int retries = 0;
 	int ret;
 
 	do {
-		ret = dpaa2_io_service_acquire(NULL, priv->bpid,
-					       buf_array, count);
+		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
 		if (ret < 0) {
 			if (ret == -EBUSY &&
 			    retries++ < DPAA2_ETH_SWP_BUSY_RETRIES)
@@ -1742,23 +1762,35 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int count)
 	} while (ret);
 }
 
-static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_drain_pool(struct dpaa2_eth_priv *priv, int bpid)
 {
 	int i;
 
-	dpaa2_eth_drain_bufs(priv, DPAA2_ETH_BUFS_PER_CMD);
-	dpaa2_eth_drain_bufs(priv, 1);
+	/* Drain the buffer pool */
+	dpaa2_eth_drain_bufs(priv, bpid, DPAA2_ETH_BUFS_PER_CMD);
+	dpaa2_eth_drain_bufs(priv, bpid, 1);
 
+	/* Setup to zero the buffer count of all channels which were
+	 * using this buffer pool.
+	 */
 	for (i = 0; i < priv->num_channels; i++)
-		priv->channel[i]->buf_count = 0;
+		if (priv->channel[i]->bp->bpid == bpid)
+			priv->channel[i]->buf_count = 0;
+}
+
+static void dpaa2_eth_drain_pools(struct dpaa2_eth_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_bps; i++)
+		dpaa2_eth_drain_pool(priv, priv->bp[i]->bpid);
 }
 
 /* Function is called from softirq context only, so we don't need to guard
  * the access to percpu count
  */
 static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
-				 struct dpaa2_eth_channel *ch,
-				 u16 bpid)
+				 struct dpaa2_eth_channel *ch)
 {
 	int new_count;
 
@@ -1766,7 +1798,7 @@ static int dpaa2_eth_refill_pool(struct dpaa2_eth_priv *priv,
 		return 0;
 
 	do {
-		new_count = dpaa2_eth_add_bufs(priv, ch, bpid);
+		new_count = dpaa2_eth_add_bufs(priv, ch);
 		if (unlikely(!new_count)) {
 			/* Out of memory; abort for now, we'll try later on */
 			break;
@@ -1848,7 +1880,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 			break;
 
 		/* Refill pool if appropriate */
-		dpaa2_eth_refill_pool(priv, ch, priv->bpid);
+		dpaa2_eth_refill_pool(priv, ch);
 
 		store_cleaned = dpaa2_eth_consume_frames(ch, &fq);
 		if (store_cleaned <= 0)
@@ -2047,15 +2079,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	int err;
 
-	err = dpaa2_eth_seed_pool(priv, priv->bpid);
-	if (err) {
-		/* Not much to do; the buffer pool, though not filled up,
-		 * may still contain some buffers which would enable us
-		 * to limp on.
-		 */
-		netdev_err(net_dev, "Buffer seeding failed for DPBP %d (bpid=%d)\n",
-			   priv->dpbp_dev->obj_desc.id, priv->bpid);
-	}
+	dpaa2_eth_seed_pools(priv);
 
 	if (!dpaa2_eth_is_type_phy(priv)) {
 		/* We'll only start the txqs when the link is actually ready;
@@ -2088,7 +2112,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 
 enable_err:
 	dpaa2_eth_disable_ch_napi(priv);
-	dpaa2_eth_drain_pool(priv);
+	dpaa2_eth_drain_pools(priv);
 	return err;
 }
 
@@ -2193,7 +2217,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	dpaa2_eth_disable_ch_napi(priv);
 
 	/* Empty the buffer pool */
-	dpaa2_eth_drain_pool(priv);
+	dpaa2_eth_drain_pools(priv);
 
 	/* Empty the Scatter-Gather Buffer cache */
 	dpaa2_eth_sgt_cache_drain(priv);
@@ -3204,13 +3228,14 @@ static void dpaa2_eth_setup_fqs(struct dpaa2_eth_priv *priv)
 	dpaa2_eth_set_fq_affinity(priv);
 }
 
-/* Allocate and configure one buffer pool for each interface */
-static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
+/* Allocate and configure a buffer pool */
+struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv)
 {
-	int err;
-	struct fsl_mc_device *dpbp_dev;
 	struct device *dev = priv->net_dev->dev.parent;
+	struct fsl_mc_device *dpbp_dev;
 	struct dpbp_attr dpbp_attrs;
+	struct dpaa2_eth_bp *bp;
+	int err;
 
 	err = fsl_mc_object_allocate(to_fsl_mc_device(dev), FSL_MC_POOL_DPBP,
 				     &dpbp_dev);
@@ -3219,12 +3244,16 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 			err = -EPROBE_DEFER;
 		else
 			dev_err(dev, "DPBP device allocation failed\n");
-		return err;
+		return ERR_PTR(err);
 	}
 
-	priv->dpbp_dev = dpbp_dev;
+	bp = kzalloc(sizeof(*bp), GFP_KERNEL);
+	if (!bp) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
 
-	err = dpbp_open(priv->mc_io, 0, priv->dpbp_dev->obj_desc.id,
+	err = dpbp_open(priv->mc_io, 0, dpbp_dev->obj_desc.id,
 			&dpbp_dev->mc_handle);
 	if (err) {
 		dev_err(dev, "dpbp_open() failed\n");
@@ -3249,9 +3278,11 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 		dev_err(dev, "dpbp_get_attributes() failed\n");
 		goto err_get_attr;
 	}
-	priv->bpid = dpbp_attrs.bpid;
 
-	return 0;
+	bp->dev = dpbp_dev;
+	bp->bpid = dpbp_attrs.bpid;
+
+	return bp;
 
 err_get_attr:
 	dpbp_disable(priv->mc_io, 0, dpbp_dev->mc_handle);
@@ -3259,17 +3290,57 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 err_reset:
 	dpbp_close(priv->mc_io, 0, dpbp_dev->mc_handle);
 err_open:
+err_alloc:
 	fsl_mc_object_free(dpbp_dev);
 
-	return err;
+	return ERR_PTR(err);
+}
+
+static int dpaa2_eth_setup_default_dpbp(struct dpaa2_eth_priv *priv)
+{
+	struct dpaa2_eth_bp *bp;
+	int i;
+
+	bp = dpaa2_eth_allocate_dpbp(priv);
+	if (IS_ERR(bp))
+		return PTR_ERR(bp);
+
+	priv->bp[DPAA2_ETH_DEFAULT_BP_IDX] = bp;
+	priv->num_bps++;
+
+	for (i = 0; i < priv->num_channels; i++)
+		priv->channel[i]->bp = bp;
+
+	return 0;
+}
+
+void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp)
+{
+	int idx_bp;
+
+	/* Find the index at which this BP is stored */
+	for (idx_bp = 0; idx_bp < priv->num_bps; idx_bp++)
+		if (priv->bp[idx_bp] == bp)
+			break;
+
+	/* Drain the pool and disable the associated MC object */
+	dpaa2_eth_drain_pool(priv, bp->bpid);
+	dpbp_disable(priv->mc_io, 0, bp->dev->mc_handle);
+	dpbp_close(priv->mc_io, 0, bp->dev->mc_handle);
+	fsl_mc_object_free(bp->dev);
+	kfree(bp);
+
+	/* Move the last in use DPBP over in this position */
+	priv->bp[idx_bp] = priv->bp[priv->num_bps - 1];
+	priv->num_bps--;
 }
 
-static void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv)
+static void dpaa2_eth_free_dpbps(struct dpaa2_eth_priv *priv)
 {
-	dpaa2_eth_drain_pool(priv);
-	dpbp_disable(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
-	dpbp_close(priv->mc_io, 0, priv->dpbp_dev->mc_handle);
-	fsl_mc_object_free(priv->dpbp_dev);
+	int i;
+
+	for (i = 0; i < priv->num_bps; i++)
+		dpaa2_eth_free_dpbp(priv, priv->bp[i]);
 }
 
 static int dpaa2_eth_set_buffer_layout(struct dpaa2_eth_priv *priv)
@@ -4154,6 +4225,7 @@ static int dpaa2_eth_set_default_cls(struct dpaa2_eth_priv *priv)
  */
 static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
+	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
 	struct dpni_pools_cfg pools_params;
@@ -4162,7 +4234,7 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 	int i;
 
 	pools_params.num_dpbp = 1;
-	pools_params.pools[0].dpbp_id = priv->dpbp_dev->obj_desc.id;
+	pools_params.pools[0].dpbp_id = bp->dev->obj_desc.id;
 	pools_params.pools[0].backup_pool = 0;
 	pools_params.pools[0].buffer_size = priv->rx_buf_size;
 	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
@@ -4642,7 +4714,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	dpaa2_eth_setup_fqs(priv);
 
-	err = dpaa2_eth_setup_dpbp(priv);
+	err = dpaa2_eth_setup_default_dpbp(priv);
 	if (err)
 		goto err_dpbp_setup;
 
@@ -4778,7 +4850,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_percpu_stats:
 	dpaa2_eth_del_ch_napi(priv);
 err_bind:
-	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpbps(priv);
 err_dpbp_setup:
 	dpaa2_eth_free_dpio(priv);
 err_dpio_setup:
@@ -4831,7 +4903,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	free_percpu(priv->percpu_extras);
 
 	dpaa2_eth_del_ch_napi(priv);
-	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpbps(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
 	if (priv->onestep_reg_base)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 447718483ef4..bb0881e7033b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016-2020 NXP
+ * Copyright 2016-2022 NXP
  */
 
 #ifndef __DPAA2_ETH_H
@@ -109,6 +109,14 @@
 #define DPAA2_ETH_RX_BUF_ALIGN_REV1	256
 #define DPAA2_ETH_RX_BUF_ALIGN		64
 
+/* The firmware allows assigning multiple buffer pools to a single DPNI -
+ * maximum 8 DPBP objects. By default, only the first DPBP (idx 0) is used for
+ * all queues. Thus, when enabling AF_XDP we must accommodate up to 9 DPBPs
+ * object: the default and 8 other distinct buffer pools, one for each queue.
+ */
+#define DPAA2_ETH_DEFAULT_BP_IDX	0
+#define DPAA2_ETH_MAX_BPS		9
+
 /* We are accommodating a skb backpointer and some S/G info
  * in the frame's software annotation. The hardware
  * options are either 0 or 64, so we choose the latter.
@@ -454,6 +462,11 @@ struct dpaa2_eth_ch_xdp {
 	unsigned int res;
 };
 
+struct dpaa2_eth_bp {
+	struct fsl_mc_device *dev;
+	int bpid;
+};
+
 struct dpaa2_eth_channel {
 	struct dpaa2_io_notification_ctx nctx;
 	struct fsl_mc_device *dpcon;
@@ -472,6 +485,8 @@ struct dpaa2_eth_channel {
 	/* Buffers to be recycled back in the buffer pool */
 	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
 	int recycled_bufs_cnt;
+
+	struct dpaa2_eth_bp *bp;
 };
 
 struct dpaa2_eth_dist_fields {
@@ -535,14 +550,16 @@ struct dpaa2_eth_priv {
 	u8 ptp_correction_off;
 	void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
 					    u32 offset, u8 udp);
-	struct fsl_mc_device *dpbp_dev;
 	u16 rx_buf_size;
-	u16 bpid;
 	struct iommu_domain *iommu_domain;
 
 	enum hwtstamp_tx_types tx_tstamp_type;	/* Tx timestamping type */
 	bool rx_tstamp;				/* Rx timestamping enabled */
 
+	/* Buffer pool management */
+	struct dpaa2_eth_bp *bp[DPAA2_ETH_MAX_BPS];
+	int num_bps;
+
 	u16 tx_qdid;
 	struct fsl_mc_io *mc_io;
 	/* Cores which have an affine DPIO/DPCON.
@@ -771,4 +788,7 @@ void dpaa2_eth_dl_traps_unregister(struct dpaa2_eth_priv *priv);
 
 struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
 						  struct dpaa2_fapr *fapr);
+
+struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp);
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 46b493892f3b..32a38a03db57 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -241,9 +241,9 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	u32 bcnt_rx_total = 0, bcnt_tx_total = 0;
 	struct dpaa2_eth_ch_stats *ch_stats;
 	struct dpaa2_eth_drv_stats *extras;
+	u32 buf_cnt, buf_cnt_total = 0;
 	int j, k, err, num_cnt, i = 0;
 	u32 fcnt, bcnt;
-	u32 buf_cnt;
 
 	memset(data, 0,
 	       sizeof(u64) * (DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS));
@@ -305,12 +305,15 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	*(data + i++) = fcnt_tx_total;
 	*(data + i++) = bcnt_tx_total;
 
-	err = dpaa2_io_query_bp_count(NULL, priv->bpid, &buf_cnt);
-	if (err) {
-		netdev_warn(net_dev, "Buffer count query error %d\n", err);
-		return;
+	for (j = 0; j < priv->num_bps; j++) {
+		err = dpaa2_io_query_bp_count(NULL, priv->bp[j]->bpid, &buf_cnt);
+		if (err) {
+			netdev_warn(net_dev, "Buffer count query error %d\n", err);
+			return;
+		}
+		buf_cnt_total += buf_cnt;
 	}
-	*(data + i++) = buf_cnt;
+	*(data + i++) = buf_cnt_total;
 
 	if (dpaa2_eth_has_mac(priv))
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
-- 
2.25.1

