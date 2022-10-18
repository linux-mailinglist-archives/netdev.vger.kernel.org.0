Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCC1602E40
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiJROVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJROUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6076BBD075;
        Tue, 18 Oct 2022 07:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2WXt/8fBQW35yKfhCUUW3suLAnr2zdvW5puqDwAdpwwyhQSsxOen+Yb1bT5XCkbme/fI8IQJxMZeMJOwdQHs2rRKZggSXJa75vyiL9zxcAsm0/gdraR7jbcW+Ak8uckBRKXL8rb5UTycQ+7ojMnmvNC46/4kAaxDTd+SIV/ggLYg/EMNvWxST2EHRXOk38l/WkKgNst2MQlmHKbIE+jSm2T2x2sJZdxkxN+VKPtutNcz1ecOJWAWLCTkcg266K89J2NQ4QqE9MblhGBYlD4Hn/PeKSevBKUOrLScRrgZbJ/VNEanvkbCbYHQzYUW+pogAY1Zb7bByrkwJ5qo091/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fqf73MavOZSklD5rJTa/mWMjxQPpLp3ZdllsJTx5kOg=;
 b=GUR3oLs2eXAZ1vAr/AIefoxX08Ca2Iqg90BxCWZep/Gi8+NYI6LRPtmbITVZLwjXm8EaQY/aAh26txlWUZgUE+Bttxs2bjAgO5y+zPNLmTzWQFLvscB0kX/CFR+gD+Ibp7idKmFre1GXr2lO/E3MnErrwnH/EN5z4JP4sKI8cQleUzqs5X9gweis3TjgxggcYWWvOknX4teuq2VQRvXSs22NV72/nKW+TErPZYEGS5Q48X2RVsZZ6tEbwqz7oJHviO7JWcryjg1644Ff5qqFNjV5i3rpGNGb8a1i9Jpp0zcrsmpK32UmZzhEQS3YX7dJpMUkE0XWsnSg2QJl/eIPwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fqf73MavOZSklD5rJTa/mWMjxQPpLp3ZdllsJTx5kOg=;
 b=JMKjaVgQfulN66NJHryuoQe83XRhAkW9FdNTpC3JJiGORvQ3IAoG2EceeoI9wfPeEB03r/Satasa0/ppm5JfTIbHB7dxzIy9hHyZiGmwbW0EUT/7F4DVTtg+xuaBE/y6GTpFCnM6Gjs+038nC2pmACn92D3wj1Uu6MLK2n0Srro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:47 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 12/12] net: dpaa2-eth: add trace points on XSK events
