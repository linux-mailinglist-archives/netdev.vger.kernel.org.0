Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCE199F85
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgCaT6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 15:58:06 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:4831 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgCaT6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 15:58:06 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02VJw1wK031058;
        Tue, 31 Mar 2020 12:58:02 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: free MQPRIO resources in shutdown path
Date:   Wed,  1 Apr 2020 01:17:01 +0530
Message-Id: <1585684021-17628-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform missing MQPRIO resource cleanup in PCI shutdown path. Also,
fix MQPRIO MSIX bitmap leak in resource cleanup.

Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  4 ++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 23 +++++++++++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |  1 +
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 6767c73c87a1..b0bdf7233f0c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6681,6 +6681,10 @@ static void shutdown_one(struct pci_dev *pdev)
 			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
 				cxgb_close(adapter->port[i]);
 
+		rtnl_lock();
+		cxgb4_mqprio_stop_offload(adapter);
+		rtnl_unlock();
+
 		if (is_uld(adapter)) {
 			detach_ulds(adapter);
 			t4_uld_clean_up(adapter);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index ec3eb45ee3b4..e6af4906d674 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -301,6 +301,7 @@ static void cxgb4_mqprio_free_hw_resources(struct net_device *dev)
 			cxgb4_clear_msix_aff(eorxq->msix->vec,
 					     eorxq->msix->aff_mask);
 			free_irq(eorxq->msix->vec, &eorxq->rspq);
+			cxgb4_free_msix_idx_in_bmap(adap, eorxq->msix->idx);
 		}
 
 		free_rspq_fl(adap, &eorxq->rspq, &eorxq->fl);
@@ -611,6 +612,28 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	return ret;
 }
 
+void cxgb4_mqprio_stop_offload(struct adapter *adap)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct net_device *dev;
+	u8 i;
+
+	if (!adap->tc_mqprio || !adap->tc_mqprio->port_mqprio)
+		return;
+
+	for_each_port(adap, i) {
+		dev = adap->port[i];
+		if (!dev)
+			continue;
+
+		tc_port_mqprio = &adap->tc_mqprio->port_mqprio[i];
+		if (!tc_port_mqprio->mqprio.qopt.num_tc)
+			continue;
+
+		cxgb4_mqprio_disable_offload(dev);
+	}
+}
+
 int cxgb4_init_tc_mqprio(struct adapter *adap)
 {
 	struct cxgb4_tc_port_mqprio *tc_port_mqprio, *port_mqprio;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index c532f1ef8451..ff8794132b22 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -38,6 +38,7 @@ struct cxgb4_tc_mqprio {
 
 int cxgb4_setup_tc_mqprio(struct net_device *dev,
 			  struct tc_mqprio_qopt_offload *mqprio);
+void cxgb4_mqprio_stop_offload(struct adapter *adap);
 int cxgb4_init_tc_mqprio(struct adapter *adap);
 void cxgb4_cleanup_tc_mqprio(struct adapter *adap);
 #endif /* __CXGB4_TC_MQPRIO_H__ */
-- 
2.24.0

