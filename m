Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D5824ED12
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHWLUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727013AbgHWLUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBFEgI016559;
        Sun, 23 Aug 2020 04:20:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qiflMdxUJZ/3dPdwkAiIYPQrWKAr+RYGObIOGumsWX4=;
 b=UMNnT6/Iqs+aoog4GIrc+euPjhJ94T4+JlCHADWZZeBKu8mYE+cQ8wEYp4KI6cGtQjaD
 b9P5vauss/H+voAQaVZxaxQVCHGPW24cB7QoDiq1tBGFvFb/XtJfYLGQ+mlUwwuISiuL
 3C5XysdTlQSUxglixj3LssmZT8pKTRxn7T3PIyYvDl515UVelP/LSaYmchK9QO2TfWl5
 Qf2WUeRMh0cLz3ljx/7+IbRA+O0uPEvLTjzw0diwhIZh4wQ3otkCtDcu0Zcrf/aPacaN
 Ixg1GwaRLm/Md39I30dAc9/yKi4eougLIYkd9NekU97LnZ9KrqDLsqn8KhWfF/XwuHrl iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmjw91-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:24 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7140B3F7045;
        Sun, 23 Aug 2020 04:20:21 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v7 net-next 08/10] qed: implement devlink dump
Date:   Sun, 23 Aug 2020 14:19:32 +0300
Message-ID: <20200823111934.305-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200823111934.305-1-irusskikh@marvell.com>
References: <20200823111934.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_14:2020-08-21,2020-08-22 signatures=0
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
index bc4e40f135ff..cf7f4da68e69 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/qed/qed_if.h>
+#include <linux/vmalloc.h>
 #include "qed.h"
 #include "qed_devlink.h"
 
@@ -32,6 +33,47 @@ int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_typ
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
@@ -48,6 +90,7 @@ qed_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
 		.name = "fw_fatal",
 		.recover = qed_fw_fatal_reporter_recover,
+		.dump = qed_fw_fatal_reporter_dump,
 };
 
 #define QED_REPORTER_FW_GRACEFUL_PERIOD 1200000
-- 
2.17.1

