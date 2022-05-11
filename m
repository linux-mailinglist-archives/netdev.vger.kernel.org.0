Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1378B522A5E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbiEKDUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72806CAA5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:25 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239158tqis0o0l
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:17 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: Ut0pB98mtT9mtSCSBynrgoyfuPVBQ8pufGX+r35HUwclcKDf5R0eTJrhgnIps
        vGQaWi3xlbE0pdxGi3Mh6bTqmYLYbnaI3ykwb4sfOix5b7ICus8Ao3HpyNoZHS2jMMuUG2L
        2etqcGBVZ5cKFnP5B9/ILcuSCh0GNO+ufCz/6V7CsxFtuOefCfpMFityYh2seHhcAHioo0m
        fK92X/fVp8TY3bxiYO8JErmwEtUfQjqcz6C3SlI7ptoXYtVe+Iki5SjISVwKBjir6yxBd9k
        B/Jwcmtt/g74eSyi2NCCV4Oqnnw6ctbCb4FPvRKCz130+EVqorxzs2EQm8epHV1n7hnn2Fn
        WhDJDn43qVJGs5hgPZ+tzNxAYLoooFIsHJDLtQX
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 06/14] net: txgbe: Support to receive and tranmit packets
Date:   Wed, 11 May 2022 11:26:51 +0800
Message-Id: <20220511032659.641834-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for passing traffic. It is enabled to RSS on Rx queues.
Tx path support TSO, checksum, etc.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  308 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  751 ++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   75 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |   62 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 6003 ++++++++++++++---
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  372 +-
 6 files changed, 6510 insertions(+), 1061 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index c5a02f1950ae..487e38007ccc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -7,6 +7,8 @@
 #include <net/ip.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
+#include <linux/if_vlan.h>
+#include <linux/sctp.h>
 #include <linux/etherdevice.h>
 #include <linux/timecounter.h>
 #include <linux/clocksource.h>
@@ -18,26 +20,238 @@
 #define MAX_REQUEST_SIZE 256
 #endif
 
+/* Ether Types */
+#define TXGBE_ETH_P_CNM                         0x22E7
+
+/* TX/RX descriptor defines */
+#define TXGBE_DEFAULT_TXD               512
+#define TXGBE_DEFAULT_TX_WORK   256
+#define TXGBE_MAX_TXD                   8192
+#define TXGBE_MIN_TXD                   128
+
+#if (PAGE_SIZE < 8192)
+#define TXGBE_DEFAULT_RXD               512
+#define TXGBE_DEFAULT_RX_WORK   256
+#else
+#define TXGBE_DEFAULT_RXD               256
+#define TXGBE_DEFAULT_RX_WORK   128
+#endif
+
+#define TXGBE_MAX_RXD                   8192
+#define TXGBE_MIN_RXD                   128
+
+/* Supported Rx Buffer Sizes */
+#define TXGBE_RXBUFFER_256       256  /* Used for skb receive header */
+#define TXGBE_RXBUFFER_2K       2048
+#define TXGBE_RXBUFFER_3K       3072
+#define TXGBE_RXBUFFER_4K       4096
+#define TXGBE_MAX_RXBUFFER      16384  /* largest size for single descriptor */
+
+/* NOTE: netdev_alloc_skb reserves up to 64 bytes, NET_IP_ALIGN means we
+ * reserve 64 more, and skb_shared_info adds an additional 320 bytes more,
+ * this adds up to 448 bytes of extra data.
+ *
+ * Since netdev_alloc_skb now allocates a page fragment we can use a value
+ * of 256 and the resultant skb will have a truesize of 960 or less.
+ */
+#define TXGBE_RX_HDR_SIZE       TXGBE_RXBUFFER_256
+
+/* How many Rx Buffers do we bundle into one write to the hardware ? */
+#define TXGBE_RX_BUFFER_WRITE   16      /* Must be power of 2 */
+#define TXGBE_RX_DMA_ATTR \
+	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+enum txgbe_tx_flags {
+	/* cmd_type flags */
+	TXGBE_TX_FLAGS_HW_VLAN  = 0x01,
+	TXGBE_TX_FLAGS_TSO      = 0x02,
+	TXGBE_TX_FLAGS_TSTAMP   = 0x04,
+
+	/* olinfo flags */
+	TXGBE_TX_FLAGS_CC       = 0x08,
+	TXGBE_TX_FLAGS_IPV4     = 0x10,
+	TXGBE_TX_FLAGS_CSUM     = 0x20,
+	TXGBE_TX_FLAGS_OUTER_IPV4 = 0x100,
+	TXGBE_TX_FLAGS_LINKSEC	= 0x200,
+	TXGBE_TX_FLAGS_IPSEC    = 0x400,
+
+	/* software defined flags */
+	TXGBE_TX_FLAGS_SW_VLAN  = 0x40,
+	TXGBE_TX_FLAGS_FCOE     = 0x80,
+};
+
+/* VLAN info */
+#define TXGBE_TX_FLAGS_VLAN_MASK        0xffff0000
+#define TXGBE_TX_FLAGS_VLAN_PRIO_MASK   0xe0000000
+#define TXGBE_TX_FLAGS_VLAN_PRIO_SHIFT  29
+#define TXGBE_TX_FLAGS_VLAN_SHIFT       16
+
+#define TXGBE_MAX_RX_DESC_POLL          10
+
+#define TXGBE_MAX_PF_MACVLANS           15
+
+#define TXGBE_MAX_TXD_PWR       14
+#define TXGBE_MAX_DATA_PER_TXD  (1 << TXGBE_MAX_TXD_PWR)
+
+/* Tx Descriptors needed, worst case */
+#define TXD_USE_COUNT(S)        DIV_ROUND_UP((S), TXGBE_MAX_DATA_PER_TXD)
+#ifndef MAX_SKB_FRAGS
+#define DESC_NEEDED     4
+#elif (MAX_SKB_FRAGS < 16)
+#define DESC_NEEDED     ((MAX_SKB_FRAGS * TXD_USE_COUNT(PAGE_SIZE)) + 4)
+#else
+#define DESC_NEEDED     (MAX_SKB_FRAGS + 4)
+#endif
+
+/* wrapper around a pointer to a socket buffer,
+ * so a DMA handle can be stored along with the buffer
+ */
+struct txgbe_tx_buffer {
+	union txgbe_tx_desc *next_to_watch;
+	struct sk_buff *skb;
+	unsigned int bytecount;
+	unsigned short gso_segs;
+	__be16 protocol;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+	DEFINE_DMA_UNMAP_LEN(len);
+	u32 tx_flags;
+};
+
+struct txgbe_rx_buffer {
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	dma_addr_t page_dma;
+	struct page *page;
+	unsigned int page_offset;
+};
+
+struct txgbe_queue_stats {
+	u64 packets;
+	u64 bytes;
+};
+
+struct txgbe_tx_queue_stats {
+	u64 restart_queue;
+	u64 tx_busy;
+	u64 tx_done_old;
+};
+
+struct txgbe_rx_queue_stats {
+	u64 rsc_count;
+	u64 rsc_flush;
+	u64 non_eop_descs;
+	u64 alloc_rx_page_failed;
+	u64 alloc_rx_buff_failed;
+	u64 csum_good_cnt;
+	u64 csum_err;
+};
+
+enum txgbe_ring_state_t {
+	__TXGBE_RX_BUILD_SKB_ENABLED,
+	__TXGBE_TX_XPS_INIT_DONE,
+	__TXGBE_TX_DETECT_HANG,
+	__TXGBE_HANG_CHECK_ARMED,
+	__TXGBE_RX_RSC_ENABLED,
+};
+
+struct txgbe_fwd_adapter {
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	struct txgbe_adapter *adapter;
+};
+
+#define ring_uses_build_skb(ring) \
+	test_bit(__TXGBE_RX_BUILD_SKB_ENABLED, &(ring)->state)
+
+#define check_for_tx_hang(ring) \
+	test_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
+#define set_check_for_tx_hang(ring) \
+	set_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
+#define clear_check_for_tx_hang(ring) \
+	clear_bit(__TXGBE_TX_DETECT_HANG, &(ring)->state)
+#define ring_is_rsc_enabled(ring) \
+	test_bit(__TXGBE_RX_RSC_ENABLED, &(ring)->state)
+#define set_ring_rsc_enabled(ring) \
+	set_bit(__TXGBE_RX_RSC_ENABLED, &(ring)->state)
+#define clear_ring_rsc_enabled(ring) \
+	clear_bit(__TXGBE_RX_RSC_ENABLED, &(ring)->state)
+
 struct txgbe_ring {
 	struct txgbe_ring *next;        /* pointer to next ring in q_vector */
 	struct txgbe_q_vector *q_vector; /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	struct txgbe_fwd_adapter *accel;
+	void *desc;                     /* descriptor ring memory */
+	union {
+		struct txgbe_tx_buffer *tx_buffer_info;
+		struct txgbe_rx_buffer *rx_buffer_info;
+	};
+	unsigned long state;
+	u8 __iomem *tail;
+	dma_addr_t dma;                 /* phys. address of descriptor ring */
+	unsigned int size;              /* length in bytes */
+
 	u16 count;                      /* amount of descriptors */
 
 	u8 queue_index; /* needed for multiqueue queue management */
 	u8 reg_idx;
+	u16 next_to_use;
+	u16 next_to_clean;
+	u16 rx_buf_len;
+	u16 next_to_alloc;
+	struct txgbe_queue_stats stats;
+	struct u64_stats_sync syncp;
+
+	union {
+		struct txgbe_tx_queue_stats tx_stats;
+		struct txgbe_rx_queue_stats rx_stats;
+	};
 } ____cacheline_internodealigned_in_smp;
 
+enum txgbe_ring_f_enum {
+	RING_F_NONE = 0,
+	RING_F_RSS,
+	RING_F_ARRAY_SIZE  /* must be last in enum set */
+};
+
+#define TXGBE_MAX_RSS_INDICES           63
 #define TXGBE_MAX_FDIR_INDICES          63
 
 #define MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 #define MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
 
+#define TXGBE_MAX_MACVLANS      32
+
+struct txgbe_ring_feature {
+	u16 limit;      /* upper limit on feature indices */
+	u16 indices;    /* current value of indices */
+	u16 mask;       /* Mask used for feature to ring mapping */
+	u16 offset;     /* offset to start of feature */
+};
+
+static inline unsigned int txgbe_rx_bufsz(struct txgbe_ring __maybe_unused *ring)
+{
+#if MAX_SKB_FRAGS < 8
+	return ALIGN(TXGBE_MAX_RXBUFFER / MAX_SKB_FRAGS, 1024);
+#else
+	return TXGBE_RXBUFFER_2K;
+#endif
+}
+
+static inline unsigned int txgbe_rx_pg_order(struct txgbe_ring __maybe_unused *ring)
+{
+	return 0;
+}
+
+#define txgbe_rx_pg_size(_ring) (PAGE_SIZE << txgbe_rx_pg_order(_ring))
+
 struct txgbe_ring_container {
 	struct txgbe_ring *ring;        /* pointer to linked list of rings */
+	unsigned int total_bytes;       /* total bytes processed this int */
+	unsigned int total_packets;     /* total packets processed this int */
 	u16 work_limit;                 /* total work allowed per interrupt */
 	u8 count;                       /* total number of rings in vector */
+	u8 itr;                         /* current ITR setting for ring */
 };
 
 /* iterator for handling rings in ring container */
@@ -70,11 +284,37 @@ struct txgbe_q_vector {
 /* microsecond values for various ITR rates shifted by 2 to fit itr register
  * with the first 3 bits reserved 0
  */
+#define TXGBE_MIN_RSC_ITR       24
 #define TXGBE_100K_ITR          40
 #define TXGBE_20K_ITR           200
 #define TXGBE_16K_ITR           248
 #define TXGBE_12K_ITR           336
 
+/* txgbe_test_staterr - tests bits in Rx descriptor status and error fields */
+static inline __le32 txgbe_test_staterr(union txgbe_rx_desc *rx_desc,
+					const u32 stat_err_bits)
+{
+	return rx_desc->wb.upper.status_error & cpu_to_le32(stat_err_bits);
+}
+
+/* txgbe_desc_unused - calculate if we have unused descriptors */
+static inline u16 txgbe_desc_unused(struct txgbe_ring *ring)
+{
+	u16 ntc = ring->next_to_clean;
+	u16 ntu = ring->next_to_use;
+
+	return ((ntc > ntu) ? 0 : ring->count) + ntc - ntu - 1;
+}
+
+#define TXGBE_RX_DESC(R, i)     \
+	(&(((union txgbe_rx_desc *)((R)->desc))[i]))
+#define TXGBE_TX_DESC(R, i)     \
+	(&(((union txgbe_tx_desc *)((R)->desc))[i]))
+#define TXGBE_TX_CTXTDESC(R, i) \
+	(&(((struct txgbe_tx_context_desc *)((R)->desc))[i]))
+
+#define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
+
 #define TCP_TIMER_VECTOR        0
 #define OTHER_VECTOR    1
 #define NON_Q_VECTORS   (OTHER_VECTOR + TCP_TIMER_VECTOR)
@@ -108,6 +348,8 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG_NEED_LINK_CONFIG             ((u32)(1 << 1))
 #define TXGBE_FLAG_MSI_ENABLED                  ((u32)(1 << 2))
 #define TXGBE_FLAG_MSIX_ENABLED                 ((u32)(1 << 3))
+#define TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE        ((u32)(1 << 4))
+#define TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE         ((u32)(1 << 5))
 
 /**
  * txgbe_adapter.flag2
@@ -118,6 +360,16 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_PF_RESET_REQUESTED          (1U << 3)
 #define TXGBE_FLAG2_RESET_INTR_RECEIVED         (1U << 4)
 #define TXGBE_FLAG2_GLOBAL_RESET_REQUESTED      (1U << 5)
+#define TXGBE_FLAG2_RSC_CAPABLE                 (1U << 6)
+#define TXGBE_FLAG2_RSC_ENABLED                 (1U << 7)
+#define TXGBE_FLAG2_RSS_FIELD_IPV4_UDP          (1U << 8)
+#define TXGBE_FLAG2_RSS_FIELD_IPV6_UDP          (1U << 9)
+#define TXGBE_FLAG2_RSS_ENABLED                 (1U << 10)
+
+#define TXGBE_SET_FLAG(_input, _flag, _result) \
+	((_flag <= _result) ? \
+	 ((u32)(_input & _flag) * (_result / _flag)) : \
+	 ((u32)(_input & _flag) / (_flag / _result)))
 
 enum txgbe_isb_idx {
 	TXGBE_ISB_HEADER,
@@ -129,6 +381,7 @@ enum txgbe_isb_idx {
 
 /* board specific private data structure */
 struct txgbe_adapter {
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
@@ -155,20 +408,34 @@ struct txgbe_adapter {
 	/* TX */
 	struct txgbe_ring *tx_ring[MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
 
+	u64 restart_queue;
 	u64 lsc_int;
+	u32 tx_timeout_count;
 
 	/* RX */
 	struct txgbe_ring *rx_ring[MAX_RX_QUEUES];
+	u64 hw_csum_rx_error;
+	u64 hw_csum_rx_good;
+	u64 hw_rx_no_dma_resources;
+	u64 rsc_total_count;
+	u64 rsc_total_flush;
+	u64 non_eop_descs;
+	u32 alloc_rx_page_failed;
+	u32 alloc_rx_buff_failed;
+
 	struct txgbe_q_vector *q_vector[MAX_MSIX_Q_VECTORS];
 
 	int num_q_vectors;      /* current number of q_vectors for device */
 	int max_q_vectors;      /* upper limit of q_vectors for device */
+	struct txgbe_ring_feature ring_feature[RING_F_ARRAY_SIZE];
 	struct msix_entry *msix_entries;
 
 	/* structs defined in txgbe_hw.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
+	struct txgbe_hw_stats stats;
 
+	u64 tx_busy;
 	unsigned int tx_ring_count;
 	unsigned int rx_ring_count;
 
@@ -189,6 +456,14 @@ struct txgbe_adapter {
 
 	struct txgbe_mac_addr *mac_table;
 
+	__le16 vxlan_port;
+	unsigned long fwd_bitmask; /* bitmask indicating in use pools */
+
+#define TXGBE_MAX_RETA_ENTRIES 128
+	u8 rss_indir_tbl[TXGBE_MAX_RETA_ENTRIES];
+#define TXGBE_RSS_KEY_SIZE     40
+	u32 rss_key[TXGBE_RSS_KEY_SIZE / sizeof(u32)];
+
 	/* misc interrupt status block */
 	dma_addr_t isb_dma;
 	u32 *isb_mem;
@@ -223,18 +498,49 @@ enum txgbe_state_t {
 	__TXGBE_PTP_TX_IN_PROGRESS,
 };
 
+struct txgbe_cb {
+	dma_addr_t dma;
+	u16     append_cnt;      /* number of skb's appended */
+	bool    page_released;
+	bool    dma_released;
+};
+
+#define TXGBE_CB(skb) ((struct txgbe_cb *)(skb)->cb)
+
 void txgbe_irq_disable(struct txgbe_adapter *adapter);
 void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush);
 int txgbe_open(struct net_device *netdev);
 int txgbe_close(struct net_device *netdev);
 void txgbe_up(struct txgbe_adapter *adapter);
 void txgbe_down(struct txgbe_adapter *adapter);
+int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring);
+int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring);
+void txgbe_free_rx_resources(struct txgbe_ring *rx_ring);
+void txgbe_free_tx_resources(struct txgbe_ring *tx_ring);
+void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring);
+void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring);
 int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
+				  struct txgbe_adapter *adapter,
+				  struct txgbe_ring *tx_ring);
+void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
+				      struct txgbe_tx_buffer *tx_buffer);
+void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count);
+void txgbe_set_rx_mode(struct net_device *netdev);
+void txgbe_tx_ctxtdesc(struct txgbe_ring *tx_ring, u32 vlan_macip_lens,
+		       u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
+int txgbe_poll(struct napi_struct *napi, int budget);
 
+static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
+{
+	return netdev_get_tx_queue(ring->netdev, ring->queue_index);
+}
 
 /**
  * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
@@ -274,6 +580,8 @@ static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
 	/* skip the flush */
 }
 
+#define TXGBE_RING_SIZE(R) ((R)->count < TXGBE_MAX_TXD ? (R)->count / 128 : 0)
+
 #define TXGBE_CPU_TO_BE16(_x) cpu_to_be16(_x)
 #define TXGBE_BE16_TO_CPU(_x) be16_to_cpu(_x)
 #define TXGBE_CPU_TO_BE32(_x) cpu_to_be32(_x)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 1e30878f7c6f..d3ea9cb82690 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -9,6 +9,9 @@
 #define TXGBE_SP_MAX_TX_QUEUES  128
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
+#define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_VFT_TBL_SIZE   128
+#define TXGBE_SP_RX_PB_SIZE     512
 
 static s32 txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
 static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw);
@@ -105,6 +108,56 @@ s32 txgbe_init_hw(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_clear_hw_cntrs - Generic clear hardware counters
+ *  @hw: pointer to hardware structure
+ *
+ *  Clears all hardware statistics counters by reading them from the hardware
+ *  Statistics counters are clear on read.
+ **/
+s32 txgbe_clear_hw_cntrs(struct txgbe_hw *hw)
+{
+	u16 i = 0;
+
+	rd32(hw, TXGBE_RX_CRC_ERROR_FRAMES_LOW);
+	for (i = 0; i < 8; i++)
+		rd32(hw, TXGBE_RDB_MPCNT(i));
+
+	rd32(hw, TXGBE_RX_LEN_ERROR_FRAMES_LOW);
+	rd32(hw, TXGBE_RDB_LXONTXC);
+	rd32(hw, TXGBE_RDB_LXOFFTXC);
+	rd32(hw, TXGBE_MAC_LXONRXC);
+	rd32(hw, TXGBE_MAC_LXOFFRXC);
+
+	for (i = 0; i < 8; i++) {
+		rd32(hw, TXGBE_RDB_PXONTXC(i));
+		rd32(hw, TXGBE_RDB_PXOFFTXC(i));
+		rd32(hw, TXGBE_MAC_PXONRXC(i));
+		wr32m(hw, TXGBE_MMC_CONTROL,
+		      TXGBE_MMC_CONTROL_UP, i << 16);
+		rd32(hw, TXGBE_MAC_PXOFFRXC);
+	}
+	for (i = 0; i < 8; i++)
+		rd32(hw, TXGBE_RDB_PXON2OFFCNT(i));
+	for (i = 0; i < 128; i++)
+		wr32(hw, TXGBE_PX_MPRC(i), 0);
+
+	rd32(hw, TXGBE_PX_GPRC);
+	rd32(hw, TXGBE_PX_GPTC);
+	rd32(hw, TXGBE_PX_GORC_MSB);
+	rd32(hw, TXGBE_PX_GOTC_MSB);
+
+	rd32(hw, TXGBE_RX_BC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_RX_UNDERSIZE_FRAMES_GOOD);
+	rd32(hw, TXGBE_RX_OVERSIZE_FRAMES_GOOD);
+	rd32(hw, TXGBE_RX_FRAME_CNT_GOOD_BAD_LOW);
+	rd32(hw, TXGBE_TX_FRAME_CNT_GOOD_BAD_LOW);
+	rd32(hw, TXGBE_TX_MC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_TX_BC_FRAMES_GOOD_LOW);
+	rd32(hw, TXGBE_RDM_DRP_PKT);
+	return 0;
+}
+
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
  *  @hw: pointer to hardware structure
@@ -673,6 +726,130 @@ s32 txgbe_init_rx_addrs(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ *  txgbe_mta_vector - Determines bit-vector in multicast table to set
+ *  @hw: pointer to hardware structure
+ *  @mc_addr: the multicast address
+ *
+ *  Extracts the 12 bits, from a multicast address, to determine which
+ *  bit-vector to set in the multicast table. The hardware uses 12 bits, from
+ *  incoming rx multicast addresses, to determine the bit-vector to check in
+ *  the MTA. Which of the 4 combination, of 12-bits, the hardware uses is set
+ *  by the MO field of the MCSTCTRL. The MO field is set during initialization
+ *  to mc_filter_type.
+ **/
+static s32 txgbe_mta_vector(struct txgbe_hw *hw, u8 *mc_addr)
+{
+	u32 vector = 0;
+
+	switch (hw->mac.mc_filter_type) {
+	case 0:   /* use bits [47:36] of the address */
+		vector = ((mc_addr[4] >> 4) | (((u16)mc_addr[5]) << 4));
+		break;
+	case 1:   /* use bits [46:35] of the address */
+		vector = ((mc_addr[4] >> 3) | (((u16)mc_addr[5]) << 5));
+		break;
+	case 2:   /* use bits [45:34] of the address */
+		vector = ((mc_addr[4] >> 2) | (((u16)mc_addr[5]) << 6));
+		break;
+	case 3:   /* use bits [43:32] of the address */
+		vector = ((mc_addr[4]) | (((u16)mc_addr[5]) << 8));
+		break;
+	default:  /* Invalid mc_filter_type */
+		DEBUGOUT("MC filter type param set incorrectly\n");
+		break;
+	}
+
+	/* vector can only be 12-bits or boundary will be exceeded */
+	vector &= 0xFFF;
+	return vector;
+}
+
+/**
+ *  txgbe_set_mta - Set bit-vector in multicast table
+ *  @hw: pointer to hardware structure
+ *  @hash_value: Multicast address hash value
+ *
+ *  Sets the bit-vector in the multicast table.
+ **/
+void txgbe_set_mta(struct txgbe_hw *hw, u8 *mc_addr)
+{
+	u32 vector;
+	u32 vector_bit;
+	u32 vector_reg;
+
+	hw->addr_ctrl.mta_in_use++;
+
+	vector = txgbe_mta_vector(hw, mc_addr);
+	DEBUGOUT1(" bit-vector = 0x%03X\n", vector);
+
+	/* The MTA is a register array of 128 32-bit registers. It is treated
+	 * like an array of 4096 bits.  We want to set bit
+	 * BitArray[vector_value]. So we figure out what register the bit is
+	 * in, read it, OR in the new bit, then write back the new value.  The
+	 * register is determined by the upper 7 bits of the vector value and
+	 * the bit within that register are determined by the lower 5 bits of
+	 * the value.
+	 */
+	vector_reg = (vector >> 5) & 0x7F;
+	vector_bit = vector & 0x1F;
+	hw->mac.mta_shadow[vector_reg] |= (1 << vector_bit);
+}
+
+/**
+ *  txgbe_update_mc_addr_list - Updates MAC list of multicast addresses
+ *  @hw: pointer to hardware structure
+ *  @mc_addr_list: the list of new multicast addresses
+ *  @mc_addr_count: number of addresses
+ *  @next: iterator function to walk the multicast address list
+ *  @clear: flag, when set clears the table beforehand
+ *
+ *  When the clear flag is set, the given list replaces any existing list.
+ *  Hashes the given addresses into the multicast table.
+ **/
+s32 txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
+			      u32 mc_addr_count, txgbe_mc_addr_itr next,
+			      bool clear)
+{
+	u32 i;
+	u32 vmdq;
+	u32 psrctl;
+
+	/* Set the new number of MC addresses that we are being requested to
+	 * use.
+	 */
+	hw->addr_ctrl.num_mc_addrs = mc_addr_count;
+	hw->addr_ctrl.mta_in_use = 0;
+
+	/* Clear mta_shadow */
+	if (clear) {
+		DEBUGOUT(" Clearing MTA\n");
+		memset(&hw->mac.mta_shadow, 0, sizeof(hw->mac.mta_shadow));
+	}
+
+	/* Update mta_shadow */
+	for (i = 0; i < mc_addr_count; i++) {
+		DEBUGOUT(" Adding the multicast addresses:\n");
+		txgbe_set_mta(hw, next(hw, &mc_addr_list, &vmdq));
+	}
+
+	/* Enable mta */
+	for (i = 0; i < hw->mac.mcft_size; i++)
+		wr32a(hw, TXGBE_PSR_MC_TBL(0), i,
+		      hw->mac.mta_shadow[i]);
+
+	if (hw->addr_ctrl.mta_in_use > 0) {
+		psrctl = rd32(hw, TXGBE_PSR_CTL);
+		psrctl &= ~(TXGBE_PSR_CTL_MO | TXGBE_PSR_CTL_MFE);
+		psrctl |= TXGBE_PSR_CTL_MFE |
+			(hw->mac.mc_filter_type << TXGBE_PSR_CTL_MO_SHIFT);
+		wr32(hw, TXGBE_PSR_CTL, psrctl);
+	}
+
+	DEBUGOUT("txgbe update mc addr list Complete\n");
+	return 0;
+}
+
 /**
  *  txgbe_disable_pcie_master - Disable PCI-express master access
  *  @hw: pointer to hardware structure
@@ -772,6 +949,52 @@ void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask)
 	txgbe_release_eeprom_semaphore(hw);
 }
 
+/**
+ *  txgbe_disable_sec_rx_path - Stops the receive data path
+ *  @hw: pointer to hardware structure
+ *
+ *  Stops the receive data path and waits for the HW to internally empty
+ *  the Rx security block
+ **/
+s32 txgbe_disable_sec_rx_path(struct txgbe_hw *hw)
+{
+#define TXGBE_MAX_SECRX_POLL 40
+
+	int i;
+	int secrxreg;
+
+	wr32m(hw, TXGBE_RSC_CTL,
+	      TXGBE_RSC_CTL_RX_DIS, TXGBE_RSC_CTL_RX_DIS);
+	for (i = 0; i < TXGBE_MAX_SECRX_POLL; i++) {
+		secrxreg = rd32(hw, TXGBE_RSC_ST);
+		if (!(secrxreg & TXGBE_RSC_ST_RSEC_RDY))
+			/* Use interrupt-safe sleep just in case */
+			usec_delay(1000);
+		else
+			break;
+	}
+
+	/* For informational purposes only */
+	if (i >= TXGBE_MAX_SECRX_POLL)
+		DEBUGOUT("Rx unit being enabled before security path fully disabled. Continuing with init.\n");
+
+	return 0;
+}
+
+/**
+ *  txgbe_enable_sec_rx_path - Enables the receive data path
+ *  @hw: pointer to hardware structure
+ *
+ *  Enables the receive data path.
+ **/
+s32 txgbe_enable_sec_rx_path(struct txgbe_hw *hw)
+{
+	wr32m(hw, TXGBE_RSC_CTL, TXGBE_RSC_CTL_RX_DIS, 0);
+	TXGBE_WRITE_FLUSH(hw);
+
+	return 0;
+}
+
 /**
  *  txgbe_get_san_mac_addr_offset - Get SAN MAC address offset from the EEPROM
  *  @hw: pointer to hardware structure
@@ -925,6 +1148,82 @@ s32 txgbe_init_uta_tables(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ *  txgbe_set_vfta - Set VLAN filter table
+ *  @hw: pointer to hardware structure
+ *  @vlan: VLAN id to write to VLAN filter
+ *  @vind: VMDq output index that maps queue to VLAN id in VFVFB
+ *  @vlan_on: boolean flag to turn on/off VLAN in VFVF
+ *
+ *  Turn on/off specified VLAN in the VLAN filter table.
+ **/
+s32 txgbe_set_vfta(struct txgbe_hw *hw, u32 vlan, u32 vind,
+		   bool vlan_on)
+{
+	s32 regindex;
+	u32 bitindex;
+	u32 vfta;
+	u32 targetbit;
+	bool vfta_changed = false;
+
+	if (vlan > 4095)
+		return TXGBE_ERR_PARAM;
+
+	/* The VFTA is a bitstring made up of 128 32-bit registers
+	 * that enable the particular VLAN id, much like the MTA:
+	 *    bits[11-5]: which register
+	 *    bits[4-0]:  which bit in the register
+	 */
+	regindex = (vlan >> 5) & 0x7F;
+	bitindex = vlan & 0x1F;
+	targetbit = (1 << bitindex);
+	/* errata 5 */
+	vfta = hw->mac.vft_shadow[regindex];
+	if (vlan_on) {
+		if (!(vfta & targetbit)) {
+			vfta |= targetbit;
+			vfta_changed = true;
+		}
+	} else {
+		if ((vfta & targetbit)) {
+			vfta &= ~targetbit;
+			vfta_changed = true;
+		}
+	}
+
+	if (vfta_changed)
+		wr32(hw, TXGBE_PSR_VLAN_TBL(regindex), vfta);
+	/* errata 5 */
+	hw->mac.vft_shadow[regindex] = vfta;
+	return 0;
+}
+
+/**
+ *  txgbe_clear_vfta - Clear VLAN filter table
+ *  @hw: pointer to hardware structure
+ *
+ *  Clears the VLAN filer table, and the VMDq index associated with the filter
+ **/
+s32 txgbe_clear_vfta(struct txgbe_hw *hw)
+{
+	u32 offset;
+
+	for (offset = 0; offset < hw->mac.vft_size; offset++) {
+		wr32(hw, TXGBE_PSR_VLAN_TBL(offset), 0);
+		/* errata 5 */
+		hw->mac.vft_shadow[offset] = 0;
+	}
+
+	for (offset = 0; offset < TXGBE_PSR_VLAN_SWC_ENTRIES; offset++) {
+		wr32(hw, TXGBE_PSR_VLAN_SWC_IDX, offset);
+		wr32(hw, TXGBE_PSR_VLAN_SWC, 0);
+		wr32(hw, TXGBE_PSR_VLAN_SWC_VM_L, 0);
+		wr32(hw, TXGBE_PSR_VLAN_SWC_VM_H, 0);
+	}
+
+	return 0;
+}
+
 /**
  *  Get alternative WWNN/WWPN prefix from the EEPROM
  *  @hw: pointer to hardware structure
@@ -1244,6 +1543,66 @@ s32 txgbe_reset_hostif(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ * txgbe_set_rxpba - Initialize Rx packet buffer
+ * @hw: pointer to hardware structure
+ * @num_pb: number of packet buffers to allocate
+ * @headroom: reserve n KB of headroom
+ * @strategy: packet buffer allocation strategy
+ **/
+void txgbe_set_rxpba(struct txgbe_hw *hw, int num_pb, u32 headroom,
+		     int strategy)
+{
+	u32 pbsize = hw->mac.rx_pb_size;
+	int i = 0;
+	u32 rxpktsize, txpktsize, txpbthresh;
+
+	/* Reserve headroom */
+	pbsize -= headroom;
+
+	if (!num_pb)
+		num_pb = 1;
+
+	/* Divide remaining packet buffer space amongst the number of packet
+	 * buffers requested using supplied strategy.
+	 */
+	switch (strategy) {
+	case PBA_STRATEGY_WEIGHTED:
+		/* txgbe_dcb_pba_80_48 strategy weight first half of packet
+		 * buffer with 5/8 of the packet buffer space.
+		 */
+		rxpktsize = (pbsize * 5) / (num_pb * 4);
+		pbsize -= rxpktsize * (num_pb / 2);
+		rxpktsize <<= TXGBE_RDB_PB_SZ_SHIFT;
+		for (; i < (num_pb / 2); i++)
+			wr32(hw, TXGBE_RDB_PB_SZ(i), rxpktsize);
+		/* Fall through to configure remaining packet buffers */
+		fallthrough;
+	case PBA_STRATEGY_EQUAL:
+		rxpktsize = (pbsize / (num_pb - i)) << TXGBE_RDB_PB_SZ_SHIFT;
+		for (; i < num_pb; i++)
+			wr32(hw, TXGBE_RDB_PB_SZ(i), rxpktsize);
+		break;
+	default:
+		break;
+	}
+
+	/* Only support an equally distributed Tx packet buffer strategy. */
+	txpktsize = TXGBE_TDB_PB_SZ_MAX / num_pb;
+	txpbthresh = (txpktsize / 1024) - TXGBE_TXPKT_SIZE_MAX;
+	for (i = 0; i < num_pb; i++) {
+		wr32(hw, TXGBE_TDB_PB_SZ(i), txpktsize);
+		wr32(hw, TXGBE_TDM_PB_THRE(i), txpbthresh);
+	}
+
+	/* Clear unused TCs, if any, to zero buffer size*/
+	for (; i < TXGBE_MAX_PB; i++) {
+		wr32(hw, TXGBE_RDB_PB_SZ(i), 0);
+		wr32(hw, TXGBE_TDB_PB_SZ(i), 0);
+		wr32(hw, TXGBE_TDM_PB_THRE(i), 0);
+	}
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -1303,6 +1662,25 @@ void txgbe_disable_rx(struct txgbe_hw *hw)
 	}
 }
 
