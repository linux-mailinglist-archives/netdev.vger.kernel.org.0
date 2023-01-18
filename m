Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB58671532
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjARHks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjARHi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:38:27 -0500
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCAC5FD66
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 22:59:52 -0800 (PST)
X-QQ-mid: bizesmtp80t1674025121tl615zaj
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 18 Jan 2023 14:58:39 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: 4g9JbZ7lBbGhFJcS4T+3df+0IuDFNFvuF3/fS1zBdSrYPSQE9iruHxFBWYrZL
        5/7P7PKOfEqliFMnJQSJ7R6ZHnGGb2Ngy8t/jePYai9hqo3oVcGF07+9She8me5JfLKpI7z
        V81eX70eKMszUZvZtd4Vs7KR181Q3MObUbWVqi3nBx3epVnCPO9ayAH4ylR4DdANRmXOI+0
        Ayjk9w38X+jGfpMm27HSIE63l7+NiIdOWuM06haHXI4Bi+gHy+7b46JhGCNXN8HL4LMgrp0
        /u0tCFQq+MbS40BOnPaZla1lyKK5I8B7nfkLG/fBAvRCFxjprJ6ynk8jlEcoRBaU/6hlD/Z
        /wIdia7XWSO+ZyIPPwSFlfR7hGYCezR518ed51aTzzCQtSUl2+OtRqr15B9yW/35YP6UGOs
        dzsWVP/I1YuPmww7zqHf/g==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 04/10] net: libwx: Configure Rx and Tx unit on hardware
Date:   Wed, 18 Jan 2023 14:54:58 +0800
Message-Id: <20230118065504.3075474-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
References: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure hardware for preparing to process packets. Including configure
receive and transmit unit of the MAC layer, and setup the specific rings.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   | 597 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  85 +++
 3 files changed, 684 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 12718982620c..e969ae0d350e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -804,6 +804,37 @@ void wx_flush_sw_mac_table(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_flush_sw_mac_table);
 
+static int wx_add_mac_filter(struct wx *wx, u8 *addr, u16 pool)
+{
+	u32 i;
+
+	if (is_zero_ether_addr(addr))
+		return -EINVAL;
+
+	for (i = 0; i < wx->mac.num_rar_entries; i++) {
+		if (wx->mac_table[i].state & WX_MAC_STATE_IN_USE) {
+			if (ether_addr_equal(addr, wx->mac_table[i].addr)) {
+				if (wx->mac_table[i].pools != (1ULL << pool)) {
+					memcpy(wx->mac_table[i].addr, addr, ETH_ALEN);
+					wx->mac_table[i].pools |= (1ULL << pool);
+					wx_sync_mac_table(wx);
+					return i;
+				}
+			}
+		}
+
+		if (wx->mac_table[i].state & WX_MAC_STATE_IN_USE)
+			continue;
+		wx->mac_table[i].state |= (WX_MAC_STATE_MODIFIED |
+					   WX_MAC_STATE_IN_USE);
+		memcpy(wx->mac_table[i].addr, addr, ETH_ALEN);
+		wx->mac_table[i].pools |= (1ULL << pool);
+		wx_sync_mac_table(wx);
+		return i;
+	}
+	return -ENOMEM;
+}
+
 static int wx_del_mac_filter(struct wx *wx, u8 *addr, u16 pool)
 {
 	u32 i;
@@ -828,6 +859,184 @@ static int wx_del_mac_filter(struct wx *wx, u8 *addr, u16 pool)
 	return -ENOMEM;
 }
 
