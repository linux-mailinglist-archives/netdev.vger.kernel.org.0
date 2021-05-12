Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E0137BCCA
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhELMtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:49:40 -0400
Received: from mail-vi1eur05on2100.outbound.protection.outlook.com ([40.107.21.100]:20800
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230037AbhELMtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:49:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVGBzbl3Aa89jriSTgYg8v33mcy3/7ZjSSdc8lP/IVE7/CvTyHVROaMYLP27QWiESGy/Wulbh4UeMYeHdfz4RLHbQaHSyDRVu7jl+W9lekTeM2rGfXx1G8BhXI24IPT591wbfYgMSK4HMXeSUlz/bmGhfgKuLT6c2jvOWsGtbxDetEpg72xr6s9Ss8SARrABOQB+jQ8Zq1so+UmvrIk24WK1Qv7ZN1xOb+HdubonnGrM/O58cpedv4q54LRYG9yjd0xo3hsxpE2g21lJzS2I5Yka/+R1mxrh4BCsWOzTxo7/ynMcLhebzPH2P5Ko5t1GD/v89h7uZnr5qw9v0LD5Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oTs87qE2Q85P2BZKn6zudEyOApeJWkDcj4SBJEd0IY=;
 b=KI4hQoyas+RuKZJ/JwdrXtU5cmkZmrYiAu+6Lw2oyFCEGG74jVwdZkYqJdti+VWKFsjuyox2aoprODgiAb7lQErKG5t31jjkgKe5hUiprLXJvwhPuxX9yKjfDIstecJoC4yWb517r28KOBvvrJv6h7V3UyoCgpgO+RaUXnQEJ5WDSX5EAb8PKhr6t33/OjidC00RUY38chGDfSzE4NwEknPcoxw5hxCb6F+2vkpEkdP5bCLPXV3V9mZ5lnf6gfkaEcatD9JY6OvB1fp26e5CX9ch+YqswjkerCM+15u4eeFIYzPg/YZgYmwGa6zN9A6Z6uOkaHEOYH09j90d/quO+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oTs87qE2Q85P2BZKn6zudEyOApeJWkDcj4SBJEd0IY=;
 b=QgpVtbwuTzVZoJOl4sOgOisOUgPvTYacpKc4AJUmY4MnRFJ206CK7c2BCugXYTN+TsxCOFTS06bA8A0+HYzkglK3XqwIiaR4tWGp6zbKbnzA1LvlyN2DuLKm6L4wlow4sNOj8vDgPwsG+TTLoHt6JQPpcrI14178ISj5hipcu0I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0706.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:1a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 12:48:28 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%8]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 12:48:28 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org, vadym.kochan@plvision.eu,
        sridhar.samudrala@intel.com,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [RFC V2] net: core: devlink: add port_params_ops for devlink port parameters altering
