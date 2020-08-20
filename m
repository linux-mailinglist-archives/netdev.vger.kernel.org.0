Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DBB24C5E9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgHTSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:52:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14284 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728005AbgHTSwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:52:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KIUfAJ014446;
        Thu, 20 Aug 2020 11:52:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=H1CjbGPyDsNzBCUDiUbyU7FNYdZOiVlh6jYyLp56+tw=;
 b=WTddqJei0oTJ7HkK4387qHtnFuSDd+ZzRqYfMLTjKRHrRP9CHKxG3xsBNuGMRdgJKS6F
 zYnX0WWf34PK4xipjN6jGFXdzHoqaoPZExYP/PXVsH6Ibwu5LnoQpoLp4YqQfYD/5rX8
 19O+V5xJTOpUpskMvOQE0frBJTg/n6+RXZcRyS38U16enCZwU7eXyZe5qYLUw6sasmPn
 pUr9lUv4XOGWzPt0D9DmjPHBNlhSxCIpdOvGnRM43TRSqDi58CQdl9BbHJXecc1A7Yc+
 gbpTmoB3X238B7N5+uMkiXBV1P7SEanBEYuoyVN6J1b1ACCkhO1N1HTcTER5gaPxHLDZ jQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhxnvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 11:52:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 11:52:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 11:52:25 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 0C6823F703F;
        Thu, 20 Aug 2020 11:52:22 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v6 net-next 04/10] qed: implement devlink info request
Date:   Thu, 20 Aug 2020 21:51:58 +0300
Message-ID: <20200820185204.652-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200820185204.652-1-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we return existing fw & mfw versions, we also fetch device's
serial number:

~$ sudo ~/iproute2/devlink/devlink  dev info
pci/0000:01:00.1:
  driver qed
  board.serial_number REE1915E44552
  versions:
      running:
        fw.app 8.42.2.0
      stored:
        fw.mgmt 8.52.10.0

MFW and FW are different firmwares on device.
Management is a firmware responsible for link configuration and
various control plane features. Its permanent and resides in NVM.

Running FW (or fastpath FW) is an embedded microprogram implementing
all the packet processing, offloads, etc. This FW is being loaded
on each start by the driver from FW binary blob.

The base device specific structure (qed_dev_info) was not directly
available to the base driver before. Thus, here we create and store
a private copy of this structure in qed_dev root object to
access the data.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |  9 ++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 50 ++++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
 4 files changed, 60 insertions(+), 1 deletion(-)

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
index b3c9ebaf2280..00f2d7f13de6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3973,6 +3973,7 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	struct qed_mcp_link_speed_params *ext_speed;
 	struct qed_mcp_link_capabilities *p_caps;
 	struct qed_mcp_link_params *link;
+	int i;
 
 	/* Read global nvm_cfg address */
 	nvm_cfg_addr = qed_rd(p_hwfn, p_ptt, MISC_REG_GEN_PURP_CR0);
@@ -4290,6 +4291,14 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		__set_bit(QED_DEV_CAP_ROCE,
 			  &p_hwfn->hw_info.device_capabilities);
 
+	/* Read device serial number information from shmem */
+	addr = MCP_REG_SCRATCH + nvm_cfg1_offset +
+		offsetof(struct nvm_cfg1, glob) +
+		offsetof(struct nvm_cfg1_glob, serial_number);
+
+	for (i = 0; i < 4; i++)
+		p_hwfn->hw_info.part_num[i] = qed_rd(p_hwfn, p_ptt, addr + i * 4);
+
 	return qed_mcp_fill_shmem_func_info(p_hwfn, p_ptt);
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index a62c47c61edf..47d54a96cbb9 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -45,7 +45,55 @@ static const struct devlink_param qed_devlink_params[] = {
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
+		err = devlink_info_board_serial_number_put(req, buf);
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
+	return devlink_info_version_running_put(req,
+						DEVLINK_INFO_VERSION_GENERIC_FW_APP, buf);
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

