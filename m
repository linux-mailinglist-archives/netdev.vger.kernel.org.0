Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB693F3F31
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbhHVMDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232477AbhHVMDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBO8Q5012225;
        Sun, 22 Aug 2021 05:03:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=X7G7VWFRDKWmXwY/xR1rdvZx4+rKtby3dOL8a1gQC28=;
 b=Rvv0E2fmhSI+ISmVJMWFESr5X96hSr07RBZgFyP9Ri67Eg8/b65XwT88jD0mYMdakKKp
 uLwFTUHKgzPUPYgM1qEh03EC6F7Ar3yDzM2vxWn83QzJ38oS+hQ7anb6lTrLpNbfWshL
 mrQO3GVWhJO+lmnSQaNe+S2fI53H4JNf2cLBjRKGRW+CLWw0Hiyof8Aza6jEnKqXS9pr
 8UoJaeyPkjJWwPNhDjLMkPeK/LcAbilPA65tQvD0h+0COcdJVUCIPt0YxQdHCVanhBvo
 hJq287mSBP0fILoCvqJsOldv0EqETTOC/cpep/M7NUu5R23I8EtC/xTgB8lNx84XG3cT PA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:03:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:58 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id DBFFB3F7060;
        Sun, 22 Aug 2021 05:02:56 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 09/10] octeontx2-pf: Fix algorithm index in MCAM rules with RSS action
Date:   Sun, 22 Aug 2021 17:32:26 +0530
Message-ID: <1629633747-22061-10-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: u20qSgEZratJVkV_HiLn85535wY9hBCL
X-Proofpoint-ORIG-GUID: u20qSgEZratJVkV_HiLn85535wY9hBCL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherthan setting action as RSS in NPC MCAM entry, RSS flowkey
algorithm index also needs to be set. Otherwise whatever algorithm
is defined at flowkey index '0' will be considered by HW and pkt
flows will be distributed as such.

Fix this by saving the flowkey index sent by admin function while
initializing RSS and then use it when framing MCAM rules.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 11 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h |  3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c  |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 4e125d6..679c3f8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -269,6 +269,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct nix_rss_flowkey_cfg_rsp *rsp;
 	struct nix_rss_flowkey_cfg *req;
 	int err;
 
@@ -283,6 +284,16 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	req->group = DEFAULT_RSS_CONTEXT_GROUP;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	rsp = (struct nix_rss_flowkey_cfg_rsp *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp))
+		goto fail;
+
+	pfvf->hw.flowkey_alg_idx = rsp->alg_idx;
+fail:
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8fd58cd..8c602d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -196,6 +196,9 @@ struct otx2_hw {
 	u8			lso_udpv4_idx;
 	u8			lso_udpv6_idx;
 
+	/* RSS */
+	u8			flowkey_alg_idx;
+
 	/* MSI-X */
 	u8			cint_cnt; /* CQ interrupt count */
 	u16			npa_msixoff; /* Offset of NPA vectors */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 4d9de52..fdd27c4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -858,6 +858,7 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 		if (flow->flow_spec.flow_type & FLOW_RSS) {
 			req->op = NIX_RX_ACTIONOP_RSS;
 			req->index = flow->rss_ctx_id;
+			req->flow_key_alg = pfvf->hw.flowkey_alg_idx;
 		} else {
 			req->op = NIX_RX_ACTIONOP_UCAST;
 			req->index = ethtool_get_flow_spec_ring(ring_cookie);
-- 
2.7.4

