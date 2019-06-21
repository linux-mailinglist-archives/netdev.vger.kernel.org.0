Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA54EADB
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFUOhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:37:15 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:42224 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUOhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 10:37:15 -0400
Received: from localhost ([10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5LEb6Fj018083;
        Fri, 21 Jun 2019 07:37:07 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH net-next 3/4] cxgb4: Add MPS TCAM refcounting for cxgb4 change mac
Date:   Fri, 21 Jun 2019 20:06:35 +0530
Message-Id: <20190621143636.20422-4-rajur@chelsio.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190621143636.20422-1-rajur@chelsio.com>
References: <20190621143636.20422-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds TCAM reference counting
support for cxgb4 change mac path

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  7 +++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 14 +++++++-------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c  | 15 +++++++++++++++
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 92024c5..206332c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1911,6 +1911,10 @@ int cxgb4_set_msix_aff(struct adapter *adap, unsigned short vec,
 		       cpumask_var_t *aff_mask, int idx);
 void cxgb4_clear_msix_aff(unsigned short vec, cpumask_var_t aff_mask);
 
+int cxgb4_change_mac(struct port_info *pi, unsigned int viid,
+		     int *tcam_idx, const u8 *addr,
+		     bool persistent, u8 *smt_idx);
+
 int cxgb4_init_mps_ref_entries(struct adapter *adap);
 void cxgb4_free_mps_ref_entries(struct adapter *adap);
 int cxgb4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
@@ -1935,5 +1939,8 @@ int cxgb4_alloc_raw_mac_filt(struct adapter *adap,
 			     u8 lookup_type,
 			     u8 port_id,
 			     bool sleep_ok);
+int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
+			  int *tcam_idx, const u8 *addr,
+			  bool persistent, u8 *smt_idx);
 
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 4632827..1520e52 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -449,9 +449,9 @@ static int set_rxmode(struct net_device *dev, int mtu, bool sleep_ok)
  *	Addresses are programmed to hash region, if tcam runs out of entries.
  *
  */
-static int cxgb4_change_mac(struct port_info *pi, unsigned int viid,
-			    int *tcam_idx, const u8 *addr, bool persist,
-			    u8 *smt_idx)
+int cxgb4_change_mac(struct port_info *pi, unsigned int viid,
+		     int *tcam_idx, const u8 *addr, bool persist,
+		     u8 *smt_idx)
 {
 	struct adapter *adapter = pi->adapter;
 	struct hash_mac_addr *entry, *new_entry;
@@ -505,8 +505,8 @@ static int link_start(struct net_device *dev)
 	ret = t4_set_rxmode(pi->adapter, mb, pi->viid, dev->mtu, -1, -1, -1,
 			    !!(dev->features & NETIF_F_HW_VLAN_CTAG_RX), true);
 	if (ret == 0)
-		ret = cxgb4_change_mac(pi, pi->viid, &pi->xact_addr_filt,
-				       dev->dev_addr, true, &pi->smt_idx);
+		ret = cxgb4_update_mac_filt(pi, pi->viid, &pi->xact_addr_filt,
+					    dev->dev_addr, true, &pi->smt_idx);
 	if (ret == 0)
 		ret = t4_link_l1cfg(pi->adapter, mb, pi->tx_chan,
 				    &pi->link_cfg);
@@ -3020,8 +3020,8 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	ret = cxgb4_change_mac(pi, pi->viid, &pi->xact_addr_filt,
-			       addr->sa_data, true, &pi->smt_idx);
+	ret = cxgb4_update_mac_filt(pi, pi->viid, &pi->xact_addr_filt,
+				    addr->sa_data, true, &pi->smt_idx);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
index 5886207..d503baf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -54,6 +54,21 @@ static int cxgb4_mps_ref_inc(struct adapter *adap, const u8 *mac_addr,
 	return ret;
 }
 
+int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
+			  int *tcam_idx, const u8 *addr,
+			  bool persistent, u8 *smt_idx)
+{
+	int ret;
+
+	ret = cxgb4_change_mac(pi, viid, tcam_idx,
+			       addr, persistent, smt_idx);
+	if (ret < 0)
+		return ret;
+
+	cxgb4_mps_ref_inc(pi->adapter, addr, *tcam_idx, NULL);
+	return ret;
+}
+
 int cxgb4_free_raw_mac_filt(struct adapter *adap,
 			    unsigned int viid,
 			    const u8 *addr,
-- 
1.8.3.1

