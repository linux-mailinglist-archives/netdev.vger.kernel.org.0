Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EC96EEF96
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbjDZHpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240031AbjDZHo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:44:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D6D422F;
        Wed, 26 Apr 2023 00:44:34 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q6qLYg013102;
        Wed, 26 Apr 2023 00:44:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=O1V9lezV7kH9mhYDlZwG3qcnJe2KQArGF4x9iHZuphs=;
 b=R89IIF17iUj3YFKN9uhzy5hVNM05LTNne95eYxvbiQm+yLpPSZt1XZKR9kvfgyPrEuzs
 jHkGp4W4bx6s6AHf/7DC0eQqrRoc9oG3/VxmD5lW6D7FWuigoF+9o+uynQue4ziilcLf
 nQyUDyMTUG+KdiZJ9AhImWQv6FPLe4w+9UemSg12tETc9D/V5kYnhhONr72WUQ6JICtx
 M9VkspxqKuXDptcI3faY/ioyi93Xm0V4oiWQ+/8+iwtAK7SH84v6LRErx/2EHLLjc7gR
 Acc5Zrt3m33BdseSfYZSXQ9vROTvNdprPtuVH4vLiLGLHP1skhb/Bphx/tATd2J888a7 fA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fdd4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 00:44:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Apr
 2023 00:44:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Apr 2023 00:44:26 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 0739E5B692D;
        Wed, 26 Apr 2023 00:44:21 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Ratheesh Kannoth <rkannoth@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v4 07/10] octeontx2-af: Update/Fix NPC field hash extract feature
Date:   Wed, 26 Apr 2023 13:13:42 +0530
Message-ID: <20230426074345.750135-8-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230426074345.750135-1-saikrishnag@marvell.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 0S_utFBx1-5y1rp4cvp5rGWflCx9lK7i
X-Proofpoint-ORIG-GUID: 0S_utFBx1-5y1rp4cvp5rGWflCx9lK7i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
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

1. As per previous implementation, mask and control parameter to
generate the field hash value was not passed to the caller program.
Updated the secret key mbox to share that information as well,
as a part of the fix.
2. Earlier implementation did not consider hash reduction of both
source and destination IPv6 addresses. Only source IPv6 address
was considered. This fix solves that and provides option to hash

Fixes: 56d9f5fd2246 ("octeontx2-af: Use hashed field in MCAM key")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 16 +++++---
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 37 ++++++++++++-------
 .../marvell/octeontx2/af/rvu_npc_hash.h       |  6 +++
 3 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 5727d67e0259..0ce533848536 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -245,9 +245,9 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 				   npc_mcam_get_stats_req,              \
 				   npc_mcam_get_stats_rsp)              \
-M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
-				   npc_get_secret_key_req,              \
-				   npc_get_secret_key_rsp)              \
+M(NPC_GET_FIELD_HASH_INFO, 0x6013, npc_get_field_hash_info,                     \
+				   npc_get_field_hash_info_req,              \
+				   npc_get_field_hash_info_rsp)              \
 M(NPC_GET_FIELD_STATUS, 0x6014, npc_get_field_status,                     \
 				   npc_get_field_status_req,              \
 				   npc_get_field_status_rsp)              \
@@ -1524,14 +1524,20 @@ struct npc_mcam_get_stats_rsp {
 	u8 stat_ena; /* enabled */
 };
 
-struct npc_get_secret_key_req {
+struct npc_get_field_hash_info_req {
 	struct mbox_msghdr hdr;
 	u8 intf;
 };
 
-struct npc_get_secret_key_rsp {
+struct npc_get_field_hash_info_rsp {
 	struct mbox_msghdr hdr;
 	u64 secret_key[3];
+#define NPC_MAX_HASH 2
+#define NPC_MAX_HASH_MASK 2
+	/* NPC_AF_INTF(0..1)_HASH(0..1)_MASK(0..1) */
+	u64 hash_mask[NPC_MAX_INTF][NPC_MAX_HASH][NPC_MAX_HASH_MASK];
+	/* NPC_AF_INTF(0..1)_HASH(0..1)_RESULT_CTRL */
+	u64 hash_ctrl[NPC_MAX_INTF][NPC_MAX_HASH];
 };
 
 enum ptp_op {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 6597af84aa36..68f813040363 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -110,8 +110,8 @@ static u64 npc_update_use_hash(int lt, int ld)
 		 * in KEX_LD_CFG
 		 */
 		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
-					  ld ? 0x8 : 0x18,
-					  0x1, 0x0, 0x10);
+					  ld ? 0x18 : 0x8,
+					  0x1, 0x0, ld ? 0x14 : 0x10);
 		break;
 	}
 
