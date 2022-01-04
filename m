Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D1E4846C7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbiADRO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:59 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235304AbiADROl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1tQAeaxuvd9D0px++1IvIFFGGJKCX3XA2Xxi4RjOTkPtkJEEovyEFQdzZWder97qi47RlbjfSxV36ce+oVlMG+TEorITJmu2QL7WiD8/RYS0VEDuEFBU4T/wAACuFQBnRgSEKDVVtW+pEU0zonFf3upPivJC6HbNOylsGKfRYTGot59Fx9M4ui2mhYaZrAhTCeIIu32AAMCzwu0CZ1W5Uf7JLS7Cz3VDIxfDdxkiB8S2ak3LwJwOhUT05eFxJeclO19oHpPV+xFpDIp5LsC14vdcPsE79f64XW+jGL0Met3uLGs9byOxbb4FreaoIK56TbiYrGmyqcQAmqmHlPP6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p16nZpv+liy06gFtnHqaguLKddgtC+JiSEGxXUF9d1c=;
 b=lsHAZTVjZoJ56tegaXxh492VOPdklC3jLw56wFD30gUg0RRPfu/7b53mqa0vIWh3PFtEMBVxWBmirm8zktbqtA06YeOndejvfAAsQXLklzUZ0tWwmGnnbrUOVgqoTumVSdTnVcBKwjz8wdQaKPXHv+09lWmVUnv46YNU+MFB1iPSlYpRBo94Gn4KAqLkuY+hyqZISyjNnocs9baCy0JC56jbvhqgRQixxprvSrbPCehjoyukHgm5doX/J0bDDjAaSG7aBvxVvE7nXlUgBAgQrva7I+8coDR5EgMkNA6Iv4BfsAGk4lMgQvwxmG/497ANIX1FdyapYEuUW9z3bp7M5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p16nZpv+liy06gFtnHqaguLKddgtC+JiSEGxXUF9d1c=;
 b=UWHO92Zq8VrBn2GYD1R97AYHCep09eQuE2bLZZxN7dcLIXw7lEm/gNmXvDLuXbKDiB318fiqzNLvc/rtd42hClip9+uQuSVyl9+YYxuKV7Lf7PtDsT6/USLyFQ6CBLqdpeP8ya3YS+IWz7dabaYx94b4EyY7H2DmhGJCZYmxg0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 07/15] net: dsa: remove cross-chip support for MRP
