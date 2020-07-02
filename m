Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F75213032
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGBXj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGBXj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:39:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2692DC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:39:27 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so11905831plq.6
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=b5DKw11TZGdel3yqJ4oELhw9m7bltw8VuuEDect0Pb0=;
        b=uv39juVLCbmDrGr+QP7FaqOoNEmQKlqoxr8tKpxiA5BdGj9znHxp3JX29BjeBWgdrJ
         7XdWFJy5dJJa89FQoWk3pxKrJpiqfloPvXKoLhVFh4z8I1zVMq2TDaDjz67TGG31EJmD
         KKmDh+vGYEa+IMvMPfAlBOehq/WNNP9WeXXhMiYuY5R5zbrk6cV7636YoqkMQ1wuXMkn
         EpihHVzVXAtVMaRYnQNnhM/2by/YvFHr69zT1N1zSNVQTxxrUKj3C26ZmtCZBdxQgA6X
         ZtsnxQDLnp+AQiqY0qKDYs6Q9tXhWJtR6DdgbesXs/iiFg6TPHuwjr4b9YAEkLaaDMGm
         v1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b5DKw11TZGdel3yqJ4oELhw9m7bltw8VuuEDect0Pb0=;
        b=lKKMBOjuiMhFvS5wH+CFYAflf75ywDqbO3cAhuOsRFzN2lma3n7/1HV2hCyaQtauVU
         GAmykWyQgl1upI3vg13bIeiGEjh8+HZ+lOJ+pBwBQ4ugE35PW9yPzhoGNbLTQ24a9wih
         AMTZVgu5cwlhGkJRp1GxoF/f9DHDt89mKH5JZfvLwNTxIyigdXweRKU/TDEw5vqqG/bI
         76OE6uysotb8cb7Le++ajoAq8VnvXrb0y4cfCIZhWEc2pRzj1nF4IDC+fFkzFUIFCS4N
         F16mhdSJuyD47BcZTpEv88KZqKiy3tAf3wpzY0jbnH1SOfPxabAC2lI4Krvy60THMHMP
         pinQ==
X-Gm-Message-State: AOAM531DAI/QW+KM8V0tTnhsTxtOQP4h9O0UPtOFQD9fIyDkE3VYkF/r
        WNM0TYG3qEQEkF2XUHz/l4bxd3+LUxOQzQ==
X-Google-Smtp-Source: ABdhPJyI3b1BXv8Gew/bdU8TOO1ExyhSDWosLVh6WgE3cnXXmw0r+4V3bde4z1KjQTGxIfpItCWUxw==
X-Received: by 2002:a17:90a:6448:: with SMTP id y8mr35706943pjm.142.1593733166290;
        Thu, 02 Jul 2020 16:39:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id hg13sm8475200pjb.21.2020.07.02.16.39.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2020 16:39:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: centralize queue reset code
Date:   Thu,  2 Jul 2020 16:39:17 -0700
Message-Id: <20200702233917.35166-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queue reset pattern is used in a couple different places,
only slightly different from each other, and could cause
issues if one gets changed and the other didn't.  This puts
them together so that only one version is needed, yet each
can have slighty different effects by passing in a pointer
to a work function to do whatever configuration twiddling is
needed in the middle of the reset.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 52 ++++++-------------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 17 ++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  4 +-
 3 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index f7e3ce3de04d..e03ea9b18f95 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -468,12 +468,18 @@ static void ionic_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = lif->nrxq_descs;
 }
 
+static void ionic_set_ringsize(struct ionic_lif *lif, void *arg)
+{
+	struct ethtool_ringparam *ring = arg;
+
+	lif->ntxq_descs = ring->tx_pending;
+	lif->nrxq_descs = ring->rx_pending;
+}
+
 static int ionic_set_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	bool running;
-	int err;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
@@ -491,22 +497,7 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
-	running = test_bit(IONIC_LIF_F_UP, lif->state);
-	if (running)
-		ionic_stop(netdev);
-
-	lif->ntxq_descs = ring->tx_pending;
-	lif->nrxq_descs = ring->rx_pending;
-
-	if (running)
-		ionic_open(netdev);
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
-
-	return 0;
+	return ionic_reset_queues(lif, ionic_set_ringsize, ring);
 }
 
 static void ionic_get_channels(struct net_device *netdev,
@@ -521,12 +512,17 @@ static void ionic_get_channels(struct net_device *netdev,
 	ch->combined_count = lif->nxqs;
 }
 
+static void ionic_set_queuecount(struct ionic_lif *lif, void *arg)
+{
+	struct ethtool_channels *ch = arg;
+
+	lif->nxqs = ch->combined_count;
+}
+
 static int ionic_set_channels(struct net_device *netdev,
 			      struct ethtool_channels *ch)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	bool running;
-	int err;
 
 	if (!ch->combined_count || ch->other_count ||
 	    ch->rx_count || ch->tx_count)
@@ -535,21 +531,7 @@ static int ionic_set_channels(struct net_device *netdev,
 	if (ch->combined_count == lif->nxqs)
 		return 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
-	running = test_bit(IONIC_LIF_F_UP, lif->state);
-	if (running)
-		ionic_stop(netdev);
-
-	lif->nxqs = ch->combined_count;
-
-	if (running)
-		ionic_open(netdev);
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
-
-	return 0;
+	return ionic_reset_queues(lif, ionic_set_queuecount, ch);
 }
 
 static u32 ionic_get_priv_flags(struct net_device *netdev)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 3c9dde31f3fa..f49486b6d04d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1313,7 +1313,7 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return err;
 
 	netdev->mtu = new_mtu;
-	err = ionic_reset_queues(lif);
+	err = ionic_reset_queues(lif, NULL, NULL);
 
 	return err;
 }
@@ -1325,7 +1325,7 @@ static void ionic_tx_timeout_work(struct work_struct *ws)
 	netdev_info(lif->netdev, "Tx Timeout recovery\n");
 
 	rtnl_lock();
-	ionic_reset_queues(lif);
+	ionic_reset_queues(lif, NULL, NULL);
 	rtnl_unlock();
 }
 
@@ -1988,7 +1988,7 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
-int ionic_reset_queues(struct ionic_lif *lif)
+int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 {
 	bool running;
 	int err = 0;
@@ -2001,12 +2001,19 @@ int ionic_reset_queues(struct ionic_lif *lif)
 	if (running) {
 		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
+		if (err)
+			goto reset_out;
 	}
-	if (!err && running) {
-		ionic_open(lif->netdev);
+
+	if (cb)
+		cb(lif, arg);
+
+	if (running) {
+		err = ionic_open(lif->netdev);
 		netif_device_attach(lif->netdev);
 	}
 
+reset_out:
 	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
 
 	return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index c3428034a17b..ed126dd74e01 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -248,6 +248,8 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 	return (units * div) / mult;
 }
 
+typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
+
 void ionic_link_status_check_request(struct ionic_lif *lif);
 void ionic_get_stats64(struct net_device *netdev,
 		       struct rtnl_link_stats64 *ns);
@@ -267,7 +269,7 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
-int ionic_reset_queues(struct ionic_lif *lif);
+int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_qcq *qcq,
 					struct ionic_txq_desc *desc, bool dbell)
-- 
2.17.1

