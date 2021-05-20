Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987BF38B353
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhETPhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:37:15 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:8577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235891AbhETPhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:37:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtZPzh/PqJk1xEj7hNYgpZjhBhPYuQo8Ehr4zXNtLMSpJ+64L1bnMCB3l/xn5nyGnc3V4l70KbsNBA0XF631y6t8S7R16UCKXS56y+OIjqABQUCaiTPR6MplIjDljImLYliBEdw3MEk15VFwuPCvBoAdUnIc2d6tmsu7fSYGBfTcIJvmVnyugLV8sHUvwAGd8HPHnRe+NPD1uqRTifBkvOKa2tb2TGvOTEktic0kC/Us6fEgiS4KSfBGdccNvXdXGxPzHniEIOBLA+IWjScdM6m3Bf9NXOthEmxZtF6wpVwhOLW32c1EgnHr4XEamLYalHPI9MQLHZQ5WiDTLca3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe0P7WfdIFuu+woSaGWO4fiFYO5nO0G/uHHqlGEqyM8=;
 b=AuFzEZvZd1l2gkqMOBw7hvUC2IwI5Ydokc0vc42t9Z7cuw/I3mH12P3CIeUTPvWBh4JvLMaue0kEMxO9WCb6YNabNowYRO3KVUap5lLL8sgcOvF7mnPgz69M5+K0yqdLIXRGSJ320oRFnYc8zaYyKmcTQ856yCiOcgBTZFd9OW4ljGYommRfG7pboOrg812tY8ggHWCMZLA75bPkW2YgfZdkL7jd4B2DRudn6T4gpizZmG33IA0MNMRhCngVqkPgkn6HkVrrh0sbt6qDbXCYHDgKjvhrmL9+Urzbv7hpuk9Ogez6wRHPv9rtvFYmRWLkUoWrtpD13Msc60gflE1JEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xe0P7WfdIFuu+woSaGWO4fiFYO5nO0G/uHHqlGEqyM8=;
 b=KVhqWcgH/gZeBgf3J7UpUEFJ/rMz1UlJmaxN7hJXusjuSGrQeacOMNHa+9W2ckgxzRS+fW5pMtRAPqmx/km0tinCv9VMqhHh/GtsL8ubz3dCD2sECQataBSTwbF60ZSEf80Dm7Esbp4tcm+/aEutt0IUaJS6doziqfsQKkNVH2E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 15:35:45 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:35:45 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next v2 2/4] net: marvell: prestera: align flood setting according to latest firmware version