+void txgbe_enable_rx(struct txgbe_hw *hw)
+{
+	u32 pfdtxgswc;
+
+	/* enable mac receiver */
+	wr32m(hw, TXGBE_MAC_RX_CFG,
+	      TXGBE_MAC_RX_CFG_RE, TXGBE_MAC_RX_CFG_RE);
+
+	wr32m(hw, TXGBE_RDB_PB_CTL,
+	      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
+
+	if (hw->mac.set_lben) {
+		pfdtxgswc = rd32(hw, TXGBE_PSR_CTL);
+		pfdtxgswc |= TXGBE_PSR_CTL_SW_EN;
+		wr32(hw, TXGBE_PSR_CTL, pfdtxgswc);
+		hw->mac.set_lben = false;
+	}
+}
+
 /**
  * txgbe_mng_present - returns true when management capability is present
  * @hw: pointer to hardware structure
@@ -1501,6 +1879,328 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 	return err;
 }
 
+/* The txgbe_ptype_lookup is used to convert from the 8-bit ptype in the
+ * hardware to a bit-field that can be used by SW to more easily determine the
+ * packet type.
+ *
+ * Macros are used to shorten the table lines and make this table human
+ * readable.
+ *
+ * We store the PTYPE in the top byte of the bit field - this is just so that
+ * we can check that the table doesn't have a row missing, as the index into
+ * the table should be the PTYPE.
+ *
+ * Typical work flow:
+ *
+ * IF NOT txgbe_ptype_lookup[ptype].known
+ * THEN
+ *      Packet is unknown
+ * ELSE IF txgbe_ptype_lookup[ptype].mac == TXGBE_DEC_PTYPE_MAC_IP
+ *      Use the rest of the fields to look at the tunnels, inner protocols, etc
+ * ELSE
+ *      Use the enum txgbe_l2_ptypes to decode the packet type
+ * ENDIF
+ */
+
+/* macro to make the table lines short */
+#define TXGBE_PTT(ptype, mac, ip, etype, eip, proto, layer)\
+	{       ptype, \
+		1, \
+		/* mac     */ TXGBE_DEC_PTYPE_MAC_##mac, \
+		/* ip      */ TXGBE_DEC_PTYPE_IP_##ip, \
+		/* etype   */ TXGBE_DEC_PTYPE_ETYPE_##etype, \
+		/* eip     */ TXGBE_DEC_PTYPE_IP_##eip, \
+		/* proto   */ TXGBE_DEC_PTYPE_PROT_##proto, \
+		/* layer   */ TXGBE_DEC_PTYPE_LAYER_##layer }
+
+#define TXGBE_UKN(ptype) \
+		{ ptype, 0, 0, 0, 0, 0, 0, 0 }
+
+/* Lookup table mapping the HW PTYPE to the bit field for decoding */
+struct txgbe_dptype txgbe_ptype_lookup[256] = {
+	TXGBE_UKN(0x00),
+	TXGBE_UKN(0x01),
+	TXGBE_UKN(0x02),
+	TXGBE_UKN(0x03),
+	TXGBE_UKN(0x04),
+	TXGBE_UKN(0x05),
+	TXGBE_UKN(0x06),
+	TXGBE_UKN(0x07),
+	TXGBE_UKN(0x08),
+	TXGBE_UKN(0x09),
+	TXGBE_UKN(0x0A),
+	TXGBE_UKN(0x0B),
+	TXGBE_UKN(0x0C),
+	TXGBE_UKN(0x0D),
+	TXGBE_UKN(0x0E),
+	TXGBE_UKN(0x0F),
+
+	/* L2: mac */
+	TXGBE_UKN(0x10),
+	TXGBE_PTT(0x11, L2, NONE, NONE, NONE, NONE, PAY2),
+	TXGBE_PTT(0x12, L2, NONE, NONE, NONE, TS,   PAY2),
+	TXGBE_PTT(0x13, L2, NONE, NONE, NONE, NONE, PAY2),
+	TXGBE_PTT(0x14, L2, NONE, NONE, NONE, NONE, PAY2),
+	TXGBE_PTT(0x15, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x16, L2, NONE, NONE, NONE, NONE, PAY2),
+	TXGBE_PTT(0x17, L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L2: ethertype filter */
+	TXGBE_PTT(0x18, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x19, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1A, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1B, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1C, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1D, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1E, L2, NONE, NONE, NONE, NONE, NONE),
+	TXGBE_PTT(0x1F, L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L3: ip non-tunnel */
+	TXGBE_UKN(0x20),
+	TXGBE_PTT(0x21, IP, FGV4, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x22, IP, IPV4, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x23, IP, IPV4, NONE, NONE, UDP,  PAY4),
+	TXGBE_PTT(0x24, IP, IPV4, NONE, NONE, TCP,  PAY4),
+	TXGBE_PTT(0x25, IP, IPV4, NONE, NONE, SCTP, PAY4),
+	TXGBE_UKN(0x26),
+	TXGBE_UKN(0x27),
+	TXGBE_UKN(0x28),
+	TXGBE_PTT(0x29, IP, FGV6, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x2A, IP, IPV6, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x2B, IP, IPV6, NONE, NONE, UDP,  PAY3),
+	TXGBE_PTT(0x2C, IP, IPV6, NONE, NONE, TCP,  PAY4),
+	TXGBE_PTT(0x2D, IP, IPV6, NONE, NONE, SCTP, PAY4),
+	TXGBE_UKN(0x2E),
+	TXGBE_UKN(0x2F),
+
+	/* L2: fcoe */
+	TXGBE_PTT(0x30, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x31, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x32, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x33, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x34, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_UKN(0x35),
+	TXGBE_UKN(0x36),
+	TXGBE_UKN(0x37),
+	TXGBE_PTT(0x38, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x39, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x3A, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x3B, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_PTT(0x3C, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	TXGBE_UKN(0x3D),
+	TXGBE_UKN(0x3E),
+	TXGBE_UKN(0x3F),
+
+	TXGBE_UKN(0x40),
+	TXGBE_UKN(0x41),
+	TXGBE_UKN(0x42),
+	TXGBE_UKN(0x43),
+	TXGBE_UKN(0x44),
+	TXGBE_UKN(0x45),
+	TXGBE_UKN(0x46),
+	TXGBE_UKN(0x47),
+	TXGBE_UKN(0x48),
+	TXGBE_UKN(0x49),
+	TXGBE_UKN(0x4A),
+	TXGBE_UKN(0x4B),
+	TXGBE_UKN(0x4C),
+	TXGBE_UKN(0x4D),
+	TXGBE_UKN(0x4E),
+	TXGBE_UKN(0x4F),
+	TXGBE_UKN(0x50),
+	TXGBE_UKN(0x51),
+	TXGBE_UKN(0x52),
+	TXGBE_UKN(0x53),
+	TXGBE_UKN(0x54),
+	TXGBE_UKN(0x55),
+	TXGBE_UKN(0x56),
+	TXGBE_UKN(0x57),
+	TXGBE_UKN(0x58),
+	TXGBE_UKN(0x59),
+	TXGBE_UKN(0x5A),
+	TXGBE_UKN(0x5B),
+	TXGBE_UKN(0x5C),
+	TXGBE_UKN(0x5D),
+	TXGBE_UKN(0x5E),
+	TXGBE_UKN(0x5F),
+	TXGBE_UKN(0x60),
+	TXGBE_UKN(0x61),
+	TXGBE_UKN(0x62),
+	TXGBE_UKN(0x63),
+	TXGBE_UKN(0x64),
+	TXGBE_UKN(0x65),
+	TXGBE_UKN(0x66),
+	TXGBE_UKN(0x67),
+	TXGBE_UKN(0x68),
+	TXGBE_UKN(0x69),
+	TXGBE_UKN(0x6A),
+	TXGBE_UKN(0x6B),
+	TXGBE_UKN(0x6C),
+	TXGBE_UKN(0x6D),
+	TXGBE_UKN(0x6E),
+	TXGBE_UKN(0x6F),
+	TXGBE_UKN(0x70),
+	TXGBE_UKN(0x71),
+	TXGBE_UKN(0x72),
+	TXGBE_UKN(0x73),
+	TXGBE_UKN(0x74),
+	TXGBE_UKN(0x75),
+	TXGBE_UKN(0x76),
+	TXGBE_UKN(0x77),
+	TXGBE_UKN(0x78),
+	TXGBE_UKN(0x79),
+	TXGBE_UKN(0x7A),
+	TXGBE_UKN(0x7B),
+	TXGBE_UKN(0x7C),
+	TXGBE_UKN(0x7D),
+	TXGBE_UKN(0x7E),
+	TXGBE_UKN(0x7F),
+
+	/* IPv4 --> IPv4/IPv6 */
+	TXGBE_UKN(0x80),
+	TXGBE_PTT(0x81, IP, IPV4, IPIP, FGV4, NONE, PAY3),
+	TXGBE_PTT(0x82, IP, IPV4, IPIP, IPV4, NONE, PAY3),
+	TXGBE_PTT(0x83, IP, IPV4, IPIP, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0x84, IP, IPV4, IPIP, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0x85, IP, IPV4, IPIP, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0x86),
+	TXGBE_UKN(0x87),
+	TXGBE_UKN(0x88),
+	TXGBE_PTT(0x89, IP, IPV4, IPIP, FGV6, NONE, PAY3),
+	TXGBE_PTT(0x8A, IP, IPV4, IPIP, IPV6, NONE, PAY3),
+	TXGBE_PTT(0x8B, IP, IPV4, IPIP, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0x8C, IP, IPV4, IPIP, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0x8D, IP, IPV4, IPIP, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0x8E),
+	TXGBE_UKN(0x8F),
+
+	/* IPv4 --> GRE/NAT --> NONE/IPv4/IPv6 */
+	TXGBE_PTT(0x90, IP, IPV4, IG, NONE, NONE, PAY3),
+	TXGBE_PTT(0x91, IP, IPV4, IG, FGV4, NONE, PAY3),
+	TXGBE_PTT(0x92, IP, IPV4, IG, IPV4, NONE, PAY3),
+	TXGBE_PTT(0x93, IP, IPV4, IG, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0x94, IP, IPV4, IG, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0x95, IP, IPV4, IG, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0x96),
+	TXGBE_UKN(0x97),
+	TXGBE_UKN(0x98),
+	TXGBE_PTT(0x99, IP, IPV4, IG, FGV6, NONE, PAY3),
+	TXGBE_PTT(0x9A, IP, IPV4, IG, IPV6, NONE, PAY3),
+	TXGBE_PTT(0x9B, IP, IPV4, IG, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0x9C, IP, IPV4, IG, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0x9D, IP, IPV4, IG, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0x9E),
+	TXGBE_UKN(0x9F),
+
+	/* IPv4 --> GRE/NAT --> MAC --> NONE/IPv4/IPv6 */
+	TXGBE_PTT(0xA0, IP, IPV4, IGM, NONE, NONE, PAY3),
+	TXGBE_PTT(0xA1, IP, IPV4, IGM, FGV4, NONE, PAY3),
+	TXGBE_PTT(0xA2, IP, IPV4, IGM, IPV4, NONE, PAY3),
+	TXGBE_PTT(0xA3, IP, IPV4, IGM, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xA4, IP, IPV4, IGM, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xA5, IP, IPV4, IGM, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xA6),
+	TXGBE_UKN(0xA7),
+	TXGBE_UKN(0xA8),
+	TXGBE_PTT(0xA9, IP, IPV4, IGM, FGV6, NONE, PAY3),
+	TXGBE_PTT(0xAA, IP, IPV4, IGM, IPV6, NONE, PAY3),
+	TXGBE_PTT(0xAB, IP, IPV4, IGM, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xAC, IP, IPV4, IGM, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xAD, IP, IPV4, IGM, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xAE),
+	TXGBE_UKN(0xAF),
+
+	/* IPv4 --> GRE/NAT --> MAC+VLAN --> NONE/IPv4/IPv6 */
+	TXGBE_PTT(0xB0, IP, IPV4, IGMV, NONE, NONE, PAY3),
+	TXGBE_PTT(0xB1, IP, IPV4, IGMV, FGV4, NONE, PAY3),
+	TXGBE_PTT(0xB2, IP, IPV4, IGMV, IPV4, NONE, PAY3),
+	TXGBE_PTT(0xB3, IP, IPV4, IGMV, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xB4, IP, IPV4, IGMV, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xB5, IP, IPV4, IGMV, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xB6),
+	TXGBE_UKN(0xB7),
+	TXGBE_UKN(0xB8),
+	TXGBE_PTT(0xB9, IP, IPV4, IGMV, FGV6, NONE, PAY3),
+	TXGBE_PTT(0xBA, IP, IPV4, IGMV, IPV6, NONE, PAY3),
+	TXGBE_PTT(0xBB, IP, IPV4, IGMV, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xBC, IP, IPV4, IGMV, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xBD, IP, IPV4, IGMV, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xBE),
+	TXGBE_UKN(0xBF),
+
+	/* IPv6 --> IPv4/IPv6 */
+	TXGBE_UKN(0xC0),
+	TXGBE_PTT(0xC1, IP, IPV6, IPIP, FGV4, NONE, PAY3),
+	TXGBE_PTT(0xC2, IP, IPV6, IPIP, IPV4, NONE, PAY3),
+	TXGBE_PTT(0xC3, IP, IPV6, IPIP, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xC4, IP, IPV6, IPIP, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xC5, IP, IPV6, IPIP, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xC6),
+	TXGBE_UKN(0xC7),
+	TXGBE_UKN(0xC8),
+	TXGBE_PTT(0xC9, IP, IPV6, IPIP, FGV6, NONE, PAY3),
+	TXGBE_PTT(0xCA, IP, IPV6, IPIP, IPV6, NONE, PAY3),
+	TXGBE_PTT(0xCB, IP, IPV6, IPIP, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xCC, IP, IPV6, IPIP, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xCD, IP, IPV6, IPIP, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xCE),
+	TXGBE_UKN(0xCF),
+
+	/* IPv6 --> GRE/NAT -> NONE/IPv4/IPv6 */
+	TXGBE_PTT(0xD0, IP, IPV6, IG,   NONE, NONE, PAY3),
+	TXGBE_PTT(0xD1, IP, IPV6, IG,   FGV4, NONE, PAY3),
+	TXGBE_PTT(0xD2, IP, IPV6, IG,   IPV4, NONE, PAY3),
+	TXGBE_PTT(0xD3, IP, IPV6, IG,   IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xD4, IP, IPV6, IG,   IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xD5, IP, IPV6, IG,   IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xD6),
+	TXGBE_UKN(0xD7),
+	TXGBE_UKN(0xD8),
+	TXGBE_PTT(0xD9, IP, IPV6, IG,   FGV6, NONE, PAY3),
+	TXGBE_PTT(0xDA, IP, IPV6, IG,   IPV6, NONE, PAY3),
+	TXGBE_PTT(0xDB, IP, IPV6, IG,   IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xDC, IP, IPV6, IG,   IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xDD, IP, IPV6, IG,   IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xDE),
+	TXGBE_UKN(0xDF),
+
+	/* IPv6 --> GRE/NAT -> MAC -> NONE/IPv4/IPv6 */
+	TXGBE_PTT(0xE0, IP, IPV6, IGM,  NONE, NONE, PAY3),
+	TXGBE_PTT(0xE1, IP, IPV6, IGM,  FGV4, NONE, PAY3),
+	TXGBE_PTT(0xE2, IP, IPV6, IGM,  IPV4, NONE, PAY3),
+	TXGBE_PTT(0xE3, IP, IPV6, IGM,  IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xE4, IP, IPV6, IGM,  IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xE5, IP, IPV6, IGM,  IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xE6),
+	TXGBE_UKN(0xE7),
+	TXGBE_UKN(0xE8),
+	TXGBE_PTT(0xE9, IP, IPV6, IGM,  FGV6, NONE, PAY3),
+	TXGBE_PTT(0xEA, IP, IPV6, IGM,  IPV6, NONE, PAY3),
+	TXGBE_PTT(0xEB, IP, IPV6, IGM,  IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xEC, IP, IPV6, IGM,  IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xED, IP, IPV6, IGM,  IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xEE),
+	TXGBE_UKN(0xEF),
+
+	/* IPv6 --> GRE/NAT -> MAC--> NONE/IPv */
+	TXGBE_PTT(0xF0, IP, IPV6, IGMV, NONE, NONE, PAY3),
+	TXGBE_PTT(0xF1, IP, IPV6, IGMV, FGV4, NONE, PAY3),
+	TXGBE_PTT(0xF2, IP, IPV6, IGMV, IPV4, NONE, PAY3),
+	TXGBE_PTT(0xF3, IP, IPV6, IGMV, IPV4, UDP,  PAY4),
+	TXGBE_PTT(0xF4, IP, IPV6, IGMV, IPV4, TCP,  PAY4),
+	TXGBE_PTT(0xF5, IP, IPV6, IGMV, IPV4, SCTP, PAY4),
+	TXGBE_UKN(0xF6),
+	TXGBE_UKN(0xF7),
+	TXGBE_UKN(0xF8),
+	TXGBE_PTT(0xF9, IP, IPV6, IGMV, FGV6, NONE, PAY3),
+	TXGBE_PTT(0xFA, IP, IPV6, IGMV, IPV6, NONE, PAY3),
+	TXGBE_PTT(0xFB, IP, IPV6, IGMV, IPV6, UDP,  PAY4),
+	TXGBE_PTT(0xFC, IP, IPV6, IGMV, IPV6, TCP,  PAY4),
+	TXGBE_PTT(0xFD, IP, IPV6, IGMV, IPV6, SCTP, PAY4),
+	TXGBE_UKN(0xFE),
+	TXGBE_UKN(0xFF),
+};
+
 void txgbe_init_mac_link_ops(struct txgbe_hw *hw)
 {
 	struct txgbe_mac_info *mac = &hw->mac;
@@ -1581,6 +2281,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw;
+	mac->ops.clear_hw_cntrs = txgbe_clear_hw_cntrs;
 	mac->ops.get_mac_addr = txgbe_get_mac_addr;
 	mac->ops.stop_adapter = txgbe_stop_adapter;
 	mac->ops.get_bus_info = txgbe_get_bus_info;
@@ -1589,6 +2290,9 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.release_swfw_sync = txgbe_release_swfw_sync;
 	mac->ops.reset_hw = txgbe_reset_hw;
 	mac->ops.get_media_type = txgbe_get_media_type;
+	mac->ops.disable_sec_rx_path = txgbe_disable_sec_rx_path;
+	mac->ops.enable_sec_rx_path = txgbe_enable_sec_rx_path;
+	mac->ops.enable_rx_dma = txgbe_enable_rx_dma;
 	mac->ops.start_hw = txgbe_start_hw;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
@@ -1597,17 +2301,27 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.led_on = txgbe_led_on;
 	mac->ops.led_off = txgbe_led_off;
 
-	/* RAR */
+	/* RAR, Multicast, VLAN */
 	mac->ops.set_rar = txgbe_set_rar;
 	mac->ops.clear_rar = txgbe_clear_rar;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
+	mac->ops.update_mc_addr_list = txgbe_update_mc_addr_list;
+	mac->ops.enable_rx = txgbe_enable_rx;
+	mac->ops.disable_rx = txgbe_disable_rx;
+	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
+	mac->ops.set_vfta = txgbe_set_vfta;
+	mac->ops.clear_vfta = txgbe_clear_vfta;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
 
 	/* Link */
 	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
 	mac->ops.check_link = txgbe_check_mac_link;
+	mac->ops.setup_rxpba = txgbe_set_rxpba;
+	mac->mcft_size          = TXGBE_SP_MC_TBL_SIZE;
+	mac->vft_size           = TXGBE_SP_VFT_TBL_SIZE;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
+	mac->rx_pb_size         = TXGBE_SP_RX_PB_SIZE;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
 	mac->max_msix_vectors   = txgbe_get_pcie_msix_count(hw);
@@ -3004,6 +3718,14 @@ s32 txgbe_start_hw(struct txgbe_hw *hw)
 	/* Set the media type */
 	hw->phy.media_type = TCALL(hw, mac.ops.get_media_type);
 
+	/* Clear the VLAN filter table */
+	TCALL(hw, mac.ops.clear_vfta);
+
+	/* Clear statistics registers */
+	TCALL(hw, mac.ops.clear_hw_cntrs);
+
+	TXGBE_WRITE_FLUSH(hw);
+
 	/* Clear the rate limiters */
 	for (i = 0; i < hw->mac.max_tx_queues; i++) {
 		wr32(hw, TXGBE_TDM_RP_IDX, i);
@@ -3052,6 +3774,33 @@ s32 txgbe_identify_phy(struct txgbe_hw *hw)
 	return status;
 }
 
+/**
+ *  txgbe_enable_rx_dma - Enable the Rx DMA unit on sapphire
+ *  @hw: pointer to hardware structure
+ *  @regval: register value to write to RXCTRL
+ *
+ *  Enables the Rx DMA unit for sapphire
+ **/
+s32 txgbe_enable_rx_dma(struct txgbe_hw *hw, u32 regval)
+{
+	/* Workaround for sapphire silicon errata when enabling the Rx datapath.
+	 * If traffic is incoming before we enable the Rx unit, it could hang
+	 * the Rx DMA unit.  Therefore, make sure the security engine is
+	 * completely disabled prior to enabling the Rx unit.
+	 */
+
+	TCALL(hw, mac.ops.disable_sec_rx_path);
+
+	if (regval & TXGBE_RDB_PB_CTL_RXEN)
+		TCALL(hw, mac.ops.enable_rx);
+	else
+		TCALL(hw, mac.ops.disable_rx);
+
+	TCALL(hw, mac.ops.enable_sec_rx_path);
+
+	return 0;
+}
+
 /**
  *  txgbe_init_eeprom_params - Initialize EEPROM params
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 2273afaea4e2..e400b0333cc4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,8 +4,71 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
+/**
+ * Packet Type decoding
+ **/
+/* txgbe_dptype.mac: outer mac */
+enum txgbe_dec_ptype_mac {
+	TXGBE_DEC_PTYPE_MAC_IP = 0,
+	TXGBE_DEC_PTYPE_MAC_L2 = 2,
+	TXGBE_DEC_PTYPE_MAC_FCOE = 3,
+};
+
+/* txgbe_dptype.[e]ip: outer&encaped ip */
+#define TXGBE_DEC_PTYPE_IP_FRAG (0x4)
+enum txgbe_dec_ptype_ip {
+	TXGBE_DEC_PTYPE_IP_NONE = 0,
+	TXGBE_DEC_PTYPE_IP_IPV4 = 1,
+	TXGBE_DEC_PTYPE_IP_IPV6 = 2,
+	TXGBE_DEC_PTYPE_IP_FGV4 =
+		(TXGBE_DEC_PTYPE_IP_FRAG | TXGBE_DEC_PTYPE_IP_IPV4),
+	TXGBE_DEC_PTYPE_IP_FGV6 =
+		(TXGBE_DEC_PTYPE_IP_FRAG | TXGBE_DEC_PTYPE_IP_IPV6),
+};
+
+/* txgbe_dptype.etype: encaped type */
+enum txgbe_dec_ptype_etype {
+	TXGBE_DEC_PTYPE_ETYPE_NONE = 0,
+	TXGBE_DEC_PTYPE_ETYPE_IPIP = 1, /* IP+IP */
+	TXGBE_DEC_PTYPE_ETYPE_IG = 2, /* IP+GRE */
+	TXGBE_DEC_PTYPE_ETYPE_IGM = 3, /* IP+GRE+MAC */
+	TXGBE_DEC_PTYPE_ETYPE_IGMV = 4, /* IP+GRE+MAC+VLAN */
+};
+
+/* txgbe_dptype.proto: payload proto */
+enum txgbe_dec_ptype_prot {
+	TXGBE_DEC_PTYPE_PROT_NONE = 0,
+	TXGBE_DEC_PTYPE_PROT_UDP = 1,
+	TXGBE_DEC_PTYPE_PROT_TCP = 2,
+	TXGBE_DEC_PTYPE_PROT_SCTP = 3,
+	TXGBE_DEC_PTYPE_PROT_ICMP = 4,
+	TXGBE_DEC_PTYPE_PROT_TS = 5, /* time sync */
+};
+
+/* txgbe_dptype.layer: payload layer */
+enum txgbe_dec_ptype_layer {
+	TXGBE_DEC_PTYPE_LAYER_NONE = 0,
+	TXGBE_DEC_PTYPE_LAYER_PAY2 = 1,
+	TXGBE_DEC_PTYPE_LAYER_PAY3 = 2,
+	TXGBE_DEC_PTYPE_LAYER_PAY4 = 3,
+};
+
+struct txgbe_dptype {
+	u32 ptype:8;
+	u32 known:1;
+	u32 mac:2; /* outer mac */
+	u32 ip:3; /* outer ip*/
+	u32 etype:3; /* encaped type */
+	u32 eip:3; /* encaped ip */
+	u32 prot:4; /* payload proto */
+	u32 layer:3; /* payload layer */
+};
+
+extern struct txgbe_dptype txgbe_ptype_lookup[256];
+
 s32 txgbe_init_hw(struct txgbe_hw *hw);
 s32 txgbe_start_hw(struct txgbe_hw *hw);
+s32 txgbe_clear_hw_cntrs(struct txgbe_hw *hw);
 s32 txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num,
 			  u32 pba_num_size);
 s32 txgbe_get_mac_addr(struct txgbe_hw *hw, u8 *mac_addr);
@@ -21,6 +84,11 @@ s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		  u32 enable_addr);
 s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
 s32 txgbe_init_rx_addrs(struct txgbe_hw *hw);
+s32 txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
+			      u32 mc_addr_count,
+			      txgbe_mc_addr_itr func, bool clear);
+s32 txgbe_disable_sec_rx_path(struct txgbe_hw *hw);
+s32 txgbe_enable_sec_rx_path(struct txgbe_hw *hw);
 
 s32 txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask);
 void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask);
@@ -31,10 +99,15 @@ s32 txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
 s32 txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
 s32 txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 s32 txgbe_init_uta_tables(struct txgbe_hw *hw);
+s32 txgbe_set_vfta(struct txgbe_hw *hw, u32 vlan,
+		   u32 vind, bool vlan_on);
+s32 txgbe_clear_vfta(struct txgbe_hw *hw);
 
 s32 txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
 			 u16 *wwpn_prefix);
 
+void txgbe_set_rxpba(struct txgbe_hw *hw, int num_pb, u32 headroom,
+		     int strategy);
 s32 txgbe_set_fw_drv_ver(struct txgbe_hw *hw, u8 maj, u8 min,
 			 u8 build, u8 ver);
 s32 txgbe_reset_hostif(struct txgbe_hw *hw);
@@ -46,6 +119,7 @@ bool txgbe_mng_present(struct txgbe_hw *hw);
 bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
+void txgbe_enable_rx(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 s32 txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
 					  u32 speed,
@@ -68,6 +142,7 @@ int txgbe_reset_misc(struct txgbe_hw *hw);
 s32 txgbe_reset_hw(struct txgbe_hw *hw);
 s32 txgbe_identify_phy(struct txgbe_hw *hw);
 s32 txgbe_init_phy_ops(struct txgbe_hw *hw);
+s32 txgbe_enable_rx_dma(struct txgbe_hw *hw, u32 regval);
 s32 txgbe_init_ops(struct txgbe_hw *hw);
 
 s32 txgbe_init_eeprom_params(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
index 514a38941488..c7eafce35e87 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -25,6 +25,39 @@ static void txgbe_cache_ring_register(struct txgbe_adapter *adapter)
 		adapter->tx_ring[i]->reg_idx = i;
 }
 
+#define TXGBE_RSS_64Q_MASK      0x3F
+#define TXGBE_RSS_16Q_MASK      0xF
+#define TXGBE_RSS_8Q_MASK       0x7
+#define TXGBE_RSS_4Q_MASK       0x3
+#define TXGBE_RSS_2Q_MASK       0x1
+#define TXGBE_RSS_DISABLED_MASK 0x0
+
+/**
+ * txgbe_set_rss_queues: Allocate queues for RSS
+ * @adapter: board private structure to initialize
+ *
+ * This is our "base" multiqueue mode.  RSS (Receive Side Scaling) will try
+ * to allocate one Rx queue per CPU, and if available, one Tx queue per CPU.
+ *
+ **/
+static bool txgbe_set_rss_queues(struct txgbe_adapter *adapter)
+{
+	struct txgbe_ring_feature *f;
+	u16 rss_i;
+
+	/* set mask for 16 queue limit of RSS */
+	f = &adapter->ring_feature[RING_F_RSS];
+	rss_i = f->limit;
+
+	f->indices = rss_i;
+	f->mask = TXGBE_RSS_64Q_MASK;
+
+	adapter->num_rx_queues = rss_i;
+	adapter->num_tx_queues = rss_i;
+
+	return true;
+}
+
 /**
  * txgbe_set_num_queues: Allocate queues for device, feature dependent
  * @adapter: board private structure to initialize
@@ -34,6 +67,8 @@ static void txgbe_set_num_queues(struct txgbe_adapter *adapter)
 	/* Start with base case */
 	adapter->num_rx_queues = 1;
 	adapter->num_tx_queues = 1;
+
+	txgbe_set_rss_queues(adapter);
 }
 
 /**
@@ -165,6 +200,10 @@ static int txgbe_alloc_q_vector(struct txgbe_adapter *adapter,
 	/* initialize CPU for DCA */
 	q_vector->cpu = -1;
 
+	/* initialize NAPI */
+	netif_napi_add(adapter->netdev, &q_vector->napi,
+		       txgbe_poll, 64);
+
 	/* tie q_vector and adapter together */
 	adapter->q_vector[v_idx] = q_vector;
 	q_vector->adapter = adapter;
@@ -268,6 +307,7 @@ static void txgbe_free_q_vector(struct txgbe_adapter *adapter, int v_idx)
 		adapter->rx_ring[ring->queue_index] = NULL;
 
 	adapter->q_vector[v_idx] = NULL;
+	netif_napi_del(&q_vector->napi);
 	kfree_rcu(q_vector, rcu);
 }
 
@@ -378,6 +418,10 @@ void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter)
 	if (!txgbe_acquire_msix_vectors(adapter))
 		return;
 
+	/* Disable RSS */
+	txgbe_dev_warn("Disabling RSS support\n");
+	adapter->ring_feature[RING_F_RSS].limit = 1;
+
 	/* recalculate number of queues now that many features have been
 	 * changed or disabled.
 	 */
@@ -440,3 +484,21 @@ void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter)
 	txgbe_reset_interrupt_capability(adapter);
 }
 
+void txgbe_tx_ctxtdesc(struct txgbe_ring *tx_ring, u32 vlan_macip_lens,
+		       u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx)
+{
+	struct txgbe_tx_context_desc *context_desc;
+	u16 i = tx_ring->next_to_use;
+
+	context_desc = TXGBE_TX_CTXTDESC(tx_ring, i);
+
+	i++;
+	tx_ring->next_to_use = (i < tx_ring->count) ? i : 0;
+
+	/* set bits to identify this as an advanced context descriptor */
+	type_tucmd |= TXGBE_TXD_DTYP_CTXT;
+	context_desc->vlan_macip_lens   = cpu_to_le32(vlan_macip_lens);
+	context_desc->seqnum_seed       = cpu_to_le32(fcoe_sof_eof);
+	context_desc->type_tucmd_mlhl   = cpu_to_le32(type_tucmd);
+	context_desc->mss_l4len_idx     = cpu_to_le32(mss_l4len_idx);
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 385c0f35e82a..550af406de8d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -8,7 +8,15 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/string.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/pkt_sched.h>
+#include <linux/ipv6.h>
 #include <linux/aer.h>
+#include <net/checksum.h>
+#include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/etherdevice.h>
 
 #include "txgbe.h"
@@ -53,6 +61,21 @@ static struct workqueue_struct *txgbe_wq;
 
 static bool txgbe_is_sfp(struct txgbe_hw *hw);
 static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev);
+static void txgbe_clean_rx_ring(struct txgbe_ring *rx_ring);
+static void txgbe_clean_tx_ring(struct txgbe_ring *tx_ring);
+static void txgbe_napi_enable_all(struct txgbe_adapter *adapter);
+static void txgbe_napi_disable_all(struct txgbe_adapter *adapter);
+
+static inline struct txgbe_dptype txgbe_decode_ptype(const u8 ptype)
+{
+	return txgbe_ptype_lookup[ptype];
+}
+
+static inline struct txgbe_dptype
+decode_rx_desc_ptype(const union txgbe_rx_desc *rx_desc)
+{
+	return txgbe_decode_ptype(TXGBE_RXD_PKTTYPE(rx_desc));
+}
 
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter,
 				     int expected_gts)
@@ -178,1393 +201,5043 @@ static void txgbe_set_ivar(struct txgbe_adapter *adapter, s8 direction,
 	}
 }
 
-/**
- * txgbe_configure_msix - Configure MSI-X hardware
- * @adapter: board private structure
- *
- * txgbe_configure_msix sets up the hardware to properly generate MSI-X
- * interrupts.
- **/
-static void txgbe_configure_msix(struct txgbe_adapter *adapter)
+void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
+				      struct txgbe_tx_buffer *tx_buffer)
 {
-	u16 v_idx;
+	if (tx_buffer->skb) {
+		dev_kfree_skb_any(tx_buffer->skb);
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_single(ring->dev,
+					 dma_unmap_addr(tx_buffer, dma),
+					 dma_unmap_len(tx_buffer, len),
+					 DMA_TO_DEVICE);
+	} else if (dma_unmap_len(tx_buffer, len)) {
+		dma_unmap_page(ring->dev,
+			       dma_unmap_addr(tx_buffer, dma),
+			       dma_unmap_len(tx_buffer, len),
+			       DMA_TO_DEVICE);
+	}
+	tx_buffer->next_to_watch = NULL;
+	tx_buffer->skb = NULL;
+	dma_unmap_len_set(tx_buffer, len, 0);
+	/* tx_buffer must be completely set up in the transmit path */
+}
 
-	/* Populate MSIX to EITR Select */
-	wr32(&adapter->hw, TXGBE_PX_ITRSEL, 0);
+static u64 txgbe_get_tx_completed(struct txgbe_ring *ring)
+{
+	return ring->stats.packets;
+}
 
-	/* Populate the IVAR table and set the ITR values to the
-	 * corresponding register.
-	 */
-	for (v_idx = 0; v_idx < adapter->num_q_vectors; v_idx++) {
-		struct txgbe_q_vector *q_vector = adapter->q_vector[v_idx];
-		struct txgbe_ring *ring;
+static u64 txgbe_get_tx_pending(struct txgbe_ring *ring)
+{
+	struct txgbe_adapter *adapter;
+	struct txgbe_hw *hw;
+	u32 head, tail;
 
-		txgbe_for_each_ring(ring, q_vector->rx)
-			txgbe_set_ivar(adapter, 0, ring->reg_idx, v_idx);
+	if (ring->accel)
+		adapter = ring->accel->adapter;
+	else
+		adapter = ring->q_vector->adapter;
 
-		txgbe_for_each_ring(ring, q_vector->tx)
-			txgbe_set_ivar(adapter, 1, ring->reg_idx, v_idx);
+	hw = &adapter->hw;
+	head = rd32(hw, TXGBE_PX_TR_RP(ring->reg_idx));
+	tail = rd32(hw, TXGBE_PX_TR_WP(ring->reg_idx));
 
-		txgbe_write_eitr(q_vector);
-	}
+	return ((head <= tail) ? tail : tail + ring->count) - head;
+}
 
-	txgbe_set_ivar(adapter, -1, 0, v_idx);
+static inline bool txgbe_check_tx_hang(struct txgbe_ring *tx_ring)
+{
+	u64 tx_done = txgbe_get_tx_completed(tx_ring);
+	u64 tx_done_old = tx_ring->tx_stats.tx_done_old;
+	u64 tx_pending = txgbe_get_tx_pending(tx_ring);
+
+	clear_check_for_tx_hang(tx_ring);
+
+	/* Check for a hung queue, but be thorough. This verifies
+	 * that a transmit has been completed since the previous
+	 * check AND there is at least one packet pending. The
+	 * ARMED bit is set to indicate a potential hang. The
+	 * bit is cleared if a pause frame is received to remove
+	 * false hang detection due to PFC or 802.3x frames. By
+	 * requiring this to fail twice we avoid races with
+	 * pfc clearing the ARMED bit and conditions where we
+	 * run the check_tx_hang logic with a transmit completion
+	 * pending but without time to complete it yet.
+	 */
+	if (tx_done_old == tx_done && tx_pending)
+		/* make sure it is true for two checks in a row */
+		return test_and_set_bit(__TXGBE_HANG_CHECK_ARMED,
+					&tx_ring->state);
+	/* update completed stats and continue */
+	tx_ring->tx_stats.tx_done_old = tx_done;
+	/* reset the countdown */
+	clear_bit(__TXGBE_HANG_CHECK_ARMED, &tx_ring->state);
 
-	wr32(&adapter->hw, TXGBE_PX_ITR(v_idx), 1950);
+	return false;
 }
 
 /**
- * txgbe_write_eitr - write EITR register in hardware specific way
- * @q_vector: structure containing interrupt and ring information
- *
- * This function is made to be called by ethtool and by the driver
- * when it needs to update EITR registers at runtime.  Hardware
- * specific quirks/differences are taken care of here.
- */
-void txgbe_write_eitr(struct txgbe_q_vector *q_vector)
+ * txgbe_tx_timeout - Respond to a Tx Hang
+ * @netdev: network interface device structure
+ **/
+static void txgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
-	struct txgbe_adapter *adapter = q_vector->adapter;
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
 	struct txgbe_hw *hw = &adapter->hw;
-	int v_idx = q_vector->v_idx;
-	u32 itr_reg = q_vector->itr & TXGBE_MAX_EITR;
+	bool real_tx_hang = false;
+	int i;
+	u16 value = 0;
+	u32 value2 = 0, value3 = 0;
+	u32 head, tail;
 
-	itr_reg |= TXGBE_PX_ITR_CNT_WDIS;
+#define TX_TIMEO_LIMIT 16000
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
 
-	wr32(hw, TXGBE_PX_ITR(v_idx), itr_reg);
+		if (check_for_tx_hang(tx_ring) && txgbe_check_tx_hang(tx_ring))
+			real_tx_hang = true;
+	}
+
+	/* Dump the relevant registers to determine the cause of a timeout event. */
+	pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &value);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "pci vendor id is 0x%x\n", value);
+	pci_read_config_word(adapter->pdev, PCI_COMMAND, &value);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "pci command reg is 0x%x.\n", value);
+
+	value2 = rd32(&adapter->hw, 0x10000);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "reg 0x10000 value is 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d0);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "reg 0x180d0 value is 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d4);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "reg 0x180d4 value is 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180d8);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "reg 0x180d8 value is 0x%08x\n", value2);
+	value2 = rd32(&adapter->hw, 0x180dc);
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "reg 0x180dc value is 0x%08x\n", value2);
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		head = rd32(&adapter->hw, TXGBE_PX_TR_RP(adapter->tx_ring[i]->reg_idx));
+		tail = rd32(&adapter->hw, TXGBE_PX_TR_WP(adapter->tx_ring[i]->reg_idx));
+
+		ERROR_REPORT1(TXGBE_ERROR_POLLING,
+			      "tx ring %d next_to_use is %d, next_to_clean is %d\n",
+			      i, adapter->tx_ring[i]->next_to_use,
+			      adapter->tx_ring[i]->next_to_clean);
+		ERROR_REPORT1(TXGBE_ERROR_POLLING,
+			      "tx ring %d hw rp is 0x%x, wp is 0x%x\n",
+			      i, head, tail);
+	}
+
+	value2 = rd32(&adapter->hw, TXGBE_PX_IMS(0));
+	value3 = rd32(&adapter->hw, TXGBE_PX_IMS(1));
+	ERROR_REPORT1(TXGBE_ERROR_POLLING,
+		      "PX_IMS0 value is 0x%08x, PX_IMS1 value is 0x%08x\n",
+		      value2, value3);
+
+	if (value2 || value3) {
+		ERROR_REPORT1(TXGBE_ERROR_POLLING, "clear interrupt mask.\n");
+		wr32(&adapter->hw, TXGBE_PX_ICS(0), value2);
+		wr32(&adapter->hw, TXGBE_PX_IMC(0), value2);
+		wr32(&adapter->hw, TXGBE_PX_ICS(1), value3);
+		wr32(&adapter->hw, TXGBE_PX_IMC(1), value3);
+	}
 }
 
 /**
- * txgbe_check_overtemp_subtask - check for over temperature
- * @adapter: pointer to adapter
+ * txgbe_clean_tx_irq - Reclaim resources after transmit completes
+ * @q_vector: structure containing interrupt and ring information
+ * @tx_ring: tx ring to clean
  **/
-static void txgbe_check_overtemp_subtask(struct txgbe_adapter *adapter)
+static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
+			       struct txgbe_ring *tx_ring)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 eicr = adapter->interrupt_event;
-	s32 temp_state;
+	struct txgbe_adapter *adapter = q_vector->adapter;
+	struct txgbe_tx_buffer *tx_buffer;
+	union txgbe_tx_desc *tx_desc;
+	unsigned int total_bytes = 0, total_packets = 0;
+	unsigned int budget = q_vector->tx.work_limit;
+	unsigned int i = tx_ring->next_to_clean;
 
 	if (test_bit(__TXGBE_DOWN, &adapter->state))
-		return;
-	if (!(adapter->flags2 & TXGBE_FLAG2_TEMP_SENSOR_EVENT))
-		return;
+		return true;
 
