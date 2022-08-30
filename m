Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17A5A5C90
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiH3HIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiH3HHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:07:25 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA17DC4809
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:07:05 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843156tpl7s9xk
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:55 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: 7Lv6dviieSQNwcvrYdd9r4Y9X79ImCUqLUykh6Sb3m9Yzz9BSAqpkH/y/34I8
        HreEggif1lqMqTrsH/u4O8ney14/bV5ozIponYXxGXYiBvoaEm+CTVkIN4xbYPJxU2JW38R
        9GGOtSEa1OEbe0JODmDfdGXD4o8hPDh4nG6xkQXW0/DKOMQTlhBBPH5YQxelXV/3J9jbzst
        1CS/G1tm6KRrv6ZrJKtGx0wp9mYTM0YFUOshxYLygFUcsZi/NKBsjCJWhTfZDZX026ty3PJ
        GCyUDIf2gRgAbvSCqT56kiaRpbpehvIUn08yLTaHQMtHmJFw0yfOK80sUKPum+mKsFcj09y
        xKKLe5+otE+rKB2Or5dou3ls3Y0uByIjiK0XWVdzhGdKwkkYoBtMf1bhYs2eqkmsnuhCVE+
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 13/16] net: txgbe: Add device Rx features
Date:   Tue, 30 Aug 2022 15:04:51 +0800
Message-Id: <20220830070454.146211-14-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support RSC/LRO, Rx checksum offload, VLAN, jumbo frame, VXLAN, etc.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst |  41 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  36 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  13 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 386 +++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  64 +++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 481 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  54 +-
 7 files changed, 1069 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index 3c7656057c69..547fcc414bd4 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -12,6 +12,7 @@ Contents
 ========
 
 - Identifying Your Adapter
+- Additional Features and Configurations
 - Support
 
 
@@ -57,6 +58,46 @@ Laser turns off for SFP+ when ifconfig ethX down
 "ifconfig ethX up" turns on the laser.
 
 
+Additional Features and Configurations
+======================================
+
+Jumbo Frames
+------------
+Jumbo Frames support is enabled by changing the Maximum Transmission Unit
+(MTU) to a value larger than the default value of 1500.
+
+Use the ifconfig command to increase the MTU size. For example, enter the
+following where <x> is the interface number::
+
+  ifconfig eth<x> mtu 9000 up
+
+NOTES:
+- The maximum MTU setting for Jumbo Frames is 9710. This value coincides
+  with the maximum Jumbo Frames size of 9728 bytes.
+- This driver will attempt to use multiple page sized buffers to receive
+  each jumbo packet. This should help to avoid buffer starvation issues
+  when allocating receive packets.
+
+Hardware Receive Side Coalescing (HW RSC)
+-----------------------------------------
+Sapphire adapters support HW RSC, which can merge multiple
+frames from the same IPv4 TCP/IP flow into a single structure that can span
+one or more descriptors. It works similarly to Software Large Receive Offload
+technique.
+
+VXLAN Overlay HW Offloading
+---------------------------
+Virtual Extensible LAN (VXLAN) allows you to extend an L2 network over an L3
+network, which may be useful in a virtualized or cloud environment. WangXun(R)
+10Gb Ethernet Network devices perform VXLAN processing, offloading it from the
+operating system. This reduces CPU utilization.
+
+VXLAN offloading is controlled by the tx and rx checksum offload options
+provided by ethtool. That is, if tx checksum offload is enabled, and the adapter
+has the capability, VXLAN offloading is also enabled. If rx checksum offload is
+enabled, then the VXLAN packets rx checksum will be offloaded.
+
+
 Support
 =======
 If you got any problem, contact Wangxun support team via support@trustnetic.com
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 075ca4f6bc07..4248e5ef7940 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -5,6 +5,7 @@
 #define _TXGBE_H_
 
 #include <net/ip.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 #include <linux/timecounter.h>
 
@@ -85,21 +86,43 @@ struct txgbe_tx_queue_stats {
 };
 
 struct txgbe_rx_queue_stats {
+	u64 rsc_count;
+	u64 rsc_flush;
 	u64 non_eop_descs;
 	u64 alloc_rx_page_failed;
 	u64 alloc_rx_buff_failed;
+	u64 csum_good_cnt;
+	u64 csum_err;
 };
 
