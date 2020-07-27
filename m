Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5874F22E94E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgG0Jld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0Jlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:41:32 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6240C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:32 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so9182885pgk.4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r1UUDn5VcjX3U/MP5a8tD+y2rWamrmtkrHWVrVHou+E=;
        b=XzHU33lMhpRdoOLQvzZzvkv3tgmeMLlrdXfH394Q4/RnpTx4dXFfEmkpw+gnqEXBkP
         I2lgL1H2FCtqZScZQ9uld1mJVEszjJkqa8GiekzOMLYnDAOofqSbibtQjGtI1ajfdrhW
         M3wIpaVCIRBZx8FUvsN9XMQ3nZAbeRZoXFMI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r1UUDn5VcjX3U/MP5a8tD+y2rWamrmtkrHWVrVHou+E=;
        b=uYcvN2rDUDm/sPzEKKntyJ7TIwQNiBZpllHCZtVXSDoiV7xrvO8soa1/DOLyGKL7uv
         6ZElSKDF/9rlBFQHZKlSGeO1EcD/EK02ixWEVwilbfg9BYxwZA5zhXFtp2TIAbzlBqtV
         PauVEKOtko3v13uer9lWJ0C01PEVTOdosgPZMA2sdo6LfNqiSaCEitYPeQ/5N5hRdsAN
         RfCQb9GFYtDNu0RiVGDdOZEKMa/hdRi4i1GdRp6raJvuYLVZJbLt683Dzc+fg3U92RGS
         81ayWvYj60pYwND49nLm2U5riQSRE03IYRDYEhX0zjwyVZztMj1+iBuP1zsk8CGSu0xH
         KDng==
X-Gm-Message-State: AOAM530UkL37Fb9JF9C7+eeGDmGIpufQRAAGjAVGY/NrEaqORip0tco9
        2uUvq7xOnihuVSMTwRbbKuGjjuhUsUs=
X-Google-Smtp-Source: ABdhPJzedNLPW6W/y2W97ZygYSYIFCPIJ91K2yfLhd+ZiriBnXN788BLKqJ1nzKMOo444LSNPyJ8rw==
X-Received: by 2002:a63:8c5d:: with SMTP id q29mr18522411pgn.249.1595842892101;
        Mon, 27 Jul 2020 02:41:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f131sm14560945pgc.14.2020.07.27.02.41.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jul 2020 02:41:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 09/10] bnxt_en: Switch over to use the 64-bit software accumulated counters.
Date:   Mon, 27 Jul 2020 05:40:44 -0400
Message-Id: <1595842845-19403-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
References: <1595842845-19403-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we can report all the full 64-bit CPU endian software accumulated
counters instead of the hw counters, some of which may be less than
64-bit wide.  Define the necessary macros to access the software
counters.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 67 ++++++++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  9 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 41 +++++++-------
 3 files changed, 64 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a8e86da..014edd8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9791,34 +9791,33 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 {
 	int i;
 
-
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
-		struct ctx_hw_stats *hw_stats = cpr->stats.hw_stats;
+		u64 *sw = cpr->stats.sw_stats;
 
-		stats->rx_packets += le64_to_cpu(hw_stats->rx_ucast_pkts);
-		stats->rx_packets += le64_to_cpu(hw_stats->rx_mcast_pkts);
-		stats->rx_packets += le64_to_cpu(hw_stats->rx_bcast_pkts);
+		stats->rx_packets += BNXT_GET_RING_STATS64(sw, rx_ucast_pkts);
+		stats->rx_packets += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
+		stats->rx_packets += BNXT_GET_RING_STATS64(sw, rx_bcast_pkts);
 
-		stats->tx_packets += le64_to_cpu(hw_stats->tx_ucast_pkts);
-		stats->tx_packets += le64_to_cpu(hw_stats->tx_mcast_pkts);
-		stats->tx_packets += le64_to_cpu(hw_stats->tx_bcast_pkts);
+		stats->tx_packets += BNXT_GET_RING_STATS64(sw, tx_ucast_pkts);
+		stats->tx_packets += BNXT_GET_RING_STATS64(sw, tx_mcast_pkts);
+		stats->tx_packets += BNXT_GET_RING_STATS64(sw, tx_bcast_pkts);
 
-		stats->rx_bytes += le64_to_cpu(hw_stats->rx_ucast_bytes);
-		stats->rx_bytes += le64_to_cpu(hw_stats->rx_mcast_bytes);
-		stats->rx_bytes += le64_to_cpu(hw_stats->rx_bcast_bytes);
+		stats->rx_bytes += BNXT_GET_RING_STATS64(sw, rx_ucast_bytes);
+		stats->rx_bytes += BNXT_GET_RING_STATS64(sw, rx_mcast_bytes);
+		stats->rx_bytes += BNXT_GET_RING_STATS64(sw, rx_bcast_bytes);
 
-		stats->tx_bytes += le64_to_cpu(hw_stats->tx_ucast_bytes);
-		stats->tx_bytes += le64_to_cpu(hw_stats->tx_mcast_bytes);
-		stats->tx_bytes += le64_to_cpu(hw_stats->tx_bcast_bytes);
+		stats->tx_bytes += BNXT_GET_RING_STATS64(sw, tx_ucast_bytes);
+		stats->tx_bytes += BNXT_GET_RING_STATS64(sw, tx_mcast_bytes);
+		stats->tx_bytes += BNXT_GET_RING_STATS64(sw, tx_bcast_bytes);
 
 		stats->rx_missed_errors +=
-			le64_to_cpu(hw_stats->rx_discard_pkts);
+			BNXT_GET_RING_STATS64(sw, rx_discard_pkts);
 
-		stats->multicast += le64_to_cpu(hw_stats->rx_mcast_pkts);
+		stats->multicast += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
 
-		stats->tx_dropped += le64_to_cpu(hw_stats->tx_error_pkts);
+		stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
 	}
 }
 
