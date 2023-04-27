Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6436F0A28
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244293AbjD0QqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242835AbjD0QqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:46:07 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE2B46BE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:46:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ4mOLZI/GF2Tdcbj47MEihATy99jWeizwhR3cvl1dZ3PUFQ0smmlCHoWAOaxcLsKSZD47rSfiuy9UsVcmi3gkA0PWPAirVi1Zkow/ccFyRjlVCqSZ0ihHxBtx1C8nDPCwyXd1/5m7AngaMOBiW76M68MbpkuDNFUee15pLzEXOl/AV+fycLKCEw4U/W6qEY36RrGUyvJ8KzomInogdu4tE442xsQ9OLCFZbfMdSYEjE3dwzZLUtQ9Jc6Iu8/KZcqrKlcbmHR1RdIcJef9bbyTqjHpUSegByKe5hBfyZz6q/kp22qPN3ED1jhBQFldyO21B+SjGZa7njcuOOnjtD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEt83n7ag8nUTY/O8zsicCZqxlVfdfSzz+yyqUsrEdY=;
 b=BcxiZCHlWzBzR83orWG+Q5cswAaHmVlS288Y1cfZazcpLlgxTkK4jerlaGyvfadhysyY9jatjM6y+uyOYXsGOj/K9p6yumJvY4kXK0f23pRiOAeWocHQ3HVurtXPEKSG4PgigH1HgoYxJ7bBVMd8JDH3fXsWmN9+IUdTdforqhwmmm2Rmtu7auLc5r4mDFXgsaIrHSijMnd8xX/eIaSooUURarpXWqAN1V7jfh//gOFXTUmaRaPR/m2H88Y43Aac7541dPxlOC1uBu2Pjq3FOLsgYKgqTzjy+5C7k6VoISccdP+sXJFIRUlb3X70ZAgGmCbPm/FsLyNVC5f6EmB8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEt83n7ag8nUTY/O8zsicCZqxlVfdfSzz+yyqUsrEdY=;
 b=OSQXd7M7ti2KTcCCoUsZXjsRb/Jo4j+e9V9fbontVAMouEl+62b9lN7SE5qlelU30+W2lRg8mpQmDaJ1hPp7vRjewekqjZ0Co2My0JYcvIHAXDU85+jks6c7g73GVQBRfTnk8hHxVAnn+45O6y2honTolWOBwex6NL8WawUrN98=
Received: from BL0PR02CA0076.namprd02.prod.outlook.com (2603:10b6:208:51::17)
 by CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 16:46:03 +0000
Received: from BL02EPF000145BA.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::54) by BL0PR02CA0076.outlook.office365.com
 (2603:10b6:208:51::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22 via Frontend
 Transport; Thu, 27 Apr 2023 16:46:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000145BA.mail.protection.outlook.com (10.167.241.210) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Thu, 27 Apr 2023 16:46:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 27 Apr
 2023 11:46:01 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC net-next 1/2] pds_core: netdev representors for each VF
Date:   Thu, 27 Apr 2023 09:45:45 -0700
Message-ID: <20230427164546.31296-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230427164546.31296-1-shannon.nelson@amd.com>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BA:EE_|CO6PR12MB5427:EE_
X-MS-Office365-Filtering-Correlation-Id: 286194d1-667e-4c22-d7ff-08db473ee30f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 73W6j9ugdYLYal/MpqbUoago/ZTkv0HN/xFCmmlwwXzarttst4n/15wVIROLduYkq/9dB8V9zLFZQuEnNkKacYaHj5KWMWNY6lYBS9IYibnnz6DSTJXD+dPVGI4tU07nrU2pdBW92QkuBRpduCYMnAQ05UehC3jRJjGsnMMDvLer7zAwyt1UcMFX9RtJay34nxrAg59fiqvfxbXjOhjC/1dYnijuCfHoCPAn1E1a4cjWdUoV+FRn7WRVJl18B+eBMk8dBsQuf6dXt37QKTIdh+cfROxpLTU0bkmaGQnr9TSL3IRjZjnIu7HhsAm0bf/lv0C8tkEFUZuIjo6NJOBXst/cOUmXPYaF5oFtajz2qWguTptHENE2uS2WwxBgsF0uwZ5fHgyER2gZc9GQG/aBI7B/BY4KZyrq+saEVA85lLfvBFiA5kjFHEVs7G2W4qScWyIM0JqKs+8t+vs2cpJCVmV5htry/xfW6YSHOenz6AVrCkJ3PO+447ZvNwLOTH0Li+3OCsKsHqBU9P6Z2d4sA3XkggAFWG0YwSYw5V3RRqYJPyVMqUPjRqgT9rGB1gPbcRVBEraPKHGZh0fnhZ6C4NAA0+hKITRHnaHmDkyqe+HXCZnRwnnEtht5Y4ULR9JVoGAIQ5git+fWSPJtmfLnZprPoVlTZZpOZ2pyLCW09iKJOkE8BhaDPGttw2oot3R8p6wer3bv4swZKLVN7r9lOw7Sg3/RYvyTBL+K4Ub6LW8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(36840700001)(40470700004)(46966006)(186003)(316002)(4326008)(40460700003)(70586007)(70206006)(110136005)(6666004)(82310400005)(86362001)(40480700001)(478600001)(36756003)(16526019)(1076003)(5660300002)(26005)(36860700001)(2616005)(41300700001)(81166007)(356005)(44832011)(426003)(336012)(2906002)(47076005)(82740400003)(83380400001)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 16:46:02.5599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 286194d1-667e-4c22-d7ff-08db473ee30f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5427
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using pds_core VFs, we want to do some amount of control
and configuration - specifically, we need the ability to
configure port vlans.  Here we add switchdev and create
representor netdevs for the VFs.

