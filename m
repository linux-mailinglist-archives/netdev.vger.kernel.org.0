Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302053F7EF5
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhHYXTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233577AbhHYXTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 19:19:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E097A610CB;
        Wed, 25 Aug 2021 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629933514;
        bh=hH8WVt+KNrvsr3utkgrPKJFbggc3FspzmQMjE+R9Kao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gr+OgWKNLwIbjIBZRFHw4naYqInAdaUsqYKEGD0zN/wqa7RBfjXZq+Ethisb+45mZ
         43ITN5sg+1m9abcc48/13+2jA77vuDrbcMjy0I95ZgKNJ7AXgsuJdVfQgYeW0kMAli
         9AAEdP3wuAAM+Ue9zzNxLk1opLWyyJVmPqlyYct3NWTzyzBkU9sOPYCFcTZIPQp+9S
         mLcDgvwQrGJnzfKkndTXjefXpUk0VUIRVJUeg8jqpLyC6c97tVMDLeN4Qgrr428GBz
         b+3gJJcNbySzs3XlvW4YAwbGgzKsqpnkySHP3YHJbXw+7b/F6c3KzldILA4kzkzcsH
         /bC8ZI/0elH0w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] bnxt: count packets discarded because of netpoll
Date:   Wed, 25 Aug 2021 16:18:29 -0700
Message-Id: <20210825231830.2748915-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210825231830.2748915-1-kuba@kernel.org>
References: <20210825231830.2748915-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt may discard packets if Rx completions are consumed
in an attempt to let netpoll make progress. It should be
exteremely rare in practice but nonetheless such events
should be counted.

Since completion ring memory is allocated dynamically use
a similar scheme to what is done for HW stats to save them.

Report the stats in rx_dropped and per-netdev ethtool
counter. Chances that users care which ring dropped are
very low.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 31 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  6 ++++
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d39449e7b236..d12a9052388f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2003,6 +2003,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	struct rx_cmp *rxcmp;
 	u16 cp_cons;
 	u8 cmp_type;
+	int ret;
 
 	cp_cons = RING_CMP(tmp_raw_cons);
 	rxcmp = (struct rx_cmp *)
@@ -2031,7 +2032,10 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 		tpa_end1->rx_tpa_end_cmp_errors_v2 |=
 			cpu_to_le32(RX_TPA_END_CMP_ERRORS);
 	}
-	return bnxt_rx_pkt(bp, cpr, raw_cons, event);
+	ret = bnxt_rx_pkt(bp, cpr, raw_cons, event);
+	if (ret != -EBUSY)
+		cpr->sw_stats.rx.rx_netpoll_discards += 1;
+	return ret;
 }
 
 u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx)
@@ -10441,7 +10445,8 @@ static bool bnxt_drv_busy(struct bnxt *bp)
 }
 
 static void bnxt_get_ring_stats(struct bnxt *bp,
-				struct rtnl_link_stats64 *stats);
+				struct rtnl_link_stats64 *stats,
+				struct bnxt_sw_stats *bsw_stats);
 
 static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 			     bool link_re_init)
@@ -10470,7 +10475,8 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 
 	/* Save ring stats before shutdown */
 	if (bp->bnapi && irq_re_init)
-		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
+		bnxt_get_ring_stats(bp, &bp->net_stats_prev,
+				    &bp->sw_stats_prev);
 	if (irq_re_init) {
 		bnxt_free_irq(bp);
 		bnxt_del_napi(bp);
@@ -10615,7 +10621,8 @@ static int bnxt_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static void bnxt_get_ring_stats(struct bnxt *bp,
-				struct rtnl_link_stats64 *stats)
+				struct rtnl_link_stats64 *stats,
+				struct bnxt_sw_stats *bsw_stats)
 {
 	int i;
 
@@ -10646,11 +10653,15 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
 		stats->multicast += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
 
 		stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
+
+		bsw_stats->rx.rx_netpoll_discards +=
+			cpr->sw_stats.rx.rx_netpoll_discards;
 	}
 }
 
 static void bnxt_add_prev_stats(struct bnxt *bp,
-				struct rtnl_link_stats64 *stats)
+				struct rtnl_link_stats64 *stats,
+				struct bnxt_sw_stats *bsw_stats)
 {
 	struct rtnl_link_stats64 *prev_stats = &bp->net_stats_prev;
 
@@ -10661,11 +10672,15 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 	stats->rx_missed_errors += prev_stats->rx_missed_errors;
 	stats->multicast += prev_stats->multicast;
 	stats->tx_dropped += prev_stats->tx_dropped;
+
+	bsw_stats->rx.rx_netpoll_discards +=
+		bp->sw_stats_prev.rx.rx_netpoll_discards;
 }
 
 static void
 bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
