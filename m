Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A0F569967
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiGGEpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiGGEp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:45:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F01230575;
        Wed,  6 Jul 2022 21:45:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674gQ5Z017857;
        Wed, 6 Jul 2022 21:45:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=FA+njnxCVzkQTBcPuBk22W1kRm0nFfVc6RO+g0a5Fyk=;
 b=CRrrIJPNbeiPVsL1WADKAYCYZUss7qkKWPdgtHX9Wb5kaFloThzr5qW8n4x0vm2yh5qI
 L9CPAh4HzcosaXKQvnDT1g7OjVKItk1Ff1CWhEo4xsQYj2MtRolVxk/VgmVV21BoI1hH
 n/c3goT5MVggjRf1sd68erNPgqlJAKdfL5wRgijiEuuyg6fgyfAQTnyX95NU6wpDePAc
 ESX5waOq6hECtktnzg2geD4XZAPab0LK6Dr8ud2EiWyscuWc/l63poy4YxfyV0D2O9et
 JHYmY226TbXcjstWwoEm9N9F+jjFKPHy0tEUlxxbTA3e5DDbWgymtzjAwlGDZinkKmbv qw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt48fb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:45:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 Jul
 2022 21:45:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 Jul 2022 21:45:03 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id A26403F7081;
        Wed,  6 Jul 2022 21:44:59 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>,
        Suman Ghosh <sumang@marvell.com>
Subject: [PATCH V2 01/12] octeontx2-af: Use hashed field in MCAM key
Date:   Thu, 7 Jul 2022 10:13:53 +0530
Message-ID: <20220707044404.2723378-2-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707044404.2723378-1-rkannoth@marvell.com>
References: <20220707044404.2723378-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: MRCLvvbz7kFj25-tyKf0kZeQ34sgrl3A
X-Proofpoint-GUID: MRCLvvbz7kFj25-tyKf0kZeQ34sgrl3A
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

CN10KB variant of CN10K series of silicons supports
a new feature where in a large protocol field
(eg 128bit IPv6 DIP) can be condensed into a small
hashed 32bit data. This saves a lot of space in MCAM key
and allows user to add more protocol fields into the filter.
A max of two such protocol data can be hashed.
This patch adds support for hashing IPv6 SIP and/or DIP.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  14 +
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  13 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   |   1 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  14 +-
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  21 +-
 .../marvell/octeontx2/af/rvu_npc_fs.h         |  17 +
 .../marvell/octeontx2/af/rvu_npc_hash.c       | 338 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.h       | 132 +++++++
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   6 +
 12 files changed, 554 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 7f4a4ca9af78..40203560b291 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -11,4 +11,4 @@ rvu_mbox-y := mbox.o rvu_trace.o
 rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
 		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o \
