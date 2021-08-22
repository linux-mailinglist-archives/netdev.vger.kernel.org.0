Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E563F3F2A
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhHVMD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41468 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhHVMD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17M9nI63017269;
        Sun, 22 Aug 2021 05:02:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=h/GjcaFOVREoS7h92m9EHoci3aAZup1fR4rzPYX2Ix0=;
 b=KLNc6BGuiSrQbrsafDGkOpY85Pf/OafOUuwB/tYeZBLOINufBsJzmsSZWOeueg7wzK/9
 YllRI5E4XgAAfZZh7YmsK3hSkxpJEehPz+6iY/9W4+e2u5KCeMQlMC2ijDK/y19KSX+K
 8qNi90b1bLYphX7O4tpX8ofAAAlHavJwNHEr1rcZL8X8q4aXbAhF4GiQUyQcZ5WzVJ5j
 GLlMiTnCWZ5KvfL9YfTc6lYSXKA4HCL/meOhuOtPRDHfAJ8dpaCtfnN6wXfScNNTy2s2
 kCf0KOUXnSpqNRn1nMbJhJ8RvSxRS63ZHjEGMoVDNioFxEH63ABTZAekwAvgoclf+ihp TA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:43 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 126013F7060;
        Sun, 22 Aug 2021 05:02:41 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 02/10] octeontx2-af: cn10k: Fix SDP base channel number
Date:   Sun, 22 Aug 2021 17:32:19 +0530
Message-ID: <1629633747-22061-3-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -PDsij0FHRFcMF4uVpm4g8sHP3CYXmD-
X-Proofpoint-ORIG-GUID: -PDsij0FHRFcMF4uVpm4g8sHP3CYXmD-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

As per hardware the base channel number configured
for programmable channels of a block must be multiple
of number of channels of that block. This condition
is not met for SDP base channel currently. Hence this
patch ensures all the base channel numbers of all
blocks are multiple of number of channels present in
the blocks. Also instead of hardcoding SDP number
of channels the same is read from the NIX_AF_CONST1
register.

Fixes: 242da439214b ("octeontx2-af: cn10k: Add support for programmable")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  2 --
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 31 +++++++++++++++-------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 47f5ed0..e0b43aa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -195,8 +195,6 @@ enum nix_scheduler {
 #define NIX_CHAN_LBK_CHX(a, b)		(0 + 0x100 * (a) + (b))
 #define NIX_CHAN_SDP_CH_START		(0x700ull)
 
-#define SDP_CHANNELS			256
-
 /* The mask is to extract lower 10-bits of channel number
  * which CPT will pass to X2P.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 8d48b64..28dcce7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -212,9 +212,10 @@ void rvu_reset_lmt_map_tbl(struct rvu *rvu, u16 pcifunc)
 
 int rvu_set_channels_base(struct rvu *rvu)
 {
+	u16 nr_lbk_chans, nr_sdp_chans, nr_cgx_chans, nr_cpt_chans;
+	u16 sdp_chan_base, cgx_chan_base, cpt_chan_base;
 	struct rvu_hwinfo *hw = rvu->hw;
-	u16 cpt_chan_base;
-	u64 nix_const;
+	u64 nix_const, nix_const1;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
@@ -222,6 +223,7 @@ int rvu_set_channels_base(struct rvu *rvu)
 		return blkaddr;
 
 	nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 
 	hw->cgx = (nix_const >> 12) & 0xFULL;
 	hw->lmac_per_cgx = (nix_const >> 8) & 0xFULL;
@@ -244,14 +246,24 @@ int rvu_set_channels_base(struct rvu *rvu)
 	 * channels such that all channel numbers are contiguous
 	 * leaving no holes. This way the new CPT channels can be
 	 * accomodated. The order of channel numbers assigned is
-	 * LBK, SDP, CGX and CPT.
+	 * LBK, SDP, CGX and CPT. Also the base channel number
+	 * of a block must be multiple of number of channels
+	 * of the block.
 	 */
-	hw->sdp_chan_base = hw->lbk_chan_base + hw->lbk_links *
-				((nix_const >> 16) & 0xFFULL);
-	hw->cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * SDP_CHANNELS;
+	nr_lbk_chans = (nix_const >> 16) & 0xFFULL;
+	nr_sdp_chans = nix_const1 & 0xFFFULL;
+	nr_cgx_chans = nix_const & 0xFFULL;
+	nr_cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
-	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links *
-				(nix_const & 0xFFULL);
+	sdp_chan_base = hw->lbk_chan_base + hw->lbk_links * nr_lbk_chans;
+	/* Round up base channel to multiple of number of channels */
+	hw->sdp_chan_base = ALIGN(sdp_chan_base, nr_sdp_chans);
+
+	cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * nr_sdp_chans;
+	hw->cgx_chan_base = ALIGN(cgx_chan_base, nr_cgx_chans);
+
+	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links * nr_cgx_chans;
+	hw->cpt_chan_base = ALIGN(cpt_chan_base, nr_cpt_chans);
 
 	/* Out of 4096 channels start CPT from 2048 so
 	 * that MSB for CPT channels is always set
@@ -355,6 +367,7 @@ static void rvu_lbk_set_channels(struct rvu *rvu)
 
 static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 {
+	u64 nix_const1 = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
 	u64 nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	u16 cgx_chans, lbk_chans, sdp_chans, cpt_chans;
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -364,7 +377,7 @@ static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
 
 	cgx_chans = nix_const & 0xFFULL;
 	lbk_chans = (nix_const >> 16) & 0xFFULL;
-	sdp_chans = SDP_CHANNELS;
+	sdp_chans = nix_const1 & 0xFFFULL;
 	cpt_chans = (nix_const >> 32) & 0xFFFULL;
 
 	start = hw->cgx_chan_base;
-- 
2.7.4

