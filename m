Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6105B4839A2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiADBJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiADBJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:09:43 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FD7C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 17:09:42 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n16so25983360plc.2
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 17:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BoHMs67i3JhfykffDf4NnlrSI/gZNQy0uGJxtraEpas=;
        b=GGiUYeOMLm9+fHfcNJ84GpqZCQUhep18HTbAAIbk5hI08nlruIUtQ2AzZWkuub3HQt
         rweVzfXpylP16pbb69hGpT4YwBtd9Ee/9JxHZlCBlS1Zlb9cdJZn5WNBajfKLNAk7PlQ
         GbI9ZtasTH5io6wn+a1V7jmp5P6ChS2G/Dccs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BoHMs67i3JhfykffDf4NnlrSI/gZNQy0uGJxtraEpas=;
        b=cV3E58FtDA0P4Y5eBTh4uZPZK9z/JGEpeZxU3sDqrK53rz7SZV6VZftRFC6K9glWEF
         QihkhF/+q5Nld9n5lK83rSNkmmSMwpESw/55zJdaSBmCMb6k4/ADZICjNU2oWu1veI53
         FXF66lvLmm65nXSS62D5URogFzTMGQDkCY8u4wqN+yyW2j8B9kWCKg6fXCePswFfoI9D
         wJ1FPxa8gbRwKYbAb4wxAt9TTa0T0ABqO8vAYobwdX1P2+eE17Fous9+HzLTcvpXWCpA
         3NkLa8G6Hg/q5JFTZ7aYnl/mhONFamXorcuu6ssT5XSiP8IzBz2c0dTcIr0+nMpWHdv9
         o/Qw==
X-Gm-Message-State: AOAM530toFYv+HXC7PIZEZkVF42tAatBTIloCmhOgl+N7Wft5ajMIWsT
        +LRSEVetj19j1MF1sTbf9VlKvA==
X-Google-Smtp-Source: ABdhPJz37rUlwN8+ngMo4P3nNDkFwIblUTTIvQ5f2U8oWe3nHOfdPellLHLlInQwv6QJuIgSolk0Cw==
X-Received: by 2002:a17:902:dcc9:b0:149:8366:ddd1 with SMTP id t9-20020a170902dcc900b001498366ddd1mr33491947pll.151.1641258581671;
        Mon, 03 Jan 2022 17:09:41 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id v10sm39208654pjr.11.2022.01.03.17.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:09:40 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v3 4/8] net/funeth: ethtool operations
Date:   Mon,  3 Jan 2022 17:09:29 -0800
Message-Id: <20220104010933.1770777-5-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104010933.1770777-1-dmichail@fungible.com>
References: <20220104010933.1770777-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool operations, primarily related to queues and ports, as well
as device statistics.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funeth/fun_port.h   |   97 ++
 .../ethernet/fungible/funeth/funeth_ethtool.c | 1176 +++++++++++++++++
 2 files changed, 1273 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funeth/fun_port.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ethtool.c

