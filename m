Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A013D97E4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhG1VzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:55:06 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:44933
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232130AbhG1Vy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:54:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An17tn5FKWL/Dp+Lo1qXDEobRNLIigilcrHLrtb561HkRorZFWe59W9nc2z/5MBgPIu0Hd557ItgorTLuts4WrUkJ6pCkDK8s31hQeNvtXmhJxCBlst42XCPNJPIk5a6Nf0QNnNSGKQfshdjRApqsTDgxZsFqgynq5WUqXbNEDAQJdHP1UWZbuSpCfE96cGtPQJhVOlZQDrN/Em2fAnk80cCuneRIwU7Blwv3VfTVsg7YYeDh1li9jPWr4FF+VH+vC+V9dJTeMD+I+SzPzs1lQ5H/5uFOmHelLtPeZkDVo37V/ujU9hPCWDLaxC8gsT4o5C+e6O4jxNUunc3VDY0mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCzPdhIS4oXM+f5vdB74F75e3unn1+4TG+s1vZqcbJk=;
 b=H/Iy2LRDQG7mD4caelvEDtGekBZu/P98auMQb54zs6WLur5vNz0iJwza9DLLrjVWEItKigTMN3UbFXcbCDaJWDUvVCe/SRauMGcQfM8LomPrZE3sxDXn6Yy8AHTgyhp+oKBvlZk3Xs3ao3gVTLnIAKfLAeuaWyG+VVcXl9hMn1n/6sowmfUng58R7hSCtso7p9Sj153ojeGGfv8SJst+G/Ol2JUzE0AneLjKWKxiUeuoqCWgD8oKXtkrvg9mkvadDdfHLcCuKp49d/MrGB/8E74Oe7s5lWIZ80elSHnG1tsOM5Vqemfw2y5+l4nUsaewK1sdBDIXgqjSQLNLkQCQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCzPdhIS4oXM+f5vdB74F75e3unn1+4TG+s1vZqcbJk=;
 b=JN33GNlf2CxtqXHrffNmuO9Au369VzGT6ECAzzbBHPLPkx9Ge6lkMfYXOHl3nzrrZlXwSSrrqofH50CbNwTYYb9lpf39SgjobsJ4/H8Q/Xdo2+JZQ3NfrvHcXzoRzOCg3y/pET/FcJ7uHwEAx2+hrwcI9BAZ01LrJksdN54woYg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4564.eurprd04.prod.outlook.com (2603:10a6:208:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 21:54:55 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 21:54:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: make sure untagged packets are dropped on ingress ports with no pvid
Date:   Thu, 29 Jul 2021 00:54:28 +0300
Message-Id: <20210728215429.3989666-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 28 Jul 2021 21:54:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43133c91-aa76-4a85-ac99-08d95212558c
X-MS-TrafficTypeDiagnostic: AM0PR04MB4564:
X-Microsoft-Antispam-PRVS: <AM0PR04MB456423D779ECA0C00F2DAF7EE0EA9@AM0PR04MB4564.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8mOTsfRmP8hs1YSey2k+B88IviT715+BfF5lCC1lZ3pVO+C5tmZhDW0dvv+nGA9cQI1e1fFK1TVrg5y53T728XeWBtWs6i7rgFmicZj34uZ6OojcqNBjuRSr7K/xzldlfKcNroihVqax+qdQZvSsSmrUvRqV7Xn1IEMHbfzI5psLV+4XKoCEIU3eXQOWzn6D34QUTGdpUdbBpZoQBv8qkglJ60nmmgZ50nFU1GRNcbgRAflSZMpd8XgJCJvfkMA8i2TsqJJNauTA2MeJY8FaxZ/5tMcy6J46GhHf+z+7AWAnQG20XiWL8qQ2j5qrrKHR/CG6lDtP00HCMdQIPLChMLQSq087E/JQSlT7d9QR3pmSMjgWd5GlHkr8cALjDPOFM8hVYJs0ctz2bJl9MrqpOI5DgdSdHH/3wpGne3fZkdNCz9WfSW1kSqwseHxgUiWKQY1pmBOwKdbQMbUix4+PL9ASage73qwwLpLAlMPwa2jgoXxFk0Gi7JTwQCHL7KvVoIYdRYGz8OrLuCYFz9hbcNQSu0SFB6pn+4Tfn52nlS2fQzphFgI+pbDGdQmbvkIAjxvddYlTUXqe8d9XdyZBB6xS1xLCZf8zMEMuw5NoMp4Xhcr8LJHC5+eeWHsWjFHIozmOVT2v5QrjHaTPEHrXFbRw20isYUdU2yAviEU+QTAdzu0Lz2HNbK7nKfHdaX5fkB15Y/rNISKouwE/wzA8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(6486002)(86362001)(110136005)(36756003)(66946007)(4326008)(316002)(8676002)(54906003)(66476007)(66556008)(6512007)(2616005)(956004)(44832011)(2906002)(6506007)(1076003)(8936002)(186003)(38100700002)(38350700002)(508600001)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yE2M69LCuqqDqJpOv7Z5SFo7+TMVMNiNa3Rz/7/OJXJtYsYqr4n80bj6L6Vc?=
 =?us-ascii?Q?JJT3iWTCImQL+OObp+q2pin7Nsc6+hKjTjb420VsEYU/KGfppwONdK5VNa5G?=
 =?us-ascii?Q?4PGyG2bWumiX4y94S22mt1cioGQpuLtHTILxlZYxdNPAgDds9UQpA0KGnduZ?=
 =?us-ascii?Q?WXKmLFUTbure9AxPLJPFbhsFvJ8Z9i1mcFzHyCnjqYfJdiNGSXi8F9d3jqbS?=
 =?us-ascii?Q?YFwDywWt/k9eZVJAsde5u4oJ0ZI/HgfP060WkQ7KjB2pelgCqJ3/7xe+TDEk?=
 =?us-ascii?Q?xSf61PvRYZZkkYJkm5/CRCGuI6Uc5RQ4GNNVWFLDu4BdY6VCpkr0BYHCKKkG?=
 =?us-ascii?Q?6WiAsvJJGOsjxq+dBY7oLLW7Qs/sWiTrw5aEMk0jB/Ae2/cYyL2rgsgBjlBD?=
 =?us-ascii?Q?fbZJjBaHwP4e+HpYOWoprZ39UlbgEe/BD5aq2lZ5Sv/OawNy8RnvoP0CsKb5?=
 =?us-ascii?Q?noZUd6bhSNvUMFnNaEb6Ax+GDN9r4I4nWyrd0noAw4GZUlMoQH8uNPRgBZka?=
 =?us-ascii?Q?2cA+E55JcBSj3f3Kt9PW2ZhDlmVVx/zaqolojzXGCY25ZDZYl6KahmBNH1v1?=
 =?us-ascii?Q?jI4DJNLkybM38MiBszXxoUtrUzyrTcY6Mu5yDs6F7efRyCHPdfuwxEIkne+g?=
 =?us-ascii?Q?m9ZwGO49IW005n7f9qIoOz3Ty0IrWCpCAbVkt/XNFkPriy6F9+z4MEx0kkPB?=
 =?us-ascii?Q?TRQmfZzhfxHz552oeq+rXtSkBBvjjCucKazzGFnzstVAAK2F7acnPojFDY5h?=
 =?us-ascii?Q?RcSuGUMVzN30ngljNF1lO7TczH/3sY+cNy8Yp33AE9oznl5QQKS5WcQ8l8BR?=
 =?us-ascii?Q?r1arHfsY7HVY9HnxUwLdQ+ECU6mmLz9LNL/mZe6iYubmQC3zozJevLP9V+TM?=
 =?us-ascii?Q?mBr3hp8wSm0TfSGaPIcDceUTQp5e/caQQEBgI6NKUDWCAiDT/Wo0/sUAN+Ql?=
 =?us-ascii?Q?/1oY/SaPv9OWsp2UMO/dNkC+ypc2WJtGEwql+YOnZTMHHnBr/VV4KoqsTq4/?=
 =?us-ascii?Q?eA5JUbxIhddzqyKiAR1kEmclJIEtXKHzzZw5qunRaXqCmkTWIXQiXFNs/yAi?=
 =?us-ascii?Q?YCjrKsm7FCOd06ZPmddfAyOQjcUwP0XsQNLFmEA9coFx12sHLFcBRajLkm1P?=
 =?us-ascii?Q?fD6DPIVo6i3ZGj4A8s6NjlrcRS+C5+toYKTZcRXZH+74A9uIc/EenKGpIjCZ?=
 =?us-ascii?Q?sBJW1lCRTs1fWW9yWMI25ymqlPe+suo+xS90VBhWkEv6j+L76VMVJuUT8pss?=
 =?us-ascii?Q?+RAS7/sNF/IdUTV+M68TaT6E0eP5Ok4mwWl465lSHpB92gcVbnZFahGMVXO5?=
 =?us-ascii?Q?0iLegQlqQlStTr829R2t9pmz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43133c91-aa76-4a85-ac99-08d95212558c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 21:54:54.9486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJaocI8wue8Pg/MjMClEXGlYjD+D4wFN8ZV69nZFZE5Tuco2qw8Ig3pFlkNCp5apkU35HuomocXpxmuqfMZMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Surprisingly, this configuration:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
bridge vlan del dev swp2 vid 1

still has the sja1105 switch sending untagged packets to the CPU (and
failing to decode them, since dsa_find_designated_bridge_port_by_vid
searches by VID 1 and rightfully finds no bridge VLAN 1 on a port).

Dumping the switch configuration, the VLANs are managed properly:
- the pvid of swp2 is 1 in the MAC Configuration Table, but
- only the CPU port is in the port membership of VLANID 1 in the VLAN
  Lookup Table

When the ingress packets are tagged with VID 1, they are properly
dropped. But when they are untagged, they are able to reach the CPU
port. Also, when the pvid in the MAC Configuration Table is changed to
e.g. 55 (an unused VLAN), the untagged packets are also dropped.

So it looks like:
- the switch bypasses ingress VLAN membership checks for untagged traffic
- the reason why the untagged traffic is dropped when I make the pvid 55
  is due to the lack of valid destination ports in VLAN 55, rather than
  an ingress membership violation
- the ingress VLAN membership cheks are only done for VLAN-tagged traffic

Interesting. It looks like there is an explicit bit to drop untagged
traffic, so we should probably be using that to preserve user expectations.

Note that only VLAN-aware ports should drop untagged packets due to no
pvid - when VLAN-unaware, the software bridge doesn't do this even if
there is no pvid on any bridge port and on the bridge itself. So the new
sja1105_drop_untagged() function cannot simply be called with "false"
from sja1105_bridge_vlan_add() and with "true" from sja1105_bridge_vlan_del.
Instead, we need to also consider the VLAN awareness state. That means
we need to hook the "drop untagged" setting in all the same places where
the "commit pvid" logic is, and it needs to factor in all the state when
flipping the "drop untagged" bit: is our current pvid in the VLAN Lookup
Table, and is the current port in that VLAN's port membership list?
VLAN-unaware ports will never drop untagged frames because these checks
always succeed by construction, and the tag_8021q VLANs cannot be changed
by the user.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 74 +++++++++++++++++++-------
 1 file changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 293c77622657..5ab1676a7448 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -57,6 +57,38 @@ static bool sja1105_can_forward(struct sja1105_l2_forwarding_entry *l2_fwd,
 	return !!(l2_fwd[from].reach_port & BIT(to));
 }
 
+static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	int count, i;
+
+	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
+	count = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entry_count;
+
+	for (i = 0; i < count; i++)
+		if (vlan[i].vlanid == vid)
+			return i;
+
+	/* Return an invalid entry index if not found */
+	return -1;
+}
+
+static int sja1105_drop_untagged(struct dsa_switch *ds, int port, bool drop)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_mac_config_entry *mac;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	if (mac[port].drpuntag == drop)
+		return 0;
+
+	mac[port].drpuntag = drop;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					    &mac[port], true);
+}
+
 static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 {
 	struct sja1105_mac_config_entry *mac;
@@ -76,6 +108,9 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
+	struct sja1105_vlan_lookup_entry *vlan;
+	bool drop_untagged = false;
+	int match, rc;
 	u16 pvid;
 
 	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev))
