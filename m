Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD086736F2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjASLdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjASLc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:32:56 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2A7854B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhniBeFX3GnFpeb9JZBDmKL+gNoUDk+BuSfBeXm2K9Ic2sr8nyO5Fc0TRQocpGIjcqZETC2F7O/SzorZI6o100aoyJ39ngB7/sJt18TMwcgltFU70OBZqXI1h5h1b0cKxFWsIsabaZ3Vvb/vU0RfM4HKm34SfuGpHKdpfSTQabRM3B+i6o8LkcW+48BNZOJhNNze81xdfgvIEn8/ASu79D7vud/+HMaXH1istUtzVi0zYxqBHHFu/5Hr4aATxwuOa0L+jzz7elEUvfgradiy4lz5iUJznt1kKvmTATTwUYjjLsUSr8Tx+mKCAJLijXSKwsEYFrEP15SIWMq5zgwOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I52CdeJ10vKhs2c8gtYHM0M5Z4DjFvUYKKJhRbgsO9E=;
 b=Cxac1WjLYZWI1BI/GieqP9+ND1vhTPhSYEAoyp4IrQhwGfcnegNYOmvexMMFO08BV+Tbnkr3c7aBfXVqFnoGqj3HctmrA4+xsCRKGkaPOnBPpZEmE7OrtIxaw83VckwCNARWMHLhMHFBu1CHRvz5d3vGeUiXaouO9TXJsnL2mbgCcviN5mzeNeoUt4evPJBha7vGfz33Qe0mnhxXpA9QuLVIXZN+/CnJ7Bgtp/C6Y47yK8yZm1XVIlNm8JK37aPq2EIxn2ouvaEyCQQlBgEjXmgShIrjCrzRA81V7dTOg0kDMG0ydZkkxeuhMzbHSlSJC3JIGAm68Jwph1c1i7M75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I52CdeJ10vKhs2c8gtYHM0M5Z4DjFvUYKKJhRbgsO9E=;
 b=kgvAnZrNTXjsMWw8zlfrkUWmdxYO5sc5CAKu98fXs+ejGnqcNxv8QsBJ57S9ABR+tVH+Euo6jzvTffQhRh2suk5u389mlGjprCoRMeZugx8q4RpWb/oYa0AB8KQGV0eXmoFewlAoMDgsX3X3bYYZbWrxnJOmyLm6303xNFbLDGo=
Received: from MW4PR04CA0323.namprd04.prod.outlook.com (2603:10b6:303:82::28)
 by PH7PR12MB6884.namprd12.prod.outlook.com (2603:10b6:510:1ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 11:32:30 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::de) by MW4PR04CA0323.outlook.office365.com
 (2603:10b6:303:82::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 11:32:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 11:32:30 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:25 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 05:32:06 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 19 Jan 2023 05:32:04 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net-next 2/7] sfc: enumerate mports in ef100
