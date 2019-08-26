Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78739D88C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfHZVeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40789 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbfHZVeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so12633016pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ofg6ID0X/l9lUMsf7nIA2KXVx3gRX9xSI7Yq/6YQdGU=;
        b=OwwLAozqyGViwHPL+Ru6oBPDPtAsrTX3m9Ja0uMAfBoXwQ7DFZIu9bmvuhuiMqIwTu
         5d6xk6fdopkaKXgM9Wicjq5ii+CJvSran0vp0Hzj3bayJM0TWqTBppcB2epyG8H1mNvG
         H9/qh7kzo1W1zkYA+NQzWKEkr+SinQN10Ko3m2U7TjOGZlXkvj6Tk5WSlHrd8plzh73N
         rnFSoZ/2SqoBV/CopzB157Tv+e6sW6Vd/DcyqTW0h8i3B257PB051aKRM12nYOMFf2Y0
         Mrm1VuYE9Nv2xG/YY6CcLgXYjiPTk3lU+H0+rZjeK7ENu8tX5W1nFuWhDqLvW2zzbqwk
         CI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ofg6ID0X/l9lUMsf7nIA2KXVx3gRX9xSI7Yq/6YQdGU=;
        b=nrraY+KrcTUVNKO3THMEeddekntuz3yn5DZIMol3wkEnOUz3pUfMgV+h9A/tLPggDN
         C7IaFe/Mwvv6ir91TRe5vnNGFGPau/k+XeSrU/OVd2uMbSOemmzc4mP749if0XgaFO4x
         KnQGwHSzGZL0i4qdF94Cpswz7Mp4XLxY0RwrnGev7N6e6a5h3tLG4v8aJQVkNzZlTne8
         +xmzaO7Vfa6KxA/54BP1Yw47JLlmF0/UTzM4prcwZZx8fIkB3uQBUU4soDhDs2C9jtpZ
         azX2ctA4vErpDGZFuJdKH7Zl+OU6HaqZ0h1nJd29jvLc1sPS5pVAWvxrl1Xewkto0ph4
         VNoQ==
X-Gm-Message-State: APjAAAV4js4YbFzKfWx4WbdmAjE0C3vLDuz8UzzNuVis0uHQTmPozvnP
        TPA6cEr9EFUN/vOIWrFlnmVMCMM82k4=
X-Google-Smtp-Source: APXvYqzubH3ddTOxe+9pQsQk1bn3NcQFUS4pjvP5Wo43MK1dYt3vR3Y4UQu1KL02sj2xni2NkxR8hQ==
X-Received: by 2002:a17:90a:ac02:: with SMTP id o2mr22292500pjq.134.1566855241685;
        Mon, 26 Aug 2019 14:34:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.34.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:34:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 11/18] ionic: Add Rx filter and rx_mode ndo support
Date:   Mon, 26 Aug 2019 14:33:32 -0700
Message-Id: <20190826213339.56909-12-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Rx filtering and rx_mode NDO callbacks.  Also add
the deferred work thread handling needed to manage the filter
requests outside of the netif_addr_lock spinlock.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 391 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  29 ++
 2 files changed, 414 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 373b93403190..0fcb26b8608e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,6 +12,52 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
