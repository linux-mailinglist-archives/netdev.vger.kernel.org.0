Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7722A8B2B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732746AbgKFAMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732660AbgKFAMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 19:12:40 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D46C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 16:12:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id g7so2388662pfc.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 16:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/0IvibNh+Smy/hpRKjeRGPoP2tQSMPHmeatAkYSGNXs=;
        b=3bONby1RmEzVqrGbkmdv3fnHqbbwEGASe8U5LusdH69XBomq9Fo+h6Cjj3Qedh4Gkn
         1WO3PdZmza2Ywpz+65AgULCyv87O75RGMYjKAVYd0MglztRv296DA068SS5HaCORFAk/
         TzUPZXR1pvVHIFiGNgmW43AyQz9dfITbpJCi9LsiuX3Fs27QeTtkYhVINcCutYZiqjjW
         TAMav4cUJw48y4z5LsMRV2uptMTP0uDqCdPqnM6ZcLrpZ0qnKtedudI/MA0wZtUhJxFH
         s5GQy41hRO8dNlXP4DhSIUfIiPAIjbufq2WD1Hu7JLE4UE2J4jubIn+d5i/ZAwruh+JS
         xuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/0IvibNh+Smy/hpRKjeRGPoP2tQSMPHmeatAkYSGNXs=;
        b=fkzIXpBNYQ43cGvP94AWlRuLhyPRLsOT2coKQB5Hv+NfbK1kDpo5viduocmzOLLJvs
         NYVNny2pRDE8tvjfU/gFZbob9GUs3WArq6i/HeDNqTpNxfBt+f1PmsNAnTw2TRzLf4xv
         wVYtdtb8e0aQFraq4DCrLDfPgAGExuuiaivSYlRseHvMMHosAbWl2+acsIF6r3fX4VWY
         kC7IM1bRnWK/6w+dXtkYz7/Sxgp4gxRGCwU05KLR2f6/SKUj1BpCNoo79VnbX1h5I/rk
         mVl/cqFJpJ+w79mjJPU3VxSIW46WIez+444rQ8yjAfl7iSViJ0eXNdMERrnGadVB2W39
         Yn6A==
X-Gm-Message-State: AOAM5329MMeCiv3TJ6CreMhmJvE+ezGOknLbukRVHYsNKk2TlpAS9Xls
        ebwjfXZ5ebTpXov4JIx73r0kP57qt5Yn2g==
X-Google-Smtp-Source: ABdhPJz7dxVKmia3qnwElovjX5bHJwXrlNAsvf/NIxpkNGCZQNDb3krzUrQKo6VLbBddAu4R4J2NNg==
X-Received: by 2002:a63:4546:: with SMTP id u6mr4727488pgk.311.1604621559998;
        Thu, 05 Nov 2020 16:12:39 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 22sm3236009pjb.40.2020.11.05.16.12.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 16:12:39 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 7/8] ionic: change set_rx_mode from_ndo to can_sleep
Date:   Thu,  5 Nov 2020 16:12:19 -0800
Message-Id: <20201106001220.68130-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having two different ways of expressing the same
sleepability concept, using opposite logic, we can rework the
from_ndo to can_sleep for a more consistent usage.

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ef092ee33e59..7e4ea4ecc912 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1129,7 +1129,7 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 		lif->rx_mode = rx_mode;
 }
 
-static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
+static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_deferred_work *work;
@@ -1149,10 +1149,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1164,10 +1164,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	if (from_ndo)
-		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
@@ -1179,7 +1179,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	if (lif->rx_mode != rx_mode) {
-		if (from_ndo) {
+		if (!can_sleep) {
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
 				netdev_err(lif->netdev, "%s OOM\n", __func__);
@@ -1197,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
-	ionic_set_rx_mode(netdev, true);
+	ionic_set_rx_mode(netdev, false);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -1788,7 +1788,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, false);
+	ionic_set_rx_mode(lif->netdev, true);
 
 	return 0;
 
-- 
2.17.1