Date:   Thu, 19 Jan 2023 11:31:35 +0000
Message-ID: <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|PH7PR12MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: e105bdcb-d99e-4a12-2ca3-08dafa10d9ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RCqVz5JXayxfhtcbOC8tJU7k1WpQHyzPejO2hEaUFKzoHSQXs7QrIIRzCLvCmvJMmZtnzxbbw5KCov7YShlfWvgGocMBJHZdknAuKXe2b3D8oR89RbA/XZ2BZqaYDIYJyQGtGD4W5ReUZNyxXlrLYLX8hhEclc+Yt1zm0CvfmkLHPoY5eiwuZ49AlAdYak0almyHmp23Rfj6FCBz/ADpj1d45FZl/iQpmhbnURGN85XZk8UtM+SlLR9ogFiC2iuYLynboIgv8qLFguPw/ab144CgKz6DCbA9QahPJfdF/NqnVMBCDuhcBojJPGrI0Pgwo8Z3pN8n6ujCsVsmZ16fxtGhEmDgwzi3jAPWd1+oQBn15O0+Cb9ch7M/oenko/VLUdqc0ZG4yakpDuJzY8/Z0fFgBjDz5tGq59AK+xfH0laFBDbtxCTEbaCYXECDOXtU9UocmFiYe8mAB8PEpqzsvzsIvW0A1EKy6zX/le+bDgu8qgW6g3XaI34WIGZ9Lu/0lmiLIyphwFN/yo1ClbaXNoARt4DRHq4ylv6mZnsRvhD3icdNaSduHVdnZTxEsCwRnsqwkEFOHdc4Y0O42JcMtKo1v0ypECdd/SmxqqSppsWFQ3c4x+qGeregJMi8bUsUAHvU/Aw54Y7wFzoV7Nr0DrnKOm9yFvxO0dB9Pg2Y025REjgGEcsrvtpICQCEAK0tiX3+/H3xs+xGgtFTY5PNuj9mdZf2i46uzXW8uZGcj5pGSPW5tGhFy+XkymbtHeeu
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(81166007)(82740400003)(83380400001)(36860700001)(356005)(86362001)(2876002)(8676002)(8936002)(5660300002)(2906002)(30864003)(70206006)(4326008)(70586007)(82310400005)(41300700001)(47076005)(426003)(26005)(40480700001)(336012)(2616005)(1076003)(186003)(6636002)(316002)(478600001)(6666004)(40460700003)(110136005)(54906003)(36756003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 11:32:30.2988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e105bdcb-d99e-4a12-2ca3-08dafa10d9ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6884
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

MAE ports (mports) are the ports on the EF100 embedded switch such
as networking PCIe functions, the physical port, and potentially
others.

This patch enumerates the mports obtained from the firmware and
registers them in driver structures. This data will be used when
creating representors and will be exposed through devlink port
interface in future patches.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c  |  23 ++++
 drivers/net/ethernet/sfc/ef100_nic.h  |   4 +
 drivers/net/ethernet/sfc/ef100_rep.c  |  22 +++
 drivers/net/ethernet/sfc/ef100_rep.h  |   2 +
 drivers/net/ethernet/sfc/mae.c        | 185 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h        |  37 ++++++
 drivers/net/ethernet/sfc/mcdi.h       |   7 +
 drivers/net/ethernet/sfc/net_driver.h |   4 +
 8 files changed, 284 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 14af8f314b83..ee260b508377 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -748,6 +748,18 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 			   id);
 	nic_data->base_mport = id;
 	nic_data->have_mport = true;
+
+	/* Construct mport selector for "calling PF" */
+	efx_mae_mport_uplink(efx, &selector);
+	/* Look up actual mport ID */
+	rc = efx_mae_lookup_mport(efx, selector, &id);
+	if (rc)
+		return rc;
+	if (id >> 16)
+		netif_warn(efx, probe, efx->net_dev, "Bad own m-port id %#x\n",
+			   id);
+	nic_data->own_mport = id;
+	nic_data->have_own_mport = true;
 	return 0;
 }
 #endif
@@ -1129,6 +1141,13 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		if (efx_probe_devlink(efx))
 			netif_warn(efx, probe, net_dev,
 				   "Failed to register devlink\n");
+		rc = efx_init_mae(efx);
+		if (rc)
+			pci_warn(efx->pci_dev,
+				 "Failed to init MAE rc %d; representors will not function\n",
+				 rc);
+		else
+			efx_ef100_init_reps(efx);
 	}
 
 	rc = efx_init_tc(efx);
@@ -1162,6 +1181,10 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+	if (efx->mae) {
+		efx_ef100_fini_reps(efx);
+		efx_fini_mae(efx);
+	}
 	efx_fini_devlink(efx);
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 0295933145fa..496aea43c60f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -74,6 +74,10 @@ struct ef100_nic_data {
 	u64 stats[EF100_STAT_COUNT];
 	u32 base_mport;
 	bool have_mport; /* base_mport was populated successfully */
+	u32 own_mport;
+	u32 local_mae_intf; /* interface_idx that corresponds to us, in mport enumerate */
+	bool have_own_mport; /* own_mport was populated successfully */
+	bool have_local_intf; /* local_mae_intf was populated successfully */
 	bool grp_mae; /* MAE Privilege */
 	u16 tso_max_hdr_len;
 	u16 tso_max_payload_num_segs;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 81ab22c74635..ebe7b1275713 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -9,6 +9,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/rhashtable.h>
 #include "ef100_rep.h"
 #include "ef100_netdev.h"
 #include "ef100_nic.h"
@@ -341,6 +342,27 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
 
+void efx_ef100_init_reps(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	int rc;
+
+	nic_data->have_local_intf = false;
+	rc = efx_mae_enumerate_mports(efx);
+	if (rc)
+		pci_warn(efx->pci_dev,
+			 "Could not enumerate mports (rc=%d), are we admin?",
+			 rc);
+}
+
+void efx_ef100_fini_reps(struct efx_nic *efx)
+{
+	struct efx_mae *mae = efx->mae;
+
+	rhashtable_free_and_destroy(&mae->mports_ht, efx_mae_remove_mport,
+				    NULL);
+}
+
 static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
 {
 	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index c21bc716f847..328ac0cbb532 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -67,4 +67,6 @@ void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
  */
 struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 extern const struct net_device_ops efx_ef100_rep_netdev_ops;
+void efx_ef100_init_reps(struct efx_nic *efx);
+void efx_ef100_fini_reps(struct efx_nic *efx);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 583baf69981c..bf039862ee14 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -9,8 +9,11 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/rhashtable.h>
+#include "ef100_nic.h"
 #include "mae.h"
 #include "mcdi.h"
+#include "mcdi_pcol.h"
 #include "mcdi_pcol_mae.h"
 
 int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label)
@@ -490,6 +493,162 @@ static bool efx_mae_asl_id(u32 id)
 	return !!(id & BIT(31));
 }
 
