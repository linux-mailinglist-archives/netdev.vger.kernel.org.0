Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC03C2B82F5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgKRRSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:18:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbgKRRSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:18:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2T00uJktjqZz0fWIkJaD1iYMeqlE/lSkbmhq0EHOLn8=;
        b=PdeMRmcyR5IKUFVikcBnnZ+6BFI7WuNcHGcXUf6XDVv8b3eT/Y0QQYEm3/pKIGrEL+UQ1c
        lfsaAs8ntbp4EQbOk3Z+PQNdc7MTtTcyh3dlTvISBs6pa4K9koXGGRZEy7fgwZZYyQmuwC
        UNJvL4O4LP2Mx+fQmWJ+69o6Vi+yw5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-WHzvYEjuN-uUwNwg8AO69Q-1; Wed, 18 Nov 2020 12:18:40 -0500
X-MC-Unique: WHzvYEjuN-uUwNwg8AO69Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2404964151;
        Wed, 18 Nov 2020 17:18:38 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECF5160843;
        Wed, 18 Nov 2020 17:18:36 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v5 3/6] netdevsim: support ethtool ring and coalesce settings
Date:   Wed, 18 Nov 2020 18:18:24 +0100
Message-Id: <20201118171827.48143-4-acardace@redhat.com>
In-Reply-To: <20201118171827.48143-1-acardace@redhat.com>
References: <20201118171827.48143-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool ring and coalesce settings support for testing.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
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

