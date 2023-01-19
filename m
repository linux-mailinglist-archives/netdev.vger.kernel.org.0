Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C756736F0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjASLdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjASLcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B59675A24
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PX/EQYYaXWLTTfTxHDbLk1E3bD0eQynx7UzCXwp0kEFgendnO6DNcqLnY40Zjvf6QacqeaiO9/zgbl82HijjOPgPnOxh7tTjP60BzazJzNGa970IOIJhf9kSfL+gpQMSAPcQ0890I1yAqF9Hg2fsdNhmvvCIUtluL3EK+o4BhHz5NXwhaS2+VN2aBclnKCwSt/L0E5RV4r7aZYZo9mpp9m4f2bmkG/x3tvW0rntu+sYOMgsSOvPSKtPmvjRGHGMxEiZt7HbFKWNBxR/vmDbhjQIHdumfh2rcqHWwKvjvdA7m4sJ5OpDhgKa+IBO+K+Yjbl2mZPv1b1pig66UUwbQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4XJd7eH+3lc3570lQ9IgBjVQokGfwPUJiMu8ctP8i8=;
 b=Qqm9P2CRSKaXeAGviZIqwtIdiHfmhT7prQro5VZfG9bS+zw0WINY9Xw3w1W7wq7IuMyfV+KGS8vj8o05FCawS2a+pzO81tdqHxAjVnyOFSJbeiG5X4utwdbmU/hAEHf/V5sjVHk1ItrWV3FuIAsiJsUWOKwgsJcpYg/cpKywY/Bq9eBR3mie4KJnJ6aeikcLpKUmRIsiHHvFUDj9FzQ/fQlXudlOCRtSvPZA62J9jQMAjaO4KuR5EgxuznHO38J9xTmz6QyXke3n7RNFFD4C4r/hiFveaQW0M89lvZ5SdvyLhSdZmRg3+YsOI5bGUFeuFE9GoeikeIEs+Nng1rlZvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4XJd7eH+3lc3570lQ9IgBjVQokGfwPUJiMu8ctP8i8=;
 b=IiNWkIqgNiFOUD+1l5O/wFybYV3/8Q2vhs5ZyZhQmdniSKrJHGWchE9s5nF7BddK2WFFQYmCyjluOXjq0kyg8uUuBXVSUHkZwuP8yNY2LYJ8NpK8xLZQ+oUbilhUtvnhuwc6K32xjTToTChz9pd6nzKI7cquICMJLEzovT5acsI=
Received: from MW4PR02CA0005.namprd02.prod.outlook.com (2603:10b6:303:16d::14)
 by PH7PR12MB5877.namprd12.prod.outlook.com (2603:10b6:510:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 11:32:12 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::a9) by MW4PR02CA0005.outlook.office365.com
 (2603:10b6:303:16d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 11:32:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:11 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:09 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 4/7] sfc: add devlink port support for ef100
