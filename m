Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AD82EEA51
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbhAHAVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729609AbhAHAVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:51 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1153C0612A0
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:43 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jx16so12152735ejb.10
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlyb0qVtCkIXWbk0G0nefFuQvt+Rbe4KU6VEbzVyNOY=;
        b=d5wse9LhBj9c9Xl7VDe03/t7oBTtgJoJU1fpoWbjcfP+GF2iHqfujDdsqv2sgFW1M4
         Mb8gis522FGR4KpZClC9rRRuIgPUGG2tWIfE10w0zY6bg7niirJ8vSJinfaRd21T0jQu
         wExxc9DpYy6mIDLEWDi23pt/WvJRoN71VrjfTmau9+t2616LFvcNjmVb/k4wbf9GRgD2
         Hkc3NSJ7vyQ2zgQ4sgm/P/N/CqwEI7sWDX79OedNnyYFk8vp/rrrotDbh2LJSqVU3eee
         CNNBancvfcokpzakRk4EJfM92FeVVkJIgfzBKSzLVX95owLCsR38cDm0kixJLvKtuPpx
         1twA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlyb0qVtCkIXWbk0G0nefFuQvt+Rbe4KU6VEbzVyNOY=;
        b=XAKNRNECmElWxSx0b4o0B68K38UR9Jhu7RFXZJoooOLy/83dLBkZQH5nmbrmDGRHYP
         4jeFnHRFDTCvy3TljpehE1lUiE7Kn2BsjY6oayCCVwESAdD1f5YxdEzMpPXkrbODCDw1
         C43dzMWQwQyXaAvV7tibWgvNvrkTe6/Ein6P0dLPqxM2v9LTqyTPmbBsBCZPm9sibe03
         HjKy0XSdY2BV6G9D2QlCHkJg/hFch8nhN76t1FLAzm6joJL9yIdEn/mQ3L9X1r5tRUjX
         unDW+W2nMmU2IjaGiFXf2IkCExzNqGfFvdg7e9y40U0s7VXgqBDbo5P1esky4vBNYNLT
         Ek0w==
X-Gm-Message-State: AOAM5315bfXNv3H8f22elhnbDCq8d80INOqwAEU7P8YF96S4xNDGNlo2
        zXbn7yDp7XTLD9C0HDTRUQY=
X-Google-Smtp-Source: ABdhPJygWX4v7c8lDip58y7wiFM1fs+NOPqwe4jgFqr9DXNvHdhVmsbsQBEZCpWyY5uG7FnzyPgMgA==
X-Received: by 2002:a17:906:68d1:: with SMTP id y17mr904432ejr.447.1610065242457;
        Thu, 07 Jan 2021 16:20:42 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 13/18] net: terminate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 02:20:00 +0200
Message-Id: <20210108002005.3429956-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dev_get_stats can now return errors. Some call sites are coming from a
context that returns void (ethtool stats, workqueue context). So since
we can't report to the upper layer, do the next best thing: shout.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new (Eric's suggestion).

 arch/s390/appldata/appldata_net_sum.c               | 10 ++++++++--
 drivers/leds/trigger/ledtrig-netdev.c               |  9 ++++++++-
 drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c |  9 +++++++--
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c    |  7 ++++++-
 drivers/net/ethernet/intel/e1000e/ethtool.c         |  9 +++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c    |  9 +++++++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c        |  9 +++++++--
 7 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 6146606ac9a3..72cb5344e488 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -58,11 +58,11 @@ struct appldata_net_sum_data {
  */
 static void appldata_get_net_sum_data(void *data)
 {
-	int i;
 	struct appldata_net_sum_data *net_data;
 	struct net_device *dev;
 	unsigned long rx_packets, tx_packets, rx_bytes, tx_bytes, rx_errors,
 			tx_errors, rx_dropped, tx_dropped, collisions;
+	int ret, i;
 
 	net_data = data;
 	net_data->sync_count_1++;
@@ -83,7 +83,13 @@ static void appldata_get_net_sum_data(void *data)
 	for_each_netdev(&init_net, dev) {
 		struct rtnl_link_stats64 stats;
 
-		dev_get_stats(dev, &stats);
+		ret = dev_get_stats(dev, &stats);
+		if (ret) {
+			netif_lists_unlock(&init_net);
+			netdev_err(dev, "dev_get_stats returned %d\n", ret);
+			return;
+		}
+
 		rx_packets += stats.rx_packets;
 		tx_packets += stats.tx_packets;
 		rx_bytes   += stats.rx_bytes;
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4382ee278309..c717b7e7dd81 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -351,6 +351,7 @@ static void netdev_trig_work(struct work_struct *work)
 	unsigned int new_activity;
 	unsigned long interval;
 	int invert;
+	int err;
 
 	/* If we dont have a device, insure we are off */
 	if (!trigger_data->net_dev) {
@@ -363,7 +364,13 @@ static void netdev_trig_work(struct work_struct *work)
 	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
 		return;
 
-	dev_get_stats(trigger_data->net_dev, &dev_stats);
+	err = dev_get_stats(trigger_data->net_dev, &dev_stats);
+	if (err) {
+		netdev_err(trigger_data->net_dev,
+			   "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	new_activity =
 	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
 		dev_stats.tx_packets : 0) +
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
index ada70425b48c..aab6a81f0438 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
@@ -266,9 +266,14 @@ static void xgene_get_ethtool_stats(struct net_device *ndev,
 {
 	struct xgene_enet_pdata *pdata = netdev_priv(ndev);
 	struct rtnl_link_stats64 stats;
-	int i;
+	int err, i;
+
+	err = dev_get_stats(ndev, &stats);
+	if (err) {
+		netdev_err(ndev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
-	dev_get_stats(ndev, &stats);
 	for (i = 0; i < XGENE_STATS_LEN; i++)
 		data[i] = *(u64 *)((char *)&stats + gstrings_stats[i].offset);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index ee2172011051..d05fa7b3f6e0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -840,6 +840,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 	struct hnae_handle *h = priv->ae_handle;
 	struct rtnl_link_stats64 net_stats;
+	int err;
 
 	if (!h->dev->ops->get_stats || !h->dev->ops->update_stats) {
 		netdev_err(netdev, "get_stats or update_stats is null!\n");
@@ -848,7 +849,11 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 
 	h->dev->ops->update_stats(h, &netdev->stats);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
 	/* get netdev statistics */
 	p[0] = net_stats.rx_packets;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6bef73..41bd3e0598ce 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2060,15 +2060,20 @@ static void e1000_get_ethtool_stats(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct rtnl_link_stats64 net_stats;
-	int i;
 	char *p = NULL;
+	int err, i;
 
 	pm_runtime_get_sync(netdev->dev.parent);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
 
 	pm_runtime_put_sync(netdev->dev.parent);
 
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
 		switch (e1000_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 2b8084664403..a647e2774f76 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1298,11 +1298,16 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbe_ring *ring;
-	int i, j;
 	char *p = NULL;
+	int err, i, j;
 
 	ixgbe_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbe_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 3b9b7e5c2998..665e39301092 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -423,11 +423,16 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbevf_ring *ring;
-	int i, j;
+	int err, i, j;
 	char *p;
 
 	ixgbevf_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBEVF_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbevf_gstrings_stats[i].type) {
 		case NETDEV_STATS:
-- 
2.25.1

