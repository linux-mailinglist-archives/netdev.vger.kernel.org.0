Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C491119394D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgCZHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:08:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60050 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727639AbgCZHIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:08:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q70cnn019549;
        Thu, 26 Mar 2020 00:08:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zM4RrSO2DvizfKXmC6pIIS8Jn6nIkU2uKlXMEB2FSnE=;
 b=J7H0ziHguX2rEveQCvf3lEFoAhPqfW1kC2OSBBfkE3Y8EaBEPyvQKOKlKKjkrHmXUUvs
 0/F6yfEYlTs88WAceC8r/TEFZxC0YImByRK2t6REaEy5bN0NClK6GujhSpnbm96H2xvt
 TWhE03OXL9Y1WoBhTVE8CbvUB+64miEbzsW7SM6qTkUk6SDhe9zMmrm0003MxTo8UDmS
 0AZribbd0ZFtIymTL14icW8fLfKLaMDWJi6YbX+wemGI2ITXXzFHTyaTkG0F+hEcoVQe
 hJkMJATx+2QHRpxU5+DUH5zxa7nwbPOvGzh1FC1AXN8l7qcGX1gszIEsAr5ejs096VT1 3w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nv951-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:21 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:19 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7D6BA3F703F;
        Thu, 26 Mar 2020 00:08:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q78Jsp025544;
        Thu, 26 Mar 2020 00:08:19 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q78JCY025543;
        Thu, 26 Mar 2020 00:08:19 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 4/8] qedf: Implement callback for bw_update.
Date:   Thu, 26 Mar 2020 00:08:02 -0700
Message-ID: <20200326070806.25493-5-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200326070806.25493-1-skashyap@marvell.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
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

