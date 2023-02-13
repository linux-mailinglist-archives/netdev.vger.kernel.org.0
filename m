Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D176946C0
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjBMNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBMNPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E2A1A670
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6wbAeR6KIdKhraRyAbQD6Lnu3rxnC/s9z43O2U7TeMnY/vYoejNYvlARJXmA92vRAiWW/n1oADGAoX5dz2Q6wJjjCRWm7sd1TeXnDq2QDj4EuQxZuwFhHEElKmI2PDgi9hOPPOUjLMtkIyJvrATlYh3ggfnLoCFF9GL33/gkxvLAmBhd041Ll0KSpucmh6Bpk0PQVBQoF0ea0o2eEWF0B6mRpdHk6BzgRWmn49Kiek8Ip7lqBhMDFYB6Xebl9KgWo/9LXPzMuHC4KVr8vao8LOrb6O/9N92bOY5U1SRddI8SVvgQQ/dQfUj9JErRvgOlwjucVgtBGCfzzDqQWfD2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qkEDRJqUIm3O8QVvNsIAitVHhpZNo14PUOnnSFG9zI=;
 b=ilO3uHPiKSRdH2Rwso2u1du9ZDiTcjEnO43fod7gyuIRoZgPUk+zzkrYFZNkSnYgq4Cl1Nss20J54qUXVhMc37EiLiUBYahjEypi0epZsUDVdNvjhAngIOrxQSk6UajsYv/Oz99AHANGCnrtSfjt0YDkriR0fvuU08RMlBbo2vW4DoI5nBrPox0N6Mmsgn76HEidb9lJyLSNn0bziHnMBpGLVB8UwFb8pwB+Hpe0F/mcOoTF+Fft54SrhDUWkmVJoijVlfyIZRle8S9+sAgGpgOEmB6afSRprqB9+xjv+K5o2DE+N2s81S2Gm9+AvRdy7YbymXbdIAQxgqrF/HZxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qkEDRJqUIm3O8QVvNsIAitVHhpZNo14PUOnnSFG9zI=;
 b=lMo4mrLBQrGeiuaKt8NFf5X5TdO01RWuxCov07kAmmtZ2iarROuIVOtY/1AlxXHGjd7UCkNumzVPxxNoqCVB7jfebFiZvRtWUGHbu5P9vWvcxUIbj97yfA6+fa/7MTXqbbcMfME7eUHwtJeHs8ipH2LiRZSBonBML0z99mPgEdjaEn6X4jBfGFGylS+NUCn9qZgnZC0uFCwqRz46QGx+p6uMHXMvrdTQYDtd6wwvacXhcSVnHXcbZKswI21OG2tn+rvG9ZvWZdJKkdXQYvFpW4b/dpIerkP4j75/sHvxKunL0JsdNdLLMi1Rp6Y6vBlkrjU6vKJ4UCLY77V6sFF4QQ==
Received: from MN2PR10CA0019.namprd10.prod.outlook.com (2603:10b6:208:120::32)
 by LV2PR12MB5749.namprd12.prod.outlook.com (2603:10b6:408:17f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 13:15:08 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::37) by MN2PR10CA0019.outlook.office365.com
 (2603:10b6:208:120::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:58 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:58 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:56 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 05/10] devlink: Move devlink health report and recover to health file
