Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67EB2711B4
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgITBsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:15 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726781AbgITBsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rgh6NWjAPjUTCQZMBMljOOHoKDBBluDuynSOXInpqUeGXkuB6iZeVgsONOFJ5X+F0qPnAnw6VjBuSs1r8SaFhHVqUrg2vvIp5Xw1guO1wI14MEvUklHTlAlb4FLh6w0PTPHwZz+zdQXh4Ff9ElpB/0XxsS8gq98g1skAKpfS0fskST3jGcYD2XwAEuYAQySjIqCr3RUwtZbZMScRfWdRAnWrls/Pqkqvxhp3PflCUoqvAOmRmuE2UkFiK5NiY+szeLP2tRUixdbAoSLHUA2OaDXEUH0iQJ3ewpF8zObZnPZ22h2LE9U5Lc0iwrJplEPevXIXufQn6Nv52nkVyUm7JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObTRSlhlIoMJIDRjsegrZM+MZwJiHD4KUwM5dFoJFGQ=;
 b=E8J39jqXuMo5po1V5Li740yueryJCZcARqrktBLMXMcM3m+l+tlmv2TCr90192Qtx1FzHASLKU8qyxo2rQ+5mQIfD8iaj1REiC5vB2fsIT8dAKZ0VuvDNNEyD5G6IV41elLwSaguXpHiW2p93qzzNpob15hqtBerfgTqkngUbBwYzNqH1gCIOzIH5gyy6RUOkKB9BSeGeuQVZo+3GUIQ0v9a1H3sjVrAGQDp+hbyRdwh/SeD9Pm2ZpoqSCjQ2xbzMYx49AXDgliOdO6xvL/Cim4sUVJOHX22VYvCkdoKIn5hGbpkek9gHunYep+gQw0J24hf07d6F8nieIApr255+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObTRSlhlIoMJIDRjsegrZM+MZwJiHD4KUwM5dFoJFGQ=;
 b=i/Og7D4Ifp2o0ngTs8bpykiHJHVNJRvNs+XvKkeDyPL2aowtlHlyIO6Xod+OTfmIyaBCSG/VTGVbZ2Psu2i04RmqC16kIpxYt3MENKZDe5gpV0Is6t3ddh4cguv82elMTAV0G8BDAkNmZx6r07E7B3+MluYzEZF8HosY/9OYy4c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 3/9] net: dsa: convert check for 802.1Q upper when bridged into PRECHANGEUPPER
Date:   Sun, 20 Sep 2020 04:47:21 +0300
Message-Id: <20200920014727.2754928-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:06 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c5db878-ee2e-4c10-a2f6-08d85d0738ba
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686BE160BC923076293252CE03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: be/hH5THJ+K+11031i9tS+AzmidtI10tMC0KFdcA75fh57NxYUS3hgU9q14J7XweYvpKlhDVs+CrqhXKG6vsg0pTYyeeZTRxcBCAsvgpc7v9DWrYz3DEkbRnBAu91CYBurow1KFrk4DyrX2g4ZKqMwa4mzd/iQ8y/j6cNcnQbPMtAU7A6jBuUYlRAh5yiVFEaDS7TxwRBgtrxSS7N1jq+g71AEdc88n9uotnI94mVTXjlPR5yj6RohHkk9akvF+aZibRQUUdJkwdll5jFDFnKAj558wUSI5YQNxBYelK5ervbbkXQu7DaHCBDy6b2IKOUdhQK3eq2mMfj8sRGkioaGBKIOSaBeuQ0QJshdS6r+mVWgQM+1OukzXj95++9TP/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: d1qlRzxmDiFjyZzbBAGukGMleHk7geLD2mzW/ryeDO5c5AI8yL8DPGFZcRzuFT1B2HtcJ7xRHYjKP7laqSNGF8yjN+fhcYHrcl/R1x9S8JbOGyvquw13cUdTiEmEm4hTwv4RLD0QfQyba4a+cVDSp1HQLm7/74OQGe91Hs9lGtY/c8WLAfjLlO2p8UZSNUHBnK1e5GUdY2h61tFDi0xxKed18inrQTwmurTuIhZ4gOlRa5QZUA41GtaziR+bTxBfoa/TXPMqrR1JfAxXU48gd3mhDjYsasisUYEN/HPekYGzI/kKY4fKx0I562YIPHQip3A5iYWuIXsYfLGwv/LXjr6sBKx44719hm6YnrR72P1quONxKqMkJDoPPq2NtO838S9l+4carf0PVL0lD4Vs5A9zitv1ypaLyaIkcUbZpSKmYaFwcq3A2vzSDzLPbkByykoe0MOCAfTUkGaeZdgU6AuSC8DfWESezvdFCi7r9+GynXGj843CW/AnpLb1ZSZtYiuDWdk5roXvjCuwjm9tFzRWoU8QZd8YBANsYiNPdVUBktTtWpjtWJ8UZlh0gwMNDg5E5EKDYvLCu9+YoVSTt+iZpGMMwSLGKBedgH+jKP8KMPE9dKBly143sM9ry6a7+PRpnsbQ2ddImE8khSdxDw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5db878-ee2e-4c10-a2f6-08d85d0738ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:07.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gS3oEpoI3LlyChxTe/C3S1nLIBtwmpTOpHF79T2OAQQGxsYo+9epZKf2UeJqAWNTD6dgwd5LGQVkHuR0dcn6fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA tries to prevent having a VLAN added by a bridge and by an 802.1Q
upper at the same time. It does that by checking the VID in
.ndo_vlan_rx_add_vid(), since that's something that the 8021q module
calls, via vlan_vid_add(). When a VLAN matches in both subsystems, this
check returns -EBUSY.

