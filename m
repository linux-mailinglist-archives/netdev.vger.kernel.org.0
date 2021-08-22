Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439BE3F3F29
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhHVMD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhHVMDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MBO8Q2012225;
        Sun, 22 Aug 2021 05:02:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=iMzgXIpRF84Lk39VFbig3OfiOEdNrgFtCTIAJjU1dDs=;
 b=XXFwOdZRQsQtrSZkJQW8yPGPs1KyAdbtJJwjIfySWJQOQvQ1IrAJyIaLGk4LBzcZaCeJ
 evnT9suyio0z9OzcmpwdXu1oCPnhAEAv/AtPEVDpxsZvtLf5hXBrTG1XUwlLlMqxmfa+
 t+rQ15Zw/9Ky9p0sltdn8jB16v8Sc/RO5gtiJEbkotYYjomUnkZtaGhMngm4/3dYZquy
 Y8H/BuVv8JPa89U/qnc9NH3awG7QVcBt3FSOTTd/7VJ940ZpRI4sKr0fLDWFmrUwlmzb
 l3E5VDynbUt4lLUlj7ceJ71nXC+q2grtsS8HmS0hYm+TDCA+lXvGXktMteWodeqWphxe DQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:40 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 8BF743F7060;
        Sun, 22 Aug 2021 05:02:38 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 01/10] octeontx2-pf: Fix NIX1_RX interface backpressure
Date:   Sun, 22 Aug 2021 17:32:18 +0530
Message-ID: <1629633747-22061-2-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: l5k2k-hzNd7SQkFdR4ETjufmzbxV049L
X-Proofpoint-ORIG-GUID: l5k2k-hzNd7SQkFdR4ETjufmzbxV049L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

'bp_ena' in Aura context is NIX block index, setting it
zero will always backpressure NIX0 block, even if NIXLF
belongs to NIX1. Hence fix this by setting it appropriately
based on NIX block address.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 70fcc1f..2112008 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1190,7 +1190,22 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	/* Enable backpressure for RQ aura */
 	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
+		/* If NIX1 LF is attached then specify NIX1_RX.
+		 *
+		 * Below NPA_AURA_S[BP_ENA] is set according to the
+		 * NPA_BPINTF_E enumeration given as:
+		 * 0x0 + a*0x1 where 'a' is 0 for NIX0_RX and 1 for NIX1_RX so
+		 * NIX0_RX is 0x0 + 0*0x1 = 0
+		 * NIX1_RX is 0x0 + 1*0x1 = 1
+		 * But in HRM it is given that
+		 * "NPA_AURA_S[BP_ENA](w1[33:32]) - Enable aura backpressure to
+		 * NIX-RX based on [BP] level. One bit per NIX-RX; index
+		 * enumerated by NPA_BPINTF_E."
+		 */
+		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
+			aq->aura.bp_ena = 1;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
+
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
 	}
-- 
2.7.4

