Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80DD694F7A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjBMSfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBMSf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65025166EA;
        Mon, 13 Feb 2023 10:35:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJFWwf0sH/4t6nH3TevjAGDyHa4IBxDYTzcwRStP19uJcdCvTQ4zexR3KT9agkApQNx+v8C/9XUT+87aRY7kedA1I48oW46zlJw4jfDOi9wLllTxW6jg9TUXOuh/FMU8OILoGm/PKKY2YZe/VhQAezbQiD/UAdJheM95XzhN0k7WXE0BgIHf0tdnarcook3F6kZG6JmbVXolkFHpd4M1wvr5xN0O5+Ga/KL3Z5glJHNmbL7VCAHtlyH+HhbWZslDlguitejdYO1MgKaX/hw3TyqhgR3GxvztCF4m0VoRgCACVtKucRASpwDA3YUHJGdqywadRJ5OfVc4iFbJwQHYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fALdKtfLTW3Ge812mVOwZ4V6Z8ffZteEEn+yz3+NxcM=;
 b=U7koUtm1SzZLqDfFWiWV4+xaMNEui9XVAk8ibHnQFagKoo47FPDWcYrdEDMJ2LVKK+L2py8BTE+wnaQ4kNjFeegww85+N68epRoCtanlADv4wC61+0yepMihOIpOFmHqA7a7bMAJ/U1Grn3S7vk/4Qvg5rE57JbwMba4inCRk3loicA0hmhiOl4PnV/xTapCBylIMPXRclZWgk4zuegL5rAvyaNZ2gmQWDDIiG6luj0A2L22H1QOGtwlTgNpr0IyZQiBUIXgjmJ/8QIeykS5IGfdmdqwmi82dV3EQbtxC9njcKY9QWzrwnhhVRDaU1SRz5Tz2SsQUI9RbyVlX8PUiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fALdKtfLTW3Ge812mVOwZ4V6Z8ffZteEEn+yz3+NxcM=;
 b=R4CsiaQvRQB+We7vgple2FU6yr99sFXwZIxtyCi4cjAt/TvfZx1vv9SHMGTApUtScR7q1mXNpL6PoX1gS/d0l+sApLSWPU9kGodkrx2VWW3n1EQ4Z3wjp56MWyiEEUn67VHEDOxwSYXia8nBmIQbqWkEB4CIvxBvQXrWS08Bzso=
Received: from BN9PR03CA0909.namprd03.prod.outlook.com (2603:10b6:408:107::14)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 18:35:21 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::ec) by BN9PR03CA0909.outlook.office365.com
 (2603:10b6:408:107::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:21 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:20 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:18 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 5/8] sfc: add devlink port support for ef100
Date:   Mon, 13 Feb 2023 18:34:25 +0000
Message-ID: <20230213183428.10734-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db7796d-5789-4199-d77e-08db0df1100f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/4/zi+6XXFVfW5nZLC6bTS3DKr/be/30jQd3k0bHiNgEKmVB7NiH+6YCtQGKelpYgAA5FllO8l3eYMM8zdu2u1mf1d4gCko5FPL5pY91RezwudbZcu70krC0ztmPwesuYSCs3JI6ut3o7uYYf+RWij67IRCrgBWSHjM5EOJoeRicwGyTm8PCqvEddJVGvE5oTXbmrmQL2eQErfr2MsnB8mgew7+VtiKmDgkdD6OueQsPSGsfUunqVGDkGLEtB+p4kqVWznv446WJXW6HP7d3OXD2fQ/3JQzcIHeoMHZywUKLFlHeECutReDsvmEj0VYRC/i1I9lnsGnYjFQpLgsp9WYkfwuHxIp8iAvK1SrzzCk2SpG/s+JGMgmJeNn5V2nvvTvjwbNUGuGtnygPM4EdSlI0QyHid3fUR0y6V73e+ODC176B0VT0naxAXdV+KPW7aWwSKM/juwwNE+VXqVWD0K8EnbOySQy/27mbZgiEhFiFt8igoUsWTbPTtrRNLqGoirKsNSDSM7clY3+71KlCHEpkO02ow6sajmb1mszFInWrwNP8PEIOOPVDierBx8JBDuzmIBtErGj1EcM4HGziHW510jD1ll7MX45GLOCO2s2O+G58U+C/hTMa/WdwOcu4HN0QqVzw2VJltt8iqNiAnnyjPG47DUOHggz/j/8FznuymFUpfDCGLh6tATqITbpFQdQDMQC2RpTsZo1rnNSabH+wnQIwE93PPkgYEgc0eM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(82310400005)(426003)(47076005)(2876002)(86362001)(316002)(40480700001)(7416002)(110136005)(54906003)(6636002)(30864003)(70206006)(70586007)(41300700001)(4326008)(36756003)(36860700001)(8676002)(8936002)(5660300002)(2906002)(83380400001)(81166007)(40460700003)(356005)(6666004)(2616005)(1076003)(26005)(186003)(336012)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:21.0341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db7796d-5789-4199-d77e-08db0df1100f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  10 +++
 drivers/net/ethernet/sfc/ef100_rep.c    |  22 +++++
 drivers/net/ethernet/sfc/ef100_rep.h    |   7 ++
 drivers/net/ethernet/sfc/efx_devlink.c  | 105 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |   8 ++
 drivers/net/ethernet/sfc/mae.h          |   2 +
 drivers/net/ethernet/sfc/net_driver.h   |   2 +
 7 files changed, 156 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 6cf74788b27a..368147359299 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -337,6 +337,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	ef100_unregister_netdev(efx);
 
 #ifdef CONFIG_SFC_SRIOV
