Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3559650BAFB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449119AbiDVPDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449172AbiDVPDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:03:02 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 188ED7650
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:00:06 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 1E3F7320133;
        Fri, 22 Apr 2022 16:00:06 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhulR-0007Az-Sp; Fri, 22 Apr 2022 16:00:05 +0100
Subject: [PATCH net-next 14/28] sfc/siena: Rename functions in ptp.h to
 avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:00:05 +0100
Message-ID: <165063960573.27138.4074590328651108662.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the function prefix.
Some functions can become static in ptp.c.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c            |    4 +-
 drivers/net/ethernet/sfc/siena/efx_common.c     |    4 +-
 drivers/net/ethernet/sfc/siena/ethtool.c        |    2 -
 drivers/net/ethernet/sfc/siena/ethtool_common.c |    6 +--
 drivers/net/ethernet/sfc/siena/mcdi.c           |    4 +-
 drivers/net/ethernet/sfc/siena/ptp.c            |   53 ++++++++++++-----------
 drivers/net/ethernet/sfc/siena/ptp.h            |   46 ++++++++++----------
 drivers/net/ethernet/sfc/siena/siena.c          |   17 ++++---
 drivers/net/ethernet/sfc/siena/tx.c             |    4 +-
 drivers/net/ethernet/sfc/siena/tx_common.c      |    6 +--
 10 files changed, 74 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index ddd9dda1779e..0587877cc809 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -494,9 +494,9 @@ static int efx_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
 	struct mii_ioctl_data *data = if_mii(ifr);
 
 	if (cmd == SIOCSHWTSTAMP)
-		return efx_ptp_set_ts_config(efx, ifr);
+		return efx_siena_ptp_set_ts_config(efx, ifr);
 	if (cmd == SIOCGHWTSTAMP)
-		return efx_ptp_get_ts_config(efx, ifr);
+		return efx_siena_ptp_get_ts_config(efx, ifr);
 
 	/* Convert phy_id from older PRTAD/DEVAD format */
 	if ((cmd == SIOCGMIIREG || cmd == SIOCSMIIREG) &&
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index fc2677e9020a..1f9d9d248daa 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -434,7 +434,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Initialise the channels */
 	efx_siena_start_channels(efx);
 
-	efx_ptp_start_datapath(efx);
+	efx_siena_ptp_start_datapath(efx);
 
 	if (netif_device_present(efx->net_dev))
 		netif_tx_wake_all_queues(efx->net_dev);
@@ -445,7 +445,7 @@ static void efx_stop_datapath(struct efx_nic *efx)
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->port_enabled);
 
-	efx_ptp_stop_datapath(efx);
+	efx_siena_ptp_stop_datapath(efx);
 
 	efx_siena_stop_channels(efx);
 }
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 429653a49dee..63388bec421d 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -235,7 +235,7 @@ static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 				    SOF_TIMESTAMPING_SOFTWARE);
 	ts_info->phc_index = -1;
 
-	efx_ptp_get_ts_info(efx, ts_info);
+	efx_siena_ptp_get_ts_info(efx, ts_info);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index 6fd09f119dce..11108a6de717 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -448,7 +448,7 @@ int efx_siena_ethtool_get_sset_count(struct net_device *net_dev, int string_set)
 		return efx->type->describe_stats(efx, NULL) +
 		       EFX_ETHTOOL_SW_STAT_COUNT +
 		       efx_describe_per_queue_stats(efx, NULL) +
-		       efx_ptp_describe_stats(efx, NULL);
+		       efx_siena_ptp_describe_stats(efx, NULL);
 	case ETH_SS_TEST:
 		return efx_ethtool_fill_self_tests(efx, NULL, NULL, NULL);
 	default:
@@ -472,7 +472,7 @@ void efx_siena_ethtool_get_strings(struct net_device *net_dev,
 		strings += EFX_ETHTOOL_SW_STAT_COUNT * ETH_GSTRING_LEN;
 		strings += (efx_describe_per_queue_stats(efx, strings) *
 			    ETH_GSTRING_LEN);
-		efx_ptp_describe_stats(efx, strings);
+		efx_siena_ptp_describe_stats(efx, strings);
 		break;
 	case ETH_SS_TEST:
 		efx_ethtool_fill_self_tests(efx, NULL, strings, NULL);
@@ -554,7 +554,7 @@ void efx_siena_ethtool_get_stats(struct net_device *net_dev,
 		}
 	}
 
