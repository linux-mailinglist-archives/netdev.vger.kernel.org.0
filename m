Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EE0683005
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjAaO7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjAaO6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8690E83EB;
        Tue, 31 Jan 2023 06:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjkVH+BwxzMznXbfAQDR/x0RwQ9PUZLXGyoQX0JpACka4DtF3UmweNY+IxbOsxKI0fBzHSIz1tN2iKdNJ2VzGpfh9/mC8Bue5KJFon7Jb7UCnNu6ZWEo3gIIZyymrZDVxsB9RlXFv4WX0XQ+inGM0e1EqdtsqNHK+ABGrv+tqxSTo7AujBWD2HBxEbgvV5u7oAQQOUTQVAgFKTfYWDfPc0214gWwP/dQmg8OjSBM2fP5Uh5HGlug4TIlbJZjj4OlIrAXvnxTrrQOJ3skRvRwsnYcBKJ+jhAOUw2/NCtMaImob0Srg78+GiRWbN67Iq0mtxZqaLL5bXp03DMfhs7X6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQHb5LLicsBbl5PFYXgEXpelQtGX/1q2ywua6uj8GfI=;
 b=nwHWNJjNUvc2pQKlSzCoU3ALXRE48nJwYEquVdDTmPmTrQEmH+9CKoyrrUrvD+9nOCQ0p6tFBz6s4KTIEiF2L8w8tmb8C9Qm/OJdBOR51FayE1HMnUxzf5E0WvGZYyN+kQ2I3IChcka9NGffTmdwvMy+cP5ECqHyvhmnMu51j+ZGK9yqiSF7Ey3NbqwdJZ8DEcXEWcvUwGqkc7zwSxI8YND43iUv9nxohY5+TDqVGsvJgrJNaHgHNdvrHmgif/RMla4tc92iblBM/1WZH2D+1eG3AR26pbVIAYuesTlfEAKVSVXWEw1unAHIRM0IoORJkoWdl4q1hQvWExIzNoVD5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQHb5LLicsBbl5PFYXgEXpelQtGX/1q2ywua6uj8GfI=;
 b=f7Z2oiUfi7VWaEHKmOghyVHHtgmiYumt5haGvTsj0UnRa9DS0qcZDkgK+hdZa5yUmN7FmnZ36kd6FWndIZKAJFVCQX7d4jqT7YiLdN+X7kTZpTgsEg9JoZU5K4um+n0WV0YiABJXIFmrVTN0pdUvNjtU2uwYSfLrwfUNfdab7EY=
Received: from DM6PR01CA0027.prod.exchangelabs.com (2603:10b6:5:296::32) by
 DM4PR12MB6495.namprd12.prod.outlook.com (2603:10b6:8:bc::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36; Tue, 31 Jan 2023 14:58:46 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::73) by DM6PR01CA0027.outlook.office365.com
 (2603:10b6:5:296::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.22 via Frontend Transport; Tue, 31 Jan 2023 14:58:45 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:45 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:43 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 5/8] sfc: add devlink port support for ef100
Date:   Tue, 31 Jan 2023 14:58:19 +0000
Message-ID: <20230131145822.36208-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|DM4PR12MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f45d4d6-0f82-4416-4492-08db039ba6fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wX4QpHkm1uAeUtPnaUyDNrPjvZ0sMrOmdCE1tA7vtCL+crfMAGIwU1hNYHX2XjZpa5gONPizVHNE4Y0Htd1ND56eyoJ2Q0RrxxJeD6Ir5FUohbAnUC2/nZMCjRD3lnCaJ5+J31uBg910XJnFGnFENxrRHWoBdrUEK4hdbKg2k7E288lOUURggWH+sfv0XLImODyndTonSk3lpHbNnOb2nV4dMkT+TugFVCMqeItvQNdVbvzrkgTMJcthqEsRfj4fv1biilnOdbClja8wG/T038SxwIKSAf1VUDhMfH5UcMLcPzpsIhr8WG2HRBJi++Xau9R0e+37a0fIUI0zC3SikYiW92jedQjIOL8/FqDoGXjzip/VstVKHd5uQHQ3etTVnuGAIhc5Hw7Fc/7mDIZENEhJJ5ZJk7xXRd18VVs/hJJEz43qr+sH9lp58QEmBrhK6JytOaW79tddOF1aLBu0ILAMAhJGev8BIpPdA45VotwfRyQNbu0LTWWpFMlgF8EDGJ/zEW6+9KPo2OVzuvuJ8WbiKZEoNIGPYfmwwqqZ5k4ygTa39vduElrXoKV6OkkKuZ5j20+B6yXA13IfeSjzTNvOZ13b0nWwAESwqOkSo179uTI7unDqKxri7IOs5epCXbClIunyEdvsOjieACRb/40Cmg9Nb2wNUoj042FDevJxSw75NUQQNucXOBAZyv6zwsrz0FkPlJBKYtXKrvD0h2PoyVsr1+rJJ6+Z1jZt/N4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(81166007)(40460700003)(356005)(41300700001)(86362001)(5660300002)(7416002)(83380400001)(426003)(47076005)(336012)(54906003)(110136005)(4326008)(2616005)(82740400003)(6636002)(8676002)(70586007)(70206006)(40480700001)(316002)(6666004)(186003)(1076003)(36756003)(26005)(36860700001)(478600001)(82310400005)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:45.8575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f45d4d6-0f82-4416-4492-08db039ba6fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Using the data when enumerating mports, create devlink ports just before
netdevs are registered and remove those devlink ports after netdev has
been unregistered.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  9 +++
 drivers/net/ethernet/sfc/ef100_rep.c    | 22 ++++++
 drivers/net/ethernet/sfc/ef100_rep.h    |  7 ++
 drivers/net/ethernet/sfc/efx_devlink.c  | 97 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |  6 ++
 drivers/net/ethernet/sfc/mae.h          |  2 +
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 7 files changed, 145 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index b10a226f4a07..36774b55d413 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -335,7 +335,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 
 	/* devlink lock */
 	efx_fini_devlink_start(efx);
