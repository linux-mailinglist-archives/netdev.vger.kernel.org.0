Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB42711BA
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgITBsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:31 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:45178
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbgITBs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoxCUvd/GW5Nee6yn4GrLy3R752MsbJMyn3PzJE0AWu89Ycj4HslvgvzXxDGVd+kdtPLkirL8JLHbLY+wXN/bKU4vQqh65091PU4J/lZ4x+Pz+7UiynB/hy/0lJZDpJBh8F6QGFbtHAENgehawh0LtPhFAv9Rdja72J46JiF6sd/v/2QjXUAdqGdIUg7E8tLs6M4LeRBK7z9oRP4xXPk6UoKMtBeNqgsKvRXzVOggEWmdKFj2O8GN4X82ZLKO4nj2w28iIesxWsYPwewu7Tr2dSiYXQu+Iobydp9WQ50zt2PrWEjlfxLjpOdbtr06mMmbpx53awPnejcq0NHKJpa+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U41Rq8TW12xp+dUPr0ANBXvdkqaoehxRd/24Vo99pN0=;
 b=CqoGtpswF8m4RX3zgg+RYP7J8zG3hbpPtZYdm1HCcrMLVmAHV1FxvwSKFtlA/a+p4ugf+0bNppBQ+LxmktruCBSZoZ/4GPshdame0gm3jd6M9adu9CFfp9ldd1h9vBNoziRDrFkVS6axQTPL6wE3nV2I2zgu53lhZOV+GzAF2Avi9QroQ9CgOot9iJ/wERGpk12Y6+TeLYifTQ1C4mekmHii1tNFM2p4er4EoNAsjYzG9/fh0LsPIS5GQCD0PNTnYWFKqptOPtj6wq7tJE0/1ULJi/Zz9hGwLGtRkuN4FA0thxA8ANfGtL+VjL2XZGMGk0gkChblrag7nMz4ug51eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U41Rq8TW12xp+dUPr0ANBXvdkqaoehxRd/24Vo99pN0=;
 b=MYZZlJiwyU+n5mHE9zO1kcoZD11np+EgbUzWHTkgOIj3qvUteTArJXyXN0sSWJswcGFPJmpqLZDxta/4X7BQ2PUz9U8M++GJLH2H35ZbPA+dsUy6Kxzb5yKtYzrQj8Oz/kvu3fGb0hY+T+zMqPDn4tFTK6HfpYxixGlhSsxeCLU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 7/9] net: dsa: install VLANs into the master's RX filter too
Date:   Sun, 20 Sep 2020 04:47:25 +0300
Message-Id: <20200920014727.2754928-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:11 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4331a367-91cf-43e3-fc14-08d85d073b92
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686ED254363B95FA700E901E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rczOV80aTwV+tpBSmdIWWe0zCzDD93l3PcSE5dqxEEeVLaEoxop+0o9OCb0yAqgExrLS8RhHkTgTqO0ZeIM7KrgieHifk9bSHN53YUtGWe7NeeSK0VELgC0lYXx4aIabCp9zEhmHzTxA7vWwzipT9imC1mUSGo1sh7c6pYLYeDyHHh0kFbhXhZGj9cdrlajuRYdQ0L8dB9As5fnLQBpji8BxXFcAnQnniH2ho8xnxBceoz3EujZ+9wFWk/nYvHaIwyv2hcr3tv8C4CcVyUwC/3o+Z1VYuutHK2NBGdgf18IfJ9BMhwyC7NdpIIr9sOp5l70v6MgSGyWBT8G0Xry/A+0bCIcOs0RdWDEBvOJFzSS4YvbPtJCn5p+sdvDnK0tq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oL6D2+s1W5gSshGIKOiRSbVE8LaYl/QwglyLsOuTNOYM/szeNyy77JasDj4/X1gbuH9x4bnxZV9GNnYHFcNAJ1i4gvutFl21DYLjRG6KbKgNHoEd5diAEgB+tIAHbvUio4SzeRNsDaXmhwYOdWav8Co3DM92GnZpOss+uElW7t3SetpwHh+ezDXxMVdsu4LEgUb2j9UYDuuOzz+hcXGTc+6JkyZyooqVXP08VXkfLVYDJWjwc68wL0Cw4NYeWcGQaH4VhGyTa5uHEqU55yb3u2eM3vENg0NaJAybCQ2q7Q8KvI6eHAO7f04DW02nAYQ5s4sbPxw7rcQ7YrybTP/RXbsNQSSB+1N8aurW1YPUsT0ACDRJFGu6oy7ABw637hkI2vP748PSlaCX7Dh/V1jovJ0XX5fN+8+ML84wlFh4p3xWMYjdO8SUytaAC1f7hJd/M5qcNqN0BVEaqU2YhTs7aca5cwIfttIAx91CAp0/G6V8G3qGtNpezwoeJrlzICJCh9hGOeF/U/h81e835tA3btDadfqTYPTUiegKQ4jpldWqTn85lybm8rBF2gKu+CNS7tfwFvXOz2fV75Oi+FOGQWWXaKXwRK4PQ+dUq2imfHRwobO0jbo4Fagt9SG0BmxcgApf6ndjMDWgIHm5StLP2A==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4331a367-91cf-43e3-fc14-08d85d073b92
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:12.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T2oOY+6iV9e6FUa3PX3tkjN3Xc1jjBBUv59GY0tEpslOddtjXqGXpfWac9R8tM88s23/NPhK8prelAQTYWaeCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most DSA switch tags shift the EtherType to the right, causing the
master to not parse the VLAN as VLAN.
However, not all switches do that (example: tail tags, tag_8021q etc),
and if the DSA master has "rx-vlan-filter: on" in ethtool -k, then we
have a problem.

Therefore, we could populate the VLAN table of the master, just in case
(for some switches it will not make a difference), so that network I/O
can work even with a VLAN filtering master.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2de0ff18f2f5..0db161178cc0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -329,9 +329,10 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct switchdev_trans *trans)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan;
-	int err;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -366,6 +367,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	for (vid = vlan.vid_begin; vid <= vlan.vid_end; vid++) {
+		err = vlan_vid_add(master, htons(ETH_P_8021Q), vid);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -409,7 +416,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
+	int vid, err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -417,10 +427,19 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	err = dsa_port_vlan_del(dp, vlan);
+	if (err)
+		return err;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
+		vlan_vid_del(master, htons(ETH_P_8021Q), vid);
+
+	return 0;
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev,
@@ -1265,6 +1284,7 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
@@ -1298,12 +1318,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	if (ret)
 		return ret;
 
-	return 0;
+	return vlan_vid_add(master, proto, vid);
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
+	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid_begin = vid,
@@ -1311,11 +1332,18 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
+	int err;
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vlan_del(dp, &vlan);
+	err = dsa_port_vlan_del(dp, &vlan);
+	if (err)
+		return err;
+
+	vlan_vid_del(master, proto, vid);
+
+	return 0;
 }
 
 struct dsa_hw_port {
-- 
2.25.1

