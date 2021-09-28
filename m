Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAE141ADD1
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbhI1Lcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:32:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240349AbhI1Lcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:32:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAHumr018449;
        Tue, 28 Sep 2021 04:31:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qUzQHWO9sHcg00Wxfaw5WJIHDpsOo9veGrdtGdNVY18=;
 b=Yes2C0Cux9B96rzk1tg/WL1cYyQxi5JMXhS5y0WsFav/ugo2uC/5A4H2+mYsgDy5Up2L
 TZCfIAH6SUafYFQP+SWLcWLImSHrjxAur3K3Ci1yNK00O9OZNdkJHY/2A6roAz/yGZUS
 ibAaCE1roYkMITCdaU/DuO3norvFcCSwDRxvNqd5Z5HRGta+ov5PUKK892rSvOrWTUtV
 y3zuqx0F9mUoE99HlwLaOz3mOcZ9EbKk5oYB+qRUbgn/EhDXYQ1K34YESanhq8Evs91D
 ge7x5FUR1Fp+gkPvEhXOCVKXdqO8HCaCtK7KXRoSvCZZ1XwgC9a00KZMOm3rSpUbYIn/ +w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bc16207k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 04:31:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 04:31:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 04:31:10 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id C40DB3F7099;
        Tue, 28 Sep 2021 04:31:07 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 1/4] octeontx2-af: Reset PTP config in FLR handler
Date:   Tue, 28 Sep 2021 17:00:58 +0530
Message-ID: <20210928113101.16580-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210928113101.16580-1-hkelam@marvell.com>
References: <20210928113101.16580-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mMxZYIR7Bi8q3dGkAZVbXA1FLwyy2QKY
X-Proofpoint-GUID: mMxZYIR7Bi8q3dGkAZVbXA1FLwyy2QKY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

Upon receiving ptp config request from netdev interface , Octeontx2 MAC
block CGX is configured to append timestamp to every incoming packet
and NPC config is updated with DMAC offset change.

Currently this configuration is not reset in FLR handler. This patch
resets the same.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  3 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 14 ++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 0128211806f9..95e807626a3e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -220,6 +220,7 @@ struct rvu_pfvf {
 	u16		maxlen;
 	u16		minlen;
 
+	bool		hw_rx_tstamp_en; /* Is rx_tstamp enabled */
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 21e5906bcc37..a5c717ad12c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -694,6 +694,7 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 
 static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 {
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	int pf = rvu_get_pf(pcifunc);
 	u8 cgx_id, lmac_id;
 	void *cgxd;
@@ -718,6 +719,8 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 	 */
 	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, enable))
 		return -EINVAL;
+	/* This flag is required to clean up CGX conf if app gets killed */
+	pfvf->hw_rx_tstamp_en = enable;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index e299ec13c7f1..601935a05921 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4516,6 +4516,9 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct hwctx_disable_req ctx_req;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
 	int err;
 
 	ctx_req.hdr.pcifunc = pcifunc;
@@ -4556,6 +4559,17 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	rvu_npc_set_parse_mode(rvu, pcifunc, OTX2_PRIV_FLAGS_DEFAULT,
 			       (PKIND_TX | PKIND_RX), 0, 0, 0, 0);
 
+	/* Disabling CGX and NPC config done for PTP */
+	if (pfvf->hw_rx_tstamp_en) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		cgxd = rvu_cgx_pdata(cgx_id, rvu);
+		cgx_lmac_ptp_config(cgxd, lmac_id, false);
+		/* Undo NPC config done for PTP */
+		if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
+			dev_err(rvu->dev, "NPC config for PTP failed\n");
+		pfvf->hw_rx_tstamp_en = false;
+	}
+
 	nix_ctx_free(rvu, pfvf);
 
 	nix_free_all_bandprof(rvu, pcifunc);
-- 
2.17.1