+	ef100_pf_unset_devlink_port(efx);
 	efx_fini_tc(efx);
 #endif
 
@@ -422,6 +423,9 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		rc = ef100_probe_netdev_pf(efx);
 		if (rc)
 			goto fail;
+#ifdef CONFIG_SFC_SRIOV
+		ef100_pf_set_devlink_port(efx);
+#endif
 	}
 
 	efx->netdev_notifier.notifier_call = ef100_netdev_event;
@@ -432,7 +436,13 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 		goto fail;
 	}
 
+	efx_probe_devlink_unlock(efx);
+	return rc;
 fail:
+#ifdef CONFIG_SFC_SRIOV
+	/* remove devlink port if does exist */
+	ef100_pf_unset_devlink_port(efx);
+#endif
 	efx_probe_devlink_unlock(efx);
 	return rc;
 }
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
index 11cb38be58d6..1bff2f607261 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -14,11 +14,52 @@
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
+#ifdef CONFIG_SFC_SRIOV
+#include "mae.h"
+#include "ef100_rep.h"
+#endif
 
 struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+#ifdef CONFIG_SFC_SRIOV
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
+#endif
+
 static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 					    struct devlink_info_req *req,
 					    unsigned int partition_type,
@@ -477,6 +518,70 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 };
 
+#ifdef CONFIG_SFC_SRIOV
+static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
+{
+	struct mae_mport_desc *mport;
+	u32 id;
+	int rc;
+
+	if (efx_mae_lookup_mport(efx, idx, &id)) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn_once(efx->pci_dev, "No mport ID found for PF.\n");
+		else
+			pci_warn_once(efx->pci_dev, "No mport ID found for VF %u.\n",
+				      idx);
+		return NULL;
+	}
+
+	mport = efx_mae_get_mport(efx, id);
+	if (!mport) {
+		/* This should not happen. */
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn_once(efx->pci_dev, "No mport found for PF.\n");
+		else
+			pci_warn_once(efx->pci_dev, "No mport found for VF %u.\n",
+				      idx);
+		return NULL;
+	}
+
+	rc = efx_devlink_add_port(efx, mport);
+	if (rc) {
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
+#endif
+
 void efx_fini_devlink_lock(struct efx_nic *efx)
 {
 	if (efx->devlink)
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index a5269361c3e0..e5fd5e1dcc27 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -36,4 +36,12 @@ void efx_probe_devlink_unlock(struct efx_nic *efx);
 void efx_fini_devlink_lock(struct efx_nic *efx);
 void efx_fini_devlink_and_unlock(struct efx_nic *efx);
 
+#ifdef CONFIG_SFC_SRIOV
+struct efx_rep;
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx);
+void ef100_rep_set_devlink_port(struct efx_rep *efv);
+void ef100_pf_unset_devlink_port(struct efx_nic *efx);
+void ef100_rep_unset_devlink_port(struct efx_rep *efv);
+#endif
 #endif	/* _EFX_DEVLINK_H */
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index b9bf86c47cda..bec293a06733 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -13,6 +13,7 @@
 #define EF100_MAE_H
 /* MCDI interface for the ef100 Match-Action Engine */
 
+#include <net/devlink.h>
 #include "net_driver.h"
 #include "tc.h"
 #include "mcdi_pcol.h" /* needed for various MC_CMD_MAE_*_NULL defines */
@@ -43,6 +44,7 @@ struct mae_mport_desc {
 		};
 	};
 	struct rhash_head linkage;
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

