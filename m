Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF1B569957
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiGGEp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiGGEpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:45:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D082BB18;
        Wed,  6 Jul 2022 21:45:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674UweZ023774;
        Wed, 6 Jul 2022 21:45:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=w6kNaAWsX8iki4lFdaPNcqS8OuCtZ0XjwFy5P0ITRUs=;
 b=IVSPI2pW0Rcp2MREmUfNqH9TT6x4bsSHsapY6ECi0Vgpn1vDhjl72in0+gJ9lY8U/eRv
 mVDWzGgH2ID98+YaExs5SNWqpo+kejBzZ0pS1OfKJRyuek5TqWHJk+mK3oclojOPzTQi
 s8fqQOjDCAHbay5ZMn4ZnVq4NUW/DWhBppwzACnTqUdTTqKM3rFtasUdmysksNbmmRaq
 x4kX9COumv10JiS4GEPMZwsujWhhJZBeO9A1qhASb2nZ9QFfoJneqjzuFDs+GchQkmHy
 PanHSBXXgHhnxOTYK9wWXHDaduhkJhfxKDV9ajUsPDsNn+mC8yBbDIsuq32pn/8eSq8c iw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt48ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:45:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Jul
 2022 21:45:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Jul 2022 21:45:05 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id CBA923F70BE;
        Wed,  6 Jul 2022 21:45:02 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH V2 02/12] octeontx2-af: Exact match support
Date:   Thu, 7 Jul 2022 10:13:54 +0530
Message-ID: <20220707044404.2723378-3-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707044404.2723378-1-rkannoth@marvell.com>
References: <20220707044404.2723378-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hRbgwxZxGt8yNkk8WyNu09XKIWVFLGCJ
X-Proofpoint-GUID: hRbgwxZxGt8yNkk8WyNu09XKIWVFLGCJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10KB silicon has support for exact match table. This table
can be used to match maimum 64 bit value of KPU parsed output.
Hit/non hit in exact match table can be used as a KEX key to
NPC mcam.

This patch makes use of Exact match table to increase number of
DMAC filters supported. NPC  mcam is no more need for each of these
DMAC entries as will be populated in Exact match table.

This patch implements following

1. Initialization of exact match table only for CN10KB.
2. Add/del/update interface function for exact match table.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  16 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   9 +-
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 938 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  56 ++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   9 +
 6 files changed, 1029 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 6d5799a7d3ed..69f9517c61f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -388,6 +388,22 @@ struct nix_rx_action {
 #endif
 };
 
+/* NPC_AF_INTFX_KEX_CFG field masks */
+#define NPC_EXACT_NIBBLE_START		40
+#define NPC_EXACT_NIBBLE_END		43
+#define NPC_EXACT_NIBBLE		GENMASK_ULL(43, 40)
+
+/* NPC_EXACT_KEX_S nibble definitions for each field */
+#define NPC_EXACT_NIBBLE_HIT		BIT_ULL(40)
+#define NPC_EXACT_NIBBLE_OPC		BIT_ULL(40)
+#define NPC_EXACT_NIBBLE_WAY		BIT_ULL(40)
+#define NPC_EXACT_NIBBLE_INDEX		GENMASK_ULL(43, 41)
+
+#define NPC_EXACT_RESULT_HIT		BIT_ULL(0)
+#define NPC_EXACT_RESULT_OPC		GENMASK_ULL(2, 1)
+#define NPC_EXACT_RESULT_WAY		GENMASK_ULL(4, 3)
+#define NPC_EXACT_RESULT_IDX		GENMASK_ULL(15, 5)
+
 /* NPC_AF_INTFX_KEX_CFG field masks */
 #define NPC_PARSE_NIBBLE		GENMASK_ULL(30, 0)
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8f67013e0592..1b6e9efbb8ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -18,6 +18,7 @@
 #include "ptp.h"
 
 #include "rvu_trace.h"
+#include "rvu_npc_hash.h"
 
 #define DRV_NAME	"rvu_af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
@@ -69,6 +70,7 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 	hw->cap.nix_rx_multicast = true;
 	hw->cap.nix_shaper_toggle_wait = false;
 	hw->cap.npc_hash_extract = false;
+	hw->cap.npc_exact_match_enabled = false;
 	hw->rvu = rvu;
 
 	if (is_rvu_pre_96xx_C0(rvu)) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index f7e9cf822371..f80d80819745 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -339,6 +339,7 @@ struct hw_cap {
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
 	bool	npc_hash_extract; /* Hash extract enabled ? */
+	bool	npc_exact_match_enabled; /* Exact match supported ? */
 };
 
 struct rvu_hwinfo {
@@ -370,6 +371,7 @@ struct rvu_hwinfo {
 	struct rvu	 *rvu;
 	struct npc_pkind pkind;
 	struct npc_mcam  mcam;
+	struct npc_exact_table *table;
 };
 
 struct mbox_wq_info {
@@ -767,7 +769,6 @@ u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu);
 u32 convert_bytes_to_dwrr_mtu(u32 bytes);
 
 /* NPC APIs */
-int rvu_npc_init(struct rvu *rvu);
 void rvu_npc_freemem(struct rvu *rvu);
 int rvu_npc_get_pkind(struct rvu *rvu, u16 pf);
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf);
@@ -786,6 +787,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    u64 chan);
 void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 				   bool enable);
+
 void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
 				  int nixlf, int type, bool enable);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
@@ -794,6 +796,7 @@ void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index);
+
 void rvu_npc_get_mcam_entry_alloc_info(struct rvu *rvu, u16 pcifunc,
 				       int blkaddr, int *alloc_cnt,
 				       int *enable_cnt);
