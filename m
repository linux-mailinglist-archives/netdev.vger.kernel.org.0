Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32866E45DF
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDQK6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjDQK6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:58:16 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F2E448B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 03:57:20 -0700 (PDT)
X-QQ-mid: bizesmtp75t1681728924tjuqu654
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 17 Apr 2023 18:55:22 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: QityeSR92A10KeUi+JZfh2EEFXbjIdZFzaipsKbosqAzh4w9DHaJlDIWRQDRG
        NebtHi1Sz3RpQqHeDBBAB3vJo2NXGcEU8eDZer8Dj4wFXdZdsOdsLq58V7dPLNCh3v3nJR1
        nZZkooSZBeESIcghZOtjPvL33Yg7ZLNbquYaPeUKIK1yZYkykUMVGBN3roX0D7E/p88q9NM
        Vas7YfnrPIaS7VLAGkZETP32Wn9Bk6CcBGWXRxbvlLZAhxJ3GQLIsD2Z0aAAdjnJwJh+YTM
        mH5+0bTrTSXhisyrkC8qZTAldOJYKimEN6kXEKCmVGmWDwW4+2XZ4Ktqk4s+/O1+g6vGqyk
        ahIXR5q/DLziQXPMnsqfvJYHq4R+sOHmxZ2yQg6NNJo1fJ4yNECU31XuU1FiHkJapUildQV
        j9wKZd7/sUI=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 9057723878912340770
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 3/5] net: wangxun: Implement vlan add and kill functions
Date:   Mon, 17 Apr 2023 18:54:55 +0800
Message-Id: <20230417105457.82127-4-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417105457.82127-1-mengyuanlou@net-swift.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement vlan add/kill functions which add and remove
vlan id in hardware.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   | 279 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  |  18 ++
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  23 ++
 4 files changed, 322 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index ca409b4054d0..e07e5e245595 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1182,12 +1182,30 @@ static void wx_enable_sec_rx_path(struct wx *wx)
 	WX_WRITE_FLUSH(wx);
 }
 
+static void wx_vlan_strip_control(struct wx *wx, bool enable)
+{
+	int i, j;
+
+	for (i = 0; i < wx->num_rx_queues; i++) {
+		struct wx_ring *ring = wx->rx_ring[i];
+
+		if (ring->accel)
+			continue;
+		j = ring->reg_idx;
+		wr32m(wx, WX_PX_RR_CFG(j), WX_PX_RR_CFG_VLAN,
+		      enable ? WX_PX_RR_CFG_VLAN : 0);
+	}
+}
+
 void wx_set_rx_mode(struct net_device *netdev)
 {
 	struct wx *wx = netdev_priv(netdev);
+	netdev_features_t features;
 	u32 fctrl, vmolr, vlnctrl;
 	int count;
 
+	features = netdev->features;
+
 	/* Check for Promiscuous and All Multicast modes */
 	fctrl = rd32(wx, WX_PSR_CTL);
 	fctrl &= ~(WX_PSR_CTL_UPE | WX_PSR_CTL_MPE);
@@ -1254,6 +1272,13 @@ void wx_set_rx_mode(struct net_device *netdev)
 	wr32(wx, WX_PSR_VLAN_CTL, vlnctrl);
 	wr32(wx, WX_PSR_CTL, fctrl);
 	wr32(wx, WX_PSR_VM_L2CTL(0), vmolr);
+
+	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
+	    (features & NETIF_F_HW_VLAN_STAG_RX))
+		wx_vlan_strip_control(wx, true);
+	else
+		wx_vlan_strip_control(wx, false);
+
 }
 EXPORT_SYMBOL(wx_set_rx_mode);
 
@@ -1462,6 +1487,16 @@ static void wx_configure_tx(struct wx *wx)
 	      WX_MAC_TX_CFG_TE, WX_MAC_TX_CFG_TE);
 }
 
