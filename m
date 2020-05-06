Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43C11C6F69
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgEFLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:34:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbgEFLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:34:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BXjS0030304;
        Wed, 6 May 2020 04:34:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=DbbohlzfFt8J+otR4t4neB17NiWqGBFr5rt0+EuxgyA=;
 b=FAEj8Kef2GUFsE4nNxc3zzDU4zrepZ3uFZEzWN/9xPu4Hb7W0Arx7n7+IdppbhvJ35uY
 b4tfmMfKm+OoU1EzWl9DcyhbwzbEe7zeIQ3uBP66GoNadteGf6H53hJz/6VAAHRhuwYW
 v4sAiGsSiK4pcLtNPUuj62p/qJxdUXrC9LReI3XRpbJT6Jahe7gTS6IEuPQydCk50KMF
 TAGnEBElBzFbzkWvDyerfO8O89a3HuDDPezfltod6UofD2aQkPNSfDhSlE6I9cW8vL6X
 /TyPRr0WfSi47IDLUnkLlxHenjoJ6kQXN2HSaWf0ksCtUkO4lgEH2DnSv79uBjAcrfL1 4A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 30urytrs4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:34:07 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:34:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:34:05 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id D803E3F7041;
        Wed,  6 May 2020 04:34:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 06/12] net: qed: gather debug data on hw errors
Date:   Wed, 6 May 2020 14:33:08 +0300
Message-ID: <a380a45a885034c9b19cd1fe786854e8a65a8088.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To implement debug dump retrieval on a live system we add callbacks to
collect the same data which is collected now during manual `ethtool -d`
call.

But we instead collect the dump immediately at the moment bad thing
happens, and save it for later retrieval by the same `ethtool -d`.

To have ability to track this event, we add kobject uevent trigger,
so udev event handler script could be used to automatically collect dumps.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h        |  2 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c  | 76 ++++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_debug.h  |  1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c   |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c |  3 +
 include/linux/qed/qed_if.h                   |  1 +
 6 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 07f6ef930b52..47679e67ac48 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -876,6 +876,8 @@ struct qed_dev {
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
 
+	u8 *p_dbg_data_buf;
+	u32 dbg_data_buf_size;
 	bool print_dbg_data;
 
 	u32 rdma_max_sge;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 57a0dab88431..6c8c44052012 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7776,6 +7776,12 @@ static u32 qed_calc_regdump_header(struct qed_dev *cdev,
 	return res;
 }
 
+static void qed_dbg_all_data_free_buf(struct qed_dev *cdev)
+{
+	vfree(cdev->p_dbg_data_buf);
+	cdev->p_dbg_data_buf = NULL;
+}
+
 int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 {
 	u8 cur_engine, omit_engine = 0, org_engine;
@@ -7786,6 +7792,14 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 	u32 offset = 0, feature_size;
 	int rc;
 
+	if (cdev->p_dbg_data_buf) {
+		DP_NOTICE(cdev,
+			  "Using a debug data buffer that was previously obtained and saved\n");
+		memcpy(buffer, cdev->p_dbg_data_buf, cdev->dbg_data_buf_size);
+		qed_dbg_all_data_free_buf(cdev);
+		return 0;
+	}
+
 	for (i = 0; i < MAX_DBG_GRC_PARAMS; i++)
 		grc_params[i] = dev_data->grc.param_val[i];
 
@@ -8004,6 +8018,8 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 	u32 regs_len = 0, image_len = 0, ilt_len = 0, total_ilt_len = 0;
 	u8 cur_engine, org_engine;
 
+	if (cdev->p_dbg_data_buf)
+		return cdev->dbg_data_buf_size;
 	cdev->disable_ilt_dump = false;
 	org_engine = qed_get_debug_engine(cdev);
 	for (cur_engine = 0; cur_engine < cdev->num_hwfns; cur_engine++) {
@@ -8055,6 +8071,63 @@ int qed_dbg_all_data_size(struct qed_dev *cdev)
 	return regs_len;
 }
 
+static void qed_dbg_send_uevent(struct qed_dev *cdev, char *uevent)
+{
+	struct device *dev = &cdev->pdev->dev;
+	char bdf[64];
+	char *envp_ext[] = { bdf, NULL };
+	int rc;
+
+	snprintf(bdf, sizeof(bdf), "QED_DEBUGFS_BDF_%s=%02x:%02x.%x",
+		 uevent, cdev->pdev->bus->number, PCI_SLOT(cdev->pdev->devfn),
+		 PCI_FUNC(cdev->pdev->devfn));
+
+	rc = kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp_ext);
+	if (rc)
+		DP_NOTICE(cdev, "Failed to send uevent %s\n", uevent);
+}
+
+static int __qed_dbg_save_all_data(struct qed_dev *cdev)
+{
+	u32 dbg_data_buf_size;
+	u8 *p_dbg_data_buf;
+	int rc;
+
+	dbg_data_buf_size = qed_dbg_all_data_size(cdev);
+	p_dbg_data_buf = vzalloc(dbg_data_buf_size);
+	if (!p_dbg_data_buf) {
+		DP_NOTICE(cdev,
+			  "Failed to allocate memory for a debug data buffer\n");
+		return -ENOMEM;
+	}
+
+	rc = qed_dbg_all_data(cdev, p_dbg_data_buf);
+	if (rc) {
+		DP_NOTICE(cdev, "Failed to obtain debug data\n");
+		vfree(p_dbg_data_buf);
+		return rc;
+	}
+
+	cdev->p_dbg_data_buf = p_dbg_data_buf;
+	cdev->dbg_data_buf_size = dbg_data_buf_size;
+
+	return 0;
+}
+
+void qed_dbg_save_all_data(struct qed_dev *cdev, bool print_dbg_data)
+{
+	bool curr_print_flag = cdev->print_dbg_data;
+
+	/* Only one debug buffer is kept, so remove anything collected
+	 * before this request
+	 */
+	qed_dbg_all_data_free_buf(cdev);
+
+	cdev->print_dbg_data = print_dbg_data;
+	__qed_dbg_save_all_data(cdev);
+	qed_dbg_send_uevent(cdev, "DBG");
+	cdev->print_dbg_data = curr_print_flag;
+}
 int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
 		    enum qed_dbg_features feature, u32 *num_dumped_bytes)
 {
@@ -8164,4 +8237,7 @@ void qed_dbg_pf_exit(struct qed_dev *cdev)
 			feature->dump_buf = NULL;
 		}
 	}