Date:   Tue,  4 Jan 2022 19:14:05 +0200
Message-Id: <20220104171413.2293847-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cffb466-4741-4eec-f265-08d9cfa5af3b
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB710432A23FC2B2E5133207F1E04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Xj7LgJP22a6q91fZc8qrCgVOXbKFzWEgwd/3LKcpn9fbjho6k8413vDrhE7XVpkJq7iySZwekJ4N/envMw8dzou3e/TiuquG4mymjbp4zWxvZrvxzcZ1r80ivSB7mbE2ujl0lqhccy62CInCd74P1m0qInvPmcQTZEcOLjmzFi7Xg8TuXqwZVfHQyS+iHDwyUEf1LUT4Pm/3z5S/N7antC/m8hvIm473pK3ryL8y86HzjwHmIPkGM38dU2bqMw6kewCL2PCbK+lUyrGMrjtlBbKRkEJiSkn3j3GZTxu7+jDCMT5aqm8ayLFTuHpqzJO3u4YO6QMhX/4vMMlkqhXN5fgilgLIe6m8ivEKlKOfzhsmEz0g0x0l/dfkq6WxVDWNa00oqTosBCwqIS1Z2s5g5ADINFii3xLTF406yJXbbzar9qh9VElAFgSj+QMxv68gL8KTBP2x7H5YIhHDCxGWgtGx6DQjNCV3xtk+2xWK8WleUn/QWG92nxclLkNk2NwHnHVR5/sVrVmwKEC29GbAJ+UOSUG8V2OVgbH71L+CmlmodpQlGCpynS4X/TncAhzU/9eGkTZ35Vv0FPtceVL7OQwHYvxOdfyDDK6GAPIMswCCRG36gY9kMYb9W8X51US64eYfutNs4uUSt/S1hjQqpkab2Kpo2b0ysTMw2MDtjAyFdHF2FKZg844583uT6Ukbh9OiEVfhlNUtEjFYvdOBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6OQ6KPd3mu9NW0VOYkdgIFQe3KAqHRGrTksVMzLmUHvTUq5yxrNvbj20cZ9E?=
 =?us-ascii?Q?lbQanx67F9R+/Q1ChXSPF8p1wAJt+f8FAS5FYZrjCKCsCr8o5XAwjin6JuLp?=
 =?us-ascii?Q?Yvrfpkh8FZ2uQkzVn0eytWSWcjk5+JptFggpiyfz1wRHMJRJt4UUHE6pR73y?=
 =?us-ascii?Q?YWWgjOGG+D/xwmk/RrSBqWWn04eKJdbbpwl1q+ea9npvf/SAASmBCRU/S53W?=
 =?us-ascii?Q?BQGGY+pgiJF3PthIdMnzHqPjMTAhEGm89CsFyQrsKHOlCt3f/zHmnhzetDxg?=
 =?us-ascii?Q?YbTXcaMF/E9C0ubOy2KZ5AE9f4F9Z9SWFlufNxviw5nAwU54vlEasmORHewO?=
 =?us-ascii?Q?3ph13HoQFDm+ZBPKxN+trY9iM2z2306gLH4/UaFd8vkvDIilcckt3H4qs8QZ?=
 =?us-ascii?Q?7X9QFJWoUJJ+i7iof3pOBBpKsIg6GFTR0zndqhAqBUO3DoDq0A2JL3tbqcLU?=
 =?us-ascii?Q?vizoOfC5gwUCx/fquyl7QFm6QunmqgOcqGMVJ3ZfpqzFX4COUzx7gPB2zCkH?=
 =?us-ascii?Q?q0iDMiUOxvr9pDvJe/5gUdvLBioSlGJBVKinC0CsSP6usFcXoO01W49OdKIu?=
 =?us-ascii?Q?Kg8OwOeXZEtykF/lLWR41XUJS3ifuVn0+GLDlVaruizp6Eqcm0T7XqresDhd?=
 =?us-ascii?Q?zZJSV9QqATI6Nhf5x7q01xtA5bsoX3MBQbOluq2Kj8SSBshTmusVh1zfldxo?=
 =?us-ascii?Q?yCJU8wgZS3kbo+aidQP/kk5R/gNtBShsx1pWUm/UUA7USMPtsLbfnilllXgR?=
 =?us-ascii?Q?Tbmnn/nFCimYwu/fwUhRutlCKVeWJ0TbdaDZWXDAjBiYf9PitlQrZiANJfJN?=
 =?us-ascii?Q?usqSev7Cgt9Qce9X23bl1uz9Sf1q9pnUz8RQf6PoJBlx1qW/y3ajTM5Ox+iI?=
 =?us-ascii?Q?TMxvhFZ9D9mpG+tc16C7Q8LNb/H5IfqEIkHZbl0RBgQ+Yu7gZ6FNbKQ3Spzt?=
 =?us-ascii?Q?2fji0uMqk9of+P8fQ19Hy066vm2G3sNLWkKaJeMKp1yHtOERzBCzQQkv1iP2?=
 =?us-ascii?Q?znO7N6Jq0pccOsGrZHAg+v1iiaIIcO/+tUldYIwzYnlLEIFZGPVg5DR16e3Z?=
 =?us-ascii?Q?1jO1tt32Tj07jF45C59+KEr9bXrpErnZqkBj2RBLFl76jsPBOwXF7tBj4BFu?=
 =?us-ascii?Q?m2DfMb8cTcpbGP4sld+ccTI2t2NkWzIQh4pDE/5mcmnZgvf2lq/+ViYvfbtn?=
 =?us-ascii?Q?sJaU2SK/ucH/m5TZUiRKH9LYeO1NcUd18ACVd+aVDNgV9WpHd9CNv+xYyWUL?=
 =?us-ascii?Q?Xtpnd3rnoudJKFX5HKoa5J7asgbCkaKq///oulF5IM5pEryutGrtkX27TlHv?=
 =?us-ascii?Q?/bii9k0ttlcgBGWoAkdF0rFQSn4WZmGxeHY+UNtueVX84OXZ7ww82cEOuRHn?=
 =?us-ascii?Q?hhHWPOT2x0T1KdpynstSxAIbttAHzT9URZgnuLalr5BVJ9l/sP3QEgJ5Vcs7?=
 =?us-ascii?Q?+/7JhL0GNGAnnNTb/FqVKJHaS7yAl1IzNHZh1+rhWnMvU1wtdxdFn+7Ac3G7?=
 =?us-ascii?Q?ROWEq8CVWQhtopUQ5ItwO0/6fox4idvPxxs4ULVbz46LYKgwzwzrQNfHm2n1?=
 =?us-ascii?Q?1l2rxqBaZQwA0LbrkPnAtYbaHBfi8eMYJlpbPZjsGmYxI7gXhsuepZGgwrfz?=
 =?us-ascii?Q?TDbXbIIItTTNq30QHcJm3Go=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cffb466-4741-4eec-f265-08d9cfa5af3b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:36.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTRZAiqFzsnu2GCtoGvWmihfrNGWuxcIv51lSq1oGH9EnwhTqjurWutloKirxGcxA5p1KGFA0QnyFTzN7e/iUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
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
 net/dsa/dsa_priv.h |  4 ---
 net/dsa/port.c     | 44 +++++++++++++++----------------
 net/dsa/switch.c   | 64 ----------------------------------------------
 3 files changed, 20 insertions(+), 92 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b5ae21f172a8..54c23479b9ba 100644
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
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 05677e016982..5c72f890c6a2 100644
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
+	if (!ds->ops->port_mrp_add)
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
+	if (!ds->ops->port_mrp_del)
+		return -EOPNOTSUPP;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MRP_DEL_RING_ROLE, &info);
+	return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
 }
 
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 393f2d8a860a..a164ec02b4e9 100644
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
-	if (!ds->ops->port_mrp_add)
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
-	if (!ds->ops->port_mrp_del)
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

