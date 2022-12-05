Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF52642EB2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiLER1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiLER1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:27:35 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BE7257
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dC/Xj2v2a2rlu5YqXK9+Owlns/IE63Ym9I3vf+LDWS4qVMwGSlrbgwJsi/GU8ktcwf+ELt2YghZnqUCrUzuxIQVZIfkD8rqfzeN10zDEgQjhB337okgWyIK21+KAUSDbMlWkVt03Xob0cFMnqM+DtTfv7vyoWmKdcXoXdm0ohtcSIt7ZxcPk5Fbm/wBTCBLoaQ5pq4tmTMSZ5BEdpGF3h698p5sndzPI4BlJk5eiVTpl/JXzGbzDc96bg6Dg9mn1v+PN9kA2cC1w4fsSt1TGFA/nnMAo+n3OnyOaDomgkArUX14uIhfopSU6OLyNoJAtlYBw5XMqSmK/TK4RPr6O8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjOQLOksm5mKdHX0ToyH1nmQXAOWP8zXWPAeUQNZBuw=;
 b=OM1Zhyk7gLyzYvTmYAlhx0tcjsiHtYL8crPvfZ1WM6V7emydlk8dtZiAB+dBTXkoSb1uD/asfNaAQpqQ07gwkB0PT1MCGV1otRLo/cvCAzpvJcPq5x5W3QLpmn4l3acWk7LKPaPdgBDfhXidB77aIOAlMemBMdfYfxV2cHjkDqel+wcA/nYlwAAIB+EEoXP0fQ/NrlyHLRupyxj/02N4szpjMQtPeAmWCmAjOutYamDr5zYa35Y+A6gH3wGbR5erxYRuZCa1j+B+obv7Scdk4ZIcyLysVhURvN9jX8UcO4TA5Lrv8KG4KDXLFtErIMSUGDdqP6r4fDisIUj0JzMmiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjOQLOksm5mKdHX0ToyH1nmQXAOWP8zXWPAeUQNZBuw=;
 b=EW6wzVVmBVoxV++KIv2yWuDu5+pr8l4beBwFJSZ6gobHfA7L7dbolBAMikEU2h85Bp1jxbCnvZv/9fEMne4xgnLaw6Tywt3L2yrypYNZ5HUbUBei//ML9LMkv8wnFyM5ezEjSYSjNQvC0FuDfBU426zXuHYNgZ+iDDP+//Uh2og=
Received: from DS7PR05CA0054.namprd05.prod.outlook.com (2603:10b6:8:2f::28) by
 CH0PR12MB5172.namprd12.prod.outlook.com (2603:10b6:610:bb::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 17:27:31 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::2c) by DS7PR05CA0054.outlook.office365.com
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
Subject: [PATCH net-next 1/2] devlink: add fw bank select parameter
Date:   Mon, 5 Dec 2022 09:26:26 -0800
Message-ID: <20221205172627.44943-2-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|CH0PR12MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a2e895-3b86-4ea1-2636-08dad6e5fd5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99U3DQycjl9UWG3VpvbEa0q773sAitElh8H/JNLevuBwqSOuYo6Hc1h82E3F2satDZCDQNq2xwz51ZZ9KbiEly7ca6C8apA4nmGoZ6iSViEScgcOxNQOHza8yvGNaSzsS5NFNhOyku5UxWLVD2klx3D4SjiRQrK/01LSFPm1+DJKO8bku562Fbemu/Fw16uV2yexBN+ZGFKwRINDXittzCP0Ap9NpkPmD1beALDrnovMn10NLbDLCl9zWMO4eYV/b+UP8Ti1njbkXAysCtglnwiQmPcvD7WkHb+fT3LeZVCIGsKJ/w7Z4NkOISKMd5z1+WGcQc8MXqujUo+x1036WY/6BX5s+YLz57X6W6NFrp8ZAFimdCyV8XPDXftWf7ALHX9bN4HW5TdIDvCL/M5EOY7N+MaoJ+GdfZ+/cTpbP9/2RKPbTH4vgxF25MGiZQmBgCNDOnTelu9EK0JVKc0AFp+BKx3oDK+C7/YdAkg1OtFIUNwcragAqcyvi4QuImqkYrIN6YyDn9lDqXDXNngV9K49rl5ExB8d2/vOvO5qhkQ44AI4FaYhaSm12Em2ZuWPvnjhXXOcVSNPmzEePlid3tC338IudBOlpNv8wjDcFM+1pacwdvMnWx50qhg4tjcP2DIUyKiw1vS/GOhjaPMVfzkbqOD4nWwlCxZkUxMx3QrRsVhP+knjovLBdtDzkycb50nG+d77k/4k3eIMLKQv5snX90iuFSaXAAbrLismqFxLPynd7deyRHc/rl2kQsuApDs/isz7A5FJw5L0wguf0w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(478600001)(6666004)(45080400002)(26005)(40480700001)(110136005)(70206006)(70586007)(966005)(4326008)(8676002)(316002)(47076005)(5660300002)(426003)(336012)(81166007)(82740400003)(41300700001)(8936002)(86362001)(356005)(15650500001)(1076003)(44832011)(186003)(16526019)(2616005)(83380400001)(2906002)(36756003)(36860700001)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 17:27:31.2185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a2e895-3b86-4ea1-2636-08dad6e5fd5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5172
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices have multiple memory banks that can be used to
hold various firmware versions that can be chosen for booting.
This can be used in addition to or along with the FW_LOAD_POLICY
parameter, depending on the capabilities of the particular
device.

This is a parameter suggested by Jake in
https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..ed62c8a92f17 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,7 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``fw_bank``
+     - u8
+     - In a multi-bank flash device, select the FW memory bank to be
+       loaded from on the next device boot/reset.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 074a79b8933f..8a1430196980 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -510,6 +510,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -568,6 +569,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
+#define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0e10a8a68c5e..6872d678be5b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5231,6 +5231,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_FW_BANK,
+		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
+		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.17.1

