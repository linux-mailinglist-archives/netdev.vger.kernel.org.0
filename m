Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F4E3D4C9A
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 09:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGYHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:18:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230187AbhGYHSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 03:18:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16P7rwoc014665;
        Sun, 25 Jul 2021 00:58:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=3GJLpFeQ46EDsvZkAlQBxzDQUQE952D0XwGT8Nz6lpo=;
 b=fcvTrrn4gs7z+06ydKodF/JOjw/XhNUzO1tqya6NV6UZ9h8qH0paczggek/TacHifxSg
 HAZoKvt9YUcNvW0D4eWgyiaH4MHR9a7satQbmb0QIjDULNyeJmxSJtwlgCnO+tPm6o6T
 n9ZiJF3/surjen8CJ57wUaZmfFzC7kQzV+HnVlxiFWP8IZc9p6okrl3258Y7WteUqz2t
 DIy6cVaR0cmM1LWB5ziq1PrfB1F/IvX+WUvMhSVhZOaryVaa0oYYBcrVtDLB1HreVqpZ
 ij0HqfNnsCJHC/xJIvIK5oOz83lpuTfc1dFZ7ZgtqKjnHjJqzKpokryOJxDnBgGuLON+ rQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a0g7r25rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Jul 2021 00:58:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 25 Jul
 2021 00:58:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 25 Jul 2021 00:58:28 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 65FD93F70A4;
        Sun, 25 Jul 2021 00:58:25 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <zyta@marvell.com>,
        <richardcochran@gmail.com>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix PKIND overlap between LBK and LMAC interfaces
Date:   Sun, 25 Jul 2021 13:28:24 +0530
Message-ID: <20210725075824.6378-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: NIfQU7zysuMWgZHTF8AFu6BSC3MVt0Jz
X-Proofpoint-ORIG-GUID: NIfQU7zysuMWgZHTF8AFu6BSC3MVt0Jz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_02:2021-07-23,2021-07-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PKINDs are not assigned to LBK channels.
The default value of LBK_CHX_PKIND (channel to PKIND mapping) register
is zero, which is resulting in a overlap of pkind between LBK and CGX
LMACs. When KPU1 parser config is modified when PTP timestamping is
enabled on the CGX LMAC interface it is impacting traffic on LBK
interfaces as well.

This patch fixes the issue by reserving the PKIND#0 for LBK devices.
CGX mapped PF pkind starts from 1 and also fixes the max pkind available.

Fixes: 421572175ba5 ("octeontx2-af: Support to enable/disable HW timestamping")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h     |  3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 11 +++++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 19bad9a59c8f..243cf8070e77 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -151,7 +151,10 @@ enum npc_kpu_lh_ltype {
  * Software assigns pkind for each incoming port such as CGX
  * Ethernet interfaces, LBK interfaces, etc.
  */
+#define NPC_UNRESERVED_PKIND_COUNT NPC_RX_VLAN_EXDSA_PKIND
+
 enum npc_pkind_type {
+	NPC_RX_LBK_PKIND = 0ULL,
 	NPC_RX_VLAN_EXDSA_PKIND = 56ULL,
 	NPC_RX_CHLEN24B_PKIND = 57ULL,
 	NPC_RX_CPT_HDR_PKIND,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0d2cd5169018..30067668eda7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -298,6 +298,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 					rvu_nix_chan_lbk(rvu, lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
+		rvu_npc_set_pkind(rvu, NPC_RX_LBK_PKIND, pfvf);
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
 					      pfvf->rx_chan_cnt);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 1097291aaa45..52b255426c22 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1721,7 +1721,6 @@ static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	int num_pkinds, num_kpus, idx;
-	struct npc_pkind *pkind;
 
 	/* Disable all KPUs and their entries */
 	for (idx = 0; idx < hw->npc_kpus; idx++) {
@@ -1739,9 +1738,8 @@ static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 	 * Check HW max count to avoid configuring junk or
 	 * writing to unsupported CSR addresses.
 	 */
-	pkind = &hw->pkind;
 	num_pkinds = rvu->kpu.pkinds;
-	num_pkinds = min_t(int, pkind->rsrc.max, num_pkinds);
+	num_pkinds = min_t(int, hw->npc_pkinds, num_pkinds);
 
 	for (idx = 0; idx < num_pkinds; idx++)
 		npc_config_kpuaction(rvu, blkaddr, &rvu->kpu.ikpu[idx], 0, idx, true);
@@ -1891,7 +1889,8 @@ static void rvu_npc_hw_init(struct rvu *rvu, int blkaddr)
 	if (npc_const1 & BIT_ULL(63))
 		npc_const2 = rvu_read64(rvu, blkaddr, NPC_AF_CONST2);
 
-	pkind->rsrc.max = (npc_const1 >> 12) & 0xFFULL;
+	pkind->rsrc.max = NPC_UNRESERVED_PKIND_COUNT;
+	hw->npc_pkinds = (npc_const1 >> 12) & 0xFFULL;
 	hw->npc_kpu_entries = npc_const1 & 0xFFFULL;
 	hw->npc_kpus = (npc_const >> 8) & 0x1FULL;
 	hw->npc_intfs = npc_const & 0xFULL;
@@ -2002,6 +2001,10 @@ int rvu_npc_init(struct rvu *rvu)
 	err = rvu_alloc_bitmap(&pkind->rsrc);
 	if (err)
 		return err;
+	/* Reserve PKIND#0 for LBKs. Power reset value of LBK_CH_PKIND is '0',
+	 * no need to configure PKIND for all LBKs separately.
+	 */
+	rvu_alloc_rsrc(&pkind->rsrc);
 
 	/* Allocate mem for pkind to PF and channel mapping info */
 	pkind->pfchan_map = devm_kcalloc(rvu->dev, pkind->rsrc.max,
-- 
2.17.1

