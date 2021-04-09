Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB85535A2F9
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhDIQXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:23:21 -0400
Received: from mail-db8eur05on2099.outbound.protection.outlook.com ([40.107.20.99]:54048
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233864AbhDIQXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:23:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdIPyZUlHn5ociHTj8rICOO3fQEmxj7cu9FxZS3wqWEZ/6vEFUnVjZ4ns3F4bqHu1SOfU+eLh56u5w4ljziulA+FPtcdE+GnrjUfC1klaPWGhfJbhAs9bSnsQqXP98PT0Rh/FlS8DWXJ6ArYUnA0el0THWbyDACdSVQLAExfdpDT2Lv6V4Np4OkKNDFvWDzX601uq9AtO3qbKRzz+UTFYeSTLb0Z+O93VBYAMZjsALWzZxXno/jYCCdnxQah6NBgUPybk+m8zVbGTXCeLvKD7CwAjZAmGfTGcQ1YmUltEiDMypzYvI1NDgF4tPLBQOx/kBX/Ec/I6pz/FAc9uNnArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKfztBdjge3U1V2fiOyv1CNsjjeanT/hzj03MUWBLPE=;
 b=iYEYYMLsY0Lu7MmHN2a+wWnqTyPi3SLFnf42satvBXFqHfnjawzYTIr3xVjSgSDVYWGBabETodPZwHvZ56q9W2ErqEG0nOIbgUa868ac91aqUAokGDdl620+4Bl7CG1dlbq0D+ofFdOR6ifv0s2bebXdN/GaEk57uDeMbPO0hGpDzzwxZlhNPsvWd0IRjfXzoZGqgF2uKBFtqRu5YNFUrbstLlmyKohWGKzbiBFON4NGWqcaj19c45zv+gxWGtB3AsuFC5e9q1q8Pmy2SThoPW3UFP7VkcVURiB/glm1yhOihvcgT21ijxzHXmhvh3348bZgjHeB1i3CquAEAaVxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKfztBdjge3U1V2fiOyv1CNsjjeanT/hzj03MUWBLPE=;
 b=g+y5GxjTYeKagdLy2LsmIVrzGicr43I8HLc4weqt3bfxuNLY/cGzX+qICv9pDbs0AI2L++g/Ew71NH3kWtVn9V3BCWSsiyxIR++UKOXUUwQNL7fzHx8TlZmu+d1/z18lqUhEJ/SQEJNrpzt5mRoRV+PRC+DXnFH7l9zI5XzlnJI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0147.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:61::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 16:23:04 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a805:b626:1a05:9992]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a805:b626:1a05:9992%5]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 16:23:04 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org, vadym.kochan@plvision.eu,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [RFC] net: core: devlink: add port_params_ops for devlink port parameters altering
