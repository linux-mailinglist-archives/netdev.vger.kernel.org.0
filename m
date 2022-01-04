Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF394846C8
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiADRPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:15:00 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235488AbiADROm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRla3XfqL4XDVNEWCMhUOR3/OB8ZInJmjDAIvt/SauRlrh0RrT7vs6JR7lubA7xrgvFbKsCpWcuW+teU9CUSb0OW1uPrMXm1waDfDDZZ9NeGc0dxoxymxN/rTnRifQj8gnt9Num+1PhHpk0g4BOrLhtxaFR8M4IXnTuenbPutBb71tgkkD7Wi1cOV0c3A7uw4Q1MPXY0gjYg6gooQBHIHqdejwOxjsSqfvFCtfKpQ+Rfdvzhlnj4qAJX+NpMAu4c4P62MAs1fhGHfyRq7vs0lttAJHdC+9dnf8qWlfbRG9OpphwZsExd8OyjSJQ4vqEyMZnoNbk6YRWs9zBBHMz3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qKKK1v0H6WnJ/I33xVohokZ+mbI2plGz1quPNQqTPI=;
 b=BIIH3zFV+TbrDmUAoU/ZZQhiFbTXW+vCMq+YZSp836ZAgu8xNfR3ilf0tZQs9pTn29ujKyf9UcJNvZM2EsO8PE99NUmgUPPdr45cxiF18KOrZ+jurrnCZCmhdRYnqnGm73LiSM8fWK9HrJrb2EEdbU4nmiyLGkFl5X0Rk09MQScHFovGdfJq7xvsiM/bpTmDkDgPstKys91n2ncDdiPVeqJFve6zjJ9U2vUGNwBInyJQYY1INFjHQokTGNAev5TGVessgDvOy4mS7pjY/22zlMfjVGPCC3QfFJxAX1sTux68304Edmz1hlzG0Mhxj6nIJoeOxYzkQm6IIB7dQydvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qKKK1v0H6WnJ/I33xVohokZ+mbI2plGz1quPNQqTPI=;
 b=dz86x8gIswrgtlZuP14mIpZERQMKieKTvuJEgWPlmhEvgGmaqFZDVRBE/cpG4PxmWIK+asZ+aZBVTuv/IbN+G4l4fW4YoWG+JnghBWZvJN2PjuondKcD+PEeUZPtXDTr8q7e3XfMy3f2QKpm06EiOQIJpEjd0dgrRt7zwpARLm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 08/15] net: dsa: remove cross-chip support for HSR
