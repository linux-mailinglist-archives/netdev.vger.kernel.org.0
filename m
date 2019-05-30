Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C144E2FB81
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfE3MWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:22:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726065AbfE3MWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 08:22:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UCC5tr005329;
        Thu, 30 May 2019 05:22:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=JxYfBNGGK53E+keDIHMpdRTCmkxtL92RYhljHjJRWQY=;
 b=MWkpoo8y7EBQJO1gdojiE/pqEes2bXfg3f8lgb06araCUWahKxNihFcO2Wlzpk9SoPBe
 7jm/3exqkF8F/xt9fG85KgOj4/HzOkkXCnl2wZG7LUoeQlQTPTYUcT8uIxIPhpu3MhZA
 HxU2rqHWFVcp0SUhpemc7hGOkMNWNNJMlQyV+DD59XitP9+cfM5CQNb5sYrwV3YvIQkC
 TmgtjWWF1tXDSmLWvQy2wugMosmsfWPIroXh31Qfy04cUM+wmxEec3TGzY94tO3MxeC+
 jQhKpAQ5FhUl3GM/n9llb9MF5y1wj7LmtDVTyn4EdZls6HVv22ZeDvAZ+EKmGKfVdtaE VQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2st448ad5s-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 05:22:35 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 30 May
 2019 05:21:45 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 30 May 2019 05:21:45 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 3C6CB3F703F;
        Thu, 30 May 2019 05:21:44 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dan.carpenter@oracle.com>
Subject: [PATCH net-next] qed: Fix static checker warning
Date:   Thu, 30 May 2019 15:20:40 +0300
Message-ID: <20190530122040.19842-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases abs_ppfid could be printed without being initialized.

Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for offload protocols")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index a971418755e9..eec7cb65c7e6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1138,12 +1138,12 @@ qed_llh_add_protocol_filter(struct qed_dev *cdev,
 	if (rc)
 		goto err;
 
+	rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+	if (rc)
+		goto err;
+
 	/* Configure the LLH only in case of a new the filter */
 	if (ref_cnt == 1) {
-		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
-		if (rc)
-			goto err;
-
 		rc = qed_llh_protocol_filter_to_hilo(cdev, type,
 						     source_port_or_eth_type,
 						     dest_port, &high, &low);
@@ -1195,12 +1195,12 @@ void qed_llh_remove_mac_filter(struct qed_dev *cdev,
 	if (rc)
 		goto err;
 
+	rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+	if (rc)
+		goto err;
+
 	/* Remove from the LLH in case the filter is not in use */
 	if (!ref_cnt) {
-		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
-		if (rc)
-			goto err;
-
 		rc = qed_llh_remove_filter(p_hwfn, p_ptt, abs_ppfid,
 					   filter_idx);
 		if (rc)
@@ -1253,12 +1253,12 @@ void qed_llh_remove_protocol_filter(struct qed_dev *cdev,
 	if (rc)
 		goto err;
 
+	rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
+	if (rc)
+		goto err;
+
 	/* Remove from the LLH in case the filter is not in use */
 	if (!ref_cnt) {
-		rc = qed_llh_abs_ppfid(cdev, ppfid, &abs_ppfid);
-		if (rc)
-			goto err;
-
 		rc = qed_llh_remove_filter(p_hwfn, p_ptt, abs_ppfid,
 					   filter_idx);
 		if (rc)
-- 
2.20.1

