Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC93C1701
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhGHQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 12:25:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:25300 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhGHQZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 12:25:39 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 168GMocS018848;
        Thu, 8 Jul 2021 09:22:50 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, shahjada@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH net] cxgb4: fix IRQ free race during driver unload
Date:   Thu,  8 Jul 2021 21:51:56 +0530
Message-Id: <20210708162156.6381-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahjada Abul Husain <shahjada@chelsio.com>

IRQs are requested during driver's ndo_open() and then later
freed up in disable_interrupts() during driver unload.
A race exists where driver can set the CXGB4_FULL_INIT_DONE
flag in ndo_open() after the disable_interrupts() in driver
unload path checks it, and hence misses calling free_irq().

Fix by unregistering netdevice first and sync with driver's
ndo_open(). This ensures disable_interrupts() checks the flag
correctly and frees up the IRQs properly.

Fixes: b37987e8db5f ("cxgb4: Disable interrupts and napi before unregistering netdev")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 18 ++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c  |  3 +++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9a2b166d651e..dbf9a0e6601d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2643,6 +2643,9 @@ static void detach_ulds(struct adapter *adap)
 {
 	unsigned int i;
 
+	if (!is_uld(adap))
+		return;
+
 	mutex_lock(&uld_mutex);
 	list_del(&adap->list_node);
 
@@ -7141,10 +7144,13 @@ static void remove_one(struct pci_dev *pdev)
 		 */
 		destroy_workqueue(adapter->workq);
 
-		if (is_uld(adapter)) {
-			detach_ulds(adapter);
-			t4_uld_clean_up(adapter);
-		}
+		detach_ulds(adapter);
+
+		for_each_port(adapter, i)
+			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
+				unregister_netdev(adapter->port[i]);
+
+		t4_uld_clean_up(adapter);
 
 		adap_free_hma_mem(adapter);
 
@@ -7152,10 +7158,6 @@ static void remove_one(struct pci_dev *pdev)
 
 		cxgb4_free_mps_ref_entries(adapter);
 
-		for_each_port(adapter, i)
-			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
-				unregister_netdev(adapter->port[i]);
-
 		debugfs_remove_recursive(adapter->debugfs_root);
 
 		if (!is_t4(adapter->params.chip))
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 743af9e654aa..17faac715882 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -581,6 +581,9 @@ void t4_uld_clean_up(struct adapter *adap)
 {
 	unsigned int i;
 
+	if (!is_uld(adap))
+		return;
+
 	mutex_lock(&uld_mutex);
 	for (i = 0; i < CXGB4_ULD_MAX; i++) {
 		if (!adap->uld[i].handle)
-- 
2.9.5

