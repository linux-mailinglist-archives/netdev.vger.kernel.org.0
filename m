Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685EE678F6D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 05:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjAXEpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 23:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAXEpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 23:45:46 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C2261A8
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 20:45:42 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w2so10395660pfc.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 20:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oS+AoklM4p5FTffaRkd4QneWGtnN/OSqXuDDZyQvaxY=;
        b=HaJDENTmdTN1L2wSIXWpekst2JOv0b7TBhr8Vd0a/cKB5iugLWF20+sQlUZo5K/BMW
         OVftbzwXW2xIm55ifS8cQp1es48N/QMzjHb9LZCfY2wSip1uHiQkfvg1sNUV2xQeDj+H
         drcNKWbdLMkvColZYzvmB7QU4sII/s5tRdE98PM95KR71rr/kTXF8RjzV2s7rSntX/ZK
         nw9wpohIwaPZUQtXu88G6cWbE5Z9WTY3HrcjhpvBR5qggKKWF3kPYgc9N8aWlhApJPyc
         SO8v6yAZfJA78jjTHt2KWTbdRlXOFgxV76wZZujnGLeaVp0WzPdbQWX1PGq3CPirucCI
         Eqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oS+AoklM4p5FTffaRkd4QneWGtnN/OSqXuDDZyQvaxY=;
        b=SGUjXfrRfnwzdLdvGxD7UaEdtZBavJLgt0rcS4UdHYrB3WJW0EA0fBiTWPz/AdbP0d
         eiuXgt/3p6pN5zil3BF/NsKQQ2ZB07lvD2v2Fxvak89/fI104qku2E3/SmZcP/yaWlo8
         qIxIZ56ca9bDIL65uFn/Ng74U2cvNgBffpKFhNfalL7t7P2udDRt5NWUt/OaNtqjQaGP
         92+XADI/JT/oKtOWR2QLpnieB01MtSuxlh22e9ENeJh8s26/BVFf+PkJXNCBS2DJv5bw
         2X/1WppRG9yPHlsLD+tdRIjmeu2owABJxOs1ouKvE5FAr+c3fzOl5JtvhhzOEIBL4VfX
         hysw==
X-Gm-Message-State: AFqh2kqJc+7g4pUprUx8OmFcZF1yE/4MqzEsDakMdHhtHNu+s/i1XlF6
        ziZFvyGHchlvOEy53FS9EY3bUPZOGYlsQg==
X-Google-Smtp-Source: AMrXdXuyc6hZ5JsVhRAP+pw9fLCkAoYN77ypPDHUOQ3KmfVuNlhdxWWKX+8EvksUhnPvbiJ2UsC+Jw==
X-Received: by 2002:aa7:8d11:0:b0:587:f436:6ea8 with SMTP id j17-20020aa78d11000000b00587f4366ea8mr24191522pfe.16.1674535541714;
        Mon, 23 Jan 2023 20:45:41 -0800 (PST)
Received: from witu-mlt.nvidia.com ([209.37.218.67])
        by smtp.gmail.com with ESMTPSA id e30-20020aa798de000000b0056283e2bdbdsm449722pfm.138.2023.01.23.20.45.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jan 2023 20:45:41 -0800 (PST)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jsankararama@vmware.com, gyang@vmware.com, doshir@vmware.com,
        alexander.duyck@gmail.com, alexandr.lobakin@intel.com,
        bang@vmware.com, Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [RFC PATCH net-next v14] vmxnet3: Add XDP support.
Date:   Mon, 23 Jan 2023 20:45:15 -0800
Message-Id: <20230124044515.17377-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

Background:
The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
mapped to the ring's descriptor. If LRO is enabled and packet size larger
than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
allocated using alloc_page. So for LRO packets, the payload will be in one
buffer from r0 and multiple from r1, for non-LRO packets, only one
descriptor in r0 is used for packet size less than 3k.

When receiving a packet, the first descriptor will have the sop (start of
packet) bit set, and the last descriptor will have the eop (end of packet)
bit set. Non-LRO packets will have only one descriptor with both sop and
eop set.

Other than r0 and r1, vmxnet3 dataring is specifically designed for
handling packets with small size, usually 128 bytes, defined in
VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
order to avoid memory mapping/unmapping overhead. In summary, packet size:
    A. < 128B: use dataring
    B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
    C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
As a result, the patch adds XDP support for packets using dataring
and r0 (case A and B), not the large packet size when LRO is enabled.

XDP Implementation:
When user loads and XDP prog, vmxnet3 driver checks configurations, such
as mtu, lro, and re-allocate the rx buffer size for reserving the extra
headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
associated with every rx queue of the device. Note that when using dataring
for small packet size, vmxnet3 (front-end driver) doesn't control the
buffer allocation, as a result we allocate a new page and copy packet
from the dataring to XDP frame.

