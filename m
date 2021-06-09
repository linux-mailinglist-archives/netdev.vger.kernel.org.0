Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99B43A18FE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhFIPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:30 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:56865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231925AbhFIPS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJ4I9+eFjvi8GO2GNhC3Yjo6dQp83qiPBB9ST/4829VM18kyJKCmqeSNukEj4q4le3dM1/AEGMqhh9XSu5/W8HcHczLSOz/pZPqe8FMT7eJVmT9tkpv+qV/QAJcGc1l5be9i0KrDAJTGrIQW262I+0k/B9RiMkcB0O7FSiuMV5brguREG8uneTAmgXIxadWTZHQNG3+r1DV7uwYRidGfYo2FEnqpScmI2hxfo8eZWlEF10Q9TJibXRO0QovwKP5F51GtZDp0ciQIbECqIHaWlPNjM9l3oCNUdLcnc3Bft14YfzRjeBHogMs+/6RAQ2I/6UVhFkpUNKV6F59sCmn06g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pL45qvyhpnYGrfVEUwWAdXtMGQuRZxauRWQG/2USTrE=;
 b=IzfpdMP+ljojl46eM6YcvMqbIrPmVXYIpsvlL38dd5Sq1WxjzimUi/n5s1IBF/0aHpfGhfFWOQH8yBV6f9eST6jgGkrRnAsQGtmzWLaMAC0SjMRZo4dYGwXWmMRjbLuhwjJPsJ/jEA9w0Ie0xkiIV+co33QKwwbGNvgsL72iaycaZs7f4mzMWH8tWyLS1ps4DCGrZmuOOt+Xm+6NIMP2N+iB/4peDLySAfAWLHo/MZqahC0upl1d7OG2uQTyUVVySmGd9ZYr4FJHY0Nhh6YIiTrvUk9+Ex3PQaofGdYqD86IC6kBVfyfyFul+aFdB2iuVbALUgoKpcgSXVImGpzaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pL45qvyhpnYGrfVEUwWAdXtMGQuRZxauRWQG/2USTrE=;
 b=IMO3aMj/vgSGT0SWWFd7Bdvu63MzcHXm8mXgyhy0XEgSbyn+JAlkoU0jN6Wzw7vWVEoyWQdi4EdsdeSHdFZcYzWn6+fZDee2KlDDImGykThSXSd54kESg55C4chEaUURtEyjCztnQEPrqAdBdSZQbtAErb4x+GWb8knIJ/tN7i8=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:26 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:26 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/11] net: core: devlink: add port_params_ops for devlink port parameters altering
