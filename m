Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C913CFB25
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbhGTNID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:08:03 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:40467
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238689AbhGTNGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:06:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpBHTlyPJvf32276aAz4JXPMUyue+DDewwRwU2TAPRtkOyxxzvQaeFdC43+Tpj1TbBNkZdQMJQT2mMbN3wfiT2z4OsPLbhgJN9O8BNYSSrXjRIn0f6W+fjcnnskleVwszVziHX8SBAvNFrLFarbbJ7bspXGxooNpi2yWcmwyJ+8YngZrsGNj1P5Yxry6S/rMyjC9ZDm4CgN4Sx48ew2etx8GJllfDFnriYna67YT9RnqDx1WzvOch7UTutKJ0RT9cBQyjW213ezQWeXwW3oNJ1sfAPvr/mpdU8DgKr+2ehsEVfbebNJ7e/AnmlDKinv9BMy+7PwxN0W1z/SMxk74iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j4DWG2oB5ZSG+uXAIUIJKSEvSTanwfJbyyxTGGzw0Y=;
 b=dajBdlsGvOlpyJ8Z9/q6BO//3ircp0Ml2zkiqVz/IF8h86ZaFNlQrovN/KLd8HPRin2uNV4dvqGQabd26fiClsEJglp0r+UOaUTdqcufa7no1rXcK8FjZ/tKC4C+M+j9lRNsf4jn/xdHB2QHC2hIeTEChTrFmYX/u+stteEsBSEjXntxiQUt68wWapOCrtY/Xgu526hIOZvcD30N0IrGNImdcLZKqyLN996STZWUK+15apFxTMtvoUzU/vEfL5UuBZqoANTAiK6+in3oG05tIvvzw3tsNkonndmZRqOCSdHfTjP9a/FTMOtTPK31N4XYd3CTRE4ntwPKddb1+b8hGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j4DWG2oB5ZSG+uXAIUIJKSEvSTanwfJbyyxTGGzw0Y=;
 b=PW8gvqGqTYnVmSdMQb93UCI69MTUPKCDBYmic1ibYB02abVselUVdprbqhjD2WxdN++pMCLRH8rx9Hu3S8lkqoLObBIe+qvnBpavnoVLxuH+sSkZo3HYjG4IJ53ggLR9f6nWAN/IWAgDqPN6gcQLnoidyl4lbgY8TRDfEu07LGA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 13:47:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 03/10] mlxsw: spectrum: refactor prechangeupper sanity checks
