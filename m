Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DD738910C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347982AbhESOgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:36:08 -0400
Received: from mail-eopbgr130127.outbound.protection.outlook.com ([40.107.13.127]:11181
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347944AbhESOgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbcgMNLd72NHTNnczAfvBcRpw9ykRH+rRhQ0Bmen8gCobN4ooNY7xC+ccE7Yt3VDYBSd7+pMdIfPO0mvk1m/RZSO7dmUQqRRq2Ia7NRFP0zVfFBAawZ7WasI6I/9bmDfrmW77rBrnG6zjeh6S3P+HM5f/AuUnIQUdLLeeo9t8uWY+LGExOP4xC0WXvJn/GLOxvTvMt2izj755XtxTRhAqz3ArKZCryiyS4kWdNN7KC1oyj8h6QLDs0/apGHtUmOD4JDJwEClex46v4DGHyyGAcgiRYv6FJmQ2Q1xJbL1ArLjiH4BVIYKy1OmhEMsmN9c6WDzgX5bAGvLPoqQ9i49Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5plG8tDRJvRLVsKKRKjo1qBppECZW5Ht3vnKvs1ruCs=;
 b=naqZqJ7A0F8QueVtDrIhB0Q2ZVyWADPBLAqBPEjQgsrKgyWd5PcDPId6TtcZfd7Wiao0YTDj5/h2oYL/6uoqmfZZxqP3MjgUkjmGgjOQtUQRxDNbJJCHZQ/Um14aBhj0a6s9kj3jTxyg0u25gGKALLZGijJWu1+roAh0PIyFjculPZetRTaHA5xhR+oZHhHs0Zri53LbdFS+npz8ZWf8S+AyPx706KsGBxO9EQ4iK2owpZSws+RY5dMDEzk9AD0ftCIfn6lJo77oO0AWmr721RzSWq+X7dVj6U0QWUnuhg1xGG3P+JVHWi0riXEs1F3XZunTErVIz2LEtosbrYJhEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5plG8tDRJvRLVsKKRKjo1qBppECZW5Ht3vnKvs1ruCs=;
 b=ISIWRQgSJxYmL9jjtKzy6ozbZt6msCUSLtvmUlQzGNUr1Oicrk73Uv6cn1BaU9J3GvA16efdPnUZ67D3243CoI9Osex24nAqiZDXqOCYPKQRoZF2r8ytUeezec5p8zvECEkEA/wo7Ko47cnZpHjJO5RBaUhQw+/5juppKnbs4n8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Wed, 19 May 2021 14:34:44 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 14:34:44 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 3/4] net: marvell: prestera: align flood setting according to latest firmware version