Date:   Mon, 13 Feb 2023 15:14:13 +0200
Message-ID: <1676294058-136786-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|LV2PR12MB5749:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d2e2ea-d4b3-4a13-6ca6-08db0dc454a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xi/a51edOaXlr3LPxpzprxUPrXIDiHjKGZW3to5PSgYM+Izt5TSAPpUoVJ1XbUKx0B6tYlIlBa5gf6R3iyvOHWvloPESj5zFBefs8bUzIcau44depdqh0AeDkGlBV9QAsgpwtupawyUSCbpg7xeVKEQjc5TtlKpVIoyy9Pbtyn6QOnIiu69/bpDmbLm3rBIvE9RZhW8hDKwlacPgpALIdIgfIoxAWVMAu98NwjNnxNuGrlRvz3YYyB8aIL3wS1d9I9rWDyyXvgLr+MhgaNG+uwgZHsyRHC7JmI7x8NqqcOB40UiU4Hf97bkF+zFu1FPjlucKYAl8Kuvc1OP54j3twG24REN6RuvGe8AymbjqWMeruTJYuCP6nQwiUyh94dM/1cdoAsM3yj5ISsYuydykGVrmmei0X5Ao2YFdei7F8WAiv9X49JiX4w3ZoamRRc0eh026SZVZRdfEhInJLDOCsfw1AKm896LoURl6uy0dVsmWLJY8qy3JOT29sMzFkiJtbUaAS751zg/Fm/coH6RTGU1KchUiCU6xMU2Hj6sqzgFKioKRF521DrNsTgwoky6Ih/yaMb/GHf0eAPD4AumDNaEGfk9haQD62tFwkjEoby20dO+gWSOOtuEvB8zEwgmIJxLcvwmFQgGeZ9BsSYf1Cx+e0FTEMnCGay2UZ+dYoF/8+o3wPdepWrXCWt69LJC5RG9j0k6xVxS8Gh5QQuEahA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(36756003)(41300700001)(40460700003)(110136005)(356005)(316002)(4326008)(8676002)(70586007)(70206006)(36860700001)(40480700001)(86362001)(82310400005)(82740400003)(7636003)(7696005)(107886003)(6666004)(186003)(26005)(2906002)(5660300002)(8936002)(30864003)(2616005)(426003)(336012)(478600001)(47076005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:08.6125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d2e2ea-d4b3-4a13-6ca6-08db0dc454a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5749
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report helper and recover callback and related code
from leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h |   5 ++
 net/devlink/health.c        | 136 ++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 141 +-----------------------------------
 3 files changed, 144 insertions(+), 138 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 085f80b5feb8..d1a901cb5900 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -237,6 +237,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
 				enum devlink_command cmd, u32 portid,
 				u32 seq, int flags);
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack);
 
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
@@ -267,3 +270,5 @@ int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 					    struct genl_info *info);
 int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					    struct genl_info *info);
+int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
+						struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 1ecfd01b7b2f..962727bb5b6c 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/genetlink.h>
+#include <trace/events/devlink.h>
 #include "devl_internal.h"
 
 void *
@@ -408,3 +409,138 @@ int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 
 	return 0;
 }
+
+static void devlink_recover_notify(struct devlink_health_reporter *reporter,
+				   enum devlink_command cmd)
+{
+	struct devlink *devlink = reporter->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
+				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+void
+devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
+{
+	reporter->recovery_count++;
+	reporter->last_recovery_ts = jiffies;
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
+
+static int
+devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
+				void *priv_ctx, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
+		return 0;
+
+	if (!reporter->ops->recover)
+		return -EOPNOTSUPP;
+
+	err = reporter->ops->recover(reporter, priv_ctx, extack);
+	if (err)
+		return err;
+
+	devlink_health_reporter_recovery_done(reporter);
+	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	return 0;
+}
+
+int devlink_health_report(struct devlink_health_reporter *reporter,
+			  const char *msg, void *priv_ctx)
+{
+	enum devlink_health_reporter_state prev_health_state;
+	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
+	int ret;
+
+	/* write a log message of the current error */
+	if (!WARN_ON(!msg))
+		trace_devlink_health_report(devlink, reporter->ops->name, msg);
+	reporter->error_count++;
+	prev_health_state = reporter->health_state;
+	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
+	if (reporter->auto_recover &&
+	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
+		trace_devlink_health_recover_aborted(devlink,
+						     reporter->ops->name,
+						     reporter->health_state,
+						     jiffies -
+						     reporter->last_recovery_ts);
+		return -ECANCELED;
+	}
+
+	if (reporter->auto_dump) {
+		mutex_lock(&reporter->dump_lock);
+		/* store current dump of current error, for later analysis */
+		devlink_health_do_dump(reporter, priv_ctx, NULL);
+		mutex_unlock(&reporter->dump_lock);
+	}
+
+	if (!reporter->auto_recover)
+		return 0;
+
+	devl_lock(devlink);
+	ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
+	devl_unlock(devlink);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devlink_health_report);
+
+void
+devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
+				     enum devlink_health_reporter_state state)
+{
+	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
+		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
+		return;
+
+	if (reporter->health_state == state)
+		return;
+
+	reporter->health_state = state;
+	trace_devlink_health_reporter_state_update(reporter->devlink,
+						   reporter->ops->name, state);
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
+
+int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
+						struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	return devlink_health_reporter_recover(reporter, NULL, info->extack);
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index bc72d80141cf..03184dd3d271 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5963,61 +5963,6 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	return err;
 }
 
