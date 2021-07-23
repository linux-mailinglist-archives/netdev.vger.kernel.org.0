Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE643D4020
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhGWRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGWRW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CF1C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:00 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j17-20020a17090aeb11b029017613554465so4774920pjz.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rnihq+GD69yneZi/cs41paGcuWkG+BcHiT1CyYF7Mgo=;
        b=gVR6tlJyXsSYg7MR1p2fjduiK6KwX7CG6hgreYTMyXCQdk6sEVctQgL7882hJUcaLr
         6gE0BSYH229ImsGk2G+hejjWA6VkTC9K/p31UJVAINCkXskHNzHNTbgqrOUPYW7/ebDM
         ZELX4ljW4swGTDMu886OeD5a5YniGK7LG+2kvtcbFB+TNDmuqWkDX8005G6/hxg3JpOY
         oPDORnoVxslsIdwW6y5C4EgWMee2lQzvBmxAwteqpZit0qxPnZKgAKGCZ0pqYZJgCW10
         TlutG+F7va6MIm4SK0E5Hz9Y+rgqlbDTKy/ghVa0JiYW3naC3i1z0aK2EvLdT+Fxw/SH
         /I1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Rnihq+GD69yneZi/cs41paGcuWkG+BcHiT1CyYF7Mgo=;
        b=XKax7dPs/b6F7LURXYb8F1cZcVz3hFFQDcuI+C8LgMXk0QL6CK1S4J9S9jaNTMvsKR
         XNqbvVnXr76AXLeRY3JfGldeP3cRbGg3LeEQciX2n3ytKGX7mK8EAuOCA16bfvjmccOM
         ef1GEVugvVpBzSDGswSGpGtfhDZEjDEM1KqNTlfrcneJIV3XFk/IhxwoN4Z2Cx1u4gLd
         ru5oT+ibQ5i2so3oDQpUaPWVXim6kfrepncrG6Xb5GkBb8g/2MboBmcIWVq80Drvchn9
         dcYxROgjBDmdcnxTqar3Itbm70jt/ywTQrJWg0pkoYcz05Ifd9x83pOg9ml965oZMxt5
         T1fg==
X-Gm-Message-State: AOAM530wkhLTu9L3BRnrGznHZeyKVM/ex28zJMUTxtDk67OdeFNa115C
        llstGfiKkOH5k3rSgxpJFYMaEQ==
X-Google-Smtp-Source: ABdhPJwrWpWvMv+vKY30dMyZW75RpT8+QFIEzDxwG0lCHaXOOjqLYvC5PpDzWqThB/WRdrFnotB61g==
X-Received: by 2002:a17:90a:e558:: with SMTP id ei24mr14804937pjb.207.1627063379531;
        Fri, 23 Jul 2021 11:02:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:02:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/5] ionic: make all rx_mode work threadsafe
Date:   Fri, 23 Jul 2021 11:02:45 -0700
Message-Id: <20210723180249.57599-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
References: <20210723180249.57599-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the bulk of the code from ionic_set_rx_mode(), which
can be called from atomic context, into ionic_lif_rx_mode()
which is a safe context.

A call from the stack will get pushed off into a work thread,
but it is also possible to simultaneously have a call driven
by a queue reconfig request from an ethtool command or fw
recovery event.  We add a mutex around the rx_mode work to be
sure they don't collide.

Fixes: 81dbc24147f9 ("ionic: change set_rx_mode from_ndo to can_sleep")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 183 ++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +-
 2 files changed, 85 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index af3a5368529c..7815e9034fb8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -29,7 +29,7 @@ static const u8 ionic_qtype_versions[IONIC_QTYPE_MAX] = {
 				      */
 };
 
-static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
+static void ionic_lif_rx_mode(struct ionic_lif *lif);
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
 static void ionic_link_status_check(struct ionic_lif *lif);
@@ -77,7 +77,7 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 
 		switch (w->type) {
 		case IONIC_DW_TYPE_RX_MODE:
-			ionic_lif_rx_mode(lif, w->rx_mode);
+			ionic_lif_rx_mode(lif);
 			break;
 		case IONIC_DW_TYPE_RX_ADDR_ADD:
 			ionic_lif_addr_add(lif, w->addr);
@@ -1301,10 +1301,8 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 	return 0;
 }
 
-static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
-			  bool can_sleep)
+static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add)
 {
-	struct ionic_deferred_work *work;
 	unsigned int nmfilters;
 	unsigned int nufilters;
 
@@ -1330,97 +1328,46 @@ static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 			lif->nucast--;
 	}
 
