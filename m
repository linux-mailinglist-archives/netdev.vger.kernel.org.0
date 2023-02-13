Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7A16946C5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjBMNPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjBMNPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC9E1B318
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCVFTfTAdAgQREGr17zeuONoQfHXVqp7AeazxU0slhH0LbyXYKr4a3tnXQ5G95vElpeVlNlDWoHnp/k0qDRjKSiLwdtfrRnQ5PxchEedBPjGnA9SJK8jLIWTDGSFcZR1OYle8UNmpIjizNpGunS0qyw5StEs96O7x6J5WqB1vZUEh5Q0oBCXFYqyywUH9mKnGlZgtAsutCttE4I7+QPw2wOPpvPpPlFIk8lalKI+BGDaehlWRFlq14+l3bc88TVEH6dimhJ3pJpbhhJzVAiD0WzP6OQMTYg+ZYvqN6FNgO8CatvUHNPS02JiBQHwXVu2VvAsRGu02nnRAZuMV83tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N26FIMxXV+kb+ZBcRaXeFlHHVQstHkX4T2cWjeq6b6U=;
 b=f2eCldHAU8ZYlketJ/bs0JmljQW7gav/IKXtAb6+W+GIZUEubpPn9Bbl5ExauiSgGOUQV3TY8EApUK/LxG4lMa3ErnMl0I0pgTbZR/mRmBcrCdO5BqFEmG+dQ22j6krBILtY/6idw5jMMOEpBU3DZNdvdY044U+2mxi0iqTwND9XBFDkxjjZI/HrKalcfHcfoIDLIZ71jTvOCnz2W/sUwYv1oZ11sJREdVNZRYM5/F2yKVQuWHR851eKOivxQQRSydcaJy2JyGwsBloOaTIEimmMweImj33n0PeNJZfVCtF1yFebiEym8KJ97aO7/opUwZfLuQ9FG8owj0L6BGu6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N26FIMxXV+kb+ZBcRaXeFlHHVQstHkX4T2cWjeq6b6U=;
 b=Rs+jywYPxN6f7VwRshKJv/KH03nR5oEaUsDHA0FkKnqU9o8iqAVokiu6SO3f3UHidXZ8OBQ9UKJnc44nSonFRgCBQc+ASLKbgy9pZ8deMMtdgdf++m05fGyYvaAzNCcTz246hAbZJ73BuZIVj9bIabW3ZtB3NX8olEyEgUfgYvsz0HdKkCB61m+2+HNI4hafOi+eErbo7+E7vkuQfwhI4J/To/GF/ubHaIEhPkHxxBbob62NHXRFt2M5iIsmgV3kryKzZVWc02JLR/rxucnvvqggo3Sn20D8v82SX1HmCHRvxPQ3cKJu1WfzH0ZsTycEJyt5ta/PZzwaPiF2XSsjmg==
Received: from MN2PR10CA0034.namprd10.prod.outlook.com (2603:10b6:208:120::47)
 by PH0PR12MB7094.namprd12.prod.outlook.com (2603:10b6:510:21d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 13:15:19 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::20) by MN2PR10CA0034.outlook.office365.com
 (2603:10b6:208:120::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:15:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:15:07 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:15:06 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 10/10] devlink: Update devlink health documentation
Date:   Mon, 13 Feb 2023 15:14:18 +0200
Message-ID: <1676294058-136786-11-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|PH0PR12MB7094:EE_
X-MS-Office365-Filtering-Correlation-Id: fe0870eb-9ac6-4513-c077-08db0dc45b2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: opdErdQmmI1/Z/0I8c521sKnjdkTmD4tJzc6OXpyesStaiYM3jeUHUjHneqEPn+6Gx+hPvDGqKFn7KgXrAxdvqdlam1YR5M2V8hcsGhX+KJH3wqeGGyQhtYhxCvBEesBPGeTxtOxJIakQJHfuEUXmz7zo4+/CrUh59iz32xMgFe2+0Ko0ZXnNB8goTF07l00EgS5D8TQ/QvHdgfieXFFsonEu/KvtHXy3Djixlogmwbw/Og+4RbDIY1amu3GXiaFLicRauO+olmENpACm4fU+cAhULSsSwFlQWUHoYneV8DR1QZ/53bZB4iAl3g7BDP8NDjuv/idijZBjFzKizVYbHwQIKkcXbMVHZjLRtekYxgRMBh7WCIXLGv26CaM/dA2hIAu0duGCcQu5F/aU2Wt3lmH5FgiOQK7+18Y5Gz+P44R0z3mQKj9KO9B7RCxVZZ6W8Lc5QGNZFZ3hAQUIbqP3zEEzFC0IeIIUuZaHJheqZ+9flBwVPpUZet+8hPMNHPJpVnxD3pYU97by8kW4Q1htGaacPd9a9QVhsWlQ0JJlYHuQVM0ew4HFvLSFZVFtQqShGB5dwSMeoffShIts2cA5vt6Vo2RbkJ8Fa6tkmqU0z1aEKkaCEixWtRdmFhwAlIETxk1/bC4W3m8Ew/Psu7yKoDK1aH9atV8miUwpf8GTNb06moPTEza5TjgbjyP1Z49KCCJqONKZr2rkxsIWG23og==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(36756003)(86362001)(356005)(40460700003)(316002)(4326008)(70206006)(70586007)(8676002)(478600001)(7696005)(110136005)(82310400005)(8936002)(41300700001)(5660300002)(15650500001)(40480700001)(36860700001)(83380400001)(2906002)(7636003)(82740400003)(26005)(186003)(107886003)(6666004)(426003)(47076005)(336012)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:19.5501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0870eb-9ac6-4513-c077-08db0dc45b2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7094
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

