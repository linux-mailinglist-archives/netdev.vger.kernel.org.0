Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68566179F8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiKCJ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiKCJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B5EF02E;
        Thu,  3 Nov 2022 02:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C9861D17;
        Thu,  3 Nov 2022 09:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DE7C433C1;
        Thu,  3 Nov 2022 09:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467734;
        bh=QnUKOkTnkrHSIAJftcLA82WwgC5QIgVyI3AfWfYWnJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Js1XxUMpW2P1TglN29w9kWjKbuWWG9AoAx+gNzAcLGRM5oDnhapIeCnnUrorVyphD
         p9Vljgh4Q9fC94HKnUhK3qujlif5xYldu4NbBY9yGehLc3gz/Mtda7s/icdKssknII
         a9RwFNsbzzLTENBMQxbFqpkgWB5mojpP8KxcKE11ZkAFyM8UW2G93QOou8trasWayg
         AvUtB6/LOP9moiiU29m4gMHTnbzxTOiT8tZTuA5zRiQU6dm2fsZHJXguu+WwpAWH/U
         YQusR0hCY7Bzft1JOKQSzj+GhB7xH6jTP5QYqJnlI8XfyOChu/c7ql0bpr1/IxEgvM
         4TzAp11jMNCRA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 4/8] net: ethernet: mtk_wed: introduce wed wo support
Date:   Thu,  3 Nov 2022 10:28:03 +0100
Message-Id: <8a0a904f6de169e58f57f6031425ba1b1271fbcc.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667466887.git.lorenzo@kernel.org>
References: <cover.1667466887.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce WO chip support to mtk wed driver. MTK WED WO is used to
implement RX Wireless Ethernet Dispatch and offload traffic received by
wlan nic to the wired interface.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/Makefile      |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed.c     |   7 +-
 drivers/net/ethernet/mediatek/mtk_wed.h     |   2 +
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c |   3 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c  | 508 ++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed_wo.h  | 104 ++++
 6 files changed, 622 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.c

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index d4bdefa77159..8e0c61c33ff8 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
 mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o mtk_ppe_offload.o
-mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o mtk_wed_mcu.o
+mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o mtk_wed_mcu.o mtk_wed_wo.o
 ifdef CONFIG_DEBUG_FS
 mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 65e01bf4b4d2..9c9dd17332b6 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -16,6 +16,7 @@
 #include "mtk_wed_regs.h"
 #include "mtk_wed.h"
 #include "mtk_ppe.h"
+#include "mtk_wed_wo.h"
 
 #define MTK_PCIE_BASE(n)		(0x1a143000 + (n) * 0x2000)
 
@@ -355,6 +356,8 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 
 	mtk_wed_free_buffer(dev);
 	mtk_wed_free_tx_rings(dev);
+	if (hw->version != 1)
+		mtk_wed_wo_deinit(hw);
 
 	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
 		struct device_node *wlan_node;
@@ -878,9 +881,11 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	}
 
 	mtk_wed_hw_init_early(dev);
-	if (hw->hifsys)
+	if (hw->version == 1)
 		regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
 				   BIT(hw->index), 0);
+	else
+		ret = mtk_wed_wo_init(hw);
 
 out:
 	mutex_unlock(&hw_lock);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index ae420ca01a48..af656fd31ff9 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 
 struct mtk_eth;
