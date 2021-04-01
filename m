Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E60351F54
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhDATF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbhDATEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:04:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC25DC05BD3C
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 11so291710pfn.9
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3hoz2k7yjIaY/rbh5fOydT8HVzXfm0EzyMwjLuszb8o=;
        b=dKICFne9ap46ectVJE+pnRyg19oNqTNX2pLttujR3Zui/L6xBl4nknFJLIZsEaJjEX
         t0wZJ3RV/npskuCL641aqQlJAuu+vQg2lmEZloGgqQUEboOWai7NGmxXllK/CEIn3fnM
         4Y1yt4YmX3Oz/2jKwtKhoHx4KoD2Epr8jS+8UQjq2ruCDigXQcgBCJcJMoVVK+sncy+i
         WqvtGdpqx29mVyI+JMtklBnVFjOEZkKyorASC4CBgCVraUKU7+rVEdicw876GtP5u4PN
         IEkCrlaQvZX6rYvZIu5ASRY0moBFZyrygFjAK6gBUmEE5lXRBzV/ECopw424AHhphEcO
         8zPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3hoz2k7yjIaY/rbh5fOydT8HVzXfm0EzyMwjLuszb8o=;
        b=FgQqE+Ue6NQWD796uTWhrMzAofV/JzMmv0adRHKBtYIkX8Per5vP0vGza9mdzxN1Jv
         /5/46WGZKlWsnNNGHffJRVL0B0ZD5o6e4DiwgaXWQqXExn66OsnQtqBSqu0cFzgmjInj
         Bh5Kg0Q7nvqfrwHkwHBW1mLRTETZXovVJ9IXsCFIql6eLXvlyRjpeQm4GoTD/iNMF9Mf
         vXyYV4O0n9pq41tjNh2upSpCLp7hL6Aa0ahOU7YgWL6qMolgDV4Fca+hpQ08QnReBh1q
         M1caewOnMl//Oabeccte5Jx3jxzuFupjJd2nVMdYxoZYUrpOv4/3eHQ/cV3dhB9A8cxF
         g2Lw==
X-Gm-Message-State: AOAM531CSDIeS7szTJ8+IF/jy+iMmQYW0+FRleclXdlgj6Rg1AJv3qBq
        LC2leZA8BY6+3ddYu2LaoYVGG5odMeUzkg==
X-Google-Smtp-Source: ABdhPJygV2wiucIFjZPYlkWKoPd/H0Iu0gGiBWO7oOf7ypbkq+V1l/6H67IO3+HmVqTgS+aKoVw28A==
X-Received: by 2002:a63:dc43:: with SMTP id f3mr52242pgj.290.1617299793988;
        Thu, 01 Apr 2021 10:56:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 11/12] ionic: ethtool ptp stats
Date:   Thu,  1 Apr 2021 10:56:09 -0700
Message-Id: <20210401175610.44431-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new hwstamp stats to our ethtool stats output.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_stats.c | 38 +++++++++++++++++--
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index ed9cf93d9acd..58a854666c62 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -130,6 +130,8 @@ static const struct ionic_stat_desc ionic_tx_stats_desc[] = {
 	IONIC_TX_STAT_DESC(frags),
 	IONIC_TX_STAT_DESC(tso),
 	IONIC_TX_STAT_DESC(tso_bytes),
+	IONIC_TX_STAT_DESC(hwstamp_valid),
+	IONIC_TX_STAT_DESC(hwstamp_invalid),
 	IONIC_TX_STAT_DESC(csum_none),
 	IONIC_TX_STAT_DESC(csum),
 	IONIC_TX_STAT_DESC(vlan_inserted),
@@ -143,6 +145,8 @@ static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
 	IONIC_RX_STAT_DESC(csum_none),
 	IONIC_RX_STAT_DESC(csum_complete),
 	IONIC_RX_STAT_DESC(csum_error),
+	IONIC_RX_STAT_DESC(hwstamp_valid),
+	IONIC_RX_STAT_DESC(hwstamp_invalid),
 	IONIC_RX_STAT_DESC(dropped),
 	IONIC_RX_STAT_DESC(vlan_stripped),
 };
