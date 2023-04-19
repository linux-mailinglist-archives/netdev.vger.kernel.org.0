Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE396E730A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjDSGUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjDSGUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:20:41 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D2B26A9;
        Tue, 18 Apr 2023 23:20:40 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J4BvKs030775;
        Tue, 18 Apr 2023 23:20:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=fRAj2n7fpPO4NwJ2yzsB/HPD25KmiFWUyXE50hisb7E=;
 b=HaSDLcwVCOxJ6UHAokW42EURCUeErCwQ+ZinNjg/n9V9+s8Bhj2QwtosfSwNpbd9ZZ8n
 Y2dqzyVXnb0HOvanSdjkU3Yazryhb4KNW/rrnb3Y2rIjfhSaWcSGyKN1AAw6AtIUu5gL
 mWvUNyqntxHdA3b1V9MA6OgDQqQ0ahXbG2rZtLYy5Ld1gLBfGQjzj7P1qmluoDavSdwj
 HMoWPtN+hJwEGpkYuNr5quhKkPJU2CacGXSSXLyCQSNydEBcWmWu5/NwcEKRdbNSz9h4
 Nzmwbn33GcSSMk/9g67QKnAr9MJGJtXNsX7NWnpnC05b36e0hXge5s1JNwhw3uRFCGLV Fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q28s0gmf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 23:20:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 18 Apr
 2023 23:20:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 18 Apr 2023 23:20:31 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id B9CA93F7058;
        Tue, 18 Apr 2023 23:20:26 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3 01/10] octeontx2-af: Secure APR table update with the lock
Date:   Wed, 19 Apr 2023 11:50:09 +0530
Message-ID: <20230419062018.286136-2-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419062018.286136-1-saikrishnag@marvell.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Oju6Zmi6bl8nexobfQH3Q7PY4905u3vJ
X-Proofpoint-ORIG-GUID: Oju6Zmi6bl8nexobfQH3Q7PY4905u3vJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_02,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

APR table contains the lmtst base address of PF/VFs. These entries
are updated by the PF/VF during the device probe. The lmtst address
is fetched from HW using "TXN_REQ" and "ADDR_RSP_STS" registers.
The lock tries to protect these registers from getting overwritten
when multiple PFs invokes rvu_get_lmtaddr() simultaneously.

For example, if PF1 submit the request and got permitted before it
reads the response and PF2 got scheduled submit the request then the
response of PF1 is overwritten by the PF2 response.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 4ad9ff025c96..0e74c5a2231e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -60,13 +60,14 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 			   u64 iova, u64 *lmt_addr)
 {
 	u64 pa, val, pf;
-	int err;
+	int err = 0;
 
 	if (!iova) {
 		dev_err(rvu->dev, "%s Requested Null address for transulation\n", __func__);
 		return -EINVAL;
 	}
 
+	mutex_lock(&rvu->rsrc_lock);
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_REQ, iova);
 	pf = rvu_get_pf(pcifunc) & 0x1F;
 	val = BIT_ULL(63) | BIT_ULL(14) | BIT_ULL(13) | pf << 8 |
@@ -76,12 +77,13 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 	err = rvu_poll_reg(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS, BIT_ULL(0), false);
 	if (err) {
 		dev_err(rvu->dev, "%s LMTLINE iova transulation failed\n", __func__);
-		return err;
+		goto exit;
 	}
 	val = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS);
 	if (val & ~0x1ULL) {
 		dev_err(rvu->dev, "%s LMTLINE iova transulation failed err:%llx\n", __func__, val);
-		return -EIO;
+		err = -EIO;
+		goto exit;
 	}
 	/* PA[51:12] = RVU_AF_SMMU_TLN_FLIT0[57:18]
 	 * PA[11:0] = IOVA[11:0]
@@ -89,8 +91,9 @@ static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
 	pa = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TLN_FLIT0) >> 18;
 	pa &= GENMASK_ULL(39, 0);
 	*lmt_addr = (pa << 12) | (iova  & 0xFFF);
-
-	return 0;
+exit:
+	mutex_unlock(&rvu->rsrc_lock);
+	return err;
 }
 
 static int rvu_update_lmtaddr(struct rvu *rvu, u16 pcifunc, u64 lmt_addr)
-- 
2.25.1