+enum txgbe_ring_state_t {
+	__TXGBE_RX_RSC_ENABLED,
+};
+
+struct txgbe_fwd_adapter {
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+	struct txgbe_adapter *adapter;
+};
+
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
 	void *desc;                     /* descriptor ring memory */
 	union {
 		struct txgbe_tx_buffer *tx_buffer_info;
 		struct txgbe_rx_buffer *rx_buffer_info;
 	};
+	unsigned long state;
 	u8 __iomem *tail;
 	dma_addr_t dma;                 /* phys. address of descriptor ring */
 	unsigned int size;              /* length in bytes */
@@ -183,6 +206,7 @@ struct txgbe_q_vector {
 /* microsecond values for various ITR rates shifted by 2 to fit itr register
  * with the first 3 bits reserved 0
  */
+#define TXGBE_MIN_RSC_ITR       24
 #define TXGBE_100K_ITR          40
 #define TXGBE_20K_ITR           200
 #define TXGBE_16K_ITR           248
@@ -244,6 +268,8 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG_NEED_LINK_CONFIG             BIT(1)
 #define TXGBE_FLAG_MSI_ENABLED                  BIT(2)
 #define TXGBE_FLAG_MSIX_ENABLED                 BIT(3)
+#define TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE        BIT(4)
+#define TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE         BIT(5)
 
 /**
  * txgbe_adapter.flag2
@@ -254,6 +280,8 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_PF_RESET_REQUESTED          BIT(3)
 #define TXGBE_FLAG2_RESET_INTR_RECEIVED         BIT(4)
 #define TXGBE_FLAG2_GLOBAL_RESET_REQUESTED      BIT(5)
+#define TXGBE_FLAG2_RSC_CAPABLE                 BIT(6)
+#define TXGBE_FLAG2_RSC_ENABLED                 BIT(7)
 
 enum txgbe_isb_idx {
 	TXGBE_ISB_HEADER,
@@ -266,6 +294,7 @@ enum txgbe_isb_idx {
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
@@ -387,13 +416,19 @@ void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 				      struct txgbe_tx_buffer *tx_buffer);
 void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count);
+void txgbe_configure_rscctl(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring);
 void txgbe_configure_port(struct txgbe_adapter *adapter);
+void txgbe_clear_vxlan_port(struct txgbe_adapter *adapter);
 void txgbe_set_rx_mode(struct net_device *netdev);
 int txgbe_write_mc_addr_list(struct net_device *netdev);
+void txgbe_do_reset(struct net_device *netdev);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 int txgbe_poll(struct napi_struct *napi, int budget);
 void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
 			    struct txgbe_ring *ring);
+void txgbe_vlan_strip_enable(struct txgbe_adapter *adapter);
+void txgbe_vlan_strip_disable(struct txgbe_adapter *adapter);
 
 static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
 {
@@ -404,6 +439,7 @@ int txgbe_write_uc_addr_list(struct net_device *netdev, int pool);
 int txgbe_add_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
 int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool);
 int txgbe_available_rars(struct txgbe_adapter *adapter);
+void txgbe_vlan_mode(struct net_device *netdev, u32 features);
 
 void txgbe_set_rx_drop_en(struct txgbe_adapter *adapter);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 01438fc89b01..90118d1602c4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -143,6 +143,15 @@ static void txgbe_set_vmdq_san_mac_dummy(struct txgbe_hw *TUP0, u32 TUP1)
 {
 }
 
+static void txgbe_set_vfta_dummy(struct txgbe_hw *TUP0, u32 TUP1,
+				 u32 TUP2, bool TUP3)
+{
+}
+
+static void txgbe_clear_vfta_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 static void txgbe_init_uta_tables_dummy(struct txgbe_hw *TUP0)
 {
 }
@@ -249,7 +258,7 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix_dummy;
 	mac->ops.setup_rxpba = txgbe_set_rxpba_dummy;
 
-	/* RAR, Multicast */
+	/* RAR, Multicast, VLAN */
 	mac->ops.set_rar = txgbe_set_rar_dummy;
 	mac->ops.clear_rar = txgbe_clear_rar_dummy;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs_dummy;
@@ -258,6 +267,8 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.enable_rx = txgbe_enable_rx_dummy;
 	mac->ops.disable_rx = txgbe_disable_rx_dummy;
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac_dummy;
+	mac->ops.set_vfta = txgbe_set_vfta_dummy;
+	mac->ops.clear_vfta = txgbe_clear_vfta_dummy;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables_dummy;
 
 	/* Link */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index ab333659dea6..b3cb0a846260 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -10,6 +10,7 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_VFT_TBL_SIZE   128
 #define TXGBE_SP_RX_PB_SIZE     512
 
 static int txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
@@ -907,6 +908,77 @@ void txgbe_init_uta_tables(struct txgbe_hw *hw)
 		wr32(hw, TXGBE_PSR_UC_TBL(i), 0);
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
+void txgbe_set_vfta(struct txgbe_hw *hw, u32 vlan, u32 vind,
+		    bool vlan_on)
+{
+	u32 bitindex, vfta, targetbit;
+	bool vfta_changed = false;
+	s32 regindex;
+
+	if (vlan > 4095)
+		return;
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
+}
+
+/**
+ *  txgbe_clear_vfta - Clear VLAN filter table
+ *  @hw: pointer to hardware structure
+ *
+ *  Clears the VLAN filer table, and the VMDq index associated with the filter
+ **/
+void txgbe_clear_vfta(struct txgbe_hw *hw)
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
+}
+
 /**
  *  txgbe_get_wwn_prefix - Get alternative WWNN/WWPN prefix from the EEPROM
  *  @hw: pointer to hardware structure
@@ -1545,6 +1617,310 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
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
@@ -1633,7 +2009,7 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
 	mac->ops.setup_rxpba = txgbe_set_rxpba;
 
-	/* RAR, Multicast */
+	/* RAR, Multicast, VLAN */
 	mac->ops.set_rar = txgbe_set_rar;
 	mac->ops.clear_rar = txgbe_clear_rar;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