-		  rvu_sdp.o
+		  rvu_sdp.o rvu_npc_hash.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 550cb11197bf..38e064bdaf72 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -241,6 +241,9 @@ M(NPC_MCAM_READ_BASE_RULE, 0x6011, npc_read_base_steer_rule,            \
 M(NPC_MCAM_GET_STATS, 0x6012, npc_mcam_entry_stats,                     \
 				   npc_mcam_get_stats_req,              \
 				   npc_mcam_get_stats_rsp)              \
+M(NPC_GET_SECRET_KEY, 0x6013, npc_get_secret_key,                     \
+				   npc_get_secret_key_req,              \
+				   npc_get_secret_key_rsp)              \
 /* NIX mbox IDs (range 0x8000 - 0xFFFF) */				\
 M(NIX_LF_ALLOC,		0x8000, nix_lf_alloc,				\
 				 nix_lf_alloc_req, nix_lf_alloc_rsp)	\
@@ -428,6 +431,7 @@ struct get_hw_cap_rsp {
 	struct mbox_msghdr hdr;
 	u8 nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
 	u8 nix_shaping;		     /* Is shaping and coloring supported */
+	u8 npc_hash_extract;	/* Is hash extract supported */
 };
 
 /* CGX mbox message formats */
@@ -1440,6 +1444,16 @@ struct npc_mcam_get_stats_rsp {
 	u8 stat_ena; /* enabled */
 };
 
+struct npc_get_secret_key_req {
+	struct mbox_msghdr hdr;
+	u8 intf;
+};
+
+struct npc_get_secret_key_rsp {
+	struct mbox_msghdr hdr;
+	u64 secret_key[3];
+};
+
 enum ptp_op {
 	PTP_OP_ADJFINE = 0,
 	PTP_OP_GET_CLOCK = 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 9b6e587e78b4..6d5799a7d3ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -10,6 +10,14 @@
 
 #define NPC_KEX_CHAN_MASK	0xFFFULL
 
+#define SET_KEX_LD(intf, lid, ltype, ld, cfg)	\
+	rvu_write64(rvu, blkaddr,	\
+		    NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, ltype, ld), cfg)
+
+#define SET_KEX_LDFLAGS(intf, ld, flags, cfg)	\
+	rvu_write64(rvu, blkaddr,	\
+		    NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
+
 enum NPC_LID_E {
 	NPC_LID_LA = 0,
 	NPC_LID_LB,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 54e1b27a7dfe..8f67013e0592 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -68,6 +68,7 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 	hw->cap.nix_tx_link_bp = true;
 	hw->cap.nix_rx_multicast = true;
 	hw->cap.nix_shaper_toggle_wait = false;
+	hw->cap.npc_hash_extract = false;
 	hw->rvu = rvu;
 
 	if (is_rvu_pre_96xx_C0(rvu)) {
@@ -85,6 +86,9 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
 
 	if (!is_rvu_otx2(rvu))
 		hw->cap.per_pf_mbox_regs = true;
+
+	if (is_rvu_npc_hash_extract_en(rvu))
+		hw->cap.npc_hash_extract = true;
 }
 
 /* Poll a RVU block's register 'offset', for a 'zero'
@@ -1991,6 +1995,7 @@ int rvu_mbox_handler_get_hw_cap(struct rvu *rvu, struct msg_req *req,
 
 	rsp->nix_fixed_txschq_mapping = hw->cap.nix_fixed_txschq_mapping;
 	rsp->nix_shaping = hw->cap.nix_shaping;
+	rsp->npc_hash_extract = hw->cap.npc_hash_extract;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 513b43ecd5be..f7e9cf822371 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -338,6 +338,7 @@ struct hw_cap {
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
+	bool	npc_hash_extract; /* Hash extract enabled ? */
 };
 
 struct rvu_hwinfo {
@@ -419,6 +420,7 @@ struct npc_kpu_profile_adapter {
 	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
 	const struct npc_kpu_profile	*kpu; /* array[kpus] */
 	struct npc_mcam_kex		*mkex;
+	struct npc_mcam_kex_hash	*mkex_hash;
 	bool				custom;
 	size_t				pkinds;
 	size_t				kpus;
@@ -575,6 +577,17 @@ static inline bool is_rvu_otx2(struct rvu *rvu)
 		midr == PCI_REVISION_ID_95XXMM || midr == PCI_REVISION_ID_95XXO);
 }
 
+static inline bool is_rvu_npc_hash_extract_en(struct rvu *rvu)
+{
+	u64 npc_const3;
+
+	npc_const3 = rvu_read64(rvu, BLKADDR_NPC, NPC_AF_CONST3);
+	if (!(npc_const3 & BIT_ULL(62)))
+		return false;
+
+	return true;
+}
+
 static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
 				   u8 lmacid, u8 chan)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 9ffe99830e34..97a633c1d395 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -14,6 +14,7 @@
 #include "lmac_common.h"
 #include "rvu_reg.h"
 #include "rvu_trace.h"
+#include "rvu_npc_hash.h"
 
 struct cgx_evq_entry {
 	struct list_head evq_node;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index e05fd2b9a929..86cf5794490f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -15,6 +15,7 @@
 #include "npc.h"
 #include "cgx.h"
 #include "npc_profile.h"
+#include "rvu_npc_hash.h"
 
 #define RSVD_MCAM_ENTRIES_PER_PF	3 /* Broadcast, Promisc and AllMulticast */
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
@@ -1181,14 +1182,6 @@ void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	rvu_npc_disable_default_entries(rvu, pcifunc, nixlf);
 }
 
-#define SET_KEX_LD(intf, lid, ltype, ld, cfg)	\
-	rvu_write64(rvu, blkaddr,			\
-		NPC_AF_INTFX_LIDX_LTX_LDX_CFG(intf, lid, ltype, ld), cfg)
-
-#define SET_KEX_LDFLAGS(intf, ld, flags, cfg)	\
-	rvu_write64(rvu, blkaddr,			\
-		NPC_AF_INTFX_LDATAX_FLAGSX_CFG(intf, ld, flags), cfg)
-
 static void npc_program_mkex_rx(struct rvu *rvu, int blkaddr,
 				struct npc_mcam_kex *mkex, u8 intf)
 {
@@ -1262,6 +1255,9 @@ static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 		npc_program_mkex_rx(rvu, blkaddr, mkex, intf);
 		npc_program_mkex_tx(rvu, blkaddr, mkex, intf);
 	}
+
+	/* Programme mkex hash profile */
+	npc_program_mkex_hash(rvu, blkaddr);
 }
 
 static int npc_fwdb_prfl_img_map(struct rvu *rvu, void __iomem **prfl_img_addr,
@@ -1463,6 +1459,7 @@ static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 	profile->kpus = ARRAY_SIZE(npc_kpu_profiles);
 	profile->lt_def = &npc_lt_defaults;
 	profile->mkex = &npc_mkex_default;
+	profile->mkex_hash = &npc_mkex_hash_default;
 
 	return 0;
 }
