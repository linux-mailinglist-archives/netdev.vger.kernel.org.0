Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359602718C0
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgIUALi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:38 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:51024
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726326AbgIUALf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQMImXkEkgYLzP1KF6d7GvRIM7nv6rL11bfKhhIRMzE5qwSRg/s11uiWVEYnyzCtDhbJzSNBymwVXfguZNdvprgV/EP8vNG2PIS5BON0cg49kx5FYIbff+rkyHBfFVTbNKeeoquPhMpGWQVnJdej/ex4AdeHS3E4g1+anV82bvcutbThuOL7xHOqLxOdxfTUq0hHUumKsR8dteP2mrPZUAosDSTmyEdqE8WxVGy8S7yxoLq/FceoiV5R9r+6SB4QWHR959UQydLKhemxdnHb4k9jDXSh6O94v7Gq1+cH/m4HyU1SkO3szi0qx1B2+dRTrf/20ejA9D1XEaJYUOPlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaDA7Z4BhOuow4BiLlMuU4krQLkpkk++RW5FRc3J5js=;
 b=iPdYQlSYNI//+yaTm7LgrfhUn1YEwQxKYJEVLm/QJ0rKyWaUoMeQcHWubdrqp4YXUqnfUBQz3H4CMkva0dU4dY/M+P1+Oj35OAfpJ9mAlK7sTLadkTuz5jy1Fhkeoii/W64lNL/t29jgrnKQdyggYSa/tCcK82lqyvzzsY+FM0pgX41q72jLxOL8MLl5hC6pWnTmatQyARg2egggr95pPH88EiG49Wqs+4/oJNk8pjcJQo2L48n62fSmbOeXuk7NhWatnCTZIuQ8UNoFM2dqhaAtMUHn7hpDEwmtPlkz09XDM5xQacnrh5vDLiLgZnGgPG88UGi9+7BmCUN37qMR9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaDA7Z4BhOuow4BiLlMuU4krQLkpkk++RW5FRc3J5js=;
 b=nzXtAdA8Lpvq+A5lGfKdd2y1wfJ3VEqP8dtLFX4MUnY2AR+X1y3Jr5MgggdsWvmQqQu1gSnNGTwhWl3U27kFIoKMCms+5eH3OQn4k0mIO8GNvRqbr3wVhP4bwpXRtPNas5CSTwCPuuj0dZLisHycaICXscdQGpgxWUICYJOyPTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:50 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 3/9] net: dsa: convert check for 802.1Q upper when bridged into PRECHANGEUPPER
Date:   Mon, 21 Sep 2020 03:10:25 +0300
Message-Id: <20200921001031.3650456-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:49 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1a28ce6-925a-47e8-1dcd-08d85dc2cbbb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501679A6E4D0A2E5782FEABE03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRC6IXd7KGO4M87NWA/qptVWCdjtaNGZ+D3npEsheTKLS4rtDJmY32/6hpyRf+95if9Ui/E8mnv1kKi+JEDmXSxf700me14prvoPSIx+8ih+q0XQQJC5C5G+/bUIr6bsjis45I/RVPPVAF/rOjMCarWEzWk17cFTfxmOA/tfJF/Suyl3LlgCujMI77BKGSdn/e4ow2GLUsv9uA3HR/AwVNdumcdzJNDf9yPwL7XC8AI3V6cwb+P9hyhs315DJRU22CJiIcRD/McCpBIChFnRua6KrE+WE0dzwnwQmEaX8tcLmHKrBzHTGVgOz1enrmM08sZ5az0QuxklavpE57PZ09i6ogO3V4i9gVphIpgle33aMmi4j3AwpYDxjgCFIUc2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6s6hk77p/nxtZssvnPJ5PHPk+jIlIIlqRGB1pTMlaQLnj/s7OQ+1K5n9vmV5aKU++QsA/S/rT7phe6fqKqHpGliDSKTo1mRiC5lppEYxhhGhPaWTS5Hfxu3/I3L6GEPY6Lwj5veN7V/tjirQE03SkYeAQu/vtIi9hlpafSbxWRcHvKYjAspf1DOIKYPoqAnzItNF33BEoBBuCbhVVYMztFCLdhxKGtWoqdkwX2XQRa/tCzCZZ5aJ/5GPZASEqzzXR7vrh+ShuCQGV5riqfMrG0YJuKaRO+vc46r6KMD8RdSXNvrnDj/542gFY4urDpf1BP3ElPfe+rxD7xBhaFE2uXxCDtK6VN058Ktat8JMi/C+gwrjzbhYAkdw463pTdZ+euSH5x1W741OVhbJzvxuxMWRuW3J2LepHCW/wcqQM3XUYnahmJ+DZGlok7EmxqRNcL9nzG4Z6kGlXnMTcNDpCp34sT+6gnIBx06FsVmh29flFg9tsbglFf+S+7YfX9xwj8C4zJbdH2s1LHz+n4SgrJQu/QN4FLSJ4NbWxO3x3dQLofmARkxlrQzWCMLe9WjirP2jf+BHKnhiGxNNbj8rRpAYIFOuks/kHlshQrOC2x1iFKH19GJjmHX3bzQ8NL7W64vA4DeCdG/HSj6tsriIqQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a28ce6-925a-47e8-1dcd-08d85dc2cbbb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:49.7860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9NJkOz9+qyp2bIrhHMRla/quD0kLEFXA5MkEMyWZtv0jvT3dv7oPQ3G7B0uH35ciXFVwI+CIXVxNCPdh4cylw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

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

