Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2532602E3B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiJROU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiJROUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9626834721;
        Tue, 18 Oct 2022 07:20:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXmqapyMNophpTc4Vcx9fPdlpeKNX008/nuqgsVafyYV/g0h9dADhYgFpmINq0n535/GZpScb02AGHQpAi/8DkD3h8ovA48SeOUmF9mTx1tjhlzNz+3ksl+TDNnkC6Gqk6obD4jlg2fZrgrFwpQfwj9P6hVfvTjH3R0StJYAl+K2iVY2qhz22aqSfMu/VX7+NyULk6Nqm8PLhupYh9DiVUr94c5At4Zptr/+kouSrXksBBUzrEo/bx3Zid4eP1bfdFwQfOQukPtbbPvBwx9va4DNiqkTYRBt+kMJ7WqzcdKsU23k7vCc4mgRWFfybTQ40V4e7RwISvXKUUjXnWsqvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpVmp7B+Dd6WVQNKtc8ac898yi4wq+I45xHhwV1u+DQ=;
 b=NuiDpdgTl0rP/Y9V+NHbDIzeNiPufWJsh/4q9A/mEzz9GKuCLiNnwpQfN/MtbeSaOO07F9g9a1Vj49L15h5f5Gb+SwUtjmYZkW436XYpJ+WuzEsqr8FMN6DaTbHjlgMp1ULfI1OPGBS+23El0q/Or2mjDJIXxDOlGEoJ7NunLCdJ8iueoC1tr7to7WEkLb+5pokSCTpUlUg35Ne6s3UxwwaDswybJJC7X4RRjWT7hA2rQBllPGyLg4zMWXon7cWgUGsuaCeN3APfjtsaDUb44iZ7c56KZBNebatRmIunVktCK2XkVwLHzXBDmgLBtwNd1qoVH+XVf6EnjDba2Ms5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpVmp7B+Dd6WVQNKtc8ac898yi4wq+I45xHhwV1u+DQ=;
 b=eyvnwViF7V56BqsfREWOXdFu6QHI4f1UozPjdBEd+30/mLXm8METQ/7rPA3PgCgd9EKJp5a8uTtpLLA8WMl6/PoCTRPpY5cPFRYsL9M1GEF2rh5jHhib1hsGpS1iPJsQ1ovpizjtpBOPA29vL36t9xaLxTo5PFnpNpZFSwmUL08=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:41 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 09/12] net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