+static int wx_available_rars(struct wx *wx)
+{
+	u32 i, count = 0;
+
+	for (i = 0; i < wx->mac.num_rar_entries; i++) {
+		if (wx->mac_table[i].state == 0)
+			count++;
+	}
+
+	return count;
+}
+
+/**
+ * wx_write_uc_addr_list - write unicast addresses to RAR table
+ * @netdev: network interface device structure
+ * @pool: index for mac table
+ *
+ * Writes unicast address list to the RAR table.
+ * Returns: -ENOMEM on failure/insufficient address space
+ *                0 on no addresses written
+ *                X on writing X addresses to the RAR table
+ **/
+static int wx_write_uc_addr_list(struct net_device *netdev, int pool)
+{
+	struct wx *wx = netdev_priv(netdev);
+	int count = 0;
+
+	/* return ENOMEM indicating insufficient memory for addresses */
+	if (netdev_uc_count(netdev) > wx_available_rars(wx))
+		return -ENOMEM;
+
+	if (!netdev_uc_empty(netdev)) {
+		struct netdev_hw_addr *ha;
+
+		netdev_for_each_uc_addr(ha, netdev) {
+			wx_del_mac_filter(wx, ha->addr, pool);
+			wx_add_mac_filter(wx, ha->addr, pool);
+			count++;
+		}
+	}
+	return count;
+}
+
+/**
+ *  wx_mta_vector - Determines bit-vector in multicast table to set
+ *  @wx: pointer to private structure
+ *  @mc_addr: the multicast address
+ *
+ *  Extracts the 12 bits, from a multicast address, to determine which
+ *  bit-vector to set in the multicast table. The hardware uses 12 bits, from
+ *  incoming rx multicast addresses, to determine the bit-vector to check in
+ *  the MTA. Which of the 4 combination, of 12-bits, the hardware uses is set
+ *  by the MO field of the MCSTCTRL. The MO field is set during initialization
+ *  to mc_filter_type.
+ **/
+static u32 wx_mta_vector(struct wx *wx, u8 *mc_addr)
+{
+	u32 vector = 0;
+
+	switch (wx->mac.mc_filter_type) {
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
+		wx_err(wx, "MC filter type param set incorrectly\n");
+		break;
+	}
+
+	/* vector can only be 12-bits or boundary will be exceeded */
+	vector &= 0xFFF;
+	return vector;
+}
+
+/**
+ *  wx_set_mta - Set bit-vector in multicast table
+ *  @wx: pointer to private structure
+ *  @mc_addr: Multicast address
+ *
+ *  Sets the bit-vector in the multicast table.
+ **/
+static void wx_set_mta(struct wx *wx, u8 *mc_addr)
+{
+	u32 vector, vector_bit, vector_reg;
+
+	wx->addr_ctrl.mta_in_use++;
+
+	vector = wx_mta_vector(wx, mc_addr);
+	wx_dbg(wx, " bit-vector = 0x%03X\n", vector);
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
+	wx->mac.mta_shadow[vector_reg] |= (1 << vector_bit);
+}
+
+/**
+ *  wx_update_mc_addr_list - Updates MAC list of multicast addresses
+ *  @wx: pointer to private structure
+ *  @netdev: pointer to net device structure
+ *
+ *  The given list replaces any existing list. Clears the MC addrs from receive
+ *  address registers and the multicast table. Uses unused receive address
+ *  registers for the first multicast addresses, and hashes the rest into the
+ *  multicast table.
+ **/
+static void wx_update_mc_addr_list(struct wx *wx, struct net_device *netdev)
+{
+	struct netdev_hw_addr *ha;
+	u32 i, psrctl;
+
+	/* Set the new number of MC addresses that we are being requested to
+	 * use.
+	 */
+	wx->addr_ctrl.num_mc_addrs = netdev_mc_count(netdev);
+	wx->addr_ctrl.mta_in_use = 0;
+
+	/* Clear mta_shadow */
+	wx_dbg(wx, " Clearing MTA\n");
+	memset(&wx->mac.mta_shadow, 0, sizeof(wx->mac.mta_shadow));
+
+	/* Update mta_shadow */
+	netdev_for_each_mc_addr(ha, netdev) {
+		wx_dbg(wx, " Adding the multicast addresses:\n");
+		wx_set_mta(wx, ha->addr);
+	}
+
+	/* Enable mta */
+	for (i = 0; i < wx->mac.mcft_size; i++)
+		wr32a(wx, WX_PSR_MC_TBL(0), i,
+		      wx->mac.mta_shadow[i]);
+
+	if (wx->addr_ctrl.mta_in_use > 0) {
+		psrctl = rd32(wx, WX_PSR_CTL);
+		psrctl &= ~(WX_PSR_CTL_MO | WX_PSR_CTL_MFE);
+		psrctl |= WX_PSR_CTL_MFE |
+			  (wx->mac.mc_filter_type << WX_PSR_CTL_MO_SHIFT);
+		wr32(wx, WX_PSR_CTL, psrctl);
+	}
+
+	wx_dbg(wx, "Update mc addr list Complete\n");
+}
+
+/**
+ * wx_write_mc_addr_list - write multicast addresses to MTA
+ * @netdev: network interface device structure
+ *
+ * Writes multicast address list to the MTA hash table.
+ * Returns: 0 on no addresses written
+ *          X on writing X addresses to MTA
+ **/
+static int wx_write_mc_addr_list(struct net_device *netdev)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	if (!netif_running(netdev))
+		return 0;
+
+	wx_update_mc_addr_list(wx, netdev);
+
+	return netdev_mc_count(netdev);
+}
+
 /**
  * wx_set_mac - Change the Ethernet Address of the NIC
  * @netdev: network interface device structure
@@ -883,6 +1092,385 @@ void wx_disable_rx(struct wx *wx)
 }
 EXPORT_SYMBOL(wx_disable_rx);
 
+static void wx_enable_rx(struct wx *wx)
+{
+	u32 psrctl;
+
+	/* enable mac receiver */
+	wr32m(wx, WX_MAC_RX_CFG,
+	      WX_MAC_RX_CFG_RE, WX_MAC_RX_CFG_RE);
+
+	wr32m(wx, WX_RDB_PB_CTL,
+	      WX_RDB_PB_CTL_RXEN, WX_RDB_PB_CTL_RXEN);
+
+	if (wx->mac.set_lben) {
+		psrctl = rd32(wx, WX_PSR_CTL);
+		psrctl |= WX_PSR_CTL_SW_EN;
+		wr32(wx, WX_PSR_CTL, psrctl);
+		wx->mac.set_lben = false;
+	}
+}
+
+/**
+ * wx_set_rxpba - Initialize Rx packet buffer
+ * @wx: pointer to private structure
+ **/
+static void wx_set_rxpba(struct wx *wx)
+{
+	u32 rxpktsize, txpktsize, txpbthresh;
+
+	rxpktsize = wx->mac.rx_pb_size << WX_RDB_PB_SZ_SHIFT;
+	wr32(wx, WX_RDB_PB_SZ(0), rxpktsize);
+
+	/* Only support an equally distributed Tx packet buffer strategy. */
+	txpktsize = wx->mac.tx_pb_size;
+	txpbthresh = (txpktsize / 1024) - WX_TXPKT_SIZE_MAX;
+	wr32(wx, WX_TDB_PB_SZ(0), txpktsize);
+	wr32(wx, WX_TDM_PB_THRE(0), txpbthresh);
+}
+
+static void wx_configure_port(struct wx *wx)
+{
+	u32 value, i;
+
+	value = WX_CFG_PORT_CTL_D_VLAN | WX_CFG_PORT_CTL_QINQ;
+	wr32m(wx, WX_CFG_PORT_CTL,
+	      WX_CFG_PORT_CTL_D_VLAN |
+	      WX_CFG_PORT_CTL_QINQ,
+	      value);
+
+	wr32(wx, WX_CFG_TAG_TPID(0),
+	     ETH_P_8021Q | ETH_P_8021AD << 16);
+	wx->tpid[0] = ETH_P_8021Q;
+	wx->tpid[1] = ETH_P_8021AD;
+	for (i = 1; i < 4; i++)
+		wr32(wx, WX_CFG_TAG_TPID(i),
+		     ETH_P_8021Q | ETH_P_8021Q << 16);
+	for (i = 2; i < 8; i++)
+		wx->tpid[i] = ETH_P_8021Q;
+}
+
+/**
+ *  wx_disable_sec_rx_path - Stops the receive data path
+ *  @wx: pointer to private structure
+ *
+ *  Stops the receive data path and waits for the HW to internally empty
+ *  the Rx security block
+ **/
+static int wx_disable_sec_rx_path(struct wx *wx)
+{
+	u32 secrx;
+
+	wr32m(wx, WX_RSC_CTL,
+	      WX_RSC_CTL_RX_DIS, WX_RSC_CTL_RX_DIS);
+
+	return read_poll_timeout(rd32, secrx, secrx & WX_RSC_ST_RSEC_RDY,
+				 1000, 40000, false, wx, WX_RSC_ST);
+}
+
+/**
+ *  wx_enable_sec_rx_path - Enables the receive data path
+ *  @wx: pointer to private structure
+ *
+ *  Enables the receive data path.
+ **/
+static void wx_enable_sec_rx_path(struct wx *wx)
+{
+	wr32m(wx, WX_RSC_CTL, WX_RSC_CTL_RX_DIS, 0);
+	WX_WRITE_FLUSH(wx);
+}
+
+void wx_set_rx_mode(struct net_device *netdev)
+{
+	struct wx *wx = netdev_priv(netdev);
+	u32 fctrl, vmolr, vlnctrl;
+	int count;
+
+	/* Check for Promiscuous and All Multicast modes */
+	fctrl = rd32(wx, WX_PSR_CTL);
+	fctrl &= ~(WX_PSR_CTL_UPE | WX_PSR_CTL_MPE);
+	vmolr = rd32(wx, WX_PSR_VM_L2CTL(0));
+	vmolr &= ~(WX_PSR_VM_L2CTL_UPE |
+		   WX_PSR_VM_L2CTL_MPE |
+		   WX_PSR_VM_L2CTL_ROPE |
+		   WX_PSR_VM_L2CTL_ROMPE);
+	vlnctrl = rd32(wx, WX_PSR_VLAN_CTL);
+	vlnctrl &= ~(WX_PSR_VLAN_CTL_VFE | WX_PSR_VLAN_CTL_CFIEN);
+
+	/* set all bits that we expect to always be set */
+	fctrl |= WX_PSR_CTL_BAM | WX_PSR_CTL_MFE;
+	vmolr |= WX_PSR_VM_L2CTL_BAM |
+		 WX_PSR_VM_L2CTL_AUPE |
+		 WX_PSR_VM_L2CTL_VACC;
+	vlnctrl |= WX_PSR_VLAN_CTL_VFE;
+
+	wx->addr_ctrl.user_set_promisc = false;
+	if (netdev->flags & IFF_PROMISC) {
+		wx->addr_ctrl.user_set_promisc = true;
+		fctrl |= WX_PSR_CTL_UPE | WX_PSR_CTL_MPE;
+		/* pf don't want packets routing to vf, so clear UPE */
+		vmolr |= WX_PSR_VM_L2CTL_MPE;
+		vlnctrl &= ~WX_PSR_VLAN_CTL_VFE;
+	}
+
+	if (netdev->flags & IFF_ALLMULTI) {
+		fctrl |= WX_PSR_CTL_MPE;
+		vmolr |= WX_PSR_VM_L2CTL_MPE;
+	}
+
+	if (netdev->features & NETIF_F_RXALL) {
+		vmolr |= (WX_PSR_VM_L2CTL_UPE | WX_PSR_VM_L2CTL_MPE);
+		vlnctrl &= ~WX_PSR_VLAN_CTL_VFE;
+		/* receive bad packets */
+		wr32m(wx, WX_RSC_CTL,
+		      WX_RSC_CTL_SAVE_MAC_ERR,
+		      WX_RSC_CTL_SAVE_MAC_ERR);
+	} else {
+		vmolr |= WX_PSR_VM_L2CTL_ROPE | WX_PSR_VM_L2CTL_ROMPE;
+	}
+
+	/* Write addresses to available RAR registers, if there is not
+	 * sufficient space to store all the addresses then enable
+	 * unicast promiscuous mode
+	 */
+	count = wx_write_uc_addr_list(netdev, 0);
+	if (count < 0) {
+		vmolr &= ~WX_PSR_VM_L2CTL_ROPE;
+		vmolr |= WX_PSR_VM_L2CTL_UPE;
+	}
+
+	/* Write addresses to the MTA, if the attempt fails
+	 * then we should just turn on promiscuous mode so
+	 * that we can at least receive multicast traffic
+	 */
+	count = wx_write_mc_addr_list(netdev);
+	if (count < 0) {
+		vmolr &= ~WX_PSR_VM_L2CTL_ROMPE;
+		vmolr |= WX_PSR_VM_L2CTL_MPE;
+	}
+
+	wr32(wx, WX_PSR_VLAN_CTL, vlnctrl);
+	wr32(wx, WX_PSR_CTL, fctrl);
+	wr32(wx, WX_PSR_VM_L2CTL(0), vmolr);
+}
+EXPORT_SYMBOL(wx_set_rx_mode);
+
+static void wx_set_rx_buffer_len(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	u32 mhadd, max_frame;
+
+	max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	/* adjust max frame to be at least the size of a standard frame */
+	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
+		max_frame = (ETH_FRAME_LEN + ETH_FCS_LEN);
+
+	mhadd = rd32(wx, WX_PSR_MAX_SZ);
+	if (max_frame != mhadd)
+		wr32(wx, WX_PSR_MAX_SZ, max_frame);
+}
+
+/* Disable the specified rx queue */
+void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring)
+{
+	u8 reg_idx = ring->reg_idx;
+	u32 rxdctl;
+	int ret;
+
+	/* write value back with RRCFG.EN bit cleared */
+	wr32m(wx, WX_PX_RR_CFG(reg_idx),
+	      WX_PX_RR_CFG_RR_EN, 0);
+
+	/* the hardware may take up to 100us to really disable the rx queue */
+	ret = read_poll_timeout(rd32, rxdctl, !(rxdctl & WX_PX_RR_CFG_RR_EN),
+				10, 100, true, wx, WX_PX_RR_CFG(reg_idx));
+
+	if (ret == -ETIMEDOUT) {
+		/* Just for information */
+		wx_err(wx,
+		       "RRCFG.EN on Rx queue %d not cleared within the polling period\n",
+		       reg_idx);
+	}
+}
+EXPORT_SYMBOL(wx_disable_rx_queue);
+
+static void wx_enable_rx_queue(struct wx *wx, struct wx_ring *ring)
+{
+	u8 reg_idx = ring->reg_idx;
+	u32 rxdctl;
+	int ret;
+
+	ret = read_poll_timeout(rd32, rxdctl, rxdctl & WX_PX_RR_CFG_RR_EN,
+				1000, 10000, true, wx, WX_PX_RR_CFG(reg_idx));
+
+	if (ret == -ETIMEDOUT) {
+		/* Just for information */
+		wx_err(wx,
+		       "RRCFG.EN on Rx queue %d not set within the polling period\n",
+		       reg_idx);
+	}
+}
+
+static void wx_configure_srrctl(struct wx *wx,
+				struct wx_ring *rx_ring)
+{
+	u16 reg_idx = rx_ring->reg_idx;
+	u32 srrctl;
+
+	srrctl = rd32(wx, WX_PX_RR_CFG(reg_idx));
+	srrctl &= ~(WX_PX_RR_CFG_RR_HDR_SZ |
+		    WX_PX_RR_CFG_RR_BUF_SZ |
+		    WX_PX_RR_CFG_SPLIT_MODE);
+	/* configure header buffer length, needed for RSC */
+	srrctl |= WX_RXBUFFER_256 << WX_PX_RR_CFG_BHDRSIZE_SHIFT;
+
+	/* configure the packet buffer length */
+	srrctl |= WX_RX_BUFSZ >> WX_PX_RR_CFG_BSIZEPKT_SHIFT;
+
+	wr32(wx, WX_PX_RR_CFG(reg_idx), srrctl);
+}
+
+static void wx_configure_tx_ring(struct wx *wx,
+				 struct wx_ring *ring)
+{
+	u32 txdctl = WX_PX_TR_CFG_ENABLE;
+	u8 reg_idx = ring->reg_idx;
+	int ret;
+
+	/* disable queue to avoid issues while updating state */
+	wr32(wx, WX_PX_TR_CFG(reg_idx), WX_PX_TR_CFG_SWFLSH);
+	WX_WRITE_FLUSH(wx);
+
+	/* reset head and tail pointers */
+	wr32(wx, WX_PX_TR_RP(reg_idx), 0);
+	wr32(wx, WX_PX_TR_WP(reg_idx), 0);
+	ring->tail = wx->hw_addr + WX_PX_TR_WP(reg_idx);
+
+	if (ring->count < WX_MAX_TXD)
+		txdctl |= ring->count / 128 << WX_PX_TR_CFG_TR_SIZE_SHIFT;
+	txdctl |= 0x20 << WX_PX_TR_CFG_WTHRESH_SHIFT;
+
+	/* enable queue */
+	wr32(wx, WX_PX_TR_CFG(reg_idx), txdctl);
+
+	/* poll to verify queue is enabled */
+	ret = read_poll_timeout(rd32, txdctl, txdctl & WX_PX_TR_CFG_ENABLE,
+				1000, 10000, true, wx, WX_PX_TR_CFG(reg_idx));
+	if (ret == -ETIMEDOUT)
+		wx_err(wx, "Could not enable Tx Queue %d\n", reg_idx);
+}
+
+static void wx_configure_rx_ring(struct wx *wx,
+				 struct wx_ring *ring)
+{
+	u16 reg_idx = ring->reg_idx;
+	u32 rxdctl;
+
+	/* disable queue to avoid issues while updating state */
+	rxdctl = rd32(wx, WX_PX_RR_CFG(reg_idx));
+	wx_disable_rx_queue(wx, ring);
+
+	if (ring->count == WX_MAX_RXD)
+		rxdctl |= 0 << WX_PX_RR_CFG_RR_SIZE_SHIFT;
+	else
+		rxdctl |= (ring->count / 128) << WX_PX_RR_CFG_RR_SIZE_SHIFT;
+
+	rxdctl |= 0x1 << WX_PX_RR_CFG_RR_THER_SHIFT;
+	wr32(wx, WX_PX_RR_CFG(reg_idx), rxdctl);
+
+	/* reset head and tail pointers */
+	wr32(wx, WX_PX_RR_RP(reg_idx), 0);
+	wr32(wx, WX_PX_RR_WP(reg_idx), 0);
+	ring->tail = wx->hw_addr + WX_PX_RR_WP(reg_idx);
+
+	wx_configure_srrctl(wx, ring);
+
+	/* enable receive descriptor ring */
+	wr32m(wx, WX_PX_RR_CFG(reg_idx),
+	      WX_PX_RR_CFG_RR_EN, WX_PX_RR_CFG_RR_EN);
+
+	wx_enable_rx_queue(wx, ring);
+}
+
+/**
+ * wx_configure_tx - Configure Transmit Unit after Reset
+ * @wx: pointer to private structure
+ *
+ * Configure the Tx unit of the MAC after a reset.
+ **/
+static void wx_configure_tx(struct wx *wx)
+{
+	u32 i;
+
+	/* TDM_CTL.TE must be before Tx queues are enabled */
+	wr32m(wx, WX_TDM_CTL,
+	      WX_TDM_CTL_TE, WX_TDM_CTL_TE);
+
+	/* Setup the HW Tx Head and Tail descriptor pointers */
+	for (i = 0; i < wx->num_tx_queues; i++)
+		wx_configure_tx_ring(wx, wx->tx_ring[i]);
+
+	wr32m(wx, WX_TSC_BUF_AE, WX_TSC_BUF_AE_THR, 0x10);
+
+	if (wx->mac.type == wx_mac_em)
+		wr32m(wx, WX_TSC_CTL, WX_TSC_CTL_TX_DIS | WX_TSC_CTL_TSEC_DIS, 0x1);
+
+	/* enable mac transmitter */
+	wr32m(wx, WX_MAC_TX_CFG,
+	      WX_MAC_TX_CFG_TE, WX_MAC_TX_CFG_TE);
+}
+
+/**
+ * wx_configure_rx - Configure Receive Unit after Reset
+ * @wx: pointer to private structure
+ *
+ * Configure the Rx unit of the MAC after a reset.
+ **/
+static void wx_configure_rx(struct wx *wx)
+{
+	u32 psrtype, i;
+	int ret;
+
+	wx_disable_rx(wx);
+
+	psrtype = WX_RDB_PL_CFG_L4HDR |
+		  WX_RDB_PL_CFG_L3HDR |
+		  WX_RDB_PL_CFG_L2HDR |
+		  WX_RDB_PL_CFG_TUN_TUNHDR |
+		  WX_RDB_PL_CFG_TUN_TUNHDR;
+	wr32(wx, WX_RDB_PL_CFG(0), psrtype);
+
+	/* enable hw crc stripping */
+	wr32m(wx, WX_RSC_CTL, WX_RSC_CTL_CRC_STRIP, WX_RSC_CTL_CRC_STRIP);
+
+	if (wx->mac.type == wx_mac_sp) {
+		u32 psrctl;
+
+		/* RSC Setup */
+		psrctl = rd32(wx, WX_PSR_CTL);
+		psrctl |= WX_PSR_CTL_RSC_ACK; /* Disable RSC for ACK packets */
+		psrctl |= WX_PSR_CTL_RSC_DIS;
+		wr32(wx, WX_PSR_CTL, psrctl);
+	}
+
+	/* set_rx_buffer_len must be called before ring initialization */
+	wx_set_rx_buffer_len(wx);
+
+	/* Setup the HW Rx Head and Tail Descriptor Pointers and
+	 * the Base and Length of the Rx Descriptor Ring
+	 */
+	for (i = 0; i < wx->num_rx_queues; i++)
+		wx_configure_rx_ring(wx, wx->rx_ring[i]);
+
+	/* Enable all receives, disable security engine prior to block traffic */
+	ret = wx_disable_sec_rx_path(wx);
+	if (ret < 0)
+		wx_err(wx, "The register status is abnormal, please check device.");
+
+	wx_enable_rx(wx);
+	wx_enable_sec_rx_path(wx);
+}
+
 static void wx_configure_isb(struct wx *wx)
 {
 	/* set ISB Address */
@@ -892,6 +1480,15 @@ static void wx_configure_isb(struct wx *wx)
 
 void wx_configure(struct wx *wx)
 {
+	wx_set_rxpba(wx);
+	wx_configure_port(wx);
+
+	wx_set_rx_mode(wx->netdev);
+
+	wx_enable_sec_rx_path(wx);
+
+	wx_configure_tx(wx);
+	wx_configure_rx(wx);
 	wx_configure_isb(wx);
 }
 EXPORT_SYMBOL(wx_configure);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 60bda129cfa6..44dfd6ea442a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -22,6 +22,8 @@ void wx_mac_set_default_filter(struct wx *wx, u8 *addr);
 void wx_flush_sw_mac_table(struct wx *wx);
 int wx_set_mac(struct net_device *netdev, void *p);
 void wx_disable_rx(struct wx *wx);
+void wx_set_rx_mode(struct net_device *netdev);
+void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring);
 void wx_configure(struct wx *wx);
 int wx_disable_pcie_master(struct wx *wx);
 int wx_stop_adapter(struct wx *wx);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 7368c681221f..988878ddba47 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -66,6 +66,9 @@
 /* port cfg Registers */
 #define WX_CFG_PORT_CTL              0x14400
 #define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
