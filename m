Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D173CCB1D
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:21 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:24552
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232582AbhGRVtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOdHdQfMYEzudGzLDZEsihfv92yVgve3gemMQi2kJ8K6Cdb2yx8WqKonuemyltU9H/JJiVnJZ+SwW/wzTofmt2AXoMfxZa88cMHKxc1/Cux/IwZsgussgaMJtZWuOp+u59+sl2RxB2U53PBjj/cTOntQ03ugb2NA6NwFgDCNOtBkoSXnyO1xkHgA3m4aUXGcokYpWdFHzVPZE+YkLn3Gej/uhw7hBFFJZGq35xXK+g2hU5iGqxk0YBco9XwgBrf8MEh5IYkGOpNaUJ27MGz91HmMnUshHwXnevsd0YeFB9g/ke+IaYFlfgtnh8zx3PFljdiznbekZRUx2/2giCe5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7kipnqE2/cIM210xLYQxhZcLux8caCuodjFgWG/qc8=;
 b=SPsfM85KqI7f63dQdTdby2N6UisJi8Qh960DSGiq8Gouej21Hl7Uc2EPRPQ02KxtBiknvnoem635uYO2DhuVU+8o5S/UulEcYLtlQ3RmwjyDmU6ZgWbmX4D47Hr8kYXElntNcp8zYWOYNegkX/VKCN/XLBG1+HPAdQ0yik/BqMs2P9VGV/wUIH7XSuQR3tKHI27XVy7Rf8XHLRJyIkX+1y9tRrcYvDDlqSYJ6McULoSRiERBq76+GV+yMhYL0KcIVqGwHI8n8+kzwHY0ZWU/wMR4huBaIiMrIkXU8Pn4EbXqHNeNgtjaktr1LTLVvTRHiz1EJLRK6YGPGeMis1ONXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7kipnqE2/cIM210xLYQxhZcLux8caCuodjFgWG/qc8=;
 b=FnIM+/eH3ACF8z8N4INRwFu1dS3HuMtjhx/IE6UIFtgjxRczoKHM2DPKMUR9A7SI+WCFokTi5WyyblOy7iPyVh5MWqKJAXwYd7Dj32N7sHkBo2weghLrVujTb7Ic8EfOev0bvvMpEAbJ/7D82CHR817yTDlLl++zmRUDXwzdlGU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:12 +0000
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
Subject: [PATCH v4 net-next 03/15] mlxsw: spectrum: refactor prechangeupper sanity checks
Date:   Mon, 19 Jul 2021 00:44:22 +0300
Message-Id: <20210718214434.3938850-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d0e14f-739a-42ab-629a-08d94a3575fe
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7325570266DEC8DDA31B0EEEE0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0Rqr0t4W8pSC0otOkg01efVvKvQr5ozC9r635vmjcFdPNOJMLsoalmoqBAH+c2tIUbnXwVzq1vf3NjfgaW+WVzPI3E6XThSh1FyV2PeBCsTW158fxf+U6qicPk0CVIp35x6JQqjPka0nh0RhRMJbzO/k0UgA9mj+JwiHNPuESt18k/n32WEkVpXh85zIy44T5HXWWb6jblNQ8RDY2gqlthEnLTIzIF9ZWZEwzT4r6WEvfOhloOlLsLoRBZ6ggDhVNEiy2PzigQu52PvmehiT77OvXKt0ACfT8GXh3b9SSstEhxRdJbWGc0ZxGoaZFiJH0ugIVP4hFamUE55UBG7XwQbFB+MAuw17bf5OVik4VH1pV3Tk18FzTXl1CV//SyvmY3qOEHA2MuzIlRgJVRfv8g/ycp0DGqtZYXRCnACCdMXs1WLdEgAT/RO1AY3GRSRiSeAnlgoFZbDrsTap7eorwHbqpqygin4fdSglU253U0C6OOAw445R1MbtTkxmJbaNF+r0aLdTqMopm/G3hEp6MwgBgpmUlYFxdIwDvlv768cGfEkyjiwui+GxpAxv3oi77QYRC/iEgfucLXyvglloA14fzBfLKXMpNOW4t/9oef9G7udYJp1fKNo85/j9rGo0VELT95ODZyys8tVD6BLbkr3Q2EOZ6EXfXScmOvzkQKYr5NgpYFxgf9eraHvPv3SSQvIUMhzpZehBzpAdqsWug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(66574015)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(478600001)(36756003)(6512007)(30864003)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4eokcaTfCgQDB404amB9B5EiES+EAY5PBuzmqcOAyImSeXl0PWfKANU0mf99?=
 =?us-ascii?Q?vzXcabVmJUED71kOaCIRO+KfY63k/b74wgqa0vvKku7bWFq7zSca4YHEqHwl?=
 =?us-ascii?Q?IG5mebGzUj9iBidpmKH/ckfC46mj9cdM+NMIZDROM3GQu5SicYD8sTWQHVFG?=
 =?us-ascii?Q?0AA1QFQ2fcsHS58Btz2vDqKuDVAr65Ht9NttOd5zZFn651U4mXEJwK6w7qqr?=
 =?us-ascii?Q?ky7szwz2AWL05kBNaypcq7girOHaoGPlPM918yzSHO4aurfUply9gzbNn5Hv?=
 =?us-ascii?Q?xRhjEuanWKhEFolQ0dCgSLPw26Wv39bJJcJ9UYapQYKv74qCEcpWZdijO7Pu?=
 =?us-ascii?Q?jc7bAPA/XEwuJogV49IYLdxGGbh7l+x5tJ9R3tiXb2UV5B90Pq6qxdronCrK?=
 =?us-ascii?Q?Eo06ofBCQqOT6MS2neW+S0zU04IJ2A7x1aEizWYNpZ/xHKCRY5euD5WNrwAr?=
 =?us-ascii?Q?Ky3bvf4KG7eG0BWo6mhimdS1uIamddZqwSCODC8KZfxUhHjGbARWpnoKJM0K?=
 =?us-ascii?Q?r39Hrtrb4YSZ1K1XmS09+xYuCRamuIm/p4IjjMAN54bpWpSWW/xYS9ZrkcDS?=
 =?us-ascii?Q?hNquca+pjE0USoITV/EJbusHu1KvIG2jqSCKGAms7tQkP6CTz8WQUE3Vhn9b?=
 =?us-ascii?Q?VGoHB7UPqPXheAZqj5DvfSbFB8jWIgI+6iaAwu16o6ffBMN+fdaJPHlt1Eq8?=
 =?us-ascii?Q?X170TcTTLLr2s5XbxBgYUUWCFeufqXhJrPQ70TOyq6CoAyS6gB8IMj8Bvmmc?=
 =?us-ascii?Q?y6L426WQxJVz8tECj0RbkEOEeg/E3s/1rj2xqrHDe5bncuvNxziOHGOoFPfp?=
 =?us-ascii?Q?dRCT+399+GDZnf2gcOMC+JqD2hIJ1qHiwL+xhNH4loz/VwwVPs0gjawRNKYH?=
 =?us-ascii?Q?VMeFnp2Uqjqg15RTVZYVYoVCiM/LtYLK27UKwaDBIkjneAOp2mF8RNA3WYU4?=
 =?us-ascii?Q?ImgEPIRodyBab4X6j17Ss87ITtMvH9odNowGJMUcwxo8f9lWQsOghA070F6u?=
 =?us-ascii?Q?LpmVErA0oWVJk5Tkke6UyJ01fZpH1Makhqb2YtqlLvuYs5Zk/V1F7WXDk3wo?=
 =?us-ascii?Q?fdBRsk8ql6q0yhTS9XDYUdp+YkcBeXRQ/EbLfzi7qwLba7rVcbcSGbhrtEWh?=
 =?us-ascii?Q?+Y6j6NWk6A5gytbBHJuNnIT3IsFkZ5paNYnVOrM/rNoOaL9LRIbegYMcsFEw?=
 =?us-ascii?Q?9c7FPkpzmtUxlIidTv3pbRRaqKRJuJcjx5CUw3ppldFDdmLW+HG6JVuQXq87?=
 =?us-ascii?Q?n3tUkbgs9Q1xCSMN+oinbzNCwON27nqSj2QmBLm0cCiFVY1sbL6BGAKN5lr6?=
 =?us-ascii?Q?s7uN8wZENcU1GC7ob55EdETp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d0e14f-739a-42ab-629a-08d94a3575fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:12.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUG9iI5tqTCDiWXnI3+kTmZu7heblKrIJ8QO/imO4SLAGJlvJKohsYp15h5+E+CVu0b/DTMjOgYiGZ8i7TB1Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for extra code in the NETDEV_PRECHANGEUPPER handlers from
mlxsw by moving the existing sanity checks to 2 new dedicated functions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: patch is new
v3->v4: none

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