Date:   Wed, 19 May 2021 17:33:20 +0300
Message-Id: <20210519143321.849-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210519143321.849-1-vadym.kochan@plvision.eu>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 14:34:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4765fe5-f5e6-48ec-06f9-08d91ad33e9b
X-MS-TrafficTypeDiagnostic: HE1P190MB0025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00252BCF259F6F0310A1B62F952B9@HE1P190MB0025.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIziyrgoWnh5u9jY4xvUZ5oMyNLY2TnOd8KnvLinTAl5QT2+Sxii0t9dQPey1kszU81/JVKI8U/JuBCoLCh/Z4FPGGt5DS4Mq9XuuUI2xWxhXi0fYoWC1okCab6siDQiIDv/ROE8X14yjxaN9+0ZW0kR636Z+8Dy8BdbMfnfoJIJUXUi3SjMIGHz6a6dkxJTWUts1112qqXsJFXOL+YWzXS2soUQjdiSgg6S3YE+rQiI8wdF1R43D7aorrdD1AqsRWq4vSUMu/6NPZkr8R4lszBlJ5hYV47kGnvCBubQC50ImadZ4GTmVKlBRsPId/BLmQ8bsVQHK3GCVX4TAZ/WTKw74PVDO+FntTpLlRkRS8lXb/h20szssGdIvVA4CuC1x34dxH/TkJJ7exO/lVotjkoqGyW4XXTBHqpE3Rj7dWQ2kET2qZWFdh8Dr+mumSLFl54XsqStO4SFNI9X9XEN0q3LEOaabz0KhTpfAUyb6Ppb+Mlo9sUXlq+8ffJ81wXpzdPeH8vJYAx/XI5ifjZzDUHNrNr/M+Pi7JPm6jEjiA8sWJpEqt9rmV8GzLloFS+jpQHLyKHL+WCI3T3MchF4SpTIgvHdojhoWUJz+bP51qRkzHu4zy6S33VNCfrh7WNNuKzZ2qlgKe+V3B0yBn4UjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66556008)(66946007)(38350700002)(316002)(66476007)(38100700002)(5660300002)(86362001)(52116002)(8676002)(54906003)(6666004)(1076003)(8936002)(478600001)(26005)(110136005)(44832011)(6506007)(6486002)(16526019)(186003)(956004)(2616005)(4326008)(36756003)(2906002)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WuCc2+/y5l2/rSR9fEt3UGX5cFGLcQT00b4PYsL0mcZprohXkK2D9RUzNi+Z?=
 =?us-ascii?Q?U9eHeyIF+9t6CIY8fQ6yLzJdFH6+a2LNz9OvjyfT1S98WFhArC5jWx7fgh/M?=
 =?us-ascii?Q?82XiNzJNX1fr4fpPs/CbsipoipWA1G2ALbmEgmcwx8auiwzgg+Vy3f1uligx?=
 =?us-ascii?Q?o2LYGZBzaSGvlfIPejlEloK4LHSRfD+1pk1OFPUAAFo0013aY/epIcEnJjhr?=
 =?us-ascii?Q?WpNdk5MlCORfxVGYJyf9GJYgODXg1LopTvmNkZoPre7ExZOXOc2gBoiJEsih?=
 =?us-ascii?Q?Ozu4K8CqxHp4WUH7Zt9SvKyXU77op6HEBVxMWsncZ4eDLO7EfWOPqxPwP7lX?=
 =?us-ascii?Q?0yuSSK2WgvN6ahKPv0gyAcblDGDr3DWXHncFjDHvYEFG9aW4hqrk3lpI96Mp?=
 =?us-ascii?Q?FxDZ5FMDnGbp+rxZKiS0zOeflCFnKhsJtbtuzG3pLctI4fOCqwsTRXdr3zk+?=
 =?us-ascii?Q?1agh677XbMABiquFXsmK5WgutyI2srtFI+n7Ye67rJumHU8UcoDvJPjVnhRT?=
 =?us-ascii?Q?DlDgc/AGTX9KzPOCs0SQpcuh7Ap/InjpdpMYbudXGO9KEzQ1To4AS9QrIOAZ?=
 =?us-ascii?Q?57bZIF5cd/+rd8JTkiowqxVxyPRVdimcNKGsArYsU30iXt9pTzUKMYrBs3+W?=
 =?us-ascii?Q?naXI3799Ke570LhMxpCU4eDV1fgokyncje3o4DmNmfIW+FXNRzHpMvUctMIZ?=
 =?us-ascii?Q?jOwxmEKjcMepkAF7rV9mhyJgHYa5NBkdxDBRsknRsR/ci/14zzdIF6M0Oj2a?=
 =?us-ascii?Q?aZB9H1pQ7YTPeR2B/luBFTLGEQdcXyHr22ZAaxhI8Z82R+tyiBR7/MbeF3Gc?=
 =?us-ascii?Q?byqqcXoll/o3Ce0argVnt0fY2AdgYR1/5m+sAtJYJ/hPKJOdeT0ckVGYaWf0?=
 =?us-ascii?Q?iXL5eMv7fYgQM/9RlVEo8q/VrHsQSCYGDZmKnbw3jUIDLWBW0K9praJR3ucq?=
 =?us-ascii?Q?fPiNLc7tgF35r6ZoVFSXt6hez4sqqhXpZxRPjXTakI5wnGmyuSc7KiZOdbXJ?=
 =?us-ascii?Q?Hih4g1tzEtT2o0oM9lqalW7Up43MhxMyh0TRcA6zSd9x2fb1MgbHVdNDaj2q?=
 =?us-ascii?Q?PErAEsylEhynLAfLD14V/rXePPD9Y+wdGuVe40d8gOsmsLOcHYocDO3LcgPL?=
 =?us-ascii?Q?4TBEpmTx/jWiylmr6MQIWAbiRgCCfwN8FQmjE0qnV7G1bCblS+oaJAoin4Fg?=
 =?us-ascii?Q?mGYgqt73dq8mNVCQMwiJC8AmVqQ8MJyYcRzZ70d7PKKH3uzwH7sb6EmEBfdt?=
 =?us-ascii?Q?xJKIOEyJsciMRSyU1F/oQZIqfPq1O/O69NwdLECT1LVTh9buc6o94OQX4rMo?=
 =?us-ascii?Q?gGfiZaIWNepD0rENQrALQ2w4?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d4765fe5-f5e6-48ec-06f9-08d91ad33e9b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 14:34:44.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8QKlQG369hyBygxt0jhy23Pw93+6+os7lyQV6z8zZDO6O+MaB1ydVJ1ocQi/AlHY9ckFjnoCRPsMm5yS0a7aWHmHZC4eYurUsFpY32x4HLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Latest FW IPC flood message format was changed to configure uc/mc
