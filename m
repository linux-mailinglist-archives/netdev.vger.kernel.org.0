Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771A68FBE8
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfHPHPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 03:15:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfHPHPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 03:15:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E8556308AA12;
        Fri, 16 Aug 2019 07:15:37 +0000 (UTC)
Received: from ceranb.redhat.com (ovpn-204-190.brq.redhat.com [10.40.204.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A230E19C6A;
        Fri, 16 Aug 2019 07:15:36 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     sathya.perla@broadcom.com, poros@redhat.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH] be2net: eliminate enable field from be_aic_obj
Date:   Fri, 16 Aug 2019 09:15:35 +0200
Message-Id: <20190816071535.28349-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 16 Aug 2019 07:15:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adaptive coalescing is managed per adapter not per event queue so it
does not needed to store 'enable' flag for each event queue.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/emulex/benet/be.h         | 2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 7 ++++---
 drivers/net/ethernet/emulex/benet/be_main.c    | 7 ++++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index f287b5da5546..cf3e6f2892ff 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -192,7 +192,6 @@ struct be_eq_obj {
 } ____cacheline_aligned_in_smp;
 
 struct be_aic_obj {		/* Adaptive interrupt coalescing (AIC) info */
-	bool enable;
 	u32 min_eqd;		/* in usecs */
 	u32 max_eqd;		/* in usecs */
 	u32 prev_eqd;		/* in usecs */
@@ -589,6 +588,7 @@ struct be_adapter {
 
 	struct be_drv_stats drv_stats;
 	struct be_aic_obj aic_obj[MAX_EVT_QS];
+	bool aic_enabled;
 	u8 vlan_prio_bmap;	/* Available Priority BitMap */
 	u16 recommended_prio_bits;/* Recommended Priority bits in vlan tag */
 	struct be_dma_mem rx_filter; /* Cmd DMA mem for rx-filter */
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 492f8769ac12..5bb5abf99588 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -329,8 +329,8 @@ static int be_get_coalesce(struct net_device *netdev,
 	et->tx_coalesce_usecs_high = aic->max_eqd;
 	et->tx_coalesce_usecs_low = aic->min_eqd;
 
-	et->use_adaptive_rx_coalesce = aic->enable;
-	et->use_adaptive_tx_coalesce = aic->enable;
+	et->use_adaptive_rx_coalesce = adapter->aic_enabled;
+	et->use_adaptive_tx_coalesce = adapter->aic_enabled;
 
 	return 0;
 }
@@ -346,8 +346,9 @@ static int be_set_coalesce(struct net_device *netdev,
 	struct be_eq_obj *eqo;
 	int i;
 
+	adapter->aic_enabled = et->use_adaptive_rx_coalesce;
+
 	for_all_evt_queues(adapter, eqo, i) {
-		aic->enable = et->use_adaptive_rx_coalesce;
 		aic->max_eqd = min(et->rx_coalesce_usecs_high, BE_MAX_EQD);
 		aic->min_eqd = min(et->rx_coalesce_usecs_low, aic->max_eqd);
 		aic->et_eqd = min(et->rx_coalesce_usecs, aic->max_eqd);
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 314e9868b861..39eb7d525043 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2147,7 +2147,7 @@ static int be_get_new_eqd(struct be_eq_obj *eqo)
 	int i;
 
 	aic = &adapter->aic_obj[eqo->idx];
-	if (!aic->enable) {
+	if (!adapter->aic_enabled) {
 		if (aic->jiffies)
 			aic->jiffies = 0;
 		eqd = aic->et_eqd;
@@ -2204,7 +2204,7 @@ static u32 be_get_eq_delay_mult_enc(struct be_eq_obj *eqo)
 	int eqd;
 	u32 mult_enc;
 
-	if (!aic->enable)
+	if (!adapter->aic_enabled)
 		return 0;
 
 	if (jiffies_to_msecs(now - aic->jiffies) < 1)
@@ -2959,6 +2959,8 @@ static int be_evt_queues_create(struct be_adapter *adapter)
 				    max(adapter->cfg_num_rx_irqs,
 					adapter->cfg_num_tx_irqs));
 
+	adapter->aic_enabled = true;
+
 	for_all_evt_queues(adapter, eqo, i) {
 		int numa_node = dev_to_node(&adapter->pdev->dev);
 
@@ -2966,7 +2968,6 @@ static int be_evt_queues_create(struct be_adapter *adapter)
 		eqo->adapter = adapter;
 		eqo->idx = i;
 		aic->max_eqd = BE_MAX_EQD;
-		aic->enable = true;
 
 		eq = &eqo->q;
 		rc = be_queue_alloc(adapter, eq, EVNT_Q_LEN,
-- 
2.21.0