Date:   Fri,  9 Apr 2021 19:22:47 +0300
Message-Id: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0097.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::12) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AS8PR04CA0097.eurprd04.prod.outlook.com (2603:10a6:20b:31e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 16:23:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54a0995d-2f7f-467f-ac77-08d8fb73c0b9
X-MS-TrafficTypeDiagnostic: AM4P190MB0147:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB014720194F0CBB1541B1904EE4739@AM4P190MB0147.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VpF5iOYyC19/unmlbgd4XbyXBLCHSAcIUZpeJzrHixNIU2ktIm0VaMrz7qOGSzBEi2Wel22xnn8RHP++w37vSR3e9Ab0hOovlSrYucV3CKHYelUc2u7tmqQEqkNMK+K6HHNukUcA4kN8LQMvgWpQqft2rvjAxc/TnI4jDY4X+zNL4WU5vRgS4RbVBoeaExvgI5Kv5Y0QMqdchrr84FMp/xN522xEYMJv/WaA8OEkmyTGJqa+i/iiR3W7r6SSzwX2kpK8pWVBDxmLWlozclwRIBpdITac4rREomRw5mMlf02U6M6EzCSupXEPgDt2ivMgGrhsYGV6C7K9+WbctkqZdc94C7a7jjKOmw30ALntLPaLHL7HrLLF63JpdpxTjVm3oLikdvov3lk2hvPSpv8s4RRrFJKIuP2PrpbB79m3NjQTWh+3Oy8ZTmkElNPqcTmQkridkFJxExqJaALqUqHB6/jPh2uDtQYdpEjLU+UeEwWzR4Cw/4uDk6FEgzZi9oUTsBbajORUU4ImSp7AgVFjCAxJ8gXpPJYmRlsxdtpMcuZUF/zTVyIAAtjObFGjRtuPW78mOuwu13xKKdTSjIx2fGV1vzaEQOhgP0To6Slg9tqn8Dk+SP+sSr1KV4ST6pmH+z0lU1DJx6kwHoVQ0joH8ztZKvfrJz1y5zdd+kpXRYREJ08p9owClVcJsZ+WgRN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(136003)(366004)(396003)(6916009)(44832011)(186003)(478600001)(5660300002)(66556008)(956004)(52116002)(8676002)(38100700001)(8936002)(6512007)(26005)(6506007)(38350700001)(2616005)(107886003)(83380400001)(6486002)(4326008)(86362001)(2906002)(36756003)(66946007)(66476007)(316002)(1076003)(6666004)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+5Kb8NU0fQciREgCCBz9FaYg1wW45SlxH4i+xxF/U3Xi+Ck/pJ+FoLlOJtF+?=
 =?us-ascii?Q?yV645T7i+/Mo9vkObG2OUFFtEAN2SFLbDA9KIetkaaoG189SL/+j74WbwU0a?=
 =?us-ascii?Q?xZVJCVStycwGNVO2mIMaGbhamytTdX8biRaucTTIagFq2bANu4VLEFS0iupX?=
 =?us-ascii?Q?Y2KMNgtCDMUVjtOpGTKtBQ98/MffC7Ek/zvFBCorA6IFzn3+60jq8S1821PB?=
 =?us-ascii?Q?xMWQia/ErR90eBPhnG1ul05TbpNNQwvbuJMpfgJW9/7YxkX8IvyHSYMq4XZP?=
 =?us-ascii?Q?B4PO/jvuac3ugxS2caakUAT2CV/N2WYJDoFijuyHNwuosT7l1SUJdyzS+cVS?=
 =?us-ascii?Q?aBXODJd/3GpSIAqLlR6ynl1QZEG7s0Es+qZnKHkAz9fTayjDGodxT4md4Tsl?=
 =?us-ascii?Q?oYWzLngYh1VBxceK63/q1P+V7kE71FMYud0NsRVLSf3diJECsmj1O5dyD2JP?=
 =?us-ascii?Q?/zY/CNnQcMBz28Z+6uuPIL824s2dS2Z0tJacxfnpPO5jkClIZBsdHoVZz79u?=
 =?us-ascii?Q?jvjG6AA7OhZcUtHnlr1IcO721GOatRUDCLrU4YLQkW53rCRs+8iMhNuJwq4I?=
 =?us-ascii?Q?Or6T446KYwNUmtMoMm0bIygqbShxKUwFP0P9R127svY1L/2CKA8nu2vpFJw/?=
 =?us-ascii?Q?fBDKWY2BWeKhQd92sU5o51oQ2rmcXNbZbDFNaBRuPKioOHFODmIUaNkUapds?=
 =?us-ascii?Q?6zMo1RixoWLmBQPEElvqBSS+lq/OZufbzm5RFRyGC9vHuc1K7dPOjBeip4GZ?=
 =?us-ascii?Q?CKQ4sk7rrz1xjdsXc6GfUdfKIovJ0VnV/gzIjgW2eqLCGOxSurjiX/Pb3nQN?=
 =?us-ascii?Q?M2z3Zc4sbrmVRYZsMdxT9VYHtbqyEHaikFaixloAxWDh6ik6zYS1aCLZ3OGC?=
 =?us-ascii?Q?9AxjXo+rZ6oPieiFbAGp9tK+8UI6Kx8IvgwZObbFhGQChuHxqzse4jWEi3rn?=
 =?us-ascii?Q?+Cusj/g+x944v0PyH0Dd6cB5jZK8uUTrgrncwGWUQnUgu/ZnnXKm70CLdcjh?=
 =?us-ascii?Q?Hkg6z3o9fTFhn3kv8UH+fAeeYu9lYCdUDVDF7fPhuuec7s6Rglcwdfx4PfYY?=
 =?us-ascii?Q?1Axx5xQC+lE8r0bR8ol0E/gMjnfPcJpqPWfdOGUPg3Sw6M2a8iJjG+jFR33V?=
 =?us-ascii?Q?o+4RqiRdYa0ttzvhbUpuFWAjysMH+tcAWhNB6lv8loJjLOItcS6WVDSRd6tk?=
 =?us-ascii?Q?SLvVc+MpdGg63rRcPWJea/MaxRf/JrEpmw3qWSkZvZJvbdhntUc6rqcdRVrD?=
 =?us-ascii?Q?Esbf5tfX1iioXx9bGezyPL1JI99rVX+ZHgfY6q2EdFPiCPgKmawRvvj2+lTJ?=
 =?us-ascii?Q?4Fn6PJgpcS6RtRtq7Gr39XPi?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a0995d-2f7f-467f-ac77-08d8fb73c0b9
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 16:23:04.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ELfIRsORijNi5cDfEkD46f4FNdFnsOEAER8fc/kN+Xom9yxzA+ai5za4DqPtaErxlExPscfi95F2A6BJsA3hubhsQyXkLdsXl/P4Ah9NZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd like to discuss a possibility of handling devlink port parameters
with devlink port pointer supplied.

Current design makes it impossible to distinguish which port's parameter
should get altered (set) or retrieved (get) whenever there's a single
parameter registered within a few ports.

This patch aims to show how this can be changed:
  - introduce structure port_params_ops that has callbacks for get/set/validate;
  - if devlink has registered port_params_ops, then upon every devlink
    port parameter get/set call invoke port parameters callback

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/netdevsim/dev.c       | 46 +++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 include/net/devlink.h             | 11 ++++++++
 net/core/devlink.c                | 16 ++++++++++-
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6189a4c0d39e..4f9a3104ca46 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -39,6 +39,11 @@ static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
 
+static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
+				   struct devlink_param_gset_ctx *ctx);
+static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
+				   struct devlink_param_gset_ctx *ctx);
+
 static int
 nsim_dev_take_snapshot(struct devlink *devlink,
 		       const struct devlink_region_ops *ops,
@@ -339,6 +344,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 enum nsim_devlink_param_id {
 	NSIM_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	NSIM_DEVLINK_PARAM_ID_TEST1,
+	NSIM_DEVLINK_PARAM_ID_TEST2,
 };
 
 static const struct devlink_param nsim_devlink_params[] = {
@@ -349,6 +355,10 @@ static const struct devlink_param nsim_devlink_params[] = {
 			     "test1", DEVLINK_PARAM_TYPE_BOOL,
 			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			     NULL, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(NSIM_DEVLINK_PARAM_ID_TEST2,
+			     "test1", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL, NULL),
 };
 
 static void nsim_devlink_set_params_init_values(struct nsim_dev *nsim_dev,
@@ -892,6 +902,11 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+static const struct devlink_port_param_ops nsim_dev_port_param_ops = {
+	.get = nsim_dev_port_param_get,
+	.set = nsim_dev_port_param_set,
+};
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
@@ -905,6 +920,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.port_param_ops = &nsim_dev_port_param_ops,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
@@ -1239,6 +1255,36 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 	return err;
 }
 
+static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
+	struct nsim_dev_port *nsim_port =
+		__nsim_dev_port_lookup(nsim_dev, port->index);
+
+	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
+		ctx->val.vu32 = nsim_port->test_parameter_value;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
+				   struct devlink_param_gset_ctx *ctx)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
+	struct nsim_dev_port *nsim_port =
+		__nsim_dev_port_lookup(nsim_dev, port->index);
+
+	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
+		nsim_port->test_parameter_value = ctx->val.vu32;
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
index 7ff24e03577b..4f5fc491c8d6 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -203,6 +203,7 @@ struct nsim_dev_port {
 	unsigned int port_index;
 	struct dentry *ddir;
 	struct netdevsim *ns;
+	u32 test_parameter_value;
 };
 
 struct nsim_dev {
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420db5d32..85a7b9970496 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1189,6 +1189,16 @@ enum devlink_trap_group_generic_id {
 		.min_burst = _min_burst,				      \
 	}
 
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
@@ -1451,6 +1461,7 @@ struct devlink_ops {
 				 struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
+	struct devlink_port_param_ops *port_param_ops;
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..20f3545f4e7b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3918,6 +3918,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 				 enum devlink_command cmd,
 				 u32 portid, u32 seq, int flags)
 {
+	struct devlink_port *dl_port;
 	union devlink_param_value param_value[DEVLINK_PARAM_CMODE_MAX + 1];
 	bool param_value_set[DEVLINK_PARAM_CMODE_MAX + 1] = {};
 	const struct devlink_param *param = param_item->param;
@@ -3941,7 +3942,20 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
 			if (!param_item->published)
 				continue;
 			ctx.cmode = i;
-			err = devlink_param_get(devlink, param, &ctx);
+			if ((cmd == DEVLINK_CMD_PORT_PARAM_GET ||
+			    cmd == DEVLINK_CMD_PORT_PARAM_NEW ||
+			    cmd == DEVLINK_CMD_PORT_PARAM_DEL) &&
+			    devlink->ops->port_param_ops) {
+
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
-- 
2.17.1