+#define WX_CFG_PORT_CTL_QINQ         BIT(2)
+#define WX_CFG_PORT_CTL_D_VLAN       BIT(0) /* double vlan*/
+#define WX_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
 
 /* GPIO Registers */
 #define WX_GPIO_DR                   0x14800
@@ -88,15 +91,25 @@
 #define WX_TDM_CTL                   0x18000
 /* TDM CTL BIT */
 #define WX_TDM_CTL_TE                BIT(0) /* Transmit Enable */
+#define WX_TDM_PB_THRE(_i)           (0x18020 + ((_i) * 4))
 
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
 #define WX_RDB_PB_CTL                0x19000
 #define WX_RDB_PB_CTL_RXEN           BIT(31) /* Enable Receiver */
 #define WX_RDB_PB_CTL_DISABLED       BIT(0)
+#define WX_RDB_PB_SZ(_i)             (0x19020 + ((_i) * 4))
+#define WX_RDB_PB_SZ_SHIFT           10
 /* statistic */
 #define WX_RDB_PFCMACDAL             0x19210
 #define WX_RDB_PFCMACDAH             0x19214
+/* ring assignment */
+#define WX_RDB_PL_CFG(_i)            (0x19300 + ((_i) * 4))
+#define WX_RDB_PL_CFG_L4HDR          BIT(1)
+#define WX_RDB_PL_CFG_L3HDR          BIT(2)
+#define WX_RDB_PL_CFG_L2HDR          BIT(3)
+#define WX_RDB_PL_CFG_TUN_TUNHDR     BIT(4)
+#define WX_RDB_PL_CFG_TUN_OUTL2HDR   BIT(5)
 
 /******************************* PSR Registers *******************************/
 /* psr control */