-	efx_ptp_update_stats(efx, data);
+	efx_siena_ptp_update_stats(efx, data);
 }
 
 /* This must be called with rtnl_lock held. */
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 7f8f0889bf8d..ff426b228cb2 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -1363,10 +1363,10 @@ void efx_mcdi_process_event(struct efx_channel *channel,
 	case MCDI_EVENT_CODE_PTP_RX:
 	case MCDI_EVENT_CODE_PTP_FAULT:
 	case MCDI_EVENT_CODE_PTP_PPS:
-		efx_ptp_event(efx, event);
+		efx_siena_ptp_event(efx, event);
 		break;
 	case MCDI_EVENT_CODE_PTP_TIME:
-		efx_time_sync_event(channel, event);
+		efx_siena_time_sync_event(channel, event);
 		break;
 	case MCDI_EVENT_CODE_TX_FLUSH:
 	case MCDI_EVENT_CODE_RX_FLUSH:
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index daf23070d353..b67417063a80 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -355,7 +355,7 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
 static int efx_phc_enable(struct ptp_clock_info *ptp,
 			  struct ptp_clock_request *request, int on);
 
-bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
+bool efx_siena_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
 {
 	return efx_has_cap(efx, TX_MAC_TIMESTAMPING);
 }
@@ -365,7 +365,7 @@ bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
  */
 static bool efx_ptp_want_txqs(struct efx_channel *channel)
 {
-	return efx_ptp_use_mac_tx_timestamps(channel->efx);
+	return efx_siena_ptp_use_mac_tx_timestamps(channel->efx);
 }
 
 #define PTP_SW_STAT(ext_name, field_name)				\
@@ -393,7 +393,7 @@ static const unsigned long efx_ptp_stat_mask[] = {
 	[0 ... BITS_TO_LONGS(PTP_STAT_COUNT) - 1] = ~0UL,
 };
 
-size_t efx_ptp_describe_stats(struct efx_nic *efx, u8 *strings)
+size_t efx_siena_ptp_describe_stats(struct efx_nic *efx, u8 *strings)
 {
 	if (!efx->ptp_data)
 		return 0;
@@ -402,7 +402,7 @@ size_t efx_ptp_describe_stats(struct efx_nic *efx, u8 *strings)
 				      efx_ptp_stat_mask, strings);
 }
 
-size_t efx_ptp_update_stats(struct efx_nic *efx, u64 *stats)
+size_t efx_siena_ptp_update_stats(struct efx_nic *efx, u64 *stats)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_STATUS_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_PTP_OUT_STATUS_LEN);
@@ -536,14 +536,14 @@ static ktime_t efx_ptp_s_qns_to_ktime_correction(u32 nic_major, u32 nic_minor,
 	return kt;
 }
 
