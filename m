Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E92139614A
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhEaOi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:38:26 -0400
Received: from mail-am6eur05on2100.outbound.protection.outlook.com ([40.107.22.100]:22081
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233451AbhEaOgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 10:36:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3XMUFUWoTpRSds/aIJ7O0sL1IJrbYT/byRVrVucEgn/BD3beL1wxSWtICSNdATHSlIB/5hJuA9yVbLjqmPxXpRYHL/+iPfi3sqXw/t6d1DopeACkC0fcXxJJf1WRXIjdgQ8pGjMi0ohwybPK3iJsfLkeZ0294rPjLnO8YbzM/vAcCjkhf/V5/XtiV7fONt5FK7dBdQLMGURhXkSTgFKivFz1fDaFpbvcW7ggG1MxMY1+XlLywArdyc0FjoiId/JbzYHE+F1RshL10Tyy3Igi2E1ep79Ou6SfgS5E1YBAckgrQ5CGNXMSuWPdI7gZCDCEdm50GVHu5C7ou+2sVpWUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf+b96qSAq813cgKq/ot1vZgZ5KyDl4odPL1rVWocyU=;
 b=ho/DcpNcFq5iQRtX4RWvd89eLzxXX/53LZxL5192D984KfFe9mOVfJoIAypb3XJLEvP0TBv1jUTkXVGjG/y/bHGZP2oxr3sTVJ7mvHK6tXqVYLrF+uxIACbKlJaltC5QplYxRr5ePHy1XRepLQlvm6awELW+vLv15Cmz703rVCEEQc0N0B9AMHsvc6SGga08ezmMUWpJgvdqwX0tsFV2oZrbJh9SeML/rrFVXHcWrS73Kf5nEnMqhlCpxm/X6Vnr3Gu1tfTBz7crMCZXfXC5d+ORQZStYwK9cH3uscvUQeZa1yz6lpAsQSapWde6/7pykjoZKoweCTyXLlJONiweIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf+b96qSAq813cgKq/ot1vZgZ5KyDl4odPL1rVWocyU=;
 b=pscOY9SMXrkeL4h/7h9S+8/oF0iODQOqzDDgTHvuP3vEs/t3sZMFOaMg9PO/UxMGy27W4f5XZfy/PwbLarl7SRmcnfxDEigXJkZdUrNrmsfm+5fqK8XxVG8WWFSOQCGEt8w52kgfEBnULKaQOxpNzKgUj37SCh6zkbjN3O1mERk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.29; Mon, 31 May 2021 14:33:26 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:33:26 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 2/4] net: marvell: prestera: align flood setting according to latest firmware version
