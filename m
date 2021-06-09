Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA183A1906
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbhFIPSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:42 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239058AbhFIPSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLdJUUpXcb6tjm36QnZmxcXS+C5DFY0fN9LcZi9wsyhhrSYqcSpo0mx6+6qAWX9vvLsjtTESIVdFfN7Mo+lWzJe8mHs/jWf9sAwl20j0EayOVCO68yErhxeEdhD6JyPAD+hZdy7LeKDFu1TXr+/CHhcN2PlkL7RJUD3hHjUTTp+mB14rn2mnA9zyJ835+8ou2ZJKL+Esb9MFdQMCTeeIpQtqB0YIV/mVpWsUAEH8MNcTTcbtQfMUSJQe75vdvY8gKJ956WcyaqkAo5ddh7FCZX7y2D7tYbTnj9dx92YPsoYMH21hGD8a/UF03Fq2xRO8RXY/75wEaKIUigHMqCL6fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcK4Qxd4NM4B24hUsxAcq5tVaCjmvwvP3MHHAXq9ryU=;
 b=jZQemISUJ5ojskOWYWO8yE9IRo4jg+PudnwaqXeFloDYaV5GzvGZjXHZVLbeaKPV68nEOD48yFLO7g4WYW+ZDplItngPPQNTfmdCrVJ86BSLu4ZkMUIhfuw0xoVhfxKAhvqK6OeN79d7bwyFXnjpGy9Ba0NQJX3lvPsEwx4Mxnrrvl0imqeEq4+8HBc/1Z4ynpz6xadKpKOCwSfUifeeIX/N2zdDX/tzKeTQn8CQ+wF6ZsqATzkHIFDGY81ELnrQ17XuvonHOb1bqtGzG26qLo3sGdHTlY+LpbgzDp09c7hpwOAbjNz/XYByIWccUu+icVkNS8BUbh6H4LsO5Xrf+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcK4Qxd4NM4B24hUsxAcq5tVaCjmvwvP3MHHAXq9ryU=;
 b=NUxT8POBgDpxza+HjmfIymH0S3t+iTJ1cjKPGvAHAapFahbXMdGWVluEJh+kdMlQqH1xMPYgVMZGSTipGs5IN7kFZWsMY/ex2x7Csb8IiYbaChbfO/0COW1t9uJxP7vZZgYg4QXo3DQdISMV63LG0slCJHs1Em3v5FLgWFnHa8I=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:38 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:38 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/11] drivers: net: netdevsim: add devlink port params usage
