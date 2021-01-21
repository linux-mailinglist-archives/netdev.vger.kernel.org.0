Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1EB2FE8CF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbhAULbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:31:05 -0500
Received: from mail-am6eur05on2133.outbound.protection.outlook.com ([40.107.22.133]:51136
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729880AbhAULav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:30:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbNPYeo8Y4Ja6NX50Xmih0wMlvJoRUJzaNP1e3xKS8UAVakRe9MOI6y4dszT+aa8llSx3afHwb93eXIEh3f6DLAXiABflZbvZ9p0JOv77wcIHz3vMy9rLn5BbHq18X7jbJNVAJaEgnhdhx0LvoKS25FI+CG1b93LCl4fIwaFj0eiWRDBAevyvLHieOkAlRCg7lV3duyV+luB/qza5IwZC6ogoeUGdOnhRE1e/VlKq4H+VC6ULMjk9eCnZgrS4BxCHstLIPg/mfCJf9nw7cvW4xxsg5hUf3KCb3Ohk88fqEUi7Ipxr6eM+fRPuuzJVqcfXVs+8tXlqAY26t/8S4VRLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjGD3YOCd69yOIvkowREBl1YjvoACyJifH8OpssY/k=;
 b=SW+K960jOKb7DIMght3dwPIKbTNzBIKNnp78az4TuxdV/+ckvVGJqYeDndbYY7rw6B7ouR7LYwOyX9at5ri6XgPy/Eafp6z3T0Zb15pcuzaWQKWQPylPmjGwMzGRKbiwObEesSACoKS0MYzXqnYObXOY7usTQ0WbLGj4wDxcPfNVPqwckhlDCzjtWjCvs8MJRuZ9xItItJuErJQpHal6GNGX7PnjarlVwCuYJLtpkR5BQJ9IAuXVmu89bpvK+42Dk0YeGvdhkVpP1zrpEtlo2gxQCyiXqKjd1xXl//A5/USPSGhC1zp2KqndZnEFkxg7/tpNcGfkup92/in0ERaWiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QjGD3YOCd69yOIvkowREBl1YjvoACyJifH8OpssY/k=;
 b=pWPC7otckY09KeoSLTTlBbD7v5Fnpeyc/gLDwcPuVz8B/gXJG3pwj9TlUH6P8XcCnqkPFJt+Iyg745lPbfgxwxGHmUyUZajaqL7nZyD0/123EPRaLX6DgPN3wHwDTnx1c0eYm+ZPsrINkSuk+KHyOQYOqYlr3UHUFYWh8z9/7VI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1345.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:266::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 11:29:47 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.011; Thu, 21 Jan 2021
 11:29:47 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next] net: core: devlink: add new trap action HARD_DROP
