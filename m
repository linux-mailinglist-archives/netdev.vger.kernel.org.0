Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F1F3420
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbfKGQH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:28 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:36119 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388454AbfKGQH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:27 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7MwY024016;
        Thu, 7 Nov 2019 08:07:23 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 1/6] cxgb4: query firmware for QoS offload resources
Date:   Thu,  7 Nov 2019 21:29:04 +0530
Message-Id: <70470cd5385989ef533da128ad20373ffbf65e35.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QoS offload needs Ethernet Offload (ETHOFLD) resources present in the
NIC. These resources are shared with other ULDs. So, query firmware
for the available number of traffic classes, as well as, start and
end indices (EOTID) of the ETHOFLD region.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  6 +++
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 52 ++++++++++++++++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    | 10 ++++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  2 +
 4 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 1fbb640e896a..f2f643be7905 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -392,6 +392,7 @@ struct adapter_params {
 	struct arch_specific_params arch;  /* chip specific params */
 	unsigned char offload;
 	unsigned char crypto;		/* HW capability for crypto */
+	unsigned char ethofld;		/* QoS support */
 
 	unsigned char bypass;
 	unsigned char hash_filter;
@@ -1293,6 +1294,11 @@ static inline int is_uld(const struct adapter *adap)
 	return (adap->params.offload || adap->params.crypto);
 }
 
+static inline int is_ethofld(const struct adapter *adap)
+{
+	return adap->params.ethofld;
+}
+
 static inline u32 t4_read_reg(struct adapter *adap, u32 reg_addr)
 {
 	return readl(adap->regs + reg_addr);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 33a923cfd82e..20d1687adea2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1458,19 +1458,23 @@ static int tid_init(struct tid_info *t)
 	struct adapter *adap = container_of(t, struct adapter, tids);
 	unsigned int max_ftids = t->nftids + t->nsftids;
 	unsigned int natids = t->natids;
+	unsigned int eotid_bmap_size;
 	unsigned int stid_bmap_size;
 	unsigned int ftid_bmap_size;
 	size_t size;
 
 	stid_bmap_size = BITS_TO_LONGS(t->nstids + t->nsftids);
 	ftid_bmap_size = BITS_TO_LONGS(t->nftids);
+	eotid_bmap_size = BITS_TO_LONGS(t->neotids);
 	size = t->ntids * sizeof(*t->tid_tab) +
 	       natids * sizeof(*t->atid_tab) +
 	       t->nstids * sizeof(*t->stid_tab) +
 	       t->nsftids * sizeof(*t->stid_tab) +
 	       stid_bmap_size * sizeof(long) +
 	       max_ftids * sizeof(*t->ftid_tab) +
-	       ftid_bmap_size * sizeof(long);
+	       ftid_bmap_size * sizeof(long) +
+	       t->neotids * sizeof(*t->eotid_tab) +
+	       eotid_bmap_size * sizeof(long);
 
 	t->tid_tab = kvzalloc(size, GFP_KERNEL);
 	if (!t->tid_tab)
@@ -1481,6 +1485,8 @@ static int tid_init(struct tid_info *t)
 	t->stid_bmap = (unsigned long *)&t->stid_tab[t->nstids + t->nsftids];
 	t->ftid_tab = (struct filter_entry *)&t->stid_bmap[stid_bmap_size];
 	t->ftid_bmap = (unsigned long *)&t->ftid_tab[max_ftids];
+	t->eotid_tab = (struct eotid_entry *)&t->ftid_bmap[ftid_bmap_size];
+	t->eotid_bmap = (unsigned long *)&t->eotid_tab[t->neotids];
 	spin_lock_init(&t->stid_lock);
 	spin_lock_init(&t->atid_lock);
 	spin_lock_init(&t->ftid_lock);
@@ -1507,6 +1513,9 @@ static int tid_init(struct tid_info *t)
 		if (!t->stid_base &&
 		    CHELSIO_CHIP_VERSION(adap->params.chip) <= CHELSIO_T5)
 			__set_bit(0, t->stid_bmap);
+
+		if (t->neotids)
+			bitmap_zero(t->eotid_bmap, t->neotids);
 	}
 
 	bitmap_zero(t->ftid_bmap, t->nftids);
@@ -4604,11 +4613,18 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 	adap->clipt_start = val[0];
 	adap->clipt_end = val[1];
 