-struct efx_channel *efx_ptp_channel(struct efx_nic *efx)
+struct efx_channel *efx_siena_ptp_channel(struct efx_nic *efx)
 {
 	return efx->ptp_data ? efx->ptp_data->channel : NULL;
 }
 
 static u32 last_sync_timestamp_major(struct efx_nic *efx)
 {
-	struct efx_channel *channel = efx_ptp_channel(efx);
+	struct efx_channel *channel = efx_siena_ptp_channel(efx);
 	u32 major = 0;
 
 	if (channel)
@@ -606,13 +606,13 @@ efx_ptp_mac_nic_to_ktime_correction(struct efx_nic *efx,
 	return kt;
 }
 
-ktime_t efx_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue)
+ktime_t efx_siena_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue)
 {
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	ktime_t kt;
 
-	if (efx_ptp_use_mac_tx_timestamps(efx))
+	if (efx_siena_ptp_use_mac_tx_timestamps(efx))
 		kt = efx_ptp_mac_nic_to_ktime_correction(efx, ptp,
 				tx_queue->completed_timestamp_major,
 				tx_queue->completed_timestamp_minor,
@@ -1437,7 +1437,7 @@ static const struct ptp_clock_info efx_phc_clock_info = {
 };
 
 /* Initialise PTP state. */
-int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
+static int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 {
 	struct efx_ptp_data *ptp;
 	int rc = 0;
@@ -1464,7 +1464,7 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 		goto fail2;
 	}
 
-	if (efx_ptp_use_mac_tx_timestamps(efx)) {
+	if (efx_siena_ptp_use_mac_tx_timestamps(efx)) {
 		ptp->xmit_skb = efx_ptp_xmit_skb_queue;
 		/* Request sync events on this channel. */
 		channel->sync_events_state = SYNC_EVENTS_QUIESCENT;
@@ -1553,7 +1553,7 @@ static int efx_ptp_probe_channel(struct efx_channel *channel)
 	return 0;
 }
 
-void efx_ptp_remove(struct efx_nic *efx)
+static void efx_ptp_remove(struct efx_nic *efx)
 {
 	if (!efx->ptp_data)
 		return;
@@ -1593,7 +1593,7 @@ static void efx_ptp_get_channel_name(struct efx_channel *channel,
 /* Determine whether this packet should be processed by the PTP module
  * or transmitted conventionally.
  */
-bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
+bool efx_siena_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
 {
 	return efx->ptp_data &&
 		efx->ptp_data->enabled &&
@@ -1699,7 +1699,7 @@ static bool efx_ptp_rx(struct efx_channel *channel, struct sk_buff *skb)
  * itself, through an MCDI call.  MCDI calls aren't permitted
  * in the transmit path so defer the actual transmission to a suitable worker.
  */
-int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
+int efx_siena_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 
@@ -1713,13 +1713,13 @@ int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-int efx_ptp_get_mode(struct efx_nic *efx)
+int efx_siena_ptp_get_mode(struct efx_nic *efx)
 {
 	return efx->ptp_data->mode;
 }
 
-int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
-			unsigned int new_mode)
+int efx_siena_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
+			      unsigned int new_mode)
 {
 	if ((enable_wanted != efx->ptp_data->enabled) ||
 	    (enable_wanted && (efx->ptp_data->mode != new_mode))) {
@@ -1777,7 +1777,8 @@ static int efx_ptp_ts_init(struct efx_nic *efx, struct hwtstamp_config *init)
 	return 0;
 }
 
-void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info)
+void efx_siena_ptp_get_ts_info(struct efx_nic *efx,
+			       struct ethtool_ts_info *ts_info)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	struct efx_nic *primary = efx->primary;
@@ -1797,7 +1798,7 @@ void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info)
 	ts_info->rx_filters = ptp->efx->type->hwtstamp_filters;
 }
 
-int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr)
+int efx_siena_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
 	int rc;
@@ -1817,7 +1818,7 @@ int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr)
 		? -EFAULT : 0;
 }
 
-int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr)
+int efx_siena_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr)
 {
 	if (!efx->ptp_data)
 		return -EOPNOTSUPP;
@@ -1898,7 +1899,7 @@ static void ptp_event_pps(struct efx_nic *efx, struct efx_ptp_data *ptp)
 		queue_work(ptp->pps_workwq, &ptp->pps_work);
 }
 
-void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev)
+void efx_siena_ptp_event(struct efx_nic *efx, efx_qword_t *ev)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	int code = EFX_QWORD_FIELD(*ev, MCDI_EVENT_CODE);
@@ -1949,7 +1950,7 @@ void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev)
 	}
 }
 
-void efx_time_sync_event(struct efx_channel *channel, efx_qword_t *ev)
+void efx_siena_time_sync_event(struct efx_channel *channel, efx_qword_t *ev)
 {
 	struct efx_nic *efx = channel->efx;
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1985,8 +1986,8 @@ static inline u32 efx_rx_buf_timestamp_minor(struct efx_nic *efx, const u8 *eh)
 #endif
 }
 
