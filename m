Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314236F2903
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 15:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjD3NPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 09:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjD3NPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 09:15:36 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2066.outbound.protection.outlook.com [40.107.247.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F024269E;
        Sun, 30 Apr 2023 06:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NH3gQD2q4yXWXan/mb8tHW87i2u2iEWh9VAEB5qIOsTu7C9spoJlLB25pqKinsbl7I0RTnn/uW7ouepwAk/LrNvxb+p8z2G8Kl3gBLZscHH1oCCmvEV/4au8IdoNaTGJ7FByZUhIF70q59SFT5jVLZmw7p1pw95QzhINgYgnDENqPLdr+KpW04zyN98Ts7coRG4HLZbO3adA8CfDuBmEB7I9+ORjwyYAGEGvrmDCbRLWtEuK+MoKyybHMrZOAc1POAdx8dha+vjEd8kJK7hyr3PZUQ5YY5/xQcKpK56uLG8Jt9oxIc2Sf+SDbDxRewCHfCoBy1+Di2ROafkqZQU8eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7aJHs4ZPbQLM+0r0hvl1cR057SHLuG2e2tFeWcuOjo=;
 b=fYo3jf7V+004PIXfSWfIBVPeNBks7J3l2I8rWbndDoilu5Fv1x90l/pSbTw8boi9otN0C7ETelqD/Rq8ignYiACl/3Q+s8AM3P7u3SQXzvJpW6mOsP0fOSpqTtcxdA88NMsYkDPaXGmTI0q8Acdmr0xBg0B3yncqipDWWHDOm+r0K9Fl1enUHu/8eqTpbt+ctuz+312m4JHummKOVeJ1F7jnJHYm5hZA7V3IVbhDnBmV97qJiSvdPy6XqyJXQkkMgLuyKQFxnKJU3unEOUdb8cVBICjLFN+pe9Rd2HoFU3FbdcHpDmQbJtJ9LfpJe62tYEMmftxOp+rIbDT2ERhjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7aJHs4ZPbQLM+0r0hvl1cR057SHLuG2e2tFeWcuOjo=;
 b=SgU4sjQc2/iebYT+sIaY7TBMvEK0MP2DKGAwb4kdttAp4Fn72O2KyJ7ypKO+rHuFVWvzf+Yn4Lq5Ji0eaXDdHu7caVE96ID058Eo2BjwpIIv3XNYQe6ljntytyJSbKhRTN0VIDekJwk5EdK9qz5NZ3r498hhlxyrPi7jzRNxK7s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AM7PR04MB7142.eurprd04.prod.outlook.com (2603:10a6:20b:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Sun, 30 Apr
 2023 13:15:31 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.026; Sun, 30 Apr 2023
 13:15:31 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com,
        Alvaro Karsz <alvaro.karsz@solid-run.com>
Subject: [RFC PATCH net 2/3] virtio-net: allow usage of vrings smaller than MAX_SKB_FRAGS + 2
Date:   Sun, 30 Apr 2023 16:15:17 +0300
Message-Id: <20230430131518.2708471-3-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0191.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::10) To AM0PR04MB4723.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB4723:EE_|AM7PR04MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 5748f0f7-03c0-4712-ddf2-08db497cf974
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TnD5wNTSfyEOeCdUUfS6WFkqe6eL3KiVU2jhRjBMKwyYIXQOyBnvm0BfLgleKQEH5wG7uMEy7h/kAJw2JX5m9is8oSfOfRFRMLqyTPEyf5VamWQ/n/OUUVRIXLAF78AJEISwdXAwqg4T34htm36mHsW0t8IAx2fgvpRA8atyDDezI1Vn0yz0l/uPJpHWCTHY+zeU0wUzJi9WDAQ0Djzcem1DyE7QxvWP29fwlhbMcVdrebTeKdRzL5y1LveTf1XpSZukQZiy9XCVqOPNir+lttYaYuDmqTfKsISZzXQanI6+2reF4IB455MkZVh9czILk8/bqjErBIXFUSZFt3zrrxoKImQsMGXNL2eI6R6dGPzzpiEPCVNzeqs0J+623bjrNJXxGggOm1pZ9RydMqmJx37OKUqImCgBmHJks1gsjsMjRM+EKzKbG/wMRZjbjEtnl1nJWBI+f1Omj5cjguffF4CeixHPVkvSBoEpaM4Y9Jluh50nPnFkdnFCNVgn6ztTjBPWbGAk9fVQFLxXGytr/FPrrCKHxDLEQ1LLlFupREhCoORWdCwU+VKr9xOrwH0vo36fxSP1NSotkoLgRjvofTRoLDunht2QewhIu6VVfrNFJGK3lYlJ76kmCOuupJOF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(396003)(39830400003)(451199021)(86362001)(36756003)(38100700002)(38350700002)(7416002)(5660300002)(4326008)(66946007)(316002)(66476007)(44832011)(8936002)(41300700001)(66556008)(8676002)(2906002)(83380400001)(2616005)(6666004)(52116002)(478600001)(6486002)(6506007)(1076003)(26005)(107886003)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RROlZnH3FJfpUbh1QyDF9W7VN3Vog9edRitDeQ5ro0zYr5+NdsmZ1u5bOraj?=
 =?us-ascii?Q?dLtolGEcB2rLnMf0YiaJsRS6K6QW9CH+DfiY2UgikDUuaEVsE5TqV8i9fHru?=
 =?us-ascii?Q?PvgabMZmibFJgq6GSgssIMv0B2TjAJFQVUberhvd+icBR7lrq0perMwbvivm?=
 =?us-ascii?Q?nygQRs9uuh8F5TA11NPiUDeov2YRC/6+DYTutDNmZm5+8YyrtdrHF4NqEgPY?=
 =?us-ascii?Q?CaORjy8d6uFDEsDjBrjAQgW7rP/3V/EpwUvEdXaNil3cNkNJNHsQgxhbh6r5?=
 =?us-ascii?Q?VDnGt0JrmJYOhIp2WXedmiuscWiP3UKDRXl+crnnu0R2kXO3DZmWFqogEKDw?=
 =?us-ascii?Q?wz82bkroGA1ZkYHRwqsyCHyFRvAjR6yvAg//A4s9plsSjAiCFSouG4oUwPZr?=
 =?us-ascii?Q?Pf/uISJ+JbJKxABCREmgb57pm6ZmTkHKrVw5k0NUmYAfQ8Q9kK1PhmClu71p?=
 =?us-ascii?Q?4/yB5LeDuehCSlTiJqNjRbl0x2k+sVpECJeVM2m4UWnsHiDHbJ6EgV/9tEje?=
 =?us-ascii?Q?DJyO06UVQ/pahdtct3cewOrOp7o7i+mKT4JyqYGABBTjpaJNuI1hwQckHkrG?=
 =?us-ascii?Q?tTkiB5tKpbtxejiF6ZGaTDSVaZ6yOFb5T3mZWSUSTwRaWNxyKX3PPRLjgFme?=
 =?us-ascii?Q?TzvVGnHFQ4D0hf5wDZUEqw8Utfdf+j1JJLlqRqG3gX9E6akpR1QQqaEGOBcE?=
 =?us-ascii?Q?yVC3fl9NCTv86irD8uekyHa+BxeqUcf7PKYcOtWLCoGnavBIn1F03rrzE0Ol?=
 =?us-ascii?Q?3PJKLvxymL989Pv369xRJOAGUMmizuJ37JRX4KUkYQikBuZB9A5ofQbKYDE2?=
 =?us-ascii?Q?ZUa46DCK4foyp9qXY/0utDo5Qct77Se/DaeAKTCY9kA7ln7nNFFQ5B7jRnGR?=
 =?us-ascii?Q?XnvatcFZWG4vmmi1rzkQCOMT7iiIxVqsGhaVvAYstxPV6WdSydl7caLVj84C?=
 =?us-ascii?Q?dhFVIF2wPlNUDl1N9Prgw3MZlakvBTvdfy5ixo96AoofKsHX4BnkHkhmN6GQ?=
 =?us-ascii?Q?wHpXsXwB9zHERcq/HG+3Sm4JZAxAs+XQVbpZyZ8iEVvjiNSbkcg3HCiaCgAD?=
 =?us-ascii?Q?tqVayhzSYrOnjboGZTCgLlk+8Kar9Za/MEcAcTf+DIaNP37YLupxkcgxwLms?=
 =?us-ascii?Q?tE3QtlvqNhsM/KtxS0ka7MbbeVSJgFylue5M/gwmxTg9CcRk9+42Kw8BlMgu?=
 =?us-ascii?Q?7YH78R/VEyQULOOx5NgDHn9XNTVzrHjTUoHvwXtrfWVar0MDtERt5FHwG/yI?=
 =?us-ascii?Q?Qyf6vvkxAivFhvRTUl31DtxpsuJzpijDRKC0GDvRoa6lsKw0lh6+Tj6ZgTV5?=
 =?us-ascii?Q?Dmf8DM9JHP6ZNGMQOKMJ/z46JYLtQw/MlTIlpHl5Qmf8HoYzRh9hU63TJy1E?=
 =?us-ascii?Q?k3CxaSIlDk0GgvwESyRPvPKqvBR2TOiylUBSIXAlFnFQGHFtOiWWHqW43cI+?=
 =?us-ascii?Q?r0b9yzzsgdBJuXTAPOUkILnzHfyiU6XG21EbROtmki0sP+uLEt1Po87T33lM?=
 =?us-ascii?Q?8sIMVr9KihaV39aP0jCJ5mQQI2Wpi1wkXVatlBJlKabBgSHO/TzlrZBG5csJ?=
 =?us-ascii?Q?R+m15FflBPwtJDM16/d5OKPPH2e/S3NRM6Nk6/GbWkK2/JhXH7ZFzwxXAn3D?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5748f0f7-03c0-4712-ddf2-08db497cf974
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 13:15:31.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHWJRQlFn/vy4TC7MPc/nAy+wPpJVS5sJsj/ci5biCxHvA3GZ4KQCWoLvjFx6y31jatYnEX82XLAQuTrRkiExqJ7ar3DHbRf6N417CfFhjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7142
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, if a network device uses vrings with less than
MAX_SKB_FRAGS + 2 entries, the device won't be functional.

The following condition vq->num_free >= 2 + MAX_SKB_FRAGS will always
evaluate to false, leading to TX timeouts.

This patch introduces a new variable, single_pkt_max_descs, that holds
the max number of descriptors we may need to handle a single packet.

This patch also detects the small vring during probe, blocks some
features that can't be used with small vrings, and fails probe,
leading to a reset and features re-negotiation.

Features that can't be used with small vrings:
GRO features (VIRTIO_NET_F_GUEST_*):
When we use small vrings, we may not have enough entries in the ring to
chain page size buffers and form a 64K buffer.
So we may need to allocate 64k of continuous memory, which may be too
much when the system is stressed.

This patch also fixes the MTU size in small vring cases to be up to the
default one, 1500B.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/net/virtio_net.c | 149 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc..b4441d63890 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -103,6 +103,8 @@ struct virtnet_rq_stats {
 #define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
 #define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
 
+#define IS_SMALL_VRING(size)	((size) < MAX_SKB_FRAGS + 2)
+
 static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
 	{ "packets",		VIRTNET_SQ_STAT(packets) },
 	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
@@ -268,6 +270,12 @@ struct virtnet_info {
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
+	/* How many ring descriptors we may need to transmit a single packet */
+	u16 single_pkt_max_descs;
+
+	/* Do we have virtqueues with small vrings? */
+	bool svring;
+
 	/* CPU hotplug instances for online & dead */
 	struct hlist_node node;
 	struct hlist_node node_dead;
@@ -455,6 +463,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	unsigned int copy, hdr_len, hdr_padded_len;
 	struct page *page_to_free = NULL;
 	int tailroom, shinfo_size;
+	u16 max_frags = MAX_SKB_FRAGS;
 	char *p, *hdr_p, *buf;
 
 	p = page_address(page) + offset;
@@ -520,7 +529,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	 * tries to receive more than is possible. This is usually
 	 * the case of a broken device.
 	 */
-	if (unlikely(len > MAX_SKB_FRAGS * PAGE_SIZE)) {
+	if (unlikely(vi->svring))
+		max_frags = 1;
+
+	if (unlikely(len > max_frags * PAGE_SIZE)) {
 		net_dbg_ratelimited("%s: too much data\n", skb->dev->name);
 		dev_kfree_skb(skb);
 		return NULL;
@@ -612,7 +624,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 	 * Since most packets only take 1 or 2 ring slots, stopping the queue
 	 * early means 16 slots are typically wasted.
 	 */
-	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
+	if (sq->vq->num_free < vi->single_pkt_max_descs) {
 		netif_stop_subqueue(dev, qnum);
 		if (use_napi) {
 			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
@@ -620,7 +632,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
 			free_old_xmit_skbs(sq, false);
-			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
+			if (sq->vq->num_free >= vi->single_pkt_max_descs) {
 				netif_start_subqueue(dev, qnum);
 				virtqueue_disable_cb(sq->vq);
 			}
@@ -1108,6 +1120,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		return 0;
 
 	if (*num_buf > 1) {
+		/* Small vring - can't be more than 1 buffer */
+		if (unlikely(vi->svring))
+			return -EINVAL;
+
 		/* If we want to build multi-buffer xdp, we need
 		 * to specify that the flags of xdp_buff have the
 		 * XDP_FLAGS_HAS_FRAG bit.
@@ -1828,7 +1844,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 			free_old_xmit_skbs(sq, true);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
-		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+		if (sq->vq->num_free >= vi->single_pkt_max_descs)
 			netif_tx_wake_queue(txq);
 
 		__netif_tx_unlock(txq);
@@ -1919,7 +1935,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	virtqueue_disable_cb(sq->vq);
 	free_old_xmit_skbs(sq, true);
 
-	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
+	if (sq->vq->num_free >= vi->single_pkt_max_descs)
 		netif_tx_wake_queue(txq);
 
 	opaque = virtqueue_enable_cb_prepare(sq->vq);
@@ -3862,6 +3878,15 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6));
 }
 
+static bool virtnet_check_host_gso(const struct virtnet_info *vi)
+{
+	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_HOST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_HOST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_HOST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_HOST_UFO) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_HOST_USO);
+}
+
 static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
 {
 	bool guest_gso = virtnet_check_guest_gso(vi);
@@ -3876,6 +3901,112 @@ static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
 	}
 }
 
+static u16 virtnet_calc_max_descs(struct virtnet_info *vi)
+{
+	if (vi->svring) {
+		if (virtnet_check_host_gso(vi))
+			return 4; /* 1 fragment + linear part + virtio header + GSO header */
+		else
+			return 3; /* 1 fragment + linear part + virtio header */
+	} else {
+		return MAX_SKB_FRAGS + 2;
+	}
+}
+
+static bool virtnet_uses_svring(struct virtnet_info *vi)
+{
+	u32 i;
+
+	/* If a transmit/receive virtqueue is small,
+	 * we cannot handle fragmented packets.
+	 */
+	for (i = 0; i < vi->max_queue_pairs; i++) {
+		if (IS_SMALL_VRING(virtqueue_get_vring_size(vi->sq[i].vq)) ||
+		    IS_SMALL_VRING(virtqueue_get_vring_size(vi->rq[i].vq)))
+			return true;
+	}
+
+	return false;
+}
+
+/* Function returns the number of features it blocked */
+static int virtnet_block_svring_unsupported(struct virtio_device *vdev)
+{
+	int cnt = 0;
+	/* Block Virtio guest GRO features.
+	 * Asking Linux to allocate 64k of continuous memory is too much,
+	 * specially when the system is stressed.
+	 *
+	 * If VIRTIO_NET_F_MRG_RXBUF is negotiated we can allcoate smaller
+	 * buffers, but since the ring is small, the buffers can be quite big.
+	 *
+	 */
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_TSO4);
+		cnt++;
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_TSO6);
+		cnt++;
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_ECN);
+		cnt++;
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_UFO);
+		cnt++;
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO4)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_USO4);
+		cnt++;
+	}
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO6)) {
+		virtio_block_feature(vdev, VIRTIO_NET_F_GUEST_USO6);
+		cnt++;
+	}
+
+	return cnt;
+}
+
+static int virtnet_fixup_svring(struct virtnet_info *vi)
+{
+	int i;
+	/* Do we use small vrings?
+	 * If not, nothing we need to do.
+	 */
+	vi->svring = virtnet_uses_svring(vi);
+	if (!vi->svring)
+		return 0;
+
+	/* Some features can't be used with small vrings.
+	 * Block those and return an error.
+	 * This will trigger a reprobe without the blocked
+	 * features.
+	 */
+	if (virtnet_block_svring_unsupported(vi->vdev))
+		return -EOPNOTSUPP;
+
+	/* Disable NETIF_F_SG */
+	vi->dev->hw_features &= ~NETIF_F_SG;
+
+	/* Don't use MTU bigger than default */
+	if (vi->dev->max_mtu > ETH_DATA_LEN)
+		vi->dev->max_mtu = ETH_DATA_LEN;
+	if (vi->dev->mtu > ETH_DATA_LEN)
+		vi->dev->mtu = ETH_DATA_LEN;
+
+	/* Don't use big packets */
+	vi->big_packets = false;
+	vi->big_packets_num_skbfrags = 1;
+
+	/* Fix min_buf_len for receive virtqueues */
+	for (i = 0; i < vi->max_queue_pairs; i++)
+		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
+
+	return 0;
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err = -ENOMEM;
@@ -4061,6 +4192,14 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (err)
 		goto free;
 
+	/* Do required fixups in case we are using small vrings */
+	err = virtnet_fixup_svring(vi);
+	if (err)
+		goto free_vqs;
+
+	/* Calculate the max. number of descriptors we may need to transmit a single packet */
+	vi->single_pkt_max_descs = virtnet_calc_max_descs(vi);
+
 #ifdef CONFIG_SYSFS
 	if (vi->mergeable_rx_bufs)
 		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
-- 
2.34.1

