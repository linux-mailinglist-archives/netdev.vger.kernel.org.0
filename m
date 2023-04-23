Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28A6EBE55
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDWJzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDWJzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:19 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23EE10FD;
        Sun, 23 Apr 2023 02:55:18 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N5TuZV002401;
        Sun, 23 Apr 2023 02:55:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=wOL9J5+b1MuQxRRbUHulzpZlybxnSPQ/BiOW4ZOtA2s=;
 b=XBo6O1avscawmdLqrfem5Ud5wY7mlNv+mCEVcxLr6jZKbBlXujRxOGYNsTQmHZFIE1uC
 YhgJGVFnfyZzbusHq1O3MFBCdbuX8E4ba/rC+yLMHmWivtEPzso0eve3yN1F9SPguTkt
 wUe7kQqEnoV2xh33pXo6IzCfI2tI+xIIddWCFZOG7hoykewNn/aBHeHs8ph4P26wY8RF
 ilexewzhee3aau+0tGH4RhKU/AZOhEcOdYyQMBVa4gBFFf9e0oEQRecbyzK7cbU48yZ2
 9sKhm2EaKMvLnlHP8VfC4s3XYV2K//axtDZtRnvzb+AFaMQH6ZLz2iVSf6xhgxhUfek8 zQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:02 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 5D19E3F706D;
        Sun, 23 Apr 2023 02:54:59 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 1/9] octeonxt2-af: mcs: Fix per port bypass config
Date:   Sun, 23 Apr 2023 15:24:46 +0530
Message-ID: <20230423095454.21049-2-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ok-kSeqbDsPmCZdlKsZnD6z0dXOhoz0P
X-Proofpoint-GUID: ok-kSeqbDsPmCZdlKsZnD6z0dXOhoz0P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each lmac port, MCS has two MCS_TOP_SLAVE_CHANNEL_CONFIGX
registers. For CN10KB both register need to be configured for the
port level mcs bypass to work. This patch also sets bitmap
of flowid/secy entry reserved for default bypass so that these
entries can be shown in debugfs.

Fixes: bd69476e86fc ("octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c       | 11 ++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index f68a6a0e3aa4..492baa0b594c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -494,6 +494,9 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 
 	/* Flow entry */
 	flow_id = mcs->hw->tcam_entries - MCS_RSRC_RSVD_CNT;
+	__set_bit(flow_id, mcs->rx.flow_ids.bmap);
+	__set_bit(flow_id, mcs->tx.flow_ids.bmap);
+
 	for (reg_id = 0; reg_id < 4; reg_id++) {
 		reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 		mcs_reg_write(mcs, reg, GENMASK_ULL(63, 0));
@@ -504,6 +507,8 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 	}
 	/* secy */
 	secy_id = mcs->hw->secy_entries - MCS_RSRC_RSVD_CNT;
+	__set_bit(secy_id, mcs->rx.secy.bmap);
+	__set_bit(secy_id, mcs->tx.secy.bmap);
 
 	/* Set validate frames to NULL and enable control port */
 	plcy = 0x7ull;
@@ -528,6 +533,7 @@ int mcs_install_flowid_bypass_entry(struct mcs *mcs)
 	/* Enable Flowid entry */
 	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_RX, true);
 	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_TX, true);
+
 	return 0;
 }
 
@@ -1325,8 +1331,11 @@ void mcs_reset_port(struct mcs *mcs, u8 port_id, u8 reset)
 void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode)
 {
 	u64 reg;
+	int id = lmac_id * 2;
 
-	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(lmac_id * 2);
+	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(id);
+	mcs_reg_write(mcs, reg, (u64)mode);
+	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG((id + 1));
 	mcs_reg_write(mcs, reg, (u64)mode);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 26cfa501f1a1..9533b1d92960 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -497,8 +497,9 @@ static int rvu_dbg_mcs_rx_secy_stats_display(struct seq_file *filp, void *unused
 			   stats.octet_validated_cnt);
 		seq_printf(filp, "secy%d: Pkts on disable port: %lld\n", secy_id,
 			   stats.pkt_port_disabled_cnt);
-		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_badtag_cnt);
-		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_nosa_cnt);
+		seq_printf(filp, "secy%d: Pkts with badtag: %lld\n", secy_id, stats.pkt_badtag_cnt);
+		seq_printf(filp, "secy%d: Pkts with no SA(sectag.tci.c=0): %lld\n", secy_id,
+			   stats.pkt_nosa_cnt);
 		seq_printf(filp, "secy%d: Pkts with nosaerror: %lld\n", secy_id,
 			   stats.pkt_nosaerror_cnt);
 		seq_printf(filp, "secy%d: Tagged ctrl pkts: %lld\n", secy_id,
-- 
2.25.1

