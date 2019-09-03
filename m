Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24BA7700
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfICW3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44384 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfICW3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id q21so6760574pfn.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=GZB2Wvvxj7/nrxJfuCXYnM2r6nCrKlFTo7yR71ALuP0=;
        b=qdVZuS2PygAmxE1W5ul+T9PCYZ+36i1ryW84jYeiXW0ZdgBsVfUa1q/gO5Ss841MDw
         4dTOKCBCwMsxC8Ui7undZRCKmFd88+k7up9Wf7+kA+G0MTT43qtkXG3lBrdcwomq2rK+
         QEh5CoAkBuGfubqTZB0aWbkgsiqVviURicoobXnlfLbg/y2kR9VXLhgUpyGCbuKSHQo6
         cJSKcDLHGurCU9F3eKTrOm3Zr/i4qQsABux5n93tfuRtA+1kCe9HotY0VNqTGJx/RTtv
         e2NUHBtoR5HHdS0XFq1uewEk7WECfD97lkSs1MOPggLYM1lVGS099rJ0ifAUudVzTtzd
         pIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=GZB2Wvvxj7/nrxJfuCXYnM2r6nCrKlFTo7yR71ALuP0=;
        b=c/yqzBUyL352X+gu5sRg1s3c5CcFpE9lZHiEirdgY+XogTtWtHzed90+a8w3HZcS66
         1/VZQaVBiK7YbfiPk2nuQ1BgF6YjoUJIYT1P/PlHVm6m/5ypEHcKa0GUWA40OZS0GG+S
         CEbIJPodvevouPghcIDqJa1x8jNL7Zt6B5KJocCGIX4k/pcyVefTWQPwL9UstuISXa5J
         okrxSWvz75AqbSOeRPJ9h5tT03Ekevbj4Ep1/t30nUifaYfp4h2xpKSPAIecQiJCjdt4
         l2EDgoJRWT5jU97k1rTg3PrjOCcZBxPouisoNEOZDZqU0BYyH4rTs8U1QcBCNvndGzeY
         7ViQ==
X-Gm-Message-State: APjAAAU87ps+5MHJCFb9M0Y/wYJV4GYwE4Ay6m5mFwPwI2/D6Ntqyb8J
        RJZDjaFz4mcVLd8AiVz2vYHoVg==
X-Google-Smtp-Source: APXvYqxcATYkM73/SXIuu3hM2ElrpkLvpof4ta7duquvxpZ3nmmRGiYWJVxGpe6+uqo2aPMeGn/h0Q==
X-Received: by 2002:a62:8142:: with SMTP id t63mr5418997pfd.246.1567549747020;
        Tue, 03 Sep 2019 15:29:07 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.29.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:29:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 19/19] ionic: Add coalesce and other features
Date:   Tue,  3 Sep 2019 15:28:21 -0700
Message-Id: <20190903222821.46161-20-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupt coalescing, tunable copybreak value, and
tx timeout.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   1 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 108 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  28 ++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  30 +++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   2 -
 5 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index d26752e23912..9610aeb7d5f4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -16,6 +16,7 @@
 #define IONIC_MIN_TXRX_DESC		16
 #define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