-void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
-				   struct sk_buff *skb)
+void __efx_siena_rx_skb_attach_timestamp(struct efx_channel *channel,
+					 struct sk_buff *skb)
 {
 	struct efx_nic *efx = channel->efx;
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -2171,7 +2172,7 @@ static const struct efx_channel_type efx_ptp_channel_type = {
 	.keep_eventq		= false,
 };
 
-void efx_ptp_defer_probe_with_channel(struct efx_nic *efx)
+void efx_siena_ptp_defer_probe_with_channel(struct efx_nic *efx)
 {
 	/* Check whether PTP is implemented on this NIC.  The DISABLE
 	 * operation will succeed if and only if it is implemented.
@@ -2181,7 +2182,7 @@ void efx_ptp_defer_probe_with_channel(struct efx_nic *efx)
 			&efx_ptp_channel_type;
 }
 
-void efx_ptp_start_datapath(struct efx_nic *efx)
+void efx_siena_ptp_start_datapath(struct efx_nic *efx)
 {
 	if (efx_ptp_restart(efx))
 		netif_err(efx, drv, efx->net_dev, "Failed to restart PTP.\n");
@@ -2190,7 +2191,7 @@ void efx_ptp_start_datapath(struct efx_nic *efx)
 		efx->type->ptp_set_ts_sync_events(efx, true, true);
 }
 
-void efx_ptp_stop_datapath(struct efx_nic *efx)
+void efx_siena_ptp_stop_datapath(struct efx_nic *efx)
 {
 	/* temporarily disable timestamping */
 	if (efx->type->ptp_set_ts_sync_events)
diff --git a/drivers/net/ethernet/sfc/siena/ptp.h b/drivers/net/ethernet/sfc/siena/ptp.h
index 9855e8c9e544..4172f90e9f6f 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.h
+++ b/drivers/net/ethernet/sfc/siena/ptp.h
@@ -13,33 +13,33 @@
 #include "net_driver.h"
 
 struct ethtool_ts_info;
-int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
-void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
-struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
-void efx_ptp_remove(struct efx_nic *efx);
-int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-void efx_ptp_get_ts_info(struct efx_nic *efx, struct ethtool_ts_info *ts_info);
-bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
-int efx_ptp_get_mode(struct efx_nic *efx);
-int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
-			unsigned int new_mode);
-int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
-void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
-size_t efx_ptp_describe_stats(struct efx_nic *efx, u8 *strings);
-size_t efx_ptp_update_stats(struct efx_nic *efx, u64 *stats);
-void efx_time_sync_event(struct efx_channel *channel, efx_qword_t *ev);
-void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
-				   struct sk_buff *skb);
+void efx_siena_ptp_defer_probe_with_channel(struct efx_nic *efx);
+struct efx_channel *efx_siena_ptp_channel(struct efx_nic *efx);
+int efx_siena_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
+int efx_siena_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
+void efx_siena_ptp_get_ts_info(struct efx_nic *efx,
+			       struct ethtool_ts_info *ts_info);
+bool efx_siena_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
+int efx_siena_ptp_get_mode(struct efx_nic *efx);
+int efx_siena_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
+			      unsigned int new_mode);
+int efx_siena_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
+void efx_siena_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
+size_t efx_siena_ptp_describe_stats(struct efx_nic *efx, u8 *strings);
+size_t efx_siena_ptp_update_stats(struct efx_nic *efx, u64 *stats);
+void efx_siena_time_sync_event(struct efx_channel *channel, efx_qword_t *ev);
+void __efx_siena_rx_skb_attach_timestamp(struct efx_channel *channel,
+					 struct sk_buff *skb);
 static inline void efx_rx_skb_attach_timestamp(struct efx_channel *channel,
 					       struct sk_buff *skb)
 {
 	if (channel->sync_events_state == SYNC_EVENTS_VALID)
-		__efx_rx_skb_attach_timestamp(channel, skb);
+		__efx_siena_rx_skb_attach_timestamp(channel, skb);
 }
