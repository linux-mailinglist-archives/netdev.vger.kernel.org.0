Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20876829EF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjAaKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjAaKGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:06:25 -0500
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3834B8A2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:06:21 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159575tcwg3502
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:14 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: rZJGTgY0+YPb92DdUW7QHzINapvmHCqqpMj4Ppg1Ih3EGyqTrWrHvPsR44ViH
        uW2dwVNo2C1PtTMxfTqMJQVx1ufTm0azFUGM4khn+SrNAi81yMoVdyEaUc+j2yQWOIVZ8AK
        jetn664i/12fosn8oL9Y1T2b2T9JepUVcSQm/unV+ywSvgcePnoUQ/DMhoYWbPpHdxprcGT
        FSAi6FNGNnGte7Jhw2Jt5saWMF++mACE6QDf/gDnfnm57oLHCOrzSZ5wb/NpZqbbMtxgrkv
        eX4SB5mq4HxlL1E1LL8T62cvuBVHmC1I+JlLGj4JWL8W95YoyYp1e5PW//tIUn55CNY73JN
        AuK2zFvb2yahDMvpScpgkgEalsBLvSDbNAxWnCYM7OMNmdNkUCywsW58c8t+lgKOpxdcwt/
        ebo6RJLy2/io5PkahF25vENllt7bTct/
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 05/10] net: libwx: Allocate Rx and Tx resources
Date:   Tue, 31 Jan 2023 18:05:36 +0800
Message-Id: <20230131100541.73757-6-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131100541.73757-1-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiawen Wu <jiawenwu@trustnetic.com>

Setup Rx and Tx descriptors for specefic rings.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/Kconfig         |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   |   8 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 304 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h  |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  74 +++++
 5 files changed, 389 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 0922beac3ec0..c9d88673d306 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_WANGXUN
 
 config LIBWX
 	tristate