Date:   Wed,  9 Jun 2021 18:15:57 +0300
Message-Id: <20210609151602.29004-8-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a92472a-d448-4e6d-3b53-08d92b599417
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1427D498666456F4EB86AC8FE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:381;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNzBWq5VNoruVS82zJRleoNjafT8YNp2QbHP/keZ9PJn/mcFUrbZ4+Uu3KhzyL6f9j9/yD9qP8cnqxcGHudL8u3ujOQwKRJ+HT3X1rmOpe7myI2ido4QdCDhzGIhXDE+d64Q4OzZcQIV/L5hBn8oRvPGvM4tssXsDy3UXd4gtDSf0e/U+k1vO+9oiqGhaPJuUCNEOXPPv9/7PkstoOD+TWGHq90ylBS5uORtMZeZSHmYxe29e59YvQABXiwgCjvZp11Hm+3v2IUVQpQeQpDc8b+vNbrS5kRATvPy0y/yjJiomf+Uu8BaglORujwp90Dq7S/n3xNvLceOyzSD1C6U+/twg0xkRB0eljwBL7kgoNhIeErPtDSF6SDzM8Fd9GzweqM02LxDGc4ktLwqyRCq1MFcJai6pzrKahgm9+0S6rH5D3giY7k339OWvhYIojPN6eaz1ZHI5RI7Pu3Avuzs4EjEbCA1lHarcjf2PEe302+YP55vuvcG0+X2qpQ5xK4lB9/REYinxQbJ8z8I+qVprnxq/fCDHS71cJu36930UkE+z66oLynRV3k1g5OtVbzQ4b+Tuz1a1/PGZXp2byGDoQjF2Qr6CCuIDcrevj5VjfbLBy96TcpBzCFZw4xGhZKKs3ZYPp/zpDZ9YXVkR779gxd8XRfdzyHZp2CoaASNJWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bdgSIszsGRH8kny00uJV0ZV6nBREifjrUsIYytSwTTufH7UjFfEhJ7BCZ364?=
 =?us-ascii?Q?+PIr/q/47rAyQ8OtazEkqET+Mz3VHagqHQVNGCA3w/mIywNe7fStQNS2WlHA?=
 =?us-ascii?Q?J4w2wET3W8W8gx9mft7e7nGZloraxT/LzVSl4lvX5OTvW0dwOsoQNunVaP6R?=
 =?us-ascii?Q?UvO8/MIJWStW9MSa9HsKKvNYk2pGcXvBZiOduR2JvjB1qV7bVlAQuUEgy3Zr?=
 =?us-ascii?Q?0ZV3CLVgfwP/fk3PZyDfLndMUnimAhHpdsAgYzcsnkN/F7xVMuQ2LcdJZBp3?=
 =?us-ascii?Q?FMQlmOz5SphSlL2/p+4QDsL5tezq2/2WvqL5FTfA9MUkakHoY8FgG/TTz6Tx?=
 =?us-ascii?Q?FICjk6Wk+1xXmOY6cKF8SVLtdFzsHAVwppEVQziSNc9TtTS86+2o+nDc8WIB?=
 =?us-ascii?Q?KYuXahIcynZdaP/dQulp4oAPZwGYUFLmScCKHyBEPuNmC8tdFZ+6aOixz8LH?=
 =?us-ascii?Q?e+SbDt05joE0WX/4Pg/CIWWQFFBvVRM+9sCGyr5oyrEgppv4Lf64MzP06PAt?=
 =?us-ascii?Q?YrPFUJV5BIdsWJznM6FD+ZVkrOqIiFxblRP4xZ/ncENxXD48dEpyPLWiDLZR?=
 =?us-ascii?Q?Xvj7ruNGrMN54bIuDVvkmmNcc8vt7O6Fx8SZAzYr71TLUflckOw3/WDyfG94?=
 =?us-ascii?Q?ivIrruN2BLmtF2AWUCeufE7p73QyEHmQEbODUjD7iL1RiS/cZG1qPgHBELO6?=
 =?us-ascii?Q?BvzzXKVNMpS5X5/u9ODvQJ2TLtYMwKdriU0g6S6SPzv3HTX8iPXNKOA9Bzua?=
 =?us-ascii?Q?t3T9H50vck7gf8g7dOOxbrFUotZA+9ysdSGMRLwgf++4ZBWuxc3AryXROLz+?=
 =?us-ascii?Q?Off2uLXRYCdcMSfL8nNY8lOYpo5AIEY9XyFUkampf0cAkBTggMeD9GScUYoa?=
 =?us-ascii?Q?4TSspFX0uqLrHUpZAIsBF5YyYQlFaXZaKDOMOGcBcHtMkaPMTASJA+9kg31P?=
 =?us-ascii?Q?IB9N0NtHLGcvcLq87cObgLHpLHhK1zFCQuS6z/DqyjYarXcCDdX+MvNmeDYQ?=
 =?us-ascii?Q?HByYS4snEX+mKiIkm+JFYEkUIHXTKV70S2oMC05Nl7o+4SDBQbPYVnqOFFhx?=
 =?us-ascii?Q?oYpOU+ES5dP514f8ZAMekApg/IZOcToSI3FBdxzVHEsmMXr5+LJt+Q650nBQ?=
 =?us-ascii?Q?aECBlspnJL5PK32a+Ntr+cxzw07quOBh7eO0T0+ATwyeMOvR7qUAe/K/VF/M?=
 =?us-ascii?Q?FT/DznWA2QenSkJ12qxRpWRSQ30xqMcaebVAYJKPR2dKP8h9DjkA4pMg3mL9?=
 =?us-ascii?Q?LNBlkuz21gT0QK/wo9NUXegqWb89l+xnh0SKQDrJFE3Xj7tDBnTBhA4GCFsL?=
 =?us-ascii?Q?WogWXuVoziFbG2BBaWyA6QdM?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a92472a-d448-4e6d-3b53-08d92b599417
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:38.7255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZE0SYBGQam47a3GZU7RZy9H/vDwJinfdPSbQAnKyxVHoM2yvg8cfBstCSfR8Hyza3DToWCObB9L1jbHWQOSwFCaQXUCbqQvn7oXCju1rUcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add registration of test parameters that could be altered (or retrieved)
using the new port param ops callbacks list.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/netdevsim/dev.c       | 86 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  2 +
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 87e039433312..82ca69624b59 100644
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
@@ -342,6 +347,17 @@ static int nsim_dev_resources_register(struct devlink *devlink)
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
@@ -913,6 +929,11 @@ nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
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
@@ -927,6 +948,25 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
+	.port_param_ops = &nsim_dev_port_param_ops,
+};
+
+
+static struct devlink_param nsim_dev_port_params[] = {
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
@@ -956,10 +996,15 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
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
@@ -973,6 +1018,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
+err_port_params_unregister:
+	devlink_port_params_unregister(devlink_port, nsim_dev_port_params,
+				       ARRAY_SIZE(nsim_dev_port_params));
 err_dl_port_unregister:
 	devlink_port_unregister(devlink_port);
 err_port_free:
@@ -1261,6 +1309,42 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
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
index db66a0e58792..6f12623191ca 100644
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
-- 
2.17.1

