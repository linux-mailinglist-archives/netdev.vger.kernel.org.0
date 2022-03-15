Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A154D947B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 07:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbiCOGSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 02:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345161AbiCOGSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 02:18:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26964A3F6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647325039; x=1678861039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qbRc/ogE8uVr9+wZOn0Q1cmhnBkZNCp8HID8ntjHLqE=;
  b=Jh77qd5KOTCLaKLOzXUtqez5AjemKblRLRBKrpSJXqX9l0lmIJWlXIx4
   G8Ttfr61p0GE3SvhBGPpYRMA4relmN8nfBhoXuDf9OGLTDMOkgq2Xo/Jp
   /5UfwhnXjoYmGVYkYNA2GbiRS20I/Oe5d1a8yR9yLLKPMAlb7WWQGWMtw
   thAjLzO8kJpF2r0k9mXHoHxWoPH7WMmiRFU7MOrgBEncGO7PEQMLQoNyr
   mw5V31h+v757xXxvELGFOAsk9r/U78Azo++HW1j7DMBL5ku+R6yOFmdbi
   o/LFVU+a+gF88MKZSMRfT92FyfkcLCfFYwMzM780ulmec09eOoDS1gym0
   g==;
X-IronPort-AV: E=Sophos;i="5.90,182,1643698800"; 
   d="scan'208";a="88938872"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Mar 2022 23:17:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 14 Mar 2022 23:17:18 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 14 Mar 2022 23:17:16 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 4/5] net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)
Date:   Tue, 15 Mar 2022 11:47:00 +0530
Message-ID: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP-IOs block provides for time stamping PTP-IO input events.
PTP-IOs are numbered from 0 to 11.
When a PTP-IO is enabled by the corresponding bit in the PTP-IO
Capture Configuration Register, a rising or falling edge,
respectively, will capture the 1588 Local Time Counter

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.h |  73 ++++
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 329 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_ptp.h  |   9 +
 3 files changed, 375 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index d1036a323c52..9c528705866f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -358,8 +358,18 @@
 #define PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	(BIT((channel) << 2))
 
 #define PTP_INT_STS				(0x0A08)
+#define PTP_INT_IO_FE_MASK_			GENMASK(31, 24)
+#define PTP_INT_IO_FE_SHIFT_			(24)
+#define PTP_INT_IO_FE_SET_(channel)		BIT(24 + (channel))
+#define PTP_INT_IO_RE_MASK_			GENMASK(23, 16)
+#define PTP_INT_IO_RE_SHIFT_			(16)
+#define PTP_INT_IO_RE_SET_(channel)		BIT(16 + (channel))
 #define PTP_INT_EN_SET				(0x0A0C)
+#define PTP_INT_EN_FE_EN_SET_(channel)		BIT(24 + (channel))
+#define PTP_INT_EN_RE_EN_SET_(channel)		BIT(16 + (channel))
 #define PTP_INT_EN_CLR				(0x0A10)
+#define PTP_INT_EN_FE_EN_CLR_(channel)		BIT(24 + (channel))
+#define PTP_INT_EN_RE_EN_CLR_(channel)		BIT(16 + (channel))
 #define PTP_INT_BIT_TX_SWTS_ERR_		BIT(13)
 #define PTP_INT_BIT_TX_TS_			BIT(12)
 #define PTP_INT_BIT_TIMER_B_			BIT(1)
@@ -377,6 +387,16 @@
 #define PTP_CLOCK_TARGET_NS_X(channel)		(0x0A34 + ((channel) << 4))
 #define PTP_CLOCK_TARGET_RELOAD_SEC_X(channel)	(0x0A38 + ((channel) << 4))
 #define PTP_CLOCK_TARGET_RELOAD_NS_X(channel)	(0x0A3C + ((channel) << 4))
+#define PTP_LTC_SET_SEC_HI			(0x0A50)
+#define PTP_LTC_SET_SEC_HI_SEC_47_32_MASK_	GENMASK(15, 0)
+#define PTP_VERSION				(0x0A54)
+#define PTP_VERSION_TX_UP_MASK_			GENMASK(31, 24)
+#define PTP_VERSION_TX_LO_MASK_			GENMASK(23, 16)
+#define PTP_VERSION_RX_UP_MASK_			GENMASK(15, 8)
+#define PTP_VERSION_RX_LO_MASK_			GENMASK(7, 0)
+#define PTP_IO_SEL				(0x0A58)
+#define PTP_IO_SEL_MASK_			GENMASK(10, 8)
+#define PTP_IO_SEL_SHIFT_			(8)
 #define PTP_LATENCY				(0x0A5C)
 #define PTP_LATENCY_TX_SET_(tx_latency)		(((u32)(tx_latency)) << 16)
 #define PTP_LATENCY_RX_SET_(rx_latency)		\