+static void wx_restore_vlan(struct wx *wx)
+{
+	u16 vid = 1;
+
+	wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), 0);
+
+	for_each_set_bit_from(vid, wx->active_vlans, VLAN_N_VID)
+		wx_vlan_rx_add_vid(wx->netdev, htons(ETH_P_8021Q), vid);
+}
+
 /**
  * wx_configure_rx - Configure Receive Unit after Reset
  * @wx: pointer to private structure
@@ -1527,7 +1562,7 @@ void wx_configure(struct wx *wx)
 	wx_configure_port(wx);
 
 	wx_set_rx_mode(wx->netdev);
-
+	wx_restore_vlan(wx);
 	wx_enable_sec_rx_path(wx);
 
 	wx_configure_tx(wx);
@@ -1727,4 +1762,246 @@ int wx_sw_init(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_sw_init);
 
+/**
+ *  wx_find_vlvf_slot - find the vlanid or the first empty slot
+ *  @wx: pointer to hardware structure
+ *  @vlan: VLAN id to write to VLAN filter
+ *
+ *  return the VLVF index where this VLAN id should be placed
+ *
+ **/
+static int wx_find_vlvf_slot(struct wx *wx, u32 vlan)
+{
+	u32 bits = 0, first_empty_slot = 0;
+	int regindex;
+
+	/* short cut the special case */
+	if (vlan == 0)
+		return 0;
+
+	/* Search for the vlan id in the VLVF entries. Save off the first empty
+	 * slot found along the way
+	 */
+	for (regindex = 1; regindex < WX_PSR_VLAN_SWC_ENTRIES; regindex++) {
+		wr32(wx, WX_PSR_VLAN_SWC_IDX, regindex);
+		bits = rd32(wx, WX_PSR_VLAN_SWC);
+		if (!bits && !(first_empty_slot))
+			first_empty_slot = regindex;
+		else if ((bits & 0x0FFF) == vlan)
+			break;
+	}
+
+	/* If regindex is less than TXGBE_VLVF_ENTRIES, then we found the vlan
+	 * in the VLVF. Else use the first empty VLVF register for this
+	 * vlan id.
+	 */
+	if (regindex >= WX_PSR_VLAN_SWC_ENTRIES) {
+		if (first_empty_slot)
+			regindex = first_empty_slot;
+		else
+			regindex = -ENOMEM;
+	}
+
+	return regindex;
+}
+
+/**
+ *  wx_set_vlvf - Set VLAN Pool Filter
+ *  @wx: pointer to hardware structure
+ *  @vlan: VLAN id to write to VLAN filter
+ *  @vind: VMDq output index that maps queue to VLAN id in VFVFB
+ *  @vlan_on: boolean flag to turn on/off VLAN in VFVF
+ *  @vfta_changed: pointer to boolean flag which indicates whether VFTA
+ *                 should be changed
+ *
+ *  Turn on/off specified bit in VLVF table.
+ **/
+static int wx_set_vlvf(struct wx *wx, u32 vlan, u32 vind, bool vlan_on,
+		       bool *vfta_changed)
+{
+	u32 vt;
+
+	/* If VT Mode is set
+	 *   Either vlan_on
+	 *     make sure the vlan is in VLVF
+	 *     set the vind bit in the matching VLVFB
+	 *   Or !vlan_on
+	 *     clear the pool bit and possibly the vind
+	 */
+	vt = rd32(wx, WX_CFG_PORT_CTL);
+	if (vt & WX_CFG_PORT_CTL_NUM_VT_MASK) {
+		s32 vlvf_index;
+		u32 bits;
+
+		vlvf_index = wx_find_vlvf_slot(wx, vlan);
+		if (vlvf_index < 0)
+			return vlvf_index;
+
+		wr32(wx, WX_PSR_VLAN_SWC_IDX, vlvf_index);
+		if (vlan_on) {
+			/* set the pool bit */
+			if (vind < 32) {
+				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_L);
+				bits |= (1 << vind);
+				wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
+			} else {
+				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_H);
+				bits |= (1 << (vind - 32));
+				wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
+			}
+		} else {
+			/* clear the pool bit */
+			if (vind < 32) {
+				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_L);
+				bits &= ~(1 << vind);
+				wr32(wx, WX_PSR_VLAN_SWC_VM_L, bits);
+				bits |= rd32(wx, WX_PSR_VLAN_SWC_VM_H);
+			} else {
+				bits = rd32(wx, WX_PSR_VLAN_SWC_VM_H);
+				bits &= ~(1 << (vind - 32));
+				wr32(wx, WX_PSR_VLAN_SWC_VM_H, bits);
+				bits |= rd32(wx, WX_PSR_VLAN_SWC_VM_L);
+			}
+		}
+
+		if (bits) {
+			wr32(wx, WX_PSR_VLAN_SWC, (WX_PSR_VLAN_SWC_VIEN | vlan));
+			if (!vlan_on && vfta_changed)
+				*vfta_changed = false;
+		} else {
+			wr32(wx, WX_PSR_VLAN_SWC, 0);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ *  wx_set_vfta - Set VLAN filter table
+ *  @wx: pointer to hardware structure
+ *  @vlan: VLAN id to write to VLAN filter
+ *  @vind: VMDq output index that maps queue to VLAN id in VFVFB
+ *  @vlan_on: boolean flag to turn on/off VLAN in VFVF
+ *
+ *  Turn on/off specified VLAN in the VLAN filter table.
+ **/
+static int wx_set_vfta(struct wx *wx, u32 vlan, u32 vind, bool vlan_on)
+{
+	u32 bitindex, vfta, targetbit;
+	bool vfta_changed = false;
+	int regindex, ret;
+
+	/* this is a 2 part operation - first the VFTA, then the
+	 * VLVF and VLVFB if VT Mode is set
+	 * We don't write the VFTA until we know the VLVF part succeeded.
+	 */
+
+	/* Part 1
+	 * The VFTA is a bitstring made up of 128 32-bit registers
+	 * that enable the particular VLAN id, much like the MTA:
+	 *    bits[11-5]: which register
+	 *    bits[4-0]:  which bit in the register
+	 */
+	regindex = (vlan >> 5) & 0x7F;
+	bitindex = vlan & 0x1F;
+	targetbit = (1 << bitindex);
+	/* errata 5 */
+	vfta = wx->mac.vft_shadow[regindex];
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
+	/* Part 2
+	 * Call wx_set_vlvf to set VLVFB and VLVF
+	 */
+	ret = wx_set_vlvf(wx, vlan, vind, vlan_on, &vfta_changed);
+	if (ret != 0)
+		return ret;
+
+	if (vfta_changed)
+		wr32(wx, WX_PSR_VLAN_TBL(regindex), vfta);
+	wx->mac.vft_shadow[regindex] = vfta;
+
+	return 0;
+}
+
+/**
+ *  wx_clear_vfta - Clear VLAN filter table
+ *  @wx: pointer to hardware structure
+ *
+ *  Clears the VLAN filer table, and the VMDq index associated with the filter
+ **/
+static void wx_clear_vfta(struct wx *wx)
+{
+	u32 offset;
+
+	for (offset = 0; offset < wx->mac.vft_size; offset++) {
+		wr32(wx, WX_PSR_VLAN_TBL(offset), 0);
+		wx->mac.vft_shadow[offset] = 0;
+	}
+
+	for (offset = 0; offset < WX_PSR_VLAN_SWC_ENTRIES; offset++) {
+		wr32(wx, WX_PSR_VLAN_SWC_IDX, offset);
+		wr32(wx, WX_PSR_VLAN_SWC, 0);
+		wr32(wx, WX_PSR_VLAN_SWC_VM_L, 0);
+		wr32(wx, WX_PSR_VLAN_SWC_VM_H, 0);
+	}
+}
+
+int wx_vlan_rx_add_vid(struct net_device *netdev,
+		       __be16 proto, u16 vid)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	/* add VID to filter table */
+	wx_set_vfta(wx, vid, VMDQ_P(0), true);
+	set_bit(vid, wx->active_vlans);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_vlan_rx_add_vid);
+
+int wx_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	/* remove VID from filter table */
+	if (vid)
+		wx_set_vfta(wx, vid, VMDQ_P(0), false);
+	clear_bit(vid, wx->active_vlans);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_vlan_rx_kill_vid);
+
+/**
+ *  wx_start_hw - Prepare hardware for Tx/Rx
+ *  @wx: pointer to hardware structure
+ *
+ *  Starts the hardware using the generic start_hw function
+ *  and the generation start_hw function.
+ *  Then performs revision-specific operations, if any.
+ **/
+void wx_start_hw(struct wx *wx)
+{
+	int i;
+
+	/* Clear the VLAN filter table */
+	wx_clear_vfta(wx);
+	WX_WRITE_FLUSH(wx);
+	/* Clear the rate limiters */
+	for (i = 0; i < wx->mac.max_tx_queues; i++) {
+		wr32(wx, WX_TDM_RP_IDX, i);
+		wr32(wx, WX_TDM_RP_RATE, 0);
+	}
+}
+EXPORT_SYMBOL(wx_start_hw);
+
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index c173c56f0ab5..1f93ca32c921 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -26,10 +26,13 @@ void wx_set_rx_mode(struct net_device *netdev);
 int wx_change_mtu(struct net_device *netdev, int new_mtu);
 void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring);
 void wx_configure(struct wx *wx);