-	adapter->flags2 &= ~TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+	tx_buffer = &tx_ring->tx_buffer_info[i];
+	tx_desc = TXGBE_TX_DESC(tx_ring, i);
+	i -= tx_ring->count;
+
+	do {
+		union txgbe_tx_desc *eop_desc = tx_buffer->next_to_watch;
+
+		/* if next_to_watch is not set then there is no work pending */
+		if (!eop_desc)
+			break;
+
+		/* prevent any other reads prior to eop_desc */
+		smp_rmb();
+
+		/* if DD is not set pending work has not been completed */
+		if (!(eop_desc->wb.status & cpu_to_le32(TXGBE_TXD_STAT_DD)))
+			break;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buffer->next_to_watch = NULL;
+
+		/* update the statistics for this packet */
+		total_bytes += tx_buffer->bytecount;
+		total_packets += tx_buffer->gso_segs;
+
+		/* free the skb */
+		dev_consume_skb_any(tx_buffer->skb);
+
+		/* unmap skb header data */
+		dma_unmap_single(tx_ring->dev,
+				 dma_unmap_addr(tx_buffer, dma),
+				 dma_unmap_len(tx_buffer, len),
+				 DMA_TO_DEVICE);
+
+		/* clear tx_buffer data */
+		tx_buffer->skb = NULL;
+		dma_unmap_len_set(tx_buffer, len, 0);
+
+		/* unmap remaining buffers */
+		while (tx_desc != eop_desc) {
+			tx_buffer++;
+			tx_desc++;
+			i++;
+			if (unlikely(!i)) {
+				i -= tx_ring->count;
+				tx_buffer = tx_ring->tx_buffer_info;
+				tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+			}
 
-	/* Since the warning interrupt is for both ports
-	 * we don't have to check if:
-	 *  - This interrupt wasn't for our port.
-	 *  - We may have missed the interrupt so always have to
-	 *    check if we  got a LSC
-	 */
-	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
-		return;
+			/* unmap any remaining paged data */
+			if (dma_unmap_len(tx_buffer, len)) {
+				dma_unmap_page(tx_ring->dev,
+					       dma_unmap_addr(tx_buffer, dma),
+					       dma_unmap_len(tx_buffer, len),
+					       DMA_TO_DEVICE);
+				dma_unmap_len_set(tx_buffer, len, 0);
+			}
+		}
 
-	temp_state = TCALL(hw, phy.ops.check_overtemp);
-	if (!temp_state || temp_state == TXGBE_NOT_IMPLEMENTED)
-		return;
+		/* move us one more past the eop_desc for start of next pkt */
+		tx_buffer++;
+		tx_desc++;
+		i++;
+		if (unlikely(!i)) {
+			i -= tx_ring->count;
+			tx_buffer = tx_ring->tx_buffer_info;
+			tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+		}
 
-	if (temp_state == TXGBE_ERR_UNDERTEMP &&
-	    test_bit(__TXGBE_HANGING, &adapter->state)) {
-		txgbe_crit(drv, "%s\n", txgbe_underheat_msg);
-		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
-		      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
-		netif_carrier_on(adapter->netdev);
-		clear_bit(__TXGBE_HANGING, &adapter->state);
-	} else if (temp_state == TXGBE_ERR_OVERTEMP &&
-		!test_and_set_bit(__TXGBE_HANGING, &adapter->state)) {
-		txgbe_crit(drv, "%s\n", txgbe_overheat_msg);
-		netif_carrier_off(adapter->netdev);
-		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
-		      TXGBE_RDB_PB_CTL_RXEN, 0);
+		/* issue prefetch for next Tx descriptor */
+		prefetch(tx_desc);
+
+		/* update budget accounting */
+		budget--;
+	} while (likely(budget));
+
+	i += tx_ring->count;
+	tx_ring->next_to_clean = i;
+	u64_stats_update_begin(&tx_ring->syncp);
+	tx_ring->stats.bytes += total_bytes;
+	tx_ring->stats.packets += total_packets;
+	u64_stats_update_end(&tx_ring->syncp);
+	q_vector->tx.total_bytes += total_bytes;
+	q_vector->tx.total_packets += total_packets;
+
+	if (check_for_tx_hang(tx_ring) && txgbe_check_tx_hang(tx_ring)) {
+	/* schedule immediate reset if we believe we hung */
+		struct txgbe_hw *hw = &adapter->hw;
+		u16 value = 0;
+
+		txgbe_err(drv, "Detected Tx Unit Hang\n"
+			"  Tx Queue             <%d>\n"
+			"  TDH, TDT             <%x>, <%x>\n"
+			"  next_to_use          <%x>\n"
+			"  next_to_clean        <%x>\n"
+			"tx_buffer_info[next_to_clean]\n"
+			"  jiffies              <%lx>\n",
+			tx_ring->queue_index,
+			rd32(hw, TXGBE_PX_TR_RP(tx_ring->reg_idx)),
+			rd32(hw, TXGBE_PX_TR_WP(tx_ring->reg_idx)),
+			tx_ring->next_to_use, i,
+			jiffies);
+
+		pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &value);
+		if (value == TXGBE_FAILED_READ_CFG_WORD)
+			txgbe_info(hw, "pcie link has been lost.\n");
+
+		netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
+
+		txgbe_info(probe,
+			   "tx hang %d detected on queue %d, resetting adapter\n",
+			   adapter->tx_timeout_count + 1, tx_ring->queue_index);
+
+		/* the adapter is about to reset, no point in enabling stuff */
+		return true;
 	}
 
-	adapter->interrupt_event = 0;
-}
-
-static void txgbe_check_overtemp_event(struct txgbe_adapter *adapter, u32 eicr)
-{
-	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
-		return;
+	netdev_tx_completed_queue(txring_txq(tx_ring),
+				  total_packets, total_bytes);
 
-	if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
-		adapter->interrupt_event = eicr;
-		adapter->flags2 |= TXGBE_FLAG2_TEMP_SENSOR_EVENT;
-		txgbe_service_event_schedule(adapter);
+#define TX_WAKE_THRESHOLD (DESC_NEEDED * 2)
+	if (unlikely(total_packets && netif_carrier_ok(tx_ring->netdev) &&
+		     (txgbe_desc_unused(tx_ring) >= TX_WAKE_THRESHOLD))) {
+		/* Make sure that anybody stopping the queue after this
+		 * sees the new next_to_clean.
+		 */
+		smp_mb();
+
+		if (__netif_subqueue_stopped(tx_ring->netdev,
+					     tx_ring->queue_index) &&
+		    !test_bit(__TXGBE_DOWN, &adapter->state)) {
+			netif_wake_subqueue(tx_ring->netdev,
+					    tx_ring->queue_index);
+			++tx_ring->tx_stats.restart_queue;
+		}
 	}
+
+	return !!budget;
 }
 
-static void txgbe_check_sfp_event(struct txgbe_adapter *adapter, u32 eicr)
+#define TXGBE_RSS_L4_TYPES_MASK \
+	((1ul << TXGBE_RXD_RSSTYPE_IPV4_TCP) | \
+	 (1ul << TXGBE_RXD_RSSTYPE_IPV4_UDP) | \
+	 (1ul << TXGBE_RXD_RSSTYPE_IPV4_SCTP) | \
+	 (1ul << TXGBE_RXD_RSSTYPE_IPV6_TCP) | \
+	 (1ul << TXGBE_RXD_RSSTYPE_IPV6_UDP) | \
+	 (1ul << TXGBE_RXD_RSSTYPE_IPV6_SCTP))
+
+static inline void txgbe_rx_hash(struct txgbe_ring *ring,
+				 union txgbe_rx_desc *rx_desc,
+				 struct sk_buff *skb)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 eicr_mask = TXGBE_PX_MISC_IC_GPIO;
-	u32 reg;
+	u16 rss_type;
 
-	if (eicr & eicr_mask) {
-		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
-			wr32(hw, TXGBE_GPIO_INTMASK, 0xFF);
-			reg = rd32(hw, TXGBE_GPIO_INTSTATUS);
-			if (reg & TXGBE_GPIO_INTSTATUS_2) {
-				adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
-				wr32(hw, TXGBE_GPIO_EOI,
-				     TXGBE_GPIO_EOI_2);
-				adapter->sfp_poll_time = 0;
-				txgbe_service_event_schedule(adapter);
-			}
-			if (reg & TXGBE_GPIO_INTSTATUS_3) {
-				adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
-				wr32(hw, TXGBE_GPIO_EOI,
-				     TXGBE_GPIO_EOI_3);
-				txgbe_service_event_schedule(adapter);
-			}
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
+		return;
 
-			if (reg & TXGBE_GPIO_INTSTATUS_6) {
-				wr32(hw, TXGBE_GPIO_EOI,
-				     TXGBE_GPIO_EOI_6);
-				adapter->flags |=
-					TXGBE_FLAG_NEED_LINK_CONFIG;
-				txgbe_service_event_schedule(adapter);
-			}
-			wr32(hw, TXGBE_GPIO_INTMASK, 0x0);
-		}
-	}
-}
+	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+		   TXGBE_RXD_RSSTYPE_MASK;
 
-static void txgbe_check_lsc(struct txgbe_adapter *adapter)
-{
-	adapter->lsc_int++;
-	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
-	adapter->link_check_timeout = jiffies;
-	if (!test_bit(__TXGBE_DOWN, &adapter->state))
-		txgbe_service_event_schedule(adapter);
+	if (!rss_type)
+		return;
+
+	skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
+		     (TXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
+		     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
 }
 
 /**
- * txgbe_irq_enable - Enable default interrupt generation settings
- * @adapter: board private structure
+ * txgbe_rx_checksum - indicate in skb if hw indicated a good cksum
+ * @ring: structure containing ring specific data
+ * @rx_desc: current Rx descriptor being processed
+ * @skb: skb currently being received and modified
  **/
-void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
+static inline void txgbe_rx_checksum(struct txgbe_ring *ring,
+				     union txgbe_rx_desc *rx_desc,
+				     struct sk_buff *skb)
 {
-	u32 mask = 0;
-	struct txgbe_hw *hw = &adapter->hw;
-	u8 device_type = hw->subsystem_id & 0xF0;
+	struct txgbe_dptype dptype = decode_rx_desc_ptype(rx_desc);
 
-	/* enable gpio interrupt */
-	if (device_type != TXGBE_ID_MAC_XAUI &&
-	    device_type != TXGBE_ID_MAC_SGMII) {
-		mask |= TXGBE_GPIO_INTEN_2;
-		mask |= TXGBE_GPIO_INTEN_3;
-		mask |= TXGBE_GPIO_INTEN_6;
-	}
-	wr32(&adapter->hw, TXGBE_GPIO_INTEN, mask);
+	skb->ip_summed = CHECKSUM_NONE;
 
-	if (device_type != TXGBE_ID_MAC_XAUI &&
-	    device_type != TXGBE_ID_MAC_SGMII) {
-		mask = TXGBE_GPIO_INTTYPE_LEVEL_2 | TXGBE_GPIO_INTTYPE_LEVEL_3 |
-			TXGBE_GPIO_INTTYPE_LEVEL_6;
-	}
-	wr32(&adapter->hw, TXGBE_GPIO_INTTYPE_LEVEL, mask);
+	skb_checksum_none_assert(skb);
 
-	/* enable misc interrupt */
-	mask = TXGBE_PX_MISC_IEN_MASK;
+	/* Rx csum disabled */
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+		return;
 
-	mask |= TXGBE_PX_MISC_IEN_OVER_HEAT;
+	/* if IPv4 header checksum error */
+	if ((txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_IPCS) &&
+	     txgbe_test_staterr(rx_desc, TXGBE_RXD_ERR_IPE)) ||
+	    (txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_OUTERIPCS) &&
+	     txgbe_test_staterr(rx_desc, TXGBE_RXD_ERR_OUTERIPER))) {
+		ring->rx_stats.csum_err++;
+		return;
+	}
 
-	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
+	/* L4 checksum offload flag must set for the below code to work */
+	if (!txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_L4CS))
+		return;
 
-	/* unmask interrupt */
-	txgbe_intr_enable(&adapter->hw, TXGBE_INTR_MISC(adapter));
-	if (queues)
-		txgbe_intr_enable(&adapter->hw, TXGBE_INTR_QALL(adapter));
+	/*likely incorrect csum if IPv6 Dest Header found */
+	if (dptype.prot != TXGBE_DEC_PTYPE_PROT_SCTP && TXGBE_RXD_IPV6EX(rx_desc))
+		return;
 
-	/* flush configuration */
-	if (flush)
-		TXGBE_WRITE_FLUSH(&adapter->hw);
+	/* if L4 checksum error */
+	if (txgbe_test_staterr(rx_desc, TXGBE_RXD_ERR_TCPE)) {
+		ring->rx_stats.csum_err++;
+		return;
+	}
+	/* If there is an outer header present that might contain a checksum
+	 * we need to bump the checksum level by 1 to reflect the fact that
+	 * we are indicating we validated the inner checksum.
+	 */
+	if (dptype.etype >= TXGBE_DEC_PTYPE_ETYPE_IG) {
+		skb->csum_level = 1;
+		/* FIXME :does skb->csum_level skb->encapsulation can both set ? */
+		skb->encapsulation = 1;
+	}
+
+	/* It must be a TCP or UDP or SCTP packet with a valid checksum */
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	ring->rx_stats.csum_good_cnt++;
 }
 
-static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
+static bool txgbe_alloc_mapped_page(struct txgbe_ring *rx_ring,
+				    struct txgbe_rx_buffer *bi)
 {
-	struct txgbe_adapter *adapter = data;
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 eicr;
-	u32 ecc;
+	struct page *page = bi->page;
+	dma_addr_t dma;
 
-	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	/* since we are recycling buffers we should seldom need to alloc */
+	if (likely(page))
+		return true;
 
-	if (eicr & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
-		txgbe_check_lsc(adapter);
+	/* alloc new page for storage */
+	page = dev_alloc_pages(txgbe_rx_pg_order(rx_ring));
+	if (unlikely(!page)) {
+		rx_ring->rx_stats.alloc_rx_page_failed++;
+		return false;
+	}
 
-	if (eicr & TXGBE_PX_MISC_IC_INT_ERR) {
-		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
-		ecc = rd32(hw, TXGBE_MIS_ST);
-		if (((ecc & TXGBE_MIS_ST_LAN0_ECC) && hw->bus.lan_id == 0) ||
-		    ((ecc & TXGBE_MIS_ST_LAN1_ECC) && hw->bus.lan_id == 1))
-			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+	/* map page for use */
+	dma = dma_map_page(rx_ring->dev, page, 0,
+			   txgbe_rx_pg_size(rx_ring), DMA_FROM_DEVICE);
 
-		txgbe_service_event_schedule(adapter);
-	}
-	if (eicr & TXGBE_PX_MISC_IC_DEV_RST) {
-		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
-		txgbe_service_event_schedule(adapter);
-	}
-	if ((eicr & TXGBE_PX_MISC_IC_STALL) ||
-	    (eicr & TXGBE_PX_MISC_IC_ETH_EVENT)) {
-		adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
-		txgbe_service_event_schedule(adapter);
-	}
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rx_ring->dev, dma)) {
+		__free_pages(page, txgbe_rx_pg_order(rx_ring));
 
-	txgbe_check_sfp_event(adapter, eicr);
-	txgbe_check_overtemp_event(adapter, eicr);
+		rx_ring->rx_stats.alloc_rx_page_failed++;
+		return false;
+	}
 
-	/* re-enable the original interrupt state, no lsc, no queues */
-	if (!test_bit(__TXGBE_DOWN, &adapter->state))
-		txgbe_irq_enable(adapter, false, false);
+	bi->page_dma = dma;
+	bi->page = page;
+	bi->page_offset = 0;
 
-	return IRQ_HANDLED;
+	return true;
 }
 
-static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
+/**
+ * txgbe_alloc_rx_buffers - Replace used receive buffers
+ * @rx_ring: ring to place buffers on
+ * @cleaned_count: number of buffers to replace
+ **/
+void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count)
 {
-	struct txgbe_q_vector *q_vector = data;
+	union txgbe_rx_desc *rx_desc;
+	struct txgbe_rx_buffer *bi;
+	u16 i = rx_ring->next_to_use;
 
-	/* EIAM disabled interrupts (on this vector) for us */
+	/* nothing to do */
+	if (!cleaned_count)
+		return;
 
-	if (q_vector->rx.ring || q_vector->tx.ring)
-		napi_schedule_irqoff(&q_vector->napi);
+	rx_desc = TXGBE_RX_DESC(rx_ring, i);
+	bi = &rx_ring->rx_buffer_info[i];
+	i -= rx_ring->count;
+
+	do {
+		if (!txgbe_alloc_mapped_page(rx_ring, bi))
+			break;
+		rx_desc->read.pkt_addr =
+			cpu_to_le64(bi->page_dma + bi->page_offset);
+
+		rx_desc++;
+		bi++;
+		i++;
+		if (unlikely(!i)) {
+			rx_desc = TXGBE_RX_DESC(rx_ring, 0);
+			bi = rx_ring->rx_buffer_info;
+			i -= rx_ring->count;
+		}
 
-	return IRQ_HANDLED;
-}
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.upper.status_error = 0;
 
-/**
- * txgbe_request_msix_irqs - Initialize MSI-X interrupts
- * @adapter: board private structure
- *
- * txgbe_request_msix_irqs allocates MSI-X vectors and requests
- * interrupts from the kernel.
- **/
-static int txgbe_request_msix_irqs(struct txgbe_adapter *adapter)
-{
-	struct net_device *netdev = adapter->netdev;
-	int vector, err;
-	int ri = 0, ti = 0;
+		cleaned_count--;
+	} while (cleaned_count);
 
-	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
-		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
-		struct msix_entry *entry = &adapter->msix_entries[vector];
+	i += rx_ring->count;
 
-		if (q_vector->tx.ring && q_vector->rx.ring) {
-			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
-				 "%s-TxRx-%d", netdev->name, ri++);
-			ti++;
-		} else if (q_vector->rx.ring) {
-			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
-				 "%s-rx-%d", netdev->name, ri++);
-		} else if (q_vector->tx.ring) {
-			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
-				 "%s-tx-%d", netdev->name, ti++);
-		} else {
-			/* skip this unused q_vector */
-			continue;
-		}
-		err = request_irq(entry->vector, &txgbe_msix_clean_rings, 0,
-				  q_vector->name, q_vector);
-		if (err) {
-			txgbe_err(probe, "request_irq failed for MSIX interrupt '%s' Error: %d\n",
-				  q_vector->name, err);
-			goto free_queue_irqs;
-		}
-	}
+	if (rx_ring->next_to_use != i) {
+		rx_ring->next_to_use = i;
+		/* update next to alloc since we have filled the ring */
+		rx_ring->next_to_alloc = i;
 
-	err = request_irq(adapter->msix_entries[vector].vector,
-			  txgbe_msix_other, 0, netdev->name, adapter);
-	if (err) {
-		txgbe_err(probe, "request_irq for msix_other failed: %d\n", err);
-		goto free_queue_irqs;
+		/* Force memory writes to complete before letting h/w
+		 * know there are new descriptors to fetch.  (Only
+		 * applicable for weak-ordered memory model archs,
+		 * such as IA-64).
+		 */
+		wmb();
+		writel(i, rx_ring->tail);
 	}
+}
 
-	return 0;
+static void txgbe_set_rsc_gso_size(struct txgbe_ring __maybe_unused *ring,
+				   struct sk_buff *skb)
+{
+	u16 hdr_len = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
 
-free_queue_irqs:
-	while (vector) {
-		vector--;
-		irq_set_affinity_hint(adapter->msix_entries[vector].vector,
-				      NULL);
-		free_irq(adapter->msix_entries[vector].vector,
-			 adapter->q_vector[vector]);
-	}
-	adapter->flags &= ~TXGBE_FLAG_MSIX_ENABLED;
-	pci_disable_msix(adapter->pdev);
-	kfree(adapter->msix_entries);
-	adapter->msix_entries = NULL;
-	return err;
+	/* set gso_size to avoid messing up TCP MSS */
+	skb_shinfo(skb)->gso_size = DIV_ROUND_UP((skb->len - hdr_len),
+						 TXGBE_CB(skb)->append_cnt);
+	skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
 }
 
-/**
- * txgbe_intr - legacy mode Interrupt Handler
- * @irq: interrupt number
- * @data: pointer to a network interface device structure
- **/
-static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
+static void txgbe_update_rsc_stats(struct txgbe_ring *rx_ring,
+				   struct sk_buff *skb)
 {
-	struct txgbe_adapter *adapter = data;
-	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
-	u32 eicr;
-	u32 eicr_misc;
+	/* if append_cnt is 0 then frame is not RSC */
+	if (!TXGBE_CB(skb)->append_cnt)
+		return;
 
-	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_VEC0);
-	if (!eicr) {
-		/* shared interrupt alert!
-		 * the interrupt that we masked before the EICR read.
-		 */
-		if (!test_bit(__TXGBE_DOWN, &adapter->state))
-			txgbe_irq_enable(adapter, true, true);
-		return IRQ_NONE;        /* Not our interrupt */
-	}
-	adapter->isb_mem[TXGBE_ISB_VEC0] = 0;
-	if (!(adapter->flags & TXGBE_FLAG_MSI_ENABLED))
-		wr32(&adapter->hw, TXGBE_PX_INTA, 1);
+	rx_ring->rx_stats.rsc_count += TXGBE_CB(skb)->append_cnt;
+	rx_ring->rx_stats.rsc_flush++;
 
-	eicr_misc = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
-	if (eicr_misc & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
-		txgbe_check_lsc(adapter);
+	txgbe_set_rsc_gso_size(rx_ring, skb);
 
-	if (eicr_misc & TXGBE_PX_MISC_IC_INT_ERR) {
-		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
-		adapter->flags2 |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
-		txgbe_service_event_schedule(adapter);
-	}
+	/* gso_size is computed using append_cnt so always clear it last */
+	TXGBE_CB(skb)->append_cnt = 0;
+}
 
-	if (eicr_misc & TXGBE_PX_MISC_IC_DEV_RST) {
-		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
-		txgbe_service_event_schedule(adapter);
+static void txgbe_rx_vlan(struct txgbe_ring *ring,
+			  union txgbe_rx_desc *rx_desc,
+			  struct sk_buff *skb)
+{
+	u8 idx = 0;
+	u16 ethertype;
+
+	if ((ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_VP)) {
+		idx = (le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+		       TXGBE_RXD_TPID_MASK) >> TXGBE_RXD_TPID_SHIFT;
+		ethertype = ring->q_vector->adapter->hw.tpid[idx];
+		__vlan_hwaccel_put_tag(skb,
+				       htons(ethertype),
+				       le16_to_cpu(rx_desc->wb.upper.vlan));
 	}
-	txgbe_check_sfp_event(adapter, eicr_misc);
-	txgbe_check_overtemp_event(adapter, eicr_misc);
+}
 
-	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
-	/* would disable interrupts here but it is auto disabled */
-	napi_schedule_irqoff(&q_vector->napi);
+/**
+ * txgbe_process_skb_fields - Populate skb header fields from Rx descriptor
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @rx_desc: pointer to the EOP Rx descriptor
+ * @skb: pointer to current skb being populated
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, VLAN, protocol, and
+ * other fields within the skb.
+ **/
+static void txgbe_process_skb_fields(struct txgbe_ring *rx_ring,
+				     union txgbe_rx_desc *rx_desc,
+				     struct sk_buff *skb)
+{
+	txgbe_update_rsc_stats(rx_ring, skb);
+	txgbe_rx_hash(rx_ring, rx_desc, skb);
+	txgbe_rx_checksum(rx_ring, rx_desc, skb);
 
-	/* re-enable link(maybe) and non-queue interrupts, no flush.
-	 * txgbe_poll will re-enable the queue interrupts
-	 */
-	if (!test_bit(__TXGBE_DOWN, &adapter->state))
-		txgbe_irq_enable(adapter, false, false);
+	txgbe_rx_vlan(rx_ring, rx_desc, skb);
 
-	return IRQ_HANDLED;
+	skb_record_rx_queue(skb, rx_ring->queue_index);
+
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+}
+
+static void txgbe_rx_skb(struct txgbe_q_vector *q_vector,
+			 struct sk_buff *skb)
+{
+	napi_gro_receive(&q_vector->napi, skb);
 }
 
 /**
- * txgbe_request_irq - initialize interrupts
- * @adapter: board private structure
+ * txgbe_is_non_eop - process handling of non-EOP buffers
+ * @rx_ring: Rx ring being processed
+ * @rx_desc: Rx descriptor for current buffer
+ * @skb: Current socket buffer containing buffer in progress
  *
- * Attempts to configure interrupts using the best available
- * capabilities of the hardware and kernel.
+ * This function updates next to clean.  If the buffer is an EOP buffer
+ * this function exits returning false, otherwise it will place the
+ * sk_buff in the next buffer to be chained and return true indicating
+ * that this is in fact a non-EOP buffer.
  **/
-static int txgbe_request_irq(struct txgbe_adapter *adapter)
+static bool txgbe_is_non_eop(struct txgbe_ring *rx_ring,
+			     union txgbe_rx_desc *rx_desc,
+			     struct sk_buff *skb)
 {
-	struct net_device *netdev = adapter->netdev;
-	int err;
+	u32 ntc = rx_ring->next_to_clean + 1;
 
-	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
-		err = txgbe_request_msix_irqs(adapter);
-	else if (adapter->flags & TXGBE_FLAG_MSI_ENABLED)
-		err = request_irq(adapter->pdev->irq, &txgbe_intr, 0,
-				  netdev->name, adapter);
-	else
-		err = request_irq(adapter->pdev->irq, &txgbe_intr, IRQF_SHARED,
-				  netdev->name, adapter);
+	/* fetch, update, and store next to clean */
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
 
-	if (err)
-		txgbe_err(probe, "request_irq failed, Error %d\n", err);
+	prefetch(TXGBE_RX_DESC(rx_ring, ntc));
 
-	return err;
+	/* update RSC append count if present */
+	if (ring_is_rsc_enabled(rx_ring)) {
+		__le32 rsc_enabled = rx_desc->wb.lower.lo_dword.data &
+				     cpu_to_le32(TXGBE_RXD_RSCCNT_MASK);
+
+		if (unlikely(rsc_enabled)) {
+			u32 rsc_cnt = le32_to_cpu(rsc_enabled);
+
+			rsc_cnt >>= TXGBE_RXD_RSCCNT_SHIFT;
+			TXGBE_CB(skb)->append_cnt += rsc_cnt - 1;
+
+			/* update ntc based on RSC value */
+			ntc = le32_to_cpu(rx_desc->wb.upper.status_error);
+			ntc &= TXGBE_RXD_NEXTP_MASK;
+			ntc >>= TXGBE_RXD_NEXTP_SHIFT;
+		}
+	}
+
+	/* if we are the last buffer then there is nothing else to do */
+	if (likely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP)))
+		return false;
+
+	rx_ring->rx_buffer_info[ntc].skb = skb;
+	rx_ring->rx_stats.non_eop_descs++;
+
+	return true;
 }
 
-static void txgbe_free_irq(struct txgbe_adapter *adapter)
+static void txgbe_pull_tail(struct sk_buff *skb)
 {
-	int vector;
+	skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+	unsigned char *va;
+	unsigned int pull_len;
 
-	if (!(adapter->flags & TXGBE_FLAG_MSIX_ENABLED)) {
-		free_irq(adapter->pdev->irq, adapter);
-		return;
-	}
+	/* it is valid to use page_address instead of kmap since we are
+	 * working with pages allocated out of the lomem pool per
+	 * alloc_page(GFP_ATOMIC)
+	 */
+	va = skb_frag_address(frag);
 
-	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
-		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
-		struct msix_entry *entry = &adapter->msix_entries[vector];
+	/* we need the header to contain the greater of either ETH_HLEN or
+	 * 60 bytes if the skb->len is less than 60 for skb_pad.
+	 */
+	pull_len = eth_get_headlen(skb->dev, va, TXGBE_RX_HDR_SIZE);
 
-		/* free only the irqs that were actually requested */
-		if (!q_vector->rx.ring && !q_vector->tx.ring)
-			continue;
+	/* align pull length to size of long to optimize memcpy performance */
+	skb_copy_to_linear_data(skb, va, ALIGN(pull_len, sizeof(long)));
 
-		/* clear the affinity_mask in the IRQ descriptor */
-		irq_set_affinity_hint(entry->vector, NULL);
-		free_irq(entry->vector, q_vector);
+	/* update all of the pointers */
+	skb_frag_size_sub(frag, pull_len);
+	skb_frag_off_add(frag, pull_len);
+	skb->data_len -= pull_len;
+	skb->tail += pull_len;
+}
+
+/**
+ * txgbe_dma_sync_frag - perform DMA sync for first frag of SKB
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @skb: pointer to current skb being updated
+ *
+ * This function provides a basic DMA sync up for the first fragment of an
+ * skb.  The reason for doing this is that the first fragment cannot be
+ * unmapped until we have reached the end of packet descriptor for a buffer
+ * chain.
+ */
+static void txgbe_dma_sync_frag(struct txgbe_ring *rx_ring,
+				struct sk_buff *skb)
+{
+	if (ring_uses_build_skb(rx_ring)) {
+		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
+
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      TXGBE_CB(skb)->dma,
+					      offset,
+					      skb_headlen(skb),
+					      DMA_FROM_DEVICE);
+	} else {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      TXGBE_CB(skb)->dma,
+					      skb_frag_off(frag),
+					      skb_frag_size(frag),
+					      DMA_FROM_DEVICE);
 	}
 
-	free_irq(adapter->msix_entries[vector++].vector, adapter);
+	/* If the page was released, just unmap it. */
+	if (unlikely(TXGBE_CB(skb)->page_released)) {
+		dma_unmap_page_attrs(rx_ring->dev, TXGBE_CB(skb)->dma,
+				     txgbe_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE,
+				     TXGBE_RX_DMA_ATTR);
+	}
 }
 
 /**
- * txgbe_irq_disable - Mask off interrupt generation on the NIC
- * @adapter: board private structure
+ * txgbe_cleanup_headers - Correct corrupted or empty headers
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @rx_desc: pointer to the EOP Rx descriptor
+ * @skb: pointer to current skb being fixed
+ *
+ * Check for corrupted packet headers caused by senders on the local L2
+ * embedded NIC switch not setting up their Tx Descriptors right.  These
+ * should be very rare.
+ *
+ * Also address the case where we are pulling data in on pages only
+ * and as such no data is present in the skb header.
+ *
+ * In addition if skb is not at least 60 bytes we need to pad it so that
+ * it is large enough to qualify as a valid Ethernet frame.
+ *
+ * Returns true if an error was encountered and skb was freed.
  **/
-void txgbe_irq_disable(struct txgbe_adapter *adapter)
+static bool txgbe_cleanup_headers(struct txgbe_ring *rx_ring,
+				  union txgbe_rx_desc *rx_desc,
+				  struct sk_buff *skb)
 {
-	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, 0);
-	txgbe_intr_disable(&adapter->hw, TXGBE_INTR_ALL);
+	struct net_device *netdev = rx_ring->netdev;
 
-	TXGBE_WRITE_FLUSH(&adapter->hw);
-	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED) {
-		int vector;
+	/* verify that the packet does not have any known errors */
+	if (unlikely(txgbe_test_staterr(rx_desc,
+					TXGBE_RXD_ERR_FRAME_ERR_MASK) &&
+		     !(netdev->features & NETIF_F_RXALL))) {
+		dev_kfree_skb_any(skb);
+		return true;
+	}
 
-		for (vector = 0; vector < adapter->num_q_vectors; vector++)
-			synchronize_irq(adapter->msix_entries[vector].vector);
+	/* place header in linear portion of buffer */
+	if (skb_is_nonlinear(skb)  && !skb_headlen(skb))
+		txgbe_pull_tail(skb);
 
-		synchronize_irq(adapter->msix_entries[vector++].vector);
-	} else {
-		synchronize_irq(adapter->pdev->irq);
-	}
+	/* if eth_skb_pad returns an error the skb was freed */
+	if (eth_skb_pad(skb))
+		return true;
+
+	return false;
 }
 
 /**
- * txgbe_configure_msi_and_legacy - Initialize PIN (INTA...) and MSI interrupts
+ * txgbe_reuse_rx_page - page flip buffer and store it back on the ring
+ * @rx_ring: rx descriptor ring to store buffers on
+ * @old_buff: donor buffer to have page reused
  *
+ * Synchronizes page for reuse by the adapter
  **/
-static void txgbe_configure_msi_and_legacy(struct txgbe_adapter *adapter)
+static void txgbe_reuse_rx_page(struct txgbe_ring *rx_ring,
+				struct txgbe_rx_buffer *old_buff)
 {
-	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
-	struct txgbe_ring *ring;
-
-	txgbe_write_eitr(q_vector);
+	struct txgbe_rx_buffer *new_buff;
+	u16 nta = rx_ring->next_to_alloc;
 
-	txgbe_for_each_ring(ring, q_vector->rx)
-		txgbe_set_ivar(adapter, 0, ring->reg_idx, 0);
+	new_buff = &rx_ring->rx_buffer_info[nta];
 
-	txgbe_for_each_ring(ring, q_vector->tx)
-		txgbe_set_ivar(adapter, 1, ring->reg_idx, 0);
+	/* update, and store next to alloc */
+	nta++;
+	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
 
-	txgbe_set_ivar(adapter, -1, 0, 1);
+	/* transfer page from old buffer to new buffer */
+	new_buff->page_dma = old_buff->page_dma;
+	new_buff->page = old_buff->page;
+	new_buff->page_offset = old_buff->page_offset;
 
-	txgbe_info(hw, "Legacy interrupt IVAR setup done\n");
+	/* sync the buffer for use by the device */
+	dma_sync_single_range_for_device(rx_ring->dev, new_buff->page_dma,
+					 new_buff->page_offset,
+					 txgbe_rx_bufsz(rx_ring),
+					 DMA_FROM_DEVICE);
 }
 
-static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
+static inline bool txgbe_page_is_reserved(struct page *page)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	int i;
-
-	for (i = 0; i < hw->mac.num_rar_entries; i++) {
-		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
-			if (adapter->mac_table[i].state &
-					TXGBE_MAC_STATE_IN_USE) {
-				TCALL(hw, mac.ops.set_rar, i,
-				      adapter->mac_table[i].addr,
-				      adapter->mac_table[i].pools,
-				      TXGBE_PSR_MAC_SWC_AD_H_AV);
-			} else {
-				TCALL(hw, mac.ops.clear_rar, i);
-			}
-			adapter->mac_table[i].state &=
-				~(TXGBE_MAC_STATE_MODIFIED);
-		}
-	}
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-/* this function destroys the first RAR entry */
-static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
-					 u8 *addr)
+/**
+ * txgbe_add_rx_frag - Add contents of Rx buffer to sk_buff
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @rx_buffer: buffer containing page to add
+ * @rx_desc: descriptor containing length of buffer written by hardware
+ * @skb: sk_buff to place the data into
+ *
+ * This function will add the data contained in rx_buffer->page to the skb.
+ * This is done either through a direct copy if the data in the buffer is
+ * less than the skb header size, otherwise it will just attach the page as
+ * a frag to the skb.
+ *
+ * The function will then update the page offset if necessary and return
+ * true if the buffer can be reused by the adapter.
+ **/
+static bool txgbe_add_rx_frag(struct txgbe_ring *rx_ring,
+			      struct txgbe_rx_buffer *rx_buffer,
+			      union txgbe_rx_desc *rx_desc,
+			      struct sk_buff *skb)
 {
-	struct txgbe_hw *hw = &adapter->hw;
+	struct page *page = rx_buffer->page;
+	unsigned int size = le16_to_cpu(rx_desc->wb.upper.length);
+#if (PAGE_SIZE < 8192)
+	unsigned int truesize = txgbe_rx_bufsz(rx_ring);
+#else
+	unsigned int truesize = ALIGN(size, L1_CACHE_BYTES);
+	unsigned int last_offset = txgbe_rx_pg_size(rx_ring) -
+				   txgbe_rx_bufsz(rx_ring);
+#endif
+
+	if (size <= TXGBE_RX_HDR_SIZE && !skb_is_nonlinear(skb)) {
+		unsigned char *va = page_address(page) + rx_buffer->page_offset;
+
+		memcpy(__skb_put(skb, size), va, ALIGN(size, sizeof(long)));
+
+		/* page is not reserved, we can reuse buffer as-is */
+		if (likely(!txgbe_page_is_reserved(page)))
+			return true;
+
+		/* this page cannot be reused so discard it */
+		__free_pages(page, txgbe_rx_pg_order(rx_ring));
+		return false;
+	}
 
-	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
-	adapter->mac_table[0].pools = 1ULL;
-	adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
-				       TXGBE_MAC_STATE_IN_USE);
-	TCALL(hw, mac.ops.set_rar, 0, adapter->mac_table[0].addr,
-	      adapter->mac_table[0].pools,
-	      TXGBE_PSR_MAC_SWC_AD_H_AV);
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+			rx_buffer->page_offset, size, truesize);
+
+	/* avoid re-using remote pages */
+	if (unlikely(txgbe_page_is_reserved(page)))
+		return false;
+
+#if (PAGE_SIZE < 8192)
+	/* if we are only owner of page we can reuse it */
+	if (unlikely(page_count(page) != 1))
+		return false;
+
+	/* flip page offset to other buffer */
+	rx_buffer->page_offset ^= truesize;
+#else
+	/* move offset up to the next cache line */
+	rx_buffer->page_offset += truesize;
+
+	if (rx_buffer->page_offset > last_offset)
+		return false;
+#endif
+
+	/* Even if we own the page, we are not allowed to use atomic_set()
+	 * This would break get_page_unless_zero() users.
+	 */
+	page_ref_inc(page);
+
+	return true;
 }
 
