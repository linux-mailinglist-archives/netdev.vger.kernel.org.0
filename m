Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F08369690
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbhDWQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:00:43 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:55911
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243216AbhDWQAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7dkwkwqZC3QGEWAQnk8Dhrtp78u9pvSca3+LZJjbu+7mRLfhg6P5fTROAVLe4Ws1UXNKBf8Bynp0oKUgC9n4KQGGQMkDLKDuzzCpMcGy9Cx+rDPCjemusMtE0AmT/wzpaxD4ISONibiFW9b+Y+vQiqeji0XY3dgQwXoGfuzexrVHUCJpZGTEFkIe8+Hy4c+FQOQLXNdRcC+ob/qo+gwiFhlMW3idw00OBb+I+d5j6HgAhy+yIDlZF4wzEOuuMYkaOTRwatM4UAH0tnAMYKlZ5OptR50fYTEUTcNX+6vUJtk88GV9Wmnc+iGc2hCT4r5JAG2zRDczqsOYdv/uleCow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFpqKsR6aKyV1WiLABviZ6okCsrssu6rdDIzdKlGqog=;
 b=GL5I31cNQ7IwFFO86ACHlR8dMVxMfwxlC8AGsaULQA7oCoZ4kyKambPBYAOLYRQcm/84U/C08w3NROdG+XmqsDbF095sPwShaoksC+yTLhBSDHhlMUFzNGCBoF+obp12VRN4hcvUSsExYHynJD2MJdRFYFMJ5F4gu54lncnGT1kJ0fdNNAA47u6HmMuuuu0qM2XIgags8lTHLwqm8wu0nikTTqbAJ2vxCrDgX6Ng3Bcy2Cc4oqTAbF4+6T7OxYNtb27EgjSz2E5H+7nFIMY/6yVpMXlk19fdPTbi/rVnO/EJvtsbjajXqVSU72so/W6RYY/T8VVP9uTdOuUIjrR9hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFpqKsR6aKyV1WiLABviZ6okCsrssu6rdDIzdKlGqog=;
 b=acyrrkjV8qK3q+QxDiii3NnTPiUf+9gUsgz+6CIN/IXjjp1Vlg4xbzJh3DghVDr5/QNAG6PK6le/u1qvPY1rm1fMMWcLx7nCfYH2vo/abzgNsbk95Q//QhXNrgqVWlf4ElwR4PGlBWFBmO8cOcp6Ra1ZXAcKNT9revjwY1CnK5o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0187.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 15:59:57 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 15:59:57 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 3/3] net: marvell: prestera: align flood setting according to latest firmware version
