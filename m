Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBCE3A2F9D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhFJPpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:45:53 -0400
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:46158
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230289AbhFJPpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 11:45:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/gfgvMHuGaButlgzbXwz49/KxNGa1SFUX7QkFd7Um+AQWvzgydC9iUcu7NPyZrYppKhUhgYgxxZrLmTetTcQxF/4pVbWROt+atjMANAONUXGHMgjDxlYXjTu5d0499vw2J9Zz7UPkhAKSsxNsCd/5+pmSubh5V6TO3eEiAT51C47Of7owYgqhpti1z4X+80OXcKkJRN3vQvZOUUvU7rBV8Gp/s67kaPzhmuuDWtHl0jBTU3BNBskEMV2k7O5JHU3iqMQpxz5f7BDqaGbDyQS283xPghJrIrMfmyXMeD6GKFeakPg6FsrmnVOx0zfS0NaL7tlsl98Y9eZm5Yo5c4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9YQtIseedxrt7XvCBE/hyTVrb4xbjfr80j0bC3rFHU=;
 b=RQ6cox/BlPeA2KAMlYuiAxCYdYXP3d19HUgFS4VrNLMxT6MaeiKytVzThaDHts+I4VtM1ZDIRVjIbP2ovS0ZByk+Ni8u8Jr8nmZDP7UoD8/Mx8qeUrsFMlA2I6BlVMw388GXSCp7mB1jhdpy4q74/GaXPnnwG3mVZkGquE2aVkd3yN7UPXULcvaJYclMeojXnps4PwP5zEhfBpX/AUOqriFVR2mUca2WEEmmCHiI/4wpmgsVGWHGXA7eqVavcVR2HsRzuw20y1OAnVbOBHU098zpuIBI679HYEGn4i6LzHuhJ37hay1aIefI0py/fcvJXKouUxGc0XQSvEZ+Tg7KKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9YQtIseedxrt7XvCBE/hyTVrb4xbjfr80j0bC3rFHU=;
 b=xwtDnNWHoDLilljqmWhv6CXU5ZBbx1p7xArzAmZc94kHfcrMrUS3ORQWUjowmtuST24lULo8zA+qkLKuzUozvN/W1U7qXoCinjH33FT+BakC2HwYPmMCYHtekWozR5VVCcXttClIP2UsgE8ZZiCvM357VloWNH1MWALF/syIfMg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Thu, 10 Jun 2021 15:43:49 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 15:43:49 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH v2 1/3] net: marvell: prestera: move netdev topology validation to prestera_main
