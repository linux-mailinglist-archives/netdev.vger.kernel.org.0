Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C953C69B5C4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBQW5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjBQW5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:20 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F8B604C5
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPDdnDq5P6LFqPxkI4ONtSzii+tg8sxTOTkwiARk6Cwv342QYu+T+BNUupRkbhsya4DHlzgjITpjPuUho3xDakwizZxEM8vlKpFoAaLlbH3ugdP5XNaKXynuSIN0L5FmbdIoeB/1uVwd555wTn7q0iAuXslHlZrXDYOIcjO6WdOk8HStbqWEs96m6gbLOO2eNS8Keb2r5ZYO2PnxEFROHq+KCp9x24su9bYXIJWjeH0J4tbJdkJFwe9Setc/EGdE9bVW0kHY6vJpvLelc0SlEmv8nJbCSRHWLHI0sLavAUIGaG+ENQUzT7tamBUgCNog87ER0QnOpmCOwuSgoegM8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh8b787mjCT17ppOrNZEkZnE6B9i0PCov0XdaxCHMlg=;
 b=E20z506Jj/ZMg4CPtlC97/zvMdFsiTPC/JP7uhJRd+kttAZ9qdv8Qvj0oaWRpZtDOUGobOx3XfgOKYE/6ERYFgOLcoeqy9l1CA3GW+0HGPzlyqFVp5oFFsQ4iPpZr1i3o7xT06E0Cj9noEIj1eL9vatUCZ24b7GONzXV8cVnz+KQsB1fW8a9kVd29vbVa/x+NS6rysVcC5UgzqNsCrrT0iAbCxWXdu6txmeHqO483w6Rrw0cf3PV//aWoiYulqVaWAdR1iw66bA/XNAjBIEunuwyT4T9/r5p7QAB1ncmGo9rftzZgRnyhVUCbpk0gztnd130ZxFAeJKXX5xpgyQzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh8b787mjCT17ppOrNZEkZnE6B9i0PCov0XdaxCHMlg=;
 b=Rznqtgnt6W/VsVE7xJ97u867dneuAM/h5umYez4z1SqPG5hdihN7TOnLKlWdOmipMZzCF7yWjN7S4/DTzYkd8MgopRKpjCrZBQywVvGSq72lKJ4UWqcdIszpeTJgPiZqCzRQCcnvZSNjGhJj807pR7Na2Q0pXuzrMPAJoHrnIrc=