-static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
+static struct sk_buff *txgbe_fetch_rx_buffer(struct txgbe_ring *rx_ring,
+					     union txgbe_rx_desc *rx_desc)
 {
-	u32 i;
-	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_rx_buffer *rx_buffer;
+	struct sk_buff *skb;
+	struct page *page;
+
+	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	page = rx_buffer->page;
+	prefetchw(page);
+
+	skb = rx_buffer->skb;
+
+	if (likely(!skb)) {
+		void *page_addr = page_address(page) +
+				  rx_buffer->page_offset;
+
+		/* prefetch first cache line of first page */
+		prefetch(page_addr);
+#if L1_CACHE_BYTES < 128
+		prefetch(page_addr + L1_CACHE_BYTES);
+#endif
+
+		/* allocate a skb to store the frags */
+		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
+						TXGBE_RX_HDR_SIZE);
+		if (unlikely(!skb)) {
+			rx_ring->rx_stats.alloc_rx_buff_failed++;
+			return NULL;
+		}
 
-	for (i = 0; i < hw->mac.num_rar_entries; i++) {
-		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
-		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
-		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
-		adapter->mac_table[i].pools = 0;
-	}
-	txgbe_sync_mac_table(adapter);
-}
-
-void txgbe_configure_isb(struct txgbe_adapter *adapter)
-{
-	/* set ISB Address */
-	struct txgbe_hw *hw = &adapter->hw;
-
-	wr32(hw, TXGBE_PX_ISB_ADDR_L,
-	     adapter->isb_dma & DMA_BIT_MASK(32));
-	wr32(hw, TXGBE_PX_ISB_ADDR_H, adapter->isb_dma >> 32);
-}
+		/* we will be copying header into skb->data in
+		 * pskb_may_pull so it is in our interest to prefetch
+		 * it now to avoid a possible cache miss
+		 */
+		prefetchw(skb->data);
 
-static void txgbe_configure(struct txgbe_adapter *adapter)
-{
-	txgbe_configure_isb(adapter);
-}
+		/* Delay unmapping of the first packet. It carries the
+		 * header information, HW may still access the header
+		 * after the writeback.  Only unmap it when EOP is
+		 * reached
+		 */
+		if (likely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP)))
+			goto dma_sync;
 
-static bool txgbe_is_sfp(struct txgbe_hw *hw)
-{
-	switch (TCALL(hw, mac.ops.get_media_type)) {
-	case txgbe_media_type_fiber:
-		return true;
-	default:
-		return false;
+		TXGBE_CB(skb)->dma = rx_buffer->page_dma;
+	} else {
+		if (txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP))
+			txgbe_dma_sync_frag(rx_ring, skb);
+
+dma_sync:
+		/* we are reusing so sync this buffer for CPU use */
+		dma_sync_single_range_for_cpu(rx_ring->dev,
+					      rx_buffer->page_dma,
+					      rx_buffer->page_offset,
+					      txgbe_rx_bufsz(rx_ring),
+					      DMA_FROM_DEVICE);
+
+		rx_buffer->skb = NULL;
 	}
-}
 
-static bool txgbe_is_backplane(struct txgbe_hw *hw)
-{
-	switch (TCALL(hw, mac.ops.get_media_type)) {
-	case txgbe_media_type_backplane:
-		return true;
-	default:
-		return false;
+	/* pull page into skb */
+	if (txgbe_add_rx_frag(rx_ring, rx_buffer, rx_desc, skb)) {
+		/* hand second half of page back to the ring */
+		txgbe_reuse_rx_page(rx_ring, rx_buffer);
+	} else if (TXGBE_CB(skb)->dma == rx_buffer->page_dma) {
+		/* the page has been released from the ring */
+		TXGBE_CB(skb)->page_released = true;
+	} else {
+		/* we are not reusing the buffer so unmap it */
+		dma_unmap_page(rx_ring->dev, rx_buffer->page_dma,
+			       txgbe_rx_pg_size(rx_ring),
+			       DMA_FROM_DEVICE);
 	}
+
+	/* clear contents of buffer_info */
+	rx_buffer->page = NULL;
+
+	return skb;
 }
 
 /**
- * txgbe_sfp_link_config - set up SFP+ link
- * @adapter: pointer to private adapter struct
+ * txgbe_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
+ * @q_vector: structure containing interrupt and ring information
+ * @rx_ring: rx descriptor ring to transact packets on
+ * @budget: Total limit on number of packets to process
+ *
+ * This function provides a "bounce buffer" approach to Rx interrupt
+ * processing.  The advantage to this is that on systems that have
+ * expensive overhead for IOMMU access this provides a means of avoiding
+ * it by maintaining the mapping of the page to the system.
+ *
+ * Returns amount of work completed.
  **/
-static void txgbe_sfp_link_config(struct txgbe_adapter *adapter)
+static int txgbe_clean_rx_irq(struct txgbe_q_vector *q_vector,
+			      struct txgbe_ring *rx_ring,
+			      int budget)
 {
-	/* We are assuming the worst case scenerio here, and that
-	 * is that an SFP was inserted/removed after the reset
-	 * but before SFP detection was enabled.  As such the best
-	 * solution is to just start searching as soon as we start
-	 */
+	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
+	u16 cleaned_count = txgbe_desc_unused(rx_ring);
 
-	adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
-	adapter->sfp_poll_time = 0;
-}
+	do {
+		union txgbe_rx_desc *rx_desc;
+		struct sk_buff *skb;
 
-static void txgbe_setup_gpie(struct txgbe_adapter *adapter)
-{
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 gpie = 0;
+		/* return some buffers to hardware, one at a time is too slow */
+		if (cleaned_count >= TXGBE_RX_BUFFER_WRITE) {
+			txgbe_alloc_rx_buffers(rx_ring, cleaned_count);
+			cleaned_count = 0;
+		}
 
-	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
-		gpie = TXGBE_PX_GPIE_MODEL;
+		rx_desc = TXGBE_RX_DESC(rx_ring, rx_ring->next_to_clean);
 
-	wr32(hw, TXGBE_PX_GPIE, gpie);
-}
+		if (!txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_DD))
+			break;
 
-static void txgbe_up_complete(struct txgbe_adapter *adapter)
-{
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 links_reg;
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc until we know the
+		 * descriptor has been written back
+		 */
+		dma_rmb();
 
-	txgbe_get_hw_control(adapter);
-	txgbe_setup_gpie(adapter);
+		/* retrieve a buffer from the ring */
+		skb = txgbe_fetch_rx_buffer(rx_ring, rx_desc);
 
-	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
-		txgbe_configure_msix(adapter);
-	else
-		txgbe_configure_msi_and_legacy(adapter);
+		/* exit if we failed to retrieve a buffer */
+		if (!skb)
+			break;
 
-	/* enable the optics for SFP+ fiber */
-	TCALL(hw, mac.ops.enable_tx_laser);
+		cleaned_count++;
 
-	smp_mb__before_atomic();
-	clear_bit(__TXGBE_DOWN, &adapter->state);
+		/* place incomplete frames back on ring for completion */
+		if (txgbe_is_non_eop(rx_ring, rx_desc, skb))
+			continue;
 
-	if (txgbe_is_sfp(hw)) {
-		txgbe_sfp_link_config(adapter);
-	} else if (txgbe_is_backplane(hw)) {
-		adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
-		txgbe_service_event_schedule(adapter);
-	}
+		/* verify the packet layout is correct */
+		if (txgbe_cleanup_headers(rx_ring, rx_desc, skb))
+			continue;
 
-	links_reg = rd32(hw, TXGBE_CFG_PORT_ST);
-	if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP) {
-		if (links_reg & TXGBE_CFG_PORT_ST_LINK_10G) {
-			wr32(hw, TXGBE_MAC_TX_CFG,
-			     (rd32(hw, TXGBE_MAC_TX_CFG) &
-			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
-			     TXGBE_MAC_TX_CFG_SPEED_10G);
-		} else if (links_reg & (TXGBE_CFG_PORT_ST_LINK_1G | TXGBE_CFG_PORT_ST_LINK_100M)) {
-			wr32(hw, TXGBE_MAC_TX_CFG,
-			     (rd32(hw, TXGBE_MAC_TX_CFG) &
-			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
-			     TXGBE_MAC_TX_CFG_SPEED_1G);
-		}
-	}
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
 
-	/* clear any pending interrupts, may auto mask */
-	rd32(hw, TXGBE_PX_IC(0));
-	rd32(hw, TXGBE_PX_IC(1));
-	rd32(hw, TXGBE_PX_MISC_IC);
-	if ((hw->subsystem_id & 0xF0) == TXGBE_ID_XAUI)
-		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
-	txgbe_irq_enable(adapter, true, true);
+		/* populate checksum, timestamp, VLAN, and protocol */
+		txgbe_process_skb_fields(rx_ring, rx_desc, skb);
 
-	/* bring the link up in the watchdog, this could race with our first
-	 * link up interrupt but shouldn't be a problem
-	 */
-	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
-	adapter->link_check_timeout = jiffies;
+		txgbe_rx_skb(q_vector, skb);
 
-	mod_timer(&adapter->service_timer, jiffies);
+		/* update budget accounting */
+		total_rx_packets++;
+	} while (likely(total_rx_packets < budget));
 
-	if (hw->bus.lan_id == 0) {
-		wr32m(hw, TXGBE_MIS_PRB_CTL,
-		      TXGBE_MIS_PRB_CTL_LAN0_UP, TXGBE_MIS_PRB_CTL_LAN0_UP);
-	} else if (hw->bus.lan_id == 1) {
-		wr32m(hw, TXGBE_MIS_PRB_CTL,
-		      TXGBE_MIS_PRB_CTL_LAN1_UP, TXGBE_MIS_PRB_CTL_LAN1_UP);
-	} else {
-		txgbe_err(probe, "%s:invalid bus lan id %d\n",
-			  __func__, hw->bus.lan_id);
-	}
+	u64_stats_update_begin(&rx_ring->syncp);
+	rx_ring->stats.packets += total_rx_packets;
+	rx_ring->stats.bytes += total_rx_bytes;
+	u64_stats_update_end(&rx_ring->syncp);
+	q_vector->rx.total_packets += total_rx_packets;
+	q_vector->rx.total_bytes += total_rx_bytes;
 
-	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
-	wr32m(hw, TXGBE_CFG_PORT_CTL,
-	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
+	return total_rx_packets;
 }
 
-void txgbe_reinit_locked(struct txgbe_adapter *adapter)
+/**
+ * txgbe_configure_msix - Configure MSI-X hardware
+ * @adapter: board private structure
+ *
+ * txgbe_configure_msix sets up the hardware to properly generate MSI-X
+ * interrupts.
+ **/
+static void txgbe_configure_msix(struct txgbe_adapter *adapter)
 {
-	/* put off any impending NetWatchDogTimeout */
-	netif_trans_update(adapter->netdev);
+	u16 v_idx;
 
-	while (test_and_set_bit(__TXGBE_RESETTING, &adapter->state))
-		usleep_range(1000, 2000);
-	txgbe_down(adapter);
-	txgbe_up(adapter);
-	clear_bit(__TXGBE_RESETTING, &adapter->state);
-}
+	/* Populate MSIX to EITR Select */
+	wr32(&adapter->hw, TXGBE_PX_ITRSEL, 0);
 
-void txgbe_up(struct txgbe_adapter *adapter)
-{
-	/* hardware has been reset, we need to reload some things */
-	txgbe_configure(adapter);
+	/* Populate the IVAR table and set the ITR values to the
+	 * corresponding register.
+	 */
+	for (v_idx = 0; v_idx < adapter->num_q_vectors; v_idx++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[v_idx];
+		struct txgbe_ring *ring;
 
-	txgbe_up_complete(adapter);
+		txgbe_for_each_ring(ring, q_vector->rx)
+			txgbe_set_ivar(adapter, 0, ring->reg_idx, v_idx);
+
+		txgbe_for_each_ring(ring, q_vector->tx)
+			txgbe_set_ivar(adapter, 1, ring->reg_idx, v_idx);
+
+		txgbe_write_eitr(q_vector);
+	}
+
+	txgbe_set_ivar(adapter, -1, 0, v_idx);
+
+	wr32(&adapter->hw, TXGBE_PX_ITR(v_idx), 1950);
 }
 
-void txgbe_reset(struct txgbe_adapter *adapter)
+enum latency_range {
+	lowest_latency = 0,
+	low_latency = 1,
+	bulk_latency = 2,
+	latency_invalid = 255
+};
+
+/**
+ * txgbe_update_itr - update the dynamic ITR value based on statistics
+ * @q_vector: structure containing interrupt and ring information
+ * @ring_container: structure containing ring performance data
+ *
+ * Stores a new ITR value based on packets and byte
+ * counts during the last interrupt.  The advantage of per interrupt
+ * computation is faster updates and more accurate ITR for the current
+ * traffic pattern.  Constants in this function were computed
+ * based on theoretical maximum wire speed and thresholds were set based
+ * on testing data as well as attempting to minimize response time
+ * while increasing bulk throughput.
+ **/
+static void txgbe_update_itr(struct txgbe_q_vector *q_vector,
+			     struct txgbe_ring_container *ring_container)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	struct net_device *netdev = adapter->netdev;
-	int err;
-	u8 old_addr[ETH_ALEN];
+	int bytes = ring_container->total_bytes;
+	int packets = ring_container->total_packets;
+	u32 timepassed_us;
+	u64 bytes_perint;
+	u8 itr_setting = ring_container->itr;
 
-	if (TXGBE_REMOVED(hw->hw_addr))
+	if (packets == 0)
 		return;
-	/* lock SFP init bit to prevent race conditions with the watchdog */
-	while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
-		usleep_range(1000, 2000);
 
-	/* clear all SFP and link config related flags while holding SFP_INIT */
-	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
-	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+	/* simple throttlerate management
+	 *   0-10MB/s   lowest (100000 ints/s)
+	 *  10-20MB/s   low    (20000 ints/s)
+	 *  20-1249MB/s bulk   (12000 ints/s)
+	 */
+	/* what was last interrupt timeslice? */
+	timepassed_us = q_vector->itr >> 2;
+	if (timepassed_us == 0)
+		return;
+	bytes_perint = bytes / timepassed_us; /* bytes/usec */
 
-	err = TCALL(hw, mac.ops.init_hw);
-	switch (err) {
-	case 0:
-	case TXGBE_ERR_SFP_NOT_PRESENT:
-	case TXGBE_ERR_SFP_NOT_SUPPORTED:
+	switch (itr_setting) {
+	case lowest_latency:
+		if (bytes_perint > 10)
+			itr_setting = low_latency;
 		break;
-	case TXGBE_ERR_MASTER_REQUESTS_PENDING:
-		txgbe_dev_err("master disable timed out\n");
+	case low_latency:
+		if (bytes_perint > 20)
+			itr_setting = bulk_latency;
+		else if (bytes_perint <= 10)
+			itr_setting = lowest_latency;
+		break;
+	case bulk_latency:
+		if (bytes_perint <= 20)
+			itr_setting = low_latency;
 		break;
-	default:
-		txgbe_dev_err("Hardware Error: %d\n", err);
 	}
 
-	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
-	/* do not flush user set addresses */
-	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
-	txgbe_flush_sw_mac_table(adapter);
-	txgbe_mac_set_default_filter(adapter, old_addr);
+	/* clear work counters since we have the values we need */
+	ring_container->total_bytes = 0;
+	ring_container->total_packets = 0;
 
-	/* update SAN MAC vmdq pool selection */
-	TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
+	/* write updated itr to ring container */
+	ring_container->itr = itr_setting;
 }
 
-void txgbe_disable_device(struct txgbe_adapter *adapter)
+/**
+ * txgbe_write_eitr - write EITR register in hardware specific way
+ * @q_vector: structure containing interrupt and ring information
+ *
+ * This function is made to be called by ethtool and by the driver
+ * when it needs to update EITR registers at runtime.  Hardware
+ * specific quirks/differences are taken care of here.
+ */
+void txgbe_write_eitr(struct txgbe_q_vector *q_vector)
 {
-	struct net_device *netdev = adapter->netdev;
+	struct txgbe_adapter *adapter = q_vector->adapter;
 	struct txgbe_hw *hw = &adapter->hw;
-	u32 i;
+	int v_idx = q_vector->v_idx;
+	u32 itr_reg = q_vector->itr & TXGBE_MAX_EITR;
 
-	/* signal that we are down to the interrupt handler */
-	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
-		return; /* do nothing if already down */
+	itr_reg |= TXGBE_PX_ITR_CNT_WDIS;
 
-	txgbe_disable_pcie_master(hw);
-	/* disable receives */
-	TCALL(hw, mac.ops.disable_rx);
+	wr32(hw, TXGBE_PX_ITR(v_idx), itr_reg);
+}
 
-	/* call carrier off first to avoid false dev_watchdog timeouts */
-	netif_carrier_off(netdev);
-	netif_tx_disable(netdev);
+static void txgbe_set_itr(struct txgbe_q_vector *q_vector)
+{
+	u16 new_itr = q_vector->itr;
+	u8 current_itr;
 
-	txgbe_irq_disable(adapter);
+	txgbe_update_itr(q_vector, &q_vector->tx);
+	txgbe_update_itr(q_vector, &q_vector->rx);
 
-	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
-			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
-	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+	current_itr = max(q_vector->rx.itr, q_vector->tx.itr);
 
-	del_timer_sync(&adapter->service_timer);
+	switch (current_itr) {
+	/* counts and packets in update_itr are dependent on these numbers */
+	case lowest_latency:
+		new_itr = TXGBE_100K_ITR;
+		break;
+	case low_latency:
+		new_itr = TXGBE_20K_ITR;
+		break;
+	case bulk_latency:
+		new_itr = TXGBE_12K_ITR;
+		break;
+	default:
+		break;
+	}
 
-	if (hw->bus.lan_id == 0)
-		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
-	else if (hw->bus.lan_id == 1)
-		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN1_UP, 0);
-	else
-		txgbe_dev_err("%s: invalid bus lan id %d\n", __func__,
-			      hw->bus.lan_id);
+	if (new_itr != q_vector->itr) {
+		/* do an exponential smoothing */
+		new_itr = (10 * new_itr * q_vector->itr) /
+			  ((9 * new_itr) + q_vector->itr);
 
-	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
-	      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
-		/* disable mac transmiter */
-		wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, 0);
-	}
-	/* disable transmits in the hardware now that interrupts are off */
-	for (i = 0; i < adapter->num_tx_queues; i++) {
-		u8 reg_idx = adapter->tx_ring[i]->reg_idx;
+		/* save the algorithm value here */
+		q_vector->itr = new_itr;
 
-		wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
+		txgbe_write_eitr(q_vector);
 	}
-
-	/* Disable the Tx DMA engine */
-	wr32m(hw, TXGBE_TDM_CTL, TXGBE_TDM_CTL_TE, 0);
 }
 
-void txgbe_down(struct txgbe_adapter *adapter)
+/**
+ * txgbe_check_overtemp_subtask - check for over temperature
+ * @adapter: pointer to adapter
+ **/
+static void txgbe_check_overtemp_subtask(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr = adapter->interrupt_event;
+	s32 temp_state;
 
-	txgbe_disable_device(adapter);
-	txgbe_reset(adapter);
+	if (test_bit(__TXGBE_DOWN, &adapter->state))
+		return;
+	if (!(adapter->flags2 & TXGBE_FLAG2_TEMP_SENSOR_EVENT))
+		return;
 
-	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)))
-		/* power down the optics for SFP+ fiber */
-		TCALL(&adapter->hw, mac.ops.disable_tx_laser);
+	adapter->flags2 &= ~TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+
+	/* Since the warning interrupt is for both ports
+	 * we don't have to check if:
+	 *  - This interrupt wasn't for our port.
+	 *  - We may have missed the interrupt so always have to
+	 *    check if we  got a LSC
+	 */
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
+
+	temp_state = TCALL(hw, phy.ops.check_overtemp);
+	if (!temp_state || temp_state == TXGBE_NOT_IMPLEMENTED)
+		return;
+
+	if (temp_state == TXGBE_ERR_UNDERTEMP &&
+	    test_bit(__TXGBE_HANGING, &adapter->state)) {
+		txgbe_crit(drv, "%s\n", txgbe_underheat_msg);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, TXGBE_RDB_PB_CTL_RXEN);
+		netif_carrier_on(adapter->netdev);
+		clear_bit(__TXGBE_HANGING, &adapter->state);
+	} else if (temp_state == TXGBE_ERR_OVERTEMP &&
+		!test_and_set_bit(__TXGBE_HANGING, &adapter->state)) {
+		txgbe_crit(drv, "%s\n", txgbe_overheat_msg);
+		netif_carrier_off(adapter->netdev);
+		wr32m(&adapter->hw, TXGBE_RDB_PB_CTL,
+		      TXGBE_RDB_PB_CTL_RXEN, 0);
+	}
+
+	adapter->interrupt_event = 0;
 }
 
-/**
- *  txgbe_init_shared_code - Initialize the shared code
- *  @hw: pointer to hardware structure
- *
- *  This will assign function pointers and assign the MAC type and PHY code.
- **/
-s32 txgbe_init_shared_code(struct txgbe_hw *hw)
+static void txgbe_check_overtemp_event(struct txgbe_adapter *adapter, u32 eicr)
 {
-	s32 status;
+	if (!(eicr & TXGBE_PX_MISC_IC_OVER_HEAT))
+		return;
 
-	status = txgbe_init_ops(hw);
-	return status;
+	if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+		adapter->interrupt_event = eicr;
+		adapter->flags2 |= TXGBE_FLAG2_TEMP_SENSOR_EVENT;
+		txgbe_service_event_schedule(adapter);
+	}
 }
 
-/**
- * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
- * @adapter: board private structure to initialize
- *
- * txgbe_sw_init initializes the Adapter private data structure.
- * Fields are initialized based on PCI device information and
- * OS network device settings (MTU size).
- **/
-static int txgbe_sw_init(struct txgbe_adapter *adapter)
+static void txgbe_check_sfp_event(struct txgbe_adapter *adapter, u32 eicr)
 {
 	struct txgbe_hw *hw = &adapter->hw;
-	struct pci_dev *pdev = adapter->pdev;
-	int err;
-
-	/* PCI config space info */
-	hw->vendor_id = pdev->vendor;
-	hw->device_id = pdev->device;
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
-	if (hw->revision_id == TXGBE_FAILED_READ_CFG_BYTE &&
-	    txgbe_check_cfg_remove(hw, pdev)) {
-		txgbe_err(probe, "read of revision id failed\n");
-		err = -ENODEV;
-		goto out;
-	}
-	hw->subsystem_vendor_id = pdev->subsystem_vendor;
-	hw->subsystem_device_id = pdev->subsystem_device;
+	u32 eicr_mask = TXGBE_PX_MISC_IC_GPIO;
+	u32 reg;
 
-	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &hw->subsystem_id);
-	if (hw->subsystem_id == TXGBE_FAILED_READ_CFG_WORD) {
-		txgbe_err(probe, "read of subsystem id failed\n");
-		err = -ENODEV;
-		goto out;
-	}
+	if (eicr & eicr_mask) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			wr32(hw, TXGBE_GPIO_INTMASK, 0xFF);
+			reg = rd32(hw, TXGBE_GPIO_INTSTATUS);
+			if (reg & TXGBE_GPIO_INTSTATUS_2) {
+				adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_2);
+				adapter->sfp_poll_time = 0;
+				txgbe_service_event_schedule(adapter);
+			}
+			if (reg & TXGBE_GPIO_INTSTATUS_3) {
+				adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_3);
+				txgbe_service_event_schedule(adapter);
+			}
 
-	err = txgbe_init_shared_code(hw);
-	if (err) {
-		txgbe_err(probe, "init_shared_code failed: %d\n", err);
-		goto out;
-	}
-	adapter->mac_table = kzalloc(sizeof(*adapter->mac_table) *
-				     hw->mac.num_rar_entries,
-				     GFP_ATOMIC);
-	if (!adapter->mac_table) {
-		err = TXGBE_ERR_OUT_OF_MEM;
-		txgbe_err(probe, "mac_table allocation failed: %d\n", err);
-		goto out;
+			if (reg & TXGBE_GPIO_INTSTATUS_6) {
+				wr32(hw, TXGBE_GPIO_EOI,
+				     TXGBE_GPIO_EOI_6);
+				adapter->flags |=
+					TXGBE_FLAG_NEED_LINK_CONFIG;
+				txgbe_service_event_schedule(adapter);
+			}
+			wr32(hw, TXGBE_GPIO_INTMASK, 0x0);
+		}
 	}
-
-	/* enable itr by default in dynamic mode */
-	adapter->rx_itr_setting = 1;
-	adapter->tx_itr_setting = 1;
-
-	adapter->atr_sample_rate = 20;
-
-	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
-
-	set_bit(__TXGBE_DOWN, &adapter->state);
-out:
-	return err;
 }
 
-/**
- * txgbe_setup_isb_resources - allocate interrupt status resources
- * @adapter: board private structure
- *
- * Return 0 on success, negative on failure
- **/
-static int txgbe_setup_isb_resources(struct txgbe_adapter *adapter)
+static void txgbe_check_lsc(struct txgbe_adapter *adapter)
 {
-	struct device *dev = pci_dev_to_dev(adapter->pdev);
-
-	adapter->isb_mem = dma_alloc_coherent(dev,
-					      sizeof(u32) * TXGBE_ISB_MAX,
-					      &adapter->isb_dma,
-					      GFP_KERNEL);
-	if (!adapter->isb_mem)
-		return -ENOMEM;
-	memset(adapter->isb_mem, 0, sizeof(u32) * TXGBE_ISB_MAX);
-	return 0;
+	adapter->lsc_int++;
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_service_event_schedule(adapter);
 }
 
 /**
- * txgbe_free_isb_resources - allocate all queues Rx resources
+ * txgbe_irq_enable - Enable default interrupt generation settings
  * @adapter: board private structure
- *
- * Return 0 on success, negative on failure
  **/
-static void txgbe_free_isb_resources(struct txgbe_adapter *adapter)
+void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush)
 {
-	struct device *dev = pci_dev_to_dev(adapter->pdev);
+	u32 mask = 0;
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 device_type = hw->subsystem_id & 0xF0;
 
-	dma_free_coherent(dev, sizeof(u32) * TXGBE_ISB_MAX,
-			  adapter->isb_mem, adapter->isb_dma);
-	adapter->isb_mem = NULL;
-}
+	/* enable gpio interrupt */
+	if (device_type != TXGBE_ID_MAC_XAUI &&
+	    device_type != TXGBE_ID_MAC_SGMII) {
+		mask |= TXGBE_GPIO_INTEN_2;
+		mask |= TXGBE_GPIO_INTEN_3;
+		mask |= TXGBE_GPIO_INTEN_6;
+	}
+	wr32(&adapter->hw, TXGBE_GPIO_INTEN, mask);
 
-/**
- * txgbe_open - Called when a network interface is made active
- * @netdev: network interface device structure
- *
- * Returns 0 on success, negative value on failure
- *
- * The open entry point is called when a network interface is made
- * active by the system (IFF_UP).  At this point all resources needed
- * for transmit and receive operations are allocated, the interrupt
- * handler is registered with the OS, the watchdog timer is started,
- * and the stack is notified that the interface is ready.
- **/
-int txgbe_open(struct net_device *netdev)
-{
-	struct txgbe_adapter *adapter = netdev_priv(netdev);
-	int err;
+	if (device_type != TXGBE_ID_MAC_XAUI &&
+	    device_type != TXGBE_ID_MAC_SGMII) {
+		mask = TXGBE_GPIO_INTTYPE_LEVEL_2 | TXGBE_GPIO_INTTYPE_LEVEL_3 |
+			TXGBE_GPIO_INTTYPE_LEVEL_6;
+	}
+	wr32(&adapter->hw, TXGBE_GPIO_INTTYPE_LEVEL, mask);
 
-	netif_carrier_off(netdev);
+	/* enable misc interrupt */
+	mask = TXGBE_PX_MISC_IEN_MASK;
 
-	err = txgbe_setup_isb_resources(adapter);
-	if (err)
-		goto err_req_isb;
+	mask |= TXGBE_PX_MISC_IEN_OVER_HEAT;
 
-	txgbe_configure(adapter);
+	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, mask);
 
-	err = txgbe_request_irq(adapter);
-	if (err)
-		goto err_req_irq;
+	/* unmask interrupt */
+	txgbe_intr_enable(&adapter->hw, TXGBE_INTR_MISC(adapter));
+	if (queues)
+		txgbe_intr_enable(&adapter->hw, TXGBE_INTR_QALL(adapter));
 
-	/* Notify the stack of the actual queue counts. */
-	err = netif_set_real_num_tx_queues(netdev, adapter->num_tx_queues);
-	if (err)
-		goto err_set_queues;
+	/* flush configuration */
+	if (flush)
+		TXGBE_WRITE_FLUSH(&adapter->hw);
+}
 