Date:   Fri, 23 Apr 2021 18:59:33 +0300
Message-Id: <20210423155933.29787-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210423155933.29787-1-vadym.kochan@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0147.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:20b:127::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 15:59:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ece516d6-4751-4704-aea6-08d90670d7a7
X-MS-TrafficTypeDiagnostic: HE1P190MB0187:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB01871DDD84DCC6495862E53895459@HE1P190MB0187.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBbKF8SvHzQPnEIn1JA7irTjxr6/G5eM8VAdo5HbbeG1SV21V5rch3GzO7a872/Z0hQohnOgQd33bk8iFCcyqPrduSwphhFqbgFUx10dpbGJvn/Gn0n1+FEdJvqH18b6Ua/oYGtFYcMmLoUHzlwZh4m+7lF6PXF36TtT7MeVU+GQ99j/CxqpEMDkGSSFgw7JPhjSZqQO6WZLqGuAmN7jFYUXIrr+a1ET6VMnnfRqKkA22XNnjHDj7rps9lRB5ZO/u1x2zvNyXf8+IRrkan8V6Nauw029sjPTBz5X7DkM14+Jun7XtBNGUWMIJ1KRRurPHyAuimCela+Rme5enUhGPbp1Y1CIxp9lRsbd1JxY5iuhkWFdKCQszUAODhYal9mMBV0tunfjFaXgJ0uhh5b9d+OmFJLqCADwX7m0noivwTJDMQ2Mx8BZouV4t+lUAcCQHvLNR2LnVNWmBHj7CEYnRbMSAdfEQmmXHb+iR6zN0S9GgvdSNJsJOcnKNPHUEAwRqmdrTiyJb+EIw2KjiospeRJyUnV0gvZvo+sH6/ZFhR86yqx4MHC52k5Mnx2SKpRawYXT86WS+w4m7BbWTJY6PtAtdX5Qw0EWJlAi2htvE14NJtRIBJC8yu0fL0DrQo937hHZCFeshBQPasKT+CyOUZ4wXxF7MmOTSLMwBwkJeB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(376002)(346002)(366004)(86362001)(66556008)(66476007)(6666004)(5660300002)(4326008)(66946007)(186003)(2906002)(316002)(36756003)(1076003)(6512007)(478600001)(54906003)(2616005)(110136005)(6506007)(26005)(8676002)(16526019)(8936002)(956004)(6486002)(83380400001)(52116002)(44832011)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?byTmgalO4TFDfihJhOoOgY5jnU/JV+9Wax5Xz02t/w97Fv6464FiIrLnXXFS?=
 =?us-ascii?Q?7upyHzRTmQ+d56CC+8HpsGv17DwMRu20cB0j7IokeXu7hVxfJtBz4st+CDHE?=
 =?us-ascii?Q?xCAMbeX3Nk4aQ2dk1uQDITni7bkMHvD/XeuNxw/RNrHZiFg7x0pC5QWNoadz?=
 =?us-ascii?Q?qxwaWJXYf9Oy1nUfbi2kj6DR9kDRR/P4cP4t0WD8Fh9oguhOYfO1N/IEWCZu?=
 =?us-ascii?Q?BzpPMZULF4LOR+TErt45pMOE1V/hBbdboNXQDII30ev/P+wBxrOfwtrvHpuA?=
 =?us-ascii?Q?ke6tZKEPkX+N3qwVyNmqsDeBW65tq+stKmrDVUkEKBd2NvOSirct8SKQpEVb?=
 =?us-ascii?Q?Jr8dXezGLqR9BE6xUA8846IEEb+GpWDFdJbUXFS9ie446kZHbyeHxNYJ5qkR?=
 =?us-ascii?Q?h7/Yk3ZORqG/9+EnQ1Q+UUIIwc1In8iNQk81z1JKsou8DzDntD7yGpH3xaNO?=
 =?us-ascii?Q?0K/PP7mEctjLg02xV3LvS/ve8+UsWypE7ZotzGGMUzUFBQ2P8cPfXKfE8Ug9?=
 =?us-ascii?Q?rksNhEdki85NwwjKwqr3HtB8Hp4y7EBhAtnSqRWfT9ku3UBWP3pYRy7D/Xnw?=
 =?us-ascii?Q?q1dG8WjqZyUj3eV1mji9gtdDjcyeJg4jKaqJDb8VCF8nDlYcjn74zt+O7Skl?=
 =?us-ascii?Q?G/MeTDtp4oeAmzEKcNSLagSbdiIhBRsjgLK0HvpBVx1MhvlsYpqxk9i/I6TY?=
 =?us-ascii?Q?4OG0wLDs9Qpb8wK0AzON8OCTJu/oKrRBL/tSHP8yDDYJ1VKftpIWb2HMyNXE?=
 =?us-ascii?Q?AgkjL85Uy0DBoasR0u+asuCaZ3YGOHyDdm2gzvBRKHgfMBoWo6En0NTZ2X4u?=
 =?us-ascii?Q?n0iHecYvZlsvM516dvOjx4y1MyvAwm7IoCv7QHstIaAeYRfbMjMd5ARim368?=
 =?us-ascii?Q?wU8VRlmh6a+5Mg7qXJdrO0nrQefg+H2qljeLoadPfe8ev2khLn8kOsBIIyUY?=
 =?us-ascii?Q?9EIgYQhfW75Yrw0OBk1IFHiMDXKXqXu7IAAIbPkfnv9OcEmeAWNiRgunmBU2?=
 =?us-ascii?Q?27wkRBNXBFB5mihhgIX1zApurMzATTdTLYACESyWjLZ7iqzlEC0xyQl5g3gh?=
 =?us-ascii?Q?JYcPenFaXGHlyuJBfbstobm/D55oqNP6ab/2QDvoKIcoszSFrS6zIcv7pLSn?=
 =?us-ascii?Q?5h1m8mNW8uW91Beu+ZrHC7CrzVpF4/Fhq/I0NYK9GVnVwEsyUq55HDlx49o+?=
 =?us-ascii?Q?VV0wxRWOUgwSEW42MIm1OhBpQZkN8L0sMI5BufkotzGyxfXD81yf5TPwRaN7?=
 =?us-ascii?Q?I3Gx7QiBw5woIIRNYcjDjunVlxovutpyCapw0QlQxFEEKupYwNv7rJDnNy/3?=
 =?us-ascii?Q?7kuPpr3Cbha5DWBcDFmKIh0s?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ece516d6-4751-4704-aea6-08d90670d7a7
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:57.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWD5+K9vtQoZaSbYy+2QDbduXo5pq0tBeIn9AJlueWGreJAiWse1rYCSeaXS2E7Hs2r/+Vb3+ZcKr5mprZ1a0O9rVMlrwcJFN2cIORiF6R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Latest FW IPC flood message format was changed to configure uc/mc
flooding separately, so change code according to this.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 37 ++++++++++++--
 .../ethernet/marvell/prestera/prestera_hw.h   |  3 +-
 .../marvell/prestera/prestera_switchdev.c     | 50 +++++++++++++++----
 3 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 0424718d5998..4afef6e14db3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -85,6 +85,11 @@ enum {
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
@@ -188,6 +193,11 @@ struct prestera_msg_port_mdix_param {
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
@@ -196,7 +206,6 @@ union prestera_msg_port_param {
 	u8  accept_frm_type;
 	u32 speed;
 	u8 learning;
-	u8 flood;
 	u32 link_mode;
 	u8  type;
 	u8  duplex;
@@ -205,6 +214,7 @@ union prestera_msg_port_param {
 	struct prestera_msg_port_mdix_param mdix;
 	struct prestera_msg_port_autoneg_param autoneg;
 	struct prestera_msg_port_cap_param cap;
+	struct prestera_msg_port_flood_param flood;
 };
 
 struct prestera_msg_port_attr_req {
@@ -988,14 +998,35 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
+		.port = port->hw_id,
+		.dev = port->dev_id,
+		.param = {
+			.flood = {
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
+int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = PRESTERA_CMD_PORT_ATTR_FLOOD,
 		.port = port->hw_id,
 		.dev = port->dev_id,
 		.param = {
-			.flood = flood,
+			.flood = {
+				.type = PRESTERA_PORT_FLOOD_TYPE_MC,
+				.enable = flood,
+			}
 		}
 	};
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index b2b5ac95b4e3..109a677951cc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -138,7 +138,8 @@ int prestera_hw_port_mdix_get(const struct prestera_port *port, u8 *status,
 int prestera_hw_port_mdix_set(const struct prestera_port *port, u8 mode);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index cb564890a3dc..f615ebe683f0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -404,9 +404,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
 	if (err)
-		goto err_port_flood_set;
+		goto err_port_uc_flood_set;
+
+	err = prestera_hw_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_port_mc_flood_set;
 
 	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
 	if (err)
@@ -415,8 +419,10 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	return 0;
 
 err_port_learning_set:
-	prestera_hw_port_flood_set(port, false);
-err_port_flood_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -528,7 +534,8 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 		prestera_bridge_1d_port_leave(br_port);
 
 	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, false);
+	prestera_hw_port_uc_flood_set(port, false);
+	prestera_hw_port_mc_flood_set(port, false);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -591,21 +598,36 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 		return 0;
 
 	if (flags.mask & BR_FLOOD) {
-		err = prestera_hw_port_flood_set(port, flags.val & BR_FLOOD);
+		err = prestera_hw_port_uc_flood_set(port,
+						    flags.val & BR_FLOOD);
+		if (err)
+			goto err_port_uc_flood_set;
+	}
+
+	if (flags.mask & BR_MCAST_FLOOD) {
+		err = prestera_hw_port_mc_flood_set(port,
+						    flags.val & BR_MCAST_FLOOD);
 		if (err)
-			return err;
+			goto err_port_mc_flood_set;
 	}
 
 	if (flags.mask & BR_LEARNING) {
 		err = prestera_hw_port_learning_set(port,
 						    flags.val & BR_LEARNING);
 		if (err)
-			return err;
+			goto err_port_learning_set;
 	}
 
 	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
 
 	return 0;
+
+err_port_learning_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
+	return err;
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -901,9 +923,13 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, br_port->flags & BR_FLOOD);
+	err = prestera_hw_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
 	if (err)
-		return err;
+		goto err_port_uc_flood_set;
+
+	err = prestera_hw_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_port_mc_flood_set;
 
 	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
 	if (err)
@@ -934,6 +960,10 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_port_vid_stp_set:
 	prestera_hw_port_learning_set(port, false);
 err_port_learning_set:
+	prestera_hw_port_mc_flood_set(port, false);
+err_port_mc_flood_set:
+	prestera_hw_port_uc_flood_set(port, false);
+err_port_uc_flood_set:
 	return err;
 }
 
-- 
2.17.1

