Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C43268B98A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBFKKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjBFKJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:41 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B9B1353F;
        Mon,  6 Feb 2023 02:09:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/qsobdgXHllO2jV+UFNy9zgGmkzgKy1QMuBBAGlrv2qFTncI2gK8fSvY0/kHg5a4p83LG+bZod6+P+vWaoIlIED0Oz0V+OhCZg/8nfv57YG8vcRvu7ei2sZc41/cKNOBQK8GzcuuvyLUWrMLxy1hqBRldR1nyZriWATDyJBuPC+EiwE3LyWIjjbX7PrCu251FZcbxWnPz+XQnM+Ia8XuY7eYoKYNFvFLpj5TMQCb2/aa8BWD1MlW8QV/QXlQQslcSWR1dtm5GM4qfco2EW8gXq2+EK77ezY16OGuWZFh18ihFn7fuDj7thKuDWvmrpl7/O/vNVptBthRaHul21XZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvFRLxAHIsvmhIumtEp1stztHsxSWFojF8TsKxtM7KM=;
 b=HH/DmL1iJSFDriMe2O87k3gjo95/YfQzPgAJhb6SYHBK5d7s0eOoeMK8+/F5uhOYy27D9/Hpg8ltUAGaiJHhsiLvh22ZhwYquPmXqSVq4j2YGZncXExLJHXbJ5lfbFLTt6pouHhmeXUoSLn/ThbYGYYYfTrNq6BNxZOTRY8LKw5FT23hE3/eVGAE4Y8iyPb9th0RVN/qZFFRq0GUKV0CJ9TBaavzBm5AU4/bR2lLSl0k5AoT6j8X9upuWt2OaW3KC+ASSGsQ4+tlvEPGidCPuo45EDN8jnsfd0NzjVCDFOEZvf7jUwyomUWoikhijGALZAg2PLsf4VKx0AbtB3Wnxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvFRLxAHIsvmhIumtEp1stztHsxSWFojF8TsKxtM7KM=;
 b=SNMx0+Jvh7kD3ustQKQSAnghxhA//u1qtnBU4kI54NI0l6Roncuo3PcMq5aLczBTQno3E3gCpAOqTPOCuSmW4iz19WIiQjnCgwII7uQFui9yyn3QC9U4qWqRFj2okFAusq95bwEF6CfLj824TLYkLVwtJzXtG1sZbAjoi2GMLso=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7735.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 10/11] net: enetc: add RX support for zero-copy XDP sockets