The receive side of XDP is implemented for case A and B, by invoking the
bpf program at vmxnet3_rq_rx_complete and handle its returned action.
The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
the ring0 and dataring case separately, and decides the next journey of
the packet afterward.

For TX, vmxnet3 has split header design. Outgoing packets are parsed
first and protocol headers (L2/L3/L4) are copied to the backend. The
rest of the payload are dma mapped. Since XDP_TX does not parse the
packet protocol, the entire XDP frame is dma mapped for transmission
and transmitted in a batch. Later on, the frame is freed and recycled
back to the memory pool.

Performance:
Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
to vmxnet3 device, sending 64B or 512B UDP packet.

VM1 txgen:
$ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
--forward-mode=txonly --eth-peer=0,<mac addr of vm2>
option: add "--txonly-multi-flow"
option: use --txpkts=512 or 64 byte

VM2 running XDP:
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
options: XDP_DROP, XDP_PASS, XDP_TX

To test REDIRECT to cpu 0, use
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop

Single core performance comparison with skb-mode.
64B:      skb-mode -> native-mode
XDP_DROP: 1.6Mpps -> 2.4Mpps
XDP_PASS: 338Kpps -> 367Kpps
XDP_TX:   1.1Mpps -> 2.3Mpps
REDIRECT-drop: 1.3Mpps -> 2.3Mpps

512B:     skb-mode -> native-mode
XDP_DROP: 863Kpps -> 1.3Mpps
XDP_PASS: 275Kpps -> 376Kpps
XDP_TX:   554Kpps -> 1.2Mpps
REDIRECT-drop: 659Kpps -> 1.2Mpps

Demo: https://youtu.be/4lm1CSCi78Q

Future work:
- XDP frag support
- use napi_consume_skb() instead of dev_kfree_skb_any at unmap

Signed-off-by: William Tu <u9012063@gmail.com>
Tested-by: Yifeng Sun <yifengs@vmware.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
v13 -> v14:
feedbacks from Alexander Lobakin
- fix several new lines, unrelated changes, unlikely, RCT style,
  coding style, etc.
- add NET_IP_ALIGN and create VMXNET3_XDP_HEADROOM, instead of
  using XDP_PACKET_HEADROOM
- remove %pp_page and use %page in rx_buf_int
- fix the %VMXNET3_XDP_MAX_MTU, mtu doesn't include eth, vlan, and fcs
- use NL_SET instead of netdev_err when detecting LRP
- remove two global function, vmxnet3{_xdp_headroom, xdp_enabled}
make the vmxnet3_xdp_enabled static inline function, and remove
vmxnet3_xdp_headroom.
- rename the VMXNET3_XDP_MAX_MTU to VMXNET3_XDP_MAX_FRSIZE

- add Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
- add yifeng sun for testing on ESXi and XDP
compare v13..v14
https://github.com/williamtu/net-next/compare/v13..v14

v12 -> v13:
- feedbacks from Guolin:
  Instead of return -ENOTSUPP, disable the LRO in
  netdev->features, and print err msg

v11 -> v12:
work on feedbacks from Alexander Duyck
- fix issues and refactor the vmxnet3_unmap_tx_buf and
  unmap_pkt

v10 -> v11:
work on feedbacks from Alexander Duyck
internal feedback from Guolin and Ronak
- fix the issue of xdp_return_frame_bulk, move to up level
  of vmxnet3_unmap_tx_buf and some refactoring
- refactor and simplify vmxnet3_tq_cleanup
- disable XDP when LRO is enabled, suggested by Ronak
---
 drivers/net/Kconfig                   |   1 +
 drivers/net/vmxnet3/Makefile          |   2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c     | 219 ++++++++++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
 drivers/net/vmxnet3/vmxnet3_int.h     |  43 ++-
 drivers/net/vmxnet3/vmxnet3_xdp.c     | 419 ++++++++++++++++++++++++++
 drivers/net/vmxnet3/vmxnet3_xdp.h     |  46 +++
 7 files changed, 704 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
 create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e..a4419d661bdd 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -571,6 +571,7 @@ config VMXNET3
 	tristate "VMware VMXNET3 ethernet driver"
 	depends on PCI && INET
 	depends on PAGE_SIZE_LESS_THAN_64KB
+	select PAGE_POOL
 	help
 	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
index a666a88ac1ff..f82870c10205 100644
--- a/drivers/net/vmxnet3/Makefile
+++ b/drivers/net/vmxnet3/Makefile
@@ -32,4 +32,4 @@
 
 obj-$(CONFIG_VMXNET3) += vmxnet3.o
 
-vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o
+vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o vmxnet3_xdp.o
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d3e7b27eb933..fa49d8ab9950 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -28,6 +28,7 @@
 #include <net/ip6_checksum.h>
 
 #include "vmxnet3_int.h"