+#define IONIC_ITR_COAL_USEC_DEFAULT	64
 
 #define IONIC_DEV_CMD_REG_VERSION	1
 #define IONIC_DEV_INFO_REG_COUNT	32
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 321b0543f2f8..7d10265f782a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -365,6 +365,78 @@ static int ionic_get_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_set_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *coalesce)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_identity *ident;
+	struct ionic_qcq *qcq;
+	unsigned int i;
+	u32 usecs;
+	u32 coal;
+
+	if (coalesce->rx_max_coalesced_frames ||
+	    coalesce->rx_coalesce_usecs_irq ||
+	    coalesce->rx_max_coalesced_frames_irq ||
+	    coalesce->tx_max_coalesced_frames ||
+	    coalesce->tx_coalesce_usecs_irq ||
+	    coalesce->tx_max_coalesced_frames_irq ||
+	    coalesce->stats_block_coalesce_usecs ||
+	    coalesce->use_adaptive_rx_coalesce ||
+	    coalesce->use_adaptive_tx_coalesce ||
+	    coalesce->pkt_rate_low ||
+	    coalesce->rx_coalesce_usecs_low ||
+	    coalesce->rx_max_coalesced_frames_low ||
+	    coalesce->tx_coalesce_usecs_low ||
+	    coalesce->tx_max_coalesced_frames_low ||
+	    coalesce->pkt_rate_high ||
+	    coalesce->rx_coalesce_usecs_high ||
+	    coalesce->rx_max_coalesced_frames_high ||
+	    coalesce->tx_coalesce_usecs_high ||
+	    coalesce->tx_max_coalesced_frames_high ||
+	    coalesce->rate_sample_interval)
+		return -EINVAL;
+
+	ident = &lif->ionic->ident;
+	if (ident->dev.intr_coal_div == 0) {
+		netdev_warn(netdev, "bad HW value in dev.intr_coal_div = %d\n",
+			    ident->dev.intr_coal_div);
+		return -EIO;
+	}
+
+	/* Tx uses Rx interrupt, so only change Rx */
+	if (coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs) {
+		netdev_warn(netdev, "only the rx-usecs can be changed\n");
+		return -EINVAL;
+	}
+
+	coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->rx_coalesce_usecs);
+
+	if (coal > IONIC_INTR_CTRL_COAL_MAX)
+		return -ERANGE;
+
+	/* If they asked for non-zero and it resolved to zero, bump it up */
+	if (!coal && coalesce->rx_coalesce_usecs)
+		coal = 1;
+
+	/* Convert it back to get device resolution */
+	usecs = ionic_coal_hw_to_usec(lif->ionic, coal);
+
+	if (usecs != lif->rx_coalesce_usecs) {
+		lif->rx_coalesce_usecs = usecs;
+
+		if (test_bit(IONIC_LIF_UP, lif->state)) {
+			for (i = 0; i < lif->nxqs; i++) {
+				qcq = lif->rxqcqs[i].qcq;
+				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+						     qcq->intr.index, coal);
+			}
+		}
+	}
+
+	return 0;
+}
+
 static void ionic_get_ringparam(struct net_device *netdev,
 				struct ethtool_ringparam *ring)
 {
@@ -550,6 +622,39 @@ static int ionic_set_rxfh(struct net_device *netdev, const u32 *indir,
 	return 0;
 }
 
+static int ionic_set_tunable(struct net_device *dev,
+			     const struct ethtool_tunable *tuna,
+			     const void *data)
+{
+	struct ionic_lif *lif = netdev_priv(dev);
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		lif->rx_copybreak = *(u32 *)data;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int ionic_get_tunable(struct net_device *netdev,
+			     const struct ethtool_tunable *tuna, void *data)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)data = lif->rx_copybreak;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int ionic_get_module_info(struct net_device *netdev,
 				 struct ethtool_modinfo *modinfo)
 
@@ -643,6 +748,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= ionic_get_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
+	.set_coalesce		= ionic_set_coalesce,
 	.get_ringparam		= ionic_get_ringparam,
 	.set_ringparam		= ionic_set_ringparam,
 	.get_channels		= ionic_get_channels,
@@ -657,6 +763,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_rxfh_key_size	= ionic_get_rxfh_key_size,
 	.get_rxfh		= ionic_get_rxfh,
 	.set_rxfh		= ionic_set_rxfh,
+	.get_tunable		= ionic_get_tunable,
+	.set_tunable		= ionic_set_tunable,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 966a81006528..db7c82742828 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3,6 +3,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/cpumask.h>
@@ -1254,9 +1255,22 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
+static void ionic_tx_timeout_work(struct work_struct *ws)
+{
+	struct ionic_lif *lif = container_of(ws, struct ionic_lif, tx_timeout_work);
+
+	netdev_info(lif->netdev, "Tx Timeout recovery\n");
+
+	rtnl_lock();
+	ionic_reset_queues(lif);
+	rtnl_unlock();
+}
+
 static void ionic_tx_timeout(struct net_device *netdev)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	schedule_work(&lif->tx_timeout_work);
 }
 
 static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
