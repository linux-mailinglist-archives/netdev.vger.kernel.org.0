Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF747DD41
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbhLWBQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:44 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18414 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345794AbhLWBOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=N46QLJgAXe0NvBlcbTaWBwYjHo/Ap7DZmE5k7VZ+W3Q=;
        b=V64BEDRL3vBXJzMTbzc6Zw5w8bWHXW3QPOVeOZ1rCzoRRF5U/xrJZjkvJjjXUQ7GDUwZ
        e6kbIZjO2AEwZ8IjpQvQpfmRV5rm1PjiVRPfdK1CfW+0+lUzDd6+BopDXAirnUjQSDqAFG
        WKyqC7NfeyCabd0oKi1XRghEK2xDCQSlcYASMbOQ5mi26CwrNWIbF7bNEU5V8wVbYjWmuQ
        UoeXghe8Lg0Ilm7l7rm/Phy7C6iZLXpUGlKNNZskttfZU7y9p77HDE3ycVuHfidwB47hI3
        c2Of3FNGpUFcMSTvKB9VkpaIBW6NS/RPkV1m5+xCleUER4JiobS/wif3jg6cpLmA==
Received: by filterdrecv-64fcb979b9-st7n5 with SMTP id filterdrecv-64fcb979b9-st7n5-1-61C3CD5E-31
        2021-12-23 01:14:06.632823617 +0000 UTC m=+8644640.616410629
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-1 (SG)
        with ESMTP
        id __87Da3hTAGNaPsJHueHmQ
        Thu, 23 Dec 2021 01:14:06.464 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 5E49F701456; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 24/50] wilc1000: protect tx_q_limit with a mutex instead of
 a spinlock
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-25-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvGBcp4s2Az1AHv79A?=
 =?us-ascii?Q?BU3BFGyn+E9LPexzA58AtugPyGPRXwwtc3DKSoO?=
 =?us-ascii?Q?sBtpfgdGlcAixxwv=2FfgakudCQuG61w4B9KCKA6Y?=
 =?us-ascii?Q?DiD5VB4hJmWu3OOn5veqnR315LEIBdLdtcPR=2Fle?=
 =?us-ascii?Q?QwTci2Ufpc69OElfoYZxcY8Q8qyLLo3x9XEh0s?=
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

Access to tx_q_limit needs to be serialized among the possibly
multiple writers to the tx queue.  A mutex will do fine for that.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 2 ++
 drivers/net/wireless/microchip/wilc1000/netdev.h   | 2 ++
 drivers/net/wireless/microchip/wilc1000/wlan.c     | 5 ++---
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index d352b7dd03283..0fcc064254f1e 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1672,6 +1672,7 @@ static void wlan_init_locks(struct wilc *wl)
 
 	spin_lock_init(&wl->txq_spinlock);
 	mutex_init(&wl->txq_add_to_head_cs);
+	mutex_init(&wl->tx_q_limit_lock);
 
 	init_waitqueue_head(&wl->txq_event);
 	init_completion(&wl->cfg_event);
@@ -1688,6 +1689,7 @@ void wlan_deinit_locks(struct wilc *wilc)
 	mutex_destroy(&wilc->txq_add_to_head_cs);
 	mutex_destroy(&wilc->vif_mutex);
 	mutex_destroy(&wilc->deinit_lock);
+	mutex_destroy(&wilc->tx_q_limit_lock);
 	cleanup_srcu_struct(&wilc->srcu);
 }
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index 650b40961cf98..e247f92a409e0 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -257,6 +257,8 @@ struct wilc {
 	atomic_t txq_entries;
 	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
+	/* protect tx_q_limit state */
+	struct mutex tx_q_limit_lock;
 	struct wilc_tx_queue_status tx_q_limit;
 	struct rxq_entry_t rxq_head;
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index f82857cebe35e..9b6605e9df296 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -279,13 +279,12 @@ static void init_q_limits(struct wilc *wl)
 
 static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 {
-	unsigned long flags;
 	struct wilc_tx_queue_status *q = &wl->tx_q_limit;
 	u8 end_index;
 	u8 q_limit;
 	bool ret = false;
 
-	spin_lock_irqsave(&wl->txq_spinlock, flags);
+	mutex_lock(&wl->tx_q_limit_lock);
 
 	end_index = q->end_index;
 	q->cnt[q->buffer[end_index]] -= factors[q->buffer[end_index]];
@@ -306,7 +305,7 @@ static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 	if (skb_queue_len(&wl->txq[q_num]) <= q_limit)
 		ret = true;
 
-	spin_unlock_irqrestore(&wl->txq_spinlock, flags);
+	mutex_unlock(&wl->tx_q_limit_lock);
 
 	return ret;
 }
-- 
2.25.1

