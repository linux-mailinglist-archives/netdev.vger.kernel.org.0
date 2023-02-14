Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95C6969DC
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjBNQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjBNQib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:31 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB302BF21
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSx/DwOM8qcx8uX3dT2wyj7BHkeMDpg4jcpI4mpQchB9dVF8TyaP+5wsTBt9xfSZp26Lb/wYYzJWNsPdx/1buhfHbqUb0k5QiDgK9wKKgNqX+TCr8DIGhdpIVTTdJkdsF8vNTbZXpOT9Atl5iOMqQ2KtQPaG9n+nVLQgG0rUy0lQYnvYjIh2mIxTPEaTRT9nHmda0/D+kOEsIUa3F8svYcMeaVuQRB5ASYw2xTDFF9ktvX0HAF3edUpvcjFnprLvvdtatvWiX/0pya5r275K+V8CCB0Z5LPsrQ+FCYOnATuP4QuaC6oT8BsFN6LD/jdCdFQXYB5gU8M1e/jfzgx8YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEKsQ7a6SAwzHXKmr2v7jcabQ7BvGBKAmfQhAnOhn7I=;
 b=UPSdPHRmUnqUw76EWo+He/a4Faw+BZrk/IvkQUieKLP0N3cNHjvHtX4ume9ZvgT4OBxsontymFuv16BEEnR2QGk+0OCANYGFXY6O01iM2StF34Hcdn2FbO8GluR29wzgMtNIsV5txjodpWYxdjIhO7S2YOyymiaBCOYzHht4JoA3QF+JyijZ666bhybdOMMfroqtjySjj5yj9Y9zFvzRNuGq9KYOLJJX5c7uOqnRmFTy/B7ZmS5dc38VUfFjMq/KVpwhIYCTh/Mw2/qifGFB2K8AnVpjT1B801hgmNOBy3uu5803OOd/3j01FLqX2Zkw9D+27cHECqkg+41WQCcuJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEKsQ7a6SAwzHXKmr2v7jcabQ7BvGBKAmfQhAnOhn7I=;
 b=HuqAebMP7Y0L7a+z4JCZIEPAueHUNNncG9X0fGaicpzbhc9vMI5BAF1uv9k16BuAFvNQitPBhmcwUjuoZuXUiTWtOVMhkFlxGFhc84jLFv8GxGpziBcd01qjTf/GjIjM6cNDt6hAymD6J20hjNx8ZZGGPDp7fYYC+n7MU3fOrFOIpZtdQt2QmZnSVnNGn44EFG8xnHoBOrpWCEnvy4qPG7n54vNsGJ0K9ufh8wd8AVl8LGKl+WIKkWZFVIsT//0Z8x/lw64FdSTTt78X/1m3s007vvi/8FPYP4/wqhfJ4pnvX9FsOLjtCzBBU0wDU0goXMXlyC2wYo3bwk4NdKkWQA==
Received: from BN8PR04CA0048.namprd04.prod.outlook.com (2603:10b6:408:d4::22)
 by MN2PR12MB4581.namprd12.prod.outlook.com (2603:10b6:208:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:23 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::96) by BN8PR04CA0048.outlook.office365.com
 (2603:10b6:408:d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:13 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:12 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:11 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 01/10] devlink: Split out health reporter create code
Date:   Tue, 14 Feb 2023 18:37:57 +0200
Message-ID: <1676392686-405892-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|MN2PR12MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: 46c59b84-12b8-4be9-f245-08db0ea9e381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2Ug/DlksUrDfTGw9qPsMGOhqwlhT7DdN/hNb/hfX4p3D8H/G3zMn1AtLTodEnTLOp2WJ0of+qj2R3LsizvJpA8GSlb6PGdPi1ZgkgNHBMZuO7LiaXqMAcJJzxNfz6G1MNYrmLrR+VEMxSVM1jrCxb52dRlwkTWhsUQhUDFj24jXmiHGo4R9n9A0q6BXhSm0Km7jm/37bNQs62IeBOLw69Fn6clXSn8KMgInhDdW8lhdfcsw9mo2WtjTniTluSNS6xxEtJBQeBDPRIY4yIuna8DeNNxkU4bJtMTvoFUhSKefWd6CHogLXYWShXCdhXWkLj5sq9WbhzTLMLi5UKCqNWkyRJbQKpL79yifu9sC0e8irFP/KMj5n1TL5DbDb+JZgy+Y0Vc5oKSwHKzgApRQp3oFrus1QAD/gXUegQ+qHw+MJEp9lnZdoYg0kAX86EIAPhtvTpxjEObb7jOk3VJKD8TennYRH34q0RU09cExrU3KqWeknVzy2LPFo70tb0gM8kUf+lYnJcpjU90qTl1QzTJ0qxs8rzBlf5W8BbPSeR0xr/ut17CciUl7TCOB+R744OJ3QKJhpLOkAFhFcQu07/eJCrdBkacRHXy2qLICkDBxXCFe984MRziP7kYKhaM+kRNqMIHuulPop3G1dOXdmPgNiZbyakXbj7mmW360lo5IT4tbCEClDOICj1roHfyVw2+nvfCJ/peYmF1re49a8do1knawUp1YHK/LQ/x9kEA=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(36840700001)(46966006)(40470700004)(36756003)(30864003)(2906002)(47076005)(5660300002)(83380400001)(26005)(426003)(186003)(2616005)(336012)(356005)(40480700001)(82740400003)(36860700001)(7636003)(4326008)(8676002)(70586007)(8936002)(70206006)(316002)(86362001)(41300700001)(478600001)(107886003)(40460700003)(6666004)(82310400005)(7696005)(110136005)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:23.0388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c59b84-12b8-4be9-f245-08db0ea9e381
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health reporter create/destroy and related dev code to new
file health.c. This file shall include all callbacks and functionality
that are related to devlink health.

