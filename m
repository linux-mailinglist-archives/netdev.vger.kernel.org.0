Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315F3602E2C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJROT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiJROTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:47 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75B31572F;
        Tue, 18 Oct 2022 07:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsDh+KLhpFStstMtFLTgIKtw19b9vQUbCIZmm6ZWPv5Nkw4KYxt1bNA5cBJIDfmYWrcKYvdgvxSx3kxgfs4R5uHpn6MSP7JTHiYyWwZ28TawqYSoQ3ohzYST2dJFlxw+vu6q9/n9F3PAgQVFyigqkQgOM7GQt4iQ9XQoh+PXt+gBRfnnAoeb7EdG4BM5UUa1D54LGJ1JWf7npxICICxLYyo1oaLhYc4fIsDAmd5ck8qoCiUj6HMTIr1AwrF8vQE22U0P/NirY74yxzsUO2C7ukwGcW2tGhAiKLgkJk4RsmM4M2+Vxvb4GxcadwxZm7fknR49r1LqNd6Oce1mLG3gzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dD1ZYv5hgpKKUFCs44I7VMWomJrZ6Y+lxd+wAwn02Os=;
 b=mmFatQzu8VbUUg7pJZ7RTvbf3XkCdt1pGRKMU589FbSgZkIf4TABmidpx4Wb59i+LZNpt01/0ZyRX9uduz0C7kI499ji+Xaysnt2lIJCCB58H5HX0dg+bXIhMqwrV98qoVgvyo51OifC8mXIgEIs3FXuzNrKoFXSx+k7s+cQy9b98iVhMS9uFiNm+PVNrP0Q2NyAQtkjHjjsYgLG/i4I0CPRt2MMYxnH4pKBfqyAAJXRKC2lQsL/agTdjIGNTfebIkhqct3dcMv+V4mpROKQTTvmh74SBKBut1oo2oi28+pPYAj+wh0SPNAf2DlrYEM6rJ4vBhVzj+pudHAIYlBpeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dD1ZYv5hgpKKUFCs44I7VMWomJrZ6Y+lxd+wAwn02Os=;
 b=Fq/e4hj0cboHYO/rMoDHGNRGnSJz8Qkw93nSdKJZ4fmJKIPWY8WZy1VSyEb5Ff5jqXX49dMKsRgtskXPwkYjqpLipIdYasBKqgYJLajj/kNqgaxUi9s0ywzE9RefNFoN/elDMelR4+O0lzmCn3gDQobyCdd4/Ot/jNd6NVnqDiI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:31 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 03/12] net: dpaa2-eth: add support for multiple buffer pools per DPNI
