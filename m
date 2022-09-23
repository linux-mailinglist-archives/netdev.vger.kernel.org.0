Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F52F5E7EEB
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiIWPrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiIWPqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:55 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2779A0604;
        Fri, 23 Sep 2022 08:46:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Apm+pm2Ro2un1L22nKLRHm2l6VHtFKchyMkDoIZqakR0JfwWOzjhUooWyWNGMhnpiRBr/lLHXLVwiXB6HE4AUccuy1h1LYy2JQhgvd/ys0wOGXurnLAMXNprUATOHLbfiHpiCRDKnB6+uAHTUzZwEi/VshYu68Gm6X3au+DfhcqTNLavlxR304JF0ufKeaJwtp90acS2eFUBG9PDktZbuRsBL5cek2QsxicJ+MVMs+LrGTfEfvJ4r3O+aabxhVd571paw/oXDuGAR0T40rF4U5qjKAVaZrreHJH4qvzbCH9BnGHAUD+lembCkHr2bLu9yL90caFziM+2QaPULF8qHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEOn5DO3hl1VkUQBPD2J76rzTXzWMwjDw3iWyE8TNJ4=;
 b=LBVyeMDyAM0LEOjvCBmaETFLQvlA4jbP3k2XsfOwyiFfq1RkJS2PJqrr7ZU9ZeRfkiDRcD2PlCgTPWWztzGBrqUyYTI6tAX5aoAlYgeujwaFqRkWgjA4wlYwhyZHD+ZhccnYg+Tgl/FRsVuQNSGAG9YJsxwAMI9JrLcTDJ7F3dYW26cwIH8Oj7kL4LLS2lYI9hJfdqSYW4eYI12EaIAp2yiMPFZLCVtgPRTd6Fdedp9w7RLCUWJ5FZ+24mUguCPilL0PVKxqQg5Dh5C3xp/ij7vabsdB0/BhCqX+EPz7vkPR+C0Yd1ObtTxpcbfu7qCY/+UQWz1PwBCsnJfSHjCqNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEOn5DO3hl1VkUQBPD2J76rzTXzWMwjDw3iWyE8TNJ4=;
 b=o72VL+DH0/C23Tz/51di6hq0u1iy5YMzaz/7eYHZTUL9ldG3Vnsf2ieG+lCDLL2GLWFM3J8iP3YhF2DJ4s6A9BrUbNiqS7Bf3nb6+XvsClupvrfhHJLHHguC59ft8X/51U2NtK2tnNH7ND9Xiu6iLx7hpqsMpfQByYYQ2v8uMsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:50 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:50 +0000
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
Subject: [PATCH net-next v2 09/12] net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
Date:   Fri, 23 Sep 2022 18:45:53 +0300
Message-Id: <20220923154556.721511-10-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4727ac53-f39b-4739-f5af-08da9d7ad4af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bIHy3vO08lMjZaPt1/1KEswtQECM1dbNYI3IPGZ+7rccPESHmDga43f948ooIusfXOAD0ghaEjaj9i/KNnX1o9Ve9j92gy7wUrGBZ26CMHCum4PAXsXuIeU13kMGPEF+9VPJg5B+QXSms/emJp9CJH9JfH5PA3RxyA0Idz48iN+dl2cFIvyUTWmDqZYrbSyaM1fxO+wzrt7UwYoSpEzQS8r8hBz/fdQESne0BcZAp4cjNCjfUP+QbxYxcXlwzYH1OZ2yNHX7CpcSHiNDShzVKz8ieZyxCRu+gNdT1oo8wZThyjMgH6/Q/Y4EIblHUsVWg6auSw3Jdg0Tcb5IW0RdHaO23FMr5TTZ5eo7aNgi0sMnx0IHkd5OWYx7puDUUkoQHALe1INIF4Xj12v0zJc34D4CtVwPBNKyTvr5Sr2ouRs0a16TCKFB8C2g0gCdnI6BBXzpGBG8wgHvQZUYVyvK0p4oRz/+X9wsbcIibpCQS0yoEWhgVxdXjYDloQCe5uQrfDsDZWN9+992OZQZC18hKqpw/iKtZhMUeIll2J+MiR0PGOmpzFUYff8SUTUuOVQ8b5Okhv2MyQTL8cqU6VfTclJQ6CbE6eLHt0+jK/yqIZWVt+owwSM6iUDwc8+yOYCoHa3+JPdUbZz9r5+0AbvJiw+iutL0ffrhPUnzBeuQjE55lC/heVrkA52hurRwfdKETz9UwMDlRGo7NX1y56NcOheghcczNtNt+2pKHQB1jUtEiVvJ7dZO0s2e7ryMfq+9NPGAn+LRGZloI8WuG0JLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(66476007)(41300700001)(52116002)(83380400001)(6506007)(66556008)(4326008)(66946007)(8676002)(26005)(36756003)(6512007)(38350700002)(8936002)(38100700002)(6486002)(110136005)(54906003)(316002)(478600001)(2906002)(2616005)(44832011)(86362001)(1076003)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/sKyRRl6f6mFrAPcq+Ag5Qat8wdLmWcmP6Jb0fyodLGs/hqSvTK5wNvwGVv?=
 =?us-ascii?Q?YsdbV9o4UD0PisdjbYxLGb/cR5LkMUmHbYRtINPQZ0/AX2VUII325iILYIz1?=
 =?us-ascii?Q?5mB2aJl/BUOtmDP1W5AboHAkKTNcJ1lVQffu6U6AWd+TmnboUl++F6Ok+e3n?=
 =?us-ascii?Q?FM7YDYhnfTDJBVwqP47UuSH07Rkuh+OmaUB+BKSUKNejKi4ig18EKrTwh7of?=
 =?us-ascii?Q?5H8BHYWcUFFAbS+UMMoYNTJLGR/MT8mIZndqxal7qtQflgw+yr4LBHjjMoJV?=
 =?us-ascii?Q?8KxfiBxnaqKKixEB6Ihy2y5sh+Q8RwDVi2vdXuEWutkvwCQLRbogrloX4jNe?=
 =?us-ascii?Q?Vvq1AnJZjMA28TpDauBzOdsdqnK5Y7EUHmvpT3NvjFqybrK/VwG94GXBPRQB?=
 =?us-ascii?Q?t8uMlCe4iTytEE2TnbHbTnY9e31xeobT/Bq4Sj+h6/l/Nv3Fm3KWgSBMkc/s?=
 =?us-ascii?Q?iU9+wBMv49TvmKGzhYQwnSLcFzsZePo8SFpLllEV1ziX8MfTKUlL/CYXK9EE?=
 =?us-ascii?Q?xnbN4xAyL4AX7MxCa/qzOeiii1m+MyERfnzR0CEwXIiutA06heDL2q/jZTAi?=
 =?us-ascii?Q?b3LnZeAf2O8BU7KklGxBYpmUzwsiZIULG0VAPUwXAk5ntfmRJjNlAANpyMWX?=
 =?us-ascii?Q?vju33WfA+RayjjZP1loBDbIal2V6VCtFThVMOXn0mD3FuEBTcLRIbNjj8zDI?=
 =?us-ascii?Q?rEE7bV6zsLbXfqxsdc6k98FIixuPaf3eQA59M28E52OMJEv31gRgLeiSScyv?=
 =?us-ascii?Q?t1mDqOFvjFZN0dVHvfbsFQFEy39liArZcxUt6duBhaNFP5XxxMOZTCYPlCYd?=
 =?us-ascii?Q?bPgKUZrgIM0gbo6U7IiDsRcFPERYmz1FJHYRyjxs2VAAFhANZDT5ZJ3sTXFi?=
 =?us-ascii?Q?CTULLRCAb7GOTX/M/sF4JUDG6wFbVnfJ3qw7HXRp/jLmR4k2UrpG0Guhvo9h?=
 =?us-ascii?Q?/bdW8GM7CExNX/vJpK4wAW/29R1MnFCOpSuLczgpgt09J8ZiwvIK73k0aIh3?=
 =?us-ascii?Q?8AArHiHGnE6iwHtcEY76eFVoykaoRpb3BoQWQcEX16hnRTC0T/f/iHU9Z+5d?=
 =?us-ascii?Q?xL2mdCWkvuhLNSACqroi0zfZUL2tIwAoG3cQCffhr32b3IC/CsDJA9ROFfWR?=
 =?us-ascii?Q?fjzk57Jvp2A48QmPYtIv9yBsjug3q64aqHolZnrmFE9gAfXJP/iTVJ9dvZKT?=
 =?us-ascii?Q?0waL3ATV0gPQixug0guaAY01HXitRDE488xNOr+l2t6OboifkKUw10bk7rPk?=
 =?us-ascii?Q?jIu+E8oK0MK2VzMdLqS8NAxfEjygig2uOjUG0eERhHlDXAvwm8SrjvsCtfmy?=
 =?us-ascii?Q?iLfmRaMO0R2bi3gtvcmd1kvavvQ76Y2vRD6UXstRpABMnJFbYdHRyp2iStyw?=
 =?us-ascii?Q?gei9Gheg6Pu65khYdlggxHhaBhlqrQh0Y2H1EUlAvml1rSqxG3UKLXGuK8gV?=
 =?us-ascii?Q?irsRkJtyPq9qCan2+g/6F5OFmiRhP1iqSBHhK0sSTLvLZml19WPqk7QDPoBg?=
 =?us-ascii?Q?TpJime2Twcrc1hoSnyT+y78dOoTTbBWHnYWGAun0DJkqYZbKqaRYYOzhqyme?=
 =?us-ascii?Q?VMvWnf6srnzMhczh5/1DNcmG3YDdc2XVkoerdgBEzRl0+vbrYVMpmTFurlvU?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4727ac53-f39b-4739-f5af-08da9d7ad4af
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:50.7624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtWd/yK4q/3B2J91w9BE7/fZ+5LD6gVOruhOcp6Of8MbCIM0uhmQ+vMpkHZjU/gvf9vKa4yf1zaFXpjIXrxTjg==
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

Carve out code from the dpaa2_eth_rx() function in order to create and
export the dpaa2_eth_receive_skb() function. Do this in order to reuse
this code also from the XSK path which will be introduced in a later
patch.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 84 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 +++
 2 files changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a3958f02bd7e..d786740d1bdd 100644
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

