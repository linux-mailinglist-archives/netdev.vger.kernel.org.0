Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717B7CD927
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 22:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfJFUVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 16:21:17 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41503 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJFUVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 16:21:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id t10so5827246plr.8
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 13:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=H427miNUjPiTlwtERmaaH+FLvKqAaLJ2sdz9DLxlVdA=;
        b=o8XweMSiRdQzRttCjwfSbuHGcOWj5p/pTYRwigAE6a00a7rybKTH7YDpV/5Vncl1ty
         2H6vK/z7zmKw36qWiHwLcb0SZf41yZVQm3VARMzMQxln0IC4ADYlsYZQQUdMW/4lOFVq
         HmLwDdgTt/vFogt+xYFPbkgYj6HolieCpDh5pModsXw7mtBHAp/hQ9+TRA8sWR4C/Vdp
         478LA/mnlq4uuo6oOXKMJRn7VhZSxmMybqQyKPud7/bHbG07FgSNTktyNMfP4tyK3Xpm
         QGE85/Hk+VSgn8LBKXZEBvTsimHtBmIKzO9w3SlJG1U9T9tgVgYE6K5+0/5tt8BWVGkK
         j5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H427miNUjPiTlwtERmaaH+FLvKqAaLJ2sdz9DLxlVdA=;
        b=FXoP74zP0Mx4v9foaA8+7ZyzWZH3U2uiRotBUTftPYRYkeaJL6C80TvxKpXzUSujnq
         7YD1l+ZIWZ7BGS0zUIY0vtpIJwswgGUOV9GXaF7Zdbz5gJwZkE6v3CrQlFazRPLT9i4a
         zT+Hpoej9nirtxv+fH5cJmBdaDA+qYOY0kWwCqZm/Y33CQMByecr1myLaAWdSZtzxrrC
         v+MJZ9ufareflUtzS5RcvegIImJFTmqOgNLtB748lqBN09y9K1CbsjB/4sTbQcU/kMUJ
         DmFVlG4Z2/BSWX49F7r3fRU/3QAV+sx09gc7rvh/C3iFfNi60dgAklrBDrJQ8RwSldql
         siKQ==
X-Gm-Message-State: APjAAAUgtDDuYJ3x5nCbFfEnAVAkOaaQXqvFiTjn08vfSWNppr83v2Xu
        N8Ga/wf1Y7MUy+GYfBwB98Bzz6JBiUXygw==
X-Google-Smtp-Source: APXvYqwBBHBX3EUnuFAIlHgotkB21YvIxetC2N3lPKc01bnl1Ug81+7WrIzRyw3MZETbKzbrRs4oxg==
X-Received: by 2002:a17:902:b701:: with SMTP id d1mr24109709pls.209.1570393274199;
        Sun, 06 Oct 2019 13:21:14 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id cx22sm10388271pjb.19.2019.10.06.13.21.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 13:21:13 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix stats memory dereference
Date:   Sun,  6 Oct 2019 13:21:07 -0700
Message-Id: <20191006202107.24204-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the netdev is down, the queues and their debug stats
do not exist, so don't try using a pointer to them when
when printing the ethtool stats.

Fixes: e470355bd96a ("ionic: Add driver stats")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_stats.c | 29 ++++++++++++-------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index cf243a9d0168..a55fd1f8c31b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -184,6 +184,8 @@ struct ionic_lif {
 
 #define lif_to_txqcq(lif, i)	((lif)->txqcqs[i].qcq)
 #define lif_to_rxqcq(lif, i)	((lif)->rxqcqs[i].qcq)
+#define lif_to_txstats(lif, i)	((lif)->txqcqs[i].stats->tx)
+#define lif_to_rxstats(lif, i)	((lif)->rxqcqs[i].stats->rx)
 #define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 #define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index e2907884f843..03916b6d47f2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -117,7 +117,8 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	/* rx stats */
 	total += MAX_Q(lif) * IONIC_NUM_RX_STATS;
 
-	if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+	if (test_bit(IONIC_LIF_UP, lif->state) &&
+	    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
 		/* tx debug stats */
 		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
 				      IONIC_NUM_TX_Q_STATS +
@@ -149,7 +150,8 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 			*buf += ETH_GSTRING_LEN;
 		}
 
-		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_UP, lif->state) &&
+		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
 			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
 				snprintf(*buf, ETH_GSTRING_LEN,
 					 "txq_%d_%s",
@@ -187,7 +189,8 @@ static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 			*buf += ETH_GSTRING_LEN;
 		}
 
-		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_UP, lif->state) &&
+		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
 			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
 				snprintf(*buf, ETH_GSTRING_LEN,
 					 "rxq_%d_cq_%s",
@@ -223,6 +226,8 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 {
 	struct ionic_lif_sw_stats lif_stats;
 	struct ionic_qcq *txqcq, *rxqcq;
+	struct ionic_tx_stats *txstats;
+	struct ionic_rx_stats *rxstats;
 	int i, q_num;
 
 	ionic_get_lif_stats(lif, &lif_stats);
@@ -233,15 +238,17 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 	}
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		txqcq = lif_to_txqcq(lif, q_num);
+		txstats = &lif_to_txstats(lif, q_num);
 
 		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
-			**buf = IONIC_READ_STAT64(&txqcq->stats->tx,
+			**buf = IONIC_READ_STAT64(txstats,
 						  &ionic_tx_stats_desc[i]);
 			(*buf)++;
 		}
 
-		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_UP, lif->state) &&
+		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			txqcq = lif_to_txqcq(lif, q_num);
 			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&txqcq->q,
 						      &ionic_txq_stats_desc[i]);
@@ -258,22 +265,24 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 				(*buf)++;
 			}
 			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
-				**buf = txqcq->stats->tx.sg_cntr[i];
+				**buf = txstats->sg_cntr[i];
 				(*buf)++;
 			}
 		}
 	}
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		rxqcq = lif_to_rxqcq(lif, q_num);
+		rxstats = &lif_to_rxstats(lif, q_num);
 
 		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
-			**buf = IONIC_READ_STAT64(&rxqcq->stats->rx,
+			**buf = IONIC_READ_STAT64(rxstats,
 						  &ionic_rx_stats_desc[i]);
 			(*buf)++;
 		}
 
-		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		if (test_bit(IONIC_LIF_UP, lif->state) &&
+		    test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			rxqcq = lif_to_rxqcq(lif, q_num);
 			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&rxqcq->cq,
 						   &ionic_dbg_cq_stats_desc[i]);
-- 
2.17.1

