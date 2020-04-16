Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08BB1ABC1D
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502998AbgDPJE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:04:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27850 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502769AbgDPIou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8dtsD020184;
        Thu, 16 Apr 2020 01:43:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=RsMZzWEe15RgqHqAwHvHuBYjDy6BZByaXxfi4czSNNA=;
 b=QfVhdw0NKvaFEvI79mgo0glFERlx1j/ZH+OOGfQX9PcxDHFUDzZCjREwjJRkBPBFt8sW
 w/uSaLEo2NqnPxd6hlWFLpDoytii2BIvvm8dhE++BlgVwSxg3np9rBxPPs6NcLGGcGnN
 Y2ndiVODmqnDqM3a9gjofCZcSxa1Xq2igsEGlk2YzREtUh/NWuVHcSvv/jyJJXX4czmi
 csX7ZPH49G67QHD+hRAgG7Gt+tLBC+rfI8xwEx0EnUNICDMe2i1kdxnDT8F4gn18/Z9V
 4YGBdU0CG+XyVolU8FlVOx7jQntQjfnKCVktI/68+XmzAflTbZ6K9Xu+gthZYFEvHsgQ aA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:43 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 10F9E3F7040;
        Thu, 16 Apr 2020 01:43:43 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hg2f018922;
        Thu, 16 Apr 2020 01:43:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hglg018921;
        Thu, 16 Apr 2020 01:43:42 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 9/9] qedf: Get dev info after updating the params.
Date:   Thu, 16 Apr 2020 01:43:14 -0700
Message-ID: <20200416084314.18851-10-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200416084314.18851-1-skashyap@marvell.com>
References: <20200416084314.18851-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_03:2020-04-14,2020-04-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An update to pf params can change the devinfo, get
an updated device information.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 52673b4..dc5ac55 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3332,6 +3332,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	}
 	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
 
+	/* Learn information crucial for qedf to progress */
+	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
+	if (rc) {
+		QEDF_ERR(&qedf->dbg_ctx, "Failed to dev info.\n");
+		goto err2;
+	}
+
 	/* Record BDQ producer doorbell addresses */
 	qedf->bdq_primary_prod = qedf->dev_info.primary_dbq_rq_addr;
 	qedf->bdq_secondary_prod = qedf->dev_info.secondary_bdq_rq_addr;
-- 
1.8.3.1