diff --git a/drivers/net/ethernet/fungible/funeth/fun_port.h b/drivers/net/ethernet/fungible/funeth/fun_port.h
new file mode 100644
index 000000000000..0f9da44e3786
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/fun_port.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef _FUN_PORT_H
+#define _FUN_PORT_H
+
+enum port_mac_rx_stats {
+	PORT_MAC_RX_etherStatsOctets = 0x0,
+	PORT_MAC_RX_OctetsReceivedOK = 0x1,
+	PORT_MAC_RX_aAlignmentErrors = 0x2,
+	PORT_MAC_RX_aPAUSEMACCtrlFramesReceived = 0x3,
+	PORT_MAC_RX_aFrameTooLongErrors = 0x4,
+	PORT_MAC_RX_aInRangeLengthErrors = 0x5,
+	PORT_MAC_RX_aFramesReceivedOK = 0x6,
+	PORT_MAC_RX_aFrameCheckSequenceErrors = 0x7,
+	PORT_MAC_RX_VLANReceivedOK = 0x8,
+	PORT_MAC_RX_ifInErrors = 0x9,
+	PORT_MAC_RX_ifInUcastPkts = 0xa,
+	PORT_MAC_RX_ifInMulticastPkts = 0xb,
+	PORT_MAC_RX_ifInBroadcastPkts = 0xc,
+	PORT_MAC_RX_etherStatsDropEvents = 0xd,
+	PORT_MAC_RX_etherStatsPkts = 0xe,
+	PORT_MAC_RX_etherStatsUndersizePkts = 0xf,
+	PORT_MAC_RX_etherStatsPkts64Octets = 0x10,
+	PORT_MAC_RX_etherStatsPkts65to127Octets = 0x11,
+	PORT_MAC_RX_etherStatsPkts128to255Octets = 0x12,
+	PORT_MAC_RX_etherStatsPkts256to511Octets = 0x13,
+	PORT_MAC_RX_etherStatsPkts512to1023Octets = 0x14,
+	PORT_MAC_RX_etherStatsPkts1024to1518Octets = 0x15,
+	PORT_MAC_RX_etherStatsPkts1519toMaxOctets = 0x16,
+	PORT_MAC_RX_etherStatsOversizePkts = 0x17,
+	PORT_MAC_RX_etherStatsJabbers = 0x18,
+	PORT_MAC_RX_etherStatsFragments = 0x19,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_0 = 0x1a,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_1 = 0x1b,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_2 = 0x1c,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_3 = 0x1d,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_4 = 0x1e,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_5 = 0x1f,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_6 = 0x20,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_7 = 0x21,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_8 = 0x22,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_9 = 0x23,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_10 = 0x24,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_11 = 0x25,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_12 = 0x26,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_13 = 0x27,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_14 = 0x28,
+	PORT_MAC_RX_CBFCPAUSEFramesReceived_15 = 0x29,
+	PORT_MAC_RX_MACControlFramesReceived = 0x2a,
+	PORT_MAC_RX_STATS_MAX = 0x2b,
+};
+
+enum port_mac_tx_stats {
+	PORT_MAC_TX_etherStatsOctets = 0x0,
+	PORT_MAC_TX_OctetsTransmittedOK = 0x1,
+	PORT_MAC_TX_aPAUSEMACCtrlFramesTransmitted = 0x2,
+	PORT_MAC_TX_aFramesTransmittedOK = 0x3,
+	PORT_MAC_TX_VLANTransmittedOK = 0x4,
+	PORT_MAC_TX_ifOutErrors = 0x5,
+	PORT_MAC_TX_ifOutUcastPkts = 0x6,
+	PORT_MAC_TX_ifOutMulticastPkts = 0x7,
+	PORT_MAC_TX_ifOutBroadcastPkts = 0x8,
+	PORT_MAC_TX_etherStatsPkts64Octets = 0x9,
+	PORT_MAC_TX_etherStatsPkts65to127Octets = 0xa,
+	PORT_MAC_TX_etherStatsPkts128to255Octets = 0xb,
+	PORT_MAC_TX_etherStatsPkts256to511Octets = 0xc,
+	PORT_MAC_TX_etherStatsPkts512to1023Octets = 0xd,
+	PORT_MAC_TX_etherStatsPkts1024to1518Octets = 0xe,
+	PORT_MAC_TX_etherStatsPkts1519toMaxOctets = 0xf,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_0 = 0x10,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_1 = 0x11,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_2 = 0x12,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_3 = 0x13,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_4 = 0x14,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_5 = 0x15,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_6 = 0x16,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_7 = 0x17,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_8 = 0x18,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_9 = 0x19,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_10 = 0x1a,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_11 = 0x1b,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_12 = 0x1c,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_13 = 0x1d,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_14 = 0x1e,
+	PORT_MAC_TX_CBFCPAUSEFramesTransmitted_15 = 0x1f,
+	PORT_MAC_TX_MACControlFramesTransmitted = 0x20,
+	PORT_MAC_TX_etherStatsPkts = 0x21,
+	PORT_MAC_TX_STATS_MAX = 0x22,
+};
+
+enum port_mac_fec_stats {
+	PORT_MAC_FEC_Correctable = 0x0,
+	PORT_MAC_FEC_Uncorrectable = 0x1,
+	PORT_MAC_FEC_STATS_MAX = 0x2,
+};
+
+#endif /* _FUN_PORT_H */
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
new file mode 100644
index 000000000000..996f72d1f6d2
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
@@ -0,0 +1,1176 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/ethtool.h>
+#include <linux/linkmode.h>
+#include <linux/netdevice.h>
+#include <linux/nvme.h>
+#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/pci.h>
+#include <linux/rtnetlink.h>
+#include "funeth.h"
+#include "fun_port.h"
+#include "funeth_txrx.h"
+
+/* Min queue depth. The smallest power-of-2 supporting jumbo frames with 4K
+ * pages is 8. Require it for all types of queues though some could work with
+ * fewer entries.
+ */
+#define FUNETH_MIN_QDEPTH 8
+
+static const char mac_tx_stat_names[][ETH_GSTRING_LEN] = {
+	"mac_tx_octets_total",
+	"mac_tx_frames_total",
+	"mac_tx_vlan_frames_ok",
+	"mac_tx_unicast_frames",
+	"mac_tx_multicast_frames",
+	"mac_tx_broadcast_frames",
+	"mac_tx_errors",
+	"mac_tx_CBFCPAUSE0",
+	"mac_tx_CBFCPAUSE1",
+	"mac_tx_CBFCPAUSE2",
+	"mac_tx_CBFCPAUSE3",
+	"mac_tx_CBFCPAUSE4",
+	"mac_tx_CBFCPAUSE5",
+	"mac_tx_CBFCPAUSE6",
+	"mac_tx_CBFCPAUSE7",
+	"mac_tx_CBFCPAUSE8",
+	"mac_tx_CBFCPAUSE9",
+	"mac_tx_CBFCPAUSE10",
+	"mac_tx_CBFCPAUSE11",
+	"mac_tx_CBFCPAUSE12",
+	"mac_tx_CBFCPAUSE13",
+	"mac_tx_CBFCPAUSE14",
+	"mac_tx_CBFCPAUSE15",
+};
+
+static const char mac_rx_stat_names[][ETH_GSTRING_LEN] = {
+	"mac_rx_octets_total",
+	"mac_rx_frames_total",
+	"mac_rx_VLAN_frames_ok",
+	"mac_rx_unicast_frames",
+	"mac_rx_multicast_frames",
+	"mac_rx_broadcast_frames",
+	"mac_rx_drop_events",
+	"mac_rx_errors",
+	"mac_rx_alignment_errors",
+	"mac_rx_CBFCPAUSE0",
+	"mac_rx_CBFCPAUSE1",
+	"mac_rx_CBFCPAUSE2",
+	"mac_rx_CBFCPAUSE3",
+	"mac_rx_CBFCPAUSE4",
+	"mac_rx_CBFCPAUSE5",
+	"mac_rx_CBFCPAUSE6",
+	"mac_rx_CBFCPAUSE7",
+	"mac_rx_CBFCPAUSE8",
+	"mac_rx_CBFCPAUSE9",
+	"mac_rx_CBFCPAUSE10",
+	"mac_rx_CBFCPAUSE11",
+	"mac_rx_CBFCPAUSE12",
+	"mac_rx_CBFCPAUSE13",
+	"mac_rx_CBFCPAUSE14",
+	"mac_rx_CBFCPAUSE15",
+};
+
+static const char * const txq_stat_names[] = {
+	"tx_pkts",
+	"tx_bytes",
+	"tx_cso",
+	"tx_tso",
+	"tx_more",
+	"tx_queue_stops",
+	"tx_queue_restarts",
+	"tx_mapping_errors",
+	"tx_length_errors",
+	"tx_tls_encrypted_packets",
+	"tx_tls_encrypted_bytes",
+	"tx_tls_ooo",
+	"tx_tls_drop_no_sync_data",
+};
+
+static const char * const xdpq_stat_names[] = {
+	"tx_xdp_pkts",
+	"tx_xdp_bytes",
+	"tx_xdp_full",
+	"tx_xdp_mapping_errors",
+	"tx_xdp_length_errors",
+};
+
+static const char * const rxq_stat_names[] = {
+	"rx_pkts",
+	"rx_bytes",
+	"rx_cso",
+	"gro_pkts",
+	"gro_merged",
+	"rx_xdp_tx",
+	"rx_xdp_redir",
+	"rx_xdp_drops",
+	"rx_buffers",
+	"rx_page_allocs",
+	"rx_drops",
+	"rx_budget_exhausted",
+	"rx_mapping_errors",
+};
+
+static const char * const tls_stat_names[] = {
+	"tx_tls_ctx",
+	"tx_tls_del",
+	"tx_tls_resync",
+};
+
+static void fun_link_modes_to_ethtool(u64 modes,
+				      unsigned long *ethtool_modes_map)
+{
+#define ADD_LINK_MODE(mode) \
+	__set_bit(ETHTOOL_LINK_MODE_ ## mode ## _BIT, ethtool_modes_map)
+
+	if (modes & FUN_PORT_CAP_AUTONEG)
+		ADD_LINK_MODE(Autoneg);
+	if (modes & FUN_PORT_CAP_1000_X)
+		ADD_LINK_MODE(1000baseX_Full);
+	if (modes & FUN_PORT_CAP_10G_R) {
+		ADD_LINK_MODE(10000baseCR_Full);
+		ADD_LINK_MODE(10000baseSR_Full);
+		ADD_LINK_MODE(10000baseLR_Full);
+		ADD_LINK_MODE(10000baseER_Full);
+	}
+	if (modes & FUN_PORT_CAP_25G_R) {
+		ADD_LINK_MODE(25000baseCR_Full);
+		ADD_LINK_MODE(25000baseSR_Full);
+	}
+	if (modes & FUN_PORT_CAP_40G_R4) {
+		ADD_LINK_MODE(40000baseCR4_Full);
+		ADD_LINK_MODE(40000baseSR4_Full);
+		ADD_LINK_MODE(40000baseLR4_Full);
+	}
+	if (modes & FUN_PORT_CAP_50G_R2) {
+		ADD_LINK_MODE(50000baseCR2_Full);
+		ADD_LINK_MODE(50000baseSR2_Full);
+	}
+	if (modes & FUN_PORT_CAP_50G_R) {
+		ADD_LINK_MODE(50000baseCR_Full);
+		ADD_LINK_MODE(50000baseSR_Full);
+		ADD_LINK_MODE(50000baseLR_ER_FR_Full);
+	}
+	if (modes & FUN_PORT_CAP_100G_R4) {
+		ADD_LINK_MODE(100000baseCR4_Full);
+		ADD_LINK_MODE(100000baseSR4_Full);
+		ADD_LINK_MODE(100000baseLR4_ER4_Full);
+	}
+	if (modes & FUN_PORT_CAP_100G_R2) {
+		ADD_LINK_MODE(100000baseCR2_Full);
+		ADD_LINK_MODE(100000baseSR2_Full);
+		ADD_LINK_MODE(100000baseLR2_ER2_FR2_Full);
+	}
+	if (modes & FUN_PORT_CAP_FEC_NONE)
+		ADD_LINK_MODE(FEC_NONE);
+	if (modes & FUN_PORT_CAP_FEC_FC)
+		ADD_LINK_MODE(FEC_BASER);
+	if (modes & FUN_PORT_CAP_FEC_RS)
+		ADD_LINK_MODE(FEC_RS);
+	if (modes & FUN_PORT_CAP_RX_PAUSE)
+		ADD_LINK_MODE(Pause);
+
+#undef ADD_LINK_MODE
+}
+
+static void set_asym_pause(u64 advertising, struct ethtool_link_ksettings *ks)
+{
+	bool rx_pause, tx_pause;
+
+	rx_pause = advertising & FUN_PORT_CAP_RX_PAUSE;
+	tx_pause = advertising & FUN_PORT_CAP_TX_PAUSE;
+	if (tx_pause ^ rx_pause)
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     Asym_Pause);
+}
+
+static unsigned int fun_port_type(unsigned int xcvr)
+{
+	if (!xcvr)
+		return PORT_NONE;
+
+	switch (xcvr & 7) {
+	case FUN_XCVR_BASET:
+		return PORT_TP;
+	case FUN_XCVR_CU:
+		return PORT_DA;
+	default:
+		return PORT_FIBRE;
+	}
+}
+
+static int fun_get_link_ksettings(struct net_device *netdev,
+				  struct ethtool_link_ksettings *ks)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+	unsigned int seq, speed, xcvr;
+	u64 lp_advertising;
+	bool link_up;
+
+	ethtool_link_ksettings_zero_link_mode(ks, supported);
+	ethtool_link_ksettings_zero_link_mode(ks, advertising);
+	ethtool_link_ksettings_zero_link_mode(ks, lp_advertising);
+
+	/* Link settings change asynchronously, take a consistent snapshot */
+	do {
+		seq = read_seqcount_begin(&fp->link_seq);
+		link_up = netif_carrier_ok(netdev);
+		speed = fp->link_speed;
+		xcvr = fp->xcvr_type;
+		lp_advertising = fp->lp_advertising;
+	} while (read_seqcount_retry(&fp->link_seq, seq));
+
+	if (link_up) {
+		ks->base.speed = speed;
+		ks->base.duplex = DUPLEX_FULL;
+		fun_link_modes_to_ethtool(lp_advertising,
+					  ks->link_modes.lp_advertising);
+	} else {
+		ks->base.speed = SPEED_UNKNOWN;
+		ks->base.duplex = DUPLEX_UNKNOWN;
+	}
+
+	ks->base.autoneg = (fp->advertising & FUN_PORT_CAP_AUTONEG) ?
+			   AUTONEG_ENABLE : AUTONEG_DISABLE;
+	ks->base.port = fun_port_type(xcvr);
+
+	fun_link_modes_to_ethtool(fp->port_caps, ks->link_modes.supported);
+	if (fp->port_caps & (FUN_PORT_CAP_RX_PAUSE | FUN_PORT_CAP_TX_PAUSE))
+		ethtool_link_ksettings_add_link_mode(ks, supported, Asym_Pause);
+
+	fun_link_modes_to_ethtool(fp->advertising, ks->link_modes.advertising);
+	set_asym_pause(fp->advertising, ks);
+	return 0;
+}
+
+static u64 fun_advert_modes(const struct ethtool_link_ksettings *ks)
+{
+	u64 modes = 0;
+
+#define HAS_MODE(mode) \
+	ethtool_link_ksettings_test_link_mode(ks, advertising, mode)
+
+	if (HAS_MODE(1000baseX_Full))
+		modes |= FUN_PORT_CAP_1000_X;
+	if (HAS_MODE(10000baseCR_Full) || HAS_MODE(10000baseSR_Full) ||
+	    HAS_MODE(10000baseLR_Full) || HAS_MODE(10000baseER_Full))
+		modes |= FUN_PORT_CAP_10G_R;
+	if (HAS_MODE(25000baseCR_Full) || HAS_MODE(25000baseSR_Full))
+		modes |= FUN_PORT_CAP_25G_R;
+	if (HAS_MODE(40000baseCR4_Full) || HAS_MODE(40000baseSR4_Full) ||
+	    HAS_MODE(40000baseLR4_Full))
+		modes |= FUN_PORT_CAP_40G_R4;
+	if (HAS_MODE(50000baseCR2_Full) || HAS_MODE(50000baseSR2_Full))
+		modes |= FUN_PORT_CAP_50G_R2;
+	if (HAS_MODE(50000baseCR_Full) || HAS_MODE(50000baseSR_Full) ||
+	    HAS_MODE(50000baseLR_ER_FR_Full))
+		modes |= FUN_PORT_CAP_50G_R;
+	if (HAS_MODE(100000baseCR4_Full) || HAS_MODE(100000baseSR4_Full) ||
+	    HAS_MODE(100000baseLR4_ER4_Full))
+		modes |= FUN_PORT_CAP_100G_R4;
+	if (HAS_MODE(100000baseCR2_Full) || HAS_MODE(100000baseSR2_Full) ||
+	    HAS_MODE(100000baseLR2_ER2_FR2_Full))
+		modes |= FUN_PORT_CAP_100G_R2;
+
+	return modes;
+#undef HAS_MODE
+}
+
+static u64 fun_speed_to_link_mode(unsigned int speed)
+{
+	switch (speed) {
+	case SPEED_100000:
+		return FUN_PORT_CAP_100G_R4 | FUN_PORT_CAP_100G_R2;
+	case SPEED_50000:
+		return FUN_PORT_CAP_50G_R | FUN_PORT_CAP_50G_R2;
+	case SPEED_40000:
+		return FUN_PORT_CAP_40G_R4;
+	case SPEED_25000:
+		return FUN_PORT_CAP_25G_R;
+	case SPEED_10000:
+		return FUN_PORT_CAP_10G_R;
+	case SPEED_1000:
+		return FUN_PORT_CAP_1000_X;
+	default:
+		return 0;
+	}
+}
+
+static int fun_change_advert(struct funeth_priv *fp, u64 new_advert)
+{
+	int err;
+
+	if (new_advert == fp->advertising)
+		return 0;
+
+	err = fun_port_write_cmd(fp, FUN_ADMIN_PORT_KEY_ADVERT, new_advert);
+	if (!err)
+		fp->advertising = new_advert;
+	return err;
+}
+
+#define FUN_PORT_CAP_FEC_MASK \
+	(FUN_PORT_CAP_FEC_NONE | FUN_PORT_CAP_FEC_FC | FUN_PORT_CAP_FEC_RS)
+
+static int fun_set_link_ksettings(struct net_device *netdev,
+				  const struct ethtool_link_ksettings *ks)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = {};
+	struct funeth_priv *fp = netdev_priv(netdev);
+	u64 new_advert;
+
+	/* eswitch ports don't support mode changes */
+	if (fp->port_caps & FUN_PORT_CAP_VPORT)
+		return -EOPNOTSUPP;
+
+	if (ks->base.duplex == DUPLEX_HALF)
+		return -EINVAL;
+	if (ks->base.autoneg == AUTONEG_ENABLE &&
+	    !(fp->port_caps & FUN_PORT_CAP_AUTONEG))
+		return -EINVAL;
+
+	if (ks->base.autoneg == AUTONEG_ENABLE) {
+		if (linkmode_empty(ks->link_modes.advertising))
+			return -EINVAL;
+
+		fun_link_modes_to_ethtool(fp->port_caps, supported);
+		if (!linkmode_subset(ks->link_modes.advertising, supported))
+			return -EINVAL;
+
+		new_advert = fun_advert_modes(ks) | FUN_PORT_CAP_AUTONEG;
+	} else {
+		new_advert = fun_speed_to_link_mode(ks->base.speed);
+		new_advert &= fp->port_caps;
+		if (!new_advert)
+			return -EINVAL;
+	}
+	new_advert |= fp->advertising &
+		      (FUN_PORT_CAP_PAUSE_MASK | FUN_PORT_CAP_FEC_MASK);
+
+	return fun_change_advert(fp, new_advert);
+}
+
+static void fun_get_pauseparam(struct net_device *netdev,
+			       struct ethtool_pauseparam *pause)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+	u8 active_pause = fp->active_fc;
+
+	pause->rx_pause = !!(active_pause & FUN_PORT_CAP_RX_PAUSE);
+	pause->tx_pause = !!(active_pause & FUN_PORT_CAP_TX_PAUSE);
+	pause->autoneg = !!(fp->advertising & FUN_PORT_CAP_AUTONEG);
+}
+
+static int fun_set_pauseparam(struct net_device *netdev,
+			      struct ethtool_pauseparam *pause)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	u64 new_advert;
+
+	if (fp->port_caps & FUN_PORT_CAP_VPORT)
+		return -EOPNOTSUPP;
+	/* Forcing PAUSE settings with AN enabled is unsupported. */
+	if (!pause->autoneg && (fp->advertising & FUN_PORT_CAP_AUTONEG))
+		return -EOPNOTSUPP;
+	if (pause->autoneg && !(fp->advertising & FUN_PORT_CAP_AUTONEG))
+		return -EINVAL;
+	if (pause->tx_pause && !(fp->port_caps & FUN_PORT_CAP_TX_PAUSE))
+		return -EINVAL;
+	if (pause->rx_pause && !(fp->port_caps & FUN_PORT_CAP_RX_PAUSE))
+		return -EINVAL;
+
+	new_advert = fp->advertising & ~FUN_PORT_CAP_PAUSE_MASK;
+	if (pause->tx_pause)
+		new_advert |= FUN_PORT_CAP_TX_PAUSE;
+	if (pause->rx_pause)
+		new_advert |= FUN_PORT_CAP_RX_PAUSE;
+
+	return fun_change_advert(fp, new_advert);
+}
+
+static int fun_restart_an(struct net_device *netdev)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->advertising & FUN_PORT_CAP_AUTONEG))
+		return -EOPNOTSUPP;
+
+	return fun_port_write_cmd(fp, FUN_ADMIN_PORT_KEY_ADVERT,
+				  FUN_PORT_CAP_AUTONEG);
+}
+
+static int fun_set_phys_id(struct net_device *netdev,
+			   enum ethtool_phys_id_state state)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	unsigned int beacon;
+
+	if (fp->port_caps & FUN_PORT_CAP_VPORT)
+		return -EOPNOTSUPP;
+	if (state != ETHTOOL_ID_ACTIVE && state != ETHTOOL_ID_INACTIVE)
+		return -EOPNOTSUPP;
+
+	beacon = state == ETHTOOL_ID_ACTIVE ? FUN_PORT_LED_BEACON_ON :
+					      FUN_PORT_LED_BEACON_OFF;
+	return fun_port_write_cmd(fp, FUN_ADMIN_PORT_KEY_LED, beacon);
+}
+
+static void fun_get_drvinfo(struct net_device *netdev,
+			    struct ethtool_drvinfo *info)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(fp->pdev), sizeof(info->bus_info));
+}
+
+static u32 fun_get_msglevel(struct net_device *netdev)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	return fp->msg_enable;
+}
+
+static void fun_set_msglevel(struct net_device *netdev, u32 value)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+
+	fp->msg_enable = value;
+}
+
+static int fun_get_regs_len(struct net_device *dev)
+{
+	return NVME_REG_ACQ + sizeof(u64);
+}
+
+static void fun_get_regs(struct net_device *dev, struct ethtool_regs *regs,
+			 void *buf)
+{
+	const struct funeth_priv *fp = netdev_priv(dev);
+	void __iomem *bar = fp->fdev->bar;
+
+	regs->version = 0;
+	*(u64 *)(buf + NVME_REG_CAP)   = readq(bar + NVME_REG_CAP);
+	*(u32 *)(buf + NVME_REG_VS)    = readl(bar + NVME_REG_VS);
+	*(u32 *)(buf + NVME_REG_INTMS) = readl(bar + NVME_REG_INTMS);
+	*(u32 *)(buf + NVME_REG_INTMC) = readl(bar + NVME_REG_INTMC);
+	*(u32 *)(buf + NVME_REG_CC)    = readl(bar + NVME_REG_CC);
+	*(u32 *)(buf + NVME_REG_CSTS)  = readl(bar + NVME_REG_CSTS);
+	*(u32 *)(buf + NVME_REG_AQA)   = readl(bar + NVME_REG_AQA);
+	*(u64 *)(buf + NVME_REG_ASQ)   = readq(bar + NVME_REG_ASQ);
+	*(u64 *)(buf + NVME_REG_ACQ)   = readq(bar + NVME_REG_ACQ);
+}
+
+static int fun_get_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *coal,
+			    struct kernel_ethtool_coalesce *kcoal,
+			    struct netlink_ext_ack *ext_ack)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	coal->rx_coalesce_usecs        = fp->rx_coal_usec;
+	coal->rx_max_coalesced_frames  = fp->rx_coal_count;
+	coal->use_adaptive_rx_coalesce = !fp->cq_irq_db;
+	coal->tx_coalesce_usecs        = fp->tx_coal_usec;
+	coal->tx_max_coalesced_frames  = fp->tx_coal_count;
+	return 0;
+}
+
+static int fun_set_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *coal,
+			    struct kernel_ethtool_coalesce *kcoal,
+			    struct netlink_ext_ack *ext_ack)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	struct funeth_rxq **rxqs;
+	unsigned int i, db_val;
+
+	if (coal->rx_coalesce_usecs > FUN_DB_INTCOAL_USEC_M ||
+	    coal->rx_max_coalesced_frames > FUN_DB_INTCOAL_ENTRIES_M ||
+	    (coal->rx_coalesce_usecs | coal->rx_max_coalesced_frames) == 0 ||
+	    coal->tx_coalesce_usecs > FUN_DB_INTCOAL_USEC_M ||
+	    coal->tx_max_coalesced_frames > FUN_DB_INTCOAL_ENTRIES_M ||
+	    (coal->tx_coalesce_usecs | coal->tx_max_coalesced_frames) == 0)
+		return -EINVAL;
+
+	/* a timer is required if there's any coalescing */
+	if ((coal->rx_max_coalesced_frames > 1 && !coal->rx_coalesce_usecs) ||
+	    (coal->tx_max_coalesced_frames > 1 && !coal->tx_coalesce_usecs))
+		return -EINVAL;
+
+	fp->rx_coal_usec  = coal->rx_coalesce_usecs;
+	fp->rx_coal_count = coal->rx_max_coalesced_frames;
+	fp->tx_coal_usec  = coal->tx_coalesce_usecs;
+	fp->tx_coal_count = coal->tx_max_coalesced_frames;
+
+	db_val = FUN_IRQ_CQ_DB(fp->rx_coal_usec, fp->rx_coal_count);
+	WRITE_ONCE(fp->cq_irq_db, db_val);
+
+	rxqs = rtnl_dereference(fp->rxqs);
+	if (!rxqs)
+		return 0;
+
+	for (i = 0; i < netdev->real_num_rx_queues; i++)
+		WRITE_ONCE(rxqs[i]->irq_db_val, db_val);
+
+	db_val = FUN_IRQ_SQ_DB(fp->tx_coal_usec, fp->tx_coal_count);
+	for (i = 0; i < netdev->real_num_tx_queues; i++)
+		WRITE_ONCE(fp->txqs[i]->irq_db_val, db_val);
+
+	return 0;
+}
+
+static void fun_get_channels(struct net_device *netdev,
+			     struct ethtool_channels *chan)
+{
+	chan->max_rx   = netdev->num_rx_queues;
+	chan->rx_count = netdev->real_num_rx_queues;
+
+	chan->max_tx   = netdev->num_tx_queues;
+	chan->tx_count = netdev->real_num_tx_queues;
+}
+
+static void set_ring_count(struct net_device *netdev, unsigned int ntx,
+			   unsigned int nrx)
+{
+	netif_set_real_num_tx_queues(netdev, ntx);
+	if (nrx != netdev->real_num_rx_queues) {
+		netif_set_real_num_rx_queues(netdev, nrx);
+		fun_reset_rss_indir(netdev);
+	}
+}
+
+static int fun_set_channels(struct net_device *netdev,
+			    struct ethtool_channels *chan)
+{
+	unsigned int old_tx, old_rx;
+	int rc = 0;
+
+	if (!chan->tx_count || !chan->rx_count)
+		return -EINVAL;
+
+	if (chan->tx_count == netdev->real_num_tx_queues &&
+	    chan->rx_count == netdev->real_num_rx_queues)
+		return 0;
+
+	if (netif_running(netdev))
+		netdev->netdev_ops->ndo_stop(netdev);
+
+	old_tx = netdev->real_num_tx_queues;
+	old_rx = netdev->real_num_rx_queues;
+	set_ring_count(netdev, chan->tx_count, chan->rx_count);
+
+	if (netif_running(netdev)) {
+		rc = netdev->netdev_ops->ndo_open(netdev);
+		if (rc) {
+			set_ring_count(netdev, old_tx, old_rx);
+			netdev->netdev_ops->ndo_open(netdev);
+		}
+	}
+
+	return rc;
+}
+
+static void fun_get_ringparam(struct net_device *netdev,
+			      struct ethtool_ringparam *ring,
+			      struct kernel_ethtool_ringparam *kring,
+			      struct netlink_ext_ack *extack)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+	unsigned int max_depth = fp->fdev->q_depth;
+
+	ring->rx_max_pending = max_depth;
+	ring->tx_max_pending = max_depth;
+
+	ring->rx_pending = fp->rq_depth;
+	ring->tx_pending = fp->sq_depth;
+}
+
+static int fun_set_ringparam(struct net_device *netdev,
+			     struct ethtool_ringparam *ring,
+			     struct kernel_ethtool_ringparam *kring,
+			     struct netlink_ext_ack *extack)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	int rc;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	/* queue depths must be powers-of-2 */
+	if (!is_power_of_2(ring->rx_pending) ||
+	    !is_power_of_2(ring->tx_pending))
+		return -EINVAL;
+
+	if (ring->rx_pending < FUNETH_MIN_QDEPTH ||
+	    ring->tx_pending < FUNETH_MIN_QDEPTH)
+		return -EINVAL;
+
+	if (fp->sq_depth == ring->tx_pending &&
+	    fp->rq_depth == ring->rx_pending)
+		return 0;
+
+	fp->sq_depth = ring->tx_pending;
+	fp->rq_depth = ring->rx_pending;
+
+	if (!netif_running(netdev))
+		return 0;
+
+	/* recreate queues with new settings */
+	rc = netdev->netdev_ops->ndo_stop(netdev);
+	if (!rc)
+		rc = netdev->netdev_ops->ndo_open(netdev);
+	return rc;
+}
+
+static int fun_get_sset_count(struct net_device *dev, int sset)
+{
+	const struct funeth_priv *fp = netdev_priv(dev);
+	int n;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		n = (dev->real_num_tx_queues + 1) * ARRAY_SIZE(txq_stat_names) +
+		    (dev->real_num_rx_queues + 1) * ARRAY_SIZE(rxq_stat_names) +
+		    (fp->num_xdpqs + 1) * ARRAY_SIZE(xdpq_stat_names) +
+		    ARRAY_SIZE(tls_stat_names);
+		if (fp->port_caps & FUN_PORT_CAP_STATS) {
+			n += ARRAY_SIZE(mac_tx_stat_names) +
+			     ARRAY_SIZE(mac_rx_stat_names);
+		}
+		return n;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static void fun_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+	unsigned int i, j;
+	u8 *p = data;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		if (fp->port_caps & FUN_PORT_CAP_STATS) {
+			memcpy(p, mac_tx_stat_names, sizeof(mac_tx_stat_names));
+			p += sizeof(mac_tx_stat_names);
+			memcpy(p, mac_rx_stat_names, sizeof(mac_rx_stat_names));
+			p += sizeof(mac_rx_stat_names);
+		}
+
+		for (i = 0; i < netdev->real_num_tx_queues; i++) {
+			for (j = 0; j < ARRAY_SIZE(txq_stat_names); j++)
+				ethtool_sprintf(&p, "%s[%u]", txq_stat_names[j],
+						i);
+		}
+		for (j = 0; j < ARRAY_SIZE(txq_stat_names); j++)
+			ethtool_sprintf(&p, txq_stat_names[j]);
+
+		for (i = 0; i < fp->num_xdpqs; i++) {
+			for (j = 0; j < ARRAY_SIZE(xdpq_stat_names); j++)
+				ethtool_sprintf(&p, "%s[%u]",
+						xdpq_stat_names[j], i);
+		}
+		for (j = 0; j < ARRAY_SIZE(xdpq_stat_names); j++)
+			ethtool_sprintf(&p, xdpq_stat_names[j]);
+
+		for (i = 0; i < netdev->real_num_rx_queues; i++) {
+			for (j = 0; j < ARRAY_SIZE(rxq_stat_names); j++)
+				ethtool_sprintf(&p, "%s[%u]", rxq_stat_names[j],
+						i);
+		}
+		for (j = 0; j < ARRAY_SIZE(rxq_stat_names); j++)
+			ethtool_sprintf(&p, rxq_stat_names[j]);
+
+		for (j = 0; j < ARRAY_SIZE(tls_stat_names); j++)
+			ethtool_sprintf(&p, tls_stat_names[j]);
+		break;
+	default:
+		break;
+	}
+}
+
+static u64 *get_mac_stats(const struct funeth_priv *fp, u64 *data)
+{
+#define TX_STAT(s) \
+	*data++ = be64_to_cpu(fp->stats[PORT_MAC_RX_STATS_MAX + PORT_MAC_TX_##s])
+
+	TX_STAT(etherStatsOctets);
+	TX_STAT(etherStatsPkts);
+	TX_STAT(VLANTransmittedOK);
+	TX_STAT(ifOutUcastPkts);
+	TX_STAT(ifOutMulticastPkts);
+	TX_STAT(ifOutBroadcastPkts);
+	TX_STAT(ifOutErrors);
+	TX_STAT(CBFCPAUSEFramesTransmitted_0);
+	TX_STAT(CBFCPAUSEFramesTransmitted_1);
+	TX_STAT(CBFCPAUSEFramesTransmitted_2);
+	TX_STAT(CBFCPAUSEFramesTransmitted_3);
+	TX_STAT(CBFCPAUSEFramesTransmitted_4);
+	TX_STAT(CBFCPAUSEFramesTransmitted_5);
+	TX_STAT(CBFCPAUSEFramesTransmitted_6);
+	TX_STAT(CBFCPAUSEFramesTransmitted_7);
+	TX_STAT(CBFCPAUSEFramesTransmitted_8);
+	TX_STAT(CBFCPAUSEFramesTransmitted_9);
+	TX_STAT(CBFCPAUSEFramesTransmitted_10);
+	TX_STAT(CBFCPAUSEFramesTransmitted_11);
+	TX_STAT(CBFCPAUSEFramesTransmitted_12);
+	TX_STAT(CBFCPAUSEFramesTransmitted_13);
+	TX_STAT(CBFCPAUSEFramesTransmitted_14);
+	TX_STAT(CBFCPAUSEFramesTransmitted_15);
+
+#define RX_STAT(s) *data++ = be64_to_cpu(fp->stats[PORT_MAC_RX_##s])
+
+	RX_STAT(etherStatsOctets);
+	RX_STAT(etherStatsPkts);
+	RX_STAT(VLANReceivedOK);
+	RX_STAT(ifInUcastPkts);
+	RX_STAT(ifInMulticastPkts);
+	RX_STAT(ifInBroadcastPkts);
+	RX_STAT(etherStatsDropEvents);
+	RX_STAT(ifInErrors);
+	RX_STAT(aAlignmentErrors);
+	RX_STAT(CBFCPAUSEFramesReceived_0);
+	RX_STAT(CBFCPAUSEFramesReceived_1);
+	RX_STAT(CBFCPAUSEFramesReceived_2);
+	RX_STAT(CBFCPAUSEFramesReceived_3);
+	RX_STAT(CBFCPAUSEFramesReceived_4);
+	RX_STAT(CBFCPAUSEFramesReceived_5);
+	RX_STAT(CBFCPAUSEFramesReceived_6);
+	RX_STAT(CBFCPAUSEFramesReceived_7);
+	RX_STAT(CBFCPAUSEFramesReceived_8);
+	RX_STAT(CBFCPAUSEFramesReceived_9);
+	RX_STAT(CBFCPAUSEFramesReceived_10);
+	RX_STAT(CBFCPAUSEFramesReceived_11);
+	RX_STAT(CBFCPAUSEFramesReceived_12);
+	RX_STAT(CBFCPAUSEFramesReceived_13);
+	RX_STAT(CBFCPAUSEFramesReceived_14);
+	RX_STAT(CBFCPAUSEFramesReceived_15);
+
+	return data;
+
+#undef TX_STAT
+#undef RX_STAT
+}
+
+static void fun_get_ethtool_stats(struct net_device *netdev,
+				  struct ethtool_stats *stats, u64 *data)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+	struct funeth_rxq **rxqs = rtnl_dereference(fp->rxqs);
+	struct funeth_txq_stats txs;
+	struct funeth_rxq_stats rxs;
+	unsigned int i, start;
+	u64 *totals, *tot;
+
+	if (!netif_running(netdev))
+		return;
+
+	if (fp->port_caps & FUN_PORT_CAP_STATS)
+		data = get_mac_stats(fp, data);
+
+	if (!rxqs)
+		return;
+
+#define ADD_STAT(cnt) do { \
+	*data = (cnt); *tot++ += *data++; \
+} while (0)
+
+	/* Tx queues */
+	totals = data + netdev->real_num_tx_queues * ARRAY_SIZE(txq_stat_names);
+
+	for (i = 0; i < netdev->real_num_tx_queues; i++) {
+		tot = totals;
+
+		FUN_QSTAT_READ(fp->txqs[i], start, txs);
+
+		ADD_STAT(txs.tx_pkts);
+		ADD_STAT(txs.tx_bytes);
+		ADD_STAT(txs.tx_cso);
+		ADD_STAT(txs.tx_tso);
+		ADD_STAT(txs.tx_more);
+		ADD_STAT(txs.tx_nstops);
+		ADD_STAT(txs.tx_nrestarts);
+		ADD_STAT(txs.tx_map_err);
+		ADD_STAT(txs.tx_len_err);
+		ADD_STAT(txs.tx_tls_pkts);
+		ADD_STAT(txs.tx_tls_bytes);
+		ADD_STAT(txs.tx_tls_fallback);
+		ADD_STAT(txs.tx_tls_drops);
+	}
+	data += ARRAY_SIZE(txq_stat_names);
+
+	/* XDP Tx queues */
+	totals = data + fp->num_xdpqs * ARRAY_SIZE(xdpq_stat_names);
+
+	for (i = 0; i < fp->num_xdpqs; i++) {
+		tot = totals;
+
+		FUN_QSTAT_READ(fp->xdpqs[i], start, txs);
+
+		ADD_STAT(txs.tx_pkts);
+		ADD_STAT(txs.tx_bytes);
+		ADD_STAT(txs.tx_xdp_full);
+		ADD_STAT(txs.tx_map_err);
+		ADD_STAT(txs.tx_len_err);
+	}
+	data += ARRAY_SIZE(xdpq_stat_names);
+
+	/* Rx queues */
+	totals = data + netdev->real_num_rx_queues * ARRAY_SIZE(rxq_stat_names);
+
+	for (i = 0; i < netdev->real_num_rx_queues; i++) {
+		tot = totals;
+
+		FUN_QSTAT_READ(rxqs[i], start, rxs);
+
+		ADD_STAT(rxs.rx_pkts);
+		ADD_STAT(rxs.rx_bytes);
+		ADD_STAT(rxs.rx_cso);
+		ADD_STAT(rxs.gro_pkts);
+		ADD_STAT(rxs.gro_merged);
+		ADD_STAT(rxs.xdp_tx);
+		ADD_STAT(rxs.xdp_redir);
+		ADD_STAT(rxs.xdp_drops);
+		ADD_STAT(rxs.rx_bufs);
+		ADD_STAT(rxs.rx_page_alloc);
+		ADD_STAT(rxs.rx_mem_drops + rxs.xdp_err);
+		ADD_STAT(rxs.rx_budget);
+		ADD_STAT(rxs.rx_map_err);
+	}
+	data += ARRAY_SIZE(rxq_stat_names);
+#undef ADD_STAT
+
+	*data++ = atomic64_read(&fp->tx_tls_add);
+	*data++ = atomic64_read(&fp->tx_tls_del);
+	*data++ = atomic64_read(&fp->tx_tls_resync);
+}
+
+#define RX_STAT(fp, s) be64_to_cpu((fp)->stats[PORT_MAC_RX_##s])
+#define TX_STAT(fp, s) \
+	be64_to_cpu((fp)->stats[PORT_MAC_RX_STATS_MAX + PORT_MAC_TX_##s])
+#define FEC_STAT(fp, s) \
+	be64_to_cpu((fp)->stats[PORT_MAC_RX_STATS_MAX + \
+				PORT_MAC_TX_STATS_MAX + PORT_MAC_FEC_##s])
+
+static void fun_get_pause_stats(struct net_device *netdev,
+				struct ethtool_pause_stats *stats)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->port_caps & FUN_PORT_CAP_STATS))
+		return;
+
+	stats->tx_pause_frames = TX_STAT(fp, aPAUSEMACCtrlFramesTransmitted);
+	stats->rx_pause_frames = RX_STAT(fp, aPAUSEMACCtrlFramesReceived);
+}
+
+static void fun_get_802_3_stats(struct net_device *netdev,
+				struct ethtool_eth_mac_stats *stats)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->port_caps & FUN_PORT_CAP_STATS))
+		return;
+
+	stats->FramesTransmittedOK = TX_STAT(fp, aFramesTransmittedOK);
+	stats->FramesReceivedOK = RX_STAT(fp, aFramesReceivedOK);
+	stats->FrameCheckSequenceErrors = RX_STAT(fp, aFrameCheckSequenceErrors);
+	stats->OctetsTransmittedOK = TX_STAT(fp, OctetsTransmittedOK);
+	stats->OctetsReceivedOK = RX_STAT(fp, OctetsReceivedOK);
+	stats->InRangeLengthErrors = RX_STAT(fp, aInRangeLengthErrors);
+	stats->FrameTooLongErrors = RX_STAT(fp, aFrameTooLongErrors);
+}
+
+static void fun_get_802_3_ctrl_stats(struct net_device *netdev,
+				     struct ethtool_eth_ctrl_stats *stats)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->port_caps & FUN_PORT_CAP_STATS))
+		return;
+
+	stats->MACControlFramesTransmitted = TX_STAT(fp, MACControlFramesTransmitted);
+	stats->MACControlFramesReceived = RX_STAT(fp, MACControlFramesReceived);
+}
+
+static void fun_get_rmon_stats(struct net_device *netdev,
+			       struct ethtool_rmon_stats *stats,
+			       const struct ethtool_rmon_hist_range **ranges)
+{
+	static const struct ethtool_rmon_hist_range rmon_ranges[] = {
+		{   64,    64 },
+		{   65,   127 },
+		{  128,   255 },
+		{  256,   511 },
+		{  512,  1023 },
+		{ 1024,  1518 },
+		{ 1519, 32767 },
+		{}
+	};
+
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->port_caps & FUN_PORT_CAP_STATS))
+		return;
+
+	stats->undersize_pkts = RX_STAT(fp, etherStatsUndersizePkts);
+	stats->oversize_pkts = RX_STAT(fp, etherStatsOversizePkts);
+	stats->fragments = RX_STAT(fp, etherStatsFragments);
+	stats->jabbers = RX_STAT(fp, etherStatsJabbers);
+
+	stats->hist[0] = RX_STAT(fp, etherStatsPkts64Octets);
+	stats->hist[1] = RX_STAT(fp, etherStatsPkts65to127Octets);
+	stats->hist[2] = RX_STAT(fp, etherStatsPkts128to255Octets);
+	stats->hist[3] = RX_STAT(fp, etherStatsPkts256to511Octets);
+	stats->hist[4] = RX_STAT(fp, etherStatsPkts512to1023Octets);
+	stats->hist[5] = RX_STAT(fp, etherStatsPkts1024to1518Octets);
+	stats->hist[6] = RX_STAT(fp, etherStatsPkts1519toMaxOctets);
+
+	stats->hist_tx[0] = TX_STAT(fp, etherStatsPkts64Octets);
+	stats->hist_tx[1] = TX_STAT(fp, etherStatsPkts65to127Octets);
+	stats->hist_tx[2] = TX_STAT(fp, etherStatsPkts128to255Octets);
+	stats->hist_tx[3] = TX_STAT(fp, etherStatsPkts256to511Octets);
+	stats->hist_tx[4] = TX_STAT(fp, etherStatsPkts512to1023Octets);
+	stats->hist_tx[5] = TX_STAT(fp, etherStatsPkts1024to1518Octets);
+	stats->hist_tx[6] = TX_STAT(fp, etherStatsPkts1519toMaxOctets);
+
+	*ranges = rmon_ranges;
+}
+
+static void fun_get_fec_stats(struct net_device *netdev,
+			      struct ethtool_fec_stats *stats)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!(fp->port_caps & FUN_PORT_CAP_STATS))
+		return;
+
+	stats->corrected_blocks.total = FEC_STAT(fp, Correctable);
+	stats->uncorrectable_blocks.total = FEC_STAT(fp, Uncorrectable);
+}
+
+#undef RX_STAT
+#undef TX_STAT
+#undef FEC_STAT
+
+static int fun_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
+			 u32 *rule_locs)
+{
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = netdev->real_num_rx_queues;
+		return 0;
+	default:
+		break;
+	}
+	return -EOPNOTSUPP;
+}
+
+static int fun_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info)
+{
+	return 0;
+}
+
+static u32 fun_get_rxfh_indir_size(struct net_device *netdev)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	return fp->indir_table_nentries;
+}
+
+static u32 fun_get_rxfh_key_size(struct net_device *netdev)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	return sizeof(fp->rss_key);
+}
+
+static int fun_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+			u8 *hfunc)
+{
+	const struct funeth_priv *fp = netdev_priv(netdev);
+
+	if (!fp->rss_cfg)
+		return -EOPNOTSUPP;
+
+	if (indir)
+		memcpy(indir, fp->indir_table,
+		       sizeof(u32) * fp->indir_table_nentries);
+
+	if (key)
+		memcpy(key, fp->rss_key, sizeof(fp->rss_key));
+
+	if (hfunc)
+		*hfunc = fp->hash_algo == FUN_ETH_RSS_ALG_TOEPLITZ ?
+				ETH_RSS_HASH_TOP : ETH_RSS_HASH_CRC32;
+
+	return 0;
+}
+
+static int fun_set_rxfh(struct net_device *netdev, const u32 *indir,
+			const u8 *key, const u8 hfunc)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	const u32 *rss_indir = indir ? indir : fp->indir_table;
+	const u8 *rss_key = key ? key : fp->rss_key;
+	enum fun_eth_hash_alg algo;
+
+	if (!fp->rss_cfg)
+		return -EOPNOTSUPP;
+
+	if (hfunc == ETH_RSS_HASH_NO_CHANGE)
+		algo = fp->hash_algo;
+	else if (hfunc == ETH_RSS_HASH_CRC32)
+		algo = FUN_ETH_RSS_ALG_CRC32;
+	else if (hfunc == ETH_RSS_HASH_TOP)
+		algo = FUN_ETH_RSS_ALG_TOEPLITZ;
+	else
+		return -EINVAL;
+
+	/* If the port is enabled try to reconfigure RSS and keep the new
+	 * settings if successful. If it is down we update the RSS settings
+	 * and apply them at the next UP time.
+	 */
+	if (netif_running(netdev)) {
+		int rc = fun_config_rss(netdev, algo, rss_key, rss_indir,
+					FUN_ADMIN_SUBOP_MODIFY);
+		if (rc)
+			return rc;
+	}
+
+	fp->hash_algo = algo;
+	if (key)
+		memcpy(fp->rss_key, key, sizeof(fp->rss_key));
+	if (indir)
+		memcpy(fp->indir_table, indir,
+		       sizeof(u32) * fp->indir_table_nentries);
+	return 0;
+}
+
+static int fun_get_ts_info(struct net_device *netdev,
+			   struct ethtool_ts_info *info)
+{
+	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->phc_index = -1;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
+	return 0;
+}
+
+static unsigned int to_ethtool_fec(unsigned int fun_fec)
+{
+	unsigned int fec = 0;
+
+	if (fun_fec == FUN_PORT_FEC_NA)
+		fec |= ETHTOOL_FEC_NONE;
+	if (fun_fec & FUN_PORT_FEC_OFF)
+		fec |= ETHTOOL_FEC_OFF;
+	if (fun_fec & FUN_PORT_FEC_RS)
+		fec |= ETHTOOL_FEC_RS;
+	if (fun_fec & FUN_PORT_FEC_FC)
+		fec |= ETHTOOL_FEC_BASER;
+	if (fun_fec & FUN_PORT_FEC_AUTO)
+		fec |= ETHTOOL_FEC_AUTO;
+	return fec;
+}
+
+static int fun_get_fecparam(struct net_device *netdev,
+			    struct ethtool_fecparam *fec)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	u64 fec_data;
+	int rc;
+
+	rc = fun_port_read_cmd(fp, FUN_ADMIN_PORT_KEY_FEC, &fec_data);
+	if (rc)
+		return rc;
+
+	fec->active_fec = to_ethtool_fec(fec_data & 0xff);
+	fec->fec = to_ethtool_fec(fec_data >> 8);
+	return 0;
+}
+
+static int fun_set_fecparam(struct net_device *netdev,
+			    struct ethtool_fecparam *fec)
+{
+	struct funeth_priv *fp = netdev_priv(netdev);
+	u64 fec_mode;
+
+	switch (fec->fec) {
+	case ETHTOOL_FEC_AUTO:
+		fec_mode = FUN_PORT_FEC_AUTO;
+		break;
+	case ETHTOOL_FEC_OFF:
+		if (!(fp->port_caps & FUN_PORT_CAP_FEC_NONE))
+			return -EINVAL;
+		fec_mode = FUN_PORT_FEC_OFF;
+		break;
+	case ETHTOOL_FEC_BASER:
+		if (!(fp->port_caps & FUN_PORT_CAP_FEC_FC))
+			return -EINVAL;
+		fec_mode = FUN_PORT_FEC_FC;
+		break;
+	case ETHTOOL_FEC_RS:
+		if (!(fp->port_caps & FUN_PORT_CAP_FEC_RS))
+			return -EINVAL;
+		fec_mode = FUN_PORT_FEC_RS;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return fun_port_write_cmd(fp, FUN_ADMIN_PORT_KEY_FEC, fec_mode);
+}
+
+static const struct ethtool_ops fun_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
+	.get_link_ksettings  = fun_get_link_ksettings,
+	.set_link_ksettings  = fun_set_link_ksettings,
+	.set_phys_id         = fun_set_phys_id,
+	.get_drvinfo         = fun_get_drvinfo,
+	.get_msglevel        = fun_get_msglevel,
+	.set_msglevel        = fun_set_msglevel,
+	.get_regs_len        = fun_get_regs_len,
+	.get_regs            = fun_get_regs,
+	.get_link	     = ethtool_op_get_link,
+	.get_coalesce        = fun_get_coalesce,
+	.set_coalesce        = fun_set_coalesce,
+	.get_ts_info         = fun_get_ts_info,
+	.get_ringparam       = fun_get_ringparam,
+	.set_ringparam       = fun_set_ringparam,
+	.get_sset_count      = fun_get_sset_count,
+	.get_strings         = fun_get_strings,
+	.get_ethtool_stats   = fun_get_ethtool_stats,
+	.get_rxnfc	     = fun_get_rxnfc,
+	.set_rxnfc           = fun_set_rxnfc,
+	.get_rxfh_indir_size = fun_get_rxfh_indir_size,
+	.get_rxfh_key_size   = fun_get_rxfh_key_size,
+	.get_rxfh            = fun_get_rxfh,
+	.set_rxfh            = fun_set_rxfh,
+	.get_channels        = fun_get_channels,
+	.set_channels        = fun_set_channels,
+	.get_fecparam	     = fun_get_fecparam,
+	.set_fecparam	     = fun_set_fecparam,
+	.get_pauseparam      = fun_get_pauseparam,
+	.set_pauseparam      = fun_set_pauseparam,
+	.nway_reset          = fun_restart_an,
+	.get_pause_stats     = fun_get_pause_stats,
+	.get_fec_stats       = fun_get_fec_stats,
+	.get_eth_mac_stats   = fun_get_802_3_stats,
+	.get_eth_ctrl_stats  = fun_get_802_3_ctrl_stats,
+	.get_rmon_stats      = fun_get_rmon_stats,
+};
+
+void fun_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &fun_ethtool_ops;
+}
-- 
2.25.1