Date:   Tue, 18 Oct 2022 17:18:58 +0300
Message-Id: <20221018141901.147965-10-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 29278cf8-a1ef-4151-6872-08dab113cc32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTMNijHUhBddCJIrwc+g/lSsVa6WBIH90uRiQ3L9T6GBi9/xzJE5eSJPJKfrrnJas/vA7xQq51YxKxrIsODN8jhWL65r/EgwrYvBZ8QaU9Vm5luFjAX8Pk3bQCtdnfaeGk3KVn65nYVUu4J4QUaZuqRgm2koew7HBIeaVZ4kdBj1IYk32j2qjIo3QPgJSLhJhC4LcVhMOD0zy+2tmIyUiOfuy7xJiSCVJkAXYYTnTOXFlVWUzsOjxDm3Hy08A8YXo38Hi2K25KDAMomjemKE+s9jb6/7vaKIg6ulTBTwRW8QpnralrGmTdVuErUso1PKseMJNeGdjGIdaiDde0c8maI4csgpNv2DJNbNECd2NcOESL+EiRjF6rZC0xAL0fRWRvX/Gz1oq9K0mPlWLM7d/VPISVDxBlX4GZVGWqSH9852KccvhUdGtRIzy3qZrHE68KVhyPkImeSzaLQLZfKzEFNT2SfVdiQLNrh+wKeK3DvRQoWnosGdXlb/wWlfKolFJQn9EN39/nvBpGRk07fraoXa8C5Il9l6ZyxYgnJzpTmuyG9SmATfKQgJGhm1ElXKJRYQuzAvgo+0mlxXgIj27HRHh2t0wwlqdUvGrgiKflsO4RPBDl2FpOQjqQgRTwGRk1PSHd19bPmnkunp3VIhcpdvAdn6MSlTuXPz0RbXBYLfgG+x7tx55bApuAgyiLuuZ7WygGZBO2slhVvNNBlW0R0u+vEyckKhXJrkmHfUnwfsGriUqzT8OY8iEt1f7uouVGW230FBMP5lWzYTRHJj2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6PmmbmF3pY/tXZcpnZqL3BeBc6cDz5L8CJXZKdxjUMG4Zi+qp18OVPSzUOZ4?=
 =?us-ascii?Q?FLrAphjcZTIPztkbbl5ghPZ6D/Su+FAmM8Vi028HBieaHNSGHMRKO2b/yfFr?=
 =?us-ascii?Q?RKnahDoHvSm0TaVeWsBqRmwd4r2w/TQpsTaOwW0E1GHq9OKcXb6kPG2djBVa?=
 =?us-ascii?Q?uVdgJogoyIOo0fNgb37VZUyyaqxJLxoTrSmKTy57iOtlYgP/8W5R2F1kJWKx?=
 =?us-ascii?Q?xVG7ml2dqeiuU6zkIiNdGmPc4yk6IV7qvGOFvXE3aqbhDuN60lscKv4ZzaKx?=
 =?us-ascii?Q?AMrXeIgRkeIlJzrqZVMbg+6Zei0HnTlg/uc55CzusBN5mTz14KH2/1Dm6NJK?=
 =?us-ascii?Q?2WLs07oeWSRXG81yGU2R7KO6zfRxWHwpSm7JVAojKBNO6l7xKxU8NvBjCjr7?=
 =?us-ascii?Q?7t0HUQ/fIrYnDyAVvn4gNEOlT3+H01fp2Ec4rsRzHha84CimP8qBQ3XicLS9?=
 =?us-ascii?Q?HH9QYVzALmpOSwvPOJO7ZfOVKfAK/vX2ikmvPJVBn1c0RT/rhKC5gvt35iWC?=
 =?us-ascii?Q?hgddLOv8/XjGczt3JVOHcGgpl7nYhko8l27VIiFJyvj37KgSBW//pC6p1Zzv?=
 =?us-ascii?Q?kvBGJtLeOYoi8hGW0wjB1fPzWX3T/TioyAQ2hMD51FfiWosy80VQfygdDrpO?=
 =?us-ascii?Q?AhX2NbS/oIboowhnCW208jzxbjmwuPouYcD0Lo8ru5l7Vx88idnV7h7i4FS+?=
 =?us-ascii?Q?STn7wH+75vMm89E/vY6++58hAwE/PJUY3Kn57c3in0JKImZejgBwVoHsVFbo?=
 =?us-ascii?Q?EzJQFfUVtFDNyjXMvbPIIID5S1eGD27Nmojc34nL+ILwT6aR8gAevOu3ASth?=
 =?us-ascii?Q?RjaWHE9zBW0gWfqK37bY0Ebmnhlukm7txFMRMWO8iuXMJyjN9Gmw69h1ZOqN?=
 =?us-ascii?Q?6OzW3h8c4ANOVTQvmvTyrOp5FFW7BupXkjk6H4uRXIqOW9563W0fUNSslLz6?=
 =?us-ascii?Q?SWRySMG5ObQeH7XKFu+WGShbhU4ReYQGShVtBgTCtETrMV6y8VzP/cGxoqT+?=
 =?us-ascii?Q?9sxdP2R5E/uwjvbcRv6BVGiNSjocW7nWnra/by5d0NI9S/te4h6d3zgeK/9j?=
 =?us-ascii?Q?+q7xMjvdi7V3Qxf0kMA0OhuMwXqx9F8RrCCKiIHlU2SYBKOn3AR7lsx+K40m?=
 =?us-ascii?Q?Ep34XO7+ZlV6ke4dybKs5p6cIvv62kI8PvH5cfTWinv1zPpZmZFXM7lbd3ri?=
 =?us-ascii?Q?yd7M51dl+uB6VdCG2SN3z515J2bINSS4z4VX2EidLajUeqrY0wOuYuLKIFCJ?=
 =?us-ascii?Q?L+H14HNyBZUioXZTtnCBXT25z2FFLtwS3a1JBuP4MEvpkW9G0TvP8wgCf5mV?=
 =?us-ascii?Q?Obc75bjR+f375uc8thvRgcFME+Z7/9UmqJYsa4LeX41NDq49uhotiK78AZuW?=
 =?us-ascii?Q?xnNxuZJr5Gn2MFPcxo9mG7eLwu5H0AZDzmhUiPNjPpRN4zoViVWR442N4+nQ?=
 =?us-ascii?Q?XOaGcvJdcH6G8YtCg0ohpEjiWrEmm28osg+c5um4jsP4xrSiVo1cCo95s7Ua?=
 =?us-ascii?Q?WkjGsGDvZv1k3bK4EHuR2j+lmWavYlfUwo02d7tbIsJFeXGXMmRdEY7xuoU9?=
 =?us-ascii?Q?VL3A5y8bG3RrSh9KcFry10y2G6AGm1e7Coy17RAJ0ahE5F5jr8ZRrOqML6ZN?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29278cf8-a1ef-4151-6872-08dab113cc32
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:41.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4NmSlSvU00tdUH5Fvv8FmcwqEjoEHZ7kN+j7cMFcAe5d1Vc9Bax7Palj7v06Gbra/wJiIPodxP0Q57Kcm1HJw==
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

