Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CE62980
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404150AbfGHT0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:26:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45610 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404134AbfGHTZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so8046561pfq.12
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=JTz6lvB5KE5WfaxsLM5MzGsLVamXWXY3XPl8jHJjruE=;
        b=sHCuE2VAyMTNR0DfHhc667NVqWOqMP7CilQEATDpM22hOamZHwuqLhDSxlqwzkFmk1
         QMc/VUE1UCurwuRqEOuA/k1G43VmBvTBredtBPma1rRR/W7T9WoRSnQEYesGOViI8H14
         t1Ay/iirDZw1ou9+Po+RB59EQRmgbWV2r+axpFkpxj55QPCzS0Q5Ld9ISC7v5MHUvZEY
         SNxhpZMvVvkfrIioD/9b86TUnTpjwwLLbSlV2Fb9Q2TSvf+CKkTMkFbSvGqH1BMa1Wum
         zR4EBw8MVgsHYvQCK58QynGBbs2LFAzI5sd4COFchpCu8tyn8P6BGIbJzoY1YEgWjPy+
         u6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=JTz6lvB5KE5WfaxsLM5MzGsLVamXWXY3XPl8jHJjruE=;
        b=RkwrvuwDLh8p+iIgijOXh6R/dsXX6FYs/qKutVS59JVTFpL2SVWvzh8TYLtIAvZyQX
         r9K7X0wAj51MbL6FmGJ/GEIFVddni3QO4RnUWvLUApO5LM/kHItLoxqn8aQn1qm8Eqj1
         27+CbJwb8yWq2kxo+qLNPlpOkVyCcW9F6YLMbVbSUwO2//f2+nWPFDFFN1083MTJrWmr
         fbuCHPEwPsRsmleTsFk30MiEVJIz+hGFmY+2LjPS5ycMtNhYkpV1eiyU+T7aXnCr6cA8
         KrFp4euOyXZj41MmAj9tqt5gJkJIiUcD173fMvrXDxgXKeRDtAeC8+msU1WcCSL/81vo
         OQTg==
X-Gm-Message-State: APjAAAWwN/NRlURheUwstY6UeCuK360ZnxA5xTUhI/kvGp695B/gcjAc
        AHS6HjUqq6H2rmIm7YsmVvhS7A==
X-Google-Smtp-Source: APXvYqy9nveTEevwOfTnXr2nB4CXCNJOKaqygO3J7TFsGKkeVy1qRKXDIE7IVtECcOITJnuz3nagUA==
X-Received: by 2002:a63:2c8:: with SMTP id 191mr25537632pgc.139.1562613956441;
        Mon, 08 Jul 2019 12:25:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 18/19] ionic: Add coalesce and other features
Date:   Mon,  8 Jul 2019 12:25:31 -0700
Message-Id: <20190708192532.27420-19-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708192532.27420-1-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
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
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  13 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 4 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 9b720187b549..cd08166f73a9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -11,7 +11,7 @@ struct lif;
 
 #define DRV_NAME		"ionic"
 #define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
-#define DRV_VERSION		"0.11.0-k"
+#define DRV_VERSION		"0.11.0-44-k"
 
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 403882a5e09e..7e46b5d7cd65 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -383,6 +383,75 @@ static int ionic_get_coalesce(struct net_device *netdev,
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
@@ -570,6 +639,39 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
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
 
@@ -655,6 +757,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= ionic_get_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
+	.set_coalesce		= ionic_set_coalesce,
 	.get_ringparam		= ionic_get_ringparam,
 	.set_ringparam		= ionic_set_ringparam,
 	.get_channels		= ionic_get_channels,
@@ -669,6 +772,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.set_rxfh		= ionic_set_rxfh,
 	.get_priv_flags		= ionic_get_priv_flags,
 	.set_priv_flags		= ionic_set_priv_flags,
+	.get_tunable		= ionic_get_tunable,
+	.set_tunable		= ionic_set_tunable,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 68a9975e34c6..8473b065763b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -744,9 +744,19 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
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
@@ -2009,6 +2019,7 @@ static int ionic_lif_init(struct lif *lif)
 
 	ionic_link_status_check(lif);
 
+	INIT_WORK(&lif->tx_timeout_work, ionic_tx_timeout_work);
 	return 0;
 
 err_out_notifyq_deinit:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 0e6908f959f2..76cc519acd5a 100644
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

