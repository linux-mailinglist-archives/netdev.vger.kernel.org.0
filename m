Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B5848056E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 01:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhL1A5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 19:57:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25026 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230423AbhL1A5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 19:57:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BRI8xBY021958;
        Mon, 27 Dec 2021 16:57:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=X5NsQZav2d8wen4c9lzEoLTEFjg3MBPcUaL6A3f31g0=;
 b=aGq9dskywFM0RcCErWFDmvbZel4p8bqSQlqk5pMwG9ijC9lAocr0XvvwN+8Jt7wPkq/s
 ohF63jaN1DLWO+m/aPSrYQdxpaECACtM6V5GQS3fYLErO3iVHtiL/DoY5pJmwviIq2b0
 1hjfMPMmXTZOcP/BYrmXkMIOrAvLgjYaS5T1ahI0iO0NeDc6HaWBV5T49c2oq1GdfhXB
 TqzgSrd5NxFPg/lz3TM1KA/QnJ1wdqzMutdr4iISDBGPfOLblMApdUtBNMijIaybOtSQ
 1tmIKRaAcHRu+MFP4k6r7pVOVaWiDvmIHeVa1/gt0r497zTcWpnu2caZtr6PNDqNs2zh Dg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d7jgsgwgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:57:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Dec
 2021 16:57:49 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 27 Dec 2021 16:57:48 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: [PATCH net-next v2 1/1] qed: add prints if request_firmware() failed
Date:   Mon, 27 Dec 2021 09:56:56 -0800
Message-ID: <20211227175656.267184-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QHnJuo6VesoHWD8Og8xIpAKUNEKUq3Ck
X-Proofpoint-GUID: QHnJuo6VesoHWD8Og8xIpAKUNEKUq3Ck
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_10,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If driver load failed due to request_firmware() not finding the device
firmware file, add prints that help remedy the situation.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
---
Changes in v2:
 - Rename QED_FW_REPO to FW_REPO
 - Move FW_REPO macro to qed_if.h
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 3 +++
 include/linux/qed/qed_if.h                 | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 46d4207f22a3..845c151c5def 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1285,6 +1285,9 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 			DP_NOTICE(cdev,
 				  "Failed to find fw file - /lib/firmware/%s\n",
 				  QED_FW_FILE_NAME);
+			DP_NOTICE(cdev,
+				  "you may need to download firmware from %s",
+				  FW_REPO);
 			goto err;
 		}
 
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 6dc4943d8aec..f063d82ef8f9 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1210,6 +1210,9 @@ struct qed_common_ops {
 	int (*get_esl_status)(struct qed_dev *cdev, bool *esl_active);
 };
 
+#define FW_REPO		\
+	"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"
+
 #define MASK_FIELD(_name, _value) \
 	((_value) &= (_name ## _MASK))
 
-- 
2.27.0