-	if (!can_sleep) {
-		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work)
-			return -ENOMEM;
-		work->type = add ? IONIC_DW_TYPE_RX_ADDR_ADD :
-				   IONIC_DW_TYPE_RX_ADDR_DEL;
-		memcpy(work->addr, addr, ETH_ALEN);
-		netdev_dbg(lif->netdev, "deferred: rx_filter %s %pM\n",
-			   add ? "add" : "del", addr);
-		ionic_lif_deferred_enqueue(&lif->deferred, work);
-	} else {
-		netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
-			   add ? "add" : "del", addr);
-		if (add)
-			return ionic_lif_addr_add(lif, addr);
-		else
-			return ionic_lif_addr_del(lif, addr);
-	}
+	netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
+		   add ? "add" : "del", addr);
+	if (add)
+		return ionic_lif_addr_add(lif, addr);
+	else
+		return ionic_lif_addr_del(lif, addr);
 
 	return 0;
 }
 
 static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR, CAN_SLEEP);
-}
-
-static int ionic_ndo_addr_add(struct net_device *netdev, const u8 *addr)
-{
-	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR, CAN_NOT_SLEEP);
+	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR);
 }
 
 static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR, CAN_SLEEP);
+	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR);
 }
 
-static int ionic_ndo_addr_del(struct net_device *netdev, const u8 *addr)
+static void ionic_lif_rx_mode(struct ionic_lif *lif)
 {
-	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR, CAN_NOT_SLEEP);
-}
-
-static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
-{
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.rx_mode_set = {
-			.opcode = IONIC_CMD_RX_MODE_SET,
-			.lif_index = cpu_to_le16(lif->index),
-			.rx_mode = cpu_to_le16(rx_mode),
-		},
-	};
+	struct net_device *netdev = lif->netdev;
+	unsigned int nfilters;
+	unsigned int nd_flags;
 	char buf[128];
-	int err;
+	u16 rx_mode;
 	int i;
 #define REMAIN(__x) (sizeof(buf) - (__x))
 
-	i = scnprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
-		      lif->rx_mode, rx_mode);
-	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
-		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
-	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
-		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
-	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
-		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
-	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
-		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
-	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
-		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
-	netdev_dbg(lif->netdev, "lif%d %s\n", lif->index, buf);
-
-	err = ionic_adminq_post_wait(lif, &ctx);
-	if (err)
-		netdev_warn(lif->netdev, "set rx_mode 0x%04x failed: %d\n",
-			    rx_mode, err);
-	else
-		lif->rx_mode = rx_mode;
-}
+	mutex_lock(&lif->config_lock);
 
-static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
-{
-	struct ionic_lif *lif = netdev_priv(netdev);
-	struct ionic_deferred_work *work;
-	unsigned int nfilters;
-	unsigned int rx_mode;
+	/* grab the flags once for local use */
+	nd_flags = netdev->flags;
 
 	rx_mode = IONIC_RX_MODE_F_UNICAST;
-	rx_mode |= (netdev->flags & IFF_MULTICAST) ? IONIC_RX_MODE_F_MULTICAST : 0;
-	rx_mode |= (netdev->flags & IFF_BROADCAST) ? IONIC_RX_MODE_F_BROADCAST : 0;
-	rx_mode |= (netdev->flags & IFF_PROMISC) ? IONIC_RX_MODE_F_PROMISC : 0;
-	rx_mode |= (netdev->flags & IFF_ALLMULTI) ? IONIC_RX_MODE_F_ALLMULTI : 0;
+	rx_mode |= (nd_flags & IFF_MULTICAST) ? IONIC_RX_MODE_F_MULTICAST : 0;
+	rx_mode |= (nd_flags & IFF_BROADCAST) ? IONIC_RX_MODE_F_BROADCAST : 0;
+	rx_mode |= (nd_flags & IFF_PROMISC) ? IONIC_RX_MODE_F_PROMISC : 0;
+	rx_mode |= (nd_flags & IFF_ALLMULTI) ? IONIC_RX_MODE_F_ALLMULTI : 0;
 
 	/* sync unicast addresses
 	 * next check to see if we're in an overflow state
@@ -1429,49 +1376,83 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	if (can_sleep)
-		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
-	else
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
 		lif->uc_overflow = true;
 	} else if (lif->uc_overflow) {
 		lif->uc_overflow = false;
-		if (!(netdev->flags & IFF_PROMISC))
+		if (!(nd_flags & IFF_PROMISC))
 			rx_mode &= ~IONIC_RX_MODE_F_PROMISC;
 	}
 
 	/* same for multicast */
-	if (can_sleep)
-		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
-	else
-		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
 		lif->mc_overflow = true;
 	} else if (lif->mc_overflow) {
 		lif->mc_overflow = false;
-		if (!(netdev->flags & IFF_ALLMULTI))
+		if (!(nd_flags & IFF_ALLMULTI))
 			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
 	}
 
