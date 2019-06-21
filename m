Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732AC4EAD8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfFUOhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:37:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:29927 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfFUOhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 10:37:06 -0400
Received: from localhost ([10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5LEb2UO018074;
        Fri, 21 Jun 2019 07:37:03 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH net-next 1/4] cxgb4: Re-work the logic for mps refcounting
Date:   Fri, 21 Jun 2019 20:06:33 +0530
Message-Id: <20190621143636.20422-2-rajur@chelsio.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190621143636.20422-1-rajur@chelsio.com>
References: <20190621143636.20422-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove existing mps refcounting code which was
added only for encap filters and add necessary
data structures/functions to support mps reference
counting for all the mac filters. Also add wrapper
functions for allocating and freeing encap mac
filters.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/Makefile       |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h        |  24 ++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  14 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c    | 109 ++++++++++++++++++++++
 5 files changed, 135 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c

diff --git a/drivers/net/ethernet/chelsio/cxgb4/Makefile b/drivers/net/ethernet/chelsio/cxgb4/Makefile
index 91d8a88..20390f6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/Makefile
+++ b/drivers/net/ethernet/chelsio/cxgb4/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_CHELSIO_T4) += cxgb4.o
 
 cxgb4-objs := cxgb4_main.o l2t.o smt.o t4_hw.o sge.o clip_tbl.o cxgb4_ethtool.o \
 	      cxgb4_uld.o srq.o sched.o cxgb4_filter.o cxgb4_tc_u32.o \
-	      cxgb4_ptp.o cxgb4_tc_flower.o cxgb4_cudbg.o \
+	      cxgb4_ptp.o cxgb4_tc_flower.o cxgb4_cudbg.o cxgb4_mps.o \
 	      cudbg_common.o cudbg_lib.o cudbg_zlib.o
 cxgb4-$(CONFIG_CHELSIO_T4_DCB) +=  cxgb4_dcb.o
 cxgb4-$(CONFIG_CHELSIO_T4_FCOE) +=  cxgb4_fcoe.o
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index db2ec46..937815d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -905,10 +905,6 @@ struct mbox_list {
 	struct list_head list;
 };
 
