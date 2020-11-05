Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AF32A7A79
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 10:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbgKEJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 04:28:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730831AbgKEJ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 04:28:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A59Pwof011418;
        Thu, 5 Nov 2020 01:28:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=klynVtm40od/tU1pVwsS+MxYY4xTDBY9yJGKFQ7Vncg=;
 b=kecY1L+V/yCcwqRH8CeVrEsxohlQZseUONV/h3WTCbTl91nX9/1/WNaSu0DHyuAPMcAG
 MBhCIVYcp54dL4cGT/SgFa7+9VkiGxHcd4EyiYYtFgBkua/XHhmIkvRg4LTND1w5huWm
 gncu60DMMBjveEu+eFVDms8jWkn2cn6imfxF6ctauymzqj0v630YzxFgT0pfmXxVgHRC
 kl1g8NIFRsRfceFkwuTMUYEtBJmtr00l0GAoyUDpmGAhc19raRuTnEwy3Z63UX482I/I
 3R+wI4pfjIR+gZyDGdYhpXCULwQQs9/wa97fAC5Vv38NFCu0tR7AHQhZSWnTEwyeUOhH OA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34mbfcrr7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 01:28:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 Nov
 2020 01:28:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 Nov 2020 01:28:40 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 83FFF3F703F;
        Thu,  5 Nov 2020 01:28:36 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH v2 net-next 03/13] octeontx2-af: Generate key field bit mask from KEX profile
Date:   Thu, 5 Nov 2020 14:58:06 +0530
Message-ID: <20201105092816.819-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201105092816.819-1-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_05:2020-11-05,2020-11-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Key Extraction(KEX) profile decides how the packet metadata such as
layer information and selected packet data bytes at each layer are
placed in MCAM search key. This patch reads the configured KEX profile
parameters to find out the bit position and bit mask for each field.
The information is used when programming the MCAM match data by SW
to match a packet flow and take appropriate action on the flow. This
patch also verifies the mandatory fields such as channel and DMAC
are not overwritten by the KEX configuration of other fields.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  48 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  38 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  11 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 562 +++++++++++++++++++++
 5 files changed, 658 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 2f7a861d0c7b..ffc681b67f1c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
-		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
+		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 91a9d00e4fb5..0fe47216f771 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -140,6 +140,54 @@ enum npc_kpu_lh_ltype {
 	NPC_LT_LH_CUSTOM1 = 0xF,
 };
 
