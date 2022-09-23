Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED495E7EF0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiIWPr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiIWPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:47:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BD85A8B2;
        Fri, 23 Sep 2022 08:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izNsB3dRphDE7CRcIOs4TSvq+SAR+4Guqz1ZnyGyOLIU2BPWxxfb3Vqleicqy68Dp+jkxZr9dZIpN9bBKsOvrwMMxqd+6N/v+V/c7Ru2jkSQ7AeOQDLp7up7J2CjYQ/a1xU/aXUwg0TQQyzpsxqCkOhqjmZIefztzuFXgb4g10xug+UPB/fQdsXr0jiH1Xw/0Oj28sIVGqcg+rv1/uzCFL9pFsINtDVosv6Opg+uwgnCO4CsGYYlYfCbuX6kJlVxzstOCxqK4LIsqcGD00sfsLKl18aAgIYTlFvfWn0qrVkL+JQK74II3w7yNXkoUQaiz9LTD0OARzwtbjXiP5dpbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRifrcB0Hnsok+K4UozMkJwYCQ9Z0pkV6fmXuhnux8U=;
 b=HXyb30iRgp8jL9K3Kmu68Dos6Ro4vKa/W3EvQGDu7Z5GU/0zstFTkHlsZpmxPtItiVo6MpprixyEO0rb14tskjA4H5Qcj6z2rn6N/WIcHFznRMKkKLEO6GWJyP7w2G0Dwd9XykgwWdp7TWtyy3ySeAW+bMsHH0z+Ig3BD2alXtkxXJ5ohQwbKVMpI4MyARe8Ift6PYLov3hXNxSixKRTTqOqFPhktigmzD+kUtuaKPPtEAAvz0db3p6ERPLpjZyZ2ytchkdpb6FIYsRZH8rmpWRjEJX0TtXRuoCILxRpgfhzC7osRedSpSP4dI8gYWl3aBWkuRdE9H/blpvf/NWwpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRifrcB0Hnsok+K4UozMkJwYCQ9Z0pkV6fmXuhnux8U=;
 b=nLkWRMYyJaHxxdyI8O5MKv4vbCzygmNCx2k4SHi7Q3SfFnVnaSqF7TSr/HhXafkjhfPXmY2lHK62fZAPonqh84Y8WlQr0U30fYpteNjA797GMkDyW/DLcPUXig/SPn3YCIBWoXyUhsDCI9cBScjAWI2tDGpVcGgtgYuMKIzOGwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:55 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:55 +0000
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
Subject: [PATCH net-next v2 12/12] net: dpaa2-eth: add trace points on XSK events
Date:   Fri, 23 Sep 2022 18:45:56 +0300
Message-Id: <20220923154556.721511-13-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f36dff1a-2dc7-4f02-11ca-08da9d7ad734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3k1B5yPvDaC405ibl29PsQZs+j4k+F9Y5/KuQG5PvpcuVKZlzktAl1jSw839bUQZhJykf3luK3iBAe2u26aVmItHyDaH8ZCMNwrR7frBSR0mZ0LIb1aYVjc7uQGuh9FKwAPVLFWsZIse0RpHkVoW9kaoUiPzdKZjD4Hml1Vin9L7dF7u4GFB5vPxwmyiYpyKNS9DYO0M1bPYLiCvMBTxBJfcn5dKntgykABxEUQiMRSS+nfTc3q9gZxFNeVMDgAjC08wR9iqpxI30uvuodZr00nFP55ccH08UsGatGjbyUyKHK3l663RACHMOHmAzYa+hdDOCJRw5yoG8aWcfRnlFVXKLRT/Iv2KVUgz4SjjsDQDaT62klHRY84WOg0mp2rVvvCZ0/d092pRQffCRycNN7Gt3dttwLMDnNNel5/GPLa7zzpHWuHyVkyISCQCZMoEOPqaAZEBY1pmx9MujGj7LejGJIViVRsmWVCSmHf7e7DxVw42nEuxVNbsnSsXFI2rt+KR+PZ7KD3R4fnh3JaCfELQ9ajMQ5BOXwQvSC8tkXrPohe6v9h2+Mf44BtPFCo9Kj8OwCNue6Dp7cZZMzoZyUj3t9Fy7v4CVRzaQeIuE8UnlzC8t/x9X+89U5HEbqQ/rj0+P7IT6HB9UZqRZKHt13Pe1So/du+GrdDCN5fb4Wsh31VPUTuwIP1HbIhc0yLsHYC+ZZ+fIiGv/KKdyZxTg4xRClYqCdJjGTN4WVBrC2VUIU6eH7Th98wbmtfDvdWgGi9YCj6pY1EK9AcQzcgEQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(66476007)(41300700001)(52116002)(83380400001)(6506007)(66556008)(4326008)(66946007)(8676002)(26005)(36756003)(6512007)(38350700002)(8936002)(38100700002)(6486002)(110136005)(54906003)(316002)(478600001)(2906002)(2616005)(44832011)(86362001)(1076003)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VzEfOWSWI15j43FKa4ZSYLCRBHmT77Q0+ZTROvS6obv9jKSORxZm62huV73v?=
 =?us-ascii?Q?o34DWhooitmfPhBdU41+nfFCYf+0niuQGpyLPedF0QDaE+wusfMBqHL4kB5d?=
 =?us-ascii?Q?4mvQ1Mjb37Nh/ExgToj62Ky0S4tWzthPqlB733jtTAOpmdowxDywMaYw0gKk?=
 =?us-ascii?Q?QSu7yGP0b8NqxA6DAk6M8DfaWyldz1PpuHSl/x9PD9HzTAh+fLNp6scwYM3J?=
 =?us-ascii?Q?9v7NgdVU12zSp4CtknNxYxyCrudutUWUdXIS2UNdz39CTTVQQvZeAJockpza?=
 =?us-ascii?Q?ptYTVQNgpxLIgIqZ8M8ZrNwm/rCX93ywR+YRmPa35AfRoLIGwJCo32LhlSOQ?=
 =?us-ascii?Q?xeuANyxMCnvTMO4ytjljyGFu6jHBqefLKv5mrGMROElR/OCdqW2IJ7b40Kwd?=
 =?us-ascii?Q?x/Pq9prqy1RYm3FVc95c4GmRobmpWl8QGGCx+ARXGL8yWEI94wmKZQbmXTXC?=
 =?us-ascii?Q?OKQHHFSvJOWY8K9NRHTV69KoJeSPInB0gUgIkQfsUckj4qe9e8OooiAq07oG?=
 =?us-ascii?Q?QcbmXrquzqRh8DsV12wGnLoeVl6bpJ+htVyzwP7fr8heHwBpUX+I7lU5BOWK?=
 =?us-ascii?Q?0TYF619w8X4T7fBp/N3AkKngVk1wMPCTV5+nXYf9XCU25yH8AJe4y+4V4yHb?=
 =?us-ascii?Q?uCk8HBjCpNzR6+7iowZ9ft0b1Bq/DFNDUSBmrwX9S9XdHQYgNcN5wvz/h32z?=
 =?us-ascii?Q?FbhJtNJU/zAOj5E//56kdsBCEGPPyoxi7YKG+Sxxb6NpjVDHjx3G0ijM1Zky?=
 =?us-ascii?Q?DO/PgM9Bxs9phusJgqclG2LcpZH2NH0XfC3pPppZf+wkxM3OdyLSb6tw8IF0?=
 =?us-ascii?Q?8Z6wJOal1Th4cE97x6cDO9E7bBknn0tOTt7Pfr246hsMH2h7ik1w0o8Z6GVk?=
 =?us-ascii?Q?3INCFT5k7Km77m1go3PxrryPnE3LtYit2Eza64y5VBOaZENQDXwLtYlLw8K+?=
 =?us-ascii?Q?Se6I8xeN9m7TmocpQzakUCH4mdDWNDvKn9RJkBNStH2ORUks0iyi93P48w1h?=
 =?us-ascii?Q?W5eMhzJqeuA6+2R8feQdEgeJ1EGvGn7arEe2ALfVX7OQIz5hDUIN6bDWZ9wk?=
 =?us-ascii?Q?d/qbh65O3kVkOqHLAtWx5omLwZPpXeYQZko3gqL8mKuHsEQIdF4oJriMg4ZS?=
 =?us-ascii?Q?tBpdAeRv1FsLY2KObKQMZenlVNby5McTEJKVDh2ZqVIdoYHy9l/CgE8UmZVz?=
 =?us-ascii?Q?Hq6l0z+Uh2P00Ccb27edvTdS91QSdIMdVh/F4qsGRsNbcVHFc6dec+iIBpNl?=
 =?us-ascii?Q?Z7VT/+5WRvBP09P7MFF8m0VfPBebna7G3B4pw0Qx4oT6cabZcqa80Zw/7ocM?=
 =?us-ascii?Q?CvvmJn3vY/lYbVwQMfX9lJ9dK5iAeBQZqrT3/0eCb4a2IyYWjDvvOszVMQ0g?=
 =?us-ascii?Q?a8OdzppD6IsL3KLzRMUDalNw6CByJR0ydeBejbaAbBOVNn8z0O9Z8uWWFvwK?=
 =?us-ascii?Q?qlrBOHBcbPB386KW4H6A0yqIxmxFATc1PpAUe3P25TIhhQtLVXI3IziTKVNS?=
 =?us-ascii?Q?wJxf/hoMWsiHZm3Y6IfjJl/+Wln+ppxKMK57AqeGg5z6W0jQcZf0hkFgpJRz?=
 =?us-ascii?Q?kwdm/lt4UouMyPuyr1NspXAgIs8wmMQg1dtguxIsMj3mQYb6cQStRRn38xaf?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36dff1a-2dc7-4f02-11ca-08da9d7ad734
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:55.0930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RN8D1Rrf+1WAGXpw4f9WCG96XONpSFznO6rdGBlhTveulf6eMCJAY+dRQsdRS2erU+5GPsnwKqR2/U+hPxCXEg==
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