In addition, fix kdoc indentation and make reporter create/destroy kdoc
more clear. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/Makefile        |   2 +-
 net/devlink/devl_internal.h |  28 +++++
 net/devlink/health.c        | 196 +++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 209 +-----------------------------------
 4 files changed, 226 insertions(+), 209 deletions(-)
 create mode 100644 net/devlink/health.c

diff --git a/net/devlink/Makefile b/net/devlink/Makefile
index daad4521c61e..ef91a76646a3 100644
--- a/net/devlink/Makefile
+++ b/net/devlink/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := leftover.o core.o netlink.o dev.o
+obj-y := leftover.o core.o netlink.o dev.o health.o
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 2f4820e40d27..49fe9e2dae34 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -198,6 +198,34 @@ int devlink_resources_validate(struct devlink *devlink,
 			       struct devlink_resource *resource,
 			       struct genl_info *info);
 
+/* Health */
+struct devlink_health_reporter {
+	struct list_head list;
+	void *priv;
+	const struct devlink_health_reporter_ops *ops;
+	struct devlink *devlink;
+	struct devlink_port *devlink_port;
+	struct devlink_fmsg *dump_fmsg;
+	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
+	u64 graceful_period;
+	bool auto_recover;
+	bool auto_dump;
+	u8 health_state;
+	u64 dump_ts;
+	u64 dump_real_ts;
+	u64 error_count;
+	u64 recovery_count;
+	u64 last_recovery_ts;
+};
+
+struct devlink_health_reporter *
+devlink_health_reporter_find_by_name(struct devlink *devlink,
+				     const char *reporter_name);
+struct devlink_health_reporter *
+devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
+					  const char *reporter_name);
+void devlink_fmsg_free(struct devlink_fmsg *fmsg);
+
 /* Line cards */
 struct devlink_linecard;
 