+void wx_start_hw(struct wx *wx);
 int wx_disable_pcie_master(struct wx *wx);
 int wx_stop_adapter(struct wx *wx);
 void wx_reset_misc(struct wx *wx);
 int wx_get_pcie_msix_counts(struct wx *wx, u16 *msix_count, u16 max_msix_count);
 int wx_sw_init(struct wx *wx);
+int wx_vlan_rx_add_vid(struct net_device *netdev, __be16 proto, u16 vid);
+int wx_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid);
 
 #endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 3f1e905df542..7dad09afea8d 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -499,6 +499,23 @@ static inline void wx_rx_checksum(struct wx_ring *ring,
 	ring->rx_stats.csum_good_cnt++;
 }
 
+static void wx_rx_vlan(struct wx_ring *ring, union wx_rx_desc *rx_desc,
+		       struct sk_buff *skb)
+{
+	u16 ethertype;
+	u8 idx = 0;
+
+	if ((ring->netdev->features &
+	     (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)) &&
+	    wx_test_staterr(rx_desc, WX_RXD_STAT_VP)) {
+		idx = (le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+		       0x1c0) >> 6;
+		ethertype = ring->q_vector->wx->tpid[idx];
+		__vlan_hwaccel_put_tag(skb, htons(ethertype),
+				       le16_to_cpu(rx_desc->wb.upper.vlan));
+	}
+}
+
 /**
  * wx_process_skb_fields - Populate skb header fields from Rx descriptor
  * @rx_ring: rx descriptor ring packet is being transacted on
@@ -515,6 +532,7 @@ static void wx_process_skb_fields(struct wx_ring *rx_ring,
 {
 	wx_rx_hash(rx_ring, rx_desc, skb);
 	wx_rx_checksum(rx_ring, rx_desc, skb);
+	wx_rx_vlan(rx_ring, rx_desc, skb);
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 }
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index a1158466695a..218b8da70c80 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -6,6 +6,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/netdevice.h>
+#include <linux/if_vlan.h>
 #include <net/ip.h>
 
 #define WX_NCSI_SUP                             0x8000
@@ -65,6 +66,8 @@
 #define WX_CFG_PORT_CTL_QINQ         BIT(2)
 #define WX_CFG_PORT_CTL_D_VLAN       BIT(0) /* double vlan*/
 #define WX_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