+/* mport handling */
+static const struct rhashtable_params efx_mae_mports_ht_params = {
+	.key_len	= sizeof(u32),
+	.key_offset	= offsetof(struct mae_mport_desc, mport_id),
+	.head_offset	= offsetof(struct mae_mport_desc, linkage),
+};
+
+struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id)
+{
+	return rhashtable_lookup_fast(&efx->mae->mports_ht, &mport_id,
+				      efx_mae_mports_ht_params);
+}
+
+static int efx_mae_add_mport(struct efx_nic *efx, struct mae_mport_desc *desc)
+{
+	struct efx_mae *mae = efx->mae;
+	int rc;
+
+	rc = rhashtable_insert_fast(&mae->mports_ht, &desc->linkage,
+				    efx_mae_mports_ht_params);
+
+	if (rc) {
+		pci_err(efx->pci_dev, "Failed to insert MPORT %08x, rc %d\n",
+			desc->mport_id, rc);
+		kfree(desc);
+		return rc;
+	}
+
+	return rc;
+}
+
+void efx_mae_remove_mport(void *desc, void *arg)
+{
+	struct mae_mport_desc *mport = desc;
+
+	synchronize_rcu();
+	kfree(mport);
+}
+
+static int efx_mae_process_mport(struct efx_nic *efx,
+				 struct mae_mport_desc *desc)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct mae_mport_desc *mport;
+
+	mport = efx_mae_get_mport(efx, desc->mport_id);
+	if (!IS_ERR_OR_NULL(mport)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "mport with id %u does exist!!!\n", desc->mport_id);
+		return -EEXIST;
+	}
+
+	if (nic_data->have_own_mport &&
+	    desc->mport_id == nic_data->own_mport) {
+		WARN_ON(desc->mport_type != MAE_MPORT_DESC_MPORT_TYPE_VNIC);
+		WARN_ON(desc->vnic_client_type !=
+			MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION);
+		nic_data->local_mae_intf = desc->interface_idx;
+		nic_data->have_local_intf = true;
+		pci_dbg(efx->pci_dev, "MAE interface_idx is %u\n",
+			nic_data->local_mae_intf);
+	}
+
+	return efx_mae_add_mport(efx, desc);
+}
+
+int efx_mae_enumerate_mports(struct efx_nic *efx)
+{
+#define MCDI_MPORT_JOURNAL_LEN \
+	sizeof(efx_dword_t[DIV_ROUND_UP(MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LENMAX_MCDI2, 4)])
+	efx_dword_t *outbuf = kzalloc(MCDI_MPORT_JOURNAL_LEN, GFP_KERNEL);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_IN_LEN);
+	MCDI_DECLARE_STRUCT_PTR(desc);
+	size_t outlen, stride, count;
+	int rc = 0, i;
+
+	if (!outbuf)
+		return -ENOMEM;
+	do {
+		rc = efx_mcdi_rpc(efx, MC_CMD_MAE_MPORT_READ_JOURNAL, inbuf,
+				  sizeof(inbuf), outbuf,
+				  MCDI_MPORT_JOURNAL_LEN, &outlen);
+		if (rc)
+			goto fail;
+		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST) {
+			rc = -EIO;
+			goto fail;
+		}
+		count = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_COUNT);
+		if (!count)
+			continue; /* not break; we want to look at MORE flag */
+		stride = MCDI_DWORD(outbuf, MAE_MPORT_READ_JOURNAL_OUT_SIZEOF_MPORT_DESC);
+		if (stride < MAE_MPORT_DESC_LEN) {
+			rc = -EIO;
+			goto fail;
+		}
+		if (outlen < MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LEN(count * stride)) {
+			rc = -EIO;
+			goto fail;
+		}
+
+		for (i = 0; i < count; i++) {
+			struct mae_mport_desc *d;
+
+			d = kzalloc(sizeof(*d), GFP_KERNEL);
+			if (!d) {
+				rc = -ENOMEM;
+				goto fail;
+			}
+
+			desc = (efx_dword_t *)
+				_MCDI_PTR(outbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_MPORT_DESC_DATA_OFST +
+					  i * stride);
+			d->mport_id = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_MPORT_ID);
+			d->flags = MCDI_STRUCT_DWORD(desc, MAE_MPORT_DESC_FLAGS);
+			d->caller_flags = MCDI_STRUCT_DWORD(desc,
+							    MAE_MPORT_DESC_CALLER_FLAGS);
+			d->mport_type = MCDI_STRUCT_DWORD(desc,
+							  MAE_MPORT_DESC_MPORT_TYPE);
+			switch (d->mport_type) {
+			case MAE_MPORT_DESC_MPORT_TYPE_NET_PORT:
+				d->port_idx = MCDI_STRUCT_DWORD(desc,
+								MAE_MPORT_DESC_NET_PORT_IDX);
+				break;
+			case MAE_MPORT_DESC_MPORT_TYPE_ALIAS:
+				d->alias_mport_id = MCDI_STRUCT_DWORD(desc,
+								      MAE_MPORT_DESC_ALIAS_DELIVER_MPORT_ID);
+				break;
+			case MAE_MPORT_DESC_MPORT_TYPE_VNIC:
+				d->vnic_client_type = MCDI_STRUCT_DWORD(desc,
+									MAE_MPORT_DESC_VNIC_CLIENT_TYPE);
+				d->interface_idx = MCDI_STRUCT_DWORD(desc,
+								     MAE_MPORT_DESC_VNIC_FUNCTION_INTERFACE);
+				d->pf_idx = MCDI_STRUCT_WORD(desc,
+							     MAE_MPORT_DESC_VNIC_FUNCTION_PF_IDX);
+				d->vf_idx = MCDI_STRUCT_WORD(desc,
+							     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
+				break;
+			default:
+				/* Unknown mport_type, just accept it */
+				break;
+			}
+			rc = efx_mae_process_mport(efx, d);
+			/* Any failure will be due to memory allocation faiure,
+			 * so there is no point to try subsequent entries.
+			 */
+			if (rc)
+				goto fail;
+		}
+	} while (MCDI_FIELD(outbuf, MAE_MPORT_READ_JOURNAL_OUT, MORE) &&
+		 !WARN_ON(!count));
+fail:
+	kfree(outbuf);
+	return rc;
+}
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
@@ -805,3 +964,29 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id)
 		return -EIO;
 	return 0;
 }