@@ -1642,6 +2018,8 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.enable_rx = txgbe_enable_rx;
 	mac->ops.disable_rx = txgbe_disable_rx;
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
+	mac->ops.set_vfta = txgbe_set_vfta;
+	mac->ops.clear_vfta = txgbe_clear_vfta;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
 	/* Link */
@@ -1649,6 +2027,7 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.check_link = txgbe_check_mac_link;
 
 	mac->mcft_size          = TXGBE_SP_MC_TBL_SIZE;
+	mac->vft_size           = TXGBE_SP_VFT_TBL_SIZE;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->rx_pb_size         = TXGBE_SP_RX_PB_SIZE;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
@@ -2926,6 +3305,11 @@ void txgbe_start_hw(struct txgbe_hw *hw)
 	/* Set the media type */
 	hw->phy.media_type = txgbe_get_media_type(hw);
 
+	/* Clear the VLAN filter table */
+	hw->mac.ops.clear_vfta(hw);
+
+	TXGBE_WRITE_FLUSH(hw);
+
 	/* Clear the rate limiters */
 	for (i = 0; i < hw->mac.max_tx_queues; i++) {
 		wr32(hw, TXGBE_TDM_RP_IDX, i);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index c63c4f5a79ad..5799838fd10c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -16,6 +16,67 @@
 #define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
 #define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
 
+/**
+ * Packet Type decoding
+ **/
+/* txgbe_dptype.mac: outer mac */
+enum txgbe_dec_ptype_mac {
+	TXGBE_DEC_PTYPE_MAC_IP = 0,
+	TXGBE_DEC_PTYPE_MAC_L2 = 2,
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
 u16 txgbe_get_pcie_msix_count(struct txgbe_hw *hw);
 int txgbe_init_hw(struct txgbe_hw *hw);
 void txgbe_start_hw(struct txgbe_hw *hw);
@@ -44,6 +105,9 @@ void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr);
 void txgbe_set_vmdq_san_mac(struct txgbe_hw *hw, u32 vmdq);
 void txgbe_clear_vmdq(struct txgbe_hw *hw, u32 rar, u32 vmdq);
 void txgbe_init_uta_tables(struct txgbe_hw *hw);
+void txgbe_set_vfta(struct txgbe_hw *hw, u32 vlan,
+		    u32 vind, bool vlan_on);
+void txgbe_clear_vfta(struct txgbe_hw *hw);
 
 void txgbe_get_wwn_prefix(struct txgbe_hw *hw, u16 *wwnn_prefix,
 			  u16 *wwpn_prefix);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 2e72a3d6313a..888cb5b9b2dd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -7,6 +7,9 @@
 #include <linux/netdevice.h>
 #include <linux/string.h>
 #include <linux/aer.h>
+#include <net/checksum.h>
+#include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/etherdevice.h>
 
 #include "txgbe.h"
@@ -47,6 +50,17 @@ static void txgbe_clean_tx_ring(struct txgbe_ring *tx_ring);
 static void txgbe_napi_enable_all(struct txgbe_adapter *adapter);
 static void txgbe_napi_disable_all(struct txgbe_adapter *adapter);
 
+static struct txgbe_dptype txgbe_decode_ptype(const u8 ptype)
+{
+	return txgbe_ptype_lookup[ptype];
+}
+
+static struct txgbe_dptype
+decode_rx_desc_ptype(const union txgbe_rx_desc *rx_desc)
+{
+	return txgbe_decode_ptype(TXGBE_RXD_PKTTYPE(rx_desc));
+}
+
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev;
@@ -296,6 +310,63 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
 	return !!budget;
 }
 
