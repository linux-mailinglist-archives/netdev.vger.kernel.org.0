Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31306969E4
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjBNQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjBNQi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F02CFD5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/fpXEllhn3usy1GE7aqjwTIq4pN1NNBqhOr8R1Vknd65oI4H8TIP+bCKB/p6kSF8J7U9fCm2Pt2aesyypp+mqxEOpGolwrMfhKP1lvqm8shx9S+suMWCH+3pNtofvQhF94UVlIc5GjPH/7rVhYEL45SDNChT4DQF8hXAsF8Kx8boO1kAIsW0gooEmqTpihaPmkMAg212R7GaXB3aBeZRxZQ0o9wJDUm4L6OBPooTkce6fyOULLfegD9AOqmKBNrG1DvaMNN6UeUqRoF7W+mJ63kVxPSjaXh2wUEoH9V5ro6+kM5XbUy66fU65fIHy2jayCUApgheUMZNMaivHuB6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4DMzuOyqJ40Jxx9KVC97Qdxl/d/5+C7MgBoQxXRrLc=;
 b=iCD3HwphK/XzmSrBpsBW5Gr6/5HAxwn7H+NQu3eN5LdJQaQuNEU4/I1+DWdc0uHAbgXRdrjJfSscE8pviDU4L4STbHzeRZ3TlLhOkabSOtu9d5W9V3cFQY9VEZ8deZAJaXzwuKe70XtvLMfcUpfuDl6CCx+xfikWaFJoEjeC9TlGHv3DbzZON0d6DSpfceKLweeNyKrA+BBcpQMQgmgPsOdq4sAv0e7hnEV0Xk21KFBi8ooILdRvG+QOu/eOqapa1Z5v4WxAsrhpFtt6vruUXjmsfiF20fYwzO46lh6OtUKGoFCiTXeQTeYepNY9m2dBEUfCZB3urpbbrvOO6PI05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4DMzuOyqJ40Jxx9KVC97Qdxl/d/5+C7MgBoQxXRrLc=;
 b=mVukr8pmjyeUm9fxjwjKxZ6ZYKSYX/CS/qrUb0Oy/+/KC3dHZncb5gRVYecnzTW4y+fkx7f6wufyx/nTqqJzW+Aj+K6gTSdN+qujNoGNSEbZc4oU1xaxbwh8VPXcx8UxvpHJTr6R9OOn0X/IrKQGg/GWkosSXxS57sewOv4jtPFxBdPEci8ZHvSs25rSXFYwSCpFsH82FqbET3Ff08kwA+SAbLO3hXt0Xzrj9FIXz0zkTDTXWMxrAXWcn3i2ldeJSBUpwr0ScgdKiZ3JopZwhtAOUFxjusK58nq8VFFTpb2qXrmMrkbOACSzV3tYACeCdqeJ9fU549n2JwdKRxo3dg==
Received: from MW4PR04CA0047.namprd04.prod.outlook.com (2603:10b6:303:6a::22)
 by MW6PR12MB8661.namprd12.prod.outlook.com (2603:10b6:303:23f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:37 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::1f) by MW4PR04CA0047.outlook.office365.com
 (2603:10b6:303:6a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:28 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:28 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:26 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 09/10] devlink: Update devlink health documentation