Received: from DS7PR05CA0021.namprd05.prod.outlook.com (2603:10b6:5:3b9::26)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 22:56:47 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::4e) by DS7PR05CA0021.outlook.office365.com
 (2603:10b6:5:3b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.12 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:46 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:44 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Fri, 17 Feb 2023 14:55:54 -0800
Message-ID: <20230217225558.19837-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: 85a80c93-1e48-460f-52fe-08db113a3f0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JcDQG8arMwTmdp5jSPq1dwY51dsS4FAVffcnlrb8/L3qSPMnhL9Vy2n3b/Af5/n0q1JVD8greGtqcVon+GBKNMbjVTU9xU63PsesWAAZI5NmNcyjv5ApQ294u79xgl74ijAmcm9UkiirDR1XVpykvdCY57YTWwbk1ANA7rLwnA/4u867wZsWYkP4AKUWG7/QkD9DeWY3d//rJnHFIkFj0CNFTYWBIRY8ZRiLHb8UF+RKaQ1jhtQ6WpW0GWRZYfObeXB9x8JgTzSGfGObsthCEiresSezlBpd46DH9oLM2AzkOzEohyXifavXYOJavuUtOBGi7yKE6E5Qw1UdKcFCXBUcUUoOZEgara+ysPnia9knNa7kUJ/Zxuu3X8UgsA8O3/BpvD5mmdxd3gEeBUjcAJEACaMXber83K9pjc1a3iqeQ2VdfDv5Dp5wLYjrPTlVltq7Hxi6Gx/jVq8OhzcqpnwUrIn7gzLQb/AyOmQDIn0VYnC3ElJPW9b9A3Tkze+ETM6gYCYizgnxSuELiMJSA3/nRoLigoGA/PuqneMgfg9lj5aDiyfx2cJXUffkfQisgUoaWFEckmQrRQgY3PSkL6yNKv7BJEMomlRU4ssA99mwSoZ0RBqiTmFm2H3t2SkpgEkfWuabGw6aU3UpVSglcTHeonNqQ3r1oe3b1+/Jn3QxRld/ecMwJOM/jVvA4CYr7iUChOnJGv86J6LMs5NQPhYbg1udbUqm7A3S868j+zN9NOtRy+WHCq77IsO7GxonqHHQYBrMSaTryq3YJUtRSw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(44832011)(2906002)(86362001)(82740400003)(36860700001)(81166007)(40460700003)(110136005)(47076005)(426003)(336012)(186003)(54906003)(26005)(478600001)(40480700001)(82310400005)(16526019)(36756003)(356005)(8676002)(83380400001)(70206006)(70586007)(316002)(1076003)(6666004)(41300700001)(2616005)(8936002)(4326008)(5660300002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:46.4976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a80c93-1e48-460f-52fe-08db113a3f0b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each VF, and the device
name is made up of the PF driver name, VIF name, and PCI BDF
of the VF.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 123 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |   4 +
 drivers/net/ethernet/amd/pds_core/main.c   |  43 +++++++
 include/linux/pds/pds_auxbus.h             |  35 ++++++
 5 files changed, 206 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 include/linux/pds/pds_auxbus.h

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 6d1d6c58a1fa..0abc33ce826c 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
 	      devlink.o \
+	      auxbus.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
new file mode 100644
index 000000000000..dc36fc98de52
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+
+#include "core.h"
+
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+static void pdsc_auxbus_dev_release(struct device *dev)
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+
+	devm_kfree(dev->parent, padev);
+}
+
+static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
+							  char *name, u32 id,
+							  struct pci_dev *client_dev)
+{
+	struct auxiliary_device *aux_dev;
+	struct pds_auxiliary_dev *padev;
+	int err;
+
+	padev = devm_kzalloc(pdsc->dev, sizeof(*padev), GFP_KERNEL);
+	if (!padev)
+		return NULL;
+
+	padev->pcidev = client_dev;
+
+	aux_dev = &padev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->id = id;
+	padev->id = id;
+	aux_dev->dev.parent = pdsc->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(pdsc->dev, "auxiliary_device_init of %s id %d failed: %pe\n",
+			 name, id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		auxiliary_device_uninit(aux_dev);
+		dev_warn(pdsc->dev, "auxiliary_device_add of %s id %d failed: %pe\n",
+			 name, id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	dev_dbg(pdsc->dev, "%s: name %s id %d pdsc %p\n",
+		__func__, padev->aux_dev.name, id, pdsc);
+
+	return padev;
+
+err_out:
+	devm_kfree(pdsc->dev, padev);
+	return NULL;
+}
+
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
+{
+	struct pds_auxiliary_dev *padev;
+	enum pds_core_vif_types vt;
+	int err = 0;
+
+	if (!pdsc->vfs)
+		return -ENOTTY;
+
+	if (vf_id >= pdsc->num_vfs)
+		return -ERANGE;
+
+	if (pdsc->vfs[vf_id].padev) {
+		dev_info(pdsc->dev, "%s: vfid %d already running\n", __func__, vf_id);
+		return -ENODEV;
+	}
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		u16 vt_support;
+		u32 id;
+
+		/* Verify that the type supported and enabled */
+		vt_support = !!le16_to_cpu(pdsc->dev_ident.vif_types[vt]);
+		if (!(vt_support &&
+		      pdsc->viftype_status[vt].supported &&
+		      pdsc->viftype_status[vt].enabled))
+			continue;
+
+		id = PCI_DEVID(pdsc->pdev->bus->number,
+			       pci_iov_virtfn_devfn(pdsc->pdev, vf_id));
+		padev = pdsc_auxbus_dev_register(pdsc, pdsc->viftype_status[vt].name, id,
+						 pdsc->pdev);
+		pdsc->vfs[vf_id].padev = padev;
+
+		/* We only support a single type per VF, so jump out here */
+		break;
+	}
+
+	return err;
+}
+
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id)
+{
+	struct pds_auxiliary_dev *padev;
+
+	dev_info(pdsc->dev, "%s: vfid %d\n", __func__, vf_id);
+
+	padev = pdsc->vfs[vf_id].padev;
+	pdsc->vfs[vf_id].padev = NULL;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 1885976c6486..7abd2cc4efc7 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -188,6 +188,7 @@ struct pdsc {
 	dma_addr_t phy_db_pages;
 	u64 __iomem *kern_dbpage;
 
+	struct notifier_block nb;
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
@@ -302,6 +303,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 1376dec84756..160b38ba674c 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -170,6 +170,7 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	struct pdsc *pdsc = pci_get_drvdata(pdev);
 	struct device *dev = pdsc->dev;
 	int ret = 0;
+	int i;
 
 	if (num_vfs > 0) {
 		pdsc->vfs = kcalloc(num_vfs, sizeof(struct pdsc_vf), GFP_KERNEL);
@@ -187,6 +188,8 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	}
 
 no_vfs:
+	for (i = pdsc->num_vfs - 1; i >= 0; i--)
+		pdsc_auxbus_dev_del_vf(pdsc, i);
 	pci_disable_sriov(pdev);
 
 	kfree(pdsc->vfs);
@@ -196,6 +199,36 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	return ret;
 }
 
+static int pdsc_pci_bus_notifier(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct pdsc *pdsc = container_of(nb, struct pdsc, nb);
+	struct device *dev = data;
+	struct pci_dev *physfn;
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	physfn = pci_physfn(pdev);
+
+	if (!(pdev->is_virtfn && physfn == pdsc->pdev))
+		return 0;
+
+	switch (action) {
+	case BUS_NOTIFY_BOUND_DRIVER:
+		dev_dbg(pdsc->dev, "BOUND_DRIVER %s vf %d\n",
+			pci_name(pdev), pci_iov_vf_id(pdev));
+		pdsc_auxbus_dev_add_vf(pdsc, pci_iov_vf_id(pdev));
+		break;
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		dev_dbg(pdsc->dev, "UNBIND_DRIVER %s vf %d\n",
+			pci_name(pdev), pci_iov_vf_id(pdev));
+		pdsc_auxbus_dev_del_vf(pdsc, pci_iov_vf_id(pdev));
+		break;
+	}
+
+	return 0;
+}
+
 static DEFINE_IDA(pdsc_pf_ida);
 
 #define PDSC_WQ_NAME_LEN 24
@@ -285,6 +318,11 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	pdsc->nb.notifier_call = pdsc_pci_bus_notifier;
+	err = bus_register_notifier(&pci_bus_type, &pdsc->nb);
+	if (err)
+		dev_warn(dev, "Cannot register bus notifier: %pe\n", ERR_PTR(err));
+
 	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
 			      ioread8(&pdsc->info_regs->fw_status);
 	/* Lastly, start the health check timer */
@@ -330,8 +368,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	/* Undo the devlink registration now to be sure there
 	 * are no requests while we're stopping.
 	 */
+	bus_unregister_notifier(&pci_bus_type, &pdsc->nb);
 	pdsc_dl_unregister(pdsc);
 
+	/* Remove the VFs and their aux_bus connections before other
+	 * cleanup so that the clients can use the AdminQ to cleanly
+	 * shut themselves down.
+	 */
 	pdsc_sriov_configure(pdev, 0);
 
 	/* Now we can lock it up and tear it down */
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..737fd4dbbf5a
--- /dev/null
+++ b/include/linux/pds/pds_auxbus.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDSC_AUXBUS_H_
+#define _PDSC_AUXBUS_H_
+
+#include <linux/auxiliary_bus.h>
+
+struct pds_auxiliary_dev;
+
+struct pds_auxiliary_drv {
+	/* .event_handler() - callback for receiving events
+	 * padev:  ptr to the client device info
+	 * event:  ptr to event data
+	 * The client can provide an event handler callback that can
+	 * receive DSC events.  The Core driver may generate its
+	 * own events which can notify the client of changes in the
+	 * DSC status, such as a RESET event generated when the Core
+	 * has lost contact with the FW - in this case the event.eid
+	 * field will be 0.
+	 */
+	void (*event_handler)(struct pds_auxiliary_dev *padev,
+			      union pds_core_notifyq_comp *event);
+};
+
+struct pds_auxiliary_dev {
+	struct auxiliary_device aux_dev;
+	struct pci_dev *pcidev;
+	u32 id;
+	u16 client_id;
+	void (*event_handler)(struct pds_auxiliary_dev *padev,
+			      union pds_core_notifyq_comp *event);
+	void *priv;
+};
+#endif /* _PDSC_AUXBUS_H_ */
-- 
2.17.1