+#include "vmxnet3_xdp.h"
 
 char vmxnet3_driver_name[] = "vmxnet3";
 #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
@@ -323,17 +324,18 @@ static u32 get_bitfield32(const __le32 *bitfield, u32 pos, u32 size)
 
 
 static void
-vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
-		     struct pci_dev *pdev)
+vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev)
 {
-	if (tbi->map_type == VMXNET3_MAP_SINGLE)
+	u32 map_type = tbi->map_type;
+
+	if (map_type & VMXNET3_MAP_SINGLE)
 		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
 				 DMA_TO_DEVICE);
-	else if (tbi->map_type == VMXNET3_MAP_PAGE)
+	else if (map_type & VMXNET3_MAP_PAGE)
 		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
 			       DMA_TO_DEVICE);
 	else
-		BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
+		BUG_ON((map_type & ~VMXNET3_MAP_XDP));
 
 	tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
 }
@@ -341,19 +343,20 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
 
 static int
 vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
-		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter)
+		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter,
+		  struct xdp_frame_bulk *bq)
 {
-	struct sk_buff *skb;
+	struct vmxnet3_tx_buf_info *tbi;
 	int entries = 0;
+	u32 map_type;
 
 	/* no out of order completion */
 	BUG_ON(tq->buf_info[eop_idx].sop_idx != tq->tx_ring.next2comp);
 	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
 
-	skb = tq->buf_info[eop_idx].skb;
-	BUG_ON(skb == NULL);
-	tq->buf_info[eop_idx].skb = NULL;
-
+	tbi = &tq->buf_info[eop_idx];
+	BUG_ON(tbi->skb == NULL);
+	map_type = tbi->map_type;
 	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
 
 	while (tq->tx_ring.next2comp != eop_idx) {
@@ -369,7 +372,14 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
 		entries++;
 	}
 
-	dev_kfree_skb_any(skb);
+	if (map_type & VMXNET3_MAP_XDP)
+		xdp_return_frame_bulk(tbi->xdpf, bq);
+	else
+		dev_kfree_skb_any(tbi->skb);
+
+	/* xdpf and skb are in an anonymous union. */
+	tbi->skb = NULL;
+
 	return entries;
 }
 
@@ -378,9 +388,11 @@ static int
 vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
 			struct vmxnet3_adapter *adapter)
 {
-	int completed = 0;
 	union Vmxnet3_GenericDesc *gdesc;
+	struct xdp_frame_bulk bq;
+	int completed = 0;
 
+	xdp_frame_bulk_init(&bq);
 	gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
 	while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) == tq->comp_ring.gen) {
 		/* Prevent any &gdesc->tcd field from being (speculatively)
@@ -390,11 +402,12 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
 
 		completed += vmxnet3_unmap_pkt(VMXNET3_TCD_GET_TXIDX(
 					       &gdesc->tcd), tq, adapter->pdev,
-					       adapter);
+					       adapter, &bq);
 
 		vmxnet3_comp_ring_adv_next2proc(&tq->comp_ring);
 		gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
 	}
+	xdp_flush_frame_bulk(&bq);
 
 	if (completed) {
 		spin_lock(&tq->tx_lock);
@@ -414,26 +427,34 @@ static void
 vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
 		   struct vmxnet3_adapter *adapter)
 {
+	struct xdp_frame_bulk bq;
+	u32 map_type;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
 	while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
 		struct vmxnet3_tx_buf_info *tbi;
 
 		tbi = tq->buf_info + tq->tx_ring.next2comp;
+		map_type = tbi->map_type;
 
 		vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
 		if (tbi->skb) {
-			dev_kfree_skb_any(tbi->skb);
+			if (map_type & VMXNET3_MAP_XDP)
+				xdp_return_frame_bulk(tbi->xdpf, &bq);
+			else
+				dev_kfree_skb_any(tbi->skb);
 			tbi->skb = NULL;
 		}
 		vmxnet3_cmd_ring_adv_next2comp(&tq->tx_ring);
 	}
 
-	/* sanity check, verify all buffers are indeed unmapped and freed */
-	for (i = 0; i < tq->tx_ring.size; i++) {
-		BUG_ON(tq->buf_info[i].skb != NULL ||
-		       tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
-	}
+	xdp_flush_frame_bulk(&bq);
+
+	/* sanity check, verify all buffers are indeed unmapped */
+	for (i = 0; i < tq->tx_ring.size; i++)
+		BUG_ON(tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
 
 	tq->tx_ring.gen = VMXNET3_INIT_GEN;
 	tq->tx_ring.next2fill = tq->tx_ring.next2comp = 0;
@@ -587,7 +608,17 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 		gd = ring->base + ring->next2fill;
 		rbi->comp_state = VMXNET3_RXD_COMP_PENDING;
 
-		if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
+		if (rbi->buf_type == VMXNET3_RX_BUF_XDP) {
+			void *data = vmxnet3_pp_get_buff(rq->page_pool,
+							 &rbi->dma_addr,
+							 GFP_KERNEL);
+			if (!data) {
+				rq->stats.rx_buf_alloc_failure++;
+				break;
+			}
+			rbi->page = virt_to_head_page(data);
+			val = VMXNET3_RXD_BTYPE_HEAD << VMXNET3_RXD_BTYPE_SHIFT;
+		} else if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
 			if (rbi->skb == NULL) {
 				rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
 								       rbi->len,
@@ -1253,6 +1284,62 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	return NETDEV_TX_OK;
 }
 
+static int
+vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
+		  struct vmxnet3_rx_queue *rq, int size)
+{
+	const struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = NUMA_NO_NODE,
+		.dev = &adapter->pdev->dev,
+		.offset = VMXNET3_XDP_RX_OFFSET,
+		.max_len = VMXNET3_XDP_MAX_FRSIZE,
+		.dma_dir = DMA_BIDIRECTIONAL,
+	};
+	struct page_pool *pp;
+	int err;
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp))
+		return PTR_ERR(pp);
+
+	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid,
+			       rq->napi.napi_id);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_POOL, pp);
+	if (err)
+		goto err_unregister_rxq;
+
+	rq->page_pool = pp;
+
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(pp);
+
+	return err;
+}
+
+void *
+vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
+		    gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
+	if (unlikely(!page))
+		return NULL;
+
+	*dma_addr = page_pool_get_dma_addr(page) + pp->p.offset;
+
+	return page_address(page);
+}
 
 static netdev_tx_t
 vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
