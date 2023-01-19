Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4282B673591
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjASKds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjASKdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:23 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553C54FC1B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VB4ChLDV2GwIRTMHS3CbfBTGYWFpIOlVKDGbXEHRFYSK59g8owIoqqaHr5QuoRipTktcIQc/DnDGJxfthsTLbxr+Vrmu0UrWuXbWb1+a2IVRbZ4t9jwvNR+N7DKgS1ckIobVf4L8BVQTIQUHr/A+zWnigFQf1eczmXh2VXlpjlsCtfHabY8UxmQ0hyw4PW9rOIbrLngNYW9Rr1hte/Elhp8+yqc6UE+QpGHjjqo3LIVTFG+B6DR8PTtZh2CvzHbVvtd9DEg9Bu/DlWNt3+C3KuICisieeUvTIKlmrSleFOVlBHkIO7auWgxgRW7w++Q1OsGT5F6k0hDDO9ofIqeuTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kx5CdkpauMYZ1Ii4r7UmgLNR4SOy2wZaDbQEd13iiMg=;
 b=d82GsPt/hmBOttWLkg0rn6NUiixIL94RCc88zhGxyUw8vb0meMNxAoRN6rzDDLuCOF5Jg2vluYKgoeYJle/feUnEuZQlRFi43JALs0zWYz2J6rN/jSZ06fVTKM1cwYvsIKWL3kW6cIB0GQ8QTWfyPJhavyhBVE2AdftJjgVKveKCUejKr5SXjT4axPSQlRSIC6QUUkjkSGrbWyI8qrc5ssHZOeE6lz00oJekYXrZgxbrZg6KahOsjdOWuBtPNtue2vp3oTjeaxRYIvcJETopbeKgGlwhzV61bET4DrVOjMx8MT9eGjHejatYQn2ZZbcJI/xa2Q72ow90CU0fQvEhJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx5CdkpauMYZ1Ii4r7UmgLNR4SOy2wZaDbQEd13iiMg=;
 b=REC/w0tCStvA0A0PhDCOZGyPQ7WJOKLqGaRrcLsC4aD4uj/6Blaj+wOxde7/3M7mr/knjMQ+6wmEUasD/FloAHiSB6sS8znleh5WCuBg29cvxY4FE3OpQprjEOUcPUQt0LWGkZo8W736xc1b+3t7eupIzHG1ZCjYyGIaDGdcmWk45ofGD2MOweMV6EI6jywE+VnyBoaum4gK6qhwH6iZOzvq7bx2U41J1sPbhpFRQZGsg1IVrWaqHVMvIcBH6ula7yRUN+3k1R0M5xzcZMvUamLz0599HIpFEXVO2YU97EEBQ1KTk3ce8zsQbcNp+6Mqj5VDnyEHbMFbUixZRxWQxA==