Date:   Tue, 20 Jul 2021 16:46:48 +0300
Message-Id: <20210720134655.892334-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720134655.892334-1-vladimir.oltean@nxp.com>
References: <20210720134655.892334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de46b773-523c-4ab1-93ed-08d94b84e235
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3551:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3551E192924BAD4B18870AE8E0E29@VI1PR0402MB3551.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HO9MowUSWnPVxxfjlHV/KWrsmwcansO13dLFEMayp7HEBycVwOSR/qPCstUcnXovWLY+RXOgTpgWBvlNhHxi/V2upv3sp8o2BDLCvIcib/6gikbJNtv7vOwUVtw2y6J5L66HZwJYVWkv5z4wv2u5mtrZDklRxA8DQPr7KQ+DUPm1kfXFvlv0GS/8+N0qON207JPitMUvhy+QFu1W35Gb326KFDe0t0ge4A4IKlmMErREpL08Xwp/6ohGFS0hOGTbEmFXGYfZb+Pu+RzMJ1yj4IQbAx9SMr57b5ZLVlB0H8MlRqDTzo3eMWG56kwzGu/Y9RqD+SFexVR9yKdXA33SR4oFUWQM++irC7BvX6iqXgZdO88J0GKB5Q6HtAt9l9E8jAyVPURYKv0oK8Da6UP2P2gMiW1m0/TB5ucwEQHbrsrQ8ZnUAENjWq5ASdOF/g19lGY7LzA5ClJzDCqA8rqdUWUV2J/K1Xu7srGvOVQ+Wrw6zqR5BBZNo10Kh+Vlg1T7Khac9aXV6fiLn74QgWPl40Kl5z3oL2MvcArCFpHESZQmfgjGZaewjRDyDKyR1cpCZs/Yr9zDU3GdRma/IeYx4p8EXCkxdrWazd/Zs61GOkgZBNdi8TPiZ0FrCSWwg4ehQLYrfzQjd9XtYKTJNwZQnwSGCV8y49Dfd0ZPv+Cu/J/lV2dKPEwxOZo0/1dukDZsdZpPYpjfqvkclTU+Mx2Owg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(478600001)(44832011)(316002)(30864003)(38100700002)(2616005)(956004)(5660300002)(6486002)(54906003)(1076003)(38350700002)(66574015)(2906002)(66946007)(6512007)(7416002)(110136005)(86362001)(83380400001)(66476007)(8936002)(186003)(4326008)(66556008)(6506007)(6666004)(26005)(36756003)(8676002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nBp6N964XEauaYrA8KGAMlk4KVuBM9rNGniJxMiLR+pLDnRKJ0uVI2fNP4QG?=
 =?us-ascii?Q?yfQKePMRgoGWn86zz7CKb/Hj5qDJ6dx77UtD6xA/2pnwJJTFAayGpyrtxbXs?=
 =?us-ascii?Q?hK6EBwHMEXgtFLn4s0Py9BIOD+Pa0sxWt/LcFB7w5fiRfZHHKJueJ/uJHaUm?=
 =?us-ascii?Q?uI6QdBRLK3Hk5yE6oMcsQhTcNv888sYk6PqbPZOJlQW9Ron7UfI0y1KUgJV3?=
 =?us-ascii?Q?zwcyb3rTinuJzNwqWcmLX11q9XgXygQQvVHRxZwT9VPpTuDmJVdBWunWZHrR?=
 =?us-ascii?Q?6UZhy2ATqhkXQaydMC08BaFkFne6tz2LckV7HILebiN8XMw92gsHw9/T16NF?=
 =?us-ascii?Q?fqhRg9oGHugTvEpdbjqNjsJC8nNEByNvWWz5lj4DD+wF1Mfz4+F3VY0zVgpD?=
 =?us-ascii?Q?ZUuZnA5A/+2cM6GMOjNVKNJN5EFG5PvVP+DoHPgl6PLWyLqBlktzIwcwT2RM?=
 =?us-ascii?Q?TTBO8ZIacbCxH+uVnIcL0QF3bLJswGSS1Mz0B9bu70t9Wo5qjAUdstuAOX+g?=
 =?us-ascii?Q?9QW6ba9IRR4D6duULfkaBX8a5uQftM/9tnV/8a6m6UIVDtfTK1/VWRbxb8FL?=
 =?us-ascii?Q?fB8O8ruD8zqP6ZIzrKZZtmlcTVh8SjrkiWwHLgDdl9NEVhbG/26Mb7eOTWS6?=
 =?us-ascii?Q?dnlXYuhTikDsAAClyld4Fk1CIUmnqcn/P+k6BerHJGLh3WBBA7yhHa6vZTku?=
 =?us-ascii?Q?94FjKmb2L4e9rwmm5s5aa0+oX/BEZl4LimPWBsD5h1B3n43hAnZH0YX6YNRH?=
 =?us-ascii?Q?CzPBA0UcFVBOado46C9uaHfBLTVGQDBrsyy8fGJo0MC11Tvw4Q8ESvegJxdD?=
 =?us-ascii?Q?G8orKkcmGrO2T8JYhl7oufTEigI+ycXsoao0CEJTrvBtbccWaxkJ9+NX04zf?=
 =?us-ascii?Q?nDQm+Sbxy33/1NTByM5npKVvObxjL822GHUt7LoBcvSWgIHAOdD2Xihikm0M?=
 =?us-ascii?Q?Mgjbw72vORFnmeWNEK/k9LO4ps7q38qV0FbNX9ay4eTU9jJ/NrvX4TOKJ4XU?=
 =?us-ascii?Q?LCWeNsYbo7JU4UeewkhqIXVmwFNex6f6gbsvgdBrlzTtM1P/0zSIJU7fYkTx?=
 =?us-ascii?Q?gp5HXtDIeSUS7IG9Rc+pePfAEt0F8RfNEvDXIkPymrgbmBR2OcPdvneSWLoQ?=
 =?us-ascii?Q?294VvGlDV2rWBDDvwgNh6QbeNgUHCYW67B6AXJworN/fnBm+xSno0TLPBEtB?=
 =?us-ascii?Q?ekj754hEw9SXIeb4SqmqJeOs1A+l5UiOYr+81f1rLVcO8lgH3B5JMjMNOsi9?=
 =?us-ascii?Q?e1fuYWcc2F6FOw6G+t2DnwA9YDrtWgfvzv1azNK5Mq9NTRQ249kZuglWGIq9?=
 =?us-ascii?Q?sztVD/QFthyWfltAeYdCq5Ru?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de46b773-523c-4ab1-93ed-08d94b84e235
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:15.4623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVrNO1bO/yKlq7cbKzwtP3BYM4pq0IacFDN/G3p2k4dvH/y/FmtE3h1q7e4fFVRYdPj3Im4ewIsjNaY2eezxJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for extra code in the NETDEV_PRECHANGEUPPER handlers from
mlxsw by moving the existing sanity checks to 2 new dedicated functions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: patch is new
v3->v5: none

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 272 +++++++++++-------
 1 file changed, 169 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 88699e678544..c1b78878e5cf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4055,6 +4055,118 @@ static bool mlxsw_sp_bridge_vxlan_is_valid(struct net_device *br_dev,
 	return true;
 }
 
+static int
+mlxsw_sp_prechangeupper_sanity_checks(struct mlxsw_sp *mlxsw_sp,
+				      struct net_device *dev,
+				      struct net_device *lower_dev,
+				      struct net_device *upper_dev,
+				      struct netdev_notifier_changeupper_info *info,
+				      struct netlink_ext_ack *extack)
+{
+	u16 proto;
+
+	if (!is_vlan_dev(upper_dev) &&
+	    !netif_is_lag_master(upper_dev) &&
+	    !netif_is_bridge_master(upper_dev) &&
+	    !netif_is_ovs_master(upper_dev) &&
+	    !netif_is_macvlan(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+		return -EINVAL;
+	}
+
+	if (!info->linking)
+		return 0;
+
+	if (netif_is_bridge_master(upper_dev) &&
+	    !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp, upper_dev) &&
+	    mlxsw_sp_bridge_has_vxlan(upper_dev) &&
+	    !mlxsw_sp_bridge_vxlan_is_valid(upper_dev, extack))
+		return -EOPNOTSUPP;
+
+	if (netdev_has_any_upper_dev(upper_dev) &&
+	    (!netif_is_bridge_master(upper_dev) ||
+	     !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp,
+						  upper_dev))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Enslaving a port to a device that already has an upper device is not supported");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_master(upper_dev) &&
+	    !mlxsw_sp_master_lag_check(mlxsw_sp, upper_dev,
+				       info->upper_info, extack))
+		return -EINVAL;
+
+	if (netif_is_lag_master(upper_dev) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Master device is a LAG master and this device has a VLAN");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_port(dev) && is_vlan_dev(upper_dev) &&
+	    !netif_is_lag_master(vlan_dev_real_dev(upper_dev))) {
+		NL_SET_ERR_MSG_MOD(extack, "Can not put a VLAN on a LAG port");
+		return -EINVAL;
+	}
+
+	if (netif_is_macvlan(upper_dev) &&
+	    !mlxsw_sp_rif_exists(mlxsw_sp, lower_dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "macvlan is only supported on top of router interfaces");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_is_ovs_master(upper_dev) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Master device is an OVS master and this device has a VLAN");
+		return -EINVAL;
+	}
+
+	if (netif_is_ovs_port(dev) && is_vlan_dev(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can not put a VLAN on an OVS port");
+		return -EINVAL;
+	}
+
+	if (netif_is_bridge_master(upper_dev)) {
+		br_vlan_get_proto(upper_dev, &proto);
+		if (br_vlan_enabled(upper_dev) &&
+		    proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Enslaving a port to a bridge with unknown VLAN protocol is not supported");
+			return -EOPNOTSUPP;
+		}
+		if (vlan_uses_dev(lower_dev) &&
+		    br_vlan_enabled(upper_dev) &&
+		    proto == ETH_P_8021AD) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Enslaving a port that already has a VLAN upper to an 802.1ad bridge is not supported");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	if (netif_is_bridge_port(lower_dev) && is_vlan_dev(upper_dev)) {
+		struct net_device *br_dev = netdev_master_upper_dev_get(lower_dev);
+
+		if (br_vlan_enabled(br_dev)) {
+			br_vlan_get_proto(br_dev, &proto);
+			if (proto == ETH_P_8021AD) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "VLAN uppers are not supported on a port enslaved to an 802.1ad bridge");
+				return -EOPNOTSUPP;
+			}
+		}
+	}
+
+	if (is_vlan_dev(upper_dev) &&
+	    ntohs(vlan_dev_vlan_proto(upper_dev)) != ETH_P_8021Q) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN uppers are only supported with 802.1q VLAN protocol");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 					       struct net_device *dev,
 					       unsigned long event, void *ptr)