Date:   Wed, 12 May 2021 15:48:16 +0300
Message-Id: <20210512124816.4821-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P192CA0032.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P192CA0032.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 12:48:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9ac4c6b-c3c5-4e3c-e297-08d915443d9c
X-MS-TrafficTypeDiagnostic: AM0P190MB0706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0P190MB0706DA413A2DF21AEC30C764E4529@AM0P190MB0706.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdngGtOM8hMsWZmw1iOV97oAAYc1ZQhn/d7SwaMRaaIGEPx6Yj7g/ifD5wFrUy66mZotCWaoxxSx7jLCC4ibICqXY3Jnh8VTciBlS1a8qxIogdexLQOzf0Lle6NuQo6pWdTo+zlCmmnKBNBuMCIoax0CqI3Afd8FwGLeHe3E3YPSz2FDBbLIkBwXavPrMfLnfMrZw3NEBujqcHfdmW5URteUGroRdZYyR/zJuhQyngFgVwD6Zrl0EEDXvwry7w5j0jATvdxvFUfFVOCRlOCFKZ45QfaJa5lg7p3MobJ1iGvbfIL/5ccL4E/7L2BpkgkdNlQa7viVKNqEpKZcLYKw6HiqF+0v/Y5AgmWoND374/+RxiEPyuqN6LXVmseFZgev1A7zyvmRAYssLs9btODQXRqUYDGJynO4GZeaax9Pc0DASRsIoj616Bs8PEYwfZj+5ulyI+mG0DpysbTPtKGGTkF20Yg1g7iS1xZLRbZq+Y6lTCo7xUN0yH0iBOT+yIzzQmnD0NNxhNkZ1L/INaVLO4lJg7faxT0oNSIr0vfcFsmRLZsRtlfsfG23Vi6g5QjGqHncjWO/CQWfVK/S9w62HzSvwYMYCRN5lrACC8Rz9s0J5r+7KbBlkWJw2elwqEAuw5ha2cYQaJaEZcFkUoW4/lb7q2lkAbmfFBlty8gf9Q0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(39830400003)(366004)(136003)(396003)(956004)(2616005)(36756003)(44832011)(52116002)(26005)(1076003)(16526019)(316002)(5660300002)(30864003)(86362001)(66556008)(66476007)(66946007)(186003)(107886003)(6666004)(38100700002)(2906002)(38350700002)(6512007)(83380400001)(6916009)(4326008)(478600001)(8676002)(6486002)(8936002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7OK2JxdE4+XttwbsrspLl9J8yENb7NCQ0pxn8ONSClnCSgWT6tVv68jYuHZ4?=
 =?us-ascii?Q?Cy/MK1PUhvu7geeBAgBnHGlLtyxDkrXytaKFMs00uzbgdHW6ygk29W4a6aKk?=
 =?us-ascii?Q?hs4KROFHodQwt5gLghSMyjN5NLdnLQZ6+8wXHu1sO2JhivtojjQr3uMLxP1H?=
 =?us-ascii?Q?MthGzyltMU5NrCBir2M3ezieIgP8zeAMQaEGtMF/5DFEjwfbrpKb6jpURM2i?=
 =?us-ascii?Q?/3U8eiWG8wK44qM7peTrQ3y5NMuo8JuOg6bWf6aebtAZ76v3bH+GdAXiB2mF?=
 =?us-ascii?Q?/Yx58/LD3LTvfUYWuTuUtv35bRNHffP7OJgZ99AiAt996xH3yPRy5HfcCt/q?=
 =?us-ascii?Q?YSxI16U9j61Jx2OSlKRzA4Vb5qghMDEJqBiWJr6ekrJ5pYop4dtL7x9SFFX3?=
 =?us-ascii?Q?6BxxJhvGoFQVY6RJCPYp7vF6zl8bIx4xx8HnwF1H/vLC0l4nneCs2+7KPk10?=
 =?us-ascii?Q?y748cG5mUvWdX2kfONyfqySHjsoud8LWr5fWV0f1VT83mEhD2CseJuGYutNf?=
 =?us-ascii?Q?Ic8zjPB7j+zPNJqtoTNFsAXNCvVCHlwXJb+kpLOuO5tI5cbEvO7F4dUcXamw?=
 =?us-ascii?Q?k2Olky1c+EA8YqEPhlcVTEBGmEskzt+YoHs+lcjzvarmDzfOtNMb46enzanG?=
 =?us-ascii?Q?lJAbwNFCGfUnVeevYqWHbQUVsq7ZjEGaesRy2bvs2Zxh5lFlpk7ORGJ7NQzL?=
 =?us-ascii?Q?EwISXS6NPBWQn2JkEHksBhADR2G6H7YjXKfZl38iorKCndsnlql18Nprv+51?=
 =?us-ascii?Q?O6mAqZcP0HCQgecAwK7kqQq7guhHYDnsMPKtceeEXaEtQAwhP11bWdP6ydO3?=
 =?us-ascii?Q?6Jn70/sp6kQ9p+goejM4xG302xUL5Lg0BCFkaV5RmCh7NFl6zDm8SzZPgxCv?=
 =?us-ascii?Q?AM4NypR+d2A/aDxITyQsikxnYpNmECq69+U+zAF4upwznSlqG6XqnnJN7gYv?=
 =?us-ascii?Q?mwZC1qBNsWqWWwcFIy5Z6Z23NKbSsnRmhTBXX7MZMw4SEZZPMMd8EzE7Tg17?=
 =?us-ascii?Q?S+jHt2gr3qdOI21s8cdGRNmcmF7Hd5N1Nla+BTqR2luWF41Rlp+PbOlpmxwV?=
 =?us-ascii?Q?K3wwEYWxp1kKIqKzV70cpC+k7k9I1Smi+xOlDKV/jBX/3iUjY9dGHxqDNJh7?=
 =?us-ascii?Q?FkVAzLYqfJXZpmtNc5IETzJ59gTHhn6UnDXcGkf2IPeeAoLYpeENS2iONgm2?=
 =?us-ascii?Q?dPfDdQVsa66pEYw+TAk0YlrLvx52SdJhWUL7m8feyeuwW9riErxNv6RLTiw0?=
 =?us-ascii?Q?bbDFux4H3IyguvJChhuRhrxX7YYbb5+nkCzXHfchZgWc01VbgTUr5BuQofOI?=
 =?us-ascii?Q?Buz9HdIO0xUGitVz8MBgX3Ed?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ac4c6b-c3c5-4e3c-e297-08d915443d9c
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 12:48:28.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTmZsHDcFMoKV2vsH+lOKDnZb+fcfGNz40JxaVZLIffdz8nB628zMXY6+LnxbQfwqJD3MfKYK3f/hGeXzUXKDLX6GjObIUGR2Hh4zPyoYvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd like to discuss a possibility of handling devlink port parameters
with devlink port pointer supplied.

Current design makes it impossible to distinguish which port's parameter
should get altered (set) or retrieved (get) whenever there's a single
parameter registered within a few ports.

This patch aims to show how this can be changed:
  - introduce structure port_params_ops that has callbacks for
    get/set/validate;
  - if devlink has registered port_params_ops, then upon every devlink
    port parameter get/set call invoke port parameters callback

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Suggested-by: Vadym Kochan <vadym.kochan@plvision.eu>
--
V2:
  1) devlink:
       - add commentary description over devlink_port_param_ops struct.
       - add port param ops 'set' usage.
       - remove WARN_ON upon registering devlink params in case of
         get/set not set.
  2) netdevsim:
       - dynamically allocate port params, as well as their values.
       - add base / max values for port params and devlink
         params enums to ease-out iteration over them.
       - separate devlink port params IDs and devlink param IDs.
       - add statically allocated devlink port params array.
