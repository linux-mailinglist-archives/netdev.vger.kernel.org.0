Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D52718C2
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:39 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:17287
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgIUALg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efxlleZ9gWo+c36BUlU2roZi9UXeOr0Lf2QBrEQeCPB+KrQ8ISuMGkl1XfkS/O08yE6nh9KQinC7Iz/pwrD4qAaA+4yb+AzqvBdSnAczT7C2Ti58AI5KS+YWBsnIPgi3yYAr+komgHHVo/aciHxqygcm13P7TooqBf7v+7YjF+rRJteiL4NEcXiY+Vgr1ePCqPqwKT+3w3+A2xx+gLbkIoJ57a7WsmC85YZ8cZyq6vy9JNB6WzS3d9hKpqCkUjam9AmSjb408++nZB/BpIzQaeIFthRLPgVIr8rlBDrqYbkOxxdWvZq2bNoUf83vWyYpwcJ7tOf1JWgOUwmjo21L8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA/nmfbRVxGI/qm96vQG5wezV2nnzc5ZCHSMxMKKvbU=;
 b=FxRFMBGxGc+kD0MpNRR7idEignOIjD1oSEPwjE2CRDQwfRf0w6T/qN3RnnSFtKhWV25X00uin8QfJ8RH8Q/c01IuH85W2fO374H48rNGLDCJezWhQZf1YCkSatwXbUeyPsSy4emB6I44sL5qqENkHozp6/a0QfPuPiXuPdGc8GEZH4Zi6q7UY+V6Qusxmqqkmzg2hOS4IXYh+BLb1z4y8pSCb8ogdWbNco0SUG+8fbw6JCwFG8DXYOS6y76HzYGqNZAeaIjUGZRkwhjf80bSYnN4UGUyJYpU4Rm4yBvGmFCJ9qL5vph3x9Lf+TSd/zo531QCKKZhAcvoW14vG2o7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA/nmfbRVxGI/qm96vQG5wezV2nnzc5ZCHSMxMKKvbU=;
 b=dwEZQ40ZfNt1RYgd3i+JXJBqBFiptuVV2l9f4T7napM5ff1vTqupxpwqMYj00ovoSVLB1yKASK1gnOaCzMsIW8MvgBrl+P1oSPL1bQOdqwTqUkvCGIpjb4MleLrgBqNMUhtDsbXBS9j6uEQjY8auvA7TMSEM3G5e+4XqW+iDDH0=
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
Subject: [PATCH v2 net-next 4/9] net: dsa: convert denying bridge VLAN with existing 8021q upper to PRECHANGEUPPER
Date:   Mon, 21 Sep 2020 03:10:26 +0300
Message-Id: <20200921001031.3650456-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e675e1b-cab3-4e04-097c-08d85dc2cc24
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB550135EAD605111973B719C7E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wbTJv80qzDp8c7G4m27FSiv0txd/MsfHou9w5NaPR7c43W2NiTELeAj3H3P1nKrIibVAG7kX9nnebpF3CW2M954yob0coYq50mBvQmUmFohMvuVZWETSn6OGwzLBs5WkmZ1ZS4MR9tzRdmhJcyoDT/Ms2wASdunenJpGN0CFDiCNlvaSS/YQwpKzlDV0u53YW1M/E/B5fZ9GYqm6h1wTQUIi5MmQtzyDYmLAgAHPcC0rieQR16iMtrTyVb5QtSjj859DbAOHAUroRyCGW2UEGOMS4/p039v82C2FIpm4735elOk8EcOCK2lf1hXlUl3RD9LIOj8ToIm+SGVnrk4rOp2Tav0uIdlthFXuQBJyq8M0xg9Ic+Sb1JNLxfFitdFz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1+UDVdnAFPkrzjRjXMlGzppBOJ4KulLKGyHPls08Y8NBor8eYMh5m/2CgdBoFpdaJWDKE8gdpcIWey+JkIbfsX/iUr4Ii+kMOpQCzLQ+7mo9NCBTOGZOmrGajr0mOF2R5rsKsnfNDz3FA1whuolXmxhRRmbdYiRM3rzisHkfHZjnyiwpu/c2ICN0CaFX+TEgCbuGNJ+P7tUmnwuoQ8cw/ARKmlH6bDrqEpoQZP1jcXb73osOU9TvOgPo+kai7BvSB7Yf1qNlEveL/59HCDgyEGUymOy4rl03S1ESdAHiYz1t965TwW0gk/9oP4RrmznoU96b/uMH4XdAfRm86BdIgFLr+g90foaUtNY9ZO0g6MOfuvAFKdANrFVwStplNpCmD1o/15amF4USz7K+jITvmDMMeHftU8/PQoG2Doge8gPfvQ9E6yJqXPcOYVR6Wc/W/DVasacCRZ+Y0LdF7psuMQkVKSapPGAgIf3wt+NwlEwgInFRsZd0huypP3V0bDL6FmLcfA82WFQgl9PMLYD+mi5T0Ol97t+uHU82tUtpCbL4mi9CJk2VUMdcWC8zSzswv0vbWKtMY+ye3xXMPAaJ2sr73KiLld8ySSO3L7njK69fVRvYqJBv9ArFJmrC9h2o9tecnD+etHO14VSZAVPnxg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e675e1b-cab3-4e04-097c-08d85dc2cc24
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:50.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4IKx6YOZL6FsNg7dKT9bUOCpuLWw1ncy/oFEsFKRwDAWXjMUM7AbkWBSOLgiOjame/2vnu0RYkssQozcwbr3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is checking for the following order of operations, and makes sure
to deny that configuration:

