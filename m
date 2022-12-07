Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBAF645CF7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLGO4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLGO4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:56:24 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA294F1A5;
        Wed,  7 Dec 2022 06:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8uEyz+uEPcLjv43iUGevFNBoDWhO5mISA3jjZlAAYm8ZCrvUJr0XZFtArwKahrSDpvhFSJlY30ORJOfXOp1fiiByz/DZqK5HlURqsDEzk3XyA1dRn4o7vet2ezeR6/A0DpYRvRYb3ZWBC6Iomvm+XSkBQabCX2T/s6qjUoY6bE1ys4Hut1MPKHpImyQ/0KQekTHxgkKa4B0feAFgSAZpa0Zvn4HBqNJgWlf6bnVONj1Uq74uZ2e1/T1cTIsOUgpJaq6rRQWRsgz+9F31QwB+3qG/54Jk68TpfZ1Y8eUefGY1bx2yoXuyOMlI4kaOZv+gx/xkwrdk15gIg+8o0CDbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hip/ibXfIEvyJAj0mTWh/48v0JyNcGhhrokubS6rWDI=;
 b=FzVEWznR0E5L6roy6lsA5lkYdHRAMtgbAlPsPL1nXwhGU3pBZPJlE2Wg9oa5LVs5wOezV8pFMt5RWkpKpkvfxOIMDBxM8/kGfbkun/k+65XzXxREevGA1T3Pz/Lz3cwZkNmvkhvP9+YZcFxTJwLM92Y2PmB1s28I9mOHV9darGcODwXdACqUY7A6VpsMzE2At2gf00H6EkqhZXGW7ZGopUyZDPRSQrSx/6EZsTP33FiQTjTEU+78tvs3D6muNqTGTrPu4UoEUFpb9NUAbNA+v3Zebu8hHNfaop2qzh/GpQjPCMDxM3QGS/Pb6Du0WJuyZlFHb8DDZ1wJboncHObDnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hip/ibXfIEvyJAj0mTWh/48v0JyNcGhhrokubS6rWDI=;
 b=MD9wHCyyRp5PszgsLg3rq2EDSss41TxsBaleSNKQ21eu6+lEVH6TxMryLRpra6JWELb7cTsW9pV/u40DcCEbLm4gar6TFKOhaW9ZWb67mINYvcCCFlqEsV6TN+qIMsvLgHxSX0WVbB4gLoKFsDk+0GtuZy8F4DeliyZZ34evgPw=
Received: from DM6PR08CA0028.namprd08.prod.outlook.com (2603:10b6:5:80::41) by
 MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:56:20 +0000
