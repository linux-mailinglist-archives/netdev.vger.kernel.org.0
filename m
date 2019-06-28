Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA9E5A673
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfF1VkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:40:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45843 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfF1Vjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:39:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id z19so3136879pgl.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=qNS2Xnm+h2vls75R27XtNJkA41DKC97q9ItSKvdNgZ8=;
        b=xHhg0edb+frRhkTitHBpms8P8GNiv8/QIgA4FdJ397wd/IqBxyJ2lZeoA+hSOXlNcn
         gb+xOPxH4pKBVa3XxdQsErF3rJFPuLxu7xm4aHK38Lh/0tV0cR/OPQ1Dbh3mJgzmbdR5
         rE+ZpOmsTzqdXI6JJFFoP+HsMGZC91/5eIiS85Mlvef0bNUf+P46bPIprcPw0/m7aLGw
         OVFJ+NKxvCurvHiXdwoACckYf+nc9ENgagv8ndjqJEeYsYMGSoMjXq3s+V0r7O/mb7zY
         bf8LZwJ8Q6/0MAbdcjHp+X5x2R3lZTTJCJPuyqdyNEh4l1aXG1o2kTLESS9KhUBp4zoy
         HG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=qNS2Xnm+h2vls75R27XtNJkA41DKC97q9ItSKvdNgZ8=;
        b=ARMwJZoTTCgSmmlN2wZa3nEXxBwE2/Sp6co8J6PCBrx7al/55EzoHiRmLOzTdy65aB
         EvnMoXSTxCUi/36L2RqDeq6QhEgj68h/VqeEI6c3Tvz+t6kUaSeGmsTkiE0NGR1402RV
         6JWMBKKGA7R/ZlbZ8+VyPdE1wEeQnd/m38OIl9Pd+i8ZwQVAdx4Bccta8JOl8TrBISqj
         VfC49AF75eECqdVKM/zSkdUtUGNUZD3Yp3GVuzSula6C3XH9uvuMfQKap/hgTV+kx4c+
         P97+lh8N+nJVmC6hz9+Qz9uYW/PPZ7S3SIz8hmT2hMqyHZjOmej9kUvoHug4d2t+TlnT
         pVrw==
X-Gm-Message-State: APjAAAViEphbUuhUvZJiCwpg3tjogo0qwSs0r+fj8uMjWLzxMqmL3Euh
        P/8+NWBjm+pvlNBPiyWwJ2qe1UmfY2U=
X-Google-Smtp-Source: APXvYqxrG/xA0yMXzqIXJDUlkpTDxT+eZTCPFyAmfIKPUFF5QQ7VxaUfsli1vdKxJCPDYv0Th+6X8A==
X-Received: by 2002:a63:f746:: with SMTP id f6mr11228132pgk.56.1561757994322;
        Fri, 28 Jun 2019 14:39:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.39.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:39:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 11/19] ionic: Add Rx filter and rx_mode ndo support
Date:   Fri, 28 Jun 2019 14:39:26 -0700
Message-Id: <20190628213934.8810-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Rx filtering and rx_mode NDO callbacks.  Also add
the deferred work thread handling needed to manage the filter
requests otuside of the netif_addr_lock spinlock.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 389 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  29 ++
 2 files changed, 412 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8f7abcebb1a5..dbe35249ab76 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,9 +12,55 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static void ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode);
+static int ionic_lif_addr_add(struct lif *lif, const u8 *addr);
+static int ionic_lif_addr_del(struct lif *lif, const u8 *addr);
+
 static int ionic_set_nic_features(struct lif *lif, netdev_features_t features);
 static int ionic_notifyq_clean(struct lif *lif, int budget);
 
+static void ionic_lif_deferred_work(struct work_struct *work)
+{
+	struct lif *lif = container_of(work, struct lif, deferred.work);
+	struct ionic_deferred *def = &lif->deferred;
+	struct ionic_deferred_work *w = NULL;
+
+	spin_lock_bh(&def->lock);
+	if (!list_empty(&def->list)) {
+		w = list_first_entry(&def->list,
+				     struct ionic_deferred_work, list);
+		list_del(&w->list);
+	}
+	spin_unlock_bh(&def->lock);
+
+	if (w) {
+		switch (w->type) {
+		case DW_TYPE_RX_MODE:
+			ionic_lif_rx_mode(lif, w->rx_mode);
+			break;
+		case DW_TYPE_RX_ADDR_ADD:
+			ionic_lif_addr_add(lif, w->addr);
+			break;
+		case DW_TYPE_RX_ADDR_DEL:
+			ionic_lif_addr_del(lif, w->addr);
+			break;
+		default:
+			break;
+		}
+		kfree(w);
+		schedule_work(&def->work);
+	}
+}
+
+static void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
+				       struct ionic_deferred_work *work)
+{
+	spin_lock_bh(&def->lock);
+	list_add_tail(&work->list, &def->list);
+	spin_unlock_bh(&def->lock);
+	schedule_work(&def->work);
+}
+
 int ionic_open(struct net_device *netdev)
 {
 	struct lif *lif = netdev_priv(netdev);
@@ -180,6 +226,235 @@ static int ionic_notifyq_clean(struct lif *lif, int budget)
 	return work_done;
 }
 