-	err = netif_set_real_num_rx_queues(netdev, adapter->num_rx_queues);
-	if (err)
-		goto err_set_queues;
+static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
+{
+	struct txgbe_adapter *adapter = data;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 eicr;
+	u32 ecc;
+
+	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+
+	if (eicr & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr & TXGBE_PX_MISC_IC_INT_ERR) {
+		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
+		ecc = rd32(hw, TXGBE_MIS_ST);
+		if (((ecc & TXGBE_MIS_ST_LAN0_ECC) && hw->bus.lan_id == 0) ||
+		    ((ecc & TXGBE_MIS_ST_LAN1_ECC) && hw->bus.lan_id == 1))
+			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+
+		txgbe_service_event_schedule(adapter);
+	}
+	if (eicr & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	if ((eicr & TXGBE_PX_MISC_IC_STALL) ||
+	    (eicr & TXGBE_PX_MISC_IC_ETH_EVENT)) {
+		adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	txgbe_check_sfp_event(adapter, eicr);
+	txgbe_check_overtemp_event(adapter, eicr);
+
+	/* re-enable the original interrupt state, no lsc, no queues */
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_irq_enable(adapter, false, false);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t txgbe_msix_clean_rings(int __always_unused irq, void *data)
+{
+	struct txgbe_q_vector *q_vector = data;
+
+	/* EIAM disabled interrupts (on this vector) for us */
+
+	if (q_vector->rx.ring || q_vector->tx.ring)
+		napi_schedule_irqoff(&q_vector->napi);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_poll - NAPI polling RX/TX cleanup routine
+ * @napi: napi struct with our devices info in it
+ * @budget: amount of work driver is allowed to do this pass, in packets
+ *
+ * This function will clean all queues associated with a q_vector.
+ **/
+int txgbe_poll(struct napi_struct *napi, int budget)
+{
+	struct txgbe_q_vector *q_vector =
+			       container_of(napi, struct txgbe_q_vector, napi);
+	struct txgbe_adapter *adapter = q_vector->adapter;
+	struct txgbe_ring *ring;
+	int per_ring_budget;
+	bool clean_complete = true;
+
+	txgbe_for_each_ring(ring, q_vector->tx) {
+		if (!txgbe_clean_tx_irq(q_vector, ring))
+			clean_complete = false;
+	}
+
+	/* Exit if we are called by netpoll */
+	if (budget <= 0)
+		return budget;
+
+	/* attempt to distribute budget to each queue fairly, but don't allow
+	 * the budget to go below 1 because we'll exit polling
+	 */
+	if (q_vector->rx.count > 1)
+		per_ring_budget = max(budget / q_vector->rx.count, 1);
+	else
+		per_ring_budget = budget;
+
+	txgbe_for_each_ring(ring, q_vector->rx) {
+		int cleaned = txgbe_clean_rx_irq(q_vector, ring,
+						 per_ring_budget);
+
+		if (cleaned >= per_ring_budget)
+			clean_complete = false;
+	}
+
+	/* If all work not completed, return budget and keep polling */
+	if (!clean_complete)
+		return budget;
+
+	/* all work done, exit the polling mode */
+	napi_complete(napi);
+	if (adapter->rx_itr_setting == 1)
+		txgbe_set_itr(q_vector);
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_intr_enable(&adapter->hw,
+				  TXGBE_INTR_Q(q_vector->v_idx));
+
+	return 0;
+}
+
+/**
+ * txgbe_request_msix_irqs - Initialize MSI-X interrupts
+ * @adapter: board private structure
+ *
+ * txgbe_request_msix_irqs allocates MSI-X vectors and requests
+ * interrupts from the kernel.
+ **/
+static int txgbe_request_msix_irqs(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int vector, err;
+	int ri = 0, ti = 0;
+
+	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
+		struct msix_entry *entry = &adapter->msix_entries[vector];
+
+		if (q_vector->tx.ring && q_vector->rx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-TxRx-%d", netdev->name, ri++);
+			ti++;
+		} else if (q_vector->rx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-rx-%d", netdev->name, ri++);
+		} else if (q_vector->tx.ring) {
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-tx-%d", netdev->name, ti++);
+		} else {
+			/* skip this unused q_vector */
+			continue;
+		}
+		err = request_irq(entry->vector, &txgbe_msix_clean_rings, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			txgbe_err(probe, "request_irq failed for MSIX interrupt '%s' Error: %d\n",
+				  q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	err = request_irq(adapter->msix_entries[vector].vector,
+			  txgbe_msix_other, 0, netdev->name, adapter);
+	if (err) {
+		txgbe_err(probe, "request_irq for msix_other failed: %d\n", err);
+		goto free_queue_irqs;
+	}
+
+	return 0;
+
+free_queue_irqs:
+	while (vector) {
+		vector--;
+		irq_set_affinity_hint(adapter->msix_entries[vector].vector,
+				      NULL);
+		free_irq(adapter->msix_entries[vector].vector,
+			 adapter->q_vector[vector]);
+	}
+	adapter->flags &= ~TXGBE_FLAG_MSIX_ENABLED;
+	pci_disable_msix(adapter->pdev);
+	kfree(adapter->msix_entries);
+	adapter->msix_entries = NULL;
+	return err;
+}
+
+/**
+ * txgbe_intr - legacy mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
+{
+	struct txgbe_adapter *adapter = data;
+	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
+	u32 eicr;
+	u32 eicr_misc;
+
+	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the EICR read.
+		 */
+		if (!test_bit(__TXGBE_DOWN, &adapter->state))
+			txgbe_irq_enable(adapter, true, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	adapter->isb_mem[TXGBE_ISB_VEC0] = 0;
+	if (!(adapter->flags & TXGBE_FLAG_MSI_ENABLED))
+		wr32(&adapter->hw, TXGBE_PX_INTA, 1);
+
+	eicr_misc = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
+	if (eicr_misc & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
+		txgbe_check_lsc(adapter);
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_INT_ERR) {
+		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
+		adapter->flags2 |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	if (eicr_misc & TXGBE_PX_MISC_IC_DEV_RST) {
+		adapter->flags2 |= TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		txgbe_service_event_schedule(adapter);
+	}
+	txgbe_check_sfp_event(adapter, eicr_misc);
+	txgbe_check_overtemp_event(adapter, eicr_misc);
+
+	adapter->isb_mem[TXGBE_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
+
+	/* re-enable link(maybe) and non-queue interrupts, no flush.
+	 * txgbe_poll will re-enable the queue interrupts
+	 */
+	if (!test_bit(__TXGBE_DOWN, &adapter->state))
+		txgbe_irq_enable(adapter, false, false);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_request_irq - initialize interrupts
+ * @adapter: board private structure
+ *
+ * Attempts to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
+static int txgbe_request_irq(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int err;
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		err = txgbe_request_msix_irqs(adapter);
+	else if (adapter->flags & TXGBE_FLAG_MSI_ENABLED)
+		err = request_irq(adapter->pdev->irq, &txgbe_intr, 0,
+				  netdev->name, adapter);
+	else
+		err = request_irq(adapter->pdev->irq, &txgbe_intr, IRQF_SHARED,
+				  netdev->name, adapter);
+
+	if (err)
+		txgbe_err(probe, "request_irq failed, Error %d\n", err);
+
+	return err;
+}
+
+static void txgbe_free_irq(struct txgbe_adapter *adapter)
+{
+	int vector;
+
+	if (!(adapter->flags & TXGBE_FLAG_MSIX_ENABLED)) {
+		free_irq(adapter->pdev->irq, adapter);
+		return;
+	}
+
+	for (vector = 0; vector < adapter->num_q_vectors; vector++) {
+		struct txgbe_q_vector *q_vector = adapter->q_vector[vector];
+		struct msix_entry *entry = &adapter->msix_entries[vector];
+
+		/* free only the irqs that were actually requested */
+		if (!q_vector->rx.ring && !q_vector->tx.ring)
+			continue;
+
+		/* clear the affinity_mask in the IRQ descriptor */
+		irq_set_affinity_hint(entry->vector, NULL);
+		free_irq(entry->vector, q_vector);
+	}
+
+	free_irq(adapter->msix_entries[vector++].vector, adapter);
+}
+
+/**
+ * txgbe_irq_disable - Mask off interrupt generation on the NIC
+ * @adapter: board private structure
+ **/
+void txgbe_irq_disable(struct txgbe_adapter *adapter)
+{
+	wr32(&adapter->hw, TXGBE_PX_MISC_IEN, 0);
+	txgbe_intr_disable(&adapter->hw, TXGBE_INTR_ALL);
+
+	TXGBE_WRITE_FLUSH(&adapter->hw);
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED) {
+		int vector;
+
+		for (vector = 0; vector < adapter->num_q_vectors; vector++)
+			synchronize_irq(adapter->msix_entries[vector].vector);
+
+		synchronize_irq(adapter->msix_entries[vector++].vector);
+	} else {
+		synchronize_irq(adapter->pdev->irq);
+	}
+}
+
+/**
+ * txgbe_configure_msi_and_legacy - Initialize PIN (INTA...) and MSI interrupts
+ *
+ **/
+static void txgbe_configure_msi_and_legacy(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector = adapter->q_vector[0];
+	struct txgbe_ring *ring;
+
+	txgbe_write_eitr(q_vector);
+
+	txgbe_for_each_ring(ring, q_vector->rx)
+		txgbe_set_ivar(adapter, 0, ring->reg_idx, 0);
+
+	txgbe_for_each_ring(ring, q_vector->tx)
+		txgbe_set_ivar(adapter, 1, ring->reg_idx, 0);
+
+	txgbe_set_ivar(adapter, -1, 0, 1);
+
+	txgbe_info(hw, "Legacy interrupt IVAR setup done\n");
+}
+
+/**
+ * txgbe_configure_tx_ring - Configure Tx ring after Reset
+ * @adapter: board private structure
+ * @ring: structure containing ring specific data
+ *
+ * Configure the Tx descriptor ring after a reset.
+ **/
+void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u64 tdba = ring->dma;
+	int wait_loop = 10;
+	u32 txdctl = TXGBE_PX_TR_CFG_ENABLE;
+	u8 reg_idx = ring->reg_idx;
+
+	/* disable queue to avoid issues while updating state */
+	wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
+	TXGBE_WRITE_FLUSH(hw);
+
+	wr32(hw, TXGBE_PX_TR_BAL(reg_idx), tdba & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_TR_BAH(reg_idx), tdba >> 32);
+
+	/* reset head and tail pointers */
+	wr32(hw, TXGBE_PX_TR_RP(reg_idx), 0);
+	wr32(hw, TXGBE_PX_TR_WP(reg_idx), 0);
+	ring->tail = adapter->io_addr + TXGBE_PX_TR_WP(reg_idx);
+
+	/* reset ntu and ntc to place SW in sync with hardwdare */
+	ring->next_to_clean = 0;
+	ring->next_to_use = 0;
+
+	txdctl |= TXGBE_RING_SIZE(ring) << TXGBE_PX_TR_CFG_TR_SIZE_SHIFT;
+
+	/* set WTHRESH to encourage burst writeback, it should not be set
+	 * higher than 1 when:
+	 * - ITR is 0 as it could cause false TX hangs
+	 * - ITR is set to > 100k int/sec and BQL is enabled
+	 *
+	 * In order to avoid issues WTHRESH + PTHRESH should always be equal
+	 * to or less than the number of on chip descriptors, which is
+	 * currently 40.
+	 */
+
+	txdctl |= 0x20 << TXGBE_PX_TR_CFG_WTHRESH_SHIFT;
+
+	/* initialize XPS */
+	if (!test_and_set_bit(__TXGBE_TX_XPS_INIT_DONE, &ring->state)) {
+		struct txgbe_q_vector *q_vector = ring->q_vector;
+
+		if (q_vector)
+			netif_set_xps_queue(adapter->netdev,
+					    &q_vector->affinity_mask,
+					    ring->queue_index);
+	}
+
+	clear_bit(__TXGBE_HANG_CHECK_ARMED, &ring->state);
+
+	/* enable queue */
+	wr32(hw, TXGBE_PX_TR_CFG(reg_idx), txdctl);
+
+	/* poll to verify queue is enabled */
+	do {
+		msleep(1);
+		txdctl = rd32(hw, TXGBE_PX_TR_CFG(reg_idx));
+	} while (--wait_loop && !(txdctl & TXGBE_PX_TR_CFG_ENABLE));
+	if (!wait_loop)
+		txgbe_err(drv, "Could not enable Tx Queue %d\n", reg_idx);
+}
+
+/**
+ * txgbe_configure_tx - Configure Transmit Unit after Reset
+ * @adapter: board private structure
+ *
+ * Configure the Tx unit of the MAC after a reset.
+ **/
+static void txgbe_configure_tx(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	/* TDM_CTL.TE must be before Tx queues are enabled */
+	wr32m(hw, TXGBE_TDM_CTL,
+	      TXGBE_TDM_CTL_TE, TXGBE_TDM_CTL_TE);
+
+	/* Setup the HW Tx Head and Tail descriptor pointers */
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_configure_tx_ring(adapter, adapter->tx_ring[i]);
+
+	wr32m(hw, TXGBE_TSC_BUF_AE, 0x3FF, 0x10);
+	/* enable mac transmitter */
+	wr32m(hw, TXGBE_MAC_TX_CFG,
+	      TXGBE_MAC_TX_CFG_TE, TXGBE_MAC_TX_CFG_TE);
+}
+
+static void txgbe_enable_rx_drop(struct txgbe_adapter *adapter,
+				 struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = ring->reg_idx;
+
+	u32 srrctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	srrctl |= TXGBE_PX_RR_CFG_DROP_EN;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+static void txgbe_disable_rx_drop(struct txgbe_adapter *adapter,
+				  struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 reg_idx = ring->reg_idx;
+
+	u32 srrctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+
+	srrctl &= ~TXGBE_PX_RR_CFG_DROP_EN;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+void txgbe_set_rx_drop_en(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	/* We should set the drop enable bit if:
+	 *  Number of Rx queues > 1
+	 *
+	 *  This allows us to avoid head of line blocking for security
+	 *  and performance reasons.
+	 */
+	if (adapter->num_rx_queues > 1) {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			txgbe_enable_rx_drop(adapter, adapter->rx_ring[i]);
+	} else {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			txgbe_disable_rx_drop(adapter, adapter->rx_ring[i]);
+	}
+}
+
+static void txgbe_configure_srrctl(struct txgbe_adapter *adapter,
+				   struct txgbe_ring *rx_ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 srrctl;
+	u16 reg_idx = rx_ring->reg_idx;
+
+	srrctl = rd32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+		       ~(TXGBE_PX_RR_CFG_RR_HDR_SZ |
+		       TXGBE_PX_RR_CFG_RR_BUF_SZ |
+		       TXGBE_PX_RR_CFG_SPLIT_MODE));
+	/* configure header buffer length, needed for RSC */
+	srrctl |= TXGBE_RX_HDR_SIZE << TXGBE_PX_RR_CFG_BSIZEHDRSIZE_SHIFT;
+
+	/* configure the packet buffer length */
+	srrctl |= txgbe_rx_bufsz(rx_ring) >> TXGBE_PX_RR_CFG_BSIZEPKT_SHIFT;
+
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
+}
+
+/**
+ * Write the RETA table to HW
+ *
+ * @adapter: device handle
+ *
+ * Write the RSS redirection table stored in adapter.rss_indir_tbl[] to HW.
+ */
+void txgbe_store_reta(struct txgbe_adapter *adapter)
+{
+	u32 i, reta_entries = 128;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 reta = 0;
+	u8 *indir_tbl = adapter->rss_indir_tbl;
+
+	/* Fill out the redirection table as follows:
+	 *  - 8 bit wide entries containing 4 bit RSS index
+	 */
+
+	/* Write redirection table to HW */
+	for (i = 0; i < reta_entries; i++) {
+		reta |= indir_tbl[i] << (i & 0x3) * 8;
+		if ((i & 3) == 3) {
+			wr32(hw, TXGBE_RDB_RSSTBL(i >> 2), reta);
+			reta = 0;
+		}
+	}
+}
+
+static void txgbe_setup_reta(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i, j;
+	u32 reta_entries = 128;
+	u16 rss_i = adapter->ring_feature[RING_F_RSS].indices;
+
+	/* Fill out hash function seeds */
+	for (i = 0; i < 10; i++)
+		wr32(hw, TXGBE_RDB_RSSRK(i), adapter->rss_key[i]);
+
+	/* Fill out redirection table */
+	memset(adapter->rss_indir_tbl, 0, sizeof(adapter->rss_indir_tbl));
+
+	for (i = 0, j = 0; i < reta_entries; i++, j++) {
+		if (j == rss_i)
+			j = 0;
+
+		adapter->rss_indir_tbl[i] = j;
+	}
+
+	txgbe_store_reta(adapter);
+}
+
+static void txgbe_setup_mrqc(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 rss_field = 0;
+
+	/* Disable indicating checksum in descriptor, enables RSS hash */
+	wr32m(hw, TXGBE_PSR_CTL,
+	      TXGBE_PSR_CTL_PCSD, TXGBE_PSR_CTL_PCSD);
+
+	/* Perform hash on these packet types */
+	rss_field = TXGBE_RDB_RA_CTL_RSS_IPV4 |
+		    TXGBE_RDB_RA_CTL_RSS_IPV4_TCP |
+		    TXGBE_RDB_RA_CTL_RSS_IPV6 |
+		    TXGBE_RDB_RA_CTL_RSS_IPV6_TCP;
+
+	if (adapter->flags2 & TXGBE_FLAG2_RSS_FIELD_IPV4_UDP)
+		rss_field |= TXGBE_RDB_RA_CTL_RSS_IPV4_UDP;
+	if (adapter->flags2 & TXGBE_FLAG2_RSS_FIELD_IPV6_UDP)
+		rss_field |= TXGBE_RDB_RA_CTL_RSS_IPV6_UDP;
+
+	netdev_rss_key_fill(adapter->rss_key, sizeof(adapter->rss_key));
+
+	txgbe_setup_reta(adapter);
+
+	if (adapter->flags2 & TXGBE_FLAG2_RSS_ENABLED)
+		rss_field |= TXGBE_RDB_RA_CTL_RSS_EN;
+
+	wr32(hw, TXGBE_RDB_RA_CTL, rss_field);
+}
+
+/**
+ * txgbe_configure_rscctl - enable RSC for the indicated ring
+ * @adapter:    address of board private structure
+ * @ring: structure containing ring specific data
+ **/
+void txgbe_configure_rscctl(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 rscctrl;
+	u8 reg_idx = ring->reg_idx;
+
+	if (!ring_is_rsc_enabled(ring))
+		return;
+
+	rscctrl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+	rscctrl |= TXGBE_PX_RR_CFG_RSC;
+	/* we must limit the number of descriptors so that the
+	 * total size of max desc * buf_len is not greater
+	 * than 65536
+	 */
+#if (MAX_SKB_FRAGS >= 16)
+	rscctrl |= TXGBE_PX_RR_CFG_MAX_RSCBUF_16;
+#elif (MAX_SKB_FRAGS >= 8)
+	rscctrl |= TXGBE_PX_RR_CFG_MAX_RSCBUF_8;
+#elif (MAX_SKB_FRAGS >= 4)
+	rscctrl |= TXGBE_PX_RR_CFG_MAX_RSCBUF_4;
+#else
+	rscctrl |= TXGBE_PX_RR_CFG_MAX_RSCBUF_1;
+#endif
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), rscctrl);
+}
+
+static void txgbe_rx_desc_queue_enable(struct txgbe_adapter *adapter,
+				       struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int wait_loop = TXGBE_MAX_RX_DESC_POLL;
+	u32 rxdctl;
+	u8 reg_idx = ring->reg_idx;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+
+	do {
+		usleep_range(1000, 2000);
+		rxdctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+	} while (--wait_loop && !(rxdctl & TXGBE_PX_RR_CFG_RR_EN));
+
+	if (!wait_loop)
+		txgbe_err(drv,
+			  "RXDCTL.ENABLE on Rx queue %d not set within the polling period\n",
+			  reg_idx);
+}
+
+/* disable the specified tx ring/queue */
+void txgbe_disable_tx_queue(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int wait_loop = TXGBE_MAX_RX_DESC_POLL;
+	u32 rxdctl, reg_offset, enable_mask;
+	u8 reg_idx = ring->reg_idx;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+
+	reg_offset = TXGBE_PX_TR_CFG(reg_idx);
+	enable_mask = TXGBE_PX_TR_CFG_ENABLE;
+
+	/* write value back with TDCFG.ENABLE bit cleared */
+	wr32m(hw, reg_offset, enable_mask, 0);
+
+	/* the hardware may take up to 100us to really disable the tx queue */
+	do {
+		udelay(10);
+		rxdctl = rd32(hw, reg_offset);
+	} while (--wait_loop && (rxdctl & enable_mask));
+
+	if (!wait_loop)
+		txgbe_err(drv,
+			  "TDCFG.ENABLE on Tx queue %d not cleared within the polling period\n",
+			  reg_idx);
+}
+
+/* disable the specified rx ring/queue */
+void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int wait_loop = TXGBE_MAX_RX_DESC_POLL;
+	u32 rxdctl;
+	u8 reg_idx = ring->reg_idx;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+
+	/* write value back with RXDCTL.ENABLE bit cleared */
+	wr32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+	      TXGBE_PX_RR_CFG_RR_EN, 0);
+
+	/* the hardware may take up to 100us to really disable the rx queue */
+	do {
+		udelay(10);
+		rxdctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+	} while (--wait_loop && (rxdctl & TXGBE_PX_RR_CFG_RR_EN));
+
+	if (!wait_loop) {
+		txgbe_err(drv,
+			  "RXDCTL.ENABLE on Rx queue %d not cleared within the polling period\n",
+			  reg_idx);
+	}
+}
+
+void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
+			     struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u64 rdba = ring->dma;
+	u32 rxdctl;
+	u16 reg_idx = ring->reg_idx;
+
+	/* disable queue to avoid issues while updating state */
+	rxdctl = rd32(hw, TXGBE_PX_RR_CFG(reg_idx));
+	txgbe_disable_rx_queue(adapter, ring);
+
+	wr32(hw, TXGBE_PX_RR_BAL(reg_idx), rdba & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_RR_BAH(reg_idx), rdba >> 32);
+
+	if (ring->count == TXGBE_MAX_RXD)
+		rxdctl |= 0 << TXGBE_PX_RR_CFG_RR_SIZE_SHIFT;
+	else
+		rxdctl |= (ring->count / 128) << TXGBE_PX_RR_CFG_RR_SIZE_SHIFT;
+
+	rxdctl |= 0x1 << TXGBE_PX_RR_CFG_RR_THER_SHIFT;
+	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), rxdctl);
+
+	/* reset head and tail pointers */
+	wr32(hw, TXGBE_PX_RR_RP(reg_idx), 0);
+	wr32(hw, TXGBE_PX_RR_WP(reg_idx), 0);
+	ring->tail = adapter->io_addr + TXGBE_PX_RR_WP(reg_idx);
+
+	/* reset ntu and ntc to place SW in sync with hardwdare */
+	ring->next_to_clean = 0;
+	ring->next_to_use = 0;
+	ring->next_to_alloc = 0;
+
+	txgbe_configure_srrctl(adapter, ring);
+	/* In ESX, RSCCTL configuration is done by on demand */
+	txgbe_configure_rscctl(adapter, ring);
+
+	/* enable receive descriptor ring */
+	wr32m(hw, TXGBE_PX_RR_CFG(reg_idx),
+	      TXGBE_PX_RR_CFG_RR_EN, TXGBE_PX_RR_CFG_RR_EN);
+
+	txgbe_rx_desc_queue_enable(adapter, ring);
+	txgbe_alloc_rx_buffers(ring, txgbe_desc_unused(ring));
+}
+
+static void txgbe_setup_psrtype(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int rss_i = adapter->ring_feature[RING_F_RSS].indices;
+	int pool;
+
+	/* PSRTYPE must be initialized in adapters */
+	u32 psrtype = TXGBE_RDB_PL_CFG_L4HDR |
+		      TXGBE_RDB_PL_CFG_L3HDR |
+		      TXGBE_RDB_PL_CFG_L2HDR |
+		      TXGBE_RDB_PL_CFG_TUN_OUTER_L2HDR |
+		      TXGBE_RDB_PL_CFG_TUN_TUNHDR;
+
+	if (rss_i > 3)
+		psrtype |= 2 << 29;
+	else if (rss_i > 1)
+		psrtype |= 1 << 29;
+
+	for_each_set_bit(pool, &adapter->fwd_bitmask, TXGBE_MAX_MACVLANS)
+		wr32(hw, TXGBE_RDB_PL_CFG(pool), psrtype);
+}
+
+static void txgbe_set_rx_buffer_len(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
+	u32 max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	struct txgbe_ring *rx_ring;
+	int i;
+	u32 mhadd;
+
+	/* adjust max frame to be at least the size of a standard frame */
+	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
+		max_frame = (ETH_FRAME_LEN + ETH_FCS_LEN);
+
+	mhadd = rd32(hw, TXGBE_PSR_MAX_SZ);
+	if (max_frame != mhadd)
+		wr32(hw, TXGBE_PSR_MAX_SZ, max_frame);
+
+	/* Setup the HW Rx Head and Tail Descriptor Pointers and
+	 * the Base and Length of the Rx Descriptor Ring
+	 */
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		rx_ring = adapter->rx_ring[i];
+
+		if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
+			set_ring_rsc_enabled(rx_ring);
+		else
+			clear_ring_rsc_enabled(rx_ring);
+	}
+}
+
+/**
+ * txgbe_configure_rx - Configure Receive Unit after Reset
+ * @adapter: board private structure
+ *
+ * Configure the Rx unit of the MAC after a reset.
+ **/
+static void txgbe_configure_rx(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i;
+	u32 rxctrl, psrctl;
+
+	/* disable receives while setting up the descriptors */
+	TCALL(hw, mac.ops.disable_rx);
+
+	txgbe_setup_psrtype(adapter);
+
+	/* enable hw crc stripping */
+	wr32m(hw, TXGBE_RSC_CTL,
+	      TXGBE_RSC_CTL_CRC_STRIP, TXGBE_RSC_CTL_CRC_STRIP);
+
+	/* RSC Setup */
+	psrctl = rd32m(hw, TXGBE_PSR_CTL, ~TXGBE_PSR_CTL_RSC_DIS);
+	psrctl |= TXGBE_PSR_CTL_RSC_ACK; /* Disable RSC for ACK packets */
+	if (!(adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED))
+		psrctl |= TXGBE_PSR_CTL_RSC_DIS;
+	wr32(hw, TXGBE_PSR_CTL, psrctl);
+
+	/* Program registers for the distribution of queues */
+	txgbe_setup_mrqc(adapter);
+
+	/* set_rx_buffer_len must be called before ring initialization */
+	txgbe_set_rx_buffer_len(adapter);
+
+	/* Setup the HW Rx Head and Tail Descriptor Pointers and
+	 * the Base and Length of the Rx Descriptor Ring
+	 */
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_configure_rx_ring(adapter, adapter->rx_ring[i]);
+
+	rxctrl = rd32(hw, TXGBE_RDB_PB_CTL);
+
+	/* enable all receives */
+	rxctrl |= TXGBE_RDB_PB_CTL_RXEN;
+	TCALL(hw, mac.ops.enable_rx_dma, rxctrl);
+}
+
+static int txgbe_vlan_rx_add_vid(struct net_device *netdev,
+				 __be16 proto, u16 vid)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	/* add VID to filter table */
+	if (hw->mac.ops.set_vfta)
+		TCALL(hw, mac.ops.set_vfta, vid, 0, true);
+
+	set_bit(vid, adapter->active_vlans);
+
+	return 0;
+}
+
+static int txgbe_vlan_rx_kill_vid(struct net_device *netdev,
+				  __be16 proto, u16 vid)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	/* remove VID from filter table */
+	if (hw->mac.ops.set_vfta)
+		TCALL(hw, mac.ops.set_vfta, vid, 0, false);
+
+	clear_bit(vid, adapter->active_vlans);
+
+	return 0;
+}
+
+/**
+ * txgbe_vlan_strip_disable - helper to disable vlan tag stripping
+ * @adapter: driver data
+ */
+void txgbe_vlan_strip_disable(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i, j;
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *ring = adapter->rx_ring[i];
+
+		if (ring->accel)
+			continue;
+		j = ring->reg_idx;
+		wr32m(hw, TXGBE_PX_RR_CFG(j),
+		      TXGBE_PX_RR_CFG_VLAN, 0);
+	}
+}
+
+/**
+ * txgbe_vlan_strip_enable - helper to enable vlan tag stripping
+ * @adapter: driver data
+ */
+void txgbe_vlan_strip_enable(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i, j;
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *ring = adapter->rx_ring[i];
+
+		if (ring->accel)
+			continue;
+		j = ring->reg_idx;
+		wr32m(hw, TXGBE_PX_RR_CFG(j),
+		      TXGBE_PX_RR_CFG_VLAN, TXGBE_PX_RR_CFG_VLAN);
+	}
+}
+
+void txgbe_vlan_mode(struct net_device *netdev, u32 features)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	bool enable;
+
+	enable = !!(features & (NETIF_F_HW_VLAN_CTAG_RX));
+
+	if (enable)
+		/* enable VLAN tag insert/strip */
+		txgbe_vlan_strip_enable(adapter);
+	else
+		/* disable VLAN tag insert/strip */
+		txgbe_vlan_strip_disable(adapter);
+}
+
+static void txgbe_restore_vlan(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	u16 vid;
+
+	txgbe_vlan_rx_add_vid(adapter->netdev, htons(ETH_P_8021Q), 0);
+	txgbe_vlan_mode(netdev, netdev->features);
+
+	for_each_set_bit(vid, adapter->active_vlans, VLAN_N_VID)
+		txgbe_vlan_rx_add_vid(netdev, htons(ETH_P_8021Q), vid);
+}
+
+static u8 *txgbe_addr_list_itr(struct txgbe_hw __maybe_unused *hw,
+			       u8 **mc_addr_ptr, u32 *vmdq)
+{
+	struct netdev_hw_addr *mc_ptr;
+	u8 *addr = *mc_addr_ptr;
+
+	*vmdq = 0;
+
+	mc_ptr = container_of(addr, struct netdev_hw_addr, addr[0]);
+	if (mc_ptr->list.next) {
+		struct netdev_hw_addr *ha;
+
+		ha = list_entry(mc_ptr->list.next, struct netdev_hw_addr, list);
+		*mc_addr_ptr = ha->addr;
+	} else {
+		*mc_addr_ptr = NULL;
+	}
+
+	return addr;
+}
+
+/**
+ * txgbe_write_mc_addr_list - write multicast addresses to MTA
+ * @netdev: network interface device structure
+ *
+ * Writes multicast address list to the MTA hash table.
+ * Returns: -ENOMEM on failure
+ *                0 on no addresses written
+ *                X on writing X addresses to MTA
+ **/
+int txgbe_write_mc_addr_list(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	struct netdev_hw_addr *ha;
+	u8  *addr_list = NULL;
+	int addr_count = 0;
+
+	if (!hw->mac.ops.update_mc_addr_list)
+		return -ENOMEM;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	if (netdev_mc_empty(netdev)) {
+		TCALL(hw, mac.ops.update_mc_addr_list, NULL, 0,
+		      txgbe_addr_list_itr, true);
+	} else {
+		ha = list_first_entry(&netdev->mc.list,
+				      struct netdev_hw_addr, list);
+		addr_list = ha->addr;
+		addr_count = netdev_mc_count(netdev);
+
+		TCALL(hw, mac.ops.update_mc_addr_list, addr_list, addr_count,
+		      txgbe_addr_list_itr, true);
+	}
+
+	return addr_count;
+}
+
+static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	int i;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_MODIFIED) {
+			if (adapter->mac_table[i].state &
+					TXGBE_MAC_STATE_IN_USE) {
+				TCALL(hw, mac.ops.set_rar, i,
+				      adapter->mac_table[i].addr,
+				      adapter->mac_table[i].pools,
+				      TXGBE_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				TCALL(hw, mac.ops.clear_rar, i);
+			}
+			adapter->mac_table[i].state &=
+				~(TXGBE_MAC_STATE_MODIFIED);
+		}
+	}
+}
+
+int txgbe_available_rars(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i, count = 0;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state == 0)
+			count++;
+	}
+	return count;
+}
+
+/* this function destroys the first RAR entry */
+static void txgbe_mac_set_default_filter(struct txgbe_adapter *adapter,
+					 u8 *addr)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	memcpy(&adapter->mac_table[0].addr, addr, ETH_ALEN);
+	adapter->mac_table[0].pools = 1ULL;
+	adapter->mac_table[0].state = (TXGBE_MAC_STATE_DEFAULT |
+				       TXGBE_MAC_STATE_IN_USE);
+	TCALL(hw, mac.ops.set_rar, 0, adapter->mac_table[0].addr,
+	      adapter->mac_table[0].pools,
+	      TXGBE_PSR_MAC_SWC_AD_H_AV);
+}
+
+int txgbe_add_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE) {
+			if (ether_addr_equal(addr, adapter->mac_table[i].addr)) {
+				if (adapter->mac_table[i].pools != (1ULL << pool)) {
+					memcpy(adapter->mac_table[i].addr, addr, ETH_ALEN);
+					adapter->mac_table[i].pools |= (1ULL << pool);
+					txgbe_sync_mac_table(adapter);
+					return i;
+				}
+			}
+		}
+
+		if (adapter->mac_table[i].state & TXGBE_MAC_STATE_IN_USE)
+			continue;
+		adapter->mac_table[i].state |= (TXGBE_MAC_STATE_MODIFIED |
+						TXGBE_MAC_STATE_IN_USE);
+		memcpy(adapter->mac_table[i].addr, addr, ETH_ALEN);
+		adapter->mac_table[i].pools |= (1ULL << pool);
+		txgbe_sync_mac_table(adapter);
+		return i;
+	}
+	return -ENOMEM;
+}
+
+static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
+{
+	u32 i;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+	}
+	txgbe_sync_mac_table(adapter);
+}
+
+int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
+{
+	/* search table for addr, if found, set to 0 and sync */
+	u32 i;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	for (i = 0; i < hw->mac.num_rar_entries; i++) {
+		if (ether_addr_equal(addr, adapter->mac_table[i].addr)) {
+			if (adapter->mac_table[i].pools & (1ULL << pool)) {
+				adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+				adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+				adapter->mac_table[i].pools &= ~(1ULL << pool);
+				txgbe_sync_mac_table(adapter);
+			}
+			return 0;
+		}
+
+		if (adapter->mac_table[i].pools != (1 << pool))
+			continue;
+		if (!ether_addr_equal(addr, adapter->mac_table[i].addr))
+			continue;
+
+		adapter->mac_table[i].state |= TXGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~TXGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+		txgbe_sync_mac_table(adapter);
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_write_uc_addr_list - write unicast addresses to RAR table
+ * @netdev: network interface device structure
+ *
+ * Writes unicast address list to the RAR table.
+ * Returns: -ENOMEM on failure/insufficient address space
+ *                0 on no addresses written
+ *                X on writing X addresses to the RAR table
+ **/
+int txgbe_write_uc_addr_list(struct net_device *netdev, int pool)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int count = 0;
+
+	/* return ENOMEM indicating insufficient memory for addresses */
+	if (netdev_uc_count(netdev) > txgbe_available_rars(adapter))
+		return -ENOMEM;
+
+	if (!netdev_uc_empty(netdev)) {
+		struct netdev_hw_addr *ha;
+
+		netdev_for_each_uc_addr(ha, netdev) {
+			txgbe_del_mac_filter(adapter, ha->addr, pool);
+			txgbe_add_mac_filter(adapter, ha->addr, pool);
+			count++;
+		}
+	}
+	return count;
+}
+
+/**
+ * txgbe_set_rx_mode - Unicast, Multicast and Promiscuous mode set
+ * @netdev: network interface device structure
+ *
+ * The set_rx_method entry point is called whenever the unicast/multicast
+ * address list or the network interface flags are updated.  This routine is
+ * responsible for configuring the hardware for proper unicast, multicast and
+ * promiscuous mode.
+ **/
+void txgbe_set_rx_mode(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 fctrl, vmolr, vlnctrl;
+	int count;
+
+	/* Check for Promiscuous and All Multicast modes */
+	fctrl = rd32m(hw, TXGBE_PSR_CTL,
+		      ~(TXGBE_PSR_CTL_UPE | TXGBE_PSR_CTL_MPE));
+	vmolr = rd32m(hw, TXGBE_PSR_VM_L2CTL(0),
+		      ~(TXGBE_PSR_VM_L2CTL_UPE |
+			TXGBE_PSR_VM_L2CTL_MPE |
+			TXGBE_PSR_VM_L2CTL_ROPE |
+			TXGBE_PSR_VM_L2CTL_ROMPE));
+	vlnctrl = rd32m(hw, TXGBE_PSR_VLAN_CTL,
+			~(TXGBE_PSR_VLAN_CTL_VFE |
+			  TXGBE_PSR_VLAN_CTL_CFIEN));
+
+	/* set all bits that we expect to always be set */
+	fctrl |= TXGBE_PSR_CTL_BAM | TXGBE_PSR_CTL_MFE;
+	vmolr |= TXGBE_PSR_VM_L2CTL_BAM |
+		 TXGBE_PSR_VM_L2CTL_AUPE |
+		 TXGBE_PSR_VM_L2CTL_VACC;
+	vlnctrl |= TXGBE_PSR_VLAN_CTL_VFE;
+
+	hw->addr_ctrl.user_set_promisc = false;
+	if (netdev->flags & IFF_PROMISC) {
+		hw->addr_ctrl.user_set_promisc = true;
+		fctrl |= (TXGBE_PSR_CTL_UPE | TXGBE_PSR_CTL_MPE);
+		/* pf don't want packets routing to vf, so clear UPE */
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+		vlnctrl &= ~TXGBE_PSR_VLAN_CTL_VFE;
+	}
+
+	if (netdev->flags & IFF_ALLMULTI) {
+		fctrl |= TXGBE_PSR_CTL_MPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+	}
+
+	/* This is useful for sniffing bad packets. */
+	if (netdev->features & NETIF_F_RXALL) {
+		vmolr |= (TXGBE_PSR_VM_L2CTL_UPE | TXGBE_PSR_VM_L2CTL_MPE);
+		vlnctrl &= ~TXGBE_PSR_VLAN_CTL_VFE;
+		/* receive bad packets */
+		wr32m(hw, TXGBE_RSC_CTL,
+		      TXGBE_RSC_CTL_SAVE_MAC_ERR,
+		      TXGBE_RSC_CTL_SAVE_MAC_ERR);
+	} else {
+		vmolr |= TXGBE_PSR_VM_L2CTL_ROPE | TXGBE_PSR_VM_L2CTL_ROMPE;
+	}
+
+	/* Write addresses to available RAR registers, if there is not
+	 * sufficient space to store all the addresses then enable
+	 * unicast promiscuous mode
+	 */
+	count = txgbe_write_uc_addr_list(netdev, 0);
+	if (count < 0) {
+		vmolr &= ~TXGBE_PSR_VM_L2CTL_ROPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_UPE;
+	}
+
+	/* Write addresses to the MTA, if the attempt fails
+	 * then we should just turn on promiscuous mode so
+	 * that we can at least receive multicast traffic
+	 */
+	count = txgbe_write_mc_addr_list(netdev);
+	if (count < 0) {
+		vmolr &= ~TXGBE_PSR_VM_L2CTL_ROMPE;
+		vmolr |= TXGBE_PSR_VM_L2CTL_MPE;
+	}
+
+	wr32(hw, TXGBE_PSR_VLAN_CTL, vlnctrl);
+	wr32(hw, TXGBE_PSR_CTL, fctrl);
+	wr32(hw, TXGBE_PSR_VM_L2CTL(0), vmolr);
+
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		txgbe_vlan_strip_enable(adapter);
+	else
+		txgbe_vlan_strip_disable(adapter);
+}
+
+static void txgbe_napi_enable_all(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++) {
+		q_vector = adapter->q_vector[q_idx];
+		napi_enable(&q_vector->napi);
+	}
+}
+
+static void txgbe_napi_disable_all(struct txgbe_adapter *adapter)
+{
+	struct txgbe_q_vector *q_vector;
+	int q_idx;
+
+	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++) {
+		q_vector = adapter->q_vector[q_idx];
+		napi_disable(&q_vector->napi);
+	}
+}
+
+void txgbe_clear_vxlan_port(struct txgbe_adapter *adapter)
+{
+	adapter->vxlan_port = 0;
+	if (!(adapter->flags & TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE))
+		return;
+	wr32(&adapter->hw, TXGBE_CFG_VXLAN, 0);
+}
+
+#define TXGBE_GSO_PARTIAL_FEATURES (NETIF_F_GSO_GRE | \
+				    NETIF_F_GSO_GRE_CSUM | \
+				    NETIF_F_GSO_IPXIP4 | \
+				    NETIF_F_GSO_IPXIP6 | \
+				    NETIF_F_GSO_UDP_TUNNEL | \
+				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
+
+static void txgbe_configure_pb(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	TCALL(hw, mac.ops.setup_rxpba, 0, 0, PBA_STRATEGY_EQUAL);
+}
+
+void txgbe_configure_isb(struct txgbe_adapter *adapter)
+{
+	/* set ISB Address */
+	struct txgbe_hw *hw = &adapter->hw;
+
+	wr32(hw, TXGBE_PX_ISB_ADDR_L,
+	     adapter->isb_dma & DMA_BIT_MASK(32));
+	wr32(hw, TXGBE_PX_ISB_ADDR_H, adapter->isb_dma >> 32);
+}
+
+void txgbe_configure_port(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 value, i;
+
+	value = TXGBE_CFG_PORT_CTL_D_VLAN | TXGBE_CFG_PORT_CTL_QINQ;
+	wr32m(hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_D_VLAN |
+	      TXGBE_CFG_PORT_CTL_QINQ,
+	      value);
+
+	wr32(hw, TXGBE_CFG_TAG_TPID(0),
+	     ETH_P_8021Q | ETH_P_8021AD << 16);
+	adapter->hw.tpid[0] = ETH_P_8021Q;
+	adapter->hw.tpid[1] = ETH_P_8021AD;
+	for (i = 1; i < 4; i++)
+		wr32(hw, TXGBE_CFG_TAG_TPID(i),
+		     ETH_P_8021Q | ETH_P_8021Q << 16);
+	for (i = 2; i < 8; i++)
+		adapter->hw.tpid[i] = ETH_P_8021Q;
+}
+
+static void txgbe_configure(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	txgbe_configure_pb(adapter);
+
+	txgbe_configure_port(adapter);
+
+	txgbe_set_rx_mode(adapter->netdev);
+	txgbe_restore_vlan(adapter);
+
+	TCALL(hw, mac.ops.disable_sec_rx_path);
+
+	TCALL(hw, mac.ops.enable_sec_rx_path);
+
+	txgbe_configure_tx(adapter);
+	txgbe_configure_rx(adapter);
+	txgbe_configure_isb(adapter);
+}
+
+static bool txgbe_is_sfp(struct txgbe_hw *hw)
+{
+	switch (TCALL(hw, mac.ops.get_media_type)) {
+	case txgbe_media_type_fiber:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool txgbe_is_backplane(struct txgbe_hw *hw)
+{
+	switch (TCALL(hw, mac.ops.get_media_type)) {
+	case txgbe_media_type_backplane:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
+ * txgbe_sfp_link_config - set up SFP+ link
+ * @adapter: pointer to private adapter struct
+ **/
+static void txgbe_sfp_link_config(struct txgbe_adapter *adapter)
+{
+	/* We are assuming the worst case scenerio here, and that
+	 * is that an SFP was inserted/removed after the reset
+	 * but before SFP detection was enabled.  As such the best
+	 * solution is to just start searching as soon as we start
+	 */
+
+	adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+	adapter->sfp_poll_time = 0;
+}
+
+static void txgbe_setup_gpie(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 gpie = 0;
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		gpie = TXGBE_PX_GPIE_MODEL;
+
+	wr32(hw, TXGBE_PX_GPIE, gpie);
+}
+
+static void txgbe_up_complete(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 links_reg;
+
+	txgbe_get_hw_control(adapter);
+	txgbe_setup_gpie(adapter);
+
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED)
+		txgbe_configure_msix(adapter);
+	else
+		txgbe_configure_msi_and_legacy(adapter);
+
+	/* enable the optics for SFP+ fiber */
+	TCALL(hw, mac.ops.enable_tx_laser);
+
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_DOWN, &adapter->state);
+	txgbe_napi_enable_all(adapter);
+
+	if (txgbe_is_sfp(hw)) {
+		txgbe_sfp_link_config(adapter);
+	} else if (txgbe_is_backplane(hw)) {
+		adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	links_reg = rd32(hw, TXGBE_CFG_PORT_ST);
+	if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP) {
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_10G) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
+			     TXGBE_MAC_TX_CFG_SPEED_10G);
+		} else if (links_reg & (TXGBE_CFG_PORT_ST_LINK_1G | TXGBE_CFG_PORT_ST_LINK_100M)) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
+			     TXGBE_MAC_TX_CFG_SPEED_1G);
+		}
+	}
+
+	/* clear any pending interrupts, may auto mask */
+	rd32(hw, TXGBE_PX_IC(0));
+	rd32(hw, TXGBE_PX_IC(1));
+	rd32(hw, TXGBE_PX_MISC_IC);
+	if ((hw->subsystem_id & 0xF0) == TXGBE_ID_XAUI)
+		wr32(hw, TXGBE_GPIO_EOI, TXGBE_GPIO_EOI_6);
+	txgbe_irq_enable(adapter, true, true);
+
+	/* enable transmits */
+	netif_tx_start_all_queues(adapter->netdev);
+
+	/* bring the link up in the watchdog, this could race with our first
+	 * link up interrupt but shouldn't be a problem
+	 */
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+
+	mod_timer(&adapter->service_timer, jiffies);
+
+	if (hw->bus.lan_id == 0) {
+		wr32m(hw, TXGBE_MIS_PRB_CTL,
+		      TXGBE_MIS_PRB_CTL_LAN0_UP, TXGBE_MIS_PRB_CTL_LAN0_UP);
+	} else if (hw->bus.lan_id == 1) {
+		wr32m(hw, TXGBE_MIS_PRB_CTL,
+		      TXGBE_MIS_PRB_CTL_LAN1_UP, TXGBE_MIS_PRB_CTL_LAN1_UP);
+	} else {
+		txgbe_err(probe, "%s:invalid bus lan id %d\n",
+			  __func__, hw->bus.lan_id);
+	}
+
+	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
+	wr32m(hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
+}
+
+void txgbe_reinit_locked(struct txgbe_adapter *adapter)
+{
+	/* put off any impending NetWatchDogTimeout */
+	netif_trans_update(adapter->netdev);
+
+	while (test_and_set_bit(__TXGBE_RESETTING, &adapter->state))
+		usleep_range(1000, 2000);
+	txgbe_down(adapter);
+	txgbe_up(adapter);
+	clear_bit(__TXGBE_RESETTING, &adapter->state);
+}
+
+void txgbe_up(struct txgbe_adapter *adapter)
+{
+	/* hardware has been reset, we need to reload some things */
+	txgbe_configure(adapter);
+
+	txgbe_up_complete(adapter);
+}
+
+void txgbe_reset(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
+	int err;
+	u8 old_addr[ETH_ALEN];
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return;
+	/* lock SFP init bit to prevent race conditions with the watchdog */
+	while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		usleep_range(1000, 2000);
+
+	/* clear all SFP and link config related flags while holding SFP_INIT */
+	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+
+	err = TCALL(hw, mac.ops.init_hw);
+	switch (err) {
+	case 0:
+	case TXGBE_ERR_SFP_NOT_PRESENT:
+	case TXGBE_ERR_SFP_NOT_SUPPORTED:
+		break;
+	case TXGBE_ERR_MASTER_REQUESTS_PENDING:
+		txgbe_dev_err("master disable timed out\n");
+		break;
+	default:
+		txgbe_dev_err("Hardware Error: %d\n", err);
+	}
+
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+	/* do not flush user set addresses */
+	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
+	txgbe_flush_sw_mac_table(adapter);
+	txgbe_mac_set_default_filter(adapter, old_addr);
+
+	/* update SAN MAC vmdq pool selection */
+	TCALL(hw, mac.ops.set_vmdq_san_mac, 0);
+}
+
+/**
+ * txgbe_clean_rx_ring - Free Rx Buffers per Queue
+ * @rx_ring: ring to free buffers from
+ **/
+static void txgbe_clean_rx_ring(struct txgbe_ring *rx_ring)
+{
+	struct device *dev = rx_ring->dev;
+	unsigned long size;
+	u16 i;
+
+	/* ring already cleared, nothing to do */
+	if (!rx_ring->rx_buffer_info)
+		return;
+
+	/* Free all the Rx ring sk_buffs */
+	for (i = 0; i < rx_ring->count; i++) {
+		struct txgbe_rx_buffer *rx_buffer = &rx_ring->rx_buffer_info[i];
+
+		if (rx_buffer->dma) {
+			dma_unmap_single(dev,
+					 rx_buffer->dma,
+					 rx_ring->rx_buf_len,
+					 DMA_FROM_DEVICE);
+			rx_buffer->dma = 0;
+		}
+
+		if (rx_buffer->skb) {
+			struct sk_buff *skb = rx_buffer->skb;
+
+			if (TXGBE_CB(skb)->dma_released) {
+				dma_unmap_single(dev,
+						 TXGBE_CB(skb)->dma,
+						 rx_ring->rx_buf_len,
+						 DMA_FROM_DEVICE);
+				TXGBE_CB(skb)->dma = 0;
+				TXGBE_CB(skb)->dma_released = false;
+			}
+
+			if (TXGBE_CB(skb)->page_released)
+				dma_unmap_page(dev,
+					       TXGBE_CB(skb)->dma,
+					       txgbe_rx_bufsz(rx_ring),
+					       DMA_FROM_DEVICE);
+			dev_kfree_skb(skb);
+			rx_buffer->skb = NULL;
+		}
+
+		if (!rx_buffer->page)
+			continue;
+
+		dma_unmap_page(dev, rx_buffer->page_dma,
+			       txgbe_rx_pg_size(rx_ring),
+			       DMA_FROM_DEVICE);
+
+		__free_pages(rx_buffer->page,
+			     txgbe_rx_pg_order(rx_ring));
+		rx_buffer->page = NULL;
+	}
+
+	size = sizeof(struct txgbe_rx_buffer) * rx_ring->count;
+	memset(rx_ring->rx_buffer_info, 0, size);
+
+	/* Zero out the descriptor ring */
+	memset(rx_ring->desc, 0, rx_ring->size);
+
+	rx_ring->next_to_alloc = 0;
+	rx_ring->next_to_clean = 0;
+	rx_ring->next_to_use = 0;
+}
+
+/**
+ * txgbe_clean_tx_ring - Free Tx Buffers
+ * @tx_ring: ring to be cleaned
+ **/
+static void txgbe_clean_tx_ring(struct txgbe_ring *tx_ring)
+{
+	struct txgbe_tx_buffer *tx_buffer_info;
+	unsigned long size;
+	u16 i;
+
+	/* ring already cleared, nothing to do */
+	if (!tx_ring->tx_buffer_info)
+		return;
+
+	/* Free all the Tx ring sk_buffs */
+	for (i = 0; i < tx_ring->count; i++) {
+		tx_buffer_info = &tx_ring->tx_buffer_info[i];
+		txgbe_unmap_and_free_tx_resource(tx_ring, tx_buffer_info);
+	}
+
+	netdev_tx_reset_queue(txring_txq(tx_ring));
+
+	size = sizeof(struct txgbe_tx_buffer) * tx_ring->count;
+	memset(tx_ring->tx_buffer_info, 0, size);
+
+	/* Zero out the descriptor ring */
+	memset(tx_ring->desc, 0, tx_ring->size);
+}
+
+/**
+ * txgbe_clean_all_rx_rings - Free Rx Buffers for all queues
+ * @adapter: board private structure
+ **/
+static void txgbe_clean_all_rx_rings(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_clean_rx_ring(adapter->rx_ring[i]);
+}
+
+/**
+ * txgbe_clean_all_tx_rings - Free Tx Buffers for all queues
+ * @adapter: board private structure
+ **/
+static void txgbe_clean_all_tx_rings(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_clean_tx_ring(adapter->tx_ring[i]);
+}
+
+void txgbe_disable_device(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
+		return; /* do nothing if already down */
+
+	txgbe_disable_pcie_master(hw);
+	/* disable receives */
+	TCALL(hw, mac.ops.disable_rx);
+
+	/* disable all enabled rx queues */
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		/* this call also flushes the previous write */
+		txgbe_disable_rx_queue(adapter, adapter->rx_ring[i]);
+
+	netif_tx_stop_all_queues(netdev);
+
+	/* call carrier off first to avoid false dev_watchdog timeouts */
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	txgbe_irq_disable(adapter);
+
+	txgbe_napi_disable_all(adapter);
+
+	adapter->flags2 &= ~(TXGBE_FLAG2_PF_RESET_REQUESTED |
+			     TXGBE_FLAG2_GLOBAL_RESET_REQUESTED);
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+
+	del_timer_sync(&adapter->service_timer);
+
+	if (hw->bus.lan_id == 0)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
+	else if (hw->bus.lan_id == 1)
+		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN1_UP, 0);
+	else
+		txgbe_dev_err("%s: invalid bus lan id %d\n", __func__,
+			      hw->bus.lan_id);
+
+	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+	      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+		/* disable mac transmiter */
+		wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, 0);
+	}
+	/* disable transmits in the hardware now that interrupts are off */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		u8 reg_idx = adapter->tx_ring[i]->reg_idx;
+
+		wr32(hw, TXGBE_PX_TR_CFG(reg_idx), TXGBE_PX_TR_CFG_SWFLSH);
+	}
+
+	/* Disable the Tx DMA engine */
+	wr32m(hw, TXGBE_TDM_CTL, TXGBE_TDM_CTL_TE, 0);
+}
+
+void txgbe_down(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	txgbe_disable_device(adapter);
+	txgbe_reset(adapter);
+
+	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)))
+		/* power down the optics for SFP+ fiber */
+		TCALL(&adapter->hw, mac.ops.disable_tx_laser);
+
+	txgbe_clean_all_tx_rings(adapter);
+	txgbe_clean_all_rx_rings(adapter);
+}
+
+/**
+ *  txgbe_init_shared_code - Initialize the shared code
+ *  @hw: pointer to hardware structure
+ *
+ *  This will assign function pointers and assign the MAC type and PHY code.
+ **/
+s32 txgbe_init_shared_code(struct txgbe_hw *hw)
+{
+	s32 status;
+
+	status = txgbe_init_ops(hw);
+	return status;
+}
+
+/**
+ * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
+ * @adapter: board private structure to initialize
+ *
+ * txgbe_sw_init initializes the Adapter private data structure.
+ * Fields are initialized based on PCI device information and
+ * OS network device settings (MTU size).
+ **/
+static const u32 def_rss_key[10] = {
+	0xE291D73D, 0x1805EC6C, 0x2A94B30D,
+	0xA54F2BEC, 0xEA49AF7C, 0xE214AD3D, 0xB855AABE,
+	0x6A3E67EA, 0x14364D17, 0x3BED200D
+};
+
+static int txgbe_sw_init(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct pci_dev *pdev = adapter->pdev;
+	int err;
+	unsigned int rss;
+
+	/* PCI config space info */
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
+	if (hw->revision_id == TXGBE_FAILED_READ_CFG_BYTE &&
+	    txgbe_check_cfg_remove(hw, pdev)) {
+		txgbe_err(probe, "read of revision id failed\n");
+		err = -ENODEV;
+		goto out;
+	}
+	hw->subsystem_vendor_id = pdev->subsystem_vendor;
+	hw->subsystem_device_id = pdev->subsystem_device;
+
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &hw->subsystem_id);
+	if (hw->subsystem_id == TXGBE_FAILED_READ_CFG_WORD) {
+		txgbe_err(probe, "read of subsystem id failed\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = txgbe_init_shared_code(hw);
+	if (err) {
+		txgbe_err(probe, "init_shared_code failed: %d\n", err);
+		goto out;
+	}
+	adapter->mac_table = kzalloc(sizeof(*adapter->mac_table) *
+				     hw->mac.num_rar_entries,
+				     GFP_ATOMIC);
+	if (!adapter->mac_table) {
+		err = TXGBE_ERR_OUT_OF_MEM;
+		txgbe_err(probe, "mac_table allocation failed: %d\n", err);
+		goto out;
+	}
+
+	memcpy(adapter->rss_key, def_rss_key, sizeof(def_rss_key));
+
+	/* Set common capability flags and settings */
+	rss = min_t(int, TXGBE_MAX_RSS_INDICES,
+		    num_online_cpus());
+	adapter->ring_feature[RING_F_RSS].limit = rss;
+	adapter->flags2 |= TXGBE_FLAG2_RSS_ENABLED;
+
+	/* enable itr by default in dynamic mode */
+	adapter->rx_itr_setting = 1;
+	adapter->tx_itr_setting = 1;
+
+	adapter->atr_sample_rate = 20;
+
+	adapter->flags |= TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
+	adapter->flags2 |= TXGBE_FLAG2_RSC_CAPABLE;
+
+	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
+
+	/* set default ring sizes */
+	adapter->tx_ring_count = TXGBE_DEFAULT_TXD;
+	adapter->rx_ring_count = TXGBE_DEFAULT_RXD;
+
+	/* set default work limits */
+	adapter->tx_work_limit = TXGBE_DEFAULT_TX_WORK;
+	adapter->rx_work_limit = TXGBE_DEFAULT_RX_WORK;
+
+	set_bit(0, &adapter->fwd_bitmask);
+	set_bit(__TXGBE_DOWN, &adapter->state);
+out:
+	return err;
+}
+
+/**
+ * txgbe_setup_tx_resources - allocate Tx resources (Descriptors)
+ * @tx_ring:    tx descriptor ring (for a specific queue) to setup
+ *
+ * Return 0 on success, negative on failure
+ **/
+int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring)
+{
+	struct device *dev = tx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = -1;
+	int size;
+
+	size = sizeof(struct txgbe_tx_buffer) * tx_ring->count;
+
+	if (tx_ring->q_vector)
+		numa_node = tx_ring->q_vector->numa_node;
+
+	tx_ring->tx_buffer_info = vzalloc_node(size, numa_node);
+	if (!tx_ring->tx_buffer_info)
+		tx_ring->tx_buffer_info = vzalloc(size);
+	if (!tx_ring->tx_buffer_info)
+		goto err;
+
+	/* round up to nearest 4K */
+	tx_ring->size = tx_ring->count * sizeof(union txgbe_tx_desc);
+	tx_ring->size = ALIGN(tx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	tx_ring->desc = dma_alloc_coherent(dev,
+					   tx_ring->size,
+					   &tx_ring->dma,
+					   GFP_KERNEL);
+	set_dev_node(dev, orig_node);
+	if (!tx_ring->desc)
+		tx_ring->desc = dma_alloc_coherent(dev, tx_ring->size,
+						   &tx_ring->dma, GFP_KERNEL);
+	if (!tx_ring->desc)
+		goto err;
+
+	return 0;
+
+err:
+	vfree(tx_ring->tx_buffer_info);
+	tx_ring->tx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Tx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_setup_all_tx_resources - allocate all queues Tx resources
+ * @adapter: board private structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_all_tx_resources(struct txgbe_adapter *adapter)
+{
+	int i, err = 0;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		err = txgbe_setup_tx_resources(adapter->tx_ring[i]);
+		if (!err)
+			continue;
+
+		txgbe_err(probe, "Allocation for Tx Queue %u failed\n", i);
+		goto err_setup_tx;
+	}
+
+	return 0;
+err_setup_tx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		txgbe_free_tx_resources(adapter->tx_ring[i]);
+	return err;
+}
+
+/**
+ * txgbe_setup_rx_resources - allocate Rx resources (Descriptors)
+ * @rx_ring:    rx descriptor ring (for a specific queue) to setup
+ *
+ * Returns 0 on success, negative on failure
+ **/
+int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring)
+{
+	struct device *dev = rx_ring->dev;
+	int orig_node = dev_to_node(dev);
+	int numa_node = -1;
+	int size;
+
+	size = sizeof(struct txgbe_rx_buffer) * rx_ring->count;
+
+	if (rx_ring->q_vector)
+		numa_node = rx_ring->q_vector->numa_node;
+
+	rx_ring->rx_buffer_info = vzalloc_node(size, numa_node);
+	if (!rx_ring->rx_buffer_info)
+		rx_ring->rx_buffer_info = vzalloc(size);
+	if (!rx_ring->rx_buffer_info)
+		goto err;
+
+	/* Round up to nearest 4K */
+	rx_ring->size = rx_ring->count * sizeof(union txgbe_rx_desc);
+	rx_ring->size = ALIGN(rx_ring->size, 4096);
+
+	set_dev_node(dev, numa_node);
+	rx_ring->desc = dma_alloc_coherent(dev,
+					   rx_ring->size,
+					   &rx_ring->dma,
+					   GFP_KERNEL);
+	set_dev_node(dev, orig_node);
+	if (!rx_ring->desc)
+		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
+						   &rx_ring->dma, GFP_KERNEL);
+	if (!rx_ring->desc)
+		goto err;
+
+	return 0;
+err:
+	vfree(rx_ring->rx_buffer_info);
+	rx_ring->rx_buffer_info = NULL;
+	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
+	return -ENOMEM;
+}
+
+/**
+ * txgbe_setup_all_rx_resources - allocate all queues Rx resources
+ * @adapter: board private structure
+ *
+ * If this function returns with an error, then it's possible one or
+ * more of the rings is populated (while the rest are not).  It is the
+ * callers duty to clean those orphaned rings.
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_all_rx_resources(struct txgbe_adapter *adapter)
+{
+	int i, err = 0;
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		err = txgbe_setup_rx_resources(adapter->rx_ring[i]);
+		if (!err)
+			continue;
+
+		txgbe_err(probe, "Allocation for Rx Queue %u failed\n", i);
+		goto err_setup_rx;
+	}
+
+		return 0;
+err_setup_rx:
+	/* rewind the index freeing the rings as we go */
+	while (i--)
+		txgbe_free_rx_resources(adapter->rx_ring[i]);
+	return err;
+}
+
+/**
+ * txgbe_setup_isb_resources - allocate interrupt status resources
+ * @adapter: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static int txgbe_setup_isb_resources(struct txgbe_adapter *adapter)
+{
+	struct device *dev = pci_dev_to_dev(adapter->pdev);
+
+	adapter->isb_mem = dma_alloc_coherent(dev,
+					      sizeof(u32) * TXGBE_ISB_MAX,
+					      &adapter->isb_dma,
+					      GFP_KERNEL);
+	if (!adapter->isb_mem)
+		return -ENOMEM;
+	memset(adapter->isb_mem, 0, sizeof(u32) * TXGBE_ISB_MAX);
+	return 0;
+}
+
+/**
+ * txgbe_free_isb_resources - allocate all queues Rx resources
+ * @adapter: board private structure
+ *
+ * Return 0 on success, negative on failure
+ **/
+static void txgbe_free_isb_resources(struct txgbe_adapter *adapter)
+{
+	struct device *dev = pci_dev_to_dev(adapter->pdev);
+
+	dma_free_coherent(dev, sizeof(u32) * TXGBE_ISB_MAX,
+			  adapter->isb_mem, adapter->isb_dma);
+	adapter->isb_mem = NULL;
+}
+
+/**
+ * txgbe_free_tx_resources - Free Tx Resources per Queue
+ * @tx_ring: Tx descriptor ring for a specific queue
+ *
+ * Free all transmit software resources
+ **/
+void txgbe_free_tx_resources(struct txgbe_ring *tx_ring)
+{
+	txgbe_clean_tx_ring(tx_ring);
+
+	vfree(tx_ring->tx_buffer_info);
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
+ * txgbe_free_all_tx_resources - Free Tx Resources for All Queues
+ * @adapter: board private structure
+ *
+ * Free all transmit software resources
+ **/
+static void txgbe_free_all_tx_resources(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++)
+		txgbe_free_tx_resources(adapter->tx_ring[i]);
+}
+
+/**
+ * txgbe_free_rx_resources - Free Rx Resources
+ * @rx_ring: ring to clean the resources from
+ *
+ * Free all receive software resources
+ **/
+void txgbe_free_rx_resources(struct txgbe_ring *rx_ring)
+{
+	txgbe_clean_rx_ring(rx_ring);
+
+	vfree(rx_ring->rx_buffer_info);
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
+}
+
+/**
+ * txgbe_free_all_rx_resources - Free Rx Resources for All Queues
+ * @adapter: board private structure
+ *
+ * Free all receive software resources
+ **/
+static void txgbe_free_all_rx_resources(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_rx_queues; i++)
+		txgbe_free_rx_resources(adapter->rx_ring[i]);
+}
+
+/**
+ * txgbe_change_mtu - Change the Maximum Transfer Unit
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int txgbe_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	if (new_mtu < 68 || new_mtu > 9414)
+		return -EINVAL;
+
+	txgbe_info(probe, "changing MTU from %d to %d\n", netdev->mtu, new_mtu);
+
+	/* must set new MTU before calling down or up */
+	netdev->mtu = new_mtu;
+
+	if (netif_running(netdev))
+		txgbe_reinit_locked(adapter);
+
+	return 0;
+}
+
+/**
+ * txgbe_open - Called when a network interface is made active
+ * @netdev: network interface device structure
+ *
+ * Returns 0 on success, negative value on failure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).  At this point all resources needed
+ * for transmit and receive operations are allocated, the interrupt
+ * handler is registered with the OS, the watchdog timer is started,
+ * and the stack is notified that the interface is ready.
+ **/
+int txgbe_open(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int err;
+
+	netif_carrier_off(netdev);
+
+	/* allocate transmit descriptors */
+	err = txgbe_setup_all_tx_resources(adapter);
+	if (err)
+		goto err_setup_tx;
+
+	/* allocate receive descriptors */
+	err = txgbe_setup_all_rx_resources(adapter);
+	if (err)
+		goto err_setup_rx;
+
+	err = txgbe_setup_isb_resources(adapter);
+	if (err)
+		goto err_req_isb;
+
+	txgbe_configure(adapter);
+
+	err = txgbe_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
+	/* Notify the stack of the actual queue counts. */
+	err = netif_set_real_num_tx_queues(netdev, adapter->num_tx_queues);
+	if (err)
+		goto err_set_queues;
+
+	err = netif_set_real_num_rx_queues(netdev, adapter->num_rx_queues);
+	if (err)
+		goto err_set_queues;
+
+	txgbe_up_complete(adapter);
+
+	txgbe_clear_vxlan_port(adapter);
+	udp_tunnel_get_rx_info(netdev);
+
+	return 0;
+
+err_set_queues:
+	txgbe_free_irq(adapter);
+err_req_irq:
+	txgbe_free_isb_resources(adapter);
+err_req_isb:
+	txgbe_free_all_rx_resources(adapter);
+
+err_setup_rx:
+	txgbe_free_all_tx_resources(adapter);
+err_setup_tx:
+	txgbe_reset(adapter);
+
+	return err;
+}
+
+/**
+ * txgbe_close_suspend - actions necessary to both suspend and close flows
+ * @adapter: the private adapter struct
+ *
+ * This function should contain the necessary work common to both suspending
+ * and closing of the device.
+ */
+static void txgbe_close_suspend(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	txgbe_disable_device(adapter);
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		TCALL(hw, mac.ops.disable_tx_laser);
+	txgbe_clean_all_tx_rings(adapter);
+	txgbe_clean_all_rx_rings(adapter);
+
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
+	txgbe_free_all_rx_resources(adapter);
+	txgbe_free_all_tx_resources(adapter);
+}
+
+/**
+ * txgbe_close - Disables a network interface
+ * @netdev: network interface device structure
+ *
+ * Returns 0, this is not allowed to fail
+ *
+ * The close entry point is called when an interface is de-activated
+ * by the OS.  The hardware is still under the drivers control, but
+ * needs to be disabled.  A global MAC reset is issued to stop the
+ * hardware, and all transmit and receive resources are freed.
+ **/
+int txgbe_close(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	txgbe_down(adapter);
+	txgbe_free_irq(adapter);
+
+	txgbe_free_isb_resources(adapter);
+	txgbe_free_all_rx_resources(adapter);
+	txgbe_free_all_tx_resources(adapter);
+
+	txgbe_release_hw_control(adapter);
+
+	return 0;
+}
+
+static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
+{
+	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev = adapter->netdev;
+
+	netif_device_detach(netdev);
+
+	rtnl_lock();
+	if (netif_running(netdev))
+		txgbe_close_suspend(adapter);
+	rtnl_unlock();
+
+	txgbe_clear_interrupt_scheme(adapter);
+
+	txgbe_release_hw_control(adapter);
+
+	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
+		pci_disable_device(pdev);
+
+	return 0;
+}
+
+static void txgbe_shutdown(struct pci_dev *pdev)
+{
+	bool wake;
+
+	__txgbe_shutdown(pdev, &wake);
+
+	if (system_state == SYSTEM_POWER_OFF) {
+		pci_wake_from_d3(pdev, wake);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
+}
+
+/**
+ * txgbe_get_stats64 - Get System Network Statistics
+ * @netdev: network interface device structure
+ * @stats: storage space for 64bit statistics
+ *
+ * Returns 64bit statistics, for use in the ndo_get_stats64 callback. This
+ * function replaces txgbe_get_stats for kernels which support it.
+ */
+static void txgbe_get_stats64(struct net_device *netdev,
+			      struct rtnl_link_stats64 *stats)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *ring = READ_ONCE(adapter->rx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin_irq(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry_irq(&ring->syncp,
+				 start));
+			stats->rx_packets += packets;
+			stats->rx_bytes   += bytes;
+		}
+	}
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *ring = READ_ONCE(adapter->tx_ring[i]);
+		u64 bytes, packets;
+		unsigned int start;
+
+		if (ring) {
+			do {
+				start = u64_stats_fetch_begin_irq(&ring->syncp);
+				packets = ring->stats.packets;
+				bytes   = ring->stats.bytes;
+			} while (u64_stats_fetch_retry_irq(&ring->syncp,
+				 start));
+			stats->tx_packets += packets;
+			stats->tx_bytes   += bytes;
+		}
+	}
+	rcu_read_unlock();
+	/* following stats updated by txgbe_watchdog_subtask() */
+	stats->multicast        = netdev->stats.multicast;
+	stats->rx_errors        = netdev->stats.rx_errors;
+	stats->rx_length_errors = netdev->stats.rx_length_errors;
+	stats->rx_crc_errors    = netdev->stats.rx_crc_errors;
+	stats->rx_missed_errors = netdev->stats.rx_missed_errors;
+}
+
+/**
+ * txgbe_update_stats - Update the board statistics counters.
+ * @adapter: board private structure
+ **/
+void txgbe_update_stats(struct txgbe_adapter *adapter)
+{
+	struct net_device_stats *net_stats = &adapter->netdev->stats;
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_hw_stats *hwstats = &adapter->stats;
+	u64 total_mpc = 0;
+	u32 i, missed_rx = 0, mpc, bprc, lxon, lxoff;
+	u64 non_eop_descs = 0, restart_queue = 0, tx_busy = 0;
+	u64 alloc_rx_page_failed = 0, alloc_rx_buff_failed = 0;
+	u64 bytes = 0, packets = 0, hw_csum_rx_error = 0;
+	u64 hw_csum_rx_good = 0;
+
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED) {
+		u64 rsc_count = 0;
+		u64 rsc_flush = 0;
+
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			rsc_count += adapter->rx_ring[i]->rx_stats.rsc_count;
+			rsc_flush += adapter->rx_ring[i]->rx_stats.rsc_flush;
+		}
+		adapter->rsc_total_count = rsc_count;
+		adapter->rsc_total_flush = rsc_flush;
+	}
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct txgbe_ring *rx_ring = adapter->rx_ring[i];
+
+		non_eop_descs += rx_ring->rx_stats.non_eop_descs;
+		alloc_rx_page_failed += rx_ring->rx_stats.alloc_rx_page_failed;
+		alloc_rx_buff_failed += rx_ring->rx_stats.alloc_rx_buff_failed;
+		hw_csum_rx_error += rx_ring->rx_stats.csum_err;
+		hw_csum_rx_good += rx_ring->rx_stats.csum_good_cnt;
+		bytes += rx_ring->stats.bytes;
+		packets += rx_ring->stats.packets;
+	}
+	adapter->non_eop_descs = non_eop_descs;
+	adapter->alloc_rx_page_failed = alloc_rx_page_failed;
+	adapter->alloc_rx_buff_failed = alloc_rx_buff_failed;
+	adapter->hw_csum_rx_error = hw_csum_rx_error;
+	adapter->hw_csum_rx_good = hw_csum_rx_good;
+	net_stats->rx_bytes = bytes;
+	net_stats->rx_packets = packets;
+
+	bytes = 0;
+	packets = 0;
+	/* gather some stats to the adapter struct that are per queue */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
+
+		restart_queue += tx_ring->tx_stats.restart_queue;
+		tx_busy += tx_ring->tx_stats.tx_busy;
+		bytes += tx_ring->stats.bytes;
+		packets += tx_ring->stats.packets;
+	}
+	adapter->restart_queue = restart_queue;
+	adapter->tx_busy = tx_busy;
+	net_stats->tx_bytes = bytes;
+	net_stats->tx_packets = packets;
+
+	hwstats->crcerrs += rd32(hw, TXGBE_RX_CRC_ERROR_FRAMES_LOW);
+
+	/* 8 register reads */
+	for (i = 0; i < 8; i++) {
+		/* for packet buffers not used, the register should read 0 */
+		mpc = rd32(hw, TXGBE_RDB_MPCNT(i));
+		missed_rx += mpc;
+		hwstats->mpc[i] += mpc;
+		total_mpc += hwstats->mpc[i];
+		hwstats->pxontxc[i] += rd32(hw, TXGBE_RDB_PXONTXC(i));
+		hwstats->pxofftxc[i] +=
+				rd32(hw, TXGBE_RDB_PXOFFTXC(i));
+		hwstats->pxonrxc[i] += rd32(hw, TXGBE_MAC_PXONRXC(i));
+	}
+
+	hwstats->gprc += rd32(hw, TXGBE_PX_GPRC);
+
+	hwstats->o2bgptc += rd32(hw, TXGBE_TDM_OS2BMC_CNT);
+	if (txgbe_check_mng_access(&adapter->hw)) {
+		hwstats->o2bspc += rd32(hw, TXGBE_MNG_OS2BMC_CNT);
+		hwstats->b2ospc += rd32(hw, TXGBE_MNG_BMC2OS_CNT);
+	}
+	hwstats->b2ogprc += rd32(hw, TXGBE_RDM_BMC2OS_CNT);
+	hwstats->gorc += rd32(hw, TXGBE_PX_GORC_LSB);
+	hwstats->gorc += (u64)rd32(hw, TXGBE_PX_GORC_MSB) << 32;
+
+	hwstats->gotc += rd32(hw, TXGBE_PX_GOTC_LSB);
+	hwstats->gotc += (u64)rd32(hw, TXGBE_PX_GOTC_MSB) << 32;
+
+	adapter->hw_rx_no_dma_resources +=
+				     rd32(hw, TXGBE_RDM_DRP_PKT);
+	hwstats->lxonrxc += rd32(hw, TXGBE_MAC_LXONRXC);
+
+	bprc = rd32(hw, TXGBE_RX_BC_FRAMES_GOOD_LOW);
+	hwstats->bprc += bprc;
+	hwstats->mprc = 0;
+
+	for (i = 0; i < 128; i++)
+		hwstats->mprc += rd32(hw, TXGBE_PX_MPRC(i));
+
+	hwstats->roc += rd32(hw, TXGBE_RX_OVERSIZE_FRAMES_GOOD);
+	hwstats->rlec += rd32(hw, TXGBE_RX_LEN_ERROR_FRAMES_LOW);
+	lxon = rd32(hw, TXGBE_RDB_LXONTXC);
+	hwstats->lxontxc += lxon;
+	lxoff = rd32(hw, TXGBE_RDB_LXOFFTXC);
+	hwstats->lxofftxc += lxoff;
+
+	hwstats->gptc += rd32(hw, TXGBE_PX_GPTC);
+	hwstats->mptc += rd32(hw, TXGBE_TX_MC_FRAMES_GOOD_LOW);
+	hwstats->ruc += rd32(hw, TXGBE_RX_UNDERSIZE_FRAMES_GOOD);
+	hwstats->tpr += rd32(hw, TXGBE_RX_FRAME_CNT_GOOD_BAD_LOW);
+	hwstats->bptc += rd32(hw, TXGBE_TX_BC_FRAMES_GOOD_LOW);
+	/* Fill out the OS statistics structure */
+	net_stats->multicast = hwstats->mprc;
+
+	/* Rx Errors */
+	net_stats->rx_errors = hwstats->crcerrs +
+				       hwstats->rlec;
+	net_stats->rx_dropped = 0;
+	net_stats->rx_length_errors = hwstats->rlec;
+	net_stats->rx_crc_errors = hwstats->crcerrs;
+	net_stats->rx_missed_errors = total_mpc;
+}
+
+/**
+ * txgbe_check_hang_subtask - check for hung queues and dropped interrupts
+ * @adapter - pointer to the device adapter structure
+ *
+ * This function serves two purposes.  First it strobes the interrupt lines
+ * in order to make certain interrupts are occurring.  Secondly it sets the
+ * bits needed to check for TX hangs.  As a result we should immediately
+ * determine if a hang has occurred.
+ */
+static void txgbe_check_hang_subtask(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	/* If we're down or resetting, just bail */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	/* Force detection of hung controller */
+	if (netif_carrier_ok(adapter->netdev)) {
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			set_check_for_tx_hang(adapter->tx_ring[i]);
+	}
+}
+
+/**
+ * txgbe_watchdog_update_link - update the link status
+ * @adapter - pointer to the device adapter structure
+ * @link_speed - pointer to a u32 to store the link_speed
+ **/
+static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 link_speed = adapter->link_speed;
+	bool link_up = adapter->link_up;
+	u32 reg;
+	u32 i = 1;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE))
+		return;
+
+	link_speed = TXGBE_LINK_SPEED_10GB_FULL;
+	link_up = true;
+	TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+
+	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
+		TXGBE_TRY_LINK_TIMEOUT))) {
+		adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+	}
+
+	for (i = 0; i < 3; i++) {
+		TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+		msleep(1);
+	}
+
+	adapter->link_up = link_up;
+	adapter->link_speed = link_speed;
+
+	if (link_up) {
+		txgbe_set_rx_drop_en(adapter);
+
+		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
+			     TXGBE_MAC_TX_CFG_SPEED_10G);
+		} else if (link_speed & (TXGBE_LINK_SPEED_1GB_FULL |
+			   TXGBE_LINK_SPEED_100_FULL | TXGBE_LINK_SPEED_10_FULL)) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
+			     TXGBE_MAC_TX_CFG_SPEED_1G);
+		}
+
+		/* Re configure MAC RX */
+		reg = rd32(hw, TXGBE_MAC_RX_CFG);
+		wr32(hw, TXGBE_MAC_RX_CFG, reg);
+		wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
+		reg = rd32(hw, TXGBE_MAC_WDG_TIMEOUT);
+		wr32(hw, TXGBE_MAC_WDG_TIMEOUT, reg);
+	}
+}
+
+/**
+ * txgbe_watchdog_link_is_up - update netif_carrier status and
+ *                             print link up message
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_link_is_up(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 link_speed = adapter->link_speed;
+	bool flow_rx, flow_tx;
+
+	/* only continue if link was previously down */
+	if (netif_carrier_ok(netdev))
+		return;
+
+	/* flow_rx, flow_tx report link flow control status */
+	flow_rx = (rd32(hw, TXGBE_MAC_RX_FLOW_CTRL) & 0x101) == 0x1;
+	flow_tx = !!(TXGBE_RDB_RFCC_RFCE_802_3X &
+		     rd32(hw, TXGBE_RDB_RFCC));
+
+	txgbe_info(drv, "NIC Link is Up %s, Flow Control: %s\n",
+		   (link_speed == TXGBE_LINK_SPEED_10GB_FULL ?
+		    "10 Gbps" :
+		    (link_speed == TXGBE_LINK_SPEED_1GB_FULL ?
+		     "1 Gbps" :
+		     (link_speed == TXGBE_LINK_SPEED_100_FULL ?
+		      "100 Mbps" :
+		      (link_speed == TXGBE_LINK_SPEED_10_FULL ?
+		       "10 Mbps" :
+		       "unknown speed")))),
+		  ((flow_rx && flow_tx) ? "RX/TX" :
+		   (flow_rx ? "RX" :
+		    (flow_tx ? "TX" : "None"))));
+
+	netif_carrier_on(netdev);
+	netif_tx_wake_all_queues(netdev);
+}
+
+/**
+ * txgbe_watchdog_link_is_down - update netif_carrier status and
+ *                               print link down message
+ * @adapter - pointer to the adapter structure
+ **/
+static void txgbe_watchdog_link_is_down(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	adapter->link_up = false;
+	adapter->link_speed = 0;
+
+	/* only continue if link was up previously */
+	if (!netif_carrier_ok(netdev))
+		return;
+
+	txgbe_info(drv, "NIC Link is Down\n");
+	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
+}
+
+static bool txgbe_ring_tx_pending(struct txgbe_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct txgbe_ring *tx_ring = adapter->tx_ring[i];
+
+		if (tx_ring->next_to_use != tx_ring->next_to_clean)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * txgbe_watchdog_flush_tx - flush queues on link down
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_flush_tx(struct txgbe_adapter *adapter)
+{
+	if (!netif_carrier_ok(adapter->netdev)) {
+		if (txgbe_ring_tx_pending(adapter)) {
+			/* We've lost link, so the controller stops DMA,
+			 * but we've got queued Tx work that's never going
+			 * to get done, so reset controller to flush Tx.
+			 * (Do the reset outside of interrupt context).
+			 */
+			txgbe_warn(drv,
+				   "initiating reset due to lost link with pending Tx work\n");
+			adapter->flags2 |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		}
+	}
+}
+
+/**
+ * txgbe_watchdog_subtask - check and bring link up
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_subtask(struct txgbe_adapter *adapter)
+{
+	/* if interface is down do nothing */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	txgbe_watchdog_update_link(adapter);
+
+	if (adapter->link_up)
+		txgbe_watchdog_link_is_up(adapter);
+	else
+		txgbe_watchdog_link_is_down(adapter);
+
+	txgbe_update_stats(adapter);
+
+	txgbe_watchdog_flush_tx(adapter);
+}
+
+/**
+ * txgbe_sfp_detection_subtask - poll for SFP+ cable
+ * @adapter - the txgbe adapter structure
+ **/
+static void txgbe_sfp_detection_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_mac_info *mac = &hw->mac;
+	s32 err;
+
+	/* not searching for SFP so there is nothing to do here */
+	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
+		return;
+
+	if (adapter->sfp_poll_time &&
+	    time_after(adapter->sfp_poll_time, jiffies))
+		return; /* If not yet time to poll for SFP */
+
+	/* someone else is in init, wait until next service event */
+	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		return;
+
+	adapter->sfp_poll_time = jiffies + TXGBE_SFP_POLL_JIFFIES - 1;
+
+	err = TCALL(hw, phy.ops.identify_sfp);
+	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED)
+		goto sfp_out;
+
+	if (err == TXGBE_ERR_SFP_NOT_PRESENT) {
+		/* If no cable is present, then we need to reset
+		 * the next time we find a good cable.
+		 */
+		adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+	}
+
+	/* exit on error */
+	if (err)
+		goto sfp_out;
+
+	/* exit if reset not needed */
+	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
+		goto sfp_out;
+
+	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+
+	if (hw->phy.multispeed_fiber) {
+		/* Set up dual speed SFP+ support */
+		mac->ops.setup_link = txgbe_setup_mac_link_multispeed_fiber;
+		mac->ops.setup_mac_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+	} else {
+		mac->ops.setup_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+		hw->phy.autoneg_advertised = 0;
+	}
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+	txgbe_info(probe, "detected SFP+: %d\n", hw->phy.sfp_type);
+
+sfp_out:
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+
+	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED && adapter->netdev_registered)
+		txgbe_dev_err("failed to initialize because an unsupported SFP+ module type was detected.\n");
+}
+
+/**
+ * txgbe_sfp_link_config_subtask - set up link SFP after module install
+ * @adapter - the txgbe adapter structure
+ **/
+static void txgbe_sfp_link_config_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 speed;
+	bool autoneg = false;
+	u8 device_type = hw->subsystem_id & 0xF0;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_CONFIG))
+		return;
+
+	/* someone else is in init, wait until next service event */
+	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		return;
+
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+
+	if (device_type == TXGBE_ID_MAC_SGMII) {
+		speed = TXGBE_LINK_SPEED_1GB_FULL;
+	} else {
+		speed = hw->phy.autoneg_advertised;
+		if (!speed && hw->mac.ops.get_link_capabilities) {
+			TCALL(hw, mac.ops.get_link_capabilities, &speed, &autoneg);
+			/* setup the highest link when no autoneg */
+			if (!autoneg) {
+				if (speed & TXGBE_LINK_SPEED_10GB_FULL)
+					speed = TXGBE_LINK_SPEED_10GB_FULL;
+			}
+		}
+	}
+
+	TCALL(hw, mac.ops.setup_link, speed, false);
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+}
+
+/**
+ * txgbe_service_timer - Timer Call-back
+ * @data: pointer to adapter cast into an unsigned long
+ **/
+static void txgbe_service_timer(struct timer_list *t)
+{
+	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
+	unsigned long next_event_offset;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	/* poll faster when waiting for link */
+	if (adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE) {
+		if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4)
+			next_event_offset = HZ;
+		else
+			next_event_offset = HZ / 10;
+	} else {
+		next_event_offset = HZ * 2;
+	}
+
+	/* Reset the timer */
+	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
+
+	txgbe_service_event_schedule(adapter);
+}
+
+static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
+{
+	u32 reset_flag = 0;
+	u32 value = 0;
+
+	if (!(adapter->flags2 & (TXGBE_FLAG2_PF_RESET_REQUESTED |
+				 TXGBE_FLAG2_GLOBAL_RESET_REQUESTED |
+				 TXGBE_FLAG2_RESET_INTR_RECEIVED)))
+		return;
+
+	/* If we're already down, just bail */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state))
+		return;
+
+	netdev_err(adapter->netdev, "Reset adapter\n");
+	adapter->tx_timeout_count++;
+
+	rtnl_lock();
+	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+	}
+	if (adapter->flags2 & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		reset_flag |= TXGBE_FLAG2_PF_RESET_REQUESTED;
+		adapter->flags2 &= ~TXGBE_FLAG2_PF_RESET_REQUESTED;
+	}
+
+	if (adapter->flags2 & TXGBE_FLAG2_RESET_INTR_RECEIVED) {
+		/* If there's a recovery already waiting, it takes
+		 * precedence before starting a new reset sequence.
+		 */
+		adapter->flags2 &= ~TXGBE_FLAG2_RESET_INTR_RECEIVED;
+		value = rd32m(&adapter->hw, TXGBE_MIS_RST_ST,
+			      TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK) >>
+			TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT;
+		if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST) {
+			adapter->hw.reset_type = TXGBE_SW_RESET;
+			/* errata 7 */
+			if (txgbe_mng_present(&adapter->hw) &&
+			    adapter->hw.revision_id == TXGBE_SP_MPW)
+				adapter->flags2 |=
+					TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED;
+		} else if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST) {
+			adapter->hw.reset_type = TXGBE_GLOBAL_RESET;
+		}
+		adapter->hw.force_full_reset = true;
+		txgbe_reinit_locked(adapter);
+		adapter->hw.force_full_reset = false;
+		goto unlock;
+	}
+
+	if (reset_flag & TXGBE_FLAG2_PF_RESET_REQUESTED) {
+		/*debug to up*/
+		txgbe_reinit_locked(adapter);
+	} else if (reset_flag & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
+		/* Request a Global Reset
+		 *
+		 * This will start the chip's countdown to the actual full
+		 * chip reset event, and a warning interrupt to be sent
+		 * to all PFs, including the requestor.  Our handler
+		 * for the warning interrupt will deal with the shutdown
+		 * and recovery of the switch setup.
+		 */
+		/*debug to up*/
+		pci_save_state(adapter->pdev);
+		if (txgbe_mng_present(&adapter->hw))
+			txgbe_reset_hostif(&adapter->hw);
+		else
+			wr32m(&adapter->hw, TXGBE_MIS_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST,
+			      TXGBE_MIS_RST_GLOBAL_RST);
+	}
+
+unlock:
+	rtnl_unlock();
+}
+
+/**
+ * txgbe_service_task - manages and runs subtasks
+ * @work: pointer to work_struct containing our data
+ **/
+static void txgbe_service_task(struct work_struct *work)
+{
+	struct txgbe_adapter *adapter = container_of(work,
+						     struct txgbe_adapter,
+						     service_task);
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			rtnl_lock();
+			txgbe_down(adapter);
+			rtnl_unlock();
+		}
+		txgbe_service_event_complete(adapter);
+		return;
+	}
+
+	txgbe_reset_subtask(adapter);
+	txgbe_sfp_detection_subtask(adapter);
+	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_check_overtemp_subtask(adapter);
+	txgbe_watchdog_subtask(adapter);
+	txgbe_check_hang_subtask(adapter);
+
+	txgbe_service_event_complete(adapter);
+}
+
+static u8 get_ipv6_proto(struct sk_buff *skb, int offset)
+{
+	struct ipv6hdr *hdr = (struct ipv6hdr *)(skb->data + offset);
+	u8 nexthdr = hdr->nexthdr;
 
-	txgbe_up_complete(adapter);
+	offset += sizeof(struct ipv6hdr);
 
-	return 0;
+	while (ipv6_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
 
-err_set_queues:
-	txgbe_free_irq(adapter);
-err_req_irq:
-	txgbe_free_isb_resources(adapter);
-err_req_isb:
-	return err;
-}
+		if (nexthdr == NEXTHDR_NONE)
+			break;
 
-/**
- * txgbe_close_suspend - actions necessary to both suspend and close flows
- * @adapter: the private adapter struct
- *
- * This function should contain the necessary work common to both suspending
- * and closing of the device.
- */
-static void txgbe_close_suspend(struct txgbe_adapter *adapter)
-{
-	struct txgbe_hw *hw = &adapter->hw;
+		hp = skb_header_pointer(skb, offset, sizeof(_hdr), &_hdr);
+		if (!hp)
+			break;
 
-	txgbe_disable_device(adapter);
-	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
-		TCALL(hw, mac.ops.disable_tx_laser);
-	txgbe_free_irq(adapter);
+		if (nexthdr == NEXTHDR_FRAGMENT)
+			break;
+		else if (nexthdr == NEXTHDR_AUTH)
+			offset +=  ipv6_authlen(hp);
+		else
+			offset +=  ipv6_optlen(hp);
 
-	txgbe_free_isb_resources(adapter);
+		nexthdr = hp->nexthdr;
+	}
+
+	return nexthdr;
 }
 
