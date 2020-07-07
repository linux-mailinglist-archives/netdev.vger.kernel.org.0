Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE941217A0A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGGVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgGGVNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:13:33 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDADAC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:13:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so17620749pgf.0
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PmK36SxDExFG7SUtpzZNnx28CnmbWgxr8KKUVrE9Tiw=;
        b=ZeWIjpvzIALfZf27zTW9BGc26wfRszH8l9ihUX4hepxCIyiVzaKTXfX+FGwtUVDHNY
         lmDdgiiz7bFwVZsSufnoHDwvvp3g7almeE1cL4Za9UVfgPhdkYMxohBBJzybr/CfiLhY
         ktyLfGvqaBbErC4D8JKZOEOUa9M2Red+DMShm0gEx5K/q+5Fr7IeiASZHYnjLJHyfGCE
         jeLgGblM61DPR3bqxtUs/6IiP+EQcL8JvN/ML9a4vqWKbElkWgxNtzaf1ENojtpk0anD
         QiF6T2o25w3gbxupcTCX2+BaS+SYiquQs6S4y3n8mDS0vpfLZ55YsUJUuoh+teOtVBN6
         p8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PmK36SxDExFG7SUtpzZNnx28CnmbWgxr8KKUVrE9Tiw=;
        b=bslsIyst6Nfkae63lWuXW4VwClkXuz3RHDbuBtBVkTbQ1OQ8nXBKQeagK9PzzzIEpX
         zIqLTjI+f0K0R4+wAjoCRED5YdF/ScnpJSHZFSofP6t4ASMWzhyvSr6R4vZF69EsdvpO
         4w8et1xSIk8tDcpkRFP22rpibALVY+jfBFP5JDO7VW905Bz+Y33l8qldnUJmwNSr8p1k
         B6R07C1hUHIHig95FVDRlU68GkwJWV8UIhJzlakDA/D/2HNswyMY19o7GuA1BphjkrGP
         WN6N/FFWIljQO4rhKWrTrg2aM5Sc1Yy/g4G31Ly2je+bN/XRKEKgUZ1CXyohq2cKlj++
         LKYQ==
X-Gm-Message-State: AOAM530AsMJe003nFVOokLF6ijY4gDURJuLZtiexuoWpJyQe42Yn4qeH
        AfZY7YqevZvKd5CPxIVJC8b0qosNANNF2w==
X-Google-Smtp-Source: ABdhPJz+cA/QRX1iPRC6RblvyluXgYBxT3d3vP/lLJcnfmtPLEloa8sDxqvF9Pr0pELXKkResCZ9wg==
X-Received: by 2002:a63:100b:: with SMTP id f11mr44621960pgl.287.1594156412546;
        Tue, 07 Jul 2020 14:13:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s131sm1791079pgc.30.2020.07.07.14.13.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:13:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net] ionic: centralize queue reset code
Date:   Tue,  7 Jul 2020 14:13:26 -0700
Message-Id: <20200707211326.11291-1-snelson@pensando.io>
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

This specifically addresses issues seen where under loops
of changing ring size or queue count parameters we could
occasionally bump into the netdev watchdog.

v2: added more commit message commentary

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

