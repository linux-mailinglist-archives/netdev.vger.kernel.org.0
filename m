Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4888048535A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiAENSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:18:31 -0500
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:24383
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237074AbiAENS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:18:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrZhvideN+JhgrCsq2vEovRu3ycXSV8BfrmS8t6hQitZKh06nlshgE8cqmNnG44hVR6L3x2esaC0qK1Zrr8uyjhqFMLOSoyg4kPJpmvMlSYTW6fZ5kNSyyDK8EhQP7NqsA7QlmLrGpw0TdpO9ZJjhh4yGWqXgRjIXjv1xirA4Q5tQdHTfmSX5/kh99HKdbuQVfw4/yjSl/dTT8gWvLS3hR9EYC/7u9zwNfWvwEHY2SezEjBwUb69v0zn1R8yZDLtkOBVzzzz9gr13k3RmdNfFl1Ae+Y4nZuGuvKPdLGEOjHRYHyNqXEpQT/Hj0TgvQh6UjBBK1Y8mGc2vsQqvIiW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5cnKkCIVO9FpCrLXWpU9V+tbKe6rGwVN049sIBnwy0=;
 b=mEsAFCuqQUEeCUAi7OvyWgWA4MCUEbvkoMNLlg5At06aObHmR/PP6vYoN7mk1C6anGhAqHF/zHW56pRjp2xIv/7WxxKHRGdpEpRKXETNse0yPhAUjc1hFHv8hVAiOj+tSx3UDcELWiG8jwkgS5sevTsTmWfATnY5rpFbslo++K/y3ONhF7IoY1dqmFJ0XLpmW+5ZDChi2XbSs4Cyo/cKJstdNZydmFIRnY+I+gng26lWZrem0IU9h+SviOhe2KjbNEMdfo7Z5Q3EtUtMduiO6vbROi0JDELyhWw/VWlPlVD+9DLE6xOhByB7UQ81l+ogSoON4CQiHxa8kD45qYlOgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5cnKkCIVO9FpCrLXWpU9V+tbKe6rGwVN049sIBnwy0=;
 b=Sbv1DRp3JbCP4MDX6CHu3iW5zyIYRt7AQdvunW4ZZ8d7fPqDQoKenO8WY49446LzHEZUV2LqqvXZoHywxOha03KpZ8aSDMAUFyCYU57758DuGN3b5bCBla82nqNHzIIMbHrc1PnYsFSPkuuHnAE336c2qNcW0EQ2kLrGKekYVe0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 13:18:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:18:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net-next 2/3] net: dsa: remove cross-chip support for MRP
