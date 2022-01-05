Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4948535B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbiAENSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:18:41 -0500
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:24383
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237077AbiAENSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:18:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtJfdR33WHxVS1uTXBhiTjeD/HbmBCkr1lL7OjWSvawN7aQjNvtIRZ/ZPBqKKIzFBY/VcocJmCNxPFGy4B/ZzsSrTY++HyXdRheweapFGTWbg2eSNMkOFhnnCZ65vricuGUKU8vhU5xrtG72yevTt32sjzA5EhtLAgw0ifSbXO1q9BPG/cUcwKr5wGKu6POU/HsZye6D947fXEJqGFphkD6UwL1z/SM4nhFSfdJX5bjeCrZgXn0/j1lD2erCxV/d55yrcgWKqxhj1pa1DB0yF5zDCMNwx1O0CqVlJXI3pDsV+SJtZV3TnJ+N1gWjnvdgkfqEP+jOgA8MfuCi23TwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElbCvXDCEaGH2SMOR2QM5fLQDSHHXOcL/NWlJVpi7HA=;
 b=fJ6NLC9OnOHdzsY0mpuFkLnhb63Qfa0BgG5e+5UFvAd0AkPc+KnpoyPRvyvBeu0I/wrr355jDQ8a4wHGMY0cHTljwvA8ea/QFVUelI23ScHndPuiemMmsdlJPL1ERbm4WSY97Yr5wxd0h8UOGxDOrdfgQIvSUGzstHn2oFEqOzroYRme5F3dXp0AfQ40UPR62Rz1DLogMCFovKs7ieIkYbCLQ4UkGAbTH1+qyCzb1Piu3nAjbDmizkuYj4Ifh4i1flL7SevHb71YXqywCP1zRUHbWs6SXOUKeXUAdd7jiWoArsHRXR8CbTkhVfJPxE5WURTZHzmvluRSRI/acXF9pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElbCvXDCEaGH2SMOR2QM5fLQDSHHXOcL/NWlJVpi7HA=;
 b=pCNWM6m4lYnPfv0ciFDQHu8R1LOQ5d+/1IiqH59Oj4p+iT+ELMyfE6wg4NJNsc6fmO6NPsON1fjK5LsAW43Xo8bzQrlDku8al0UUNradmd9IMCGV6ExPjbil6t16h8wFIj86d12NNBuawQv6zYB2B9lH8m95dgCELXiy6VvwHx8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 13:18:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:18:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 3/3] net: dsa: remove cross-chip support for HSR