Date:   Mon,  6 Feb 2023 12:08:36 +0200
Message-Id: <20230206100837.451300-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: 51017d7d-b089-4ef0-2ce3-08db082a32ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BM3rm04AJAvk470TVyWRKRhgOYC3FVfARZo40xwK8tk/jyXfACSKJyxIU+ICil2O9aqn2wW5zGtHE5BtrB2EO2/o3Zs8SsGwOjMj3OfLrkAK6RA0BM2067azT6TXVN4uxvnx0ISptNHQG/LqSswnUStg4XCwxi/jGqrPIu7qGX/rvs2hNmP0J7UxDt11HhMhFSgvwQX2CBrR0iZKFUXz4gwbs1cDpWRkpN5Ae8wVODak0N9XStMT99Y46eS59oYLC2HQkaeApQSzK+LK+vKS/kTMvznfuOK5dqt3bfdfxOKZD7GVry0dqS41INdaOTv0GTq1fe0BZUsHtf95YuZm+oMDKcLWXSmy2YlNRqCeA4mi8NEzqlnG/YwRQjVqF7Z2cHBlxsXMvTbZfZZV8Aa7SmLoygWtGWagYOH8uPQwAdRgsT9ZvWMjNbg9hxZxJi2ZwVvsx2jtcfXGLyQiAu09AgTvxYqHB6qP56TbXg/6HgKspOE0XUyfVhaJ1GG2bBGwb645PXkwsfWo5DR8Pd6oZApBV3pSp7Sn2OSsgbN01w4mHnq0PJhIr0QqRV25Ks3wsFz0PFzzB4yET+wCRAVFGhurBl4oszttGc07T3+dRc1r3Ln+46RP4cMVnPyHhqa50MjS4rI/s1HK1c6DSVR2xEJmjenMG6yOivcTvBr12JHtxzs6sJy1NBgeXGywi7hb2/lBlECUtmkyxpbuuzWBzbtMMTEU2yUBazlv44ZHKYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(66946007)(66556008)(4326008)(6916009)(41300700001)(8936002)(8676002)(7416002)(5660300002)(54906003)(66476007)(2906002)(30864003)(44832011)(2616005)(83380400001)(478600001)(6486002)(186003)(52116002)(6512007)(26005)(316002)(6506007)(6666004)(1076003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WeHwi5J0kk4U9eQOT3Ip8APKGNPCfBMKqcSmbQUBmiI+fzVecZ/7KA+1gS8A?=
 =?us-ascii?Q?syCJfyv47Rpk0rk6XwKz/20yUq0mF1Jx47WfqbM4Ab3PZRlhIf9f2x3TMAYR?=
 =?us-ascii?Q?/Ozv6TRHm4glNqhiwovaOi2RfnCmo2rOmGGqGrILgQTOdEMheW/lP0zryX87?=
 =?us-ascii?Q?K8K+OY0YvANP7EUulPSOjZkCHE7NdT2TtEirhjuFCS79moRrmLZINcWl3Xvf?=
 =?us-ascii?Q?bWOOQJ6RO/k87549XHNX/dJzdFvSQ/R1YnMLTTLuc4Ez2858f6Kgm+NRJsOb?=
 =?us-ascii?Q?jvw3QnpLz3F2G5sNC58/zt5Pk5YVAbrC9/aoNgI/A21HZXzwpSvCuoZPxsWS?=
 =?us-ascii?Q?4WaLDeSzd1gQRKKCL/d1uNDSvZzTVjo+1JPMlImkwRFT7pSRqoKYGQA5WLd9?=
 =?us-ascii?Q?LZnqwQqbm62EhofUz/ZFmwO33gI7sFzIIsptC3ziZ0sDciS03qkfBLe3LXOi?=
 =?us-ascii?Q?7M81NH1GprQTN6iPv51hhT/LwHi/aOFSPaeqV5MgzJWY2nTFlceYrWT3K7Q2?=
 =?us-ascii?Q?iJg+j2NhzIlZj+jNsCw9H3Huz7K+DR2mSumVZ1erFk5/ztLELqM6BbEwpTh1?=
 =?us-ascii?Q?CNFNzkqu8+DZRUxZ23592LD9kQj5DzvKgKtoHBr7NjcSUVhZX7E5FKTnwkSQ?=
 =?us-ascii?Q?evVFj3jvEfc/hminEkp0LrxJs49J7hZvEaxLQaLnRS/TEjMWbpUWkqivhCIh?=
 =?us-ascii?Q?rOF5t0DIr48HCpRHtoH41s6dLv0+c2cdj685MRhfzdT8HY9OHx31mIl03iSm?=
 =?us-ascii?Q?g/RYAVmcogZQgZxAIxq+97ZH9ZSsNwYOOm/zvmtxGZtIs4Og5hlTAzecNsSt?=
 =?us-ascii?Q?DKDpXvQT6ayuIn4WGpHokayOxatDQ04f71gY9yWoYjtknU3im2rXqA7y5Bj0?=
 =?us-ascii?Q?ARA4S9M9M8WEw771xh3WYS0lgmR35ZwLxzxmTPQi0mlB74Q8Dzhxywrb/28E?=
 =?us-ascii?Q?Yhv5WOdhMFm+LprufNxV8XY46C7VbnY/9HGYHkoIV5VH+A3VPTF4ij9fuG12?=
 =?us-ascii?Q?7bCmrOldpBKudIoUeRQzexXsUvdxv+3QVU+hYEY4feG0DHioWgXbk6g+WEOv?=
 =?us-ascii?Q?+giu3+PYjdScuTWHl7wlPvZQpIgCPDZJ9aEh6z9ha1Uof8GDdFO8xQL0c0D3?=
 =?us-ascii?Q?/25U7fQsTthgcvJKTaipmjV6W6pDcd0YqlVSET3EDHCKJ8KMxPbEaeeOw6y5?=
 =?us-ascii?Q?LiBCv/oQWH7XVf/BBO3j5dgmFU05XUHNhc911KWtMhmkstQ24umx77W3hm5W?=
 =?us-ascii?Q?zqxoEX6/y6WtxKMcdemcJXJPdAEFZejAjd81rA8SCq6F6hf3V0GctzMUfJzw?=
 =?us-ascii?Q?bTkniPvh/v0pFnPXqMRj3yg66ln7W1YsLFMv82rJxN74XgxZaWtm4E3C6aV8?=
 =?us-ascii?Q?PSpZM9JnbmkNaAhEyFsZYT4JnWN5Kq8Mm0y73GTKoziqLe5UOdzW9VyyPceI?=
 =?us-ascii?Q?hnFSNuo79VR4uKyzhtXL75/cS4ONOWBxU1gSPMnxgNTCU5sKJUf0DJVEhGqA?=
 =?us-ascii?Q?mdi2nUcD5trPHUCSp8PZXsG4DYtrwQdttFGxgoIrOV1ojeWTjy7rycTGTfw2?=
 =?us-ascii?Q?vC8vxXPLT1rGkleT+QVNS4XC1ge+a5oWkrG3EfmQ7gYw0GFwRWDy7Y8e0GGf?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51017d7d-b089-4ef0-2ce3-08db082a32ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:13.9109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQ3wOGn7O/d870LdfO7rI/InnZUXucBAiduW9RGPnXoLZW+aFrks+KNjaCkKeIgimc7ULImOFOrRBtqXC6QmKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for filling an RX ring with buffers coming from an XSK umem.
Although enetc has up to 8 RX rings, we still use one of the 2 per-CPU
RX rings for XSK.

To set up an XSK pool on one of the RX queues, we use the
reconfiguration procedure which temporarily stops the rings.

Since the RX procedure in the NAPI poll function is completely different
(both the API for creating an xdp_buff, as well as refilling the ring
with memory from user space), create a separate enetc_clean_rx_ring_xsk()
function which gets called when we have both an XSK pool and an XDK
program on this RX queue.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 377 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
 3 files changed, 373 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index dee432cacf85..3990c006c011 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -10,6 +10,7 @@
 #include <net/ip6_checksum.h>
 #include <net/pkt_sched.h>
 #include <net/tso.h>
+#include <net/xdp_sock_drv.h>
 
 u32 enetc_port_mac_rd(struct enetc_si *si, u32 reg)
 {
@@ -103,6 +104,9 @@ static void enetc_free_rx_swbd(struct enetc_bdr *rx_ring,
 			       rx_swbd->dir);
 		__free_page(rx_swbd->page);
 		rx_swbd->page = NULL;
+	} else if (rx_swbd->xsk_buff) {
+		xsk_buff_free(rx_swbd->xsk_buff);
+		rx_swbd->xsk_buff = NULL;
 	}
 }
 
