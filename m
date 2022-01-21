Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C334959F9
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378714AbiAUGfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8380 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbiAUGfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05k3K029271;
        Thu, 20 Jan 2022 22:35:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dZ7dHLKK5foc0klWv+rqHx1BWYUYNUzn5rnrRMxbHcw=;
 b=dgHgIrBicyGxv8C5WXhaZMNjd+E5cKA8DaNFQDGkG5obLalyFf1hLIV1KlITJKWo0sNX
 vbBmJOkCFZtfxOt9jk7qcjBhePASJDNCeIkrtrdixrMN/RXmazlMNlrYsRm5Jy9XM6HA
 iID1XgRh62Pkqn3YcVxfygwTED27kIDtkImUPSA3/W94E8EgQc8km8Wktu3WKRxsTZE7
 SSjqmhqdaSp/WCkcxatvWcEv58/pOMlgztFK4bOLbQm955nGx2Ntphy9ZWYZyjwCemN0
 gEc7IHxPCi8EJVzaTcMhrSVeCAf35UrCJzCWPAZvmxmCB0f60Wj2gH59GU/0Q96gmtxA lw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Jan
 2022 22:35:03 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:03 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 8D2FD3F7060;
        Thu, 20 Jan 2022 22:35:00 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 3/9] octeontx2-af: Retry until RVU block reset complete
Date:   Fri, 21 Jan 2022 12:04:41 +0530
Message-ID: <1642746887-30924-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: xgq31PXMExfb2OGKEbg-cWJF0FWGCejT
X-Proofpoint-ORIG-GUID: xgq31PXMExfb2OGKEbg-cWJF0FWGCejT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Few RVU blocks like SSO require more time for reset on some
silicons. Hence retrying the block reset until success.

Fixes: c0fa2cff8822c ("octeontx2-af: Handle return value in block reset")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3ca6b94..54e1b27 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -520,8 +520,11 @@ static void rvu_block_reset(struct rvu *rvu, int blkaddr, u64 rst_reg)
 
 	rvu_write64(rvu, blkaddr, rst_reg, BIT_ULL(0));
 	err = rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true);
-	if (err)
-		dev_err(rvu->dev, "HW block:%d reset failed\n", blkaddr);
+	if (err) {
+		dev_err(rvu->dev, "HW block:%d reset timeout retrying again\n", blkaddr);
+		while (rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true) == -EBUSY)
+			;
+	}
 }
 
 static void rvu_reset_all_blocks(struct rvu *rvu)
-- 
2.7.4