+	struct bnxt_sw_stats bsw_stats = {};
 	struct bnxt *bp = netdev_priv(dev);
 
 	set_bit(BNXT_STATE_READ_STATS, &bp->state);
@@ -10699,9 +10714,11 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_errors = BNXT_GET_TX_PORT_STATS64(tx, tx_err);
 	}
 
-	bnxt_get_ring_stats(bp, stats);
+	bnxt_get_ring_stats(bp, stats, &bsw_stats);
 skip_current:
-	bnxt_add_prev_stats(bp, stats);
+	bnxt_add_prev_stats(bp, stats, &bsw_stats);
+
+	stats->rx_dropped += bsw_stats.rx.rx_netpoll_discards;
 
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 7b989b6e4f6e..5c2e9a06e959 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -939,6 +939,7 @@ struct bnxt_rx_sw_stats {
 	u64			rx_l4_csum_errors;
 	u64			rx_resets;
 	u64			rx_buf_errors;
+	u64			rx_netpoll_discards;
 };
 
 struct bnxt_cmn_sw_stats {
@@ -1917,6 +1918,7 @@ struct bnxt {
 	dma_addr_t		hwrm_cmd_kong_resp_dma_addr;
 
 	struct rtnl_link_stats64	net_stats_prev;
+	struct bnxt_sw_stats	sw_stats_prev;
 	struct bnxt_stats_mem	port_stats;
 	struct bnxt_stats_mem	rx_port_stats_ext;
 	struct bnxt_stats_mem	tx_port_stats_ext;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9f8c72d95228..25f1327aedb6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -307,6 +307,7 @@ static const char * const bnxt_cmn_sw_stats_str[] = {
 enum {
 	RX_TOTAL_DISCARDS,
 	TX_TOTAL_DISCARDS,
+	RX_NETPOLL_DISCARDS,
 };
 
 static struct {
@@ -315,6 +316,7 @@ static struct {
 } bnxt_sw_func_stats[] = {
 	{0, "rx_total_discard_pkts"},
 	{0, "tx_total_discard_pkts"},
+	{0, "rx_netpoll_discards"},
 };
 
 #define NUM_RING_RX_SW_STATS		ARRAY_SIZE(bnxt_rx_sw_stats_str)
@@ -561,6 +563,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++)
 		bnxt_sw_func_stats[i].counter = 0;
+	bnxt_sw_func_stats[RX_NETPOLL_DISCARDS].counter =
+		bp->sw_stats_prev.rx.rx_netpoll_discards;
 
 	tpa_stats = bnxt_get_num_tpa_ring_stats(bp);
 	for (i = 0; i < bp->cp_nr_rings; i++) {
@@ -603,6 +607,8 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 			BNXT_GET_RING_STATS64(sw_stats, rx_discard_pkts);
 		bnxt_sw_func_stats[TX_TOTAL_DISCARDS].counter +=
 			BNXT_GET_RING_STATS64(sw_stats, tx_discard_pkts);
+		bnxt_sw_func_stats[RX_NETPOLL_DISCARDS].counter +=
+			cpr->sw_stats.rx.rx_netpoll_discards;
 	}
 
 	for (i = 0; i < BNXT_NUM_SW_FUNC_STATS; i++, j++)
-- 
2.31.1

