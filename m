Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8BD5A767
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfF1XHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:07:53 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38540 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:07:53 -0400
Received: by mail-pg1-f202.google.com with SMTP id 3so3903620pgc.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FedepCcanBgqbhMA/dtNMMvvTcUUTYu37UewXWYPGWY=;
        b=tFKg7yt7JN9UhpG2k8j7oBxFtWK8OmEwziNGZogt3vxcWRSq5aj+Bl2VjXxNS3Kxvj
         fCJkYhCtUUlXbbBYyXWjhyuIqVZzCbfCB3w9DI+PbRklEkb/hSr85aAQcjMd5OcXOfMM
         ZhwvgiEd3vmYw4TyYE5jovGH7b8PIeZ6IDJd1pRt9+mfRdlt1EJGqPPXlU6a2Z9Um1+d
         T1+MQJEwR4Y1U7kvJUlkn6UlMVMVAmR31VQlpkFsqVoopn+dVC9OSjc1VxThp3UcnckM
         n7I5J/24OOp1vzZa2DaiPK8G5X2ZKD5vTdZ4DRvuYkQdaOoPw7f7XLEHFKzmqq3gCbMz
         6qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FedepCcanBgqbhMA/dtNMMvvTcUUTYu37UewXWYPGWY=;
        b=uWlqPuPV3ND+b8Djfh5E2PqlJE9GkgEgyqnMnud03hb5h6HXTOShB0GKndAbQ8oIKU
         S+lGEjjCzkGebvYRvqKQI3h+roPaFf08Xp5L2tg0kdrlJGmip9r00zdRjhm6oAbS4+fS
         wJPlPHPs0cKIABqPcav8eqbizAL3SlJziDXDYl6DBW5UUKLMNZneWRsI7a5uGULGTSXA
         xGFTlgDqKY4wtezGoZEUNGUr16Fazy/cu8V8kGDo6zqrxwNr9iZ0kDpp0Z4SO1nf6F9U
         YHkZ4D54dNrY86C6HRaKLtNbJNC7FvJKB0VpaR+rWXcPGZ7YzjJglrvD9qwRCLdz1gMP
         6rSQ==
X-Gm-Message-State: APjAAAXkCCiyXocUlZ6lbqMfiv7YC8gJGNflQ84Ttl538ifOIWrk5Qnj
        gDKIUk1bn3VX/keuoIdJNC12XS09+c8QodkWS/PJlTJImdBxGpGTHN8vDFAueoyaHWZhHK6BDVm
        dGDhPSsNnzN17sDAfBHsrVfhOFu5JbhOJM06HlakeCRICt9xJ8wBKcdOnLgj1hQ==
X-Google-Smtp-Source: APXvYqzq6Xpw87uE9WP+1h/wQ/HfILLThYpMUNeOGXB6YPvroXLBhyyRLWv+26CQm4Qfz/EGE5gZoQTXPr8=
X-Received: by 2002:a63:ed13:: with SMTP id d19mr11556493pgi.100.1561763272042;
 Fri, 28 Jun 2019 16:07:52 -0700 (PDT)
Date:   Fri, 28 Jun 2019 16:07:33 -0700
In-Reply-To: <20190628230733.54169-1-csully@google.com>
Message-Id: <20190628230733.54169-5-csully@google.com>
Mime-Version: 1.0
References: <20190628230733.54169-1-csully@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v3 4/4] gve: Add ethtool support
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following ethtool commands:

ethtool -s|--change devname [msglvl N] [msglevel type on|off]
ethtool -S|--statistics devname
ethtool -i|--driver devname
ethtool -l|--show-channels devname
ethtool -L|--set-channels devname
ethtool -g|--show-ring devname
ethtool --reset devname

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Jon Olson <jonolson@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/Makefile      |   2 +-
 drivers/net/ethernet/google/gve/gve.h         |   4 +
 drivers/net/ethernet/google/gve/gve_ethtool.c | 232 ++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_main.c    |  39 +++
 4 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/google/gve/gve_ethtool.c

diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
index a1890c93705b..3354ce40eb97 100644
--- a/drivers/net/ethernet/google/gve/Makefile
+++ b/drivers/net/ethernet/google/gve/Makefile
@@ -1,4 +1,4 @@
 # Makefile for the Google virtual Ethernet (gve) driver
 
 obj-$(CONFIG_GVE) += gve.o
-gve-objs := gve_main.o gve_tx.o gve_rx.o gve_adminq.o
+gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index b7cc23b06284..c765f718dc4a 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -449,4 +449,8 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown);
 int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_rx_config,
 		      struct gve_queue_config new_tx_config);
