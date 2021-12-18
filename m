Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06906479E40
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhLRXy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:26 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25540 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbhLRXyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=NYxaYzHm1pIpxmKQkLLEhojKZgPDBGN2Wz7Q273Yc1A=;
        b=HG0x7g6AYvBW7Kwh69dG78sBh0H6cqqwRR63mdBuojCcEwr7oMSkE9ma9RABy+ZzYXez
        UGUmEI00PI8tnksPs6KOX7fJOHSyUteSHQQhCGxcKL/N3gtUSoXao08lGfSaSmdN11S7YT
        8k/qNKBUKVERPNlbNV7nSYd0JXY91M5YInsgxVz/g/MRrX7ltX8mE4pdlByW2HiaKYe0Oe
        xOE2yBuODvcZ7ml/ii+hCjl+4/jONDuM3e5KTK4LDbiQD+OVfO+q7+o9euJRMQAR730Am2
        BbPQCI17a+KWSaSnzbeUuQATzwAiJwrgSPjbeYmM8Q0GyxnBqpAa3y7DF8JqmMzw==
Received: by filterdrecv-656998cfdd-ptr8m with SMTP id filterdrecv-656998cfdd-ptr8m-1-61BE74A8-19
        2021-12-18 23:54:16.906807421 +0000 UTC m=+7604818.766390139
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id 75uavCaHQAmRTtDVHItOng
        Sat, 18 Dec 2021 23:54:16.730 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 9FD617010AC; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 10/23] wilc1000: factor initialization of tx queue-specific
 packet fields
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-11-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOXjTHfbwtHLXBF2R?=
 =?us-ascii?Q?yVqEni302Z8u6SJC5T3FxD4jowv+cJ16LpDOrzQ?=
 =?us-ascii?Q?Ddqo0IpEgm6aZBeAWbpDKVt10kxoQSZT3SgI1PB?=
 =?us-ascii?Q?XvdyML0sSddYhb9ebR6Ic3k1qvnhXKICtvOr17C?=
 =?us-ascii?Q?xFWbQWmRmJFZcC7e5B0YrYXbVBUgPyy65K2+85?=
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

This ensures that the fields are initialized consistently for all
packets on the tx queues.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 45 ++++++++++---------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index eeb9961adfa34..dd669f9ea88a8 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -12,8 +12,12 @@
 
 #define WAKE_UP_TRIAL_RETRY		10000
 
+#define NOT_TCP_ACK			(-1)
+
 static const u8 factors[NQUEUES] = {1, 1, 1, 1};
 
+static void tcp_process(struct net_device *, struct txq_entry_t *);
+
 static inline bool is_wilc1000(u32 id)
 {
 	return (id & (~WILC_CHIP_REV_FIELD)) == WILC_1000_BASE_ID;
@@ -60,13 +64,26 @@ wilc_wlan_txq_remove_from_head(struct wilc *wilc, u8 q_num)
 	return tqe;
 }
 
-static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 q_num,
+static void init_txq_entry(struct txq_entry_t *tqe, struct wilc_vif *vif,
+			   u8 type, enum ip_pkt_priority q_num)
+{
+	tqe->vif = vif;
+	tqe->q_num = q_num;
+	tqe->type = type;
+	tqe->ack_idx = NOT_TCP_ACK;
+}
+
+static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 type, u8 q_num,
 				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc *wilc = vif->wilc;
 
+	init_txq_entry(tqe, vif, type, q_num);
+	if (type == WILC_NET_PKT && vif->ack_filter.enabled)
+		tcp_process(dev, tqe);
+
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	list_add_tail(&tqe->list, &wilc->txq[q_num].txq_head.list);
@@ -78,12 +95,14 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev, u8 q_num,
 	wake_up_interruptible(&wilc->txq_event);
 }
 
-static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 q_num,
+static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 type, u8 q_num,
 				      struct txq_entry_t *tqe)
 {
 	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
 
+	init_txq_entry(tqe, vif, type, q_num);
+
 	mutex_lock(&wilc->txq_add_to_head_cs);
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
@@ -97,8 +116,6 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 q_num,
 	wake_up_interruptible(&wilc->txq_event);
 }
 
-#define NOT_TCP_ACK			(-1)
-
 static inline void add_tcp_session(struct wilc_vif *vif, u32 src_prt,
 				   u32 dst_prt, u32 seq)
 {
@@ -281,16 +298,12 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 		return 0;
 	}
 
-	tqe->type = WILC_CFG_PKT;
 	tqe->buffer = buffer;
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
-	tqe->q_num = AC_VO_Q;
-	tqe->ack_idx = NOT_TCP_ACK;
-	tqe->vif = vif;
 
-	wilc_wlan_txq_add_to_head(vif, AC_VO_Q, tqe);
+	wilc_wlan_txq_add_to_head(vif, WILC_CFG_PKT, AC_VO_Q, tqe);
 
 	return 1;
 }
@@ -452,15 +465,12 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
 		tx_complete_fn(tx_data, 0);
 		return 0;
 	}
-	tqe->type = WILC_NET_PKT;
 	tqe->buffer = buffer;
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
 	tqe->priv = tx_data;
-	tqe->vif = vif;
 
 	q_num = ac_classify(wilc, tx_data->skb);
-	tqe->q_num = q_num;
 	if (ac_change(wilc, &q_num)) {
 		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
@@ -468,10 +478,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev,
 	}
 
 	if (is_ac_q_limit(wilc, q_num)) {
-		tqe->ack_idx = NOT_TCP_ACK;
-		if (vif->ack_filter.enabled)
-			tcp_process(dev, tqe);
-		wilc_wlan_txq_add_to_tail(dev, q_num, tqe);
+		wilc_wlan_txq_add_to_tail(dev, WILC_NET_PKT, q_num, tqe);
 	} else {
 		tx_complete_fn(tx_data, 0);
 		kfree(tqe);
@@ -505,15 +512,11 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 		tx_complete_fn(priv, 0);
 		return 0;
 	}
-	tqe->type = WILC_MGMT_PKT;
 	tqe->buffer = buffer;
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = tx_complete_fn;
 	tqe->priv = priv;
-	tqe->q_num = AC_VO_Q;
-	tqe->ack_idx = NOT_TCP_ACK;
-	tqe->vif = vif;
-	wilc_wlan_txq_add_to_tail(dev, AC_VO_Q, tqe);
+	wilc_wlan_txq_add_to_tail(dev, WILC_MGMT_PKT, AC_VO_Q, tqe);
 	return 1;
 }
 
-- 
2.25.1