+
+	/* free a previously saved buffer if exists */
+	qed_dbg_all_data_free_buf(cdev);
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.h b/drivers/net/ethernet/qlogic/qed/qed_debug.h
index edf99d296bd1..7ba42375287a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.h
@@ -46,6 +46,7 @@ int qed_dbg_mcp_trace(struct qed_dev *cdev, void *buffer,
 int qed_dbg_mcp_trace_size(struct qed_dev *cdev);
 int qed_dbg_all_data(struct qed_dev *cdev, void *buffer);
 int qed_dbg_all_data_size(struct qed_dev *cdev);
+void qed_dbg_save_all_data(struct qed_dev *cdev, bool print_dbg_data);
 u8 qed_get_debug_engine(struct qed_dev *cdev);
 void qed_set_debug_engine(struct qed_dev *cdev, int engine_number);
 int qed_dbg_feature(struct qed_dev *cdev, void *buffer,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index d7c9d94e4c59..4411bc8fce98 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -2710,6 +2710,7 @@ const struct qed_common_ops qed_common_ops_pass = {
 	.update_msglvl = &qed_init_dp,
 	.dbg_all_data = &qed_dbg_all_data,
 	.dbg_all_data_size = &qed_dbg_all_data_size,
+	.dbg_save_all_data = &qed_dbg_save_all_data,
 	.chain_alloc = &qed_chain_alloc,
 	.chain_free = &qed_chain_free,
 	.nvm_flash = &qed_nvm_flash,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 3a3e0089a03c..590b0bfa7030 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -2527,6 +2527,9 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
 		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
 		  edev->err_flags);
 
+	if (test_and_clear_bit(QEDE_ERR_GET_DBG_INFO, &edev->err_flags))
+		edev->ops->common->dbg_save_all_data(cdev, true);
+
 	/* Trigger a recovery process.
 	 * This is placed in the sleep requiring section just to make
 	 * sure it is the last one, and that all the other operations
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 1b7d9548ee43..47f69964da27 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -940,6 +940,7 @@ struct qed_common_ops {
 
 	int (*dbg_all_data_size) (struct qed_dev *cdev);
 
+	void (*dbg_save_all_data)(struct qed_dev *cdev, bool print_dbg_data);
 /**
  * @brief can_link_change - can the instance change the link or not
  *
-- 
2.25.1