+
 	ef100_unregister_netdev(efx);
+	ef100_pf_unset_devlink_port(efx);
 
 #ifdef CONFIG_SFC_SRIOV
 	efx_fini_tc(efx);
@@ -423,6 +425,8 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		rc = ef100_probe_netdev_pf(efx);
 		if (rc)
 			goto fail;
+
+		ef100_pf_set_devlink_port(efx);
 	}
 
 	efx->netdev_notifier.notifier_call = ef100_netdev_event;
@@ -433,7 +437,12 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		goto fail;
 	}
 
+	/* devlink unlock */
+	efx_probe_devlink_done(efx);
+	return rc;
 fail:
+	/* remove devlink port if does exist */
+	ef100_pf_unset_devlink_port(efx);
 	/* devlink unlock */
 	efx_probe_devlink_done(efx);
 	return rc;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 9cd1a3ac67e0..6b5bc5d6955d 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -16,6 +16,7 @@
 #include "mae.h"
 #include "rx_common.h"
 #include "tc_bindings.h"
+#include "efx_devlink.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
@@ -297,6 +298,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 			i, rc);
 		goto fail1;
 	}
+	ef100_rep_set_devlink_port(efv);
 	rc = register_netdev(efv->net_dev);
 	if (rc) {
 		pci_err(efx->pci_dev,
@@ -308,6 +310,7 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 		efv->net_dev->name);
 	return 0;
 fail2:
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 fail1:
 	efx_ef100_rep_destroy_netdev(efv);
@@ -323,6 +326,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
 		return;
 	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
 	unregister_netdev(rep_dev);
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 	efx_ef100_rep_destroy_netdev(efv);
 }
@@ -339,6 +343,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
 
+static bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
+{
+	return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
+	       mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
+}
+
+bool ef100_mport_on_local_intf(struct efx_nic *efx,
+			       struct mae_mport_desc *mport_desc)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	bool pcie_func;
+
+	pcie_func = ef100_mport_is_pcie_vnic(mport_desc);
+
+	return nic_data->have_local_intf && pcie_func &&
+		     mport_desc->interface_idx == nic_data->local_mae_intf;
+}
+
 void efx_ef100_init_reps(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 328ac0cbb532..ae6add4b0855 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -22,6 +22,8 @@ struct efx_rep_sw_stats {
 	atomic64_t rx_dropped, tx_errors;
 };
 
+struct devlink_port;
+
 /**
  * struct efx_rep - Private data for an Efx representor
  *
@@ -39,6 +41,7 @@ struct efx_rep_sw_stats {
  * @rx_lock: protects @rx_list
  * @napi: NAPI control structure
  * @stats: software traffic counters for netdev stats
+ * @dl_port: devlink port associated to this netdev representor
  */
 struct efx_rep {
 	struct efx_nic *parent;
@@ -54,6 +57,7 @@ struct efx_rep {
 	spinlock_t rx_lock;
 	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
+	struct devlink_port *dl_port;
 };
 
 int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
@@ -69,4 +73,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 extern const struct net_device_ops efx_ef100_rep_netdev_ops;
 void efx_ef100_init_reps(struct efx_nic *efx);
 void efx_ef100_fini_reps(struct efx_nic *efx);
+struct mae_mport_desc;
+bool ef100_mport_on_local_intf(struct efx_nic *efx,
+			       struct mae_mport_desc *mport_desc);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index ff5adfe3905e..b1637eb372ad 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -16,11 +16,48 @@
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
+#include "mae.h"
+#include "ef100_rep.h"
 
 struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+static void efx_devlink_del_port(struct devlink_port *dl_port)
+{
+	if (!dl_port)
+		return;
+	devl_port_unregister(dl_port);
+}
+
+static int efx_devlink_add_port(struct efx_nic *efx,
+				struct mae_mport_desc *mport)
+{
+	bool external = false;
+
+	if (!ef100_mport_on_local_intf(efx, mport))
+		external = true;
+
+	switch (mport->mport_type) {
+	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL)
+			devlink_port_attrs_pci_vf_set(&mport->dl_port, 0, mport->pf_idx,
+						      mport->vf_idx,
+						      external);
+		else
+			devlink_port_attrs_pci_pf_set(&mport->dl_port, 0, mport->pf_idx,
+						      external);
+		break;
+	default:
+		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
+		return 0;
+	}
+
+	mport->dl_port.index = mport->mport_id;
+
+	return devl_port_register(efx->devlink, &mport->dl_port, mport->mport_id);
+}
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -428,6 +465,66 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 };
 
