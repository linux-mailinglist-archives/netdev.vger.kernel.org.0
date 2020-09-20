Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B92711B5
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgITBsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:20 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbgITBsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMjo9dxfmrz0jabJhjupFLMCyDifp0SAjxDyoCBf0yRhkRqisLSP5Ra/WXM1Tk3FIJbRzH2jp6EEipuOLeRr+zFm0uFc4BhGb9AjRKPfCOupCUVGfxn+YwaHYSy2WH6jNgGWNXZ1NCXJy3J1kjKMJFJxRjp92xki5fUihbDuOlz92k4Do5szDDRAz+OpAopCrCK2LSXwCNQtBB1AK5esPaHdKKKtuQvg4P186KaTuU4va+L94K9rPU8+a4QNAsU6yRg6vpzA0Sm0fWVadpOmmHKNd2WN6BSnDCegPfnT5B1X+nuKTTSKzGK3h9Ts/35MoW7171vYGwUPH6F+X6q/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rEANGceKdmQCrE59JyxD5NgmiHf3ao+afGf/Miqt8=;
 b=PB0rNPW+cWjiR57Hvnh4WJ6KiepWAgwop7gX3v0bo/pok5XJBlevly9eMoXK13lj3EQ7zsFYzw+58Ol8+O5SHnUbpcIuHxZGfLNdzp/OMIuxeEujcP67J0Kx801pXjjJOK0ijK5LRcNMvl6BZP11XeEchBlAH2e3LMzj3BicMSIYFpq4S3iW+j8iOHKqfywHXkmA084Z5jC3KGdfJXxE8sAHWtCOf0MGwrMRKBkzcGo8Rkk+RJ4/+EwX8N3e6AX63EXa7uzw+CehSvr2NkT5bzcflhfvHBwEp111WBelLNeJpSI9kQ7gzwxOuQUEpGO9ih36jsbqEOjn3SBg6VK+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54rEANGceKdmQCrE59JyxD5NgmiHf3ao+afGf/Miqt8=;
 b=NjHdg+KL8tAmR2bmpb8MoezAVFCVcz2GPxoqmzngcMZtvo9XYvL/59iagK9AkBs7v37qT/pyxKdJAeLpG+9xVN8zaA4RaLURovJTdq3i8B2rde1mvetqWm5QoZ7F5zZyD6hsvPwNUvdP6bnCWRrvdabU9FRRobaVnBkjqYEW7ew=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 4/9] net: dsa: convert denying bridge VLAN with existing 8021q upper to PRECHANGEUPPER
Date:   Sun, 20 Sep 2020 04:47:22 +0300
Message-Id: <20200920014727.2754928-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:07 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32acfabd-a4ff-41e9-441f-08d85d073970
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686A06F9358BD6A948C7045E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/izgU6Exye31p10xYGH+G+qvFDKgQGEmGwU/NBwN0ndG0itePy78+YkPA5rC/XD9WFtfDH71bjFnsRne23HWTUy+WqLKBLGuNS8QjNfQyZPMGcwwRP/NFs2d55IP2rtqEq+oSEF7fp8u6FTZ9MP0+HpA1TWeG1nOA4vdOKdPL1/vrf5G8evxrYIRFGlU7NBINUna2JPb4ExvJv28DTfXHYDWtL+BZUoMjBYl2oIlyfbuLVNWO8cM819/wcgMnibSeZFCnX2t5a7mdYcQQdHkC5wMHVom746qyKrMTwIzRd52iO2tcQzHmmS/Izzplstqfji6kJCDml50F0XEPqCoLuwxuSWQhlWky+i8XPHfRoKZ6MCXvnIDsOEOfxUpcV8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rmoLMAEYlnk+EaIK2fZpp0BsgOBO0lsQreF1+rbMQVA/bLHNwsT82K03TFpz8dPCWLby4CK0S2921dHRWVhKJYXSUy3u+6HvldIXCWRXLoeZKBDAb/7izJC/gVG/6avNiX+3EfqN9LUXLPryeSsYtBKEnxjn1r9pBZCy1Y1AYtZ9lKR0uNX0jzXDP9GaFNRAhcxWHCS+sfRqGS0G+C69GBv9RkGKCAqzgjyPzH177M2IJIpUsF23hUUUci9p1Kw/2Zwkg30EXaTcRFAdNlfxROMTNDCTnPelfL5gqju8r7kU0mYt9qCubWBHSGeBOHKvHz54Cfm/eiXfFrvAUXctOFXTFvpp46SPFN7hpdcao0996qolxvQf9AQ7NyRZgOXbMgw6euPTJKQNZhhxi+aKMmxPo6QON4oCGqSIyN8EW3+N2NNCyVj01yUTml3g8G8xtbhRPQ5HQ3idRquXd78gRGWmG7oCDEP/nrSh3L35cZaGu6Nr23hCErbz/Wt9+dR89BXz4+ka1ILymxWSQRofmOWQax2jm07KPEk6vxVQU3pPkkvLoj8pjahh4VNzHtaRG0nqpq4HUhJJ0sj6xcep/LSrf/xktJ0OoAyV5GeXbENqeTY9INY9lNqYbe7EvjP2npi8ihp77tqqq8j+nMPJug==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32acfabd-a4ff-41e9-441f-08d85d073970
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:08.4837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMh5W+QMzL9bdBr5QdBlCnHvtqV78JYxNsKcTGuV3JIPhX27tsLCqYp6jMETxQIfLQzO6LxFDvdtT9kzUi6ElQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
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
---
 net/dsa/slave.c  | 33 +++++++++++++++++++++++++++++++++
 net/dsa/switch.c | 41 -----------------------------------------
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1940c2458f0f..b88a31a79e2f 100644
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
+		if (vlan->vid_begin <= vid && vlan->vid_end >= vid)
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

