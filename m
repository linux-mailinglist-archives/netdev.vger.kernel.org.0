Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A893F3F2E
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhHVMDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54350 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231723AbhHVMDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17M9nI66017269;
        Sun, 22 Aug 2021 05:02:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=19spTkTXVDBbcPDiL8WwgwKj8BXckoV0mI61YmI9nVw=;
 b=I0xM0VvXocXukozzXObViaIo2Hoyh4w/0iYauNdbX405AgX+scumOEpsv8PmJk1gNjZr
 iVJbJ+f4fgeUp2Iaon0POBB9GVDxSAQ+6PMbG8ebmtNVU7Y8lmche1+630R6YmmG+XU0
 K0cbYMzTPXDCLUPYeOditYMwc1YI97SAAKlI5Wx6ej0P/XilWmZ8Sn0KWEi78b1Lf3lt
 xorwfxr3qe/Dk6RArtHHRny0CHZnDg72ej110yglQXZqeTUzNYMpTTa+hahUhhSBESzA
 KyWuIKNihb8wApMfedAJQycZv2L3P0udhlQBRCrlJZxBNfc9v5oplGFLe7v1h6dKpNLy 9g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:52 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id AE98D3F7061;
        Sun, 22 Aug 2021 05:02:50 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 06/10] octeontx2-af: Use DMA_ATTR_FORCE_CONTIGUOUS attribute in DMA alloc
Date:   Sun, 22 Aug 2021 17:32:23 +0530
Message-ID: <1629633747-22061-7-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _BOYMvJR4pWe-_wrbIqUZLq4okb_qiMU
X-Proofpoint-ORIG-GUID: _BOYMvJR4pWe-_wrbIqUZLq4okb_qiMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

CN10K platform requires physically contiguous memory for LMTST
operations which goes beyond a single page. Not having physically
contiguous memory will result in HW fetching transmit descriptors from
a wrong memory location.

Hence use DMA_ATTR_FORCE_CONTIGUOUS attribute while allocating
LMTST regions.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e0b43aa..459fa95 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -64,8 +64,8 @@ static inline int qmem_alloc(struct device *dev, struct qmem **q,
 
 	qmem->entry_sz = entry_sz;
 	qmem->alloc_sz = (qsize * entry_sz) + OTX2_ALIGN;
-	qmem->base = dma_alloc_coherent(dev, qmem->alloc_sz,
-					 &qmem->iova, GFP_KERNEL);
+	qmem->base = dma_alloc_attrs(dev, qmem->alloc_sz, &qmem->iova,
+				     GFP_KERNEL, DMA_ATTR_FORCE_CONTIGUOUS);
 	if (!qmem->base)
 		return -ENOMEM;
 
@@ -84,9 +84,10 @@ static inline void qmem_free(struct device *dev, struct qmem *qmem)
 		return;
 
 	if (qmem->base)
-		dma_free_coherent(dev, qmem->alloc_sz,
-				  qmem->base - qmem->align,
-				  qmem->iova - qmem->align);
+		dma_free_attrs(dev, qmem->alloc_sz,
+			       qmem->base - qmem->align,
+			       qmem->iova - qmem->align,
+			       DMA_ATTR_FORCE_CONTIGUOUS);
 	devm_kfree(dev, qmem);
 }
 
-- 
2.7.4