Date:   Thu, 19 Jan 2023 11:31:37 +0000
Message-ID: <20230119113140.20208-5-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|PH7PR12MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f2bb904-022b-47c4-822b-08dafa10cee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zIdEiDqUPuVE8JO8Tw7uEc1eWlFV5qlrQhVpatzkt8K1TcH+eLDUhrZNP2fJfwRO2NV4dlLGELQ4PvsF7WNQ++PYMg+QDyy+l57W3vNDF5kETzFntu5n5axgtj1KfXsfsRnHP9l/Xm11pOhtmOyxupF0KweiYq+F1rQPZWPpWVZDSjvYn3D0NWigdWIeGskMst+VF5ukI6LySJ9JOOEd3LXKyrrb3PzbFH8vaOxtKUUv+3oyzpf0QbgHJoGYwufe7I4zn5/0yZCmlvO2bEqNIOS2ZzmEruSq7eC5IrOKivICMNd9DT1dOGQxJlYjxjjsYdOnqaqk8BYTdg2g/kjyVISlunTBkmv+matpoKJRo9P0Jwi9rhnVJoOfyI8aalL3CuWkKVe+ecdl4AHasPhRKRFVUNuUl9hEqNJTIdfe03I2bg1w4qkNmbM7+Uf1KJaUHDk0o/b9PiwrmcPQHxpEFiD9jMTAsub2p2dD2vX2TI9d8SYM7TmkfhdDxDUS6j52NpaEZTVBYWDBX2TxieBKbboABr3HMLNkd9pFFSU8+upAQ7XXYjkVLvwiROp8JkpkhA/rNEQ/z0cE4TywfsSIt2qdhyL7Ts9Kbpm4sqXb15g8KWLwznHGNi8eyfdHVps18hnMZH0H94ACduF0geJHivZk4HE9iPIJKB+LrmU3WxdrfjaytPFqcXSkp15p41qofogDAu6N6ppOSoYJ1JYtBqhky3cB5fLAa2w6TcAwIsU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(81166007)(86362001)(356005)(41300700001)(5660300002)(8936002)(40460700003)(82740400003)(36860700001)(36756003)(478600001)(186003)(110136005)(6636002)(54906003)(83380400001)(26005)(6666004)(8676002)(316002)(70586007)(4326008)(82310400005)(70206006)(426003)(336012)(2616005)(47076005)(1076003)(40480700001)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:12.2024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2bb904-022b-47c4-822b-08dafa10cee0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5877
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
netdevs are registered and removing those devlink ports after netdev has
been unregister.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  14 ++-
 drivers/net/ethernet/sfc/ef100_rep.c    |  23 +++++
 drivers/net/ethernet/sfc/ef100_rep.h    |   6 ++
 drivers/net/ethernet/sfc/efx_devlink.c  | 114 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  |   7 ++
 drivers/net/ethernet/sfc/net_driver.h   |   1 +
 6 files changed, 161 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index ddcc325ed570..4a5d028f757e 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -24,6 +24,7 @@
 #include "rx_common.h"
 #include "ef100_sriov.h"
 #include "tc_bindings.h"
+#include "efx_devlink.h"
 
 static void ef100_update_name(struct efx_nic *efx)
 {
@@ -280,6 +281,9 @@ static int ef100_register_netdev(struct efx_nic *efx)
 	net_dev->max_mtu = EFX_MAX_MTU;
 	net_dev->ethtool_ops = &ef100_ethtool_ops;
 
+	if (!efx->type->is_vf)
+		ef100_pf_set_devlink_port(efx);
+
 	rtnl_lock();
 
 	rc = dev_alloc_name(net_dev, net_dev->name);
@@ -302,6 +306,7 @@ static int ef100_register_netdev(struct efx_nic *efx)
 
 fail_locked:
 	rtnl_unlock();
+	ef100_pf_unset_devlink_port(efx);
 	netif_err(efx, drv, efx->net_dev, "could not register net dev\n");
 	return rc;
 }
@@ -312,6 +317,7 @@ static void ef100_unregister_netdev(struct efx_nic *efx)
 		efx_fini_mcdi_logging(efx);
 		efx->state = STATE_PROBED;
 		unregister_netdev(efx->net_dev);
+		ef100_pf_unset_devlink_port(efx);
 	}
 }
 
@@ -405,16 +411,16 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
-	rc = ef100_register_netdev(efx);
-	if (rc)
-		goto fail;
-
 	if (!efx->type->is_vf) {
 		rc = ef100_probe_netdev_pf(efx);
 		if (rc)
 			goto fail;
 	}
 
+	rc = ef100_register_netdev(efx);
+	if (rc)
+		goto fail;
+
 	efx->netdev_notifier.notifier_call = ef100_netdev_event;
 	rc = register_netdevice_notifier(&efx->netdev_notifier);
 	if (rc) {
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 9cd1a3ac67e0..ff0c8da61919 100644
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
@@ -304,10 +306,12 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
 			i, rc);
 		goto fail2;
 	}
+
 	pci_dbg(efx->pci_dev, "Representor for VF %d is %s\n", i,
 		efv->net_dev->name);
 	return 0;
 fail2:
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 fail1:
 	efx_ef100_rep_destroy_netdev(efv);
@@ -323,6 +327,7 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
 		return;
 	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
 	unregister_netdev(rep_dev);
+	ef100_rep_unset_devlink_port(efv);
 	efx_ef100_deconfigure_rep(efv);
 	efx_ef100_rep_destroy_netdev(efv);
 }
@@ -339,6 +344,24 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
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
+	bool pcie_func;
+	struct ef100_nic_data *nic_data = efx->nic_data;
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
index 328ac0cbb532..9cca41614982 100644
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
@@ -54,6 +56,7 @@ struct efx_rep {
 	spinlock_t rx_lock;
 	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
+	struct devlink_port *dl_port;
 };
 
 int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
