Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD06C8584
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCXTDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCXTDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4331F1689B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZAqu4ayqbMfyRzIgQzY4S2V/tEsvvS9mReIimVcv5p3rDqy4LIe2dDlYqv7DUXrSfq/PFpw0plyhCIvxGhljxSp50eZZtPHWG75CUnSQ+MozhRnNtRCK7D4q5db7i3S33wd+s75jZQapJ8STiOGGGB6pOBvFHuS2TVkp906iqpbO1jT51psufibC8TmjQQg7yRiKeTcnQd0lLai+ZaHzGNK+Bhr16wBAG0hn594P0uKBp9TwyH4uwumzCFwWLoYwoXDCEvyTG8FOr1Oa4/VKzTkeICrM5e1k0z+wkE6feB6eLjLwihkj2AxKrLMVWnM4//ozqNXjJBfhmuBSnARIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HJWzfeUCO/bI93ULhMqaIpajfGw5GszKQ1Ck1eDLAM=;
 b=WXv5aflM4pIlWvw+eE2/Lei2DDk1Nfad9XBZkEcSRiJTa6phsZuQADtO+K9ghXozSnzd0ve8zLskHbYuvrYip256MmDCROfLhcTmFTwK0s6iUpJeZxg12FS9b3sim43sT7A4qfaO7SuxqEbIATgXSRWSX+1G8EFqnLhao59huXaupI9ZgLca7nTznp7jplT+EiyCUjXedcUImvJ2L/pF/IhAZOGtBkwDA7fBQMm3to2Dd8/NtOhXjE4lrjgiMYf78VDkfbqFQzxeCGPrGWnIInqV3HHBsszXq3wzHIK6Vm5fCRsY3bYpS1FqM9ZUG6iH4J4+XA4MZW706vneremEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HJWzfeUCO/bI93ULhMqaIpajfGw5GszKQ1Ck1eDLAM=;
 b=saa+n2/pMON5gqd9jiBNH76AXlLSez9zjENuql9PhGD1usZk1JK0hbvtzJsBbu/TZtNsdZ3zIFcx53BfcUWyX4t49E9HgemHNLr9n5OW755jRAyZtDWMro4rSoGCvef77rutkdau5NXMVx1DbaAEVL4bi6bCCRdC2UJfRU268f0=
Received: from DM6PR02CA0154.namprd02.prod.outlook.com (2603:10b6:5:332::21)
 by CH2PR12MB4858.namprd12.prod.outlook.com (2603:10b6:610:67::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:13 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::b0) by DM6PR02CA0154.outlook.office365.com
 (2603:10b6:5:332::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:13 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:12 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 08/14] pds_core: set up the VIF definitions and defaults
Date:   Fri, 24 Mar 2023 12:02:37 -0700
Message-ID: <20230324190243.27722-9-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|CH2PR12MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a24194-4b06-4ea2-0bd3-08db2c9a6aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3u/0zuApwFb73DR4ppz+Cdhy69LZ9x3MJEAjSOfMbB7ihb/DDoJean/CMHQr7rxk5j5+tF4aHfKZCOM+1G7zJHIlexAr9Oxz9WZiVDoRpErp2zHJRB2MWv5YSBFZ41Q4SuBBEIBk2Ewmx43D9rUr4e5dvvyGD7z5hIY7TjeC8LmVrjG9cqMyBggqGZHsK4wA7SmSvgDlB+gNbFcLnk6cncs3YNM69a9nOPVLBdRBLo1XeghPU/YqgOFqX1b5TzZ0tnPGsYxWFnFARKSllBZ9lrj9tKBYus6h6Wk9bAIGj8nIhVfZrgXjd29QCa5ToXnYoao153RWohl7U6MxIIrgNECvDZbxB+rbCuVulPwNFScC0tqcHDPLd5hhzsb2rluk4rqn41rwz+g75ChV786sG2r5aBH++YeltQzZCTB25rhIN8uMfN25iwS2AxblCGmcLSdGqLcmDkaf4Z+NrCsX2YREQP7XqtjAxKzkskSwxJkGnidcNhFRHKQFdstxrDOomBFxwPQr/csSeFu8KlS9bVV6ga68vOdJad7eOQbZDq0ApSjN2nHKz+dIFLpIygOFWWzJKcTMqZYJXlgBL/6i9EpVS9+x0pVfnST5bAM1WxSQ7dLFM7Obbu/ynLxrK4LjQMQWWhUmKADWitgep5Enu5EIITe41lGo08qN51INXTijLgn3d9yhaN7I0r71CGtP9Xh8AjlKqwGPPbRMogmG171IdGddmBsA9J/Snop5jwQpRT22r8cDtETJfZ71Ot7p7JzPDYLvUoItj2HwhL5tg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(86362001)(8676002)(4326008)(70586007)(8936002)(70206006)(478600001)(41300700001)(110136005)(16526019)(82310400005)(5660300002)(44832011)(82740400003)(54906003)(316002)(40460700003)(356005)(81166007)(2906002)(36756003)(1076003)(2616005)(336012)(186003)(6666004)(26005)(47076005)(83380400001)(426003)(40480700001)(36860700001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:13.0644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a24194-4b06-4ea2-0bd3-08db2c9a6aca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4858
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/core.c    | 48 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h    | 14 ++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c | 24 +++++++++++
 include/linux/pds/pds_common.h              | 19 ++++++++
 4 files changed, 105 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 1babb1b4c04c..6b2884f64419 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -350,6 +350,43 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	return err;
 }
 
