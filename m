Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B459F3C5F05
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhGLPZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:04 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:27617
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235425AbhGLPZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGHNQQjM/o8G6uapC0CR0lsZptxH6u8plHvrgeUmNusFH5BHe24/KTesiPvolYGPYO/HBJR/rIa9kt6ARTO4yvxwEv0RlHGZHTPz1Uqlmqz6Hb6Q0wvDtEEzVfLkQToeRKhF8hstgaXB79DwwbjMeqWg2kiNgOweq41ywXmHAgnxxxJsV1UD0B1b3wmIZs0/SXMG3ky+xAZhuOH/wAW0A9qcB4Pagb2ceh06QFMxPW7hw+zJNjcxIPrNKtSNDd93bOiKsbszOAFdFS4J/crblLIwj3+GKlLTqVdwuSqZ3OEmTQZs3hlJojH8jRuxwN4C5eIONw9gdQ4DMjoC+oGKeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q12W3iGzdEe9ki7sY+sZvz0z9fOy28jPhIOgxpsguk=;
 b=mp6R0lu7I/5Y/5tH+ZVBVYVDhMokicX3G3IoyI7jSBszdMWK5cB9anxq1chjpbPLKaXG8cgyIvG94XLEZlJXsVk/Rgg+d4bYgAksLeAMkvYOejTKjSbvWIRIcpR/oSvxx6xcXzIU3mqeiq0VmbQDsMByBrq9G82P4t3Ryqj7essizvLxy081CRi9EFb20v1BljjGwms0mFYx/jaG/YvTBgDgujmAjyN/rVee+GsiKtMs1Mfzt6nxNu3XyTcc56b5EYrAdGNclO7ONUbe432Hz9ndsHHLQyh7I7VJHsIbt9vo9PqRvSds1BT3zzQ69jKCYEgOn4avkHCiwhjoeaC4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q12W3iGzdEe9ki7sY+sZvz0z9fOy28jPhIOgxpsguk=;
 b=RH57AOL47IQ5MrvZBaEGmSgo9EMb0Kmhr1BwI8nasNfV48MokCAstDBjV+naeEa6D0i2VNTJQ10AtJvr/yNObLXHp5LtmscPDJuL3xoiZpGtUn8YklZBo8dWBspNgc8dwhUNxy5hk4rbw9ZUHQGnj/1gRlvzF6H9hJKTxeO+qCI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:10 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 03/24] net: mlxsw: refactor prechangeupper sanity checks