@@ -69,4 +72,7 @@ struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 extern const struct net_device_ops efx_ef100_rep_netdev_ops;
 void efx_ef100_init_reps(struct efx_nic *efx);
 void efx_ef100_fini_reps(struct efx_nic *efx);
+struct mae_mport_desc;
+bool ef100_mport_on_local_intf(struct efx_nic *efx,
+			       struct mae_mport_desc *mport_desc);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index c506f8f35d25..bb19d3ad7ffd 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -16,6 +16,8 @@
 #include "mcdi.h"
 #include "mcdi_functions.h"
 #include "mcdi_pcol.h"
+#include "mae.h"
+#include "ef100_rep.h"
 
 /* Custom devlink-info version object names for details that do not map to the
  * generic standardized names.
@@ -381,6 +383,52 @@ struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+static void efx_devlink_del_port(struct devlink_port *dl_port)
+{
+	if (!dl_port)
+		return;
+	devlink_port_unregister(dl_port);
+	kfree(dl_port);
+}
+
+static int efx_devlink_add_port(struct efx_nic *efx,
+				struct mae_mport_desc *mport,
+				struct devlink_port *dl_port)
+{
+	struct devlink_port_attrs attrs = {};
+	bool external = false;
+	int err;
+
+	if (!ef100_mport_on_local_intf(efx, mport))
+		external = true;
+
+	switch (mport->mport_type) {
+	case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = mport->port_idx;
+		devlink_port_attrs_set(dl_port, &attrs);
+		break;
+	case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+		if (mport->vf_idx != MAE_MPORT_DESC_VF_IDX_NULL) {
+			devlink_port_attrs_pci_vf_set(dl_port, 0, mport->pf_idx,
+						      mport->vf_idx,
+						      external);
+		} else {
+			devlink_port_attrs_pci_pf_set(dl_port, 0, mport->pf_idx,
+						      external);
+		}
+		break;
+	default:
+		/* MAE_MPORT_DESC_MPORT_ALIAS and UNDEFINED */
+		return 0;
+	}
+
+	dl_port->index = mport->mport_id;
+	err = devlink_port_register(efx->devlink, dl_port, mport->mport_id);
+
+	return err;
+}
+
 static int efx_devlink_info_get(struct devlink *devlink,
 				struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
@@ -396,6 +444,72 @@ static const struct devlink_ops sfc_devlink_ops = {
 	.info_get			= efx_devlink_info_get,
 };
 
+static struct devlink_port *ef100_set_devlink_port(struct efx_nic *efx, u32 idx)
+{
+	struct mae_mport_desc *mport;
+	struct devlink_port *dl_port;
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
+	dl_port = kzalloc(sizeof(*dl_port), GFP_KERNEL);
+	if (!dl_port)
+		return NULL;
+
+	if (efx_devlink_add_port(efx, mport, dl_port)) {
+		if (idx == MAE_MPORT_DESC_VF_IDX_NULL)
+			pci_warn(efx->pci_dev,
+				 "devlink port creation for PF failed.\n");
+		else
+			pci_warn(efx->pci_dev,
+				 "devlink_port creationg for VF %u failed.\n",
+				 idx);
+		kfree(dl_port);
+		return NULL;
+	}
+
+	return dl_port;
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
 void efx_fini_devlink(struct efx_nic *efx)
 {
 	if (efx->devlink) {
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index 997f878aea93..a834c393a9ad 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -17,4 +17,11 @@
 int efx_probe_devlink(struct efx_nic *efx);
 void efx_fini_devlink(struct efx_nic *efx);
 
+struct mae_mport_desc;
+struct efx_rep;
+
+void ef100_pf_set_devlink_port(struct efx_nic *efx);
+void ef100_rep_set_devlink_port(struct efx_rep *efv);
+void ef100_pf_unset_devlink_port(struct efx_nic *efx);
+void ef100_rep_unset_devlink_port(struct efx_rep *efv);
 #endif	/* _EFX_DEVLINK_H */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index bc9efbfb3d6b..20f43695d082 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1185,6 +1185,7 @@ struct efx_nic {
 	struct efx_tc_state *tc;
 
 	struct devlink *devlink;
+	struct devlink_port *dl_port;
 	unsigned int mem_bar;
 	u32 reg_base;
 
-- 
2.17.1