Date:   Tue,  4 Jan 2022 19:14:06 +0200
Message-Id: <20220104171413.2293847-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4a6508c5-330d-4512-8626-08d9cfa5afd4
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB710481D6ADA20828FD85E71FE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZq3wXliclxODIv/2wxf+5BtADLoxIdefD39RUauGFa6iEMhTLUcrt95q0zgmXncEiTR9Uq+xyezcTIBq5XFi1vFK0gQsCwNz37AYzL/qVEgdcVW4C7zlT1Dl2OThQzL+vH246YI1KBct/ZR+yelH6d/8xpNWWqZMNpXtdb/DrbwgXG43lXXsUWhacZ1UvtMgFWeYlyk25vtkW6KzpENlXDGMSalbi1dDMUgtgZHY7h0oXSy4KdM1P/W7mZhhfKS7XRnNhahvyhR0E4HwLeAxNj0vmxwN/0VOfiqbKnWKiW8uiWc/e7Uf8/+WdZFxwcIP8FKyGdOZjeu5Y5qtlS1YTCyR05tbMypiMDvV7pcyQumJmcylJCiF6grkeTsDCS8u0BvEYp1KMuaYQF0qPkBaBXU86anRB6w/iMDRfWoPR3HwQ6Efs++/ga7aPHCEj2WZp+Ozgmly6tY8uyTGIfcE96F1f27Pb6vyob6YpvH0q8jqEDC1T6ErGMk37ALmTmFiYjajRNwqyc1BYvgbOXvZa+5IKl2LCRmVRrzTqycs9yGJUOdYkmWvycw6U4MoXZg2Q2xbOIpoZ+t/xgPhDCEIDy5YuDWxkagK2JqqPAup1zo1m74JZf27jrVS0DXUDvqK3XcPdAITX7iyXZDAsLa8T0Z39IjBax4anXC12aL++sZslfhtFUWVgW0R5e0ynBuaUunhx2tPvf3jfkgVfIEPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I7WForWJHAvRUahTghULWXJrx9fYO2K0KeIJJTMT2hTdbFbCXSLNc8h8vI3f?=
 =?us-ascii?Q?P+ejBhu0Di2LKY4WM4VCXo/3e+Y/UUxYvBXj4UVykp3Ubm9LQKk5WcO7G7UF?=
 =?us-ascii?Q?TR+fi0aPjMCxKrJlWnbnnElarU+cKApY7M3VuQmYuU/L9fP6PgV258UNTc9q?=
 =?us-ascii?Q?a3//hsmXmbX58X/spI1vMDygWU1Q6QHKdjXrDthZfm7f3GdsZDQid38vuW+I?=
 =?us-ascii?Q?A736B3lxyAyR7LQMPE5IGXs1c900VRwVzG469yx9ugcfi7Fcm+3UP34A8B6T?=
 =?us-ascii?Q?iKw62IlgLfQqK4RZcbP8NLcs3d5b7w5W2A3ioosCYkQ12PKpX0zh+SBKZEcV?=
 =?us-ascii?Q?7x+j4QczMmApfd4UUF3Xcns4S/hlCpdgCNJMQcnOPxcRqn5zoNZwWpBZfDJo?=
 =?us-ascii?Q?vTMaZNS6qx9xenw3tyL+ZB2iPUdBvbroOvhow6p72lxmpnsEqAqX27dz4luV?=
 =?us-ascii?Q?FwREUbNfgzQaNSSpOdD+F/VgXikyQYlU1Nz/z+3KtcCqu98rnFIDxkkexeX/?=
 =?us-ascii?Q?v0yEymhiRxOEvR9JiBFqzrv0nnUHzDOO27T/kCpWzx/DSHKt36MA3Fh1ulgs?=
 =?us-ascii?Q?fBhnrRV8jXaM2E3KtqvA/KE5wpGLVDiPyXcCv0L96oZowOOuBxAaXJMvd/kx?=
 =?us-ascii?Q?d+KQA8bPNu2ryjMF9vGSrL8d/Cd8op/CcHVznUSrmlXv/SdIsWkeNcyaiL3u?=
 =?us-ascii?Q?8jaG/OIIJ9AbnEXdflrEYeCGsFE5S0BNmwS16Crew5WC+5dKtwkGiwIFTjCG?=
 =?us-ascii?Q?7c/47VbIH1ZmI2Ndx7OA0BVyQLWn5sOoJppKxfG01wvp+/ZE87Fr5g1Gnm9S?=
 =?us-ascii?Q?UQXsh3RjbElwEmy+mUXBcP9usY5hAAX2tnnjAJjAqzc+yaGnmfmD9JVkCLci?=
 =?us-ascii?Q?q7getXtNWuVHJI6qFpOxVLEP93oi+vXMyDncUndbONf5MkFutUPnvWjOZVv6?=
 =?us-ascii?Q?MEF8wLqrzTXmcmvpbqgpqmd7mC8LhpM1FO7Dhx9RgHJQioyMYrtSNfQlRlUF?=
 =?us-ascii?Q?ThkIbmVA1CvBiqXztjouHSsQv6UvctdWs7V0yaIqLSBhFPnNACx8fWJAdDQg?=
 =?us-ascii?Q?dI8BSpNohibdYJuJLf+3yIY6RauzSLRdI1WMh3jezo5cqZUQA4vmjDsXOrhz?=
 =?us-ascii?Q?ijfwyQLWT1RcOSzZGpcXc+s7C1mW576xFoayJZXq+B1AXaujQMhF6j48EQJt?=
 =?us-ascii?Q?LydgwQvHJxPiNXFQwqmu5BeWLhIeWilyDsfCgv/cPAE2+S4K5JdmCu9z0XPw?=
 =?us-ascii?Q?5L0MVLBw0V8gIXDSVwW7/m/EfOfTeneeUHQSTfrMJXSKdxJH5ORavYlA7bcy?=
 =?us-ascii?Q?RU7O/K3Je5Z5w10vVrOtVNMak6fQsMTvK5dkLEpM6uXofRgNQ/zhHMeRxP+o?=
 =?us-ascii?Q?n/isIDEOJgHUvj4JANi5OPkXwbdx4HPOFtTKWMB3vxihyXnCA7JJ91Fs/7g4?=
 =?us-ascii?Q?n676TxEpcI3Z+Enqhb5qD1zkRnKjPrDmxjTIg8Bjha79pTW90ccCpDI4zpn+?=
 =?us-ascii?Q?qzLNeYeNcL7/eIe9OjzIDM4vRuXbjsHZEwA5g27CWpXgBUt7pVCkfuqh6S9N?=
 =?us-ascii?Q?M4o7A12DXruaT6xpvxqWCS9iuDkfNryxW6EomryWty+02tqTLJi0EIldv3rJ?=
 =?us-ascii?Q?ZITAqYLy+XBXr/dZvSXI7P4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6508c5-330d-4512-8626-08d9cfa5afd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:37.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zD0IA5pdF+MBefzA1Ws1EtmcRmH/QnPDJBn/fjt5R29BiCxwer850fFfRDArmE2jB5B6hamBxhNMH4P5qzhrgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cross-chip notifiers for HSR are bypass operations, meaning that