Date:   Wed,  5 Jan 2022 15:18:12 +0200
Message-Id: <20220105131813.2647558-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
References: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0106.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 429fbc38-39b7-44bd-45de-08d9d04dda82
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942541292747AE791B47F24E04B9@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RSqg2zScCJREvr2vIVPJg5oxdOGDo04bB20WffqR5dInsTBggNMNPQwdGG31fI3XdkSdHo8a/4rXFF/9jQjbMBba6JXK7Yh/HNQrdOB23ehv2XNr7MiifzQ/Xo0znvboATkAKF4RwKWwj485GmBwK8mtSZNnOIQee3xoPnuPPm7shxckgOiLwIqSxEZxUGmuTE2P2uFP5FULqj3fO1+O7KR13Ge6kJ3MGcU4DgP9sV6l1U0gag4IvFQGvFkFtYFiI/TG8TI/EjPLcXBV4J45XfuG9OWPP69SEzN0wGMNa3czmmAEGweWjvjcRlMYyAnp3p1C19jBT/8lk/YaPH2yCC7qbS80JGyLkel0o2QxL0jFsJ3/om0CZLENokpIP8AW4FyO3JMsb3bgFYDxklbN4aXvToGv3OqArMDIvIMbra1EAFEPupXGR8OJ6KbDzukK7ZQp3Q5tBOatIdiIQxjX0tvfG2jB1752swxrVyBHvfNwkokcEGPPqBmyW9N3sWGgGcrnaTCd5kUIMWPvsuIvwi5cZvdfjqoNFLTlwujcNpinBnuhmUCYP9q6OgKvBRgwv7l7L/Xvgn+bag3xSB2O5tIzSE2zWN0woFjae32c0jUSshf8UYC+XN6ulbbl0yeywIEyNiOGYPLzZtjrH/KkSDuSSOFSvaqLXdchDSWkxbsWpfk5kCZ5I4coVwzQemrOOdhMwTKzcyUHkYLxgeXWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(8936002)(6512007)(83380400001)(508600001)(2616005)(6506007)(36756003)(5660300002)(38100700002)(38350700002)(1076003)(6666004)(4326008)(44832011)(316002)(66476007)(66556008)(66946007)(86362001)(186003)(26005)(8676002)(6916009)(2906002)(54906003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?trXjEjhG98Pr8U49gRQMHtRL5F1MyTGRuMYfX1pZ6/IlcxLmdyWlb4VviB6u?=
 =?us-ascii?Q?uIbtjJ5bYa++Zx3+u+wJlaYJq7nHsmfQAnBV/5p5n4LP7Mx2Xa9fzPCUa5DP?=
 =?us-ascii?Q?/S8/I0NL6xfKE0O1cXXD+IpGztrXXQxBbiTvJTRYnapXJGaSgJ6FwGhfzuno?=
 =?us-ascii?Q?BSfadxM9eXKSJh6UnEDidtcE9DUzNZcS+JqeAejBdrj78Q+PWm7OOzOyly/k?=
 =?us-ascii?Q?Zcn5DSmX+z8GxyX5hiPrESR75IZSjqIVfo+4qd35Bd0ZYHkxaE7btY/NK4J5?=
 =?us-ascii?Q?TvC+wVnrcxOJg9DIE3E+0ec1IpNlru/BAzwozsmy7xvNPhGTBER9yaVX4iva?=
 =?us-ascii?Q?AiNL1/xcSlnHl30uKQzrnjHHSOzXblNqdeRiitWP+hxmc3Gsm8DeJVFwLf45?=
 =?us-ascii?Q?KM1bYpblBbGA4clTiH+jtKXdK6SrDdnIIe2jGXxJVHZrZOSROmC7phyps0+h?=
 =?us-ascii?Q?yc6v0iCwfeWvJxDHa1UvwO2mOBC7SnQB6v5ydwDTdM/oqUW3QHWb4e77znoq?=
 =?us-ascii?Q?8bLt/STz+LtynKoKLNqyu3QO1I67oKxTiFjjBHlYmH3uAgVxgc8VfvbIdDw9?=
 =?us-ascii?Q?aeSZue/CbltVVAKqSDNXiJsM44nWbKkaiew1+CupMWbgpFuY4WbiIUJFEqBy?=
 =?us-ascii?Q?fkyI8aJVCR1WCQwF+g8BOvHiJt2lmpUWQ2n4bIpi6W4U9ucpPHIdsLY7yQQh?=
 =?us-ascii?Q?vCgT/Mjqj5z3sPmt1s0m80bKRdupUaMTOPTo08MBJWziRLf34IIPRLJzcU3v?=
 =?us-ascii?Q?CW8WjzYysPASG3QjtbRzSFrIJitQFpErBRGhm5QOlJsma3JeZ18Ajx5Wi8KK?=
 =?us-ascii?Q?S3VKNVQmXFc3izBG0qU3O+YPxweFa7PuwO+tRW1pyqZ7PDIMm7gUk2u0oPRc?=
 =?us-ascii?Q?3mCo11QBPNsgcKxCwt7982YevuEfiQTOxY3k4jNP4gePeyLlmqZNaTz3toYd?=
 =?us-ascii?Q?HNJmokhWGLkkpheek2rUlgfiqbi7C3hV5bYw+358mudmLub2bt+JxSTbPFl6?=
 =?us-ascii?Q?bE4QnvU3Y6BFQTUUpAUa5syXIFU2511vTJFk9jKYHPJ/2bhUmlJhEAJzTSoU?=
 =?us-ascii?Q?tVxR9aQ1vH+rB1qmfFKHQuyuFsEv2Uv7u0MpuuSr7TU+z4jgUen43vcsE6NU?=
 =?us-ascii?Q?9f8f9DVUPYF7F5lQgXP9+NJTiEoqiE7u5i1G5N06MeSHWHL0lYoq9a+DP3hO?=
 =?us-ascii?Q?LNMGWCa0FES8EULdrGL7n1XvQ1r+sAxPV5kxyYM5vbvBxrCMaY/1gmxvBMgZ?=
 =?us-ascii?Q?gUgd2fZy94VBvHx/T2hqUxcYd8zUsqHCM81wtsQph6QLuICdUlzLgZ1DXGYx?=
 =?us-ascii?Q?/zjvN8L0IGbG1CUCJApuNTQqQx+FtFVhOYvkj8IJtQR0D0J5JRNYwGLAUsKZ?=
 =?us-ascii?Q?t8BB2S97CgLx2vcfICPdYe3Vpkdu/F5/lmXdhveDXfggrhlgn5fphDBcSJuN?=
 =?us-ascii?Q?4eOhv0ya3CJk7h0y+VRdk0kp7uIxEIIEthTMISPYLHilpaK8Y8WgUGVMp0eB?=
 =?us-ascii?Q?sP7jTtxrkcbOKHWaUSs/ZCP1Iw+/e60+04Pcoe5+W7CQoGUH/DVpyRVtpTnU?=
 =?us-ascii?Q?KgQgZ2ETh8ioXo3XaqZRTfrtct5McN/LrWTP6cVnyKEHP4CXVIxegZ/Xvr1M?=
 =?us-ascii?Q?Uauc0q7y+aSa+h8ep/zle08=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429fbc38-39b7-44bd-45de-08d9d04dda82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:18:24.8228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ep4HP5ylhwmOVHmJNTHaK5ZfOc3PwMUxsqCb7RmWXJdAAvnhxXgLmpQo+v4w5iFnunazmY/SMA2onaUmb5E8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cross-chip notifiers for MRP are bypass operations, meaning that
even though all switches in a tree are notified, only the switch
specified in the info structure is targeted.

We can eliminate the unnecessary complexity by deleting the cross-chip
notifier logic and calling the ds->ops straight from port.c.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: delete leftover definitions of struct dsa_notifier_mrp_info and
        struct dsa_notifier_mrp_ring_role_info.

 net/dsa/dsa_priv.h | 18 -------------
 net/dsa/port.c     | 44 +++++++++++++++----------------
 net/dsa/switch.c   | 64 ----------------------------------------------
 3 files changed, 20 insertions(+), 106 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b5ae21f172a8..c593d56c94b3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -40,10 +40,6 @@ enum {
 	DSA_NOTIFIER_TAG_PROTO,
 	DSA_NOTIFIER_TAG_PROTO_CONNECT,
 	DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
-	DSA_NOTIFIER_MRP_ADD,
-	DSA_NOTIFIER_MRP_DEL,
-	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
-	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
 };
@@ -107,20 +103,6 @@ struct dsa_notifier_tag_proto_info {
 	const struct dsa_device_ops *tag_ops;
 };
 
-/* DSA_NOTIFIER_MRP_* */
-struct dsa_notifier_mrp_info {
-	const struct switchdev_obj_mrp *mrp;
-	int sw_index;
-	int port;
-};
-
-/* DSA_NOTIFIER_MRP_* */
-struct dsa_notifier_mrp_ring_role_info {
-	const struct switchdev_obj_ring_role_mrp *mrp;
-	int sw_index;
-	int port;
-};
-
 /* DSA_NOTIFIER_TAG_8021Q_VLAN_* */
 struct dsa_notifier_tag_8021q_vlan_info {
 	int tree_index;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 05677e016982..05be4577b044 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -907,49 +907,45 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp)
 {
-	struct dsa_notifier_mrp_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.mrp = mrp,
-	};
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_mrp_add)
+		return -EOPNOTSUPP;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD, &info);
+	return ds->ops->port_mrp_add(ds, dp->index, mrp);
 }
 
 int dsa_port_mrp_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp)
 {
-	struct dsa_notifier_mrp_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.mrp = mrp,
-	};
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_mrp_del)
+		return -EOPNOTSUPP;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL, &info);
+	return ds->ops->port_mrp_del(ds, dp->index, mrp);
 }
 
 int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp)
 {
-	struct dsa_notifier_mrp_ring_role_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.mrp = mrp,
-	};
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_mrp_add_ring_role)
+		return -EOPNOTSUPP;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_ADD_RING_ROLE, &info);
+	return ds->ops->port_mrp_add_ring_role(ds, dp->index, mrp);
 }
 
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp)
 {
-	struct dsa_notifier_mrp_ring_role_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.mrp = mrp,
-	};
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->port_mrp_del_ring_role)
+		return -EOPNOTSUPP;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &info);
+	return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
 }
 
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 260d8e7d6e5a..a164ec02b4e9 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -701,58 +701,6 @@ dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_switch_mrp_add(struct dsa_switch *ds,
-			      struct dsa_notifier_mrp_info *info)
-{
-	if (!ds->ops->port_mrp_add)
-		return -EOPNOTSUPP;
-
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mrp_add(ds, info->port, info->mrp);
-
-	return 0;
-}
-
-static int dsa_switch_mrp_del(struct dsa_switch *ds,
-			      struct dsa_notifier_mrp_info *info)
-{
-	if (!ds->ops->port_mrp_del)
-		return -EOPNOTSUPP;
-
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mrp_del(ds, info->port, info->mrp);
-
-	return 0;
-}
-
-static int
-dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
-			     struct dsa_notifier_mrp_ring_role_info *info)
-{
-	if (!ds->ops->port_mrp_add_ring_role)
-		return -EOPNOTSUPP;
-
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mrp_add_ring_role(ds, info->port,
-						       info->mrp);
-
-	return 0;
-}
-
-static int
-dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
-			     struct dsa_notifier_mrp_ring_role_info *info)
-{
-	if (!ds->ops->port_mrp_del_ring_role)
-		return -EOPNOTSUPP;
-
-	if (ds->index == info->sw_index)
-		return ds->ops->port_mrp_del_ring_role(ds, info->port,
-						       info->mrp);
-
-	return 0;
-}
-
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -826,18 +774,6 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
 		err = dsa_switch_disconnect_tag_proto(ds, info);
 		break;
-	case DSA_NOTIFIER_MRP_ADD:
-		err = dsa_switch_mrp_add(ds, info);
-		break;
-	case DSA_NOTIFIER_MRP_DEL:
-		err = dsa_switch_mrp_del(ds, info);
-		break;
-	case DSA_NOTIFIER_MRP_ADD_RING_ROLE:
-		err = dsa_switch_mrp_add_ring_role(ds, info);
-		break;
-	case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
-		err = dsa_switch_mrp_del_ring_role(ds, info);
-		break;
 	case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
 		err = dsa_switch_tag_8021q_vlan_add(ds, info);
 		break;
-- 
2.25.1