@@ -134,7 +134,6 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
 					u64 cfg = npc_update_use_hash(lt, ld);
 
-					hash_cnt++;
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
@@ -149,6 +148,8 @@ static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
 							     mkex_hash->hash_mask[intf][ld][1]);
 					SET_KEX_LD_HASH_CTRL(intf, ld,
 							     mkex_hash->hash_ctrl[intf][ld]);
+
+					hash_cnt++;
 				}
 			}
 		}
@@ -171,7 +172,6 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
 				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
 					u64 cfg = npc_update_use_hash(lt, ld);
 
-					hash_cnt++;
 					if (hash_cnt == NPC_MAX_HASH)
 						return;
 
@@ -187,8 +187,6 @@ static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
 					SET_KEX_LD_HASH_CTRL(intf, ld,
 							     mkex_hash->hash_ctrl[intf][ld]);
 					hash_cnt++;
-					if (hash_cnt == NPC_MAX_HASH)
-						return;
 				}
 		}
 	}
@@ -238,8 +236,8 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 			   struct flow_msg *omask)
 {
 	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
-	struct npc_get_secret_key_req req;
-	struct npc_get_secret_key_rsp rsp;
+	struct npc_get_field_hash_info_req req;
+	struct npc_get_field_hash_info_rsp rsp;
 	u64 ldata[2], cfg;
 	u32 field_hash;
 	u8 hash_idx;
@@ -250,7 +248,7 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 	}
 
 	req.intf = intf;
-	rvu_mbox_handler_npc_get_secret_key(rvu, &req, &rsp);
+	rvu_mbox_handler_npc_get_field_hash_info(rvu, &req, &rsp);
 
 	for (hash_idx = 0; hash_idx < NPC_MAX_HASH; hash_idx++) {
 		cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_CFG(intf, hash_idx));
@@ -311,13 +309,13 @@ void npc_update_field_hash(struct rvu *rvu, u8 intf,
 	}
 }
 
-int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
-					struct npc_get_secret_key_req *req,
-					struct npc_get_secret_key_rsp *rsp)
+int rvu_mbox_handler_npc_get_field_hash_info(struct rvu *rvu,
+					     struct npc_get_field_hash_info_req *req,
+					     struct npc_get_field_hash_info_rsp *rsp)
 {
 	u64 *secret_key = rsp->secret_key;
 	u8 intf = req->intf;
-	int blkaddr;
+	int i, j, blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0) {
@@ -329,6 +327,19 @@ int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
 	secret_key[1] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf));
 	secret_key[2] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf));
 
+	for (i = 0; i < NPC_MAX_HASH; i++) {
+		for (j = 0; j < NPC_MAX_HASH_MASK; j++) {
+			rsp->hash_mask[NIX_INTF_RX][i][j] =
+				GET_KEX_LD_HASH_MASK(NIX_INTF_RX, i, j);
+			rsp->hash_mask[NIX_INTF_TX][i][j] =
+				GET_KEX_LD_HASH_MASK(NIX_INTF_TX, i, j);
+		}
+	}
+
+	for (i = 0; i < NPC_MAX_INTF; i++)
+		for (j = 0; j < NPC_MAX_HASH; j++)
+			rsp->hash_ctrl[i][j] = GET_KEX_LD_HASH_CTRL(i, j);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
index 3efeb09c58de..65936f4aeaac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -31,6 +31,12 @@
 	rvu_write64(rvu, blkaddr,	\
 		    NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx), cfg)
 
+#define GET_KEX_LD_HASH_CTRL(intf, ld)	\
+	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld))
+
+#define GET_KEX_LD_HASH_MASK(intf, ld, mask_idx)	\
+	rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx))
+
 #define SET_KEX_LD_HASH_CTRL(intf, ld, cfg) \
 	rvu_write64(rvu, blkaddr,	\
 		    NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld), cfg)
-- 
2.25.1