@@ -1404,6 +1491,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxDesc rxCmdDesc;
 	struct Vmxnet3_RxCompDesc rxComp;
 #endif
+	bool need_flush = false;
+
 	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
 			  &rxComp);
 	while (rcd->gen == rq->comp_ring.gen) {
@@ -1444,6 +1533,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			goto rcd_done;
 		}
 
+		if (rcd->sop && rcd->eop && vmxnet3_xdp_enabled(adapter)) {
+			struct sk_buff *skb_xdp_pass;
+			int act;
+
+			if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
+				ctx->skb = NULL;
+				goto skip_xdp; /* Handle it later. */
+			}
+
+			if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
+				goto rcd_done;
+
+			act = vmxnet3_process_xdp(adapter, rq, rcd, rbi, rxd,
+						  &skb_xdp_pass);
+			if (act == XDP_PASS) {
+				ctx->skb = skb_xdp_pass;
+				goto sop_done;
+			}
+			ctx->skb = NULL;
+			if (act == XDP_REDIRECT)
+				need_flush = true;
+			goto rcd_done;
+		}
+skip_xdp:
+
 		if (rcd->sop) { /* first buf of the pkt */
 			bool rxDataRingUsed;
 			u16 len;
@@ -1452,7 +1566,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			       (rcd->rqID != rq->qid &&
 				rcd->rqID != rq->dataRingQid));
 
-			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB);
+			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB &&
+			       rbi->buf_type != VMXNET3_RX_BUF_XDP);
 			BUG_ON(ctx->skb != NULL || rbi->skb == NULL);
 
 			if (unlikely(rcd->len == 0)) {
@@ -1470,6 +1585,26 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			rxDataRingUsed =
 				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
 			len = rxDataRingUsed ? rcd->len : rbi->len;
+
+			if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {
+				struct sk_buff *skb_xdp_pass;
+				size_t sz;
+				int act;
+
+				sz = rcd->rxdIdx * rq->data_ring.desc_size;
+				act = vmxnet3_process_xdp_small(adapter, rq,
+								&rq->data_ring.base[sz],
+								rcd->len,
+								&skb_xdp_pass);
+				if (act == XDP_PASS) {
+					ctx->skb = skb_xdp_pass;
+					goto sop_done;
+				}
+				if (act == XDP_REDIRECT)
+					need_flush = true;
+
+				goto rcd_done;
+			}
 			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
 							    len);
 			if (new_skb == NULL) {
@@ -1622,6 +1757,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		}
 
 
+sop_done:
 		skb = ctx->skb;
 		if (rcd->eop) {
 			u32 mtu = adapter->netdev->mtu;
@@ -1730,6 +1866,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		vmxnet3_getRxComp(rcd,
 				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
 	}
+	if (need_flush)
+		xdp_do_flush();
 
 	return num_pkts;
 }
@@ -1755,13 +1893,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
 
 			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
-					rq->buf_info[ring_idx][i].skb) {
+			    rq->buf_info[ring_idx][i].page &&
+			    rq->buf_info[ring_idx][i].buf_type ==
+			    VMXNET3_RX_BUF_XDP) {
+				page_pool_recycle_direct(rq->page_pool,
+							 rq->buf_info[ring_idx][i].page);
+				rq->buf_info[ring_idx][i].page = NULL;
+			} else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
+				   rq->buf_info[ring_idx][i].skb) {
 				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
 						 rxd->len, DMA_FROM_DEVICE);
 				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
 				rq->buf_info[ring_idx][i].skb = NULL;
 			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
