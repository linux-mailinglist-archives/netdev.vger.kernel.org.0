Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628676C57E9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjCVUm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCVUmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:42:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B075B8889C;
        Wed, 22 Mar 2023 13:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ey3AhI9bc3GRB5Nt++XNk3sMZjjSCxULGSDLWIFOzW4DhHe0iue9a5lms7B5/fTWstJSGYoBgYaFtvlORo3A63zuWf4Eohz4SqsWrtbVMyqXJ7ssMeGaDnTquSNt/rpf7MFSzWvWjb5rkilnPcRmbM3b06wzt+8wgcsTumMXpjzzVaUh4gOlIsY1hmJiUzgTL3EDZEvElsuRoJ3WQK7wB6pOlIwEUesxl2FlUce8aSvuxZ/hNkvTZ+zzVnNjpwSQYmVufTFJg1SyTY/obqFDKASkElfqTCKf5cbJ8iVrL8gGMEc/hNQAn4pKHz7SMARH2VLaFVMFpZNl2juQD3be0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nvdaTDqs8OPWe13RfVpIHdN5TY+4KX7QaydwJCbbOU=;
 b=YpACdWnsDPD+/5qdp5yeG+1QdsXvgUHSSn0WVKbwzKvyuT9TH5WiuVO7grUEe+EFm4OooacMylzbIswbarc5gaP13ZCmFh1QVOR23XkRry7d81Ifmcj6wgfX45k8pNBhx1ItZoHa8hcnAiyJok+KzBYOzwPICI+7fzCdXmlKg3hIrgb/tSZMcn3RYm1azNhlD+gQ0C5Txy4+J0XHPegbfsT8wDi9kmj47OvrMWfdlHglEOXiEET5CpjYTHfa2/bxqYW8ARwe7b11IVPPIlT9Rc5J+Yfu42/DTJkzYpQssWBy+c+IK9aS5DMGA4i2z10qTRT43VE/hsQt2flaDfS0Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nvdaTDqs8OPWe13RfVpIHdN5TY+4KX7QaydwJCbbOU=;
 b=evyAGRdjaPgnUCnpTI6owk9RCTJjUetB+evg18TlxD74XsT9OuI+0WupK9aXc+zGpGinsRORNIgcHKEUrW9exlsjvgYzMk9t3WtVLcvp677ZDpgMCnPlDNHA8EJcq3S8ZGngvsLF6QyV2OK7S8FVW8JHDvluMIsBfEvBpNCao8U=