+
+int efx_init_mae(struct efx_nic *efx)
+{
+	struct efx_mae *mae = kmalloc(sizeof(*mae), GFP_KERNEL);
+	int rc;
+
+	if (!mae)
+		return -ENOMEM;
+
+	rc = rhashtable_init(&mae->mports_ht, &efx_mae_mports_ht_params);
+	if (rc < 0) {
+		kfree(mae);
+		return rc;
+	}
+	efx->mae = mae;
+	mae->efx = efx;
+	return 0;
+}
+
+void efx_fini_mae(struct efx_nic *efx)
+{
+	struct efx_mae *mae = efx->mae;
+
+	kfree(mae);
+	efx->mae = NULL;
+}
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 72343e90e222..e1f057f01f08 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -27,6 +27,40 @@ void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
 
+struct mae_mport_desc {
+	u32 mport_id;
+	u32 flags;
+	u32 caller_flags; /* enum mae_mport_desc_caller_flags */
+	u32 mport_type; /* MAE_MPORT_DESC_MPORT_TYPE_* */
+	union {
+		u32 port_idx; /* for mport_type == NET_PORT */
+		u32 alias_mport_id; /* for mport_type == ALIAS */
+		struct { /* for mport_type == VNIC */
+			u32 vnic_client_type; /* MAE_MPORT_DESC_VNIC_CLIENT_TYPE_* */
+			u32 interface_idx;
+			u16 pf_idx;
+			u16 vf_idx;
+		};
+	};
+	struct rhash_head linkage;
+	struct efx_rep *efv;
+};
+
+int efx_mae_enumerate_mports(struct efx_nic *efx);
+struct mae_mport_desc *efx_mae_get_mport(struct efx_nic *efx, u32 mport_id);
+void efx_mae_put_mport(struct efx_nic *efx, struct mae_mport_desc *desc);
+
+/**
+ * struct efx_mae - MAE information
+ *
+ * @efx: The associated NIC
+ * @mports_ht: m-port descriptions from MC_CMD_MAE_MPORT_READ_JOURNAL
+ */
+struct efx_mae {
+	struct efx_nic *efx;
+	struct rhashtable mports_ht;
+};
+
 int efx_mae_start_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
 int efx_mae_stop_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
 void efx_mae_counters_grant_credits(struct work_struct *work);