Date:   Mon, 31 May 2021 17:32:44 +0300
Message-Id: <20210531143246.24202-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210531143246.24202-1-vadym.kochan@plvision.eu>
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Mon, 31 May 2021 14:33:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e164827-9c05-448d-c2f8-08d924410d27
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04590140AAB181F29A1929D7953F9@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4C/JQeSZUhmL+m1FG8MEDtEbGgSqD6iQaA2G8aXhTPry3URMnuIhkWNyVaGBKfgA0r9E10aAV5dOQKK0JOe80fDPavztCqYR7ufXl8qvvcsSTbrLveGksCdgVJvlszVG8Uqn5piOi8TVycmPB9h0a+8VNDK11MV7xJtwcHFT38IXnviHTlg5WdWmvGh9v8BKD5fR5+zSSruiAYf9LudVwJ+O0/RWJU3Vt9yNo9zQy6COVnFe8/+5FbcntX0v1ZfqRPIq9X5k2fDHz++RLDaix+yybKFza3+A2S76nb39NSo8CzMQ0IibiYs951q3DRuYfcJKQ7dnWEBlHW6tAwxwA+7TUVGQ1+8Ndj2Mzum9OG7w6FNnnu9ayE0NdKkqcTbHR94w/fS171lL/O+GPkBQwMqmR3bfIjlHFcfMngel6ogZCY+1fURF/JzgYZvqsf6F6+jrfX6aaLHVujknkYCdvHrLL7VNx+H1EAgpg9YnrAbIH2p8tnM7LpiK0MBGFuKJtqRfYQJ1hR/gJF25YkUqu6ev0y/sfM0Qs783aoYWIdPmwRSt736fCgTT5OA6h/9n1kMQCfKILTFlOgPb4DZXH53K3F3VFLK18+ioD5dwwtBAwP5daFBCt9UtUMmmlyeavl1ow/sr99rrjSy0Wn5Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39830400003)(136003)(366004)(16526019)(26005)(5660300002)(6506007)(8676002)(2906002)(6512007)(6486002)(38100700002)(38350700002)(44832011)(316002)(186003)(66476007)(54906003)(110136005)(478600001)(66946007)(86362001)(66556008)(2616005)(6666004)(4326008)(36756003)(83380400001)(1076003)(8936002)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x2us+XJGF4mj3+NtQS/KHjZg322+yC+ngKu4y2WNjRt7ocrZmu1/8SYt+a0R?=
 =?us-ascii?Q?44B3Nl83TOsANuJSUVM8Bw6trqBpqgMsT1FP6AW3L1W+ko6Vur9fEUtntOk+?=
 =?us-ascii?Q?D5O8DTiud6CWHOowZo5gSa6+8+p5v7QcZp2kZ/zX4S+uWKnauyzuAu95oHbA?=
 =?us-ascii?Q?ddakvwxfNYMjjFgflARdZYLa4JRKeUy2A03nOecuuXtm559VJkwzFRJ3sR2Q?=
 =?us-ascii?Q?1pgzT+IIEVTrPP2sCYc0wmrbHCgNCfAkowKp93rgUblbz+W8QVTJeaQnf2UN?=
 =?us-ascii?Q?KVh9saxQMY7IosagINWo98Lk/E+7CNGWNFaA9PcINe8pVzDjnsQXJ286nEPJ?=
 =?us-ascii?Q?8v/709S71hvc5pzSq4EDeAqDihebFyU6OyCEZP7xtO1Fy9cxT1SSSZUmjNJ8?=
 =?us-ascii?Q?CdUQRopJ7UXmcWFexSFYAtO3EDG318CH4Rh++aNVh4/5ZgJlnk1g68vw8aQ6?=
 =?us-ascii?Q?hB2eJ1JOeF8hO4oOZI+lexOVVEKp3DPqLqcYuodzscXZUoze5MzlPIe0XGCl?=
 =?us-ascii?Q?oi3qAfGYozxWod9HBeJ2K7W5vS0onlTvwEoMxtuJ9yZp715cm1lQM4F6k8T/?=
 =?us-ascii?Q?eXdVhCOAMkEOdxM4yK561/FqEWHupYxkLKJ2J0mm30Q9D3LFI+b3Qm1DlMY7?=
 =?us-ascii?Q?v8IifhjM6SqWu98urMYcp4BReK0GR0/7NsD6FJ66RTzTU1wIneivf2K33/Yj?=
 =?us-ascii?Q?EWltvXOmVXUiRJ57+sTWRzvEHFiyBhO4a5yzmxxp7goKLQAGhLn7MutbvMGT?=
 =?us-ascii?Q?NLJWyWex9wdPO0psZ0NKQA8TiydHkwyuz1E4s5f0HNzsT6HnryYFWyhSRV9Y?=
 =?us-ascii?Q?xAStMvyEjeEBXqbg/DJGjqT9YcBCAAhQKhxD5+2xeSrYU3TYkdWN4ydJhYBu?=
 =?us-ascii?Q?L/SdZLm/eyP2TsZjo/hN33a1fJRfYnL0Q2LpvvPVDha8XjawUsGYoL8l1db1?=
 =?us-ascii?Q?QCOJ2qQWoZ3OiBr89Ze9P3Y2CRriF93QV+KLEpb2eaPhqi5WpXnwvSfLb/4E?=
 =?us-ascii?Q?1P28SxvDJcbA2u75rXIP/RCELUXmAVW19jop2Wn+eHu5KLUjzqZvlkCU/Gig?=
 =?us-ascii?Q?d08yFsU5IXdk6FtY0lQrZEgSpS+xL+LOcXaUzF+Tt2mQjFxEciwg8mk94Z8v?=
 =?us-ascii?Q?pD5zcVQ+NP47Q3thF/VU3AWQiheK2/Qq46nhJYf8tPVpCgwtwaEHvpzzhhbc?=
 =?us-ascii?Q?5yIEHpGXMFAgjYQtlnwfhfglYaocnd502Wp2Rf5/wBXBimMtdK5HGgFFHDF8?=
 =?us-ascii?Q?rXLCaj6CliS86M8u/PccsawLD2YGA+OqmX6bgijgZYGnWmIBHowgfb5oAjeE?=
 =?us-ascii?Q?no1NX4o55vwD1YGBNGFsK4Ov?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e164827-9c05-448d-c2f8-08d924410d27
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 14:33:26.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKcwYr6E7sI0982jH4DdzvA3KIVWgFdmksNHF0yo/duaOPLmErI8aQuNNRpFAHJb9WBUeODSw8IdHFgPMILNPx9bagnZbXNw9ffOdv8njMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
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

