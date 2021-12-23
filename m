Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD947DCCB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345899AbhLWBOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:14 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18110 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbhLWBOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=pzoQ8/2NNAK4ATykxYPnsdStYUF1CXuhMggSoBJHvS0=;
        b=kggOZLvyCFjQAqRfjyC9khGmtSKnSeXjxfIsv+w51tombRHzqOpGaFpK9w2ov+HqwPoR
        9BPqJvOQSOQjv6YEi/EhxXzCxYDpt/qJ08xCeIiisJtCZgJ+D+I3ANQGtn4lH83h39khPg
        SGSDy6n4CfttLWBPA05HuQG9KoQWistIbE9Gx5W5I+r3w0Ra0TC8tZr8WQ2Ug5riEi4RjY
        aH+xXV08CVVdhALm9hiHTHNpYo+bDqrdqloVrwKKk+0fkhslOiKRgeHaSsbtNAu0o91u7g
        ImUfgZQq3gmreCmdkE8oDCqHpspEl27cqk4Atw0MNZxzfCoJKoD9sIPNY6zZDbzw==
Received: by filterdrecv-75ff7b5ffb-6sw96 with SMTP id filterdrecv-75ff7b5ffb-6sw96-1-61C3CD5E-7
        2021-12-23 01:14:06.163181464 +0000 UTC m=+9687258.234840275
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-0 (SG)
        with ESMTP
        id mXqZGDqcQA29k1_iIsj-2g
        Thu, 23 Dec 2021 01:14:06.024 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 088427010AC; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 11/50] wilc1000: convert tqx_entries from "int" to
 "atomic_t"
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-12-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvMpnkY6SXEETBOQOb?=
 =?us-ascii?Q?cjnMOudSn0Sbh67pCS5DMiOw3ECgFuH=2FG=2FUpuN+?=
 =?us-ascii?Q?chI5OwysiIgY+5fa81Ji5w2rnvCHgzJtSlFLPwf?=
 =?us-ascii?Q?DlbUxdyGOlnnPGZ42ciW1NHAvYDfw7poa=2FGCgAj?=
 =?us-ascii?Q?vafACxNnr0I8nT5oz6RwFzX31SvD50ntfylhtm?=
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
index d5969f2e369c4..486091a4cb993 100644
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
index d88fee8f9a6b0..60f4871a7d579 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -255,7 +255,7 @@ struct wilc {
 	u8 *tx_buffer;
 
 	struct txq_handle txq[NQUEUES];
-	int txq_entries;
+	atomic_t txq_entries;
 	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
 	struct wilc_tx_queue_status tx_q_limit;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 781c40f2c930c..26b7d219ecbbb 100644
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