+	select PAGE_POOL
 	help
 	Common library for Wangxun(R) Ethernet drivers.
 
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 554d0875bc62..a9a6bfff58ef 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1335,12 +1335,16 @@ static void wx_configure_tx_ring(struct wx *wx,
 {
 	u32 txdctl = WX_PX_TR_CFG_ENABLE;
 	u8 reg_idx = ring->reg_idx;
+	u64 tdba = ring->dma;
 	int ret;
 
 	/* disable queue to avoid issues while updating state */
 	wr32(wx, WX_PX_TR_CFG(reg_idx), WX_PX_TR_CFG_SWFLSH);
 	WX_WRITE_FLUSH(wx);
 
+	wr32(wx, WX_PX_TR_BAL(reg_idx), tdba & DMA_BIT_MASK(32));
+	wr32(wx, WX_PX_TR_BAH(reg_idx), tdba >> 32);
+
 	/* reset head and tail pointers */
 	wr32(wx, WX_PX_TR_RP(reg_idx), 0);
 	wr32(wx, WX_PX_TR_WP(reg_idx), 0);
@@ -1364,12 +1368,16 @@ static void wx_configure_rx_ring(struct wx *wx,
 				 struct wx_ring *ring)
 {
 	u16 reg_idx = ring->reg_idx;
+	u64 rdba = ring->dma;
 	u32 rxdctl;
 
 	/* disable queue to avoid issues while updating state */
 	rxdctl = rd32(wx, WX_PX_RR_CFG(reg_idx));
 	wx_disable_rx_queue(wx, ring);
 
+	wr32(wx, WX_PX_RR_BAL(reg_idx), rdba & DMA_BIT_MASK(32));
+	wr32(wx, WX_PX_RR_BAH(reg_idx), rdba >> 32);
+
 	if (ring->count == WX_MAX_RXD)
 		rxdctl |= 0 << WX_PX_RR_CFG_RR_SIZE_SHIFT;
 	else
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 76711087c184..e4d1feaa1c95 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/etherdevice.h>
+#include <net/page_pool.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 
@@ -192,6 +193,9 @@ static int wx_alloc_q_vector(struct wx *wx,
 	wx->q_vector[v_idx] = q_vector;
 	q_vector->wx = wx;
 	q_vector->v_idx = v_idx;
+	if (cpu_online(v_idx))
+		q_vector->numa_node = cpu_to_node(v_idx);
+
 
 	/* initialize work limits */
 	q_vector->tx.work_limit = wx->tx_work_limit;
@@ -610,4 +614,304 @@ void wx_configure_vectors(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_configure_vectors);
 
+/**
+ * wx_free_rx_resources - Free Rx Resources
+ * @rx_ring: ring to clean the resources from
+ *
+ * Free all receive software resources
+ **/
+static void wx_free_rx_resources(struct wx_ring *rx_ring)
+{
+	kvfree(rx_ring->rx_buffer_info);
+	rx_ring->rx_buffer_info = NULL;
+
+	/* if not set, then don't free */
+	if (!rx_ring->desc)
+		return;
+
+	dma_free_coherent(rx_ring->dev, rx_ring->size,
+			  rx_ring->desc, rx_ring->dma);
+
+	rx_ring->desc = NULL;
+
+	if (rx_ring->page_pool) {
+		page_pool_destroy(rx_ring->page_pool);
+		rx_ring->page_pool = NULL;
+	}
+}
+
+/**
+ * wx_free_all_rx_resources - Free Rx Resources for All Queues
+ * @wx: pointer to hardware structure
+ *
+ * Free all receive software resources
+ **/
+static void wx_free_all_rx_resources(struct wx *wx)
+{
+	int i;
+
+	for (i = 0; i < wx->num_rx_queues; i++)
+		wx_free_rx_resources(wx->rx_ring[i]);
+}
+
+/**
+ * wx_free_tx_resources - Free Tx Resources per Queue
+ * @tx_ring: Tx descriptor ring for a specific queue
+ *
+ * Free all transmit software resources
+ **/
+static void wx_free_tx_resources(struct wx_ring *tx_ring)
+{
+	kvfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+
+	/* if not set, then don't free */
+	if (!tx_ring->desc)
+		return;
+
+	dma_free_coherent(tx_ring->dev, tx_ring->size,
+			  tx_ring->desc, tx_ring->dma);
+	tx_ring->desc = NULL;
+}
+
+/**
+ * wx_free_all_tx_resources - Free Tx Resources for All Queues
+ * @wx: pointer to hardware structure
+ *
+ * Free all transmit software resources
+ **/
+static void wx_free_all_tx_resources(struct wx *wx)
+{
+	int i;
+
+	for (i = 0; i < wx->num_tx_queues; i++)
+		wx_free_tx_resources(wx->tx_ring[i]);
+}
+
+void wx_free_resources(struct wx *wx)
+{
+	wx_free_isb_resources(wx);
+	wx_free_all_rx_resources(wx);
+	wx_free_all_tx_resources(wx);
+}
+EXPORT_SYMBOL(wx_free_resources);
+
+static int wx_alloc_page_pool(struct wx_ring *rx_ring)
+{
+	int ret = 0;
+
+	struct page_pool_params pp_params = {
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.order = 0,
+		.pool_size = rx_ring->size,
+		.nid = dev_to_node(rx_ring->dev),
+		.dev = rx_ring->dev,
+		.dma_dir = DMA_FROM_DEVICE,
+		.offset = 0,
+		.max_len = PAGE_SIZE,
+	};
+
+	rx_ring->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rx_ring->page_pool)) {
+		rx_ring->page_pool = NULL;
+		ret = PTR_ERR(rx_ring->page_pool);
+	}
+
+	return ret;
+}
+
+/**
+ * wx_setup_rx_resources - allocate Rx resources (Descriptors)
+ * @rx_ring: rx descriptor ring (for a specific queue) to setup
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int wx_setup_rx_resources(struct wx_ring *rx_ring)
+{
+	struct device *dev = rx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = NUMA_NO_NODE;
+	int size, ret;
+
+	size = sizeof(struct wx_rx_buffer) * rx_ring->count;
+
+	if (rx_ring->q_vector)
+		numa_node = rx_ring->q_vector->numa_node;
+
+	rx_ring->rx_buffer_info = kvmalloc_node(size, GFP_KERNEL, numa_node);
+	if (!rx_ring->rx_buffer_info)
+		rx_ring->rx_buffer_info = kvmalloc(size, GFP_KERNEL);
+	if (!rx_ring->rx_buffer_info)
+		goto err;
+
+	/* Round up to nearest 4K */
+	rx_ring->size = rx_ring->count * sizeof(union wx_rx_desc);
+	rx_ring->size = ALIGN(rx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
+					   &rx_ring->dma, GFP_KERNEL);
+	if (!rx_ring->desc) {
+		set_dev_node(dev, orig_node);
+		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
+						   &rx_ring->dma, GFP_KERNEL);
+	}
+
+	if (!rx_ring->desc)
+		goto err;
+
+	ret = wx_alloc_page_pool(rx_ring);
+	if (ret < 0) {
+		dev_err(rx_ring->dev, "Page pool creation failed: %d\n", ret);
+		goto err;
+	}
+
+	return 0;
+err:
+	kvfree(rx_ring->rx_buffer_info);
+	rx_ring->rx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * wx_setup_all_rx_resources - allocate all queues Rx resources
+ * @wx: pointer to hardware structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int wx_setup_all_rx_resources(struct wx *wx)
+{
+	int i, err = 0;
+
+	for (i = 0; i < wx->num_rx_queues; i++) {
+		err = wx_setup_rx_resources(wx->rx_ring[i]);
+		if (!err)
+			continue;
+
+		wx_err(wx, "Allocation for Rx Queue %u failed\n", i);
+		goto err_setup_rx;
+	}
+
+		return 0;
+err_setup_rx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		wx_free_rx_resources(wx->rx_ring[i]);
+	return err;
+}
+
+/**
+ * wx_setup_tx_resources - allocate Tx resources (Descriptors)
+ * @tx_ring: tx descriptor ring (for a specific queue) to setup
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int wx_setup_tx_resources(struct wx_ring *tx_ring)
+{
+	struct device *dev = tx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = NUMA_NO_NODE;
+	int size;
+
+	size = sizeof(struct wx_tx_buffer) * tx_ring->count;
+
+	if (tx_ring->q_vector)
+		numa_node = tx_ring->q_vector->numa_node;
+
+	tx_ring->tx_buffer_info = kvmalloc_node(size, GFP_KERNEL, numa_node);
+	if (!tx_ring->tx_buffer_info)
+		tx_ring->tx_buffer_info = kvmalloc(size, GFP_KERNEL);
+	if (!tx_ring->tx_buffer_info)
+		goto err;
+
+	/* round up to nearest 4K */
+	tx_ring->size = tx_ring->count * sizeof(union wx_tx_desc);
+	tx_ring->size = ALIGN(tx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	tx_ring->desc = dma_alloc_coherent(dev, tx_ring->size,
+					   &tx_ring->dma, GFP_KERNEL);
+	if (!tx_ring->desc) {
+		set_dev_node(dev, orig_node);
+		tx_ring->desc = dma_alloc_coherent(dev, tx_ring->size,
+						   &tx_ring->dma, GFP_KERNEL);
+	}
+
+	if (!tx_ring->desc)
+		goto err;
+
+	return 0;
+
+err:
+	kvfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Tx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * wx_setup_all_tx_resources - allocate all queues Tx resources
+ * @wx: pointer to private structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int wx_setup_all_tx_resources(struct wx *wx)
+{
+	int i, err = 0;
+
+	for (i = 0; i < wx->num_tx_queues; i++) {
+		err = wx_setup_tx_resources(wx->tx_ring[i]);
+		if (!err)
+			continue;
+
+		wx_err(wx, "Allocation for Tx Queue %u failed\n", i);
+		goto err_setup_tx;
+	}
+
+	return 0;
+err_setup_tx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		wx_free_tx_resources(wx->tx_ring[i]);
+	return err;
+}
+
+int wx_setup_resources(struct wx *wx)
+{
+	int err;
+
+	/* allocate transmit descriptors */
+	err = wx_setup_all_tx_resources(wx);
+	if (err)
+		return err;
+
+	/* allocate receive descriptors */
+	err = wx_setup_all_rx_resources(wx);
+	if (err)
+		goto err_free_tx;
+
+	err = wx_setup_isb_resources(wx);
+	if (err)
+		goto err_free_rx;
+
+	return 0;
+
+err_free_rx:
+	wx_free_all_rx_resources(wx);
+err_free_tx:
+	wx_free_all_tx_resources(wx);
+
+	return err;
+}
+EXPORT_SYMBOL(wx_setup_resources);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.h b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
index 8ae657155f34..6fa95752fc42 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.h
@@ -16,5 +16,7 @@ int wx_setup_isb_resources(struct wx *wx);
 void wx_free_isb_resources(struct wx *wx);
 u32 wx_misc_isb(struct wx *wx, enum wx_isb_idx idx);
 void wx_configure_vectors(struct wx *wx);
+void wx_free_resources(struct wx *wx);
+int wx_setup_resources(struct wx *wx);
 
 #endif /* _NGBE_LIB_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 988878ddba47..1863c6cbc6c6 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -432,6 +432,71 @@ enum wx_reset_type {
 	WX_GLOBAL_RESET
 };
 
+/* Transmit Descriptor */
+union wx_tx_desc {
+	struct {
+		__le64 buffer_addr; /* Address of descriptor's data buf */
+		__le32 cmd_type_len;
+		__le32 olinfo_status;
+	} read;
+	struct {
+		__le64 rsvd; /* Reserved */
+		__le32 nxtseq_seed;
+		__le32 status;
+	} wb;
+};
+
+/* Receive Descriptor */
+union wx_rx_desc {
+	struct {
+		__le64 pkt_addr; /* Packet buffer address */
+		__le64 hdr_addr; /* Header buffer address */
+	} read;
+	struct {
+		struct {
+			union {
+				__le32 data;
+				struct {
+					__le16 pkt_info; /* RSS, Pkt type */
+					__le16 hdr_info; /* Splithdr, hdrlen */
+				} hs_rss;
+			} lo_dword;
+			union {
+				__le32 rss; /* RSS Hash */
+				struct {
+					__le16 ip_id; /* IP id */
+					__le16 csum; /* Packet Checksum */
+				} csum_ip;
+			} hi_dword;
+		} lower;
+		struct {
+			__le32 status_error; /* ext status/error */
+			__le16 length; /* Packet length */
+			__le16 vlan; /* VLAN tag */
+		} upper;
+	} wb;  /* writeback */
+};
+
+/* wrapper around a pointer to a socket buffer,
+ * so a DMA handle can be stored along with the buffer
+ */
+struct wx_tx_buffer {
+	union wx_tx_desc *next_to_watch;
+	struct sk_buff *skb;
+	unsigned int bytecount;
+	unsigned short gso_segs;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
+struct wx_rx_buffer {
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	dma_addr_t page_dma;
+	struct page *page;
+	unsigned int page_offset;
+};
+
 /* iterator for handling rings in ring container */
 #define wx_for_each_ring(posm, headm) \
 	for (posm = (headm).ring; posm; posm = posm->next)
@@ -448,7 +513,15 @@ struct wx_ring {
 	struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	struct page_pool *page_pool;
+	void *desc;                     /* descriptor ring memory */
+	union {
+		struct wx_tx_buffer *tx_buffer_info;
+		struct wx_rx_buffer *rx_buffer_info;
+	};
 	u8 __iomem *tail;
+	dma_addr_t dma;                 /* phys. address of descriptor ring */
+	unsigned int size;              /* length in bytes */
 
 	u16 count;                      /* amount of descriptors */
 
@@ -463,6 +536,7 @@ struct wx_ring {
 struct wx_q_vector {
 	struct wx *wx;
 	int cpu;        /* CPU for DCA */
+	int numa_node;
 	u16 v_idx;      /* index of q_vector within array, also used for
 			 * finding the bit in EICR and friends that
 			 * represents the vector for this ring
-- 
2.39.1

