Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE72B82F4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgKRRSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:18:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbgKRRSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O48wEeNRvA0/uuGRxs2xQLuzJ3SYZNte8k6kTbEZOKA=;
        b=BkNUY9bvcgBOUGE6NrGsKfcenGawB/oDYmTg5mHGbYaiFH/uYQUuHxZZKpA05tp5n5Lr/N
        Hq2HInG+ttf7zSw/dquBHKCc8MmhABnctkGnVAHfIQ2UtiiL/2Tox8H172SQLPQK7TTBmZ
        a+Srz3DVX95JHhc7dQPEJ4tJNKhV0pU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-L8NQP3PPMA2hZSFMk_HpWA-1; Wed, 18 Nov 2020 12:18:37 -0500
X-MC-Unique: L8NQP3PPMA2hZSFMk_HpWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9161F8049D4;
        Wed, 18 Nov 2020 17:18:36 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 665D860843;
        Wed, 18 Nov 2020 17:18:35 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v5 2/6] netdevsim: move ethtool pause params in separate struct
Date:   Wed, 18 Nov 2020 18:18:23 +0100
Message-Id: <20201118171827.48143-3-acardace@redhat.com>
In-Reply-To: <20201118171827.48143-1-acardace@redhat.com>
References: <20201118171827.48143-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will help the refactoring in the next commit
when coalesce and ring settings are added.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/netdevsim/ethtool.c   | 14 +++++++-------
 drivers/net/netdevsim/netdevsim.h |  6 +++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index f1884d90a876..a1500f849203 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -13,9 +13,9 @@ nsim_get_pause_stats(struct net_device *dev,
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	if (ns->ethtool.report_stats_rx)
+	if (ns->ethtool.pauseparam.report_stats_rx)
 		pause_stats->rx_pause_frames = 1;
-	if (ns->ethtool.report_stats_tx)
+	if (ns->ethtool.pauseparam.report_stats_tx)
 		pause_stats->tx_pause_frames = 2;
 }
 
@@ -25,8 +25,8 @@ nsim_get_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 	struct netdevsim *ns = netdev_priv(dev);
 
 	pause->autoneg = 0; /* We don't support ksettings, so can't pretend */
-	pause->rx_pause = ns->ethtool.rx;
-	pause->tx_pause = ns->ethtool.tx;
+	pause->rx_pause = ns->ethtool.pauseparam.rx;
+	pause->tx_pause = ns->ethtool.pauseparam.tx;
 }
 
 static int
@@ -37,8 +37,8 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
 	if (pause->autoneg)
 		return -EINVAL;
 
-	ns->ethtool.rx = pause->rx_pause;
-	ns->ethtool.tx = pause->tx_pause;
+	ns->ethtool.pauseparam.rx = pause->rx_pause;
+	ns->ethtool.pauseparam.tx = pause->tx_pause;
 	return 0;
 }
 
@@ -58,7 +58,7 @@ void nsim_ethtool_init(struct netdevsim *ns)
 
 	dir = debugfs_create_dir("pause", ethtool);
 	debugfs_create_bool("report_stats_rx", 0600, dir,
-			    &ns->ethtool.report_stats_rx);
+			    &ns->ethtool.pauseparam.report_stats_rx);
 	debugfs_create_bool("report_stats_tx", 0600, dir,
 			    &ns->ethtool.report_stats_tx);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 827fc80f50a0..4b3023e49094 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -51,13 +51,17 @@ struct nsim_ipsec {
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
+};
+
 struct netdevsim {
 	struct net_device *netdev;
 	struct nsim_dev *nsim_dev;
-- 
2.28.0