@@ -401,6 +421,59 @@
 #define PTP_TX_MSG_HEADER_MSG_TYPE_		(0x000F0000)
 #define PTP_TX_MSG_HEADER_MSG_TYPE_SYNC_	(0x00000000)
 
+#define PTP_TX_CAP_INFO				(0x0AB8)
+#define PTP_TX_CAP_INFO_TX_CH_MASK_		GENMASK(1, 0)
+#define PTP_TX_DOMAIN				(0x0ABC)
+#define PTP_TX_DOMAIN_MASK_			GENMASK(23, 16)
+#define PTP_TX_DOMAIN_RANGE_EN_			BIT(15)
+#define PTP_TX_DOMAIN_RANGE_MASK_		GENMASK(7, 0)
+#define PTP_TX_SDOID				(0x0AC0)
+#define PTP_TX_SDOID_MASK_			GENMASK(23, 16)
+#define PTP_TX_SDOID_RANGE_EN_			BIT(15)
+#define PTP_TX_SDOID_11_0_MASK_			GENMASK(7, 0)
+#define PTP_IO_CAP_CONFIG			(0x0AC4)
+#define PTP_IO_CAP_CONFIG_LOCK_FE_(channel)	BIT(24 + (channel))
+#define PTP_IO_CAP_CONFIG_LOCK_RE_(channel)	BIT(16 + (channel))
+#define PTP_IO_CAP_CONFIG_FE_CAP_EN_(channel)	BIT(8 + (channel))
+#define PTP_IO_CAP_CONFIG_RE_CAP_EN_(channel)	BIT(0 + (channel))
+#define PTP_IO_RE_LTC_SEC_CAP_X			(0x0AC8)
+#define PTP_IO_RE_LTC_NS_CAP_X			(0x0ACC)
+#define PTP_IO_FE_LTC_SEC_CAP_X			(0x0AD0)
+#define PTP_IO_FE_LTC_NS_CAP_X			(0x0AD4)
+#define PTP_IO_EVENT_OUTPUT_CFG			(0x0AD8)
+#define PTP_IO_EVENT_OUTPUT_CFG_SEL_(channel)	BIT(16 + (channel))
+#define PTP_IO_EVENT_OUTPUT_CFG_EN_(channel)	BIT(0 + (channel))
+#define PTP_IO_PIN_CFG				(0x0ADC)
+#define PTP_IO_PIN_CFG_OBUF_TYPE_(channel)	BIT(0 + (channel))
+#define PTP_LTC_RD_SEC_HI			(0x0AF0)
+#define PTP_LTC_RD_SEC_HI_SEC_47_32_MASK_	GENMASK(15, 0)
+#define PTP_LTC_RD_SEC_LO			(0x0AF4)
+#define PTP_LTC_RD_NS				(0x0AF8)
+#define PTP_LTC_RD_NS_29_0_MASK_		GENMASK(29, 0)
+#define PTP_LTC_RD_SUBNS			(0x0AFC)
+#define PTP_RX_USER_MAC_HI			(0x0B00)
+#define PTP_RX_USER_MAC_HI_47_32_MASK_		GENMASK(15, 0)
+#define PTP_RX_USER_MAC_LO			(0x0B04)
+#define PTP_RX_USER_IP_ADDR_0			(0x0B20)
+#define PTP_RX_USER_IP_ADDR_1			(0x0B24)
+#define PTP_RX_USER_IP_ADDR_2			(0x0B28)
+#define PTP_RX_USER_IP_ADDR_3			(0x0B2C)
+#define PTP_RX_USER_IP_MASK_0			(0x0B30)
+#define PTP_RX_USER_IP_MASK_1			(0x0B34)
+#define PTP_RX_USER_IP_MASK_2			(0x0B38)
+#define PTP_RX_USER_IP_MASK_3			(0x0B3C)
+#define PTP_TX_USER_MAC_HI			(0x0B40)
+#define PTP_TX_USER_MAC_HI_47_32_MASK_		GENMASK(15, 0)
+#define PTP_TX_USER_MAC_LO			(0x0B44)
+#define PTP_TX_USER_IP_ADDR_0			(0x0B60)
+#define PTP_TX_USER_IP_ADDR_1			(0x0B64)
+#define PTP_TX_USER_IP_ADDR_2			(0x0B68)
+#define PTP_TX_USER_IP_ADDR_3			(0x0B6C)
+#define PTP_TX_USER_IP_MASK_0			(0x0B70)
+#define PTP_TX_USER_IP_MASK_1			(0x0B74)
+#define PTP_TX_USER_IP_MASK_2			(0x0B78)
+#define PTP_TX_USER_IP_MASK_3			(0x0B7C)
+
 #define DMAC_CFG				(0xC00)
 #define DMAC_CFG_COAL_EN_			BIT(16)
 #define DMAC_CFG_CH_ARB_SEL_RX_HIGH_		(0x00000000)
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index ec082594bbbd..9fffce5baade 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -25,6 +25,18 @@ static void lan743x_ptp_clock_set(struct lan743x_adapter *adapter,
 				  u32 seconds, u32 nano_seconds,
 				  u32 sub_nano_seconds);
 