+/**
+ * txgbe_rx_checksum - indicate in skb if hw indicated a good cksum
+ * @ring: structure containing ring specific data
+ * @rx_desc: current Rx descriptor being processed
+ * @skb: skb currently being received and modified
+ **/
+static void txgbe_rx_checksum(struct txgbe_ring *ring,
+			      union txgbe_rx_desc *rx_desc,
+			      struct sk_buff *skb)
+{
+	struct txgbe_dptype dptype = decode_rx_desc_ptype(rx_desc);
+
+	skb->ip_summed = CHECKSUM_NONE;
+
+	skb_checksum_none_assert(skb);
+
+	/* Rx csum disabled */
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	/* if IPv4 header checksum error */
+	if ((txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_IPCS) &&
+	     txgbe_test_staterr(rx_desc, TXGBE_RXD_ERR_IPE)) ||
+	    (txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_OUTERIPCS) &&
+	     txgbe_test_staterr(rx_desc, TXGBE_RXD_ERR_OUTERIPER))) {
+		ring->rx_stats.csum_err++;
+		return;
+	}
+
+	/* L4 checksum offload flag must set for the below code to work */
+	if (!txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_L4CS))
+		return;
+
+	/*likely incorrect csum if IPv6 Dest Header found */
+	if (dptype.prot != TXGBE_DEC_PTYPE_PROT_SCTP && TXGBE_RXD_IPV6EX(rx_desc))
+		return;
+
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
+}
+
 static bool txgbe_alloc_mapped_page(struct txgbe_ring *rx_ring,
 				    struct txgbe_rx_buffer *bi)
 {
@@ -391,6 +462,51 @@ void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count)
 	}
 }
 
