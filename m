Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BACD130D9B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 07:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgAFGje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 01:39:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:42582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgAFGje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 01:39:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C832AADBE;
        Mon,  6 Jan 2020 06:39:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7A388E048A; Mon,  6 Jan 2020 07:39:31 +0100 (CET)
Message-Id: <27c09c8633c2c34a78ae528e5f4850bcd964acc7.1578292157.git.mkubecek@suse.cz>
In-Reply-To: <cover.1578292157.git.mkubecek@suse.cz>
References: <cover.1578292157.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 1/3] wil6210: get rid of begin() and complete()
 ethtool_ops
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Mon,  6 Jan 2020 07:39:31 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wil6210 driver locks a mutex in begin() ethtool_ops callback and
unlocks it in complete() so that all ethtool requests are serialized. This
is not going to work correctly with netlink interface; e.g. when ioctl
triggers a netlink notification, netlink code would call begin() again
while the mutex taken by ioctl code is still held by the same task.

Let's get rid of the begin() and complete() callbacks and move the mutex
locking into the remaining ethtool_ops handlers except get_drvinfo which
only copies strings that are not changing so that there is no need for
serialization.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/wireless/ath/wil6210/ethtool.c | 43 ++++++++--------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/ethtool.c b/drivers/net/wireless/ath/wil6210/ethtool.c
index 912c4eaf017b..fef10886ca4a 100644
--- a/drivers/net/wireless/ath/wil6210/ethtool.c
+++ b/drivers/net/wireless/ath/wil6210/ethtool.c
@@ -11,26 +11,6 @@
 
 #include "wil6210.h"
 
-static int wil_ethtoolops_begin(struct net_device *ndev)
-{
-	struct wil6210_priv *wil = ndev_to_wil(ndev);
-
-	mutex_lock(&wil->mutex);
-
-	wil_dbg_misc(wil, "ethtoolops_begin\n");
-
-	return 0;
-}
-
-static void wil_ethtoolops_complete(struct net_device *ndev)
-{
-	struct wil6210_priv *wil = ndev_to_wil(ndev);
-
-	wil_dbg_misc(wil, "ethtoolops_complete\n");
-
-	mutex_unlock(&wil->mutex);
-}
-
 static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 				       struct ethtool_coalesce *cp)
 {
@@ -39,11 +19,12 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 	u32 rx_itr_en, rx_itr_val = 0;
 	int ret;
 
+	mutex_lock(&wil->mutex);
 	wil_dbg_misc(wil, "ethtoolops_get_coalesce\n");
 
 	ret = wil_pm_runtime_get(wil);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	tx_itr_en = wil_r(wil, RGF_DMA_ITR_TX_CNT_CTL);
 	if (tx_itr_en & BIT_DMA_ITR_TX_CNT_CTL_EN)
@@ -57,7 +38,11 @@ static int wil_ethtoolops_get_coalesce(struct net_device *ndev,
 
 	cp->tx_coalesce_usecs = tx_itr_val;
 	cp->rx_coalesce_usecs = rx_itr_val;
-	return 0;
+	ret = 0;
+
+out:
+	mutex_unlock(&wil->mutex);
+	return ret;
 }
 
 static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
@@ -67,12 +52,14 @@ static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	int ret;
 
+	mutex_lock(&wil->mutex);
 	wil_dbg_misc(wil, "ethtoolops_set_coalesce: rx %d usec, tx %d usec\n",
 		     cp->rx_coalesce_usecs, cp->tx_coalesce_usecs);
 
 	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		wil_dbg_misc(wil, "No IRQ coalescing in monitor mode\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* only @rx_coalesce_usecs and @tx_coalesce_usecs supported,
@@ -88,24 +75,26 @@ static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
 
 	ret = wil_pm_runtime_get(wil);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	wil->txrx_ops.configure_interrupt_moderation(wil);
 
 	wil_pm_runtime_put(wil);
+	ret = 0;
 
-	return 0;
+out:
+	mutex_unlock(&wil->mutex);
+	return ret;
 
 out_bad:
 	wil_dbg_misc(wil, "Unsupported coalescing params. Raw command:\n");
 	print_hex_dump_debug("DBG[MISC] coal ", DUMP_PREFIX_OFFSET, 16, 4,
 			     cp, sizeof(*cp), false);
+	mutex_unlock(&wil->mutex);
 	return -EINVAL;
 }
 
 static const struct ethtool_ops wil_ethtool_ops = {
-	.begin		= wil_ethtoolops_begin,
-	.complete	= wil_ethtoolops_complete,
 	.get_drvinfo	= cfg80211_get_drvinfo,
 	.get_coalesce	= wil_ethtoolops_get_coalesce,
 	.set_coalesce	= wil_ethtoolops_set_coalesce,
-- 
2.24.1

