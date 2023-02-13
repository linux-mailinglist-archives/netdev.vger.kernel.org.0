Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCC26946BA
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBMNPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjBMNO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:14:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462CE72A8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H45+UwIy8YZ5zS3tbOfLv4w0CCYvF4xzcCuNu8Ryt/sjUNyoXMhPH4PmZennUdRQeRSCFQtX6FMwtUF3BMFBlWwarJNQpSzFcLgQRXtMW7dPL9/FKye6kuUBFDTAppJcdh9LXXyDLQ78g6iddruMYaLW2e/AR6dKtOFKpC3ZUG6NVHHqJX+GfAcU9UqMi/TYpjnJySewHgFmBwLK1+8EoNQjpjH+7aoC88GuX2+ivqaQQknaCn6vexOCGy6fe21cDH4Hg0VWG0YZqRlQ+jC5PEcbajK5npRr3by2r8w7eE2Y/HiyVmnByPcsxuw/nbDdkq7lXyG2Afzjuf83kmvPjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmGwA6/21Hl5a8K+5n4wHztusb+qNWhsEWoojFHAoQk=;
 b=nhMmU5sbCNYxBFy5JEQ/ze5KzYOgrAEpocnpMtQ9F9h6/mb/kp2WVi0YLSZ0W+G0PhV9sScYpjTN53LgFV6JZ12DQJruo3afdIiQloU/EbrhQSMrRJgJLknZzsw4NjRLgHl6zuh9W88xZ1SUDkXMj0XQqcPEFKqQf14eMZ65f5X7qoDvPl0kRrqC9KREs7bbSSYfPUri11SdcSOsXN425cGvtQ5VxeQRuus+RFrHdom7/uGyiKxX39SPRVKYYcBZgHndVEfHCHV0hebXHPI3ttxwPYLhfZOhSpLv4QBXxaDHJqQDUCUCLKobXvz/5PaXPwd3uxpEsqCayOiRiZKxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmGwA6/21Hl5a8K+5n4wHztusb+qNWhsEWoojFHAoQk=;
 b=GWiWyqIcLxb/u2MpBVyLxPoEy7MOmcnrfPSJnJva2HCC/R1fzRFHcsqguYro0hgvWhkOhEAoPqeU/hbd4/vdRukhw/TpRkSttf1Hp9zyilu6jqDWFngWXfRfKVmbSTaoBIdfotwv0Y+WT06MXhwWPe5gnLBQNzUP6Z5jfbweXhYux+UsK5f8Vz43AbKghn8UKMyzzw4AIdTecrd+CxDS4qqPc3dgJoNJraEm/BpTM1Vy+OWTpzyJ4h6OR1QjiPlF5QgWh94Nq4QJIFq5iFPBaCIU0Aa/omEfuPjhtcVFLGTZwwMtbyRFOdZPnqfOvqYYQMaOBsLgyW+bY7DS8meNJg==
Received: from DS7PR05CA0029.namprd05.prod.outlook.com (2603:10b6:5:3b9::34)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 13:14:51 +0000
Received: from DS1PEPF0000E63F.namprd02.prod.outlook.com
 (2603:10b6:5:3b9:cafe::ee) by DS7PR05CA0029.outlook.office365.com
 (2603:10b6:5:3b9::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Mon, 13 Feb 2023 13:14:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E63F.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:14:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:50 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:50 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:49 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 01/10] devlink: Split out health reporter create code
Date:   Mon, 13 Feb 2023 15:14:09 +0200
Message-ID: <1676294058-136786-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63F:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 722bf31c-9201-4304-fb00-08db0dc44a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90atzh1CFAWuPLT0QdyanN8D8FJr2A9j4zlrNluNjUEGihQkVQYSALhFXRY0pOx6wKaPEz95MgT2ckqU0CCgnZWJPk/JS+emVObYDGTCMA1o3tIpnLxAoKGwwi2Ugh0x4a6YbeyPitSLBjKLAa9ocjc31eCOt7sHdqx9DmOy/zJVGDY5/A2GCvKpkmMHR6ZlIBohAw+xim966RswNNjpnrtcikZQhNK97InR15RbQZHgwKoLT0NbGEs/uJczrgX7PWPCmiuprKWXwA5Dgy/XUEMD+OUEPyjtSDcBSqehTC/Emo1KcxvyU4L7DpaY8C/qLb4Ooh0qYfB5IPXtL467Vv1SbXPJEftIpw+axVYICsjM2XTZypfxz1lunasWllwgeIO9zJdrDTp+SNy8XXK/MiZMQH7SzFrtbLGqrHwFuOFAyqCQVVy2P1sYaiE1Es779d1csSBlI1viHNmabQjfvcI8OtLwZ0bX4uIUxEeXEchekmdG3Xt1ib6+9RjIwO+8tKLm6NEHgV2nFv4CiPUXbughMPTOlDojVFqiEwlc8NkMSrXCtlgZ6sO83MsQRx68NsqbZktHz6bIFE43GUiYHwdY5+BZbNGAetlRdC9NFiQpc80chvCLyn8zgHzkPtfGsVNe8Ds/i/U1VVrbDiGa/xkpBhfaTt83MuZXrS5S8Qv6w037pZLjNiPE5ofvFJvmldWahJj6y3r2/9IFsWMLuzyuxiAanxxGygcJqRD8TfQ=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(36756003)(70586007)(8676002)(70206006)(4326008)(478600001)(7696005)(316002)(40460700003)(356005)(86362001)(6666004)(107886003)(426003)(47076005)(82740400003)(186003)(26005)(336012)(2616005)(41300700001)(8936002)(110136005)(82310400005)(83380400001)(5660300002)(7636003)(40480700001)(2906002)(30864003)(36860700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:14:51.4009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 722bf31c-9201-4304-fb00-08db0dc44a5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851
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
that are related to devlink health. No functional change in this patch.

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
index 000000000000..6b0863fbef93
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
+ *	devl_port_health_reporter_create - create devlink health reporter for
+ *	                                   specified port instance
+ *
+ *	@port: devlink_port which should contain the new reporter
+ *	@ops: ops
+ *	@graceful_period: to avoid recovery loops, in msecs
+ *	@priv: priv
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
+ *	devl_health_reporter_create - create devlink health reporter
+ *
+ *	@devlink: devlink
+ *	@ops: ops
+ *	@graceful_period: to avoid recovery loops, in msecs
+ *	@priv: priv
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
+ *	devl_health_reporter_destroy - destroy devlink health reporter
+ *
+ *	@reporter: devlink health reporter to destroy
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

