Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AA933F145
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhCQNg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9614 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231310AbhCQNf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:35:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQIIU006940;
        Wed, 17 Mar 2021 06:35:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DxLb9p1aH7dGjPrhnzRKJEURQlerR+PDA52oyHbYY4Q=;
 b=UvG1m8dGq+kiRn/wJfmrP/7a3+/GbbxuB6XDkEH9ichQMMMODThBfobQTSb3sDuTTAab
 Wf8uuEBE+MmF7OtlUGXVTnxHqwzSirjQRbx4UINiMjF/0NdgXPkkr7kvyP/JBxReR/tr
 k3RbXMN59fKo+t0kWPgqHItPXeOFSgUaa8FGjJZWN83lQ9MwAljk9/UoWBa4+Jd12Y2J
 2QmnjKcPef3CTXEyQe5v9BA0bpXtFYeWadczV3wDeWUFzK60FHj8FDCSt7wCp0cgZeF6
 q5bOIps14sQsMHmuy8C9fMP+O37OwZi9syd5MheU5bvf+fVwc0eeRzzPRTD8X+gug8ic Cg== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:35:54 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:35:53 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:35:53 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id A944C3F7041;
        Wed, 17 Mar 2021 06:35:49 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Nalla, Pradeep" <pnalla@marvell.com>,
        Nalla@mx0b-0016f401.pphosted.com,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH net-next 2/5] octeontx2-af: Add support for multi channel in NIX promisc entry
Date:   Wed, 17 Mar 2021 19:05:35 +0530
Message-ID: <20210317133538.15609-3-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210317133538.15609-1-naveenm@marvell.com>
References: <20210317133538.15609-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nalla, Pradeep" <pnalla@marvell.com>

This patch adds support for multi channel NIX promisc entry. Packets sent
on all those channels by the host should be received by the interface to
which those channels belong. Channel count, if greater than 1, should be
power of 2 as only one promisc entry is available for the interface. Key
mask is modified such that incoming packets from channel base to channel
count are directed to the same pci function.

Signed-off-by: Nalla, Pradeep <pnalla@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h     |  3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c |  6 ++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 14 +++++++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e6517a697de7..baaba01bd8c5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -646,7 +646,8 @@ int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en);
 void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr);
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
-				   int nixlf, u64 chan, bool allmulti);
+				   int nixlf, u64 chan, u8 chan_cnt,
+				   bool allmulti);
 void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d3000194e2d3..f2a1c4235f74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -273,7 +273,8 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
-					      pfvf->rx_chan_base, false);
+					      pfvf->rx_chan_base,
+					      pfvf->rx_chan_cnt, false);
 		break;
 	}
 
@@ -3088,7 +3089,8 @@ int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 		rvu_npc_disable_promisc_entry(rvu, pcifunc, nixlf);
 	else
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
-					      pfvf->rx_chan_base, allmulti);
+					      pfvf->rx_chan_base,
+					      pfvf->rx_chan_cnt, allmulti);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 80b90a48df4f..73b430ce52d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -647,13 +647,15 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 }
 
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
-				   int nixlf, u64 chan, bool allmulti)
+				   int nixlf, u64 chan, u8 chan_cnt,
+				   bool allmulti)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, ucast_idx, index, kwi;
 	struct mcam_entry entry = { {0} };
 	struct nix_rx_action action = { };
+	u64 relaxed_mask;
 
 	/* Only PF or AF VF can add a promiscuous entry */
 	if ((pcifunc & RVU_PFVF_FUNC_MASK) && !is_afvf(pcifunc))
@@ -669,6 +671,16 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	entry.kw[0] = chan;
 	entry.kw_mask[0] = 0xFFFULL;
 
+	if (chan_cnt > 1) {
+		if (!is_power_of_2(chan_cnt)) {
+			dev_err(rvu->dev, "channel count more than 1, must be power of 2\n");
+			return;
+		}
+		relaxed_mask = GENMASK_ULL(BITS_PER_LONG_LONG - 1,
+					   ilog2(chan_cnt));
+		entry.kw_mask[0] &= relaxed_mask;
+	}
+
 	if (allmulti) {
 		kwi = NPC_KEXOF_DMAC / sizeof(u64);
 		entry.kw[kwi] = BIT_ULL(40); /* LSB bit of 1st byte in DMAC */
-- 
2.16.5

