Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD347DCC1
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbhLWBOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:07 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:17736 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhLWBOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=SmrKBnVEuSa1Juw5SAAEJzj60ijmoTkRxcpcsF5nTSA=;
        b=YzSVNjRk+pvvM/BP2KyqNRbFcAtzJzqrV6h52ohmxR9Ww55s/6LALy6sVHvjEUv4TYMD
        fQ4LVwp3Ly2gngrVfmzWb+ZGvO4MCjEzzPo9HB2XHuQocnkPkqtu88vpwBo6iImkLrFttH
        OhTrn4ii0s2x1DSGx5pRCs2qRwMvNGeZ/ODXAuRw8sdB8GxHJzUft8kDY5V0IJwp8jz8a0
        hiMNwVZplJdRMiq0TMyz9k4i7tAHzrNatBuuO2HlRCQmOkNBlHygcafhBxxIdZ8deNw/Nk
        towjwgWcVKCKpvwD0X8DIpWpEaR03lizF0ufxN49H9g7NE8iVQ1IpCYQbL1ks2+Q==
Received: by filterdrecv-64fcb979b9-tjknx with SMTP id filterdrecv-64fcb979b9-tjknx-1-61C3CD5D-25
        2021-12-23 01:14:05.75681832 +0000 UTC m=+8644588.560336792
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id s_DzTIWtT-iUGkJKJ4u1tg
        Thu, 23 Dec 2021 01:14:05.581 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D188C70054A; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 01/50] wilc1000: don't hold txq_spinlock while initializing
 AC queue limits
Date:   Thu, 23 Dec 2021 01:14:05 +0000 (UTC)
Message-Id: <20211223011358.4031459-2-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFFgikHEO6TrfMipf?=
 =?us-ascii?Q?R5df56socHUWL2usMYlQYxi9mNZe3jUS8vaJZg3?=
 =?us-ascii?Q?E+EW8ovRMMV2T=2Fwpc1krcS5fB6jrNH9nEaaDhVh?=
 =?us-ascii?Q?xjJ4BwhLuj59Oh3+xZf=2FmI+fxQDsVRsf5K4mcJk?=
 =?us-ascii?Q?PrSNKkVgXcqa2CCre8427Gzc1wQAiWfSu+en8E?=
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

The wilc_tx_queue_status queue is relatively large and there is
absolutely no need to initialize it while holding a spinlock.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/netdev.h  |  1 -
 .../net/wireless/microchip/wilc1000/wlan.c    | 32 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index a067274c20144..f4fc2cc392bd0 100644
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
index fb5633a05fd51..c4da14147dd04 100644
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
@@ -1484,6 +1488,8 @@ int wilc_wlan_init(struct net_device *dev)
 		goto fail;
 	}
 
+	init_q_limits(wilc);
+
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
 
-- 
2.25.1