diff --git a/net/devlink/health.c b/net/devlink/health.c
new file mode 100644
index 000000000000..18d1f38380b3
--- /dev/null
+++ b/net/devlink/health.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
+ */
+
+#include <net/genetlink.h>
+#include "devl_internal.h"
+
+void *
+devlink_health_reporter_priv(struct devlink_health_reporter *reporter)
+{
+	return reporter->priv;
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
+
+static struct devlink_health_reporter *
+__devlink_health_reporter_find_by_name(struct list_head *reporter_list,
+				       const char *reporter_name)
+{
+	struct devlink_health_reporter *reporter;
+
+	list_for_each_entry(reporter, reporter_list, list)
+		if (!strcmp(reporter->ops->name, reporter_name))
+			return reporter;
+	return NULL;
+}
+
+struct devlink_health_reporter *
+devlink_health_reporter_find_by_name(struct devlink *devlink,
+				     const char *reporter_name)
+{
+	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
+						      reporter_name);
+}
+
+struct devlink_health_reporter *
+devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
+					  const char *reporter_name)
+{
+	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
+						      reporter_name);
+}
+
+static struct devlink_health_reporter *
+__devlink_health_reporter_create(struct devlink *devlink,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	if (WARN_ON(graceful_period && !ops->recover))
+		return ERR_PTR(-EINVAL);
+
+	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
+	if (!reporter)
+		return ERR_PTR(-ENOMEM);
+
+	reporter->priv = priv;
+	reporter->ops = ops;
+	reporter->devlink = devlink;
+	reporter->graceful_period = graceful_period;
+	reporter->auto_recover = !!ops->recover;
+	reporter->auto_dump = !!ops->dump;
+	mutex_init(&reporter->dump_lock);
+	return reporter;
+}
+
+/**
+ * devl_port_health_reporter_create() - create devlink health reporter for
+ *                                      specified port instance
+ *
+ * @port: devlink_port to which health reports will relate
+ * @ops: devlink health reporter ops
+ * @graceful_period: min time (in msec) between recovery attempts
+ * @priv: driver priv pointer
+ */
+struct devlink_health_reporter *
+devl_port_health_reporter_create(struct devlink_port *port,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	devl_assert_locked(port->devlink);
+
+	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
+						   ops->name))
+		return ERR_PTR(-EEXIST);
+
+	reporter = __devlink_health_reporter_create(port->devlink, ops,
+						    graceful_period, priv);
+	if (IS_ERR(reporter))
+		return reporter;
+
+	reporter->devlink_port = port;
+	list_add_tail(&reporter->list, &port->reporter_list);
+	return reporter;
+}
+EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
+
+struct devlink_health_reporter *
+devlink_port_health_reporter_create(struct devlink_port *port,
+				    const struct devlink_health_reporter_ops *ops,
+				    u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+	struct devlink *devlink = port->devlink;
+
+	devl_lock(devlink);
+	reporter = devl_port_health_reporter_create(port, ops,
+						    graceful_period, priv);
+	devl_unlock(devlink);
+	return reporter;
+}
+EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
+
+/**
+ * devl_health_reporter_create - create devlink health reporter
+ *
+ * @devlink: devlink instance which the health reports will relate
+ * @ops: devlink health reporter ops
+ * @graceful_period: min time (in msec) between recovery attempts
+ * @priv: driver priv pointer
+ */
+struct devlink_health_reporter *
+devl_health_reporter_create(struct devlink *devlink,
+			    const struct devlink_health_reporter_ops *ops,
+			    u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	devl_assert_locked(devlink);
+
+	if (devlink_health_reporter_find_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
+
+	reporter = __devlink_health_reporter_create(devlink, ops,
+						    graceful_period, priv);
+	if (IS_ERR(reporter))
+		return reporter;
+
+	list_add_tail(&reporter->list, &devlink->reporter_list);
+	return reporter;
+}
+EXPORT_SYMBOL_GPL(devl_health_reporter_create);
+
+struct devlink_health_reporter *
+devlink_health_reporter_create(struct devlink *devlink,
+			       const struct devlink_health_reporter_ops *ops,
+			       u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	devl_lock(devlink);
+	reporter = devl_health_reporter_create(devlink, ops,
+					       graceful_period, priv);
+	devl_unlock(devlink);
+	return reporter;
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_create);
+
+static void
+devlink_health_reporter_free(struct devlink_health_reporter *reporter)
+{
+	mutex_destroy(&reporter->dump_lock);
+	if (reporter->dump_fmsg)
+		devlink_fmsg_free(reporter->dump_fmsg);
+	kfree(reporter);
+}
+
+/**
+ * devl_health_reporter_destroy() - destroy devlink health reporter
+ *
+ * @reporter: devlink health reporter to destroy
+ */
+void
+devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
+{
+	devl_assert_locked(reporter->devlink);
+
+	list_del(&reporter->list);
+	devlink_health_reporter_free(reporter);
+}
+EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
+
+void
+devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
+{
+	struct devlink *devlink = reporter->devlink;
+
+	devl_lock(devlink);
+	devl_health_reporter_destroy(reporter);
+	devl_unlock(devlink);
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 3569706c49e1..cfd1b90a0fc1 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5403,7 +5403,7 @@ static struct devlink_fmsg *devlink_fmsg_alloc(void)
 	return fmsg;
 }
 
-static void devlink_fmsg_free(struct devlink_fmsg *fmsg)
+void devlink_fmsg_free(struct devlink_fmsg *fmsg)
 {
 	struct devlink_fmsg_item *item, *tmp;
 
@@ -5963,213 +5963,6 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_health_reporter {
-	struct list_head list;
-	void *priv;
-	const struct devlink_health_reporter_ops *ops;
-	struct devlink *devlink;
-	struct devlink_port *devlink_port;
-	struct devlink_fmsg *dump_fmsg;
-	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
-	u64 graceful_period;
-	bool auto_recover;
-	bool auto_dump;
-	u8 health_state;
-	u64 dump_ts;
-	u64 dump_real_ts;
-	u64 error_count;
-	u64 recovery_count;
-	u64 last_recovery_ts;
-};
-
-void *
-devlink_health_reporter_priv(struct devlink_health_reporter *reporter)
-{
-	return reporter->priv;
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
-
-static struct devlink_health_reporter *
-__devlink_health_reporter_find_by_name(struct list_head *reporter_list,
-				       const char *reporter_name)
-{
-	struct devlink_health_reporter *reporter;
-
-	list_for_each_entry(reporter, reporter_list, list)
-		if (!strcmp(reporter->ops->name, reporter_name))
-			return reporter;
-	return NULL;
-}
-
-static struct devlink_health_reporter *
-devlink_health_reporter_find_by_name(struct devlink *devlink,
-				     const char *reporter_name)
-{
-	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
-						      reporter_name);
-}
-
-static struct devlink_health_reporter *
-devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
-					  const char *reporter_name)
-{
-	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
-						      reporter_name);
-}
-
-static struct devlink_health_reporter *
-__devlink_health_reporter_create(struct devlink *devlink,
-				 const struct devlink_health_reporter_ops *ops,
-				 u64 graceful_period, void *priv)
-{
-	struct devlink_health_reporter *reporter;
-
-	if (WARN_ON(graceful_period && !ops->recover))
-		return ERR_PTR(-EINVAL);
-
-	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
-	if (!reporter)
-		return ERR_PTR(-ENOMEM);
-
-	reporter->priv = priv;
-	reporter->ops = ops;
-	reporter->devlink = devlink;
-	reporter->graceful_period = graceful_period;
-	reporter->auto_recover = !!ops->recover;
-	reporter->auto_dump = !!ops->dump;
-	mutex_init(&reporter->dump_lock);
-	return reporter;
-}
-
-/**
- *	devl_port_health_reporter_create - create devlink health reporter for
- *	                                   specified port instance
- *
- *	@port: devlink_port which should contain the new reporter
- *	@ops: ops
- *	@graceful_period: to avoid recovery loops, in msecs
- *	@priv: priv
- */
-struct devlink_health_reporter *
-devl_port_health_reporter_create(struct devlink_port *port,
-				 const struct devlink_health_reporter_ops *ops,
-				 u64 graceful_period, void *priv)
-{
-	struct devlink_health_reporter *reporter;
-
-	devl_assert_locked(port->devlink);
-
-	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
-						   ops->name))
-		return ERR_PTR(-EEXIST);
-
-	reporter = __devlink_health_reporter_create(port->devlink, ops,
-						    graceful_period, priv);
-	if (IS_ERR(reporter))
-		return reporter;
-
-	reporter->devlink_port = port;
-	list_add_tail(&reporter->list, &port->reporter_list);
-	return reporter;
-}
-EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
-
-struct devlink_health_reporter *
-devlink_port_health_reporter_create(struct devlink_port *port,
-				    const struct devlink_health_reporter_ops *ops,
-				    u64 graceful_period, void *priv)
-{
-	struct devlink_health_reporter *reporter;
-	struct devlink *devlink = port->devlink;
-
-	devl_lock(devlink);
-	reporter = devl_port_health_reporter_create(port, ops,
-						    graceful_period, priv);
-	devl_unlock(devlink);
-	return reporter;
-}
-EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
-
-/**
- *	devl_health_reporter_create - create devlink health reporter
- *
- *	@devlink: devlink
- *	@ops: ops
- *	@graceful_period: to avoid recovery loops, in msecs
- *	@priv: priv
- */
-struct devlink_health_reporter *
-devl_health_reporter_create(struct devlink *devlink,
-			    const struct devlink_health_reporter_ops *ops,
-			    u64 graceful_period, void *priv)
-{
-	struct devlink_health_reporter *reporter;
-
-	devl_assert_locked(devlink);
-
-	if (devlink_health_reporter_find_by_name(devlink, ops->name))
-		return ERR_PTR(-EEXIST);
-
-	reporter = __devlink_health_reporter_create(devlink, ops,
-						    graceful_period, priv);
-	if (IS_ERR(reporter))
-		return reporter;
-
-	list_add_tail(&reporter->list, &devlink->reporter_list);
-	return reporter;
-}
-EXPORT_SYMBOL_GPL(devl_health_reporter_create);
-
-struct devlink_health_reporter *
-devlink_health_reporter_create(struct devlink *devlink,
-			       const struct devlink_health_reporter_ops *ops,
-			       u64 graceful_period, void *priv)
-{
-	struct devlink_health_reporter *reporter;
-
-	devl_lock(devlink);
-	reporter = devl_health_reporter_create(devlink, ops,
-					       graceful_period, priv);
-	devl_unlock(devlink);
-	return reporter;
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_create);
-
-static void
-devlink_health_reporter_free(struct devlink_health_reporter *reporter)
-{
-	mutex_destroy(&reporter->dump_lock);
-	if (reporter->dump_fmsg)
-		devlink_fmsg_free(reporter->dump_fmsg);
-	kfree(reporter);
-}
-
-/**
- *	devl_health_reporter_destroy - destroy devlink health reporter
- *
- *	@reporter: devlink health reporter to destroy
- */
-void
-devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	devl_assert_locked(reporter->devlink);
-
-	list_del(&reporter->list);
-	devlink_health_reporter_free(reporter);
-}
-EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
-
-void
-devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	struct devlink *devlink = reporter->devlink;
-
-	devl_lock(devlink);
-	devl_health_reporter_destroy(reporter);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
-
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
-- 
2.27.0