+#define WX_CFG_PORT_CTL_NUM_VT_MASK  GENMASK(13, 12) /* number of TVs */
+
 
 /* GPIO Registers */
 #define WX_GPIO_DR                   0x14800
@@ -88,6 +91,8 @@
 /* TDM CTL BIT */
 #define WX_TDM_CTL_TE                BIT(0) /* Transmit Enable */
 #define WX_TDM_PB_THRE(_i)           (0x18020 + ((_i) * 4))
+#define WX_TDM_RP_IDX                0x1820C
+#define WX_TDM_RP_RATE               0x18404
 
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
@@ -151,6 +156,9 @@
 #define WX_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define WX_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 
+/* vlan tbl */
+#define WX_PSR_VLAN_TBL(_i)          (0x16000 + ((_i) * 4))
+
 /* mac switcher */
 #define WX_PSR_MAC_SWC_AD_L          0x16200
 #define WX_PSR_MAC_SWC_AD_H          0x16204
@@ -162,6 +170,15 @@
 #define WX_PSR_MAC_SWC_IDX           0x16210
 #define WX_CLEAR_VMDQ_ALL            0xFFFFFFFFU
 
+/* vlan switch */
+#define WX_PSR_VLAN_SWC              0x16220
+#define WX_PSR_VLAN_SWC_VM_L         0x16224
+#define WX_PSR_VLAN_SWC_VM_H         0x16228
+#define WX_PSR_VLAN_SWC_IDX          0x16230         /* 64 vlan entries */
+/* VLAN pool filtering masks */
+#define WX_PSR_VLAN_SWC_VIEN         BIT(31)  /* filter is valid */
+#define WX_PSR_VLAN_SWC_ENTRIES      64
+
 /********************************* RSEC **************************************/
 /* general rsec */
 #define WX_RSC_CTL                   0x17000
@@ -256,6 +273,7 @@
 #define WX_PX_RR_RP(_i)              (0x0100C + ((_i) * 0x40))
 #define WX_PX_RR_CFG(_i)             (0x01010 + ((_i) * 0x40))
 /* PX_RR_CFG bit definitions */
+#define WX_PX_RR_CFG_VLAN            BIT(31)
 #define WX_PX_RR_CFG_SPLIT_MODE      BIT(26)
 #define WX_PX_RR_CFG_RR_THER_SHIFT   16
 #define WX_PX_RR_CFG_RR_HDR_SZ       GENMASK(15, 12)
@@ -533,6 +551,8 @@ enum wx_tx_flags {
 
 /* VLAN info */
 #define WX_TX_FLAGS_VLAN_MASK			GENMASK(31, 16)
+#define WX_TX_FLAGS_VLAN_PRIO_MASK		GENMASK(31, 29)
+#define WX_TX_FLAGS_VLAN_PRIO_SHIFT		29
 #define WX_TX_FLAGS_VLAN_SHIFT			16
 
 /**
@@ -1023,6 +1043,7 @@ struct wx_ring_container {
 };
 
 struct wx_fwd_adapter {
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 	struct net_device *vdev;
 	struct wx *wx;
 	unsigned int tx_base_queue;
@@ -1095,6 +1116,8 @@ enum wx_isb_idx {
 };
 
 struct wx {
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
+
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
 	struct net_device *netdev;
-- 
2.40.0

