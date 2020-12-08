Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182FC2D2A5F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgLHMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:11 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:43431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729286AbgLHMKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyjXZXsynyHqIShdeNCxCpGZLpJGBcPEt2tI8ei0ESgW1Ce7H+TDsviXsiUO3EgZwBlsayBKP1+M1r2J9YzehjbMCK9dUmp/5//WrERN8va6DLR/L007xtyMEFuKTPnKScKczR04mrh04+vuSskYmUIZT231u5hPmnFAVWBsn9RIhTXYuY5LCkr8zJUgKLjVjWur2/Duefdtke7DHZMyrhDG65/0JqhtHb5EozWmtFFrAFFyAZNaivCw9aHOIZ/Td05XDi/BXgX5AZ+cmzsKQoK6q+gwdorvaTqgONgRwcz65wrk5mj+O5/4D0JobSJGlTontSb/Djo+Qb2mg8m/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEQfj5pnIWtEqMGn6qpXmVhBqBi132UFkkhrtPu/Nmc=;
 b=V7qGptN4Q6Xi4ET297N+rl+Yxs+LPLVrmy5OEHuHDUPVRx+VevTArb1TZAaE2rqXMFCtuCsLDOSMYM/KWAdNiqv1rKP0Y8YDHWagg5JGdwwMkAYENvDRkKdHrVkEAlWeAq/kBSBmOV/vzLnpwrWcN7iAfs7QfpdncgWhPa+uwO5UYcDvCkWxIvgIY8yi9jwEPwvul5p9ck30ZkoZQqyclbGP2e5Q9DOXe22nLpmLC3a1JsBynbESGfwA0+oPZVDHrPRMW9Q0bJpUFve9JA/qcU21Tt67L0ORzx9Jo2yI3anuH/wpaVg9JMobN+0Wk7peYzpFJ7sLCsbJ5JlW4Vdk0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEQfj5pnIWtEqMGn6qpXmVhBqBi132UFkkhrtPu/Nmc=;
 b=UOn44+skPz8Wd9kjSaZHfbRN7xxSKskVEHnf415gBR62m1oAjDwrPFt5gVdvqAi+g/YCXLaDgGxRBfuQtxZCqa6DAWC6sIjcD+97OHiWG/9y2VHLufg8nlkRRG8sPpHPvekSo35Eeh9Vi2R5v60SNRDP8Tr+2nT1RXfNQeSKuU0=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 04/16] net: mscc: ocelot: use a switch-case statement in ocelot_netdevice_event