-/**
- * txgbe_close - Disables a network interface
- * @netdev: network interface device structure
- *
- * Returns 0, this is not allowed to fail
- *
- * The close entry point is called when an interface is de-activated
- * by the OS.  The hardware is still under the drivers control, but
- * needs to be disabled.  A global MAC reset is issued to stop the
- * hardware, and all transmit and receive resources are freed.
- **/
-int txgbe_close(struct net_device *netdev)
+union network_header {
+	struct iphdr *ipv4;
+	struct ipv6hdr *ipv6;
+	void *raw;
+};
+
+static struct txgbe_dptype encode_tx_desc_ptype(const struct txgbe_tx_buffer *first)
 {
-	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct sk_buff *skb = first->skb;
+	u8 tun_prot = 0;
+	u8 l4_prot = 0;
+	u8 ptype = 0;
+
+	if (skb->encapsulation) {
+		union network_header hdr;
+
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET))
+				goto encap_frag;
+			ptype = TXGBE_PTYPE_TUN_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = get_ipv6_proto(skb, skb_network_offset(skb));
+			if (tun_prot == NEXTHDR_FRAGMENT)
+				goto encap_frag;
+			ptype = TXGBE_PTYPE_TUN_IPV6;
+			break;
+		default:
+			goto exit;
+		}
 