However the vlan_vid_add() function isn't specific to the 8021q module
in any way at all. It is simply the kernel's way to tell an interface to
add a VLAN to its RX filter and not drop that VLAN. So there's no reason
to return -EBUSY when somebody tries to call vlan_vid_add() for a VLAN
that was installed by the bridge. The proper behavior is to accept that
configuration.

So what's wrong is how DSA checks that it has an 8021q upper. It should
look at the actual uppers for that, not just assume that the 8021q
module was somewhere in the call stack of .ndo_vlan_rx_add_vid().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 74 +++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1bcba1c1b7cc..1940c2458f0f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1240,26 +1240,9 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-	struct bridge_vlan_info info;
 	struct switchdev_trans trans;
 	int ret;
 
-	/* Check for a possible bridge VLAN entry now since there is no
-	 * need to emulate the switchdev prepare + commit phase.
-	 */
-	if (dp->bridge_dev) {
-		if (dsa_port_skip_vlan_configuration(dp))
-			return 0;
-
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
-			return -EBUSY;
-	}
-
 	/* User port... */
 	trans.ph_prepare = true;
 	ret = dsa_port_vlan_add(dp, &vlan, &trans);
@@ -1295,24 +1278,6 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-	struct bridge_vlan_info info;
-	int ret;
-
-	/* Check for a possible bridge VLAN entry now since there is no
-	 * need to emulate the switchdev prepare + commit phase.
-	 */
-	if (dp->bridge_dev) {
-		if (dsa_port_skip_vlan_configuration(dp))
-			return 0;
-
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
-			return -EBUSY;
-	}
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
@@ -1941,16 +1906,53 @@ dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+static int
+dsa_slave_check_8021q_upper(struct net_device *dev,
+			    struct netdev_notifier_changeupper_info *info)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct net_device *br = dp->bridge_dev;
+	struct bridge_vlan_info br_info;
+	struct netlink_ext_ack *extack;
+	int err = NOTIFY_DONE;
+	u16 vid;
+
+	if (!br)
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+	vid = vlan_dev_vlan_id(info->upper_dev);
+
+	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
+	 * device, respectively the VID is not found, returning
+	 * 0 means success, which is a failure for us here.
+	 */
+	err = br_vlan_get_info(br, vid, &br_info);
+	if (err == 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "This VLAN is already configured by the bridge");
+		return notifier_from_errno(-EBUSY);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER:
+	case NETDEV_PRECHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
+
 		if (!dsa_slave_dev_check(dev))
 			return dsa_prevent_bridging_8021q_upper(dev, ptr);
+
+		if (is_vlan_dev(info->upper_dev))
+			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
+	}
 	case NETDEV_CHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
 			return NOTIFY_DONE;
-- 
2.25.1