Date:   Mon, 12 Jul 2021 18:21:21 +0300
Message-Id: <20210712152142.800651-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbea3e55-272e-4c4f-5b88-08d94548d197
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549ADD18D8FF78D8938219FE0159@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xaS783BQYi2/8+wQ9/4qZrW9cWA6eCU/SdBFuxpWgN0xvwscgmOnsG9y/YhuSUKrKw9xqE0b1o5R/CL1IbF+nL8xRiHj4VfQ8t1P+aEUxFyT/7MbMp3caHzTvqlZcIP962rvke/thFywRELu3tOuOCWp9DBwH1AetXAaY3a310wmNpha2VISYKVmVv/ZTOdVV82Qvkvn344eWkX1jiUKY3SK/PEgJHVBHUXk0uSMj1dAAfmS0DCyFfsX2hQWfWHnQ8qe5vRJyAqpryfcnO02eb3DYCR2cTnvs/b/g8/ixS7qiZMVxi73Eta4sEXC7NotvvoYehkAAlVlRreAnseV09v7mmKqgK9c1gf13h2+fv317oulI4YbUbRsItkTNvR7qx9Xhx73AHQh1ifMAcxWaF9/bSByKuJfn2LRc71HICLOnJChvtEWB4pEOauCDN+no/Q1Dls0uDy7RkRTSgs8BU88pcMRE/VNqlEWdK15Fz0zRg6Ore1xltImDxKn7Ae3hYgbB8Kg4X8TJNHIx8Qx4slTxGCfXbNUqVI1cuuL70V0BrlJ9qUcaV7ECRuXO8ksn/ZyQOStiYfrudA+lKHKKWd5RbJZPcEAmY7LuG+c17LwXPo4pjqMfyJCseCxs4FVFNCRbxKctk5LMTg4G5f+rKy6iEUyTdvY1nyDgHkWT47NvbaIL0lT1HlQ/dKP9FYBinWv5tejzWtZC1MIyy75w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(6506007)(6666004)(478600001)(26005)(186003)(83380400001)(66476007)(66556008)(2616005)(2906002)(7416002)(6512007)(316002)(956004)(44832011)(54906003)(110136005)(4326008)(8676002)(66574015)(66946007)(8936002)(30864003)(86362001)(38100700002)(52116002)(1076003)(5660300002)(6486002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?awhWS2dC9MVtQOqj94lsEoc9JM6/wMJp+o7ssWf2Zpm3DQ3S0ZDekXOfvweE?=
 =?us-ascii?Q?6F+U/O5nwpZ/z+9xBU46rZXWd0waUlcl6gMb5xFImbZLF7KMbFF68bnQnXfn?=
 =?us-ascii?Q?qNF3tL0XY40vKGaUgGYr3JvW4awvB16rS9PpyVFECNW3Y0mkSnh+kZTcR/Bq?=
 =?us-ascii?Q?99+0WZ+eW4o+/p+WVTf5yHS66blRAl78okp08616+9Q4rcgRJZ40wpCtFx9O?=
 =?us-ascii?Q?BOqntwpz1X6NqsQXQYlJQCOv01IL3KGPwZ0OzKfU57rG3O+h1KVxwt5rpP9E?=
 =?us-ascii?Q?Fod+DSZVPOhxDitQ6vAnfceoul/IARx4Eq2R6e6h8BeAMQxZ4IfOd7ZJi2rH?=
 =?us-ascii?Q?+wDKceCxxUJKmKz2OCajoWVsXiWXh2Me+kf9P5fyGr6ZcZ6azfNNTD15EfcW?=
 =?us-ascii?Q?75Nz98j92QLERhzQwQTHAfvd/1ZiRySCctIJWBH8bwJBe414yelfxxujp6K1?=
 =?us-ascii?Q?DkMnMeYbe443pfinizns62xStG92urKasiFJR0frmH4XC+9hzmQuP6OP1QNi?=
 =?us-ascii?Q?WdqdA/wmOQK0Zm0PszALEdH8LmhPikslfm2mShPr0jmVX8D98hSkHmtaB2Qr?=
 =?us-ascii?Q?Rtlff1Cx4aM9pA/nemLlHbat+phGhIxbFaUvjPr0lN4+bp1IWNjpT0/krnKP?=
 =?us-ascii?Q?KAS8Af3xeJfpJatE6JsSEPEqSmNQ1qUNR4taX4qA1QzaDdMVnOFZYuabYTFP?=
 =?us-ascii?Q?ch+6QVxQvpQeWHgKc3HamXZkneJNYDK5ft46SZxZKDHk3x/9bqp+hJm70GVA?=
 =?us-ascii?Q?pPiNXd5Zz0kAew0xFmzgV96eKdCm7lXbVww8wPKSziQUMJSnnDKODrG80I6+?=
 =?us-ascii?Q?XBOLtJYS2f9ePPe1PC64x5dw5Wl/3cgRBG5iaqf5ck7+f1gy/hX9gU6pR5H2?=
 =?us-ascii?Q?QL5ni25Gy3n7xyy0kAKKhS68kvo2KgyM3UDjlH1XZCIrsz0TeResy0ImceRx?=
 =?us-ascii?Q?jLm2U8HuhPD8F3SOvjFETCXSvK0gJdmujc2/e5Yc+LOI4s8fyiBAQQahH98A?=
 =?us-ascii?Q?4glBqznDEiUIICrvPRhtXwRHmnQlB201DnHR5U1yE3pCdSESWwbb9sNnhgQ0?=
 =?us-ascii?Q?QYmIxqopZRA5t+4RE55yWgEo8lWOtjfpnnb5CDpiXMKWI25aQhIyP5TMC3j9?=
 =?us-ascii?Q?DyEQ0m6d9KZlLo+kJ3oozWjqAGeUDVVJlVQ18CZhqHfrGv9IUk+mzjEkhvJ2?=
 =?us-ascii?Q?FsBJKzDrYgM1QCOVc/6fSw7i/xe6dSqKR6NEwb8/JPJfTBHt0dOyGatxPCrx?=
 =?us-ascii?Q?QzDvumZjLy/HdHHHS1vUSpAGr77OC8HR2+xthzsfpHf7uAe/Jc3vtuQgnzf2?=
 =?us-ascii?Q?LIq6J8FFqsn7wktB8U/4zugB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbea3e55-272e-4c4f-5b88-08d94548d197
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:10.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAq8pG2gXiiBnkybmI8Da4AJbb9P1ad9b6hRvs1fI6zxI8M72P7MpCC+NeeR/cuwKLXejMeslLMrogv0T/qVOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for extra code in the NETDEV_PRECHANGEUPPER handlers from
mlxsw by moving the existing sanity checks to 2 new dedicated functions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 263 +++++++++++-------
 1 file changed, 160 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 88699e678544..985bae6cf083 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4055,6 +4055,110 @@ static bool mlxsw_sp_bridge_vxlan_is_valid(struct net_device *br_dev,
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
+		NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a device that already has an upper device is not supported");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_master(upper_dev) &&
+	    !mlxsw_sp_master_lag_check(mlxsw_sp, upper_dev,
+				       info->upper_info, extack))
+		return -EINVAL;
+
+	if (netif_is_lag_master(upper_dev) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Master device is a LAG master and this device has a VLAN");
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
+		NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
+		return -EOPNOTSUPP;
+	}
+
+	if (netif_is_ovs_master(upper_dev) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Master device is an OVS master and this device has a VLAN");
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
+			NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a bridge with unknown VLAN protocol is not supported");
+			return -EOPNOTSUPP;
+		}
+		if (vlan_uses_dev(lower_dev) &&
+		    br_vlan_enabled(upper_dev) &&
+		    proto == ETH_P_8021AD) {
+			NL_SET_ERR_MSG_MOD(extack, "Enslaving a port that already has a VLAN upper to an 802.1ad bridge is not supported");
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
+				NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are not supported on a port enslaved to an 802.1ad bridge");
+				return -EOPNOTSUPP;
+			}
+		}
+	}
+
+	if (is_vlan_dev(upper_dev) &&
+	    ntohs(vlan_dev_vlan_proto(upper_dev)) != ETH_P_8021Q) {
+		NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 					       struct net_device *dev,
 					       unsigned long event, void *ptr)
@@ -4065,7 +4169,6 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 	struct net_device *upper_dev;
 	struct mlxsw_sp *mlxsw_sp;
 	int err = 0;
-	u16 proto;
 
 	mlxsw_sp_port = netdev_priv(dev);
 	mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -4075,84 +4178,15 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
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
@@ -4260,6 +4294,45 @@ static int mlxsw_sp_netdevice_lag_event(struct net_device *lag_dev,
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
+		NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a device that already has an upper device is not supported");
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
@@ -4277,30 +4350,14 @@ static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
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