@@ -828,6 +831,10 @@ int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
 bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
 			   int index);
+int rvu_npc_init(struct rvu *rvu);
+int npc_install_mcam_drop_rule(struct rvu *rvu, int mcam_idx, u16 *counter_idx,
+			       u64 chan_val, u64 chan_mask, u64 exact_val, u64 exact_mask,
+			       u64 bcast_mcast_val, u64 bcast_mcast_mask);
 
 /* CPT APIs */
 int rvu_cpt_register_interrupts(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index dbb33075b7f0..7d3683035ab4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -20,6 +20,7 @@
 #include "cgx.h"
 #include "rvu_npc_hash.h"
 #include "rvu_npc_fs.h"
+#include "rvu_npc_hash.h"
 
 static u64 rvu_npc_wide_extract(const u64 input[], size_t start_bit,
 				size_t width_bits)
@@ -336,3 +337,940 @@ int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
 
 	return 0;
 }
+
+/**
+ *	rvu_npc_exact_mac2u64 - utility function to convert mac address to u64.
+ *	@mac_addr: MAC address.
+ *	Return: mdata for exact match table.
+ */
+static u64 rvu_npc_exact_mac2u64(u8 *mac_addr)
+{
+	u64 mac = 0;
+	int index;
+
+	for (index = ETH_ALEN - 1; index >= 0; index--)
+		mac |= ((u64)*mac_addr++) << (8 * index);
+
+	return mac;
+}
+
+/**
+ *	rvu_exact_prepare_mdata - Make mdata for mcam entry
+ *	@mac: MAC address
+ *	@chan: Channel number.
+ *	@ctype: Channel Type.
+ *	@mask: LDATA mask.
+ *	Return: Meta data
+ */
+static u64 rvu_exact_prepare_mdata(u8 *mac, u16 chan, u16 ctype, u64 mask)
+{
+	u64 ldata = rvu_npc_exact_mac2u64(mac);
+
+	/* Please note that mask is 48bit which excludes chan and ctype.
+	 * Increase mask bits if we need to include them as well.
+	 */
+	ldata |= ((u64)chan << 48);
+	ldata |= ((u64)ctype  << 60);
+	ldata &= mask;
+	ldata = ldata << 2;
+
+	return ldata;
+}
+
+/**
+ *      rvu_exact_calculate_hash - calculate hash index to mem table.
+ *	@rvu: resource virtualization unit.
+ *	@chan: Channel number
+ *	@ctype: Channel type.
+ *	@mac: MAC address
+ *	@mask: HASH mask.
+ *	@table_depth: Depth of table.
+ *	Return: Hash value
+ */
+static u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
+				    u64 mask, u32 table_depth)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	u64 hash_key[2];
+	u64 key_in[2];
+	u64 ldata;
+	u32 hash;
+
+	key_in[0] = RVU_NPC_HASH_SECRET_KEY0;
+	key_in[1] = RVU_NPC_HASH_SECRET_KEY2;
+
+	hash_key[0] = key_in[0] << 31;
+	hash_key[0] |= key_in[1];
+	hash_key[1] = key_in[0] >> 33;
+
+	ldata = rvu_exact_prepare_mdata(mac, chan, ctype, mask);
+
+	dev_dbg(rvu->dev, "%s: ldata=0x%llx hash_key0=0x%llx hash_key2=0x%llx\n", __func__,
+		ldata, hash_key[1], hash_key[0]);
+	hash = rvu_npc_toeplitz_hash(&ldata, (u64 *)hash_key, 64, 95);
+
+	hash &= table->mem_table.hash_mask;
+	hash += table->mem_table.hash_offset;
+	dev_dbg(rvu->dev, "%s: hash=%x\n", __func__,  hash);
+
+	return hash;
+}
+
+/**
+ *      rvu_npc_exact_alloc_mem_table_entry - find free entry in 4 way table.
+ *      @rvu: resource virtualization unit.
+ *	@way: Indicate way to table.
+ *	@index: Hash index to 4 way table.
+ *	@hash: Hash value.
+ *
+ *	Searches 4 way table using hash index. Returns 0 on success.
+ *	Return: 0 upon success.
+ */
+static int rvu_npc_exact_alloc_mem_table_entry(struct rvu *rvu, u8 *way,
+					       u32 *index, unsigned int hash)
+{
+	struct npc_exact_table *table;
+	int depth, i;
+
+	table = rvu->hw->table;
+	depth = table->mem_table.depth;
+
+	/* Check all the 4 ways for a free slot. */
+	mutex_lock(&table->lock);
+	for (i = 0; i <  table->mem_table.ways; i++) {
+		if (test_bit(hash + i * depth, table->mem_table.bmap))
+			continue;
+
+		set_bit(hash + i * depth, table->mem_table.bmap);
+		mutex_unlock(&table->lock);
+
+		dev_dbg(rvu->dev, "%s: mem table entry alloc success (way=%d index=%d)\n",
+			__func__, i, hash);
+
+		*way = i;
+		*index = hash;
+		return 0;
+	}
+	mutex_unlock(&table->lock);
+
+	dev_dbg(rvu->dev, "%s: No space in 4 way exact way, weight=%u\n", __func__,
+		bitmap_weight(table->mem_table.bmap, table->mem_table.depth));
+	return -ENOSPC;
+}
+
+/**
+ *	rvu_npc_exact_free_id - Free seq id from bitmat.
+ *	@rvu: Resource virtualization unit.
+ *	@seq_id: Sequence identifier to be freed.
+ */
+static void rvu_npc_exact_free_id(struct rvu *rvu, u32 seq_id)
+{
+	struct npc_exact_table *table;
+
+	table = rvu->hw->table;
+	mutex_lock(&table->lock);
+	clear_bit(seq_id, table->id_bmap);
+	mutex_unlock(&table->lock);
+	dev_dbg(rvu->dev, "%s: freed id %d\n", __func__, seq_id);
+}
+
+/**
+ *	rvu_npc_exact_alloc_id - Alloc seq id from bitmap.
+ *	@rvu: Resource virtualization unit.
+ *	@seq_id: Sequence identifier.
+ *	Return: True or false.
+ */
+static bool rvu_npc_exact_alloc_id(struct rvu *rvu, u32 *seq_id)
+{
+	struct npc_exact_table *table;
+	u32 idx;
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+	idx = find_first_zero_bit(table->id_bmap, table->tot_ids);
+	if (idx == table->tot_ids) {
+		mutex_unlock(&table->lock);
+		dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n",
+			__func__, bitmap_weight(table->id_bmap, table->tot_ids));
+
+		return false;
+	}
+
+	/* Mark bit map to indicate that slot is used.*/
+	set_bit(idx, table->id_bmap);
+	mutex_unlock(&table->lock);
+
+	*seq_id = idx;
+	dev_dbg(rvu->dev, "%s: Allocated id (%d)\n", __func__, *seq_id);
+
+	return true;
+}
+
+/**
+ *      rvu_npc_exact_alloc_cam_table_entry - find free slot in fully associative table.
+ *      @rvu: resource virtualization unit.
+ *	@index: Index to exact CAM table.
+ *	Return: 0 upon success; else error number.
+ */
+static int rvu_npc_exact_alloc_cam_table_entry(struct rvu *rvu, int *index)
+{
+	struct npc_exact_table *table;
+	u32 idx;
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+	idx = find_first_zero_bit(table->cam_table.bmap, table->cam_table.depth);
+	if (idx == table->cam_table.depth) {
+		mutex_unlock(&table->lock);
+		dev_info(rvu->dev, "%s: No space in exact cam table, weight=%u\n", __func__,
+			 bitmap_weight(table->cam_table.bmap, table->cam_table.depth));
+		return -ENOSPC;
+	}
+
+	/* Mark bit map to indicate that slot is used.*/
+	set_bit(idx, table->cam_table.bmap);
+	mutex_unlock(&table->lock);
+
+	*index = idx;
+	dev_dbg(rvu->dev, "%s: cam table entry alloc success (index=%d)\n",
+		__func__, idx);
+	return 0;
+}
+
+/**
+ *	rvu_exact_prepare_table_entry - Data for exact match table entry.
+ *	@rvu: Resource virtualization unit.
+ *	@enable: Enable/Disable entry
+ *	@ctype: Software defined channel type. Currently set as 0.
+ *	@chan: Channel number.
+ *	@mac_addr: Destination mac address.
+ *	Return: mdata for exact match table.
+ */
+static u64 rvu_exact_prepare_table_entry(struct rvu *rvu, bool enable,
+					 u8 ctype, u16 chan, u8 *mac_addr)
+
+{
+	u64 ldata = rvu_npc_exact_mac2u64(mac_addr);
+
+	/* Enable or disable */
+	u64 mdata = FIELD_PREP(GENMASK_ULL(63, 63), !!enable);
+
+	/* Set Ctype */
+	mdata |= FIELD_PREP(GENMASK_ULL(61, 60), ctype);
+
+	/* Set chan */
+	mdata |= FIELD_PREP(GENMASK_ULL(59, 48), chan);
+
+	/* MAC address */
+	mdata |= FIELD_PREP(GENMASK_ULL(47, 0), ldata);
+
+	return mdata;
+}
+
+/**
+ *	rvu_exact_config_secret_key - Configure secret key.
+ *	@rvu: Resource virtualization unit.
+ */
+static void rvu_exact_config_secret_key(struct rvu *rvu)
+{
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET0(NIX_INTF_RX),
+		    RVU_NPC_HASH_SECRET_KEY0);
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET1(NIX_INTF_RX),
+		    RVU_NPC_HASH_SECRET_KEY1);
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_SECRET2(NIX_INTF_RX),
+		    RVU_NPC_HASH_SECRET_KEY2);
+}
+
+/**
+ *	rvu_exact_config_search_key - Configure search key
+ *	@rvu: Resource virtualization unit.
+ */
+static void rvu_exact_config_search_key(struct rvu *rvu)
+{
+	int blkaddr;
+	u64 reg_val;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+
+	/* HDR offset */
+	reg_val = FIELD_PREP(GENMASK_ULL(39, 32), 0);
+
+	/* BYTESM1, number of bytes - 1 */
+	reg_val |= FIELD_PREP(GENMASK_ULL(18, 16), ETH_ALEN - 1);
+
+	/* Enable LID and set LID to  NPC_LID_LA */
+	reg_val |= FIELD_PREP(GENMASK_ULL(11, 11), 1);
+	reg_val |= FIELD_PREP(GENMASK_ULL(10, 8),  NPC_LID_LA);
+
+	/* Clear layer type based extraction */
+
+	/* Disable LT_EN */
+	reg_val |= FIELD_PREP(GENMASK_ULL(12, 12), 0);
+
+	/* Set LTYPE_MATCH to 0 */
+	reg_val |= FIELD_PREP(GENMASK_ULL(7, 4), 0);
+
+	/* Set LTYPE_MASK to 0 */
+	reg_val |= FIELD_PREP(GENMASK_ULL(3, 0), 0);
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_CFG(NIX_INTF_RX), reg_val);
+}
+
+/**
+ *	rvu_exact_config_result_ctrl - Set exact table hash control
+ *	@rvu: Resource virtualization unit.
+ *	@depth: Depth of Exact match table.
+ *
+ *	Sets mask and offset for hash for mem table.
+ */
+static void rvu_exact_config_result_ctrl(struct rvu *rvu, uint32_t depth)
+{
+	int blkaddr;
+	u64 reg = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+
+	/* Set mask. Note that depth is a power of 2 */
+	rvu->hw->table->mem_table.hash_mask = (depth - 1);
+	reg |= FIELD_PREP(GENMASK_ULL(42, 32), (depth - 1));
+
+	/* Set offset as 0 */
+	rvu->hw->table->mem_table.hash_offset = 0;
+	reg |= FIELD_PREP(GENMASK_ULL(10, 0), 0);
+
+	/* Set reg for RX */
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_RESULT_CTL(NIX_INTF_RX), reg);
+	/* Store hash mask and offset for s/w algorithm */
+}
+
+/**
+ *	rvu_exact_config_table_mask - Set exact table mask.
+ *	@rvu: Resource virtualization unit.
+ */
+static void rvu_exact_config_table_mask(struct rvu *rvu)
+{
+	int blkaddr;
+	u64 mask = 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+
+	/* Don't use Ctype */
+	mask |= FIELD_PREP(GENMASK_ULL(61, 60), 0);
+
+	/* Set chan */
+	mask |= GENMASK_ULL(59, 48);
+
+	/* Full ldata */
+	mask |= GENMASK_ULL(47, 0);
+
+	/* Store mask for s/w hash calcualtion */
+	rvu->hw->table->mem_table.mask = mask;
+
+	/* Set mask for RX.*/
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_EXACT_MASK(NIX_INTF_RX), mask);
+}
+
+/**
+ *      rvu_npc_exact_get_max_entries - Get total number of entries in table.
+ *      @rvu: resource virtualization unit.
+ *	Return: Maximum table entries possible.
+ */
+u32 rvu_npc_exact_get_max_entries(struct rvu *rvu)
+{
+	struct npc_exact_table *table;
+
+	table = rvu->hw->table;
+	return table->tot_ids;
+}
+
+/**
+ *      rvu_npc_exact_has_match_table - Checks support for exact match.
+ *      @rvu: resource virtualization unit.
+ *	Return: True if exact match table is supported/enabled.
+ */
+bool rvu_npc_exact_has_match_table(struct rvu *rvu)
+{
+	return  rvu->hw->cap.npc_exact_match_enabled;
+}
+
+/**
+ *      __rvu_npc_exact_find_entry_by_seq_id - find entry by id
+ *      @rvu: resource virtualization unit.
+ *	@seq_id: Sequence identifier.
+ *
+ *	Caller should acquire the lock.
+ *	Return: Pointer to table entry.
+ */
+static struct npc_exact_table_entry *
+__rvu_npc_exact_find_entry_by_seq_id(struct rvu *rvu, u32 seq_id)
+{
+	struct npc_exact_table *table = rvu->hw->table;
+	struct npc_exact_table_entry *entry = NULL;
+	struct list_head *lhead;
+
+	lhead = &table->lhead_gbl;
+
+	/* traverse to find the matching entry */
+	list_for_each_entry(entry, lhead, glist) {
+		if (entry->seq_id != seq_id)
+			continue;
+
+		return entry;
+	}
+
+	return NULL;
+}
+
+/**
+ *      rvu_npc_exact_add_to_list - Add entry to list
+ *      @rvu: resource virtualization unit.
+ *	@opc_type: OPCODE to select MEM/CAM table.
+ *	@ways: MEM table ways.
+ *	@index: Index in MEM/CAM table.
+ *	@cgx_id: CGX identifier.
+ *	@lmac_id: LMAC identifier.
+ *	@mac_addr: MAC address.
+ *	@chan: Channel number.
+ *	@ctype: Channel Type.
+ *	@seq_id: Sequence identifier
+ *	@cmd: True if function is called by ethtool cmd
+ *	@mcam_idx: NPC mcam index of DMAC entry in NPC mcam.
+ *	@pcifunc: pci function
+ *	Return: 0 upon success.
+ */
+static int rvu_npc_exact_add_to_list(struct rvu *rvu, enum npc_exact_opc_type opc_type, u8 ways,
+				     u32 index, u8 cgx_id, u8 lmac_id, u8 *mac_addr, u16 chan,
+				     u8 ctype, u32 *seq_id, bool cmd, u32 mcam_idx, u16 pcifunc)
+{
+	struct npc_exact_table_entry *entry, *tmp, *iter;
+	struct npc_exact_table *table = rvu->hw->table;
+	struct list_head *lhead, *pprev;
+
+	WARN_ON(ways >= NPC_EXACT_TBL_MAX_WAYS);
+
+	if (!rvu_npc_exact_alloc_id(rvu, seq_id)) {
+		dev_err(rvu->dev, "%s: Generate seq id failed\n", __func__);
+		return -EFAULT;
+	}
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		rvu_npc_exact_free_id(rvu, *seq_id);
+		dev_err(rvu->dev, "%s: Memory allocation failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	mutex_lock(&table->lock);
+	switch (opc_type) {
+	case NPC_EXACT_OPC_CAM:
+		lhead = &table->lhead_cam_tbl_entry;
+		table->cam_tbl_entry_cnt++;
+		break;
+
+	case NPC_EXACT_OPC_MEM:
+		lhead = &table->lhead_mem_tbl_entry[ways];
+		table->mem_tbl_entry_cnt++;
+		break;
+
+	default:
+		mutex_unlock(&table->lock);
+		kfree(entry);
+		rvu_npc_exact_free_id(rvu, *seq_id);
+
+		dev_err(rvu->dev, "%s: Unknown opc type%d\n", __func__, opc_type);
+		return  -EINVAL;
+	}
+
+	/* Add to global list */
+	INIT_LIST_HEAD(&entry->glist);
+	list_add_tail(&entry->glist, &table->lhead_gbl);
+	INIT_LIST_HEAD(&entry->list);
+	entry->index = index;
+	entry->ways = ways;
+	entry->opc_type = opc_type;
+
+	entry->pcifunc = pcifunc;
+
+	ether_addr_copy(entry->mac, mac_addr);
+	entry->chan = chan;
+	entry->ctype = ctype;
+	entry->cgx_id = cgx_id;
+	entry->lmac_id = lmac_id;
+
+	entry->seq_id = *seq_id;
+
+	entry->mcam_idx = mcam_idx;
+	entry->cmd = cmd;
+
+	pprev = lhead;
+
+	/* Insert entry in ascending order of index */
+	list_for_each_entry_safe(iter, tmp, lhead, list) {
+		if (index < iter->index)
+			break;
+
+		pprev = &iter->list;
+	}
+
+	/* Add to each table list */
+	list_add(&entry->list, pprev);
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_mem_table_write - Wrapper for register write
+ *	@rvu: resource virtualization unit.
+ *	@blkaddr: Block address
+ *	@ways: ways for MEM table.
+ *	@index: Index in MEM
+ *	@mdata: Meta data to be written to register.
+ */
+static void rvu_npc_exact_mem_table_write(struct rvu *rvu, int blkaddr, u8 ways,
+					  u32 index, u64 mdata)
+{
+	rvu_write64(rvu, blkaddr, NPC_AF_EXACT_MEM_ENTRY(ways, index), mdata);
+}
+
+/**
+ *	rvu_npc_exact_cam_table_write - Wrapper for register write
+ *	@rvu: resource virtualization unit.
+ *	@blkaddr: Block address
+ *	@index: Index in MEM
+ *	@mdata: Meta data to be written to register.
+ */
+static void rvu_npc_exact_cam_table_write(struct rvu *rvu, int blkaddr,
+					  u32 index, u64 mdata)
+{
+	rvu_write64(rvu, blkaddr, NPC_AF_EXACT_CAM_ENTRY(index), mdata);
+}
+
+/**
+ *      rvu_npc_exact_dealloc_table_entry - dealloc table entry
+ *      @rvu: resource virtualization unit.
+ *	@opc_type: OPCODE for selection of table(MEM or CAM)
+ *	@ways: ways if opc_type is MEM table.
+ *	@index: Index of MEM or CAM table.
+ *	Return: 0 upon success.
+ */
+static int rvu_npc_exact_dealloc_table_entry(struct rvu *rvu, enum npc_exact_opc_type opc_type,
+					     u8 ways, u32 index)
+{
+	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	struct npc_exact_table *table;
+	u8 null_dmac[6] = { 0 };
+	int depth;
+
+	/* Prepare entry with all fields set to zero */
+	u64 null_mdata = rvu_exact_prepare_table_entry(rvu, false, 0, 0, null_dmac);
+
+	table = rvu->hw->table;
+	depth = table->mem_table.depth;
+
+	mutex_lock(&table->lock);
+
+	switch (opc_type) {
+	case NPC_EXACT_OPC_CAM:
+
+		/* Check whether entry is used already */
+		if (!test_bit(index, table->cam_table.bmap)) {
+			mutex_unlock(&table->lock);
+			dev_err(rvu->dev, "%s: Trying to free an unused entry ways=%d index=%d\n",
+				__func__, ways, index);
+			return -EINVAL;
+		}
+
+		rvu_npc_exact_cam_table_write(rvu, blkaddr, index, null_mdata);
+		clear_bit(index, table->cam_table.bmap);
+		break;
+
+	case NPC_EXACT_OPC_MEM:
+
+		/* Check whether entry is used already */
+		if (!test_bit(index + ways * depth, table->mem_table.bmap)) {
+			mutex_unlock(&table->lock);
+			dev_err(rvu->dev, "%s: Trying to free an unused entry index=%d\n",
+				__func__, index);
+			return -EINVAL;
+		}
+
+		rvu_npc_exact_mem_table_write(rvu, blkaddr, ways, index, null_mdata);
+		clear_bit(index + ways * depth, table->mem_table.bmap);
+		break;
+
+	default:
+		mutex_unlock(&table->lock);
+		dev_err(rvu->dev, "%s: invalid opc type %d", __func__, opc_type);
+		return -ENOSPC;
+	}
+
+	mutex_unlock(&table->lock);
+
+	dev_dbg(rvu->dev, "%s: Successfully deleted entry (index=%d, ways=%d opc_type=%d\n",
+		__func__, index,  ways, opc_type);
+
+	return 0;
+}
+
+/**
+ *	rvu_npc_exact_alloc_table_entry - Allociate an entry
+ *      @rvu: resource virtualization unit.
+ *	@mac: MAC address.
+ *	@chan: Channel number.
+ *	@ctype: Channel Type.
+ *	@index: Index of MEM table or CAM table.
+ *	@ways: Ways. Only valid for MEM table.
+ *	@opc_type: OPCODE to select table (MEM or CAM)
+ *
+ *	Try allocating a slot from MEM table. If all 4 ways
+ *	slot are full for a hash index, check availability in
+ *	32-entry CAM table for allocation.
+ *	Return: 0 upon success.
+ */
+static int rvu_npc_exact_alloc_table_entry(struct rvu *rvu,  char *mac, u16 chan, u8 ctype,
+					   u32 *index, u8 *ways, enum npc_exact_opc_type *opc_type)
+{
+	struct npc_exact_table *table;
+	unsigned int hash;
+	int err;
+
+	table = rvu->hw->table;
+
+	/* Check in 4-ways mem entry for free slote */
+	hash =  rvu_exact_calculate_hash(rvu, chan, ctype, mac, table->mem_table.mask,
+					 table->mem_table.depth);
+	err = rvu_npc_exact_alloc_mem_table_entry(rvu, ways, index, hash);
+	if (!err) {
+		*opc_type = NPC_EXACT_OPC_MEM;
+		dev_dbg(rvu->dev, "%s: inserted in 4 ways hash table ways=%d, index=%d\n",
+			__func__, *ways, *index);
+		return 0;
+	}
+
+	dev_dbg(rvu->dev, "%s: failed to insert in 4 ways hash table\n", __func__);
+
+	/* wayss is 0 for cam table */
+	*ways = 0;
+	err = rvu_npc_exact_alloc_cam_table_entry(rvu, index);
+	if (!err) {
+		*opc_type = NPC_EXACT_OPC_CAM;
+		dev_dbg(rvu->dev, "%s: inserted in fully associative hash table index=%u\n",
+			__func__, *index);
+		return 0;
+	}
+
+	dev_err(rvu->dev, "%s: failed to insert in fully associative hash table\n", __func__);
+	return -ENOSPC;
+}
+
+/**
+ *      rvu_npc_exact_del_table_entry_by_id - Delete and free table entry.
+ *      @rvu: resource virtualization unit.
+ *	@seq_id: Sequence identifier of the entry.
+ *
+ *	Deletes entry from linked lists and free up slot in HW MEM or CAM
+ *	table.
+ *	Return: 0 upon success.
+ */
+int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id)
+{
+	struct npc_exact_table_entry *entry = NULL;
+	struct npc_exact_table *table;
+	int *cnt;
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+
+	/* Lookup for entry which needs to be updated */
+	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, seq_id);
+	if (!entry) {
+		dev_dbg(rvu->dev, "%s: failed to find entry for id=0x%x\n", __func__, seq_id);
+		mutex_unlock(&table->lock);
+		return -ENODATA;
+	}
+
+	cnt = (entry->opc_type == NPC_EXACT_OPC_CAM) ? &table->cam_tbl_entry_cnt :
+				&table->mem_tbl_entry_cnt;
+
+	/* delete from lists */
+	list_del_init(&entry->list);
+	list_del_init(&entry->glist);
+
+	(*cnt)--;
+
+	mutex_unlock(&table->lock);
+
+	rvu_npc_exact_dealloc_table_entry(rvu, entry->opc_type, entry->ways, entry->index);
+
+	rvu_npc_exact_free_id(rvu, seq_id);
+
+	dev_dbg(rvu->dev, "%s: delete entry success for id=0x%x, mca=%pM\n",
+		__func__, seq_id, entry->mac);
+	kfree(entry);
+
+	return 0;
+}
+
+/**
+ *      rvu_npc_exact_add_table_entry - Adds a table entry
+ *      @rvu: resource virtualization unit.
+ *	@cgx_id: cgx identifier.
+ *	@lmac_id: lmac identifier.
+ *	@mac: MAC address.
+ *	@chan: Channel number.
+ *	@ctype: Channel Type.
+ *	@seq_id: Sequence number.
+ *	@cmd: Whether it is invoked by ethtool cmd.
+ *	@mcam_idx: NPC mcam index corresponding to MAC
+ *	@pcifunc: PCI func.
+ *
+ *	Creates a new exact match table entry in either CAM or
+ *	MEM table.
+ *	Return: 0 upon success.
+ */
+static int __maybe_unused rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
+							u8 *mac, u16 chan, u8 ctype, u32 *seq_id,
+							bool cmd, u32 mcam_idx, u16 pcifunc)
+{
+	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	enum npc_exact_opc_type opc_type;
+	u32 index;
+	u64 mdata;
+	int err;
+	u8 ways;
+
+	ctype = 0;
+
+	err = rvu_npc_exact_alloc_table_entry(rvu, mac, chan, ctype, &index, &ways, &opc_type);
+	if (err) {
+		dev_err(rvu->dev, "%s: Could not alloc in exact match table\n", __func__);
+		return err;
+	}
+
+	/* Write mdata to table */
+	mdata = rvu_exact_prepare_table_entry(rvu, true, ctype, chan, mac);
+
+	if (opc_type == NPC_EXACT_OPC_CAM)
+		rvu_npc_exact_cam_table_write(rvu, blkaddr, index, mdata);
+	else
+		rvu_npc_exact_mem_table_write(rvu, blkaddr, ways, index,  mdata);
+
+	/* Insert entry to linked list */
+	err = rvu_npc_exact_add_to_list(rvu, opc_type, ways, index, cgx_id, lmac_id,
+					mac, chan, ctype, seq_id, cmd, mcam_idx, pcifunc);
+	if (err) {
+		rvu_npc_exact_dealloc_table_entry(rvu, opc_type, ways, index);
+		dev_err(rvu->dev, "%s: could not add to exact match table\n", __func__);
+		return err;
+	}
+
+	dev_dbg(rvu->dev,
+		"%s: Successfully added entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
+		__func__, index, mac, ways, opc_type);
+
+	return 0;
+}
+
+/**
+ *      rvu_npc_exact_update_table_entry - Update exact match table.
+ *      @rvu: resource virtualization unit.
+ *	@cgx_id: CGX identifier.
+ *	@lmac_id: LMAC identifier.
+ *	@old_mac: Existing MAC address entry.
+ *	@new_mac: New MAC address entry.
+ *	@seq_id: Sequence identifier of the entry.
+ *
+ *	Updates MAC address of an entry. If entry is in MEM table, new
+ *	hash value may not match with old one.
+ *	Return: 0 upon success.
+ */
+static int __maybe_unused rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id,
+							   u8 lmac_id, u8 *old_mac,
+							   u8 *new_mac, u32 *seq_id)
+{
+	int blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	struct npc_exact_table_entry *entry;
+	struct npc_exact_table *table;
+	u32 hash_index;
+	u64 mdata;
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+
+	/* Lookup for entry which needs to be updated */
+	entry = __rvu_npc_exact_find_entry_by_seq_id(rvu, *seq_id);
+	if (!entry) {
+		mutex_unlock(&table->lock);
+		dev_dbg(rvu->dev,
+			"%s: failed to find entry for cgx_id=%d lmac_id=%d old_mac=%pM\n",
+			__func__, cgx_id, lmac_id, old_mac);
+		return -ENODATA;
+	}
+
+	/* If entry is in mem table and new hash index is different than old
+	 * hash index, we cannot update the entry. Fail in these scenarios.
+	 */
+	if (entry->opc_type == NPC_EXACT_OPC_MEM) {
+		hash_index =  rvu_exact_calculate_hash(rvu, entry->chan, entry->ctype,
+						       new_mac, table->mem_table.mask,
+						       table->mem_table.depth);
+		if (hash_index != entry->index) {
+			dev_err(rvu->dev,
+				"%s: Update failed due to index mismatch(new=0x%x, old=%x)\n",
+				__func__, hash_index, entry->index);
+			mutex_unlock(&table->lock);
+			return -EINVAL;
+		}
+	}
+
+	mdata = rvu_exact_prepare_table_entry(rvu, true, entry->ctype, entry->chan, new_mac);
+
+	if (entry->opc_type == NPC_EXACT_OPC_MEM)
+		rvu_npc_exact_mem_table_write(rvu, blkaddr, entry->ways, entry->index, mdata);
+	else
+		rvu_npc_exact_cam_table_write(rvu, blkaddr, entry->index, mdata);
+
+	/* Update entry fields */
+	ether_addr_copy(entry->mac, new_mac);
+	*seq_id = entry->seq_id;
+
+	dev_dbg(rvu->dev,
+		"%s: Successfully updated entry (index=%d, dmac=%pM, ways=%d opc_type=%d\n",
+		__func__, hash_index, entry->mac, entry->ways, entry->opc_type);
+
+	dev_dbg(rvu->dev, "%s: Successfully updated entry (old mac=%pM new_mac=%pM\n",
+		__func__, old_mac, new_mac);
+
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+/**
+ *      rvu_npc_exact_init - initialize exact match table
+ *      @rvu: resource virtualization unit.
+ *
+ *	Initialize HW and SW resources to manage 4way-2K table and fully
+ *	associative 32-entry mcam table.
+ *	Return: 0 upon success.
+ */
+int rvu_npc_exact_init(struct rvu *rvu)
+{
+	struct npc_exact_table *table;
+	u64 npc_const3;
+	int table_size;
+	int blkaddr;
+	u64 cfg;
+	int i;
+
+	/* Read NPC_AF_CONST3 and check for have exact
+	 * match functionality is present
+	 */
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Check exact match feature is supported */
+	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
+	if (!(npc_const3 & BIT_ULL(62))) {
+		dev_info(rvu->dev, "%s: No support for exact match support\n",
+			 __func__);
+		return 0;
+	}
+
+	/* Check if kex profile has enabled EXACT match nibble */
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
+	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
+		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
+			 __func__);
+		return 0;
+	}
+
+	/* Set capability to true */
+	rvu->hw->cap.npc_exact_match_enabled = true;
+
+	table = kmalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	dev_dbg(rvu->dev, "%s: Memory allocation for table success\n", __func__);
+	memset(table, 0, sizeof(*table));
+	rvu->hw->table = table;
+
+	/* Read table size, ways and depth */
+	table->mem_table.depth = FIELD_GET(GENMASK_ULL(31, 24), npc_const3);
+	table->mem_table.ways = FIELD_GET(GENMASK_ULL(19, 16), npc_const3);
+	table->cam_table.depth = FIELD_GET(GENMASK_ULL(15, 0), npc_const3);
+
+	dev_dbg(rvu->dev, "%s: NPC exact match 4way_2k table(ways=%d, depth=%d)\n",
+		__func__,  table->mem_table.ways, table->cam_table.depth);
+
+	/* Check if depth of table is not a sequre of 2
+	 * TODO: why _builtin_popcount() is not working ?
+	 */
+	if ((table->mem_table.depth & (table->mem_table.depth - 1)) != 0) {
+		dev_err(rvu->dev,
+			"%s: NPC exact match 4way_2k table depth(%d) is not square of 2\n",
+			__func__,  table->mem_table.depth);
+		return -EINVAL;
+	}
+
+	table_size = table->mem_table.depth * table->mem_table.ways;
+
+	/* Allocate bitmap for 4way 2K table */
+	table->mem_table.bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table_size),
+					     sizeof(long), GFP_KERNEL);
+	if (!table->mem_table.bmap)
+		return -ENOMEM;
+
+	dev_dbg(rvu->dev, "%s: Allocated bitmap for 4way 2K entry table\n", __func__);
+
+	/* Allocate bitmap for 32 entry mcam */
+	table->cam_table.bmap = devm_kcalloc(rvu->dev, 1, sizeof(long), GFP_KERNEL);
+
+	if (!table->cam_table.bmap)
+		return -ENOMEM;
+
+	dev_dbg(rvu->dev, "%s: Allocated bitmap for 32 entry cam\n", __func__);
+
+	table->tot_ids = (table->mem_table.depth * table->mem_table.ways) + table->cam_table.depth;
+	table->id_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table->tot_ids),
+				      table->tot_ids, GFP_KERNEL);
+
+	if (!table->id_bmap)
+		return -ENOMEM;
+
+	dev_dbg(rvu->dev, "%s: Allocated bitmap for id map (total=%d)\n",
+		__func__, table->tot_ids);
+
+	/* Initialize list heads for npc_exact_table entries.
+	 * This entry is used by debugfs to show entries in
+	 * exact match table.
+	 */
+	for (i = 0; i < NPC_EXACT_TBL_MAX_WAYS; i++)
+		INIT_LIST_HEAD(&table->lhead_mem_tbl_entry[i]);
+
+	INIT_LIST_HEAD(&table->lhead_cam_tbl_entry);
+	INIT_LIST_HEAD(&table->lhead_gbl);
+
+	mutex_init(&table->lock);
+
+	rvu_exact_config_secret_key(rvu);
+	rvu_exact_config_search_key(rvu);
+
+	rvu_exact_config_table_mask(rvu);
+	rvu_exact_config_result_ctrl(rvu, table->mem_table.depth);
+
+	dev_info(rvu->dev, "initialized exact match table successfully\n");
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index d0d1ac925e1e..f2346aa79ce2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -129,4 +129,60 @@ static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	},
 };
 
