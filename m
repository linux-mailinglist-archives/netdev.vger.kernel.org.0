Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B469B479E76
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhLRXz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:55:27 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25568 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhLRXyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=SCd/tobGA8mYNvYTBXsoUFl/FSU5vvWP7ZqX5PwsUss=;
        b=YhT7y5CVb83Y2Du5r095HrgYErIWOUWcdEcvLZOOSfmUS84PuK0SwlhItB2Ap9qpRODm
        IM+PmqexYg1z5zAkPJuKx+uAdR8jxKREYFSIu7vJo2ITgxsfe6r3K5d/tA/fmUfY5lgpsd
        59p+a4Yl1fNiPEQwhjBimqLFRUfU3JYKoZ9gkp2Xv/kqiS0GXbOXfmNJa4fIsHEb5RGJye
        hAHgu2yNcs55DIvklwwwbTeAqjm86NociIcH2p5VfjcMQRrvMfY1YIRlD8rW6E1N6+4iC6
        m4khNvNQk/4ARDfeyY2OjOu9rMBtLsXjgT/6Y1Qzm7A0Jh0JA+biujmhGU1l+gOw==
Received: by filterdrecv-656998cfdd-ngmx2 with SMTP id filterdrecv-656998cfdd-ngmx2-1-61BE74A8-1F
        2021-12-18 23:54:16.941728902 +0000 UTC m=+7604817.237963524
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id tYUYtDuLSPmIBYrCuLuwHQ
        Sat, 18 Dec 2021 23:54:16.765 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id A1F297010BD; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 11/23] wilc1000: convert tqx_entries from "int" to "atomic_t"
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-12-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvIrCLYJZzghAKaQ1Q?=
 =?us-ascii?Q?2=2FAozQL5y8K=2FDU2wm3OsO49UXpEaoCHuK4aKIib?=
 =?us-ascii?Q?U=2FpTfUlJUYYwdUWpYfuIIt8IPyhhJkTIBWzVv7V?=
 =?us-ascii?Q?HN1a14MxIkLASH5hKYbBKMCDx8UVE7KdQ6BaNSc?=
 =?us-ascii?Q?0z42LoPJBW2jhYoR7Cycp223P0RE1yP60TKl88?=
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

This is in preparation of converting the tx queue to struct sk_buffs
entries.  atomic_t isn't necessary for the current code, but it is a
safe change.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/netdev.c |  3 ++-
 drivers/net/wireless/microchip/wilc1000/netdev.h |  2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c   | 12 ++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 4dd7c8137c204..3b9f5d3e65998 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -149,7 +149,8 @@ static int wilc_txq_task(void *vp)
 	complete(&wl->txq_thread_started);
 	while (1) {
 		wait_event_interruptible(wl->txq_event,
-					 (wl->txq_entries > 0 || wl->close));
+					 (atomic_read(&wl->txq_entries) > 0 ||
+					  wl->close));
 
 		if (wl->close) {
 			complete(&wl->txq_thread_started);
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index ce79bdcc28000..d51095ac54730 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -253,7 +253,7 @@ struct wilc {
 	u8 *tx_buffer;
 
 	struct txq_handle txq[NQUEUES];
-	int txq_entries;
+	atomic_t txq_entries;
 	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
 	struct wilc_tx_queue_status tx_q_limit;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index dd669f9ea88a8..8435e1abdd515 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -41,7 +41,7 @@ static void wilc_wlan_txq_remove(struct wilc *wilc, u8 q_num,
 				 struct txq_entry_t *tqe)
 {
 	list_del(&tqe->list);
-	wilc->txq_entries -= 1;
+	atomic_dec(&wilc->txq_entries);
 	wilc->txq[q_num].count--;
 }
 
@@ -57,7 +57,7 @@ wilc_wlan_txq_remove_from_head(struct wilc *wilc, u8 q_num)
 		tqe = list_first_entry(&wilc->txq[q_num].txq_head.list,
 				       struct txq_entry_t, list);
 		list_del(&tqe->list);
-		wilc->txq_entries -= 1;
+		atomic_dec(&wilc->txq_entries);
 		wilc->txq[q_num].count--;
 	}
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -87,7 +87,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	list_add_tail(&tqe->list, &wilc->txq[q_num].txq_head.list);
-	wilc->txq_entries += 1;
+	atomic_inc(&wilc->txq_entries);
 	wilc->txq[q_num].count++;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -108,7 +108,7 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 type, u8 q_num,
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	list_add(&tqe->list, &wilc->txq[q_num].txq_head.list);
-	wilc->txq_entries += 1;
+	atomic_inc(&wilc->txq_entries);
 	wilc->txq[q_num].count++;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -484,7 +484,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
 		kfree(tqe);
 	}
 
-	return wilc->txq_entries;
+	return atomic_read(&wilc->txq_entries);
 }
 
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
@@ -952,7 +952,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 
 out_update_cnt:
-	*txq_count = wilc->txq_entries;
+	*txq_count = atomic_read(&wilc->txq_entries);
 	return ret;
 }
 
-- 
2.25.1

