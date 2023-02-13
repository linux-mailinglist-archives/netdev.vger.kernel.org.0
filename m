Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFD6946C2
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjBMNP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjBMNP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9531ADFC
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcKvANSlqTZLP5pyyNFM8hb/gq8ROFQ6uRgLPsKTGNCrZVn9xPBPRR5b5sUV/848PG/Fp/m92I5pFs/Nor1WF5ehQGaBL/+UBHdnXP90Eo8GMDoET1jHwTXAopRrb/rFUciAtkvxPMfQx2fHsCseEecvIv/nf/u3h8RmCbO5+55QNcRnIB2jKYA2p8Be5O5fHaVrhUc8vdHPxCYGeZMNm6MR/qfHd//8Dxz4VDOkXF+g5DeHeMBXCWA6hwVxfD56EHEPd7FMZH/h4dt76bl89aRRaGn17Ttr47bKcYymQLVx+QE/7WljVPPNl6kdsDnBBAClf4sWeUOFEnChyJJmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MLgYPjO+5LK8MJXGgJjVQFhKsK6wzqwrA/fvz9mo4AY=;
 b=WWhKt6Q2azCmeHJ3QHFmPw8V3Fpudr2fkfkA7CggbeELOHsckcmPaQWJ2ORbpYWM/GKZ4etawjfAS0sxS+aB2tK/MzTt5PXc2P0BYx1uxokBfiwVhCG9BrEoZe1IgcvYXDMxAM/W6NzDSxKpJIVoIHZzEAmt1Pe1vrOUtJUdNOWxCNK1Ol35JfHcf7gVGEZg791ODKPr6Un0hZc6nsAosvxJhVJMkGIH6qWtxvaleV26rS2dbcL/R+LydxXKXBbBzDvcP66m/OZz2PJ3A4GnfwKX+HLsVeLkWLsWfCz+znlz4W95dCnahHHmpldwVHb/fVBebYvbcanjKZJRiou07A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLgYPjO+5LK8MJXGgJjVQFhKsK6wzqwrA/fvz9mo4AY=;
 b=uF28wFMp9xjoBIqHOjNiV80M0OtcYHBD1zFLazbz4LB91r6sb748pxL9jnR7qaTDV8QVRUcpMXjjhf8MEivLhy5sytJhPCxd3eRKG1+p+rRu1l8RBuPJ3MUK5U5s0qgdHdqTwPt2LN4KJwOWENEeJmUhR0sozq/c6WWJX7l9YP7CG167MES7V+2pupl9ecpWZnqJ5dBAPVwBXMStWJchjeWEGGwrOPFxMygzpamMlo5VZ9sOrrfLPPZjMuDqYj0B+VMxFvLgs/tOubcv/D/lr8pepiz1Sfk/EANcCCow/cdzjJ+EULyQ3xs/iz0yUOB9P9IOPCyFfHqaN6EgHs3rCA==
Received: from MN2PR11CA0010.namprd11.prod.outlook.com (2603:10b6:208:23b::15)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Mon, 13 Feb
 2023 13:15:11 +0000
Received: from BL02EPF00010206.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::e9) by MN2PR11CA0010.outlook.office365.com
 (2603:10b6:208:23b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010206.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:15:02 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:15:02 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:15:00 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 07/10] devlink: Move devlink health dump to health file