@@ -60,4 +94,7 @@ int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 			u32 prio, u32 acts_id, u32 *id);
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 
+int efx_init_mae(struct efx_nic *efx);
+void efx_fini_mae(struct efx_nic *efx);
+void efx_mae_remove_mport(void *desc, void *arg);
 #endif /* EF100_MAE_H */
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 63b090587f7a..5fd2215da951 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -199,6 +199,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	MCDI_DECLARE_BUF(_name, 8)
 #define _MCDI_PTR(_buf, _offset)					\
 	((u8 *)(_buf) + (_offset))
+#define MCDI_STRUCT_PTR(_buf, _field)                                   \
+	_MCDI_PTR(_buf, _field ## _OFST)
 #define MCDI_PTR(_buf, _field)						\
 	_MCDI_PTR(_buf, MC_CMD_ ## _field ## _OFST)
 /* Use MCDI_STRUCT_ functions to access members of MCDI structuredefs.
@@ -229,6 +231,9 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_WORD(_buf, _field)						\
 	((u16)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2) +	\
 	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
+#define MCDI_STRUCT_WORD(_buf, _field)                                  \
+	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
+	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
 /* Write a 16-bit field defined in the protocol as being big-endian. */
 #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 2);				\
@@ -241,6 +246,8 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	EFX_POPULATE_DWORD_1(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0, _value)
 #define MCDI_DWORD(_buf, _field)					\
 	EFX_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0)
+#define MCDI_STRUCT_DWORD(_buf, _field)                                 \
+	EFX_DWORD_FIELD(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0)
 /* Write a 32-bit field defined in the protocol as being big-endian. */
 #define MCDI_STRUCT_SET_DWORD_BE(_buf, _field, _value) do {		\
 	BUILD_BUG_ON(_field ## _LEN != 4);				\
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index d036641dc043..bc9efbfb3d6b 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -845,6 +845,8 @@ enum efx_xdp_tx_queues_mode {
 	EFX_XDP_TX_QUEUES_BORROWED	/* queues borrowed from net stack */
 };
 
+struct efx_mae;
+
 /**
  * struct efx_nic - an Efx NIC
  * @name: Device name (net device name or bus id before net device registered)
@@ -881,6 +883,7 @@ enum efx_xdp_tx_queues_mode {
  * @msi_context: Context for each MSI
  * @extra_channel_types: Types of extra (non-traffic) channels that
  *	should be allocated for this NIC
+ * @mae: Details of the Match Action Engine
  * @xdp_tx_queue_count: Number of entries in %xdp_tx_queues.
  * @xdp_tx_queues: Array of pointers to tx queues used for XDP transmit.
  * @xdp_txq_queues_mode: XDP TX queues sharing strategy.
@@ -1044,6 +1047,7 @@ struct efx_nic {
 	struct efx_msi_context msi_context[EFX_MAX_CHANNELS];
 	const struct efx_channel_type *
 	extra_channel_type[EFX_MAX_EXTRA_CHANNELS];
+	struct efx_mae *mae;
 
 	unsigned int xdp_tx_queue_count;
 	struct efx_tx_queue **xdp_tx_queues;
-- 
2.17.1

