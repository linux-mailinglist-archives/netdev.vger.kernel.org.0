Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 770F84EADC
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfFUOhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:37:17 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:57328 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUOhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 10:37:17 -0400
Received: from localhost (junagarh.blr.asicdesigners.com [10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5LEb8IA018086;
        Fri, 21 Jun 2019 07:37:14 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH net-next 4/4] cxgb4: Add MPS refcounting for alloc/free mac filters
Date:   Fri, 21 Jun 2019 20:06:36 +0530
Message-Id: <20190621143636.20422-5-rajur@chelsio.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190621143636.20422-1-rajur@chelsio.com>
References: <20190621143636.20422-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds reference counting support for
alloc/free mac filters

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      |  6 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 12 +++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c  | 72 +++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 206332c..078b8aa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1915,6 +1915,12 @@ int cxgb4_change_mac(struct port_info *pi, unsigned int viid,
 		     int *tcam_idx, const u8 *addr,
 		     bool persistent, u8 *smt_idx);
 
+int cxgb4_alloc_mac_filt(struct adapter *adap, unsigned int viid,
+			 bool free, unsigned int naddr,
+			 const u8 **addr, u16 *idx,
+			 u64 *hash, bool sleep_ok);
+int cxgb4_free_mac_filt(struct adapter *adap, unsigned int viid,
+			unsigned int naddr, const u8 **addr, bool sleep_ok);
 int cxgb4_init_mps_ref_entries(struct adapter *adap);
 void cxgb4_free_mps_ref_entries(struct adapter *adap);
 int cxgb4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 1520e52..b08efc4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -366,13 +366,19 @@ static int cxgb4_mac_sync(struct net_device *netdev, const u8 *mac_addr)
 	int ret;
 	u64 mhash = 0;
 	u64 uhash = 0;
+	/* idx stores the index of allocated filters,
+	 * its size should be modified based on the number of
+	 * MAC addresses that we allocate filters for
+	 */
+
+	u16 idx[1] = {};
 	bool free = false;
 	bool ucast = is_unicast_ether_addr(mac_addr);
 	const u8 *maclist[1] = {mac_addr};
 	struct hash_mac_addr *new_entry;
 
-	ret = t4_alloc_mac_filt(adap, adap->mbox, pi->viid, free, 1, maclist,
-				NULL, ucast ? &uhash : &mhash, false);
+	ret = cxgb4_alloc_mac_filt(adap, pi->viid, free, 1, maclist,
+				   idx, ucast ? &uhash : &mhash, false);
 	if (ret < 0)
 		goto out;
 	/* if hash != 0, then add the addr to hash addr list
@@ -410,7 +416,7 @@ static int cxgb4_mac_unsync(struct net_device *netdev, const u8 *mac_addr)
 		}
 	}
 
-	ret = t4_free_mac_filt(adap, adap->mbox, pi->viid, 1, maclist, false);
+	ret = cxgb4_free_mac_filt(adap, pi->viid, 1, maclist, false);
 	return ret < 0 ? -EINVAL : 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
index d503baf..a9ade68 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -3,6 +3,31 @@
 
 #include "cxgb4.h"
 
+static int cxgb4_mps_ref_dec_by_mac(struct adapter *adap,
+				    const u8 *addr, const u8 *mask)
+{
+	u8 bitmask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	struct mps_entries_ref *mps_entry, *tmp;
+	int ret = -EINVAL;
+
+	spin_lock_bh(&adap->mps_ref_lock);
+	list_for_each_entry_safe(mps_entry, tmp, &adap->mps_ref, list) {
+		if (ether_addr_equal(mps_entry->addr, addr) &&
+		    ether_addr_equal(mps_entry->mask, mask ? mask : bitmask)) {
+			if (!atomic_dec_and_test(&mps_entry->refcnt)) {
+				spin_unlock_bh(&adap->mps_ref_lock);
+				return -EBUSY;
+			}
+			list_del(&mps_entry->list);
+			kfree(mps_entry);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_bh(&adap->mps_ref_lock);
+	return ret;
+}
+
 static int cxgb4_mps_ref_dec(struct adapter *adap, u16 idx)
 {
 	struct mps_entries_ref *mps_entry, *tmp;
@@ -54,6 +79,53 @@ static int cxgb4_mps_ref_inc(struct adapter *adap, const u8 *mac_addr,
 	return ret;
 }
 
+int cxgb4_free_mac_filt(struct adapter *adap, unsigned int viid,
+			unsigned int naddr, const u8 **addr, bool sleep_ok)
+{
+	int ret, i;
+
+	for (i = 0; i < naddr; i++) {
+		if (!cxgb4_mps_ref_dec_by_mac(adap, addr[i], NULL)) {
+			ret = t4_free_mac_filt(adap, adap->mbox, viid,
+					       1, &addr[i], sleep_ok);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	/* return number of filters freed */
+	return naddr;
+}
+
+int cxgb4_alloc_mac_filt(struct adapter *adap, unsigned int viid,
+			 bool free, unsigned int naddr, const u8 **addr,
+			 u16 *idx, u64 *hash, bool sleep_ok)
+{
+	int ret, i;
+
+	ret = t4_alloc_mac_filt(adap, adap->mbox, viid, free,
+				naddr, addr, idx, hash, sleep_ok);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < naddr; i++) {
+		if (idx[i] != 0xffff) {
+			if (cxgb4_mps_ref_inc(adap, addr[i], idx[i], NULL)) {
+				ret = -ENOMEM;
+				goto error;
+			}
+		}
+	}
+
+	goto out;
+error:
+	cxgb4_free_mac_filt(adap, viid, naddr, addr, sleep_ok);
+
+out:
+	/* Returns a negative error number or the number of filters allocated */
+	return ret;
+}
+
 int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
 			  int *tcam_idx, const u8 *addr,
 			  bool persistent, u8 *smt_idx)
-- 
1.8.3.1