+enum npc_exact_opc_type {
+	NPC_EXACT_OPC_MEM,
+	NPC_EXACT_OPC_CAM,
+};
+
+struct npc_exact_table_entry {
+	struct list_head list;
+	struct list_head glist;
+	u32 seq_id;	/* Sequence number of entry */
+	u32 index;	/* Mem table or cam table index */
+	u32 mcam_idx;
+		/* Mcam index. This is valid only if "cmd" field is false */
+	enum npc_exact_opc_type opc_type;
+	u16 chan;
+	u16 pcifunc;
+	u8 ways;
+	u8 mac[ETH_ALEN];
+	u8 ctype;
+	u8 cgx_id;
+	u8 lmac_id;
+	bool cmd;	/* Is added by ethtool command ? */
+};
+
+struct npc_exact_table {
+	struct mutex lock;	/* entries update lock */
+	unsigned long *id_bmap;
+	u32 tot_ids;
+	struct {
+		int ways;
+		int depth;
+		unsigned long *bmap;
+		u64 mask;	// Masks before hash calculation.
+		u16 hash_mask;	// 11 bits for hash mask
+		u16 hash_offset; // 11 bits offset
+	} mem_table;
+
+	struct {
+		int depth;
+		unsigned long *bmap;
+	} cam_table;
+#define NPC_EXACT_TBL_MAX_WAYS 4
+
+	struct list_head lhead_mem_tbl_entry[NPC_EXACT_TBL_MAX_WAYS];
+	int mem_tbl_entry_cnt;
+
+	struct list_head lhead_cam_tbl_entry;
+	int cam_tbl_entry_cnt;
+
+	struct list_head lhead_gbl;
+};
+
+bool rvu_npc_exact_has_match_table(struct rvu *rvu);
+int rvu_npc_exact_del_table_entry_by_id(struct rvu *rvu, u32 seq_id);
+u32 rvu_npc_exact_get_max_entries(struct rvu *rvu);
+int rvu_npc_exact_init(struct rvu *rvu);
+
 #endif /* RVU_NPC_HASH_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 801cb7d418ba..77a9ade91f3e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -605,6 +605,15 @@
 #define NPC_AF_DBG_DATAX(a)		(0x3001400 | (a) << 4)
 #define NPC_AF_DBG_RESULTX(a)		(0x3001800 | (a) << 4)
 
+#define NPC_AF_EXACT_MEM_ENTRY(a, b)	(0x300000 | (a) << 15 | (b) << 3)
+#define NPC_AF_EXACT_CAM_ENTRY(a)	(0xC00 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_MASK(a)	(0x660 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_RESULT_CTL(a)(0x680 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_CFG(a)	(0xA00 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_SECRET0(a)	(0xE00 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_SECRET1(a)	(0xE20 | (a) << 3)
+#define NPC_AF_INTFX_EXACT_SECRET2(a)	(0xE40 | (a) << 3)
+
 #define NPC_AF_MCAMEX_BANKX_CAMX_INTF(a, b, c) ({			   \
 	u64 offset;							   \
 									   \
-- 
2.25.1

