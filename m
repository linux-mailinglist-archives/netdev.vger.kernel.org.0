Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707144DB28
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfFTUY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:58 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34926 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfFTUYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id p1so1848912plo.2
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=adiQkJ2yboNbCHEFLGjQkxDbDdUNkpMPejJipbVwCD0=;
        b=Q5rTTyUrXw67cVJdNx2m4lAQYeLTNLErNsO35+KqM8n1CD3LcZU6EO3ydBZ8dxK7jU
         zzhkkA/sKn4KOXSaACDQRQ3nOXbGJVUbTkfjFCIx8zFNRZQSbPbkEWrUb7ag1jCVqq34
         +Su6wCjOXcuPHXU4S6gJ5dxAMTU/7wmAe8AiqND5l3jH4uqUuZBuDhjKemoAXnd0CB8L
         QCDHDiu5arGTi2nsHGZYcRozS+QDYNrIVanniNuqFmp7BJPsf14UxbeqmMRFaH9IR3T1
         GVJvOz/67242StyZZicI2nnk+SJEvjOIxaVXAjNIq14N4HBxrQNVtEmlrOK/66vvaQaN
         qhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=adiQkJ2yboNbCHEFLGjQkxDbDdUNkpMPejJipbVwCD0=;
        b=YiIHSE6t3jYkFEQvQhoiJYUsHKbJTYxMuzzR2GKCxgNL5Mm+q9GqzvrUu0DaneFGkR
         EB3CDGw8SadzsEBARlGvZPHZRMnIvRyUdO3dhuMNTiZcBXQ/GLfe7agQU+HAFoLPSfj6
         vjabUGbaLF3oLlcQMJSTpf8hdMFg88D0+vektqrM9ItkC73+A00P72yfar2Cg7yPvSG6
         SigtgbulKLCElKV2sD19DdKtjsrVyDHZMNbpHyhwDqC64nyOrwPHhsjKd6mNeTbQGSr4
         6W04e8Hh6kuKZecemHTzvEBm3hLAeSGQRvCHLxwBO72m1PawszfePHOoYkuieOXGqATu
         auZg==
X-Gm-Message-State: APjAAAXSHx0X52lkHEplq20OrHPqAq279i4/ChsCZEtsx16W0hdQYCZx
        ESoZwlJVzY6ToQ3/UahGXM2Dug==
X-Google-Smtp-Source: APXvYqwHtPGHF7hqJuKCwjCjKbEcY5imv/qvcq7SjoZLcoj37yrNnIhZfmvzovda0nPrqj7xlJR6lw==
X-Received: by 2002:a17:902:e582:: with SMTP id cl2mr112057965plb.60.1561062287273;
        Thu, 20 Jun 2019 13:24:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 18/18] ionic: Add coalesce and other features
Date:   Thu, 20 Jun 2019 13:24:24 -0700
Message-Id: <20190620202424.23215-19-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupt coalescing, tunable copybreak value, and
tx timeout.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   2 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 105 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  18 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 4 files changed, 124 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 12f30427ea91..ae4b027d1373 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -11,7 +11,7 @@ struct lif;
 
 #define DRV_NAME		"ionic"
 #define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
