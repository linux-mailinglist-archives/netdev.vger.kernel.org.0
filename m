Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7190E4DD7C9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiCRKPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiCRKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E636103BA0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5xMSsEajLfAlzwD1Xh6DwpaO757UI/FmrFOeW3oUSBOYtxTXE6D/6BK+bZkmB0mlM9fmRlMqRRDtLnmqGHUaWz/0+o5WuVJrsnVWHqUgl4YY+GOKGbDSoWda9oDlT4C8HZAABjccKeyGM0Lkr3EtpuJd1/0TMz7sQXOAwZekInk/ml9qugk9TvC5sABznw+KHK9CWBnAfF/alxeQpgMdoMm8V4Mmk3pHz7pEPXr5KcLFaIp3suc0GidPNKIti2aYdTuJH9f3XBVUoa4zpr/ylZMgH8UrCZ6WBSsYjM3DdIb7R1N+suxJw+WrvEQgpDftXH0hPdYKMod0IpXSrG5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gjc5/bdeIZjZw09d0RrUP1ApFLQe0T/+SbkHZNEndRc=;
 b=UHLHd2UXRrDn1R+bc2j1XT7WbYPZ6HBKX6P0OcofRpzbwOlKvjUaADdV1FwjJ6CHnEz1kAd7ibPi8OlyfyK0KVkYRGdwL9ehP8AzPGfj7d3QebVkmI88pir47ApKlN4jCti7rEBcIY83ZHRaGdqFyi8OCS84zXFSPJl/Y8qdkkV42/sI/Do4K9oACh3AXStDmHCazBm09/kVXtnhox7cdvelk8tXv0At2HrlVDtJeiVWR5JLoG0bhUwH4llx1b3/v1kpcOuMwXkx3U3DHibiBEEYEI/WOqoaC1npTkEi+JXV72Bq6yOFsH2iyB0PE9ou3p440mDgmyBssGyW8UyNRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gjc5/bdeIZjZw09d0RrUP1ApFLQe0T/+SbkHZNEndRc=;
 b=siwE/m0tW0ONPQZICRZyROaMYAt7jfMWmt7+R82cJi3IsS142l+obvZ3KdAbV0uRH3LfV4NhdM2wQH8JiU8FVtdCv1SLLeRcJM/vkudz66Av/D5NijrWjrlH8gOPjRrL6+na0BEobuol5+X+HTl5kFX48qbL9iVfIocRqvhjhzU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3139.namprd13.prod.outlook.com (2603:10b6:405:7f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.8; Fri, 18 Mar
 2022 10:13:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:45 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for NFDK
Date:   Fri, 18 Mar 2022 11:13:02 +0100
Message-Id: <20220318101302.113419-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c85fec-1a11-4be2-e0f9-08da08c7fc77
X-MS-TrafficTypeDiagnostic: BN6PR13MB3139:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB31396242492FBD8B31B775A8E8139@BN6PR13MB3139.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjyntII0o/ztJCwOInw1pI6lCoCMw/VcPd+3igSp9QekTIw6vkE9O7vgB70AvsbwF1HSv+Om3HXWQPvbMJArR8opCwkbpN9hAMVIrJJB9Df4EaWx8O6klaSesMjE8AjguCMaGyjtyuUmr76kM+nwHhr5WUi6BtydNYWy40VOA7MtFRkp78t4aXlpHvqqCi2T0vncfu2kaIOMJ2tOEIvxoFQoUSyTntivTrcmwc54QAfrrclFGulXrhLEjiGynJJPXj+dfI8v/YdFl6kmSvhKzb0JVRZ4K1d5laAYZje2UQfSZeQpt29kFpFp7Gvldnvph14AiGDBWw8RmcPz47eRhA+WXqeMKyOK+lMcYohAS9bpGUilrUU7GM730g5lNv6MhZZFk/4lZd6tWn6BIUTEApIY0X2YAO3V7MQRiQx2gC36uYgt4PG5y38ML3+liBDSO7qvt5rEOTvvzyJok54iSHngEyVYiUHss6W5GKmQZn31qSlyJPCF7D9LPwBUYWockmC4luoNi4TTFAfLVnMjZP24ZvoGlcI8SvOLZGNQKi1RBP5hmQDX0o1foqlx+kQTKPNPrO9SivdKaMY2yBjd9jO806e/1a3Dt/F1UuPluUtsNx04FV7v88gjlZ7hwkjgF0ijipomeTexpRicMBFS1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(39830400003)(396003)(366004)(376002)(66946007)(66556008)(36756003)(8676002)(8936002)(66476007)(5660300002)(4326008)(44832011)(6486002)(508600001)(316002)(2906002)(110136005)(38100700002)(2616005)(83380400001)(107886003)(1076003)(186003)(86362001)(6506007)(6512007)(6666004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Km4rZPXZivsMLe+flJGhvrnu6tMMM7SoyftiWG7ikFFwRgmjLCz8MvWokYbv?=
 =?us-ascii?Q?pcskPENKOUQWaLazBybbaW7Wt602eZwWSu8bOVGv0+GNNZle608uRQzgWfzT?=
 =?us-ascii?Q?cHIt1DDzgTimbbrRIevWtkxW7ZhGMEJ2+BvNdI/rwlcAtSUoYM1XXSGQEDz2?=
 =?us-ascii?Q?oJYA+rbwR3Rarot8jfnBdnicaYDOeLLA4Apo6VKe3IAqKfGNymTgqS5xwbdP?=
 =?us-ascii?Q?or3du5RDA0Ox4jTbTd9APYd3PJ5c0s8uv1eTwLISEuHFhsRyg5t0EAZalSgm?=
 =?us-ascii?Q?3jZPM2EMxjD3z7deRicTIuDkeXmgtfOwoLPA7m/Of0c1kxh+fGA5DghlDSWL?=
 =?us-ascii?Q?9Sx+01MjQi2EHBtVGOlrSOLgGHlRKKfsufqhf6K+MeyWiOvelp5cZVxRtH2s?=
 =?us-ascii?Q?ywqxyUAgnuZwq2+BClftNS5EDhHfjaYdDyumQhDTqlmzpzG8F+ZGHpxgc+Bp?=
 =?us-ascii?Q?253BYTPZDwucdrbQNkWRXRaeYufwAk1mXOvEvvNR9MOOkr5izbZCy1IE2d1m?=
 =?us-ascii?Q?SE5BsCxbFA4eosyRBxXecm0xtBCe1/vETArEqsIJWlQ72fGVPu7m62WIUt8b?=
 =?us-ascii?Q?0oTGhjSeprou53atoKx1OjXizR36Kml9CNK7ifYUFdOG7j+BjfNBNn8ev4zh?=
 =?us-ascii?Q?yRr8z4reCCVxMrZFueNO1C0r0Gd7eS6867RT0GTswhmsSBPn3IN8LVo8HGve?=
 =?us-ascii?Q?VzzeIWFxrwElPzFADnEyO+9f4ExTUKGxF0mZYg0KSBgVpTtxHjlb8Ndh/4mL?=
 =?us-ascii?Q?BYncocHxXSJBuXHEVD9/Mo/qvinGrazZKjsqxBrb5pQV4Fequ4q9rnrShJd7?=
 =?us-ascii?Q?bGu60+bntuoxndUcLM+jql2PK3v9FM0nb2wpQi3sUqBINbJKogHQb/gAtz6S?=
 =?us-ascii?Q?k5PQ98isEyTc8kOdp8bEdvBX4Fm9saPXmRU79rRcPewoilv7EQqFQ9xdyhS6?=
 =?us-ascii?Q?EsvjgGbfgpnbCGDaIJFg/fFl5TYMVyin9bhxAXSAD9ZGkco9k8NEjD7R9qWn?=
 =?us-ascii?Q?ZA+EhdRjNSqSy7q2AklUpNcPL2j1HADfil+bR14o4iqW5WdIw4yUn6igRNm9?=
 =?us-ascii?Q?ZwEQ0c99fRiO3uGUtkkwP1OxMaotoF1ChUTuwkv5KqgxNtH/+CtSGtcv5m++?=
 =?us-ascii?Q?on+EmbPsznbwDD7QuWONUPL00Ree0wx/gw96QFl0ksuZ1Nn0N/79IkMVjaxk?=
 =?us-ascii?Q?LFYqxA4a1xYUnq1jhG9uJVYPhzTpc1/ldAtwsKL5k1QLlG93wHmaPduLYUCu?=
 =?us-ascii?Q?V89TjB0xUMPIifO4GYhsnBclI+hH2iGNXtA9DoqzoyJcK3Nhjg7ROqb10QcK?=
 =?us-ascii?Q?MVQDNJPkZg4sdlsHYVjRoRCtptbS3e5TOp0Ci7oDphO9DADwl02CEqdBS+O0?=
 =?us-ascii?Q?roCfCwnkicozq0chcoOZlLVJTGBJzpyIMxjumZq8UpujKznmKBD6+pS6IMyd?=
 =?us-ascii?Q?JQ/+uIIpid19Qw4l3/ek8RrxnLpcSPL4q1OXllZhcneYTLUp5OMoYEQBlBEX?=
 =?us-ascii?Q?3MEfTOA+rlT9Oymv4timWf5355guECrEIiO0QtOxHiuBEvG3+XTLQyPcpQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c85fec-1a11-4be2-e0f9-08da08c7fc77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:45.4981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZskXXC/5ifTc7ZVRrGvlZOI5RapnuXw4Kv6EjMB8k4a6kJFG06spt577rMjsAWUeXruTWuxeXl09yZ9Vcn38iuwtS4RlBGw5gK4rmHGTdbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Due to the different definition of txbuf in NFDK comparing to NFD3,
there're no pre-allocated txbufs for xdp use in NFDK's implementation,
we just use the existed rxbuf and recycle it when xdp tx is completed.

For each packet to transmit in xdp path, we cannot use more than
`NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
and another is for dma address, so currently the amount of transmitted
bytes is not accumulated. Also we borrow the last bit of virtual addr
to indicate a new transmitted packet due to address's alignment
attribution.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 196 +++++++++++++++++-
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  16 ++
 2 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index d107458d1fd3..5a9310f770af 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -541,11 +541,6 @@ static void nfp_nfdk_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
 }
 
-static bool nfp_nfdk_xdp_complete(struct nfp_net_tx_ring *tx_ring)
-{
-	return true;
-}
-
 /* Receive processing */
 static void *
 nfp_nfdk_napi_alloc_one(struct nfp_net_dp *dp, dma_addr_t *dma_addr)
@@ -791,6 +786,185 @@ nfp_nfdk_rx_drop(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 		dev_kfree_skb_any(skb);
 }
 
+static bool nfp_nfdk_xdp_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct nfp_net_rx_ring *rx_ring;
+	u32 qcp_rd_p, done = 0;
+	bool done_all;
+	int todo;
+
+	/* Work out how many descriptors have been transmitted */
+	qcp_rd_p = nfp_net_read_tx_cmpl(tx_ring, dp);
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return true;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
+	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
+
+	rx_ring = r_vec->rx_ring;
+	while (todo > 0) {
+		int idx = D_IDX(tx_ring, tx_ring->rd_p + done);
+		struct nfp_nfdk_tx_buf *txbuf;
+		unsigned int step = 1;
+
+		txbuf = &tx_ring->ktxbufs[idx];
+		if (!txbuf->raw)
+			goto next;
+
+		if (NFDK_TX_BUF_INFO(txbuf->raw) != NFDK_TX_BUF_INFO_SOP) {
+			WARN_ONCE(1, "Unexpected TX buffer in XDP TX ring\n");
+			goto next;
+		}
+
+		/* Two successive txbufs are used to stash virtual and dma
+		 * address respectively, recycle and clean them here.
+		 */
+		nfp_nfdk_rx_give_one(dp, rx_ring,
+				     (void *)NFDK_TX_BUF_PTR(txbuf[0].raw),
+				     txbuf[1].dma_addr);
+		txbuf[0].raw = 0;
+		txbuf[1].raw = 0;
+		step = 2;
+
+		u64_stats_update_begin(&r_vec->tx_sync);
+		/* Note: tx_bytes not accumulated. */
+		r_vec->tx_pkts++;
+		u64_stats_update_end(&r_vec->tx_sync);
+next:
+		todo -= step;
+		done += step;
+	}
+
+	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + done);
+	tx_ring->rd_p += done;
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+
+	return done_all;
+}
+
+static bool
+nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
+		    struct nfp_net_tx_ring *tx_ring,
+		    struct nfp_net_rx_buf *rxbuf, unsigned int dma_off,
+		    unsigned int pkt_len, bool *completed)
+{
+	unsigned int dma_map_sz = dp->fl_bufsz - NFP_NET_RX_BUF_NON_DATA;
+	unsigned int dma_len, type, cnt, dlen_type, tmp_dlen;
+	struct nfp_nfdk_tx_buf *txbuf;
+	struct nfp_nfdk_tx_desc *txd;
+	unsigned int n_descs;
+	dma_addr_t dma_addr;
+	int wr_idx;
+
+	/* Reject if xdp_adjust_tail grow packet beyond DMA area */
+	if (pkt_len + dma_off > dma_map_sz)
+		return false;
+
+	/* Make sure there's still at least one block available after
+	 * aligning to block boundary, so that the txds used below
+	 * won't wrap around the tx_ring.
+	 */
+	if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+		if (!*completed) {
+			nfp_nfdk_xdp_complete(tx_ring);
+			*completed = true;
+		}
+
+		if (unlikely(nfp_net_tx_full(tx_ring, NFDK_TX_DESC_STOP_CNT))) {
+			nfp_nfdk_rx_drop(dp, rx_ring->r_vec, rx_ring, rxbuf,
+					 NULL);
+			return false;
+		}
+	}
+
+	/* Check if cross block boundary */
+	n_descs = nfp_nfdk_headlen_to_segs(pkt_len);
+	if ((round_down(tx_ring->wr_p, NFDK_TX_DESC_BLOCK_CNT) !=
+	     round_down(tx_ring->wr_p + n_descs, NFDK_TX_DESC_BLOCK_CNT)) ||
+	    ((u32)tx_ring->data_pending + pkt_len >
+	     NFDK_TX_MAX_DATA_PER_BLOCK)) {
+		unsigned int nop_slots = D_BLOCK_CPL(tx_ring->wr_p);
+
+		wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+		txd = &tx_ring->ktxds[wr_idx];
+		memset(txd, 0,
+		       array_size(nop_slots, sizeof(struct nfp_nfdk_tx_desc)));
+
+		tx_ring->data_pending = 0;
+		tx_ring->wr_p += nop_slots;
+		tx_ring->wr_ptr_add += nop_slots;
+	}
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	txbuf = &tx_ring->ktxbufs[wr_idx];
+
+	txbuf[0].raw = (u64)rxbuf->frag | NFDK_TX_BUF_INFO_SOP;
+	txbuf[1].dma_addr = rxbuf->dma_addr;
+	/* Note: pkt len not stored */
+
+	dma_sync_single_for_device(dp->dev, rxbuf->dma_addr + dma_off,
+				   pkt_len, DMA_BIDIRECTIONAL);
+
+	/* Build TX descriptor */
+	txd = &tx_ring->ktxds[wr_idx];
+	dma_len = pkt_len;
+	dma_addr = rxbuf->dma_addr + dma_off;
+
+	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+		type = NFDK_DESC_TX_TYPE_SIMPLE;
+	else
+		type = NFDK_DESC_TX_TYPE_GATHER;
+
+	/* FIELD_PREP() implicitly truncates to chunk */
+	dma_len -= 1;
+	dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN_HEAD, dma_len) |
+		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
+
+	txd->dma_len_type = cpu_to_le16(dlen_type);
+	nfp_desc_set_dma_addr(txd, dma_addr);
+
+	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
+	dma_len -= tmp_dlen;
+	dma_addr += tmp_dlen + 1;
+	txd++;
+
+	while (dma_len > 0) {
+		dma_len -= 1;
+		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
+		txd->dma_len_type = cpu_to_le16(dlen_type);
+		nfp_desc_set_dma_addr(txd, dma_addr);
+
+		dlen_type &= NFDK_DESC_TX_DMA_LEN;
+		dma_len -= dlen_type;
+		dma_addr += dlen_type + 1;
+		txd++;
+	}
+
+	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
+
+	/* Metadata desc */
+	txd->raw = 0;
+	txd++;
+
+	cnt = txd - tx_ring->ktxds - wr_idx;
+	tx_ring->wr_p += cnt;
+	if (tx_ring->wr_p % NFDK_TX_DESC_BLOCK_CNT)
+		tx_ring->data_pending += pkt_len;
+	else
+		tx_ring->data_pending = 0;
+
+	tx_ring->wr_ptr_add += cnt;
+	return true;
+}
+
 /**
  * nfp_nfdk_rx() - receive up to @budget packets on @rx_ring
  * @rx_ring:   RX ring to receive from
@@ -903,6 +1077,7 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 
 		if (xdp_prog && !meta.portid) {
 			void *orig_data = rxbuf->frag + pkt_off;
+			unsigned int dma_off;
 			int act;
 
 			xdp_prepare_buff(&xdp,
@@ -919,6 +1094,17 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			case XDP_PASS:
 				meta_len_xdp = xdp.data - xdp.data_meta;
 				break;
+			case XDP_TX:
+				dma_off = pkt_off - NFP_NET_RX_BUF_HEADROOM;
+				if (unlikely(!nfp_nfdk_tx_xdp_buf(dp, rx_ring,
+								  tx_ring,
+								  rxbuf,
+								  dma_off,
+								  pkt_len,
+								  &xdp_tx_cmpl)))
+					trace_xdp_exception(dp->netdev,
+							    xdp_prog, act);
+				continue;
 			default:
 				bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
 				fallthrough;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index 5107c4f03feb..82bfbe7062b8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -71,6 +71,22 @@ struct nfp_nfdk_tx_desc {
 	};
 };
 
+/* The device don't make use of the three least significant bits of the address
+ * due to alignment constraints. The driver can make use of those bits to carry
+ * information about the buffer before giving it to the device.
+ *
+ * NOTE: The driver must clear the lower bits before handing the buffer to the
+ * device.
+ *
+ * - NFDK_TX_BUF_INFO_SOP - Start of a packet
+ *   Mark the buffer as a start of a packet. This is used in the XDP TX process
+ *   to stash virtual and DMA address so that they can be recycled when the TX
+ *   operation is completed.
+ */
+#define NFDK_TX_BUF_PTR(raw) ((raw) & ~7UL)
+#define NFDK_TX_BUF_INFO(raw) ((raw) & 7UL)
+#define NFDK_TX_BUF_INFO_SOP BIT(0)
+
 struct nfp_nfdk_tx_buf {
 	union {
 		/* First slot */
-- 
2.30.2

