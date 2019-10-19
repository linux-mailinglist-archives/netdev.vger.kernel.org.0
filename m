Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40398DD742
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfJSID2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:03:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727233AbfJSID2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:03:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D39B648A6D6418EDE745;
        Sat, 19 Oct 2019 16:03:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 19 Oct 2019 16:03:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/8] net: hns3: introduce ring_to_netdev() in enet module
Date:   Sat, 19 Oct 2019 16:03:52 +0800
Message-ID: <1571472236-17401-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
References: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

There are a few places that need to access the netdev of a ring
through ring->tqp->handle->kinfo.netdev, and ring->tqp is a struct
which both in enet and hclge modules, it is better to use the
struct that is only used in enet module.

This patch adds the ring_to_netdev() to access the netdev of ring
through ring->tqp_vector->napi.dev.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 14 +++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 089cd58..422fa4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2478,7 +2478,7 @@ static int is_valid_clean_head(struct hns3_enet_ring *ring, int h)
 
 void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 {
-	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
+	struct net_device *netdev = ring_to_netdev(ring);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct netdev_queue *dev_queue;
 	int bytes, pkts;
@@ -2560,7 +2560,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				ring->stats.sw_err_cnt++;
 				u64_stats_update_end(&ring->syncp);
 
-				hns3_rl_err(ring->tqp_vector->napi.dev,
+				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
 					    ret);
 				break;
@@ -2669,7 +2669,7 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 			     u32 l234info, u32 bd_base_info, u32 ol_info)
 {
-	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
+	struct net_device *netdev = ring_to_netdev(ring);
 	int l3_type, l4_type;
 	int ol4_type;
 
@@ -2785,7 +2785,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 {
 #define HNS3_NEED_ADD_FRAG	1
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_clean];
-	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
+	struct net_device *netdev = ring_to_netdev(ring);
 	struct sk_buff *skb;
 
 	ring->skb = napi_alloc_skb(&ring->tqp_vector->napi, HNS3_RX_HEAD_SIZE);
@@ -2866,7 +2866,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 			new_skb = napi_alloc_skb(&ring->tqp_vector->napi,
 						 HNS3_RX_HEAD_SIZE);
 			if (unlikely(!new_skb)) {
-				hns3_rl_err(ring->tqp_vector->napi.dev,
+				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx fraglist skb fail\n");
 				return -ENXIO;
 			}
@@ -2942,7 +2942,7 @@ static void hns3_set_rx_skb_rss_type(struct hns3_enet_ring *ring,
 
 static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 {
-	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
+	struct net_device *netdev = ring_to_netdev(ring);
 	enum hns3_pkt_l2t_type l2_frame_type;
 	u32 bd_base_info, l234info, ol_info;
 	struct hns3_desc *desc;
@@ -4224,7 +4224,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 				/* if alloc new buffer fail, exit directly
 				 * and reclear in up flow.
 				 */
-				netdev_warn(ring->tqp->handle->kinfo.netdev,
+				netdev_warn(ring_to_netdev(ring),
 					    "reserve buffer map failed, ret = %d\n",
 					    ret);
 				return ret;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 3322284..8a88002 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -607,6 +607,8 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define ring_to_dev(ring) ((ring)->dev)
 
+#define ring_to_netdev(ring)	((ring)->tqp_vector->napi.dev)
+
 #define ring_to_dma_dir(ring) (HNAE3_IS_TX_RING(ring) ? \
 	DMA_TO_DEVICE : DMA_FROM_DEVICE)
 
-- 
2.7.4