+static int ionic_lif_addr_add(struct lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = CMD_OPCODE_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(RX_FILTER_MATCH_MAC),
+		},
+	};
+	struct rx_filter *f;
+	int err;
+
+	/* don't bother if we already have it */
+	spin_lock_bh(&lif->rx_filters.lock);
+	f = ionic_rx_filter_by_addr(lif, addr);
+	spin_unlock_bh(&lif->rx_filters.lock);
+	if (f)
+		return 0;
+
+	netdev_dbg(lif->netdev, "rx_filter add ADDR %pM (id %d)\n", addr,
+		   ctx.comp.rx_filter_add.filter_id);
+
+	memcpy(ctx.cmd.rx_filter_add.mac.addr, addr, ETH_ALEN);
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	return ionic_rx_filter_save(lif, 0, RXQ_INDEX_ANY, 0, &ctx);
+}
+
+static int ionic_lif_addr_del(struct lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = CMD_OPCODE_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct rx_filter *f;
+	int err;
+
+	spin_lock_bh(&lif->rx_filters.lock);
+	f = ionic_rx_filter_by_addr(lif, addr);
+	if (!f) {
+		spin_unlock_bh(&lif->rx_filters.lock);
+		return -ENOENT;
+	}
+
+	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
+	ionic_rx_filter_free(lif, f);
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	netdev_dbg(lif->netdev, "rx_filter del ADDR %pM (id %d)\n", addr,
+		   ctx.cmd.rx_filter_del.filter_id);
+
+	return 0;
+}
+
+static int ionic_lif_addr(struct lif *lif, const u8 *addr, bool add)
+{
+	struct ionic *ionic = lif->ionic;
+	struct ionic_deferred_work *work;
+	unsigned int nmfilters;
+	unsigned int nufilters;
+
+	if (add) {
+		/* Do we have space for this filter?  We test the counters
+		 * here before checking the need for deferral so that we
+		 * can return an overflow error to the stack.
+		 */
+		nmfilters = le32_to_cpu(ionic->ident.lif.eth.max_mcast_filters);
+		nufilters = le32_to_cpu(ionic->ident.lif.eth.max_ucast_filters);
+
+		if ((is_multicast_ether_addr(addr) && lif->nmcast < nmfilters))
+			lif->nmcast++;
+		else if (!is_multicast_ether_addr(addr) &&
+			 lif->nucast < nufilters)
+			lif->nucast++;
+		else
+			return -ENOSPC;
+	} else {
+		if (is_multicast_ether_addr(addr) && lif->nmcast)
+			lif->nmcast--;
+		else if (!is_multicast_ether_addr(addr) && lif->nucast)
+			lif->nucast--;
+	}
+
+	if (in_interrupt()) {
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "%s OOM\n", __func__);
+			return -ENOMEM;
+		}
+		work->type = add ? DW_TYPE_RX_ADDR_ADD : DW_TYPE_RX_ADDR_DEL;
+		memcpy(work->addr, addr, ETH_ALEN);
+		netdev_dbg(lif->netdev, "deferred: rx_filter %s %pM\n",
+			   add ? "add" : "del", addr);
+		ionic_lif_deferred_enqueue(&lif->deferred, work);
+	} else {
+		netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
+			   add ? "add" : "del", addr);
+		if (add)
+			return ionic_lif_addr_add(lif, addr);
+		else
+			return ionic_lif_addr_del(lif, addr);
+	}
+
+	return 0;
+}
+
+static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
+{
+	return ionic_lif_addr(netdev_priv(netdev), addr, true);
+}
+
+static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
+{
+	return ionic_lif_addr(netdev_priv(netdev), addr, false);
+}
+
+static void ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_mode_set = {
+			.opcode = CMD_OPCODE_RX_MODE_SET,
+			.lif_index = cpu_to_le16(lif->index),
+			.rx_mode = cpu_to_le16(rx_mode),
+		},
+	};
+	char buf[128];
+	int err;
+	int i;
+#define REMAIN(__x) (sizeof(buf) - (__x))
+
+	i = snprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
+		     lif->rx_mode, rx_mode);
+	if (rx_mode & RX_MODE_F_UNICAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
+	if (rx_mode & RX_MODE_F_MULTICAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
+	if (rx_mode & RX_MODE_F_BROADCAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
+	if (rx_mode & RX_MODE_F_PROMISC)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
+	if (rx_mode & RX_MODE_F_ALLMULTI)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
+	netdev_dbg(lif->netdev, "lif%d %s\n", lif->index, buf);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		netdev_warn(lif->netdev, "set rx_mode 0x%04x failed: %d\n",
+			    rx_mode, err);
+	else
+		lif->rx_mode = rx_mode;
+}
+
+static void _ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode)
+{
+	struct ionic_deferred_work *work;
+
+	if (in_interrupt()) {
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "%s OOM\n", __func__);
+			return;
+		}
+		work->type = DW_TYPE_RX_MODE;
+		work->rx_mode = rx_mode;
+		netdev_dbg(lif->netdev, "deferred: rx_mode\n");
+		ionic_lif_deferred_enqueue(&lif->deferred, work);
+	} else {
+		ionic_lif_rx_mode(lif, rx_mode);
+	}
+}
+
+static void ionic_set_rx_mode(struct net_device *netdev)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct identity *ident = &lif->ionic->ident;
+	unsigned int nfilters;
+	unsigned int rx_mode;
+
+	rx_mode = RX_MODE_F_UNICAST;
+	rx_mode |= (netdev->flags & IFF_MULTICAST) ? RX_MODE_F_MULTICAST : 0;
+	rx_mode |= (netdev->flags & IFF_BROADCAST) ? RX_MODE_F_BROADCAST : 0;
+	rx_mode |= (netdev->flags & IFF_PROMISC) ? RX_MODE_F_PROMISC : 0;
+	rx_mode |= (netdev->flags & IFF_ALLMULTI) ? RX_MODE_F_ALLMULTI : 0;
+
+	/* sync unicast addresses
+	 * next check to see if we're in an overflow state
+	 *    if so, we track that we overflowed and enable NIC PROMISC
+	 *    else if the overflow is set and not needed
+	 *       we remove our overflow flag and check the netdev flags
+	 *       to see if we can disable NIC PROMISC
+	 */
+	__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	nfilters = le32_to_cpu(ident->lif.eth.max_ucast_filters);
+	if (netdev_uc_count(netdev) + 1 > nfilters) {
+		rx_mode |= RX_MODE_F_PROMISC;
+		lif->uc_overflow = true;
+	} else if (lif->uc_overflow) {
+		lif->uc_overflow = false;
+		if (!(netdev->flags & IFF_PROMISC))
+			rx_mode &= ~RX_MODE_F_PROMISC;
+	}
+
+	/* same for multicast */
+	__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	nfilters = le32_to_cpu(ident->lif.eth.max_mcast_filters);
+	if (netdev_mc_count(netdev) > nfilters) {
+		rx_mode |= RX_MODE_F_ALLMULTI;
+		lif->mc_overflow = true;
+	} else if (lif->mc_overflow) {
+		lif->mc_overflow = false;
+		if (!(netdev->flags & IFF_ALLMULTI))
+			rx_mode &= ~RX_MODE_F_ALLMULTI;
+	}
+
+	if (lif->rx_mode != rx_mode)
+		_ionic_lif_rx_mode(lif, rx_mode);
+}
+
 static int ionic_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
