Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BB369B5BB
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjBQW5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CE460A6B
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiPYw5CvwIc2TaP5EHtJmhYmzUtbnLBoJTf8F7xY6tNEJmmM65F4VcPD7VII1SVqj8qJI+vUZdBb4KchbyDBml6gonpWpbCozXGQgtOsUeWUMpsap7Y/x0dOe2OEXk+fwtrVe2tkI2fmD2gRqRaI9jc1ksAj5gtgTw0rqY6c+kkVbAtHLDbNwC3WxUgzu0hbLDex1Y2GGyCHZeLHnGkugGdq/lTW+F52uptIDLx0NcggZ3GKF5H1++BiX/oTQXLbO69rmsIP7XzF79+j7SQM5z6LhOgdsb9c57m7h5amIC383dwxvKlocjGwQAmlCBj2sw/I66B7si9rKDk0ABU2Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62o4bFjvid3jRWNIWfCz5FuAKsjxcW4fRAilnIldAz8=;
 b=Ee9/PawrvmSSGlk5aJPXxSMZjCENkAmDc5DTqtuhR50kYyJEXPWnntRkyEbzM2MpGmM5RM6ZZoAQ+pHGXaMQcqkYGYXWrMdG0XnV/gUMcllGGVFNxscMBaDiDardpV9colPsyiAnMImiEavFol0IAb8ij2H7AE8p24NuTyQ/W2HCHt0mOzhfRbtTnTOIqxFawaUeABBUTTm7Mb7LiD2Z5KdhhqvoP0yrjB20Ro1ydA2xQ2yxtHXjeQqmi1X54qRSFOy6L0V1AXSb8cRu7LA2JI0F6yW61to+hh17BJIV3xvT2fxOHGzq1e4nJQik5Ul4g0fqkaujCxxCaFMENNjifA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62o4bFjvid3jRWNIWfCz5FuAKsjxcW4fRAilnIldAz8=;
 b=Qv6JrYvKjs9EEc1CmvYOs/KaIAX0ZgryH4rh5uwXpDaYF+Mg3vXG6196x/MQyObwEgAeZV4KGBGZLnR4hDyL4Vf7njdktl2WwYLK7d7GVedn1nYiijKuALQVQQzi0htW0qr1B01PFnXU8WBL3Sy1yYgJB9/mdDLCWxjYIC/DWUc=
Received: from MW4PR04CA0046.namprd04.prod.outlook.com (2603:10b6:303:6a::21)
 by SN7PR12MB7418.namprd12.prod.outlook.com (2603:10b6:806:2a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 22:56:38 +0000
Received: from CO1PEPF00001A62.namprd05.prod.outlook.com
 (2603:10b6:303:6a:cafe::ea) by MW4PR04CA0046.outlook.office365.com
 (2603:10b6:303:6a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A62.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:37 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:35 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Date:   Fri, 17 Feb 2023 14:55:45 -0800
Message-ID: <20230217225558.19837-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A62:EE_|SN7PR12MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: 6960a522-9dcc-41a7-64bc-08db113a39e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KL8aQDz3zZHhtPT6R84/pFWSi4UKOcDZt2jeK5JetOoPUcLWAXz8l5OFvSFmr1g3syovVZs47MptHvQgisn4yU7DOY7e5Vcj4Rh0Af6j98bwun17Ka/QzxjCeLqFaCVH12tfgOD2nq0hox3QPWyasiX2+Deu3cN0zEDoOHO7hqPvcxXDyAP4qhGXAF4ojasImimt+LOvesj8p/Qj3EcRDsOx9wUU7q8KQQXrY7X6ytAIvOtQgKPssEH0f8jMtlIPX0+1W/6FEwCQi3Sa79aLVBlJtJaKeAhRcp40DTId7Hi5CiKkcSBL/0qVH7uTiHmsJRtdFV9dgi5Dn46NdFmfqK8TcBCZfcgZDivIWoJvfAu1BbbrtgM1GimWSg0nGlhC6ShFluD0MqRbd5E92W4e1jePI0tPMGasGVxB8vzs9wR/+HWD4b+qS3IQka/0OFDfgmBnKF0A9cmqgjr3d4kyAtkCqgelC1ywmrvixUmtD6c0FYIL4oBj+ojlw50pwNWNOtBzSnsKbliXiZvYC2NOwFp1TWbSaxJ1Twh/vUKBaDF5zmXLWAslbcE+B4Ix/3U5ZZBN2otKjqTiBNQHRZeKus/MvI0rpyPiJL9QE1XgbxtN5zJacuDQUitksfFPDnqNhsH0ReKJhtraWIKIWWeNGfzm3alrA3nB649gP1LCxZr5QOsvuOD9JxgRx5xE8Glu4qn+dvp1W/eKU92iJqYHSpkgUilRWkdc3L15I1fS7os=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(8936002)(41300700001)(5660300002)(70206006)(44832011)(4326008)(8676002)(2906002)(70586007)(110136005)(316002)(54906003)(40480700001)(186003)(1076003)(16526019)(6666004)(36756003)(26005)(40460700003)(83380400001)(2616005)(336012)(478600001)(356005)(47076005)(36860700001)(81166007)(82310400005)(82740400003)(426003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:37.9023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6960a522-9dcc-41a7-64bc-08db113a39e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7418
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new device generic parameter to enable/disable support
for live migration in the devlink device.  This is intended
primarily for a core device that supports other ports/VFs/SFs.
Those dependent ports may need their own migratable parameter
for individual enable/disable control.

Examples:
  $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
  $ devlink dev param show pci/0000:07:00.0 name enable_migration
  pci/0000:07:00.0:
    name enable_migration type generic
      values:
        cmode runtime value true

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/devlink/leftover.c                              | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..900216fd56b9 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,6 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``enable_migration``
+     - Boolean
+     - Enable/disable support for live migration in the devlink device.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6a942e70e451..bd85a3ff3774 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -513,6 +513,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -571,6 +572,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 3569706c49e1..2e56dfadd37b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -3923,6 +3923,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
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

