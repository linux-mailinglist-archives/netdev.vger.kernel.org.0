Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5271F1065B8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfKVG0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbfKVFuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ABE02070E;
        Fri, 22 Nov 2019 05:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401854;
        bh=887t78AFWn2ykuGAN0KAxB68A8TLqpVuRB002iBx9Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmJVnp6DN1mxYMZSgFny7ZYkh0vlAj47magYwBRBrAVr0Vl/V5y5PETU4QAkzlJka
         CCbk9rQQtT19luMQakL5os8RoscSqSdR3U5zMQKirBqGGKegBl3rNEyvq8gREEfFJE
         R7BxQr7t4xH1HbB748x8oKO4WAC0UUPRi+e/V4Bc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 091/219] bnxt_en: Save ring statistics before reset.
Date:   Fri, 22 Nov 2019 00:47:03 -0500
Message-Id: <20191122054911.1750-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit b8875ca356f1c0b17ec68be6666269373a62288e ]

With the current driver, the statistics reported by .ndo_get_stats64()
are reset when the device goes down.  Store a snapshot of the
rtnl_link_stats64 before shutdown.  This snapshot is added to the
current counters in .ndo_get_stats64() so that the counters will not
get reset when the device is down.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 57 +++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c54a74de7b088..2f61175f5655a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7148,6 +7148,9 @@ static bool bnxt_drv_busy(struct bnxt *bp)
 		test_bit(BNXT_STATE_READ_STATS, &bp->state));
 }
 
+static void bnxt_get_ring_stats(struct bnxt *bp,
+				struct rtnl_link_stats64 *stats);
+
 static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 			     bool link_re_init)
 {
@@ -7173,6 +7176,9 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	del_timer_sync(&bp->timer);
 	bnxt_free_skbs(bp);
 
+	/* Save ring stats before shutdown */
+	if (bp->bnapi)
+		bnxt_get_ring_stats(bp, &bp->net_stats_prev);
 	if (irq_re_init) {
 		bnxt_free_irq(bp);
 		bnxt_del_napi(bp);
@@ -7234,23 +7240,12 @@ static int bnxt_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return -EOPNOTSUPP;
 }
 
-static void
-bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+static void bnxt_get_ring_stats(struct bnxt *bp,
+				struct rtnl_link_stats64 *stats)
 {
-	u32 i;
-	struct bnxt *bp = netdev_priv(dev);
+	int i;
 
-	set_bit(BNXT_STATE_READ_STATS, &bp->state);
-	/* Make sure bnxt_close_nic() sees that we are reading stats before
-	 * we check the BNXT_STATE_OPEN flag.
-	 */
-	smp_mb__after_atomic();
-	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
-		clear_bit(BNXT_STATE_READ_STATS, &bp->state);
-		return;
-	}
 
-	/* TODO check if we need to synchronize with bnxt_close path */
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr = &bnapi->cp_ring;
@@ -7279,6 +7274,40 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 		stats->tx_dropped += le64_to_cpu(hw_stats->tx_drop_pkts);
 	}
+}
+
+static void bnxt_add_prev_stats(struct bnxt *bp,
+				struct rtnl_link_stats64 *stats)
+{
+	struct rtnl_link_stats64 *prev_stats = &bp->net_stats_prev;
+
+	stats->rx_packets += prev_stats->rx_packets;
+	stats->tx_packets += prev_stats->tx_packets;
+	stats->rx_bytes += prev_stats->rx_bytes;
+	stats->tx_bytes += prev_stats->tx_bytes;
+	stats->rx_missed_errors += prev_stats->rx_missed_errors;
+	stats->multicast += prev_stats->multicast;
+	stats->tx_dropped += prev_stats->tx_dropped;
+}
+
+static void
+bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+
+	set_bit(BNXT_STATE_READ_STATS, &bp->state);
+	/* Make sure bnxt_close_nic() sees that we are reading stats before
+	 * we check the BNXT_STATE_OPEN flag.
+	 */
+	smp_mb__after_atomic();
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
+		clear_bit(BNXT_STATE_READ_STATS, &bp->state);
+		*stats = bp->net_stats_prev;
+		return;
+	}
+
+	bnxt_get_ring_stats(bp, stats);
+	bnxt_add_prev_stats(bp, stats);
 
 	if (bp->flags & BNXT_FLAG_PORT_STATS) {
 		struct rx_port_stats *rx = bp->hw_rx_port_stats;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cf2d4a6583d55..f9e253b705ece 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1302,6 +1302,7 @@ struct bnxt {
 	void			*hwrm_cmd_resp_addr;
 	dma_addr_t		hwrm_cmd_resp_dma_addr;
 
+	struct rtnl_link_stats64	net_stats_prev;
 	struct rx_port_stats	*hw_rx_port_stats;
 	struct tx_port_stats	*hw_tx_port_stats;
 	struct rx_port_stats_ext	*hw_rx_port_stats_ext;
-- 
2.20.1