@@ -196,8 +471,26 @@ static int ionic_set_features(struct net_device *netdev,
 
 static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct sockaddr *addr = sa;
+	u8 *mac;
+
+	mac = (u8 *)addr->sa_data;
+	if (ether_addr_equal(netdev->dev_addr, mac))
+		return 0;
+
+	if (!is_valid_ether_addr(mac))
+		return -EADDRNOTAVAIL;
+
+	if (!is_zero_ether_addr(netdev->dev_addr)) {
+		netdev_info(netdev, "deleting mac addr %pM\n",
+			    netdev->dev_addr);
+		ionic_addr_del(netdev, netdev->dev_addr);
+	}
+
+	memcpy(netdev->dev_addr, mac, netdev->addr_len);
+	netdev_info(netdev, "updating mac addr %pM\n", mac);
+
+	return ionic_addr_add(netdev, mac);
 }
 
 static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
@@ -232,20 +525,63 @@ static void ionic_tx_timeout(struct net_device *netdev)
 static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
 				 u16 vid)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = CMD_OPCODE_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(RX_FILTER_MATCH_VLAN),
+			.vlan.vlan = cpu_to_le16(vid),
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	netdev_dbg(netdev, "rx_filter add VLAN %d (id %d)\n", vid,
+		   ctx.comp.rx_filter_add.filter_id);
+
+	return ionic_rx_filter_save(lif, 0, RXQ_INDEX_ANY, 0, &ctx);
 }
 
 static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 				  u16 vid)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = CMD_OPCODE_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct rx_filter *f;