Date:   Tue, 18 Oct 2022 17:18:52 +0300
Message-Id: <20221018141901.147965-4-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f6e9863b-964a-478b-9e4f-08dab113c62a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Xi4mLcNXson2dxR9pcsw2KG9H2tROtnS+jdvIBQOKvjOGMKbTG95ZVAb/Xd+VFsh39vSslI+mBwQxWtnCVwLUNeOGUikkmzA3ubHot0fDMnvPFkZ7XayLTehqx+nLUj9yPV3Zy/xtRTzeLG1V82phjOgcMzRPD7wHmqKdbz1FsIpkUQN97w4V/iDndWM6yBb2wOFQzYeJ/DB4w0TqVmTwOTy4tOFBxJDxiUu8Eo2hV2htiHXE0T8mC56cqAO3GDcTK3woYujDBdOVbI+3mtDdneCOlO1vBL9wyMXTciwUrbT2BrbFJLlrbJwmSEP/ZeBXrJav8BC2OEEfC8fpTLMKCN8UnF4wClbwSafRTB8ZsRB5dhZHmau+5UmbWSwqQKD17CfaMuoS6C3pUGO9OIXMOKQWJ3lPZv2BHF6wflUAytO0KOSaWLwi9MnaJE7BbSXpQW4eIqhiPAaWSFjk0ueUNFN7SZG8INk7Nc7Gc+x04Mr58SWo5OtKfr5eoGwz5CPFBWH0lbP11MXYyI7GfxXi06a748K2LRTbOx3qcVqOnBSRMsvdZAD4Nqw+BkfQ1ieehyFwfYijEZZBqqXsH7oYicZh8nxPW5m5b+zEFWEtndL83gIsseKYK962OmjKC9W5/1NFkVp7j/Dcl7CJQ6xZJ926ccFHEovZ3ieKMdyalHno6IZytEdzwXGdCJ/2EDI9pgzrYe2nsePg3mM84pdBXf4C1XEDTS9CU6IADZlvNlPIN4ZgacM7gaY7NYrYhN1qEd7Wfwpe+3zNTjMe/M8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(30864003)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PUf02mSkNn3LepfU9g7UJwI7qXRbGPwRnxh6SXWJvS25bS4TQpdwSgIGEhAp?=
 =?us-ascii?Q?5IFhz9tLMT1b8ugmiSPuBujAsnqjjh0AJyFmkA1pflaOuAbrECRXTAkBfRNa?=
 =?us-ascii?Q?4ufxk0fBNncxBsa09QAQMOEI0u9cHHeQ2pktdmHObZIuYQa/3sAwvCFjczJ5?=
 =?us-ascii?Q?NuTq7PFZoZ01B7V0VUjQFHGltIamtH4kXAGANp++/KVsw95wg5Hd1og1qbXA?=
 =?us-ascii?Q?LtSYIyBlzCHDXePVU3ZLo9hRScFZ/dLJ037vWS4PO6eqNhbCz8b5/e5LznDM?=
 =?us-ascii?Q?oB27oliZwQDkuFu0OWIa5H+Xd5cRmXNStT1mBj2zzPenZmOpZun6mAVcqnVi?=
 =?us-ascii?Q?cJ/02gIzaNwKThkshLWRxfzZMOrnTkTkFfRy5OruPEPP+vlBfisMqCltcJO9?=
 =?us-ascii?Q?efutAIgyRNNPnFz5EanAdTmMcFdaHKzQbTUWq2egROY5oLGMh/TYU2QZWdya?=
 =?us-ascii?Q?+AwM0t3bnb6RvBH6FgdC/BdOj+ynAS5jSTBTkfKCh7gKYoVtectV68WtUvu2?=
 =?us-ascii?Q?BnRANhug3zxX2eNePl15Rn0DCRn1GJayAsDuhUr7rV+N85C9PuxSQYZPLk8a?=
 =?us-ascii?Q?xYOapJHaB0zOP/jekYFDjRfqolud7aOXiJxfVytmQJfzjEgICiCX09hMW2x3?=
 =?us-ascii?Q?YTguKEFl5ujl75k+qCful15hkV6CNnUjvcg3SgucbWUWSWZ1K/kTBwO5ClgS?=
 =?us-ascii?Q?DipE+xWWzjRY36ozsr3HIm1bpLOtptqf90BO3soSF7liUM9Ilw5/gCCmx1nD?=
 =?us-ascii?Q?PyYwEZ4I/Y6tEthknW4TH7sNmhQoS25tcE+aV5NrKtWIquK3kkLAEBabARfN?=
 =?us-ascii?Q?8Og/pm5cs21cZAu3DlFBwRshq6wtMI8TtTSMPTaozQNF8mP38XNGCbNtEmQ3?=
 =?us-ascii?Q?xADALbUvZ62H6xSHZAbjVdcrNCou3zlyxWqy8xanonSV3FNJcppSeGbv/DZ3?=
 =?us-ascii?Q?S13dgO1RNZXwaB1PcCX2gHCtyyQQch0MB/Eg1BkTgvyJeEyOA32HtwlMipKK?=
 =?us-ascii?Q?DeJEiO3X5b4Y8h/RnC9Ga3Wo23418m/G8URjmZtodZ8G9YIojwVKt36V+QwY?=
 =?us-ascii?Q?8h1cyiN/8RS8v/RPuMr1a6sywQL8yWRQNgGvnnY7tyIYwQplSr+UcuAmVJkG?=
 =?us-ascii?Q?aykEvgCt/VjCIHfOLlo9h6fyd2emIBr3B4HO+8DWn67ZS6GDhCetYTJivUkd?=
 =?us-ascii?Q?J5RkEWSJi9XPt5vPzgdXQiLATM6mObnNWoWqdghLF97O2q4tafc8gkLOCNNX?=
 =?us-ascii?Q?CqGZtNXzuGkMMh2e5R3rgE/gAwfZTioJJ6v9jBHYjQ+zN+oZD//2Q1mNcSpF?=
 =?us-ascii?Q?gu95wmeHjpqRPTtFNkDChs1mVL09a8bCo43biMGbPJMKQwjOfDZEACeu35lH?=
 =?us-ascii?Q?z6vbmO3Xg8oNmFIMDSVAyhLgukZfj3HKPp8VPjJTD3M02BSOEMn2dQ38aGOa?=
 =?us-ascii?Q?2tbjTlTa7e5bKfz3jvas0oXkbVIMMV/9wuZmAQhv9xdv4iAxWC84FRBHoY1/?=
 =?us-ascii?Q?79KFAGZWoT1AFHvtARzINnjvPAGdugnr+C/OyR/5i2kR3Y6/Uxet8oV3ItsZ?=
 =?us-ascii?Q?nogG9wjkeNTbfqy7/0rC8e9Y9AqxUz/zxwZKCHIn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e9863b-964a-478b-9e4f-08dab113c62a
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:31.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43u2gmxOAZYAwuQtQM+8Th49BW9IjegyTSdGZ462HPYIVAvr++BqtgAfXpOOnpLu+XNq7VBMojmcKbYokk2nFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
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
Changes in v3:
 - fix leaking of bp on the error path

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 189 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  26 ++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  15 +-
 3 files changed, 163 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8d029addddad..1213ae4e1301 100644
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
@@ -3259,17 +3290,58 @@ static int dpaa2_eth_setup_dpbp(struct dpaa2_eth_priv *priv)
 err_reset:
 	dpbp_close(priv->mc_io, 0, dpbp_dev->mc_handle);
 err_open:
+	kfree(bp);
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
@@ -4154,6 +4226,7 @@ static int dpaa2_eth_set_default_cls(struct dpaa2_eth_priv *priv)
  */
 static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
+	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
 	struct dpni_pools_cfg pools_params;
@@ -4162,7 +4235,7 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 	int i;
 
 	pools_params.num_dpbp = 1;
-	pools_params.pools[0].dpbp_id = priv->dpbp_dev->obj_desc.id;
+	pools_params.pools[0].dpbp_id = bp->dev->obj_desc.id;
 	pools_params.pools[0].backup_pool = 0;
 	pools_params.pools[0].buffer_size = priv->rx_buf_size;
 	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
@@ -4641,7 +4714,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	dpaa2_eth_setup_fqs(priv);
 
-	err = dpaa2_eth_setup_dpbp(priv);
+	err = dpaa2_eth_setup_default_dpbp(priv);
 	if (err)
 		goto err_dpbp_setup;
 
@@ -4777,7 +4850,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_alloc_percpu_stats:
 	dpaa2_eth_del_ch_napi(priv);
 err_bind:
-	dpaa2_eth_free_dpbp(priv);
+	dpaa2_eth_free_dpbps(priv);
 err_dpbp_setup:
 	dpaa2_eth_free_dpio(priv);
 err_dpio_setup:
@@ -4830,7 +4903,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
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