---
 drivers/net/netdevsim/dev.c       | 85 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  2 +
 include/net/devlink.h             | 23 +++++++++
 net/core/devlink.c                | 46 +++++++++++++----
 4 files changed, 145 insertions(+), 11 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6189a4c0d39e..74a6a6e22119 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -39,6 +39,11 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
+static int nsim_dev_devlink_port_param_set(struct devlink_port *port, u32 id,
+					   struct devlink_param_gset_ctx *ctx);
+static int nsim_dev_devlink_port_param_get(struct devlink_port *port, u32 id,
+					   struct devlink_param_gset_ctx *ctx);
+
 static int
 nsim_dev_take_snapshot(struct devlink *devlink,
 		       const struct devlink_region_ops *ops,
@@ -339,6 +344,17 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 enum nsim_devlink_param_id {
 	NSIM_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	NSIM_DEVLINK_PARAM_ID_TEST1,
+	NSIM_DEVLINK_PARAM_ID_MAX,
+};
+
+#define NSIM_DEV_DEVLINK_PORT_PARAM_NUM \
+	(NSIM_DEVLINK_PORT_PARAM_ID_MAX - NSIM_DEVLINK_PORT_PARAM_ID_BASE - 1)
+
+enum nsim_devlink_port_param_id {
+	NSIM_DEVLINK_PORT_PARAM_ID_BASE = NSIM_DEVLINK_PARAM_ID_MAX,
+	NSIM_DEVLINK_PORT_PARAM_ID_TEST_STR,
+	NSIM_DEVLINK_PORT_PARAM_ID_TEST_BOOL,
+	NSIM_DEVLINK_PORT_PARAM_ID_MAX,
 };
 
 static const struct devlink_param nsim_devlink_params[] = {
@@ -892,6 +908,11 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+static const struct devlink_port_param_ops nsim_dev_port_param_ops = {
+	.get = nsim_dev_devlink_port_param_get,
+	.set = nsim_dev_devlink_port_param_set,
+};
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
@@ -905,6 +926,24 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.port_param_ops = &nsim_dev_port_param_ops,
+};
+
+struct devlink_param nsim_dev_port_params[] = {
+	{
+		.id = NSIM_DEVLINK_PORT_PARAM_ID_TEST_STR,
+		.name = "port_param_test_str",
+		.generic = false,
+		.type = DEVLINK_PARAM_TYPE_STRING,
+		.supported_cmodes = BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+	},
+	{
+		.id = NSIM_DEVLINK_PORT_PARAM_ID_TEST_BOOL,
+		.name = "port_param_test_bool",
+		.generic = false,
+		.type = DEVLINK_PARAM_TYPE_BOOL,
+		.supported_cmodes = BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+	},
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
@@ -934,10 +973,15 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_port_free;
 
-	err = nsim_dev_port_debugfs_init(nsim_dev, nsim_dev_port);
+	err = devlink_port_params_register(devlink_port, nsim_dev_port_params,
+					   ARRAY_SIZE(nsim_dev_port_params));
 	if (err)
 		goto err_dl_port_unregister;
 
+	err = nsim_dev_port_debugfs_init(nsim_dev, nsim_dev_port);
+	if (err)
+		goto err_port_params_unregister;
+
 	nsim_dev_port->ns = nsim_create(nsim_dev, nsim_dev_port);
 	if (IS_ERR(nsim_dev_port->ns)) {
 		err = PTR_ERR(nsim_dev_port->ns);
@@ -951,6 +995,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
+err_port_params_unregister:
+	devlink_port_params_unregister(devlink_port, nsim_dev_port_params,
+				       ARRAY_SIZE(nsim_dev_port_params));
 err_dl_port_unregister:
 	devlink_port_unregister(devlink_port);
 err_port_free:
@@ -1239,6 +1286,42 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 	return err;
 }
 
+static int nsim_dev_devlink_port_param_get(struct devlink_port *port, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
+	struct nsim_dev_port *nsim_port =
+		__nsim_dev_port_lookup(nsim_dev, port->index);
+
+	if (id == NSIM_DEVLINK_PORT_PARAM_ID_TEST_STR) {
+		strcpy(ctx->val.vstr, nsim_port->devlink_test_param_str);
+		return 0;
+	} else if (id == NSIM_DEVLINK_PORT_PARAM_ID_TEST_BOOL) {
+		ctx->val.vbool = nsim_port->devlink_test_param_bool;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int nsim_dev_devlink_port_param_set(struct devlink_port *port, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
+	struct nsim_dev_port *nsim_port =
+		__nsim_dev_port_lookup(nsim_dev, port->index);
+
+	if (id == NSIM_DEVLINK_PORT_PARAM_ID_TEST_STR) {
+		strcpy(nsim_port->devlink_test_param_str, ctx->val.vstr);
+		return 0;
+	} else if (id == NSIM_DEVLINK_PORT_PARAM_ID_TEST_BOOL) {
+		nsim_port->devlink_test_param_bool = ctx->val.vbool;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 int nsim_dev_init(void)
 {
 	nsim_dev_ddir = debugfs_create_dir(DRV_NAME, NULL);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7ff24e03577b..4262fd8f0a4e 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -203,6 +203,8 @@ struct nsim_dev_port {
 	unsigned int port_index;
 	struct dentry *ddir;
 	struct netdevsim *ns;
+	char devlink_test_param_str[__DEVLINK_PARAM_MAX_STRING_VALUE];
+	bool devlink_test_param_bool;
 };
 
 struct nsim_dev {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7c984cadfec4..e9571113df59 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1191,6 +1191,28 @@ enum devlink_trap_group_generic_id {
 		.min_burst = _min_burst,				      \
 	}
 
+/**
+ * struct devlink_port_param_ops - devlink port parameters-specific ops
+ * @get: get port parameter value, used for runtime and permanent
+ *       configuration modes
+ * @set: set port parameter value, used for runtime and permanent
+ *       configuration modes
+ * @validate: validate input value is applicable (within value range, etc.)
+ *
+ * This struct should be used by the driver register port parameters ops,
+ * that would be used by the devlink subsystem to fetch (get) or alter (set)
+ * devlink port parameter.
+ */
+struct devlink_port_param_ops {
+	int (*get)(struct devlink_port *port, u32 id,
+		   struct devlink_param_gset_ctx *ctx);
+	int (*set)(struct devlink_port *port, u32 id,
+		   struct devlink_param_gset_ctx *ctx);
+	int (*validate)(struct devlink_port *port, u32 id,
+			union devlink_param_value val,
+			struct netlink_ext_ack *extack);
+};
+
 struct devlink_ops {
 	/**
 	 * @supported_flash_update_params:
@@ -1453,6 +1475,7 @@ struct devlink_ops {
 				 struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
+	const struct devlink_port_param_ops *port_param_ops;
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4eb969518ee0..13cd757d879a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3923,6 +3923,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 	const struct devlink_param *param = param_item->param;
 	struct devlink_param_gset_ctx ctx;
 	struct nlattr *param_values_list;
+	struct devlink_port *dl_port;
 	struct nlattr *param_attr;
 	int nla_type;
 	void *hdr;
@@ -3941,7 +3942,20 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 			if (!param_item->published)
 				continue;
 			ctx.cmode = i;
-			err = devlink_param_get(devlink, param, &ctx);
+			if ((cmd == DEVLINK_CMD_PORT_PARAM_GET ||
+			     cmd == DEVLINK_CMD_PORT_PARAM_NEW ||
+			     cmd == DEVLINK_CMD_PORT_PARAM_DEL) &&
+			     devlink->ops->port_param_ops &&
+			     devlink->ops->port_param_ops->get) {
+				dl_port = devlink_port_get_by_index(devlink,
+								    port_index);
+				err = devlink->ops->port_param_ops->get(dl_port,
+									param->id,
+									&ctx);
+			} else {
+				err = devlink_param_get(devlink, param, &ctx);
+			}
+
 			if (err)
 				return err;
 			param_value[i] = ctx.val;
@@ -4201,6 +4215,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 	struct devlink_param_item *param_item;
 	const struct devlink_param *param;
 	union devlink_param_value value;
+	struct devlink_port *dl_port;
 	int err = 0;
 
 	param_item = devlink_param_get_from_info(param_list, info);
@@ -4234,13 +4249,26 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 			param_item->driverinit_value = value;
 		param_item->driverinit_value_valid = true;
 	} else {
-		if (!param->set)
-			return -EOPNOTSUPP;
-		ctx.val = value;
-		ctx.cmode = cmode;
-		err = devlink_param_set(devlink, param, &ctx);
-		if (err)
-			return err;
+		if (cmd == DEVLINK_CMD_PORT_PARAM_SET &&
+		    devlink->ops->port_param_ops &&
+		    devlink->ops->port_param_ops->set) {
+			dl_port = devlink_port_get_by_index(devlink,
+							    port_index);
+			err = devlink->ops->port_param_ops->set(dl_port,
+								param->id,
+								&ctx);
+			if (err)
+				return err;
+		} else {
+			if (!param->set)
+				return -EOPNOTSUPP;
+
+			ctx.val = value;
+			ctx.cmode = cmode;
+			err = devlink_param_set(devlink, param, &ctx);
+			if (err)
+				return err;
+		}
 	}
 
 	devlink_param_notify(devlink, port_index, param_item, cmd);
@@ -4269,8 +4297,6 @@ static int devlink_param_register_one(struct devlink *devlink,
 
 	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
 		WARN_ON(param->get || param->set);
-	else
-		WARN_ON(!param->get || !param->set);
 
 	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
 	if (!param_item)
-- 
2.17.1