@@ -979,6 +983,44 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 	return j;
 }
 
+static int enetc_refill_rx_ring_xsk(struct enetc_bdr *rx_ring, int buff_cnt)
+{
+	struct xsk_buff_pool *pool = rx_ring->xdp.xsk_pool;
+	struct enetc_rx_swbd *rx_swbd;
+	struct xdp_buff *xsk_buff;
+	union enetc_rx_bd *rxbd;
+	int i, j;
+
+	i = rx_ring->next_to_use;
+	rxbd = enetc_rxbd(rx_ring, i);
+
+	for (j = 0; j < buff_cnt; j++) {
+		xsk_buff = xsk_buff_alloc(pool); // TODO use _batch?
+		if (!xsk_buff)
+			break;
+
+		rx_swbd = &rx_ring->rx_swbd[i];
+		rx_swbd->xsk_buff = xsk_buff;
+		rx_swbd->dma = xsk_buff_xdp_get_dma(xsk_buff);
+
+		/* update RxBD */
+		rxbd->w.addr = cpu_to_le64(rx_swbd->dma);
+		/* clear 'R" as well */
+		rxbd->r.lstatus = 0;
+
+		enetc_rxbd_next(rx_ring, &rxbd, &i);
+	}
+
+	if (likely(j)) {
+		rx_ring->next_to_use = i;
+
+		/* update ENETC's consumer index */
+		enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
+	}
+
+	return j;
+}
+
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static void enetc_get_rx_tstamp(struct net_device *ndev,
 				union enetc_rx_bd *rxbd,
@@ -1128,6 +1170,18 @@ static void enetc_add_rx_buff_to_skb(struct enetc_bdr *rx_ring, int i,
 	enetc_flip_rx_buff(rx_ring, rx_swbd);
 }
 
+static void enetc_put_rx_swbd(struct enetc_bdr *rx_ring, int i)
+{
+	struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[i];
+
+	if (rx_swbd->xsk_buff) {
+		xsk_buff_free(rx_swbd->xsk_buff);
+		rx_swbd->xsk_buff = NULL;
+	} else {
+		enetc_put_rx_buff(rx_ring, rx_swbd);
+	}
+}
+
 static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 					      u32 bd_status,
 					      union enetc_rx_bd **rxbd, int *i,
@@ -1136,7 +1190,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 	if (likely(!(bd_status & ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))))
 		return false;
 