Date:   Thu, 21 Jan 2021 13:29:37 +0200
Message-Id: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [77.222.147.22]
X-ClientProxiedBy: AM3PR05CA0151.eurprd05.prod.outlook.com
 (2603:10a6:207:3::29) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (77.222.147.22) by AM3PR05CA0151.eurprd05.prod.outlook.com (2603:10a6:207:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 11:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f56782-7c8d-4f40-51b2-08d8bdffdb84
X-MS-TrafficTypeDiagnostic: AM9P190MB1345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB13457BB993F4342165978BCCE4A10@AM9P190MB1345.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vav80ysvnqlv//CgmtHpkNMDrRvg9QSnw2lruQWEcW/Z14hm7Gnmsfy8jlbsPIx8+sJwamODZVaET+0s2KNQ4E2P9WSjZg0prpObaUcWpYZMnSfeVOlkBhV4UXr+nvVrBBRLC/9HFCw+gJgbsdO2/8fvLMRGxfNG+HThXT4KfT9UJIw5ofK8ubvkKPbnr1NMtEPwa3hLK+NXJ/edfkSi6qFMxZ1r67OXcsmtSsOnJwQZzhDghumidP7mVU/d+nR+3aEycJkSWpFvIbKkVP5RwKnie1excbXsdOBJFD2G4EYt61vT1ZbovedrgmYApj6nHoiJ6mU2O4GcJQwfh8Nt5GoLww2wnqOabgl1d+Sg85HF0htuaO5skFUXHk0FEaQ1wBWxd58JVsVSxe5ll8Qxuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(366004)(346002)(396003)(376002)(6666004)(956004)(6512007)(5660300002)(2616005)(6486002)(44832011)(52116002)(4326008)(1076003)(478600001)(66476007)(66556008)(316002)(36756003)(26005)(6506007)(6916009)(66946007)(186003)(16526019)(8676002)(2906002)(55236004)(107886003)(86362001)(83380400001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H3AIhvzvIVvnLsc22gWjShAvnkHu/yymAIcanRgXEvlgXDzdtihFIkvQWTHX?=
 =?us-ascii?Q?mUWf9wzT1zLI5A+nwH6QDaPZ/uf67MM8l4BDkuFDZu42Bfre5FKFWN5dFiVW?=
 =?us-ascii?Q?bNhhXEhZxcy1bQ9qbX6GVOxcVqZ9HAT/oPvSwF+iMGwRiL2Zqnzw1orpcMoJ?=
 =?us-ascii?Q?N15ETFZfYLQiSQ4pGLOUnEA4sgeUfKEvq/5U0JAHOhf6moULIGpcvHYF61gj?=
 =?us-ascii?Q?mQYVG1vlVA8aJ5BBTgtDnRaSvtDGo05noyqAvwCPUG17HZOC5DM9FlbmBRRM?=
 =?us-ascii?Q?oeOvy4xgDj9Va0ghXleEW4eS/iOuLXeunJk18WLj0JW+0G8XYxRujZWCn8Df?=
 =?us-ascii?Q?ec+f0jugGpNKAP54CBuiSeoxSQKgtB218v/VUeWTzMc/bWHk3eTPZExQzs6H?=
 =?us-ascii?Q?rFeR5YGAbJE0UtFgFlSovJdOmw+PZctIodigBCX7nzpY2nopH+ctD9a06U2D?=
 =?us-ascii?Q?F52qJ/aA1P7NRRIeDpH4gsbxofSfY17cwvQkUyXJ/g+/7HPesGP8u6RJl0kO?=
 =?us-ascii?Q?/Lk+upmosDzezp2cPq0ypfA6B9Fe9ieHTD0OQN/5B27RkGh+nsJktUIbWg+V?=
 =?us-ascii?Q?grL59+J07NDgqP1k1tZpURaWLteH4GyTRbP5zVuNIvB3qrEEIAQM52hEBAUu?=
 =?us-ascii?Q?buAdtBKa+NDwML4eWWOBfGGURSAH41uXIoga70SOzNhjCWMPAAiCRnxB2PLw?=
 =?us-ascii?Q?Rm7SS8Yn5WvTbpHWGA8votRF8Hco/Foz4mW/7U0Nh8gh+yEmNmT0wmQDmZ0E?=
 =?us-ascii?Q?stVBosCdltSP44tLWVg1ni8/BAH0lOfiFbklhyu1IdVk4K+xrjN5RYB0XtVw?=
 =?us-ascii?Q?8xh/Mxmy2aPMVjBRc8N+tC9hk8o1uY+UyB+Z0ELWdgacrvNe8ClvSehR17Ow?=
 =?us-ascii?Q?JMQgyHwY+h6IG05CWe4NRu/sl2WbMI2aDNwppkN//u+S0QjmvjejIeYmXELG?=
 =?us-ascii?Q?BSRpKtpLQmDANyO4CtridU7VMpcbB3g87AH4+c2bNyNgIDf7yMaT3neqIUIg?=
 =?us-ascii?Q?ktUp?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f56782-7c8d-4f40-51b2-08d8bdffdb84
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 11:29:47.2745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiEYSeyJtbwIErg0MeKBIfzq0TgTT/LPL3AjHQhBZWDthHRE4l6IIuAUl5Ou00gabCnpVo0D0YwRJbtm6rJImJ2FZxIxnRoXwuU8Gvq/jzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new trap action HARD_DROP, which can be used by the
drivers to register traps, where it's impossible to get
packet reported to the devlink subsystem by the device
driver, because it's impossible to retrieve dropped packet
from the device itself.
In order to use this action, driver must also register
additional devlink operation - callback that is used
to retrieve number of packets that have been dropped by
the device.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 include/net/devlink.h        | 10 ++++++++
 include/uapi/linux/devlink.h |  4 ++++
 net/core/devlink.c           | 44 +++++++++++++++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..6811a614f6fd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1294,6 +1294,16 @@ struct devlink_ops {
 				     const struct devlink_trap_group *group,
 				     enum devlink_trap_action action,
 				     struct netlink_ext_ack *extack);
+	/**
+	 * @trap_hard_drop_counter_get: Trap hard drop counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets dropped
+	 * by the underlying device, that have been dropped because device
+	 * failed to pass the trapped packet.
+	 */
+	int (*trap_hard_drop_counter_get)(struct devlink *devlink,
+					  const struct devlink_trap *trap,
+					  u64 *p_drops);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cf89c318f2ac..9247d9c7db03 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -261,12 +261,16 @@ enum {
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
  *                            sent to the CPU.
+ * @DEVLINK_TRAP_ACTION_HARD_DROP: Packet was dropped by the underlying device,
+ *                                 and device cannot report packet to devlink
+ *                                 (or inject it into the kernel RX path).
  * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
  * @DEVLINK_TRAP_ACTION_MIRROR: Packet is forwarded by the device and a copy is
  *                              sent to the CPU.
  */
 enum devlink_trap_action {
 	DEVLINK_TRAP_ACTION_DROP,
+	DEVLINK_TRAP_ACTION_HARD_DROP,
 	DEVLINK_TRAP_ACTION_TRAP,
 	DEVLINK_TRAP_ACTION_MIRROR,
 };
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..5a06e00429e1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6732,6 +6732,7 @@ devlink_trap_action_get_from_info(struct genl_info *info,
 	val = nla_get_u8(info->attrs[DEVLINK_ATTR_TRAP_ACTION]);
 	switch (val) {
 	case DEVLINK_TRAP_ACTION_DROP:
+	case DEVLINK_TRAP_ACTION_HARD_DROP:
 	case DEVLINK_TRAP_ACTION_TRAP:
 	case DEVLINK_TRAP_ACTION_MIRROR:
 		*p_trap_action = val;
@@ -6820,6 +6821,37 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int
+devlink_trap_hard_drop_stats_put(struct sk_buff *msg,
+				 struct devlink *devlink,
+				 const struct devlink_trap_item *trap_item)
+{
+	struct nlattr *attr;
+	u64 drops;
+	int err;
+
+	err = devlink->ops->trap_hard_drop_counter_get(devlink, trap_item->trap,
+						       &drops);
+	if (err)
+		return err;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -6857,7 +6889,10 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	if (trap_item->action == DEVLINK_TRAP_ACTION_HARD_DROP)
+		err = devlink_trap_hard_drop_stats_put(msg, devlink, trap_item);
+	else
+		err = devlink_trap_stats_put(msg, trap_item->stats);
 	if (err)
 		goto nla_put_failure;
 
@@ -9697,6 +9732,10 @@ devlink_trap_register(struct devlink *devlink,
 	if (devlink_trap_item_lookup(devlink, trap->name))
 		return -EEXIST;
 
+	if (trap->init_action == DEVLINK_TRAP_ACTION_HARD_DROP &&
+	    !devlink->ops->trap_hard_drop_counter_get)
+		return -EINVAL;
+
 	trap_item = kzalloc(sizeof(*trap_item), GFP_KERNEL);
 	if (!trap_item)
 		return -ENOMEM;
@@ -9876,6 +9915,9 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 {
 	struct devlink_trap_item *trap_item = trap_ctx;
 
+	if (trap_item->action == DEVLINK_TRAP_ACTION_HARD_DROP)
+		return;
+
 	devlink_trap_stats_update(trap_item->stats, skb->len);
 	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
 
-- 
2.17.1

