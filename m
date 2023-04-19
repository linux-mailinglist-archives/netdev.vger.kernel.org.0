Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0E86E731A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjDSGWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDSGV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:21:56 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DCE9EF6;
        Tue, 18 Apr 2023 23:21:22 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J3rEGd023194;
        Tue, 18 Apr 2023 23:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=lfOp3wJpnqadEP0qVQvK7te4u5FBGBGOXqeBDSnYvzI=;
 b=MC1mkcRrC4gRalC3SiVk1AtpswNpe3N4pZM+lg+LUyNKS3O16sUwuNp4ZjF+CVoXRPCB
 ReZRdE6f+JrcsBAUgrAZvXFo3GJtRGcuQLuLzgHdZ8QR7Oc6Ral1E6a+5GelHQF8CivE
 DxUaN2UXrNG5eMibGthNRC8NKr0Y6d1m0d5a+V+HDmtmq3qO6UVsjxMu7k2bvFiFdtMG
 rXKsrCTkg/HpSO645/vuwxzsg1jKgkD8XUfUDYNLREPVmEMRoyC2vAqjAuQ/8ceVykAo
 vEcDx/FFO0qzU3bNwuMohNtk1LOUolqMkPOm4r8r1FR3OeBdlZDn80JZyxJBMeF7cSRv Jg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q28s0gmhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 23:21:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 18 Apr
 2023 23:21:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 18 Apr 2023 23:21:06 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 811A73F7091;
        Tue, 18 Apr 2023 23:21:01 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3 08/10] octeontx2-af: Fix issues with NPC field hash extract
Date:   Wed, 19 Apr 2023 11:50:16 +0530
Message-ID: <20230419062018.286136-9-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419062018.286136-1-saikrishnag@marvell.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: IXEnZh5JRZrpnz8TK3tlkKHnRSjs2rU_
X-Proofpoint-ORIG-GUID: IXEnZh5JRZrpnz8TK3tlkKHnRSjs2rU_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_02,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ratheesh Kannoth <rkannoth@marvell.com>

1. Allow field hash configuration for both source and destination IPv6.
2. Configure hardware parser based on hash extract feature enable flag
   for IPv6.
3. Fix IPv6 endianness issue while updating the source/destination IP
   address via ntuple rule.

Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../marvell/octeontx2/af/rvu_npc_fs.c         | 23 +++--
 .../marvell/octeontx2/af/rvu_npc_fs.h         |  4 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 88 ++++++++++---------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  4 +-
 4 files changed, 69 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 27603078689a..6d63a0ef6d9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -13,11 +13,6 @@
 #include "rvu_npc_fs.h"
 #include "rvu_npc_hash.h"
 
-#define NPC_BYTESM		GENMASK_ULL(19, 16)
-#define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
-#define NPC_KEY_OFFSET		GENMASK_ULL(5, 0)
-#define NPC_LDATA_EN		BIT_ULL(7)
-
 static const char * const npc_flow_names[] = {
 	[NPC_DMAC]	= "dmac",
 	[NPC_SMAC]	= "smac",
@@ -442,6 +437,7 @@ static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
 static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
 			   u8 lt, u64 cfg, u8 intf)
 {
+	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u8 hdr, key, nr_bytes, bit_offset;
 	u8 la_ltype, la_start;
@@ -490,8 +486,21 @@ do {									       \
 	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
 	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
 	NPC_SCAN_HDR(NPC_IPFRAG_IPV6, NPC_LID_LC, NPC_LT_LC_IP6_EXT, 6, 1);
-	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
-	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	if (rvu->hw->cap.npc_hash_extract) {
+		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][0])
+			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 4);
+		else
+			NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
+
+		if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][1])
+			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 4);
+		else
+			NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	} else {
+		NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
+		NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	}
+
 	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
 	NPC_SCAN_HDR(NPC_DPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 2, 2);
 	NPC_SCAN_HDR(NPC_SPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 0, 2);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
index bdd65ce56a32..3f5c9042d10e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
@@ -9,6 +9,10 @@
 #define __RVU_NPC_FS_H
 
 #define IPV6_WORDS	4
+#define NPC_BYTESM	GENMASK_ULL(19, 16)
+#define NPC_HDR_OFFSET	GENMASK_ULL(15, 8)
+#define NPC_KEY_OFFSET	GENMASK_ULL(5, 0)
+#define NPC_LDATA_EN	BIT_ULL(7)
 
 void npc_update_entry(struct rvu *rvu, enum key_fields type,
 		      struct mcam_entry *entry, u64 val_lo,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 68f813040363..51209119f0f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -78,42 +78,43 @@ static u32 rvu_npc_toeplitz_hash(const u64 *data, u64 *key, size_t data_bit_len,
 	return hash_out;
 }
 
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx)
+u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
+			u8 intf, u8 hash_idx)
 {
 	u64 hash_key[3];
 	u64 data_padded[2];
 	u32 field_hash;
 
-	hash_key[0] = secret_key[1] << 31;
-	hash_key[0] |= secret_key[2];
-	hash_key[1] = secret_key[1] >> 33;
-	hash_key[1] |= secret_key[0] << 31;
-	hash_key[2] = secret_key[0] >> 33;
+	hash_key[0] = rsp.secret_key[1] << 31;
+	hash_key[0] |= rsp.secret_key[2];
+	hash_key[1] = rsp.secret_key[1] >> 33;
+	hash_key[1] |= rsp.secret_key[0] << 31;
+	hash_key[2] = rsp.secret_key[0] >> 33;
 
-	data_padded[0] = mkex_hash->hash_mask[intf][hash_idx][0] & ldata[0];
-	data_padded[1] = mkex_hash->hash_mask[intf][hash_idx][1] & ldata[1];
+	data_padded[0] = rsp.hash_mask[intf][hash_idx][0] & ldata[0];
+	data_padded[1] = rsp.hash_mask[intf][hash_idx][1] & ldata[1];
 	field_hash = rvu_npc_toeplitz_hash(data_padded, hash_key, 128, 159);
 
-	field_hash &= mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
-	field_hash |= mkex_hash->hash_ctrl[intf][hash_idx];
+	field_hash &= FIELD_GET(GENMASK(63, 32), rsp.hash_ctrl[intf][hash_idx]);
+	field_hash += FIELD_GET(GENMASK(31, 0), rsp.hash_ctrl[intf][hash_idx]);
 	return field_hash;
 }
 
