Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABBA68F0BC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjBHO0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjBHOZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDDE4B187;
        Wed,  8 Feb 2023 06:25:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/NbOmhDsXdnKoHC0lO5x+z05yHTiRMu4/TvSaAaA2FjcTrNzmuV2M5GI+FcKPsG6ISISATseFEg3WEVQPpODn3c1qv0JW4iBFJTsnH0X85izTdO0FzyusJLxL+wyP3Dgj1NdtI7iCdyACCLJVI1C3od5K3MDOhECwXIofS759FvE5IiVilB4a6jDtrvAihD3Zqm853TY1rSQIkeSsZTjlgTY+kNyg+ezvY5uhaQZSi71j2o138BZwCgAMyyIb7SNZJbYBTRJTA74MUcksvZ05HtaZFfoO2buLxx0t+vjKAbqZJSrEF0j1Ms5x/3hTnmFuHh9Kb0XzS3dABBdFeHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhN/5JDwx/23kR8RdkL9oQfvz07VgaXrnLlbzt/ZME4=;
 b=FxManupWQOBU2rNDgUQoFED9J3TfVXfEeXH+LDT8LD0PrJ/4Otuhjd2fP/TFpKlXzhBLrwz3eqPOpOBYKfGfzHuzTengmUuSEXrgFgN1Cl/wmus8ly/RAvViGkX1nwgsw9p5oHWuBp4df7u+9pfzldRIkfVq8iGv9Y7IhVUTwHiQBubcwLG7VSE7p7jImYQC6IuMpTcZqBAB0vR4kUC8Mk48ws+c1MfV1KZQ8odGNwVQDBAtGhC+6rTIQ9eg3dWpgFpNKkUlV7tDSZ3Wj8RYlFA006JZfA3YNRvaFHmNcX/FI7jYSP/gHCWFfXDRxf8AcA1u74epNzlnEW0cJJCuFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhN/5JDwx/23kR8RdkL9oQfvz07VgaXrnLlbzt/ZME4=;
 b=JhQXr6RhMOhYaXDeXtJTChHJOTitwPEMcI2urXqPa+QcbPppvPfbXTKO3UVe8Y/sljRgRsC5Ddg4h4UaMMybntShcbQJsJAUZlMX3Scoz3usfZEjIVsiDly199C22zqYy5c/mOs9LgVp/gn0cw19eJRU0+LRNAT6nS+zFJ2a5pk=
