Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830766946C3
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBMNPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjBMNP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3191ADD9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAaNPEvviIc5/rBuY+Jrwkd1Q3sTlJMHkbbAhNtKWhhCmdZbXoQES/FeOHMsjSk2XfdkCtsmvpV/vEYIxtMO4xzOuOd6X6Rh1KGiA+2JhWoaP2Fnb37jktX2+uvZLPcWRl9/zfFZMOCi+Rdpn7OoDlksqn+eHeUy5aZBxjsgG45loOML0y+OfbXWG8koqOSvNJ8M+ZETnHrsQrwWXodWj1nqp+ggSxAfZe7gQjbzkKiowiGGekrkRAyB3pFJrwTsJM41RuE8nKPUQwI1hkrgL+omv8akWA0Clw4cjkjF4RoLADr40Z6Jv2q321vBGdgLPYgL2Fw/dv/LVWTyt01XrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hxtZMQ0aTjKZ4KPDYgGXLOJs1UCh6hD1uKLs6VP22M=;
 b=AUc3O7HpepL3utyHb/OalkOtVzQ5QErnTUaXZ0/4BgWecRhdF9AFaLyOYiDU3QmHvoa8RClwbqIlj7SYNgdmcHLriNV0K+JWBSdOkwtwU/hjSR61GymAV0L5qWJkvd5cFdZfYMUWlIp8wTb7GKG6HMbcR9Gj+kIeFgOSoXduELvtWNmZd9fH0Ud46m7mHGzCJCx7dY76EIKIqYTiFnrZmTAthUdFMd6Eq0Umb5xFWKwx5PLee0HKYr9SfVsS9DmJMixqSWyjFg3vXQGiFOhelBBjL2YDxY85zroAxEXOEnFqFC/YRpj94CJSw8W1+cWWu2NRFlmMbgo7xv+szzVx+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hxtZMQ0aTjKZ4KPDYgGXLOJs1UCh6hD1uKLs6VP22M=;
 b=Yr0DnGCqFd+Fw9gy3ZjGvnYbknKqYFkPQ/W7zWcFecn5ZtzWkoGeTgw8ZzijnO0R10Keb0+2f3uTaiiD1x6ZJKTVzdrpaQbI5FlcrMTNtShKpynvsVfL52VtI26eb+8XnCR1MF0Xps9oincxV12SNI2amMlNrGoiA2Aftt2jsGUbjFRNY5DmSYOQh5qxn99Jvz7Ntujx01X8fVF7h3S4YWuotgL7B3hs93eQFccaA0Ge0mHsXBWwRbBJNv9Cg08i4YPll5GZMbCXirxUaxa1iuSuDHc0dWVZwrAOTY+0RiTS1DcWVMB7yoHwChyZM1fFYPTu6swvmQ/6a9XN8aO3CQ==
Received: from MN2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:208:120::42)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Mon, 13 Feb
 2023 13:15:15 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::99) by MN2PR10CA0029.outlook.office365.com
 (2603:10b6:208:120::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:15:04 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:15:04 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:15:02 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 08/10] devlink: Move devlink health test to health file
Date:   Mon, 13 Feb 2023 15:14:16 +0200
Message-ID: <1676294058-136786-9-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: c5a84f32-483c-4e45-f31b-08db0dc45858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkdOhwSDswmZRaLa8+SfG9vceFb3QOj4K3bzorOEzF1v0WDj7b9XhtCcKuueL/gNwcPR+A/zPuMYSQi0atp0vIIAmZfJ5yipgJxqWyzWjX1oXgBLUf36I++ri450Ik2/kwuJQ+jVaTps2n45spwMBIfkvrg/gHiBs35WOXbqabbfk7GBgfBgujYj46pvHi/WlynJ8sG9at4FUdlOBxnZYSETCdO9qx72zYAuZKJ/qSQm1Wl7FOaq183CLuyWGxvxQW2FryzqSxOtr3xU1s3HtYGnhV1GakSk7yMv4sx6+8u7UK6LBwgQTcgXmzDToTt2UIbIUpcdyzJeixNHK2hMSZjqHCoNgaAveFnBCqpEP59GWiz+25XXNqVx8qpbZQ5TGVSdm/dxs+2yh2rXwVVuBS0EDsxcXKvXM4SAICUAOkdi8W+oUoD/tM9hB+gQrJtphkd/yHWee7KhNH6txKmQersucOr1fiRTN8XT6wAeGCyOvbnkx1o4yrEre0bLszES7SsEq6vz30NHM8s8qwfqH5yBeOjua4MwJcYAJ5Izi32ngxA8Yz8VLUE/BdOBVBsgDwiLYZut609Q3lyCbj2pFQILHS4dwX6iCAn3aKChZsanLeWDw+a9SD2JU5AxuSFTTIUvh1pdSvh1vfbU52PK4XowhRGPvzwBn8U0DjHQD8O/74iWl6GwLgQKZBYSAZBY+SAHbdun4j4saH5Bf9U61A==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(6666004)(41300700001)(107886003)(70206006)(70586007)(8676002)(4326008)(426003)(356005)(47076005)(82310400005)(336012)(36860700001)(83380400001)(86362001)(82740400003)(40480700001)(7636003)(36756003)(2616005)(7696005)(40460700003)(5660300002)(186003)(8936002)(2906002)(478600001)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:14.8001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a84f32-483c-4e45-f31b-08db0dc45858
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report test callback from leftover.c to health.c. No
functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h |  2 ++
 net/devlink/health.c        | 16 ++++++++++++++++
 net/devlink/leftover.c      | 16 ----------------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index ae7229742d66..211f7ea38d6a 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -282,3 +282,5 @@ int devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 						   struct netlink_callback *cb);
 int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
 						   struct genl_info *info);
+int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
+					     struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 0080eb442a4e..3ebd531dee8a 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -1296,3 +1296,19 @@ int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
 	mutex_unlock(&reporter->dump_lock);
 	return 0;
 }
+
+int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
+					     struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->test)
+		return -EOPNOTSUPP;
+
+	return reporter->ops->test(reporter, info->extack);
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 55be664d14ad..dffca2f9bfa7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5372,22 +5372,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
-						    struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->test)
-		return -EOPNOTSUPP;
-
-	return reporter->ops->test(reporter, info->extack);
-}
-
 struct devlink_stats {
 	u64_stats_t rx_bytes;
 	u64_stats_t rx_packets;
-- 
2.27.0

