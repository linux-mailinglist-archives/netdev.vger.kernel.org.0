Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2F3115EF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhBEWpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:45:50 -0500
Received: from mail-eopbgr50086.outbound.protection.outlook.com ([40.107.5.86]:61168
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232468AbhBENFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:05:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLaEidR2l2abGoE6xaIXBdpqI26NnXQLukwdmoVwSLWQp+z3Ieev9M0b2fql5XtiCFvI6WlpdNg7Gv3rFtwnMwuAc15boNqFEPSY0H2w4EPYE9pW6JT49sFFvRdvevRIQnXyRowwcBumACUVRZJaFV1EFkj8FmAPd/NEDlpj6l/WNYWYuGY/mbodZYTlaBfIBmi3vi0TC3FCD7ecxlmQ6horC2oP+sdnOVRud7SvLYl92wptYL/1UzAE+QFX1WuZyy0vj16w6RuhzlGvEMtPe8QMM+rCXgc7rwVf/6Re1utnAURfDmWVeemoP3/hUsP3SZwtFDVC7GCM/2225h5h6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Jt+k4VIz/Okps95xWshPAH4d7l0kk+BjIgs6DRTXoA=;
 b=Fmk4wvOvF7IdtcJfUvmI9mpqVYiT/gGjykD0ggxfD1bnOJEKPq5PBP1nVaZsfU/HMCS125FP26Rb6MhaQjTPHQI1RUfLtZ7O/BCgSQKAifvMaSDwqVxEdtcJ4ztT64ni2Y77dH2KcM5hbheg8AoQo0ygw+sARkbYQ+l03bowgcQADgL5d68A/OviZikoByiI1mUaHI53P7vCsIXsEaJvf8UWnD2f82EWzEH6o1d7uZjesQEWy5NsmUe9SJvlc4yxlHnYdYu+y9bap/Wpkbi0rJxwrx42kUZ1AtKMlfl+3T3Pj5lZABS5gxdJnQIcBqbjM0uEezFK5tWXg7nrGHlsTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Jt+k4VIz/Okps95xWshPAH4d7l0kk+BjIgs6DRTXoA=;
 b=ozxsCdx6c8cF75CglG7W9yhHix9onVUcNbRfLZlyhmmhNCIrkdFA0Qxpuz7zjSP7EDAdNjFIIURi8JMz7EEvpDRGjQveY2X+Mu7NiqxWxfxDyKohVzSd5VoOqNjqPomIeQ0rRS+pFeUcW0KyDqe6eT2XAzrLHFbfwzto6iEZzRI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 03/12] net: mscc: ocelot: don't refuse bonding interfaces we can't offload