+static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
+{
+	struct mae_mport_desc *mport;
+	u32 id;
+
+	if (efx_mae_lookup_mport(efx, idx, &id)) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn(efx->pci_dev, "No mport ID found for PF.\n");
+		else
+			pci_warn(efx->pci_dev, "No mport ID found for VF %u.\n",
+				 idx);
+		return NULL;
+	}
+
+	mport = efx_mae_get_mport(efx, id);
+	if (!mport) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn(efx->pci_dev, "No mport found for PF.\n");
+		else
+			pci_warn(efx->pci_dev, "No mport found for VF %u.\n",
+				 idx);
+		return NULL;
+	}
+
+	if (efx_devlink_add_port(efx, mport)) {
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn(efx->pci_dev,
+				 "devlink port creation for PF failed.\n");
+		else
+			pci_warn(efx->pci_dev,
+				 "devlink_port creationg for VF %u failed.\n",
+				 idx);
+		return NULL;
+	}
+
+	return &mport->dl_port;
+}
+
+void ef100_rep_set_devlink_port(struct efx_rep *efv)
+{
+	efv->dl_port = ef100_set_devlink_port(efv->parent, efv->idx);
+}
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx)
+{
+	efx->dl_port = ef100_set_devlink_port(efx, MAE_MPORT_DESC_VF_IDX_NULL);
+}
+
+void ef100_rep_unset_devlink_port(struct efx_rep *efv)
+{
+	efx_devlink_del_port(efv->dl_port);
+}
+
+void ef100_pf_unset_devlink_port(struct efx_nic *efx)
+{
+	efx_devlink_del_port(efx->dl_port);
+}
+
 void efx_fini_devlink_start(struct efx_nic *efx)
 {
 	if (efx->devlink)
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index 8bcd077d8d8d..d453a180c44c 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -36,4 +36,10 @@ void efx_probe_devlink_done(struct efx_nic *efx);
 void efx_fini_devlink_start(struct efx_nic *efx);
 void efx_fini_devlink(struct efx_nic *efx);
 
+struct efx_rep;
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx);
+void ef100_rep_set_devlink_port(struct efx_rep *efv);
+void ef100_pf_unset_devlink_port(struct efx_nic *efx);
+void ef100_rep_unset_devlink_port(struct efx_rep *efv);
 #endif	/* _EFX_DEVLINK_H */
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index d9adeafc0654..e1b7967132ad 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -13,6 +13,7 @@
 #define EF100_MAE_H
 /* MCDI interface for the ef100 Match-Action Engine */
 
+#include <net/devlink.h>
 #include "net_driver.h"
 #include "tc.h"
 #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
@@ -44,6 +45,7 @@ struct mae_mport_desc {
 	};
 	struct rhash_head linkage;
 	struct efx_rep *efv;
+	struct devlink_port dl_port;
 };
 
 int efx_mae_enumerate_mports(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index bc9efbfb3d6b..fcd51d3992fa 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -998,6 +998,7 @@ struct efx_mae;
  * @netdev_notifier: Netdevice notifier.
  * @tc: state for TC offload (EF100).
  * @devlink: reference to devlink structure owned by this device
+ * @dl_port: devlink port associated with the PF
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1185,6 +1186,7 @@ struct efx_nic {
 	struct efx_tc_state *tc;
 
 	struct devlink *devlink;
+	struct devlink_port *dl_port;
 	unsigned int mem_bar;
 	u32 reg_base;
 
-- 
2.17.1