@@ -9856,20 +9855,26 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 	bnxt_add_prev_stats(bp, stats);
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
-		struct rx_port_stats *rx = bp->port_stats.hw_stats;
-		struct tx_port_stats *tx = bp->port_stats.hw_stats +
-					   BNXT_TX_PORT_STATS_BYTE_OFFSET;
-
-		stats->rx_crc_errors = le64_to_cpu(rx->rx_fcs_err_frames);
-		stats->rx_frame_errors = le64_to_cpu(rx->rx_align_err_frames);
-		stats->rx_length_errors = le64_to_cpu(rx->rx_undrsz_frames) +
-					  le64_to_cpu(rx->rx_ovrsz_frames) +
-					  le64_to_cpu(rx->rx_runt_frames);
-		stats->rx_errors = le64_to_cpu(rx->rx_false_carrier_frames) +
-				   le64_to_cpu(rx->rx_jbr_frames);
-		stats->collisions = le64_to_cpu(tx->tx_total_collisions);
-		stats->tx_fifo_errors = le64_to_cpu(tx->tx_fifo_underruns);
-		stats->tx_errors = le64_to_cpu(tx->tx_err);
+		u64 *rx = bp->port_stats.sw_stats;
+		u64 *tx = bp->port_stats.sw_stats +
+			  BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+
+		stats->rx_crc_errors =
+			BNXT_GET_RX_PORT_STATS64(rx, rx_fcs_err_frames);
+		stats->rx_frame_errors =
+			BNXT_GET_RX_PORT_STATS64(rx, rx_align_err_frames);
+		stats->rx_length_errors =
+			BNXT_GET_RX_PORT_STATS64(rx, rx_undrsz_frames) +
+			BNXT_GET_RX_PORT_STATS64(rx, rx_ovrsz_frames) +
+			BNXT_GET_RX_PORT_STATS64(rx, rx_runt_frames);
+		stats->rx_errors =
+			BNXT_GET_RX_PORT_STATS64(rx, rx_false_carrier_frames) +
+			BNXT_GET_RX_PORT_STATS64(rx, rx_jbr_frames);
+		stats->collisions =
+			BNXT_GET_TX_PORT_STATS64(tx, tx_total_collisions);
+		stats->tx_fifo_errors =
+			BNXT_GET_TX_PORT_STATS64(tx, tx_fifo_underruns);
+		stats->tx_errors = BNXT_GET_TX_PORT_STATS64(tx, tx_err);
 	}
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 44c7812..0c9b79b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1928,6 +1928,15 @@ struct bnxt {
 	struct device		*hwmon_dev;
 };
 
+#define BNXT_GET_RING_STATS64(sw, counter)		\
+	(*((sw) + offsetof(struct ctx_hw_stats, counter) / 8))
+
+#define BNXT_GET_RX_PORT_STATS64(sw, counter)		\
+	(*((sw) + offsetof(struct rx_port_stats, counter) / 8))
+
+#define BNXT_GET_TX_PORT_STATS64(sw, counter)		\
+	(*((sw) + offsetof(struct tx_port_stats, counter) / 8))
+
 #define BNXT_PORT_STATS_SIZE				\
 	(sizeof(struct rx_port_stats) + sizeof(struct tx_port_stats) + 1024)
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 59ebb2b..ff380d7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -559,20 +559,19 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
-		struct ctx_hw_stats *hw = cpr->stats.hw_stats;
-		__le64 *hw_stats = cpr->stats.hw_stats;
+		u64 *sw_stats = cpr->stats.sw_stats;
 		u64 *sw;
 		int k;
 
 		if (is_rx_ring(bp, i)) {
 			for (k = 0; k < NUM_RING_RX_HW_STATS; j++, k++)
-				buf[j] = le64_to_cpu(hw_stats[k]);
+				buf[j] = sw_stats[k];
 		}
 		if (is_tx_ring(bp, i)) {
 			k = NUM_RING_RX_HW_STATS;
 			for (; k < NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS;
 			       j++, k++)
-				buf[j] = le64_to_cpu(hw_stats[k]);
+				buf[j] = sw_stats[k];
 		}
 		if (!tpa_stats || !is_rx_ring(bp, i))
 			goto skip_tpa_ring_stats;
