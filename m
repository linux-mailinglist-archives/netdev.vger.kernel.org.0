Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FB16C5139
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjCVQvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjCVQuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:50:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AA5CEC2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:50:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+8LGdutGpIdntdeJzUkPYymsb26gtMVlYwbO7NeC+1XDrBBN57Y0mokv2QT7j3fQy/5umsw9qvtEFUXSTyH+uLzfCe67un7vq4MuZTWT6S89NTuJramDFCFaskoXjhHN8zWASQPTThLDBEC4bzU9mTHiVdm+k9PwQVNLMnBDGajn7cQI5NzmL1Qap0JhmrCyC9a6Xt1XoWRzAUVn7Mz963v4B3bc7EyFD0TFFYLTU1Z+c2NcR6WAVPoa/YABjI/R1D7kO3YDMMFXOnVTKdD+/3SDvuuARp8mJjLaLfZERYisC/JYpIDuRJlsIC43lYH4HBdJA4isZf9DhgJDkeHtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOjL/iXdM+JsJsABKBqeek7GV5wKVgXUQdeZIdmh/Yc=;
 b=fiLh/E2oVG1TtoCdqIp8ZTGt++/wDHTk0gFjoMmC9MQz/cM+SmwMszly/mVIE1d551qaTbU7733zZsVKxmEFe3vVBPsEim1m5f+Ct/4fGyR6u1zKK96DQtpo/gzgbaBW0PNFOahmdh0zY9AXRM3SMkrwym7bk+t5GGv5mPctr4XFMs5C41SQCqGYTNZHb4BkjfJuZRBDoU+a24uCT9t4kjQp26UHDF4r4hgifCNXw9QxWdajJtnTFK5nsGZhdeB3v49c5SExv4tpV6l5xfYe1vkoJhKwaJBYFAhq08UOCdnPsi2IMuW0pbX6AqWB2bE/CibeWw1R1pZDy2tKUj2ucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOjL/iXdM+JsJsABKBqeek7GV5wKVgXUQdeZIdmh/Yc=;
 b=oz9OY8qn8cpao9gFSf/5MeikKaaUMGLV9r4PXgYadl8bECrlQrd7s/vxk/CHZY2jl+9whNFado3yQYjHKMj+TDWsCRITqiuK97ww9x7k8BTyLvJC6poNB3BOgsHY6/vHlerELRe9bQMK1vwgPrW0VQkasck7UF5xBwCRZXdQkGeZK6ABAxrqGE4RhOLKj6tCcd/oNaNNR1IMpp/oERCucpixhPWMuIeOrpl8goY5TJfa0JlCZUgODijF7h1jXHdcEApiKZyHlZCL4pr/yA6rEbQjAUeTnkxd0BXA5VsbM/N9JuOWGCZ8+moU+tGO7oEdT2DOsM4BaqMKSPbJfPJtlQ==