-					rq->buf_info[ring_idx][i].page) {
+				   rq->buf_info[ring_idx][i].page) {
 				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
 					       rxd->len, DMA_FROM_DEVICE);
 				put_page(rq->buf_info[ring_idx][i].page);
@@ -1786,6 +1931,7 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->num_rx_queues; i++)
 		vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
+	rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
 }
 
 
@@ -1815,6 +1961,11 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 		}
 	}
 
+	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
+	rq->page_pool = NULL;
+
 	if (rq->data_ring.base) {
 		dma_free_coherent(&adapter->pdev->dev,
 				  rq->rx_ring[0].size * rq->data_ring.desc_size,
@@ -1858,14 +2009,16 @@ static int
 vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 		struct vmxnet3_adapter  *adapter)
 {
-	int i;
+	int i, err;
 
 	/* initialize buf_info */
 	for (i = 0; i < rq->rx_ring[0].size; i++) {
 
-		/* 1st buf for a pkt is skbuff */
+		/* 1st buf for a pkt is skbuff or xdp page */
 		if (i % adapter->rx_buf_per_pkt == 0) {
-			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_SKB;
+			rq->buf_info[0][i].buf_type = vmxnet3_xdp_enabled(adapter) ?
+						      VMXNET3_RX_BUF_XDP :
+						      VMXNET3_RX_BUF_SKB;
 			rq->buf_info[0][i].len = adapter->skb_buf_size;
 		} else { /* subsequent bufs for a pkt is frag */
 			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_PAGE;
@@ -1886,6 +2039,12 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 		rq->rx_ring[i].gen = VMXNET3_INIT_GEN;
 		rq->rx_ring[i].isOutOfOrder = 0;
 	}
+
+	err = vmxnet3_create_pp(adapter, rq,
+				rq->rx_ring[0].size + rq->rx_ring[1].size);
+	if (err)
+		return err;
+
 	if (vmxnet3_rq_alloc_rx_buf(rq, 0, rq->rx_ring[0].size - 1,
 				    adapter) == 0) {
 		/* at least has 1 rx buffer for the 1st ring */
@@ -1989,7 +2148,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
 }
 
 
-static int
+int
 vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
 {
 	int i, err = 0;
@@ -3026,7 +3185,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
 }
 
 
-static void
+void
 vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 {
 	size_t sz, i, ring0_size, ring1_size, comp_size;
@@ -3585,6 +3744,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 		.ndo_poll_controller = vmxnet3_netpoll,
 #endif
+		.ndo_bpf = vmxnet3_xdp,
+		.ndo_xdp_xmit = vmxnet3_xdp_xmit,
 	};
 	int err;
 	u32 ver;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 18cf7c723201..6f542236b26e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -76,6 +76,10 @@ vmxnet3_tq_driver_stats[] = {
 					 copy_skb_header) },
 	{ "  giant hdr",	offsetof(struct vmxnet3_tq_driver_stats,
 					 oversized_hdr) },
+	{ "  xdp xmit",		offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit) },
+	{ "  xdp xmit err",	offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit_err) },
 };
 
 /* per rq stats maintained by the device */
@@ -106,6 +110,16 @@ vmxnet3_rq_driver_stats[] = {
 					 drop_fcs) },
 	{ "  rx buf alloc fail", offsetof(struct vmxnet3_rq_driver_stats,
 					  rx_buf_alloc_failure) },
+	{ "     xdp packets", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_packets) },
+	{ "     xdp tx", offsetof(struct vmxnet3_rq_driver_stats,
+				  xdp_tx) },
+	{ "     xdp redirects", offsetof(struct vmxnet3_rq_driver_stats,
+					 xdp_redirects) },
+	{ "     xdp drops", offsetof(struct vmxnet3_rq_driver_stats,
+				     xdp_drops) },
+	{ "     xdp aborted", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_aborted) },
 };
 
 /* global stats maintained by the driver */
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3367db23aa13..c374c3358dd0 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -56,6 +56,9 @@
 #include <linux/if_arp.h>
 #include <linux/inetdevice.h>
 #include <linux/log2.h>
+#include <linux/bpf.h>
+#include <linux/skbuff.h>
+#include <net/page_pool.h>
 
 #include "vmxnet3_defs.h"
 
@@ -188,19 +191,20 @@ struct vmxnet3_tx_data_ring {
 	dma_addr_t          basePA;
 };
 
