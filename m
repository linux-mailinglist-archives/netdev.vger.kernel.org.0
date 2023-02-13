Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA416946BF
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjBMNPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBMNPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0DA1A941
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWJhTAYuJmeWCgcpuBvQxG+DDwrfjTHJdi6mYBoQ2K+Qq8w9JDhCMr8O8O2If8vQt9u9v75HujSeyzD2TJYimb3Waui1uVjw7+7/di2i25AtjuhGyEwracGydA2lDPOy9I/wswcx6nEt6/TPeX/tV3jOyC21XcFdk36PfJJ1X1TKA3hzwkm94A2NuJ4kuOG++gV1kgzi7/eTPgBtw8oHjDhV0XVeDN0SpCq5BQQSblwAuMGW3hbMSYV9gMz4lh82JiPLskG8M7+csK9K7M0sLzLjk+wP88JeGzRMClpZ1wf9MUGxAEZ7X+mw0v9884Z4MFILVugBHDx7ee9Pi4yncQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZ2piGd4eIh5rJTzURtf6o7S+ggCbYuz/+oGLmMvEZ8=;
 b=Xn9pEo5W2AOOujoCaGOJ4AU6s8YZ84vNjHjDONLO3oxuCByq1eF/1a0EKSlWeIP0CVdEWX0IaNuQQ/RoZo5VJVO0m2TvQK8nIDHZQqaK9oBgYBYOuagPHMkFl/5JXnZs+HZ9Ra5z0lCi/zcJ48yBnMxXysr34CMRuIzjYNZeG5RzNmsZCpcZwbcwBVcvr+UoyaPBKswIl/Jp8vOzGdzBiJSqijnDhKXFNozURC8a2iyc1TvzjTMm8fjiGJf+YQKPM1yTxcICleVFUCfT4HJocKWdl9gcyC+2LvBD8hBNVZM943+4r3seq/jmB+gtIEcnda+mR2uHEEkdoND4zBlGag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZ2piGd4eIh5rJTzURtf6o7S+ggCbYuz/+oGLmMvEZ8=;
 b=Pp/DmMqTmxfpCohMpus6/YYuQCFGnL0rAqE8PK+dqLI74GSRzOvuUs51m56fsjDYaUvhWte+eowHAp9w+vU5W5bECalIg7mzNp3J6n98LZORKpjW5SjN6hZOaHV/qFBntlsy+Z5HK2KZDe7AwF7HeH7SetMuroqbCnVWWAj/TiabVkSnBJNZQd0MmIddSjAsOoEENYrqA16Nv7CnBW+4S3677q7d9WUAj7rDsHodqG7dcBr4Dn26ISsjT0diEE3s+E8AGcX45brjM6WOugg/La0Zd9kEm9w1MFs1tE3aBZKbaFVTNjDGGRAOiP8mPgith2Y68R9LIHjcxpNj1taKjw==
Received: from MN2PR10CA0032.namprd10.prod.outlook.com (2603:10b6:208:120::45)
 by CH2PR12MB4151.namprd12.prod.outlook.com (2603:10b6:610:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 13:15:07 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::3c) by MN2PR10CA0032.outlook.office365.com
 (2603:10b6:208:120::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:52 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:52 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:51 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 02/10] devlink: health: Fix nla_nest_end in error flow
Date:   Mon, 13 Feb 2023 15:14:10 +0200
Message-ID: <1676294058-136786-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|CH2PR12MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: ee85dab3-273f-4b8a-6427-08db0dc4537c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIYkEyfGQQ/ayCUpnt4q6LzSK4GbMkaGpf5ltSLgZkOGPVI6fByJaj9Rpcl2+KiC4/wSQlqOhP4zIcxjxgA6iT1p0qYN2e10JXG0bozWxH2D+4EAB0DcFES4JMqPkjKeUGVC7LyhFNMDXcxAW45ZzfV11f0BX5i/zVKd10l9pb3E822wPHEOEw+hBggoI2xE0v2+GhncZ6UKoeHXBkD9AKtsfRG//erju6emeDcTXpYvbQGnXy3HauYz1QkJs63p72QVhv6uWixkRQH7AOpzRHg3gnEANBSq+pYuDOwh5UnQtknhBrzVL5EDtAeUVwCtTqBB/r4iV6WcUxZ7P1dAIsZt0O53easPoyAn2X5/JSFneQTfh3Xzs/6hdpOzUYlvs2Hn8KV6Wz6Fwn7pHCKBi/vSavRG5SQlbNewb/kt8HPAUclazu91WfDirFInkxfWJH91QZ4K7SImgD24InOiA89b+yNZayRm7zZFZhV4KwCg41zS58C/vNlpl6wdWb3WQS2usKk665gd3eIoMEmq+Ofn8pFVpjyhPXBfaZrZb7gK8x9Rx4dVRy3eOva6xT5gePYVL6+xg5giqxyVwh1ebyyP6blB8iJY1OUL9PMQzWGwhUUEduE/SMWiPMNoyBPDA2ebTKTW8LHQzPW/Cwh0slxK1exFoRmrt1JR0aI6TXWYXSBEbNeQ6m9kzqMTfSnPHscQb25iboOC5XOhOAZEaQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(5660300002)(4744005)(2906002)(36756003)(26005)(426003)(83380400001)(47076005)(186003)(356005)(336012)(2616005)(40480700001)(36860700001)(82740400003)(7636003)(70586007)(4326008)(70206006)(8676002)(316002)(41300700001)(107886003)(6666004)(478600001)(110136005)(86362001)(40460700003)(7696005)(8936002)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:06.6437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee85dab3-273f-4b8a-6427-08db0dc4537c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4151
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
it to call nla_nest_cancel() instead.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/leftover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index cfd1b90a0fc1..90f95f06de28 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6028,7 +6028,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return 0;
 
 reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
+	nla_nest_cancel(msg, reporter_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.27.0

