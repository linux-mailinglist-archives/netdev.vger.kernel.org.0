Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81656B1CB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbiGHEnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiGHEnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:43:11 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3036D76953;
        Thu,  7 Jul 2022 21:42:45 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2681sYH5030159;
        Thu, 7 Jul 2022 21:42:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=oYmSqFk0DfpBEnnp4S7JRwqW4pYW0nT8BtyRInaYEl4=;
 b=Nybz8r1GhrLubfuPrTHbGbR+V9Cn4/otjFmVsf/rhze75X11odAa0nfGGDhsWkhEEZyn
 ThVpezKeyAArK2FWY1Cm1yGos9tyWJMeca9cHfPF9MkCrRJcRWbSFi1ka724v2sodV9m
 jGnN1jHjViEM+d5jVQ5DqP3rHer5MC48KmTmmID9seIRzx4ai3nAPCAxfdWy/mzKZ3k0
 oXfokLL3dDbAJ9fU6yOEbMV9YmzUy17SKjnmtHVtF7OtwxnzzQ+hTRYFr4AXGrN38WBD
 edsTHV2XorEK0LrXfCZfjYFbGKNUgvSZsLD2XBya2eZ4pib4unqi11YFIEFdYN5OnjiO 3A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h6bay8ek5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:42:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 21:42:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 7 Jul 2022 21:42:31 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 4D4D73F7074;
        Thu,  7 Jul 2022 21:42:28 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v5 09/12] octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
Date:   Fri, 8 Jul 2022 10:11:48 +0530
Message-ID: <20220708044151.2972645-10-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708044151.2972645-1-rkannoth@marvell.com>
References: <20220708044151.2972645-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: eHKVITEHWw_b6LuutzlR4y8LNzVec6Su
X-Proofpoint-ORIG-GUID: eHKVITEHWw_b6LuutzlR4y8LNzVec6Su
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_04,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions are wrappers for mac add/addr/del/update in
exact match table. These will be invoked from mbox handler routines
if exact matct table is supported and enabled.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 359 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  23 +-
 2 files changed, 370 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 491af47ac129..ed8b9afbf731 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1168,14 +1168,17 @@ static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_i
 
 	*enable_or_disable_cam = false;
 
+	if (promisc)
+		goto done;
+
 	/* If all rules are deleted and not already in promisc mode; disable cam */