-enum vmxnet3_buf_map_type {
-	VMXNET3_MAP_INVALID = 0,
-	VMXNET3_MAP_NONE,
-	VMXNET3_MAP_SINGLE,
-	VMXNET3_MAP_PAGE,
-};
+#define VMXNET3_MAP_NONE	0
+#define VMXNET3_MAP_SINGLE	BIT(0)
+#define VMXNET3_MAP_PAGE	BIT(1)
+#define VMXNET3_MAP_XDP		BIT(2)
 
 struct vmxnet3_tx_buf_info {
 	u32      map_type;
 	u16      len;
 	u16      sop_idx;
 	dma_addr_t  dma_addr;
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 };
 
 struct vmxnet3_tq_driver_stats {
@@ -217,6 +221,9 @@ struct vmxnet3_tq_driver_stats {
 	u64 linearized;         /* # of pkts linearized */
 	u64 copy_skb_header;    /* # of times we have to copy skb header */
 	u64 oversized_hdr;
+
+	u64 xdp_xmit;
+	u64 xdp_xmit_err;
 };
 
 struct vmxnet3_tx_ctx {
@@ -253,12 +260,13 @@ struct vmxnet3_tx_queue {
 						    * stopped */
 	int				qid;
 	u16				txdata_desc_size;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+} ____cacheline_aligned;
 
 enum vmxnet3_rx_buf_type {
 	VMXNET3_RX_BUF_NONE = 0,
 	VMXNET3_RX_BUF_SKB = 1,
-	VMXNET3_RX_BUF_PAGE = 2
+	VMXNET3_RX_BUF_PAGE = 2,
+	VMXNET3_RX_BUF_XDP = 3,
 };
 
 #define VMXNET3_RXD_COMP_PENDING        0
@@ -285,6 +293,12 @@ struct vmxnet3_rq_driver_stats {
 	u64 drop_err;
 	u64 drop_fcs;
 	u64 rx_buf_alloc_failure;
+
+	u64 xdp_packets;	/* Total packets processed by XDP. */
+	u64 xdp_tx;
+	u64 xdp_redirects;
+	u64 xdp_drops;
+	u64 xdp_aborted;
 };
 
 struct vmxnet3_rx_data_ring {
@@ -307,7 +321,9 @@ struct vmxnet3_rx_queue {
 	struct vmxnet3_rx_buf_info     *buf_info[2];
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+} ____cacheline_aligned;
 
 #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
 #define VMXNET3_DEVICE_MAX_RX_QUEUES 32   /* Keep this value as a power of 2 */
@@ -415,6 +431,7 @@ struct vmxnet3_adapter {
 	u16    tx_prod_offset;
 	u16    rx_prod_offset;
 	u16    rx_prod2_offset;
+	struct bpf_prog __rcu *xdp_bpf_prog;
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
@@ -490,6 +507,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
 void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
+int
+vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter);
+
+void
+vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter);
+
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
new file mode 100644
index 000000000000..11154679a388
--- /dev/null
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -0,0 +1,419 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Linux driver for VMware's vmxnet3 ethernet NIC.
+ * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
+ * Maintained by: pv-drivers@vmware.com
+ *
+ */
+
+#include "vmxnet3_int.h"
+#include "vmxnet3_xdp.h"
+
+static void
+vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
+			     struct bpf_prog *prog)
+{
+	rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
+}
+
+static int
+vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
+		struct netlink_ext_ack *extack)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *new_bpf_prog = bpf->prog;
+	struct bpf_prog *old_bpf_prog;
+	unsigned int max_mtu;
+	bool need_update;
+	bool running;
+	int err;
+
+	max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VMXNET3_XDP_HEADROOM) -
+				    netdev->hard_header_len;
+	if (new_bpf_prog && netdev->mtu > max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	if (adapter->netdev->features & NETIF_F_LRO) {
+		NL_SET_ERR_MSG_MOD(extack, "LRO is not supported with XDP");
+		adapter->netdev->features &= ~NETIF_F_LRO;
+	}
+
+	old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
+	if (!new_bpf_prog && !old_bpf_prog)
+		return 0;
+
+	running = netif_running(netdev);
+	need_update = !!old_bpf_prog != !!new_bpf_prog;
+
+	if (running && need_update)
+		vmxnet3_quiesce_dev(adapter);
+
+	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
+	if (old_bpf_prog)
+		bpf_prog_put(old_bpf_prog);
+
+	if (!running || !need_update)
+		return 0;
+
+	vmxnet3_reset_dev(adapter);
+	vmxnet3_rq_destroy_all(adapter);
+	vmxnet3_adjust_rx_ring_size(adapter);
+	err = vmxnet3_rq_create_all(adapter);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "failed to re-create rx queues for XDP.");
+		return -EOPNOTSUPP;
+	}
+	err = vmxnet3_activate_dev(adapter);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "failed to activate device for XDP.");
+		return -EOPNOTSUPP;
+	}
+	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
+
+	return 0;
+}
+
+/* This is the main xdp call used by kernel to set/unset eBPF program. */
+int
+vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
+		       struct xdp_frame *xdpf,
+		       struct vmxnet3_tx_queue *tq, bool dma_map)
+{
+	struct vmxnet3_tx_buf_info *tbi = NULL;
+	union Vmxnet3_GenericDesc *gdesc;
+	struct vmxnet3_tx_ctx ctx;
+	int tx_num_deferred;
+	struct page *page;
+	u32 buf_size;
+	int ret = 0;
+	u32 dw2;
+
+	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
+	dw2 |= xdpf->len;
+	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
+	gdesc = ctx.sop_txd;
+
+	buf_size = xdpf->len;
+	tbi = tq->buf_info + tq->tx_ring.next2fill;
+
+	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
+		tq->stats.tx_ring_full++;
+		return -ENOSPC;
+	}
+
+	tbi->map_type = VMXNET3_MAP_XDP;
+	if (dma_map) { /* ndo_xdp_xmit */
+		tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
+					       xdpf->data, buf_size,
+					       DMA_TO_DEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
+			return -EFAULT;
+		tbi->map_type |= VMXNET3_MAP_SINGLE;
+	} else { /* XDP buffer from page pool */
+		page = virt_to_head_page(xdpf->data);
+		tbi->dma_addr = page_pool_get_dma_addr(page) +
+				XDP_PACKET_HEADROOM;
+		dma_sync_single_for_device(&adapter->pdev->dev,
+					   tbi->dma_addr, buf_size,
+					   DMA_BIDIRECTIONAL);
+	}
+	tbi->xdpf = xdpf;
+	tbi->len = buf_size;
+
+	gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
+	WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
+
+	gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
+	gdesc->dword[2] = cpu_to_le32(dw2);
+
+	/* Setup the EOP desc */
+	gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
+
+	gdesc->txd.om = 0;
+	gdesc->txd.msscof = 0;
+	gdesc->txd.hlen = 0;
+	gdesc->txd.ti = 0;
+
+	tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
+	le32_add_cpu(&tq->shared->txNumDeferred, 1);
+	tx_num_deferred++;
+
+	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
+
+	/* set the last buf_info for the pkt */
+	tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
+
+	dma_wmb();
+	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
+						  VMXNET3_TXD_GEN);
+
+	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
+		tq->shared->txNumDeferred = 0;
+		VMXNET3_WRITE_BAR0_REG(adapter,
+				       VMXNET3_REG_TXPROD + tq->qid * 8,
+				       tq->tx_ring.next2fill);
+	}
+
+	return ret;
+}
+
+static int
+vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
+		      struct xdp_frame *xdpf)
+{
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int tq_number;
+	int err, cpu;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	if (likely(cpu < tq_number))
+		tq = &adapter->tx_queue[cpu];
+	else
+		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
+	if (tq->stopped)
+		return -ENETDOWN;
+
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, cpu);
+	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
+	__netif_tx_unlock(nq);
+
+	return err;
+}
+
+/* ndo_xdp_xmit */
+int
+vmxnet3_xdp_xmit(struct net_device *dev,
+		 int n, struct xdp_frame **frames, u32 flags)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(dev);
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int i, err, cpu;
+	int tq_number;
+
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
+		return -ENETDOWN;
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
+		return -EINVAL;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	if (likely(cpu < tq_number))
+		tq = &adapter->tx_queue[cpu];
+	else
+		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
+	if (tq->stopped)
+		return -ENETDOWN;
+
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	for (i = 0; i < n; i++) {
+		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
+		if (err) {
+			tq->stats.xdp_xmit_err++;
+			break;
+		}
+	}
+	tq->stats.xdp_xmit += i;
+
+	return i;
+}
+
+static int
+vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	struct page *page;
+	int err;
+	u32 act;
+
+	prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	act = bpf_prog_run_xdp(prog, xdp);
+	rq->stats.xdp_packets++;
+
+	switch (act) {
+	case XDP_PASS:
+		return act;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
+		if (!err)
+			rq->stats.xdp_redirects++;
+		else
+			rq->stats.xdp_drops++;
+		return act;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf ||
+			     vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
+			rq->stats.xdp_drops++;
+			page = virt_to_head_page(xdp->data_hard_start);
+			page_pool_recycle_direct(rq->page_pool, page);
+		} else {
+			rq->stats.xdp_tx++;
+		}
+		return act;
+	default:
+		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(rq->adapter->netdev, prog, act);
+		rq->stats.xdp_aborted++;
+		break;
+	case XDP_DROP:
+		rq->stats.xdp_drops++;
+		break;
+	}
+
+	page_pool_recycle_direct(rq->page_pool,
+				 virt_to_head_page(xdp->data_hard_start));
+
+	return act;
+}
+
+static struct sk_buff *
+vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
+		  const struct xdp_buff *xdp)
+{
+	struct sk_buff *skb;
+
+	skb = build_skb(page_address(page), PAGE_SIZE);
+	if (unlikely(!skb)) {
+		page_pool_recycle_direct(rq->page_pool, page);
+		rq->stats.rx_buf_alloc_failure++;
+		return NULL;
+	}
+
+	/* bpf prog might change len and data position. */
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	skb_put(skb, xdp->data_end - xdp->data);
+	skb_mark_for_recycle(skb);
+
+	return skb;
+}
+
+/* Handle packets from DataRing. */
+int
+vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
+			  struct vmxnet3_rx_queue *rq,
+			  void *data, int len,
+			  struct sk_buff **skb_xdp_pass)
+{
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	struct page *page;
+	int act;
+
+	page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
+	if (unlikely(!page)) {
+		rq->stats.rx_buf_alloc_failure++;
+		return XDP_DROP;
+	}
+
+	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
+			 len, false);
+	xdp_buff_clear_frags_flag(&xdp);
+
+	/* Must copy the data because it's at dataring. */
+	memcpy(xdp.data, data, len);
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		page_pool_recycle_direct(rq->page_pool, page);
+		act = XDP_PASS;
+		goto out_skb;
+	}
+	act = vmxnet3_run_xdp(rq, &xdp);
+	rcu_read_unlock();
+
+	if (act == XDP_PASS) {
+out_skb:
+		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
+		if (!skb_xdp_pass)
+			return XDP_DROP;
+	}
+
+	/* No need to refill. */
+	return act;
+}
+
+int
+vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
+		    struct vmxnet3_rx_queue *rq,
+		    struct Vmxnet3_RxCompDesc *rcd,
+		    struct vmxnet3_rx_buf_info *rbi,
+		    struct Vmxnet3_RxDesc *rxd,
+		    struct sk_buff **skb_xdp_pass)
+{
+	struct bpf_prog *xdp_prog;
+	dma_addr_t new_dma_addr;
+	struct xdp_buff xdp;
+	struct page *page;
+	void *new_data;
+	int act;
+
+	page = rbi->page;
+	dma_sync_single_for_cpu(&adapter->pdev->dev,
+				page_pool_get_dma_addr(page) +
+				XDP_PACKET_HEADROOM, rcd->len,
+				page_pool_get_dma_dir(rq->page_pool));
+
+	xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
+			 rcd->len, false);
+	xdp_buff_clear_frags_flag(&xdp);
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		act = XDP_PASS;
+		goto refill;
+	}
+	act = vmxnet3_run_xdp(rq, &xdp);
+	rcu_read_unlock();
+
+	if (act == XDP_PASS) {
+		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
+		if (!skb_xdp_pass)
+			act = XDP_DROP;
+	}
+
+refill:
+	new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
+				       GFP_ATOMIC);
+	if (!new_data) {
+		rq->stats.rx_buf_alloc_failure++;
+		return XDP_DROP;
+	}
+	rbi->page = virt_to_head_page(new_data);
+	rbi->dma_addr = new_dma_addr;
+	rxd->addr = cpu_to_le64(rbi->dma_addr);
+	rxd->len = rbi->len;
+
+	return act;
+}
diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.h b/drivers/net/vmxnet3/vmxnet3_xdp.h
new file mode 100644
index 000000000000..14bd2dbee707
--- /dev/null
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Linux driver for VMware's vmxnet3 ethernet NIC.
+ * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
+ * Maintained by: pv-drivers@vmware.com
+ *
+ */
+
+#ifndef _VMXNET3_XDP_H
+#define _VMXNET3_XDP_H
+
+#include <linux/filter.h>
+#include <linux/bpf_trace.h>
+#include <linux/netlink.h>
+#include <net/page_pool.h>
+#include <net/xdp.h>
+
+#include "vmxnet3_int.h"
+
+#define VMXNET3_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
+#define VMXNET3_XDP_RX_OFFSET	VMXNET3_XDP_HEADROOM
+#define VMXNET3_XDP_MAX_FRSIZE	(PAGE_SIZE - VMXNET3_XDP_HEADROOM \
+			- SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
+int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
+int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+		     u32 flags);
+int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
+			struct vmxnet3_rx_queue *rq,
+			struct Vmxnet3_RxCompDesc *rcd,
+			struct vmxnet3_rx_buf_info *rbi,
+			struct Vmxnet3_RxDesc *rxd,
+			struct sk_buff **skb_xdp_pass);
+int vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
+			      struct vmxnet3_rx_queue *rq,
+			      void *data, int len,
+			      struct sk_buff **skb_xdp_pass);
+void *vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
+			  gfp_t gfp_mask);
+
+static inline bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
+{
+	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
+}
+
+#endif
-- 
2.32.1 (Apple Git-133)

