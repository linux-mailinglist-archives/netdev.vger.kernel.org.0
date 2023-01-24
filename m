Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665CB67A5BC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbjAXWbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjAXWbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:31:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E6951414
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:31:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3blu0dv695neBGK3+ccFpeiZn/OR9gdHjXcygX8XsH/nJJt7iKFNwM3PZ4iBco+TH42NukQ6n+4WNboG87AZiwNg51xrPnvFTY3hEi+gPN2fDrG1ZB3AJMTTNEYaTS5mKdf1YKNxYARud2SDWxlWsNXluuOv7MuyeF7GMbyT3izcEE+OOlkz/lQoKke867zPBKW0YFgPIRX3kLW3UGSY1xiicolRLKmBTM/lMbm4pbfK/vdp5BoYrA4rycoGBKoRxxgIvjpN1/+2DLZBaEERxuOZKbFebs9fqXkgjivnovjXLT0pyY6eFdZoCo2kOkesxLScqQXHkrkI8r+GXuKyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Q+qxvwfBjLxH4nI99thdQlv5a1gQy4gDgN2btLKMtg=;
 b=nJMZ5TFPyo4Qte2QDyVD2STR85aZW+ikzlGKxCbvP8vHV2dJVYBjMXoce+ealrIgIJ+s3D0MsIHv8GSfy6zPlUtllPOefubIzC+bus/bAzI0YmBeYeR+/qU87sSVL/Q12Qze1GUZJ4ZLGd9XjGizWmIJVHl2rF09vADnGBbW/+x2tujJjwdvjJY/gcdeazRjjku8UD05gd0Wyf3RH3E2T1bxJ3K9+xKdtmG6g65U64Qn7r4bTgyrQzK1fW9vaXSkexEZklxSZ2geEOgfDao5fWsfQgRNTm1+7wSdOaqoPRUvXj4yQnNmqrFmj/MZbeoIEOPI3BSq+3++Y86+l60l6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Q+qxvwfBjLxH4nI99thdQlv5a1gQy4gDgN2btLKMtg=;
 b=aWHMaRlpYyzTJ+hantW3YhvfPIvzqTte7+Bj0oLMD85jEn52XR4r6PdJoVfDIavIhI8mIxRDCwOqd8w46D5/wbj3L8vGZSgzdFLKuG3zRHLnEkuLzgC9YVFVzvzB8Nb7H0oGXXfyCXddvZ6Oxv2n177JF7+8htsK64NHky7fbhE=
Received: from DM6PR11CA0045.namprd11.prod.outlook.com (2603:10b6:5:14c::22)
 by DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Tue, 24 Jan 2023 22:30:57 +0000
Received: from DS1PEPF0000E64A.namprd02.prod.outlook.com
 (2603:10b6:5:14c:cafe::b6) by DM6PR11CA0045.outlook.office365.com
 (2603:10b6:5:14c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 22:30:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS1PEPF0000E64A.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.10 via Frontend Transport; Tue, 24 Jan 2023 22:30:57 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:30:56 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 16:30:56 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 24 Jan 2023 16:30:55 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH v2 net-next 5/8] sfc: add devlink port support for ef100
Date:   Tue, 24 Jan 2023 22:30:26 +0000
Message-ID: <20230124223029.51306-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
References: <20230124223029.51306-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64A:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: 7247bf32-cc5a-4bcb-812f-08dafe5aa9f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSTH6LsQHF6ToKCF5p8l3XAHWgV9hHnM7iVAl2FqFInCaGPNIh2r1eYVseuO6J6E2j+aRYt8jWVdrY4cLZ3ctpm2AZ9JYQyESJgo9NicZkrqcyYV2s5e6z3c1vm/sJkFN70/cuFJ61DZd/B+w5ZZ8UMopt3p4Wgcgtaw3C1baqx/11ru749tKaLPwl2NPn2grU/JWeNaFumUd6rTJ1eNmbN0zQutc0uRUNmVPwbAigF1jL1UY/S7jrWwgDpxlh7qbzkFIc0ssATRUasE99toyKMRoiNrZp6wcO9B+1zYEVNqUdJIvMv6R3LlLAe59eyGaumWoe45TQ3Jh9a8S2SZjqj7rwbqvmEGxzzDhwo13Qlee3yJlBjie8+5XOis0IVCuyey+d2NiIpcYCuIUkwXIaRygHXikx7WM8LBTWVJBH5WA9C/I+iD7GqMzEZxx903EQL550gsWNHcpAbCr7IGtBuWx43IrPpGrXEabfH6tUFxZqGcTpXdl9LvFBtlTtrxAZsBU8GrSEp6/5qIXSBVbV+Z0tjRny1BQ34gbRFplbOz/MlAIAdh7Bh6B0ROyizv2RenzAhKFr8quJO+vZVSELziJL3PL0WWOzQjEyzcO+pw7JkpSc+NEvFhkvzMTVDZ46RW0O2q+xT1AaX7aBcD1m+v8ArtIRIu7srfd2LB/rCRhkDqJyCMgkdur2mXbNd5ihE289JqmNfM0NaUBoLz1oKpkKd/YSBmhruFsnWlYNc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(81166007)(2906002)(2616005)(336012)(1076003)(2876002)(426003)(41300700001)(8936002)(6666004)(47076005)(40460700003)(5660300002)(82310400005)(4326008)(82740400003)(6636002)(8676002)(40480700001)(316002)(54906003)(36860700001)(70586007)(83380400001)(70206006)(36756003)(86362001)(478600001)(110136005)(356005)(186003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:30:57.7581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7247bf32-cc5a-4bcb-812f-08dafe5aa9f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/efx_devlink.h  |  7 ++
 drivers/net/ethernet/sfc/mae.h          |  2 +
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 7 files changed, 146 insertions(+)

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
index 9cd1a3ac67e0..94b7a78d247f 100644
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
 
+bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
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
index 2593248928a6..6cd65730ecc5 100644
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
index 8bcd077d8d8d..8d993ac2572b 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -36,4 +36,11 @@ void efx_probe_devlink_done(struct efx_nic *efx);
 void efx_fini_devlink_start(struct efx_nic *efx);
 void efx_fini_devlink(struct efx_nic *efx);
 
+struct mae_mport_desc;
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