+/* list of known and supported fields in packet header and
+ * fields present in key structure.
+ */
+enum key_fields {
+	NPC_DMAC,
+	NPC_SMAC,
+	NPC_ETYPE,
+	NPC_OUTER_VID,
+	NPC_TOS,
+	NPC_SIP_IPV4,
+	NPC_DIP_IPV4,
+	NPC_SIP_IPV6,
+	NPC_DIP_IPV6,
+	NPC_SPORT_TCP,
+	NPC_DPORT_TCP,
+	NPC_SPORT_UDP,
+	NPC_DPORT_UDP,
+	NPC_SPORT_SCTP,
+	NPC_DPORT_SCTP,
+	NPC_HEADER_FIELDS_MAX,
+	NPC_CHAN = NPC_HEADER_FIELDS_MAX, /* Valid when Rx */
+	NPC_PF_FUNC, /* Valid when Tx */
+	NPC_ERRLEV,
+	NPC_ERRCODE,
+	NPC_LXMB,
+	NPC_LA,
+	NPC_LB,
+	NPC_LC,
+	NPC_LD,
+	NPC_LE,
+	NPC_LF,
+	NPC_LG,
+	NPC_LH,
+	/* ether type for untagged frame */
+	NPC_ETYPE_ETHER,
+	/* ether type for single tagged frame */
+	NPC_ETYPE_TAG1,
+	/* ether type for double tagged frame */
+	NPC_ETYPE_TAG2,
+	/* outer vlan tci for single tagged frame */
+	NPC_VLAN_TAG1,
+	/* outer vlan tci for double tagged frame */
+	NPC_VLAN_TAG2,
+	/* other header fields programmed to extract but not of our interest */
+	NPC_UNKNOWN,
+	NPC_KEY_FIELDS_MAX,
+};
+
 struct npc_kpu_profile_cam {
 	u8 state;
 	u8 state_mask;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 1724dbd18847..7e556c7b6ccf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -15,6 +15,7 @@
 #include "rvu_struct.h"
 #include "common.h"
 #include "mbox.h"
+#include "npc.h"
 
 /* PCI device IDs */
 #define	PCI_DEVID_OCTEONTX2_RVU_AF		0xA065
@@ -105,6 +106,36 @@ struct nix_mce_list {
 	int			max;
 };
 
+/* layer meta data to uniquely identify a packet header field */
+struct npc_layer_mdata {
+	u8 lid;
+	u8 ltype;
+	u8 hdr;
+	u8 key;
+	u8 len;
+};
+
+/* Structure to represent a field present in the
+ * generated key. A key field may present anywhere and can
+ * be of any size in the generated key. Once this structure
+ * is populated for fields of interest then field's presence
+ * and location (if present) can be known.
+ */
+struct npc_key_field {
+	/* Masks where all set bits indicate position
+	 * of a field in the key
+	 */
+	u64 kw_mask[NPC_MAX_KWS_IN_KEY];
+	/* Number of words in the key a field spans. If a field is
+	 * of 16 bytes and key offset is 4 then the field will use
+	 * 4 bytes in KW0, 8 bytes in KW1 and 4 bytes in KW2 and
+	 * nr_kws will be 3(KW0, KW1 and KW2).
+	 */
+	int nr_kws;
+	/* used by packet header fields */
+	struct npc_layer_mdata layer_mdata;
+};
+
 struct npc_mcam {
 	struct rsrc_bmap counters;
 	struct mutex	lock;	/* MCAM entries and counters update lock */
@@ -128,6 +159,11 @@ struct npc_mcam {
 	u16	hprio_count;
 	u16	hprio_end;
 	u16     rx_miss_act_cntr; /* Counter for RX MISS action */
+	/* fields present in the generated key */
+	struct npc_key_field	tx_key_fields[NPC_KEY_FIELDS_MAX];
+	struct npc_key_field	rx_key_fields[NPC_KEY_FIELDS_MAX];
+	u64	tx_features;
+	u64	rx_features;
 };
 
 /* Structure for per RVU func info ie PF/VF */
@@ -537,6 +573,8 @@ bool is_npc_intf_rx(u8 intf);
 bool is_npc_interface_valid(struct rvu *rvu, u8 intf);
 int rvu_npc_get_tx_nibble_cfg(struct rvu *rvu, u64 nibble_ena);
 int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel);
+int npc_flow_steering_init(struct rvu *rvu, int blkaddr);
+const char *npc_get_field_name(u8 hdr);
 
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3666159bb6b6..eb4eaa7ece3a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1400,12 +1400,19 @@ int rvu_npc_init(struct rvu *rvu)
 
 	rvu_npc_setup_interfaces(rvu, blkaddr);
 
+	/* Configure MKEX profile */
+	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
+
 	err = npc_mcam_rsrcs_init(rvu, blkaddr);
 	if (err)
 		return err;
 
-	/* Configure MKEX profile */
-	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
+	err = npc_flow_steering_init(rvu, blkaddr);
+	if (err) {
+		dev_err(rvu->dev,
+			"Incorrect mkex profile loaded using default mkex\n");
+		npc_load_mkex_profile(rvu, blkaddr, def_pfl_name);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
new file mode 100644
index 000000000000..4dae89776422
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#include <linux/bitfield.h>
+
+#include "rvu_struct.h"
+#include "rvu_reg.h"
+#include "rvu.h"
+#include "npc.h"
+
+#define NPC_BYTESM		GENMASK_ULL(19, 16)
+#define NPC_HDR_OFFSET		GENMASK_ULL(15, 8)
+#define NPC_KEY_OFFSET		GENMASK_ULL(5, 0)
+#define NPC_LDATA_EN		BIT_ULL(7)
+
+static const char * const npc_flow_names[] = {
+	[NPC_DMAC]	= "dmac",
+	[NPC_SMAC]	= "smac",
+	[NPC_ETYPE]	= "ether type",
+	[NPC_OUTER_VID]	= "outer vlan id",
+	[NPC_TOS]	= "tos",
+	[NPC_SIP_IPV4]	= "ipv4 source ip",
+	[NPC_DIP_IPV4]	= "ipv4 destination ip",
+	[NPC_SIP_IPV6]	= "ipv6 source ip",
+	[NPC_DIP_IPV6]	= "ipv6 destination ip",
+	[NPC_SPORT_TCP]	= "tcp source port",
+	[NPC_DPORT_TCP]	= "tcp destination port",
+	[NPC_SPORT_UDP]	= "udp source port",
+	[NPC_DPORT_UDP]	= "udp destination port",
+	[NPC_SPORT_SCTP] = "sctp source port",
+	[NPC_DPORT_SCTP] = "sctp destination port",
+	[NPC_UNKNOWN]	= "unknown",
+};
+
+const char *npc_get_field_name(u8 hdr)
+{
+	if (hdr >= ARRAY_SIZE(npc_flow_names))
+		return npc_flow_names[NPC_UNKNOWN];
+
+	return npc_flow_names[hdr];
+}
+
+/* Compute keyword masks and figure out the number of keywords a field
+ * spans in the key.
+ */
+static void npc_set_kw_masks(struct npc_mcam *mcam, u8 type,
+			     u8 nr_bits, int start_kwi, int offset, u8 intf)
+{
+	struct npc_key_field *field = &mcam->rx_key_fields[type];
+	u8 bits_in_kw;
+	int max_kwi;
+
+	if (mcam->banks_per_entry == 1)
+		max_kwi = 1; /* NPC_MCAM_KEY_X1 */
+	else if (mcam->banks_per_entry == 2)
+		max_kwi = 3; /* NPC_MCAM_KEY_X2 */
+	else
+		max_kwi = 6; /* NPC_MCAM_KEY_X4 */
+
+	if (is_npc_intf_tx(intf))
+		field = &mcam->tx_key_fields[type];
+
+	if (offset + nr_bits <= 64) {
+		/* one KW only */
+		if (start_kwi > max_kwi)
+			return;
+		field->kw_mask[start_kwi] |= GENMASK_ULL(nr_bits - 1, 0)
+					     << offset;
+		field->nr_kws = 1;
+	} else if (offset + nr_bits > 64 &&
+		   offset + nr_bits <= 128) {
+		/* two KWs */
+		if (start_kwi + 1 > max_kwi)
+			return;
+		/* first KW mask */
+		bits_in_kw = 64 - offset;
+		field->kw_mask[start_kwi] |= GENMASK_ULL(bits_in_kw - 1, 0)
+					     << offset;
+		/* second KW mask i.e. mask for rest of bits */
+		bits_in_kw = nr_bits + offset - 64;
+		field->kw_mask[start_kwi + 1] |= GENMASK_ULL(bits_in_kw - 1, 0);
+		field->nr_kws = 2;
+	} else {
+		/* three KWs */
+		if (start_kwi + 2 > max_kwi)
+			return;
+		/* first KW mask */
+		bits_in_kw = 64 - offset;
+		field->kw_mask[start_kwi] |= GENMASK_ULL(bits_in_kw - 1, 0)
+					     << offset;
+		/* second KW mask */
+		field->kw_mask[start_kwi + 1] = ~0ULL;
+		/* third KW mask i.e. mask for rest of bits */
+		bits_in_kw = nr_bits + offset - 128;
+		field->kw_mask[start_kwi + 2] |= GENMASK_ULL(bits_in_kw - 1, 0);
+		field->nr_kws = 3;
+	}
+}
+
+/* Helper function to figure out whether field exists in the key */
+static bool npc_is_field_present(struct rvu *rvu, enum key_fields type, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct npc_key_field *input;
+
+	input  = &mcam->rx_key_fields[type];
+	if (is_npc_intf_tx(intf))
+		input  = &mcam->tx_key_fields[type];
+
+	return input->nr_kws > 0;
+}
+
+static bool npc_is_same(struct npc_key_field *input,
+			struct npc_key_field *field)
+{
+	int ret;
+
+	ret = memcmp(&input->layer_mdata, &field->layer_mdata,
+		     sizeof(struct npc_layer_mdata));
+	return ret == 0;
+}
+
+static void npc_set_layer_mdata(struct npc_mcam *mcam, enum key_fields type,
+				u64 cfg, u8 lid, u8 lt, u8 intf)
+{
+	struct npc_key_field *input = &mcam->rx_key_fields[type];
+
+	if (is_npc_intf_tx(intf))
+		input = &mcam->tx_key_fields[type];
+
+	input->layer_mdata.hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
+	input->layer_mdata.key = FIELD_GET(NPC_KEY_OFFSET, cfg);
+	input->layer_mdata.len = FIELD_GET(NPC_BYTESM, cfg) + 1;
+	input->layer_mdata.ltype = lt;
+	input->layer_mdata.lid = lid;
+}
+
+static bool npc_check_overlap_fields(struct npc_key_field *input1,
+				     struct npc_key_field *input2)
+{
+	int kwi;
+
+	/* Fields with same layer id and different ltypes are mutually
+	 * exclusive hence they can be overlapped
+	 */
+	if (input1->layer_mdata.lid == input2->layer_mdata.lid &&
+	    input1->layer_mdata.ltype != input2->layer_mdata.ltype)
+		return false;
+
+	for (kwi = 0; kwi < NPC_MAX_KWS_IN_KEY; kwi++) {
+		if (input1->kw_mask[kwi] & input2->kw_mask[kwi])
+			return true;
+	}
+
+	return false;
+}
+
+/* Helper function to check whether given field overlaps with any other fields
+ * in the key. Due to limitations on key size and the key extraction profile in
+ * use higher layers can overwrite lower layer's header fields. Hence overlap
+ * needs to be checked.
+ */
+static bool npc_check_overlap(struct rvu *rvu, int blkaddr,
+			      enum key_fields type, u8 start_lid, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct npc_key_field *dummy, *input;
+	int start_kwi, offset;
+	u8 nr_bits, lid, lt, ld;
+	u64 cfg;
+
+	dummy = &mcam->rx_key_fields[NPC_UNKNOWN];
+	input = &mcam->rx_key_fields[type];
+
+	if (is_npc_intf_tx(intf)) {
+		dummy = &mcam->tx_key_fields[NPC_UNKNOWN];
+		input = &mcam->tx_key_fields[type];
+	}
+
+	for (lid = start_lid; lid < NPC_MAX_LID; lid++) {
+		for (lt = 0; lt < NPC_MAX_LT; lt++) {
+			for (ld = 0; ld < NPC_MAX_LD; ld++) {
+				cfg = rvu_read64(rvu, blkaddr,
+						 NPC_AF_INTFX_LIDX_LTX_LDX_CFG
+						 (intf, lid, lt, ld));
+				if (!FIELD_GET(NPC_LDATA_EN, cfg))
+					continue;
+				memset(dummy, 0, sizeof(struct npc_key_field));
+				npc_set_layer_mdata(mcam, NPC_UNKNOWN, cfg,
+						    lid, lt, intf);
+				/* exclude input */
+				if (npc_is_same(input, dummy))
+					continue;
+				start_kwi = dummy->layer_mdata.key / 8;
+				offset = (dummy->layer_mdata.key * 8) % 64;
+				nr_bits = dummy->layer_mdata.len * 8;
+				/* form KW masks */
+				npc_set_kw_masks(mcam, NPC_UNKNOWN, nr_bits,
+						 start_kwi, offset, intf);
+				/* check any input field bits falls in any
+				 * other field bits.
+				 */
+				if (npc_check_overlap_fields(dummy, input))
+					return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static int npc_check_field(struct rvu *rvu, int blkaddr, enum key_fields type,
+			   u8 intf)
+{
+	if (!npc_is_field_present(rvu, type, intf) ||
+	    npc_check_overlap(rvu, blkaddr, type, 0, intf))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
+				  u8 key_nibble, u8 intf)
+{
+	u8 offset = (key_nibble * 4) % 64; /* offset within key word */
+	u8 kwi = (key_nibble * 4) / 64; /* which word in key */
+	u8 nr_bits = 4; /* bits in a nibble */
+	u8 type;
+
+	switch (bit_number) {
+	case 0 ... 2:
+		type = NPC_CHAN;
+		break;
+	case 3:
+		type = NPC_ERRLEV;
+		break;
+	case 4 ... 5:
+		type = NPC_ERRCODE;
+		break;
+	case 6:
+		type = NPC_LXMB;
+		break;
+	/* check for LTYPE only as of now */
+	case 9:
+		type = NPC_LA;
+		break;
+	case 12:
+		type = NPC_LB;
+		break;
+	case 15:
+		type = NPC_LC;
+		break;
+	case 18:
+		type = NPC_LD;
+		break;
+	case 21:
+		type = NPC_LE;
+		break;
+	case 24:
+		type = NPC_LF;
+		break;
+	case 27:
+		type = NPC_LG;
+		break;
+	case 30:
+		type = NPC_LH;
+		break;
+	default:
+		return;
+	};
+	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
+}
+
+static void npc_handle_multi_layer_fields(struct rvu *rvu, int blkaddr, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct npc_key_field *key_fields;
+	/* Ether type can come from three layers
+	 * (ethernet, single tagged, double tagged)
+	 */
+	struct npc_key_field *etype_ether;
+	struct npc_key_field *etype_tag1;
+	struct npc_key_field *etype_tag2;
+	/* Outer VLAN TCI can come from two layers
+	 * (single tagged, double tagged)
+	 */
+	struct npc_key_field *vlan_tag1;
+	struct npc_key_field *vlan_tag2;
+	u64 *features;
+	u8 start_lid;
+	int i;
+
+	key_fields = mcam->rx_key_fields;
+	features = &mcam->rx_features;
+
+	if (is_npc_intf_tx(intf)) {
+		key_fields = mcam->tx_key_fields;
+		features = &mcam->tx_features;
+	}
+
+	/* Handle header fields which can come from multiple layers like
+	 * etype, outer vlan tci. These fields should have same position in
+	 * the key otherwise to install a mcam rule more than one entry is
+	 * needed which complicates mcam space management.
+	 */
+	etype_ether = &key_fields[NPC_ETYPE_ETHER];
+	etype_tag1 = &key_fields[NPC_ETYPE_TAG1];
+	etype_tag2 = &key_fields[NPC_ETYPE_TAG2];
+	vlan_tag1 = &key_fields[NPC_VLAN_TAG1];
+	vlan_tag2 = &key_fields[NPC_VLAN_TAG2];
+
+	/* if key profile programmed does not extract ether type at all */
+	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
+		goto vlan_tci;
+
+	/* if key profile programmed extracts ether type from one layer */
+	if (etype_ether->nr_kws && !etype_tag1->nr_kws && !etype_tag2->nr_kws)
+		key_fields[NPC_ETYPE] = *etype_ether;
+	if (!etype_ether->nr_kws && etype_tag1->nr_kws && !etype_tag2->nr_kws)
+		key_fields[NPC_ETYPE] = *etype_tag1;
+	if (!etype_ether->nr_kws && !etype_tag1->nr_kws && etype_tag2->nr_kws)
+		key_fields[NPC_ETYPE] = *etype_tag2;
+
+	/* if key profile programmed extracts ether type from multiple layers */
+	if (etype_ether->nr_kws && etype_tag1->nr_kws) {
+		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+			if (etype_ether->kw_mask[i] != etype_tag1->kw_mask[i])
+				goto vlan_tci;
+		}
+		key_fields[NPC_ETYPE] = *etype_tag1;
+	}
+	if (etype_ether->nr_kws && etype_tag2->nr_kws) {
+		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+			if (etype_ether->kw_mask[i] != etype_tag2->kw_mask[i])
+				goto vlan_tci;
+		}
+		key_fields[NPC_ETYPE] = *etype_tag2;
+	}
+	if (etype_tag1->nr_kws && etype_tag2->nr_kws) {
+		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+			if (etype_tag1->kw_mask[i] != etype_tag2->kw_mask[i])
+				goto vlan_tci;
+		}
+		key_fields[NPC_ETYPE] = *etype_tag2;
+	}
+
+	/* check none of higher layers overwrite ether type */
+	start_lid = key_fields[NPC_ETYPE].layer_mdata.lid + 1;
+	if (npc_check_overlap(rvu, blkaddr, NPC_ETYPE, start_lid, intf))
+		goto vlan_tci;
+	*features |= BIT_ULL(NPC_ETYPE);
+vlan_tci:
+	/* if key profile does not extract outer vlan tci at all */
+	if (!vlan_tag1->nr_kws && !vlan_tag2->nr_kws)
+		goto done;
+
+	/* if key profile extracts outer vlan tci from one layer */
+	if (vlan_tag1->nr_kws && !vlan_tag2->nr_kws)
+		key_fields[NPC_OUTER_VID] = *vlan_tag1;
+	if (!vlan_tag1->nr_kws && vlan_tag2->nr_kws)
+		key_fields[NPC_OUTER_VID] = *vlan_tag2;
+
+	/* if key profile extracts outer vlan tci from multiple layers */
+	if (vlan_tag1->nr_kws && vlan_tag2->nr_kws) {
+		for (i = 0; i < NPC_MAX_KWS_IN_KEY; i++) {
+			if (vlan_tag1->kw_mask[i] != vlan_tag2->kw_mask[i])
+				goto done;
+		}
+		key_fields[NPC_OUTER_VID] = *vlan_tag2;
+	}
+	/* check none of higher layers overwrite outer vlan tci */
+	start_lid = key_fields[NPC_OUTER_VID].layer_mdata.lid + 1;
+	if (npc_check_overlap(rvu, blkaddr, NPC_OUTER_VID, start_lid, intf))
+		goto done;
+	*features |= BIT_ULL(NPC_OUTER_VID);
+done:
+	return;
+}
+
+static void npc_scan_ldata(struct rvu *rvu, int blkaddr, u8 lid,
+			   u8 lt, u64 cfg, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u8 hdr, key, nr_bytes, bit_offset;
+	u8 la_ltype, la_start;
+	/* starting KW index and starting bit position */
+	int start_kwi, offset;
+
+	nr_bytes = FIELD_GET(NPC_BYTESM, cfg) + 1;
+	hdr = FIELD_GET(NPC_HDR_OFFSET, cfg);
+	key = FIELD_GET(NPC_KEY_OFFSET, cfg);
+	start_kwi = key / 8;
+	offset = (key * 8) % 64;
+
+	/* For Tx, Layer A has NIX_INST_HDR_S(64 bytes) preceding
+	 * ethernet header.
+	 */
+	if (is_npc_intf_tx(intf)) {
+		la_ltype = NPC_LT_LA_IH_NIX_ETHER;
+		la_start = 8;
+	} else {
+		la_ltype = NPC_LT_LA_ETHER;
+		la_start = 0;
+	}
+
+#define NPC_SCAN_HDR(name, hlid, hlt, hstart, hlen)			       \
+do {									       \
+	if (lid == (hlid) && lt == (hlt)) {				       \
+		if ((hstart) >= hdr &&					       \
+		    ((hstart) + (hlen)) <= (hdr + nr_bytes)) {	               \
+			bit_offset = (hdr + nr_bytes - (hstart) - (hlen)) * 8; \
+			npc_set_layer_mdata(mcam, (name), cfg, lid, lt, intf); \
+			npc_set_kw_masks(mcam, (name), (hlen) * 8,	       \
+					 start_kwi, offset + bit_offset, intf);\
+		}							       \
+	}								       \
+} while (0)
+
+	/* List LID, LTYPE, start offset from layer and length(in bytes) of
+	 * packet header fields below.
+	 * Example: Source IP is 4 bytes and starts at 12th byte of IP header
+	 */
+	NPC_SCAN_HDR(NPC_SIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 12, 4);
+	NPC_SCAN_HDR(NPC_DIP_IPV4, NPC_LID_LC, NPC_LT_LC_IP, 16, 4);
+	NPC_SCAN_HDR(NPC_SIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 8, 16);
+	NPC_SCAN_HDR(NPC_DIP_IPV6, NPC_LID_LC, NPC_LT_LC_IP6, 24, 16);
+	NPC_SCAN_HDR(NPC_SPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 0, 2);
+	NPC_SCAN_HDR(NPC_DPORT_UDP, NPC_LID_LD, NPC_LT_LD_UDP, 2, 2);
+	NPC_SCAN_HDR(NPC_SPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 0, 2);
+	NPC_SCAN_HDR(NPC_DPORT_TCP, NPC_LID_LD, NPC_LT_LD_TCP, 2, 2);
+	NPC_SCAN_HDR(NPC_SPORT_SCTP, NPC_LID_LD, NPC_LT_LD_SCTP, 0, 2);
+	NPC_SCAN_HDR(NPC_DPORT_SCTP, NPC_LID_LD, NPC_LT_LD_SCTP, 2, 2);
+	NPC_SCAN_HDR(NPC_ETYPE_ETHER, NPC_LID_LA, NPC_LT_LA_ETHER, 12, 2);
+	NPC_SCAN_HDR(NPC_ETYPE_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 4, 2);
+	NPC_SCAN_HDR(NPC_ETYPE_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 8, 2);
+	NPC_SCAN_HDR(NPC_VLAN_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 2, 2);
+	NPC_SCAN_HDR(NPC_VLAN_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 2, 2);
+	NPC_SCAN_HDR(NPC_DMAC, NPC_LID_LA, la_ltype, la_start, 6);
+	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start, 6);
+	/* PF_FUNC is 2 bytes at 0th byte of NPC_LT_LA_IH_NIX_ETHER */
+	NPC_SCAN_HDR(NPC_PF_FUNC, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 0, 2);
+}
+
+static void npc_set_features(struct rvu *rvu, int blkaddr, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u64 *features = &mcam->rx_features;
+	u64 tcp_udp_sctp;
+	int err, hdr;
+
+	if (is_npc_intf_tx(intf))
+		features = &mcam->tx_features;
+
+	for (hdr = NPC_DMAC; hdr < NPC_HEADER_FIELDS_MAX; hdr++) {
+		err = npc_check_field(rvu, blkaddr, hdr, intf);
+		if (!err)
+			*features |= BIT_ULL(hdr);
+	}
+
+	tcp_udp_sctp = BIT_ULL(NPC_SPORT_TCP) | BIT_ULL(NPC_SPORT_UDP) |
+		       BIT_ULL(NPC_DPORT_TCP) | BIT_ULL(NPC_DPORT_UDP) |
+		       BIT_ULL(NPC_SPORT_SCTP) | BIT_ULL(NPC_DPORT_SCTP);
+
+	/* for tcp/udp/sctp corresponding layer type should be in the key */
+	if (*features & tcp_udp_sctp)
+		if (npc_check_field(rvu, blkaddr, NPC_LD, intf))
+			*features &= ~tcp_udp_sctp;
+
+	/* for vlan corresponding layer type should be in the key */
+	if (*features & BIT_ULL(NPC_OUTER_VID))
+		if (npc_check_field(rvu, blkaddr, NPC_LB, intf))
+			*features &= ~BIT_ULL(NPC_OUTER_VID);
+}
+
+/* Scan key extraction profile and record how fields of our interest
+ * fill the key structure. Also verify Channel and DMAC exists in
+ * key and not overwritten by other header fields.
+ */
+static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	u8 lid, lt, ld, bitnr;
+	u8 key_nibble = 0;
+	u64 cfg;
+
+	/* Scan and note how parse result is going to be in key.
+	 * A bit set in PARSE_NIBBLE_ENA corresponds to a nibble from
+	 * parse result in the key. The enabled nibbles from parse result
+	 * will be concatenated in key.
+	 */
+	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(intf));
+	cfg &= NPC_PARSE_NIBBLE;
+	for_each_set_bit(bitnr, (unsigned long *)&cfg, 31) {
+		npc_scan_parse_result(mcam, bitnr, key_nibble, intf);
+		key_nibble++;
+	}
+
+	/* Scan and note how layer data is going to be in key */
+	for (lid = 0; lid < NPC_MAX_LID; lid++) {
+		for (lt = 0; lt < NPC_MAX_LT; lt++) {
+			for (ld = 0; ld < NPC_MAX_LD; ld++) {
+				cfg = rvu_read64(rvu, blkaddr,
+						 NPC_AF_INTFX_LIDX_LTX_LDX_CFG
+						 (intf, lid, lt, ld));
+				if (!FIELD_GET(NPC_LDATA_EN, cfg))
+					continue;
+				npc_scan_ldata(rvu, blkaddr, lid, lt, cfg,
+					       intf);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int npc_scan_verify_kex(struct rvu *rvu, int blkaddr)
+{
+	int err;
+
+	err = npc_scan_kex(rvu, blkaddr, NIX_INTF_RX);
+	if (err)
+		return err;
+
+	err = npc_scan_kex(rvu, blkaddr, NIX_INTF_TX);
+	if (err)
+		return err;
+
+	/* Channel is mandatory */
+	if (!npc_is_field_present(rvu, NPC_CHAN, NIX_INTF_RX)) {
+		dev_err(rvu->dev, "Channel not present in Key\n");
+		return -EINVAL;
+	}
+	/* check that none of the fields overwrite channel */
+	if (npc_check_overlap(rvu, blkaddr, NPC_CHAN, 0, NIX_INTF_RX)) {
+		dev_err(rvu->dev, "Channel cannot be overwritten\n");
+		return -EINVAL;
+	}
+	/* DMAC should be present in key for unicast filter to work */
+	if (!npc_is_field_present(rvu, NPC_DMAC, NIX_INTF_RX)) {
+		dev_err(rvu->dev, "DMAC not present in Key\n");
+		return -EINVAL;
+	}
+	/* check that none of the fields overwrite DMAC */
+	if (npc_check_overlap(rvu, blkaddr, NPC_DMAC, 0, NIX_INTF_RX)) {
+		dev_err(rvu->dev, "DMAC cannot be overwritten\n");
+		return -EINVAL;
+	}
+
+	npc_set_features(rvu, blkaddr, NIX_INTF_TX);
+	npc_set_features(rvu, blkaddr, NIX_INTF_RX);
+	npc_handle_multi_layer_fields(rvu, blkaddr, NIX_INTF_TX);
+	npc_handle_multi_layer_fields(rvu, blkaddr, NIX_INTF_RX);
+
+	return 0;
+}
+
+int npc_flow_steering_init(struct rvu *rvu, int blkaddr)
+{
+	return npc_scan_verify_kex(rvu, blkaddr);
+}
-- 
2.16.5

