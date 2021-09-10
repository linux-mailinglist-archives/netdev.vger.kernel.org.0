Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19146406889
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 10:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhIJIfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 04:35:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231665AbhIJIfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 04:35:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189LjU7P008811;
        Fri, 10 Sep 2021 01:34:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=FIkKEavo0r4oFY3NDcayZR5Y2OmVqPONmxSIy6vp0Bs=;
 b=jBn+M2YyGdXfLFqV7/9W2XhtN+YCFd48nvD/cJ8U2FE6XwzasjtI4PhKdRXtqWiwLmtO
 Dae0LONRs25jDud1hac66KTx/oASrSOh4jEXrrSOZacNEnjf/C1X+K3akDu9gTmsO/Hh
 qSWjE8o/BFVf/d92OvVZ1lCaCF6yGMh6yGbs6833xxHlZNSeXvecK1wsbpSPBrZmVFbp
 /CoTxOXbe5pPShJ+vwpwTZ90q64bLvpbvgQuGYDk8ZrPDfLcKdKlEp9pynj2Valova7M
 JVyd8YOZgWAL9/NwwRNfp+jEVTKVb8z6D9yo3jegVcwNv0xkdil87XX0GFxncZGIAoDx WA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3aytf5squ0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 10 Sep 2021 01:34:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 10 Sep
 2021 01:34:14 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Fri, 10 Sep 2021 01:34:12 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH net v2] qed: Handle management FW error
Date:   Fri, 10 Sep 2021 11:33:56 +0300
Message-ID: <20210910083356.17046-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yjZ1H6xBMbLILmtIsUiZ0iTbBn9inrFG
X-Proofpoint-GUID: yjZ1H6xBMbLILmtIsUiZ0iTbBn9inrFG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-10_02,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle MFW (management FW) error response in order to avoid a crash
during recovery flows.

Changes from v1:
- Add "Fixes tag".

Fixes: tag 5e7ba042fd05 ("qed: Fix reading stale configuration information")
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 6e5a6cc97d0e..24cd41567775 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3367,6 +3367,7 @@ qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 			  struct qed_nvm_image_att *p_image_att)
 {
 	enum nvm_image_type type;
+	int rc;
 	u32 i;
 
 	/* Translate image_id into MFW definitions */
@@ -3395,7 +3396,10 @@ qed_mcp_get_nvm_image_att(struct qed_hwfn *p_hwfn,
 		return -EINVAL;
 	}
 
-	qed_mcp_nvm_info_populate(p_hwfn);
+	rc = qed_mcp_nvm_info_populate(p_hwfn);
+	if (rc)
+		return rc;
+
 	for (i = 0; i < p_hwfn->nvm_info.num_images; i++)
 		if (type == p_hwfn->nvm_info.image_att[i].image_type)
 			break;
-- 
2.22.0

