Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7032B082E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgKLPMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:12:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728227AbgKLPMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605193960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oHXRPQXPnLLvmVLhAXxnIvYMbvRr69LUOSbByqXKDMM=;
        b=GnUiK7LXD2JuF6lJRbVy/33Xi4Qj+12c7BgK9Dly7iFbKd+5hdte4hUbNjFb6spTn7T2jK
        BTvoRy9z048+1zgJwL9O2PK6o10NRGdRa9Mefk6FRtrj6TijrV5Pe3SaZwb+Onrj8/k6go
        K3ayVBXBmoZFAD0rTJGOhWDSBDDTdu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-8qsbEDZUNRaAs38Vmp1x6A-1; Thu, 12 Nov 2020 10:12:37 -0500
X-MC-Unique: 8qsbEDZUNRaAs38Vmp1x6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69D58186DD27;
        Thu, 12 Nov 2020 15:12:36 +0000 (UTC)
Received: from yoda.redhat.com (unknown [10.40.195.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 698195D9F7;
        Thu, 12 Nov 2020 15:12:35 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/1] netdevsim: support ethtool ring and coalesce settings
Date:   Thu, 12 Nov 2020 16:12:29 +0100
Message-Id: <20201112151229.1288504-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool ring and coalesce settings support for testing.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
---
 drivers/net/netdevsim/ethtool.c   | 65 +++++++++++++++++++++++++++----
 drivers/net/netdevsim/netdevsim.h |  9 ++++-
 2 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index f1884d90a876..25acd3bc1781 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -7,15 +7,18 @@
 
 #include "netdevsim.h"
 
+#define UINT32_MAX 0xFFFFFFFFU
+#define ETHTOOL_COALESCE_ALL_PARAMS UINT32_MAX
+
 static void
 nsim_get_pause_stats(struct net_device *dev,
 		     struct ethtool_pause_stats *pause_stats)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	if (ns->ethtool.report_stats_rx)
+	if (ns->ethtool.pauseparam.report_stats_rx)
 		pause_stats->rx_pause_frames = 1;
-	if (ns->ethtool.report_stats_tx)
+	if (ns->ethtool.pauseparam.report_stats_tx)
 		pause_stats->tx_pause_frames = 2;
 }
 
@@ -25,8 +28,8 @@ nsim_get_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 	struct netdevsim *ns = netdev_priv(dev);
 
 	pause->autoneg = 0; /* We don't support ksettings, so can't pretend */
-	pause->rx_pause = ns->ethtool.rx;
-	pause->tx_pause = ns->ethtool.tx;
+	pause->rx_pause = ns->ethtool.pauseparam.rx;
+	pause->tx_pause = ns->ethtool.pauseparam.tx;
 }
 
 static int
@@ -37,8 +40,39 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 	if (pause->autoneg)
 		return -EINVAL;
 
-	ns->ethtool.rx = pause->rx_pause;
-	ns->ethtool.tx = pause->tx_pause;
+	ns->ethtool.pauseparam.rx = pause->rx_pause;
+	ns->ethtool.pauseparam.tx = pause->tx_pause;
+	return 0;
+}
+
+static int nsim_get_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(coal, &ns->ethtool.coalesce, sizeof(ns->ethtool.coalesce));
+	return 0;
+}
+
+static int nsim_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(&ns->ethtool.coalesce, coal, sizeof(ns->ethtool.coalesce));
+	return 0;
+}
+
+static void nsim_get_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(ring, &ns->ethtool.ring, sizeof(ns->ethtool.ring));
+}
+
+static int nsim_set_ringparam(struct net_device *dev, struct ethtool_ringparam *ring)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
 	return 0;
 }
 
@@ -46,19 +80,34 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.get_pause_stats	= nsim_get_pause_stats,
 	.get_pauseparam		= nsim_get_pauseparam,
 	.set_pauseparam		= nsim_set_pauseparam,
+	.supported_coalesce_params = ETHTOOL_COALESCE_ALL_PARAMS,
+	.set_coalesce           = nsim_set_coalesce,
+	.get_coalesce           = nsim_get_coalesce,
+	.get_ringparam          = nsim_get_ringparam,
+	.set_ringparam          = nsim_set_ringparam,
 };
 
+static void nsim_ethtool_coalesce_init(struct netdevsim *ns)
+{
+	ns->ethtool.ring.rx_max_pending = UINT32_MAX;
+	ns->ethtool.ring.rx_jumbo_max_pending = UINT32_MAX;
+	ns->ethtool.ring.rx_mini_max_pending = UINT32_MAX;
+	ns->ethtool.ring.tx_max_pending = UINT32_MAX;
+}
+
 void nsim_ethtool_init(struct netdevsim *ns)
 {
 	struct dentry *ethtool, *dir;
 
 	ns->netdev->ethtool_ops = &nsim_ethtool_ops;
 
+	nsim_ethtool_coalesce_init(ns);
+
 	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev_port->ddir);
 
 	dir = debugfs_create_dir("pause", ethtool);
 	debugfs_create_bool("report_stats_rx", 0600, dir,
-			    &ns->ethtool.report_stats_rx);
+			    &ns->ethtool.pauseparam.report_stats_rx);
 	debugfs_create_bool("report_stats_tx", 0600, dir,
-			    &ns->ethtool.report_stats_tx);
+			    &ns->ethtool.pauseparam.report_stats_tx);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 827fc80f50a0..b023dc0a4259 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -15,6 +15,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -51,13 +52,19 @@ struct nsim_ipsec {
 	u32 ok;
 };
 
-struct nsim_ethtool {
+struct nsim_ethtool_pauseparam {
 	bool rx;
 	bool tx;
 	bool report_stats_rx;
 	bool report_stats_tx;
 };
 
+struct nsim_ethtool {
+	struct nsim_ethtool_pauseparam pauseparam;
+	struct ethtool_coalesce coalesce;
+	struct ethtool_ringparam ring;
+};
+
 struct netdevsim {
 	struct net_device *netdev;
 	struct nsim_dev *nsim_dev;
-- 
2.28.0

