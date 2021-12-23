Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B5747DD1B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346415AbhLWBP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:58 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27410 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346256AbhLWBOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=ZdHnC/ICI6OpSU7qfH1VoVrAfvudFBK6XDLPwhLw7Ms=;
        b=HGyIzW+DINtndUkhBAmxAdHPUVDc57ZO/oYi2UkXxu85I8JQtt34MYLD0NMZHPIVckkZ
        V7mYn94sr8w/cP+YtXDXPNcVzMrkgLaAaDqYFR+fqyYNPZNjxxNtJUNIDDNxoackTk7K8t
        dc1Ly+m7uL9IYpvHvk6R8i8ySCXwslfqWUzV/ElsloVn07YhUc0gGgfvGh217fnlYAJNDn
        K/8wyk8Aj5O7JBfM6/W7T7Nnjq9TOIG3pmSZlNKwLdNj0a8qvOs3MXc/HxFsjHy/wY2QZt
        qDAMgE9BMfAxJFyLMJXVbVQewcjVqharPb5gPCbHExXbcv4Wj/HXu7KhtFY81KOQ==
Received: by filterdrecv-7bf5c69d5-plqrp with SMTP id filterdrecv-7bf5c69d5-plqrp-1-61C3CD5E-4E
        2021-12-23 01:14:07.00162435 +0000 UTC m=+9687195.598538133
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-2-1 (SG)
        with ESMTP
        id _HdNEz2_QZ6cJ9OC_17EnQ
        Thu, 23 Dec 2021 01:14:06.873 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id BFD7D7014F5; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 39/50] wilc1000: eliminate txq_add_to_head_cs mutex
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-40-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvMTg55MYAqxjZd=2FNY?=
 =?us-ascii?Q?MBupDVuLv7j=2F03Wcbcz16=2FVnnLJEBfaOIbI=2FU3u?=
 =?us-ascii?Q?bx1XABWR3g1bZkHu+ef6gWQG5mjxORS5pREM85N?=
 =?us-ascii?Q?pPLoyka3mgve=2FOVkDkeHPlot=2FZvlwFETL+NemFQ?=
 =?us-ascii?Q?QNDSArofbUY1ADKfpa9m4MM7jbQ5NFioC5Z4BG?=
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

Since the tx queue handler is no longer peeking at the transmit
queues, we don't need this mutex anymore.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  2 --
 drivers/net/wireless/microchip/wilc1000/netdev.h   |  3 ---
 drivers/net/wireless/microchip/wilc1000/wlan.c     | 13 +------------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 6d3635864569f..d87358ca71cf9 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1670,7 +1670,6 @@ static void wlan_init_locks(struct wilc *wl)
 	mutex_init(&wl->vif_mutex);
 	mutex_init(&wl->deinit_lock);
 
-	mutex_init(&wl->txq_add_to_head_cs);
 	mutex_init(&wl->tx_q_limit_lock);
 
 	init_waitqueue_head(&wl->txq_event);
@@ -1685,7 +1684,6 @@ void wlan_deinit_locks(struct wilc *wilc)
 	mutex_destroy(&wilc->hif_cs);
 	mutex_destroy(&wilc->rxq_cs);
 	mutex_destroy(&wilc->cfg_cmd_lock);
-	mutex_destroy(&wilc->txq_add_to_head_cs);
 	mutex_destroy(&wilc->vif_mutex);
 	mutex_destroy(&wilc->deinit_lock);
 	mutex_destroy(&wilc->tx_q_limit_lock);
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index e168f8644c678..086b9273bb117 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -225,9 +225,6 @@ struct wilc {
 	struct srcu_struct srcu;
 	u8 open_ifcs;
 
-	/* protect head of transmit queue */
-	struct mutex txq_add_to_head_cs;
-
 	/* protect rxq_entry_t receiver queue */
 	struct mutex rxq_cs;
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index eefc0d18c1b5c..67f5293370d35 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -70,12 +70,9 @@ static void wilc_wlan_txq_add_to_head(struct wilc_vif *vif, u8 type, u8 q_num,
 
 	init_txq_entry(tqe, type, q_num);
 
-	mutex_lock(&wilc->txq_add_to_head_cs);
-
 	skb_queue_head(&wilc->txq[q_num], tqe);
 	atomic_inc(&wilc->txq_entries);
 
-	mutex_unlock(&wilc->txq_add_to_head_cs);
 	wake_up_interruptible(&wilc->txq_event);
 }
 
@@ -848,9 +845,6 @@ static int send_vmm_table(struct wilc *wilc,
  *
  * Copy a number of packets to the transmit buffer.
  *
- * Context: The txq_add_to_head_cs mutex must still be held when
- * calling this function.
- *
  * Return: Number of bytes copied to the transmit buffer (always
  *	non-negative).
  */
@@ -940,8 +934,6 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (wilc->quit)
 		goto out_update_cnt;
 
-	mutex_lock(&wilc->txq_add_to_head_cs);
-
 	srcu_idx = srcu_read_lock(&wilc->srcu);
 	list_for_each_entry_rcu(vif, &wilc->vif_list, list)
 		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
@@ -949,7 +941,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 
 	vmm_table_len = fill_vmm_table(wilc, vmm_table);
 	if (vmm_table_len == 0)
-		goto out_unlock;
+		goto out_update_cnt;
 
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
@@ -967,9 +959,6 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (ret >= 0 && entries < vmm_table_len)
 		ret = WILC_VMM_ENTRY_FULL_RETRY;
 
-out_unlock:
-	mutex_unlock(&wilc->txq_add_to_head_cs);
-
 out_update_cnt:
 	*txq_count = atomic_read(&wilc->txq_entries);
 	return ret;
-- 
2.25.1