+static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
+static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
+
+static void ionic_lif_deferred_work(struct work_struct *work)
+{
+	struct ionic_lif *lif = container_of(work, struct ionic_lif, deferred.work);
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
+		case IONIC_DW_TYPE_RX_MODE:
+			ionic_lif_rx_mode(lif, w->rx_mode);
+			break;
+		case IONIC_DW_TYPE_RX_ADDR_ADD:
+			ionic_lif_addr_add(lif, w->addr);
+			break;
+		case IONIC_DW_TYPE_RX_ADDR_DEL:
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
 static irqreturn_t ionic_isr(int irq, void *data)
 {
 	struct napi_struct *napi = data;
@@ -400,6 +446,238 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return max(n_work, a_work);
 }
 
+static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = IONIC_CMD_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_MAC),
+		},
+	};
+	struct ionic_rx_filter *f;
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
+	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
+}
+
+static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = IONIC_CMD_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct ionic_rx_filter *f;
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
+static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add)
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
+		work->type = add ? IONIC_DW_TYPE_RX_ADDR_ADD :
+				   IONIC_DW_TYPE_RX_ADDR_DEL;
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
+static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_mode_set = {
+			.opcode = IONIC_CMD_RX_MODE_SET,
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
+	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
+	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
+	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
+	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
+		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
+	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
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
+static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
+{
+	struct ionic_deferred_work *work;
+
+	if (in_interrupt()) {
+		work = kzalloc(sizeof(*work), GFP_ATOMIC);
+		if (!work) {
+			netdev_err(lif->netdev, "%s OOM\n", __func__);
+			return;
+		}
+		work->type = IONIC_DW_TYPE_RX_MODE;
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
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_identity *ident;
+	unsigned int nfilters;
+	unsigned int rx_mode;
+
+	ident = &lif->ionic->ident;
+
+	rx_mode = IONIC_RX_MODE_F_UNICAST;
+	rx_mode |= (netdev->flags & IFF_MULTICAST) ? IONIC_RX_MODE_F_MULTICAST : 0;
+	rx_mode |= (netdev->flags & IFF_BROADCAST) ? IONIC_RX_MODE_F_BROADCAST : 0;
+	rx_mode |= (netdev->flags & IFF_PROMISC) ? IONIC_RX_MODE_F_PROMISC : 0;
+	rx_mode |= (netdev->flags & IFF_ALLMULTI) ? IONIC_RX_MODE_F_ALLMULTI : 0;
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
+		rx_mode |= IONIC_RX_MODE_F_PROMISC;
+		lif->uc_overflow = true;
+	} else if (lif->uc_overflow) {
+		lif->uc_overflow = false;
+		if (!(netdev->flags & IFF_PROMISC))
+			rx_mode &= ~IONIC_RX_MODE_F_PROMISC;
+	}
+
+	/* same for multicast */
+	__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	nfilters = le32_to_cpu(ident->lif.eth.max_mcast_filters);
+	if (netdev_mc_count(netdev) > nfilters) {
+		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
+		lif->mc_overflow = true;
+	} else if (lif->mc_overflow) {
+		lif->mc_overflow = false;
+		if (!(netdev->flags & IFF_ALLMULTI))
+			rx_mode &= ~IONIC_RX_MODE_F_ALLMULTI;
+	}
+
+	if (lif->rx_mode != rx_mode)
+		_ionic_lif_rx_mode(lif, rx_mode);
+}
+
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
 {
 	u64 wanted = 0;
@@ -588,8 +866,26 @@ static int ionic_set_features(struct net_device *netdev,
 
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
@@ -624,15 +920,57 @@ static void ionic_tx_timeout(struct net_device *netdev)
 static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
 				 u16 vid)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = IONIC_CMD_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(IONIC_RX_FILTER_MATCH_VLAN),
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
+	return ionic_rx_filter_save(lif, 0, IONIC_RXQ_INDEX_ANY, 0, &ctx);
 }
 
 static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 				  u16 vid)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = IONIC_CMD_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct ionic_rx_filter *f;
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
 
 int ionic_open(struct net_device *netdev)
@@ -668,6 +1006,7 @@ int ionic_stop(struct net_device *netdev)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -734,6 +1073,10 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	spin_lock_init(&lif->adminq_lock);
 
+	spin_lock_init(&lif->deferred.lock);
+	INIT_LIST_HEAD(&lif->deferred.list);
+	INIT_WORK(&lif->deferred.work, ionic_lif_deferred_work);
+
 	/* allocate lif info */
 	lif->info_sz = ALIGN(sizeof(*lif->info), PAGE_SIZE);
 	lif->info = dma_alloc_coherent(dev, lif->info_sz,
@@ -953,6 +1296,37 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
 	return 0;
 }
 
+static int ionic_station_set(struct ionic_lif *lif)
+{
+	struct net_device *netdev = lif->netdev;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_getattr = {
+			.opcode = IONIC_CMD_LIF_GETATTR,
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
 static int ionic_lif_init(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -1016,6 +1390,10 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_station_set(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
@@ -1072,6 +1450,7 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
 	 */
+	cancel_work_sync(&ionic->master_lif->deferred.work);
 	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(ionic->master_lif->netdev);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index b1cd51a5162c..a7dcb7865b89 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -58,6 +58,29 @@ struct ionic_qcq {
 #define napi_to_qcq(napi)	container_of(napi, struct ionic_qcq, napi)
 #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
 
+enum ionic_deferred_work_type {
+	IONIC_DW_TYPE_RX_MODE,
+	IONIC_DW_TYPE_RX_ADDR_ADD,
+	IONIC_DW_TYPE_RX_ADDR_DEL,
+	IONIC_DW_TYPE_LINK_STATUS,
+	IONIC_DW_TYPE_LIF_RESET,
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
 enum ionic_lif_state_flags {
 	IONIC_LIF_INITED,
 	IONIC_LIF_UP,
@@ -85,13 +108,19 @@ struct ionic_lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	unsigned int rx_mode;
 	u64 hw_features;
+	bool mc_overflow;
+	unsigned int nmcast;
+	bool uc_overflow;
+	unsigned int nucast;
 
 	struct ionic_lif_info *info;
 	dma_addr_t info_pa;
 	u32 info_sz;
 
 	struct ionic_rx_filters rx_filters;
+	struct ionic_deferred deferred;
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
-- 
2.17.1

