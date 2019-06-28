Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35205A675
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfF1VkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:40:05 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42389 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfF1VkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:40:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id k13so3135664pgq.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=bgeNNBwJbSa2L8N5cezraYXk/56g+qVETLUvEo95yAs=;
        b=Mult6dtB7+tAst9vGT3hxPXA0z3TEAgzbrAyMVpiN1uFS2aCkEdp3zFhGly7MBgM+l
         IUwx4mWL9Aon+m5zjUBcoBK4r70tffpsyIwk2BxrqdMrjrt5LyrsbADwhBq70CFONyAs
         d4e/xgNWD0cnmXeY32HTV2y0c3LGy3cn8FlJK+SkuG8OQKlseaPafsRs8BC78Ql7aeNV
         jGfKWKAIR/0Le8kkQM6aFQs3ARUkLOiWU/4BIGQkYHzhLI/Fnb84AS3ToK1mnawgjBNl
         pGLQCZ5KUkMY/93NmKdXBoliiBKg2DKbmsQ8DFQNvD4mylnhq5/qibnJjhJKYBlWaoV4
         GfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=bgeNNBwJbSa2L8N5cezraYXk/56g+qVETLUvEo95yAs=;
        b=DQ06zked5GBSWKMNvl2oTibCR/WpT9I+OzXHZZ7s+PYFRNAwS0G1suYapZqCBipAXz
         wz7y6vCBJWzeRAWhnYAKcbBxV1lTp3UQb8zzw/cYVd2xLvgH8kpjYxbuygvll+HYhThT
         5/KB6uJ2R1AMTjO1VpfiTURf9bcMW82bMKx2ZUtnGkBaMJNGs914w4OqSv7DsMhQlowS
         ziIL1gbJETJNSSuvfHz6IRIBUnKmz45Ho6OEf6mJWcBEgMjVp1CuJl5H0UuG0qfIqOwm
         unVZpKi5sUMyqjN15fNSw0ts0qMqz14k3dqF2LxQ9rDbRyGDGNu52cpSfcvx7FnxEyl9
         HdWA==
X-Gm-Message-State: APjAAAX9nR48G2DmpsMoPPtNBs7618oPG3LjaK+CIMZhnD59gO2553gz
        ujYAx41TKJUUVu/kftAjqcFOSA==
X-Google-Smtp-Source: APXvYqwgolkF6KphOwfNhIvVpQ77m3pG8GVmZPsWJaPnAplAg3eiHgz+lQhi+3Qfy1H7WqPaqR14aA==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr15529954pji.136.1561758001890;
        Fri, 28 Jun 2019 14:40:01 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.40.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:40:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 18/19] ionic: Add coalesce and other features
Date:   Fri, 28 Jun 2019 14:39:33 -0700
Message-Id: <20190628213934.8810-19-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
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
index cd4c0651096a..86ff65f2f195 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -391,6 +391,75 @@ static int ionic_get_coalesce(struct net_device *netdev,
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
@@ -578,6 +647,39 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
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
 
@@ -663,6 +765,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= ionic_get_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
+	.set_coalesce		= ionic_set_coalesce,
 	.get_ringparam		= ionic_get_ringparam,
 	.set_ringparam		= ionic_set_ringparam,
 	.get_channels		= ionic_get_channels,
@@ -677,6 +780,8 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.set_rxfh		= ionic_set_rxfh,
 	.get_priv_flags		= ionic_get_priv_flags,
 	.set_priv_flags		= ionic_set_priv_flags,
+	.get_tunable		= ionic_get_tunable,
+	.set_tunable		= ionic_set_tunable,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 42c0827255a5..c541076eac1d 100644
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
@@ -2013,6 +2023,7 @@ static int ionic_lif_init(struct lif *lif)
 
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

