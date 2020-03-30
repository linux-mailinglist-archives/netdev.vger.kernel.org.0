Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B064719748C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgC3Gav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 02:30:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729188AbgC3Gau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 02:30:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U6P7DR016701;
        Sun, 29 Mar 2020 23:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zM4RrSO2DvizfKXmC6pIIS8Jn6nIkU2uKlXMEB2FSnE=;
 b=HHQxTyaTd/Y19/ZaVeN6hdXVFjuq/iMfCqXK+wO7jmzFEQDatZtJg5d+u0hxSpAqE3Mj
 PHEpRNFmSFtdlIA/3GoZy5d5NFZLLn6bl627197gjjq46wZh9e8tBAcS0SNsY74hFNOn
 76M6xR4lem3nKNyWE52VHYrnyStu1L3vSOGC5sWRXlefiHY7Ch+sLjEDC9p0+vLmwVPT
 opAOf4QLdGYrIf5TTp2xTp9b5MhVDDUA09u8kkHokocour4Bk50Afw6iHF3tObZa8+5s
 GpLEWGQjpS1CNfqppXOvD7hbQUEkUspNyDCvtw8jYWkjZ0fEPkSgA6+xo0ksk8itP5yf Kg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xnwdab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 29 Mar 2020 23:30:49 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Mar
 2020 23:30:47 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 29 Mar 2020 23:30:47 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B7BF03F703F;
        Sun, 29 Mar 2020 23:30:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02U6UlF3027360;
        Sun, 29 Mar 2020 23:30:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02U6UlZi027359;
        Sun, 29 Mar 2020 23:30:47 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 4/8] qedf: Implement callback for bw_update.
Date:   Sun, 29 Mar 2020 23:30:30 -0700
Message-ID: <20200330063034.27309-5-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is extension of bw common callback provided by qed.
This is called whenever there is a change in the BW.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ee468102..ba66216 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -509,6 +509,32 @@ static void qedf_update_link_speed(struct qedf_ctx *qedf,
 	fc_host_supported_speeds(lport->host) = lport->link_supported_speeds;
 }
 
+static void qedf_bw_update(void *dev)
+{
+	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
+	struct qed_link_output link;
+
+	/* Get the latest status of the link */
+	qed_ops->common->get_link(qedf->cdev, &link);
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Ignore link update, driver getting unload.\n");
+		return;
+	}
+
+	if (link.link_up) {
+		if (atomic_read(&qedf->link_state) == QEDF_LINK_UP)
+			qedf_update_link_speed(qedf, &link);
+		else
+			QEDF_ERR(&qedf->dbg_ctx,
+				 "Ignore bw update, link is down.\n");
+
+	} else {
+		QEDF_ERR(&qedf->dbg_ctx, "link_up is not set.\n");
+	}
+}
+
 static void qedf_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedf_ctx *qedf = (struct qedf_ctx *)dev;
@@ -635,6 +661,7 @@ static u32 qedf_get_login_failures(void *cookie)
 static struct qed_fcoe_cb_ops qedf_cb_ops = {
 	{
 		.link_update = qedf_link_update,
+		.bw_update = qedf_bw_update,
 		.dcbx_aen = qedf_dcbx_handler,
 		.get_generic_tlv_data = qedf_get_generic_tlv_data,
 		.get_protocol_tlv_data = qedf_get_protocol_tlv_data,
-- 
1.8.3.1