Date:   Tue, 18 Oct 2022 17:19:01 +0300
Message-Id: <20221018141901.147965-13-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 49581f46-1c39-4ff5-1e25-08dab113cfb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RaSqeLpQkyXnAVbCv/0jq57YcWhDadxxN7XPM9GUTy8g4OPTt0JPZ/elFPuQA9dFLDc1wEu/N2FtWZngJmkg6qyNJMCl9PvHL8dISbMNF3NmpiHlNEkKPdZO58EcdblqFrQou4DoSf8R6gC5YV/7Y/PbAkpVZsl2ezFkqbLcGk9uDZ6OHe/5AItwF+40XnHnwg9+qLwxkeWCYMN24nqIvS6kVixCcJFPdE1xvUR9GMBJYZU4PzA09yUgn3+rO0zPWhi/D+9ZYjSfzgXDe0ni5xcVbYQcPBxbvmNznfYCtGLGenkNEU1gcdeTgmtfVaIjKNcsfRipsxuDjCtRl2jcHDRgf8XHDaniAWLNFv67u+60Ik00qhUXuR6P1Y7Kv3FFN5rUXVgfXDYCsdpIOlpt8HV/8JhPiReUlQLTnfwLBdYjQPyj/R/ZzIY+sX0vmpPJTalp6H4EET0cyzUiHDkJwN0iLq0S7zXIPi65Nun1BrNeyd8SFcRW45hkSH/d3BJYGA0aSlxzs2uNUXcBcrmXN3tjQgt07AWWw+S0VqzouVTzL0XqiCYwxyou77UK5MK0wuSHe3IM6RQ0IUnk9PFUVmunAkcfcrJ5f3l9T6L0F3OHkyrXlhdYRzHctDzs17ltZ0eyiqiNPD5RAiDVZi1Npv4sd5FiWGYh/D6J7CKGwYy8A3zeRugbK4POpO9/o36N/lzOU/lX33Gu26R8+T3vfDAXJsLDhsh53RUyXAdnCUE3nC2TaEGGTDEv5j/8c97lVN63wNDc6gR9lgjV4AzgtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+0fjkzNV3M2hZmHnen48lhJBJy/RRuhc1i7UOWb9tX8a5fNz9ZjvAP8Tog+6?=
 =?us-ascii?Q?t6sBvFq6vti5pbXKtrRD2EO9eCBKhH4LoyxvGeZFGIKmk6ObazOIbL0R8FvD?=
 =?us-ascii?Q?Bpftvdtzeem7Wrhtz/j/2fXoTiyjS8G4vkXaS7Xe2b335Zgrz9Sps4NTEGCK?=
 =?us-ascii?Q?67cqyWsL4jjCiTTKfHJb2qqLMIuveXL4yxwT+ovorOIki778ifeLvdX9kVh3?=
 =?us-ascii?Q?wFt6/D5tktBowONtEKJT0QyFvtMEP81QbX+jdL3Z1uI/lQogyLFW4EyERMlN?=
 =?us-ascii?Q?ueLIKKgDs1v20VYNFZ/mfl3hM7OirerVVcwDnGZwu7ObCZCj6pp6tbcOzogU?=
 =?us-ascii?Q?U3iaz38fKQjYYtEY1oRP+x5zFCIKitXOR+Zpv9c1PBAqNP1GXXnvWtHb/+88?=
 =?us-ascii?Q?54zRbhJhQe/YWeGrl8d8CXxDMNC9G0IxT1ZPpBGOT+qiDMRtRh3L4ge1qChr?=
 =?us-ascii?Q?5mJFCfVGj/Qhn4GH9894dBYj+j5xoVPVV612meCdkVN9i/hciW7VPOBpGgmh?=
 =?us-ascii?Q?QxROg2cdAt/GTIEbugDvH60hs865vydbqnWef0fT4XOWtLO9EM4x8PH4d7eh?=
 =?us-ascii?Q?zkA/8mHqr4BmQ4XXh57RXTiV+TvMmYCfOKdx+E8TE4tnJlk3cVxRD0ivVC+/?=
 =?us-ascii?Q?VsiotHKNvwf0OsAIqj1+7CRMFumwAI5oq5c4/4r/uhfAsOM3rcY/D4DMneLw?=
 =?us-ascii?Q?Z2Iy/hiX5uBUWkGNQRY2xnI0NP6bULleImRW8zzneRlcseRB0hODFd4J+CZP?=
 =?us-ascii?Q?qI2vD3B+M5Zc5zypy0chN5NLehXDBGogu41cGji3DTEe+d23awjplLiLUxWU?=
 =?us-ascii?Q?NG7fzatO3uLIdIDCAvD5EY90WuZvQoHrxYIHh23tEP71oUrs+uMvNWqR0mny?=
 =?us-ascii?Q?3drfCQXeFwXLv9S4UpP74l2AIlqhnn75ImWMDQrHb1bfYY1kAUXrgiPvvzJ7?=
 =?us-ascii?Q?TpAfC+Zhm89p2fgquZhDvfPW2K/Wy54R3DcEFU3pYN9GTNBorAPGBI+fRc89?=
 =?us-ascii?Q?XmxjOUpMjOGyvXgAZ4ugsObUl1nrnbRebCJz1xWH93lzexkFyczJTHrOoasY?=
 =?us-ascii?Q?FDm9dj50sNVM+vZwi+6vPWTVMCuCW9TLyOdj+sgobpWxIhMcn6pzeiYWBSmJ?=
 =?us-ascii?Q?yHGg67QuZb018HfhfMyLUbx2NtDQd4WSqsQIJjyTi1xZ3gX83WARd7rIGs2e?=
 =?us-ascii?Q?Mtbyd1wFy02mhBGblr0U2JKzUkGz3BEWtZLJFgbd0SgUWdDd79pdfmhjFQhv?=
 =?us-ascii?Q?PMboBP38rfB/0jhXxVlLWljauOOkR9dctH9NPGQpCujfM6KFxlKU5IYCdyKd?=
 =?us-ascii?Q?Ghzjl/88l4ysxqCHT2ZOrdDpco2HlexXgz0tXsPATAPAtQZyUy32lYspzPwH?=
 =?us-ascii?Q?+fn+9/Z+hxuKEuQipdygup/a0kvwlkbzk8AqqZCBhBYl3CACmHZmBEjFuQuT?=
 =?us-ascii?Q?NfslL8wfdnb8WlOcHWpa/FiKtu3GpAkvqqP09QY1PnBcbN0kSw1HuXEqIkzx?=
 =?us-ascii?Q?OqtYNK1o/rJH+nKwoPtmRlYhu3y41Ti5kuQjRpfZ5bimzUOEIiN8LxVur+TR?=
 =?us-ascii?Q?Yd0QMkshOQeHwSj/B5OzJVauEqfjkjFG+vPr7TyGHYe2o4CuebDxA0B3jZFZ?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49581f46-1c39-4ff5-1e25-08dab113cfb0
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:47.7543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJhhm2pf0/kYzzxeWauymM+pIgfgK90NPszrfhrChGY2Sp1lDVno7wgTOxgDxKKpGrI3SCY5y8M+S/PJA7x2lw==
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

Define the dpaa2_tx_xsk_fd and dpaa2_rx_xsk_fd trace events for the XSK
zero-copy Rx and Tx path.  Also, define the dpaa2_eth_buf as an event
class so that both dpaa2_eth_buf_seed and dpaa2_xsk_buf_seed traces can
derive from the same class.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Use xdp_buff->data_hard_start when tracing the BP seeding.
Changes in v3:
 - none


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
index 31eebeae5d95..281d7e3905c1 100644
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

