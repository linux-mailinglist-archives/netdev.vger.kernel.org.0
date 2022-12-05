Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D172B642355
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiLEHFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiLEHFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:05:40 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11DDC74E;
        Sun,  4 Dec 2022 23:05:38 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B50UjE4018131;
        Sun, 4 Dec 2022 23:05:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CpNFlSq8bxVo+CgJQDKSAXMnU7E4NUQxMDf/tmLOSLE=;
 b=Af/1LdA4Mw2wWVYcQFVi02p0ld0uKp6vRRZJHW/SkwAsTBqklE1v28dJilKlbsuM/wDG
 4Gg+2CLUEPVmXzEl4199PbIV2ntKjUhFAdfkv+Ti8FCDrke2GdQ20votBVSqDhVxKIMB
 TK522ObnPGEbETwgWYmxBNQTNcdKlNjbd2K3FaDqXaAXzP7NUlEJRczcuSGjJ6Euf/oz
 myUKo+WrkKIrFpHo7oRmgUcDa1baeSDAxFRom880rWKqhpM8P6oACmLNxsU7YPHiHwee
 wReKRQck1djcRVlgRU+pyOJXmjs/crIMB0e8/THO1yrMzqYPTaZSVIBV/Kbs+HieAvSo cg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m84pumnvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Dec 2022 23:05:31 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 4 Dec
 2022 23:05:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 4 Dec 2022 23:05:29 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 25A943F7098;
        Sun,  4 Dec 2022 23:05:25 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next Patch v4 1/4] octeontx2-af: Support variable number of lmacs
Date:   Mon, 5 Dec 2022 12:35:18 +0530
Message-ID: <20221205070521.21860-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221205070521.21860-1-hkelam@marvell.com>
References: <20221205070521.21860-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QE8NdAeQHlj6zenYOJQzQm0BnEBH4z9N
X-Proofpoint-GUID: QE8NdAeQHlj6zenYOJQzQm0BnEBH4z9N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu Saladi <rsaladi2@marvell.com>

Most of the code in CGX/RPM driver assumes that max lmacs per
given MAC as always, 4 and the number of MAC blocks also as 4.
With this assumption, the max number of interfaces supported is
hardcoded to 16. This creates a problem as next gen CN10KB silicon
MAC supports 8 lmacs per MAC block.

This patch solves the problem by using "max lmac per MAC block"
value from constant csrs and uses cgx_cnt_max value which is
populated based number of MAC blocks supported by silicon.

Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 35 ++++++++-----------
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  6 ++--
 .../marvell/octeontx2/af/lmac_common.h        |  5 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 26 ++++++++------
 .../marvell/octeontx2/af/rvu_debugfs.c        |  2 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  2 +-
 .../marvell/octeontx2/af/rvu_npc_hash.c       |  4 ++-
 8 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index c8724bfa86b0..fa5a1e88cb84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -78,7 +78,7 @@ static bool is_dev_rpm(void *cgxd)
 
 bool is_lmac_valid(struct cgx *cgx, int lmac_id)
 {
-	if (!cgx || lmac_id < 0 || lmac_id >= MAX_LMAC_PER_CGX)
+	if (!cgx || lmac_id < 0 || lmac_id >= cgx->max_lmac_per_mac)
 		return false;
 	return test_bit(lmac_id, &cgx->lmac_bmap);
 }
