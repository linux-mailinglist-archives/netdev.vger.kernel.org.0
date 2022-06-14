Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E6054BBAE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 22:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358208AbiFNUaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358171AbiFNU37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:29:59 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-bgr052101064017.outbound.protection.outlook.com [52.101.64.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FDB29834;
        Tue, 14 Jun 2022 13:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjU9CCd781LN5H6xEJecVSgXeGLXAnlqau1CxV8QH/AyDGi2gRgSfe8rETE8FFGTO0VuCjRjL4bpx2xfsxa9PeBS/QkIUOfZIfSpdTIus6YumCm061RHn8BFvUFM/lPjLFdA9/WA9QHPIYDXwiXw9N9GmnCNBDQN+p3H2XQEjoHWr5Eu0OTReSPDsCInrhgNTpQJNIgCwgFw/1tEwn3yAGsvbOo5r1zfoOmL9AZ9aAC+pz16Fha79Z0HmyOdrH2piLhbksj1yUrco6QrXSeYHhH4POHy/ir69+QmVCxUDkBMOlxjWflOGcIfRcTm+q4T7LLTt5fhWMgGFCJUY5wTrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbLQur2lLKngM1gyBsHo22EVD11TSunfeRWn8X4BpbQ=;
 b=XVhPbbHXpP3abGm1rcGUpEV5cAnNxMLGxiggUbUoTQMITEISx+hknwasObwxbk41nJtp2eJ+Hzoe/lg8pLDaPW7t97ZoXhIqZO98DguFQ86QX0O4hyQH11hJakfeLOMj64ERQViIuugotsAnJqYlcRCbxB0b+6A0pdVwixRpzxthpPcyXL19klxPwI0rWceBGJR01dhagVO/No0z4Y8NoKR/6lI2/ZuyXQjK91vz4g1p8GnCjRHnSpNk5pTil1ESsvJ9Vn1jFCNYL2Ot4IBhK05xwAwfNiBy32kRY4WXrbbwLcCjeNF44w6cd0uKurdMeG80uXALjPK80xv4hNkddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbLQur2lLKngM1gyBsHo22EVD11TSunfeRWn8X4BpbQ=;
 b=b96NdCY3Q9GdlGCcKh/zUGvdAC4X3uIR3LNFwiWDOVZOuCtJcaaVTtJh/H72vuh9RwHAYtRZx0Y5T4j8jFBlik1ey7JP9ytbwrb2n/5Z7gj7wup7CxlYlz8BOCgs1v1blUgoPfmy0LFvsXAnyccxDwtVhfhsIMuRb8z7MvvNM2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:103::11)
 by MN0PR21MB3314.namprd21.prod.outlook.com (2603:10b6:208:37f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.8; Tue, 14 Jun
 2022 20:29:56 +0000
Received: from BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac]) by BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac%5]) with mapi id 15.20.5353.001; Tue, 14 Jun 2022
 20:29:56 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next,v2,2/2] net: mana: Add support of XDP_REDIRECT action