-	if (!*cnt && !promisc) {
+	if (!*cnt && val < 0) {
 		*enable_or_disable_cam = true;
 		goto done;
 	}
 
 	/* If rule got added and not already in promisc mode; enable cam */
-	if (!old_cnt && !promisc) {
+	if (!old_cnt && val > 0) {
 		*enable_or_disable_cam = true;
 		goto done;
 	}
@@ -1193,7 +1196,7 @@ static u16 __rvu_npc_exact_cmd_rules_cnt_update(struct rvu *rvu, int drop_mcam_i
  *	table.
  *	Return: 0 upon success.
  */
-int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
+static int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
 {
 	struct npc_exact_table_entry *entry = NULL;
 	struct npc_exact_table *table;
@@ -1265,9 +1268,9 @@ int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
  *	MEM table.
  *	Return: 0 upon success.
  */
-static int __maybe_unused rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
-							u8 *mac, u16 chan, u8 ctype, u32 *seq_id,
-							bool cmd, u32 mcam_idx, u16 pcifunc)
+static int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id, u8 *mac,
+					 u16 chan, u8 ctype, u32 *seq_id, bool cmd,
+					 u32 mcam_idx, u16 pcifunc)
 {
 	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	enum npc_exact_opc_type opc_type;
@@ -1335,9 +1338,8 @@ static int __maybe_unused rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_
  *	hash value may not match with old one.
  *	Return: 0 upon success.
  */
-static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id,
-							   u8 lmac_id, u8 *old_mac,
-							   u8 *new_mac, u32 *seq_id)
+static int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
+					    u8 *old_mac, u8 *new_mac, u32 *seq_id)
 {
 	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	struct npc_exact_table_entry *entry;
@@ -1367,7 +1369,7 @@ static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 c
 						       new_mac, table->mem_table.mask,
 						       table->mem_table.depth);
 		if (hash_index != entry->index) {
-			dev_err(rvu->dev,
+			dev_dbg(rvu->dev,
 				"%s: Update failed due to index mismatch(new=0x%x, old=%x)\n",
 				__func__, hash_index, entry->index);
 			mutex_unlock(&table->lock);
@@ -1397,6 +1399,343 @@ static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 c
 	return 0;
 }
 
+/**
+ *	rvu_npc_exact_promisc_disable - Disable promiscuous mode.
+ *      @rvu: resource virtualization unit.
+ *	@pcifunc: pcifunc
+ *
+ *	Drop rule is against each PF. We dont support DMAC filter for
+ *	VF.
+ *	Return: 0 upon success
+ */
+
+int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc)
+{
+	struct npc_exact_table *table;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	u32 drop_mcam_idx;
+	bool *promisc;
+	u32 cnt;
+
+	table = rvu->hw->table;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					 &drop_mcam_idx, NULL, NULL, NULL);
+
+	mutex_lock(&table->lock);
+	promisc = &table->promisc_mode[drop_mcam_idx];
+
+	if (!*promisc) {
+		mutex_unlock(&table->lock);
+		dev_dbg(rvu->dev, "%s: Err Already promisc mode disabled (cgx=%d lmac=%d)\n",
+			__func__, cgx_id, lmac_id);
+		return LMAC_AF_ERR_INVALID_PARAM;
+	}
+	*promisc = false;
+	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
+	mutex_unlock(&table->lock);
+
+	/* If no dmac filter entries configured, disable drop rule */
+	if (!cnt)
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
+	else
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
+
+	dev_dbg(rvu->dev, "%s: disabled  promisc mode (cgx=%d lmac=%d, cnt=%d)\n",
+		__func__, cgx_id, lmac_id, cnt);
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_promisc_enable - Enable promiscuous mode.
+ *      @rvu: resource virtualization unit.
+ *	@pcifunc: pcifunc.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc)
+{
+	struct npc_exact_table *table;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	u32 drop_mcam_idx;
+	bool *promisc;
+	u32 cnt;
+
+	table = rvu->hw->table;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rvu_npc_exact_get_drop_rule_info(rvu, NIX_INTF_TYPE_CGX, cgx_id, lmac_id,
+					 &drop_mcam_idx, NULL, NULL, NULL);
+
+	mutex_lock(&table->lock);
+	promisc = &table->promisc_mode[drop_mcam_idx];
+
+	if (*promisc) {
+		mutex_unlock(&table->lock);
+		dev_dbg(rvu->dev, "%s: Already in promisc mode (cgx=%d lmac=%d)\n",
+			__func__, cgx_id, lmac_id);
+		return LMAC_AF_ERR_INVALID_PARAM;
+	}
+	*promisc = true;
+	cnt = __rvu_npc_exact_cmd_rules_cnt_update(rvu, drop_mcam_idx, 0, NULL);
+	mutex_unlock(&table->lock);
+
+	/* If no dmac filter entries configured, disable drop rule */
+	if (!cnt)
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, false);
+	else
+		rvu_npc_enable_mcam_by_entry_index(rvu, drop_mcam_idx, NIX_INTF_RX, !*promisc);
+
+	dev_dbg(rvu->dev, "%s: Enabled promisc mode (cgx=%d lmac=%d cnt=%d)\n",
+		__func__, cgx_id, lmac_id, cnt);
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_mac_addr_reset - Delete PF mac address.
+ *      @rvu: resource virtualization unit.
+ *	@req: Reset request
+ *	@rsp: Reset response.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
+				 struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u32 seq_id = req->index;
+	struct rvu_pfvf *pfvf;
+	u8 cgx_id, lmac_id;
+	int rc;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+
+	rc = rvu_npc_exact_del_table_entry_by_id(rvu, seq_id);
+	if (rc) {
+		/* TODO: how to handle this error case ? */
+		dev_err(rvu->dev, "%s MAC (%pM) del PF=%d failed\n", __func__, pfvf->mac_addr, pf);
+		return 0;
+	}
+
+	dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d success (seq_id=%u)\n",
+		__func__, pfvf->mac_addr, pf, seq_id);
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_mac_addr_update - Update mac address field with new value.
+ *      @rvu: resource virtualization unit.
+ *	@req: Update request.
+ *	@rsp: Update response.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_mac_addr_update(struct rvu *rvu,
+				  struct cgx_mac_addr_update_req *req,
+				  struct cgx_mac_addr_update_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct npc_exact_table_entry *entry;
+	struct npc_exact_table *table;
+	struct rvu_pfvf *pfvf;
+	u32 seq_id, mcam_idx;
+	u8 old_mac[ETH_ALEN];
+	u8 cgx_id, lmac_id;
+	int rc;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return LMAC_AF_ERR_PERM_DENIED;
+
+	dev_dbg(rvu->dev, "%s: Update request for seq_id=%d, mac=%pM\n",
+		__func__, req->index, req->mac_addr);
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+
+	/* Lookup for entry which needs to be updated */
+	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, req->index);
+	if (!entry) {
+		dev_err(rvu->dev, "%s: failed to find entry for id=0x%x\n", __func__, req->index);
+		mutex_unlock(&table->lock);
+		return LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED;
+	}
+	ether_addr_copy(old_mac, entry->mac);
+	seq_id = entry->seq_id;
+	mcam_idx = entry->mcam_idx;
+	mutex_unlock(&table->lock);
+
+	rc = rvu_npc_exact_update_table_entry(rvu, cgx_id, lmac_id,  old_mac,
+					      req->mac_addr, &seq_id);
+	if (!rc) {
+		rsp->index = seq_id;
+		dev_dbg(rvu->dev, "%s  mac:%pM (pfvf:%pM default:%pM) update to PF=%d success\n",
+			__func__, req->mac_addr, pfvf->mac_addr, pfvf->default_mac, pf);
+		ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+		return 0;
+	}
+
+	/* Try deleting and adding it again */
+	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
+	if (rc) {
+		/* This could be a new entry */
+		dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d failed\n", __func__,
+			pfvf->mac_addr, pf);
+	}
+
+	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
+					   pfvf->rx_chan_base, 0, &seq_id, true,
+					   mcam_idx, req->hdr.pcifunc);
+	if (rc) {
+		dev_err(rvu->dev, "%s MAC (%pM) add PF=%d failed\n", __func__,
+			req->mac_addr, pf);
+		return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
+	}
+
+	rsp->index = seq_id;
+	dev_dbg(rvu->dev,
+		"%s MAC (new:%pM, old=%pM default:%pM) del and add to PF=%d success (seq_id=%u)\n",
+		__func__, req->mac_addr, pfvf->mac_addr, pfvf->default_mac, pf, seq_id);
+
+	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_mac_addr_add - Adds MAC address to exact match table.
+ *      @rvu: resource virtualization unit.
+ *	@req: Add request.
+ *	@rsp: Add response.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_mac_addr_add(struct rvu *rvu,
+			       struct cgx_mac_addr_add_req *req,
+			       struct cgx_mac_addr_add_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct rvu_pfvf *pfvf;
+	u8 cgx_id, lmac_id;
+	int rc = 0;
+	u32 seq_id;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+
+	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
+					   pfvf->rx_chan_base, 0, &seq_id,
+					   true, -1, req->hdr.pcifunc);
+
+	if (!rc) {
+		rsp->index = seq_id;
+		dev_dbg(rvu->dev, "%s MAC (%pM) add to PF=%d success (seq_id=%u)\n",
+			__func__, req->mac_addr, pf, seq_id);
+		return 0;
+	}
+
+	dev_err(rvu->dev, "%s MAC (%pM) add to PF=%d failed\n", __func__,
+		req->mac_addr, pf);
+	return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
+}
+
+/**
+ *	rvu_npc_exact_mac_addr_del - Delete DMAC filter
+ *      @rvu: resource virtualization unit.
+ *	@req: Delete request.
+ *	@rsp: Delete response.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_mac_addr_del(struct rvu *rvu,
+			       struct cgx_mac_addr_del_req *req,
+			       struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	int rc;
+
+	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
+	if (!rc) {
+		dev_dbg(rvu->dev, "%s del to PF=%d success (seq_id=%u)\n",
+			__func__, pf, req->index);
+		return 0;
+	}
+
+	dev_err(rvu->dev, "%s del to PF=%d failed (seq_id=%u)\n",
+		__func__,  pf, req->index);
+	return LMAC_AF_ERR_EXACT_MATCH_TBL_DEL_FAILED;
+}
+
+/**
+ *	rvu_npc_exact_mac_addr_set - Add PF mac address to dmac filter.
+ *      @rvu: resource virtualization unit.
+ *	@req: Set request.
+ *	@rsp: Set response.
+ *	Return: 0 upon success
+ */
+int rvu_npc_exact_mac_addr_set(struct rvu *rvu, struct cgx_mac_addr_set_or_get *req,
+			       struct cgx_mac_addr_set_or_get *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u32 seq_id = req->index;
+	struct rvu_pfvf *pfvf;
+	u8 cgx_id, lmac_id;
+	u32 mcam_idx = -1;
+	int rc, nixlf;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	pfvf = &rvu->pf[pf];
+
+	/* If table does not have an entry; both update entry and del table entry API
+	 * below fails. Those are not failure conditions.
+	 */
+	rc = rvu_npc_exact_update_table_entry(rvu, cgx_id, lmac_id, pfvf->mac_addr,
+					      req->mac_addr, &seq_id);
+	if (!rc) {
+		rsp->index = seq_id;
+		ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+		ether_addr_copy(rsp->mac_addr, req->mac_addr);
+		dev_dbg(rvu->dev, "%s MAC (%pM) update to PF=%d success\n",
+			__func__, req->mac_addr, pf);
+		return 0;
+	}
+
+	/* Try deleting and adding it again */
+	rc = rvu_npc_exact_del_table_entry_by_id(rvu, req->index);
+	if (rc) {
+		dev_dbg(rvu->dev, "%s MAC (%pM) del PF=%d failed\n",
+			__func__, pfvf->mac_addr, pf);
+	}
+
+	/* find mcam entry if exist */
+	rc = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, NULL);
+	if (!rc) {
+		mcam_idx = npc_get_nixlf_mcam_index(&rvu->hw->mcam, req->hdr.pcifunc,
+						    nixlf, NIXLF_UCAST_ENTRY);
+	}
+
+	rc = rvu_npc_exact_add_table_entry(rvu, cgx_id, lmac_id, req->mac_addr,
+					   pfvf->rx_chan_base, 0, &seq_id,
+					   true, mcam_idx, req->hdr.pcifunc);
+	if (rc) {
+		dev_err(rvu->dev, "%s MAC (%pM) add PF=%d failed\n",
+			__func__, req->mac_addr, pf);
+		return LMAC_AF_ERR_EXACT_MATCH_TBL_ADD_FAILED;
+	}
+
+	rsp->index = seq_id;
+	ether_addr_copy(rsp->mac_addr, req->mac_addr);
+	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+	dev_dbg(rvu->dev,
+		"%s MAC (%pM) del and add to PF=%d success (seq_id=%u)\n",
+		__func__, req->mac_addr, pf, seq_id);
+	return 0;
+}
+
 /**
  *	rvu_npc_exact_can_disable_feature - Check if feature can be disabled.
  *      @rvu: resource virtualization unit.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index e6cc6d9aea7e..3efeb09c58de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -202,13 +202,32 @@ struct npc_exact_table {
 };
 
 bool rvu_npc_exact_has_match_table(struct rvu *rvu);
-int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id);
 u32 rvu_npc_exact_get_max_entries(struct rvu *rvu);
 int rvu_npc_exact_init(struct rvu *rvu);
+int rvu_npc_exact_mac_addr_reset(struct rvu *rvu, struct cgx_mac_addr_reset_req *req,
+				 struct msg_rsp *rsp);
+
+int rvu_npc_exact_mac_addr_update(struct rvu *rvu,
+				  struct cgx_mac_addr_update_req *req,
+				  struct cgx_mac_addr_update_rsp *rsp);
+
+int rvu_npc_exact_mac_addr_add(struct rvu *rvu,
+			       struct cgx_mac_addr_add_req *req,
+			       struct cgx_mac_addr_add_rsp *rsp);
+
+int rvu_npc_exact_mac_addr_del(struct rvu *rvu,
+			       struct cgx_mac_addr_del_req *req,
+			       struct msg_rsp *rsp);
+
+int rvu_npc_exact_mac_addr_set(struct rvu *rvu, struct cgx_mac_addr_set_or_get *req,
+			       struct cgx_mac_addr_set_or_get *rsp);
+
+void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
 
 bool rvu_npc_exact_can_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_disable_feature(struct rvu *rvu);
 void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc);
 u16 rvu_npc_exact_drop_rule_to_pcifunc(struct rvu *rvu, u32 drop_rule_idx);
-
+int rvu_npc_exact_promisc_disable(struct rvu *rvu, u16 pcifunc);
+int rvu_npc_exact_promisc_enable(struct rvu *rvu, u16 pcifunc);
 #endif /* RVU_NPC_HASH_H */
-- 
2.25.1

