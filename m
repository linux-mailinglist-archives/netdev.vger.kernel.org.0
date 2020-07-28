Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D267230601
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgG1I7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:59:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38688 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgG1I7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:59:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S8u66F016341;
        Tue, 28 Jul 2020 01:59:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=q7sErpGan+dcSWmQx2xW9Q9tuoS7tUNDnrEuNRYZfn4=;
 b=DiaydVBtnJt7cebKI2VxjSQakquJASdk0uR0Svis5FUCPbO3JExb8FE4JalF66MHSkx6
 FA/K8Gw9oKKxLfWP87E4BXY4LgdXkYz1I9SAKtswbr9I3+S81lf9JKfrehATATq7kqSg
 /rPgNsDR8rEu6IgS2CtsEnZUFbnSKnjWiAgE9AHNDS18BBrxB6J020odEpCwBXI9pOiI
 b3BZNYxOyWHaZC6e1AVDHdPxB+XLlhXgEIIZpVvjaX2RaEAYbQPoDg6axjJwfjdDNHl1
 mgA8h8rVTneYEo8qZ43OOv08FkMrlxlCgaa/SNR7F2rspg+H6hhoFQPXcQWRk1kVxfAD gA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32gm8njhjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 01:59:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 01:59:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jul 2020 01:59:30 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7FA403F703F;
        Tue, 28 Jul 2020 01:59:27 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 09/11] qed: implement devlink dump
Date:   Tue, 28 Jul 2020 11:58:57 +0300
Message-ID: <20200728085859.899-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728085859.899-1-irusskikh@marvell.com>
References: <20200728085859.899-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_01:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gather and push out full device dump to devlink.
Device dump is the same as with `ethtool -d`, but now its generated
exactly at the moment bad thing happens.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index b25be68f959c..904babe70489 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/qed/qed_if.h>
+#include <linux/vmalloc.h>
 #include "qed.h"
 #include "qed_devlink.h"
 
@@ -31,6 +32,47 @@ int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_typ
 	return 0;
 }
 
+static int
+qed_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
+			   struct devlink_fmsg *fmsg, void *priv_ctx,
+			   struct netlink_ext_ack *extack)
+{
+	struct qed_devlink *qdl = devlink_health_reporter_priv(reporter);
+	struct qed_fw_fatal_ctx *fw_fatal_ctx = priv_ctx;
+	struct qed_dev *cdev = qdl->cdev;
+	u32 dbg_data_buf_size;
+	u8 *p_dbg_data_buf;
+	int err;
+
+	/* Having context means that was a dump request after fatal,
+	 * so we enable extra debugging while gathering the dump,
+	 * just in case
+	 */
+	cdev->print_dbg_data = fw_fatal_ctx ? true : false;
+
+	dbg_data_buf_size = qed_dbg_all_data_size(cdev);
+	p_dbg_data_buf = vzalloc(dbg_data_buf_size);
+	if (!p_dbg_data_buf) {
+		DP_NOTICE(cdev,
+			  "Failed to allocate memory for a debug data buffer\n");
+		return -ENOMEM;
+	}
+
+	err = qed_dbg_all_data(cdev, p_dbg_data_buf);
+	if (err) {
+		DP_NOTICE(cdev, "Failed to obtain debug data\n");
+		vfree(p_dbg_data_buf);
+		return err;
+	}
+
+	err = devlink_fmsg_binary_pair_put(fmsg, "dump_data",
+					   p_dbg_data_buf, dbg_data_buf_size);
+
+	vfree(p_dbg_data_buf);
+
+	return err;
+}
+
 static int
 qed_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 			      void *priv_ctx,
@@ -47,6 +89,7 @@ qed_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
 		.name = "fw_fatal",
 		.recover = qed_fw_fatal_reporter_recover,
+		.dump = qed_fw_fatal_reporter_dump,
 };
 
 #define QED_REPORTER_FW_GRACEFUL_PERIOD 1200000
-- 
2.17.1

