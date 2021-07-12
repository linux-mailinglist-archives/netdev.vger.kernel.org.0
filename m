Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD44B3C5F01
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhGLPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:02 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:27617
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232203AbhGLPY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:24:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdNxwc4ilikKionUpiBvWxpQsWAw2Lx5cmuXOUgEvo1nadKYKmCbqBEBmTg0dyVToHiyxpYItAAlFBiLhvPl4aFLOGZzGjsmuIvdATWUhKd0Zs14vkhdgA1APHRZwfb3GQ4TAf5iOp1U5us2lFjBLBG7C/tkSkouoQkCK+1VPAaDicd1fC/cOEpWo5ZsX1oLkM/a6199Yc240eNCRwoRpFxB9dpjFZl4jYUJoQ1uLG/z939aLDpURCT0f3a+wkIPPHmhnjJi67u6LPwuaIzFOn461VO2AUVWgFO5zSGawwkAFKbDUg75G7Nx9xiT31TdsRs08o+/GSI0QeogvT4cUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fa/GIxMWj0fNCHBGxwYOP+lgVtD3UA9ZDx31dli7Pw=;
 b=Z4T6eS6aG0uuTUAvpX72IIwf2iUaqEmDuGpCRUUacFnsjhHEirPm9Gw5nfnF6X4VtpZYI1CHuA7l3MMzU3OrWZ5CnncrPQkyFAVslWHHwbExt6EF6nbJmRDbp8Unuz4qMpbI98mrm61/cpx2Lt4mnLxqy4KzqaRGsCH0pw6a+nJKX8exmMMckC5BSoqzL7Yp49ECLIq56ugEbrMoo5Ejx3uFH7s01nzlLiRCFQ7NFKp637yjlctoakO9sg2bdwCjIeFHTRI0VehIEfDPe4jdehkIkAMo32IueBhdVwn9erPbtdYC4p/S/OWsxZy0mmY7tfXCODVtoRzwVezwoIBlpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fa/GIxMWj0fNCHBGxwYOP+lgVtD3UA9ZDx31dli7Pw=;
 b=s5FkBeqg0yyHqFKzJDdmQQAHFISYBCizsiW0mIRSXOx0ov3lgf/QiQwS0UMDb/u35BtZB2afouG7YJgEs17xxlP1bYZZ6i2jxRn1ZFkcCyzSmuUKUvgdUPi0p6U2/6QkHqUNZD20eqeidxzmP9M9DOKD5eCq/Vr+iJahageXxSk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:09 +0000
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
Subject: [RFC PATCH v3 net-next 02/24] net: dpaa2-switch: refactor prechangeupper sanity checks
Date:   Mon, 12 Jul 2021 18:21:20 +0300
Message-Id: <20210712152142.800651-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b748bb-5ad9-4425-027a-08d94548d0c2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549ECE88C58965D0F92C4D4E0159@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x51m05w023YkAWRM04+dt/YYMWmXytG7vQ0H4R2t+eTkQAY4nyToeJneZ/9JUc7RSvEE1d57AdUIK8w4mTCtj+XY1/xQz5vaInWVmwNOVSETc7y84d/mV2yChx1WbmNK1LJjQnvw2AzvXD9o48koO7wXpfpzqOIGwBGb0DiGiTrdK70q/jxnXogLJZ010mndlF3i/seysO1NajO7QgLI/3OJ/MzsotEzIMEok30ZFcaEg+hiKKNa7rCb7U4bp1ykeY2fCYyNOeG+ADnV750eV8YSAr9nUN705gkb+FYczlXgNmi52jHK9el7hb3UGa0oNVm6GsFNA+NHyNrAfISzS5KsVAYVryJbNOSHnA96FX106Vwd+5nvDH+Io6BDNn5BgONl0m+/tYXUsEjNyE3n6FHaAHXwCp85GbLepKoLzPEObzkOuf7nVoclix286W0beVXpO+F42CuvFrTYgY2V/VLsOnwqETxek5BKRZiEzDvK4PLsdzJ0/saM5QOl96WXYe9cdrDk1kAlzQseuhoU3wI7PSHijdlb00OqFwEMm1YYf4STRUa94+CRy5yPnx/qZ73Zj+TpUwEKRKXr/+F5DPVCszn+Vely1O3vGVi9iELqGd+vAJNaAUcUon/FmLpA0gKK0nA0SoVyffITEZNua+YDDC3mHxBTjRwVtVBcw7FulWv9NQ6wFtS70OZb0VWaCv0HBtvov48btVrdii0b7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(6506007)(6666004)(478600001)(26005)(186003)(83380400001)(66476007)(66556008)(2616005)(2906002)(7416002)(6512007)(316002)(956004)(44832011)(54906003)(110136005)(4326008)(8676002)(66946007)(8936002)(86362001)(38100700002)(52116002)(1076003)(5660300002)(6486002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gj29oo30wGJ30S0UIxS4ICRya4p3XaKzPGA6Qp+O9RANhMX7ZgsHKjFzHp35?=
 =?us-ascii?Q?kuLlDJ6Qyjl5jKFfpoGsGa1/7yaKTHtHJa1mqCBy/GZ5yrLyNEy/rbwYTV19?=
 =?us-ascii?Q?9EH+AKdOrnVFzn67kO7BF1iqRFonA4+WyWyLnd6BWPogNKkxFxnTqwX6ubc6?=
 =?us-ascii?Q?Rw/ls4ru9m88lwgwR0bTOmvSvusBiuGRJoY6ezU7ocmPX2TM98Jeif1dyLlB?=
 =?us-ascii?Q?ONZfuS71+str3Xe5ilv+eqP+Yeummoua+hwsbL0hU/y1JAgNOZUJ0LaK6SbZ?=
 =?us-ascii?Q?rPalhYE6cqbtB3mmyzxNRe2RskP1j/LiQrpQ1ZakZAQD3cN+e6v/ZSVtAlqn?=
 =?us-ascii?Q?wgy4ZfMlGJTmGMSI+2PfgUKu/Isou2gs/QBZcXb5i05q9d181rvxXT4DkAjg?=
 =?us-ascii?Q?XZVzhq8O1nHKiOJg4H4cFu4LL0Zxr853B0CHUnymrp2UhkhvE6b3JgD3M/IZ?=
 =?us-ascii?Q?kSf7KlQRNWq4UGtUmrzdvCNjqloXye8/tiAYWFV/mBCUXe6zqvK4JGvGawdf?=
 =?us-ascii?Q?Pr5tLT5aDAJWQL6wM1hGFw98kI1s7gDcJ4cM4es4cyOS9sd+9dhXRkCCwGQW?=
 =?us-ascii?Q?6IYYxuf9fDTis45J/BkmX19HeMRdp4bvr8V4aQgC98+LQZup8utmlnhNKWzp?=
 =?us-ascii?Q?iClo46VZXahThW8+FYv5Jg/lq6SqdxDa/kI1lpPpXCxVSUG9hJ5Rke+UaWjQ?=
 =?us-ascii?Q?fJFHKp22HUKH5QvVcdJBYqdh+zKFNuOnjandu4wRrwwUYHSuH+KhIHNQZvwA?=
 =?us-ascii?Q?bCS7TwI8WxQmjKj2VMijkYFCmVgLYCcUcDY6EcE2pLAy+5y0vE1Bl3coEeFT?=
 =?us-ascii?Q?L7GePokODiao2UudqV39hN0y6PqHrYV9ojiDcJn8K2PicaHgLZOwPbutKG4b?=
 =?us-ascii?Q?o/IiOUvisTVZcmv/vJmhdOE+cLZuNJlxRRYFakWQEJ3s7VvZleErHC82aSGW?=
 =?us-ascii?Q?ujCxORmV8W+AJvMAvBKwOjAhP7TPvF36TSHwjVDhkq7G9E/NuBi56gADECjH?=
 =?us-ascii?Q?56tRRXpHK9u8ay2eSlgD12jJ3nNYe5WblIfWVI3WqJEp8RRkWVsBusnJ2sWQ?=
 =?us-ascii?Q?hFbMfHG2ogR2IBlraG8KMzNpIEBX19i6qK/Y2qFqY49uAa+x98nen7sL6px0?=
 =?us-ascii?Q?/EcDZKJeAJXkRVniaCElthPaA16yJud85johsgMxPmYtykXWUPN2HdaNLM1y?=
 =?us-ascii?Q?clVT8YCBj1pWZwaOo1SfLa1ZTKc3fQvZTFGnHUMBk8Gdjf5YK/52dJYps8DD?=
 =?us-ascii?Q?VQjudZ5sH+D7sBLvULNN4vMX6MGKy46jrD+96ojfLJ2Hb5OaY8E5/HHdrHXk?=
 =?us-ascii?Q?/QpzID75nojy8KOZ/doKvnjZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b748bb-5ad9-4425-027a-08d94548d0c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:09.3542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOs3rK+JNtV5L/C8mSi7KQmh8Sna8I+hdG4mz8qsJYBTq33UBIt7gJH7zOOmeSIk0PEZEaNAfHVRpw7W+3T0SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for some extra code in the NETDEV_PRECHANGEUPPER handler
by moving what already exists into a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 37 +++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 62d322ebf1f2..f6d4cf053ff7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2030,6 +2030,28 @@ static int dpaa2_switch_prevent_bridging_with_8021q_upper(struct net_device *net
 	return 0;
 }
 
+static int
+dpaa2_switch_prechangeupper_sanity_checks(struct net_device *dev,
+					  struct net_device *upper_dev,
+					  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!br_vlan_enabled(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
+		return -EOPNOTSUPP;
+	}
+
+	err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot join a bridge while VLAN uppers are present");
+		return 0;
+	}
+
+	return 0;
+}
+
 static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
@@ -2050,18 +2072,11 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		if (!netif_is_bridge_master(upper_dev))
 			break;
 
-		if (!br_vlan_enabled(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
-			err = -EOPNOTSUPP;
-			goto out;
-		}
-
-		err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Cannot join a bridge while VLAN uppers are present");
+		err = dpaa2_switch_prechangeupper_sanity_checks(netdev,
+								upper_dev,
+								extack);
+		if (err)
 			goto out;
-		}
 
 		break;
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

