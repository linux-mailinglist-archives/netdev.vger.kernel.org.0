Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E3F200B4E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFSOWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:7956 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFSOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:10 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbc002529;
        Fri, 19 Jun 2020 07:22:02 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 1/5] cxgb4: add skeleton for ethtool n-tuple filters
Date:   Fri, 19 Jun 2020 19:51:35 +0530
Message-Id: <20200619142139.27982-2-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate and manage resources required for ethtool n-tuple filters.
Also fetch the HASH filter region size and calculate nhash entries.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    | 14 ++++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 82 +++++++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |  2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 38 +++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  4 +
 6 files changed, 126 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 999816273328..466a61ba23ce 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1066,6 +1066,17 @@ struct mps_entries_ref {
 	refcount_t refcnt;
 };
 
+struct cxgb4_ethtool_filter_info {
+	u32 *loc_array; /* Array holding the actual TIDs set to filters */
+	unsigned long *bmap; /* Bitmap for managing filters in use */
+	u32 in_use; /* # of filters in use */
+};
+
+struct cxgb4_ethtool_filter {
+	u32 nentries; /* Adapter wide number of supported filters */
+	struct cxgb4_ethtool_filter_info *port; /* Per port entry */
+};
+
 struct adapter {
 	void __iomem *regs;
 	void __iomem *bar2;
@@ -1191,6 +1202,9 @@ struct adapter {
 
 	/* TC MATCHALL classifier offload */
 	struct cxgb4_tc_matchall *tc_matchall;
+
+	/* Ethtool n-tuple */
+	struct cxgb4_ethtool_filter *ethtool_filters;
 };
 
 /* Support for "sched-class" command to allow a TX Scheduling Class to be
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 0bfdc97e9083..51f1d5f87bc3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -10,6 +10,7 @@
 #include "t4_regs.h"
 #include "t4fw_api.h"
 #include "cxgb4_cudbg.h"
+#include "cxgb4_filter.h"
 
 #define EEPROM_MAGIC 0x38E2F10C
 
@@ -1853,6 +1854,87 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.set_priv_flags    = cxgb4_set_priv_flags,
 };
 
+void cxgb4_cleanup_ethtool_filters(struct adapter *adap)
+{
+	struct cxgb4_ethtool_filter_info *eth_filter_info;
+	u8 i;
+
+	if (!adap->ethtool_filters)
+		return;
+
+	eth_filter_info = adap->ethtool_filters->port;
+
+	if (eth_filter_info) {
+		for (i = 0; i < adap->params.nports; i++) {
+			kvfree(eth_filter_info[i].loc_array);
+			kfree(eth_filter_info[i].bmap);
+		}
+		kfree(eth_filter_info);
+	}
+
+	kfree(adap->ethtool_filters);
+}
+
+int cxgb4_init_ethtool_filters(struct adapter *adap)
+{
+	struct cxgb4_ethtool_filter_info *eth_filter_info;
+	struct cxgb4_ethtool_filter *eth_filter;
+	struct tid_info *tids = &adap->tids;
+	u32 nentries, i;
+	int ret;
+
+	eth_filter = kzalloc(sizeof(*eth_filter), GFP_KERNEL);
+	if (!eth_filter)
+		return -ENOMEM;
+
+	eth_filter_info = kcalloc(adap->params.nports,
+				  sizeof(*eth_filter_info),
+				  GFP_KERNEL);
+	if (!eth_filter_info) {
+		ret = -ENOMEM;
+		goto free_eth_filter;
+	}
+
+	eth_filter->port = eth_filter_info;
+
+	nentries = tids->nhpftids + tids->nftids;
+	if (is_hashfilter(adap))
+		nentries += tids->nhash +
+			    (adap->tids.stid_base - adap->tids.tid_base);
+	eth_filter->nentries = nentries;
+
+	for (i = 0; i < adap->params.nports; i++) {
+		eth_filter->port[i].loc_array = kvzalloc(nentries, GFP_KERNEL);
+		if (!eth_filter->port[i].loc_array) {
+			ret = -ENOMEM;
+			goto free_eth_finfo;
+		}
+
+		eth_filter->port[i].bmap = kcalloc(BITS_TO_LONGS(nentries),
+						   sizeof(unsigned long),
+						   GFP_KERNEL);
+		if (!eth_filter->port[i].bmap) {
+			ret = -ENOMEM;
+			goto free_eth_finfo;
+		}
+	}
+
+	adap->ethtool_filters = eth_filter;
+	return 0;
+
+free_eth_finfo:
+	while (i-- > 0) {
+		kfree(eth_filter->port[i].bmap);
+		kvfree(eth_filter->port[i].loc_array);
+	}
+	kfree(eth_filter_info);
+
+free_eth_filter:
+	kfree(eth_filter);
+
+	return ret;
+}
+
 void cxgb4_set_ethtool_ops(struct net_device *netdev)
 {
 	netdev->ethtool_ops = &cxgb_ethtool_ops;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
index b0751c0611ec..807a8dafec45 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
@@ -53,4 +53,6 @@ void clear_all_filters(struct adapter *adapter);
 void init_hash_filter(struct adapter *adap);
 bool is_filter_exact_match(struct adapter *adap,
 			   struct ch_filter_specification *fs);
+void cxgb4_cleanup_ethtool_filters(struct adapter *adap);
+int cxgb4_init_ethtool_filters(struct adapter *adap);
 #endif /* __CXGB4_FILTER_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 854b1717a70d..501917751b7f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5860,6 +5860,7 @@ static void free_some_resources(struct adapter *adapter)
 	cxgb4_cleanup_tc_mqprio(adapter);
 	cxgb4_cleanup_tc_flower(adapter);
 	cxgb4_cleanup_tc_u32(adapter);
+	cxgb4_cleanup_ethtool_filters(adapter);
 	kfree(adapter->sge.egr_map);
 	kfree(adapter->sge.ingr_map);
 	kfree(adapter->sge.starving_fl);
@@ -6493,6 +6494,24 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				 i);
 	}
 
+	if (is_offload(adapter) || is_hashfilter(adapter)) {
+		if (t4_read_reg(adapter, LE_DB_CONFIG_A) & HASHEN_F) {
+			u32 v;
+
+			v = t4_read_reg(adapter, LE_DB_HASH_CONFIG_A);
+			if (chip_ver <= CHELSIO_T5) {
+				adapter->tids.nhash = 1 << HASHTIDSIZE_G(v);
+				v = t4_read_reg(adapter, LE_DB_TID_HASHBASE_A);
+				adapter->tids.hash_base = v / 4;
+			} else {
+				adapter->tids.nhash = HASHTBLSIZE_G(v) << 3;
+				v = t4_read_reg(adapter,
+						T6_LE_DB_HASH_TID_BASE_A);
+				adapter->tids.hash_base = v;
+			}
+		}
+	}
+
 	if (tid_init(&adapter->tids) < 0) {
 		dev_warn(&pdev->dev, "could not allocate TID table, "
 			 "continuing\n");
@@ -6514,22 +6533,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (cxgb4_init_tc_matchall(adapter))
 			dev_warn(&pdev->dev,
 				 "could not offload tc matchall, continuing\n");
-	}
-
-	if (is_offload(adapter) || is_hashfilter(adapter)) {
-		if (t4_read_reg(adapter, LE_DB_CONFIG_A) & HASHEN_F) {
-			u32 hash_base, hash_reg;
-
-			if (chip_ver <= CHELSIO_T5) {
-				hash_reg = LE_DB_TID_HASHBASE_A;
-				hash_base = t4_read_reg(adapter, hash_reg);
-				adapter->tids.hash_base = hash_base / 4;
-			} else {
-				hash_reg = T6_LE_DB_HASH_TID_BASE_A;
-				hash_base = t4_read_reg(adapter, hash_reg);
-				adapter->tids.hash_base = hash_base;
-			}
-		}
+		if (cxgb4_init_ethtool_filters(adapter))
+			dev_warn(&pdev->dev,
+				 "could not initialize ethtool filters, continuing\n");
 	}
 
 	/* See what interrupts we'll be using */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index dbce99b209d6..a963fd0b4540 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -106,6 +106,8 @@ struct tid_info {
 	unsigned long *stid_bmap;
 	unsigned int nstids;
 	unsigned int stid_base;
+
+	unsigned int nhash;
 	unsigned int hash_base;
 
 	union aopen_entry *atid_tab;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index 4b697550f08d..065c01c654ff 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -3044,6 +3044,10 @@
 #define HASHTIDSIZE_M    0x3fU
 #define HASHTIDSIZE_G(x) (((x) >> HASHTIDSIZE_S) & HASHTIDSIZE_M)
 
+#define HASHTBLSIZE_S    3
+#define HASHTBLSIZE_M    0x1ffffU
+#define HASHTBLSIZE_G(x) (((x) >> HASHTBLSIZE_S) & HASHTBLSIZE_M)
+
 #define LE_DB_HASH_TID_BASE_A 0x19c30
 #define LE_DB_HASH_TBL_BASE_ADDR_A 0x19c30
 #define LE_DB_INT_CAUSE_A 0x19c3c
-- 
2.21.1

