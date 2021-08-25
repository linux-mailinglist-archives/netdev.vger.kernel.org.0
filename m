Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824223F6EE4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 07:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhHYFj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 01:39:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29200 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231816AbhHYFj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 01:39:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OISDxC024916;
        Tue, 24 Aug 2021 22:39:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=d/KVUIZQvTBpVdMdgmztVhrhEsaFPHlnmaRjkvWDdvY=;
 b=dNB2zINxV8k82uiFVtgQM1tm0XWhr33+DCt06wzufEkfyMAhGrvo2LQ0RtTKcsXsl42g
 7vtcSRd44eTjhqWej4kFTHcNoiRe1dEDtZ8OAZRAZtoFQftoQ9nVcRPHYUGQ/TYjrKWl
 BaO+zbR4rNN3bAmqUhuJ8lBdt/u7oca5Vc6LMT6YbybdH+UqeNb2ozyAHNX4typac9c2
 GHBWNE1iFisy42MP55mI2k4iQS70g/bUdRYwFa7mdmvO8v9ul9vu1kYQP2okopX8qCdd
 G8tqYFS3HiXH6ck1Q6zRwueZ7GwNZHAYHHu6ngk4RlKj6exylcEDuf/+7G2BcsU7U2ju 9g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3an62ksxkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 22:39:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 24 Aug
 2021 22:39:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 24 Aug 2021 22:39:08 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9BBBA3F7051;
        Tue, 24 Aug 2021 22:39:05 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <ndabilpuram@marvell.com>
Subject: [PATCH] octeontx2-af: Change the order of queue work and interrupt disable
Date:   Wed, 25 Aug 2021 11:09:04 +0530
Message-ID: <20210825053904.3700-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vh4VEJwn96OYWjzz9V_DS0X4RAufnOsf
X-Proofpoint-GUID: vh4VEJwn96OYWjzz9V_DS0X4RAufnOsf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_01,2021-08-25_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Clear and disable interrupt before queueing work as there might be
a chance that work gets completed on other core faster and
interrupt enable as a part of the work completes before
interrupt disable in the interrupt context. This leads to
permanent disable of interrupt.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 84f0aaa8665d..5bdeed250089 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2447,11 +2447,12 @@ static void rvu_afvf_queue_flr_work(struct rvu *rvu, int start_vf, int numvfs)
 	for (vf = 0; vf < numvfs; vf++) {
 		if (!(intr & BIT_ULL(vf)))
 			continue;
-		dev = vf + start_vf + rvu->hw->total_pfs;
-		queue_work(rvu->flr_wq, &rvu->flr_wrk[dev].work);
 		/* Clear and disable the interrupt */
 		rvupf_write64(rvu, RVU_PF_VFFLR_INTX(reg), BIT_ULL(vf));
 		rvupf_write64(rvu, RVU_PF_VFFLR_INT_ENA_W1CX(reg), BIT_ULL(vf));
+
+		dev = vf + start_vf + rvu->hw->total_pfs;
+		queue_work(rvu->flr_wq, &rvu->flr_wrk[dev].work);
 	}
 }
 
@@ -2467,14 +2468,14 @@ static irqreturn_t rvu_flr_intr_handler(int irq, void *rvu_irq)
 
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		if (intr & (1ULL << pf)) {
-			/* PF is already dead do only AF related operations */
-			queue_work(rvu->flr_wq, &rvu->flr_wrk[pf].work);
 			/* clear interrupt */
 			rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFFLR_INT,
 				    BIT_ULL(pf));
 			/* Disable the interrupt */
 			rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFFLR_INT_ENA_W1C,
 				    BIT_ULL(pf));
+			/* PF is already dead do only AF related operations */
+			queue_work(rvu->flr_wq, &rvu->flr_wrk[pf].work);
 		}
 	}
 
-- 
2.17.1