-struct mps_encap_entry {
-	atomic_t refcnt;
-};
-
 #if IS_ENABLED(CONFIG_THERMAL)
 struct ch_thermal {
 	struct thermal_zone_device *tzdev;
@@ -917,6 +913,14 @@ struct ch_thermal {
 };
 #endif
 
+struct mps_entries_ref {
+	struct list_head list;
+	u8 addr[ETH_ALEN];
+	u8 mask[ETH_ALEN];
+	u16 idx;
+	atomic_t refcnt;
+};
+
 struct adapter {
 	void __iomem *regs;
 	void __iomem *bar2;
@@ -969,7 +973,6 @@ struct adapter {
 	unsigned int rawf_start;
 	unsigned int rawf_cnt;
 	struct smt_data *smt;
-	struct mps_encap_entry *mps_encap;
 	struct cxgb4_uld_info *uld;
 	void *uld_handle[CXGB4_ULD_MAX];
 	unsigned int num_uld;
@@ -977,6 +980,8 @@ struct adapter {
 	struct list_head list_node;
 	struct list_head rcu_node;
 	struct list_head mac_hlist; /* list of MAC addresses in MPS Hash */
+	struct list_head mps_ref;
+	spinlock_t mps_ref_lock; /* lock for syncing mps ref/def activities */
 
 	void *iscsi_ppm;
 
@@ -1906,4 +1911,13 @@ int cxgb4_set_msix_aff(struct adapter *adap, unsigned short vec,
 		       cpumask_var_t *aff_mask, int idx);
 void cxgb4_clear_msix_aff(unsigned short vec, cpumask_var_t aff_mask);
 
+int cxgb4_init_mps_ref_entries(struct adapter *adap);
+void cxgb4_free_mps_ref_entries(struct adapter *adap);
+int cxgb4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
+			       const u8 *addr, const u8 *mask,
+			       unsigned int vni, unsigned int vni_mask,
+			       u8 dip_hit, u8 lookup_type, bool sleep_ok);
+int cxgb4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
+			      int idx, bool sleep_ok);
+
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 6232236..43b0f8c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -727,10 +727,8 @@ void clear_filter(struct adapter *adap, struct filter_entry *f)
 		cxgb4_smt_release(f->smt);
 
 	if (f->fs.val.encap_vld && f->fs.val.ovlan_vld)
-		if (atomic_dec_and_test(&adap->mps_encap[f->fs.val.ovlan &
-							 0x1ff].refcnt))
-			t4_free_encap_mac_filt(adap, pi->viid,
-					       f->fs.val.ovlan & 0x1ff, 0);
+		t4_free_encap_mac_filt(adap, pi->viid,
+				       f->fs.val.ovlan & 0x1ff, 0);
 
 	if ((f->fs.hash || is_t6(adap->params.chip)) && f->fs.type)
 		cxgb4_clip_release(f->dev, (const u32 *)&f->fs.val.lip, 1);
@@ -1177,7 +1175,6 @@ static int cxgb4_set_hash_filter(struct net_device *dev,
 			if (ret < 0)
 				goto free_atid;
 
-			atomic_inc(&adapter->mps_encap[ret].refcnt);
 			f->fs.val.ovlan = ret;
 			f->fs.mask.ovlan = 0xffff;
 			f->fs.val.ovlan_vld = 1;
@@ -1420,7 +1417,6 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 			if (ret < 0)
 				goto free_clip;
 
-			atomic_inc(&adapter->mps_encap[ret].refcnt);
 			f->fs.val.ovlan = ret;
 			f->fs.mask.ovlan = 0x1ff;
 			f->fs.val.ovlan_vld = 1;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 5490800..4632827 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3273,8 +3273,6 @@ static void cxgb_del_udp_tunnel(struct net_device *netdev,
 				    i);
 			return;
 		}
-		atomic_dec(&adapter->mps_encap[adapter->rawf_start +
-			   pi->port_id].refcnt);
 	}
 }
 
@@ -3363,7 +3361,6 @@ static void cxgb_add_udp_tunnel(struct net_device *netdev,
 			cxgb_del_udp_tunnel(netdev, ti);
 			return;
 		}
-		atomic_inc(&adapter->mps_encap[ret].refcnt);
 	}
 }
 
@@ -5446,7 +5443,6 @@ static void free_some_resources(struct adapter *adapter)
 {
 	unsigned int i;
 
-	kvfree(adapter->mps_encap);
 	kvfree(adapter->smt);
 	kvfree(adapter->l2t);
 	kvfree(adapter->srq);
@@ -5972,12 +5968,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		adapter->params.offload = 0;
 	}
 