-	txgbe_down(adapter);
-	txgbe_free_irq(adapter);
+		if (tun_prot == IPPROTO_IPIP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			ptype |= TXGBE_PTYPE_PKT_IPIP;
+		} else if (tun_prot == IPPROTO_UDP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+			    skb->inner_protocol != htons(ETH_P_TEB)) {
+				ptype |= TXGBE_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)
+					skb_inner_mac_header(skb))->h_proto
+					== htons(ETH_P_8021Q)) {
+					ptype |= TXGBE_PTYPE_PKT_IGMV;
+				} else {
+					ptype |= TXGBE_PTYPE_PKT_IGM;
+				}
+			}
 
-	txgbe_free_isb_resources(adapter);
+		} else if (tun_prot == IPPROTO_GRE) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol ==  htons(ETH_P_IP) ||
+			    skb->inner_protocol ==  htons(ETH_P_IPV6)) {
+				ptype |= TXGBE_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)
+					skb_inner_mac_header(skb))->h_proto
+					== htons(ETH_P_8021Q)) {
+					ptype |= TXGBE_PTYPE_PKT_IGMV;
+				} else {
+					ptype |= TXGBE_PTYPE_PKT_IGM;
+				}
+			}
+		} else {
+			goto exit;
+		}
 
-	txgbe_release_hw_control(adapter);
+		switch (hdr.ipv4->version) {
+		case IPVERSION:
+			l4_prot = hdr.ipv4->protocol;
+			if (hdr.ipv4->frag_off & htons(IP_MF | IP_OFFSET)) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case 6:
+			l4_prot = get_ipv6_proto(skb,
+						 skb_inner_network_offset(skb));
+			ptype |= TXGBE_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		default:
+			goto exit;
+		}
+	} else {
+encap_frag:
+
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			l4_prot = ip_hdr(skb)->protocol;
+			ptype = TXGBE_PTYPE_PKT_IP;
+			if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+#ifdef NETIF_F_IPV6_CSUM
+		case htons(ETH_P_IPV6):
+			l4_prot = get_ipv6_proto(skb, skb_network_offset(skb));
+			ptype = TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+#endif /* NETIF_F_IPV6_CSUM */
+		case htons(ETH_P_1588):
+			ptype = TXGBE_PTYPE_L2_TS;
+			goto exit;
+		case htons(ETH_P_FIP):
+			ptype = TXGBE_PTYPE_L2_FIP;
+			goto exit;
+		case htons(ETH_P_LLDP):
+			ptype = TXGBE_PTYPE_L2_LLDP;
+			goto exit;
+		case htons(TXGBE_ETH_P_CNM):
+			ptype = TXGBE_PTYPE_L2_CNM;
+			goto exit;
+		case htons(ETH_P_PAE):
+			ptype = TXGBE_PTYPE_L2_EAPOL;
+			goto exit;
+		case htons(ETH_P_ARP):
+			ptype = TXGBE_PTYPE_L2_ARP;
+			goto exit;
+		default:
+			ptype = TXGBE_PTYPE_L2_MAC;
+			goto exit;
+		}
+	}
 
-	return 0;
+	switch (l4_prot) {
+	case IPPROTO_TCP:
+		ptype |= TXGBE_PTYPE_TYP_TCP;
+		break;
+	case IPPROTO_UDP:
+		ptype |= TXGBE_PTYPE_TYP_UDP;
+		break;
+	case IPPROTO_SCTP:
+		ptype |= TXGBE_PTYPE_TYP_SCTP;
+		break;
+	default:
+		ptype |= TXGBE_PTYPE_TYP_IP;
+		break;
+	}
+
+exit:
+	return txgbe_decode_ptype(ptype);
 }
 
-static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
+static int txgbe_tso(struct txgbe_ring *tx_ring,
+		     struct txgbe_tx_buffer *first,
+		     u8 *hdr_len, struct txgbe_dptype dptype)
 {
-	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
+	struct sk_buff *skb = first->skb;
+	u32 vlan_macip_lens, type_tucmd;
+	u32 mss_l4len_idx, l4len;
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	u32 tunhdr_eiplen_tunlen = 0;
 
-	netif_device_detach(netdev);
+	u8 tun_prot = 0;
+	bool enc = skb->encapsulation;
 
-	rtnl_lock();
-	if (netif_running(netdev))
-		txgbe_close_suspend(adapter);
-	rtnl_unlock();
+	struct ipv6hdr *ipv6h;
 
-	txgbe_clear_interrupt_scheme(adapter);
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
 
-	txgbe_release_hw_control(adapter);
+	if (!skb_is_gso(skb))
+		return 0;
 
-	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
-		pci_disable_device(pdev);
+	if (skb_header_cloned(skb)) {
+		int err = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
 
-	return 0;
-}
+		if (err)
+			return err;
+	}
 
-static void txgbe_shutdown(struct pci_dev *pdev)
-{
-	bool wake;
+	iph = enc ? inner_ip_hdr(skb) : ip_hdr(skb);
+
+	if (iph->version == 4) {
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		iph->tot_len = 0;
+		iph->check = 0;
+		tcph->check = ~csum_tcpudp_magic(iph->saddr,
+						iph->daddr, 0,
+						IPPROTO_TCP,
+						0);
+		first->tx_flags |= TXGBE_TX_FLAGS_TSO |
+				   TXGBE_TX_FLAGS_CSUM |
+				   TXGBE_TX_FLAGS_IPV4 |
+				   TXGBE_TX_FLAGS_CC;
+	} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
+		ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		ipv6h->payload_len = 0;
+		tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
+					       &ipv6h->daddr,
+					       0, IPPROTO_TCP, 0);
+		first->tx_flags |= TXGBE_TX_FLAGS_TSO |
+				   TXGBE_TX_FLAGS_CSUM |
+				   TXGBE_TX_FLAGS_CC;
+	}
 
-	__txgbe_shutdown(pdev, &wake);
+	/* compute header lengths */
+	l4len = enc ? inner_tcp_hdrlen(skb) : tcp_hdrlen(skb);
+	*hdr_len = enc ? (skb_inner_transport_header(skb) - skb->data)
+		       : skb_transport_offset(skb);
+	*hdr_len += l4len;
+
+	/* update gso size and bytecount with header size */
+	first->gso_segs = skb_shinfo(skb)->gso_segs;
+	first->bytecount += (first->gso_segs - 1) * *hdr_len;
+
+	/* mss_l4len_id: use 0 as index for TSO */
+	mss_l4len_idx = l4len << TXGBE_TXD_L4LEN_SHIFT;
+	mss_l4len_idx |= skb_shinfo(skb)->gso_size << TXGBE_TXD_MSS_SHIFT;
+
+	/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
+
+	if (enc) {
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			first->tx_flags |= TXGBE_TX_FLAGS_OUTER_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+		switch (tun_prot) {
+		case IPPROTO_UDP:
+			tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_UDP;
+			tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_GRE:
+			tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_GRE;
+			tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_IPIP:
+			tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
+						 (char *)ip_hdr(skb)) >> 2) <<
+						TXGBE_TXD_OUTER_IPLEN_SHIFT;
+			break;
+		default:
+			break;
+		}
 
-	if (system_state == SYSTEM_POWER_OFF) {
-		pci_wake_from_d3(pdev, wake);
-		pci_set_power_state(pdev, PCI_D3hot);
+		vlan_macip_lens = skb_inner_network_header_len(skb) >> 1;
+	} else {
+		vlan_macip_lens = skb_network_header_len(skb) >> 1;
 	}
+
+	vlan_macip_lens |= skb_network_offset(skb) << TXGBE_TXD_MACLEN_SHIFT;
+	vlan_macip_lens |= first->tx_flags & TXGBE_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = dptype.ptype << 24;
+	txgbe_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+			  type_tucmd, mss_l4len_idx);
+
+	return 1;
 }
 
-/**
- * txgbe_watchdog_update_link - update the link status
- * @adapter - pointer to the device adapter structure
- * @link_speed - pointer to a u32 to store the link_speed
- **/
-static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
+static void txgbe_tx_csum(struct txgbe_ring *tx_ring,
+			  struct txgbe_tx_buffer *first,
+			  struct txgbe_dptype dptype)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 link_speed = adapter->link_speed;
-	bool link_up = adapter->link_up;
-	u32 reg;
-	u32 i = 1;
+	struct sk_buff *skb = first->skb;
+	u32 vlan_macip_lens = 0;
+	u32 mss_l4len_idx = 0;
+	u32 tunhdr_eiplen_tunlen = 0;
 
-	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE))
-		return;
+	u8 tun_prot = 0;
 
-	link_speed = TXGBE_LINK_SPEED_10GB_FULL;
-	link_up = true;
-	TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+	u32 type_tucmd;
 
-	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
-		TXGBE_TRY_LINK_TIMEOUT))) {
-		adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
-	}
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (!(first->tx_flags & TXGBE_TX_FLAGS_HW_VLAN) &&
+		    !(first->tx_flags & TXGBE_TX_FLAGS_CC))
+			return;
+		vlan_macip_lens = skb_network_offset(skb) <<
+				  TXGBE_TXD_MACLEN_SHIFT;
+	} else {
+		u8 l4_prot = 0;
+
+		union {
+			struct iphdr *ipv4;
+			struct ipv6hdr *ipv6;
+			u8 *raw;
+		} network_hdr;
+		union {
+			struct tcphdr *tcphdr;
+			u8 *raw;
+		} transport_hdr;
+
+		if (skb->encapsulation) {
+			network_hdr.raw = skb_inner_network_header(skb);
+			transport_hdr.raw = skb_inner_transport_header(skb);
+			vlan_macip_lens = skb_network_offset(skb) <<
+					  TXGBE_TXD_MACLEN_SHIFT;
+			switch (first->protocol) {
+			case htons(ETH_P_IP):
+				tun_prot = ip_hdr(skb)->protocol;
+				break;
+			case htons(ETH_P_IPV6):
+				tun_prot = ipv6_hdr(skb)->nexthdr;
+				break;
+			default:
+				if (unlikely(net_ratelimit())) {
+					dev_warn(tx_ring->dev,
+						 "partial checksum but version=%d\n",
+						 network_hdr.ipv4->version);
+				}
+				return;
+			}
+			switch (tun_prot) {
+			case IPPROTO_UDP:
+				tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_UDP;
+				tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					skb_transport_header(skb)) >> 1) <<
+					TXGBE_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_GRE:
+				tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_GRE;
+				tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					skb_transport_header(skb)) >> 1) <<
+					TXGBE_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_IPIP:
+				tunhdr_eiplen_tunlen =
+					(((char *)inner_ip_hdr(skb) -
+					(char *)ip_hdr(skb)) >> 2) <<
+					TXGBE_TXD_OUTER_IPLEN_SHIFT;
+				break;
+			default:
+				break;
+			}
 
-	for (i = 0; i < 3; i++) {
-		TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
-		msleep(1);
-	}
+		} else {
+			network_hdr.raw = skb_network_header(skb);
+			transport_hdr.raw = skb_transport_header(skb);
+			vlan_macip_lens = skb_network_offset(skb) <<
+					  TXGBE_TXD_MACLEN_SHIFT;
+		}
 
-	adapter->link_up = link_up;
-	adapter->link_speed = link_speed;
+		switch (network_hdr.ipv4->version) {
+		case IPVERSION:
+			vlan_macip_lens |=
+				(transport_hdr.raw - network_hdr.raw) >> 1;
+			l4_prot = network_hdr.ipv4->protocol;
+			break;
+		case 6:
+			vlan_macip_lens |=
+				(transport_hdr.raw - network_hdr.raw) >> 1;
+			l4_prot = network_hdr.ipv6->nexthdr;
+			break;
+		default:
+			break;
+		}
 
-	if (link_up) {
-		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
-			wr32(hw, TXGBE_MAC_TX_CFG,
-			     (rd32(hw, TXGBE_MAC_TX_CFG) &
-			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
-			     TXGBE_MAC_TX_CFG_SPEED_10G);
-		} else if (link_speed & (TXGBE_LINK_SPEED_1GB_FULL |
-			   TXGBE_LINK_SPEED_100_FULL | TXGBE_LINK_SPEED_10_FULL)) {
-			wr32(hw, TXGBE_MAC_TX_CFG,
-			     (rd32(hw, TXGBE_MAC_TX_CFG) &
-			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
-			     TXGBE_MAC_TX_CFG_SPEED_1G);
+		switch (l4_prot) {
+		case IPPROTO_TCP:
+
+		mss_l4len_idx = (transport_hdr.tcphdr->doff * 4) <<
+				TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_SCTP:
+			mss_l4len_idx = sizeof(struct sctphdr) <<
+					TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_UDP:
+			mss_l4len_idx = sizeof(struct udphdr) <<
+					TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		default:
+			break;
 		}
 
-		/* Re configure MAC RX */
-		reg = rd32(hw, TXGBE_MAC_RX_CFG);
-		wr32(hw, TXGBE_MAC_RX_CFG, reg);
-		wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
-		reg = rd32(hw, TXGBE_MAC_WDG_TIMEOUT);
-		wr32(hw, TXGBE_MAC_WDG_TIMEOUT, reg);
+		/* update TX checksum flag */
+		first->tx_flags |= TXGBE_TX_FLAGS_CSUM;
 	}
+	first->tx_flags |= TXGBE_TX_FLAGS_CC;
+	/* vlan_macip_lens: MACLEN, VLAN tag */
+	vlan_macip_lens |= first->tx_flags & TXGBE_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = dptype.ptype << 24;
+	txgbe_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+			  type_tucmd, mss_l4len_idx);
 }
 
-/**
- * txgbe_watchdog_link_is_up - update netif_carrier status and
- *                             print link up message
- * @adapter - pointer to the device adapter structure
- **/
-static void txgbe_watchdog_link_is_up(struct txgbe_adapter *adapter)
+static u32 txgbe_tx_cmd_type(u32 tx_flags)
 {
-	struct net_device *netdev = adapter->netdev;
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 link_speed = adapter->link_speed;
-	bool flow_rx, flow_tx;
+	/* set type for advanced descriptor with frame checksum insertion */
+	u32 cmd_type = TXGBE_TXD_DTYP_DATA |
+		       TXGBE_TXD_IFCS;
 
-	/* only continue if link was previously down */
-	if (netif_carrier_ok(netdev))
-		return;
+	/* set HW vlan bit if vlan is present */
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_HW_VLAN,
+				   TXGBE_TXD_VLE);
 
-	/* flow_rx, flow_tx report link flow control status */
-	flow_rx = (rd32(hw, TXGBE_MAC_RX_FLOW_CTRL) & 0x101) == 0x1;
-	flow_tx = !!(TXGBE_RDB_RFCC_RFCE_802_3X &
-		     rd32(hw, TXGBE_RDB_RFCC));
+	/* set segmentation enable bits for TSO/FSO */
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_TSO,
+				   TXGBE_TXD_TSE);
 
-	txgbe_info(drv, "NIC Link is Up %s, Flow Control: %s\n",
-		   (link_speed == TXGBE_LINK_SPEED_10GB_FULL ?
-		    "10 Gbps" :
-		    (link_speed == TXGBE_LINK_SPEED_1GB_FULL ?
-		     "1 Gbps" :
-		     (link_speed == TXGBE_LINK_SPEED_100_FULL ?
-		      "100 Mbps" :
-		      (link_speed == TXGBE_LINK_SPEED_10_FULL ?
-		       "10 Mbps" :
-		       "unknown speed")))),
-		  ((flow_rx && flow_tx) ? "RX/TX" :
-		   (flow_rx ? "RX" :
-		    (flow_tx ? "TX" : "None"))));
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_LINKSEC,
+				   TXGBE_TXD_LINKSEC);
 
-	netif_carrier_on(netdev);
+	return cmd_type;
 }
 
-/**
- * txgbe_watchdog_link_is_down - update netif_carrier status and
- *                               print link down message
- * @adapter - pointer to the adapter structure
- **/
-static void txgbe_watchdog_link_is_down(struct txgbe_adapter *adapter)
+static void txgbe_tx_olinfo_status(union txgbe_tx_desc *tx_desc,
+				   u32 tx_flags, unsigned int paylen)
 {
-	struct net_device *netdev = adapter->netdev;
-
-	adapter->link_up = false;
-	adapter->link_speed = 0;
+	u32 olinfo_status = paylen << TXGBE_TXD_PAYLEN_SHIFT;
+
+	/* enable L4 checksum for TSO and TX checksum offload */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_CSUM,
+					TXGBE_TXD_L4CS);
+
+	/* enable IPv4 checksum for TSO */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_IPV4,
+					TXGBE_TXD_IIPCS);
+	/* enable outer IPv4 checksum for TSO */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_OUTER_IPV4,
+					TXGBE_TXD_EIPCS);
+	/* Check Context must be set if Tx switch is enabled, which it
+	 * always is for case where virtual functions are running
+	 */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_CC,
+					TXGBE_TXD_CC);
 
-	/* only continue if link was up previously */
-	if (!netif_carrier_ok(netdev))
-		return;
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_IPSEC,
+					TXGBE_TXD_IPSEC);
 
-	txgbe_info(drv, "NIC Link is Down\n");
-	netif_carrier_off(netdev);
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 }
 
-/**
- * txgbe_watchdog_subtask - check and bring link up
- * @adapter - pointer to the device adapter structure
- **/
-static void txgbe_watchdog_subtask(struct txgbe_adapter *adapter)
+static int __txgbe_maybe_stop_tx(struct txgbe_ring *tx_ring, u16 size)
 {
-	/* if interface is down do nothing */
-	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
-	    test_bit(__TXGBE_REMOVING, &adapter->state) ||
-	    test_bit(__TXGBE_RESETTING, &adapter->state))
-		return;
+	netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
 
-	txgbe_watchdog_update_link(adapter);
+	/* Herbert's original patch had:
+	 *  smp_mb__after_netif_stop_queue();
+	 * but since that doesn't exist yet, just open code it.
+	 */
+	smp_mb();
 
-	if (adapter->link_up)
-		txgbe_watchdog_link_is_up(adapter);
-	else
-		txgbe_watchdog_link_is_down(adapter);
+	/* We need to check again in a case another CPU has just
+	 * made room available.
+	 */
+	if (likely(txgbe_desc_unused(tx_ring) < size))
+		return -EBUSY;
+
+	/* A reprieve! - use start_queue because it doesn't call schedule */
+	netif_start_subqueue(tx_ring->netdev, tx_ring->queue_index);
+	++tx_ring->tx_stats.restart_queue;
+	return 0;
 }
 
-/**
- * txgbe_sfp_detection_subtask - poll for SFP+ cable
- * @adapter - the txgbe adapter structure
- **/
-static void txgbe_sfp_detection_subtask(struct txgbe_adapter *adapter)
+static inline int txgbe_maybe_stop_tx(struct txgbe_ring *tx_ring, u16 size)
 {
-	struct txgbe_hw *hw = &adapter->hw;
-	struct txgbe_mac_info *mac = &hw->mac;
-	s32 err;
+	if (likely(txgbe_desc_unused(tx_ring) >= size))
+		return 0;
 
-	/* not searching for SFP so there is nothing to do here */
-	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
-		return;
+	return __txgbe_maybe_stop_tx(tx_ring, size);
+}
 
-	if (adapter->sfp_poll_time &&
-	    time_after(adapter->sfp_poll_time, jiffies))
-		return; /* If not yet time to poll for SFP */
+#define TXGBE_TXD_CMD (TXGBE_TXD_EOP | \
+		       TXGBE_TXD_RS)
 
-	/* someone else is in init, wait until next service event */
-	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
-		return;
+static int txgbe_tx_map(struct txgbe_ring *tx_ring,
+			struct txgbe_tx_buffer *first,
+			const u8 hdr_len)
+{
+	struct sk_buff *skb = first->skb;
+	struct txgbe_tx_buffer *tx_buffer;
+	union txgbe_tx_desc *tx_desc;
+	skb_frag_t *frag;
+	dma_addr_t dma;
+	unsigned int data_len, size;
+	u32 tx_flags = first->tx_flags;
+	u32 cmd_type = txgbe_tx_cmd_type(tx_flags);
+	u16 i = tx_ring->next_to_use;
 
-	adapter->sfp_poll_time = jiffies + TXGBE_SFP_POLL_JIFFIES - 1;
+	tx_desc = TXGBE_TX_DESC(tx_ring, i);
 
-	err = TCALL(hw, phy.ops.identify_sfp);
-	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED)
-		goto sfp_out;
+	txgbe_tx_olinfo_status(tx_desc, tx_flags, skb->len - hdr_len);
 
-	if (err == TXGBE_ERR_SFP_NOT_PRESENT) {
-		/* If no cable is present, then we need to reset
-		 * the next time we find a good cable.
-		 */
-		adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
-	}
+	size = skb_headlen(skb);
+	data_len = skb->data_len;
+
+	dma = dma_map_single(tx_ring->dev, skb->data, size, DMA_TO_DEVICE);
+
+	tx_buffer = first;
+
+	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
+		if (dma_mapping_error(tx_ring->dev, dma))
+			goto dma_error;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buffer, len, size);
+		dma_unmap_addr_set(tx_buffer, dma, dma);
+
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
+
+		while (unlikely(size > TXGBE_MAX_DATA_PER_TXD)) {
+			tx_desc->read.cmd_type_len =
+				cpu_to_le32(cmd_type ^ TXGBE_MAX_DATA_PER_TXD);
+
+			i++;
+			tx_desc++;
+			if (i == tx_ring->count) {
+				tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+				i = 0;
+			}
+			tx_desc->read.olinfo_status = 0;
+
+			dma += TXGBE_MAX_DATA_PER_TXD;
+			size -= TXGBE_MAX_DATA_PER_TXD;
+
+			tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		}
+
+		if (likely(!data_len))
+			break;
 
-	/* exit on error */
-	if (err)
-		goto sfp_out;
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type ^ size);
 
-	/* exit if reset not needed */
-	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
-		goto sfp_out;
+		i++;
+		tx_desc++;
+		if (i == tx_ring->count) {
+			tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+			i = 0;
+		}
+		tx_desc->read.olinfo_status = 0;
 
-	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+		size = skb_frag_size(frag);
 
-	if (hw->phy.multispeed_fiber) {
-		/* Set up dual speed SFP+ support */
-		mac->ops.setup_link = txgbe_setup_mac_link_multispeed_fiber;
-		mac->ops.setup_mac_link = txgbe_setup_mac_link;
-		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
-	} else {
-		mac->ops.setup_link = txgbe_setup_mac_link;
-		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
-		hw->phy.autoneg_advertised = 0;
+		data_len -= size;
+
+		dma = skb_frag_dma_map(tx_ring->dev, frag, 0, size,
+				       DMA_TO_DEVICE);
+
+		tx_buffer = &tx_ring->tx_buffer_info[i];
 	}
 
-	adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
-	txgbe_info(probe, "detected SFP+: %d\n", hw->phy.sfp_type);
+	/* write last descriptor with RS and EOP bits */
+	cmd_type |= size | TXGBE_TXD_CMD;
+	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 
-sfp_out:
-	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+	netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
 
-	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED && adapter->netdev_registered)
-		txgbe_dev_err("failed to initialize because an unsupported SFP+ module type was detected.\n");
-}
+	/* Force memory writes to complete before letting h/w know there
+	 * are new descriptors to fetch.  (Only applicable for weak-ordered
+	 * memory model archs, such as IA-64).
+	 *
+	 * We also need this memory barrier to make certain all of the
+	 * status bits have been updated before next_to_watch is written.
+	 */
+	wmb();
 
-/**
- * txgbe_sfp_link_config_subtask - set up link SFP after module install
- * @adapter - the txgbe adapter structure
- **/
-static void txgbe_sfp_link_config_subtask(struct txgbe_adapter *adapter)
-{
-	struct txgbe_hw *hw = &adapter->hw;
-	u32 speed;
-	bool autoneg = false;
-	u8 device_type = hw->subsystem_id & 0xF0;
+	/* set next_to_watch value indicating a packet is present */
+	first->next_to_watch = tx_desc;
 
-	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_CONFIG))
-		return;
+	i++;
+	if (i == tx_ring->count)
+		i = 0;
 
-	/* someone else is in init, wait until next service event */
-	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
-		return;
+	tx_ring->next_to_use = i;
 
-	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+	txgbe_maybe_stop_tx(tx_ring, DESC_NEEDED);
 
-	if (device_type == TXGBE_ID_MAC_SGMII) {
-		speed = TXGBE_LINK_SPEED_1GB_FULL;
-	} else {
-		speed = hw->phy.autoneg_advertised;
-		if (!speed && hw->mac.ops.get_link_capabilities) {
-			TCALL(hw, mac.ops.get_link_capabilities, &speed, &autoneg);
-			/* setup the highest link when no autoneg */
-			if (!autoneg) {
-				if (speed & TXGBE_LINK_SPEED_10GB_FULL)
-					speed = TXGBE_LINK_SPEED_10GB_FULL;
-			}
-		}
+	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
+		writel(i, tx_ring->tail);
+
+	return 0;
+dma_error:
+	dev_err(tx_ring->dev, "TX DMA map failed\n");
+
+	/* clear dma mappings for failed tx_buffer_info map */
+	for (;;) {
+		tx_buffer = &tx_ring->tx_buffer_info[i];
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_page(tx_ring->dev,
+				       dma_unmap_addr(tx_buffer, dma),
+				       dma_unmap_len(tx_buffer, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buffer, len, 0);
+		if (tx_buffer == first)
+			break;
+		if (i == 0)
+			i += tx_ring->count;
+		i--;
 	}
 
-	TCALL(hw, mac.ops.setup_link, speed, false);
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
 
-	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
-	adapter->link_check_timeout = jiffies;
-	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+	tx_ring->next_to_use = i;
+
+	return -1;
 }
 
 /**
- * txgbe_service_timer - Timer Call-back
- * @data: pointer to adapter cast into an unsigned long
- **/
-static void txgbe_service_timer(struct timer_list *t)
+ * skb_pad - zero pad the tail of an skb
+ * @skb: buffer to pad
+ * @pad: space to pad
+ *
+ * Ensure that a buffer is followed by a padding area that is zero
+ * filled. Used by network drivers which may DMA or transfer data
+ * beyond the buffer end onto the wire.
+ *
+ * May return error in out of memory cases. The skb is freed on error.
+ */
+
+int txgbe_skb_pad_nonzero(struct sk_buff *skb, int pad)
 {
-	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
-	unsigned long next_event_offset;
-	struct txgbe_hw *hw = &adapter->hw;
+	int err;
+	int ntail;
 
-	/* poll faster when waiting for link */
-	if (adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE) {
-		if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4)
-			next_event_offset = HZ;
-		else
-			next_event_offset = HZ / 10;
-	} else {
-		next_event_offset = HZ * 2;
+	/* If the skbuff is non linear tailroom is always zero. */
+	if (!skb_cloned(skb) && skb_tailroom(skb) >= pad) {
+		memset(skb->data + skb->len, 0x1, pad);
+		return 0;
 	}
 
-	/* Reset the timer */
-	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
+	ntail = skb->data_len + pad - (skb->end - skb->tail);
+	if (likely(skb_cloned(skb) || ntail > 0)) {
+		err = pskb_expand_head(skb, 0, ntail, GFP_ATOMIC);
+		if (unlikely(err))
+			goto free_skb;
+	}
 
-	txgbe_service_event_schedule(adapter);
-}
+	/* The use of this function with non-linear skb's really needs
+	 * to be audited.
+	 */
+	err = skb_linearize(skb);
+	if (unlikely(err))
+		goto free_skb;
 
-static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
-{
-	u32 reset_flag = 0;
-	u32 value = 0;
+	memset(skb->data + skb->len, 0x1, pad);
+	return 0;
 
-	if (!(adapter->flags2 & (TXGBE_FLAG2_PF_RESET_REQUESTED |
-				 TXGBE_FLAG2_GLOBAL_RESET_REQUESTED |
-				 TXGBE_FLAG2_RESET_INTR_RECEIVED)))
-		return;
+free_skb:
+	kfree_skb(skb);
+	return err;
+}
 
-	/* If we're already down, just bail */
-	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
-	    test_bit(__TXGBE_REMOVING, &adapter->state))
-		return;
+netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
+				  struct txgbe_adapter __maybe_unused *adapter,
+				  struct txgbe_ring *tx_ring)
+{
+	struct txgbe_tx_buffer *first;
+	int tso;
+	u32 tx_flags = 0;
+	unsigned short f;
+	u16 count = TXD_USE_COUNT(skb_headlen(skb));
+	__be16 protocol = skb->protocol;
+	u8 hdr_len = 0;
+	struct txgbe_dptype dptype;
+	u8 vlan_addlen = 0;
+
+	/* work around hw errata 3 */
+	u16 _llclen, *llclen;
+
+	llclen = skb_header_pointer(skb, ETH_HLEN - 2, sizeof(u16), &_llclen);
+	if (*llclen == 0x3 || *llclen == 0x4 || *llclen == 0x5) {
+		if (txgbe_skb_pad_nonzero(skb, ETH_ZLEN - skb->len))
+			return -ENOMEM;
+		__skb_put(skb, ETH_ZLEN - skb->len);
+	}
 
-	netdev_err(adapter->netdev, "Reset adapter\n");
+	/* need: 1 descriptor per page * PAGE_SIZE/TXGBE_MAX_DATA_PER_TXD,
+	 *       + 1 desc for skb_headlen/TXGBE_MAX_DATA_PER_TXD,
+	 *       + 2 desc gap to keep tail from touching head,
+	 *       + 1 desc for context descriptor,
+	 * otherwise try next time
+	 */
+	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+		count += TXD_USE_COUNT(skb_frag_size(&skb_shinfo(skb)->
+						     frags[f]));
 
-	rtnl_lock();
-	if (adapter->flags2 & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
-		reset_flag |= TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
-		adapter->flags2 &= ~TXGBE_FLAG2_GLOBAL_RESET_REQUESTED;
+	if (txgbe_maybe_stop_tx(tx_ring, count + 3)) {
+		tx_ring->tx_stats.tx_busy++;
+		return NETDEV_TX_BUSY;
 	}
-	if (adapter->flags2 & TXGBE_FLAG2_PF_RESET_REQUESTED) {
-		reset_flag |= TXGBE_FLAG2_PF_RESET_REQUESTED;
-		adapter->flags2 &= ~TXGBE_FLAG2_PF_RESET_REQUESTED;
+
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	first->skb = skb;
+	first->bytecount = skb->len;
+	first->gso_segs = 1;
+
+	/* if we have a HW VLAN tag being added default to the HW one */
+	if (skb_vlan_tag_present(skb)) {
+		tx_flags |= skb_vlan_tag_get(skb) << TXGBE_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= TXGBE_TX_FLAGS_HW_VLAN;
+	/* else if it is a SW VLAN check the next protocol and store the tag */
+	} else if (protocol == htons(ETH_P_8021Q)) {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
+		if (!vhdr)
+			goto out_drop;
+
+		protocol = vhdr->h_vlan_encapsulated_proto;
+		tx_flags |= ntohs(vhdr->h_vlan_TCI) <<
+				  TXGBE_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= TXGBE_TX_FLAGS_SW_VLAN;
 	}
 
-	if (adapter->flags2 & TXGBE_FLAG2_RESET_INTR_RECEIVED) {
-		/* If there's a recovery already waiting, it takes
-		 * precedence before starting a new reset sequence.
-		 */
-		adapter->flags2 &= ~TXGBE_FLAG2_RESET_INTR_RECEIVED;
-		value = rd32m(&adapter->hw, TXGBE_MIS_RST_ST,
-			      TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK) >>
-			TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT;
-		if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST) {
-			adapter->hw.reset_type = TXGBE_SW_RESET;
-			/* errata 7 */
-			if (txgbe_mng_present(&adapter->hw) &&
-			    adapter->hw.revision_id == TXGBE_SP_MPW)
-				adapter->flags2 |=
-					TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED;
-		} else if (value == TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST) {
-			adapter->hw.reset_type = TXGBE_GLOBAL_RESET;
-		}
-		adapter->hw.force_full_reset = true;
-		txgbe_reinit_locked(adapter);
-		adapter->hw.force_full_reset = false;
-		goto unlock;
+	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD)) {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
+		if (!vhdr)
+			goto out_drop;
+
+		protocol = vhdr->h_vlan_encapsulated_proto;
+		tx_flags |= TXGBE_TX_FLAGS_SW_VLAN;
+		vlan_addlen += VLAN_HLEN;
 	}
 
-	if (reset_flag & TXGBE_FLAG2_PF_RESET_REQUESTED) {
-		/*debug to up*/
-		txgbe_reinit_locked(adapter);
-	} else if (reset_flag & TXGBE_FLAG2_GLOBAL_RESET_REQUESTED) {
-		/* Request a Global Reset
-		 *
-		 * This will start the chip's countdown to the actual full
-		 * chip reset event, and a warning interrupt to be sent
-		 * to all PFs, including the requestor.  Our handler
-		 * for the warning interrupt will deal with the shutdown
-		 * and recovery of the switch setup.
-		 */
-		/*debug to up*/
-		pci_save_state(adapter->pdev);
-		if (txgbe_mng_present(&adapter->hw))
-			txgbe_reset_hostif(&adapter->hw);
-		else
-			wr32m(&adapter->hw, TXGBE_MIS_RST,
-			      TXGBE_MIS_RST_GLOBAL_RST,
-			      TXGBE_MIS_RST_GLOBAL_RST);
+	/* record initial flags and protocol */
+	first->tx_flags = tx_flags;
+	first->protocol = protocol;
+
+	dptype = encode_tx_desc_ptype(first);
+
+	tso = txgbe_tso(tx_ring, first, &hdr_len, dptype);
+	if (tso < 0)
+		goto out_drop;
+	else if (!tso)
+		txgbe_tx_csum(tx_ring, first, dptype);
+
+	txgbe_tx_map(tx_ring, first, hdr_len);
+
+	return NETDEV_TX_OK;
+
+out_drop:
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
+
+	return NETDEV_TX_OK;
+}
+
+static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_ring *tx_ring;
+	unsigned int r_idx = skb->queue_mapping;
+
+	if (!netif_carrier_ok(netdev)) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
 	}
 
