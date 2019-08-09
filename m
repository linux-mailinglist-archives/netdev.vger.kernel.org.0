Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5EE86FA2
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfHICdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:33:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405094AbfHICdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:36 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2AA94CEA7D7FB814504F;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/12] net: hns3: add some statitics info to tx process
Date:   Fri, 9 Aug 2019 10:31:13 +0800
Message-ID: <1565317878-31806-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch adds tx_vlan_err, tx_l4_proto_err, tx_l2l3l4_err
and tx_tso_err counter to tx process, in order to better
debug the desc filling error.

This patch also adds a missing u64_stats_update_* around
ring->stats.sw_err_cnt and adds hns3_rl_err to limit the
error printing in the IO patch.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 58 ++++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  4 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  4 ++
 3 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fd6a3d5..b2a668d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -28,6 +28,12 @@
 #define hns3_set_field(origin, shift, val)	((origin) |= ((val) << (shift)))
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
+#define hns3_rl_err(fmt, ...)						\
+	do {								\
+		if (net_ratelimit())					\
+			netdev_err(fmt, ##__VA_ARGS__);			\
+	} while (0)
+
 static void hns3_clear_all_ring(struct hnae3_handle *h, bool force);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
@@ -1033,6 +1039,9 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 	ret = hns3_handle_vtags(ring, skb);
 	if (unlikely(ret < 0)) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.tx_vlan_err++;
+		u64_stats_update_end(&ring->syncp);
 		return ret;
 	} else if (ret == HNS3_INNER_VLAN_TAG) {
 		inner_vtag = skb_vlan_tag_get(skb);
@@ -1053,19 +1062,31 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		skb_reset_mac_len(skb);
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.tx_l4_proto_err++;
+			u64_stats_update_end(&ring->syncp);
 			return ret;
+		}
 
 		ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
 				      &type_cs_vlan_tso,
 				      &ol_type_vlan_len_msec);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.tx_l2l3l4_err++;
+			u64_stats_update_end(&ring->syncp);
 			return ret;
+		}
 
 		ret = hns3_set_tso(skb, &paylen, &mss,
 				   &type_cs_vlan_tso);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			u64_stats_update_begin(&ring->syncp);
+			ring->stats.tx_tso_err++;
+			u64_stats_update_end(&ring->syncp);
 			return ret;
+		}
 	}
 
 	/* Set txbd */
@@ -1107,7 +1128,9 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	if (unlikely(dma_mapping_error(dev, dma))) {
+		u64_stats_update_begin(&ring->syncp);
 		ring->stats.sw_err_cnt++;
+		u64_stats_update_end(&ring->syncp);
 		return -ENOMEM;
 	}
 
@@ -1330,9 +1353,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 			u64_stats_update_end(&ring->syncp);
 		}
 
-		if (net_ratelimit())
-			netdev_err(netdev, "xmit error: %d!\n", buf_num);
-
+		hns3_rl_err(netdev, "xmit error: %d!\n", buf_num);
 		goto out_err_tx_ok;
 	}
 
@@ -1498,7 +1519,15 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 			tx_bytes += ring->stats.tx_bytes;
 			tx_pkts += ring->stats.tx_pkts;
 			tx_drop += ring->stats.sw_err_cnt;
+			tx_drop += ring->stats.tx_vlan_err;
+			tx_drop += ring->stats.tx_l4_proto_err;
+			tx_drop += ring->stats.tx_l2l3l4_err;
+			tx_drop += ring->stats.tx_tso_err;
 			tx_errors += ring->stats.sw_err_cnt;
+			tx_errors += ring->stats.tx_vlan_err;
+			tx_errors += ring->stats.tx_l4_proto_err;
+			tx_errors += ring->stats.tx_l2l3l4_err;
+			tx_errors += ring->stats.tx_tso_err;
 		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
 
 		/* fetch the rx stats */
@@ -2382,8 +2411,9 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				ring->stats.sw_err_cnt++;
 				u64_stats_update_end(&ring->syncp);
 
-				netdev_err(ring->tqp->handle->kinfo.netdev,
-					   "hnae reserve buffer map failed.\n");
+				hns3_rl_err(ring->tqp_vector->napi.dev,
+					    "alloc rx buffer failed: %d\n",
+					    ret);
 				break;
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
@@ -2468,9 +2498,9 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 		th->check = ~tcp_v6_check(skb->len - depth, &iph->saddr,
 					  &iph->daddr, 0);
 	} else {
-		netdev_err(skb->dev,
-			   "Error: FW GRO supports only IPv4/IPv6, not 0x%04x, depth: %d\n",
-			   be16_to_cpu(type), depth);
+		hns3_rl_err(skb->dev,
+			    "Error: FW GRO supports only IPv4/IPv6, not 0x%04x, depth: %d\n",
+			    be16_to_cpu(type), depth);
 		return -EFAULT;
 	}
 
@@ -2612,7 +2642,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	ring->skb = napi_alloc_skb(&ring->tqp_vector->napi, HNS3_RX_HEAD_SIZE);
 	skb = ring->skb;
 	if (unlikely(!skb)) {
-		netdev_err(netdev, "alloc rx skb fail\n");
+		hns3_rl_err(netdev, "alloc rx skb fail\n");
 
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.sw_err_cnt++;
@@ -2687,8 +2717,8 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 			new_skb = napi_alloc_skb(&ring->tqp_vector->napi,
 						 HNS3_RX_HEAD_SIZE);
 			if (unlikely(!new_skb)) {
-				netdev_err(ring->tqp->handle->kinfo.netdev,
-					   "alloc rx skb frag fail\n");
+				hns3_rl_err(ring->tqp_vector->napi.dev,
+					    "alloc rx fraglist skb fail\n");
 				return -ENXIO;
 			}
 			ring->frag_num = 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 0a970f5..a76712c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -377,6 +377,10 @@ struct ring_stats {
 			u64 restart_queue;
 			u64 tx_busy;
 			u64 tx_copy;
+			u64 tx_vlan_err;
+			u64 tx_l4_proto_err;
+			u64 tx_l2l3l4_err;
+			u64 tx_tso_err;
 		};
 		struct {
 			u64 rx_pkts;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 02f46c7..185ff32 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -30,6 +30,10 @@ static const struct hns3_stats hns3_txq_stats[] = {
 	HNS3_TQP_STAT("wake", restart_queue),
 	HNS3_TQP_STAT("busy", tx_busy),
 	HNS3_TQP_STAT("copy", tx_copy),
+	HNS3_TQP_STAT("vlan_err", tx_vlan_err),
+	HNS3_TQP_STAT("l4_proto_err", tx_l4_proto_err),
+	HNS3_TQP_STAT("l2l3l4_err", tx_l2l3l4_err),
+	HNS3_TQP_STAT("tso_err", tx_tso_err),
 };
 
 #define HNS3_TXQ_STATS_COUNT ARRAY_SIZE(hns3_txq_stats)
-- 
2.7.4

