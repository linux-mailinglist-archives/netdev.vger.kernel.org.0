Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3DD13002E
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgADCth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727194AbgADCtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:36 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8B550A92ABB75064EB55;
        Sat,  4 Jan 2020 10:49:32 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:26 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: add trace event support for HNS3 driver
Date:   Sat, 4 Jan 2020 10:49:24 +0800
Message-ID: <1578106171-17238-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This adds trace support for HNS3 driver. It also declares
some events which could be used to trace the events when a
TX/RX BD is processed, and other events which are related to
the processing of sk_buff, such as TSO, GRO.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile     |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c  |  32 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h  |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h | 139 +++++++++++++++++++++++
 4 files changed, 172 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index d01bf53..7aa2fac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the HISILICON network device drivers.
 #
 
+ccflags-y += -I$(srctree)/$(src)
+
 obj-$(CONFIG_HNS3) += hns3pf/
 obj-$(CONFIG_HNS3) += hns3vf/
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index aee5fac..9a0694a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -24,6 +24,12 @@
 
 #include "hnae3.h"
 #include "hns3_enet.h"
+/* All hns3 tracepoints are defined by the include below, which
+ * must be included exactly once across the whole kernel with
+ * CREATE_TRACE_POINTS defined
+ */
+#define CREATE_TRACE_POINTS
+#include "hns3_trace.h"
 
 #define hns3_set_field(origin, shift, val)	((origin) |= ((val) << (shift)))
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
@@ -734,6 +740,8 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 	/* get MSS for TSO */
 	*mss = skb_shinfo(skb)->gso_size;
 
+	trace_hns3_tso(skb);
+
 	return 0;
 }
 
@@ -1138,6 +1146,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
 			cpu_to_le16(BIT(HNS3_TXD_VLD_B));
 
+		trace_hns3_tx_desc(ring, ring->next_to_use);
 		ring_ptr_move_fw(ring, next_to_use);
 		return HNS3_LIKELY_BD_NUM;
 	}
@@ -1161,6 +1170,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
 				cpu_to_le16(BIT(HNS3_TXD_VLD_B));
 
+		trace_hns3_tx_desc(ring, ring->next_to_use);
 		/* move ring pointer to next */
 		ring_ptr_move_fw(ring, next_to_use);
 
@@ -1286,6 +1296,14 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
 	return false;
 }
 
+void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size)
+{
+	int i = 0;
+
+	for (i = 0; i < MAX_SKB_FRAGS; i++)
+		size[i] = skb_frag_size(&shinfo->frags[i]);
+}
+
 static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct net_device *netdev,
 				  struct sk_buff *skb)
@@ -1297,8 +1315,10 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 	bd_num = hns3_tx_bd_num(skb, bd_size);
 	if (unlikely(bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
-		    !hns3_skb_need_linearized(skb, bd_size, bd_num))
+		    !hns3_skb_need_linearized(skb, bd_size, bd_num)) {
+			trace_hns3_over_8bd(skb);
 			goto out;
+		}
 
 		if (__skb_linearize(skb))
 			return -ENOMEM;
@@ -1306,8 +1326,10 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		bd_num = hns3_tx_bd_count(skb->len);
 		if ((skb_is_gso(skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
 		    (!skb_is_gso(skb) &&
-		     bd_num > HNS3_MAX_NON_TSO_BD_NUM))
+		     bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
+			trace_hns3_over_8bd(skb);
 			return -ENOMEM;
+		}
 
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.tx_copy++;
@@ -1448,6 +1470,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 					(ring->desc_num - 1);
 	ring->desc[pre_ntu].tx.bdtp_fe_sc_vld_ra_ri |=
 				cpu_to_le16(BIT(HNS3_TXD_FE_B));
+	trace_hns3_tx_desc(ring, pre_ntu);
 
 	/* Complete translate all packets */
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
@@ -2700,6 +2723,9 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	skb->csum_start = (unsigned char *)th - skb->head;
 	skb->csum_offset = offsetof(struct tcphdr, check);
 	skb->ip_summed = CHECKSUM_PARTIAL;
+
+	trace_hns3_gro(skb);
+
 	return 0;
 }
 
@@ -2836,6 +2862,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		return -ENOMEM;
 	}
 
+	trace_hns3_rx_desc(ring);
 	prefetchw(skb->data);
 
 	ring->pending_buf = 1;
@@ -2910,6 +2937,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 		}
 
 		hns3_nic_reuse_page(skb, ring->frag_num++, ring, 0, desc_cb);