@@ -114,10 +127,24 @@
 #define WX_PSR_CTL_MO_SHIFT          5
 #define WX_PSR_CTL_MO                (0x3 << WX_PSR_CTL_MO_SHIFT)
 #define WX_PSR_CTL_TPE               BIT(4)
+#define WX_PSR_MAX_SZ                0x15020
+#define WX_PSR_VLAN_CTL              0x15088
+#define WX_PSR_VLAN_CTL_CFIEN        BIT(29)  /* bit 29 */
+#define WX_PSR_VLAN_CTL_VFE          BIT(30)  /* bit 30 */
 /* mcasst/ucast overflow tbl */
 #define WX_PSR_MC_TBL(_i)            (0x15200  + ((_i) * 4))
 #define WX_PSR_UC_TBL(_i)            (0x15400 + ((_i) * 4))
 
+/* VM L2 contorl */
+#define WX_PSR_VM_L2CTL(_i)          (0x15600 + ((_i) * 4))
+#define WX_PSR_VM_L2CTL_UPE          BIT(4) /* unicast promiscuous */
+#define WX_PSR_VM_L2CTL_VACC         BIT(6) /* accept nomatched vlan */
+#define WX_PSR_VM_L2CTL_AUPE         BIT(8) /* accept untagged packets */
+#define WX_PSR_VM_L2CTL_ROMPE        BIT(9) /* accept packets in MTA tbl */
+#define WX_PSR_VM_L2CTL_ROPE         BIT(10) /* accept packets in UC tbl */
+#define WX_PSR_VM_L2CTL_BAM          BIT(11) /* accept broadcast packets */
+#define WX_PSR_VM_L2CTL_MPE          BIT(12) /* multicast promiscuous */
+
 /* Management */
 #define WX_PSR_MNG_FLEX_SEL          0x1582C
 #define WX_PSR_MNG_FLEX_DW_L(_i)     (0x15A00 + ((_i) * 16))