-	enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
+	enetc_put_rx_swbd(rx_ring, *i);
 	(*buffs_missing)++;
 	enetc_rxbd_next(rx_ring, rxbd, i);
 
@@ -1144,7 +1198,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 		dma_rmb();
 		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
 
-		enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
+		enetc_put_rx_swbd(rx_ring, *i);
 		(*buffs_missing)++;
 		enetc_rxbd_next(rx_ring, rxbd, i);
 	}
@@ -1484,6 +1538,43 @@ static void enetc_build_xdp_buff(struct enetc_bdr *rx_ring, u32 bd_status,
 	}
 }
 
+static struct xdp_buff *enetc_build_xsk_buff(struct xsk_buff_pool *pool,
+					     struct enetc_bdr *rx_ring,
+					     u32 bd_status,
+					     union enetc_rx_bd **rxbd, int *i,
+					     int *buffs_missing, int *rx_byte_cnt)
+{
+	struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[*i];
+	u16 size = le16_to_cpu((*rxbd)->r.buf_len);
+	struct xdp_buff *xsk_buff;
+
+	/* Multi-buffer frames are not supported in XSK mode */
+	if (unlikely(!(bd_status & ENETC_RXBD_LSTATUS_F))) {
+		while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
+			enetc_put_rx_swbd(rx_ring, *i);
+
+			(*buffs_missing)++;
+			enetc_rxbd_next(rx_ring, rxbd, i);
+			dma_rmb();
+			bd_status = le32_to_cpu((*rxbd)->r.lstatus);
+		}
+
+		return NULL;
+	}
+
+	xsk_buff = rx_swbd->xsk_buff;
+	xsk_buff_set_size(xsk_buff, size);
+	xsk_buff_dma_sync_for_cpu(xsk_buff, pool);
+
+	rx_swbd->xsk_buff = NULL;
+
+	(*buffs_missing)++;
+	(*rx_byte_cnt) += size;
+	enetc_rxbd_next(rx_ring, rxbd, i);
+
+	return xsk_buff;
+}
+
 /* Convert RX buffer descriptors to TX buffer descriptors. These will be
  * recycled back into the RX ring in enetc_clean_tx_ring.
  */
@@ -1659,11 +1750,136 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 	return rx_frm_cnt;
 }
 
