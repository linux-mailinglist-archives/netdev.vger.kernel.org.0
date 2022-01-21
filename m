Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7774959F8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378710AbiAUGfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32844 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbiAUGfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05s49029339;
        Thu, 20 Jan 2022 22:35:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=iDlan2tDEYwFB4HK6VnsY6tjV1MANLaxqz/J5MFVtpk=;
 b=lM6THIWuav/jJsyoYGJtlOOo4ajXdAnpWI02sGlhbH10bfgJk3m6S89xlc6YS2M0wKjF
 xge/mc4rIPRUqTSJb/ACiTjWuRrRsuuVNfa31Tx3pObj6wf8xq63x8/HsuPKauV8GhaV
 HVNWLEjImNvGFc5QoS9D+YlyRXEcP+19SPcQCfU7S+FZoGJnsm++IRDIybgike1B5081
 hPwVS1OzByuj43ZZ0ex+S8NWZMx0a0kNzjfmxAs0HaODrU7/libi+fLJmxneWKDSYiCt
 USRKjVRbT6BqQztEMaxBHCyocWZweX1zeHzIjOsdccQn4iWNksf1IfQDveOZ0pidGGUv EA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:02 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Jan
 2022 22:35:00 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:00 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 7C2C23F7095;
        Thu, 20 Jan 2022 22:34:57 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [net PATCH 2/9] octeontx2-af: Fix LBK backpressure id count
Date:   Fri, 21 Jan 2022 12:04:40 +0530
Message-ID: <1642746887-30924-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 4dXWBhh7smpsZv1Ckget4cAG840_qDYl
X-Proofpoint-ORIG-GUID: 4dXWBhh7smpsZv1Ckget4cAG840_qDYl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

In rvu_nix_get_bpid() lbk_bpid_cnt is being read from
wrong register. Due to this backpressure enable is failing
for LBK VF32 onwards. This patch fixes that.

Fixes: fe1939bb2340 ("octeontx2-af: Add SDP interface support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d8b1948..b74ab0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -512,11 +512,11 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	lmac_chan_cnt = cfg & 0xFF;
 
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
-	sdp_chan_cnt = cfg & 0xFFF;
-
 	cgx_bpid_cnt = hw->cgx_links * lmac_chan_cnt;
 	lbk_bpid_cnt = hw->lbk_links * ((cfg >> 16) & 0xFF);
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
+	sdp_chan_cnt = cfg & 0xFFF;
 	sdp_bpid_cnt = hw->sdp_links * sdp_chan_cnt;
 
 	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-- 
2.7.4