@@ -139,6 +166,27 @@
 #define WX_PSR_MAC_SWC_IDX           0x16210
 #define WX_CLEAR_VMDQ_ALL            0xFFFFFFFFU
 
+/********************************* RSEC **************************************/
+/* general rsec */
+#define WX_RSC_CTL                   0x17000
+#define WX_RSC_CTL_SAVE_MAC_ERR      BIT(6)
+#define WX_RSC_CTL_CRC_STRIP         BIT(2)
+#define WX_RSC_CTL_RX_DIS            BIT(1)
+#define WX_RSC_ST                    0x17004
+#define WX_RSC_ST_RSEC_RDY           BIT(0)
+
+/****************************** TDB ******************************************/
+#define WX_TDB_PB_SZ(_i)             (0x1CC00 + ((_i) * 4))
+#define WX_TXPKT_SIZE_MAX            0xA /* Max Tx Packet size */
+
+/****************************** TSEC *****************************************/
+/* Security Control Registers */
+#define WX_TSC_CTL                   0x1D000
+#define WX_TSC_CTL_TX_DIS            BIT(1)
+#define WX_TSC_CTL_TSEC_DIS          BIT(0)
+#define WX_TSC_BUF_AE                0x1D00C
+#define WX_TSC_BUF_AE_THR            GENMASK(9, 0)
+
 /************************************** MNG ********************************/
 #define WX_MNG_SWFW_SYNC             0x1E008
 #define WX_MNG_SWFW_SYNC_SW_MB       BIT(2)
