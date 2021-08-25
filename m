Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0763F74FD
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbhHYMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27532 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240908AbhHYMUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:20:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6euWn015422;
        Wed, 25 Aug 2021 05:19:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yF8Fr3tvZjlkuj6LNJ/f3HS3wOEWaAFn+3fmGiJBLkY=;
 b=Ogu+u+bWwxBu1W4Tf3J3K/enGUuXIONCRWUpWjqtgyyAU+TkN63hyyIvMGEiZXZNr/rG
 ZBD42XITC9b/UJPFqTnr1ntg+cE0UEnESj1N1ydTLJ9KAOFzGlvM+5DkLpPwA8bmSBxy
 ux9fEBRAkX6rUxbXf5duZo4hZYMClXJi8RCHAVDDuCsWRBTzTmItNisjmVQGxsMzKtJs
 /vXTfPBuZBM+Z5CqUxoh0mMN3vNS7Dn+gbnXaGUlkInRsiCLEbKQuKTgtLTMhAwfvwYg
 NCPtDn+NXIx5v49jcZN8B93KK1afCbPCISuzcIu1pQY/yawgboWo5Stj5bSLQ5dnIEKD Eg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:19:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:19:15 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 7AABF3F7072;
        Wed, 25 Aug 2021 05:19:13 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 9/9] octeontx2-af: Add mbox to retrieve bandwidth profile free count
Date:   Wed, 25 Aug 2021 17:48:46 +0530
Message-ID: <1629893926-18398-10-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: CH-eFbJ0NRKjBaK7Cbx-4VUxn3dGgecA
X-Proofpoint-GUID: CH-eFbJ0NRKjBaK7Cbx-4VUxn3dGgecA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added mbox for PF/VF drivers to retrieve current ingress bandwidth
profile free count. Also added current policer timeunit
configuration info based on which ratelimiting decisions can be
taken by PF/VF drivers.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 10 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 33 ++++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index bc9cd1d..ef3c41c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -279,7 +279,9 @@ M(NIX_GET_HW_INFO,	0x801c, nix_get_hw_info, msg_req, nix_hw_info)	\
 M(NIX_BANDPROF_ALLOC,	0x801d, nix_bandprof_alloc, nix_bandprof_alloc_req, \
 				nix_bandprof_alloc_rsp)			    \
 M(NIX_BANDPROF_FREE,	0x801e, nix_bandprof_free, nix_bandprof_free_req,   \
-				msg_rsp)
+				msg_rsp)				    \
+M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
+				nix_bandprof_get_hwinfo_rsp)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -1101,6 +1103,12 @@ struct nix_bandprof_free_req {
 	u16 prof_idx[BAND_PROF_NUM_LAYERS][MAX_BANDPROF_PER_PFFUNC];
 };
 
+struct nix_bandprof_get_hwinfo_rsp {
+	struct mbox_msghdr hdr;
+	u16 prof_count[BAND_PROF_NUM_LAYERS];
+	u32 policer_timeunit;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index c2eb3b0..dfa933c5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -5173,3 +5173,36 @@ static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
 		rvu_free_rsrc(&ipolicer->band_prof, mid_prof);
 	}
 }
+
+int rvu_mbox_handler_nix_bandprof_get_hwinfo(struct rvu *rvu, struct msg_req *req,
+					     struct nix_bandprof_get_hwinfo_rsp *rsp)
+{
+	struct nix_ipolicer *ipolicer;
+	int blkaddr, layer, err;
+	struct nix_hw *nix_hw;
+	u64 tu;
+
+	if (!rvu->hw->cap.ipolicer)
+		return NIX_AF_ERR_IPOLICER_NOTSUPP;
+
+	err = nix_get_struct_ptrs(rvu, req->hdr.pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	/* Return number of bandwidth profiles free at each layer */
+	mutex_lock(&rvu->rsrc_lock);
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+
+		ipolicer = &nix_hw->ipolicer[layer];
+		rsp->prof_count[layer] = rvu_rsrc_free_count(&ipolicer->band_prof);
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+
+	/* Set the policer timeunit in nanosec */
+	tu = rvu_read64(rvu, blkaddr, NIX_AF_PL_TS) & GENMASK_ULL(9, 0);
+	rsp->policer_timeunit = (tu + 1) * 100;
+
+	return 0;
+}
-- 
2.7.4

