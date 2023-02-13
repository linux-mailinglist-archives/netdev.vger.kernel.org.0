Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E993A6946C1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjBMNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBMNPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:22 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06EF16AE9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4TOSd1vm9POGKMg/eqqRpBLPz8BTaJuNZzviz5SW9HLUh5XfZ0zrN66hN3fmFx+NggF8eROn4Cg0QuGSleOAO4IlSNW0p1xnhxr8O1tBdf677Xq8XAjxZWohXDyrJPFCQ4bTu1qXjSKLe11T3ZF/S4EbDA95ERuVeZW6ajsOuujxyRm/3cNp+mGqXJL1RufVJC7uZnNG/lORp7qKdBtRoJkZgV9D/JYb1joADNY4fDQzBl1KuuyV6S1cFZ0Xa1yIfxMrKgAV5pNHr3QL+bocAuTNoji3jZIalq8kpjh/lzHSp4Re3xs81H7UkRTMTFBPDVSKOicOe2nGtGTUD0UXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0slY3c8mEpNUd97R/PpsUFnq4IEhHbOzjYSn6K79bvI=;
 b=ZTBIlY/VPtWKygNTeNcYCa2VEUjGnDzOMouaKBeb+sXHWdrgNSDYwkc9d1HT8Pi+wnvn1b+/aPOai/4tXaoTLE5BbSbkNZoWAOr3BsmKsTCxPr/Pwwi4WuTGpq/ftqfVsdR/Slrxy6QalRNZg9LveHb7niYhJp19Etu92Rpw6R3KADZ7jLffJGicCRb6c6y41wPSaR55geHxukSIpgzsOOaxuoQQYprf8Q1H2k9Ih1dE5xMGNAyX1szewRJnAzbsvt7oRkG+IcJE/c37SJWlrbDSoZiTckiC15L9iQph6lwz/HFe1xIFZeP/5fWPT/Mqub+byxbTRqrFunM+1CvpyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0slY3c8mEpNUd97R/PpsUFnq4IEhHbOzjYSn6K79bvI=;
 b=UYmXIZ2UaIsH6s3jJv1+xiByyCYt93VI/417acrd8ay7HnjUyI6yqWFsMHVEImXtQdU6vD6x0DGuITCK4JvmnE/HGkGvvPMgqaQLdg1qnRaByhMYlXdH8M3fYnANHLLWqXV2AmS2bmOguPWspzyjoelW3KbavSY+RJysTmKmCg88WbqOUbbLxb2ioRYN2SeVxOxc0Hzy7i/VgKuaC+rmlWzXkvOujiQz+3m6ueiLPIGCYopDWuQ5bbnhGKnNb2izkocPCALtMMqNMCVArreMccL7+Y1H7If6GvCZpv5q19vcwMDwp4T6IbVkH9aXyW4aYY7tZ0xJunp4gg2PQ5b46w==
Received: from MN2PR10CA0012.namprd10.prod.outlook.com (2603:10b6:208:120::25)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 13:15:09 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::df) by MN2PR10CA0012.outlook.office365.com
 (2603:10b6:208:120::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:15:00 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:15:00 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:58 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 06/10] devlink: Move devlink fmsg and health diagnose to health file