+struct mtk_wed_wo;
 
 struct mtk_wed_hw {
 	struct device_node *node;
@@ -22,6 +23,7 @@ struct mtk_wed_hw {
 	struct regmap *mirror;
 	struct dentry *debugfs_dir;
 	struct mtk_wed_device *wed_dev;
+	struct mtk_wed_wo *wed_wo;
 	u32 debugfs_reg;
 	u32 num_flows;
 	u8 version;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index 20987eecfb52..d792d91bce51 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -127,8 +127,7 @@ mtk_wed_mcu_skb_send_msg(struct mtk_wed_wo *wo, struct sk_buff *skb,
 	if (id == MTK_WED_MODULE_ID_WO)
 		hdr->flag |= cpu_to_le16(MTK_WED_WARP_CMD_FLAG_FROM_TO_WO);
 
-	dev_kfree_skb(skb);
-	return 0;
+	return mtk_wed_wo_queue_tx_skb(wo, &wo->q_tx, skb);
 }
 
 static int
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
new file mode 100644
index 000000000000..4754b6db009e
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2022 MediaTek Inc.
+ *
+ * Author: Lorenzo Bianconi <lorenzo@kernel.org>
+ *	   Sujuan Chen <sujuan.chen@mediatek.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/of_address.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_irq.h>
+#include <linux/bitfield.h>
+
+#include "mtk_wed.h"
+#include "mtk_wed_regs.h"
+#include "mtk_wed_wo.h"
+
+static u32
+mtk_wed_mmio_r32(struct mtk_wed_wo *wo, u32 reg)
+{
+	u32 val;
+
+	if (regmap_read(wo->mmio.regs, reg, &val))
+		val = ~0;
+
+	return val;
+}
+
+static void
+mtk_wed_mmio_w32(struct mtk_wed_wo *wo, u32 reg, u32 val)
+{
+	regmap_write(wo->mmio.regs, reg, val);
+}
+
+static u32
+mtk_wed_wo_get_isr(struct mtk_wed_wo *wo)
+{
+	u32 val = mtk_wed_mmio_r32(wo, MTK_WED_WO_CCIF_RCHNUM);
+
+	return val & MTK_WED_WO_CCIF_RCHNUM_MASK;
+}
+
+static void
+mtk_wed_wo_set_isr(struct mtk_wed_wo *wo, u32 mask)
+{
+	mtk_wed_mmio_w32(wo, MTK_WED_WO_CCIF_IRQ0_MASK, mask);
+}
+
+static void
+mtk_wed_wo_set_ack(struct mtk_wed_wo *wo, u32 mask)
+{
+	mtk_wed_mmio_w32(wo, MTK_WED_WO_CCIF_ACK, mask);
+}
+
+static void
+mtk_wed_wo_set_isr_mask(struct mtk_wed_wo *wo, u32 mask, u32 val, bool set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wo->mmio.lock, flags);
+	wo->mmio.irq_mask &= ~mask;
+	wo->mmio.irq_mask |= val;
+	if (set)
+		mtk_wed_wo_set_isr(wo, wo->mmio.irq_mask);
+	spin_unlock_irqrestore(&wo->mmio.lock, flags);
+}
+
+static void
+mtk_wed_wo_irq_enable(struct mtk_wed_wo *wo, u32 mask)
+{
+	mtk_wed_wo_set_isr_mask(wo, 0, mask, false);
+	tasklet_schedule(&wo->mmio.irq_tasklet);
+}
+
+static void
+mtk_wed_wo_irq_disable(struct mtk_wed_wo *wo, u32 mask)
+{
+	mtk_wed_wo_set_isr_mask(wo, mask, 0, true);
+}
+
+static void
+mtk_wed_wo_kickout(struct mtk_wed_wo *wo)
+{
+	mtk_wed_mmio_w32(wo, MTK_WED_WO_CCIF_BUSY, 1 << MTK_WED_WO_TXCH_NUM);
+	mtk_wed_mmio_w32(wo, MTK_WED_WO_CCIF_TCHNUM, MTK_WED_WO_TXCH_NUM);
+}
+
+static void
+mtk_wed_wo_queue_kick(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
+		      u32 val)
+{
+	wmb();
+	mtk_wed_mmio_w32(wo, q->regs.cpu_idx, val);
+}
+
+static void *
+mtk_wed_wo_dequeue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q, u32 *len,
+		   bool flush)
+{
+	int buf_len = SKB_WITH_OVERHEAD(q->buf_size);
+	int index = (q->tail + 1) % q->n_desc;
+	struct mtk_wed_wo_queue_entry *entry;
+	struct mtk_wed_wo_queue_desc *desc;
+	void *buf;
+
+	if (!q->queued)
+		return NULL;
+
+	if (flush)
+		q->desc[index].ctrl |= cpu_to_le32(MTK_WED_WO_CTL_DMA_DONE);
+	else if (!(q->desc[index].ctrl & cpu_to_le32(MTK_WED_WO_CTL_DMA_DONE)))
+		return NULL;
+
+	q->tail = index;
+	q->queued--;
+
+	desc = &q->desc[index];
+	entry = &q->entry[index];
+	buf = entry->buf;
+	if (len)
+		*len = FIELD_GET(MTK_WED_WO_CTL_SD_LEN0,
+				 le32_to_cpu(READ_ONCE(desc->ctrl)));
+	if (buf)
+		dma_unmap_single(wo->hw->dev, entry->addr, buf_len,
+				 DMA_FROM_DEVICE);
+	entry->buf = NULL;
+
+	return buf;
+}
+
+static int
+mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
+			gfp_t gfp, bool rx)
+{
+	enum dma_data_direction dir = rx ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	int n_buf = 0;
+
+	spin_lock_bh(&q->lock);
+	while (q->queued < q->n_desc) {
+		void *buf = page_frag_alloc(&q->cache, q->buf_size, gfp);
+		struct mtk_wed_wo_queue_entry *entry;
+		dma_addr_t addr;
+
+		if (!buf)
+			break;
+
+		addr = dma_map_single(wo->hw->dev, buf, q->buf_size, dir);
+		if (unlikely(dma_mapping_error(wo->hw->dev, addr))) {
+			skb_free_frag(buf);
+			break;
+		}
+
+		q->head = (q->head + 1) % q->n_desc;
+		entry = &q->entry[q->head];
+		entry->addr = addr;
+		entry->len = q->buf_size;
+		q->entry[q->head].buf = buf;
+
+		if (rx) {
+			struct mtk_wed_wo_queue_desc *desc = &q->desc[q->head];
+			u32 ctrl = MTK_WED_WO_CTL_LAST_SEC0 |
+				   FIELD_PREP(MTK_WED_WO_CTL_SD_LEN0,
+					      entry->len);
+
+			WRITE_ONCE(desc->buf0, cpu_to_le32(addr));
+			WRITE_ONCE(desc->ctrl, cpu_to_le32(ctrl));
+		}
+		q->queued++;
+		n_buf++;
+	}
+	spin_unlock_bh(&q->lock);
+
+	return n_buf;
+}
+
+static void
+mtk_wed_wo_rx_complete(struct mtk_wed_wo *wo)
+{
+	mtk_wed_wo_set_ack(wo, MTK_WED_WO_RXCH_INT_MASK);
+	mtk_wed_wo_irq_enable(wo, MTK_WED_WO_RXCH_INT_MASK);
+}
+
+static void
+mtk_wed_wo_rx_run_queue(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
+{
+	for (;;) {
+		struct mtk_wed_mcu_hdr *hdr;
+		struct sk_buff *skb;
+		void *data;
+		u32 len;
+
+		data = mtk_wed_wo_dequeue(wo, q, &len, false);
+		if (!data)
+			break;
+
+		skb = build_skb(data, q->buf_size);
+		if (!skb) {
+			skb_free_frag(data);
+			continue;
+		}
+
+		__skb_put(skb, len);
+		if (mtk_wed_mcu_check_msg(wo, skb)) {
+			dev_kfree_skb(skb);
+			continue;
+		}
+
+		hdr = (struct mtk_wed_mcu_hdr *)skb->data;
+		if (hdr->flag & cpu_to_le16(MTK_WED_WARP_CMD_FLAG_RSP))
+			mtk_wed_mcu_rx_event(wo, skb);
+		else
+			mtk_wed_mcu_rx_unsolicited_event(wo, skb);
+	}
+
+	if (mtk_wed_wo_queue_refill(wo, q, GFP_ATOMIC, true)) {
+		u32 index = (q->head - 1) % q->n_desc;
+
+		mtk_wed_wo_queue_kick(wo, q, index);
+	}
+}
+
+static irqreturn_t
+mtk_wed_wo_irq_handler(int irq, void *data)
+{
+	struct mtk_wed_wo *wo = data;
+
+	mtk_wed_wo_set_isr(wo, 0);
+	tasklet_schedule(&wo->mmio.irq_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static void mtk_wed_wo_irq_tasklet(struct tasklet_struct *t)
+{
+	struct mtk_wed_wo *wo = from_tasklet(wo, t, mmio.irq_tasklet);
+	u32 intr, mask;
+
+	/* disable interrupts */
+	mtk_wed_wo_set_isr(wo, 0);
+
+	intr = mtk_wed_wo_get_isr(wo);
+	intr &= wo->mmio.irq_mask;
+	mask = intr & (MTK_WED_WO_RXCH_INT_MASK | MTK_WED_WO_EXCEPTION_INT_MASK);
+	mtk_wed_wo_irq_disable(wo, mask);
+
+	if (intr & MTK_WED_WO_RXCH_INT_MASK) {
+		mtk_wed_wo_rx_run_queue(wo, &wo->q_rx);
+		mtk_wed_wo_rx_complete(wo);
+	}
+}
+
+/* mtk wed wo hw queues */
+
+static int
+mtk_wed_wo_queue_alloc(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
+		       int n_desc, int buf_size, int index,
+		       struct mtk_wed_wo_queue_regs *regs)
+{
+	spin_lock_init(&q->lock);
+	q->regs = *regs;
+	q->n_desc = n_desc;
+	q->buf_size = buf_size;
+
+	q->desc = dmam_alloc_coherent(wo->hw->dev, n_desc * sizeof(*q->desc),
+				      &q->desc_dma, GFP_KERNEL);
+	if (!q->desc)
+		return -ENOMEM;
+
+	q->entry = devm_kzalloc(wo->hw->dev, n_desc * sizeof(*q->entry),
+				GFP_KERNEL);
+	if (!q->entry)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void
+mtk_wed_wo_queue_free(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
+{
+	mtk_wed_mmio_w32(wo, q->regs.cpu_idx, 0);
+	dma_free_coherent(wo->hw->dev, q->n_desc * sizeof(*q->desc), q->desc,
+			  q->desc_dma);
+}
+
+static void
+mtk_wed_wo_queue_tx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
+{
+	struct page *page;
+	int i;
+
+	spin_lock_bh(&q->lock);
+	for (i = 0; i < q->n_desc; i++) {
+		struct mtk_wed_wo_queue_entry *entry = &q->entry[i];
+
+		dma_unmap_single(wo->hw->dev, entry->addr, entry->len,
+				 DMA_TO_DEVICE);
+		skb_free_frag(entry->buf);
+		entry->buf = NULL;
+	}
+	spin_unlock_bh(&q->lock);
+
+	if (!q->cache.va)
+		return;
+
+	page = virt_to_page(q->cache.va);
+	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
+	memset(&q->cache, 0, sizeof(q->cache));
+}
+
+static void
+mtk_wed_wo_queue_rx_clean(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
+{
+	struct page *page;
+
+	spin_lock_bh(&q->lock);
+	for (;;) {
+		void *buf = mtk_wed_wo_dequeue(wo, q, NULL, true);
+
+		if (!buf)
+			break;
+
+		skb_free_frag(buf);
+	}
+	spin_unlock_bh(&q->lock);
+
+	if (!q->cache.va)
+		return;
+
+	page = virt_to_page(q->cache.va);
+	__page_frag_cache_drain(page, q->cache.pagecnt_bias);
+	memset(&q->cache, 0, sizeof(q->cache));
+}
+
+static void
+mtk_wed_wo_queue_reset(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q)
+{
+	mtk_wed_mmio_w32(wo, q->regs.cpu_idx, 0);
+	mtk_wed_mmio_w32(wo, q->regs.desc_base, q->desc_dma);
+	mtk_wed_mmio_w32(wo, q->regs.ring_size, q->n_desc);
+}
+
+int mtk_wed_wo_queue_tx_skb(struct mtk_wed_wo *wo, struct mtk_wed_wo_queue *q,
+			    struct sk_buff *skb)
+{
+	struct mtk_wed_wo_queue_entry *entry;
+	struct mtk_wed_wo_queue_desc *desc;
+	int ret = 0, index;
+	u32 ctrl;
+
+	spin_lock_bh(&q->lock);
+
+	q->tail = mtk_wed_mmio_r32(wo, q->regs.dma_idx);
+	index = (q->head + 1) % q->n_desc;
+	if (q->tail == index) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	entry = &q->entry[index];
+	if (skb->len > entry->len) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	desc = &q->desc[index];
+	q->head = index;
+
+	dma_sync_single_for_cpu(wo->hw->dev, entry->addr, skb->len,
+				DMA_TO_DEVICE);
+	memcpy(entry->buf, skb->data, skb->len);
+	dma_sync_single_for_device(wo->hw->dev, entry->addr, skb->len,
+				   DMA_TO_DEVICE);
+
+	ctrl = FIELD_PREP(MTK_WED_WO_CTL_SD_LEN0, skb->len) |
+	       MTK_WED_WO_CTL_LAST_SEC0 | MTK_WED_WO_CTL_DMA_DONE;
+	WRITE_ONCE(desc->buf0, cpu_to_le32(entry->addr));
+	WRITE_ONCE(desc->ctrl, cpu_to_le32(ctrl));
+
+	mtk_wed_wo_queue_kick(wo, q, q->head);
+	mtk_wed_wo_kickout(wo);
+out:
+	spin_unlock_bh(&q->lock);
+
+	dev_kfree_skb(skb);
+
+	return ret;
+}
+
+static int
+mtk_wed_wo_exception_init(struct mtk_wed_wo *wo)
+{
+	return 0;
+}
+
+static int
+mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
+{
+	struct mtk_wed_wo_queue_regs regs;
+	struct device_node *np;
+	int ret;
+
+	np = of_parse_phandle(wo->hw->node, "mediatek,wo-ccif", 0);
+	if (!np)
+		return -ENODEV;
+
+	wo->mmio.regs = syscon_regmap_lookup_by_phandle(np, NULL);
+	if (IS_ERR_OR_NULL(wo->mmio.regs))
+		return PTR_ERR(wo->mmio.regs);
+
+	wo->mmio.irq = irq_of_parse_and_map(np, 0);
+	wo->mmio.irq_mask = MTK_WED_WO_ALL_INT_MASK;
+	spin_lock_init(&wo->mmio.lock);
+	tasklet_setup(&wo->mmio.irq_tasklet, mtk_wed_wo_irq_tasklet);
+
+	ret = devm_request_irq(wo->hw->dev, wo->mmio.irq,
+			       mtk_wed_wo_irq_handler, IRQF_TRIGGER_HIGH,
+			       KBUILD_MODNAME, wo);
+	if (ret)
+		goto error;
+
+	regs.desc_base = MTK_WED_WO_CCIF_DUMMY1;
+	regs.ring_size = MTK_WED_WO_CCIF_DUMMY2;
+	regs.dma_idx = MTK_WED_WO_CCIF_SHADOW4;
+	regs.cpu_idx = MTK_WED_WO_CCIF_DUMMY3;
+
+	ret = mtk_wed_wo_queue_alloc(wo, &wo->q_tx, MTK_WED_WO_RING_SIZE,
+				     MTK_WED_WO_CMD_LEN, MTK_WED_WO_TXCH_NUM,
+				     &regs);
+	if (ret)
+		goto error;
+
+	mtk_wed_wo_queue_refill(wo, &wo->q_tx, GFP_KERNEL, false);
+	mtk_wed_wo_queue_reset(wo, &wo->q_tx);
+
+	regs.desc_base = MTK_WED_WO_CCIF_DUMMY5;
+	regs.ring_size = MTK_WED_WO_CCIF_DUMMY6;
+	regs.dma_idx = MTK_WED_WO_CCIF_SHADOW8;
+	regs.cpu_idx = MTK_WED_WO_CCIF_DUMMY7;
+
+	ret = mtk_wed_wo_queue_alloc(wo, &wo->q_rx, MTK_WED_WO_RING_SIZE,
+				     MTK_WED_WO_CMD_LEN, MTK_WED_WO_RXCH_NUM,
+				     &regs);
+	if (ret)
+		goto error;
+
+	mtk_wed_wo_queue_refill(wo, &wo->q_rx, GFP_KERNEL, true);
+	mtk_wed_wo_queue_reset(wo, &wo->q_rx);
+
+	/* rx queue irqmask */
+	mtk_wed_wo_set_isr(wo, wo->mmio.irq_mask);
+
+	return 0;
+
+error:
+	devm_free_irq(wo->hw->dev, wo->mmio.irq, wo);
+
+	return ret;
+}
+
+static void
+mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
+{
+	/* disable interrupts */
+	mtk_wed_wo_set_isr(wo, 0);
+
+	tasklet_disable(&wo->mmio.irq_tasklet);
+
+	disable_irq(wo->mmio.irq);
+	devm_free_irq(wo->hw->dev, wo->mmio.irq, wo);
+
+	mtk_wed_wo_queue_tx_clean(wo, &wo->q_tx);
+	mtk_wed_wo_queue_rx_clean(wo, &wo->q_rx);
+	mtk_wed_wo_queue_free(wo, &wo->q_tx);
+	mtk_wed_wo_queue_free(wo, &wo->q_rx);
+}
+
+int mtk_wed_wo_init(struct mtk_wed_hw *hw)
+{
+	struct mtk_wed_wo *wo;
+	int ret;
+
+	wo = devm_kzalloc(hw->dev, sizeof(*wo), GFP_KERNEL);
+	if (!wo)
+		return -ENOMEM;
+
+	hw->wed_wo = wo;
+	wo->hw = hw;
+
+	ret = mtk_wed_wo_hardware_init(wo);
+	if (ret)
+		return ret;
+
+	ret = mtk_wed_mcu_init(wo);
+	if (ret)
+		return ret;
+
+	return mtk_wed_wo_exception_init(wo);
+}
+
+void mtk_wed_wo_deinit(struct mtk_wed_hw *hw)
+{
+	struct mtk_wed_wo *wo = hw->wed_wo;
+
+	mtk_wed_wo_hw_deinit(wo);
+}
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index 2ef3ccdec5bf..eda32e25288b 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -79,6 +79,54 @@ enum mtk_wed_dummy_cr_idx {
 #define MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK	BIT(5)
 #define MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK	BIT(0)
 
+#define MTK_WED_WO_RING_SIZE	256
+#define MTK_WED_WO_CMD_LEN	1504
+
+#define MTK_WED_WO_TXCH_NUM		0
+#define MTK_WED_WO_RXCH_NUM		1
+#define MTK_WED_WO_RXCH_WO_EXCEPTION	7
+
+#define MTK_WED_WO_TXCH_INT_MASK	BIT(0)
+#define MTK_WED_WO_RXCH_INT_MASK	BIT(1)
+#define MTK_WED_WO_EXCEPTION_INT_MASK	BIT(7)
+#define MTK_WED_WO_ALL_INT_MASK		(MTK_WED_WO_RXCH_INT_MASK | \
+					 MTK_WED_WO_EXCEPTION_INT_MASK)
+
+#define MTK_WED_WO_CCIF_BUSY		0x004
+#define MTK_WED_WO_CCIF_START		0x008
+#define MTK_WED_WO_CCIF_TCHNUM		0x00c
+#define MTK_WED_WO_CCIF_RCHNUM		0x010
+#define MTK_WED_WO_CCIF_RCHNUM_MASK	GENMASK(7, 0)
+
+#define MTK_WED_WO_CCIF_ACK		0x014
+#define MTK_WED_WO_CCIF_IRQ0_MASK	0x018
+#define MTK_WED_WO_CCIF_IRQ1_MASK	0x01c
+#define MTK_WED_WO_CCIF_DUMMY1		0x020
+#define MTK_WED_WO_CCIF_DUMMY2		0x024
+#define MTK_WED_WO_CCIF_DUMMY3		0x028
+#define MTK_WED_WO_CCIF_DUMMY4		0x02c
+#define MTK_WED_WO_CCIF_SHADOW1		0x030
+#define MTK_WED_WO_CCIF_SHADOW2		0x034
+#define MTK_WED_WO_CCIF_SHADOW3		0x038
+#define MTK_WED_WO_CCIF_SHADOW4		0x03c
+#define MTK_WED_WO_CCIF_DUMMY5		0x050
+#define MTK_WED_WO_CCIF_DUMMY6		0x054
+#define MTK_WED_WO_CCIF_DUMMY7		0x058
+#define MTK_WED_WO_CCIF_DUMMY8		0x05c
+#define MTK_WED_WO_CCIF_SHADOW5		0x060
+#define MTK_WED_WO_CCIF_SHADOW6		0x064
+#define MTK_WED_WO_CCIF_SHADOW7		0x068
+#define MTK_WED_WO_CCIF_SHADOW8		0x06c
+
+#define MTK_WED_WO_CTL_SD_LEN1		GENMASK(13, 0)
+#define MTK_WED_WO_CTL_LAST_SEC1	BIT(14)
+#define MTK_WED_WO_CTL_BURST		BIT(15)
+#define MTK_WED_WO_CTL_SD_LEN0_SHIFT	16
+#define MTK_WED_WO_CTL_SD_LEN0		GENMASK(29, 16)
+#define MTK_WED_WO_CTL_LAST_SEC0	BIT(30)
+#define MTK_WED_WO_CTL_DMA_DONE		BIT(31)
+#define MTK_WED_WO_INFO_WINFO		GENMASK(15, 0)
+
 struct mtk_wed_wo_memory_region {
 	const char *name;
 	void __iomem *addr;
@@ -111,10 +159,53 @@ struct mtk_wed_fw_trailer {
 	u32 crc;
 };
 
+struct mtk_wed_wo_queue_regs {
+	u32 desc_base;
+	u32 ring_size;
+	u32 cpu_idx;
+	u32 dma_idx;
+};
+
+struct mtk_wed_wo_queue_desc {
+	__le32 buf0;
+	__le32 ctrl;
+	__le32 buf1;
+	__le32 info;
+	__le32 reserved[4];
+} __packed __aligned(32);
+
+struct mtk_wed_wo_queue_entry {
+	dma_addr_t addr;
+	void *buf;
+	u32 len;
+};
+
+struct mtk_wed_wo_queue {
+	struct mtk_wed_wo_queue_regs regs;
+
+	struct page_frag_cache cache;
+	spinlock_t lock;
+
+	struct mtk_wed_wo_queue_desc *desc;
+	dma_addr_t desc_dma;
+
+	struct mtk_wed_wo_queue_entry *entry;
+
+	u16 head;
+	u16 tail;
+	int n_desc;
+	int queued;
+	int buf_size;
+
+};
+
 struct mtk_wed_wo {
 	struct mtk_wed_hw *hw;
 	struct regmap *boot;
 
+	struct mtk_wed_wo_queue q_tx;
+	struct mtk_wed_wo_queue q_rx;
+
 	struct {
 		struct mutex mutex;
 		int timeout;
@@ -123,6 +214,15 @@ struct mtk_wed_wo {
 		struct sk_buff_head res_q;
 		wait_queue_head_t wait;
 	} mcu;
+
+	struct {
+		struct regmap *regs;
+
+		spinlock_t lock;
+		struct tasklet_struct irq_tasklet;
+		int irq;
+		u32 irq_mask;
+	} mmio;
 };
 
 static inline int
@@ -148,5 +248,9 @@ void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
 int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
 			 const void *data, int len, bool wait_resp);
 int mtk_wed_mcu_init(struct mtk_wed_wo *wo);
+int mtk_wed_wo_init(struct mtk_wed_hw *hw);
+void mtk_wed_wo_deinit(struct mtk_wed_hw *hw);
+int mtk_wed_wo_queue_tx_skb(struct mtk_wed_wo *dev, struct mtk_wed_wo_queue *q,
+			    struct sk_buff *skb);
 
 #endif /* __MTK_WED_WO_H */
-- 
2.38.1