Received: from BN0PR04CA0095.namprd04.prod.outlook.com (2603:10b6:408:ec::10)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:35:03 +0000
Received: from BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::ca) by BN0PR04CA0095.outlook.office365.com
 (2603:10b6:408:ec::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 20:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT076.mail.protection.outlook.com (10.13.176.174) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 20:35:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 15:35:01 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drviers@pensando.io>
Subject: [PATCH v5 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Wed, 22 Mar 2023 13:34:38 -0700
Message-ID: <20230322203442.56169-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322203442.56169-1-brett.creeley@amd.com>
References: <20230322203442.56169-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT076:EE_|BY5PR12MB4226:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f8393a9-35d1-41d1-257c-08db2b14ea1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N+S1PycJQWvgQTkR9VsHZUGIVrqY8Qo9emVAc4sXoD80wgmg29uqijah3GXAJS7y7JnknSSmu7CSWmBKax4QtAa6TrO49iSezesO4pKWH64UnBRl4JKdjPc9fb8lBMLw/rEnffzp5KexCMzmexO3XYja5zzCVz5vz/clGjhZUD0EgQuQeDq8wcfB5pieUZ2QqnR8KICS5UXti/DTueitz82PLfdetV3psgbn1xfH/TE7MpUAoEMnSEDLjuQn8+7GwFfRzrAypz98I3Sfo0FPa2JJ2WFaR8EocGjMCiEMb460/kvLcYpJajwTqI/Th+MRCJ0h7cri2px0+VJ2t24a2VFI0M/SOypPmnGPetR73s3uD86F6U1agg/zTDnlk9ILYMPW7GgRsGiTnLlbcgy/1JpJs5rsgevPLSQ4+hlSW9bqIxowr6uB46dlWGoQ7z/Qch1Ixtfm1PYIYT3moydZyrQ1ZoAT87kvCL5OTL0Om26DT5mZfSHJSgYtk6FqJquC7XtCoGD64bdtVsLNeS25s1Osc7GQcS9XIHxXLQoRxzkubG+DY+YEV9KyR68l8NIz3pl0mLBFv8289YDEe1Gmt2hUC4lXc0JAM0tiDxRd4GcJf/I4JPs0iw4qNf86n9C6lIeLbkny1VgltHwtTRa0GpptOxASaTz61fI21vy2Q0aKaSaQRwEPqaxnX4G4pcf3MCpidGgQbV3LQR+18Q/PIL8cm6dYhz9UmgPA0YSoBM4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(2616005)(82310400005)(316002)(336012)(110136005)(426003)(47076005)(83380400001)(36860700001)(81166007)(40460700003)(40480700001)(44832011)(70206006)(86362001)(8676002)(2906002)(41300700001)(36756003)(70586007)(82740400003)(356005)(4326008)(1076003)(26005)(6666004)(16526019)(478600001)(186003)(5660300002)(8936002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:35:02.9707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8393a9-35d1-41d1-257c-08db2b14ea1d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pds_core driver will supply adminq services, so find the PF
and register with the DSC services.

Use the following commands to enable a VF:
echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |  1 +
 drivers/vfio/pci/pds/cmds.c     | 67 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 12 ++++++
 drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
 drivers/vfio/pci/pds/vfio_dev.c |  5 +++
 drivers/vfio/pci/pds/vfio_dev.h |  2 +
 include/linux/pds/pds_lm.h      | 12 ++++++
 8 files changed, 123 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 include/linux/pds/pds_lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index e1a55ae0f079..87581111fa17 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -4,5 +4,6 @@
 obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
+	cmds.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
new file mode 100644
index 000000000000..26e383ec4544
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_lm.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+int
+pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	int err, id;
+	u16 ci;
+
+	id = PCI_DEVID(pds_vfio->pdev->bus->number,
+		       pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
+
+	dev = &pds_vfio->pdev->dev;
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
+		 "%s.%d", PDS_LM_DEV_NAME, id);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
+	if (err) {
+		dev_info(dev, "register with DSC failed, status %d: %pe\n",
+			 comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	ci = le16_to_cpu(comp.client_reg.client_id);
+	if (!ci) {
+		dev_err(dev, "%s: device returned null client_id\n", __func__);
+		return -EIO;
+	}
+	pds_vfio->client_id = ci;
+
+	return 0;
+}
+
+void
+pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	int err;
+
+	dev = &pds_vfio->pdev->dev;
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(pds_vfio->client_id);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
+	if (err)
+		dev_info(dev, "unregister from DSC failed, status %d: %pe\n",
+			 comp.status, ERR_PTR(err));
+
+	pds_vfio->client_id = 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
new file mode 100644
index 000000000000..baf0695b5576
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _CMDS_H_
+#define _CMDS_H_
+
+struct pds_vfio_pci_device;
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 5e554420792e..46537afdee2d 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -8,9 +8,13 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 
+#include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
 
 #include "vfio_dev.h"
+#include "pci_drv.h"
+#include "cmds.h"
 
 #define PDS_VFIO_DRV_NAME		"pds_vfio"
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
@@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 
 	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
 	pds_vfio->pdev = pdev;
+	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
+
+	err = pds_vfio_register_client_cmd(pds_vfio);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register as client: %pe\n",
+			ERR_PTR(err));
+		goto out_put_vdev;
+	}
 
 	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
 	if (err)
-		goto out_put_vdev;
+		goto out_unreg_client;
 
 	return 0;
 
+out_unreg_client:
+	pds_vfio_unregister_client_cmd(pds_vfio);
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
new file mode 100644
index 000000000000..e79bed12ed14
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+
+#endif /* _PCI_DRV_H */
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index f1221f14e4f6..592b10a279f0 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -31,6 +31,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 
+	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
+		__func__, pci_dev_id(pdev->physfn),
+		pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
+		pci_domain_nr(pdev->bus), pds_vfio);
+
 	return 0;
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index a66f8069b88c..0c7932c6e1e8 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -10,9 +10,11 @@
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pci_dev *pdev;
+	struct pdsc *pdsc;
 
 	int vf_id;
 	int pci_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
new file mode 100644
index 000000000000..2bc2bf79426e
--- /dev/null
+++ b/include/linux/pds/pds_lm.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PDS_LM_H_
+#define _PDS_LM_H_
+
+#include "pds_common.h"
+
+#define PDS_DEV_TYPE_LM_STR	"LM"
+#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
+
+#endif /* _PDS_LM_H_ */
-- 
2.17.1