Date:   Tue, 14 Feb 2023 18:38:05 +0200
Message-ID: <1676392686-405892-10-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|MW6PR12MB8661:EE_
X-MS-Office365-Filtering-Correlation-Id: de394666-4eca-4454-f287-08db0ea9ec15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ADNFsp4vC9QFFUTAXFQ62nIRdKbpE4223/4+P69ErWNOhEqqCCLSjO3yqBCfg9kVvIrawPkY9sAzTr559DoXKR+7gHSI7NlRsn7GvUMRAZfxQgX30N3zzKUBipStzYHR9KlLT46IBjXLLINg9qmLTuABnmuQuySynfA1JfXaydN84/jozfrURsuaRz9+sOlwAZtU7qzkuZFZfyXbRhuRum54lsOzA/F2muVpBi1CKh1dV49MjP1+f0sZv2xQgO7TR1P7T1wxMaoDsS7hlvzti4G3EYaBz/fyAoljAgC+BiOiS5ElokrJzqqPHren65ZEhffvbQu4elsRvK1OX79Vpr5lakUB+VdZc3CHS4t1mgu9PFmBaGXOEnDGL0K9v+H5z9SVUf3Vn9ww/Sn4FLLLq7g1fJnyLpIfLlEKsfbssQUIuc5wZsYCIDs6oHL03nZNw00RKFO6cBCVrNThrFXefMktZYGVUV1z68+A1/a8Hd0BRRJVjYH4U6+8HNdXtz0X6g61mWMq7VURZDFU+kkMSByQ6bmAgGbJ5QxOHwizOGc0uoDWsta/FL+ADCR5rejEoFeb5d2+lZjcIUSmlP4+gi7myH/lhaRN9qw1g5ZatxNXea+cax+hDMT7YltqUkLxRYwah+MeN3qufM6I46sNNXhNKJQGDv7eiMt6bb2z1Xe17Bb3IXKUbml9iG0snH91QXWTqKfEtpomU1PurhYaDA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(8936002)(26005)(5660300002)(7696005)(83380400001)(15650500001)(36860700001)(2906002)(6666004)(107886003)(478600001)(41300700001)(316002)(110136005)(40460700003)(40480700001)(36756003)(82740400003)(186003)(7636003)(47076005)(356005)(426003)(2616005)(82310400005)(8676002)(70206006)(70586007)(336012)(86362001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:37.5242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de394666-4eca-4454-f287-08db0ea9ec15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8661
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update devlink-health.rst file:
- Add devlink formatted message (fmsg) API documentation.
- Add auto-dump as a condition to do dump once error reported.
- Expand OOB to clarify this acronym.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 .../networking/devlink/devlink-health.rst     | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-health.rst b/Documentation/networking/devlink/devlink-health.rst
index e37f77734b5b..e0b8cfed610a 100644
--- a/Documentation/networking/devlink/devlink-health.rst
+++ b/Documentation/networking/devlink/devlink-health.rst
@@ -33,7 +33,7 @@ Device driver can provide specific callbacks for each "health reporter", e.g.:
   * Recovery procedures
   * Diagnostics procedures
   * Object dump procedures
-  * OOB initial parameters
+  * Out Of Box initial parameters
 
 Different parts of the driver can register different types of health reporters
 with different handlers.
@@ -46,12 +46,31 @@ Once an error is reported, devlink health will perform the following actions:
   * A log is being send to the kernel trace events buffer
   * Health status and statistics are being updated for the reporter instance
   * Object dump is being taken and saved at the reporter instance (as long as
-    there is no other dump which is already stored)
+    auto-dump is set and there is no other dump which is already stored)
   * Auto recovery attempt is being done. Depends on:
 
     - Auto-recovery configuration
     - Grace period vs. time passed since last recover
 
+Devlink formatted message
+=========================
+
+To handle devlink health diagnose and health dump requests, devlink creates a
+formatted message structure ``devlink_fmsg`` and send it to the driver's callback
+to fill the data in using the devlink fmsg API.
+
+Devlink fmsg is a mechanism to pass descriptors between drivers and devlink, in
+json-like format. The API allows the driver to add nested attributes such as
+object, object pair and value array, in addition to attributes such as name and
+value.
+
+Driver should use this API to fill the fmsg context in a format which will be
+translated by the devlink to the netlink message later. When it needs to send
+the data using SKBs to the netlink layer, it fragments the data between
+different SKBs. In order to do this fragmentation, it uses virtual nests
+attributes, to avoid actual nesting use which cannot be divided between
+different SKBs.
+
 User Interface
 ==============
 
-- 
2.27.0

