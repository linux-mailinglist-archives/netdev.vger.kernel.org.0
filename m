Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868D6231D7F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgG2LjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbgG2LjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBaFn4011902;
        Wed, 29 Jul 2020 04:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=DRbX0jdvS/g8oFKCNZp3eRZWyWyqZIXu//SCoonUakg=;
 b=PvYa+JwF24HzotjtukYTrNgzOlCBgbxwbH9JE5z/UZE83EzJuSApnnO2CW7cfEsNW8H5
 URD+X25j5hPCFm1mbW8pTxGo4DkqmH6Ax0LhujOQ9/wSftIv+8r1jWkg/GX79UK3HKVY
 ML2uJNVLOP6fjRPLnTOUcP98Y283cpaDq6CMSgRobt2KLCb45Yc/KJPXOJP2cQZCfleP
 w6lqVXiUeDa3Z5X41hnGk9/snq8O5RNGexM80fhAtS65rh9PsOq+EnyTaer8B2+1LjTm
 5mEgJkCLKRHMV+td2IPKYv1VR6Zz/cu1yaY4muzA67JYBvqi7JGBjUoPBx85Rfblu6nq Wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0su3rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:13 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 334C43F703F;
        Wed, 29 Jul 2020 04:39:10 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 07/11] qed: use devlink logic to report errors
Date:   Wed, 29 Jul 2020 14:38:42 +0300
Message-ID: <20200729113846.1551-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729113846.1551-1-irusskikh@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devlink_health_report to push error indications.
We implement this in qede via callback function to make it possible
to reuse the same for other drivers sitting on top of qed in future.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 17 +++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
 drivers/net/ethernet/qlogic/qede/qede.h       |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  5 ++++-
 include/linux/qed/qed_if.h                    |  3 +++
 6 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 843a35f14cca..ffe776a4f99a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -14,6 +14,23 @@ enum qed_devlink_param_id {
 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
 };
 
+struct qed_fw_fatal_ctx {
+	enum qed_hw_err_type err_type;
+};
+
+int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_type)
+{
+	struct qed_devlink *qdl = devlink_priv(devlink);
+	struct qed_fw_fatal_ctx fw_fatal_ctx = {
+		.err_type = err_type,
+	};
+
+	devlink_health_report(qdl->fw_reporter,
+			      "Fatal error reported", &fw_fatal_ctx);
+
+	return 0;
+}
+
 static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
 		.name = "fw_fatal",
 };
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
index c68ecf778826..ccc7d1d1bfd4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
@@ -15,4 +15,6 @@ void qed_devlink_unregister(struct devlink *devlink);
 void qed_fw_reporters_create(struct devlink *devlink);
 void qed_fw_reporters_destroy(struct devlink *devlink);
 
+int qed_report_fatal_error(struct devlink *dl, enum qed_hw_err_type err_type);
+
 #endif
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index d1a559ccf516..a64d594f9294 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -3007,6 +3007,7 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.update_msglvl = &qed_init_dp,
 	.devlink_register = qed_devlink_register,
 	.devlink_unregister = qed_devlink_unregister,
+	.report_fatal_error = qed_report_fatal_error,
 	.dbg_all_data = &qed_dbg_all_data,
 	.dbg_all_data_size = &qed_dbg_all_data_size,
 	.chain_alloc = &qed_chain_alloc,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 1f0e7505a973..3efc5899f656 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -264,6 +264,7 @@ struct qede_dev {
 
 	struct bpf_prog			*xdp_prog;
 
+	enum qed_hw_err_type		last_err_type;
 	unsigned long			err_flags;
 #define QEDE_ERR_IS_HANDLED		31
 #define QEDE_ERR_ATTN_CLR_EN		0
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 7c2d948b2035..df437c3f1fc9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1181,7 +1181,6 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 		}
 	} else {
 		struct net_device *ndev = pci_get_drvdata(pdev);
-
 		edev = netdev_priv(ndev);
 
 		if (edev && edev->devlink) {
@@ -2603,6 +2602,9 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
 		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
 		  edev->err_flags);
 
+	if (edev->devlink)
+		edev->ops->common->report_fatal_error(edev->devlink, edev->last_err_type);
+
 	/* Trigger a recovery process.
 	 * This is placed in the sleep requiring section just to make
 	 * sure it is the last one, and that all the other operations
@@ -2663,6 +2665,7 @@ static void qede_schedule_hw_err_handler(void *dev,
 		return;
 	}
 
+	edev->last_err_type = err_type;
 	qede_set_hw_err_flags(edev, err_type);
 	qede_atomic_hw_err_handler(edev);
 	set_bit(QEDE_SP_HW_ERR, &edev->sp_flags);
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 30fe06fe06a0..1297726f2b25 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -906,6 +906,9 @@ struct qed_common_ops {
 
 	int (*dbg_all_data_size) (struct qed_dev *cdev);
 
+	int		(*report_fatal_error)(struct devlink *devlink,
+					      enum qed_hw_err_type err_type);
+
 /**
  * @brief can_link_change - can the instance change the link or not
  *
-- 
2.17.1

