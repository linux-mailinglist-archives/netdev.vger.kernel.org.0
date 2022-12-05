Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F301642EB1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiLER1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiLER1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:27:35 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B7B24C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhe/ae0mWmcVyfE2qClAVDuWM9Zqu3+otfHU/OchRf2MwiYVL37FdL1iwKwduzsPsjQpK6H8IqGj3Y2KsUNAqashQSd2FAlLnjD/JQ5KJiftrj/KRQ02mRxMYjX+pMWbeVgEywT5Cf1lM/89YVyRQr003vcmA+0NHIkLOZtrJhooy4EoMUBWcBaXgt984RcAm9gmAfJ7hjIqtrQHkehVx81wCA1/k/VMYo9WJuASGlDURYdOEi9NxMW8m8lpwqvtEsE8up56fAyntxxA808F37PWKu13hqV4TotomaMl8IPLu2Xz3944rMOsGisdAomGriJhAyQiNryERLDQVRu7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8BxpuOF2LLZcd74BZuuEvHt/M3BI2FYtbNwyiA7qeM=;
 b=oN9Gfjr0Qf1Cwgoe6vmNfrhzgaPIpdyozJIymqRQBCC6db2M1LHdlYI7vwWTVtdv0xeekIo9tws5dG5W2CLvW9BUUL8O7mIB+6BQ1qqTnkMNwWlOWMrDMEYVJ4hkirtE+QGm4p/zoJ+GGVT8WhdzfaWBYES8SKiUFCBApWDqD9Nm9bboq4pD22RGejMeoRic1QHAH44TL4FT+X36aBAfx+xkeBHqoYC+4vsfITV0+B3eMbMR0slrfbAbmwM4yhNyvX1Pr/Nk9SYPKVmHPn0s77elISwZ7k+k2JC2Oxj366YVyj1yRcP1qPNppZdaK1H8yIraLD9BSPpzxcwrwW53ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8BxpuOF2LLZcd74BZuuEvHt/M3BI2FYtbNwyiA7qeM=;
 b=oJWzoLSMqvoLRhfDhIzAy7q2avbiOycY08aUwIxHgUIFi3cvNNDqMAuA6qpww21aKunG070N8w8kQIyPOfGMQmE9fkamkAjBYhB1GVXLbhx3SvHgFgqrbp2erX6eC5wrJtlLagAjSl10R57jZ0q7b/VnjFcitvJ6eyhhHwm335A=
Received: from DS7PR05CA0054.namprd05.prod.outlook.com (2603:10b6:8:2f::28) by
 DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13; Mon, 5 Dec 2022 17:27:31 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::6f) by DS7PR05CA0054.outlook.office365.com
 (2603:10b6:8:2f::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Mon, 5 Dec 2022 17:27:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 17:27:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 11:26:48 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@nvidia.com>
CC:     Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 2/2] devlink: add enable_migration parameter
Date:   Mon, 5 Dec 2022 09:26:27 -0800
Message-ID: <20221205172627.44943-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221205172627.44943-1-shannon.nelson@amd.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd0bed3-3d19-4fd0-723f-08dad6e5fd88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qsivbpr9KVOBujjOARKZkQSDJXnHKuVhrU0XupaYcfOZNR+6WD6qDtY1YxxTP0ZWXNvZFZPL5soSACDWJuwpQenXSPGqP+3VgvMWtWE08XqRiFH/UE6pQoL6b4viit2tTeMxyzbrqSL3jDakNYU93fnJseFTg6AWnuaTe3P0l22IFwJ81TLnsgJn8QxnCnTSivJ1F9KiS2mRX1NT8BsrAKX7G32aw0s0BOmYs8a0YYaCwIs5q0QtRpRO4kHRemcKM8hvjmSh0hKx5fXLsfbY+IvStM+ahdRXuqidezKMuNmjaR49HPnX+tkhM1o8Bv1gAO61vBSY3xcW0/ppECF3VqseU6Ki6ZDx8+wJc1tXJihCKQHL5WX3DqddxSer5p6pQheZX/FPFl8hvL8Q8GETd+0/22k+chq/6gPQFKzkKGZp/ZjmSzlxgRO6NaEmLJ7jnxSZjOEsGXpknGZzyIeMJrp2j8TigNCFjoNFXiyoMYiVP6iBYbjcIPVdCVPkdRK9uXdxIqMDLU68k5bmYPm/5joNC+xzZyuBEz+55zlDV3F65/ICbOA4JmhjhmHwguQ8Zc2gP1UQQhe/LBXB0L/+DS+OeKsb/VbBeGThC+2RjEkxwhxBibuLc5GPoxrC+k2g4rH1/e4kpHw5ZfOA7E528h1OvGQPb3D4cq/Qc+2i+tdlsa93MjxrKYRz+5KOV+LFAXQLjyQFlm7p8KpTZrAfzzbMccNR8caI8zaTGWlMtdw8rKf8eIkD+53WgRCq2Lc1ffb1PNWHqOPgwX/S6qPC6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(36840700001)(46966006)(40470700004)(426003)(47076005)(83380400001)(16526019)(40460700003)(336012)(86362001)(478600001)(966005)(40480700001)(36756003)(36860700001)(82310400005)(82740400003)(26005)(2616005)(1076003)(356005)(81166007)(4326008)(44832011)(6666004)(8676002)(5660300002)(186003)(2906002)(70586007)(70206006)(110136005)(8936002)(41300700001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:27:31.5154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd0bed3-3d19-4fd0-723f-08dad6e5fd88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To go along with existing enable_eth, enable_roce,
enable_vnet, etc., we add an enable_migration parameter.

This follows from the discussion of this RFC patch
https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index ed62c8a92f17..c56caad32a7c 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -141,3 +141,7 @@ own name.
      - u8
      - In a multi-bank flash device, select the FW memory bank to be
        loaded from on the next device boot/reset.
+   * - ``enable_migration``
+     - Boolean
+     - When enabled, the device driver will instantiate a live migration
+       specific auxiliary device of the devlink device.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8a1430196980..1d35056a558d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -511,6 +511,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -572,6 +573,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
 #define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6872d678be5b..0e32a4fe7a66 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5236,6 +5236,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
 		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.17.1

