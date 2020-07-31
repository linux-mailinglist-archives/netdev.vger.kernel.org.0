Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29753233ED6
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 07:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgGaFyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 01:54:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731301AbgGaFyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 01:54:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V5k4Fi029977;
        Thu, 30 Jul 2020 22:54:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=n+4M4uewPDaA8FzuNnayjSvVbsQtpuyRcTAyxw8FdIM=;
 b=TKUqeJX7XTaPh6ke6rYOkOKLyofVBd5NsCgdHYAkOSMSog6ORZkTpYndBFxYIU7kuKt1
 NZl4d6yp9y1RPTq2uED5k/2an1ztBUhe9UMfOO0sTDxIkeyaii9GvlfLIym6tIvayd0Y
 Vv7Ceh6TvuQbfqEaWauuDjg4CiqlU/jWvzinr3824hNUkkoUkIBNXT6mgwSBla760raE
 m3UcnZDtc5J/KOGZuUDOeaWwmdeuXTZcy64JBopXz9yzYkWRM+Tg0+gAAAjnzhAJka1X
 FiYVQ/1+2JraKF/KyashXm/ymkHtBS1nPxdW2u14bGD0bgfrPejPetSHdVRFluDDOe2C TQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r9dq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 22:54:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 22:54:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 22:54:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Jul 2020 22:54:33 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 4F8503F703F;
        Thu, 30 Jul 2020 22:54:30 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v4 net-next 08/10] qed: implement devlink dump
Date:   Fri, 31 Jul 2020 08:53:59 +0300
Message-ID: <20200731055401.940-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731055401.940-1-irusskikh@marvell.com>
References: <20200731055401.940-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_01:2020-07-30,2020-07-31 signatures=0
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
index 1cf2199a3124..4f6b1928edaf 100644
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

