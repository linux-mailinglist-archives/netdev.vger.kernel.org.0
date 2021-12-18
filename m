Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC55479E52
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhLRXyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:24 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25288 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhLRXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=lEJOszgCw0TFSxZvSVioKcU+0PoQE8Pc6r25UeeIg7A=;
        b=S/B1mMakfozT+C0PYycwp9fQiE8/uAqHELHPIMeGMZV+snaVjZ0NTDJn3pPnWMziw3/5
        m88sAqBYj6v9D2ZARJ+P7RJLv927q8ESqxGi+OIEWB02+RtC/Q/S+Fxn2kWsxzGMPsHYRB
        00JYKb1A2bdrUKTnWOA28QN4AWMwYxDpUsntvqKycFliOOb/adXCwXH2NT+aHfx3NtN1S9
        3zZoM7dYZMjI/+RXJNqZVLU+YQmUJo7ID7cH3OZ3Z6jdVPQyat87OHrfsKflWbZC+IZVKK
        E9qDzoHYRJ1JYunc2W3zwsuQaoLxBcje+Z04v8lgZ/RWxQyTrRvuy9LHg3bkLiVQ==
Received: by filterdrecv-7bf5c69d5-fb76v with SMTP id filterdrecv-7bf5c69d5-fb76v-1-61BE74A8-A
        2021-12-18 23:54:16.307699886 +0000 UTC m=+1581798.970762200
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id BtctVw9tSLegk_x0es2y0w
        Sat, 18 Dec 2021 23:54:16.141 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 8704D7005B6; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 02/23] wilc1000: switch txq_event from completion to waitqueue
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvF2Lvk30d1zpJ0jP8?=
 =?us-ascii?Q?DPK7uiSg+PB55J4rl=2FXo2H8=2F0KuHpLlqO9wlby2?=
 =?us-ascii?Q?SgTh3Y8nZTUBZLKX+W8sCnEKQLRwfT+BtjDSedS?=
 =?us-ascii?Q?4s8HueRVrR+GKwMY3KhDcxdBb0yBaej8jdX0+YA?=
 =?us-ascii?Q?JIjAxGZpsYGPOrTBRtT0aXiwGG=2FYadGMtSloXb?=
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

Completion structs are essentially counting semaphores: every
complete() call wakes up exactly one thread, either immediately (when
there are waiters queued) or in the future (when a waiter arrives).
This isn't really the appropriate synchronization structure for the
wilc1000 transmit queue handler (wilc_wlan_handle_txq) because it will
consume zero, one, or more packets on each call.  Instead, use a
waitqueue as a condition variable: wake_up_interruptible() wakes up
the tx queue handler from a call to wait_event_interruptible()
whenever something interesting happens and it then takes the
appropriate action.  This has a couple of benefits:

 - Since the transmit queue handler often transfers multiple packets
   to the chip on each call, repeated calls to wait_for_completion()
   when there is no actual work to do are avoided.

 - When the transmit queue handler cannot transfer any packets at all,
   it'll simply give up the current time slice and then tries again.
   Previously, the transmit would stall until a new packet showed up
   (which potentially could cause extended stalls).  It would be even
   better to wait for a "tx queue not full" interrupt but, sadly, I'm
   told the wilc1000 firmware doesn't provide that.

 - There is no longer any need for wilc_wlan_txq_filter_dup_tcp_ack()
   to adjust the completion structs wait count by calling
   wait_for_completion_timeout() for each dropped packet.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   | 13 +++++++++----
 drivers/net/wireless/microchip/wilc1000/netdev.h   |  2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     | 12 ++----------
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 8d8378bafd9b0..be387a8abb6af 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1692,7 +1692,7 @@ static void wlan_init_locks(struct wilc *wl)
 	spin_lock_init(&wl->txq_spinlock);
 	mutex_init(&wl->txq_add_to_head_cs);
 
-	init_completion(&wl->txq_event);
+	init_waitqueue_head(&wl->txq_event);
 	init_completion(&wl->cfg_event);
 	init_completion(&wl->sync_event);
 	init_completion(&wl->txq_thread_started);
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 03e3485d7e7fa..4dd7c8137c204 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -144,10 +144,12 @@ static int wilc_txq_task(void *vp)
 	int ret;
 	u32 txq_count;
 	struct wilc *wl = vp;
+	long timeout;
 
 	complete(&wl->txq_thread_started);
 	while (1) {
-		wait_for_completion(&wl->txq_event);
+		wait_event_interruptible(wl->txq_event,
+					 (wl->txq_entries > 0 || wl->close));
 
 		if (wl->close) {
 			complete(&wl->txq_thread_started);
@@ -170,6 +172,11 @@ static int wilc_txq_task(void *vp)
 				}
 				srcu_read_unlock(&wl->srcu, srcu_idx);
 			}
+			if (ret == WILC_VMM_ENTRY_FULL_RETRY) {
+				timeout = msecs_to_jiffies(1);
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(timeout);
+			}
 		} while (ret == WILC_VMM_ENTRY_FULL_RETRY && !wl->close);
 	}
 	return 0;
@@ -419,12 +426,11 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 
 	wl->close = 1;
 
-	complete(&wl->txq_event);
-
 	if (wl->txq_thread) {
 		kthread_stop(wl->txq_thread);
 		wl->txq_thread = NULL;
 	}
+	wake_up_interruptible(&wl->txq_event);
 }
 
 static void wilc_wlan_deinitialize(struct net_device *dev)
@@ -446,7 +452,6 @@ static void wilc_wlan_deinitialize(struct net_device *dev)
 			wl->hif_func->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
-		complete(&wl->txq_event);
 
 		wlan_deinitialize_threads(dev);
 		deinit_irq(dev);
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index fd0cb01e538a2..65cf296a8689e 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -235,7 +235,7 @@ struct wilc {
 
 	struct completion cfg_event;
 	struct completion sync_event;
-	struct completion txq_event;
+	wait_queue_head_t txq_event;
 	struct completion txq_thread_started;
 
 	struct task_struct *txq_thread;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 721e6131125e8..fafeabe2537a3 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -75,7 +75,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 q_num,
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-	complete(&wilc->txq_event);
+	wake_up_interruptible(&wilc->txq_event);
 }
 
 static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 q_num,
@@ -94,7 +94,7 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 q_num,
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	mutex_unlock(&wilc->txq_add_to_head_cs);
-	complete(&wilc->txq_event);
+	wake_up_interruptible(&wilc->txq_event);
 }
 
 #define NOT_TCP_ACK			(-1)
@@ -196,7 +196,6 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	struct wilc *wilc = vif->wilc;
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = 0;
-	u32 dropped = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
@@ -226,7 +225,6 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 					tqe->tx_complete_func(tqe->priv,
 							      tqe->status);
 				kfree(tqe);
-				dropped++;
 			}
 		}
 	}
@@ -239,12 +237,6 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 		f->pending_base = 0;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
-
-	while (dropped > 0) {
-		wait_for_completion_timeout(&wilc->txq_event,
-					    msecs_to_jiffies(1));
-		dropped--;
-	}
 }
 
 void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
-- 
2.25.1