@@ -83,7 +118,18 @@ static int sja1105_commit_pvid(struct dsa_switch *ds, int port)
 	else
 		pvid = priv->tag_8021q_pvid[port];
 
-	return sja1105_pvid_apply(priv, port, pvid);
+	rc = sja1105_pvid_apply(priv, port, pvid);
+	if (rc)
+		return rc;
+
+	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
+
+	match = sja1105_is_vlan_configured(priv, pvid);
+
+	if (match < 0 || !(vlan[match].vmemb_port & BIT(port)))
+		drop_untagged = true;
+
+	return sja1105_drop_untagged(ds, port, drop_untagged);
 }
 
 static int sja1105_init_mac_settings(struct sja1105_private *priv)
@@ -1997,22 +2043,6 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return priv->info->tag_proto;
 }
 
-static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
-{
-	struct sja1105_vlan_lookup_entry *vlan;
-	int count, i;
-
-	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
-	count = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entry_count;
-
-	for (i = 0; i < count; i++)
-		if (vlan[i].vlanid == vid)
-			return i;
-
-	/* Return an invalid entry index if not found */
-	return -1;
-}
-
 /* The TPID setting belongs to the General Parameters table,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
@@ -2219,8 +2249,16 @@ static int sja1105_bridge_vlan_del(struct dsa_switch *ds, int port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
+	int rc;
 
-	return sja1105_vlan_del(priv, port, vlan->vid);
+	rc = sja1105_vlan_del(priv, port, vlan->vid);
+	if (rc)
+		return rc;
+
+	/* In case the pvid was deleted, make sure that untagged packets will
+	 * be dropped.
+	 */
+	return sja1105_commit_pvid(ds, port);
 }
 
 static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
-- 
2.25.1

