Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883C947DD10
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346624AbhLWBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:44 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27494 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346274AbhLWBOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=Hgcvux2x80iJNHTT8Ywl3SP3JaAxVpVY4jdADVtyp24=;
        b=Zxb6E2yywaTqNbgdk7xF0Hb7M6bZBGfSj3ue71HXm4EUzTfmYCieKc5YrGHzJivzvITU
        2jjwWex4r8C0OEf36dCqam1wf463/NKRRF9WVkndExYOdxJqUngipCu0twbUaT3ISfBFf7
        q1+FWbqsZOvxOo1IhHi5uehOOd2NY8lx6/jz6LDTB49CrLLlO3omRSuO+wX48ggI28hcf3
        X4DQKtvgpP9Q+hJSvn5nuRSy5seVlrXDm8n/C6Rv3V0RK1sBARuARnz8WjnSHbjY8VWMwQ
        1fbdWTSv3g9oDNr/YFMFuS11NrbVdTR8CU868BHcJCva9Jlkj50HxtaYkYIzAaPA==
Received: by filterdrecv-7bf5c69d5-n84ln with SMTP id filterdrecv-7bf5c69d5-n84ln-1-61C3CD5E-B
        2021-12-23 01:14:06.168607769 +0000 UTC m=+9687225.761254579
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id SbsXXKDTRbKHV6cqEM3tPw
        Thu, 23 Dec 2021 01:14:06.029 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id E32C1700BFC; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 05/50] wilc1000: add wilc_wlan_tx_packet_done() function
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-6-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCKFafSZUZYOu1P05?=
 =?us-ascii?Q?CEj+Zsb9CK5JKRSqsrljNdImB023LgVhJEGXKH0?=
 =?us-ascii?Q?RMK5+rzygP7Kr=2FZNSpO4YzuYBgPGjO4cim0QebA?=
 =?us-ascii?Q?=2FKG457fIuiHgZeYQFBHS=2FLqaiM=2FyzqqM+5D0geb?=
 =?us-ascii?Q?y0aM7cvJkw5hanYnwm54TPXJNiNS=2F2zu3J1Zx5?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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
index 97624f758cbe4..7b7ee6ee9f849 100644
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

