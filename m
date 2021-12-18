Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8CF479E3A
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhLRXyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:25 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25324 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbhLRXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=gY5sGuQPIVMDU44/2pC7gMhps+WU8nE0gGBCpIqOlgQ=;
        b=Ws9w0O5N+di9y39ZKUstO9eSg7fNXIaykYmg0CiUV4T+13FiJ7jKldoWOumuMetdS8t9
        mV/gIH2DuvmiBlDIyHrGswIR+GzI0Xd7uFUJiyck/o5gNqaPXGwitQCWH4R9R4EFxwqWJK
        No0GFevUCnPwPZv8oI17cDDLpSCHJogiTmBqbyztvNF84Xh0UhPMcxzSjZ8r3f50xgoLcx
        1A2jTvafUo1F9ZOBQqO0/gt0VTBRuF/cWQO7ewosdj1fqZcgFPFltJ6VC5PYpitxwCSbI3
        42qFFTwyhjO/Gcn50LOUdieqnjS8uTM39q74BB4gcmW3m/JeIH/EvcYERHi5fPYQ==
Received: by filterdrecv-75ff7b5ffb-bcbbj with SMTP id filterdrecv-75ff7b5ffb-bcbbj-1-61BE74A8-17
        2021-12-18 23:54:16.475387188 +0000 UTC m=+9336800.790258411
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-1 (SG)
        with ESMTP
        id CRHLIZYzR-6quDBgjG8pYQ
        Sat, 18 Dec 2021 23:54:16.302 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 8422570054A; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 01/23] wilc1000: don't hold txq_spinlock while initializing AC
 queue limits
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvD47APGjFyEg=2F9qMg?=
 =?us-ascii?Q?vPPi1SQklD09yHMagrC+uTlKXz5TBABfx8jUJaf?=
 =?us-ascii?Q?CMbaOMKdvK0PKVlW4v9n1tSZ6MgedAB0ftly=2Fez?=
 =?us-ascii?Q?3DhsghdQGrsdyXYdQfvTz5l6GeH3BBMNbaqVidy?=
 =?us-ascii?Q?h3iQoRw6SIgSJapJ3oOXHPgPNliibG4Qnwqb5r?=
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

The wilc_tx_queue_status queue is relatively large and there is
absolutely no need to initialize it while holding a spinlock.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/netdev.h  |  1 -
 .../net/wireless/microchip/wilc1000/wlan.c    | 32 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index b9a88b3e322f1..fd0cb01e538a2 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -202,7 +202,6 @@ struct wilc_tx_queue_status {
 	u16 end_index;
 	u16 cnt[NQUEUES];
 	u16 sum;
-	bool initialized;
 };
 
 struct wilc {
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 1aa4236a2fe41..721e6131125e8 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -12,6 +12,8 @@
 
 #define WAKE_UP_TRIAL_RETRY		10000
 
+static const u8 factors[NQUEUES] = {1, 1, 1, 1};
+
 static inline bool is_wilc1000(u32 id)
 {
 	return (id & (~WILC_CHIP_REV_FIELD)) == WILC_1000_BASE_ID;
@@ -283,10 +285,23 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	return 1;
 }
 
+static void init_q_limits(struct wilc *wl)
+{
+	struct wilc_tx_queue_status *q = &wl->tx_q_limit;
+	int i;
+
+	for (i = 0; i < AC_BUFFER_SIZE; i++)
+		q->buffer[i] = i % NQUEUES;
+
+	for (i = 0; i < NQUEUES; i++) {
+		q->cnt[i] = AC_BUFFER_SIZE * factors[i] / NQUEUES;
+		q->sum += q->cnt[i];
+	}
+	q->end_index = AC_BUFFER_SIZE - 1;
+}
+
 static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 {
-	u8 factors[NQUEUES] = {1, 1, 1, 1};
-	u16 i;
 	unsigned long flags;
 	struct wilc_tx_queue_status *q = &wl->tx_q_limit;
 	u8 end_index;
@@ -294,17 +309,6 @@ static bool is_ac_q_limit(struct wilc *wl, u8 q_num)
 	bool ret = false;
 
 	spin_lock_irqsave(&wl->txq_spinlock, flags);
-	if (!q->initialized) {
-		for (i = 0; i < AC_BUFFER_SIZE; i++)
-			q->buffer[i] = i % NQUEUES;
-
-		for (i = 0; i < NQUEUES; i++) {
-			q->cnt[i] = AC_BUFFER_SIZE * factors[i] / NQUEUES;
-			q->sum += q->cnt[i];
-		}
-		q->end_index = AC_BUFFER_SIZE - 1;
-		q->initialized = 1;
-	}
 
 	end_index = q->end_index;
 	q->cnt[q->buffer[end_index]] -= factors[q->buffer[end_index]];
@@ -1485,6 +1489,8 @@ int wilc_wlan_init(struct net_device *dev)
 		goto fail;
 	}
 
+	init_q_limits(wilc);
+
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
 
-- 
2.25.1

