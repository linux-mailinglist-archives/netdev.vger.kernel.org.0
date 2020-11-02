Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26DA2A2496
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgKBGNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:13:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgKBGNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:13:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A262Eqw018795;
        Sun, 1 Nov 2020 22:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=LSz3p3EqK+1i0ShULTRaMPIZBSf9k/AdY3B2V2m1D0E=;
 b=PMr0zMwWWRyfmzA9yYOw/4NMGQagWpXK71tr196WOrN5WU9woT2zR99jlQzS/yn6+lwc
 Urlt0fczHCEiXUwCp35nvSPGmXx+rJn9xqe32KPFer7SS8Cxt1oa+dsgKU0ozUeobtK+
 DZdGkvq6oXhVCq/trc+E5WG5f5A2s7ElpVaXoozOZ36r/WQlrXDB8nMV0ZwxO732s4vk
 EthcQGEc9zoylME9qs+aVmuVm1wdO37OScjxHg/bjtqu2ChtAR0E33n50H1jipwq98zf
 6QJIu4ToC0r1Qq3OfT2qliGM9rSZ9KBg0OrqcCvrzziE0AIoaPcN/QAKOb5V1LhBU6Yz iw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7enp50g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 22:13:06 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 22:13:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 22:13:04 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id E72353F7040;
        Sun,  1 Nov 2020 22:12:57 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Stanislaw Kardach <skardach@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH net-next 01/13] octeontx2-af: Modify default KEX profile to extract TX packet fields
Date:   Mon, 2 Nov 2020 11:41:10 +0530
Message-ID: <20201102061122.8915-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201102061122.8915-1-naveenm@marvell.com>
References: <20201102061122.8915-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

The current default Key Extraction(KEX) profile can only use RX
packet fields while generating the MCAM search key. The profile
can't be used for matching TX packet fields. This patch modifies
the default KEX profile to add support for extracting TX packet
fields into MCAM search key. Enabled Tx KPU packet parsing by
configuring TX PKIND in tx_parse_cfg.

Also modified the default KEX profile to extract VLAN TCI from
the LB_PTR and exact byte offset of VLAN header. The NPC KPU
parser was modified to point LB_PTR to the starting byte offset
of VLAN header which points to the tpid field.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 71 ++++++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  6 ++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 199448610e3e..c5b13385c81d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13386,8 +13386,8 @@ static struct npc_mcam_kex npc_mkex_default = {
 	.kpu_version = NPC_KPU_PROFILE_VER,
 	.keyx_cfg = {
 		/* nibble: LA..LE (ltype only) + Channel */
-		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x49247,
-		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | ((1ULL << 19) - 1),
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x249207,
+		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | 0x249200,
 	},
 	.intf_lid_lt_ld = {
 	/* Default RX MCAM KEX profile */
@@ -13405,12 +13405,14 @@ static struct npc_mcam_kex npc_mkex_default = {
 			/* Layer B: Single VLAN (CTAG) */
 			/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
 			[NPC_LT_LB_CTAG] = {
-				KEX_LD_CFG(0x03, 0x0, 0x1, 0x0, 0x4),
+				KEX_LD_CFG(0x03, 0x2, 0x1, 0x0, 0x4),
 			},
 			/* Layer B: Stacked VLAN (STAG|QinQ) */
 			[NPC_LT_LB_STAG_QINQ] = {
-				/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
-				KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Ethertype: 2 bytes, KW0[47:32] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x4),
 			},
 			[NPC_LT_LB_FDSA] = {
 				/* SWITCH PORT: 1 byte, KW0[63:48] */
@@ -13450,6 +13452,65 @@ static struct npc_mcam_kex npc_mkex_default = {
 			},
 		},
 	},
+
+	/* Default TX MCAM KEX profile */
+	[NIX_INTF_TX] = {
+		[NPC_LID_LA] = {
+			/* Layer A: Ethernet: */
+			[NPC_LT_LA_IH_NIX_ETHER] = {
+				/* PF_FUNC: 2B , KW0 [47:32] */
+				KEX_LD_CFG(0x01, 0x0, 0x1, 0x0, 0x4),
+				/* DMAC: 6 bytes, KW1[63:16] */
+				KEX_LD_CFG(0x05, 0x8, 0x1, 0x0, 0xa),
+			},
+		},
+		[NPC_LID_LB] = {
+			/* Layer B: Single VLAN (CTAG) */
+			[NPC_LT_LB_CTAG] = {
+				/* CTAG VLAN[2..3] KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* CTAG VLAN[2..3] KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x8),
+			},
+			/* Layer B: Stacked VLAN (STAG|QinQ) */
+			[NPC_LT_LB_STAG_QINQ] = {
+				/* Outer VLAN: 2 bytes, KW0[63:48] */
+				KEX_LD_CFG(0x01, 0x2, 0x1, 0x0, 0x6),
+				/* Outer VLAN: 2 Bytes, KW1[15:0] */
+				KEX_LD_CFG(0x01, 0x8, 0x1, 0x0, 0x8),
+			},
+		},
+		[NPC_LID_LC] = {
+			/* Layer C: IPv4 */
+			[NPC_LT_LC_IP] = {
+				/* SIP+DIP: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
+				/* TOS: 1 byte, KW1[63:56] */
+				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
+			},
+			/* Layer C: IPv6 */
+			[NPC_LT_LC_IP6] = {
+				/* Everything up to SADDR: 8 bytes, KW2[63:0] */
+				KEX_LD_CFG(0x07, 0x0, 0x1, 0x0, 0x10),
+			},
+		},
+		[NPC_LID_LD] = {
+			/* Layer D:UDP */
+			[NPC_LT_LD_UDP] = {
+				/* SPORT: 2 bytes, KW3[15:0] */
+				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
+				/* DPORT: 2 bytes, KW3[31:16] */
+				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+			},
+			/* Layer D:TCP */
+			[NPC_LT_LD_TCP] = {
+				/* SPORT: 2 bytes, KW3[15:0] */
+				KEX_LD_CFG(0x1, 0x0, 0x1, 0x0, 0x18),
+				/* DPORT: 2 bytes, KW3[31:16] */
+				KEX_LD_CFG(0x1, 0x2, 0x1, 0x0, 0x1a),
+			},
+		},
+	},
 	},
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8bac1dd3a1c2..8c11abdbd9d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -57,6 +57,8 @@ enum nix_makr_fmt_indexes {
 	NIX_MARK_CFG_MAX,
 };
 
+#define NIX_TX_PKIND	63ULL
+
 /* For now considering MC resources needed for broadcast
  * pkt replication only. i.e 256 HWVFs + 12 PFs.
  */
@@ -1182,6 +1184,10 @@ int rvu_mbox_handler_nix_lf_alloc(struct rvu *rvu,
 	/* Config Rx pkt length, csum checks and apad  enable / disable */
 	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_CFG(nixlf), req->rx_cfg);
 
+	/* Configure pkind for TX parse config, 63 from npc_profile */
+	cfg = NIX_TX_PKIND;
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_PARSE_CFG(nixlf), cfg);
+
 	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
 	err = nix_interface_init(rvu, pcifunc, intf, nixlf);
 	if (err)
-- 
2.16.5

