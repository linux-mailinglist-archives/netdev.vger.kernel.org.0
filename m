Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38863A18FB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhFIPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:20 -0400
Received: from mail-eopbgr80093.outbound.protection.outlook.com ([40.107.8.93]:47918
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231462AbhFIPSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzLbMtcDDYetwDei4OAUOCF+UolpijLISC+fSBRLsDYrQhCNoXniagWV/tt8x1PJk30h0rF8MvKvGnFUHMcCeGdCzw+JlKTVJhXFZb8auYg/2IvYYBWlsMVmBps+wtnjbvb0dGQ0aYTFEWM5CtZNvC+f+cQK84BQEnF0tOWgr5EJjglWpBG0b9JDqO9PFTBCv7o29RgGlrtYHpb2c9pgqRBmf4eeKbiP6XytF0XeAFoEYXa9Q18o5b7AaSpK1YiQpsBtbXyVsmCmiXrN6yYHKdEKFuUeGx3pIuuSJFEfmKS10h51IL7PMb9ghlJmM5+MY+xbNgrhwVPfV3liSwc5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+qg66OwWzrIdWEEIrfhMXzl+KEFQbAiQOehmW0xEX0=;
 b=iKXVII5sr8bvPtbKXODeZ730gAG5iRMPo7mJJRwm88VMi8WEw6kf8HqyeUS5al+mroWSEWKaAl21dPuAhpdRrHjhsDwlpoUBCtS3DEAw0tg5WF2UyLpTbI5cYNg6jM0gSjo99NXUPp4RyxFNMwTPckl/5mus8UNvwWucEKYfk0CoNUnfHCik13+3BC1hRr3jumFCnjCUD1u3ZtqycFAwO0/jHlVwRn7AD/7c4YK/CQ8mJnOldcjfT9TUT5KgOE4MVyjKEmn5+2VbSZUWYJ97keOANZQzBtcXu5+Cxy6+Yc0mkHni8u3RH36I8o4IV4uBsi/o/2OGN+zDV0u8TeRTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+qg66OwWzrIdWEEIrfhMXzl+KEFQbAiQOehmW0xEX0=;
 b=ng1mOcebFc3PQPr6D9b+6vhqTYP7hp/Mn7nkutUiMSnFF7YBz3XJe3cb1PGY8lLG1jj4rkh9ZHce5O8HOeWl6+Nxh6AKNLqzLqo6fLtFuNQeJLo9CNgr16LfF7BOQL9I3Wi2jOz093DvDbC4aXMV40J7cFwKuFoSeJKujquIypM=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1427.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:17 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:17 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH net-next 01/11] net: core: devlink: add apis to publish/unpublish port params
