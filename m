Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B1A69B5C3
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQW5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBQW5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:18 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8494667835
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLyN7vAe+ZH4KBdPnH0AVCa1iRNnOMIMpzr/wKkmzD6MfUQO2w7KPVCbbrn3wmdaQ+n23md/F+rEnFvJ34U42SKAvJg93ucIZxkzmzhrTmiIcIwhHrWYlPLB6TD8BMaZoFchzmNq+j4eugfsia0T16RurzeMySVvs2++74e0NqUqsqB98wrkZ+ffKqXGp02m3EQxFS8U8pM7BrmaX6N4+g+41Jvl5VOQvabC9CDz0H2k+uQrFufy17T/lOtRC1TE+KjzV1CEH33idoNmgKzpq0c5bqObMrlLW9P/HtYMTp0nkK1O6aJS+PBA/kypYc5f9N8ng2p0FGErC7FcVi+rcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeCZJ4g8fvt7tbqp7PE44TB55VUUzgRRvGL0ZAG6Ylo=;
 b=cjo/R6pqU5kcDGnAcIYr5AFvwnBqPUAq17XGSIxSlDq5PHk3FmU0bM47d+CwKVNn3GbeGF/xNfO7WjhkMT2SLhIXRbmgHACah1XI/HRRmMATvvs4y6iuk+JuFRzR269ltLYMJH2BbEr8GqpVOC7xduB8GBGJ+4tL+YeQTdV1h8bJ6TWR6dDVfJCzAFNR5cNmZkAqIhnKhOXcVtiN2xN3B+yGuoJw/FvxIJQeuknJ29u1jaBPJP9fOeebYbozEyTgbGJt5AzqXv1hbJBu9Ljd4NFik5n9h41CJOGTIGh8l6zbjXu6jX7lqSLmbPxTV6MEhm8KwYL+ABIeJ5iyzUQMRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeCZJ4g8fvt7tbqp7PE44TB55VUUzgRRvGL0ZAG6Ylo=;
 b=MxSB8mB1w3Zwwd7T21eeclu3aCLEVUsOUF+KFSINVCvOz3PA1LWx+Cjfjc+DRhjMA7cSXSqQFXMjGYv7pHPlCTyk+vm+/UVSG2/QMvRrhQje3h2DGExtOAtL2sWBSzDkuLLFiAZTAFtPSVXUYgVfYOmT4VEuGxgz04TYdvTUsYs=
Received: from DS7PR05CA0021.namprd05.prod.outlook.com (2603:10b6:5:3b9::26)
 by SJ2PR12MB7896.namprd12.prod.outlook.com (2603:10b6:a03:4c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 22:56:45 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::4e) by DS7PR05CA0021.outlook.office365.com
 (2603:10b6:5:3b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.12 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:44 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:42 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Fri, 17 Feb 2023 14:55:52 -0800
Message-ID: <20230217225558.19837-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|SJ2PR12MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 5486eec5-2ba7-4a16-2338-08db113a3df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IySUuR4TTUamLAC2PG6Q486K6PrljV0vX0D3xFW/DrfkYmPSIb4tW3VjyyUbau2LDIvOvHgtS8NVzQkPEosA4KWuQweECmkuxkKbqCNZ+PcXf8CbF7M2iTaKv8aUGIFO2EsvM8kYgNJoqZfxQaoRUPU8VuYvD/8vczdKTtRmL1OknaQG0uQBtqTYAJ/v5MwySGcCsGpf/WCHOHP5Gb9KdZb9lx7+v6UmMUyvTk1KlNxbY1H+rmf3v9bEPrmRJuHWOYSV7vl1CQtFFZZOOYLdXSS7qdmxeWi0bZsD3lBS58gdetjRfVQuxJVyZOQtuInT0w7cEC5uhMLQc66xH7fp8K8Izra+pLDn9i3ckE6UGj4fExbxs3giCJTi8B1nIyxDp4sbt7W765JGSnVu3YLyYMZBj7hQ4m2MkjPInrglvCv0U1y7SszFBnI49vRXJVxVKLPdNb6Iy6nFI2GcqpIBi0WgoXQ+stpwfM0M32cDan8kg24KA4mcITFD7KK0/Yc+Yis5EMdO6gfNXJkW+5QEhPRjPhT6LRYTxW01RfbpAZe9D5p3wpe4z6VNIpp7piqQw2/bpGtS4V6JDxwv/FTXmqMMb8iOUg/x/pQcjRx5Xrto+RGnbn+5BttIJVW8cAvWxsPbQ34kgBcpm4tB27vPiCEFz+5h8+XGsk8B+8uxye/t+t8HxMOt9riaM6W1pDEras2T0EEFxuvbhS9DHNbsfBSqYmkFOmkdxjw4uQsFZrOgFZHRGn1pya1ySKPrnTJ1eoJ4bXFcDPNZXhP94UGyzw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(36840700001)(46966006)(40470700004)(44832011)(8936002)(70206006)(41300700001)(5660300002)(2906002)(82310400005)(36756003)(54906003)(8676002)(316002)(4326008)(110136005)(70586007)(478600001)(82740400003)(81166007)(356005)(26005)(426003)(47076005)(2616005)(336012)(6666004)(1076003)(16526019)(186003)(36860700001)(86362001)(40480700001)(40460700003)(83380400001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:44.7007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5486eec5-2ba7-4a16-2338-08db113a3df9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7896
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Virtual Interfaces (VIFs) supported by the DSC's
configuration (VFio Live Migration, vDPA, etc) are reported
in the dev_ident struct.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c    | 54 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h    | 13 +++++
 drivers/net/ethernet/amd/pds_core/debugfs.c | 23 +++++++++
 include/linux/pds/pds_common.h              | 17 +++++++
 4 files changed, 107 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 0b785aae9189..393ec10ad745 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -358,6 +358,47 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	return err;
 }
 
+static struct pdsc_viftype pdsc_viftype_defaults[] = {
+	[PDS_DEV_TYPE_VDPA] = { .name = PDS_DEV_TYPE_VDPA_STR,
+				.vif_id = PDS_DEV_TYPE_VDPA,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET },
+	[PDS_DEV_TYPE_LM]   = { .name = PDS_DEV_TYPE_LM_STR,
+				.vif_id = PDS_DEV_TYPE_LM,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION},
+	[PDS_DEV_TYPE_MAX] = { 0 }
+};
+
+static int pdsc_viftypes_init(struct pdsc *pdsc)
+{
+	enum pds_core_vif_types vt;
+
+	pdsc->viftype_status = devm_kzalloc(pdsc->dev,
+					    sizeof(pdsc_viftype_defaults),
+					    GFP_KERNEL);
+	if (!pdsc->viftype_status)
+		return -ENOMEM;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		bool vt_support;
+
+		if (!pdsc_viftype_defaults[vt].name)
+			continue;
+
+		/* Grab the defaults */
+		pdsc->viftype_status[vt] = pdsc_viftype_defaults[vt];
+
+		/* See what the Core device has for support */
+		vt_support = !!le16_to_cpu(pdsc->dev_ident.vif_types[vt]);
+		dev_dbg(pdsc->dev, "VIF %s is %ssupported\n",
+			pdsc->viftype_status[vt].name,
+			vt_support ? "" : "not ");
+
+		pdsc->viftype_status[vt].supported = vt_support;
+	}
+
+	return 0;
+}
+
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int numdescs;
@@ -400,6 +441,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (err)
 		goto err_out_teardown;
 