-static u64 npc_update_use_hash(int lt, int ld)
+static u64 npc_update_use_hash(struct rvu *rvu, int blkaddr,
+			       u8 intf, int lid, int lt, int ld)
 {
-	u64 cfg = 0;
-
-	switch (lt) {
-	case NPC_LT_LC_IP6:
-		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
-		 * in KEX_LD_CFG
-		 */
-		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
-					  ld ? 0x18 : 0x8,
-					  0x1, 0x0, ld ? 0x14 : 0x10);
-		break;
-	}
+	u8 hdr, key;
+	u64 cfg;
+
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, lt, ld));
+	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
+	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
+
+	/* Update use_hash(bit-20) to 'true' and
+	 * bytesm1(bit-16:19) to '0x3' in KEX_LD_CFG
+	 */
+	cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
+				  hdr, 0x1, 0x0, key);
 
 	return cfg;
 }
@@ -132,11 +133,13 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
 			for (ld = 0; ld < NPC_MAX_LD; ld++) {
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
+					u64 cfg;
 
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
+					cfg = npc_update_use_hash(rvu, blkaddr,
+								  intf, lid, lt, ld);
 					/* Set updated KEX configuration */
 					SET_KEX_LD(intf, lid, lt, ld, cfg);
 					/* Set HASH configuration */
@@ -170,11 +173,13 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
 		for (lt = 0; lt < NPC_MAX_LT; lt++) {
 			for (ld = 0; ld < NPC_MAX_LD; ld++)
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
-					u64 cfg = npc_update_use_hash(lt, ld);
+					u64 cfg;
 
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
+					cfg = npc_update_use_hash(rvu, blkaddr,
+								  intf, lid, lt, ld);
 					/* Set updated KEX configuration */
 					SET_KEX_LD(intf, lid, lt, ld, cfg);
 					/* Set HASH configuration */
@@ -264,44 +269,45 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 				 * is hashed to 32 bit value.
 				 */
 				case NPC_LT_LC_IP6:
-					if (features & BIT_ULL(NPC_SIP_IPV6)) {
+					/* ld[0] == hash_idx[0] == Source IPv6
+					 * ld[1] == hash_idx[1] == Destination IPv6
+					 */
+					if ((features & BIT_ULL(NPC_SIP_IPV6)) && !hash_idx) {
 						u32 src_ip[IPV6_WORDS];
 
 						be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
-						ldata[0] = (u64)src_ip[0] << 32 | src_ip[1];
-						ldata[1] = (u64)src_ip[2] << 32 | src_ip[3];
+						ldata[1] = (u64)src_ip[0] << 32 | src_ip[1];
+						ldata[0] = (u64)src_ip[2] << 32 | src_ip[3];
 						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
+										 rsp,
 										 intf,
 										 hash_idx);
 						npc_update_entry(rvu, NPC_SIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
+								 field_hash, 0,
+								 GENMASK(31, 0), 0, intf);
 						memcpy(&opkt->ip6src, &pkt->ip6src,
 						       sizeof(pkt->ip6src));
 						memcpy(&omask->ip6src, &mask->ip6src,
 						       sizeof(mask->ip6src));
-						break;
-					}
-
-					if (features & BIT_ULL(NPC_DIP_IPV6)) {
+					} else if ((features & BIT_ULL(NPC_DIP_IPV6)) && hash_idx) {
 						u32 dst_ip[IPV6_WORDS];
 
 						be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
-						ldata[0] = (u64)dst_ip[0] << 32 | dst_ip[1];
-						ldata[1] = (u64)dst_ip[2] << 32 | dst_ip[3];
+						ldata[1] = (u64)dst_ip[0] << 32 | dst_ip[1];
+						ldata[0] = (u64)dst_ip[2] << 32 | dst_ip[3];
 						field_hash = npc_field_hash_calc(ldata,
-										 mkex_hash,
-										 rsp.secret_key,
+										 rsp,
 										 intf,
 										 hash_idx);
 						npc_update_entry(rvu, NPC_DIP_IPV6, entry,
-								 field_hash, 0, 32, 0, intf);
+								 field_hash, 0,
+								 GENMASK(31, 0), 0, intf);
 						memcpy(&opkt->ip6dst, &pkt->ip6dst,
 						       sizeof(pkt->ip6dst));
 						memcpy(&omask->ip6dst, &mask->ip6dst,
 						       sizeof(mask->ip6dst));
 					}
+
 					break;
 				}
 			}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 65936f4aeaac..a1c3d987b804 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -62,8 +62,8 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 			   struct flow_msg *omask);
 void npc_config_secret_key(struct rvu *rvu, int blkaddr);
 void npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
-u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
-			u64 *secret_key, u8 intf, u8 hash_idx);
+u32 npc_field_hash_calc(u64 *ldata, struct npc_get_field_hash_info_rsp rsp,
+			u8 intf, u8 hash_idx);
 
 static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
 	.lid_lt_ld_hash_en = {
-- 
2.25.1