+/* exported by ethtool.c */
+extern const struct ethtool_ops gve_ethtool_ops;
+/* needed by ethtool */
+extern const char gve_version_str[];
 #endif /* _GVE_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
new file mode 100644
index 000000000000..52bf593f1210
--- /dev/null
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Google virtual Ethernet (gve) driver
+ *
+ * Copyright (C) 2015-2019 Google, Inc.
+ */
+
+#include <linux/rtnetlink.h>
+#include "gve.h"
+
+static void gve_get_drvinfo(struct net_device *netdev,
+			    struct ethtool_drvinfo *info)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	strlcpy(info->driver, "gve", sizeof(info->driver));
+	strlcpy(info->version, gve_version_str, sizeof(info->version));
+	strlcpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
+}
+
+static void gve_set_msglevel(struct net_device *netdev, u32 value)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	priv->msg_enable = value;
+}
+
+static u32 gve_get_msglevel(struct net_device *netdev)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	return priv->msg_enable;
+}
+
+static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets", "tx_packets", "rx_bytes", "tx_bytes",
+	"rx_dropped", "tx_dropped", "tx_timeouts",
+};
+
+#define GVE_MAIN_STATS_LEN  ARRAY_SIZE(gve_gstrings_main_stats)
+#define NUM_GVE_TX_CNTS	5
+#define NUM_GVE_RX_CNTS	2
+
+static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	char *s = (char *)data;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	memcpy(s, *gve_gstrings_main_stats,
+	       sizeof(gve_gstrings_main_stats));
+	s += sizeof(gve_gstrings_main_stats);
+	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+		snprintf(s, ETH_GSTRING_LEN, "rx_desc_cnt[%u]", i);
+		s += ETH_GSTRING_LEN;
+		snprintf(s, ETH_GSTRING_LEN, "rx_desc_fill_cnt[%u]", i);
+		s += ETH_GSTRING_LEN;
+	}
+	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+		snprintf(s, ETH_GSTRING_LEN, "tx_req[%u]", i);
+		s += ETH_GSTRING_LEN;
+		snprintf(s, ETH_GSTRING_LEN, "tx_done[%u]", i);
+		s += ETH_GSTRING_LEN;
+		snprintf(s, ETH_GSTRING_LEN, "tx_wake[%u]", i);
+		s += ETH_GSTRING_LEN;
+		snprintf(s, ETH_GSTRING_LEN, "tx_stop[%u]", i);
+		s += ETH_GSTRING_LEN;
+		snprintf(s, ETH_GSTRING_LEN, "tx_event_counter[%u]", i);
+		s += ETH_GSTRING_LEN;
+	}
+}
+
+static int gve_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return GVE_MAIN_STATS_LEN +
+		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
+		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void
+gve_get_ethtool_stats(struct net_device *netdev,
+		      struct ethtool_stats *stats, u64 *data)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
+	int ring;
+	int i;
+
+	ASSERT_RTNL();
+
+	for (rx_pkts = 0, rx_bytes = 0, ring = 0;
+	     ring < priv->rx_cfg.num_queues; ring++) {
+		if (priv->rx) {
+			rx_pkts += priv->rx[ring].rpackets;
+			rx_bytes += priv->rx[ring].rbytes;
+		}
+	}
+	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
+	     ring < priv->tx_cfg.num_queues; ring++) {
+		if (priv->tx) {
+			tx_pkts += priv->tx[ring].pkt_done;
+			tx_bytes += priv->tx[ring].bytes_done;
+		}
+	}
+
+	i = 0;
+	data[i++] = rx_pkts;
+	data[i++] = tx_pkts;
+	data[i++] = rx_bytes;
+	data[i++] = tx_bytes;
+	/* Skip rx_dropped and tx_dropped */
+	i += 2;
+	data[i++] = priv->tx_timeo_cnt;
+	i = GVE_MAIN_STATS_LEN;
+
+	/* walk RX rings */
+	if (priv->rx) {
+		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
+			struct gve_rx_ring *rx = &priv->rx[ring];
+
+			data[i++] = rx->desc.cnt;
+			data[i++] = rx->desc.fill_cnt;
+		}
+	} else {
+		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
+	}
+	/* walk TX rings */
+	if (priv->tx) {
+		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
+			struct gve_tx_ring *tx = &priv->tx[ring];
+
+			data[i++] = tx->req;
+			data[i++] = tx->done;
+			data[i++] = tx->wake_queue;
+			data[i++] = tx->stop_queue;
+			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
+									  tx));
+		}
+	} else {
+		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
+	}
+}
+
+void gve_get_channels(struct net_device *netdev, struct ethtool_channels *cmd)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	cmd->max_rx = priv->rx_cfg.max_queues;
+	cmd->max_tx = priv->tx_cfg.max_queues;
+	cmd->max_other = 0;
+	cmd->max_combined = 0;
+	cmd->rx_count = priv->rx_cfg.num_queues;
+	cmd->tx_count = priv->tx_cfg.num_queues;
+	cmd->other_count = 0;
+	cmd->combined_count = 0;
+}
+
+int gve_set_channels(struct net_device *netdev, struct ethtool_channels *cmd)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	struct gve_queue_config new_tx_cfg = priv->tx_cfg;
+	struct gve_queue_config new_rx_cfg = priv->rx_cfg;
+	struct ethtool_channels old_settings;
+	int new_tx = cmd->tx_count;
+	int new_rx = cmd->rx_count;
+
+	gve_get_channels(netdev, &old_settings);
+
+	/* Changing combined is not allowed allowed */
+	if (cmd->combined_count != old_settings.combined_count)
+		return -EINVAL;
+
+	if (!new_rx || !new_tx)
+		return -EINVAL;
+
+	if (!netif_carrier_ok(netdev)) {
+		priv->tx_cfg.num_queues = new_tx;
+		priv->rx_cfg.num_queues = new_rx;
+		return 0;
+	}
+
+	new_tx_cfg.num_queues = new_tx;
+	new_rx_cfg.num_queues = new_rx;
+
+	return gve_adjust_queues(priv, new_rx_cfg, new_tx_cfg);
+}
+
+void gve_get_ringparam(struct net_device *netdev,
+		       struct ethtool_ringparam *cmd)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	cmd->rx_max_pending = priv->rx_desc_cnt;
+	cmd->tx_max_pending = priv->tx_desc_cnt;
+	cmd->rx_pending = priv->rx_desc_cnt;
+	cmd->tx_pending = priv->tx_desc_cnt;
+}
+
+int gve_user_reset(struct net_device *netdev, u32 *flags)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	if (*flags == ETH_RESET_ALL) {
+		*flags = 0;
+		return gve_reset(priv, true);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+const struct ethtool_ops gve_ethtool_ops = {
+	.get_drvinfo = gve_get_drvinfo,
+	.get_strings = gve_get_strings,
+	.get_sset_count = gve_get_sset_count,
+	.get_ethtool_stats = gve_get_ethtool_stats,
+	.set_msglevel = gve_set_msglevel,
+	.get_msglevel = gve_get_msglevel,
+	.set_channels = gve_set_channels,
+	.get_channels = gve_get_channels,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = gve_get_ringparam,
+	.reset = gve_user_reset,
+};
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index c1482924a80c..fce9a5f35c05 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -735,6 +735,44 @@ static int gve_close(struct net_device *dev)
 	return gve_reset_recovery(priv, false);
 }
 