+static void txgbe_set_rsc_gso_size(struct txgbe_ring __maybe_unused *ring,
+				   struct sk_buff *skb)
+{
+	u16 hdr_len = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
+
+	/* set gso_size to avoid messing up TCP MSS */
+	skb_shinfo(skb)->gso_size = DIV_ROUND_UP((skb->len - hdr_len),
+						 TXGBE_CB(skb)->append_cnt);
+	skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+}
+
+static void txgbe_update_rsc_stats(struct txgbe_ring *rx_ring,
+				   struct sk_buff *skb)
+{
+	/* if append_cnt is 0 then frame is not RSC */
+	if (!TXGBE_CB(skb)->append_cnt)
+		return;
+
+	rx_ring->rx_stats.rsc_count += TXGBE_CB(skb)->append_cnt;
+	rx_ring->rx_stats.rsc_flush++;
+
+	txgbe_set_rsc_gso_size(rx_ring, skb);
+
+	/* gso_size is computed using append_cnt so always clear it last */
+	TXGBE_CB(skb)->append_cnt = 0;
+}
+
+static void txgbe_rx_vlan(struct txgbe_ring *ring,
+			  union txgbe_rx_desc *rx_desc,
+			  struct sk_buff *skb)
+{
+	u16 ethertype;
+	u8 idx = 0;
+
+	if ((ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_VP)) {
+		idx = (le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+		       TXGBE_RXD_TPID_MASK) >> TXGBE_RXD_TPID_SHIFT;
+		ethertype = ring->q_vector->adapter->hw.tpid[idx];
+		__vlan_hwaccel_put_tag(skb,
+				       htons(ethertype),
+				       le16_to_cpu(rx_desc->wb.upper.vlan));
+	}
+}
+
 /**
  * txgbe_process_skb_fields - Populate skb header fields from Rx descriptor
  * @rx_ring: rx descriptor ring packet is being transacted on
@@ -398,13 +514,18 @@ void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count)
  * @skb: pointer to current skb being populated
  *
  * This function checks the ring, descriptor, and packet information in
- * order to populate the hash, checksum, VLAN, timestamp, protocol, and
+ * order to populate the checksum, VLAN, protocol, and
  * other fields within the skb.
  **/
 static void txgbe_process_skb_fields(struct txgbe_ring *rx_ring,
 				     union txgbe_rx_desc *rx_desc,
 				     struct sk_buff *skb)
 {
+	txgbe_update_rsc_stats(rx_ring, skb);
+	txgbe_rx_checksum(rx_ring, rx_desc, skb);
+
+	txgbe_rx_vlan(rx_ring, rx_desc, skb);
+
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
@@ -439,6 +560,24 @@ static bool txgbe_is_non_eop(struct txgbe_ring *rx_ring,
 
 	prefetch(TXGBE_RX_DESC(rx_ring, ntc));
 
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
 	/* if we are the last buffer then there is nothing else to do */
 	if (likely(txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_EOP)))
 		return false;
@@ -801,6 +940,7 @@ static int txgbe_clean_rx_irq(struct txgbe_q_vector *q_vector,
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
+		/* populate checksum, VLAN, and protocol */
 		txgbe_process_skb_fields(rx_ring, rx_desc, skb);
 
 		txgbe_rx_skb(q_vector, skb);
@@ -1597,6 +1737,39 @@ static void txgbe_configure_srrctl(struct txgbe_adapter *adapter,
 	wr32(hw, TXGBE_PX_RR_CFG(reg_idx), srrctl);
 }
 
+/**
+ * txgbe_configure_rscctl - enable RSC for the indicated ring
+ * @adapter:    address of board private structure
+ * @ring: structure containing ring specific data
+ **/
+void txgbe_configure_rscctl(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 reg_idx = ring->reg_idx;
+	u32 rscctrl;
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
 static void txgbe_rx_desc_queue_enable(struct txgbe_adapter *adapter,
 				       struct txgbe_ring *ring)
 {
@@ -1672,6 +1845,8 @@ void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
 	ring->next_to_alloc = 0;
 
 	txgbe_configure_srrctl(adapter, ring);
+	/* In ESX, RSCCTL configuration is done by on demand */
+	txgbe_configure_rscctl(adapter, ring);
 
 	/* enable receive descriptor ring */
 	wr32m(hw, TXGBE_PX_RR_CFG(reg_idx),
@@ -1701,7 +1876,9 @@ static void txgbe_set_rx_buffer_len(struct txgbe_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_ring *rx_ring;
 	u32 mhadd, max_frame;
+	int i;
 
 	max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
 	/* adjust max frame to be at least the size of a standard frame */
@@ -1711,6 +1888,15 @@ static void txgbe_set_rx_buffer_len(struct txgbe_adapter *adapter)
 	mhadd = rd32(hw, TXGBE_PSR_MAX_SZ);
 	if (max_frame != mhadd)
 		wr32(hw, TXGBE_PSR_MAX_SZ, max_frame);
+
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		rx_ring = adapter->rx_ring[i];
+
+		if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
+			set_ring_rsc_enabled(rx_ring);
+		else
+			clear_ring_rsc_enabled(rx_ring);
+	}
 }
 
 /**
@@ -1737,7 +1923,8 @@ static void txgbe_configure_rx(struct txgbe_adapter *adapter)
 	/* RSC Setup */
 	psrctl = rd32m(hw, TXGBE_PSR_CTL, ~TXGBE_PSR_CTL_RSC_DIS);
 	psrctl |= TXGBE_PSR_CTL_RSC_ACK; /* Disable RSC for ACK packets */
-	psrctl |= TXGBE_PSR_CTL_RSC_DIS;
+	if (!(adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED))
+		psrctl |= TXGBE_PSR_CTL_RSC_DIS;
 	wr32(hw, TXGBE_PSR_CTL, psrctl);
 
 	/* set_rx_buffer_len must be called before ring initialization */
@@ -1756,6 +1943,101 @@ static void txgbe_configure_rx(struct txgbe_adapter *adapter)
 	hw->mac.ops.enable_rx_dma(hw, rxctrl);
 }
 
+static int txgbe_vlan_rx_add_vid(struct net_device *netdev,
+				 __be16 proto, u16 vid)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	/* add VID to filter table */
+	hw->mac.ops.set_vfta(hw, vid, 0, true);
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
+	hw->mac.ops.set_vfta(hw, vid, 0, false);
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
 static u8 *txgbe_addr_list_itr(struct txgbe_hw __maybe_unused *hw,
 			       u8 **mc_addr_ptr, u32 *vmdq)
 {
@@ -2056,6 +2338,11 @@ void txgbe_set_rx_mode(struct net_device *netdev)
 	wr32(hw, TXGBE_PSR_VLAN_CTL, vlnctrl);
 	wr32(hw, TXGBE_PSR_CTL, fctrl);
 	wr32(hw, TXGBE_PSR_VM_L2CTL(0), vmolr);
+
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
+		txgbe_vlan_strip_enable(adapter);
+	else
+		txgbe_vlan_strip_disable(adapter);
 }
 
 static void txgbe_napi_enable_all(struct txgbe_adapter *adapter)
@@ -2080,6 +2367,20 @@ static void txgbe_napi_disable_all(struct txgbe_adapter *adapter)
 	}
 }
 
+void txgbe_clear_vxlan_port(struct txgbe_adapter *adapter)
+{
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
 static void txgbe_configure_pb(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -2128,6 +2429,7 @@ static void txgbe_configure(struct txgbe_adapter *adapter)
 	txgbe_configure_port(adapter);
 
 	txgbe_set_rx_mode(adapter->netdev);
+	txgbe_restore_vlan(adapter);
 
 	hw->mac.ops.disable_sec_rx_path(hw);
 
@@ -2547,6 +2849,9 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	adapter->rx_itr_setting = 1;
 	adapter->tx_itr_setting = 1;
 
+	adapter->flags |= TXGBE_FLAG_VXLAN_OFFLOAD_CAPABLE;
+	adapter->flags2 |= TXGBE_FLAG2_RSC_CAPABLE;
+
 	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
 
 	/* set default ring sizes */
@@ -2830,6 +3135,32 @@ static void txgbe_free_all_rx_resources(struct txgbe_adapter *adapter)
 		txgbe_free_rx_resources(adapter->rx_ring[i]);
 }
 
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
+	netif_info(adapter, probe, netdev,
+		   "changing MTU from %d to %d\n", netdev->mtu, new_mtu);
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
 /**
  * txgbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -2880,6 +3211,9 @@ int txgbe_open(struct net_device *netdev)
 
 	txgbe_up_complete(adapter);
 
+	txgbe_clear_vxlan_port(adapter);
+	udp_tunnel_get_rx_info(netdev);
+
 	return 0;
 
 err_free_irq:
@@ -3446,6 +3780,108 @@ static int txgbe_del_sanmac_netdev(struct net_device *dev)
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
+			netif_info(adapter, probe, netdev,
+				   "rx-usecs set too low, disabling RSC\n");
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
+	if (need_reset)
+		txgbe_do_reset(netdev);
+
+	return 0;
+}
+
+#define TXGBE_MAX_TUNNEL_HDR_LEN 80
+static netdev_features_t
+txgbe_features_check(struct sk_buff *skb, struct net_device *dev,
+		     netdev_features_t features)
+{
+	u16 vlan_depth = skb->mac_len;
+	__be16 type = skb->protocol;
+	struct vlan_hdr *vh;
+	u32 vlan_num = 0;
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
@@ -3453,6 +3889,12 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_set_rx_mode        = txgbe_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = txgbe_set_mac,
+	.ndo_change_mtu		= txgbe_change_mtu,
+	.ndo_vlan_rx_add_vid    = txgbe_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = txgbe_vlan_rx_kill_vid,
+	.ndo_features_check     = txgbe_features_check,
+	.ndo_set_features       = txgbe_set_features,
+	.ndo_fix_features       = txgbe_fix_features,
 };
 
 void txgbe_assign_netdev_ops(struct net_device *dev)
@@ -3579,17 +4021,46 @@ static int txgbe_probe(struct pci_dev *pdev,
 		}
 	}
 
-	netdev->features = NETIF_F_SG;
+	netdev->features = NETIF_F_SG |
+			   NETIF_F_LRO |
+			   NETIF_F_RXCSUM |
+			   NETIF_F_HW_CSUM |
+			   NETIF_F_SCTP_CRC;
+
+	netdev->gso_partial_features = TXGBE_GSO_PARTIAL_FEATURES;
+	netdev->features |= NETIF_F_GSO_PARTIAL |
+			    TXGBE_GSO_PARTIAL_FEATURES;
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features |
+			       NETIF_F_HW_VLAN_CTAG_FILTER |
+			       NETIF_F_HW_VLAN_CTAG_RX |
+			       NETIF_F_HW_VLAN_CTAG_TX |
 			       NETIF_F_RXALL;
 
+	netdev->hw_features |= NETIF_F_NTUPLE;
+
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	netdev->vlan_features |= netdev->features;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->mpls_features |= NETIF_F_HW_CSUM;
+
+	/* set this bit last since it cannot be part of vlan_features */
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+			    NETIF_F_HW_VLAN_CTAG_RX |
+			    NETIF_F_HW_VLAN_CTAG_TX;
+
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
+	/* give us the option of enabling RSC/LRO later */
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_CAPABLE) {
+		netdev->hw_features |= NETIF_F_LRO;
+		netdev->features |= NETIF_F_LRO;
+		adapter->flags2 |= TXGBE_FLAG2_RSC_ENABLED;
+	}
+
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
 
@@ -3726,6 +4197,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	i_s_var += sprintf(info_string, "Enabled Features: ");
 	i_s_var += sprintf(i_s_var, "RxQ: %d TxQ: %d ",
 			   adapter->num_rx_queues, adapter->num_tx_queues);
+	if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)
+		i_s_var += sprintf(i_s_var, "RSC ");
+	if (adapter->flags & TXGBE_FLAG_VXLAN_OFFLOAD_ENABLE)
+		i_s_var += sprintf(i_s_var, "vxlan_rx ");
 
 	WARN_ON(i_s_var > (info_string + INFO_STRING_LEN));
 	/* end features printing */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ead97e228164..ed0454758174 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -554,6 +554,9 @@ enum {
 #define TXGBE_PSR_MC_TBL(_i)    (0x15200  + ((_i) * 4))
 #define TXGBE_PSR_UC_TBL(_i)    (0x15400 + ((_i) * 4))
 
+/* vlan tbl */
+#define TXGBE_PSR_VLAN_TBL(_i)  (0x16000 + ((_i) * 4))
+
 /* mac switcher */
 #define TXGBE_PSR_MAC_SWC_AD_L  0x16200
 #define TXGBE_PSR_MAC_SWC_AD_H  0x16204
@@ -566,6 +569,17 @@ enum {
 #define TXGBE_PSR_MAC_SWC_AD_H_AV       0x80000000U
 #define TXGBE_CLEAR_VMDQ_ALL            0xFFFFFFFFU
 
+/* vlan switch */
+#define TXGBE_PSR_VLAN_SWC      0x16220
+#define TXGBE_PSR_VLAN_SWC_VM_L 0x16224
+#define TXGBE_PSR_VLAN_SWC_VM_H 0x16228
+#define TXGBE_PSR_VLAN_SWC_IDX  0x16230         /* 64 vlan entries */
+/* VLAN pool filtering masks */
+#define TXGBE_PSR_VLAN_SWC_VIEN         0x80000000U  /* filter is valid */
+#define TXGBE_PSR_VLAN_SWC_ENTRIES      64
+#define TXGBE_PSR_VLAN_SWC_VLANID_MASK  0x00000FFFU
+#define TXGBE_ETHERNET_IEEE_VLAN_TYPE   0x8100  /* 802.1q protocol */
+
 /* Management */
 #define TXGBE_PSR_MNG_FIT_CTL           0x15820
 /* Management Bit Fields and Masks */
@@ -913,11 +927,44 @@ enum {
 #define TXGBE_ALT_SAN_MAC_ADDR_CAPS_ALTWWN      0x1 /* Alt WWN base exists */
 
 /******************* Receive Descriptor bit definitions **********************/
+#define TXGBE_RXD_NEXTP_MASK            0x000FFFF0U /* Next Descriptor Index */
+#define TXGBE_RXD_NEXTP_SHIFT           0x00000004U
+#define TXGBE_RXD_STAT_MASK             0x000fffffU /* Stat/NEXTP: bit 0-19 */
 #define TXGBE_RXD_STAT_DD               0x00000001U /* Done */
 #define TXGBE_RXD_STAT_EOP              0x00000002U /* End of Packet */
+#define TXGBE_RXD_STAT_VP               0x00000020U /* IEEE VLAN Pkt */
+#define TXGBE_RXD_STAT_UDPCS            0x00000040U /* UDP xsum calculated */
+#define TXGBE_RXD_STAT_L4CS             0x00000080U /* L4 xsum calculated */
+#define TXGBE_RXD_STAT_IPCS             0x00000100U /* IP xsum calculated */
+#define TXGBE_RXD_STAT_PIF              0x00000200U /* passed in-exact filter */
+#define TXGBE_RXD_STAT_OUTERIPCS        0x00000400U /* Cloud IP xsum calculated*/
+#define TXGBE_RXD_STAT_VEXT             0x00000800U /* 1st VLAN found */
+#define TXGBE_RXD_STAT_LLINT            0x00002000U /* Pkt caused Low Latency Int */
+#define TXGBE_RXD_STAT_SECP             0x00008000U /* Security Processing */
+#define TXGBE_RXD_STAT_LB               0x00010000U /* Loopback Status */
 
 #define TXGBE_RXD_ERR_MASK              0xfff00000U /* RDESC.ERRORS mask */
+#define TXGBE_RXD_ERR_OUTERIPER         0x04000000U /* CRC IP Header error */
+#define TXGBE_RXD_ERR_SECERR_MASK       0x18000000U
 #define TXGBE_RXD_ERR_RXE               0x20000000U /* Any MAC Error */
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
+#define TXGBE_RXD_PKTTYPE(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
+
+#define TXGBE_RXD_IPV6EX(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
 
 /* Masks to determine if packets should be dropped due to frame errors */
 #define TXGBE_RXD_ERR_FRAME_ERR_MASK    TXGBE_RXD_ERR_RXE
@@ -1214,7 +1261,7 @@ struct txgbe_mac_operations {
 	void (*setup_rxpba)(struct txgbe_hw *hw, int num_pb, u32 headroom,
 			    int strategy);
 
-	/* RAR, Multicast */
+	/* RAR, Multicast, VLAN */
 	void (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 			u32 enable_addr);
 	void (*clear_rar)(struct txgbe_hw *hw, u32 index);
@@ -1226,6 +1273,8 @@ struct txgbe_mac_operations {
 	void (*update_mc_addr_list)(struct txgbe_hw *hw, u8 *mc_addr_list,
 				    u32 mc_addr_count,
 				    txgbe_mc_addr_itr func, bool clear);
+	void (*clear_vfta)(struct txgbe_hw *hw);
+	void (*set_vfta)(struct txgbe_hw *hw, u32 vlan, u32 vind, bool vlan_on);
 	void (*init_uta_tables)(struct txgbe_hw *hw);
 
 	/* Manageability interface */
@@ -1262,9 +1311,12 @@ struct txgbe_mac_info {
 	/* prefix for World Wide Port Name (WWPN) */
 	u16 wwpn_prefix;
 #define TXGBE_MAX_MTA                   128
+#define TXGBE_MAX_VFTA_ENTRIES          128
 	u32 mta_shadow[TXGBE_MAX_MTA];
 	s32 mc_filter_type;
 	u32 mcft_size;
+	u32 vft_shadow[TXGBE_MAX_VFTA_ENTRIES];
+	u32 vft_size;
 	u32 num_rar_entries;
 	u32 rx_pb_size;
 	u32 max_tx_queues;
-- 
2.27.0