Date:   Mon, 13 Feb 2023 15:14:14 +0200
Message-ID: <1676294058-136786-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|DM6PR12MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: 60b04c0c-86c8-4430-0451-08db0dc45501
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 745Jxjd+LZUhfcYTKkVL5Mb3Zl2s4g7s2BXT+9G/Th1whzaDEzhn+l7mdJ6guj3Lfl4md4a6m4GrKcjEKjwCk3jMAa4pkgVc27K6XsMqunFzDM6s+q7vmDIPd3fUyO589kbFLHkT0LEI8azHm0JQ1wtC5ZqzM9x/ajP+schrawNX6fm2eOe4DbHryD4GPiYrbnyUk8V9ebArmvxCZVy+Liw53RUhA0mvFmFlgrrOkEitm1C56s/lIvjcFDawvotGRzJPdfdyzGSB1Sw7D/skq/tdaGxFBnnJ8JrYqbUOBI7welB9cKIRETd8+7C2VQeSyLcD9jWpgXamvKoXiHORYP23ZcmANcZnAsTEcrti7Bmj8r7fSAEbMu6PFgHZPJMWyTauxm8z3vOqWrXNWJeXPLwsrXj6KuZccOPpElDbsscCC2EK9iDwK2AX9nU335pBtKCZThOn61N6Mj7c1hWTjbds2lmFRnuRqR9CqVqHtXj2ubQVkYR654iGvskLp4Mp2/2fgv+zOiIhnf5WEZIFSEECARgMlHn5mWeHEIoqf4WW3atmgbo/KMjqngBWQY3mss9PjfNSekqUoVOIvN5UgMZd9HeWyxpSdHvt+yTfCyViPp1xeGV1TlkVJ21JcW57WN/Zi57lSg2dniCJz5c/gKKrMQo5ZIzUB1IswudEd+Bdint1X/rjAChiYJq6uUmBeW72dvuN58EwahZRVqFl6Q==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(5660300002)(8936002)(41300700001)(2906002)(70586007)(30864003)(70206006)(4326008)(8676002)(40480700001)(47076005)(316002)(40460700003)(110136005)(7696005)(478600001)(107886003)(6666004)(26005)(36756003)(186003)(83380400001)(426003)(82310400005)(86362001)(2616005)(82740400003)(7636003)(336012)(356005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:09.1907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b04c0c-86c8-4430-0451-08db0dc45501
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink fmsg (formatted message) is used by devlink health diagnose,
dump and drivers which support these devlink health callbacks.
Therefore, move devlink fmsg helpers and related code to file health.c.
Move devlink health diagnose to file health.c. No functional change in
this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h |   6 +
 net/devlink/health.c        | 630 ++++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 630 ------------------------------------
 3 files changed, 636 insertions(+), 630 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index d1a901cb5900..a4b96f8a0ab4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -240,7 +240,11 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 			   void *priv_ctx,
 			   struct netlink_ext_ack *extack);
+int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			struct netlink_callback *cb,
+			enum devlink_command cmd);
 
+struct devlink_fmsg *devlink_fmsg_alloc(void);
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
 /* Line cards */
@@ -272,3 +276,5 @@ int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					    struct genl_info *info);
 int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						struct genl_info *info);
+int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
+						 struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 962727bb5b6c..5542e358be2d 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -8,6 +8,48 @@
 #include <trace/events/devlink.h>
 #include "devl_internal.h"
 
+struct devlink_fmsg_item {
+	struct list_head list;
+	int attrtype;
+	u8 nla_type;
+	u16 len;
+	int value[];
+};
+
+struct devlink_fmsg {
+	struct list_head item_list;
+	bool putting_binary; /* This flag forces enclosing of binary data
+			      * in an array brackets. It forces using
+			      * of designated API:
+			      * devlink_fmsg_binary_pair_nest_start()
+			      * devlink_fmsg_binary_pair_nest_end()
+			      */
+};
+
+struct devlink_fmsg *devlink_fmsg_alloc(void)
+{
+	struct devlink_fmsg *fmsg;
+
+	fmsg = kzalloc(sizeof(*fmsg), GFP_KERNEL);
+	if (!fmsg)
+		return NULL;
+
+	INIT_LIST_HEAD(&fmsg->item_list);
+
+	return fmsg;
+}
+
+void devlink_fmsg_free(struct devlink_fmsg *fmsg)
+{
+	struct devlink_fmsg_item *item, *tmp;
+
+	list_for_each_entry_safe(item, tmp, &fmsg->item_list, list) {
+		list_del(&item->list);
+		kfree(item);
+	}
+	kfree(fmsg);
+}
+
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter)
 {
@@ -544,3 +586,591 @@ int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 
 	return devlink_health_reporter_recover(reporter, NULL, info->extack);
 }