@@ -4065,7 +4177,6 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 	struct net_device *upper_dev;
 	struct mlxsw_sp *mlxsw_sp;
 	int err = 0;
-	u16 proto;
 
 	mlxsw_sp_port = netdev_priv(dev);
 	mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -4075,84 +4186,15 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
-		if (!is_vlan_dev(upper_dev) &&
-		    !netif_is_lag_master(upper_dev) &&
-		    !netif_is_bridge_master(upper_dev) &&
-		    !netif_is_ovs_master(upper_dev) &&
-		    !netif_is_macvlan(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-		if (!info->linking)
-			break;
-		if (netif_is_bridge_master(upper_dev) &&
-		    !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp, upper_dev) &&
-		    mlxsw_sp_bridge_has_vxlan(upper_dev) &&
-		    !mlxsw_sp_bridge_vxlan_is_valid(upper_dev, extack))
-			return -EOPNOTSUPP;
-		if (netdev_has_any_upper_dev(upper_dev) &&
-		    (!netif_is_bridge_master(upper_dev) ||
-		     !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp,
-							  upper_dev))) {
-			NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a device that already has an upper device is not supported");
-			return -EINVAL;
-		}
-		if (netif_is_lag_master(upper_dev) &&
-		    !mlxsw_sp_master_lag_check(mlxsw_sp, upper_dev,
-					       info->upper_info, extack))
-			return -EINVAL;
-		if (netif_is_lag_master(upper_dev) && vlan_uses_dev(dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Master device is a LAG master and this device has a VLAN");
-			return -EINVAL;
-		}
-		if (netif_is_lag_port(dev) && is_vlan_dev(upper_dev) &&
-		    !netif_is_lag_master(vlan_dev_real_dev(upper_dev))) {
-			NL_SET_ERR_MSG_MOD(extack, "Can not put a VLAN on a LAG port");
-			return -EINVAL;
-		}
-		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_exists(mlxsw_sp, lower_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
-			return -EOPNOTSUPP;
-		}
-		if (netif_is_ovs_master(upper_dev) && vlan_uses_dev(dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Master device is an OVS master and this device has a VLAN");
-			return -EINVAL;
-		}
-		if (netif_is_ovs_port(dev) && is_vlan_dev(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Can not put a VLAN on an OVS port");
-			return -EINVAL;
-		}
-		if (netif_is_bridge_master(upper_dev)) {
-			br_vlan_get_proto(upper_dev, &proto);
-			if (br_vlan_enabled(upper_dev) &&
-			    proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
-				NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a bridge with unknown VLAN protocol is not supported");
-				return -EOPNOTSUPP;
-			}
-			if (vlan_uses_dev(lower_dev) &&
-			    br_vlan_enabled(upper_dev) &&
-			    proto == ETH_P_8021AD) {
-				NL_SET_ERR_MSG_MOD(extack, "Enslaving a port that already has a VLAN upper to an 802.1ad bridge is not supported");
-				return -EOPNOTSUPP;
-			}
-		}
-		if (netif_is_bridge_port(lower_dev) && is_vlan_dev(upper_dev)) {
-			struct net_device *br_dev = netdev_master_upper_dev_get(lower_dev);
-
-			if (br_vlan_enabled(br_dev)) {
-				br_vlan_get_proto(br_dev, &proto);
-				if (proto == ETH_P_8021AD) {
-					NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are not supported on a port enslaved to an 802.1ad bridge");
-					return -EOPNOTSUPP;
-				}
-			}
-		}
-		if (is_vlan_dev(upper_dev) &&
-		    ntohs(vlan_dev_vlan_proto(upper_dev)) != ETH_P_8021Q) {
-			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
-			return -EOPNOTSUPP;
-		}
+
+		err = mlxsw_sp_prechangeupper_sanity_checks(mlxsw_sp,
+							    dev, lower_dev,
+							    upper_dev,
+							    info,
+							    extack);
+		if (err)
+			return err;
+
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
@@ -4260,6 +4302,46 @@ static int mlxsw_sp_netdevice_lag_event(struct net_device *lag_dev,
 	return 0;
 }
 
+static int
+mlxsw_sp_vlan_prechangeupper_sanity_checks(struct mlxsw_sp *mlxsw_sp,
+					   struct net_device *vlan_dev,
+					   struct net_device *upper_dev,
+					   struct netdev_notifier_changeupper_info *info,
+					   struct netlink_ext_ack *extack)
+{
+	if (!netif_is_bridge_master(upper_dev) &&
+	    !netif_is_macvlan(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+		return -EINVAL;
+	}
+
+	if (!info->linking)
+		return 0;
+
+	if (netif_is_bridge_master(upper_dev) &&
+	    !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp, upper_dev) &&
+	    mlxsw_sp_bridge_has_vxlan(upper_dev) &&
+	    !mlxsw_sp_bridge_vxlan_is_valid(upper_dev, extack))
+		return -EOPNOTSUPP;
+
+	if (netdev_has_any_upper_dev(upper_dev) &&
+	    (!netif_is_bridge_master(upper_dev) ||
+	     !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp,
+						  upper_dev))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Enslaving a port to a device that already has an upper device is not supported");
+		return -EINVAL;
+	}
+
+	if (netif_is_macvlan(upper_dev) &&
+	    !mlxsw_sp_rif_exists(mlxsw_sp, vlan_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
 					      struct net_device *dev,
 					      unsigned long event, void *ptr,
@@ -4277,30 +4359,14 @@ static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
-		if (!netif_is_bridge_master(upper_dev) &&
-		    !netif_is_macvlan(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-		if (!info->linking)
-			break;
-		if (netif_is_bridge_master(upper_dev) &&
-		    !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp, upper_dev) &&
-		    mlxsw_sp_bridge_has_vxlan(upper_dev) &&
-		    !mlxsw_sp_bridge_vxlan_is_valid(upper_dev, extack))
-			return -EOPNOTSUPP;
-		if (netdev_has_any_upper_dev(upper_dev) &&
-		    (!netif_is_bridge_master(upper_dev) ||
-		     !mlxsw_sp_bridge_device_is_offloaded(mlxsw_sp,
-							  upper_dev))) {
-			NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a device that already has an upper device is not supported");
-			return -EINVAL;
-		}
-		if (netif_is_macvlan(upper_dev) &&
-		    !mlxsw_sp_rif_exists(mlxsw_sp, vlan_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
-			return -EOPNOTSUPP;
-		}
+
+		err = mlxsw_sp_vlan_prechangeupper_sanity_checks(mlxsw_sp,
+								 vlan_dev,
+								 upper_dev,
+								 info, extack);
+		if (err)
+			return err;
+
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
-- 
2.25.1

