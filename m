Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311CD3EC8AD
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 13:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhHOLH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 07:07:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36540 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhHOLHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 07:07:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17FAgNZq013071;
        Sun, 15 Aug 2021 04:06:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=fMjOoGyQpUpwgbcHNEJuGO86emdOD66H1BdhYG06hGc=;
 b=iQDIsNl3dmXw0Z3POH1dyRlQT30VcUkYUv5px7l3GdPIl53JsAFrWe148zelQd26ekUC
 xAMe0kfRVVko1v+Y8BlqccRwaNsLy7j6C6GennXFy2+oPV3hcbF3+PpX4dRItlrE3s3z
 f1ovR6f8E1oTF/jIqIclTpA0vKBzSwadzKEUhotls4bj6cjUeaMEG0HeSFeav+33beE8
 wq9c/01L7biCT1UqB4zsipv09KjCtR9LpxDs+SpggjcDMXBrhrcr+1BrskT8teSA0bJc
 fOUa7rbZGVBO8+HAxmUx3JGYDdodsqm+T21Q0JftNLm7Pv9UFYs8OA6P3HROXSJx/Aj8 5g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3aedbkj0hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Aug 2021 04:06:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 15 Aug
 2021 04:06:50 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 15 Aug 2021 04:06:47 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <islituo@gmail.com>, <aelior@marvell.com>, <smalin@marvell.com>,
        <malin1024@gmail.com>
Subject: [PATCH v2] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Sun, 15 Aug 2021 14:06:39 +0300
Message-ID: <20210815110639.20131-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: wP4qkXd9DY0A0AHHhDPhwkaXk326D18n
X-Proofpoint-ORIG-GUID: wP4qkXd9DY0A0AHHhDPhwkaXk326D18n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-15_03,2021-08-13_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a possible null-pointer dereference in qed_rdma_create_qp().

Changes from V2:
- Revert checkpatch fixes.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index da864d12916b..4f4b79250a2b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1285,8 +1285,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
 	if (!rdma_cxt || !in_params || !out_params ||
 	    !p_hwfn->p_rdma_info->active) {
-		DP_ERR(p_hwfn->cdev,
-		       "qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
+		pr_err("qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
 		       rdma_cxt, in_params, out_params);
 		return NULL;
 	}
-- 
2.22.0