-#define DRV_VERSION		"0.11.0-k"
+#define DRV_VERSION		"0.11.0-44-k"
 
 // TODO: register these with the official include/linux/pci_ids.h
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 2439c9beb6ae..8c046fc069d9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -402,6 +402,75 @@ static int ionic_get_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_set_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *coalesce)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct identity *ident = &lif->ionic->ident;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	u32 tx_coal, rx_coal;
+	struct qcq *qcq;
+	unsigned int i;
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
+	if (ident->dev.intr_coal_div == 0)
+		return -EIO;
+
+	/* Convert from usecs to device units */
+	tx_coal = coalesce->tx_coalesce_usecs *
+		  le32_to_cpu(ident->dev.intr_coal_mult) /
+		  le32_to_cpu(ident->dev.intr_coal_div);
+	rx_coal = coalesce->rx_coalesce_usecs *
+		  le32_to_cpu(ident->dev.intr_coal_mult) /
+		  le32_to_cpu(ident->dev.intr_coal_div);
+
+	if (tx_coal > INTR_CTRL_COAL_MAX || rx_coal > INTR_CTRL_COAL_MAX)
+		return -ERANGE;
+
+	if (coalesce->tx_coalesce_usecs != lif->tx_coalesce_usecs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			qcq = lif->txqcqs[i].qcq;
+			ionic_intr_coal_init(idev->intr_ctrl,
+					     qcq->intr.index,
+					     tx_coal);
+		}
+		lif->tx_coalesce_usecs = coalesce->tx_coalesce_usecs;
+	}
+
+	if (coalesce->rx_coalesce_usecs != lif->rx_coalesce_usecs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			qcq = lif->rxqcqs[i].qcq;
+			ionic_intr_coal_init(idev->intr_ctrl,
+					     qcq->intr.index,
+					     rx_coal);
+		}
+		lif->rx_coalesce_usecs = coalesce->rx_coalesce_usecs;
+	}
+
+	return 0;
+}
+
 static void ionic_get_ringparam(struct net_device *netdev,
 				struct ethtool_ringparam *ring)
 {
@@ -601,6 +670,39 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	return 0;
 }
 
+static int ionic_set_tunable(struct net_device *dev,
+			     const struct ethtool_tunable *tuna,
+			     const void *data)
+{
+	struct lif *lif = netdev_priv(dev);
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
+	struct lif *lif = netdev_priv(netdev);
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
 
@@ -687,6 +789,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= ionic_get_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
+	.set_coalesce		= ionic_set_coalesce,
 	.get_ringparam		= ionic_get_ringparam,
 	.set_ringparam		= ionic_set_ringparam,
 	.get_channels		= ionic_get_channels,
@@ -701,6 +804,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.set_rxfh		= ionic_set_rxfh,
 	.get_priv_flags		= ionic_get_priv_flags,
 	.set_priv_flags		= ionic_set_priv_flags,
+	.get_tunable		= ionic_get_tunable,
+	.set_tunable		= ionic_set_tunable,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6710e36794b9..8cbbb0106fcf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -743,6 +743,11 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EINVAL;
 	}
 
+	if (ionic_is_mnic(lif->ionic)) {
+		netdev_err(netdev, "MTU change not allowed on mnic device\n");
+		return -EOPNOTSUPP;
+	}
+
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
@@ -753,9 +758,19 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
+static void ionic_tx_timeout_work(struct work_struct *ws)
+{
+	struct lif *lif = container_of(ws, struct lif, tx_timeout_work);
+
+	netdev_info(lif->netdev, "Tx Timeout recovery\n");
+	ionic_reset_queues(lif);
+}
+
 static void ionic_tx_timeout(struct net_device *netdev)
 {
-	netdev_info(netdev, "%s: stubbed\n", __func__);
+	struct lif *lif = netdev_priv(netdev);
+
+	schedule_work(&lif->tx_timeout_work);
 }
 
 static int ionic_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
@@ -2046,6 +2061,7 @@ static int ionic_lif_init(struct lif *lif)
 
 	ionic_link_status_check(lif);
 
+	INIT_WORK(&lif->tx_timeout_work, ionic_tx_timeout_work);
 	return 0;
 
 err_out_notifyq_deinit:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 220955ee7259..5b6818a47f0e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -180,6 +180,7 @@ struct lif {
 	unsigned int dbid_count;
 	struct dentry *dentry;
 	u32 flags;
+	struct work_struct tx_timeout_work;
 };
 
 #define lif_to_txqcq(lif, i)	((lif)->txqcqs[i].qcq)
-- 
2.17.1

