Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353D11ABC43
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503469AbgDPJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:10:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8378 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502732AbgDPIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8e3Eu020307;
        Thu, 16 Apr 2020 01:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=QLdcEkyQglP3Ab6yjllvArNRYXHdiYvwHvoMy2go6vA=;
 b=vReO1hvQuOWAjZX4id7P3Xq4g6TmBEVdBpGd4LrvOdS6zknHkRPNdMP4tG1wpAChg1n7
 kOIGU2VM8VolZgwRVfDF0SLKuctmTncpSt9Mbkc3eO0USN6h0ZNQjbssvSo4TcwMbNtK
 d7syYm8TsLo/qvOeY6MvecmNmH5qJuMiolg51cJa+N6LrNpYiZoXQ/1++WLC6tW2d56o
 CBjKsB9fWCU5wpvnnTfXsKnHtlYeOuqF3N22UwpAgugJwH+Xr7us13PjfwJhBI9yeYHZ
 vH7RZSd7BNWpgRb83AJS6FirmkZ9zqFkDQeA2a9McX1PsWEWkLg24hhg3ILeDdXnFtKP jw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:26 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:24 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EEF153F703F;
        Thu, 16 Apr 2020 01:43:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hNrj018898;
        Thu, 16 Apr 2020 01:43:23 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hNB5018897;
        Thu, 16 Apr 2020 01:43:23 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 3/9] qedf: Acquire rport_lock for resetting the delay_timestamp
Date:   Thu, 16 Apr 2020 01:43:08 -0700
Message-ID: <20200416084314.18851-4-skashyap@marvell.com>
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

From: Javed Hasan <jhasan@marvell.com>

retry delay timestamp is updated in queuecommand as well
qedf_scsi_completion routine, protect it using lock.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index e749a2d..64c1769 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1021,14 +1021,18 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)
 	atomic_inc(&fcport->ios_to_queue);
 
 	if (fcport->retry_delay_timestamp) {
+		/* Take fcport->rport_lock for resetting the delay_timestamp */
+		spin_lock_irqsave(&fcport->rport_lock, flags);
 		if (time_after(jiffies, fcport->retry_delay_timestamp)) {
 			fcport->retry_delay_timestamp = 0;
 		} else {
+			spin_unlock_irqrestore(&fcport->rport_lock, flags);
 			/* If retry_delay timer is active, flow off the ML */
 			rc = SCSI_MLQUEUE_TARGET_BUSY;
 			atomic_dec(&fcport->ios_to_queue);
 			goto exit_qcmd;
 		}
+		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 	}
 
 	io_req = qedf_alloc_cmd(fcport, QEDF_SCSI_CMD);
-- 
1.8.3.1

