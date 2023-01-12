Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9C666A78
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbjALEm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbjALEm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:42:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCE6496E8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:42:06 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C3vtGC001257;
        Wed, 11 Jan 2023 20:42:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=QbyOzCAGtlZfAwujj3c5wFMCTSoi9jLOix7Ii/F5Zjk=;
 b=DVeullUqUwe5URXOVH+Rarxmrv3Bmqql0QjVP6eSdZ0sC3oIhHBw7TKMqbj1fHN6jclS
 DCjNzDzcRAvHdvhQEDoCHi6Fg2JG0O/ZQPnC707bhTmoqo8Ge5V2yrz++kWisWtZqvO+
 IozzDiOpLL0VGIbBdep41chN6kpo+FMz2EuycE/4C28W4jI9optbWmZyf+lGLbEVpyFF
 OIrJx9Appqw9Cxc+CVe5VcqUe2PdygxUwqz/XPYclTH7auvvX6Cp9Wxl39kEPdYARqWC
 u8GhYsG0XrySNlJ0cCOG5kTigL4Pw8siuEaug2GxYHW1+eVwMs+D6Jo2kjlhc9l3rko1 og== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n23b2gscx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 20:42:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 20:41:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 20:41:59 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id D918A3F7080;
        Wed, 11 Jan 2023 20:41:55 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,2/8] octeontx2-af: add mbox for CPT LF reset
Date:   Thu, 12 Jan 2023 10:11:41 +0530
Message-ID: <20230112044147.931159-3-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112044147.931159-1-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 9cP-PF42P2w87N6cike_XNGGI-F-ZEVr
X-Proofpoint-ORIG-GUID: 9cP-PF42P2w87N6cike_XNGGI-F-ZEVr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new mailbox to reset a requested CPT LF.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  8 +++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 33 +++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index d2584ebb7a70..b121e3d9f561 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -195,6 +195,7 @@ M(CPT_STATS,            0xA05, cpt_sts, cpt_sts_req, cpt_sts_rsp)	\
 M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
 			       msg_rsp)                                 \
 M(CPT_CTX_CACHE_SYNC,   0xA07, cpt_ctx_cache_sync, msg_req, msg_rsp)    \
+M(CPT_LF_RESET,         0xA08, cpt_lf_reset, cpt_lf_rst_req, msg_rsp)	\
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \
@@ -1692,6 +1693,13 @@ struct cpt_inst_lmtst_req {
 	u64 rsvd;
 };
 
+/* Mailbox message format to request for CPT LF reset */
+struct cpt_lf_rst_req {
+	struct mbox_msghdr hdr;
+	u32 slot;
+	u32 rsvd;
+};
+
 struct sdp_node_info {
 	/* Node to which this PF belons to */
 	u8 node_id;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 1ed16ce515bb..1cd34914cb86 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -851,6 +851,39 @@ int rvu_mbox_handler_cpt_ctx_cache_sync(struct rvu *rvu, struct msg_req *req,
 	return rvu_cpt_ctx_flush(rvu, req->hdr.pcifunc);
 }
 
+int rvu_mbox_handler_cpt_lf_reset(struct rvu *rvu, struct cpt_lf_rst_req *req,
+				  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_block *block;
+	int cptlf, blkaddr, ret;
+	u16 actual_slot;
+	u64 ctl, ctl2;
+
+	blkaddr = rvu_get_blkaddr_from_slot(rvu, BLKTYPE_CPT, pcifunc,
+					    req->slot, &actual_slot);
+	if (blkaddr < 0)
+		return CPT_AF_ERR_LF_INVALID;
+
+	block = &rvu->hw->block[blkaddr];
+
+	cptlf = rvu_get_lf(rvu, block, pcifunc, actual_slot);
+	if (cptlf < 0)
+		return CPT_AF_ERR_LF_INVALID;
+	ctl = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
+	ctl2 = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf));
+
+	ret = rvu_lf_reset(rvu, block, cptlf);
+	if (ret)
+		dev_err(rvu->dev, "Failed to reset blkaddr %d LF%d\n",
+			block->addr, cptlf);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), ctl);
+	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL2(cptlf), ctl2);
+
+	return 0;
+}
+
 static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
 {
 	struct cpt_rxc_time_cfg_req req;
-- 
2.25.1

