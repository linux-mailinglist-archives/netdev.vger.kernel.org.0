Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E6D68F0C1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjBHO0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjBHOZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8734B19A;
        Wed,  8 Feb 2023 06:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGhV+d2z/3Fg2gOoZOpo635uhaLIEroxULWfZ0LHnnq5cjmrPf6PjN/PHudMQrHT9CtsWRrptShSWWAL6dad729atlYcKGabtYEBbhSBvU1iaR1q9i3+B5Nqn/43f/3lbdWNWPQ4b9rYeJ8OyQGGDuSnzWy9KDTGIYvARfGXJzx+cuHvsqWF2234xB0tY4BAV6rMz8oPl7CKHkHEm/HpWasXhO0hf4ahfhtyWdIKvtofJRRDC1einBlr+zm/L7Te/fx8DOT5QnnlJVlutuazPllzCL6lJxqSHthEsLVDOJ0sfABMSYT4RAraHmEnycY/cnfbsfol9YFhkq1zyadcUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NVT+rE80D69maKjeEvYDDbFMgb0RKW5GGuJ+rRSbU5M=;
 b=Cbdmlrp6keaxBlXC7txaC+5JjEuQ89PAuiCVD0ps6SHvx9hpo8lLCbGlLirCL7diFciP8umKsX2j+YSPYNtWhV1oB7f+qovyShIajJiMP2VflkBARR8hvHBjSDtTD4s05Pz46EN7BnG2iPUU97nxVQe6hrJqxjVXArX8T8ikf20SMKuxqYEPXEJRE5v8SZ1hCH5/PmU+6pp0iI0BtuY+4uIeYNl+f1KDIS+3jGAtgcb3wa48ymsMCHOt7N0qXFTX7MftaqONXWO4+k8CI+S+0kn5r/0Y4jS2Qi5koMIcThy7fqc1IYDR01oRSB1Cc2KjuGfV0wfc5wwWVtzf53y0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVT+rE80D69maKjeEvYDDbFMgb0RKW5GGuJ+rRSbU5M=;
 b=heNZQ45w3T2btxQxJleMja+lPMulMg6qSq64/CnT426HmEQyVjik6AU0n0OQGJxccB3MN8oNr4SZqBTnjVDxnM76E8EuSWcaedz2za9tr89rPpk0iCWz9EWldY8ICjwUhLsCxz1+akmH5OqNrYwORhIIDhmqzIzk2oPpaSaRF90=
Received: from MW4PR04CA0153.namprd04.prod.outlook.com (2603:10b6:303:85::8)
 by PH7PR12MB7140.namprd12.prod.outlook.com (2603:10b6:510:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 8 Feb
 2023 14:25:47 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::e4) by MW4PR04CA0153.outlook.office365.com
 (2603:10b6:303:85::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 14:25:46 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:45 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 06:25:45 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:43 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 5/8] sfc: add devlink port support for ef100
Date:   Wed, 8 Feb 2023 14:25:16 +0000
Message-ID: <20230208142519.31192-6-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|PH7PR12MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 964ad5df-8557-4f6b-8e06-08db09e05e95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qH7H5v7Bwl/AggRVoUta/mv/0v4iV6jlU8TuxCoJoR+3f6PRh1RknmGmltxifSdRq857PELw7cedEglJgbNmbFkib/RKAS8RQvT8ADIkKkzKhyTGczt3fb3QNo7ETayQYKXFIzKSAAzvTKx2IuC0fW+sO4t1NGgNh2eafQdbVSxQxQR7+o94VYDZhC1JK2Jgj67BgnxMj7cv9LEE738tNEaBwCU/R77G6C/kC/Owh0OjO8n0FoxxVYVIydSRKoVKVvTXJfXToHfUJ0r5HBzYqr2SsL0X2Aa7ZnWdTCVMhIcSq5GnTDLlaQTqcl0kQECyRYqN9xy4/nrBxRZm+PY+tHJ8MozWkWy/yruxX5LskJLetSGmrYEcjsjPcn63fFNrtu0sreT0jzbQEPCzJ7ZvYp8cYGyo53lbHfpmcci8nQ/ilat4Lw/rmQjyL+YBjvThuxhpI6gHOnzq5kXaBinFAyxVZnxBsSK1mCmnGwzw/Mwq4y/FvvJDXBWU/NuxDQNf3uMDz9ruXBrofkAhZJYSPw0kc078MDhxzf8k9Hz6T+4roPMfrjDwd4zmTtnAnXc8iB1JOXio9GonTA39YluCSRqN53DPmLzBnTjZIi0qLn1CpNCZ6yVYCcBfdAGlmsU1uYlj0spV7TkwjB+FxOZcIjKyXYj29sxJFqcpt2r+loH/HsL14upQ0YVNUWmrMrDT4Vd2CnSRLpB1fzFn35XKtREDmhR0DtSHgyo+6rHya8g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(2876002)(82310400005)(7416002)(36756003)(47076005)(5660300002)(8936002)(41300700001)(426003)(336012)(40460700003)(83380400001)(70206006)(36860700001)(70586007)(2616005)(4326008)(316002)(86362001)(186003)(110136005)(356005)(81166007)(6636002)(54906003)(8676002)(1076003)(26005)(478600001)(82740400003)(40480700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:46.5522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 964ad5df-8557-4f6b-8e06-08db09e05e95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7140
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
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  10 +++
 drivers/net/ethernet/sfc/ef100_rep.c    |  22 ++++++
 drivers/net/ethernet/sfc/ef100_rep.h    |   7 ++
 drivers/net/ethernet/sfc/efx_devlink.c  | 101 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |   9 +++
 drivers/net/ethernet/sfc/mae.h          |   2 +
 drivers/net/ethernet/sfc/net_driver.h   |   2 +
 7 files changed, 153 insertions(+)

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
index c06efeac11e5..1b1276716113 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -14,6 +14,8 @@
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
+#include "mae.h"
+#include "ef100_rep.h"
 #endif
 
 struct efx_devlink {
@@ -21,6 +23,41 @@ struct efx_devlink {
 };
 
 #ifdef CONFIG_SFC_SRIOV
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
@@ -477,6 +514,70 @@ static const struct devlink_ops sfc_devlink_ops = {
 #endif
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
index a5269361c3e0..d544885d3dbf 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -36,4 +36,13 @@ void efx_probe_devlink_unlock(struct efx_nic *efx);
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
+
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