+static int lan743x_get_channel(u32 ch_map)
+{
+	int idx;
+
+	for (idx = 0; idx < 32; idx++) {
+		if (ch_map & (0x1 << idx))
+			return idx;
+	}
+
+	return -EINVAL;
+}
+
 int lan743x_gpio_init(struct lan743x_adapter *adapter)
 {
 	struct lan743x_gpio *gpio = &adapter->gpio;
@@ -179,6 +191,8 @@ static void lan743x_ptp_release_event_ch(struct lan743x_adapter *adapter,
 static void lan743x_ptp_clock_get(struct lan743x_adapter *adapter,
 				  u32 *seconds, u32 *nano_seconds,
 				  u32 *sub_nano_seconds);
+static void lan743x_ptp_io_clock_get(struct lan743x_adapter *adapter,
+				     u32 *sec, u32 *nsec, u32 *sub_nsec);
 static void lan743x_ptp_clock_step(struct lan743x_adapter *adapter,
 				   s64 time_step_ns);
 
@@ -407,7 +421,10 @@ static int lan743x_ptpci_gettime64(struct ptp_clock_info *ptpci,
 	u32 nano_seconds = 0;
 	u32 seconds = 0;
 
-	lan743x_ptp_clock_get(adapter, &seconds, &nano_seconds, NULL);
+	if (adapter->is_pci11x1x)
+		lan743x_ptp_io_clock_get(adapter, &seconds, &nano_seconds, NULL);
+	else
+		lan743x_ptp_clock_get(adapter, &seconds, &nano_seconds, NULL);
 	ts->tv_sec = seconds;
 	ts->tv_nsec = nano_seconds;
 
@@ -671,6 +688,110 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 	return ret;
 }
 
+static void lan743x_ptp_io_extts_off(struct lan743x_adapter *adapter,
+				     u32 index)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	struct lan743x_extts *extts;
+	int val;
+
+	extts = &ptp->extts[index];
+	/* PTP Interrupt Enable Clear Register */
+	if (extts->flags & PTP_FALLING_EDGE)
+		val = PTP_INT_EN_FE_EN_CLR_(index);
+	else
+		val = PTP_INT_EN_RE_EN_CLR_(index);
+	lan743x_csr_write(adapter, PTP_INT_EN_CLR, val);
+
+	/* Disables PTP-IO edge lock */
+	val = lan743x_csr_read(adapter, PTP_IO_CAP_CONFIG);
+	if (extts->flags & PTP_FALLING_EDGE) {
+		val &= ~PTP_IO_CAP_CONFIG_LOCK_FE_(index);
+		val &= ~PTP_IO_CAP_CONFIG_FE_CAP_EN_(index);
+	} else {
+		val &= ~PTP_IO_CAP_CONFIG_LOCK_RE_(index);
+		val &= ~PTP_IO_CAP_CONFIG_RE_CAP_EN_(index);
+	}
+	lan743x_csr_write(adapter, PTP_IO_CAP_CONFIG, val);
+
+	/* PTP-IO De-select register */
+	val = lan743x_csr_read(adapter, PTP_IO_SEL);
+	val &= ~PTP_IO_SEL_MASK_;
+	lan743x_csr_write(adapter, PTP_IO_SEL, val);
+
+	/* Clear timestamp */
+	memset(&extts->ts, 0, sizeof(struct timespec64));
+}
+
+static int lan743x_ptp_io_event_cap_en(struct lan743x_adapter *adapter,
+				       u32 flags, u32 channel)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	int val;
+
+	if ((flags & PTP_EXTTS_EDGES) ==  PTP_EXTTS_EDGES)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&ptp->command_lock);
+	/* PTP-IO Event Capture Enable */
+	val = lan743x_csr_read(adapter, PTP_IO_CAP_CONFIG);
+	if (flags & PTP_FALLING_EDGE) {
+		val &= ~PTP_IO_CAP_CONFIG_LOCK_RE_(channel);
+		val &= ~PTP_IO_CAP_CONFIG_RE_CAP_EN_(channel);
+		val |= PTP_IO_CAP_CONFIG_LOCK_FE_(channel);
+		val |= PTP_IO_CAP_CONFIG_FE_CAP_EN_(channel);
+	} else {
+		/* Rising eventing as Default */
+		val &= ~PTP_IO_CAP_CONFIG_LOCK_FE_(channel);
+		val &= ~PTP_IO_CAP_CONFIG_FE_CAP_EN_(channel);
+		val |= PTP_IO_CAP_CONFIG_LOCK_RE_(channel);
+		val |= PTP_IO_CAP_CONFIG_RE_CAP_EN_(channel);
+	}
+	lan743x_csr_write(adapter, PTP_IO_CAP_CONFIG, val);
+
+	/* PTP-IO Select */
+	val = lan743x_csr_read(adapter, PTP_IO_SEL);
+	val &= ~PTP_IO_SEL_MASK_;
+	val |= channel << PTP_IO_SEL_SHIFT_;
+	lan743x_csr_write(adapter, PTP_IO_SEL, val);
+
+	/* PTP Interrupt Enable Register */
+	if (flags & PTP_FALLING_EDGE)
+		val = PTP_INT_EN_FE_EN_SET_(channel);
+	else
+		val = PTP_INT_EN_RE_EN_SET_(channel);
+	lan743x_csr_write(adapter, PTP_INT_EN_SET, val);
+
+	mutex_unlock(&ptp->command_lock);
+
+	return 0;
+}
+
+static int lan743x_ptp_io_extts(struct lan743x_adapter *adapter, int on,
+				struct ptp_extts_request *extts_request)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	u32 flags = extts_request->flags;
+	u32 index = extts_request->index;
+	struct lan743x_extts *extts;
+	int extts_pin;
+	int ret = 0;
+
+	extts = &ptp->extts[index];
+
+	if (on) {
+		extts_pin = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS, index);
+		if (extts_pin < 0)
+			return -EBUSY;
+
+		ret = lan743x_ptp_io_event_cap_en(adapter, flags, index);
+	} else {
+		lan743x_ptp_io_extts_off(adapter, index);
+	}
+
+	return ret;
+}
+
 static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
 				struct ptp_clock_request *request, int on)
 {
@@ -682,6 +803,9 @@ static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
 	if (request) {
 		switch (request->type) {
 		case PTP_CLK_REQ_EXTTS:
+			if (request->extts.index < ptpci->n_ext_ts)
+				return lan743x_ptp_io_extts(adapter, on,
+							 &request->extts);
 			return -EINVAL;
 		case PTP_CLK_REQ_PEROUT:
 			if (request->perout.index < ptpci->n_per_out)
@@ -715,8 +839,8 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
-		break;
 	case PTP_PF_EXTTS:
+		break;
 	case PTP_PF_PHYSYNC:
 	default:
 		result = -1;
@@ -725,6 +849,33 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 	return result;
 }
 
+static void lan743x_ptp_io_event_clock_get(struct lan743x_adapter *adapter,
+					   bool fe, u8 channel,
+					   struct timespec64 *ts)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+	struct lan743x_extts *extts;
+	u32 sec, nsec;
+
+	mutex_lock(&ptp->command_lock);
+	if (fe) {
+		sec = lan743x_csr_read(adapter, PTP_IO_FE_LTC_SEC_CAP_X);
+		nsec = lan743x_csr_read(adapter, PTP_IO_FE_LTC_NS_CAP_X);
+	} else {
+		sec = lan743x_csr_read(adapter, PTP_IO_RE_LTC_SEC_CAP_X);
+		nsec = lan743x_csr_read(adapter, PTP_IO_RE_LTC_NS_CAP_X);
+	}
+
+	mutex_unlock(&ptp->command_lock);
+
+	/* Update Local timestamp */
+	extts = &ptp->extts[channel];
+	extts->ts.tv_sec = sec;
+	extts->ts.tv_nsec = nsec;
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+}
+
 static long lan743x_ptpci_do_aux_work(struct ptp_clock_info *ptpci)
 {
 	struct lan743x_ptp *ptp =
@@ -733,41 +884,114 @@ static long lan743x_ptpci_do_aux_work(struct ptp_clock_info *ptpci)
 		container_of(ptp, struct lan743x_adapter, ptp);
 	u32 cap_info, cause, header, nsec, seconds;
 	bool new_timestamp_available = false;
+	struct ptp_clock_event ptp_event;
+	struct timespec64 ts;
+	int ptp_int_sts;
 	int count = 0;
+	int channel;
+	s64 ns;
 
-	while ((count < 100) &&
-	       (lan743x_csr_read(adapter, PTP_INT_STS) & PTP_INT_BIT_TX_TS_)) {
+	ptp_int_sts = lan743x_csr_read(adapter, PTP_INT_STS);
+	while ((count < 100) && ptp_int_sts) {
 		count++;
-		cap_info = lan743x_csr_read(adapter, PTP_CAP_INFO);
-
-		if (PTP_CAP_INFO_TX_TS_CNT_GET_(cap_info) > 0) {
-			seconds = lan743x_csr_read(adapter,
-						   PTP_TX_EGRESS_SEC);
-			nsec = lan743x_csr_read(adapter, PTP_TX_EGRESS_NS);
-			cause = (nsec &
-				 PTP_TX_EGRESS_NS_CAPTURE_CAUSE_MASK_);
-			header = lan743x_csr_read(adapter,
-						  PTP_TX_MSG_HEADER);
-
-			if (cause == PTP_TX_EGRESS_NS_CAPTURE_CAUSE_SW_) {
-				nsec &= PTP_TX_EGRESS_NS_TS_NS_MASK_;
-				lan743x_ptp_tx_ts_enqueue_ts(adapter,
-							     seconds, nsec,
-							     header);
-				new_timestamp_available = true;
-			} else if (cause ==
-				PTP_TX_EGRESS_NS_CAPTURE_CAUSE_AUTO_) {
-				netif_err(adapter, drv, adapter->netdev,
-					  "Auto capture cause not supported\n");
+
+		if (ptp_int_sts & PTP_INT_BIT_TX_TS_) {
+			cap_info = lan743x_csr_read(adapter, PTP_CAP_INFO);
+
+			if (PTP_CAP_INFO_TX_TS_CNT_GET_(cap_info) > 0) {
+				seconds = lan743x_csr_read(adapter,
+							   PTP_TX_EGRESS_SEC);
+				nsec = lan743x_csr_read(adapter, PTP_TX_EGRESS_NS);
+				cause = (nsec &
+					 PTP_TX_EGRESS_NS_CAPTURE_CAUSE_MASK_);
+				header = lan743x_csr_read(adapter,
+							  PTP_TX_MSG_HEADER);
+
+				if (cause == PTP_TX_EGRESS_NS_CAPTURE_CAUSE_SW_) {
+					nsec &= PTP_TX_EGRESS_NS_TS_NS_MASK_;
+					lan743x_ptp_tx_ts_enqueue_ts(adapter,
+								     seconds, nsec,
+								     header);
+					new_timestamp_available = true;
+				} else if (cause ==
+					   PTP_TX_EGRESS_NS_CAPTURE_CAUSE_AUTO_) {
+					netif_err(adapter, drv, adapter->netdev,
+						  "Auto capture cause not supported\n");
+				} else {
+					netif_warn(adapter, drv, adapter->netdev,
+						   "unknown tx timestamp capture cause\n");
+				}
 			} else {
 				netif_warn(adapter, drv, adapter->netdev,
-					   "unknown tx timestamp capture cause\n");
+					   "TX TS INT but no TX TS CNT\n");
 			}
-		} else {
-			netif_warn(adapter, drv, adapter->netdev,
-				   "TX TS INT but no TX TS CNT\n");
+			lan743x_csr_write(adapter, PTP_INT_STS,
+					  PTP_INT_BIT_TX_TS_);
 		}
-		lan743x_csr_write(adapter, PTP_INT_STS, PTP_INT_BIT_TX_TS_);
+
+		if (ptp_int_sts & PTP_INT_IO_FE_MASK_) {
+			do {
+				channel = lan743x_get_channel((ptp_int_sts &
+							PTP_INT_IO_FE_MASK_) >>
+							PTP_INT_IO_FE_SHIFT_);
+				if (channel >= 0 &&
+				    channel < PCI11X1X_PTP_IO_MAX_CHANNELS) {
+					lan743x_ptp_io_event_clock_get(adapter,
+								       true,
+								       channel,
+								       &ts);
+					/* PTP Falling Event post */
+					ns = timespec64_to_ns(&ts);
+					ptp_event.timestamp = ns;
+					ptp_event.index = channel;
+					ptp_event.type = PTP_CLOCK_EXTTS;
+					ptp_clock_event(ptp->ptp_clock, &ptp_event);
+					lan743x_csr_write(adapter, PTP_INT_STS,
+							  PTP_INT_IO_FE_SET_(channel));
+					ptp_int_sts &= ~(1 <<
+							 (PTP_INT_IO_FE_SHIFT_ +
+							  channel));
+				} else {
+					/* Clear falling event interrupts */
+					lan743x_csr_write(adapter, PTP_INT_STS,
+							  PTP_INT_IO_FE_MASK_);
+					ptp_int_sts &= ~PTP_INT_IO_FE_MASK_;
+				}
+			} while (ptp_int_sts & PTP_INT_IO_FE_MASK_);
+		}
+
+		if (ptp_int_sts & PTP_INT_IO_RE_MASK_) {
+			do {
+				channel = lan743x_get_channel((ptp_int_sts &
+						       PTP_INT_IO_RE_MASK_) >>
+						       PTP_INT_IO_RE_SHIFT_);
+				if (channel >= 0 &&
+				    channel < PCI11X1X_PTP_IO_MAX_CHANNELS) {
+					lan743x_ptp_io_event_clock_get(adapter,
+								       false,
+								       channel,
+								       &ts);
+					/* PTP Rising Event post */
+					ns = timespec64_to_ns(&ts);
+					ptp_event.timestamp = ns;
+					ptp_event.index = channel;
+					ptp_event.type = PTP_CLOCK_EXTTS;
+					ptp_clock_event(ptp->ptp_clock, &ptp_event);
+					lan743x_csr_write(adapter, PTP_INT_STS,
+							  PTP_INT_IO_RE_SET_(channel));
+					ptp_int_sts &= ~(1 <<
+							 (PTP_INT_IO_RE_SHIFT_ +
+							  channel));
+				} else {
+					/* Clear Rising event interrupt */
+					lan743x_csr_write(adapter, PTP_INT_STS,
+							  PTP_INT_IO_RE_MASK_);
+					ptp_int_sts &= ~PTP_INT_IO_RE_MASK_;
+				}
+			} while (ptp_int_sts & PTP_INT_IO_RE_MASK_);
+		}
+
+		ptp_int_sts = lan743x_csr_read(adapter, PTP_INT_STS);
 	}
 
 	if (new_timestamp_available)
@@ -802,6 +1026,28 @@ static void lan743x_ptp_clock_get(struct lan743x_adapter *adapter,
 	mutex_unlock(&ptp->command_lock);
 }
 
+static void lan743x_ptp_io_clock_get(struct lan743x_adapter *adapter,
+				     u32 *sec, u32 *nsec, u32 *sub_nsec)
+{
+	struct lan743x_ptp *ptp = &adapter->ptp;
+
+	mutex_lock(&ptp->command_lock);
+	lan743x_csr_write(adapter, PTP_CMD_CTL, PTP_CMD_CTL_PTP_CLOCK_READ_);
+	lan743x_ptp_wait_till_cmd_done(adapter, PTP_CMD_CTL_PTP_CLOCK_READ_);
+
+	if (sec)
+		(*sec) = lan743x_csr_read(adapter, PTP_LTC_RD_SEC_LO);
+
+	if (nsec)
+		(*nsec) = lan743x_csr_read(adapter, PTP_LTC_RD_NS);
+
+	if (sub_nsec)
+		(*sub_nsec) =
+		lan743x_csr_read(adapter, PTP_LTC_RD_SUBNS);
+
+	mutex_unlock(&ptp->command_lock);
+}
+
 static void lan743x_ptp_clock_step(struct lan743x_adapter *adapter,
 				   s64 time_step_ns)
 {
@@ -815,8 +1061,12 @@ static void lan743x_ptp_clock_step(struct lan743x_adapter *adapter,
 
 	if (time_step_ns >  15000000000LL) {
 		/* convert to clock set */
-		lan743x_ptp_clock_get(adapter, &unsigned_seconds,
-				      &nano_seconds, NULL);
+		if (adapter->is_pci11x1x)
+			lan743x_ptp_io_clock_get(adapter, &unsigned_seconds,
+						 &nano_seconds, NULL);
+		else
+			lan743x_ptp_clock_get(adapter, &unsigned_seconds,
+					      &nano_seconds, NULL);
 		unsigned_seconds += div_u64_rem(time_step_ns, 1000000000LL,
 						&remainder);
 		nano_seconds += remainder;
@@ -831,8 +1081,13 @@ static void lan743x_ptp_clock_step(struct lan743x_adapter *adapter,
 		/* convert to clock set */
 		time_step_ns = -time_step_ns;
 
-		lan743x_ptp_clock_get(adapter, &unsigned_seconds,
-				      &nano_seconds, NULL);
+		if (adapter->is_pci11x1x) {
+			lan743x_ptp_io_clock_get(adapter, &unsigned_seconds,
+						 &nano_seconds, NULL);
+		} else {
+			lan743x_ptp_clock_get(adapter, &unsigned_seconds,
+					      &nano_seconds, NULL);
+		}
 		unsigned_seconds -= div_u64_rem(time_step_ns, 1000000000LL,
 						&remainder);
 		nano_seconds_step = remainder;
@@ -1061,6 +1316,8 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 		n_pins = LAN7430_N_GPIO;
 		break;
 	case ID_REV_ID_LAN7431_:
+	case ID_REV_ID_A011_:
+	case ID_REV_ID_A041_:
 		n_pins = LAN7431_N_GPIO;
 		break;
 	default:
@@ -1088,10 +1345,10 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 		 adapter->netdev->dev_addr);
 	ptp->ptp_clock_info.max_adj = LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB;
 	ptp->ptp_clock_info.n_alarm = 0;
-	ptp->ptp_clock_info.n_ext_ts = 0;
+	ptp->ptp_clock_info.n_ext_ts = LAN743X_PTP_N_EXTTS;
 	ptp->ptp_clock_info.n_per_out = LAN743X_PTP_N_EVENT_CHAN;
 	ptp->ptp_clock_info.n_pins = n_pins;
-	ptp->ptp_clock_info.pps = 0;
+	ptp->ptp_clock_info.pps = LAN743X_PTP_N_PPS;
 	ptp->ptp_clock_info.pin_config = ptp->pin_config;
 	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
 	ptp->ptp_clock_info.adjfreq = lan743x_ptpci_adjfreq;
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index 7663bf5d2e33..96d3a134e788 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -18,6 +18,9 @@
  */
 #define LAN743X_PTP_N_EVENT_CHAN	2
 #define LAN743X_PTP_N_PEROUT		LAN743X_PTP_N_EVENT_CHAN
+#define LAN743X_PTP_N_EXTTS		4
+#define LAN743X_PTP_N_PPS		0
+#define PCI11X1X_PTP_IO_MAX_CHANNELS	8
 
 struct lan743x_adapter;
 
@@ -60,6 +63,11 @@ struct lan743x_ptp_perout {
 	int  gpio_pin;	/* GPIO pin where output appears */
 };
 
+struct lan743x_extts {
+	int flags;
+	struct timespec64 ts;
+};
+
 struct lan743x_ptp {
 	int flags;
 
@@ -72,6 +80,7 @@ struct lan743x_ptp {
 
 	unsigned long used_event_ch;
 	struct lan743x_ptp_perout perout[LAN743X_PTP_N_PEROUT];
+	struct lan743x_extts extts[LAN743X_PTP_N_EXTTS];
 
 	bool leds_multiplexed;
 	bool led_enabled[LAN7430_N_LED];
-- 
2.25.1