Date:   Tue,  8 Dec 2020 14:07:50 +0200
Message-Id: <20201208120802.1268708-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9ed5cae-ab9f-4ca3-d08f-08d89b71f6ff
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693852898F8D55CEAC33F7DE0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14ZoDxTWOO6rIcHjDHMYFjG+H7K1j4v5L30OsP3I/nDq5LYft+dJF7mO3unVxU69GV4ZjPD9bWdpcS4+KEleIck5M6jjiJ/PMPlaadAb1Iw9n0tQCEp05+5gKmvx/+dxYT5xO1jMpfbB8Gv4xG1T34FtsRn6mGTHLP83Y5nlW+m0XjrP2bP8s3xYUkhOa6g4KbO+mLKArbK92VmhO2Bk70z5NuyeAD6FFMpS096TsnKzu+O/EjHnTMHN71kfCQQz3lY2bC7T7GEE9nnQ2vQVC90G/mn3VT/F7SiX+IOcRM4ClVm7Q4z7ivTtoZI0ERXJ95E5+m9v2P1EEwaA10P6CoeNVxT7seZbi0JhbyGxLU34woOi3DxQ13sCi2Dk8/QR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l1XSIvYCaxPfvMsjsCpJVSCIW91g4bT0eos5wB2Ji7G5zAKp3U6hOqJdEUGs?=
 =?us-ascii?Q?r5Ud/bZP1GiIKDxaLcJUBvDjJUD39q8WcdE/5DknCc2ql1Fl0JgJjzBTlYpF?=
 =?us-ascii?Q?956vwd+zomjbPIV8Grhh64hLBU1I9vLwRTXNarqY6OpWeUCqE3svXCdRacBg?=
 =?us-ascii?Q?FhS5p8kiOX53B+x1evBHDHlYtoZZ5R72zzkOJh5M2W9hQwyLVZAvd92vz5dI?=
 =?us-ascii?Q?WWyvoyCLO4sLeUxIS+rDQ4B824q8ye+JEwKAsddBb580C8i3l9kpykvjqnPM?=
 =?us-ascii?Q?AP9GIR6KdjqE9u5OfwzgPI8+VGZp9GdxkJueXjqr1LdMEN+hn0/Ksjjg2fqB?=
 =?us-ascii?Q?/3jk5G588WRHMS5qXsJF1t9KwnNjbQOigR3Mkz3bc6yVqF0wCFj90LUwnmMy?=
 =?us-ascii?Q?QYKnOQ1ySuPr92So5jw1i7+bqrf+CAXLXzoBhgUH3drknw98UhSMuLDAXoJO?=
 =?us-ascii?Q?QsPv4Sqzx+ID4nzUju5CL7KJy4IxjEFfPkrvjkWjC/VGiSRmODmkohrEMDyz?=
 =?us-ascii?Q?9lDtCZL+9EGZ7GKegzhmjvXc5/iAAdtOBJ1OmGCYyqE4P+AG0pE/eK9Op0w4?=
 =?us-ascii?Q?Drjkx3bP0SZT4JtrXReYZkr0XfLS22LrwI7saE6//lB/QH/n5xvNWlXDT1D0?=
 =?us-ascii?Q?TLDrRj7LlzBQ3h/lbCe4CAQj/G4EWhAISIqtQoPo5XoZYdV27SC9XobZow8j?=
 =?us-ascii?Q?WpMPwN6BWzfzWSWVpy8BS8N/kfEVqbZRVP3c07fXPgmyCxbkiB2/OzgncRH9?=
 =?us-ascii?Q?y/+xq7Zq5s3mw93txMxv8CoZWtrcMgxmMkinRayHsMiIKOnYYOe/Aaf9tzUi?=
 =?us-ascii?Q?rR14i7RX50sjdPM3oc+e9Sw0BHiHbyWeHutUPnMMPP+lZ5IQPNOx8oX5GYNw?=
 =?us-ascii?Q?9I9Fz91SeM81W1ZIX51EcGC0Xkx3iUntR1R5Bg0xtMd/2qw7yl/GPcYxHiRR?=
 =?us-ascii?Q?PMbp4GFEUDwdT+LTr/Irs4uLGEY4wCrNBnJw5M5RMa63y+ZokQGJQoteDMky?=
 =?us-ascii?Q?Zcvf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ed5cae-ab9f-4ca3-d08f-08d89b71f6ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:25.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7V5FiDzu6eIl+yvk5rG4z2rZIQOYfunfkLesMOugDjNG/dBXMo3Y0YdEFUVeWIVgxd9SYTS4pLKjY1QvlulWZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ocelot's net device event handler more streamlined by structuring
it in a similar way with others. The inspiration here was
dsa_slave_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 68 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 50765a3b1c44..47b620967156 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1030,49 +1030,71 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 					      info->upper_dev);
 	}
 
-	return err;
+	return notifier_from_errno(err);
+}
+
+static int
+ocelot_netdevice_lag_changeupper(struct net_device *dev,
+				 struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		err = ocelot_netdevice_changeupper(lower, info);
+		if (err)
+			return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
 }
 
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
-	struct netdev_notifier_changeupper_info *info = ptr;
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	int ret = 0;
 
-	if (event == NETDEV_PRECHANGEUPPER &&
-	    ocelot_netdevice_dev_check(dev) &&
-	    netif_is_lag_master(info->upper_dev)) {
-		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
+		struct netdev_lag_upper_info *lag_upper_info;
 		struct netlink_ext_ack *extack;
 
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		if (!netif_is_lag_master(info->upper_dev))
+			break;
+
+		lag_upper_info = info->upper_info;
+
 		if (lag_upper_info &&
 		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
 			extack = netdev_notifier_info_to_extack(&info->info);
 			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
 
-			ret = -EINVAL;
-			goto notify;
+			return NOTIFY_BAD;
 		}
+
+		break;
 	}
+	case NETDEV_CHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
 
-	if (event == NETDEV_CHANGEUPPER) {
-		if (netif_is_lag_master(dev)) {
-			struct net_device *slave;
-			struct list_head *iter;
+		if (ocelot_netdevice_dev_check(dev))
+			return ocelot_netdevice_changeupper(dev, info);
 
-			netdev_for_each_lower_dev(dev, slave, iter) {
-				ret = ocelot_netdevice_changeupper(slave, event, info);
-				if (ret)
-					goto notify;
-			}
-		} else {
-			ret = ocelot_netdevice_changeupper(dev, event, info);
-		}
+		if (netif_is_lag_master(dev))
+			return ocelot_netdevice_lag_changeupper(dev, info);
+
+		break;
+	}
+	default:
+		break;
 	}
 
-notify:
-	return notifier_from_errno(ret);
+	return NOTIFY_DONE;
 }
 
 struct notifier_block ocelot_netdevice_nb __read_mostly = {
-- 
2.25.1