Received: from CY5PR22CA0079.namprd22.prod.outlook.com (2603:10b6:930:80::26)
 by DS7PR12MB8419.namprd12.prod.outlook.com (2603:10b6:8:e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:50:33 +0000
Received: from CY4PEPF0000B8E9.namprd05.prod.outlook.com
 (2603:10b6:930:80:cafe::c4) by CY5PR22CA0079.outlook.office365.com
 (2603:10b6:930:80::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 16:50:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8E9.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.2 via Frontend Transport; Wed, 22 Mar 2023 16:50:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 09:50:19 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 09:50:17 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/6] mlxsw: reg: Add Management Capabilities Mask Register
Date:   Wed, 22 Mar 2023 17:49:31 +0100
Message-ID: <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679502371.git.petrm@nvidia.com>
References: <cover.1679502371.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E9:EE_|DS7PR12MB8419:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ae7215c-6376-4e2e-08df-08db2af58d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aU3A1U5Hn50Q4jHmBeOp8bmgBG3br1XLGNcuXJi4A5Zv7sPZwH24m+IwAOXYujp8gImTr7Saa8jZrKKvcz9pYDfhb40W/cNTI8n6QYH5bId/MhWOAHWkEYWVWuGVjzhXhz/xoFRT84e9WraJXN/wFMX6MxwYfK/L78KB1z/QQ8P9pYmOyapc6e7R3yDM9AeddLUwuRAefdaeIDulkiyC+DU3/+K6ZqCrUfylMOMbNGlgOZbnskkd6s6hR3vBJEt+sHZp5AVOxHiCbFgP3fecAgZ13zkehF3Zi3lJCHE8a0Oyx6ipzlPBlpM9kPc3V8FBFXj9UcTKIY6xyXpfPcbsqJwcXhiS4gT1MKDAKhYg/jpeJjIo3PswDNW32EgxBTke2zxmR8bOK61ySv8ZQWXHUWY43iV2CGrQRiI0hdzmRyEnmFUVT5sYhviOyHMO+VyFCJn3wS7odwH6Zl+TAsR3r6nuUQnM1XA4/i8TQtsMXfMXGPLY0Wk4s5iAIl9MeBrLD5b28NZspywzYVYrixLGz3I3r09teqyjNGp8OoRyg7kKle229QPHrreUsGZMeQWwY5GWtGOS30O9rsWDZejp4t79J7LsHvkeKh7HISwTYdINk9JnCUtNXCQJXVAWjvvz0L1x55JrTMQejizTcNY2hy96DTSM70t2Pkqs2i8CQ9jvbI2Txf1UGv7ui+MUIVyZLbSMtiTxHW2iTvezaIuYMqOzyCR+giowwsTTEBy+QzGdQAm3ALMF+r+AmqnCNpXu
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(7636003)(478600001)(2616005)(110136005)(316002)(82310400005)(2906002)(16526019)(186003)(70206006)(82740400003)(8676002)(70586007)(26005)(83380400001)(54906003)(4326008)(86362001)(36756003)(356005)(107886003)(6666004)(40480700001)(41300700001)(5660300002)(47076005)(36860700001)(336012)(426003)(40460700003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 16:50:33.1033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae7215c-6376-4e2e-08df-08db2af58d7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8419
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

MCAM register reports the device supported management features. Querying
this register exposes if features are supported with the current firmware
version in the current ASIC. Then, the drive can separate between different
implementations dynamically.

MCAM register supports querying whether a new reset flow (which includes
PCI reset) is supported or not. Add support for the register as preparation
for support of the new reset flow.

Note that the access to the bits in the field 'mng_feature_cap_mask' is
not same to other mask fields in other registers. In most of the cases
bit #0 is the first one in the last dword, in MCAM register, bits #0-#31
are in the first dword and so on. Declare the mask field using bits arrays
per dword to simplify the access.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 74 +++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0d7d5e28945a..c4446085ebc5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10509,6 +10509,79 @@ static inline void mlxsw_reg_mcda_pack(char *payload, u32 update_handle,
 		mlxsw_reg_mcda_data_set(payload, i, *(u32 *) &data[i * 4]);
 }
 
+/* MCAM - Management Capabilities Mask Register
+ * --------------------------------------------
+ * Reports the device supported management features.
+ */
+#define MLXSW_REG_MCAM_ID 0x907F
+#define MLXSW_REG_MCAM_LEN 0x48
+
+MLXSW_REG_DEFINE(mcam, MLXSW_REG_MCAM_ID, MLXSW_REG_MCAM_LEN);
+
+enum mlxsw_reg_mcam_feature_group {
+	/* Enhanced features. */
+	MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES,
+};
+
+/* reg_mcam_feature_group
+ * Feature list mask index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcam, feature_group, 0x00, 16, 8);
+
+enum mlxsw_reg_mcam_mng_feature_cap_mask_bits {
+	/* If set, MRSR.command=6 is supported. */
+	MLXSW_REG_MCAM_PCI_RESET = 48,
+};
+
+#define MLXSW_REG_BYTES_PER_DWORD 0x4
+
+/* reg_mcam_mng_feature_cap_mask
+ * Supported port's enhanced features.
+ * Based on feature_group index.
+ * When bit is set, the feature is supported in the device.
+ * Access: RO
+ */
+#define MLXSW_REG_MCAM_MNG_FEATURE_CAP_MASK_DWORD(_dw_num, _offset)	 \
+	MLXSW_ITEM_BIT_ARRAY(reg, mcam, mng_feature_cap_mask_dw##_dw_num, \
+			     _offset, MLXSW_REG_BYTES_PER_DWORD, 1)
+
+/* The access to the bits in the field 'mng_feature_cap_mask' is not same to
+ * other mask fields in other registers. In most of the cases bit #0 is the
+ * first one in the last dword. In MCAM register, the first dword contains bits
+ * #0-#31 and so on, so the access to the bits is simpler using bit array per
+ * dword. Declare each dword of 'mng_feature_cap_mask' field separately.
+ */
+MLXSW_REG_MCAM_MNG_FEATURE_CAP_MASK_DWORD(0, 0x28);
+MLXSW_REG_MCAM_MNG_FEATURE_CAP_MASK_DWORD(1, 0x2C);
+MLXSW_REG_MCAM_MNG_FEATURE_CAP_MASK_DWORD(2, 0x30);
+MLXSW_REG_MCAM_MNG_FEATURE_CAP_MASK_DWORD(3, 0x34);
+
+static inline void
+mlxsw_reg_mcam_pack(char *payload, enum mlxsw_reg_mcam_feature_group feat_group)
+{
+	MLXSW_REG_ZERO(mcam, payload);
+	mlxsw_reg_mcam_feature_group_set(payload, feat_group);
+}
+
+static inline void
+mlxsw_reg_mcam_unpack(char *payload,
+		      enum mlxsw_reg_mcam_mng_feature_cap_mask_bits bit,
+		      bool *p_mng_feature_cap_val)
+{
+	int offset = bit % (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
+	int dword = bit / (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
+	u8 (*getters[])(const char *, u16) = {
+		mlxsw_reg_mcam_mng_feature_cap_mask_dw0_get,
+		mlxsw_reg_mcam_mng_feature_cap_mask_dw1_get,
+		mlxsw_reg_mcam_mng_feature_cap_mask_dw2_get,
+		mlxsw_reg_mcam_mng_feature_cap_mask_dw3_get,
+	};
+
+	if (!WARN_ON_ONCE(dword >= ARRAY_SIZE(getters)))
+		*p_mng_feature_cap_val = getters[dword](payload, offset);
+}
+
 /* MPSC - Monitoring Packet Sampling Configuration Register
  * --------------------------------------------------------
  * MPSC Register is used to configure the Packet Sampling mechanism.
@@ -12904,6 +12977,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mcqi),
 	MLXSW_REG(mcc),
 	MLXSW_REG(mcda),
+	MLXSW_REG(mcam),
 	MLXSW_REG(mpsc),
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
-- 
2.39.0