@@ -2047,6 +2044,7 @@ int rvu_npc_init(struct rvu *rvu)
 
 	rvu_npc_setup_interfaces(rvu, blkaddr);
 
+	npc_config_secret_key(rvu, blkaddr);
 	/* Configure MKEX profile */
 	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 19c53e591d0d..08a0fa44857e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -10,6 +10,8 @@
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "npc.h"
+#include "rvu_npc_hash.h"
+#include "rvu_npc_fs.h"
 
 #define NPC_BYTESM		GENMASK_ULL(19, 16)
 #define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
@@ -624,9 +626,9 @@ static int npc_check_unsupported_flows(struct rvu *rvu, u64 features, u8 intf)
  * If any bits in mask are 0 then corresponding bits in value are
  * dont care.
  */
-static void npc_update_entry(struct rvu *rvu, enum key_fields type,
-			     struct mcam_entry *entry, u64 val_lo,
-			     u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf)
+void npc_update_entry(struct rvu *rvu, enum key_fields type,
+		      struct mcam_entry *entry, u64 val_lo,
+		      u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct mcam_entry dummy = { {0} };
@@ -705,8 +707,6 @@ static void npc_update_entry(struct rvu *rvu, enum key_fields type,
 	}
 }
 
-#define IPV6_WORDS     4
-
 static void npc_update_ipv6_flow(struct rvu *rvu, struct mcam_entry *entry,
 				 u64 features, struct flow_msg *pkt,
 				 struct flow_msg *mask,
@@ -779,7 +779,8 @@ static void npc_update_vlan_features(struct rvu *rvu, struct mcam_entry *entry,
 static void npc_update_flow(struct rvu *rvu, struct mcam_entry *entry,
 			    u64 features, struct flow_msg *pkt,
 			    struct flow_msg *mask,
-			    struct rvu_npc_mcam_rule *output, u8 intf)
+			    struct rvu_npc_mcam_rule *output, u8 intf,
+			    int blkaddr)
 {
 	u64 dmac_mask = ether_addr_to_u64(mask->dmac);
 	u64 smac_mask = ether_addr_to_u64(mask->smac);
@@ -854,6 +855,9 @@ do {									      \
 
 	npc_update_ipv6_flow(rvu, entry, features, pkt, mask, output, intf);
 	npc_update_vlan_features(rvu, entry, features, intf);
+
+	npc_update_field_hash(rvu, intf, entry, blkaddr, features,
+			      pkt, mask, opkt, omask);
 }
 
 static struct rvu_npc_mcam_rule *rvu_mcam_find_rule(struct npc_mcam *mcam,
@@ -1032,7 +1036,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	entry_index = req->entry;
 
 	npc_update_flow(rvu, entry, features, &req->packet, &req->mask, &dummy,
-			req->intf);
+			req->intf, blkaddr);
 
 	if (is_npc_intf_rx(req->intf))
 		npc_update_rx_entry(rvu, pfvf, entry, req, target, pf_set_vfs_mac);
@@ -1057,7 +1061,8 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			npc_update_flow(rvu, entry, missing_features,
 					&def_ucast_rule->packet,
 					&def_ucast_rule->mask,
-					&dummy, req->intf);
+					&dummy, req->intf,
+					blkaddr);
 		installed_features = req->features | missing_features;
 	}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
