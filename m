Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA41231D7D
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgG2LjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8978 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbgG2LjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBaPJa011959;
        Wed, 29 Jul 2020 04:39:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=/mfLxnAmTxRmqmfPVWrQGjP3L3jlkIrAHXNq6f8K8hY=;
 b=W1VJFF1BvwP2ME5iO7u5D6T/J1H0L4mHYyudjYtYB2ggxXQkdBDII46xF2RhkJpOzRNZ
 bbX7NEgAogPx/wkhgVlbcXJTnh8fxPQCxWT5vLPOLWF4ty8QG0Y+bcj3cjjL5BKh9jl/
 6d2AObpJ2kRYArOlULC+IDP6SwuhjK5ym5LBq7gwuz6w3yJu7CGYNJ5g75pzoeEXDOJy
 HeH1o/CIkmXzkqDVO3LKV3TyFEZluGPQn+HQtZaPlMjkvVn+ZT5u49OTdKNPryJmriVX
 fO1ggayfQ8Gqtev+k8VHDHnEevHZSvR+8RtNolex2KmfinXcN2REqJjkKyqpZ+ZUPo/i GQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0su3rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:07 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 6CEF53F703F;
        Wed, 29 Jul 2020 04:39:05 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 05/11] qed: implement devlink info request
Date:   Wed, 29 Jul 2020 14:38:40 +0300
Message-ID: <20200729113846.1551-6-irusskikh@marvell.com>
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

Here we return existing fw & mfw versions, we also fetch device's
serial number.

The base device specific structure (qed_dev_info) was not directly
available to the base driver before.
Thus, here we create and store a private copy of this structure
in qed_dev root object.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c     | 10 ++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 52 ++++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index b6ce1488abcc..ccd789eeda3e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -807,6 +807,7 @@ struct qed_dev {
 	struct qed_llh_info *p_llh_info;
 
 	/* Linux specific here */
+	struct qed_dev_info		common_dev_info;
 	struct  qede_dev		*edev;
 	struct  pci_dev			*pdev;
 	u32 flags;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index b3c9ebaf2280..377950ce8ea2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4290,6 +4290,16 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		__set_bit(QED_DEV_CAP_ROCE,
 			  &p_hwfn->hw_info.device_capabilities);
 
+	/* Read device serial number information from shmem */
+	addr = MCP_REG_SCRATCH + nvm_cfg1_offset +
+		offsetof(struct nvm_cfg1, glob) +
+		offsetof(struct nvm_cfg1_glob, serial_number);
+
+	p_hwfn->hw_info.part_num[0] = qed_rd(p_hwfn, p_ptt, addr);
+	p_hwfn->hw_info.part_num[1] = qed_rd(p_hwfn, p_ptt, addr + 4);
+	p_hwfn->hw_info.part_num[2] = qed_rd(p_hwfn, p_ptt, addr + 8);
+	p_hwfn->hw_info.part_num[3] = qed_rd(p_hwfn, p_ptt, addr + 12);
+
 	return qed_mcp_fill_shmem_func_info(p_hwfn, p_ptt);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 4e3316c6beb6..5bd5528dc409 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -45,7 +45,57 @@ static const struct devlink_param qed_devlink_params[] = {
 			     qed_dl_param_get, qed_dl_param_set, NULL),
 };
 
-static const struct devlink_ops qed_dl_ops;
+static int qed_devlink_info_get(struct devlink *devlink,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct qed_devlink *qed_dl = devlink_priv(devlink);
+	struct qed_dev *cdev = qed_dl->cdev;
+	struct qed_dev_info *dev_info;
+	char buf[100];
+	int err;
+
+	dev_info = &cdev->common_dev_info;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err)
+		return err;
+
+	memcpy(buf, cdev->hwfns[0].hw_info.part_num, sizeof(cdev->hwfns[0].hw_info.part_num));
+	buf[sizeof(cdev->hwfns[0].hw_info.part_num)] = 0;
+
+	if (buf[0]) {
+		err = devlink_info_serial_number_put(req, buf);
+		if (err)
+			return err;
+	}
+
+	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_3),
+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_2),
+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_1),
+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_0));
+
+	err = devlink_info_version_stored_put(req,
+					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
+	if (err)
+		return err;
+
+	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
+		 dev_info->fw_major,
+		 dev_info->fw_minor,
+		 dev_info->fw_rev,
+		 dev_info->fw_eng);
+
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW, buf);
+
+	return err;
+}
+
+static const struct devlink_ops qed_dl_ops = {
+	.info_get = qed_devlink_info_get,
+};
 
 struct devlink *qed_devlink_register(struct qed_dev *cdev)
 {
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index d6f76421379b..d1a559ccf516 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -479,6 +479,7 @@ int qed_fill_dev_info(struct qed_dev *cdev,
 	}
 
 	dev_info->mtu = hw_info->mtu;
+	cdev->common_dev_info = *dev_info;
 
 	return 0;
 }
-- 
2.17.1