@@ -192,6 +240,10 @@
 #define WX_EM_MAX_EITR               0x00007FFCU
 
 /* transmit DMA Registers */
+#define WX_PX_TR_BAL(_i)             (0x03000 + ((_i) * 0x40))
+#define WX_PX_TR_BAH(_i)             (0x03004 + ((_i) * 0x40))
+#define WX_PX_TR_WP(_i)              (0x03008 + ((_i) * 0x40))
+#define WX_PX_TR_RP(_i)              (0x0300C + ((_i) * 0x40))
 #define WX_PX_TR_CFG(_i)             (0x03010 + ((_i) * 0x40))
 /* Transmit Config masks */
 #define WX_PX_TR_CFG_ENABLE          BIT(0) /* Ena specific Tx Queue */
@@ -201,8 +253,22 @@
 #define WX_PX_TR_CFG_THRE_SHIFT      8
 
 /* Receive DMA Registers */
+#define WX_PX_RR_BAL(_i)             (0x01000 + ((_i) * 0x40))
+#define WX_PX_RR_BAH(_i)             (0x01004 + ((_i) * 0x40))
+#define WX_PX_RR_WP(_i)              (0x01008 + ((_i) * 0x40))
+#define WX_PX_RR_RP(_i)              (0x0100C + ((_i) * 0x40))
 #define WX_PX_RR_CFG(_i)             (0x01010 + ((_i) * 0x40))
 /* PX_RR_CFG bit definitions */
