Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24EC6969E3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjBNQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBNQi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:56 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6292CFFC
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKsvlFABod89kJbANo8yK0e95941P9RxOFxHzCciJmY1VrHYQ6bLA5r/FTuG6FGifqYVykeIpxHZxGJ2A/t2tmkr02A00MPWgh2kM/yXD/WU03r1z6IG3wqk2IIxy2nj73hAJ/jP1sJiP9SdVz7J0zt8LnN9aH+4ecTX+20ekajw7ZVbgZOevDnP4hJmWd6XFRpPjwJVDoK0Ptgs+MI4AzZM/khMl/JUsd442nNudNNvTIc6pjiE/VGjw63zw9efLFBMI1Cv7Ki9YyqPMrxy5FdX0d/rJHVU/v0weAHfh1L6OrHRWgv8QKHw5DZNUFLOeOL7eVjwRnQhm2rZsJQApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faaKfuGlo705/P1MWmuzMdgfsj+Z7w/c2S6LRusYISo=;
 b=ACJwC2tc15ES1aEnmlztQ0DOhKKX64YriPoIMS/JpBp9sMtpuLOLmaGkIaCpoqdH/YGvA6oITQckCNlk2x/RJ3BhNzWLAndYwXJm05AxiZmWRswqj2Iwbd6MV39hmrydzVOJvNC/KlI0l57q6Ci0sLnsO+/xSnPi1UJnzo7LoYfwiN2DJmGsBVUtO5WvXkdX7AnML48b9pheo5wOuwFnZw/1DJJ6ULii7JVqA6ouYiFM55UP6/1JaIqwU5WeGxh1ZU/rmKDCCOemkO4yD8z1kEjc+GUAb/DVsr4yTQT/ggaJEYUGd9fFsSzt03KXr4qSWvzC9TaokmSwZnVUkndgQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faaKfuGlo705/P1MWmuzMdgfsj+Z7w/c2S6LRusYISo=;
 b=FUgh24hGT2rTrCVujBroEsVkHnrDdqeAHUUjLRNZbCTwgqBdLv/bpPi05Le5o/VW3HIljTyJ+iASHWO+edoMkDwyVna8RytnKAjlKbozecHtKrCXcvKao1fSLS0zD3jcv7CoQiDBArHdn2ugOpGQBMfzO6QjwqQHE4uHvTwUtu/QR91BaoXgp5SmOqU7JD8BLy0dmyGloBcfZbQnXpg4tJlhGb3u0S/kMx0vyTrdPCmSFvxrztcaz2yQubll14tGt0b9WzOhxDh6V+Phw4foIFCn+UCc9QOTMs/JkxWXUXn8XFuHBBiJOeO0gt09t4jS8MwbKUFiM0w6LmakeDA1DA==
Received: from MW4PR04CA0049.namprd04.prod.outlook.com (2603:10b6:303:6a::24)
 by CH0PR12MB5188.namprd12.prod.outlook.com (2603:10b6:610:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Tue, 14 Feb
 2023 16:38:35 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::44) by MW4PR04CA0049.outlook.office365.com
 (2603:10b6:303:6a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:24 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:24 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:23 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 07/10] devlink: Move devlink health test to health file
Date:   Tue, 14 Feb 2023 18:38:03 +0200
Message-ID: <1676392686-405892-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|CH0PR12MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: 66aae830-e1ef-4f97-3568-08db0ea9ea6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRmiNnzJaT1IOenevUICRAcIerG/pxN8tM6BlYW7fl0UbE1WqM2HOI4e4IvUDyygbhbyTKrCWvPrUy5VP+A/nflMLFNcMTi2h15Z+xZTbq229q1XfyIHMC5sh+YpU0enLMnKVCEBJuMxzKH96DOQvyxpXMA83WuEh+SV8suhE9qSsyYwB5p7iFRsJysOL7NkQPHyVnh0uPO96ZoA32YiFmCbjg6QMkDDbJvFnamgswf5qJ7DyGy8QYwQ8T5S1Icy4vZz1IIex+S0OZxiCu03G3yz8VmfE1qUL89kjKshI5iA59Bo+nr/nPHsL4J9HKf8OZI70jq9rkzU97Oicm/83g88HHS5CqRpW0vFNDCzyDVci88vkzE3JNli0bsq1AEF44xV/d6ABnDUc4pz4ygS6xgE+ygwgWBMVsr/nNmPKlbszSzDpmzUaWO66L9Fw5T4zpF6W5GyL19G69tTxPK90JTE6VYSBrC2Y+02YnyAl9Tk94H+7mMOKRCF1MelccgZNT2k6dQeKxqTGYPBfBn11nBNPyAko1SfqcojkylykLFNfrALEvYG9s6lq3kDFPekLzEmTkkpl5IrDsX9d15+lPWEyev3/ZC7D4mzrMlaSqAfYX42xirNZUizPCC0X3AiJHJnCEHFPooE/6dyuQDr/oPN8z5Oth1iorh1ow0akU4MY+c8QnBxan2tp6vWetA6MAGRE5VDme4QvVBwpHOZOQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(186003)(83380400001)(110136005)(336012)(426003)(5660300002)(478600001)(7636003)(316002)(7696005)(8676002)(4326008)(36756003)(107886003)(2616005)(6666004)(26005)(40460700003)(82310400005)(36860700001)(2906002)(86362001)(8936002)(356005)(47076005)(82740400003)(70586007)(70206006)(41300700001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:34.7276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66aae830-e1ef-4f97-3568-08db0ea9ea6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report test callback from leftover.c to health.c. No
functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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
index 6991b9405f4f..38ad890bb947 100644
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