-	adapter->mps_encap = kvcalloc(adapter->params.arch.mps_tcam_size,
-				      sizeof(struct mps_encap_entry),
-				      GFP_KERNEL);
-	if (!adapter->mps_encap)
-		dev_warn(&pdev->dev, "could not allocate MPS Encap entries, continuing\n");
-
 #if IS_ENABLED(CONFIG_IPV6)
 	if (chip_ver <= CHELSIO_T5 &&
 	    (!(t4_read_reg(adapter, LE_DB_CONFIG_A) & ASLIPCOMPEN_F))) {
@@ -6053,6 +6043,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* check for PCI Express bandwidth capabiltites */
 	pcie_print_link_status(pdev);
 
+	cxgb4_init_mps_ref_entries(adapter);
+
 	err = init_rss(adapter);
 	if (err)
 		goto out_free_dev;
@@ -6179,6 +6171,8 @@ static void remove_one(struct pci_dev *pdev)
 
 		disable_interrupts(adapter);
 
+		cxgb4_free_mps_ref_entries(adapter);
+
 		for_each_port(adapter, i)
 			if (adapter->port[i]->reg_state == NETREG_REGISTERED)
 				unregister_netdev(adapter->port[i]);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
new file mode 100644
index 0000000..8b3a61a
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Chelsio Communications, Inc. All rights reserved. */
+
+#include "cxgb4.h"
+
+static int cxgb4_mps_ref_dec(struct adapter *adap, u16 idx)
+{
+	struct mps_entries_ref *mps_entry, *tmp;
+	int ret = -EINVAL;
+
+	spin_lock(&adap->mps_ref_lock);
+	list_for_each_entry_safe(mps_entry, tmp, &adap->mps_ref, list) {
+		if (mps_entry->idx == idx) {
+			if (!atomic_dec_and_test(&mps_entry->refcnt)) {
+				spin_unlock(&adap->mps_ref_lock);
+				return -EBUSY;
+			}
+			list_del(&mps_entry->list);
+			kfree(mps_entry);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock(&adap->mps_ref_lock);
+	return ret;
+}
+
+static int cxgb4_mps_ref_inc(struct adapter *adap, const u8 *mac_addr,
+			     u16 idx, const u8 *mask)
+{
+	u8 bitmask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	struct mps_entries_ref *mps_entry;
+	int ret = 0;
+
+	spin_lock_bh(&adap->mps_ref_lock);
+	list_for_each_entry(mps_entry, &adap->mps_ref, list) {
+		if (mps_entry->idx == idx) {
+			atomic_inc(&mps_entry->refcnt);
+			goto unlock;
+		}
+	}
+	mps_entry = kzalloc(sizeof(*mps_entry), GFP_ATOMIC);
+	if (!mps_entry) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	ether_addr_copy(mps_entry->mask, mask ? mask : bitmask);
+	ether_addr_copy(mps_entry->addr, mac_addr);
+	mps_entry->idx = idx;
+	atomic_inc(&mps_entry->refcnt);
+	list_add_tail(&mps_entry->list, &adap->mps_ref);
+unlock:
+	spin_unlock_bh(&adap->mps_ref_lock);
+	return ret;
+}
+
+int cxgb4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
+			      int idx, bool sleep_ok)
+{
+	int ret = 0;
+
+	if (!cxgb4_mps_ref_dec(adap, idx))
+		ret = t4_free_encap_mac_filt(adap, viid, idx, sleep_ok);
+
+	return ret;
+}
+
+int cxgb4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
+			       const u8 *addr, const u8 *mask,
+			       unsigned int vni, unsigned int vni_mask,
+			       u8 dip_hit, u8 lookup_type, bool sleep_ok)
+{
+	int ret;
+
+	ret = t4_alloc_encap_mac_filt(adap, viid, addr, mask, vni, vni_mask,
+				      dip_hit, lookup_type, sleep_ok);
+	if (ret < 0)
+		return ret;
+
+	if (cxgb4_mps_ref_inc(adap, addr, ret, mask)) {
+		ret = -ENOMEM;
+		t4_free_encap_mac_filt(adap, viid, ret, sleep_ok);
+	}
+	return ret;
+}
+
+int cxgb4_init_mps_ref_entries(struct adapter *adap)
+{
+	spin_lock_init(&adap->mps_ref_lock);
+	INIT_LIST_HEAD(&adap->mps_ref);
+
+	return 0;
+}
+
+void cxgb4_free_mps_ref_entries(struct adapter *adap)
+{
+	struct mps_entries_ref *mps_entry, *tmp;
+
+	if (!list_empty(&adap->mps_ref))
+		return;
+
+	spin_lock(&adap->mps_ref_lock);
+	list_for_each_entry_safe(mps_entry, tmp, &adap->mps_ref, list) {
+		list_del(&mps_entry->list);
+		kfree(mps_entry);
+	}
+	spin_unlock(&adap->mps_ref_lock);
+}
+
-- 
1.8.3.1