Date:   Tue, 14 Jun 2022 13:28:55 -0700
Message-Id: <1655238535-19257-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655238535-19257-1-git-send-email-haiyangz@microsoft.com>
References: <1655238535-19257-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To BYAPR21MB1223.namprd21.prod.outlook.com
 (2603:10b6:a03:103::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 434e0bf2-7876-4da2-2b20-08da4e44a4e7
X-MS-TrafficTypeDiagnostic: MN0PR21MB3314:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <MN0PR21MB331494EAC8345756034FEBDAACAA9@MN0PR21MB3314.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWl5kZzUQbT2yucVSdc9XhJnXdk5mgNoeYxxFj6U4T++iXp26jMS9gvjAHAsv9jsaWXVBrMcRwKJ0jA89rYxXTMVFZ6t0w96aIdIZ5vv7bOYvLR1MK6l3TTQ6KT4mQGJQAWj/Ma0t/k+rmmW7sMh3BT+lHAjdZOZfDqUCNiFDy9i2hgZciH5PniRi0G72KDUbl1hpHXQbcdYrGKjWUe2EygfFFOIM9rwM3RIbQ8lVJ9rS5DesUd+0Fde26oc1g0jc0n2hOZabBRfSILIAJl7hbyyMUwjeR1QSJ3oEKl5L79u8enq9vMNxG4YJqopfYIjAVsJN1eo7PyoOUPevoOssVIWOM+9qZ8CNA06G2PAQp6rkWoIsaLNFY0v6wcJRZgggSVWOy9BCm7/0NLWV/PYwm4sV9hKwQw9GMaTFlVJJo2VUTf3Bttujbj0IUSw/XjQC12q4tq1adnuamTPf/mlpxjOy7n7YVNloZHM2aDL7RaPrH8Asx25RAX8jPK2+tJVgI6pM6mfKEBuH9rodWVeNXA6FkvPI8GNWMB7zdJ2uf6XfJFxV6hpDlFV4gQto+7V0ElDQ/21VlITMRqDaaiCXrMBBNmJYNPXY5w3Vj7+8Rlv9VMG63WHCvDS4vpxuonkBXmZ9/bWxvzYraR3YiS4ciLxGnS3ceZl8kORK9cOMKcvdBayvKxYeWyA/TnQbkzKZW5KyVTiO2ZJTXJGvYY82B/bMYRyYvhKv2mKEnbWgS9v+4kSyaYDvPfBqfB4nB+6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1223.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(451199009)(6506007)(186003)(52116002)(2616005)(6512007)(26005)(38100700002)(82960400001)(38350700002)(82950400001)(83380400001)(5660300002)(66946007)(36756003)(8676002)(4326008)(8936002)(6486002)(316002)(2906002)(66556008)(66476007)(10290500003)(7846003)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q5f8vODSJL1JDYg+uvggaCHIawsWxm9kgK6064jh4Y6Jsnche+07iPzvll31?=
 =?us-ascii?Q?mveU4QWvkI8RMXnoXWnOOA7Dq7kckWl3VVKUShuyU3tp67Ew9vgyqcywtjM5?=
 =?us-ascii?Q?UKYC1TvXtMHuh9yvt1Z/0Oz/3aLHgPlmPY4jM4BIIwMaVFD97K35gy63ZhpW?=
 =?us-ascii?Q?yD//GoApHrgVNcAgPR9C0Yfy8T4ZDLEF4hRJ9FYE0xPpX6459IghWXWkcTxt?=
 =?us-ascii?Q?17G+wOe0dOCFfXhPesaDaXz7qIX3rFD25zwHQw6nbWkF/RN4rewnAiuIaBCp?=
 =?us-ascii?Q?U0xOQOrGugA80PyNGZktxJb3NTUv7GINKXkQqBD4YhuMAuXJ1vP9n25NoabL?=
 =?us-ascii?Q?lM/AQrCS2V0O8tay/AA6IbFFeBKvLIhKYtmB/KZi4igXG4I+0mi2LPFM2Csf?=
 =?us-ascii?Q?VqYahTKmAr000iPE8NFZ3aBTIgs+mnz6R5xpEOcpyndSzw8QAzRnkzMzzkUV?=
 =?us-ascii?Q?JuUtc9Kn3R7zAxDTeVWwGWKvHdUGeQ+Jih4KrPeS8ZY+pM6JUimS0Z/wJGDY?=
 =?us-ascii?Q?nmlbqNp4HcJzoMxyr1yT2bY+07JQWJrZSUtJlgOp+lGrE+xN57x2DwqOXbnE?=
 =?us-ascii?Q?TeGJ9Y+F4Uuv1c2/811ZJpq2EaWngqSt/6dzN2t66UnK51xCs46ul+eQnX3E?=
 =?us-ascii?Q?+lVIFjb9SlQ1kgs0tfDeRHij/HCBhrBfkTpYElosZfy0tJZUD2+3DCwGnCKN?=
 =?us-ascii?Q?dEYYxZIuWliv1kqBR5htsc53zXd8sqbv0zjSR2NPb7AvsH7avTPLLE8yGbe9?=
 =?us-ascii?Q?lsKqK/WjR53yF8morC0WTpZbX+/TPNWNyTGpi0hiiCBulz8drK8mQu51rj4/?=
 =?us-ascii?Q?wmYwS2+qo2NOUTzAoe1ppXhn989Ew0KUs1n0q7niEnYe/5Qek1a7mA40ndqc?=
 =?us-ascii?Q?j/cwh7vu0itw0NknHp11kp9VgqF346RjBeSP/ADxtvxmV+XOgnfBpjF+C1Jo?=
 =?us-ascii?Q?5AadWSXeT/XWZNZY7pVlCUXUwAtnvr9BqZ+eMqYMmnmLDTQnwh0oSuwPchQ/?=
 =?us-ascii?Q?jeHXeTPM7VdE91r8V8IJqnoiZ/zLrhB4x3wYx3fCwKdWGbn83iIYCjUjqxj0?=
 =?us-ascii?Q?9tIaZf4tttUfG2sssmuU7SpFMJphwanh5di+Gb17wjq7GUDk/c5D2KlwVx9D?=
 =?us-ascii?Q?Zn+uiXhbEXqvOBSdDPXmnkoha400+ccYaGYsIgG9s49qyCeR4mlfaX7ztCAR?=
 =?us-ascii?Q?LOpxy9KGe3Q4/sdrpxZLmKHoZXKVJcncAOu23dbPrvvEeQ29kAAHy8rkTSWc?=
 =?us-ascii?Q?aqcSh5g6xysXITppQxApDEmoGNceXKkfbyE0S8KACWykz8k4D058AgTHnQec?=
 =?us-ascii?Q?C+l4A5wMR8rLMnV3f2dDPaKMiID9ZrfxcTkRuI2XAuaJ5fMs20GoQjHKKHRH?=
 =?us-ascii?Q?jG/FpOz44rIwMHiOJJlmFAYqFGo2JfuK6y7AzccUbbAWK/HJCOkbeOHUP2cl?=
 =?us-ascii?Q?FyFBFWzFXHk0Uc+ApYT7IiEPC0lQKqfz5XzWx5bgGIWvBBZDQGTs6ysDqXU8?=
 =?us-ascii?Q?ebSfEVGC7gY4Am5LjfSPFw4WEbLXNnlir3VHT3/IWJQD0qJcOcqnELFNYJgy?=
 =?us-ascii?Q?pPjhRlN0dkIfb1wGm1/qIaaAdVgv2wOJkVkmBsfFmJIHPDyuVcRv8/TEfZW6?=
 =?us-ascii?Q?WyDfxXnlQjwuVoYtxR6OvsYJsoWiP1xOp3D4SB4fbTo25edcZAhU0x59kM3j?=
 =?us-ascii?Q?86K0oT+G3G9Ucuy+FBta4Ah6VVcTFNtMkVTeKxHaEwgxvdbFrZsOT/Hvz8xp?=
 =?us-ascii?Q?ldWn6yR90g=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 434e0bf2-7876-4da2-2b20-08da4e44a4e7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1223.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 20:29:55.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEgbKHgmls6nkf1ptH1DXxztH7C+Wnn3VPU+dr0fIg9qhG9504cVsreZjr5i8w4+jSfgg96ZMdm/Y9cXT4UDBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3314
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a handler of the XDP_REDIRECT return code from a XDP program. The
packets will be flushed at the end of each RX/CQ NAPI poll cycle.
ndo_xdp_xmit() is implemented by sharing the code in mana_xdp_tx().
Ethtool per queue counters are added for XDP redirect and xmit operations.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  6 ++
 .../net/ethernet/microsoft/mana/mana_bpf.c    | 64 +++++++++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 13 +++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 12 +++-
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index f198b34c232f..d58be64374c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -53,12 +53,14 @@ struct mana_stats_rx {
 	u64 bytes;
 	u64 xdp_drop;
 	u64 xdp_tx;
+	u64 xdp_redirect;
 	struct u64_stats_sync syncp;
 };
 
 struct mana_stats_tx {
 	u64 packets;
 	u64 bytes;
+	u64 xdp_xmit;
 	struct u64_stats_sync syncp;
 };
 
@@ -311,6 +313,8 @@ struct mana_rxq {
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
 	struct page *xdp_save_page;
+	bool xdp_flush;
+	int xdp_rc; /* XDP redirect return code */
 
 	/* MUST BE THE LAST MEMBER:
 	 * Each receive buffer has an associated mana_recv_buf_oob.
@@ -396,6 +400,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming);
 void mana_remove(struct gdma_dev *gd, bool suspending);
 
 void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
+int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
+		  u32 flags);
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 1d2f948b5c00..421fd39ff3a8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -32,9 +32,55 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
 	ndev->stats.tx_dropped++;
 }
 
+static int mana_xdp_xmit_fm(struct net_device *ndev, struct xdp_frame *frame,
+			    u16 q_idx)
+{
+	struct sk_buff *skb;
+
+	skb = xdp_build_skb_from_frame(frame, ndev);
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	skb_set_queue_mapping(skb, q_idx);
+
+	mana_xdp_tx(skb, ndev);
+
+	return 0;
+}
+
+int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
+		  u32 flags)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	struct mana_stats_tx *tx_stats;
+	int i, count = 0;
+	u16 q_idx;
+
+	if (unlikely(!apc->port_is_up))
+		return 0;
+
+	q_idx = smp_processor_id() % ndev->real_num_tx_queues;
+
+	for (i = 0; i < n; i++) {
+		if (mana_xdp_xmit_fm(ndev, frames[i], q_idx))
+			break;
+
+		count++;
+	}
+
+	tx_stats = &apc->tx_qp[q_idx].txq.stats;
+
+	u64_stats_update_begin(&tx_stats->syncp);
+	tx_stats->xdp_xmit += count;
+	u64_stats_update_end(&tx_stats->syncp);
+
+	return count;
+}
+
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
 {
+	struct mana_stats_rx *rx_stats;
 	struct bpf_prog *prog;
 	u32 act = XDP_PASS;
 
@@ -49,12 +95,30 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
+	rx_stats = &rxq->stats;
+
 	switch (act) {
 	case XDP_PASS:
 	case XDP_TX:
 	case XDP_DROP:
 		break;
 
+	case XDP_REDIRECT:
+		rxq->xdp_rc = xdp_do_redirect(ndev, xdp, prog);
+		if (!rxq->xdp_rc) {
+			rxq->xdp_flush = true;
+
+			u64_stats_update_begin(&rx_stats->syncp);
+			rx_stats->packets++;
+			rx_stats->bytes += pkt_len;
+			rx_stats->xdp_redirect++;
+			u64_stats_update_end(&rx_stats->syncp);
+
+			break;
+		}
+
+		fallthrough;
+
 	case XDP_ABORTED:
 		trace_xdp_exception(ndev, prog, act);
 		break;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 3ef09e0cdbaa..9259a74eca40 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -6,6 +6,7 @@
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/filter.h>
 #include <linux/mm.h>
 
 #include <net/checksum.h>
@@ -382,6 +383,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_get_stats64	= mana_get_stats64,
 	.ndo_bpf		= mana_bpf,
+	.ndo_xdp_xmit		= mana_xdp_xmit,
 };
 
 static void mana_cleanup_port_context(struct mana_port_context *apc)
@@ -1120,6 +1122,9 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 
 	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
 
+	if (act == XDP_REDIRECT && !rxq->xdp_rc)
+		return;
+
 	if (act != XDP_PASS && act != XDP_TX)
 		goto drop_xdp;
 
@@ -1275,11 +1280,14 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 static void mana_poll_rx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *comp = cq->gdma_comp_buf;
+	struct mana_rxq *rxq = cq->rxq;
 	int comp_read, i;
 
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
 	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
 
+	rxq->xdp_flush = false;
+
 	for (i = 0; i < comp_read; i++) {
 		if (WARN_ON_ONCE(comp[i].is_sq))
 			return;
@@ -1288,8 +1296,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 		if (WARN_ON_ONCE(comp[i].wq_num != cq->rxq->gdma_id))
 			return;
 
-		mana_process_rx_cqe(cq->rxq, cq, &comp[i]);
+		mana_process_rx_cqe(rxq, cq, &comp[i]);
 	}
+
+	if (rxq->xdp_flush)
+		xdp_do_flush();
 }
 
 static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index e13f2453eabb..c530db76880f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -23,7 +23,7 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	if (stringset != ETH_SS_STATS)
 		return -EINVAL;
 
-	return ARRAY_SIZE(mana_eth_stats) + num_queues * 6;
+	return ARRAY_SIZE(mana_eth_stats) + num_queues * 8;
 }
 
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
@@ -50,6 +50,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "rx_%d_xdp_tx", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "rx_%d_xdp_redirect", i);
+		p += ETH_GSTRING_LEN;
 	}
 
 	for (i = 0; i < num_queues; i++) {
@@ -57,6 +59,8 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "tx_%d_bytes", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_xdp_xmit", i);
+		p += ETH_GSTRING_LEN;
 	}
 }
 
@@ -70,6 +74,8 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	struct mana_stats_tx *tx_stats;
 	unsigned int start;
 	u64 packets, bytes;
+	u64 xdp_redirect;
+	u64 xdp_xmit;
 	u64 xdp_drop;
 	u64 xdp_tx;
 	int q, i = 0;
@@ -89,12 +95,14 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			bytes = rx_stats->bytes;
 			xdp_drop = rx_stats->xdp_drop;
 			xdp_tx = rx_stats->xdp_tx;
+			xdp_redirect = rx_stats->xdp_redirect;
 		} while (u64_stats_fetch_retry_irq(&rx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_drop;
 		data[i++] = xdp_tx;
+		data[i++] = xdp_redirect;
 	}
 
 	for (q = 0; q < num_queues; q++) {
@@ -104,10 +112,12 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			start = u64_stats_fetch_begin_irq(&tx_stats->syncp);
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
+			xdp_xmit = tx_stats->xdp_xmit;
 		} while (u64_stats_fetch_retry_irq(&tx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
+		data[i++] = xdp_xmit;
 	}
 }
 
-- 
2.25.1