Date:   Thu, 20 May 2021 18:34:58 +0300
Message-Id: <20210520153500.22930-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520153500.22930-1-vadym.kochan@plvision.eu>
References: <20210520153500.22930-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM4PR0101CA0065.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 15:35:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2de1718-ae2e-46ba-8619-08d91ba4eefc
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0268BC8C863721AEEBBA619D952A9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaUHISmN9YJmf9qPKSgvmbvfIHRImyA36wgAjIPWNkPx50tZL92d7H+XmrviP147tJ02Q4ZKsBSAH0GX9oQdJ2mVo2gaLwVRRW9xWYKomG3CkpLNHgcfceQttgy/cX/TCW1kadPr+fikQiFtrFjHPSM4K6QuR+pmEd+jwehVZgfKOSlRz6R0lb0DFHk/kc9tqTS0Fgkzfg1UcGd2qoPvPiJ+q97/V9a4XloewHShcPAxOpJ7rtUIT/ddaw0gLDjrWOhxXdNGsdWTFDARUmuDs9Z9H5MxQjTFhTxX2cJzbBQF5pYDdBE7JFo3tbJVyh3ZCW2NtsjJRk8kQBCUtscWu0obnhtLqekjxnHuMmxdo17nfsz0wVem8NZYLyO/nSMbY0MgM7RU9LQGoz8PBIbQ72rHOLbMleH1fBTEbFnD58qAVEV/JFT9xYz+4g7w+78B0Mjfg2BE2jwDLgrPlLJM6ezg7MM/emMrFMEBs7tPfZt03jBsSkymPxuf64sfOVT067oftyesDof/exfZF83osp1+nY/5HcMV/oC7LxjP/BvRXcvAtoa1y4kngKyKbd26fSk7A02eydJx+0kxG09Kwt6rD0i5cIHZqlrhLxhshA3XuJmFuhqvfeQ+u40yCRCVGxioSTckLHxgAekbAitgJiXyljK9SUlNpSOK+RBPZF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39830400003)(346002)(366004)(6666004)(26005)(5660300002)(4326008)(6512007)(66476007)(8676002)(66946007)(316002)(66556008)(110136005)(956004)(54906003)(36756003)(186003)(16526019)(52116002)(1076003)(2906002)(8936002)(83380400001)(38100700002)(38350700002)(86362001)(2616005)(44832011)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Q3xKfTF7AzOiO1b7OU9G8Z8YoA1oBLC0ujnY73mL0xh/YhJh5ciifUk2Zp5?=
 =?us-ascii?Q?mAVuHQULlxIskWuXuf1JuGmc4Lh/mFDSvoxwdvC76e4hHzEUJ0NbuF4JP5MN?=
 =?us-ascii?Q?4y6kBhWfTpBM2gxUAUI84CRIRzs0CkxVMj+7FAf+CfKocu0Ya1Y554BjNlQ+?=
 =?us-ascii?Q?jVvpcZyjJtxia//CYF6HwfTiM/a6A7vV/1EpqAqJ2BGk7NozjPxM7cHwztRh?=
 =?us-ascii?Q?rMFC/5pgnmszL/g+GDgn0PsgBjh7J5Z60lC7Hoj0ORDAEgrIuHg6Gsk5j3Ba?=
 =?us-ascii?Q?HFqf+4yQviQeshLyEdQ2HFzfLBeXksKfgUZ70zDX4J0af2OKpsuIiGsm7fSf?=
 =?us-ascii?Q?LN+l0rUvsvFNM4h8Pu01UGWh2E1mc2aCk3xoJz4wLlV7DVin4YVx/V+OLOO+?=
 =?us-ascii?Q?wBtKIZ7+jBWqzFfkMGTN3FXQrZd2TXxvdvS3adJubJYL8QJen/xyL7dqRqkn?=
 =?us-ascii?Q?O9qQZGQppBL+0+rU+yWXH3KFc+rAjrNIplK6t84sIDtBFZQQDrl+VzTzn72s?=
 =?us-ascii?Q?UlLBACWFkafDn+5jkc0K7gH8miBwJsXKKF2K3p2p9M94wf0O5kom4j7nBhx5?=
 =?us-ascii?Q?/mNKB07c/B3zZMda1e283PjtxDPFmVX9hcU38jrKcl/YjQixEDK7eSLnMHGo?=
 =?us-ascii?Q?kcspWLrHn4DRVlPH1y38b06yyVCpah+mMagn2zwuvcJCw5Bhfsac7uMMc7sE?=
 =?us-ascii?Q?U2TEbruGb0M9Stz4qtjJYSRjKBywPMliprlvOZvmd3PXQIQjskCMcAT7uHLr?=
 =?us-ascii?Q?ar1ZdOWnqGNrjzgNQFQ+GmtYGuNnpUdzm0KnWUSktCmYag3fVIXJpxydcD+7?=
 =?us-ascii?Q?PsYFQOO3Cf+rkcEkEPgNpPIA9/xnPQPRw5z20jF8PyFjEviHj6cmbMs/sVbr?=
 =?us-ascii?Q?Kl263C/QM1kcRGuAg+Xa+E1xVMe+6kqwgOCpHUy1oPxABlMmOij9ylKyEV/5?=
 =?us-ascii?Q?WrMa3e8UQCurXZRJ5ojZ1kU/8Q8UGUBvqLBmpwFOloL6bx1sJk4HET1TvcWx?=
 =?us-ascii?Q?tpyrbZX1wEJbr4PDOlfu6NEEX1udQSdSJskWAEq2fGrRuOl4M2sHQnDv6wax?=
 =?us-ascii?Q?rSyK9wZdfskyeWl4srNiVi/+87ErGFTJNPEADgV95t9mHeDgyweWoMYr218d?=
 =?us-ascii?Q?AnqCRzHSxMuOAABrTSby7uMLRcSUpfmn+BWM/f2a6E1zWJq/1TywJiuKLrsN?=
 =?us-ascii?Q?NDZnQ3E+mFjJ14/A2RS3G8yeG4aZIpufmhD5xJa1+DUyRZ6cdZxd+HqF6XNf?=
 =?us-ascii?Q?wVamQsgbrwQuPElgo8ze8vWuSYgz/14BCjKUlauq45Z1xLhhySiMdfhKz7nH?=
 =?us-ascii?Q?WkAcW/MNMBXRu6c9ZSG0QE+J?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a2de1718-ae2e-46ba-8619-08d91ba4eefc
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:35:44.9228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QknT5rlEjln/JTvqEKYBbVJ1czaMMi2xhrQRFZ81QvgEncEgzym22LoIXKqE1s2VKaz0bVewsrE0SgXRStgIqruDv7K1bpJPLvvgaCkvAQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Latest FW IPC flood message format was changed to configure uc/mc
flooding separately, so change code according to this.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---

Notes:
    RFC:
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