The pds_core switchdev can be enabled before or after the
VFs have been enabled.  This means that they can be brought
up specifically for configuring the VF vlan, then can be
immediately turned back off.  Disabling the switchdev will
not affect VF vlan configuration.

Due to the design of this particular device, there is no packet
switching to the PF: the only datapaths available are through
the VFs.  Therefore, neither the PF nor the VF representors
have packet processing queues.  For now, these representors
are just enough to send a few tc configuration commands to
the FW for setting port vlans on each VF.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/core.h   |  10 ++
 drivers/net/ethernet/amd/pds_core/main.c   |  28 ++++-
 drivers/net/ethernet/amd/pds_core/rep.c    | 140 +++++++++++++++++++++
 4 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/rep.c

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 0abc33ce826c..3bfcfa4eda42 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -9,6 +9,7 @@ pds_core-y := main.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
+	      rep.o \
 	      fw.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index e545fafc4819..2f38143dd5c2 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -171,6 +171,7 @@ struct pdsc {
 	unsigned int wdtimer_period;
 	struct work_struct health_work;
 	struct devlink_health_reporter *fw_reporter;
+	struct devlink_port dl_port;
 	u32 fw_recoveries;
 
 	struct pdsc_devinfo dev_info;
@@ -196,6 +197,9 @@ struct pdsc {
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
 	struct pdsc_viftype *viftype_status;
+
+	struct net_device *netdev;
+	enum devlink_eswitch_mode eswitch_mode;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -309,4 +313,10 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
 int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
 			 struct netlink_ext_ack *extack);
+
+int pdsc_add_rep(struct pdsc *vf, struct pdsc *pf);
+void pdsc_del_rep(struct pdsc *vf);
+int pdsc_dl_eswitch_mode_get(struct devlink *devlink, u16 *mode);
+int pdsc_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
+			     struct netlink_ext_ack *extack);
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index e2d14b1ca471..272a8979e53d 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -185,12 +185,27 @@ static int pdsc_init_vf(struct pdsc *vf)
 
 	pf->vfs[vf->vf_id].vf = vf;
 	err = pdsc_auxbus_dev_add(vf, pf);
-	if (err) {
+	if (err)
+		goto err_dl_unreg;
+
+	if (pf->eswitch_mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
 		devl_lock(dl);
-		devl_unregister(dl);
+		err = pdsc_add_rep(vf, pf);
 		devl_unlock(dl);
+		if (err)
+			goto err_del_aux;
 	}
 
+	return 0;
+
+err_del_aux:
+	pdsc_auxbus_dev_del(vf, pf);
+	pf->vfs[vf->vf_id].vf = NULL;
+err_dl_unreg:
+	devl_lock(dl);
+	devl_unregister(dl);
+	devl_unlock(dl);
+
 	return err;
 }
 
@@ -262,6 +277,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 		goto err_out_unlock_dl;
 	}
 
