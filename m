Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C747DD4B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346950AbhLWBQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:51 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18150 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345690AbhLWBOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=RrC6yl4xH6yjl3QxLWQ7ovhkZ1xBTAY6/gvQ4887ii8=;
        b=lCw62VJ1nIh5yKKDj+tjObc0DQ0ZSv6WcUyofX/1byILozJ8h7to26jWmhcnCtzxHlLJ
        bH45ZcIk7s2IET4bqlz760PYwUBMjXcHhE4JpkLp7chnwPWKZ2byUaavmZHS6jTaK2+4qN
        qhghAXn9QDkv6LHyawWdfObgmKPeLVPQuuirXJbYzSspe+zicQQsG6to7vpGZiUGhSvfzl
        oZARFFcgQHYw7vLh9ieNTCHImbirj9PZUnFcIjhBw06WRwoyzBm5rU/xHPr0Nahdb3Onbm
        LBEwXtgDA6rkyBUOL8aP3Qx1S4MtrrqX1hppa4Lq6G6wYvoHBfZVDnKhkWu9MGyw==
Received: by filterdrecv-75ff7b5ffb-ndqvq with SMTP id filterdrecv-75ff7b5ffb-ndqvq-1-61C3CD5E-13
        2021-12-23 01:14:06.305257498 +0000 UTC m=+9687224.905653124
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-0 (SG)
        with ESMTP
        id ZcYzltZZSCi_lFJvTySvaw
        Thu, 23 Dec 2021 01:14:06.174 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 00E3E70101D; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 10/50] wilc1000: factor initialization of tx queue-specific
 packet fields
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-11-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCJLlBTC4xumxACeW?=
 =?us-ascii?Q?N+4uQ8hRebKr63nOnFFNqzj5hYSEwCbOzbV+zUL?=
 =?us-ascii?Q?cwe6Kk0CVpAqADDFfmHNMM=2FvUvf=2FWXSEPT41g=2Fa?=
 =?us-ascii?Q?A5LTC9cN6tsmWdfglOPUvd394hV93proHHRp+fa?=
 =?us-ascii?Q?05Cq6p1OZPhair2wN7eX7Tk7l2I1PSxv+VXNKB?=
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

This ensures that the fields are initialized consistently for all
packets on the tx queues.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 45 ++++++++++---------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 77dd91c23faad..781c40f2c930c 100644
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