+static void enetc_xsk_buff_to_skb(struct xdp_buff *xsk_buff,
+				  struct enetc_bdr *rx_ring,
+				  union enetc_rx_bd *rxbd,
+				  struct napi_struct *napi)
+{
+	size_t len = xdp_get_buff_len(xsk_buff);
+	struct sk_buff *skb;
+
+	skb = napi_alloc_skb(napi, len);
+	if (unlikely(!skb)) {
+		rx_ring->stats.rx_alloc_errs++;
+		goto out;
+	}
+
+	skb_put_data(skb, xsk_buff->data, len);
+
+	enetc_get_offloads(rx_ring, rxbd, skb);
+
+	skb_record_rx_queue(skb, rx_ring->index);
+	skb->protocol = eth_type_trans(skb, rx_ring->ndev);
+
+	rx_ring->stats.packets += skb->len;
+	rx_ring->stats.bytes++;
+
+	napi_gro_receive(napi, skb);
+out:
+	xsk_buff_free(xsk_buff);
+}
+
+static int enetc_clean_rx_ring_xsk(struct enetc_bdr *rx_ring,
+				   struct napi_struct *napi, int work_limit,
+				   struct bpf_prog *prog,
+				   struct xsk_buff_pool *pool)
+{
+	struct net_device *ndev = rx_ring->ndev;
+	union enetc_rx_bd *rxbd, *orig_rxbd;
+	int rx_frm_cnt = 0, rx_byte_cnt = 0;
+	int xdp_redirect_frm_cnt = 0;
+	struct xdp_buff *xsk_buff;
+	int buffs_missing, err, i;
+	bool wakeup_xsk = false;
+	u32 bd_status, xdp_act;
+
+	buffs_missing = enetc_bd_unused(rx_ring);
+	/* next descriptor to process */
+	i = rx_ring->next_to_clean;
+
+	while (likely(rx_frm_cnt < work_limit)) {
+		if (buffs_missing >= ENETC_RXBD_BUNDLE) {
+			buffs_missing -= enetc_refill_rx_ring_xsk(rx_ring,
+								  buffs_missing);
+			wakeup_xsk |= (buffs_missing != 0);
+		}
+
+		rxbd = enetc_rxbd(rx_ring, i);
+		bd_status = le32_to_cpu(rxbd->r.lstatus);
+		if (!bd_status)
+			break;
+
+		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
+		dma_rmb(); /* for reading other rxbd fields */
+
+		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
+						      &rxbd, &i,
+						      &buffs_missing))
+			continue;
+
+		orig_rxbd = rxbd;
+
+		xsk_buff = enetc_build_xsk_buff(pool, rx_ring, bd_status,
+						&rxbd, &i, &buffs_missing,
+						&rx_byte_cnt);
+		if (!xsk_buff)
+			continue;
+
+		xdp_act = bpf_prog_run_xdp(prog, xsk_buff);
+		switch (xdp_act) {
+		default:
+			bpf_warn_invalid_xdp_action(ndev, prog, xdp_act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(ndev, prog, xdp_act);
+			fallthrough;
+		case XDP_DROP:
+			xsk_buff_free(xsk_buff);
+			break;
+		case XDP_PASS:
+			enetc_xsk_buff_to_skb(xsk_buff, rx_ring, orig_rxbd,
+					      napi);
+			break;
+		case XDP_REDIRECT:
+			err = xdp_do_redirect(ndev, xsk_buff, prog);
+			if (unlikely(err)) {
+				if (err == -ENOBUFS)
+					wakeup_xsk = true;
+				xsk_buff_free(xsk_buff);
+				rx_ring->stats.xdp_redirect_failures++;
+			} else {
+				xdp_redirect_frm_cnt++;
+				rx_ring->stats.xdp_redirect++;
+			}
+		}
+
+		rx_frm_cnt++;
+	}
+
+	rx_ring->next_to_clean = i;
+
+	rx_ring->stats.packets += rx_frm_cnt;
+	rx_ring->stats.bytes += rx_byte_cnt;
+
+	if (xdp_redirect_frm_cnt)
+		xdp_do_flush_map();
+
+	if (xsk_uses_need_wakeup(pool)) {
+		if (wakeup_xsk)
+			xsk_set_rx_need_wakeup(pool);
+		else
+			xsk_clear_rx_need_wakeup(pool);
+	}
+
+	return rx_frm_cnt;
+}
+
 static int enetc_poll(struct napi_struct *napi, int budget)
 {
 	struct enetc_int_vector
 		*v = container_of(napi, struct enetc_int_vector, napi);
 	struct enetc_bdr *rx_ring = &v->rx_ring;
+	struct xsk_buff_pool *pool;
 	struct bpf_prog *prog;
 	bool complete = true;
 	int work_done;
@@ -1676,10 +1892,15 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 			complete = false;
 
 	prog = rx_ring->xdp.prog;
-	if (prog)
+	pool = rx_ring->xdp.xsk_pool;
+	if (prog && pool)
+		work_done = enetc_clean_rx_ring_xsk(rx_ring, napi, budget, prog,
+						    pool);
+	else if (prog)
 		work_done = enetc_clean_rx_ring_xdp(rx_ring, napi, budget, prog);
 	else
 		work_done = enetc_clean_rx_ring(rx_ring, napi, budget);
+
 	if (work_done == budget)
 		complete = false;
 	if (work_done)
@@ -2168,7 +2389,16 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring,
 	rx_ring->next_to_alloc = 0;
 
 	enetc_lock_mdio();
-	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
+	/* The XSK buffer pool and the BPF program are set up through different
+	 * syscalls. From the moment the pool has been DMA mapped and until the
+	 * XDP program is attached, we still need to use normal RX buffers,
+	 * because we still use the normal NAPI poll routine. Only use buffers
+	 * from the XSK pool when both conditions are fulfilled.
+	 */
+	if (rx_ring->xdp.prog && rx_ring->xdp.xsk_pool)
+		enetc_refill_rx_ring_xsk(rx_ring, enetc_bd_unused(rx_ring));
+	else
+		enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
 	enetc_unlock_mdio();
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
@@ -2454,18 +2684,27 @@ static int enetc_xdp_rxq_mem_model_register(struct enetc_ndev_priv *priv,
 					    int rxq)
 {
 	struct enetc_bdr *rx_ring = priv->rx_ring[rxq];
+	struct xsk_buff_pool *pool;
+	enum xdp_mem_type type;
 	int err;
 
 	err = xdp_rxq_info_reg(&rx_ring->xdp.rxq, priv->ndev, rxq, 0);
 	if (err)
 		return err;
 
-	err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp.rxq,
-					 MEM_TYPE_PAGE_SHARED, NULL);
-	if (err)
+	pool = rx_ring->xdp.xsk_pool;
+	type = !!pool ? MEM_TYPE_XSK_BUFF_POOL : MEM_TYPE_PAGE_SHARED;
+
+	err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp.rxq, type, NULL);
+	if (err) {
 		xdp_rxq_info_unreg(&rx_ring->xdp.rxq);
+		return err;
+	}
 