Received: from DS1PEPF0000E655.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::2) by DM6PR08CA0028.outlook.office365.com
 (2603:10b6:5:80::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:56:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E655.mail.protection.outlook.com (10.167.18.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:56:19 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:56:15 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 06:56:11 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:56:07 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 01/11] sfc: add function personality support for EF100 devices
Date:   Wed, 7 Dec 2022 20:24:17 +0530
Message-ID: <20221207145428.31544-2-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E655:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: bce1f5f4-88ab-4de6-64af-08dad8633303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhZcrYannvw0brYX3U4S6KSgIYewgUFLpqh/speCne4QeVI4KpUrv7l5ldfaIcNmpfKh2fEXsLNNk97bssoG/1C3xEB+rzfWJ/cDaTZvDEHJz1hv0d6PaNZMGUYpmTGL12G8r4SQQERvyy33JmjABAzTqFJY7KGXA/LMz4H1X/ikl7XgfPJVSvNIdDWwMUILQXYHBepZfOpnuya1PTiXAM+jvNrTI99FlpWI6xMpze2BGOyDIHIQwQ8Wa5JubLcSkX4ijl0oliGBoLL74f3OAWkHbq6n4q9LCU0iEF60NvwvRBPD8n8dR47n9dt0HNt+wK/3900045lQ9pX8MrtTEc3TF4T8nU20ADXTygtM1zyg+80Nzo9sdFhGmYU1Qab0no5BytqKCg/vd9UmF7zobiXOwy8HKZG2oYUOOTfxwpUa7heVmtTle0D4+gM6vCgiTvk9lvE6FZG6n13CdoaNt3+yHP7JKt9Gotj9GT2qxa8r0sWV/f3zdqwt6lzsJ2VtDvNLuz0eVHVQligZYloDM+FxgSZdm8kfuDhdThyJK93RrgEh2vl/XMxadJ9l0FLn78UPMNGgzwgBD/0w2qXqpPICX2DrsL8/8OxSHBJmI1FfSRYjzZQ3X1A/KYgdi5BruPb+cydFEEnPocBN9Mj5n8wyBR8TvN4zeWktKe0vhVMzqQ+JofleaGU3NsOyIOP8o5U6ogI2gsrQxx4zUzXW+AZLHv5dQyle/L8rtkhr8Mc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(70206006)(70586007)(36860700001)(8676002)(356005)(478600001)(4326008)(40480700001)(6666004)(82740400003)(81166007)(1076003)(110136005)(54906003)(186003)(82310400005)(8936002)(86362001)(44832011)(336012)(40460700003)(41300700001)(83380400001)(2906002)(47076005)(7416002)(426003)(2616005)(5660300002)(26005)(316002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:56:19.4787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bce1f5f4-88ab-4de6-64af-08dad8633303
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E655.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function personality defines the location and semantics of
registers in the BAR. EF100 NICs allow different personalities
of a PCIe function and changing it at run-time. A total of three
function personalities are defined as of now: EF100, vDPA and
None with EF100 being the default.
For now, vDPA net devices can be created on a EF100 virtual
function and the VF personality will be changed to vDPA in the
process.

Co-developed-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100.c     |  6 +-
 drivers/net/ethernet/sfc/ef100_nic.c | 98 +++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_nic.h | 11 ++++
 3 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
index 71aab3d0480f..c1c69783db7b 100644
--- a/drivers/net/ethernet/sfc/ef100.c
+++ b/drivers/net/ethernet/sfc/ef100.c
@@ -429,8 +429,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	if (!efx)
 		return;
 
-	probe_data = container_of(efx, struct efx_probe_data, efx);
-	ef100_remove_netdev(probe_data);
+	efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_NONE);
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_struct_tc(efx);
 #endif
@@ -443,6 +442,7 @@ static void ef100_pci_remove(struct pci_dev *pci_dev)
 	pci_disable_pcie_error_reporting(pci_dev);
 
 	pci_set_drvdata(pci_dev, NULL);
+	probe_data = container_of(efx, struct efx_probe_data, efx);
 	efx_fini_struct(efx);
 	kfree(probe_data);
 };
@@ -508,7 +508,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
 		goto fail;
 
 	efx->state = STATE_PROBED;
-	rc = ef100_probe_netdev(probe_data);
+	rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
 	if (rc)
 		goto fail;
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index ad686c671ab8..a57ec6d5b781 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -751,6 +751,99 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 }
 #endif
 