Define the dpaa2_tx_xsk_fd and dpaa2_rx_xsk_fd trace events for the XSK
zero-copy Rx and Tx path.  Also, define the dpaa2_eth_buf as an event
class so that both dpaa2_eth_buf_seed and dpaa2_xsk_buf_seed traces can
derive from the same class.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Use xdp_buff->data_hard_start when tracing the BP seeding.

 .../freescale/dpaa2/dpaa2-eth-trace.h         | 142 +++++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   6 +
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  |   4 +
 3 files changed, 101 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
index 5fb5f14e01ec..9b43fadb9b11 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
@@ -73,6 +73,14 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_fd,
 	     TP_ARGS(netdev, fd)
 );
 
+/* Tx (egress) XSK fd */
+DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_xsk_fd,
+	     TP_PROTO(struct net_device *netdev,
+		      const struct dpaa2_fd *fd),
+
+	     TP_ARGS(netdev, fd)
+);
+
 /* Rx fd */
 DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_fd,
 	     TP_PROTO(struct net_device *netdev,
@@ -81,6 +89,14 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_fd,
 	     TP_ARGS(netdev, fd)
 );
 
+/* Rx XSK fd */
+DEFINE_EVENT(dpaa2_eth_fd, dpaa2_rx_xsk_fd,
+	     TP_PROTO(struct net_device *netdev,
+		      const struct dpaa2_fd *fd),
+
+	     TP_ARGS(netdev, fd)
+);
+
 /* Tx confirmation fd */
 DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_conf_fd,
 	     TP_PROTO(struct net_device *netdev,
@@ -90,57 +106,81 @@ DEFINE_EVENT(dpaa2_eth_fd, dpaa2_tx_conf_fd,
 );
 
 /* Log data about raw buffers. Useful for tracing DPBP content. */
-TRACE_EVENT(dpaa2_eth_buf_seed,
-	    /* Trace function prototype */
-	    TP_PROTO(struct net_device *netdev,
-		     /* virtual address and size */
-		     void *vaddr,
-		     size_t size,
-		     /* dma map address and size */
-		     dma_addr_t dma_addr,
-		     size_t map_size,
-		     /* buffer pool id, if relevant */
-		     u16 bpid),
-
-	    /* Repeat argument list here */
-	    TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid),
-
-	    /* A structure containing the relevant information we want
-	     * to record. Declare name and type for each normal element,
-	     * name, type and size for arrays. Use __string for variable
-	     * length strings.
-	     */
-	    TP_STRUCT__entry(
-			     __field(void *, vaddr)
-			     __field(size_t, size)
-			     __field(dma_addr_t, dma_addr)
-			     __field(size_t, map_size)
-			     __field(u16, bpid)
-			     __string(name, netdev->name)
-	    ),
-
-	    /* The function that assigns values to the above declared
-	     * fields
-	     */
-	    TP_fast_assign(
-			   __entry->vaddr = vaddr;
-			   __entry->size = size;
-			   __entry->dma_addr = dma_addr;
-			   __entry->map_size = map_size;
-			   __entry->bpid = bpid;
-			   __assign_str(name, netdev->name);
-	    ),
-
-	    /* This is what gets printed when the trace event is
-	     * triggered.
-	     */
-	    TP_printk(TR_BUF_FMT,
-		      __get_str(name),
-		      __entry->vaddr,
-		      __entry->size,
-		      &__entry->dma_addr,
-		      __entry->map_size,
-		      __entry->bpid)
+DECLARE_EVENT_CLASS(dpaa2_eth_buf,
+		    /* Trace function prototype */
+		    TP_PROTO(struct net_device *netdev,
+			     /* virtual address and size */
+			    void *vaddr,
+			    size_t size,
+			    /* dma map address and size */
+			    dma_addr_t dma_addr,
+			    size_t map_size,
+			    /* buffer pool id, if relevant */
+			    u16 bpid),
+
+		    /* Repeat argument list here */
+		    TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid),
+
+		    /* A structure containing the relevant information we want
+		     * to record. Declare name and type for each normal element,
+		     * name, type and size for arrays. Use __string for variable
+		     * length strings.
+		     */
+		    TP_STRUCT__entry(
+				      __field(void *, vaddr)
+				      __field(size_t, size)
+				      __field(dma_addr_t, dma_addr)
+				      __field(size_t, map_size)
+				      __field(u16, bpid)
+				      __string(name, netdev->name)
+		    ),
+
+		    /* The function that assigns values to the above declared
+		     * fields
+		     */
+		    TP_fast_assign(
+				   __entry->vaddr = vaddr;
+				   __entry->size = size;
+				   __entry->dma_addr = dma_addr;
+				   __entry->map_size = map_size;
+				   __entry->bpid = bpid;
+				   __assign_str(name, netdev->name);
+		    ),
+
+		    /* This is what gets printed when the trace event is
+		     * triggered.
+		     */
+		    TP_printk(TR_BUF_FMT,
+			      __get_str(name),
+			      __entry->vaddr,
+			      __entry->size,
+			      &__entry->dma_addr,
+			      __entry->map_size,
+			      __entry->bpid)
+);
+
+/* Main memory buff seeding */
+DEFINE_EVENT(dpaa2_eth_buf, dpaa2_eth_buf_seed,
+	     TP_PROTO(struct net_device *netdev,
+		      void *vaddr,
+		      size_t size,
+		      dma_addr_t dma_addr,
+		      size_t map_size,
+		      u16 bpid),
+
+	     TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid)
+);
+
+/* UMEM buff seeding on AF_XDP fast path */
+DEFINE_EVENT(dpaa2_eth_buf, dpaa2_xsk_buf_seed,
+	     TP_PROTO(struct net_device *netdev,
+		      void *vaddr,
+		      size_t size,
+		      dma_addr_t dma_addr,
+		      size_t map_size,
+		      u16 bpid),
+
+	     TP_ARGS(netdev, vaddr, size, dma_addr, map_size, bpid)
 );
 
 /* If only one event of a certain type needs to be declared, use TRACE_EVENT().
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4cfdbf644466..e78781cd37bb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1731,6 +1731,12 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 				goto err_map;
 
 			buf_array[i] = addr;
+
+			trace_dpaa2_xsk_buf_seed(priv->net_dev,
+						 xdp_buffs[i]->data_hard_start,
+						 DPAA2_ETH_RX_BUF_RAW_SIZE,
+						 addr, priv->rx_buf_size,
+						 ch->bp->bpid);
 		}
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
index 731318842054..567f52affe21 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -113,6 +113,8 @@ static void dpaa2_xsk_rx(struct dpaa2_eth_priv *priv,
 	void *vaddr;
 	u32 xdp_act;
 
+	trace_dpaa2_rx_xsk_fd(priv->net_dev, fd);
+
 	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 
@@ -416,6 +418,8 @@ bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
 			batch = i;
 			break;
 		}
+
+		trace_dpaa2_tx_xsk_fd(priv->net_dev, &fds[i]);
 	}
 
 	/* Enqueue all the created FDs */
-- 
2.25.1