Date:   Fri,  5 Feb 2021 15:02:31 +0200
Message-Id: <20210205130240.4072854-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9afc0e3c-74d1-4568-39d4-08d8c9d65da5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28638664413529697F8A732BE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i682uDElnpVfz+i9HQTNqyb8X99IqpICgGVDMnpFGbu6OjJUFFN3uEr7ac+Ms5Tt+NY2JLr9hIeKXgU4ITgAXy6x9NEh/BPl993NkAl9O0pp3bB51AAHFRSiFhf6GZolq6CvwiiHyQ9LGOK3c8tVSaRpz4SQdSB4kzqNxmEFZUL/smKTnfkASNnBMMnLYDU3xDoyuiGiYRW6xlv0ydOqL/6i+3d9gb/r/8gGgER2IEELwAKhO3uVr1wPlNtTyxsbSIsQj9u00CN5Wo2i4mMxmjcE8ToSF5bLhIXFoT7FrEPSVQbmqQmaFIx8NlATRrteov9M5M8dhFOydWVYyaE+BP82X92MHEJ5uquwU5TBRmWVFzEzqAnHtC6T5fLcu/yvvmgVvNtfP2cULCi41yiyTZJtT9zYc5xxu0F1PaFyA9Vs4n8y2LJsvg/4OzZ+JviIZnlSAlgYPA6SmoI25tgQ/i8CpeRhZbfRCLepsjR7qlZxO/UFiSUSa+tezedqgE0S9EUXmYCNchXVA1xiZRTPLNzjmOv46gcMQarurTgj6dPS3mfEXK/dF753DU4OSrN8IXcXsvBJwmQHjSwkzNkFyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Qp1wIuT1uTYp7q4k8UmQKlQ7OJk/0QwTQw5uw10A9J4Tlcr2TodrvQG7tWuW?=
 =?us-ascii?Q?cYAbJwuSalMH1ShdK3rqGSLwc5KYYU998NpsEfLR1OFwrpvSogD1734bTqx7?=
 =?us-ascii?Q?DiPmSagKAL1+mLbMnxhcD91Yzv4sMPJTLiyHHd6eTGDF7Bp7s9YBRR2Vn8e+?=
 =?us-ascii?Q?8lD4Ghx5itVEKJIlPfeawaHaIyhrglw4PBKA8L9Z/+i8zLcYUmN68aZ28qyn?=
 =?us-ascii?Q?vVDnRe3GfUDkqEVfvIoyajTkLZZsGrFWrvTXZommwBqRR7FakibD3g0mNqQL?=
 =?us-ascii?Q?2T+q7DV/mI71mtqafUUU15zRJGSfc7DOn0o8vhpYX+XjMmARAar9oO/xLB4H?=
 =?us-ascii?Q?50MvjO2iHtRL52gWaK5uSZyxfPJrSU9oBspD4T2b6lKpObFLSKwLJwvsojsh?=
 =?us-ascii?Q?gb72jtaf+EP8mTe1vRweDvt9S3D3/0uKGoMDacHU5jCupL/HyyUt20WzScsI?=
 =?us-ascii?Q?gNKu7Tat2UJsexERsVDIiEsQ/MdvOQBpJTMc8lFVtSxqrgQc3XIEwPQrhcII?=
 =?us-ascii?Q?dwo8EqCYohtJrFFbk382vgUluBk3uOQjvuxDTmNq9GuACYyIhk+yrLAJH7gT?=
 =?us-ascii?Q?699D73QNgD2Tt3AmGGvWJNz7ufeTtegJsuDR1Q3eOtTjrhhRwJAGHFixx7oG?=
 =?us-ascii?Q?NH1RemgLPSaE8DFFwwe0KOLbwna8gf8fugTYF+6ln2azQnMN6OucReVidkOC?=
 =?us-ascii?Q?gYHZB8iAb2Rb1V+z4eor7rpZGwVphsHBRcy45PK+7/8Md4566ZCzaVvtXifB?=
 =?us-ascii?Q?ikTr1MPO0LpJ2fpCi7GTL8tk/xSXPa7z1m/BVw7r8sWwlq9r+uqeyPNvj1D9?=
 =?us-ascii?Q?UK7T+KguQ0Y8/HwRLV6khdwsn7s9yoqFewAAR2TSCmhbtvoJjqRmtzaJ4uPX?=
 =?us-ascii?Q?RH4xNBfkNUJlej1jUX/qmC6D/bUbTrmKsTobm+wqULh5vo9A4+B45iRW8Nv7?=
 =?us-ascii?Q?RsLEyMFHLFs1AuYi3NanvPtq3PUSinypYj1nWfXwdQ5ZbsCKpNWvw1DD4aNX?=
 =?us-ascii?Q?K1DAr5l154Nbhj43olS/nUkL+U3VjglZnqScZG3qNfQxUXxvYb0d8hzj3R2v?=
 =?us-ascii?Q?lI7sNhoWKTtzQqPNOglbqo1EFIGexNI+K61FMj2UxvMU/sMsDYrpWXplM/38?=
 =?us-ascii?Q?6IYlg+N21dscCZFfub44J0UO3uLqZ6iVcg5ETDEKI3EF7fvoM024naRrhvnZ?=
 =?us-ascii?Q?aUpsLmeOZ80BdNBNGgczQ7xkss9bS0MgLABIPaiOSOMlvI9eHW6NBy96qDCb?=
 =?us-ascii?Q?8LWU2l0pmGHo1Xo53irsPYJ3L4R3hYcd4a3xIkermKX4RO3dkePNIQfEejor?=
 =?us-ascii?Q?aSvq4W3XbGWT6Ptp8GMz11sT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afc0e3c-74d1-4568-39d4-08d8c9d65da5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:00.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYIE3dJOl241JKjuoGrM9TYKk14vcuFoQNtsSQifZhfoTT1H/TENZsHXX3acitlCVozrMmh6evBVWk2Ev6GVWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since switchdev/DSA exposes network interfaces that fulfill many of the
same user space expectations that dedicated NICs do, it makes sense to
not deny bonding interfaces with a bonding policy that we cannot offload,
but instead allow the bonding driver to select the egress interface in
software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
Addressed Alex's feedback:
> This changes the return value in case of error, I'm not sure how
> important this is.
by keeping the return code of notifier_from_errno(-EINVAL)

 drivers/net/ethernet/mscc/ocelot.c     |  6 ++++-
 drivers/net/ethernet/mscc/ocelot.h     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c | 36 +++++++-------------------
 3 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5f21799ad85b..33274d4fc5af 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1316,12 +1316,16 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 }
 
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond)
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info)
 {
 	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 	for_each_netdev_in_bond_rcu(bond, ndev) {
 		struct ocelot_port_private *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 76b8d8ce3b48..12dc74453076 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -110,7 +110,8 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond);
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ec68cf644522..0a4de949f4d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1129,12 +1129,19 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
-		if (info->linking)
+		if (info->linking) {
 			err = ocelot_port_lag_join(ocelot, port,
-						   info->upper_dev);
-		else
+						   info->upper_dev,
+						   info->upper_info);
+			if (err == -EOPNOTSUPP) {
+				NL_SET_ERR_MSG_MOD(info->info.extack,
+						   "Offloading not supported");
+				err = 0;
+			}
+		} else {
 			ocelot_port_lag_leave(ocelot, port,
 					      info->upper_dev);
+		}
 	}
 
 	return notifier_from_errno(err);
@@ -1163,29 +1170,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER: {
-		struct netdev_notifier_changeupper_info *info = ptr;
-		struct netdev_lag_upper_info *lag_upper_info;
-		struct netlink_ext_ack *extack;
-
-		if (!ocelot_netdevice_dev_check(dev))
-			break;
-
-		if (!netif_is_lag_master(info->upper_dev))
-			break;
-
-		lag_upper_info = info->upper_info;
-
-		if (lag_upper_info &&
-		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
-			extack = netdev_notifier_info_to_extack(&info->info);
-			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
-
-			return notifier_from_errno(-EINVAL);
-		}
-
-		break;
-	}
 	case NETDEV_CHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
 
-- 
2.25.1