Date:   Wed,  9 Jun 2021 18:15:53 +0300
Message-Id: <20210609151602.29004-4-oleksandr.mazur@plvision.eu>
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
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e1febde-f3c0-4ccf-4bdb-08d92b598cca
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1427C40C29DB1072C1EA3D7EE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f45uFTTjhdtLUhDzhvMzKzKQWyN1EE4hcMQtEeDTVfKdz/6J8p31Uu5+rYFUi1NNJctN+cMl3o8vybIF+pKcV8jF5fjBNFAtPaChHTGwOvmjV6Ygr3OPd402U84+t51pcd082bZFkepOpXdSSj5310f+YjIToDp1Zp7mJYsLfu6sBZcufdisqKK5HF5uk3+26IA5vA05IAC/ypolTnux0ea9WHTQ2yR53eJ6PQ/un7dvE9j1937MkMINxORnHZnTJ+SzhZWvNLhMJpa5cn6SnOnEsb/FRjrXGVdREQMBE8yAOR/OhgxezbieOdgcCfxhvOFicj0J2gIAVNfDwXaRA7L/lFMdDINbyZIi1SRCRPwLolz2KojVpNl6xBHMaNmnbsycfl/ezrAW5wi16DH0KX5u6X9e9EU8j1Zc9I2kaFkacGBEkd/u68aQFZgXUFYcbL0Dzpbiglc9y50R6et20CRaMQq5nsMTXbAoPu0RkhR5ivkER/1zcnjz4VYYlU7pXOQ07acghJLUE9CA8HeulwfERlRsY6Hn9yo8pEM+EXM55KBq3c2n15kwvMYAXQ7eBOHF5cbEy0fkmJjKIlvagQhzPf462FPyMktKSQKimMtv6Ab00tvj5Yx5NX6DdwzH755S9SNfPn4OtDpRrUpFKa8gWrn7MDBqFDRnqN2WbZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WTDXG6+qEhdQsANj+byumv9LtZGeRa0hFFWkXvSE2z8IdXyu1qKEPs5u4STy?=
 =?us-ascii?Q?d4gHr6fR6Ruzuv2RpwLASDP4zNALddT5+LrrnqRRC8TpnRkoms2zaF12oWSG?=
 =?us-ascii?Q?M0f3n5YeI72msvAO17X42xWPfHHEC/nqCWO76g5Iz3/Gsd8+6D9mQS5U7H73?=
 =?us-ascii?Q?yt8vqow9xoERkJEzyyTLYsL7NZ0P8zwJuwJJr6pdEYXXsDs0Z/1Ie99m7wOO?=
 =?us-ascii?Q?E6qAYZ7sSpezxCRw3Me1xOteC8CV1lwCi5RePhDRvEkuG9QkFkSQ0+/VmB4x?=
 =?us-ascii?Q?Pkc5OhIHWZK8yCQnMEfFD0mh984K9CgXXl/bJ2UAVY8yoZ0nxdym2ahv1Lvk?=
 =?us-ascii?Q?g1q2r5/A08gSZs1zsF1n7lXfsca9x2jlOlbkd5bbj0NwG7xlIAVyWJ15QA+w?=
 =?us-ascii?Q?KRAcBP9QwiZ3IEeXsTquKbHqIaZws9Y5ea/cVcweJSUJoFHEypEZVl/EqK9F?=
 =?us-ascii?Q?SX29/RFfChFcAHgTz8mVaLv20CnxG5eq5m5Uh/hXHONaYL2vbpAhvdozaFkr?=
 =?us-ascii?Q?o6x+LdLTqa3+sRyiV5cnptX6cVMNXYDuS10KK0HNKacS/SV6z3dbb37m60Vm?=
 =?us-ascii?Q?Kp5W3HLLYMPbgmX0hwNh1PprfHMYuh8B2jswUMi9Y3n584Za/0J2mAvQ6jSO?=
 =?us-ascii?Q?AGt0Wo/MAsV298qjisJHStlyZ+CwsnVd80AFjukfvtB3X+8D8k2EGmkaXAnt?=
 =?us-ascii?Q?jC9kLT7R1WxIujOhFaGrVi8zmxDbkOxkm7Tf9Xw0o9Dhm4kNbgi7dE0BOvls?=
 =?us-ascii?Q?PQ9iw0zb41i0AoyAPc6IqbPrlhrLR3JTFRZQiEaYW2r8nMG6k29NliPh1/0Z?=
 =?us-ascii?Q?Dv3pcy3IcWJQ9ZbJoZyz53Xi6Y4GGqpY69mVbJ7UQiZb1kgPf7CqnNEUjf1D?=
 =?us-ascii?Q?8m9AS4SMXEaDlsk82y+m3zZQEcd9g4sL3Il6MhOEoXknsjokPW4CKN1eGshU?=
 =?us-ascii?Q?01eFkMZaep03TSdmfp/E8qZJSZf8FQs+vvKLQq7h7F8ZUJEvy9eASOogPlO4?=
 =?us-ascii?Q?v0WfmaEPnPufLWkcmyy4Xa+kVYwTVSbnhzxM1I1LEH45G+i2YhTvmq/v9JRn?=
 =?us-ascii?Q?oSWNiCVZgdkL96bzOlUtDEpVxlhEKe8/acbE3htPJtuR3j4q/wEuWF5Skbsa?=
 =?us-ascii?Q?f2mP6z0ehYYuqUBhu/TZfPdqRtYep6jjvmhtY4OqHCGImIwjJ/Y99K/DjDce?=
 =?us-ascii?Q?Lq2nYYzkfwOtyXv/eHy6GkDt5mfKGwRRwV0IfbWzqF+EYm/ehPW8Qf6xYu6M?=
 =?us-ascii?Q?hC0pX55CzyPjKbSYPeyP7IaDLYkql5Tv7uiKRsutBr0gYh4EvMCqqK3HzYdn?=
 =?us-ascii?Q?SUjK0XREQCa4xOuyZLej2B+J?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1febde-f3c0-4ccf-4bdb-08d92b598cca
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:26.4982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jG+5s41Apwhc/xM96+O+1586nKmKda4EkZ1JVGZAdsxZCZZwQz6d5thL3IZXz8ZJHUu/3SwQ14aNn36FqduFf3OmSbNF97LBlQQ/0z0Qcmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current design makes it impossible to distinguish which port's parameter
should get altered (set) or retrieved (get) whenever there's a single
parameter registered within a few ports.

Change this by adding new devlink port parameter ops structure:
  - introduce structure port_params_ops that has callbacks for
    get/set/validate;
  - if devlink has registered port_params_ops, then upon every devlink
    port parameter get/set call invoke port parameters callback

Suggested-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 include/net/devlink.h | 23 ++++++++++++++++++++++
 net/core/devlink.c    | 44 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index b8c6bac067a6..1d687651260c 100644
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
@@ -1463,6 +1485,7 @@ struct devlink_ops {
 				 struct devlink_port *port,
 				 enum devlink_port_fn_state state,
 				 struct netlink_ext_ack *extack);
+	const struct devlink_port_param_ops *port_param_ops;
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2baf8720bb48..79566a04083b 100644
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
@@ -4234,13 +4249,28 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 			param_item->driverinit_value = value;
 		param_item->driverinit_value_valid = true;
 	} else {
-		if (!param->set)
-			return -EOPNOTSUPP;
 		ctx.val = value;
 		ctx.cmode = cmode;
-		err = devlink_param_set(devlink, param, &ctx);
-		if (err)
-			return err;
+
+		if ((cmd == DEVLINK_CMD_PORT_PARAM_SET ||
+		     cmd == DEVLINK_CMD_PORT_PARAM_NEW) &&
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
+			err = devlink_param_set(devlink, param, &ctx);
+			if (err)
+				return err;
+		}
 	}
 
 	devlink_param_notify(devlink, port_index, param_item, cmd);
@@ -4269,8 +4299,6 @@ static int devlink_param_register_one(struct devlink *devlink,
 
 	if (param->supported_cmodes == BIT(DEVLINK_PARAM_CMODE_DRIVERINIT))
 		WARN_ON(param->get || param->set);
-	else
-		WARN_ON(!param->get || !param->set);
 
 	param_item = kzalloc(sizeof(*param_item), GFP_KERNEL);
 	if (!param_item)
-- 
2.17.1