new file mode 100644
index 000000000000..bdd65ce56a32
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+
+#ifndef __RVU_NPC_FS_H
+#define __RVU_NPC_FS_H
+
+#define IPV6_WORDS	4
+
+void npc_update_entry(struct rvu *rvu, enum key_fields type,
+		      struct mcam_entry *entry, u64 val_lo,
+		      u64 val_hi, u64 mask_lo, u64 mask_hi, u8 intf);
+
+#endif /* RVU_NPC_FS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
new file mode 100644
index 000000000000..dbb33075b7f0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+
+#include <linux/bitfield.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/stddef.h>
+#include <linux/debugfs.h>
+#include <linux/bitfield.h>
+
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "rvu.h"
+#include "npc.h"
+#include "cgx.h"
+#include "rvu_npc_hash.h"
+#include "rvu_npc_fs.h"
+
+static u64 rvu_npc_wide_extract(const u64 input[], size_t start_bit,
+				size_t width_bits)
+{
+	const u64 mask = ~(u64)((~(__uint128_t)0) << width_bits);
+	const size_t msb = start_bit + width_bits - 1;
+	const size_t lword = start_bit >> 6;
+	const size_t uword = msb >> 6;
+	size_t lbits;
+	u64 hi, lo;
+
+	if (lword == uword)
+		return (input[lword] >> (start_bit & 63)) & mask;
+
+	lbits = 64 - (start_bit & 63);
+	hi = input[uword];
+	lo = (input[lword] >> (start_bit & 63));
+	return ((hi << lbits) | lo) & mask;
+}
+
+static void rvu_npc_lshift_key(u64 *key, size_t key_bit_len)
+{
+	u64 prev_orig_word = 0;
+	u64 cur_orig_word = 0;
+	size_t extra = key_bit_len % 64;
+	size_t max_idx = key_bit_len / 64;
+	size_t i;
+
+	if (extra)
+		max_idx++;
+
+	for (i = 0; i < max_idx; i++) {
+		cur_orig_word = key[i];
+		key[i] = key[i] << 1;
+		key[i] |= ((prev_orig_word >> 63) & 0x1);
+		prev_orig_word = cur_orig_word;
+	}
+}
+
+static u32 rvu_npc_toeplitz_hash(const u64 *data, u64 *key, size_t data_bit_len,
+				 size_t key_bit_len)
+{
+	u32 hash_out = 0;
+	u64 temp_data = 0;
+	int i;
+
+	for (i = data_bit_len - 1; i >= 0; i--) {
+		temp_data = (data[i / 64]);
+		temp_data = temp_data >> (i % 64);
+		temp_data &= 0x1;
+		if (temp_data)
+			hash_out ^= (u32)(rvu_npc_wide_extract(key, key_bit_len - 32, 32));
+
+		rvu_npc_lshift_key(key, key_bit_len);
+	}
+
+	return hash_out;
+}
+
+u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
+			u64 *secret_key, u8 intf, u8 hash_idx)
+{
+	u64 hash_key[3];
+	u64 data_padded[2];
+	u32 field_hash;
+
+	hash_key[0] = secret_key[1] << 31;
+	hash_key[0] |= secret_key[2];
+	hash_key[1] = secret_key[1] >> 33;
+	hash_key[1] |= secret_key[0] << 31;
+	hash_key[2] = secret_key[0] >> 33;
+
+	data_padded[0] = mkex_hash->hash_mask[intf][hash_idx][0] & ldata[0];
+	data_padded[1] = mkex_hash->hash_mask[intf][hash_idx][1] & ldata[1];
+	field_hash = rvu_npc_toeplitz_hash(data_padded, hash_key, 128, 159);
+
+	field_hash &= mkex_hash->hash_ctrl[intf][hash_idx] >> 32;
+	field_hash |= mkex_hash->hash_ctrl[intf][hash_idx];
+	return field_hash;
+}
+
+static u64 npc_update_use_hash(int lt, int ld)
+{
+	u64 cfg = 0;
+
+	switch (lt) {
+	case NPC_LT_LC_IP6:
+		/* Update use_hash(bit-20) and bytesm1 (bit-16:19)
+		 * in KEX_LD_CFG
+		 */
+		cfg = KEX_LD_CFG_USE_HASH(0x1, 0x03,
+					  ld ? 0x8 : 0x18,
+					  0x1, 0x0, 0x10);
+		break;
+	}
+
+	return cfg;
+}
+
+static void npc_program_mkex_hash_rx(struct rvu *rvu, int blkaddr,
+				     u8 intf)
+{
+	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
+	int lid, lt, ld, hash_cnt = 0;
+
+	if (is_npc_intf_tx(intf))
+		return;
+
+	/* Program HASH_CFG */
+	for (lid = 0; lid < NPC_MAX_LID; lid++) {
+		for (lt = 0; lt < NPC_MAX_LT; lt++) {
+			for (ld = 0; ld < NPC_MAX_LD; ld++) {
+				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
+					u64 cfg = npc_update_use_hash(lt, ld);
+
+					hash_cnt++;
+					if (hash_cnt == NPC_MAX_HASH)
+						return;
+
+					/* Set updated KEX configuration */
+					SET_KEX_LD(intf, lid, lt, ld, cfg);
+					/* Set HASH configuration */
+					SET_KEX_LD_HASH(intf, ld,
+							mkex_hash->hash[intf][ld]);
+					SET_KEX_LD_HASH_MASK(intf, ld, 0,
+							     mkex_hash->hash_mask[intf][ld][0]);
+					SET_KEX_LD_HASH_MASK(intf, ld, 1,
+							     mkex_hash->hash_mask[intf][ld][1]);
+					SET_KEX_LD_HASH_CTRL(intf, ld,
+							     mkex_hash->hash_ctrl[intf][ld]);
+				}
+			}
+		}
+	}
+}
+
+static void npc_program_mkex_hash_tx(struct rvu *rvu, int blkaddr,
+				     u8 intf)
+{
+	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
+	int lid, lt, ld, hash_cnt = 0;
+
+	if (is_npc_intf_rx(intf))
+		return;
+
+	/* Program HASH_CFG */
+	for (lid = 0; lid < NPC_MAX_LID; lid++) {
+		for (lt = 0; lt < NPC_MAX_LT; lt++) {
+			for (ld = 0; ld < NPC_MAX_LD; ld++)
+				if (mkex_hash->lid_lt_ld_hash_en[intf][lid][lt][ld]) {
+					u64 cfg = npc_update_use_hash(lt, ld);
+
+					hash_cnt++;
+					if (hash_cnt == NPC_MAX_HASH)
+						return;
+
+					/* Set updated KEX configuration */
+					SET_KEX_LD(intf, lid, lt, ld, cfg);
+					/* Set HASH configuration */
+					SET_KEX_LD_HASH(intf, ld,
+							mkex_hash->hash[intf][ld]);
+					SET_KEX_LD_HASH_MASK(intf, ld, 0,
+							     mkex_hash->hash_mask[intf][ld][0]);
+					SET_KEX_LD_HASH_MASK(intf, ld, 1,
+							     mkex_hash->hash_mask[intf][ld][1]);
+					SET_KEX_LD_HASH_CTRL(intf, ld,
+							     mkex_hash->hash_ctrl[intf][ld]);
+					hash_cnt++;
+					if (hash_cnt == NPC_MAX_HASH)
+						return;
+				}
+		}
+	}
+}
+
+void npc_config_secret_key(struct rvu *rvu, int blkaddr)
+{
+	struct hw_cap *hwcap = &rvu->hw->cap;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u8 intf;
+
+	if (!hwcap->npc_hash_extract) {
+		dev_info(rvu->dev, "HW does not support secret key configuration\n");
+		return;
+	}
+
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf),
+			    RVU_NPC_HASH_SECRET_KEY0);
+		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf),
+			    RVU_NPC_HASH_SECRET_KEY1);
+		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf),
+			    RVU_NPC_HASH_SECRET_KEY2);
+	}
+}
+
+void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
+{
+	struct hw_cap *hwcap = &rvu->hw->cap;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u8 intf;
+
+	if (!hwcap->npc_hash_extract) {
+		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
+		return;
+	}
+
+	for (intf = 0; intf < hw->npc_intfs; intf++) {
+		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
+		npc_program_mkex_hash_tx(rvu, blkaddr, intf);
+	}
+}
+
+void npc_update_field_hash(struct rvu *rvu, u8 intf,
+			   struct mcam_entry *entry,
+			   int blkaddr,
+			   u64 features,
+			   struct flow_msg *pkt,
+			   struct flow_msg *mask,
+			   struct flow_msg *opkt,
+			   struct flow_msg *omask)
+{
+	struct npc_mcam_kex_hash *mkex_hash = rvu->kpu.mkex_hash;
+	struct npc_get_secret_key_req req;
+	struct npc_get_secret_key_rsp rsp;
+	u64 ldata[2], cfg;
+	u32 field_hash;
+	u8 hash_idx;
+
+	if (!rvu->hw->cap.npc_hash_extract) {
+		dev_dbg(rvu->dev, "%s: Field hash extract feature is not supported\n", __func__);
+		return;
+	}
+
+	req.intf = intf;
+	rvu_mbox_handler_npc_get_secret_key(rvu, &req, &rsp);
+
+	for (hash_idx = 0; hash_idx < NPC_MAX_HASH; hash_idx++) {
+		cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_HASHX_CFG(intf, hash_idx));
+		if ((cfg & BIT_ULL(11)) && (cfg & BIT_ULL(12))) {
+			u8 lid = (cfg & GENMASK_ULL(10, 8)) >> 8;
+			u8 ltype = (cfg & GENMASK_ULL(7, 4)) >> 4;
+			u8 ltype_mask = cfg & GENMASK_ULL(3, 0);
+
+			if (mkex_hash->lid_lt_ld_hash_en[intf][lid][ltype][hash_idx]) {
+				switch (ltype & ltype_mask) {
+				/* If hash extract enabled is supported for IPv6 then
+				 * 128 bit IPv6 source and destination addressed
+				 * is hashed to 32 bit value.
+				 */
+				case NPC_LT_LC_IP6:
+					if (features & BIT_ULL(NPC_SIP_IPV6)) {
+						u32 src_ip[IPV6_WORDS];
+
+						be32_to_cpu_array(src_ip, pkt->ip6src, IPV6_WORDS);
+						ldata[0] = (u64)src_ip[0] << 32 | src_ip[1];
+						ldata[1] = (u64)src_ip[2] << 32 | src_ip[3];
+						field_hash = npc_field_hash_calc(ldata,
+										 mkex_hash,
+										 rsp.secret_key,
+										 intf,
+										 hash_idx);
+						npc_update_entry(rvu, NPC_SIP_IPV6, entry,
+								 field_hash, 0, 32, 0, intf);
+						memcpy(&opkt->ip6src, &pkt->ip6src,
+						       sizeof(pkt->ip6src));
+						memcpy(&omask->ip6src, &mask->ip6src,
+						       sizeof(mask->ip6src));
+						break;
+					}
+
+					if (features & BIT_ULL(NPC_DIP_IPV6)) {
+						u32 dst_ip[IPV6_WORDS];
+
+						be32_to_cpu_array(dst_ip, pkt->ip6dst, IPV6_WORDS);
+						ldata[0] = (u64)dst_ip[0] << 32 | dst_ip[1];
+						ldata[1] = (u64)dst_ip[2] << 32 | dst_ip[3];
+						field_hash = npc_field_hash_calc(ldata,
+										 mkex_hash,
+										 rsp.secret_key,
+										 intf,
+										 hash_idx);
+						npc_update_entry(rvu, NPC_DIP_IPV6, entry,
+								 field_hash, 0, 32, 0, intf);
+						memcpy(&opkt->ip6dst, &pkt->ip6dst,
+						       sizeof(pkt->ip6dst));
+						memcpy(&omask->ip6dst, &mask->ip6dst,
+						       sizeof(mask->ip6dst));
+					}
+					break;
+				}
+			}
+		}
+	}
+}
+
+int rvu_mbox_handler_npc_get_secret_key(struct rvu *rvu,
+					struct npc_get_secret_key_req *req,
+					struct npc_get_secret_key_rsp *rsp)
+{
+	u64 *secret_key = rsp->secret_key;
+	u8 intf = req->intf;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+
+	secret_key[0] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf));
+	secret_key[1] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY1(intf));
+	secret_key[2] = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY2(intf));
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
new file mode 100644
index 000000000000..d0d1ac925e1e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell RVU Admin Function driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+
+#ifndef __RVU_NPC_HASH_H
+#define __RVU_NPC_HASH_H
+
+#define RVU_NPC_HASH_SECRET_KEY0 0xa9d5af4c9fbc76b1
+#define RVU_NPC_HASH_SECRET_KEY1 0xa9d5af4c9fbc87b4
+#define RVU_NPC_HASH_SECRET_KEY2 0x5954c9e7
+
+#define NPC_MAX_HASH 2
+#define NPC_MAX_HASH_MASK 2
+
+#define KEX_LD_CFG_USE_HASH(use_hash, bytesm1, hdr_ofs, ena, flags_ena, key_ofs) \
+			    ((use_hash) << 20 | ((bytesm1) << 16) | ((hdr_ofs) << 8) | \
+			     ((ena) << 7) | ((flags_ena) << 6) | ((key_ofs) & 0x3F))
+#define KEX_LD_CFG_HASH(hdr_ofs, bytesm1, lt_en, lid_en, lid, ltype_match, ltype_mask)	\
+			(((hdr_ofs) << 32) | ((bytesm1) << 16) | \
+			 ((lt_en) << 12) | ((lid_en) << 11) | ((lid) << 8) | \
+			 ((ltype_match) << 4) | ((ltype_mask) & 0xF))
+
+#define SET_KEX_LD_HASH(intf, ld, cfg) \
+	rvu_write64(rvu, blkaddr,	\
+		    NPC_AF_INTFX_HASHX_CFG(intf, ld), cfg)
+
+#define SET_KEX_LD_HASH_MASK(intf, ld, mask_idx, cfg) \
+	rvu_write64(rvu, blkaddr,	\
+		    NPC_AF_INTFX_HASHX_MASKX(intf, ld, mask_idx), cfg)
+
+#define SET_KEX_LD_HASH_CTRL(intf, ld, cfg) \
+	rvu_write64(rvu, blkaddr,	\
+		    NPC_AF_INTFX_HASHX_RESULT_CTRL(intf, ld), cfg)
+
+struct npc_mcam_kex_hash {
+	/* NPC_AF_INTF(0..1)_LID(0..7)_LT(0..15)_LD(0..1)_CFG */
+	bool lid_lt_ld_hash_en[NPC_MAX_INTF][NPC_MAX_LID][NPC_MAX_LT][NPC_MAX_LD];
+	/* NPC_AF_INTF(0..1)_HASH(0..1)_CFG */
+	u64 hash[NPC_MAX_INTF][NPC_MAX_HASH];
+	/* NPC_AF_INTF(0..1)_HASH(0..1)_MASK(0..1) */
+	u64 hash_mask[NPC_MAX_INTF][NPC_MAX_HASH][NPC_MAX_HASH_MASK];
+	/* NPC_AF_INTF(0..1)_HASH(0..1)_RESULT_CTRL */
+	u64 hash_ctrl[NPC_MAX_INTF][NPC_MAX_HASH];
+} __packed;
+
+void npc_update_field_hash(struct rvu *rvu, u8 intf,
+			   struct mcam_entry *entry,
+			   int blkaddr,
+			   u64 features,
+			   struct flow_msg *pkt,
+			   struct flow_msg *mask,
+			   struct flow_msg *opkt,
+			   struct flow_msg *omask);
+void npc_config_secret_key(struct rvu *rvu, int blkaddr);
+void npc_program_mkex_hash(struct rvu *rvu, int blkaddr);
+u32 npc_field_hash_calc(u64 *ldata, struct npc_mcam_kex_hash *mkex_hash,
+			u64 *secret_key, u8 intf, u8 hash_idx);
+
+static struct npc_mcam_kex_hash npc_mkex_hash_default __maybe_unused = {
+	.lid_lt_ld_hash_en = {
+	[NIX_INTF_RX] = {
+		[NPC_LID_LC] = {
+			[NPC_LT_LC_IP6] = {
+				true,
+				true,
+			},
+		},
+	},
+
+	[NIX_INTF_TX] = {
+		[NPC_LID_LC] = {
+			[NPC_LT_LC_IP6] = {
+				true,
+				true,
+			},
+		},
+	},
+	},
+
+	.hash = {
+	[NIX_INTF_RX] = {
+		KEX_LD_CFG_HASH(0x8ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
+		KEX_LD_CFG_HASH(0x18ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
+	},
+
+	[NIX_INTF_TX] = {
+		KEX_LD_CFG_HASH(0x8ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
+		KEX_LD_CFG_HASH(0x18ULL, 0xf, 0x1, 0x1, NPC_LID_LC, NPC_LT_LC_IP6, 0xf),
+	},
+	},
+
+	.hash_mask = {
+	[NIX_INTF_RX] = {
+		[0] = {
+			GENMASK_ULL(63, 0),
+			GENMASK_ULL(63, 0),
+		},
+		[1] = {
+			GENMASK_ULL(63, 0),
+			GENMASK_ULL(63, 0),
+		},
+	},
+
+	[NIX_INTF_TX] = {
+		[0] = {
+			GENMASK_ULL(63, 0),
+			GENMASK_ULL(63, 0),
+		},
+		[1] = {
+			GENMASK_ULL(63, 0),
+			GENMASK_ULL(63, 0),
+		},
+	},
+	},
+
+	.hash_ctrl = {
+	[NIX_INTF_RX] = {
+		[0] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
+		[1] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
+	},
+
+	[NIX_INTF_TX] = {
+		[0] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
+		[1] = GENMASK_ULL(63, 32), /* MSB 32 bit is mask and LSB 32 bit is offset. */
+	},
+	},
+};
+
+#endif /* RVU_NPC_HASH_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 22cd751613cd..801cb7d418ba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -565,7 +565,13 @@
 #define NPC_AF_PCK_DEF_OIP4		(0x00620)
 #define NPC_AF_PCK_DEF_OIP6		(0x00630)
 #define NPC_AF_PCK_DEF_IIP4		(0x00640)
+#define NPC_AF_INTFX_HASHX_RESULT_CTRL(a, b)	(0x006c0 | (a) << 4 | (b) << 3)
+#define NPC_AF_INTFX_HASHX_MASKX(a, b, c)  (0x00700 | (a) << 5 | (b) << 4 | (c) << 3)
 #define NPC_AF_KEX_LDATAX_FLAGS_CFG(a)	(0x00800 | (a) << 3)
+#define NPC_AF_INTFX_HASHX_CFG(a, b)  (0x00b00 | (a) << 6 | (b) << 4)
+#define NPC_AF_INTFX_SECRET_KEY0(a)	(0x00e00 | (a) << 3)
+#define NPC_AF_INTFX_SECRET_KEY1(a)	(0x00e20 | (a) << 3)
+#define NPC_AF_INTFX_SECRET_KEY2(a)	(0x00e40 | (a) << 3)
 #define NPC_AF_INTFX_KEX_CFG(a)		(0x01010 | (a) << 8)
 #define NPC_AF_PKINDX_ACTION0(a)	(0x80000ull | (a) << 6)
 #define NPC_AF_PKINDX_ACTION1(a)	(0x80008ull | (a) << 6)
-- 
2.25.1

