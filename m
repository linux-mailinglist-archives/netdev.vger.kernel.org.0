Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8687A76F9
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfICW3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36393 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfICW3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so10006481pgm.3
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=8Efk5ThIuPre5CKs0FvNF8Yy8gyFwdUhRaxg60gAd+Q=;
        b=GU3TivtCl0QFcou3pKX7LMKcq96Q8yVVjtdgdxujbilUU0wN/G36B690FaQsbcAteU
         ye0lDlI4YDWCWXSEGr5EQkIMewyv9jUAk5MkuOKIUr1+fd18Ixyz8Z5xe/ZFHAhYmCWy
         GMSvgPI/mhFfqQtCEb6wywQahrjJKiEDM4l9K+ZHLYJ4ySLlFUUjp6Q4H7kGqixIOGoO
         HOqqO4uEm1Ef+dy4PFX7VId4MrcTaM1UNEKZ3nOQN++jvm0n22NgTrXGuU3vFl8D5Qn2
         E/gMw8fRMVZkzKvj4t/u6FuLn+sL6h4Sl41LZWbbD+RU86ktjduuymyr/iwJVnS5IY+w
         FKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=8Efk5ThIuPre5CKs0FvNF8Yy8gyFwdUhRaxg60gAd+Q=;
        b=CsG7hDgeqhypvMcNCmVBFGp0V/t/np5inuVEv8B4fVozgHoKm3wMMcHec2mkzOymeH
         XJDsqy5gyW7XY6fTtJultVCIroxZ/P1RSWwf70fdvLDKGoWf8hV/fpz4yHz91Kym1IFM
         bGf5LjaR0bdhFwyRFre2cxjEkV280VmxvT3egQySbr7H7GUESTThGubsfCeCuG54K4Za
         pURSSR7eLuK5tZTszEW9q3tgy1VlGS1u3QIVp3Bb7cJiF7/3xXTuJ8pFN73AKuWptvBy
         3PLSrqb9df0NlzryfXqbhFrIjSyLZ7PrraMXCi57sJ896yKWJMMnGK2D1/ELkcfCUD9y
         Z7LA==
X-Gm-Message-State: APjAAAWSQcJpngwQBE9Q1g4h4nyZuSflbDjwPkKWRSDT2LocmQ8ytcs+
        mEqrxIYS9kGwTVwnQKOegyIrFp1doxriVQ==
X-Google-Smtp-Source: APXvYqxhKWEnVXb9uNgMH0ccj67hplllcBxU8qLWi6otc+aJBU3R1YePhnX6ZV3aGjhqiKDY3OCFzA==
X-Received: by 2002:aa7:86c8:: with SMTP id h8mr5040661pfo.241.1567549739346;
        Tue, 03 Sep 2019 15:28:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 12/19] ionic: Add Rx filter and rx_mode ndo support
Date:   Tue,  3 Sep 2019 15:28:14 -0700
Message-Id: <20190903222821.46161-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Rx filtering and rx_mode NDO callbacks.  Also add
the deferred work thread handling needed to manage the filter
requests outside of the netif_addr_lock spinlock.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 400 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  29 ++
 2 files changed, 423 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2a3f11962bd1..4bbccb8eaf35 100644
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
@@ -399,6 +445,238 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
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
@@ -587,8 +865,28 @@ static int ionic_set_features(struct net_device *netdev,
 
 static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
-	return 0;
+	struct sockaddr *addr = sa;
+	u8 *mac;
+	int err;
+
+	mac = (u8 *)addr->sa_data;
+	if (ether_addr_equal(netdev->dev_addr, mac))
+		return 0;
+
+	err = eth_prepare_mac_addr_change(netdev, addr);
+	if (err)
+		return err;
+
+	if (!is_zero_ether_addr(netdev->dev_addr)) {
+		netdev_info(netdev, "deleting mac addr %pM\n",
+			    netdev->dev_addr);
+		ionic_addr_del(netdev, netdev->dev_addr);
+	}
+
+	eth_commit_mac_addr_change(netdev, addr);
+	netdev_info(netdev, "updating mac addr %pM\n", mac);
+
+	return ionic_addr_add(netdev, mac);
 }
 
 static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
@@ -623,15 +921,57 @@ static void ionic_tx_timeout(struct net_device *netdev)
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
@@ -667,6 +1007,7 @@ int ionic_stop(struct net_device *netdev)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
 	.ndo_set_mac_address	= ionic_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -733,6 +1074,10 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	spin_lock_init(&lif->adminq_lock);
 
+	spin_lock_init(&lif->deferred.lock);
+	INIT_LIST_HEAD(&lif->deferred.list);
+	INIT_WORK(&lif->deferred.work, ionic_lif_deferred_work);
+
 	/* allocate lif info */
 	lif->info_sz = ALIGN(sizeof(*lif->info), PAGE_SIZE);
 	lif->info = dma_alloc_coherent(dev, lif->info_sz,
@@ -952,6 +1297,44 @@ static int ionic_lif_notifyq_init(struct ionic_lif *lif)
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
+	struct sockaddr addr;
+	int err;
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
+	addr.sa_family = AF_INET;
+	err = eth_prepare_mac_addr_change(netdev, &addr);
+	if (err)
+		return err;
+
+	if (!is_zero_ether_addr(netdev->dev_addr)) {
+		netdev_dbg(lif->netdev, "deleting station MAC addr %pM\n",
+			   netdev->dev_addr);
+		ionic_lif_addr(lif, netdev->dev_addr, false);
+	}
+
+	eth_commit_mac_addr_change(netdev, &addr);
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
@@ -1015,6 +1398,10 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	err = ionic_station_set(lif);
+	if (err)
+		goto err_out_notifyq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
@@ -1071,6 +1458,7 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
 	 */
+	cancel_work_sync(&ionic->master_lif->deferred.work);
 	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(ionic->master_lif->netdev);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 53fb4c71a101..7da7d4a3fdf0 100644
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