-void efx_ptp_start_datapath(struct efx_nic *efx);
-void efx_ptp_stop_datapath(struct efx_nic *efx);
-bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx);
-ktime_t efx_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue);
+
+void efx_siena_ptp_start_datapath(struct efx_nic *efx);
+void efx_siena_ptp_stop_datapath(struct efx_nic *efx);
+bool efx_siena_ptp_use_mac_tx_timestamps(struct efx_nic *efx);
+ktime_t efx_siena_ptp_nic_to_kernel_time(struct efx_tx_queue *tx_queue);
 
 #endif /* EFX_PTP_H */
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index 726dd4b72779..d70e481d0c73 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -143,27 +143,28 @@ static int siena_ptp_set_ts_config(struct efx_nic *efx,
 	switch (init->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		/* if TX timestamping is still requested then leave PTP on */
-		return efx_ptp_change_mode(efx,
-					   init->tx_type != HWTSTAMP_TX_OFF,
-					   efx_ptp_get_mode(efx));
+		return efx_siena_ptp_change_mode(efx,
+					init->tx_type != HWTSTAMP_TX_OFF,
+					efx_siena_ptp_get_mode(efx));
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
 		init->rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		return efx_ptp_change_mode(efx, true, MC_CMD_PTP_MODE_V1);
+		return efx_siena_ptp_change_mode(efx, true, MC_CMD_PTP_MODE_V1);
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 		init->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
-		rc = efx_ptp_change_mode(efx, true,
-					 MC_CMD_PTP_MODE_V2_ENHANCED);
+		rc = efx_siena_ptp_change_mode(efx, true,
+					       MC_CMD_PTP_MODE_V2_ENHANCED);
 		/* bug 33070 - old versions of the firmware do not support the
 		 * improved UUID filtering option. Similarly old versions of the
 		 * application do not expect it to be enabled. If the firmware
 		 * does not accept the enhanced mode, fall back to the standard
 		 * PTP v2 UUID filtering. */
 		if (rc != 0)
-			rc = efx_ptp_change_mode(efx, true, MC_CMD_PTP_MODE_V2);
+			rc = efx_siena_ptp_change_mode(efx, true,
+						       MC_CMD_PTP_MODE_V2);
 		return rc;
 	default:
 		return -ERANGE;
@@ -329,7 +330,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 #ifdef CONFIG_SFC_SRIOV
 	efx_siena_sriov_probe(efx);
 #endif
-	efx_ptp_defer_probe_with_channel(efx);
+	efx_siena_ptp_defer_probe_with_channel(efx);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/siena/tx.c b/drivers/net/ethernet/sfc/siena/tx.c
index 2e9b0f172b4a..f78c2a868e4b 100644
--- a/drivers/net/ethernet/sfc/siena/tx.c
+++ b/drivers/net/ethernet/sfc/siena/tx.c
@@ -318,13 +318,13 @@ netdev_tx_t efx_siena_hard_start_xmit(struct sk_buff *skb,
 
 	/* PTP "event" packet */
 	if (unlikely(efx_xmit_with_hwtstamp(skb)) &&
-	    unlikely(efx_ptp_is_ptp_tx(efx, skb))) {
+	    unlikely(efx_siena_ptp_is_ptp_tx(efx, skb))) {
 		/* There may be existing transmits on the channel that are
 		 * waiting for this packet to trigger the doorbell write.
 		 * We need to send the packets at this point.
 		 */
 		efx_tx_send_pending(efx_get_tx_channel(efx, index));
-		return efx_ptp_tx(efx, skb);
+		return efx_siena_ptp_tx(efx, skb);
 	}
 
 	tx_queue = efx_get_tx_queue(efx, index, type);
diff --git a/drivers/net/ethernet/sfc/siena/tx_common.c b/drivers/net/ethernet/sfc/siena/tx_common.c
index 66adc8525a3a..31e9888e71df 100644
--- a/drivers/net/ethernet/sfc/siena/tx_common.c
+++ b/drivers/net/ethernet/sfc/siena/tx_common.c
@@ -80,8 +80,8 @@ void efx_siena_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->old_read_count = 0;
 	tx_queue->empty_read_count = 0 | EFX_EMPTY_COUNT_VALID;
 	tx_queue->xmit_pending = false;
-	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
-				  tx_queue->channel == efx_ptp_channel(efx));
+	tx_queue->timestamping = (efx_siena_ptp_use_mac_tx_timestamps(efx) &&
+				  tx_queue->channel == efx_siena_ptp_channel(efx));
 	tx_queue->completed_timestamp_major = 0;
 	tx_queue->completed_timestamp_minor = 0;
 
@@ -148,7 +148,7 @@ static void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 			struct skb_shared_hwtstamps hwtstamp;
 
 			hwtstamp.hwtstamp =
-				efx_ptp_nic_to_kernel_time(tx_queue);
+				efx_siena_ptp_nic_to_kernel_time(tx_queue);
 			skb_tstamp_tx(skb, &hwtstamp);
 
 			tx_queue->completed_timestamp_major = 0;

