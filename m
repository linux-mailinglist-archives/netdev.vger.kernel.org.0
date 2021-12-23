Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6757547DCDE
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbhLWBO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:57 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18390 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345776AbhLWBOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=agTBrbbxmaBcZhOGntoYkSTH1oRQbQIq4v8g5Df83lg=;
        b=I2OSv7f6dUAIVuLK4ihQ3KNlGLeVSixiSC1ql98qZVBthRWB7JnPTtICS+BBenpgi0Ur
        pBWh4OmTFgslu/CmiIJmGzYNtP2jX4ccbaIyHkS8PhFu1eBeqq/YC0XAkZjV3XjUx+iHKW
        Om2N7QV4YcvT0XDqmWeAo5NGXQchWWQmAYuRNNCGQsy4ZLC5Stbp8Gio5S3kixoygLnl2W
        3gB5jFdQvmm0FShsB+bB10wSXFeiWVfo8q0XrXXBeE0D1mPBjXFt+f0f5yyQAsCF81/D4Q
        Xeyzx/sSQO4VztoksmNoSe9LpJsnTDWCNRjJkUwk99E+2WdRpprCLHXKhv/lxNdQ==
Received: by filterdrecv-656998cfdd-phncc with SMTP id filterdrecv-656998cfdd-phncc-1-61C3CD5E-38
        2021-12-23 01:14:06.64426236 +0000 UTC m=+7955207.830509139
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id 71zB2wfxQ3agYG4UQ8ZiVg
        Thu, 23 Dec 2021 01:14:06.494 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 649E9701463; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 25/50] wilc1000: replace txq_spinlock with ack_filter_lock
 mutex
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-26-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLFGvaKITknzkke94?=
 =?us-ascii?Q?9=2F7j63eSgfYeyP9v+L3+fNZ9QLqBEqZkdjJa3QD?=
 =?us-ascii?Q?7To2KHUS8OZft9cQsvjJ4hJp2PT8yyUlshXKMiC?=
 =?us-ascii?Q?wmoKDMdiG+xJSbYRrYCA4WbOoCkEHOLImsKCuT+?=
 =?us-ascii?Q?KaZfJd+zunscC3owDGVA4E2N6ZlWH8LgPlbMx8?=
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

The only purpose left for txq_spinlock is to protect the ack_filter.
The ack_filter is only updated by the tx queue writers and the tx
queue consumer, so interrupts don't have to be disabled and sleeping
is OK.  In other words, we can use a mutex instead of a spinlock.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  1 -
 drivers/net/wireless/microchip/wilc1000/netdev.c   |  2 ++
 drivers/net/wireless/microchip/wilc1000/netdev.h   |  5 ++---
 drivers/net/wireless/microchip/wilc1000/wlan.c     | 12 ++++--------
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 0fcc064254f1e..6f19dee813f2a 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1670,7 +1670,6 @@ static void wlan_init_locks(struct wilc *wl)
 	mutex_init(&wl->vif_mutex);
 	mutex_init(&wl->deinit_lock);
 
-	spin_lock_init(&wl->txq_spinlock);
 	mutex_init(&wl->txq_add_to_head_cs);
 	mutex_init(&wl->tx_q_limit_lock);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 999933532c2de..71cb15f042cdd 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -863,6 +863,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 
 	srcu_idx = srcu_read_lock(&wilc->srcu);
 	list_for_each_entry_rcu(vif, &wilc->vif_list, list) {
+		mutex_destroy(&vif->ack_filter_lock);
 		if (vif->ndev)
 			unregister_netdev(vif->ndev);
 	}
@@ -929,6 +930,7 @@ struct wilc_vif *wilc_netdev_ifc_init(struct wilc *wl, const char *name,
 	vif->wilc = wl;
 	vif->ndev = ndev;
 	ndev->ml_priv = vif;
+	mutex_init(&vif->ack_filter_lock);
 
 	ndev->netdev_ops = &wilc_netdev_ops;
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index e247f92a409e0..82f38a0e20214 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -190,6 +190,8 @@ struct wilc_vif {
 	struct timer_list during_ip_timer;
 	struct timer_list periodic_rssi;
 	struct rf_info periodic_stat;
+	/* protect ack_filter */
+	struct mutex ack_filter_lock;
 	struct tcp_ack_filter ack_filter;
 	bool connecting;
 	struct wilc_priv priv;
@@ -226,9 +228,6 @@ struct wilc {
 	/* protect head of transmit queue */
 	struct mutex txq_add_to_head_cs;
 
-	/* protect txq_entry_t transmit queue */
-	spinlock_t txq_spinlock;
-
 	/* protect rxq_entry_t receiver queue */
 	struct mutex rxq_cs;
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 9b6605e9df296..81180b2f9f4e1 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -124,15 +124,13 @@ static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 	void *buffer = tqe->data;
 	const struct ethhdr *eth_hdr_ptr = buffer;
 	int i;
-	unsigned long flags;
 	struct wilc_vif *vif = netdev_priv(dev);
-	struct wilc *wilc = vif->wilc;
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	const struct iphdr *ip_hdr_ptr;
 	const struct tcphdr *tcp_hdr_ptr;
 	u32 ihl, total_length, data_offset;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
+	mutex_lock(&vif->ack_filter_lock);
 
 	if (eth_hdr_ptr->h_proto != htons(ETH_P_IP))
 		goto out;
@@ -168,7 +166,7 @@ static inline void tcp_process(struct net_device *dev, struct sk_buff *tqe)
 	}
 
 out:
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
+	mutex_unlock(&vif->ack_filter_lock);
 }
 
 static void wilc_wlan_tx_packet_done(struct sk_buff *tqe, int status)
@@ -201,12 +199,10 @@ static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *tqe)
 static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	struct wilc_vif *vif = netdev_priv(dev);
-	struct wilc *wilc = vif->wilc;
 	struct tcp_ack_filter *f = &vif->ack_filter;
 	u32 i = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
+	mutex_lock(&vif->ack_filter_lock);
 	for (i = f->pending_base;
 	     i < (f->pending_base + f->pending_acks_idx); i++) {
 		u32 index;
@@ -238,7 +234,7 @@ static void wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	else
 		f->pending_base = 0;
 
-	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
+	mutex_unlock(&vif->ack_filter_lock);
 }
 
 void wilc_enable_tcp_ack_filter(struct wilc_vif *vif, bool value)
-- 
2.25.1