Date:   Wed,  5 Jan 2022 15:18:13 +0200
Message-Id: <20220105131813.2647558-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 741f495e-4fba-4149-8bc3-08d9d04ddb0c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB69421510430D1B165490D7EAE04B9@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmNlFd86Xee3XvnibZ3gENovkOCrsnkcNU7nrqop+nfAUr3MNd4bsxOV4zFbWwpFfdHujyeSN4Pxx5YGRc+V7tL+1jZZU6WvnLO0EiDEPOSW/bnElN6D4EY/4MfB+1Y9bMnVehzxqM8TtTrlEON+z8kRafy8znV8toN3S4dKH4kQgycwnSC/mqPKZX6NpDPyd67m+YFw7MBPI3OaQMjzpOb8V1x6Ku7UbdhTeS74NjlG8byNer3oF0Zfb0AfBvs8e/4hFWfgqx6j4U4z5nK6En3KX6N4/n11P+JHP62MnxJENO1mjeNm/IyI5Fx70nE8ba+j/bo6JKakO/CKmG2pqxagpP/drTON5nsxHSZywYG64y45jx8Y8lv2+qlhpdl/9KsWAB8XHjtYw0QSOMgmZUDf6WKkp62/q6SWp4gAIvwpRzT+dFxiXsbLzGQKc0DIZFfFmn0E4IhKxUPxweI+wXll62LinhXJe/iTFpbrnKGQO12poG32WPtux9yLtZNUP23A+Wn/8JH5Nwm/v+jPHkRNn0wmLmJH6YxA4J3CmDfkLvFBt3+vY2TJjEymzikoXkDyVWfWME5BieNzhCEAnEp2W/FQAc/3iwG+7cthQ2c056k0iqvoUwy1R2Pt80Ng1oUcnU8cSLovcOU2Gnr03qEzLXvs/xEarTcCSEYBUhMfIhvdkB+4+RVdqtl1Q4kKT5HRQKxxMYhgwr8/m2P6Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(8936002)(6512007)(83380400001)(508600001)(2616005)(6506007)(36756003)(5660300002)(38100700002)(38350700002)(1076003)(6666004)(4326008)(44832011)(316002)(66476007)(66556008)(66946007)(86362001)(186003)(26005)(8676002)(6916009)(2906002)(54906003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HySDaajGxXewmd62+qrlKmR8p0Uj0hyevJnvzQTltM3t3MRMTICbul18HxGH?=
 =?us-ascii?Q?H4G9YEOXHr4gXDFDGDS5dAr9kWTkP+ZRQsK5V+Il+Fi1oEVLC7DpB7KN1hzA?=
 =?us-ascii?Q?+7W4AYvnBEkmmmXXsK3W2oA25LRrccPQELFWsBkYVy9FhNn7f8deZ+nn74n9?=
 =?us-ascii?Q?4ERR6slTua02grO5mQNl4WTu475XbETq+bbtZJ2p/OjN5ljCBEkHMX+PmGf2?=
 =?us-ascii?Q?lhGMkXG3DE7wmU0nuUT3DsXuGEfAm7/CkVa1LRxzCsFxBxFXP30iVRE61xWb?=
 =?us-ascii?Q?VooM4yTHMvWhKLTqVll/oUE2CTXRkUvpBSHnu3IM0VyfIQACn4oRCmMO+nHG?=
 =?us-ascii?Q?tnbspJ7sW/QcSYOnWRZNxc7wK5Aw7VxwcSfwDwfbyM5xAdRmfQ0rKs/7iQER?=
 =?us-ascii?Q?hLoo6WH6k1gUjIugQ4s0lZ2bOU8WvZUKS+zNrRQ/dmdUCop7OSb5MILqjpyo?=
 =?us-ascii?Q?MajrOCROTAZiAJIiejNjnjV/mHbqTwZAhJHHhKxIe5D/t1eqFgSTfbhoT2Fw?=
 =?us-ascii?Q?cQT6+VUskoTNM/Zbk92adeiO+SYrULaj2TMsz2EG5L+cCPClAz+b6gl2lIdB?=
 =?us-ascii?Q?jp/0FqgfyGEOFbI7Gi/RSCgELC3/2PksaQdzftLcQb+ibPuuVkcVaJo13yzb?=
 =?us-ascii?Q?MmOzXd/zR7I+54H70LqGTRpvNzuXiaDwUakRxy/bOlAWARODS/NbWoNGTQFw?=
 =?us-ascii?Q?pET/snh2flylER7kefq+D/ypUSKwd2zebmo7keJw3Sp1ztsofs8lzxKAoe9j?=
 =?us-ascii?Q?KQPmz5r2tjogc3B7MR7rVndS/b38JIIDXRwaqaE7deFPwqLXOsMD10q8ueBI?=
 =?us-ascii?Q?giLGeYmQV5DNM95r1Qt7K5Sx9FAy8QiJO1WggffyN83aQmd7wvI9USHksW/b?=
 =?us-ascii?Q?0tCdDkghGrttIEWc0Iw0o/cA2+N2KXHsZSbP3ab9HfxYJH726SSuGcMhyBht?=
 =?us-ascii?Q?Acrav7yEX6Z2UpnLObwocOrO2jx0ea2EUq9S6yoySnxVO5E2ycL5bxDRoCXf?=
 =?us-ascii?Q?BRcU6jeV/5XfGVDZGyG7UJAmi6yPXfdjMRlAA7YgP9ClCi2VwgEZ6oT1OY9h?=
 =?us-ascii?Q?MN3ZhFNajUjRcaYFOZEufAji1Nlf9gwJUtbjTJ2hfa+JS+AO6MWGbw7oAPrf?=
 =?us-ascii?Q?fSoCNVIKCOeHGlNj4tkTOeoSxOccz8Pfv50RhlNGskzoC3dP2IBBknCrmtqH?=
 =?us-ascii?Q?l5pUtJaQsV9AG2bj/m909/CBAuPaLNlNBtJ2rpDxPC8uoGvwThfFGyld8zJu?=
 =?us-ascii?Q?/6Jlvnn/jJmAmkZ0wMhPiXaFd0C3IYbAOMECUMG1JDAN4j7F6vK1WD7MM68v?=
 =?us-ascii?Q?Rmc7KW4lkhfsui92ZlqdtkgnYNeS1+BvyiCe82XZDUraEdrYgrQajOshZx3f?=
 =?us-ascii?Q?A2zvyu9wSg+zgwkgqdGbYpVDafKGOviErPIh25x8mJ6PmC/bB2uRWuWDnLdS?=
 =?us-ascii?Q?wYKf4ohbVla8ohcpvd0L662O8OL7xN+32Buh1oAFIZQp9vegkEkQZL3J/lIT?=
 =?us-ascii?Q?0aOn8f46G2IWCxP1Hkh/lgUe6x8aI1Fv43AEXgP1AFEPeXClKpbr6YM0V3Tt?=
 =?us-ascii?Q?O31FsQV1NecaUb9ascWd4vrzK3jap4O3HRs2f7oR/Zr/o1a9EwXxpCHi+ktc?=
 =?us-ascii?Q?/+M8WPZALGjHwQ0Xbqatzd8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741f495e-4fba-4149-8bc3-08d9d04ddb0c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:18:25.7602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94VY4rI4HKeWhDVDbclPkUMHlxQkQYUVSodRCIU+LKGdVNqQra2CMBieUQEnn/6vpuyNAFFH5SqQPH8UAH7oWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
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
Reviewed-by: George McCollister <george.mccollister@gmail.com>
---
v1->v2:
- delete leftover definition of struct dsa_notifier_hsr_info
- guard against absence of ds->ops->port_hsr_join and
  ds->ops->port_hsr_leave

 net/dsa/dsa_priv.h |  9 ---------
 net/dsa/port.c     | 29 +++++++++++++----------------
 net/dsa/switch.c   | 24 ------------------------
 3 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c593d56c94b3..760306f0012f 100644
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
@@ -125,13 +123,6 @@ struct dsa_switchdev_event_work {
 	bool host_addr;
 };
 
-/* DSA_NOTIFIER_HSR_* */
-struct dsa_notifier_hsr_info {
-	struct net_device *hsr;
-	int sw_index;
-	int port;
-};
-
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 05be4577b044..bd78192e0e47 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1317,16 +1317,15 @@ EXPORT_SYMBOL_GPL(dsa_port_get_phy_sset_count);
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
 {
-	struct dsa_notifier_hsr_info info = {
-		.sw_index = dp->ds->index,
-		.port = dp->index,
-		.hsr = hsr,
-	};
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
+	if (!ds->ops->port_hsr_join)
+		return -EOPNOTSUPP;
+
 	dp->hsr_dev = hsr;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_JOIN, &info);
+	err = ds->ops->port_hsr_join(ds, dp->index, hsr);
 	if (err)
 		dp->hsr_dev = NULL;
 
@@ -1335,20 +1334,18 @@ int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
 
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
-	if (err)
-		dev_err(dp->ds->dev,
-			"port %d failed to notify DSA_NOTIFIER_HSR_LEAVE: %pe\n",
-			dp->index, ERR_PTR(err));
+	if (ds->ops->port_hsr_leave) {
+		err = ds->ops->port_hsr_leave(ds, dp->index, hsr);
+		if (err)
+			dev_err(dp->ds->dev,
+				"port %d failed to leave HSR %s: %pe\n",
+				dp->index, hsr->name, ERR_PTR(err));
+	}
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