ip link add link swp2 name swp2.100 type vlan id 100
ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
bridge vlan add dev swp2 vid 100

Instead of using vlan_for_each(), which looks at the VLAN filters
installed with vlan_vid_add(), just track the 8021q uppers. This has the
advantage of freeing up the vlan_vid_add() call for actual VLAN
filtering.

There is another change in this patch. The check is moved in slave.c,
from switch.c. I don't think it makes sense to have this 8021q upper
check for each switch port that gets notified of that VLAN addition
(these include DSA links and CPU ports, we know those can't have 8021q
uppers because they don't have a net_device registered for them), so
just do it in slave.c, for that one slave interface.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Using:
		if (vid >= vlan->vid_begin && vid <= vlan->vid_end)
instead of:
		if (vlan->vid_begin <= vid && vlan->vid_end >= vid)

 net/dsa/slave.c  | 33 +++++++++++++++++++++++++++++++++
 net/dsa/switch.c | 41 -----------------------------------------
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1940c2458f0f..a1b39c6ddf4d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -303,6 +303,28 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	return ret;
 }
 
+/* Must be called under rcu_read_lock() */
+static int
+dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
+				      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct net_device *upper_dev;
+	struct list_head *iter;
+
+	netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
+		u16 vid;
+
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		vid = vlan_dev_vlan_id(upper_dev);
+		if (vid >= vlan->vid_begin && vid <= vlan->vid_end)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct switchdev_trans *trans)
@@ -319,6 +341,17 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
+	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
+	 * the same VID.
+	 */
+	if (trans->ph_prepare) {
+		rcu_read_lock();
+		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
+		rcu_read_unlock();
+		if (err)
+			return err;
+	}
+
 	err = dsa_port_vlan_add(dp, &vlan, trans);
 	if (err)
 		return err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 86c8dc5c32a0..9afef6f0f9df 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -232,43 +232,6 @@ static int dsa_switch_mdb_del(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_port_vlan_device_check(struct net_device *vlan_dev,
-				      int vlan_dev_vid,
-				      void *arg)
-{
-	struct switchdev_obj_port_vlan *vlan = arg;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		if (vid == vlan_dev_vid)
-			return -EBUSY;
-	}
-
-	return 0;
-}
-
-static int dsa_port_vlan_check(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_vlan *vlan)
-{
-	const struct dsa_port *dp = dsa_to_port(ds, port);
-	int err = 0;
-
-	/* Device is not bridged, let it proceed with the VLAN device
-	 * creation.
-	 */
-	if (!dp->bridge_dev)
-		return err;
-
-	/* dsa_slave_vlan_rx_{add,kill}_vid() cannot use the prepare phase and
-	 * already checks whether there is an overlapping bridge VLAN entry
-	 * with the same VID, so here we only need to check that if we are
-	 * adding a bridge VLAN entry there is not an overlapping VLAN device
-	 * claiming that VID.
-	 */
-	return vlan_for_each(dp->slave, dsa_port_vlan_device_check,
-			     (void *)vlan);
-}
-
 static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 				  struct dsa_notifier_vlan_info *info)
 {
@@ -291,10 +254,6 @@ static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = dsa_port_vlan_check(ds, port, info->vlan);
-			if (err)
-				return err;
-
 			err = ds->ops->port_vlan_prepare(ds, port, info->vlan);
 			if (err)
 				return err;
-- 
2.25.1

