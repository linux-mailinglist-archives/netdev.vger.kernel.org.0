Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3029524ED0C
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHWLU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45206 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbgHWLUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBKGSM010399;
        Sun, 23 Aug 2020 04:20:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yHRdxWRSjvWqWPAB+kELHYnVgrIE1PvYQKCCJk7ZLbs=;
 b=LF4c49biYe+cxF/7it1Vh7tYecUzpuJecskiKywgqaDDiwjRnZPxIcPPD9VAWRF3NOpG
 dG84XoUCUgHBXM63JmmFgWD/M/sYxMgbBEtzu9N51Bo5fSmZFz9nSn9ipOYOX7cl9XqV
 v4A6KWbRpRunvfj13k1GIbyskMziJt0+38NsW5kDLc7uk7U66SlqjpvPDVgZDYraxgRv
 Yak5fEAUvMLwNGGvCofFz2awbcJpzHqbX/L8yRAOVvvnqgwx4se8+6vYVFT4NFKP2xF+
 dJ6cI9tQti3BeVXFf52C6YrOed5VyT/Kkb8CZT9Gb/RBRcAJmq31/bRzxg4RydqQ/GEt Bw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpb9n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:11 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 3AA703F704C;
        Sun, 23 Aug 2020 04:20:07 -0700 (PDT)
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
Subject: [PATCH v7 net-next 04/10] qed: implement devlink info request
Date:   Sun, 23 Aug 2020 14:19:28 +0300
Message-ID: <20200823111934.305-5-irusskikh@marvell.com>
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
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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