+int gve_adjust_queues(struct gve_priv *priv,
+		      struct gve_queue_config new_rx_config,
+		      struct gve_queue_config new_tx_config)
+{
+	int err;
+
+	if (netif_carrier_ok(priv->dev)) {
+		/* To make this process as simple as possible we teardown the
+		 * device, set the new configuration, and then bring the device
+		 * up again.
+		 */
+		err = gve_close(priv->dev);
+		/* we have already tried to reset in close,
+		 * just fail at this point
+		 */
+		if (err)
+			return err;
+		priv->tx_cfg = new_tx_config;
+		priv->rx_cfg = new_rx_config;
+
+		err = gve_open(priv->dev);
+		if (err)
+			goto err;
+
+		return 0;
+	}
+	/* Set the config for the next up. */
+	priv->tx_cfg = new_tx_config;
+	priv->rx_cfg = new_rx_config;
+
+	return 0;
+err:
+	netif_err(priv, drv, priv->dev,
+		  "Adjust queues failed! !!! DISABLING ALL QUEUES !!!\n");
+	gve_turndown(priv);
+	return err;
+}
+
 static void gve_turndown(struct gve_priv *priv)
 {
 	int idx;
@@ -1071,6 +1109,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	pci_set_drvdata(pdev, dev);
+	dev->ethtool_ops = &gve_ethtool_ops;
 	dev->netdev_ops = &gve_netdev_ops;
 	/* advertise features */
 	dev->hw_features = NETIF_F_HIGHDMA;
-- 
2.22.0.410.gd8fdbe21b5-goog