+
+static int devlink_fmsg_nest_common(struct devlink_fmsg *fmsg,
+				    int attrtype)
+{
+	struct devlink_fmsg_item *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->attrtype = attrtype;
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
+
+static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
+}
+
+int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
+
+#define DEVLINK_FMSG_MAX_SIZE (GENLMSG_DEFAULT_SIZE - GENL_HDRLEN - NLA_HDRLEN)
+
+static int devlink_fmsg_put_name(struct devlink_fmsg *fmsg, const char *name)
+{
+	struct devlink_fmsg_item *item;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
+		return -EMSGSIZE;
+
+	item = kzalloc(sizeof(*item) + strlen(name) + 1, GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->nla_type = NLA_NUL_STRING;
+	item->len = strlen(name) + 1;
+	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_NAME;
+	memcpy(&item->value, name, item->len);
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+int devlink_fmsg_pair_nest_start(struct devlink_fmsg *fmsg, const char *name)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_put_name(fmsg, name);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
+
+int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
+
+int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
+				     const char *name)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_ARR_NEST_START);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_start);
+
+int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
+
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name)
+{
+	int err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	fmsg->putting_binary = true;
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
+
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	fmsg->putting_binary = false;
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
+
+static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
+				  const void *value, u16 value_len,
+				  u8 value_nla_type)
+{
+	struct devlink_fmsg_item *item;
+
+	if (value_len > DEVLINK_FMSG_MAX_SIZE)
+		return -EMSGSIZE;
+
+	item = kzalloc(sizeof(*item) + value_len, GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->nla_type = value_nla_type;
+	item->len = value_len;
+	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
+	memcpy(&item->value, value, item->len);
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+static int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
+}
+
+static int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
+}
+
+int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
+
+static int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
+}
+
+int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
+				      NLA_NUL_STRING);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
+
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
+
+int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			       bool value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_bool_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_bool_pair_put);
+
+int devlink_fmsg_u8_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			     u8 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u8_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u8_pair_put);
+
+int devlink_fmsg_u32_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			      u32 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u32_pair_put);
+
+int devlink_fmsg_u64_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			      u64 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u64_pair_put);
+
+int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
+				 const char *value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_string_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_string_pair_put);
+
+int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
+				 const void *value, u32 value_len)
+{
+	u32 data_size;
+	int end_err;
+	u32 offset;
+	int err;
+
+	err = devlink_fmsg_binary_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	for (offset = 0; offset < value_len; offset += data_size) {
+		data_size = value_len - offset;
+		if (data_size > DEVLINK_FMSG_MAX_SIZE)
+			data_size = DEVLINK_FMSG_MAX_SIZE;
+		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
+		if (err)
+			break;
+		/* Exit from loop with a break (instead of
+		 * return) to make sure putting_binary is turned off in
+		 * devlink_fmsg_binary_pair_nest_end
+		 */
+	}
+
+	end_err = devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err = end_err;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
+
+static int
+devlink_fmsg_item_fill_type(struct devlink_fmsg_item *msg, struct sk_buff *skb)
+{
+	switch (msg->nla_type) {
+	case NLA_FLAG:
+	case NLA_U8:
+	case NLA_U32:
+	case NLA_U64:
+	case NLA_NUL_STRING:
+	case NLA_BINARY:
+		return nla_put_u8(skb, DEVLINK_ATTR_FMSG_OBJ_VALUE_TYPE,
+				  msg->nla_type);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+devlink_fmsg_item_fill_data(struct devlink_fmsg_item *msg, struct sk_buff *skb)
+{
+	int attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
+	u8 tmp;
+
+	switch (msg->nla_type) {
+	case NLA_FLAG:
+		/* Always provide flag data, regardless of its value */
+		tmp = *(bool *)msg->value;
+
+		return nla_put_u8(skb, attrtype, tmp);
+	case NLA_U8:
+		return nla_put_u8(skb, attrtype, *(u8 *)msg->value);
+	case NLA_U32:
+		return nla_put_u32(skb, attrtype, *(u32 *)msg->value);
+	case NLA_U64:
+		return nla_put_u64_64bit(skb, attrtype, *(u64 *)msg->value,
+					 DEVLINK_ATTR_PAD);
+	case NLA_NUL_STRING:
+		return nla_put_string(skb, attrtype, (char *)&msg->value);
+	case NLA_BINARY:
+		return nla_put(skb, attrtype, msg->len, (void *)&msg->value);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			 int *start)
+{
+	struct devlink_fmsg_item *item;
+	struct nlattr *fmsg_nlattr;
+	int err = 0;
+	int i = 0;
+
+	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
+	if (!fmsg_nlattr)
+		return -EMSGSIZE;
+
+	list_for_each_entry(item, &fmsg->item_list, list) {
+		if (i < *start) {
+			i++;
+			continue;
+		}
+
+		switch (item->attrtype) {
+		case DEVLINK_ATTR_FMSG_OBJ_NEST_START:
+		case DEVLINK_ATTR_FMSG_PAIR_NEST_START:
+		case DEVLINK_ATTR_FMSG_ARR_NEST_START:
+		case DEVLINK_ATTR_FMSG_NEST_END:
+			err = nla_put_flag(skb, item->attrtype);
+			break;
+		case DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA:
+			err = devlink_fmsg_item_fill_type(item, skb);
+			if (err)
+				break;
+			err = devlink_fmsg_item_fill_data(item, skb);
+			break;
+		case DEVLINK_ATTR_FMSG_OBJ_NAME:
+			err = nla_put_string(skb, item->attrtype,
+					     (char *)&item->value);
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+		if (!err)
+			*start = ++i;
+		else
+			break;
+	}
+
+	nla_nest_end(skb, fmsg_nlattr);
+	return err;
+}
+
+static int devlink_fmsg_snd(struct devlink_fmsg *fmsg,
+			    struct genl_info *info,
+			    enum devlink_command cmd, int flags)
+{
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	bool last = false;
+	int index = 0;
+	void *hdr;
+	int err;
+
+	while (!last) {
+		int tmp_index = index;
+
+		skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
+				  &devlink_nl_family, flags | NLM_F_MULTI, cmd);
+		if (!hdr) {
+			err = -EMSGSIZE;
+			goto nla_put_failure;
+		}
+
+		err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
+		if (!err)
+			last = true;
+		else if (err != -EMSGSIZE || tmp_index == index)
+			goto nla_put_failure;
+
+		genlmsg_end(skb, hdr);
+		err = genlmsg_reply(skb, info);
+		if (err)
+			return err;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq,
+			NLMSG_DONE, 0, flags | NLM_F_MULTI);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	return genlmsg_reply(skb, info);
+
+nla_put_failure:
+	nlmsg_free(skb);
+	return err;
+}
+
+int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			struct netlink_callback *cb,
+			enum devlink_command cmd)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	int index = state->idx;
+	int tmp_index = index;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI, cmd);
+	if (!hdr) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
+	if ((err && err != -EMSGSIZE) || tmp_index == index)
+		goto nla_put_failure;
+
+	state->idx = index;
+	genlmsg_end(skb, hdr);
+	return skb->len;
+
+nla_put_failure:
+	genlmsg_cancel(skb, hdr);
+	return err;
+}
+
+int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
+						 struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+	struct devlink_fmsg *fmsg;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->diagnose)
+		return -EOPNOTSUPP;
+
+	fmsg = devlink_fmsg_alloc();
+	if (!fmsg)
+		return -ENOMEM;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		goto out;
+
+	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
+	if (err)
+		goto out;
+
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		goto out;
+
+	err = devlink_fmsg_snd(fmsg, info,
+			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
+
+out:
+	devlink_fmsg_free(fmsg);
+	return err;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 03184dd3d271..e460bcf1d247 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5372,597 +5372,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_fmsg_item {
-	struct list_head list;
-	int attrtype;
-	u8 nla_type;
-	u16 len;
-	int value[];
-};
-
-struct devlink_fmsg {
-	struct list_head item_list;
-	bool putting_binary; /* This flag forces enclosing of binary data
-			      * in an array brackets. It forces using
-			      * of designated API:
-			      * devlink_fmsg_binary_pair_nest_start()
-			      * devlink_fmsg_binary_pair_nest_end()
-			      */
-};
-
-static struct devlink_fmsg *devlink_fmsg_alloc(void)
-{
-	struct devlink_fmsg *fmsg;
-
-	fmsg = kzalloc(sizeof(*fmsg), GFP_KERNEL);
-	if (!fmsg)
-		return NULL;
-
-	INIT_LIST_HEAD(&fmsg->item_list);
-
-	return fmsg;
-}
-
-void devlink_fmsg_free(struct devlink_fmsg *fmsg)
-{
-	struct devlink_fmsg_item *item, *tmp;
-
-	list_for_each_entry_safe(item, tmp, &fmsg->item_list, list) {
-		list_del(&item->list);
-		kfree(item);
-	}
-	kfree(fmsg);
-}
-
-static int devlink_fmsg_nest_common(struct devlink_fmsg *fmsg,
-				    int attrtype)
-{
-	struct devlink_fmsg_item *item;
-
-	item = kzalloc(sizeof(*item), GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->attrtype = attrtype;
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
-
-static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
-}
-
-int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
-
-#define DEVLINK_FMSG_MAX_SIZE (GENLMSG_DEFAULT_SIZE - GENL_HDRLEN - NLA_HDRLEN)
-
-static int devlink_fmsg_put_name(struct devlink_fmsg *fmsg, const char *name)
-{
-	struct devlink_fmsg_item *item;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
-		return -EMSGSIZE;
-
-	item = kzalloc(sizeof(*item) + strlen(name) + 1, GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->nla_type = NLA_NUL_STRING;
-	item->len = strlen(name) + 1;
-	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_NAME;
-	memcpy(&item->value, name, item->len);
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-int devlink_fmsg_pair_nest_start(struct devlink_fmsg *fmsg, const char *name)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_put_name(fmsg, name);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
-
-int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
-
-int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
-				     const char *name)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_ARR_NEST_START);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_start);
-
-int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_nest_end(fmsg);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
-
-int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
-					const char *name)
-{
-	int err;
-
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	fmsg->putting_binary = true;
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
-
-int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (!fmsg->putting_binary)
-		return -EINVAL;
-
-	fmsg->putting_binary = false;
-	return devlink_fmsg_arr_pair_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
-
-static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
-				  const void *value, u16 value_len,
-				  u8 value_nla_type)
-{
-	struct devlink_fmsg_item *item;
-
-	if (value_len > DEVLINK_FMSG_MAX_SIZE)
-		return -EMSGSIZE;
-
-	item = kzalloc(sizeof(*item) + value_len, GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->nla_type = value_nla_type;
-	item->len = value_len;
-	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
-	memcpy(&item->value, value, item->len);
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-static int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
-}
-
-static int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
-}
-
-int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
-
-static int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
-}
-
-int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
-				      NLA_NUL_STRING);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
-
-int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
-			    u16 value_len)
-{
-	if (!fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
-
-int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			       bool value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_bool_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_bool_pair_put);
-
-int devlink_fmsg_u8_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			     u8 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u8_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u8_pair_put);
-
-int devlink_fmsg_u32_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			      u32 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u32_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u32_pair_put);
-
-int devlink_fmsg_u64_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			      u64 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u64_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u64_pair_put);
-
-int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const char *value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_string_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_string_pair_put);
-
-int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const void *value, u32 value_len)
-{
-	u32 data_size;
-	int end_err;
-	u32 offset;
-	int err;
-
-	err = devlink_fmsg_binary_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	for (offset = 0; offset < value_len; offset += data_size) {
-		data_size = value_len - offset;
-		if (data_size > DEVLINK_FMSG_MAX_SIZE)
-			data_size = DEVLINK_FMSG_MAX_SIZE;
-		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
-		if (err)
-			break;
-		/* Exit from loop with a break (instead of
-		 * return) to make sure putting_binary is turned off in
-		 * devlink_fmsg_binary_pair_nest_end
-		 */
-	}
-
-	end_err = devlink_fmsg_binary_pair_nest_end(fmsg);
-	if (end_err)
-		err = end_err;
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
-
-static int
-devlink_fmsg_item_fill_type(struct devlink_fmsg_item *msg, struct sk_buff *skb)
-{
-	switch (msg->nla_type) {
-	case NLA_FLAG:
-	case NLA_U8:
-	case NLA_U32:
-	case NLA_U64:
-	case NLA_NUL_STRING:
-	case NLA_BINARY:
-		return nla_put_u8(skb, DEVLINK_ATTR_FMSG_OBJ_VALUE_TYPE,
-				  msg->nla_type);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int
-devlink_fmsg_item_fill_data(struct devlink_fmsg_item *msg, struct sk_buff *skb)
-{
-	int attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
-	u8 tmp;
-
-	switch (msg->nla_type) {
-	case NLA_FLAG:
-		/* Always provide flag data, regardless of its value */
-		tmp = *(bool *) msg->value;
-
-		return nla_put_u8(skb, attrtype, tmp);
-	case NLA_U8:
-		return nla_put_u8(skb, attrtype, *(u8 *) msg->value);
-	case NLA_U32:
-		return nla_put_u32(skb, attrtype, *(u32 *) msg->value);
-	case NLA_U64:
-		return nla_put_u64_64bit(skb, attrtype, *(u64 *) msg->value,
-					 DEVLINK_ATTR_PAD);
-	case NLA_NUL_STRING:
-		return nla_put_string(skb, attrtype, (char *) &msg->value);
-	case NLA_BINARY:
-		return nla_put(skb, attrtype, msg->len, (void *) &msg->value);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int
-devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			 int *start)
-{
-	struct devlink_fmsg_item *item;
-	struct nlattr *fmsg_nlattr;
-	int err = 0;
-	int i = 0;
-
-	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
-	if (!fmsg_nlattr)
-		return -EMSGSIZE;
-
-	list_for_each_entry(item, &fmsg->item_list, list) {
-		if (i < *start) {
-			i++;
-			continue;
-		}
-
-		switch (item->attrtype) {
-		case DEVLINK_ATTR_FMSG_OBJ_NEST_START:
-		case DEVLINK_ATTR_FMSG_PAIR_NEST_START:
-		case DEVLINK_ATTR_FMSG_ARR_NEST_START:
-		case DEVLINK_ATTR_FMSG_NEST_END:
-			err = nla_put_flag(skb, item->attrtype);
-			break;
-		case DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA:
-			err = devlink_fmsg_item_fill_type(item, skb);
-			if (err)
-				break;
-			err = devlink_fmsg_item_fill_data(item, skb);
-			break;
-		case DEVLINK_ATTR_FMSG_OBJ_NAME:
-			err = nla_put_string(skb, item->attrtype,
-					     (char *) &item->value);
-			break;
-		default:
-			err = -EINVAL;
-			break;
-		}
-		if (!err)
-			*start = ++i;
-		else
-			break;
-	}
-
-	nla_nest_end(skb, fmsg_nlattr);
-	return err;
-}
-
-static int devlink_fmsg_snd(struct devlink_fmsg *fmsg,
-			    struct genl_info *info,
-			    enum devlink_command cmd, int flags)
-{
-	struct nlmsghdr *nlh;
-	struct sk_buff *skb;
-	bool last = false;
-	int index = 0;
-	void *hdr;
-	int err;
-
-	while (!last) {
-		int tmp_index = index;
-
-		skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-		if (!skb)
-			return -ENOMEM;
-
-		hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
-				  &devlink_nl_family, flags | NLM_F_MULTI, cmd);
-		if (!hdr) {
-			err = -EMSGSIZE;
-			goto nla_put_failure;
-		}
-
-		err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
-		if (!err)
-			last = true;
-		else if (err != -EMSGSIZE || tmp_index == index)
-			goto nla_put_failure;
-
-		genlmsg_end(skb, hdr);
-		err = genlmsg_reply(skb, info);
-		if (err)
-			return err;
-	}
-
-	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq,
-			NLMSG_DONE, 0, flags | NLM_F_MULTI);
-	if (!nlh) {
-		err = -EMSGSIZE;
-		goto nla_put_failure;
-	}
-
-	return genlmsg_reply(skb, info);
-
-nla_put_failure:
-	nlmsg_free(skb);
-	return err;
-}
-
-static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			       struct netlink_callback *cb,
-			       enum devlink_command cmd)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	int index = state->idx;
-	int tmp_index = index;
-	void *hdr;
-	int err;
-
-	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI, cmd);
-	if (!hdr) {
-		err = -EMSGSIZE;
-		goto nla_put_failure;
-	}
-
-	err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
-	if ((err && err != -EMSGSIZE) || tmp_index == index)
-		goto nla_put_failure;
-
-	state->idx = index;
-	genlmsg_end(skb, hdr);
-	return skb->len;
-
-nla_put_failure:
-	genlmsg_cancel(skb, hdr);
-	return err;
-}
-
 static void
 devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 {
@@ -6031,45 +5440,6 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	return reporter;
 }
 
-static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
-							struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-	struct devlink_fmsg *fmsg;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->diagnose)
-		return -EOPNOTSUPP;
-
-	fmsg = devlink_fmsg_alloc();
-	if (!fmsg)
-		return -ENOMEM;
-
-	err = devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		goto out;
-
-	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
-	if (err)
-		goto out;
-
-	err = devlink_fmsg_obj_nest_end(fmsg);
-	if (err)
-		goto out;
-
-	err = devlink_fmsg_snd(fmsg, info,
-			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
-
-out:
-	devlink_fmsg_free(fmsg);
-	return err;
-}
-
 static int
 devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 					       struct netlink_callback *cb)
-- 
2.27.0

