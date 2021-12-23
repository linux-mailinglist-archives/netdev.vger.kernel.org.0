Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E35147DCE1
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbhLWBO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:59 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:17784 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238429AbhLWBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=emRedEXnN1E6Sca8nTmnylU6pLvfF71PWPx92q9deco=;
        b=Op0A18i9PVkUdlsJon3r7sJVA+uM9i5UwiX/lsv8rSrubQTNq6lINUOnGDqkl85vgR0D
        L5B4FLVb69DTzotAVTuPSBaSXA2ToMkCotY2KXRuYVdf50hDCCWwmHcZVOlxE9/70VY6BF
        oLCsPNU6rc8m3DNeiOjuFMpZPorEkIgStW+5gyUa2YNsflQ9+iEQNTmtyX5u2dHjUwWyc2
        lrRXafceBZ4x2Gfd0PifmBFMFxCHfdHAaFU6b7xOcTX0NmzcgMbma82/NmavOpxJP1QH/r
        E1XEbkgK39i7oQkOoUn35A7V4AiAqXq2A8A/Kw4hWTDsOlO/4l+OmvjS2jJK1VCQ==
Received: by filterdrecv-64fcb979b9-7lnp4 with SMTP id filterdrecv-64fcb979b9-7lnp4-1-61C3CD5D-36
        2021-12-23 01:14:05.795334457 +0000 UTC m=+8644592.725894849
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id P5TgjB1ZSFKLRRrKRnDvVg
        Thu, 23 Dec 2021 01:14:05.577 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D47DE700604; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 02/50] wilc1000: switch txq_event from completion to
 waitqueue
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKKbokcqBZrOnU5kE?=
 =?us-ascii?Q?pG8h+syelvS85jzqTtTcv7YHcinBYmG949gzYNe?=
 =?us-ascii?Q?S+CPI21kQiP7YmP1MedO60V8pEhFGODJZ+R=2FwvR?=
 =?us-ascii?Q?uJZ08I07kNkudAhDmK4cVyup1EzVOBU1=2FjPynf9?=
 =?us-ascii?Q?VcpfdEj02vUCPIK8YMsO9MxwOo8TORflaq8Kyc?=
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
index 643bddaae32ad..d5969f2e369c4 100644
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
index f4fc2cc392bd0..c07f58a86bc76 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -237,7 +237,7 @@ struct wilc {
 
 	struct completion cfg_event;
 	struct completion sync_event;
-	struct completion txq_event;
+	wait_queue_head_t txq_event;
 	struct completion txq_thread_started;
 
 	struct task_struct *txq_thread;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index c4da14147dd04..26fa7078acffd 100644
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