+/* BAR configuration.
+ * To change BAR configuration, tear down the current configuration (which
+ * leaves the hardware in the PROBED state), and then initialise the new
+ * BAR state.
+ */
+struct ef100_bar_config_ops {
+	int (*init)(struct efx_probe_data *probe_data);
+	void (*fini)(struct efx_probe_data *probe_data);
+};
+
+static const struct ef100_bar_config_ops bar_config_ops[] = {
+	[EF100_BAR_CONFIG_EF100] = {
+		.init = ef100_probe_netdev,
+		.fini = ef100_remove_netdev
+	},
+#ifdef CONFIG_SFC_VDPA
+	[EF100_BAR_CONFIG_VDPA] = {
+		.init = NULL,
+		.fini = NULL
+	},
+#endif
+	[EF100_BAR_CONFIG_NONE] = {
+		.init = NULL,
+		.fini = NULL
+	},
+};
+
+/* Keep this in sync with the definition of enum ef100_bar_config. */
+static char *bar_config_name[] = {
+	[EF100_BAR_CONFIG_NONE] = "None",
+	[EF100_BAR_CONFIG_EF100] = "EF100",
+	[EF100_BAR_CONFIG_VDPA] = "vDPA",
+};
+
+#ifdef CONFIG_SFC_VDPA
+static bool efx_vdpa_supported(struct efx_nic *efx)
+{
+	return efx->type->is_vf;
+}
+#endif
+
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config)
+{
+	const struct ef100_bar_config_ops *old_config_ops;
+	const struct ef100_bar_config_ops *new_config_ops;
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_probe_data *probe_data;
+	enum ef100_bar_config old_config;
+	int rc;
+
+	if (WARN_ON_ONCE(nic_data->bar_config > EF100_BAR_CONFIG_VDPA))
+		return -EINVAL;
+
+#ifdef CONFIG_SFC_VDPA
+	/* Current EF100 hardware supports vDPA on VFs only */
+	if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
+		pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
+			efx->name);
+		return -EOPNOTSUPP;
+	}
+#endif
+	mutex_lock(&nic_data->bar_config_lock);
+	old_config = nic_data->bar_config;
+	if (new_config == old_config) {
+		mutex_unlock(&nic_data->bar_config_lock);
+		return 0;
+	}
+
+	old_config_ops = &bar_config_ops[old_config];
+	new_config_ops = &bar_config_ops[new_config];
+
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	if (old_config_ops->fini)
+		old_config_ops->fini(probe_data);
+	nic_data->bar_config = EF100_BAR_CONFIG_NONE;
+
+	if (new_config_ops->init) {
+		rc = new_config_ops->init(probe_data);
+		if (rc) {
+			mutex_unlock(&nic_data->bar_config_lock);
+			return rc;
+		}
+	}
+
+	nic_data->bar_config = new_config;
+	pci_dbg(efx->pci_dev, "BAR configuration changed to %s\n",
+		bar_config_name[new_config]);
+	mutex_unlock(&nic_data->bar_config_lock);
+
+	return 0;
+}
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1004,6 +1097,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
+	mutex_init(&nic_data->bar_config_lock);
 	efx->max_vis = EF100_MAX_VIS;
 
 	/* Populate design-parameter defaults */
@@ -1159,8 +1253,10 @@ void ef100_remove(struct efx_nic *efx)
 
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
-	if (nic_data)
+	if (nic_data) {
 		efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
+		mutex_destroy(&nic_data->bar_config_lock);
+	}
 	kfree(nic_data);
 	efx->nic_data = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 0295933145fa..5ed693fbe79f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -61,6 +61,13 @@ enum {
 	EF100_STAT_COUNT
 };
 
+/* Keep this in sync with the contents of bar_config_name. */
+enum ef100_bar_config {
+	EF100_BAR_CONFIG_NONE,
+	EF100_BAR_CONFIG_EF100,
+	EF100_BAR_CONFIG_VDPA,
+};
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -71,6 +78,8 @@ struct ef100_nic_data {
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
+	enum ef100_bar_config bar_config;
+	struct mutex bar_config_lock; /* lock to control access to bar config */
 	u64 stats[EF100_STAT_COUNT];
 	u32 base_mport;
 	bool have_mport; /* base_mport was populated successfully */
@@ -88,4 +97,6 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx);
 int ef100_phy_probe(struct efx_nic *efx);
 int ef100_filter_table_probe(struct efx_nic *efx);
 
+int efx_ef100_set_bar_config(struct efx_nic *efx,
+			     enum ef100_bar_config new_config);
 #endif	/* EFX_EF100_NIC_H */
-- 
2.30.1