Date:   Mon, 13 Feb 2023 15:14:15 +0200
Message-ID: <1676294058-136786-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010206:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: dab4c480-6a42-4e89-39b2-08db0dc45602
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfbUjFP8ieIHm4aKWm0tOEBd2S5KeDprnfB5O5vi/RrW8YpIO+HI1mJwWv5yM5YW5yPn7qTLbvaxFHk23A47Xk6PeUyCkXCsROr+RH18SNVQF9WRdG6olzSY+PFj9tfRXEwhiXGmxjS1yUIIrXL3QxOx+bohnjZ/u4xVWiJOxgrzWaLN+uHwBgocdPBTiPIbX7K4+dPeVqMFOc+j0LHmhirylTMDs4b3GjELu58kbFD7l9MgxOx1bx9cj0cPzWFeiq+xg4kq8FfrsiG1aalthAlZJ+AiYEPPsCMWwH0gRHNgS8QkY0jG6XRUSFCNZqLHCAF4o1xcsSgTGZlhJNHvDdY9B+PMmRMf0C6ka9jF4/u04r6eUp52tweAntIt+QeEyhOW1Q2yzTRrhiifb4MQhRV3ijJjoVpPC0cEc7J9B+foS5BHf3B0/dQdImA08iB2XrkUGHSJvXZQZTv72pTra+4WabR97Kr0RxLLkAlD+G81+irBj+nVWPeIT7tYlMhxKdpIiZHmaF42KSVcgfR16/cTyROPeZtbFWH9/4EkzrPeo74/VD3lceeoDICodnPs+XeCpxl0ZP0gAbc3Uq9frEyip9ivimwFCKvy+XciEyPZQ5hTi9G6LZ/pj5nf7lgJ305g24xPdKh9sGtMX7i/KX23pzRCJyBJ2ujf7gryQEdwAuogfnxrzPmW7Xs20+9CIn3LycWZy8Nf3a6lKdZd1w==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(82310400005)(8676002)(8936002)(70586007)(70206006)(186003)(4326008)(36756003)(86362001)(26005)(7636003)(82740400003)(356005)(2616005)(2906002)(47076005)(40460700003)(107886003)(426003)(336012)(478600001)(7696005)(41300700001)(6666004)(5660300002)(40480700001)(36860700001)(110136005)(316002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:10.8763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab4c480-6a42-4e89-39b2-08db0dc45602
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health report dump callbacks and related code from
leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h |   4 ++
 net/devlink/health.c        | 122 +++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 123 ------------------------------------
 3 files changed, 126 insertions(+), 123 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index a4b96f8a0ab4..ae7229742d66 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -278,3 +278,7 @@ int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						struct genl_info *info);
 int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 						 struct genl_info *info);
+int devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
+						   struct netlink_callback *cb);
+int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
+						   struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 5542e358be2d..0080eb442a4e 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/genetlink.h>
+#include <net/sock.h>
 #include <trace/events/devlink.h>
 #include "devl_internal.h"
 
@@ -507,6 +508,56 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 	return 0;
 }
 
+static void
+devlink_health_dump_clear(struct devlink_health_reporter *reporter)
+{
+	if (!reporter->dump_fmsg)
+		return;
+	devlink_fmsg_free(reporter->dump_fmsg);
+	reporter->dump_fmsg = NULL;
+}
+
+int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+			   void *priv_ctx,
+			   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!reporter->ops->dump)
+		return 0;
+
+	if (reporter->dump_fmsg)
+		return 0;
+
+	reporter->dump_fmsg = devlink_fmsg_alloc();
+	if (!reporter->dump_fmsg) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	err = devlink_fmsg_obj_nest_start(reporter->dump_fmsg);
+	if (err)
+		goto dump_err;
+
+	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
+				  priv_ctx, extack);
+	if (err)
+		goto dump_err;
+
+	err = devlink_fmsg_obj_nest_end(reporter->dump_fmsg);
+	if (err)
+		goto dump_err;
+
+	reporter->dump_ts = jiffies;
+	reporter->dump_real_ts = ktime_get_real_ns();
+
+	return 0;
+
+dump_err:
+	devlink_health_dump_clear(reporter);
+	return err;
+}
+
 int devlink_health_report(struct devlink_health_reporter *reporter,
 			  const char *msg, void *priv_ctx)
 {
@@ -1174,3 +1225,74 @@ int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 	devlink_fmsg_free(fmsg);
 	return err;
 }