+	i = scnprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
+		      lif->rx_mode, rx_mode);
+	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
+	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
+	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
+	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
+	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
+	if (rx_mode & IONIC_RX_MODE_F_RDMA_SNIFFER)
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_RDMA_SNIFFER");
+	netdev_dbg(netdev, "lif%d %s\n", lif->index, buf);
+
 	if (lif->rx_mode != rx_mode) {
-		if (!can_sleep) {
-			work = kzalloc(sizeof(*work), GFP_ATOMIC);
-			if (!work) {
-				netdev_err(lif->netdev, "rxmode change dropped\n");
-				return;
-			}
-			work->type = IONIC_DW_TYPE_RX_MODE;
-			work->rx_mode = rx_mode;
-			netdev_dbg(lif->netdev, "deferred: rx_mode\n");
-			ionic_lif_deferred_enqueue(&lif->deferred, work);
-		} else {
-			ionic_lif_rx_mode(lif, rx_mode);
+		struct ionic_admin_ctx ctx = {
+			.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+			.cmd.rx_mode_set = {
+				.opcode = IONIC_CMD_RX_MODE_SET,
+				.lif_index = cpu_to_le16(lif->index),
+			},
+		};
+		int err;
+
+		ctx.cmd.rx_mode_set.rx_mode = cpu_to_le16(rx_mode);
+		err = ionic_adminq_post_wait(lif, &ctx);
+		if (err)
+			netdev_warn(netdev, "set rx_mode 0x%04x failed: %d\n",
+				    rx_mode, err);
+		else
+			lif->rx_mode = rx_mode;
+	}
+
+	mutex_unlock(&lif->config_lock);
+}
+
+static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_deferred_work *work;
+
+	if (!can_sleep) {
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "rxmode change dropped\n");
+			return;
 		}
+		work->type = IONIC_DW_TYPE_RX_MODE;
+		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+		ionic_lif_deferred_enqueue(&lif->deferred, work);
+	} else {
+		ionic_lif_rx_mode(lif);
 	}
 }
 
@@ -3058,6 +3039,7 @@ void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
+	mutex_destroy(&lif->config_lock);
 	mutex_destroy(&lif->queue_lock);
 	ionic_lif_reset(lif);
 }
@@ -3185,7 +3167,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 		 */
 		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
 				      netdev->dev_addr))
-			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
+			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR);
 	} else {
 		/* Update the netdev mac with the device's mac */
 		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
@@ -3202,7 +3184,7 @@ static int ionic_station_set(struct ionic_lif *lif)
 
 	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
 		   netdev->dev_addr);
-	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
+	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR);
 
 	return 0;
 }
@@ -3225,6 +3207,7 @@ int ionic_lif_init(struct ionic_lif *lif)
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
 	mutex_init(&lif->queue_lock);
+	mutex_init(&lif->config_lock);
 
 	/* now that we have the hw_index we can figure out our doorbell page */
 	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 346506f01715..af291303bd7a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -108,7 +108,6 @@ struct ionic_deferred_work {
 	struct list_head list;
 	enum ionic_deferred_work_type type;
 	union {
-		unsigned int rx_mode;
 		u8 addr[ETH_ALEN];
 		u8 fw_status;
 	};
@@ -179,6 +178,7 @@ struct ionic_lif {
 	unsigned int index;
 	unsigned int hw_index;
 	struct mutex queue_lock;	/* lock for queue structures */
+	struct mutex config_lock;	/* lock for config actions */
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
@@ -199,7 +199,7 @@ struct ionic_lif {
 	unsigned int nrxq_descs;
 	u32 rx_copybreak;
 	u64 rxq_features;
-	unsigned int rx_mode;
+	u16 rx_mode;
 	u64 hw_features;
 	bool registered;
 	bool mc_overflow;
-- 
2.17.1

