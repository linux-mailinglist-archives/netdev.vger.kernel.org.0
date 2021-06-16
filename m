Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322CE3A92DA
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhFPGmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:42:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4800 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhFPGlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4b533xc8zWtQx;
        Wed, 16 Jun 2021 14:34:31 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: use bounce buffer when rx page can not be reused
Date:   Wed, 16 Jun 2021 14:36:17 +0800
Message-ID: <1623825377-41948-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
References: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently rx page will be reused to receive future packet when
the stack releases the previous skb quickly. If the old page
can not be reused, a new page will be allocated and mapped,
which comsumes a lot of cpu when IOMMU is in the strict mode,
especially when the application and irq/NAPI happens to run on
the same cpu.

So allocate a new frag to memcpy the data to avoid the costly
IOMMU unmapping/mapping operation, and add "frag_alloc_err"
and "frag_alloc" stats in "ethtool -S ethX" cmd.

The throughput improves above 50% when running single thread of
iperf using TCP when IOMMU is in strict mode and iperf shares the
same cpu with irq/NAPI(rx_copybreak = 2048 and mtu = 1500).

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 23 ++++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 +++++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a24a75c47cad..34b6cd904a1a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -450,6 +450,7 @@ static const struct hns3_dbg_item rx_queue_info_items[] = {
 	{ "HEAD", 2 },
 	{ "FBDNUM", 2 },
 	{ "PKTNUM", 2 },
+	{ "COPYBREAK", 2 },
 	{ "RING_EN", 2 },
 	{ "RX_RING_EN", 2 },
 	{ "BASE_ADDR", 10 },
@@ -481,6 +482,7 @@ static void hns3_dump_rx_queue_info(struct hns3_enet_ring *ring,
 
 	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_RX_RING_PKTNUM_RECORD_REG));
+	sprintf(result[j++], "%9u", ring->rx_copybreak);
 
 	sprintf(result[j++], "%7s", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_EN_REG) ? "on" : "off");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 98e8a548edb8..51bbf5f760c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3552,6 +3552,28 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		   hns3_page_size(ring)) {
 		desc_cb->page_offset += truesize;
 		desc_cb->reuse_flag = 1;
+	} else if (frag_size <= ring->rx_copybreak) {
+		void *frag = napi_alloc_frag(frag_size);
+
+		if (unlikely(!frag)) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.frag_alloc_err++;
+			u64_stats_update_end(&ring->syncp);
+
+			hns3_rl_err(ring_to_netdev(ring),
+				    "failed to allocate rx frag\n");
+			goto out;
+		}
+
+		desc_cb->reuse_flag = 1;
+		memcpy(frag, desc_cb->buf + frag_offset, frag_size);
+		skb_add_rx_frag(skb, i, virt_to_page(frag),
+				offset_in_page(frag), frag_size, frag_size);
+
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.frag_alloc++;
+		u64_stats_update_end(&ring->syncp);
+		return;
 	}
 
 out:
@@ -4620,6 +4642,7 @@ static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 		ring = &priv->ring[q->tqp_index + queue_num];
 		desc_num = priv->ae_handle->kinfo.num_rx_desc;
 		ring->queue_index = q->tqp_index;
+		ring->rx_copybreak = priv->rx_copybreak;
 	}
 
 	hnae3_set_bit(ring->flag, HNAE3_RING_TYPE_B, ring_type);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 22ae291471aa..15af3d93857b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -427,6 +427,8 @@ struct ring_stats {
 			u64 csum_complete;
 			u64 rx_multicast;
 			u64 non_reuse_pg;
+			u64 frag_alloc_err;
+			u64 frag_alloc;
 		};
 		__le16 csum;
 	};
@@ -478,6 +480,7 @@ struct hns3_enet_ring {
 		/* for Rx ring */
 		struct {
 			u32 pull_len;   /* memcpy len for current rx packet */
+			u32 rx_copybreak;
 			u32 frag_num;
 			/* first buffer address for current packet */
 			unsigned char *va;
@@ -569,6 +572,7 @@ struct hns3_nic_priv {
 	struct hns3_enet_coalesce tx_coal;
 	struct hns3_enet_coalesce rx_coal;
 	u32 tx_copybreak;
+	u32 rx_copybreak;
 };
 
 union l3_hdr_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index d7852716aaad..82061ab6930f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -71,6 +71,8 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 	HNS3_TQP_STAT("csum_complete", csum_complete),
 	HNS3_TQP_STAT("multicast", rx_multicast),
 	HNS3_TQP_STAT("non_reuse_pg", non_reuse_pg),
+	HNS3_TQP_STAT("frag_alloc_err", frag_alloc_err),
+	HNS3_TQP_STAT("frag_alloc", frag_alloc),
 };
 
 #define HNS3_PRIV_FLAGS_LEN ARRAY_SIZE(hns3_priv_flags)
@@ -1610,6 +1612,9 @@ static int hns3_get_tunable(struct net_device *netdev,
 		/* all the tx rings have the same tx_copybreak */
 		*(u32 *)data = priv->tx_copybreak;
 		break;
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)data = priv->rx_copybreak;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1634,6 +1639,13 @@ static int hns3_set_tunable(struct net_device *netdev,
 			priv->ring[i].tx_copybreak = priv->tx_copybreak;
 
 		break;
+	case ETHTOOL_RX_COPYBREAK:
+		priv->rx_copybreak = *(u32 *)data;
+
+		for (i = h->kinfo.num_tqps; i < h->kinfo.num_tqps * 2; i++)
+			priv->ring[i].rx_copybreak = priv->rx_copybreak;
+
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.8.1