+
+static struct devlink_health_reporter *
+devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
+{
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct devlink_health_reporter *reporter;
+	struct nlattr **attrs = info->attrs;
+	struct devlink *devlink;
+
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
+	if (IS_ERR(devlink))
+		return NULL;
+	devl_unlock(devlink);
+
+	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
+	devlink_put(devlink);
+	return reporter;
+}
+
+int devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
+						   struct netlink_callback *cb)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	struct devlink_health_reporter *reporter;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_cb(cb);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&reporter->dump_lock);
+	if (!state->idx) {
+		err = devlink_health_do_dump(reporter, NULL, cb->extack);
+		if (err)
+			goto unlock;
+		state->dump_ts = reporter->dump_ts;
+	}
+	if (!reporter->dump_fmsg || state->dump_ts != reporter->dump_ts) {
+		NL_SET_ERR_MSG(cb->extack, "Dump trampled, please retry");
+		err = -EAGAIN;
+		goto unlock;
+	}
+
+	err = devlink_fmsg_dumpit(reporter->dump_fmsg, skb, cb,
+				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
+unlock:
+	mutex_unlock(&reporter->dump_lock);
+	return err;
+}
+
+int devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
+						   struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->dump)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&reporter->dump_lock);
+	devlink_health_dump_clear(reporter);
+	mutex_unlock(&reporter->dump_lock);
+	return 0;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index e460bcf1d247..55be664d14ad 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5372,129 +5372,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-static void
-devlink_health_dump_clear(struct devlink_health_reporter *reporter)
-{
-	if (!reporter->dump_fmsg)
-		return;
-	devlink_fmsg_free(reporter->dump_fmsg);
-	reporter->dump_fmsg = NULL;
-}
-
-int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-			   void *priv_ctx,
-			   struct netlink_ext_ack *extack)
-{
-	int err;
-
-	if (!reporter->ops->dump)
-		return 0;
-
-	if (reporter->dump_fmsg)
-		return 0;
-
-	reporter->dump_fmsg = devlink_fmsg_alloc();
-	if (!reporter->dump_fmsg) {
-		err = -ENOMEM;
-		return err;
-	}
-
-	err = devlink_fmsg_obj_nest_start(reporter->dump_fmsg);
-	if (err)
-		goto dump_err;
-
-	err = reporter->ops->dump(reporter, reporter->dump_fmsg,
-				  priv_ctx, extack);
-	if (err)
-		goto dump_err;
-
-	err = devlink_fmsg_obj_nest_end(reporter->dump_fmsg);
-	if (err)
-		goto dump_err;
-
-	reporter->dump_ts = jiffies;
-	reporter->dump_real_ts = ktime_get_real_ns();
-
-	return 0;
-
-dump_err:
-	devlink_health_dump_clear(reporter);
-	return err;
-}
-
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
-{
-	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	struct devlink_health_reporter *reporter;
-	struct nlattr **attrs = info->attrs;
-	struct devlink *devlink;
-
-	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
-	if (IS_ERR(devlink))
-		return NULL;
-	devl_unlock(devlink);
-
-	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
-	devlink_put(devlink);
-	return reporter;
-}
-
-static int
-devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
-					       struct netlink_callback *cb)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink_health_reporter *reporter;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_cb(cb);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->dump)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&reporter->dump_lock);
-	if (!state->idx) {
-		err = devlink_health_do_dump(reporter, NULL, cb->extack);
-		if (err)
-			goto unlock;
-		state->dump_ts = reporter->dump_ts;
-	}
-	if (!reporter->dump_fmsg || state->dump_ts != reporter->dump_ts) {
-		NL_SET_ERR_MSG(cb->extack, "Dump trampled, please retry");
-		err = -EAGAIN;
-		goto unlock;
-	}
-
-	err = devlink_fmsg_dumpit(reporter->dump_fmsg, skb, cb,
-				  DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
-unlock:
-	mutex_unlock(&reporter->dump_lock);
-	return err;
-}
-
-static int
-devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
-					       struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->dump)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&reporter->dump_lock);
-	devlink_health_dump_clear(reporter);
-	mutex_unlock(&reporter->dump_lock);
-	return 0;
-}
-
 static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 						    struct genl_info *info)
 {
-- 
2.27.0