+static struct pdsc_viftype pdsc_viftype_defaults[] = {
+	[PDS_DEV_TYPE_VDPA] = { .name = PDS_DEV_TYPE_VDPA_STR,
+				.vif_id = PDS_DEV_TYPE_VDPA,
+				.dl_id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET },
+	[PDS_DEV_TYPE_MAX] = { 0 }
+};
+
+static int pdsc_viftypes_init(struct pdsc *pdsc)
+{
+	enum pds_core_vif_types vt;
+
+	pdsc->viftype_status = kzalloc(sizeof(pdsc_viftype_defaults),
+				       GFP_KERNEL);
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
@@ -392,6 +429,14 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
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
 
@@ -408,6 +453,9 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
 	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
 
+	kfree(pdsc->viftype_status);
+	pdsc->viftype_status = NULL;
+
 	if (pdsc->intr_info) {
 		for (i = 0; i < pdsc->nintrs; i++)
 			pdsc_intr_free(pdsc, i);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index ba2e23ba8ce5..46dd869b60a5 100644
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
 	PDSC_S_FW_DEAD,		    /* stopped, wait on startup or recovery */
@@ -174,6 +183,7 @@ struct pdsc {
 	struct pdsc_qcq adminqcq;
 	struct pdsc_qcq notifyqcq;
 	u64 last_eid;
+	struct pdsc_viftype *viftype_status;
 };
 
 /** enum pds_core_dbell_bits - bitwise composition of dbell values.
@@ -228,6 +238,8 @@ struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
 void pdsc_dl_unregister(struct pdsc *pdsc);
+int pdsc_dl_vif_add(struct pdsc *pdsc, enum pds_core_vif_types vt,
+		    const char *name);
 
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
@@ -235,6 +247,7 @@ void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_viftype(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
 void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
@@ -244,6 +257,7 @@ static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_viftype(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_add_qcq(struct pdsc *pdsc,
 					struct pdsc_qcq *qcq) { }
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index dc3edb8a0628..466a88b0313a 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -83,6 +83,30 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 			    pdsc, &identity_fops);
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
+	debugfs_create_file("viftypes", 0400, pdsc->dentry,
+			    pdsc, &viftype_fops);
+}
+
 static int irqs_show(struct seq_file *seq, void *v)
 {
 	struct pdsc *pdsc = seq->private;
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index e45a69178f74..350295091d9d 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -51,6 +51,25 @@ enum pds_core_driver_type {
 	PDS_DRIVER_ESXI    = 6,
 };
 
+enum pds_core_vif_types {
+	PDS_DEV_TYPE_CORE	= 0,
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
+#define PDS_DEV_TYPE_CORE_STR	"Core"
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