flooding separately, so change code according to this.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
PATCH -> RFC:
    1) Add support for previous FW ABI version (suggested by Andrew Lunn)

 .../ethernet/marvell/prestera/prestera_hw.c   | 85 ++++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  3 +-
 .../marvell/prestera/prestera_switchdev.c     | 17 ++--
 3 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 0424718d5998..96ce73b50fec 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
 
 #include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
 #include <linux/ethtool.h>
 #include <linux/list.h>
 
@@ -85,6 +86,11 @@ enum {
 	PRESTERA_PORT_TP_AUTO,
 };
 
+enum {
+	PRESTERA_PORT_FLOOD_TYPE_UC = 0,
+	PRESTERA_PORT_FLOOD_TYPE_MC = 1,
+};
+
 enum {
 	PRESTERA_PORT_GOOD_OCTETS_RCV_CNT,
 	PRESTERA_PORT_BAD_OCTETS_RCV_CNT,
@@ -188,6 +194,11 @@ struct prestera_msg_port_mdix_param {
 	u8 admin_mode;
 };
 
+struct prestera_msg_port_flood_param {
+	u8 type;
+	u8 enable;
+};
+
 union prestera_msg_port_param {
 	u8  admin_state;
 	u8  oper_state;
@@ -205,6 +216,7 @@ union prestera_msg_port_param {
 	struct prestera_msg_port_mdix_param mdix;
 	struct prestera_msg_port_autoneg_param autoneg;
 	struct prestera_msg_port_cap_param cap;
+	struct prestera_msg_port_flood_param flood_ext;
 };
 
 struct prestera_msg_port_attr_req {
@@ -988,7 +1000,43 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood)
+static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.flood_ext = {
+				.type = PRESTERA_PORT_FLOOD_TYPE_UC,
+				.enable = flood,
+			}
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.flood_ext = {
+				.type = PRESTERA_PORT_FLOOD_TYPE_MC,
+				.enable = flood,
+			}
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
+static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
@@ -1003,6 +1051,41 @@ int prestera_hw_port_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
+			       unsigned long val)
+{
+	int err;
+
+	if (port->sw->dev->fw_rev.maj <= 2) {
+		if (!(mask & BR_FLOOD))
+			return 0;
+
+		return prestera_hw_port_flood_set_v2(port, val & BR_FLOOD);
+	}
+
+	if (mask & BR_FLOOD) {
+		err = prestera_hw_port_uc_flood_set(port, val & BR_FLOOD);
+		if (err)
+			goto err_uc_flood;
+	}
+
+	if (mask & BR_MCAST_FLOOD) {
+		err = prestera_hw_port_mc_flood_set(port, val & BR_MCAST_FLOOD);
+		if (err)
+			goto err_mc_flood;
+	}
+
+	return 0;
+
+err_mc_flood:
+	prestera_hw_port_mc_flood_set(port, 0);
+err_uc_flood:
+	if (mask & BR_FLOOD)
+		prestera_hw_port_uc_flood_set(port, 0);
+
+	return err;
+}
+
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index b2b5ac95b4e3..e8dd0e2b81d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -138,7 +138,8 @@ int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
 int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
+			       unsigned long val);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index cb564890a3dc..6442dc411285 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -404,7 +404,8 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
+					 br_port->flags);
 	if (err)
 		goto err_port_flood_set;
 
@@ -415,7 +416,6 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	return 0;
 
 err_port_learning_set:
-	prestera_hw_port_flood_set(port, false);
 err_port_flood_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
@@ -528,7 +528,7 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 		prestera_bridge_1d_port_leave(br_port);
 
 	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, false);
+	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -590,11 +590,9 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 	if (!br_port)
 		return 0;
 
-	if (flags.mask & BR_FLOOD) {
-		err = prestera_hw_port_flood_set(port, flags.val & BR_FLOOD);
-		if (err)
-			return err;
-	}
+	err = prestera_hw_port_flood_set(port, flags.mask, flags.val);
+	if (err)
+		return err;
 
 	if (flags.mask & BR_LEARNING) {
 		err = prestera_hw_port_learning_set(port,
@@ -901,7 +899,8 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
+					 br_port->flags);
 	if (err)
 		return err;
 
-- 
2.17.1