+
+	spin_lock_bh(&lif->rx_filters.lock);
+
+	f = ionic_rx_filter_by_vlan(lif, vid);
+	if (!f) {
+		spin_unlock_bh(&lif->rx_filters.lock);
+		return -ENOENT;
+	}
+
+	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n", vid,
+		   le32_to_cpu(ctx.cmd.rx_filter_del.filter_id));
+
+	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
+	ionic_rx_filter_free(lif, f);
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	return ionic_adminq_post_wait(lif, &ctx);
 }
 
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -546,6 +882,10 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 
 	spin_lock_init(&lif->adminq_lock);
 
+	spin_lock_init(&lif->deferred.lock);
+	INIT_LIST_HEAD(&lif->deferred.list);
+	INIT_WORK(&lif->deferred.work, ionic_lif_deferred_work);
+
 	/* allocate lif info */
 	lif->info_sz = ALIGN(sizeof(*lif->info), PAGE_SIZE);
 	lif->info = dma_alloc_coherent(dev, lif->info_sz,
@@ -607,6 +947,8 @@ static void ionic_lif_free(struct lif *lif)
 	ionic_qcqs_free(lif);
 	ionic_lif_reset(lif);
 
+	cancel_work_sync(&lif->deferred.work);
+
 	/* free lif info */
 	if (lif->info) {
 		dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
@@ -977,6 +1319,37 @@ static int ionic_init_nic_features(struct lif *lif)
 	return 0;
 }
 
+static int ionic_station_set(struct lif *lif)
+{
+	struct net_device *netdev = lif->netdev;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_getattr = {
+			.opcode = CMD_OPCODE_LIF_GETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_MAC,
+		},
+	};
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	if (!is_zero_ether_addr(netdev->dev_addr)) {
+		netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
+			   netdev->dev_addr);
+		ionic_lif_addr(lif, netdev->dev_addr, false);
+	}
+	memcpy(netdev->dev_addr, ctx.comp.lif_getattr.mac,
+	       netdev->addr_len);
+	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
+		   netdev->dev_addr);
+	ionic_lif_addr(lif, netdev->dev_addr, true);
+
+	return 0;
+}
+
 static int ionic_lif_init(struct lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -1041,6 +1414,10 @@ static int ionic_lif_init(struct lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_station_set(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9f112aa69033..20b4fa573f77 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -60,6 +60,29 @@ struct qcq {
 #define napi_to_qcq(napi)	container_of(napi, struct qcq, napi)
 #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
 
+enum ionic_deferred_work_type {
+	DW_TYPE_RX_MODE,
+	DW_TYPE_RX_ADDR_ADD,
+	DW_TYPE_RX_ADDR_DEL,
+	DW_TYPE_LINK_STATUS,
+	DW_TYPE_LIF_RESET,
+};
+
+struct ionic_deferred_work {
+	struct list_head list;
+	enum ionic_deferred_work_type type;
+	union {
+		unsigned int rx_mode;
+		u8 addr[ETH_ALEN];
+	};
+};
+
+struct ionic_deferred {
+	spinlock_t lock;		/* lock for deferred work list */
+	struct list_head list;
+	struct work_struct work;
+};
+
 enum lif_state_flags {
 	LIF_INITED,
 	LIF_UP,
@@ -87,13 +110,19 @@ struct lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	unsigned int rx_mode;
 	u64 hw_features;
+	bool mc_overflow;
+	unsigned int nmcast;
+	bool uc_overflow;
+	unsigned int nucast;
 
 	struct lif_info *info;
 	dma_addr_t info_pa;
 	u32 info_sz;
 
 	struct rx_filters rx_filters;
+	struct ionic_deferred deferred;
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
-- 
2.17.1