-	return err;
+	if (pool)
+		xsk_pool_set_rxq_info(pool, &rx_ring->xdp.rxq);
+
+	return 0;
 }
 
 static void enetc_xdp_rxq_mem_model_unregister(struct enetc_ndev_priv *priv,
@@ -2768,6 +3007,125 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 	return err;
 }
 
+struct enetc_xsk_reconfig_ctx {
+	struct enetc_bdr *rx_ring;
+	struct xsk_buff_pool *pool;
+};
+
+static int enetc_enable_xsk_cb(struct enetc_ndev_priv *priv, void *ctx)
+{
+	struct enetc_xsk_reconfig_ctx *data = ctx;
+	struct enetc_bdr *rx_ring = data->rx_ring;
+	struct xsk_buff_pool *pool = data->pool;
+	int err;
+
+	err = xsk_pool_dma_map(pool, priv->dev, 0);
+	if (err)
+		return err;
+
+	rx_ring->xdp.xsk_pool = pool;
+
+	return 0;
+}
+
+static int enetc_disable_xsk_cb(struct enetc_ndev_priv *priv, void *ctx)
+{
+	struct enetc_xsk_reconfig_ctx *data = ctx;
+	struct enetc_bdr *rx_ring = data->rx_ring;
+	struct xsk_buff_pool *pool = data->pool;
+
+	rx_ring->xdp.xsk_pool = NULL;
+	xsk_pool_dma_unmap(pool, 0);
+
+	return 0;
+}
+
+static int enetc_enable_xsk_pool(struct net_device *ndev,
+				 struct xsk_buff_pool *pool, u16 queue_id)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_xsk_reconfig_ctx ctx;
+	struct enetc_int_vector *v;
+	struct enetc_bdr *rx_ring;
+	bool extended;
+
+	if (queue_id >= priv->bdr_int_num) {
+		netdev_err(ndev, "QID %d exceeds the %d channels available\n",
+			   queue_id, priv->bdr_int_num);
+		return -ERANGE;
+	}
+
+	v = priv->int_vector[queue_id];
+	rx_ring = &v->rx_ring;
+	if (rx_ring->xdp.xsk_pool) {
+		netdev_err(ndev, "QID %d already has an XSK pool attached\n",
+			   rx_ring->index);
+		return -EBUSY;
+	}
+
+	/* Ensure enetc_setup_xdp_prog() won't be called before
+	 * enetc_setup_xsk_pool(), because enetc_xdp_rxq_mem_model_register()
+	 * depends on call ordering.
+	 */
+	if (rx_ring->xdp.prog) {
+		netdev_err(ndev,
+			   "Cannot use XSK if there is an XDP program already attached\n");
+		return -EINVAL;
+	}
+
+	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
+	ctx.rx_ring = rx_ring;
+	ctx.pool = pool;
+
+	return enetc_reconfigure(priv, extended, enetc_enable_xsk_cb, &ctx);
+}
+
+static int enetc_disable_xsk_pool(struct net_device *ndev, u16 queue_id)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_xsk_reconfig_ctx ctx;
+	struct enetc_int_vector *v;
+	struct xsk_buff_pool *pool;
+	struct enetc_bdr *rx_ring;
+	bool extended;
+
+	if (queue_id >= priv->bdr_int_num) {
+		netdev_err(ndev, "QID %d exceeds the %d channels available\n",
+			   queue_id, priv->bdr_int_num);
+		return -ERANGE;
+	}
+
+	v = priv->int_vector[queue_id];
+	rx_ring = &v->rx_ring;
+
+	pool = rx_ring->xdp.xsk_pool;
+	if (!pool) {
+		netdev_err(ndev, "QID %d does not have an XSK pool attached\n",
+			   rx_ring->index);
+		return -ENOENT;
+	}
+
+	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
+	ctx.rx_ring = rx_ring;
+	ctx.pool = pool;
+
+	return enetc_reconfigure(priv, extended, enetc_disable_xsk_cb, &ctx);
+}
+
+static int enetc_setup_xsk_pool(struct net_device *ndev,
+				struct xsk_buff_pool *pool,
+				u16 queue_id)
+{
+	return pool ? enetc_enable_xsk_pool(ndev, pool, queue_id) :
+		      enetc_disable_xsk_pool(ndev, queue_id);
+}
+
+int enetc_xsk_wakeup(struct net_device *ndev, u32 queue_id, u32 flags)
+{
+	/* xp_assign_dev() wants this; nothing needed for RX */
+	return 0;
+}
+
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
@@ -2798,6 +3156,9 @@ int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 	switch (bpf->command) {
 	case XDP_SETUP_PROG:
 		return enetc_setup_xdp_prog(ndev, bpf->prog, bpf->extack);
+	case XDP_SETUP_XSK_POOL:
+		return enetc_setup_xsk_pool(ndev, bpf->xsk.pool,
+					    bpf->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 704aa1f9dfa3..e1a746e37c9a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -48,6 +48,7 @@ struct enetc_tx_swbd {
 	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - XDP_PACKET_HEADROOM)
 
 struct enetc_rx_swbd {
+	struct xdp_buff *xsk_buff;
 	struct page *page;
 	dma_addr_t dma;
 	enum dma_data_direction dir;
@@ -77,6 +78,7 @@ struct enetc_ring_stats {
 
 struct enetc_xdp_data {
 	struct xdp_rxq_info rxq;
+	struct xsk_buff_pool *xsk_pool;
 	struct bpf_prog *prog;
 	int xdp_tx_in_flight;
 };
@@ -424,6 +426,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
 int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
+int enetc_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags);
 
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7facc7d5261e..1a95d213683b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -773,6 +773,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_setup_tc		= enetc_pf_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
+	.ndo_xsk_wakeup		= enetc_xsk_wakeup,
 };
 
 static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.34.1

