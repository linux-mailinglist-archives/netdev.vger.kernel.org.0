Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896E967358D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjASKdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjASKdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:18 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8968E8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWTh08aMNbp8Ve3aMeSLlEBKzmonOxnyhOUjqwA6BxEnmnSSPg/7ulVlPawifYdMA1c20VRpAqfgHGp84pDSIj4W8ACRI976eSCmywyrtv22DyVA8qvc8HpYkfvJqLqEygUL4fU5THSjuRl/jf1QofSBnt5fXGNAColg5vMG85GQKGol8hjxz+NnHBuM/3gNYvE5oL23AKVc4sUDHBWBj+KkVz77Drv+BTkulR4z1CBPM/hVtrNCCJROx8TIM4y9+KBYfcPVompKKrKMdx7VnLmkm9pacDHAz6u37i3l4XP+oS6ftDbH61LmoARbUA99MhG5nhCfPaJPgsxtk85TRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccl6sTp4Ga/tQaLytKtRtgQkOnoNZ4gjQt+7kvUlemM=;
 b=W9a1aZoKAO+2HYs5XCkBXPHKtxU3VDp8leqk2y6APzwj6qCFeY+j02ZDTEya8fHHQ/+HSLdKNbBix/NBFAH/Dsq01RB6gZGSm8Msq/NhnA39l3LDBib9T2n2RG7Xi2bblqbwj2G67Fs5+QbavD7T83pcXAYuVkN5kMr4ykhWZ/FUxvX/v34A8huIq2dBu0qbLSJnco2NxLvaBPA8iPVmFO1YZorOjrxzWdN/wX1XzSWZ1mBzjrLSK3VHWGS3gH5sgEyZRA0ROaFjv0dMKbYhp+I6aigXlLu77WvYfs1JgDjnGTx2XuEb95HtHC0xyWXPAUFnlaWzx9mDxEc+u63z0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccl6sTp4Ga/tQaLytKtRtgQkOnoNZ4gjQt+7kvUlemM=;
 b=dSr+rWhpEOlbBHX0RDraeQKhkRGAxcGRvGpnRD/I6noB9C3waF5F2WKO34ElBtdOMbSl2p9QErfKW9gLqbp72SHJmPmiRmX1aPQgKMMEr+KCbGIR6NNElRumXnh911AV/RcoTqy4HcudEXup+k9lbttgGRdkPepaAUQs5FcL2A0L94g5lmnd2i15PokMA9us8DQWfh3KeEqi+o7tE3oOUISBTL1hlH+uF5aGMSKTHrzwDWDCCcQKLHDUV75+jzBEidyDiC5ux2uWeV5V0FN8eaLD+Tcq3ZEDvfUsuoJIySLV8pGm+k7/36wqtCGoWOrOZ7+6TS1tw1dgRk+LspU2Lw==
Received: from BN9P223CA0023.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::28)
 by CH2PR12MB4310.namprd12.prod.outlook.com (2603:10b6:610:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 10:33:15 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::be) by BN9P223CA0023.outlook.office365.com
 (2603:10b6:408:10b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 10:33:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:01 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:32:59 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: reg: Add TLV related fields to MGIR register
Date:   Thu, 19 Jan 2023 11:32:27 +0100
Message-ID: <aab90f12e610c1344a4e127193f8b47dd2c5bc89.1674123673.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|CH2PR12MB4310:EE_
X-MS-Office365-Filtering-Correlation-Id: d9f32cbb-c115-41bf-e6ec-08dafa089298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CoP0EfJtu5OECJGOv9T34VBMe70xwpICKFfJKZL1m0PZ22lzzGb7wKIvp1KeVaT0ET/Ss4RCgKy9JQKHYPkJQNMaBuTVv74CQZEvAb0osUU9kr7qFOIGN7AxKvRJAyNcFEw6QZIQlqkAdY7++LDwLfmbtzGDcUkGlmW3abRyQUF4v24gUpXjtxOnyX5N41F0lSp+W9kKEnkuZ7tvhPwT2nhH7nGgfzKfS3iJwP6le+HDL1v0BDhlaTK5rLaJvTbmFEPjK93qAjWNbhxq93ISfCZzwHJYSu7FnPa/tKTGkNX9J8fPa+Vj+azlK7xjWpoe8bsLpJtE5o2Atf5dU8YOr8zjXFpYXl5yQhk0f5XHYy06DEI82XPBwvCfOQPywLYCa1weDP+rJ3QlMb+JgCFJbWe7OaO4qdfbyFQdyTCtFIaJ2e60/Ktwp0a2+Bn8bFl8CMcwUq+6IBFRFf0CWufIr/JbjwMQeSAoUdmx6vlinlepeVpgHcQvwAtc1sTR6aQ5hhd7fRfiM9EOTrxwPfrbzlwokACNL+CoAFjIfuZLW8BAFEFUKw6PFhMfUSA+mCJCUKMhLLo7UyPcLSqEIRR/pPS62zYgmVE2dSQ7unyvYAWngwa+1Ah3CxzlVN+sy8lfdEphO+knnoUdGlq1FASC6VFOEVYQ3CFGu0eWDIKfM8CMSzLLabBw4/8G6sRmBL8Rnmd1rVQJ8SFzj6YullSREA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(40460700003)(86362001)(107886003)(316002)(6666004)(478600001)(36756003)(7696005)(8936002)(5660300002)(40480700001)(82740400003)(70586007)(70206006)(4326008)(8676002)(41300700001)(36860700001)(26005)(186003)(356005)(16526019)(2616005)(82310400005)(2906002)(7636003)(83380400001)(110136005)(54906003)(426003)(47076005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:15.0491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f32cbb-c115-41bf-e6ec-08dafa089298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4310
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

MGIR (Management General Information Register) allows software to query the
hardware and firmware general information. As part of firmware information,
the driver can query if string TLV and latency TLV are supported. These
TLVs are part of EMAD's header and are used to provide information per
EMAD packet to software.

Currently, string TLV is already used by the driver, but it does not
query if this TLV is supported from MGIR. The next patches will add support
of latency TLV. Add the relevant fields to MGIR, so then the driver will
query them to know if the TLVs are supported before using them.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f2d6f8654e04..8165bf31a99a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10009,6 +10009,18 @@ MLXSW_REG_DEFINE(mgir, MLXSW_REG_MGIR_ID, MLXSW_REG_MGIR_LEN);
  */
 MLXSW_ITEM32(reg, mgir, hw_info_device_hw_revision, 0x0, 16, 16);
 
+/* reg_mgir_fw_info_latency_tlv
+ * When set, latency-TLV is supported.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgir, fw_info_latency_tlv, 0x20, 29, 1);
+
+/* reg_mgir_fw_info_string_tlv
+ * When set, string-TLV is supported.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgir, fw_info_string_tlv, 0x20, 28, 1);
+
 #define MLXSW_REG_MGIR_FW_INFO_PSID_SIZE 16
 
 /* reg_mgir_fw_info_psid
-- 
2.39.0