@@ -188,6 +192,8 @@ static void ionic_add_lif_txq_stats(struct ionic_lif *lif, int q_num,
 	stats->tx_tso_bytes += txstats->tso_bytes;
 	stats->tx_csum_none += txstats->csum_none;
 	stats->tx_csum += txstats->csum;
+	stats->tx_hwstamp_valid += txstats->hwstamp_valid;
+	stats->tx_hwstamp_invalid += txstats->hwstamp_invalid;
 }
 
 static void ionic_add_lif_rxq_stats(struct ionic_lif *lif, int q_num,
@@ -200,6 +206,8 @@ static void ionic_add_lif_rxq_stats(struct ionic_lif *lif, int q_num,
 	stats->rx_csum_none += rxstats->csum_none;
 	stats->rx_csum_complete += rxstats->csum_complete;
 	stats->rx_csum_error += rxstats->csum_error;
+	stats->rx_hwstamp_valid += rxstats->hwstamp_valid;
+	stats->rx_hwstamp_invalid += rxstats->hwstamp_invalid;
 }
 
 static void ionic_get_lif_stats(struct ionic_lif *lif,
@@ -215,6 +223,12 @@ static void ionic_get_lif_stats(struct ionic_lif *lif,
 		ionic_add_lif_rxq_stats(lif, q_num, stats);
 	}
 
+	if (lif->hwstamp_txq)
+		ionic_add_lif_txq_stats(lif, lif->hwstamp_txq->q.index, stats);
+
+	if (lif->hwstamp_rxq)
+		ionic_add_lif_rxq_stats(lif, lif->hwstamp_rxq->q.index, stats);
+
 	ionic_get_stats64(lif->netdev, &ns);
 	stats->hw_tx_dropped = ns.tx_dropped;
 	stats->hw_rx_dropped = ns.rx_dropped;
@@ -227,14 +241,18 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 {
 	u64 total = 0, tx_queues = MAX_Q(lif), rx_queues = MAX_Q(lif);
 
-	/* lif stats */
+	if (lif->hwstamp_txq)
+		tx_queues += 1;
+
+	if (lif->hwstamp_rxq)
+		rx_queues += 1;
+
 	total += IONIC_NUM_LIF_STATS;
+	total += IONIC_NUM_PORT_STATS;
+
 	total += tx_queues * IONIC_NUM_TX_STATS;
 	total += rx_queues * IONIC_NUM_RX_STATS;
 
-	/* port stats */
-	total += IONIC_NUM_PORT_STATS;
-
 	if (test_bit(IONIC_LIF_F_UP, lif->state) &&
 	    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
 		/* tx debug stats */
@@ -318,8 +336,14 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
 		ionic_sw_stats_get_tx_strings(lif, buf, q_num);
 
+	if (lif->hwstamp_txq)
+		ionic_sw_stats_get_tx_strings(lif, buf, lif->hwstamp_txq->q.index);
+
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
 		ionic_sw_stats_get_rx_strings(lif, buf, q_num);
+
+	if (lif->hwstamp_rxq)
+		ionic_sw_stats_get_rx_strings(lif, buf, lif->hwstamp_rxq->q.index);
 }
 
 static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
@@ -434,8 +458,14 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
 		ionic_sw_stats_get_txq_values(lif, buf, q_num);
 
+	if (lif->hwstamp_txq)
+		ionic_sw_stats_get_txq_values(lif, buf, lif->hwstamp_txq->q.index);
+
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
 		ionic_sw_stats_get_rxq_values(lif, buf, q_num);
+
+	if (lif->hwstamp_rxq)
+		ionic_sw_stats_get_rxq_values(lif, buf, lif->hwstamp_rxq->q.index);
 }
 
 const struct ionic_stats_group_intf ionic_stats_groups[] = {
-- 
2.17.1