Date:   Thu, 10 Jun 2021 18:43:09 +0300
Message-Id: <20210610154311.23818-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210610154311.23818-1-vadym.kochan@plvision.eu>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM3PR07CA0082.eurprd07.prod.outlook.com (2603:10a6:207:6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 15:43:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64742057-58ed-4751-c80f-08d92c268a2f
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0268D4BD1D85DC2E808ED3C995359@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8lzd6Jkq/FPNCMjY1vqIvwSCuqxDBphQOuEXPOzCX6agKt/PTsbaAYEit6ftpGCE2n6ghKAidQMNQ3ainSSbV3evrB0uvOFu1TVZoCFTqGnt6zETcDOyYuJ+5tWwM3j/BXho5QWfIHUcyV1+Bx0SAnwGIZ6okE4UrPNRtH52XHEbY19ZBcjA1QkANYIZN2j+Ylsne2SsjOp3vgSyU7fpfY7ObwXCkUqPJS2mFnB15DiUrO2suk0RBxK0gmP+Xa1vrCWe3bj7VIhfCoQRKpTrcn2MXqvHohaq7fDFXqgjMvBPeILj4mhHraxktAjIKfxQXqlEdwdrfhgS11E+BSvg6WdPBdKYWb3/uqn2CLOjXaGDyAGYL7lGhkpPvaSGRJxYsPc7fB/8KOvGVsekfCsMm5yLlPZ3bohVpP+BfnbROugMLeXYuGWtmWMVr1g8HPNLHUyjgsJ+Xdwss47F3t5enxlgoGXnOydBeg/u8RMSxMUmEYcJq4hwbCNeUwmS3TWhD2KXJhl4uF74dz28ga0SYTM+RwYPHNTOHG30ezTY+9jgq42Iwq6gbtVZj229bZKzzFnuxPPEAu8bq/3JEsaL/A2l4KtPiV6mRHrJObV5UFQ04SF4EjPqvsrBsiRdAkHdKSeupjqMz77w2szTAUpHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(376002)(39830400003)(346002)(136003)(366004)(66476007)(66556008)(8936002)(66946007)(8676002)(6486002)(6512007)(478600001)(2906002)(83380400001)(1076003)(6666004)(186003)(956004)(5660300002)(2616005)(6506007)(38350700002)(38100700002)(52116002)(36756003)(44832011)(110136005)(316002)(26005)(16526019)(54906003)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J16dZ9Zpa4Z9ZKbYCu/d+ThOwErKQrrfg9wS/Dg4b5DX5d5Zqq5DzTI5kWAi?=
 =?us-ascii?Q?OqFBzKGdqw+KtSZ+licwfLj6CNWUDJpPv+Qu7jKgaXhnJE9Jf0GFRIwwHIjD?=
 =?us-ascii?Q?7RZczkzotCV4UjCleo5B5qYPNO0vk0PtmkKLxliU6JvnUDNZEScMFBmIaYTo?=
 =?us-ascii?Q?f7VCl8fH9Hgi4/QmiXVn6LXvBInLwZGhb/BTdpjfYClIzRyX40mzjqaXFy0f?=
 =?us-ascii?Q?S/9k04MtZ3GmTC3Yr+INZ0ozhOGyXrizszhK+4BrHjPV2nreXpiSa5Ge4J8S?=
 =?us-ascii?Q?WdP9MlIOsTNVD235V0iiScvHK9Okg/5G4QXk4C3CiAPxq66hEFJ93GiW3QsY?=
 =?us-ascii?Q?n/Kmkpfz86dG92FJ1+FJ6MpbmkqvjFpwlpq56uczLz05a+V6n3BoMAbZcmTX?=
 =?us-ascii?Q?f2nUPMTh5ZEQ70DjdJD3fnfMnkrUV/GfOfuNsw3GTHnx7xlHF58FIxm1Lz9/?=
 =?us-ascii?Q?9ZSyrjBU6yO3eod6LkAPy0MqxG1WRKPqDOP48ry5F8p3llD4FSpEDB4WtI2Q?=
 =?us-ascii?Q?gZOakBBB8QcwyPZhhY96QI2vcxnodcR1GBJ3Sr+odSwgHz1Lk3ug23m/y94u?=
 =?us-ascii?Q?Nj4/mbVPdWsmRuW7b2uxB+Npw67RNuc/4XHood+wwBDBxz1A/MB8Irl6uxuq?=
 =?us-ascii?Q?qO4Lz95IGiuNQA5ut2tMp4FxQacQg4+uLjatzQySW5lWuET1X3ASfwZL76fA?=
 =?us-ascii?Q?p+4ACqHiGFdgNB2oT7aq9IlnJSBqfAAa5mj7X0YqPqsL32CriHlUYbCggctr?=
 =?us-ascii?Q?r6k3eFMVooMFZO8PG7m4Ac7ByP543b4W7oFSUzySbLoDWT/g/ZLsjbw/Q/ri?=
 =?us-ascii?Q?H8NEGq5QYro/NelklnjnXW+DNOuO17fUyMYRRX1v/AFoO89aZAXBgZGjCxKi?=
 =?us-ascii?Q?D17iTUcZ1rJZ3NGsHbAT8ZdpnWgvgVOAux4R+8mPmoke6MjyKJ1dbwJPl1EQ?=
 =?us-ascii?Q?jI5RYH/HephnaiYanBGrjKjv52qVqo1cJ9EUrgqz+97T4hb6GUuPsJu35a/y?=
 =?us-ascii?Q?7qZOdrtjT7shtVnppbssqWJBgrGO3XmgtyN1zSOTQHzfKUZcRMa5DSqQe9bM?=
 =?us-ascii?Q?eDrjEYvUrZOWoGq8nn+P/ta++CJhecfmvR7QPCQkPE5cMV6AZfXZZTj0uO03?=
 =?us-ascii?Q?XiH/dC3cwp7VpQy2xp2GYXx+eBJogj3nkMGxFJRRu9k1i/cURgTh2lp0BvTQ?=
 =?us-ascii?Q?zgnVdWkChxdGjb2cjY8AnnxYWMQ3J0pdziLhv4kgwZwFrL2XS67N1CHGGVm7?=
 =?us-ascii?Q?rksBOQXHdMqBgkUVj2tf8a3VWXxf+F0sJyXWX5S46R8LNh6fp5Bs5jV8Lgm4?=
 =?us-ascii?Q?uwGNx0LrdaUkbqVIyy1R6zCr?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 64742057-58ed-4751-c80f-08d92c268a2f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 15:43:48.9821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NWY1tX2i70MReGsHPXwLTy8Z9iXSKGVo0ee+h29a4mLpdlo3tKRcdJtdCfyRKdnr+iM7jjne1hHA7tRHZQu5DA0psDo5F9rixA7yKlb1ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Move handling of PRECHANGEUPPER event from prestera_switchdev to
prestera_main which is responsible for basic netdev events handling
and routing them to related module.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_main.c | 29 +++++++++++++++++--
 .../marvell/prestera/prestera_switchdev.c     | 20 -------------
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 2768c78528a5..767a06862662 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -508,13 +508,36 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev)
 static int prestera_netdev_port_event(struct net_device *dev,
 				      unsigned long event, void *ptr)
 {
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct netlink_ext_ack *extack;
+	struct net_device *upper;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+	upper = info->upper_dev;
+
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
+		if (!netif_is_bridge_master(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+			return -EINVAL;
+		}
+
+		if (!info->linking)
+			break;
+
+		if (netdev_has_any_upper_dev(upper)) {
+			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
+			return -EINVAL;
+		}
+		break;
+
 	case NETDEV_CHANGEUPPER:
-		return prestera_bridge_port_event(dev, event, ptr);
-	default:
-		return 0;
+		if (netif_is_bridge_master(upper))
+			return prestera_bridge_port_event(dev, event, ptr);
+		break;
 	}
+
+	return 0;
 }
 
 static int prestera_netdev_event_handler(struct notifier_block *nb,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 6442dc411285..8e29cbb3d10e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -537,35 +537,15 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 			       void *ptr)
 {
 	struct netdev_notifier_changeupper_info *info = ptr;
-	struct netlink_ext_ack *extack;
 	struct prestera_port *port;
 	struct net_device *upper;
 	int err;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
 	port = netdev_priv(dev);
 	upper = info->upper_dev;
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-
-		if (!info->linking)
-			break;
-
-		if (netdev_has_any_upper_dev(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
-			return -EINVAL;
-		}
-		break;
-
 	case NETDEV_CHANGEUPPER:
-		if (!netif_is_bridge_master(upper))
-			break;
-
 		if (info->linking) {
 			err = prestera_port_bridge_join(port, upper);
 			if (err)
-- 
2.17.1