Date:   Wed,  9 Jun 2021 18:15:51 +0300
Message-Id: <20210609151602.29004-2-oleksandr.mazur@plvision.eu>
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
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c79d80a-d3e8-4819-2fb8-08d92b59873a
X-MS-TrafficTypeDiagnostic: AM9P190MB1427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB142704DDB07381146E50903CE4369@AM9P190MB1427.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: neTyJqUWh24hZdv2l4EvlRxd8nAbxGaVycg2pL+61v+A8yCZ7Y0tdTYcAWUMRgwA/bwdJTDIivgOEPjmXDw+5YAnXBZOjEao6JRtj/rYTcPxZPpl5TSX2my4p/802s+f708H3n4ivV8ztmXdnoaNQCW8EF2e74+tJKEgfjTXddKb252GYlPN9lQoAOB8Yp+SrkbJqWGphxHbhTZEtHRO9ueXUWQg5urPtNw/c3KDKDpRDWMlgpQEVFUCQPO7eTKYGCMY7XzyUN+le3ptPUeHQvONcvqiwcMhZClWlv1ihhglAYSI/TuvbQ03ewsW9P47MOvJlWjGe3XSYJce6DytvCq6JYDECFoV9KQXrAT2nxGol5q3Nx5ExIXSxdBss7nCcMXKD//E5/o8xDziogisT+y9Qv9SESU8LkhaimYBa/oAd2UMtgI4MTNYfrDIq6aT/6p8vHhcwV/iieYJa9aq8i/hjrVq+m/i/B604ns592UrvUol1HqBivoMXzTbnP9Iq4swPaLM2rhKdGbYNHs6O2303VobbiklWrgjTgNQSmk/4pgC+Zna1fCUdeCpExrYG5Y5jW8gG2CqwWO73LoC2VlfVMTXPcPxP7LutirFGnjAvoB46YYKr56gOfU6osncGehtDaV4xfb5wiCFykrTRJ3CE0+lloFr8dnd+r+qfuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39830400003)(366004)(83380400001)(956004)(52116002)(2906002)(1076003)(186003)(66556008)(66946007)(16526019)(6506007)(2616005)(6486002)(6666004)(26005)(66476007)(38350700002)(8676002)(36756003)(86362001)(4326008)(54906003)(5660300002)(478600001)(44832011)(6512007)(38100700002)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b9REdH+TqGyygOofNkoO3U0FXnAKPZL04zL00WnEK4x15xvPa7Kg+cXFHTDk?=
 =?us-ascii?Q?mo+FuWOD09DgymF4GagODRlnomuZpxM7G/mVgcVjvBh89ItW7Cn2E02f/n6y?=
 =?us-ascii?Q?OdP3AYMe7V4edLe957qUAtRUDGo+dKAvOnW6vwqJV+OTqKfbCdwdDSOkQwQa?=
 =?us-ascii?Q?u1p2d+iik/5W6fT2mLv6ZXfWSG2s7ifuqPCIH7Oq5eQ4X2SqRcWA9qWpU2jB?=
 =?us-ascii?Q?rLNZTGsL4UzoMscgtJ4UxXCKs1Fl1+IoOyOTMAj498mkib1ZWP4YmIsuYXIZ?=
 =?us-ascii?Q?BBNcm0s/dORLbKBDFwwouniBSo56nL0gaugJNaRFS2mHVvHKJ/2YSfdVaivG?=
 =?us-ascii?Q?5UEcV6WR/SeGpVAeV/cDfu5HaIwKTeQyRo83c9Auasc4ea20FQappxI9RCvI?=
 =?us-ascii?Q?CD9T916ok6tnTd1LPy6ktK5Th+C2nKF3pd3BMDuauxVXTXbDEGruaa3V7fku?=
 =?us-ascii?Q?uz+qsZGEEZCpjR08QQbXq0WZFbBO07MRaYMkfCeuBJFg1iHIbIZ84ahBsGn+?=
 =?us-ascii?Q?wRvkMWzZ6GO59bTUUwzMC4CW9V5cbPq4/fHtZiLdgLMdoCN1vIowqqxaG9AX?=
 =?us-ascii?Q?Lrr4bajvaqTA/9cXYs8Eu4t7ekUaSTwqqTOPGz+lawVyYNBOpcTnxcliebOA?=
 =?us-ascii?Q?oI4RM87oaL6ViufjtMt7/3cVUEVwRA5/xCsHVDoJ/sPDPo3NS87Zpz/4yMYw?=
 =?us-ascii?Q?mZ4XYK1HmFsK3++mFA3WT9DziT3qWKqz9N+fbWPhifavfrwRw2qzNohYbVAE?=
 =?us-ascii?Q?0f9kEV1rOoA4hXzx2/VyV04vqZwa85tQ7QAtFuPokIe2+XWxBd0O0nNGaNGU?=
 =?us-ascii?Q?6suC6O7WHjwoCBTkk1L3Yx+ogXXwxBZSz4Pd2HNYS9gL9j69sYeOhq7JyIkp?=
 =?us-ascii?Q?9mOjwM+XZXcDypZKh7mgYfYaCEJRE0NWdsNG1KOcxgBLPwHiChDIV4fd4xF3?=
 =?us-ascii?Q?Oef9TNEO2NFqwif3j3e1vTk1meu2rEgCvWEhtOqLV2B5BSnNhKx+eyBisU+J?=
 =?us-ascii?Q?zDZhywc76AwokZrxYlEt92UIF4jDJ2ZU/X2UMxeT2yHsNxHTqQh8X17FB0c6?=
 =?us-ascii?Q?H99sKzfiMTyHcW8ZadHgdyQhSGlj6ypeFv2pabIx62Y+9mp+Pv2vaqSxng2b?=
 =?us-ascii?Q?LyEnH5+dtGBRVddleyr2+xJc4iINTTVhdA1bpgjgV4Ah7Kp9qFBzCJ1F1dhR?=
 =?us-ascii?Q?8rt/ZTJL+dQ1OmrI5YjgpaqEMHX48pZq1Cq4OrxbrElnP/qq/+As5bAALhxr?=
 =?us-ascii?Q?NwtuT/YCbR/MU8/t1TUFTyKovfkSOu6zul91o/roVz7pHLOBO1H3DwPiyebW?=
 =?us-ascii?Q?sXFNy2J6sWHHLabIcCxtt9/C?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c79d80a-d3e8-4819-2fb8-08d92b59873a
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:17.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgIHg7mLK++/jpDwOaTIviBrOrvZT4CIRUtDGlxP56CudhGDjrvDmnaI4gBtqntJkC6L7ZGn9VD94Zjlj3+xUjxCfyU85zZv+Ecaw6LO8eU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1427
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

Kernel has no interface to publish the devlink port
parameters. This is required for exporting the port params to the user space,
so that user can read or update the port params. This patch adds devlink
interfaces (for drivers) to publish/unpublish the devlink port parameters.

Co-developed-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7c984cadfec4..8def0f7365da 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1575,6 +1575,8 @@ int devlink_port_params_register(struct devlink_port *devlink_port,
 void devlink_port_params_unregister(struct devlink_port *devlink_port,
 				    const struct devlink_param *params,
 				    size_t params_count);
+void devlink_port_params_publish(struct devlink_port *devlink_port);
+void devlink_port_params_unpublish(struct devlink_port *ddevlink_port);
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val);
 int devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 69681f19388e..e43ffc1891a4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9265,6 +9265,48 @@ void devlink_port_params_unregister(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_params_unregister);
 
+/**
+ *	devlink_port_params_publish - publish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Publish previously registered port configuration parameters.
+ */
+void devlink_port_params_publish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (param_item->published)
+			continue;
+		param_item->published = true;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_NEW);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_publish);
+
+/**
+ *	devlink_port_params_unpublish - unpublish port configuration parameters
+ *
+ *	@devlink_port: devlink port
+ *
+ *	Unpublish previously registered port configuration parameters.
+ */
+void devlink_port_params_unpublish(struct devlink_port *devlink_port)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink_port->param_list, list) {
+		if (!param_item->published)
+			continue;
+		param_item->published = false;
+		devlink_param_notify(devlink_port->devlink, devlink_port->index,
+				     param_item, DEVLINK_CMD_PORT_PARAM_DEL);
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_port_params_unpublish);
+
 static int
 __devlink_param_driverinit_value_get(struct list_head *param_list, u32 param_id,
 				     union devlink_param_value *init_val)
-- 
2.17.1

