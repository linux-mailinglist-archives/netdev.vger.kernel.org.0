Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FBC3EAB6E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhHLUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 16:00:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230171AbhHLUAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 16:00:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CJuIgO010617;
        Thu, 12 Aug 2021 12:59:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=g8C2U/dpY/zxFFix2/XEunLn7hAYHlRcOoG1DkXP9sQ=;
 b=PQSG9lD4QEQyVGXnyxpp0ogzoCXdxV8Nbt5QbJmPuNUFkMVARDPrF6k842ZVSw/SDAkk
 1BvYnwO3o3Z+bdobseJzcKsPTcYGC8+ZaJ+1Z40pvEGd6MAp8pjfdYky9GsKJifnZj9R
 KM675tO0QPe+CJKD3ayPRgbi95n+7AtJUKXva7pr32F+D43KScFVWAr261xg3vLORNo2
 BMEenb0CgtiGqSXEtJrC8JeSjSGPv9fi7nFKxqjiFdHei5NhRo6w7Z846cwtLQJZ5Er1
 iXV8+FMzNNC4V7j3zqZaV5XaC8sbdlTeeSnkk+jM/n3IPQwBHSx+xndeoPEJJqe+gcNP hw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ad8x9g8vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 12:59:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 12 Aug
 2021 12:59:51 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Thu, 12 Aug 2021 12:59:49 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <islituo@gmail.com>, <aelior@marvell.com>, <smalin@marvell.com>,
        <malin1024@gmail.com>
Subject: [PATCH] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Thu, 12 Aug 2021 22:58:51 +0300
Message-ID: <20210812195851.9258-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: XKPPu2knsymjmMuGf0kBo4asa1wAvkEr
X-Proofpoint-ORIG-GUID: XKPPu2knsymjmMuGf0kBo4asa1wAvkEr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_06:2021-08-12,2021-08-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a possible null-pointer dereference in qed_rdma_create_qp().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index da864d12916b..8b401c5e8289 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -33,7 +33,6 @@
 #include "qed_roce.h"
 #include "qed_sp.h"
 
-
 int qed_rdma_bmap_alloc(struct qed_hwfn *p_hwfn,
 			struct qed_bmap *bmap, u32 max_count, char *name)
 {
@@ -1285,8 +1284,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
 	if (!rdma_cxt || !in_params || !out_params ||
 	    !p_hwfn->p_rdma_info->active) {
-		DP_ERR(p_hwfn->cdev,
-		       "qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
+		pr_err("qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
 		       rdma_cxt, in_params, out_params);
 		return NULL;
 	}
@@ -1904,7 +1902,6 @@ void qed_rdma_dpm_conf(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		   val, p_hwfn->dcbx_no_edpm, p_hwfn->db_bar_no_edpm);
 }
 
-
 void qed_rdma_dpm_bar(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	p_hwfn->db_bar_no_edpm = true;
-- 
2.22.0