Received: from BN9PR03CA0285.namprd03.prod.outlook.com (2603:10b6:408:f5::20)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.25; Thu, 19 Jan 2023 10:33:18 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::aa) by BN9PR03CA0285.outlook.office365.com
 (2603:10b6:408:f5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 10:33:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:04 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:33:02 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: Enable string TLV usage according to MGIR output
Date:   Thu, 19 Jan 2023 11:32:28 +0100
Message-ID: <1958a5428ad581672f1231251a7b308325c8ebfd.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT033:EE_|DM4PR12MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: e1529ac4-1f32-4e51-b804-08dafa08947d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1DbSeRm8OVD3nR54pcazPJM5BJIfBcFA8fq6xgwBhP1NEWmhQxZF2fII5kNrnOqR/2qnnl+lrtDl4XivT2HzCim5kaxWcQScili+hPznjHIeeoJx7BZCVB+zI2eMmyJd+2Dy8luYdB1l0q6Zq+DSHbJlxenlKG521cWRZNT274TqA/MhnPpGDpTQSBwwiBVw5+2Fz+rPgI2tCgQVOvHoKaYmGjTI3x6f6YGp5g3a7yun4Oh9+XqFYiCZ0suttSOOJImZPgITF2nS20mz/QZL2tb9FGw9vb+6NZ/G831NSrHpL5zPf8WStwdW/skLbFVacIVpHJftrtnhxDGVV3X7KgY4/sweKHvAa4vofhqfcPtbAzFd08Z5ed4Pe2pcEUAcUgwF8hCBecedYHEhxOeBPnBz/75/5rWjyqz54SiMKD+EhEDHl5c1xT/9Bf4WW3uuYENy/rMz2wM3IuaxkaCMfOSKJn2gp6meK8cpbA5ZUiZYl2+Lod+n3aa2v8Zcx75OgqENPiBWWM4KsNWcjTv8So43LAQLWW2mwH82dKWb0pD4GHa7iWwpAogVHEqqzvet4jsGovAzhWMNy8mrgvqEyw+aBvZUew5AIfAEn64W2Jrag2VUP6kHynRrwpg2uYYLpiGjGpw5v4DjfgpqGjreQm3t/pg2U47i99htPfWivKWpzbtJlD3OQF7owIfrc2C2R6nee7WNu1zau/ZVjaZ1mQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(82740400003)(40460700003)(36756003)(356005)(86362001)(7636003)(8936002)(5660300002)(41300700001)(26005)(316002)(4326008)(70206006)(82310400005)(70586007)(8676002)(2906002)(426003)(336012)(40480700001)(47076005)(2616005)(83380400001)(478600001)(7696005)(110136005)(54906003)(186003)(16526019)(6666004)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:18.2264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1529ac4-1f32-4e51-b804-08dafa08947d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

String TLV is not supported by old firmware versions, therefore
'struct mlxsw_core' stores the field 'emad.enable_string_tlv', which is
set to true only after firmware version check.

Instead of assuming that firmware version check is enough to enable
string TLV, a better solution is to query if this TLV is supported from
MGIR register. Add such query and initialize 'emad.enable_string_tlv'
accordingly.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 36 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 --
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  1 -
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a0a06e2eff82..cb3715f1582b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -794,6 +794,28 @@ static const struct mlxsw_listener mlxsw_emad_rx_listener =
 	MLXSW_RXL(mlxsw_emad_rx_listener_func, ETHEMAD, TRAP_TO_CPU, false,
 		  EMAD, DISCARD);
 
+static int mlxsw_emad_tlv_enable(struct mlxsw_core *mlxsw_core)
+{
+	char mgir_pl[MLXSW_REG_MGIR_LEN];
+	bool string_tlv;
+	int err;
+
+	mlxsw_reg_mgir_pack(mgir_pl);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgir), mgir_pl);
+	if (err)
+		return err;
+
+	string_tlv = mlxsw_reg_mgir_fw_info_string_tlv_get(mgir_pl);
+	mlxsw_core->emad.enable_string_tlv = string_tlv;
+
+	return 0;
+}
+
+static void mlxsw_emad_tlv_disable(struct mlxsw_core *mlxsw_core)
+{
+	mlxsw_core->emad.enable_string_tlv = false;
+}
+
 static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 {
 	struct workqueue_struct *emad_wq;
@@ -824,10 +846,17 @@ static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_trap_register;
 
+	err = mlxsw_emad_tlv_enable(mlxsw_core);
+	if (err)
+		goto err_emad_tlv_enable;
+
 	mlxsw_core->emad.use_emad = true;
 
 	return 0;
 
+err_emad_tlv_enable:
+	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_emad_rx_listener,
+				   mlxsw_core);
 err_trap_register:
 	destroy_workqueue(mlxsw_core->emad_wq);
 	return err;
@@ -840,6 +869,7 @@ static void mlxsw_emad_fini(struct mlxsw_core *mlxsw_core)
 		return;
 
 	mlxsw_core->emad.use_emad = false;
+	mlxsw_emad_tlv_disable(mlxsw_core);
 	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_emad_rx_listener,
 				   mlxsw_core);
 	destroy_workqueue(mlxsw_core->emad_wq);
@@ -3377,12 +3407,6 @@ bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_sdq_supports_cqe_v2);
 
-void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core)
-{
-	mlxsw_core->emad.enable_string_tlv = true;
-}
-EXPORT_SYMBOL(mlxsw_core_emad_string_tlv_enable);
-
 static int __init mlxsw_core_module_init(void)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e0a6fcbbcb19..a77cb0be7108 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -448,8 +448,6 @@ u32 mlxsw_core_read_utc_nsec(struct mlxsw_core *mlxsw_core);
 
 bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core);
 
-void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core);
-
 bool mlxsw_core_res_valid(struct mlxsw_core *mlxsw_core,
 			  enum mlxsw_res_id res_id);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f5b2d965d476..3d15d3387aa2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3092,7 +3092,6 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->bus_info = mlxsw_bus_info;
 
 	mlxsw_sp_parsing_init(mlxsw_sp);
-	mlxsw_core_emad_string_tlv_enable(mlxsw_core);
 
 	err = mlxsw_sp_base_mac_get(mlxsw_sp);
 	if (err) {
-- 
2.39.0