-unlock:
-	rtnl_unlock();
+	/* The minimum packet size for olinfo paylen is 17 so pad the skb
+	 * in order to meet this minimum size requirement.
+	 */
+	if (skb_put_padto(skb, 17))
+		return NETDEV_TX_OK;
+
+	if (r_idx >= adapter->num_tx_queues)
+		r_idx = r_idx % adapter->num_tx_queues;
+	tx_ring = adapter->tx_ring[r_idx];
+
+	return txgbe_xmit_frame_ring(skb, adapter, tx_ring);
 }
 
 /**
- * txgbe_service_task - manages and runs subtasks
- * @work: pointer to work_struct containing our data
+ * txgbe_set_mac - Change the Ethernet Address of the NIC
+ * @netdev: network interface device structure
+ * @p: pointer to an address structure
+ *
+ * Returns 0 on success, negative on failure
  **/
-static void txgbe_service_task(struct work_struct *work)
+static int txgbe_set_mac(struct net_device *netdev, void *p)
 {
-	struct txgbe_adapter *adapter = container_of(work,
-						     struct txgbe_adapter,
-						     service_task);
-	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
-		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
-			rtnl_lock();
-			txgbe_down(adapter);
-			rtnl_unlock();
-		}
-		txgbe_service_event_complete(adapter);
-		return;
-	}
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	struct sockaddr *addr = p;
 
-	txgbe_reset_subtask(adapter);
-	txgbe_sfp_detection_subtask(adapter);
-	txgbe_sfp_link_config_subtask(adapter);
-	txgbe_check_overtemp_subtask(adapter);
-	txgbe_watchdog_subtask(adapter);
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
 
-	txgbe_service_event_complete(adapter);
+	txgbe_del_mac_filter(adapter, hw->mac.addr, 0);
+	eth_hw_addr_set(netdev, addr->sa_data);
+	memcpy(hw->mac.addr, addr->sa_data, netdev->addr_len);
+
+	txgbe_mac_set_default_filter(adapter, hw->mac.addr);
+
+	return 0;
 }
 
 /**
@@ -1613,9 +5286,153 @@ static int txgbe_del_sanmac_netdev(struct net_device *dev)
 	return err;
 }
 
+void txgbe_do_reset(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	if (netif_running(netdev))
+		txgbe_reinit_locked(adapter);
+	else
+		txgbe_reset(adapter);
+}
+
+static netdev_features_t txgbe_fix_features(struct net_device *netdev,
+					    netdev_features_t features)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
+	if (!(features & NETIF_F_RXCSUM))
+		features &= ~NETIF_F_LRO;
+
+	/* Turn off LRO if not RSC capable */
+	if (!(adapter->flags2 & TXGBE_FLAG2_RSC_CAPABLE))
+		features &= ~NETIF_F_LRO;
+
+	return features;
+}
+
+static int txgbe_set_features(struct net_device *netdev,
+			      netdev_features_t features)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	bool need_reset = false;
+
+	/* Make sure RSC matches LRO, reset if change */
+	if (!(features & NETIF_F_LRO)) {
+		if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
+			need_reset = true;
+		adapter->flags2 &= ~TXGBE_FLAG2_RSC_ENABLED;
+	} else if ((adapter->flags2 & TXGBE_FLAG2_RSC_CAPABLE) &&
+		   !(adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)) {
+		if (adapter->rx_itr_setting == 1 ||
+		    adapter->rx_itr_setting > TXGBE_MIN_RSC_ITR) {
+			adapter->flags2 |= TXGBE_FLAG2_RSC_ENABLED;
+			need_reset = true;
+		} else if ((netdev->features ^ features) & NETIF_F_LRO) {
+			txgbe_info(probe, "rx-usecs set too low, disabling RSC\n");
+		}
+	}
+
+	if (features & NETIF_F_HW_VLAN_CTAG_RX)
+		txgbe_vlan_strip_enable(adapter);
+	else
+		txgbe_vlan_strip_disable(adapter);
+
+	if (!(adapter->flags & TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE &&
+	      features & NETIF_F_RXCSUM))
+		txgbe_clear_vxlan_port(adapter);
+
+	if (features & NETIF_F_RXHASH) {
+		if (!(adapter->flags2 & TXGBE_FLAG2_RSS_ENABLED)) {
+			wr32m(&adapter->hw, TXGBE_RDB_RA_CTL,
+			      TXGBE_RDB_RA_CTL_RSS_EN, TXGBE_RDB_RA_CTL_RSS_EN);
+			adapter->flags2 |= TXGBE_FLAG2_RSS_ENABLED;
+		}
+	} else {
+		if (adapter->flags2 & TXGBE_FLAG2_RSS_ENABLED) {
+			wr32m(&adapter->hw, TXGBE_RDB_RA_CTL,
+			      TXGBE_RDB_RA_CTL_RSS_EN, ~TXGBE_RDB_RA_CTL_RSS_EN);
+			adapter->flags2 &= ~TXGBE_FLAG2_RSS_ENABLED;
+		}
+	}
+
+	if (need_reset)
+		txgbe_do_reset(netdev);
+
+	return 0;
+}
+
+static int txgbe_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
+			     struct net_device *dev,
+			     const unsigned char *addr,
+			     u16 vid,
+			     u16 flags,
+			     struct netlink_ext_ack *extack)
+{
+	/* guarantee we can provide a unique filter for the unicast address */
+	if (is_unicast_ether_addr(addr) || is_link_local_ether_addr(addr)) {
+		if (netdev_uc_count(dev) >= TXGBE_MAX_PF_MACVLANS)
+			return -ENOMEM;
+	}
+
+	return ndo_dflt_fdb_add(ndm, tb, dev, addr, vid, flags);
+}
+
+#define TXGBE_MAX_TUNNEL_HDR_LEN 80
+static netdev_features_t
+txgbe_features_check(struct sk_buff *skb, struct net_device *dev,
+		     netdev_features_t features)
+{
+	u32 vlan_num = 0;
+	u16 vlan_depth = skb->mac_len;
+	__be16 type = skb->protocol;
+	struct vlan_hdr *vh;
+
+	if (skb_vlan_tag_present(skb))
+		vlan_num++;
+
+	if (vlan_depth)
+		vlan_depth -= VLAN_HLEN;
+	else
+		vlan_depth = ETH_HLEN;
+
+	while (type == htons(ETH_P_8021Q) || type == htons(ETH_P_8021AD)) {
+		vlan_num++;
+		vh = (struct vlan_hdr *)(skb->data + vlan_depth);
+		type = vh->h_vlan_encapsulated_proto;
+		vlan_depth += VLAN_HLEN;
+	}
+
+	if (vlan_num > 2)
+		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
+			    NETIF_F_HW_VLAN_STAG_TX);
+
+	if (skb->encapsulation) {
+		if (unlikely(skb_inner_mac_header(skb) -
+			     skb_transport_header(skb) >
+			     TXGBE_MAX_TUNNEL_HDR_LEN))
+			return features & ~NETIF_F_CSUM_MASK;
+	}
+	return features;
+}
+
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
+	.ndo_start_xmit         = txgbe_xmit_frame,
+	.ndo_set_rx_mode        = txgbe_set_rx_mode,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = txgbe_set_mac,
+	.ndo_change_mtu		= txgbe_change_mtu,
+	.ndo_tx_timeout         = txgbe_tx_timeout,
+	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
+	.ndo_get_stats64        = txgbe_get_stats64,
+	.ndo_fdb_add            = txgbe_ndo_fdb_add,
+	.ndo_features_check     = txgbe_features_check,
+	.ndo_set_features       = txgbe_set_features,
+	.ndo_fix_features       = txgbe_fix_features,
 };
 
 void txgbe_assign_netdev_ops(struct net_device *dev)
@@ -1647,6 +5464,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
 	u32 etrack_id = 0;
 	u16 build = 0, major = 0, patch = 0;
+	char *info_string, *i_s_var;
 	u8 part_str[TXGBE_PBANUM_LENGTH];
 	unsigned int indices = MAX_TX_QUEUES;
 	bool disable_dev = false;
@@ -1755,6 +5573,52 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 	}
 
+	netdev->features = NETIF_F_SG |
+			   NETIF_F_LRO |
+			   NETIF_F_TSO |
+			   NETIF_F_TSO6 |
+			   NETIF_F_RXHASH |
+			   NETIF_F_RXCSUM |
+			   NETIF_F_HW_CSUM |
+			   NETIF_F_SCTP_CRC;
+
+	netdev->gso_partial_features = TXGBE_GSO_PARTIAL_FEATURES;
+	netdev->features |= NETIF_F_GSO_PARTIAL |
+			    TXGBE_GSO_PARTIAL_FEATURES;
+
+	/* copy netdev features into list of user selectable features */
+	netdev->hw_features |= netdev->features |
+			       NETIF_F_HW_VLAN_CTAG_FILTER |
+			       NETIF_F_HW_VLAN_CTAG_RX |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_RXALL;
+
+	netdev->hw_features |= NETIF_F_NTUPLE;
+
+	if (pci_using_dac)
+		netdev->features |= NETIF_F_HIGHDMA;
+
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->mpls_features |= NETIF_F_HW_CSUM;
+
+	/* set this bit last since it cannot be part of vlan_features */
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			    NETIF_F_HW_VLAN_CTAG_RX |
+			    NETIF_F_HW_VLAN_CTAG_TX;
+
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_SUPP_NOFCS;
+
+	/* give us the option of enabling RSC/LRO later */
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_CAPABLE) {
+		netdev->hw_features |= NETIF_F_LRO;
+		adapter->flags2 |= TXGBE_FLAG2_RSC_ENABLED;
+	}
+
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+
 	/* make sure the EEPROM is good */
 	if (TCALL(hw, eeprom.ops.validate_checksum, NULL)) {
 		txgbe_dev_err("The EEPROM Checksum Is Not Valid\n");
@@ -1848,6 +5712,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
 
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
@@ -1882,6 +5747,26 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       netdev->dev_addr[2], netdev->dev_addr[3],
 		       netdev->dev_addr[4], netdev->dev_addr[5]);
 
+#define INFO_STRING_LEN 255
+	info_string = kzalloc(INFO_STRING_LEN, GFP_KERNEL);
+	if (!info_string) {
+		txgbe_err(probe, "allocation for info string failed\n");
+		goto no_info_string;
+	}
+	i_s_var = info_string;
+	i_s_var += sprintf(info_string, "Enabled Features: ");
+	i_s_var += sprintf(i_s_var, "RxQ: %d TxQ: %d ",
+			   adapter->num_rx_queues, adapter->num_tx_queues);
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
+		i_s_var += sprintf(i_s_var, "RSC ");
+	if (adapter->flags & TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE)
+		i_s_var += sprintf(i_s_var, "vxlan_rx ");
+
+	BUG_ON(i_s_var > (info_string + INFO_STRING_LEN));
+	/* end features printing */
+	txgbe_info(probe, "%s\n", info_string);
+	kfree(info_string);
+no_info_string:
 	/* firmware requires blank driver version */
 	TCALL(hw, mac.ops.set_fw_drv_ver, 0xFF, 0xFF, 0xFF, 0xFF);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ff2b7a4f028b..c673c5d86b1a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -1683,6 +1683,282 @@ enum TXGBE_MSCA_CMD_value {
 #define TXGBE_PCIDEVCTRL2_4_8s          0xd
 #define TXGBE_PCIDEVCTRL2_17_34s        0xe
 
+/******************* Receive Descriptor bit definitions **********************/
+#define TXGBE_RXD_NEXTP_MASK            0x000FFFF0U /* Next Descriptor Index */
+#define TXGBE_RXD_NEXTP_SHIFT           0x00000004U
+#define TXGBE_RXD_STAT_MASK             0x000fffffU /* Stat/NEXTP: bit 0-19 */
+#define TXGBE_RXD_STAT_DD               0x00000001U /* Done */
+#define TXGBE_RXD_STAT_EOP              0x00000002U /* End of Packet */
+#define TXGBE_RXD_STAT_CLASS_ID_MASK    0x0000001CU
+#define TXGBE_RXD_STAT_CLASS_ID_TC_RSS  0x00000000U
+#define TXGBE_RXD_STAT_CLASS_ID_FLM     0x00000004U /* FDir Match */
+#define TXGBE_RXD_STAT_CLASS_ID_SYN     0x00000008U
+#define TXGBE_RXD_STAT_CLASS_ID_5_TUPLE 0x0000000CU
+#define TXGBE_RXD_STAT_CLASS_ID_L2_ETYPE 0x00000010U
+#define TXGBE_RXD_STAT_VP               0x00000020U /* IEEE VLAN Pkt */
+#define TXGBE_RXD_STAT_UDPCS            0x00000040U /* UDP xsum calculated */
+#define TXGBE_RXD_STAT_L4CS             0x00000080U /* L4 xsum calculated */
+#define TXGBE_RXD_STAT_IPCS             0x00000100U /* IP xsum calculated */
+#define TXGBE_RXD_STAT_PIF              0x00000200U /* passed in-exact filter */
+#define TXGBE_RXD_STAT_OUTERIPCS        0x00000400U /* Cloud IP xsum calculated*/
+#define TXGBE_RXD_STAT_VEXT             0x00000800U /* 1st VLAN found */
+#define TXGBE_RXD_STAT_LLINT            0x00002000U /* Pkt caused Low Latency Int */
+#define TXGBE_RXD_STAT_TS               0x00004000U /* IEEE1588 Time Stamp */
+#define TXGBE_RXD_STAT_SECP             0x00008000U /* Security Processing */
+#define TXGBE_RXD_STAT_LB               0x00010000U /* Loopback Status */
+#define TXGBE_RXD_STAT_FCEOFS           0x00020000U /* FCoE EOF/SOF Stat */
+#define TXGBE_RXD_STAT_FCSTAT           0x000C0000U /* FCoE Pkt Stat */
+#define TXGBE_RXD_STAT_FCSTAT_NOMTCH    0x00000000U /* 00: No Ctxt Match */
+#define TXGBE_RXD_STAT_FCSTAT_NODDP     0x00040000U /* 01: Ctxt w/o DDP */
+#define TXGBE_RXD_STAT_FCSTAT_FCPRSP    0x00080000U /* 10: Recv. FCP_RSP */
+#define TXGBE_RXD_STAT_FCSTAT_DDP       0x000C0000U /* 11: Ctxt w/ DDP */
+
+#define TXGBE_RXD_ERR_MASK              0xfff00000U /* RDESC.ERRORS mask */
+#define TXGBE_RXD_ERR_SHIFT             20         /* RDESC.ERRORS shift */
+#define TXGBE_RXD_ERR_FCEOFE            0x80000000U /* FCEOFe/IPE */
+#define TXGBE_RXD_ERR_FCERR             0x00700000U /* FCERR/FDIRERR */
+#define TXGBE_RXD_ERR_FDIR_LEN          0x00100000U /* FDIR Length error */
+#define TXGBE_RXD_ERR_FDIR_DROP         0x00200000U /* FDIR Drop error */
+#define TXGBE_RXD_ERR_FDIR_COLL         0x00400000U /* FDIR Collision error */
+#define TXGBE_RXD_ERR_HBO               0x00800000U /*Header Buffer Overflow */
+#define TXGBE_RXD_ERR_OUTERIPER         0x04000000U /* CRC IP Header error */
+#define TXGBE_RXD_ERR_SECERR_MASK       0x18000000U
+#define TXGBE_RXD_ERR_RXE               0x20000000U /* Any MAC Error */
+#define TXGBE_RXD_ERR_TCPE              0x40000000U /* TCP/UDP Checksum Error */
+#define TXGBE_RXD_ERR_IPE               0x80000000U /* IP Checksum Error */
+
+#define TXGBE_RXD_RSSTYPE_MASK          0x0000000FU
+#define TXGBE_RXD_TPID_MASK             0x000001C0U
+#define TXGBE_RXD_TPID_SHIFT            6
+#define TXGBE_RXD_HDRBUFLEN_MASK        0x00007FE0U
+#define TXGBE_RXD_RSCCNT_MASK           0x001E0000U
+#define TXGBE_RXD_RSCCNT_SHIFT          17
+#define TXGBE_RXD_HDRBUFLEN_SHIFT       5
+#define TXGBE_RXD_SPLITHEADER_EN        0x00001000U
+#define TXGBE_RXD_SPH                   0x8000
+
+/* RSS Hash results */
+#define TXGBE_RXD_RSSTYPE_NONE          0x00000000U
+#define TXGBE_RXD_RSSTYPE_IPV4_TCP      0x00000001U
+#define TXGBE_RXD_RSSTYPE_IPV4          0x00000002U
+#define TXGBE_RXD_RSSTYPE_IPV6_TCP      0x00000003U
+#define TXGBE_RXD_RSSTYPE_IPV4_SCTP     0x00000004U
+#define TXGBE_RXD_RSSTYPE_IPV6          0x00000005U
+#define TXGBE_RXD_RSSTYPE_IPV6_SCTP     0x00000006U
+#define TXGBE_RXD_RSSTYPE_IPV4_UDP      0x00000007U
+#define TXGBE_RXD_RSSTYPE_IPV6_UDP      0x00000008U
+
+/**
+ * receive packet type
+ * PTYPE:8 = TUN:2 + PKT:2 + TYP:4
+ **/
+/* TUN */
+#define TXGBE_PTYPE_TUN_IPV4            (0x80)
+#define TXGBE_PTYPE_TUN_IPV6            (0xC0)
+
+/* PKT for TUN */
+#define TXGBE_PTYPE_PKT_IPIP            (0x00) /* IP+IP */
+#define TXGBE_PTYPE_PKT_IG              (0x10) /* IP+GRE */
+#define TXGBE_PTYPE_PKT_IGM             (0x20) /* IP+GRE+MAC */
+#define TXGBE_PTYPE_PKT_IGMV            (0x30) /* IP+GRE+MAC+VLAN */
+/* PKT for !TUN */
+#define TXGBE_PTYPE_PKT_MAC             (0x10)
+#define TXGBE_PTYPE_PKT_IP              (0x20)
+#define TXGBE_PTYPE_PKT_FCOE            (0x30)
+
+/* TYP for PKT=mac */
+#define TXGBE_PTYPE_TYP_MAC             (0x01)
+#define TXGBE_PTYPE_TYP_TS              (0x02) /* time sync */
+#define TXGBE_PTYPE_TYP_FIP             (0x03)
+#define TXGBE_PTYPE_TYP_LLDP            (0x04)
+#define TXGBE_PTYPE_TYP_CNM             (0x05)
+#define TXGBE_PTYPE_TYP_EAPOL           (0x06)
+#define TXGBE_PTYPE_TYP_ARP             (0x07)
+/* TYP for PKT=ip */
+#define TXGBE_PTYPE_PKT_IPV6            (0x08)
+#define TXGBE_PTYPE_TYP_IPFRAG          (0x01)
+#define TXGBE_PTYPE_TYP_IP              (0x02)
+#define TXGBE_PTYPE_TYP_UDP             (0x03)
+#define TXGBE_PTYPE_TYP_TCP             (0x04)
+#define TXGBE_PTYPE_TYP_SCTP            (0x05)
+/* TYP for PKT=fcoe */
+#define TXGBE_PTYPE_PKT_VFT             (0x08)
+#define TXGBE_PTYPE_TYP_FCOE            (0x00)
+#define TXGBE_PTYPE_TYP_FCDATA          (0x01)
+#define TXGBE_PTYPE_TYP_FCRDY           (0x02)
+#define TXGBE_PTYPE_TYP_FCRSP           (0x03)
+#define TXGBE_PTYPE_TYP_FCOTHER         (0x04)
+
+/* Packet type non-ip values */
+enum txgbe_l2_ptypes {
+	TXGBE_PTYPE_L2_ABORTED = (TXGBE_PTYPE_PKT_MAC),
+	TXGBE_PTYPE_L2_MAC = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_MAC),
+	TXGBE_PTYPE_L2_TS = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_TS),
+	TXGBE_PTYPE_L2_FIP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_FIP),
+	TXGBE_PTYPE_L2_LLDP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_LLDP),
+	TXGBE_PTYPE_L2_CNM = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_CNM),
+	TXGBE_PTYPE_L2_EAPOL = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_EAPOL),
+	TXGBE_PTYPE_L2_ARP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_ARP),
+
+	TXGBE_PTYPE_L2_IPV4_FRAG = (TXGBE_PTYPE_PKT_IP |
+				    TXGBE_PTYPE_TYP_IPFRAG),
+	TXGBE_PTYPE_L2_IPV4 = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_IP),
+	TXGBE_PTYPE_L2_IPV4_UDP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_UDP),
+	TXGBE_PTYPE_L2_IPV4_TCP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_TCP),
+	TXGBE_PTYPE_L2_IPV4_SCTP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_SCTP),
+	TXGBE_PTYPE_L2_IPV6_FRAG = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				    TXGBE_PTYPE_TYP_IPFRAG),
+	TXGBE_PTYPE_L2_IPV6 = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+			       TXGBE_PTYPE_TYP_IP),
+	TXGBE_PTYPE_L2_IPV6_UDP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				   TXGBE_PTYPE_TYP_UDP),
+	TXGBE_PTYPE_L2_IPV6_TCP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				   TXGBE_PTYPE_TYP_TCP),
+	TXGBE_PTYPE_L2_IPV6_SCTP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				    TXGBE_PTYPE_TYP_SCTP),
+
+	TXGBE_PTYPE_L2_FCOE = (TXGBE_PTYPE_PKT_FCOE | TXGBE_PTYPE_TYP_FCOE),
+	TXGBE_PTYPE_L2_FCOE_FCDATA = (TXGBE_PTYPE_PKT_FCOE |
+				      TXGBE_PTYPE_TYP_FCDATA),
+	TXGBE_PTYPE_L2_FCOE_FCRDY = (TXGBE_PTYPE_PKT_FCOE |
+				     TXGBE_PTYPE_TYP_FCRDY),
+	TXGBE_PTYPE_L2_FCOE_FCRSP = (TXGBE_PTYPE_PKT_FCOE |
+				     TXGBE_PTYPE_TYP_FCRSP),
+	TXGBE_PTYPE_L2_FCOE_FCOTHER = (TXGBE_PTYPE_PKT_FCOE |
+				       TXGBE_PTYPE_TYP_FCOTHER),
+	TXGBE_PTYPE_L2_FCOE_VFT = (TXGBE_PTYPE_PKT_FCOE | TXGBE_PTYPE_PKT_VFT),
+	TXGBE_PTYPE_L2_FCOE_VFT_FCDATA = (TXGBE_PTYPE_PKT_FCOE |
+				TXGBE_PTYPE_PKT_VFT | TXGBE_PTYPE_TYP_FCDATA),
+	TXGBE_PTYPE_L2_FCOE_VFT_FCRDY = (TXGBE_PTYPE_PKT_FCOE |
+				TXGBE_PTYPE_PKT_VFT | TXGBE_PTYPE_TYP_FCRDY),
+	TXGBE_PTYPE_L2_FCOE_VFT_FCRSP = (TXGBE_PTYPE_PKT_FCOE |
+				TXGBE_PTYPE_PKT_VFT | TXGBE_PTYPE_TYP_FCRSP),
+	TXGBE_PTYPE_L2_FCOE_VFT_FCOTHER = (TXGBE_PTYPE_PKT_FCOE |
+				TXGBE_PTYPE_PKT_VFT | TXGBE_PTYPE_TYP_FCOTHER),
+
+	TXGBE_PTYPE_L2_TUN4_MAC = (TXGBE_PTYPE_TUN_IPV4 | TXGBE_PTYPE_PKT_IGM),
+	TXGBE_PTYPE_L2_TUN6_MAC = (TXGBE_PTYPE_TUN_IPV6 | TXGBE_PTYPE_PKT_IGM),
+};
+
+#define TXGBE_RXD_PKTTYPE(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
+#define TXGBE_PTYPE_TUN(_pt) ((_pt) & 0xC0)
+#define TXGBE_PTYPE_PKT(_pt) ((_pt) & 0x30)
+#define TXGBE_PTYPE_TYP(_pt) ((_pt) & 0x0F)
+#define TXGBE_PTYPE_TYPL4(_pt) ((_pt) & 0x07)
+
+#define TXGBE_RXD_IPV6EX(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
+
+/* Masks to determine if packets should be dropped due to frame errors */
+#define TXGBE_RXD_ERR_FRAME_ERR_MASK    TXGBE_RXD_ERR_RXE
+
+/*********************** Transmit Descriptor Config Masks ****************/
+#define TXGBE_TXD_DTALEN_MASK           0x0000FFFFU /* Data buf length(bytes) */
+#define TXGBE_TXD_MAC_LINKSEC           0x00040000U /* Insert LinkSec */
+#define TXGBE_TXD_MAC_TSTAMP            0x00080000U /* IEEE1588 time stamp */
+#define TXGBE_TXD_IPSEC_SA_INDEX_MASK   0x000003FFU /* IPSec SA index */
+#define TXGBE_TXD_IPSEC_ESP_LEN_MASK    0x000001FFU /* IPSec ESP length */
+#define TXGBE_TXD_DTYP_MASK             0x00F00000U /* DTYP mask */
+#define TXGBE_TXD_DTYP_CTXT             0x00100000U /* Adv Context Desc */
+#define TXGBE_TXD_DTYP_DATA             0x00000000U /* Adv Data Descriptor */
+#define TXGBE_TXD_EOP                   0x01000000U  /* End of Packet */
+#define TXGBE_TXD_IFCS                  0x02000000U /* Insert FCS */
+#define TXGBE_TXD_LINKSEC               0x04000000U /* Enable linksec */
+#define TXGBE_TXD_RS                    0x08000000U /* Report Status */
+#define TXGBE_TXD_ECU                   0x10000000U /* DDP hdr type or iSCSI */
+#define TXGBE_TXD_QCN                   0x20000000U /* cntag insertion enable */
+#define TXGBE_TXD_VLE                   0x40000000U /* VLAN pkt enable */
+#define TXGBE_TXD_TSE                   0x80000000U /* TCP Seg enable */
+#define TXGBE_TXD_STAT_DD               0x00000001U /* Descriptor Done */
+#define TXGBE_TXD_IDX_SHIFT             4 /* Desc Index shift */
+#define TXGBE_TXD_CC                    0x00000080U /* Check Context */
+#define TXGBE_TXD_IPSEC                 0x00000100U /* Enable ipsec esp */
+#define TXGBE_TXD_IIPCS                 0x00000400U
+#define TXGBE_TXD_EIPCS                 0x00000800U
+#define TXGBE_TXD_L4CS                  0x00000200U
+#define TXGBE_TXD_PAYLEN_SHIFT          13 /* Desc PAYLEN shift */
+#define TXGBE_TXD_MACLEN_SHIFT          9  /* ctxt desc mac len shift */
+#define TXGBE_TXD_VLAN_SHIFT            16 /* ctxt vlan tag shift */
+#define TXGBE_TXD_TAG_TPID_SEL_SHIFT    11
+#define TXGBE_TXD_IPSEC_TYPE_SHIFT      14
+#define TXGBE_TXD_ENC_SHIFT             15
+
+#define TXGBE_TXD_TUCMD_IPSEC_TYPE_ESP  0x00004000U /* IPSec Type ESP */
+#define TXGBE_TXD_TUCMD_IPSEC_ENCRYPT_EN 0x00008000/* ESP Encrypt Enable */
+#define TXGBE_TXD_TUCMD_FCOE            0x00010000U /* FCoE Frame Type */
+#define TXGBE_TXD_FCOEF_EOF_MASK        (0x3 << 10) /* FC EOF index */
+#define TXGBE_TXD_FCOEF_SOF             ((1 << 2) << 10) /* FC SOF index */
+#define TXGBE_TXD_FCOEF_PARINC          ((1 << 3) << 10) /* Rel_Off in F_CTL */
+#define TXGBE_TXD_FCOEF_ORIE            ((1 << 4) << 10) /* Orientation End */
+#define TXGBE_TXD_FCOEF_ORIS            ((1 << 5) << 10) /* Orientation Start */
+#define TXGBE_TXD_FCOEF_EOF_N           (0x0 << 10) /* 00: EOFn */
+#define TXGBE_TXD_FCOEF_EOF_T           (0x1 << 10) /* 01: EOFt */
+#define TXGBE_TXD_FCOEF_EOF_NI          (0x2 << 10) /* 10: EOFni */
+#define TXGBE_TXD_FCOEF_EOF_A           (0x3 << 10) /* 11: EOFa */
+#define TXGBE_TXD_L4LEN_SHIFT           8  /* ctxt L4LEN shift */
+#define TXGBE_TXD_MSS_SHIFT             16  /* ctxt MSS shift */
+
+#define TXGBE_TXD_OUTER_IPLEN_SHIFT     12 /* ctxt OUTERIPLEN shift */
+#define TXGBE_TXD_TUNNEL_LEN_SHIFT      21 /* ctxt TUNNELLEN shift */
+#define TXGBE_TXD_TUNNEL_TYPE_SHIFT     11 /* Tx Desc Tunnel Type shift */
+#define TXGBE_TXD_TUNNEL_DECTTL_SHIFT   27 /* ctxt DECTTL shift */
+#define TXGBE_TXD_TUNNEL_UDP            (0x0ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
+#define TXGBE_TXD_TUNNEL_GRE            (0x1ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
+
+/* Transmit Descriptor */
+union txgbe_tx_desc {
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
+union txgbe_rx_desc {
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
+/* Context descriptors */
+struct txgbe_tx_context_desc {
+	__le32 vlan_macip_lens;
+	__le32 seqnum_seed;
+	__le32 type_tucmd_mlhl;
+	__le32 mss_l4len_idx;
+};
+
 /****************** Manageablility Host Interface defines ********************/
 #define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
 #define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
@@ -1932,9 +2208,80 @@ struct txgbe_bus_info {
 	u16 lan_id;
 };
 
+/* Statistics counters collected by the MAC */
+struct txgbe_hw_stats {
+	u64 crcerrs;
+	u64 illerrc;
+	u64 errbc;
+	u64 mspdc;
+	u64 mpctotal;
+	u64 mpc[8];
+	u64 mlfc;
+	u64 mrfc;
+	u64 rlec;
+	u64 lxontxc;
+	u64 lxonrxc;
+	u64 lxofftxc;
+	u64 lxoffrxc;
+	u64 pxontxc[8];
+	u64 pxonrxc[8];
+	u64 pxofftxc[8];
+	u64 pxoffrxc[8];
+	u64 prc64;
+	u64 prc127;
+	u64 prc255;
+	u64 prc511;
+	u64 prc1023;
+	u64 prc1522;
+	u64 gprc;
+	u64 bprc;
+	u64 mprc;
+	u64 gptc;
+	u64 gorc;
+	u64 gotc;
+	u64 rnbc[8];
+	u64 ruc;
+	u64 rfc;
+	u64 roc;
+	u64 rjc;
+	u64 mngprc;
+	u64 mngpdc;
+	u64 mngptc;
+	u64 tor;
+	u64 tpr;
+	u64 tpt;
+	u64 ptc64;
+	u64 ptc127;
+	u64 ptc255;
+	u64 ptc511;
+	u64 ptc1023;
+	u64 ptc1522;
+	u64 mptc;
+	u64 bptc;
+	u64 xec;
+	u64 qprc[16];
+	u64 qptc[16];
+	u64 qbrc[16];
+	u64 qbtc[16];
+	u64 qprdc[16];
+	u64 pxon2offc[8];
+	u64 fccrc;
+	u64 fclast;
+	u64 ldpcec;
+	u64 pcrc8ec;
+	u64 b2ospc;
+	u64 b2ogprc;
+	u64 o2bgptc;
+	u64 o2bspc;
+};
+
 /* forward declaration */
 struct txgbe_hw;
 
+/* iterator type for walking multicast address lists */
+typedef u8* (*txgbe_mc_addr_itr) (struct txgbe_hw *hw, u8 **mc_addr_ptr,
+				  u32 *vmdq);
+
 /* Function pointer table */
 struct txgbe_eeprom_operations {
 	s32 (*init_params)(struct txgbe_hw *hw);
@@ -1949,6 +2296,7 @@ struct txgbe_mac_operations {
 	s32 (*init_hw)(struct txgbe_hw *hw);
 	s32 (*reset_hw)(struct txgbe_hw *hw);
 	s32 (*start_hw)(struct txgbe_hw *hw);
+	s32 (*clear_hw_cntrs)(struct txgbe_hw *hw);
 	enum txgbe_media_type (*get_media_type)(struct txgbe_hw *hw);
 	s32 (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
 	s32 (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
@@ -1957,6 +2305,9 @@ struct txgbe_mac_operations {
 	s32 (*stop_adapter)(struct txgbe_hw *hw);
 	s32 (*get_bus_info)(struct txgbe_hw *hw);
 	void (*set_lan_id)(struct txgbe_hw *hw);
+	s32 (*enable_rx_dma)(struct txgbe_hw *hw, u32 regval);
+	s32 (*disable_sec_rx_path)(struct txgbe_hw *hw);
+	s32 (*enable_sec_rx_path)(struct txgbe_hw *hw);
 	s32 (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
@@ -1974,17 +2325,28 @@ struct txgbe_mac_operations {
 				     bool *autoneg);
 	void (*set_rate_select_speed)(struct txgbe_hw *hw, u32 speed);
 
+	/* Packet Buffer manipulation */
+	void (*setup_rxpba)(struct txgbe_hw *hw, int num_pb, u32 headroom,
+			    int strategy);
+
 	/* LED */
 	s32 (*led_on)(struct txgbe_hw *hw, u32 index);
 	s32 (*led_off)(struct txgbe_hw *hw, u32 index);
 
-	/* RAR */
+	/* RAR, Multicast, VLAN */
 	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		       u32 enable_addr);
 	s32 (*clear_rar)(struct txgbe_hw *hw, u32 index);
 	s32 (*set_vmdq_san_mac)(struct txgbe_hw *hw, u32 vmdq);
 	s32 (*clear_vmdq)(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 	s32 (*init_rx_addrs)(struct txgbe_hw *hw);
+	s32 (*update_uc_addr_list)(struct txgbe_hw *hw, u8 *addr_list,
+				   u32 addr_count, txgbe_mc_addr_itr func);
+	s32 (*update_mc_addr_list)(struct txgbe_hw *hw, u8 *mc_addr_list,
+				   u32 mc_addr_count,
+				   txgbe_mc_addr_itr func, bool clear);
+	s32 (*clear_vfta)(struct txgbe_hw *hw);
+	s32 (*set_vfta)(struct txgbe_hw *hw, u32 vlan, u32 vind, bool vlan_on);
 	s32 (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
@@ -1992,6 +2354,7 @@ struct txgbe_mac_operations {
 			      u8 build, u8 ver);
 	s32 (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 	void (*disable_rx)(struct txgbe_hw *hw);
+	void (*enable_rx)(struct txgbe_hw *hw);
 };
 
 struct txgbe_phy_operations {
@@ -2022,9 +2385,15 @@ struct txgbe_mac_info {
 	u16 wwnn_prefix;
 	/* prefix for World Wide Port Name (WWPN) */
 	u16 wwpn_prefix;
+#define TXGBE_MAX_MTA                   128
+#define TXGBE_MAX_VFTA_ENTRIES          128
+	u32 mta_shadow[TXGBE_MAX_MTA];
 	s32 mc_filter_type;
 	u32 mcft_size;
+	u32 vft_shadow[TXGBE_MAX_VFTA_ENTRIES];
+	u32 vft_size;
 	u32 num_rar_entries;
+	u32 rx_pb_size;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
 	u32 orig_sr_pcs_ctl2;
@@ -2081,6 +2450,7 @@ struct txgbe_hw {
 	bool force_full_reset;
 	enum txgbe_link_status link_status;
 	u16 subsystem_id;
+	u16 tpid[8];
 };
 
 #define TCALL(hw, func, args...) (((hw)->func != NULL) \
-- 
2.27.0



