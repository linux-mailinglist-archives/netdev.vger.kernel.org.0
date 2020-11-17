Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA78A2B6886
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgKQPUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730019AbgKQPUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605626428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rW/AWiECPY2JBQ4sj4W+VXCtGgita6vVeKBNU4bYUc4=;
        b=h/Gfs5T8clq0p/Ec+mKGobwTFxX6u1H5EPngXB+Salq3N5KJdi+rPxflAUX9fQK4xP9khY
        DdP+pGPslYOcl1qxi1H7gbOTe9+j8zFERTlcnX3JLwJO5gDyvm0PSHNljh53z4T3XARwMd
        aeChnPqfRsWg8mfAEajPCQzyOxjtPkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-mUerdknrNBKLTYIXQWnXXA-1; Tue, 17 Nov 2020 10:20:26 -0500
X-MC-Unique: mUerdknrNBKLTYIXQWnXXA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46D410866A1;
        Tue, 17 Nov 2020 15:20:25 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84A345D707;
        Tue, 17 Nov 2020 15:20:24 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v4 3/6] netdevsim: support ethtool ring and coalesce settings
Date:   Tue, 17 Nov 2020 16:20:12 +0100
Message-Id: <20201117152015.142089-4-acardace@redhat.com>
In-Reply-To: <20201117152015.142089-1-acardace@redhat.com>
References: <20201117152015.142089-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool ring and coalesce settings support for testing.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
v3 -> v4:
 - move supported_coalesce_params struct field as first field
 - extracted pauseparam refactoring in a different patch
---
 drivers/net/netdevsim/ethtool.c   | 68 +++++++++++++++++++++++++++++--
 drivers/net/netdevsim/netdevsim.h |  3 ++
 2 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index a1500f849203..166f0d6cbcf7 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -42,23 +42,83 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 	return 0;
 }

+static int nsim_get_coalesce(struct net_device *dev,
+			     struct ethtool_coalesce *coal)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(coal, &ns->ethtool.coalesce, sizeof(ns->ethtool.coalesce));
+	return 0;
+}
+
+static int nsim_set_coalesce(struct net_device *dev,
+			     struct ethtool_coalesce *coal)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(&ns->ethtool.coalesce, coal, sizeof(ns->ethtool.coalesce));
+	return 0;
+}
+
+static void nsim_get_ringparam(struct net_device *dev,
+			       struct ethtool_ringparam *ring)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(ring, &ns->ethtool.ring, sizeof(ns->ethtool.ring));
+}
+
+static int nsim_set_ringparam(struct net_device *dev,
+			      struct ethtool_ringparam *ring)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
+	return 0;
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
-	.get_pause_stats	= nsim_get_pause_stats,
-	.get_pauseparam		= nsim_get_pauseparam,
-	.set_pauseparam		= nsim_set_pauseparam,
+	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
+	.get_pause_stats	        = nsim_get_pause_stats,
+	.get_pauseparam		        = nsim_get_pauseparam,
+	.set_pauseparam		        = nsim_set_pauseparam,
+	.set_coalesce			= nsim_set_coalesce,
+	.get_coalesce			= nsim_get_coalesce,
+	.get_ringparam			= nsim_get_ringparam,
+	.set_ringparam			= nsim_set_ringparam,
 };

+static void nsim_ethtool_ring_init(struct netdevsim *ns)
+{
+	ns->ethtool.ring.rx_max_pending = 4096;
+	ns->ethtool.ring.rx_jumbo_max_pending = 4096;
+	ns->ethtool.ring.rx_mini_max_pending = 4096;
+	ns->ethtool.ring.tx_max_pending = 4096;
+}
+
 void nsim_ethtool_init(struct netdevsim *ns)
 {
 	struct dentry *ethtool, *dir;

 	ns->netdev->ethtool_ops = &nsim_ethtool_ops;

+	nsim_ethtool_ring_init(ns);
+
 	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev_port->ddir);

 	dir = debugfs_create_dir("pause", ethtool);
 	debugfs_create_bool("report_stats_rx", 0600, dir,
 			    &ns->ethtool.pauseparam.report_stats_rx);
 	debugfs_create_bool("report_stats_tx", 0600, dir,
-			    &ns->ethtool.report_stats_tx);
+			    &ns->ethtool.pauseparam.report_stats_tx);
+
+	dir = debugfs_create_dir("ring", ethtool);
+	debugfs_create_u32("rx_max_pending", 0600, dir,
+			   &ns->ethtool.ring.rx_max_pending);
+	debugfs_create_u32("rx_jumbo_max_pending", 0600, dir,
+			   &ns->ethtool.ring.rx_jumbo_max_pending);
+	debugfs_create_u32("rx_mini_max_pending", 0600, dir,
+			   &ns->ethtool.ring.rx_mini_max_pending);
+	debugfs_create_u32("tx_max_pending", 0600, dir,
+			   &ns->ethtool.ring.tx_max_pending);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 4b3023e49094..b023dc0a4259 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -15,6 +15,7 @@

 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -60,6 +61,8 @@ struct nsim_ethtool_pauseparam {

 struct nsim_ethtool {
 	struct nsim_ethtool_pauseparam pauseparam;
+	struct ethtool_coalesce coalesce;
+	struct ethtool_ringparam ring;
 };

 struct netdevsim {
--
2.28.0

