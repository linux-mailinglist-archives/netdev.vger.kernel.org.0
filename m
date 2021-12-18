Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A32479E65
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhLRXy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:59 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25464 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbhLRXyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=GqFSvl17lDTvbBkqniXjLg21Lj+A9xy5Bmx0Sh9Xsc0=;
        b=hoUAcEMO4F7cwMOYwc8Q3bWflwUOAgK1HQvQo4sozgyHqYfsFSf1Su/+oVvGFr6IznZX
        lasxxr3rv82mBcs/4i7y7BJf2+sePPqpOqk5GiaPW5hJ5cJysj/Bm1a1NbFBrIv3Kv0Jte
        gvsVivpjZU/IgE5NZFsWM31G4XLf06DTV+dhYHXW+dcz8QrM4DTBtOCDBM0xwLfcMILwMG
        2ESSlPWlCy8Et8zP55jWzCtyk0MeJHP8bh2Ee3KNqwWcQJkPmf5TNYrEF1JQY/evxkGwJX
        Yv22mYvlfIuIa9QSnhBqX6kB5CD/P5SblMzAZWte/tb4yH9u2FKtGdCEMsbMp6eg==
Received: by filterdrecv-75ff7b5ffb-z69hd with SMTP id filterdrecv-75ff7b5ffb-z69hd-1-61BE74A8-28
        2021-12-18 23:54:16.715682125 +0000 UTC m=+9336865.920225564
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-1 (SG)
        with ESMTP
        id Vu7kSu5CSAKaB3hoZI8cpw
        Sat, 18 Dec 2021 23:54:16.584 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 902BF7008F3; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 05/23] wilc1000: add wilc_wlan_tx_packet_done() function
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-6-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOwSrDGIbdKBFbkIA?=
 =?us-ascii?Q?Y3ejM6MX+RbkuA1BWsYq1JOMGFKUXzgeTseLK1B?=
 =?us-ascii?Q?3B5De35HnXyaaO9rTwg8vXLIjTX83bkR5saaieB?=
 =?us-ascii?Q?JQoxXjWDHTR+Sw4=2FxaNgZG4SYtp1XjVPphXm9f7?=
 =?us-ascii?Q?N0n6mjggGLC5K8T3jrmoffMw4mV0n=2FwyOWz75s?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor common tx packet-done handling code into a function.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 1c487342c1a88..caaa03c8e5df8 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -190,6 +190,16 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 }
 
+static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
+{
+	tqe->status = status;
+	if (tqe->tx_complete_func)
+		tqe->tx_complete_func(tqe->priv, tqe->status);
+	if (tqe->ack_idx != NOT_TCP_ACK && tqe->ack_idx < MAX_PENDING_ACKS)
+		tqe->vif->ack_filter.pending_acks[tqe->ack_idx].txqe = NULL;
+	kfree(tqe);
+}
+
 static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
@@ -220,11 +230,7 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			tqe = f->pending_acks[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
-				tqe->status = 1;
-				if (tqe->tx_complete_func)
-					tqe->tx_complete_func(tqe->priv,
-							      tqe->status);
-				kfree(tqe);
+				wilc_wlan_tx_packet_done(tqe, 1);
 			}
 		}
 	}
@@ -911,13 +917,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		       tqe->buffer, tqe->buffer_size);
 		offset += vmm_sz;
 		i++;
-		tqe->status = 1;
-		if (tqe->tx_complete_func)
-			tqe->tx_complete_func(tqe->priv, tqe->status);
-		if (tqe->ack_idx != NOT_TCP_ACK &&
-		    tqe->ack_idx < MAX_PENDING_ACKS)
-			vif->ack_filter.pending_acks[tqe->ack_idx].txqe = NULL;
-		kfree(tqe);
+		wilc_wlan_tx_packet_done(tqe, 1);
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
 		wilc->fw[i].count += ac_pkt_num_to_chip[i];
@@ -1236,11 +1236,8 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	wilc->quit = 1;
 	for (ac = 0; ac < NQUEUES; ac++) {
-		while ((tqe = wilc_wlan_txq_remove_from_head(wilc, ac))) {
-			if (tqe->tx_complete_func)
-				tqe->tx_complete_func(tqe->priv, 0);
-			kfree(tqe);
-		}
+		while ((tqe = wilc_wlan_txq_remove_from_head(wilc, ac)))
+			wilc_wlan_tx_packet_done(tqe, 0);
 	}
 
 	while ((rqe = wilc_wlan_rxq_remove(wilc)))
-- 
2.25.1

