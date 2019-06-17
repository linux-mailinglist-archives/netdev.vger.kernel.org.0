Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518974812E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFQLqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:46:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41042 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfFQLqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:46:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HBk71Y000500;
        Mon, 17 Jun 2019 04:46:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=u6LYQ9NBiVbUao/MH9k4OE+YXNOMLKhQak073Le/PxY=;
 b=QlB5V8ovajKe5XXhxHmtEnmwF2uz5yzKb86g7su2HvFuFVNNQFclOCGkcTrBbZDT/08I
 a3dn0e5gyASslVUPukdP6PWQs2wVry6tcGq4F2j++QoL7xyHMSOVxYsSX0kucDw7eABI
 Bk1gI3PLj49U/56OLWT6O8fNmWu/qNoVmID/fXtuc2p0sRRyiNjynIHaSbJPqI89gfSF
 0FwyTI01OTv3tPXvCRgRQwDvq7BLc/7pHQw+XAZ0jcqpinjpCvvHlNJhqR1+glbY8eBB
 TTjdATwbPtsrgASUsUQYaEdLp8lOZ53GApsWpPbz5IWvKFSjVSgB2G5/RcDbTxL9T8f1 Ng== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t506hxdr7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 04:46:06 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 04:46:02 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 17 Jun 2019 04:46:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5470C3F703F;
        Mon, 17 Jun 2019 04:46:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x5HBk2sr017139;
        Mon, 17 Jun 2019 04:46:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x5HBk2Mx017138;
        Mon, 17 Jun 2019 04:46:02 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 2/4] qed: Perform devlink registration after the hardware init.
Date:   Mon, 17 Jun 2019 04:45:26 -0700
Message-ID: <20190617114528.17086-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190617114528.17086-1-skalluru@marvell.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink callbacks need access to device resources such as ptt lock, hence
performing the devlink registration after the device initialization.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 829dd60..fdd84f5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -472,22 +472,24 @@ static struct qed_dev *qed_probe(struct pci_dev *pdev,
 	}
 	DP_INFO(cdev, "PCI init completed successfully\n");
 
-	rc = qed_devlink_register(cdev);
+	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
 	if (rc) {
-		DP_INFO(cdev, "Failed to register devlink.\n");
+		DP_ERR(cdev, "hw prepare failed\n");
 		goto err2;
 	}
 
-	rc = qed_hw_prepare(cdev, QED_PCI_DEFAULT);
+	rc = qed_devlink_register(cdev);
 	if (rc) {
-		DP_ERR(cdev, "hw prepare failed\n");
-		goto err2;
+		DP_INFO(cdev, "Failed to register devlink.\n");
+		goto err3;
 	}
 
 	DP_INFO(cdev, "qed_probe completed successfully\n");
 
 	return cdev;
 
+err3:
+	qed_hw_remove(cdev);
 err2:
 	qed_free_pci(cdev);
 err1:
@@ -501,14 +503,14 @@ static void qed_remove(struct qed_dev *cdev)
 	if (!cdev)
 		return;
 
+	qed_devlink_unregister(cdev);
+
 	qed_hw_remove(cdev);
 
 	qed_free_pci(cdev);
 
 	qed_set_power_state(cdev, PCI_D3hot);
 
-	qed_devlink_unregister(cdev);
-
 	qed_free_cdev(cdev);
 }
 
-- 
1.8.3.1

