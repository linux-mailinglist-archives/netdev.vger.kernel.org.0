Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656A42B85E8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgKRUpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:45:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgKRUpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605732333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0UhY7JRNTWWwoTi7ac3CKN9eTMMoAP1D5/XRwRw6Fk=;
        b=dPNgb7lN4hqQvYhZmLyS0ceR5jdzZcD5fzsjxohRnOgbwbxQum+5POHZ34P1C2Dp96+MeX
        x80vRgem9pR+BzUiN0qNXrKf+1CH50mBnu+g8PZ+LIm/p3hS8tSRhfFXaEt5EWS0xndGnG
        vqAJ9y8X+F3YCRpWn2d1c8pWeitxZ4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-7usO0bL2Mb24uykOPIJS4w-1; Wed, 18 Nov 2020 15:45:31 -0500
X-MC-Unique: 7usO0bL2Mb24uykOPIJS4w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A14B8144FA;
        Wed, 18 Nov 2020 20:45:30 +0000 (UTC)
Received: from yoda.redhat.com (unknown [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A69A19728;
        Wed, 18 Nov 2020 20:45:28 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 2/6] netdevsim: move ethtool pause params in separate struct
Date:   Wed, 18 Nov 2020 21:45:18 +0100
Message-Id: <20201118204522.5660-3-acardace@redhat.com>
In-Reply-To: <20201118204522.5660-1-acardace@redhat.com>
References: <20201118204522.5660-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will help the refactoring in the next commit
when coalesce and ring settings are added.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/netdevsim/ethtool.c   | 16 ++++++++--------
 drivers/net/netdevsim/netdevsim.h |  6 +++++-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index f1884d90a876..4f074bf85f5c 100644
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
-			    &ns->ethtool.report_stats_tx);
+			    &ns->ethtool.pauseparam.report_stats_tx);
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