+	pdsc->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+
 	hr = devl_health_reporter_create(dl, &pdsc_fw_reporter_ops, 0, pdsc);
 	if (IS_ERR(hr)) {
 		dev_warn(pdsc->dev, "Failed to create fw reporter: %pe\n", hr);
@@ -304,6 +321,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
 	.flash_update	= pdsc_dl_flash_update,
+	.eswitch_mode_set = pdsc_dl_eswitch_mode_set,
+	.eswitch_mode_get = pdsc_dl_eswitch_mode_get,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
@@ -406,6 +425,11 @@ static void pdsc_remove(struct pci_dev *pdev)
 
 		pf = pdsc_get_pf_struct(pdsc->pdev);
 		if (!IS_ERR(pf)) {
+			if (pf->eswitch_mode == DEVLINK_ESWITCH_MODE_SWITCHDEV) {
+				devl_lock(dl);
+				pdsc_del_rep(pdsc);
+				devl_unlock(dl);
+			}
 			pdsc_auxbus_dev_del(pdsc, pf);
 			pf->vfs[pdsc->vf_id].vf = NULL;
 		}
diff --git a/drivers/net/ethernet/amd/pds_core/rep.c b/drivers/net/ethernet/amd/pds_core/rep.c
new file mode 100644
index 000000000000..297d9e2bac31
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/rep.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+
+#include "core.h"
+
+struct pds_rep {
+	struct pdsc *vf;
+	struct pdsc *pf;
+};
+
+static const struct net_device_ops pdsc_rep_netdev_ops = {
+};
+
+static void pdsc_get_rep_drvinfo(struct net_device *netdev,
+				 struct ethtool_drvinfo *drvinfo)
+{
+	struct pds_rep *rep = netdev_priv(netdev);
+
+	strscpy(drvinfo->driver, PDS_CORE_DRV_NAME,
+		sizeof(drvinfo->driver));
+	strscpy(drvinfo->bus_info, pci_name(rep->vf->pdev),
+		sizeof(drvinfo->bus_info));
+	strscpy(drvinfo->fw_version, rep->pf->dev_info.fw_version,
+		sizeof(drvinfo->fw_version));
+}
+
+static const struct ethtool_ops pdsc_rep_ethtool_ops = {
+	.get_drvinfo = pdsc_get_rep_drvinfo,
+};
+
+int pdsc_add_rep(struct pdsc *vf, struct pdsc *pf)
+{
+	struct pds_rep *rep;
+	int err = 0;
+
+	memset(&vf->dl_port, 0, sizeof(vf->dl_port));
+	devlink_port_attrs_pci_vf_set(&vf->dl_port, 0, PCI_FUNC(pf->pdev->devfn),
+				      vf->vf_id, false);
+	err = devl_port_register(priv_to_devlink(vf), &vf->dl_port, vf->vf_id);
+	if (err) {
+		dev_err(vf->dev, "devlink_port_register failed: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	vf->netdev = alloc_etherdev(sizeof(struct pds_rep));
+	if (!vf->netdev) {
+		err = -ENOMEM;
+		goto err_unreg_port;
+	}
+	SET_NETDEV_DEV(vf->netdev, vf->dev);
+
+	rep = netdev_priv(vf->netdev);
+	rep->pf = pf;
+	rep->vf = vf;
+
+	vf->netdev->netdev_ops = &pdsc_rep_netdev_ops;
+	vf->netdev->ethtool_ops = &pdsc_rep_ethtool_ops;
+	netif_carrier_off(vf->netdev);
+
+	SET_NETDEV_DEVLINK_PORT(vf->netdev,  &vf->dl_port);
+	err = register_netdev(vf->netdev);
+	if (err) {
+		dev_err(vf->dev, "register_netdev failed: %pe\n",
+			ERR_PTR(err));
+		goto err_free_netdev;
+	}
+
+	return 0;
+
+err_free_netdev:
+	free_netdev(vf->netdev);
+	vf->netdev = NULL;
+err_unreg_port:
+	devl_port_unregister(&vf->dl_port);
+	return err;
+}
+
+void pdsc_del_rep(struct pdsc *vf)
+{
+	unregister_netdev(vf->netdev);
+	free_netdev(vf->netdev);
+	vf->netdev = NULL;
+	devl_port_unregister(&vf->dl_port);
+}
+
+int pdsc_dl_eswitch_mode_get(struct devlink *dl, u16 *mode)
+{
+	struct pdsc *pf = devlink_priv(dl);
+
+	*mode = pf->eswitch_mode;
+	return 0;
+}
+
+int pdsc_dl_eswitch_mode_set(struct devlink *dl, u16 mode,
+			     struct netlink_ext_ack *extack)
+{
+	struct pdsc *pf = devlink_priv(dl);
+	char *msg;
+	int ret = 0;
+	int i;
+
+	if (pf->eswitch_mode == mode)
+		return 0;
+
+	switch (mode) {
+	case DEVLINK_ESWITCH_MODE_LEGACY:
+		for (i = pf->num_vfs - 1; i >= 0; i--)
+			pdsc_del_rep(pf->vfs[i].vf);
+		msg = "Changed eswitch mode to legacy";
+		dev_info(pf->dev, msg);
+		NL_SET_ERR_MSG_FMT_MOD(extack, "%s", msg);
+		break;
+
+	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
+		for (i = 0; i < pf->num_vfs && !ret; i++)
+			ret = pdsc_add_rep(pf->vfs[i].vf, pf);
+		if (ret) {
+			for (i-- ; i >= 0; i--)
+				pdsc_del_rep(pf->vfs[i].vf);
+			return ret;
+		}
+
+		msg = "Changed eswitch mode to switchdev";
+		dev_info(pf->dev, msg);
+		NL_SET_ERR_MSG_FMT_MOD(extack, "%s", msg);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	pf->eswitch_mode = mode;
+
+	return 0;
+}
-- 
2.17.1