@@ -580,7 +579,7 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 		k = NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS;
 		for (; k < NUM_RING_RX_HW_STATS + NUM_RING_TX_HW_STATS +
 			   tpa_stats; j++, k++)
-			buf[j] = le64_to_cpu(hw_stats[k]);
+			buf[j] = sw_stats[k];
 
 skip_tpa_ring_stats:
 		sw = (u64 *)&cpr->sw_stats.rx;
@@ -594,9 +593,9 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			buf[j] = sw[k];
 
 		bnxt_sw_func_stats[RX_TOTAL_DISCARDS].counter +=
-			le64_to_cpu(hw->rx_discard_pkts);
+			BNXT_GET_RING_STATS64(sw_stats, rx_discard_pkts);
 		bnxt_sw_func_stats[TX_TOTAL_DISCARDS].counter +=
-			le64_to_cpu(hw->tx_discard_pkts);
+			BNXT_GET_RING_STATS64(sw_stats, tx_discard_pkts);
 	}
 
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++, j++)
@@ -604,49 +603,47 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 
 skip_ring_stats:
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
-		__le64 *port_stats = bp->port_stats.hw_stats;
+		u64 *port_stats = bp->port_stats.sw_stats;
 
-		for (i = 0; i < BNXT_NUM_PORT_STATS; i++, j++) {
-			buf[j] = le64_to_cpu(*(port_stats +
-					       bnxt_port_stats_arr[i].offset));
-		}
+		for (i = 0; i < BNXT_NUM_PORT_STATS; i++, j++)
+			buf[j] = *(port_stats + bnxt_port_stats_arr[i].offset);
 	}
 	if (bp->flags & BNXT_FLAG_PORT_STATS_EXT) {
-		__le64 *rx_port_stats_ext = bp->rx_port_stats_ext.hw_stats;
-		__le64 *tx_port_stats_ext = bp->tx_port_stats_ext.hw_stats;
+		u64 *rx_port_stats_ext = bp->rx_port_stats_ext.sw_stats;
+		u64 *tx_port_stats_ext = bp->tx_port_stats_ext.sw_stats;
 
 		for (i = 0; i < bp->fw_rx_stats_ext_size; i++, j++) {
-			buf[j] = le64_to_cpu(*(rx_port_stats_ext +
-					    bnxt_port_stats_ext_arr[i].offset));
+			buf[j] = *(rx_port_stats_ext +
+				   bnxt_port_stats_ext_arr[i].offset);
 		}
 		for (i = 0; i < bp->fw_tx_stats_ext_size; i++, j++) {
-			buf[j] = le64_to_cpu(*(tx_port_stats_ext +
-					bnxt_tx_port_stats_ext_arr[i].offset));
+			buf[j] = *(tx_port_stats_ext +
+				   bnxt_tx_port_stats_ext_arr[i].offset);
 		}
 		if (bp->pri2cos_valid) {
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_bytes_pri_arr[i].base_off +
 					 bp->pri2cos_idx[i];
 
-				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
+				buf[j] = *(rx_port_stats_ext + n);
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_rx_pkts_pri_arr[i].base_off +
 					 bp->pri2cos_idx[i];
 
-				buf[j] = le64_to_cpu(*(rx_port_stats_ext + n));
+				buf[j] = *(rx_port_stats_ext + n);
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_bytes_pri_arr[i].base_off +
 					 bp->pri2cos_idx[i];
 
-				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
+				buf[j] = *(tx_port_stats_ext + n);
 			}
 			for (i = 0; i < 8; i++, j++) {
 				long n = bnxt_tx_pkts_pri_arr[i].base_off +
 					 bp->pri2cos_idx[i];
 
-				buf[j] = le64_to_cpu(*(tx_port_stats_ext + n));
+				buf[j] = *(tx_port_stats_ext + n);
 			}
 		}
 	}
-- 
1.8.3.1