+		trace_hns3_rx_desc(ring);
 		ring_ptr_move_fw(ring, next_to_clean);
 		ring->pending_buf++;
 	} while (!(bd_base_info & BIT(HNS3_RXD_FE_B)));
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9d47abd..abefd7a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -673,4 +673,5 @@ void hns3_dbg_init(struct hnae3_handle *handle);
 void hns3_dbg_uninit(struct hnae3_handle *handle);
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
+void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
new file mode 100644
index 0000000..7bddcca
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (c) 2018-2019 Hisilicon Limited. */
+
+/* This must be outside ifdef _HNS3_TRACE_H */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hns3
+
+#if !defined(_HNS3_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _HNS3_TRACE_H_
+
+#include <linux/tracepoint.h>
+
+#define DESC_NR		(sizeof(struct hns3_desc) / sizeof(u32))
+
+DECLARE_EVENT_CLASS(hns3_skb_template,
+	TP_PROTO(struct sk_buff *skb),
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, headlen)
+		__field(unsigned int, len)
+		__field(__u8, nr_frags)
+		__field(__u8, ip_summed)
+		__field(unsigned int, hdr_len)
+		__field(unsigned short, gso_size)
+		__field(unsigned short, gso_segs)
+		__field(unsigned int, gso_type)
+		__field(bool, fraglist)
+		__array(__u32, size, MAX_SKB_FRAGS)
+	),
+
+	TP_fast_assign(
+		__entry->headlen = skb_headlen(skb);
+		__entry->len = skb->len;
+		__entry->nr_frags = skb_shinfo(skb)->nr_frags;
+		__entry->gso_size = skb_shinfo(skb)->gso_size;
+		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
+		__entry->gso_type = skb_shinfo(skb)->gso_type;
+		__entry->hdr_len = skb->encapsulation ?
+		skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb) :
+		skb_transport_offset(skb) + tcp_hdrlen(skb);
+		__entry->ip_summed = skb->ip_summed;
+		__entry->fraglist = skb_has_frag_list(skb);
+		hns3_shinfo_pack(skb_shinfo(skb), __entry->size);
+	),
+
+	TP_printk(
+		"len: %u, %u, %u, cs: %u, gso: %u, %u, %x, frag(%d %u): %s",
+		__entry->headlen, __entry->len, __entry->hdr_len,
+		__entry->ip_summed, __entry->gso_size, __entry->gso_segs,
+		__entry->gso_type, __entry->fraglist, __entry->nr_frags,
+		__print_array(__entry->size, MAX_SKB_FRAGS, sizeof(__u32))
+	)
+);
+
+DEFINE_EVENT(hns3_skb_template, hns3_over_8bd,
+	TP_PROTO(struct sk_buff *skb),
+	TP_ARGS(skb));
+
+DEFINE_EVENT(hns3_skb_template, hns3_gro,
+	TP_PROTO(struct sk_buff *skb),
+	TP_ARGS(skb));
+
+DEFINE_EVENT(hns3_skb_template, hns3_tso,
+	TP_PROTO(struct sk_buff *skb),
+	TP_ARGS(skb));
+
+TRACE_EVENT(hns3_tx_desc,
+	TP_PROTO(struct hns3_enet_ring *ring, int cur_ntu),
+	TP_ARGS(ring, cur_ntu),
+
+	TP_STRUCT__entry(
+		__field(int, index)
+		__field(int, ntu)
+		__field(int, ntc)
+		__field(dma_addr_t, desc_dma)
+		__array(u32, desc, DESC_NR)
+		__string(devname, ring->tqp->handle->kinfo.netdev->name)
+	),
+
+	TP_fast_assign(
+		__entry->index = ring->tqp->tqp_index;
+		__entry->ntu = ring->next_to_use;
+		__entry->ntc = ring->next_to_clean;
+		__entry->desc_dma = ring->desc_dma_addr,
+		memcpy(__entry->desc, &ring->desc[cur_ntu],
+		       sizeof(struct hns3_desc));
+		__assign_str(devname, ring->tqp->handle->kinfo.netdev->name);
+	),
+
+	TP_printk(
+		"%s-%d-%d/%d desc(%pad): %s",
+		__get_str(devname), __entry->index, __entry->ntu,
+		__entry->ntc, &__entry->desc_dma,
+		__print_array(__entry->desc, DESC_NR, sizeof(u32))
+	)
+);
+
+TRACE_EVENT(hns3_rx_desc,
+	TP_PROTO(struct hns3_enet_ring *ring),
+	TP_ARGS(ring),
+
+	TP_STRUCT__entry(
+		__field(int, index)
+		__field(int, ntu)
+		__field(int, ntc)
+		__field(dma_addr_t, desc_dma)
+		__field(dma_addr_t, buf_dma)
+		__array(u32, desc, DESC_NR)
+		__string(devname, ring->tqp->handle->kinfo.netdev->name)
+	),
+
+	TP_fast_assign(
+		__entry->index = ring->tqp->tqp_index;
+		__entry->ntu = ring->next_to_use;
+		__entry->ntc = ring->next_to_clean;
+		__entry->desc_dma = ring->desc_dma_addr;
+		__entry->buf_dma = ring->desc_cb[ring->next_to_clean].dma;
+		memcpy(__entry->desc, &ring->desc[ring->next_to_clean],
+		       sizeof(struct hns3_desc));
+		__assign_str(devname, ring->tqp->handle->kinfo.netdev->name);
+	),
+
+	TP_printk(
+		"%s-%d-%d/%d desc(%pad) buf(%pad): %s",
+		__get_str(devname), __entry->index, __entry->ntu,
+		__entry->ntc, &__entry->desc_dma, &__entry->buf_dma,
+		__print_array(__entry->desc, DESC_NR, sizeof(u32))
+	)
+);
+
+#endif /* _HNS3_TRACE_H_ */
+
+/* This must be outside ifdef _HNS3_TRACE_H */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE hns3_trace
+#include <trace/define_trace.h>
-- 
2.7.4