+	/* Set up the VIFs */
+	err = pdsc_viftypes_init(pdsc);
+	if (err)
+		goto err_out_teardown;
+
+	if (init)
+		pdsc_debugfs_add_viftype(pdsc);
+
 	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
 	return 0;
 
@@ -416,6 +465,11 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	if (pdsc->viftype_status) {
+		devm_kfree(pdsc->dev, pdsc->viftype_status);
+		pdsc->viftype_status = NULL;
+	}
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index d87d6d9e625e..0355a0b850eb 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -123,6 +123,15 @@ struct pdsc_qcq {
 	struct dentry *dentry;
 };
 
+struct pdsc_viftype {
+	char *name;
+	bool supported;
+	bool enabled;
+	int dl_id;
+	int vif_id;
+	struct pds_auxiliary_dev *padev;
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
@@ -173,6 +182,7 @@ struct pdsc {
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
+	struct pdsc_viftype *viftype_status;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -227,6 +237,7 @@ struct pdsc *pdsc_dl_alloc(struct device *dev);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
 void pdsc_dl_unregister(struct pdsc *pdsc);
+int pdsc_dl_vif_add(struct pdsc *pdsc, enum pds_core_vif_types vt, const char *name);
 
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
@@ -234,6 +245,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
@@ -243,6 +255,7 @@ static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq) { }
 static inline void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq) { }
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index dd7291e4d205..5766b2d4204f 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -82,6 +82,29 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 	debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
 }
 
+static int viftype_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	int vt;
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		if (!pdsc->viftype_status[vt].name)
+			continue;
+
+		seq_printf(seq, "%s\t%d supported %d enabled\n",
+			   pdsc->viftype_status[vt].name,
+			   pdsc->viftype_status[vt].supported,
+			   pdsc->viftype_status[vt].enabled);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(viftype);
+
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc)
+{
+	debugfs_create_file("viftypes", 0400, pdsc->dentry, pdsc, &viftype_fops);
+}
+
 static int irqs_show(struct seq_file *seq, void *v)
 {
 	struct pdsc *pdsc = seq->private;
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index fd889c01f24e..93ce1256e8ff 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -50,6 +50,23 @@ enum pds_core_driver_type {
 	PDS_DRIVER_ESXI    = 6,
 };
 
+enum pds_core_vif_types {
+	PDS_DEV_TYPE_VDPA	= 1,
+	PDS_DEV_TYPE_VFIO	= 2,
+	PDS_DEV_TYPE_ETH	= 3,
+	PDS_DEV_TYPE_RDMA	= 4,
+	PDS_DEV_TYPE_LM		= 5,
+
+	/* new ones added before this line */
+	PDS_DEV_TYPE_MAX	= 16   /* don't change - used in struct size */
+};
+
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_DEV_TYPE_VFIO_STR	"VFio"
+#define PDS_DEV_TYPE_ETH_STR	"Eth"
+#define PDS_DEV_TYPE_RDMA_STR	"RDMA"
+#define PDS_DEV_TYPE_LM_STR	"LM"
+
 #define PDS_CORE_IFNAMSIZ		16
 
 /**
-- 
2.17.1