-	/* We don't yet have a PARAMs calls to retrieve the number of Traffic
-	 * Classes supported by the hardware/firmware so we hard code it here
-	 * for now.
-	 */
-	adap->params.nsched_cls = is_t4(adap->params.chip) ? 15 : 16;
+	/* Get the supported number of traffic classes */
+	params[0] = FW_PARAM_DEV(NUM_TM_CLASS);
+	ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 1, params, val);
+	if (ret < 0) {
+		/* We couldn't retrieve the number of Traffic Classes
+		 * supported by the hardware/firmware. So we hard
+		 * code it here.
+		 */
+		adap->params.nsched_cls = is_t4(adap->params.chip) ? 15 : 16;
+	} else {
+		adap->params.nsched_cls = val[0];
+	}
 
 	/* query params related to active filter region */
 	params[0] = FW_PARAM_PFVF(ACTIVE_FILTER_START);
@@ -4693,7 +4709,8 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		adap->params.offload = 1;
 
 	if (caps_cmd.ofldcaps ||
-	    (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_HASHFILTER))) {
+	    (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_HASHFILTER)) ||
+	    (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_ETHOFLD))) {
 		/* query offload-related parameters */
 		params[0] = FW_PARAM_DEV(NTID);
 		params[1] = FW_PARAM_PFVF(SERVER_START);
@@ -4735,6 +4752,19 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		} else {
 			adap->num_ofld_uld += 1;
 		}
+
+		if (caps_cmd.niccaps & htons(FW_CAPS_CONFIG_NIC_ETHOFLD)) {
+			params[0] = FW_PARAM_PFVF(ETHOFLD_START);
+			params[1] = FW_PARAM_PFVF(ETHOFLD_END);
+			ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 2,
+					      params, val);
+			if (!ret) {
+				adap->tids.eotid_base = val[0];
+				adap->tids.neotids = min_t(u32, MAX_ATIDS,
+							   val[1] - val[0] + 1);
+				adap->params.ethofld = 1;
+			}
+		}
 	}
 	if (caps_cmd.rdmacaps) {
 		params[0] = FW_PARAM_PFVF(STAG_START);
@@ -5942,8 +5972,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_LIST_HEAD(&adapter->mac_hlist);
 
 	for_each_port(adapter, i) {
+		/* For supporting MQPRIO Offload, need some extra
+		 * queues for each ETHOFLD TIDs. Keep it equal to
+		 * MAX_ATIDs for now. Once we connect to firmware
+		 * later and query the EOTID params, we'll come to
+		 * know the actual # of EOTIDs supported.
+		 */
 		netdev = alloc_etherdev_mq(sizeof(struct port_info),
-					   MAX_ETH_QSETS);
+					   MAX_ETH_QSETS + MAX_ATIDS);
 		if (!netdev) {
 			err = -ENOMEM;
 			goto out_free_dev;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index cee582e36134..b78feef23dc4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -89,6 +89,10 @@ union aopen_entry {
 	union aopen_entry *next;
 };
 
+struct eotid_entry {
+	void *data;
+};
+
 /*
  * Holds the size, base address, free list start, etc of the TID, server TID,
  * and active-open TID tables.  The tables themselves are allocated dynamically.
@@ -126,6 +130,12 @@ struct tid_info {
 	unsigned int v6_stids_in_use;
 	unsigned int sftids_in_use;
 
+	/* ETHOFLD range */
+	struct eotid_entry *eotid_tab;
+	unsigned long *eotid_bmap;
+	unsigned int eotid_base;
+	unsigned int neotids;
+
 	/* TIDs in the TCAM */
 	atomic_t tids_in_use;
 	/* TIDs in the HASH */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index 65313f6b5704..d603334bae95 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1134,6 +1134,7 @@ enum fw_caps_config_nic {
 	FW_CAPS_CONFIG_NIC		= 0x00000001,
 	FW_CAPS_CONFIG_NIC_VM		= 0x00000002,
 	FW_CAPS_CONFIG_NIC_HASHFILTER	= 0x00000020,
+	FW_CAPS_CONFIG_NIC_ETHOFLD	= 0x00000040,
 };
 
 enum fw_caps_config_ofld {
@@ -1276,6 +1277,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD = 0x28,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMER	= 0x29,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMERTICK = 0x2A,
+	FW_PARAMS_PARAM_DEV_NUM_TM_CLASS = 0x2B,
 	FW_PARAMS_PARAM_DEV_FILTER = 0x2E,
 };
 
-- 
2.23.0