+#define WX_PX_RR_CFG_SPLIT_MODE      BIT(26)
+#define WX_PX_RR_CFG_RR_THER_SHIFT   16
+#define WX_PX_RR_CFG_RR_HDR_SZ       GENMASK(15, 12)
+#define WX_PX_RR_CFG_RR_BUF_SZ       GENMASK(11, 8)
+#define WX_PX_RR_CFG_BHDRSIZE_SHIFT  6 /* 64byte resolution (>> 6)
+					* + at bit 8 offset (<< 12)
+					*  = (<< 6)
+					*/
+#define WX_PX_RR_CFG_BSIZEPKT_SHIFT  2 /* so many KBs */
+#define WX_PX_RR_CFG_RR_SIZE_SHIFT   1
 #define WX_PX_RR_CFG_RR_EN           BIT(0)
 
 /* Number of 80 microseconds we wait for PCI Express master disable */
@@ -230,6 +296,20 @@
 #define WX_MAC_STATE_MODIFIED        0x2
 #define WX_MAC_STATE_IN_USE          0x4
 
+#define WX_MAX_RXD                   8192
+#define WX_MAX_TXD                   8192
+
+/* Supported Rx Buffer Sizes */
+#define WX_RXBUFFER_256      256    /* Used for skb receive header */
+#define WX_RXBUFFER_2K       2048
+#define WX_MAX_RXBUFFER      16384  /* largest size for single descriptor */
+
+#if MAX_SKB_FRAGS < 8
+#define WX_RX_BUFSZ      ALIGN(WX_MAX_RXBUFFER / MAX_SKB_FRAGS, 1024)
+#else
+#define WX_RX_BUFSZ      WX_RXBUFFER_2K
+#endif
+
 #define WX_CFG_PORT_ST               0x14404
 
 /* Host Interface Command Structures */
@@ -307,9 +387,12 @@ struct wx_mac_info {
 	bool set_lben;
 	u8 addr[ETH_ALEN];
 	u8 perm_addr[ETH_ALEN];
+	u32 mta_shadow[128];
 	s32 mc_filter_type;
 	u32 mcft_size;
 	u32 num_rar_entries;
+	u32 rx_pb_size;
+	u32 tx_pb_size;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
 
@@ -365,6 +448,7 @@ struct wx_ring {
 	struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	u8 __iomem *tail;
 
 	u16 count;                      /* amount of descriptors */
 
@@ -421,6 +505,7 @@ struct wx {
 	u16 oem_svid;
 	u16 msg_enable;
 	bool adapter_stopped;
+	u16 tpid[8];
 	char eeprom_id[32];
 	enum wx_reset_type reset_type;
 
-- 
2.27.0