@@ -90,7 +90,7 @@ static int get_sequence_id_of_lmac(struct cgx *cgx, int lmac_id)
 {
 	int tmp, id = 0;
 
-	for_each_set_bit(tmp, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
+	for_each_set_bit(tmp, &cgx->lmac_bmap, cgx->max_lmac_per_mac) {
 		if (tmp == lmac_id)
 			break;
 		id++;
@@ -121,7 +121,7 @@ u64 cgx_read(struct cgx *cgx, u64 lmac, u64 offset)
 
 struct lmac *lmac_pdata(u8 lmac_id, struct cgx *cgx)
 {
-	if (!cgx || lmac_id >= MAX_LMAC_PER_CGX)
+	if (!cgx || lmac_id >= cgx->max_lmac_per_mac)
 		return NULL;
 
 	return cgx->lmac_idmap[lmac_id];
@@ -1395,7 +1395,7 @@ int cgx_get_fwdata_base(u64 *base)
 	if (!cgx)
 		return -ENXIO;
 
-	first_lmac = find_first_bit(&cgx->lmac_bmap, MAX_LMAC_PER_CGX);
+	first_lmac = find_first_bit(&cgx->lmac_bmap, cgx->max_lmac_per_mac);
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_FWD_BASE, req);
 	err = cgx_fwi_cmd_generic(req, &resp, cgx, first_lmac);
 	if (!err)
@@ -1484,7 +1484,7 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 
 static inline int cgx_fwi_read_version(u64 *resp, struct cgx *cgx)
 {
-	int first_lmac = find_first_bit(&cgx->lmac_bmap, MAX_LMAC_PER_CGX);
+	int first_lmac = find_first_bit(&cgx->lmac_bmap, cgx->max_lmac_per_mac);
 	u64 req = 0;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_FW_VER, req);
@@ -1522,7 +1522,7 @@ static void cgx_lmac_linkup_work(struct work_struct *work)
 	int i, err;
 
 	/* Do Link up for all the enabled lmacs */
-	for_each_set_bit(i, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
+	for_each_set_bit(i, &cgx->lmac_bmap, cgx->max_lmac_per_mac) {
 		err = cgx_fwi_link_change(cgx, i, true);
 		if (err)
 			dev_info(dev, "cgx port %d:%d Link up command failed\n",
@@ -1542,14 +1542,6 @@ int cgx_lmac_linkup_start(void *cgxd)
 	return 0;
 }
 
-static void cgx_lmac_get_fifolen(struct cgx *cgx)
-{
-	u64 cfg;
-
-	cfg = cgx_read(cgx, 0, CGX_CONST);
-	cgx->mac_ops->fifo_len = FIELD_GET(CGX_CONST_RXFIFO_SIZE, cfg);
-}
-
 static int cgx_configure_interrupt(struct cgx *cgx, struct lmac *lmac,
 				   int cnt, bool req_free)
 {
@@ -1604,17 +1596,14 @@ static int cgx_lmac_init(struct cgx *cgx)
 	u64 lmac_list;
 	int i, err;
 
-	cgx_lmac_get_fifolen(cgx);
-
-	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
 	/* lmac_list specifies which lmacs are enabled
 	 * when bit n is set to 1, LMAC[n] is enabled
 	 */
 	if (cgx->mac_ops->non_contiguous_serdes_lane)
 		lmac_list = cgx_read(cgx, 0, CGXX_CMRX_RX_LMACS) & 0xFULL;
 
-	if (cgx->lmac_count > MAX_LMAC_PER_CGX)
-		cgx->lmac_count = MAX_LMAC_PER_CGX;
+	if (cgx->lmac_count > cgx->max_lmac_per_mac)
+		cgx->lmac_count = cgx->max_lmac_per_mac;
 
 	for (i = 0; i < cgx->lmac_count; i++) {
 		lmac = kzalloc(sizeof(struct lmac), GFP_KERNEL);
@@ -1692,7 +1681,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 	}
 
 	/* Free all lmac related resources */
-	for_each_set_bit(i, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
+	for_each_set_bit(i, &cgx->lmac_bmap, cgx->max_lmac_per_mac) {
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
@@ -1708,6 +1697,12 @@ static int cgx_lmac_exit(struct cgx *cgx)
 
 static void cgx_populate_features(struct cgx *cgx)
 {
+	u64 cfg;
+
+	cfg = cgx_read(cgx, 0, CGX_CONST);
+	cgx->mac_ops->fifo_len = FIELD_GET(CGX_CONST_RXFIFO_SIZE, cfg);
+	cgx->max_lmac_per_mac = FIELD_GET(CGX_CONST_MAX_LMACS, cfg);
+
 	if (is_dev_rpm(cgx))
 		cgx->hw_features = (RVU_LMAC_FEAT_DMACF | RVU_MAC_RPM |
 				    RVU_LMAC_FEAT_FC | RVU_LMAC_FEAT_PTP);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 0b06788b8d80..ce66c7271e3a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -18,11 +18,8 @@
 /* PCI BAR nos */
 #define PCI_CFG_REG_BAR_NUM		0
 
-#define CGX_ID_MASK			0x7
-#define MAX_LMAC_PER_CGX		4
+#define CGX_ID_MASK			0xF
 #define MAX_DMAC_ENTRIES_PER_CGX	32
-#define CGX_FIFO_LEN			65536 /* 64K for both Rx & Tx */
-#define CGX_OFFSET(x)			((x) * MAX_LMAC_PER_CGX)
 
 /* Registers */
 #define CGXX_CMRX_CFG			0x00
@@ -57,6 +54,7 @@
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
 #define CGX_CONST_RXFIFO_SIZE	        GENMASK_ULL(23, 0)
+#define CGX_CONST_MAX_LMACS	        GENMASK_ULL(31, 24)
 #define CGXX_SPUX_CONTROL1		0x10000
 #define CGXX_SPUX_LNX_FEC_CORR_BLOCKS	0x10700
 #define CGXX_SPUX_LNX_FEC_UNCORR_BLOCKS	0x10800
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 52b6016789fa..697cfec74aa1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -128,7 +128,10 @@ struct cgx {
 	struct pci_dev		*pdev;
 	u8			cgx_id;
 	u8			lmac_count;
-	struct lmac		*lmac_idmap[MAX_LMAC_PER_CGX];
+	/* number of LMACs per MAC could be 4 or 8 */
+	u8			max_lmac_per_mac;
+#define MAX_LMAC_COUNT		8
+	struct lmac             *lmac_idmap[MAX_LMAC_COUNT];
 	struct			work_struct cgx_cmd_work;
 	struct			workqueue_struct *cgx_cmd_workq;
 	struct list_head	cgx_list;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index f718cbd32a94..04333f127282 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -478,7 +478,7 @@ struct rvu {
 	u8			cgx_mapped_pfs;
 	u8			cgx_cnt_max;	 /* CGX port count max */
 	u8			*pf2cgxlmac_map; /* pf to cgx_lmac map */
-	u16			*cgxlmac2pf_map; /* bitmap of mapped pfs for
+	u64			*cgxlmac2pf_map; /* bitmap of mapped pfs for
 						  * every cgx lmac port
 						  */
 	unsigned long		pf_notify_bmap; /* Flags for PF notification */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index addc69f4b65c..8d9f9bbc262b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -55,8 +55,9 @@ bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature)
 	return  (cgx_features_get(cgxd) & feature);
 }
 
+#define CGX_OFFSET(x)			((x) * rvu->hw->lmac_per_cgx)
 /* Returns bitmap of mapped PFs */
-static u16 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
+static u64 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
 {
 	return rvu->cgxlmac2pf_map[CGX_OFFSET(cgx_id) + lmac_id];
 }
@@ -71,7 +72,8 @@ int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)
 	if (!pfmap)
 		return -ENODEV;
 	else
-		return find_first_bit(&pfmap, 16);
+		return find_first_bit(&pfmap,
+				      rvu->cgx_cnt_max * rvu->hw->lmac_per_cgx);
 }
 
 static u8 cgxlmac_id_to_bmap(u8 cgx_id, u8 lmac_id)
@@ -129,14 +131,14 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 	if (!cgx_cnt_max)
 		return 0;
 
-	if (cgx_cnt_max > 0xF || MAX_LMAC_PER_CGX > 0xF)
+	if (cgx_cnt_max > 0xF || rvu->hw->lmac_per_cgx > 0xF)
 		return -EINVAL;
 
 	/* Alloc map table
 	 * An additional entry is required since PF id starts from 1 and
 	 * hence entry at offset 0 is invalid.
 	 */
-	size = (cgx_cnt_max * MAX_LMAC_PER_CGX + 1) * sizeof(u8);
+	size = (cgx_cnt_max * rvu->hw->lmac_per_cgx + 1) * sizeof(u8);
 	rvu->pf2cgxlmac_map = devm_kmalloc(rvu->dev, size, GFP_KERNEL);
 	if (!rvu->pf2cgxlmac_map)
 		return -ENOMEM;
@@ -145,9 +147,10 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 	memset(rvu->pf2cgxlmac_map, 0xFF, size);
 
 	/* Reverse map table */
-	rvu->cgxlmac2pf_map = devm_kzalloc(rvu->dev,
-				  cgx_cnt_max * MAX_LMAC_PER_CGX * sizeof(u16),
-				  GFP_KERNEL);
+	rvu->cgxlmac2pf_map =
+		devm_kzalloc(rvu->dev,
+			     cgx_cnt_max * rvu->hw->lmac_per_cgx * sizeof(u64),
+			     GFP_KERNEL);
 	if (!rvu->cgxlmac2pf_map)
 		return -ENOMEM;
 
@@ -156,7 +159,7 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 		if (!rvu_cgx_pdata(cgx, rvu))
 			continue;
 		lmac_bmap = cgx_get_lmac_bmap(rvu_cgx_pdata(cgx, rvu));
-		for_each_set_bit(iter, &lmac_bmap, MAX_LMAC_PER_CGX) {
+		for_each_set_bit(iter, &lmac_bmap, rvu->hw->lmac_per_cgx) {
 			lmac = cgx_get_lmacid(rvu_cgx_pdata(cgx, rvu),
 					      iter);
 			rvu->pf2cgxlmac_map[pf] = cgxlmac_id_to_bmap(cgx, lmac);
@@ -235,7 +238,8 @@ static void cgx_notify_pfs(struct cgx_link_event *event, struct rvu *rvu)
 	pfmap = cgxlmac_to_pfmap(rvu, event->cgx_id, event->lmac_id);
 
 	do {
-		pfid = find_first_bit(&pfmap, 16);
+		pfid = find_first_bit(&pfmap,
+				      rvu->cgx_cnt_max * rvu->hw->lmac_per_cgx);
 		clear_bit(pfid, &pfmap);
 
 		/* check if notification is enabled */
@@ -310,7 +314,7 @@ static int cgx_lmac_event_handler_init(struct rvu *rvu)
 		if (!cgxd)
 			continue;
 		lmac_bmap = cgx_get_lmac_bmap(cgxd);
-		for_each_set_bit(lmac, &lmac_bmap, MAX_LMAC_PER_CGX) {
+		for_each_set_bit(lmac, &lmac_bmap, rvu->hw->lmac_per_cgx) {
 			err = cgx_lmac_evh_register(&cb, cgxd, lmac);
 			if (err)
 				dev_err(rvu->dev,
@@ -396,7 +400,7 @@ int rvu_cgx_exit(struct rvu *rvu)
 		if (!cgxd)
 			continue;
 		lmac_bmap = cgx_get_lmac_bmap(cgxd);
-		for_each_set_bit(lmac, &lmac_bmap, MAX_LMAC_PER_CGX)
+		for_each_set_bit(lmac, &lmac_bmap, rvu->hw->lmac_per_cgx)
 			cgx_lmac_evh_unregister(cgxd, lmac);
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 0eb3085c4c21..fa280ebd3052 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2613,7 +2613,7 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 		rvu->rvu_dbg.cgx = debugfs_create_dir(dname,
 						      rvu->rvu_dbg.cgx_root);
 
-		for_each_set_bit(lmac_id, &lmac_bmap, MAX_LMAC_PER_CGX) {
+		for_each_set_bit(lmac_id, &lmac_bmap, rvu->hw->lmac_per_cgx) {
 			/* lmac debugfs dir */
 			sprintf(dname, "lmac%d", lmac_id);
 			rvu->rvu_dbg.lmac =
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index a62c1b322012..de489e7366da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4109,7 +4109,7 @@ static void nix_link_config(struct rvu *rvu, int blkaddr,
 
 		/* Get LMAC id's from bitmap */
 		lmac_bmap = cgx_get_lmac_bmap(rvu_cgx_pdata(cgx, rvu));
-		for_each_set_bit(iter, &lmac_bmap, MAX_LMAC_PER_CGX) {
+		for_each_set_bit(iter, &lmac_bmap, rvu->hw->lmac_per_cgx) {
 			lmac_fifo_len = rvu_cgx_get_lmac_fifolen(rvu, cgx, iter);
 			if (!lmac_fifo_len) {
 				dev_err(rvu->dev,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 00aef8f5ac29..f69102d20c90 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1956,7 +1956,9 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	/* Install SDP drop rule */
 	drop_mcam_idx = &table->num_drop_rules;
 
-	max_lmac_cnt = rvu->cgx_cnt_max * MAX_LMAC_PER_CGX + PF_CGXMAP_BASE;
+	max_lmac_cnt = rvu->cgx_cnt_max * rvu->hw->lmac_per_cgx +
+		       PF_CGXMAP_BASE;
+
 	for (i = PF_CGXMAP_BASE; i < max_lmac_cnt; i++) {
 		if (rvu->pf2cgxlmac_map[i] == 0xFF)
 			continue;
-- 
2.17.1