Received: from DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11) by
 CY8PR12MB7515.namprd12.prod.outlook.com (2603:10b6:930:93::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Wed, 8 Feb 2023 14:25:43 +0000
Received: from DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::37) by DM6PR01CA0006.outlook.office365.com
 (2603:10b6:5:296::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT107.mail.protection.outlook.com (10.13.172.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.17 via Frontend Transport; Wed, 8 Feb 2023 14:25:43 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:42 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 06:25:42 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:40 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 4/8] sfc: add mport lookup based on driver's mport data
Date:   Wed, 8 Feb 2023 14:25:15 +0000
Message-ID: <20230208142519.31192-5-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT107:EE_|CY8PR12MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: 692ef6b2-6d4b-4ae5-ca93-08db09e05c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CPoQVSjtSIHTz/AoYHewOKHaMT/i7saF6MUHiKPDKMJa4YQ8pUk33XOy6uQfyDKhrvajU2BP2Jswk+ZEmBVs9pZuYXssKnHnxZnx3ckj1tcKKy9PsZwDYQC1D3HXAMZW94JsjFgufxU/BtdCeNmn2k2HuQ+taXQXwGTGb3Gj9yCADzdkdRlTKv7CXlZBMmyjNQsbkHzXihXlHVAIZu5AzklIpYj1EYJAMloYSMvW2sv7tZfOmqNodPyLtDjdDsbKRYNLu0fJI8eH6RaFI80r53TH8m69BefGuaTot3B5kn1F6xUSsK+W/KIc3kC+ghM4g8EsvBjjoVKKWNwEMGLoAsll698nAwa9xHAr00l+kTeUdsJ6ByjLx2o4HpdP+QTTH/a7sQI9ZwT6AJV/Ou4nYBImLTEeN+SMEQ+r6V6DY9yQ5SYqTrQ7Oqu8nBObX3rKKXkBguXSxyjE0TUGf9+1ki2hLXF5ipqK6Rr1MhYOGlWMmCuelUxKLVaWU3SM1pSTGvOVKtwBEvSCn2kme9qZoo0oXoUziIHUPU4N8oxhML1qMaRH7T1IVcrvBizHm8dyKBkJ/EAo7WCw6X5+UUg7G56zjGDCbqwhE27PD3yLeZlL/NA7GzJjRqcHGLqBkQY71rJzH0bk0GjOdq9B5QVgbb6Xa83adpVhBuepM9uidLGPwPz7Kbe2Ocfq/8q0lqP4m/KCVypC3cAOat9TSXbbNPCgGamfeRsmTbrnH+L1xA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(26005)(186003)(1076003)(2906002)(6666004)(36756003)(2876002)(7416002)(5660300002)(356005)(478600001)(81166007)(41300700001)(82310400005)(82740400003)(8936002)(40480700001)(2616005)(47076005)(8676002)(336012)(36860700001)(70586007)(70206006)(4326008)(83380400001)(6636002)(86362001)(426003)(110136005)(54906003)(40460700003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:43.2305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 692ef6b2-6d4b-4ae5-ca93-08db09e05c8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7515
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

Obtaining mport id is based on asking the firmware about it. This is
still needed for mport initialization itself, but once the mport data is
now kept by the driver, further mport id request can be satisfied
internally without firmware interaction.

Previous function is just modified in name making clear the firmware
interaction. The new function uses the old name and looks for the data
in the mport data structure.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  4 ++--
 drivers/net/ethernet/sfc/ef100_rep.c |  5 +----
 drivers/net/ethernet/sfc/mae.c       | 27 ++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h       |  2 ++
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 07e7dca0e4f2..aa11f0925e27 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -736,7 +736,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	/* Construct mport selector for "physical network port" */
 	efx_mae_mport_wire(efx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &id);
+	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
 	if (rc)
 		return rc;
 	/* The ID should always fit in 16 bits, because that's how wide the
@@ -751,7 +751,7 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 	/* Construct mport selector for "calling PF" */
 	efx_mae_mport_uplink(efx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &id);
+	rc = efx_mae_fw_lookup_mport(efx, selector, &id);
 	if (rc)
 		return rc;
 	if (id >> 16)
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index ebe7b1275713..9cd1a3ac67e0 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -243,14 +243,11 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 static int efx_ef100_configure_rep(struct efx_rep *efv)
 {
 	struct efx_nic *efx = efv->parent;
-	u32 selector;
 	int rc;
 
 	efv->rx_pring_size = EFX_REP_DEFAULT_PSEUDO_RING_SIZE;
-	/* Construct mport selector for corresponding VF */
-	efx_mae_mport_vf(efx, efv->idx, &selector);
 	/* Look up actual mport ID */
-	rc = efx_mae_lookup_mport(efx, selector, &efv->mport);
+	rc = efx_mae_lookup_mport(efx, efv->idx, &efv->mport);
 	if (rc)
 		return rc;
 	pci_dbg(efx->pci_dev, "VF %u has mport ID %#x\n", efv->idx, efv->mport);
diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 725a3ab31087..6321fd393fc3 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -97,7 +97,7 @@ void efx_mae_mport_mport(struct efx_nic *efx __always_unused, u32 mport_id, u32
 }
 
 /* id is really only 24 bits wide */
-int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
+int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_MPORT_LOOKUP_OUT_LEN);
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_LOOKUP_IN_LEN);
@@ -488,6 +488,31 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
 	return 0;
 }
 
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_mae *mae = efx->mae;
+	struct rhashtable_iter walk;
+	struct mae_mport_desc *m;
+	int rc = -ENOENT;
+
+	rhashtable_walk_enter(&mae->mports_ht, &walk);
+	rhashtable_walk_start(&walk);
+	while ((m = rhashtable_walk_next(&walk)) != NULL) {
+		if (m->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
+		    m->interface_idx == nic_data->local_mae_intf &&
+		    m->pf_idx == 0 &&
+		    m->vf_idx == vf_idx) {
+			*id = m->mport_id;
+			rc = 0;
+			break;
+		}
+	}
+	rhashtable_walk_stop(&walk);
+	rhashtable_walk_exit(&walk);
+	return rc;
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index daa29d2cde96..b9bf86c47cda 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -96,4 +96,6 @@ int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 int efx_init_mae(struct efx_nic *efx);
 void efx_fini_mae(struct efx_nic *efx);
 void efx_mae_remove_mport(void *desc, void *arg);
+int efx_mae_fw_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
+int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf, u32 *id);
 #endif /* EF100_MAE_H */
-- 
2.17.1