Carve out code from the dpaa2_eth_rx() function in order to create and
export the dpaa2_eth_receive_skb() function. Do this in order to reuse
this code also from the XSK path which will be introduced in a later
patch.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none


 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 84 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 +++
 2 files changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 9909fdf084e3..0b21a3ee1bf1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -523,11 +523,53 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 	return dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, fd_vaddr);
 }
 
+void dpaa2_eth_receive_skb(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   const struct dpaa2_fd *fd, void *vaddr,
+			   struct dpaa2_eth_fq *fq,
+			   struct rtnl_link_stats64 *percpu_stats,
+			   struct sk_buff *skb)
+{
+	struct dpaa2_fas *fas;
+	u32 status = 0;
+
+	fas = dpaa2_get_fas(vaddr, false);
+	prefetch(fas);
+	prefetch(skb->data);
+
+	/* Get the timestamp value */
+	if (priv->rx_tstamp) {
+		struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
+		__le64 *ts = dpaa2_get_ts(vaddr, false);
+		u64 ns;
+
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+
+		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
+		shhwtstamps->hwtstamp = ns_to_ktime(ns);
+	}
+
+	/* Check if we need to validate the L4 csum */
+	if (likely(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FASV)) {
+		status = le32_to_cpu(fas->status);
+		dpaa2_eth_validate_rx_csum(priv, status, skb);
+	}
+
+	skb->protocol = eth_type_trans(skb, priv->net_dev);
+	skb_record_rx_queue(skb, fq->flowid);
+
+	percpu_stats->rx_packets++;
+	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
+	ch->stats.bytes_per_cdan += dpaa2_fd_get_len(fd);
+
+	list_add_tail(&skb->list, ch->rx_list);
+}
+
 /* Main Rx frame processing routine */
-static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
-			 struct dpaa2_eth_channel *ch,
-			 const struct dpaa2_fd *fd,
-			 struct dpaa2_eth_fq *fq)
+void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch,
+		  const struct dpaa2_fd *fd,
+		  struct dpaa2_eth_fq *fq)
 {
 	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	u8 fd_format = dpaa2_fd_get_format(fd);
@@ -536,9 +578,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	struct rtnl_link_stats64 *percpu_stats;
 	struct dpaa2_eth_drv_stats *percpu_extras;
 	struct device *dev = priv->net_dev->dev.parent;
-	struct dpaa2_fas *fas;
 	void *buf_data;
-	u32 status = 0;
 	u32 xdp_act;
 
 	/* Tracing point */
@@ -548,8 +588,6 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	dma_sync_single_for_cpu(dev, addr, priv->rx_buf_size,
 				DMA_BIDIRECTIONAL);
 
-	fas = dpaa2_get_fas(vaddr, false);
-	prefetch(fas);
 	buf_data = vaddr + dpaa2_fd_get_offset(fd);
 	prefetch(buf_data);
 
@@ -587,35 +625,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	if (unlikely(!skb))
 		goto err_build_skb;
 
-	prefetch(skb->data);
-
-	/* Get the timestamp value */
-	if (priv->rx_tstamp) {
-		struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
-		__le64 *ts = dpaa2_get_ts(vaddr, false);
-		u64 ns;
-
-		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
-
-		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
-		shhwtstamps->hwtstamp = ns_to_ktime(ns);
-	}
-
-	/* Check if we need to validate the L4 csum */
-	if (likely(dpaa2_fd_get_frc(fd) & DPAA2_FD_FRC_FASV)) {
-		status = le32_to_cpu(fas->status);
-		dpaa2_eth_validate_rx_csum(priv, status, skb);
-	}
-
-	skb->protocol = eth_type_trans(skb, priv->net_dev);
-	skb_record_rx_queue(skb, fq->flowid);
-
-	percpu_stats->rx_packets++;
-	percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
-	ch->stats.bytes_per_cdan += dpaa2_fd_get_len(fd);
-
-	list_add_tail(&skb->list, ch->rx_list);
-
+	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
 	return;
 
 err_build_skb:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7c46ec37b29a..3c4fc46b1324 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -796,4 +796,16 @@ struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
 				    struct dpaa2_eth_channel *ch,
 				    const struct dpaa2_fd *fd, u32 fd_length,
 				    void *fd_vaddr);
+
+void dpaa2_eth_receive_skb(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   const struct dpaa2_fd *fd, void *vaddr,
+			   struct dpaa2_eth_fq *fq,
+			   struct rtnl_link_stats64 *percpu_stats,
+			   struct sk_buff *skb);
+
+void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
+		  struct dpaa2_eth_channel *ch,
+		  const struct dpaa2_fd *fd,
+		  struct dpaa2_eth_fq *fq);
 #endif	/* __DPAA2_H */
-- 
2.25.1