even though all switches in a tree are notified, only the switch
specified in the info structure is targeted.

We can eliminate the unnecessary complexity by deleting the cross-chip
notifier logic and calling the ds->ops straight from port.c.

Cc: George McCollister <george.mccollister@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  2 --
 net/dsa/port.c     | 20 ++++++--------------
 net/dsa/switch.c   | 24 ------------------------
 3 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 54c23479b9ba..b3386d408fc6 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -25,8 +25,6 @@ enum {
 	DSA_NOTIFIER_FDB_DEL,
 	DSA_NOTIFIER_HOST_FDB_ADD,
 	DSA_NOTIFIER_HOST_FDB_DEL,
-	DSA_NOTIFIER_HSR_JOIN,
-	DSA_NOTIFIER_HSR_LEAVE,
 	DSA_NOTIFIER_LAG_CHANGE,
 	DSA_NOTIFIER_LAG_JOIN,
 	DSA_NOTIFIER_LAG_LEAVE,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5c72f890c6a2..9e7c421c47b9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1317,16 +1317,12 @@ EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
 {
-	struct dsa_notifier_hsr_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.hsr = hsr,
-	};
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	dp->hsr_dev = hsr;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_JOIN, &info);
+	err = ds->ops->port_hsr_join(ds, dp->index, hsr);
 	if (err)
 		dp->hsr_dev = NULL;
 
@@ -1335,20 +1331,16 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
 
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
 {
-	struct dsa_notifier_hsr_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.hsr = hsr,
-	};
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	dp->hsr_dev = NULL;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_LEAVE, &info);
+	err = ds->ops->port_hsr_leave(ds, dp->index, hsr);
 	if (err)
 		dev_err(dp->ds->dev,
-			"port %d failed to notify DSA_NOTIFIER_HSR_LEAVE: %pe\n",
-			dp->index, ERR_PTR(err));
+			"port %d failed to leave HSR %s: %pe\n",
+			dp->index, hsr->name, ERR_PTR(err));
 }
 
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index a164ec02b4e9..e3c7d2627a61 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -437,24 +437,6 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
-static int dsa_switch_hsr_join(struct dsa_switch *ds,
-			       struct dsa_notifier_hsr_info *info)
-{
-	if (ds->index == info->sw_index && ds->ops->port_hsr_join)
-		return ds->ops->port_hsr_join(ds, info->port, info->hsr);
-
-	return -EOPNOTSUPP;
-}
-
-static int dsa_switch_hsr_leave(struct dsa_switch *ds,
-				struct dsa_notifier_hsr_info *info)
-{
-	if (ds->index == info->sw_index && ds->ops->port_hsr_leave)
-		return ds->ops->port_hsr_leave(ds, info->port, info->hsr);
-
-	return -EOPNOTSUPP;
-}
-
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
@@ -729,12 +711,6 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_HOST_FDB_DEL:
 		err = dsa_switch_host_fdb_del(ds, info);
 		break;
-	case DSA_NOTIFIER_HSR_JOIN:
-		err = dsa_switch_hsr_join(ds, info);
-		break;
-	case DSA_NOTIFIER_HSR_LEAVE:
-		err = dsa_switch_hsr_leave(ds, info);
-		break;
 	case DSA_NOTIFIER_LAG_CHANGE:
 		err = dsa_switch_lag_change(ds, info);
 		break;
-- 
2.25.1

