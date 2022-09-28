Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD65ED3B3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiI1D7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiI1D6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:58:48 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E101166FF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:58:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RKJG6m018634;
        Tue, 27 Sep 2022 20:58:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UMBAu48AQyiPhrnBltvUAmSRlnqNJb+kR+JKr5RyT3M=;
 b=KGLvECZy26CVZZxRFkUgRej0JQGD6YaBJ6mUxu2GCtQ5dR10dMBhiILUi/TIWb3XJot7
 Qas70RBw86r9DsUWDoBs139SFfgAnRcyIlpapBkBsRZRNkHrLrgJSwMmmwtMRu4ZAPt8
 N/1MEd8+8Gj6LUEOL5mE1SpWeAdTvdeJs81NOia+EeX92sOzpo9YlWGj7EyDce0h7MLH
 VCd/i1AG13lOOnWIHsBuUaSbRLt0GsYDXYByhkMpiWmKGg/rpcm6SbQHl+qInTl/H4zF
 Tt83pAsu1YIZnneTOlpkgTAaTobKKgKS3I5dFfXu8GxmVuWwwgyD06bRIk+kSxcn559r GA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jt1dpcy7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 20:58:38 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Sep
 2022 20:58:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 27 Sep 2022 20:58:36 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 559093F70E8;
        Tue, 27 Sep 2022 20:58:33 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 4/8] octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic
Date:   Wed, 28 Sep 2022 09:28:06 +0530
Message-ID: <1664337490-20231-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
References: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6unuVgWqVogKLxvLm7-NI0jjEatOSxvU
X-Proofpoint-GUID: 6unuVgWqVogKLxvLm7-NI0jjEatOSxvU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_12,2022-09-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Out of all the TCAM entries, reserve last TX and RX TCAM flow
entry(low priority) so that normal traffic can be sent out and
received. The traffic which needs macsec processing hits the
high priority TCAM flows. Also install a FLR handler to free
the allocated resources for PF/VF.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 45 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 23 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 66d5038..7c82a25 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -181,6 +181,51 @@ void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id,
 	}
 }
 
+int mcs_install_flowid_bypass_entry(struct mcs *mcs)
+{
+	int flow_id, secy_id, reg_id;
+	struct secy_mem_map map;
+	u64 reg, plcy = 0;
+
+	/* Flow entry */
+	flow_id = mcs->hw->tcam_entries - MCS_RSRC_RSVD_CNT;
+	for (reg_id = 0; reg_id < 4; reg_id++) {
+		reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
+		mcs_reg_write(mcs, reg, GENMASK_ULL(63, 0));
+	}
+	for (reg_id = 0; reg_id < 4; reg_id++) {
+		reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
+		mcs_reg_write(mcs, reg, GENMASK_ULL(63, 0));
+	}
+	/* secy */
+	secy_id = mcs->hw->secy_entries - MCS_RSRC_RSVD_CNT;
+
+	/* Set validate frames to NULL and enable control port */
+	plcy = 0x7ull;
+	if (mcs->hw->mcs_blks > 1)
+		plcy = BIT_ULL(0) | 0x3ull << 4;
+	mcs_secy_plcy_write(mcs, plcy, secy_id, MCS_RX);
+
+	/* Enable control port and set mtu to max */
+	plcy = BIT_ULL(0) | GENMASK_ULL(43, 28);
+	if (mcs->hw->mcs_blks > 1)
+		plcy = BIT_ULL(0) | GENMASK_ULL(63, 48);
+	mcs_secy_plcy_write(mcs, plcy, secy_id, MCS_TX);
+
+	/* Map flowid to secy */
+	map.secy = secy_id;
+	map.ctrl_pkt = 0;
+	map.flow_id = flow_id;
+	mcs->mcs_ops->mcs_flowid_secy_map(mcs, &map, MCS_RX);
+	map.sc = secy_id;
+	mcs->mcs_ops->mcs_flowid_secy_map(mcs, &map, MCS_TX);
+
+	/* Enable Flowid entry */
+	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_RX, true);
+	mcs_ena_dis_flowid_entry(mcs, flow_id, MCS_TX, true);
+	return 0;
+}
+
 void mcs_clear_secy_plcy(struct mcs *mcs, int secy_id, int dir)
 {
 	struct mcs_rsrc_map *map;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index 3c307e7..8a7d455 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -133,6 +133,27 @@ int rvu_mbox_handler_mcs_custom_tag_cfg_get(struct rvu *rvu, struct mcs_custom_t
 	return 0;
 }
 
+int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc)
+{
+	struct mcs *mcs;
+	int mcs_id;
+
+	/* CNF10K-B mcs0-6 are mapped to RPM2-8*/
+	if (rvu->mcs_blk_cnt > 1) {
+		for (mcs_id = 0; mcs_id < rvu->mcs_blk_cnt; mcs_id++) {
+			mcs = mcs_get_pdata(mcs_id);
+			mcs_free_all_rsrc(mcs, MCS_RX, pcifunc);
+			mcs_free_all_rsrc(mcs, MCS_TX, pcifunc);
+		}
+	} else {
+		/* CN10K-B has only one mcs block */
+		mcs = mcs_get_pdata(0);
+		mcs_free_all_rsrc(mcs, MCS_RX, pcifunc);
+		mcs_free_all_rsrc(mcs, MCS_TX, pcifunc);
+	}
+	return 0;
+}
+
 int rvu_mbox_handler_mcs_flowid_ena_entry(struct rvu *rvu,
 					  struct mcs_flowid_ena_dis_entry *req,
 					  struct msg_rsp *rsp)
@@ -543,8 +564,10 @@ int rvu_mcs_init(struct rvu *rvu)
 		rvu_mcs_set_lmac_bmap(rvu);
 	}
 
+	/* Install default tcam bypass entry and set port to operational mode */
 	for (mcs_id = 0; mcs_id < rvu->mcs_blk_cnt; mcs_id++) {
 		mcs = mcs_get_pdata(mcs_id);
+		mcs_install_flowid_bypass_entry(mcs);
 		for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++)
 			mcs_set_lmac_mode(mcs, lmac, 0);
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 9a150da..4aefe47 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -875,5 +875,6 @@ int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 
 /* CN10K MCS */
 int rvu_mcs_init(struct rvu *rvu);
+int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc);
 
 #endif /* RVU_H */
-- 
2.7.4

