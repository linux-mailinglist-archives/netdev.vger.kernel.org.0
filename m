Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AA6DAC97
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240727AbjDGMYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDGMYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:24:11 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0C6976F;
        Fri,  7 Apr 2023 05:24:10 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337AwmMZ000622;
        Fri, 7 Apr 2023 05:23:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=aJ4BaAT3AGcAdjDo2xWVNbwi49MYlxqi2NK5V4zd0ms=;
 b=gcnFh8BRzh9UtQjT4OfHQnbtrc0gjmvjZDCQZNAuJ0/9Qddpmrl6Ohrwz8BlMqQ4r1So
 rsvb2V9JdsEOChu9cKCqwM+g3o94i1RrSfFECyLyoUl7hF8CYLUlZJMhfXduCpqc7JS6
 wItHyiv1z5hF1tXU5SBI8lIowqGL99HXUdM1yKQKOW+EVU7yxEmNjHE9cB0FMaUI3PhU
 Pf11+A4o8Y5biM/1SkvsM2Tt482mDoACOcziKdrSI0Q5cNYPTf8zofuz3J3tNTYaA9i2
 l/CI/u33cu1FJbYh3b9/Iz5gKHKhhyCSC/lZ0NS09Ku7fPez2YBnU2Q2UhD+FgHuWgJO Gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pthvw88pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Apr 2023 05:23:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 7 Apr
 2023 05:23:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 7 Apr 2023 05:23:57 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 486483F7062;
        Fri,  7 Apr 2023 05:23:53 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <richardcochran@gmail.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v2 1/7] octeontx2-af: Secure APR table update with the lock
Date:   Fri, 7 Apr 2023 17:53:38 +0530
Message-ID: <20230407122344.4059-2-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230407122344.4059-1-saikrishnag@marvell.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kTQv6lgVAO_GSKLpznL0LK5J2INraHAe
X-Proofpoint-GUID: kTQv6lgVAO_GSKLpznL0LK5J2INraHAe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_08,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

APR table contains the lmtst base address of PF/VFs.
These entries are updated by the PF/VF during the
device probe. Due to race condition while updating the
entries are getting corrupted. Hence secure the APR
table update with the lock.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
index 4ad9ff025c96..8530250f6fba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -142,16 +142,17 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 	 * region, if so, convert that IOVA to physical address and
 	 * populate LMT table with that address
 	 */
+	mutex_lock(&rvu->rsrc_lock);
 	if (req->use_local_lmt_region) {
 		err = rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
 				      req->lmt_iova, &lmt_addr);
 		if (err < 0)
-			return err;
+			goto error;
 
 		/* Update the lmt addr for this PFFUNC in the LMT table */
 		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
 		if (err)
-			return err;
+			goto error;
 	}
 
 	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make
@@ -181,7 +182,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 		 */
 		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
 		if (err)
-			return err;
+			goto error;
 	}
 
 	/* This mailbox can also be used to update word1 of APR_LMT_MAP_ENTRY_S
@@ -230,6 +231,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
 	}
 
 error:
+	mutex_unlock(&rvu->rsrc_lock);
 	return err;
 }
 
-- 
2.25.1

