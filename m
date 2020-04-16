Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06D1ABC22
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503101AbgDPJEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:04:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51202 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502734AbgDPIos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:44:48 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03G8dtsA020184;
        Thu, 16 Apr 2020 01:43:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=BngFCdsi668MTGoNPxKvkeBU12eJulG2ylUtX0dNcf4=;
 b=h8VF1F/1ccJj1C+5nNDit9eU3UXoYJnA/KRFQ5iVAY00+rXu6J5V/AQ+4QREJ0rBOP5t
 xTwjMWOoX2+DS4xMePpEuu7Fwnwh9Uy5f2wLOjwAAlatd6oMHvi6l0Rs2pf8+tcbwv8M
 Y47gkhFOXLyQjh6QHbSZPVmld8OX/+LyGf4WZJgGhFG+WcVC4s3M9bPkFu/sQckp3QqB
 oiKryfA5JogjOFmkYNbYpZjb6J2v60hRPiDWVN6nKDQ/l1pU2QSVb9MoWejg2wImsRgn
 BYXon/BWHwDhXOHl3DH/oT6SSxwwz/kZiS/E7w8cchsfwFym8wUeMzPhr4zVhyoKNvE8 aA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30dn84p7r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Apr 2020 01:43:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Apr
 2020 01:43:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Apr 2020 01:43:33 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7D0093F703F;
        Thu, 16 Apr 2020 01:43:33 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03G8hXQg018910;
        Thu, 16 Apr 2020 01:43:33 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03G8hX4O018909;
        Thu, 16 Apr 2020 01:43:33 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 6/9] qedf: Implement callback for bw_update.
Date:   Thu, 16 Apr 2020 01:43:11 -0700
Message-ID: <20200416084314.18851-7-skashyap@marvell.com>
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

Add support for the common qed bw_update callback to qedf.  This
function is called whenever there is a reported change in the
bandwidth and update corresponding values in sysfs.

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