-static void devlink_recover_notify(struct devlink_health_reporter *reporter,
-				   enum devlink_command cmd)
-{
-	struct devlink *devlink = reporter->devlink;
-	struct sk_buff *msg;
-	int err;
-
-	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	err = devlink_nl_health_reporter_fill(msg, reporter, cmd, 0, 0, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return;
-	}
-
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg,
-				0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-}
-
-void
-devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
-{
-	reporter->recovery_count++;
-	reporter->last_recovery_ts = jiffies;
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
-
-static int
-devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
-				void *priv_ctx, struct netlink_ext_ack *extack)
-{
-	int err;
-
-	if (reporter->health_state == DEVLINK_HEALTH_REPORTER_STATE_HEALTHY)
-		return 0;
-
-	if (!reporter->ops->recover)
-		return -EOPNOTSUPP;
-
-	err = reporter->ops->recover(reporter, priv_ctx, extack);
-	if (err)
-		return err;
-
-	devlink_health_reporter_recovery_done(reporter);
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-
-	return 0;
-}
-
 static void
 devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 {
@@ -6027,9 +5972,9 @@ devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 	reporter->dump_fmsg = NULL;
 }
 
-static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-				  void *priv_ctx,
-				  struct netlink_ext_ack *extack)
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -6068,55 +6013,6 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 	return err;
 }
 
-int devlink_health_report(struct devlink_health_reporter *reporter,
-			  const char *msg, void *priv_ctx)
-{
-	enum devlink_health_reporter_state prev_health_state;
-	struct devlink *devlink = reporter->devlink;
-	unsigned long recover_ts_threshold;
-	int ret;
-
-	/* write a log message of the current error */
-	if (!WARN_ON(!msg))
-		trace_devlink_health_report(devlink, reporter->ops->name, msg);
-	reporter->error_count++;
-	prev_health_state = reporter->health_state;
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-
-	/* abort if the previous error wasn't recovered */
-	recover_ts_threshold = reporter->last_recovery_ts +
-			       msecs_to_jiffies(reporter->graceful_period);
-	if (reporter->auto_recover &&
-	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     (reporter->last_recovery_ts && reporter->recovery_count &&
-	      time_is_after_jiffies(recover_ts_threshold)))) {
-		trace_devlink_health_recover_aborted(devlink,
-						     reporter->ops->name,
-						     reporter->health_state,
-						     jiffies -
-						     reporter->last_recovery_ts);
-		return -ECANCELED;
-	}
-
-	if (reporter->auto_dump) {
-		mutex_lock(&reporter->dump_lock);
-		/* store current dump of current error, for later analysis */
-		devlink_health_do_dump(reporter, priv_ctx, NULL);
-		mutex_unlock(&reporter->dump_lock);
-	}
-
-	if (!reporter->auto_recover)
-		return 0;
-
-	devl_lock(devlink);
-	ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
-	devl_unlock(devlink);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devlink_health_report);
-
 static struct devlink_health_reporter *
 devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 {
@@ -6135,37 +6031,6 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	return reporter;
 }
 
-void
-devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
-				     enum devlink_health_reporter_state state)
-{
-	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
-		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
-		return;
-
-	if (reporter->health_state == state)
-		return;
-
-	reporter->health_state = state;
-	trace_devlink_health_reporter_state_update(reporter->devlink,
-						   reporter->ops->name, state);
-	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
-
-static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
-						       struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	return devlink_health_reporter_recover(reporter, NULL, info->extack);
-}
-
 static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 							struct genl_info *info)
 {
-- 
2.27.0