@@ -1416,6 +1430,7 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 	unsigned int flags;
 	unsigned int i;
 	int err = 0;
+	u32 coal;
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
 	for (i = 0; i < lif->nxqs; i++) {
@@ -1432,6 +1447,7 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 	}
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_INTR;
+	coal = ionic_coal_usec_to_hw(lif->ionic, lif->rx_coalesce_usecs);
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 				      lif->nrxq_descs,
@@ -1443,6 +1459,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 
 		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
 
+		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+				     lif->rxqcqs[i].qcq->intr.index, coal);
 		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
 					  lif->txqcqs[i].qcq);
 	}
@@ -1621,6 +1639,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	struct net_device *netdev;
 	struct ionic_lif *lif;
 	int tbl_sz;
+	u32 coal;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1650,6 +1669,10 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
 
+	/* Convert the default coalesce value to actual hw resolution */
+	coal = ionic_coal_usec_to_hw(lif->ionic, IONIC_ITR_COAL_USEC_DEFAULT);
+	lif->rx_coalesce_usecs = ionic_coal_hw_to_usec(lif->ionic, coal);
+
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
 	spin_lock_init(&lif->adminq_lock);
@@ -2007,6 +2030,8 @@ static int ionic_lif_init(struct ionic_lif *lif)
 
 	set_bit(IONIC_LIF_INITED, lif->state);
 
+	INIT_WORK(&lif->tx_timeout_work, ionic_tx_timeout_work);
+
 	return 0;
 
 err_out_notifyq_deinit:
@@ -2125,6 +2150,7 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * ionic->lif for candidates to unregister
 	 */
 	cancel_work_sync(&ionic->master_lif->deferred.work);
+	cancel_work_sync(&ionic->master_lif->tx_timeout_work);
 	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(ionic->master_lif->netdev);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 2e931a704565..812190e729c2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -177,6 +177,7 @@ struct ionic_lif {
 	struct dentry *dentry;
 	u32 rx_coalesce_usecs;
 	u32 flags;
+	struct work_struct tx_timeout_work;
 };
 
 #define lif_to_txqcq(lif, i)	((lif)->txqcqs[i].qcq)
@@ -195,6 +196,35 @@ static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
 	return test_bit(bitname, lif->state);
 }
 
+static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
+{
+	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
+	u32 div = le32_to_cpu(ionic->ident.dev.intr_coal_div);
+
+	/* Div-by-zero should never be an issue, but check anyway */
+	if (!div || !mult)
+		return 0;
+
+	/* Round up in case usecs is close to the next hw unit */
+	usecs += (div / mult) >> 1;
+
+	/* Convert from usecs to device units */
+	return (usecs * mult) / div;
+}
+
+static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
+{
+	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
+	u32 div = le32_to_cpu(ionic->ident.dev.intr_coal_div);
+
+	/* Div-by-zero should never be an issue, but check anyway */
+	if (!div || !mult)
+		return 0;
+
+	/* Convert from device units to usec */
+	return (units * div) / mult;
+}
+
 int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 470316735762..ab6663d94f42 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -289,11 +289,9 @@ void ionic_rx_empty(struct ionic_queue *q)
 
 	for (cur = q->tail; cur != q->head; cur = cur->next) {
 		desc = cur->desc;
-
 		dma_unmap_single(dev, le64_to_cpu(desc->addr),
 				 le16_to_cpu(desc->len), DMA_FROM_DEVICE);
 		dev_kfree_skb(cur->cb_arg);
-
 		cur->cb_arg = NULL;
 	}
 }
-- 
2.17.1

