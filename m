Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13933F52D4
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbhHWVYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:20 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:5229
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232829AbhHWVYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 17:24:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZO0U/Uf0UtNSFpiUBCvwTUxyW5B8T2IG0eb7RulKELzhCoeIWG6fkVKyQminvH9Ekn4Qhw4oStNpLCfMOGnxbCV6t3LSn1XPDdFMnWi8yMHyfepbo657hQnVfwItpLxzukvrIKpRqjmhGRGIUmFYM5RXFwlkSiB8+szC7Mu06N9jpHYgzwbCKJ4ZyJwptFnirn8iNLYLGQJOrLsJjsU9r2c/OqTzjsTSyweUiQze3nXvK6zxdmWk50kYvq9uf4Rle+UsJssUXNeDI4MSKF5O6NmmMAVydjltU6cgIXmIZDepwI/oktoO0jMSuNDJ+48GBhTQ9kP8w5lgcKttSN+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAnOLn1LPPE32yMQXZwy2x5sztBRKfYMiUoKd31srao=;
 b=SgSOVdbhFtUuMyAcF226S28ZTtMtMO7L81FCOby8Sx9JsAwj/+IbqZwmCufaahn6Cx6C3RcNE9Tn2KXCo4oajImcHy3RxzmPBSjphAs4fKGyV1OM+WqOj6zJDv3iqMuzgl66mjMEwpJBwNdqt/rAFuTdyEUBYuo94T7xcBPQImkTeBD+7zNNB703+wX5DtRegkaQsDDr5JRFJpZPuhZ5gNcLn6X5mlOIR+z7wN2Cy63GYTauIRMFre/xqXJTcKOGG1bBeUcZwYnzTwoiineGNSil5Qng/aNtt1Aojoj2JveJmUBGUh33Zfv2wHzLPryYD6U77O6guhPYq2TD1bGBVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAnOLn1LPPE32yMQXZwy2x5sztBRKfYMiUoKd31srao=;
 b=p9G/Z40A/voBmwJB3zxGaQYjynkIMABd2y+nl17tMWVfhW7yudovoNWZsZxPpIF+ooQleXpq/sic/xKmh4rjE8GtN1EzbHbOv1TUkAkRrwLXgHpVwpxsWriF3zbGVnbO/85E69AbkxHwlCuEh5tz+mlcsReqp3RaZL7P3Eu/dHg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 21:23:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Mon, 23 Aug 2021
 21:23:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 4/4] net: dsa: let drivers state that they need VLAN filtering while standalone
Date:   Tue, 24 Aug 2021 00:22:58 +0300
Message-Id: <20210823212258.3190699-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
References: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 21:23:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee573cd1-7701-474e-91a6-08d9667c3921
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2685:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2685E17425ABD4514591A2D7E0C49@VI1PR0401MB2685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP+l8LJPv94sgxcmKorWmAv+quKbwfaEI/DJtDpPruXg4g5c12poFdu+fbpm2J7b9UF46+Q/lhYvZJYKj0svDE7uom5a0s7bRSjWdqYVOcgl4c//rWw4qYQoVsfzpwr8xl1n45oOxdDOhml0H/AgZYBxeJ/zvWSnWu99TxvpoRPyoaoFa5PUBeXtWAgmRJeWfCpo4Tt+YZJlGAU/olz9v0vBHmNq5UCeXfMqZPdN/oA9cxg6Z6mOYfdOMtXh76OQiaQEDnv7rZQjWYyhBO0LmOBtSw4w3W6oZqg58aG54QeTa7pNuUMa26h2dT08r7opmQI7afP17OtB21rpOFeF4WqFDTpVrepPDXjJLup9UmWglHC4erXJBSV7WBi10Sy3/NHXA7Gj0kAbYMOQQ0hNcbgK8wWOqretUoV75Fd4GbhUQdnU+5Lr26NP4LnR+NtzvVdoTClEjrHFqt2iA3tf7Wx/mLe5zsziOvqToNCp9onT3vmSU1/cjVY/xaQ+ZHccbGg419XVp+S3Jmhd9ctAfJoP6s7ANOMETP/w91OxSeyaSJ5MDzAUzS3nIv1CH/7d+g9JQTzaFZf5h77lLLtYUxljpQYfLN5QTxVaoCIbcFvJ3xwEvtbaflNAkR3j3xoxVOJYZKRxymfBlNCeRV9gw2897vfQp997D2TeqMmG7osjWNdhKNgQOgQA96iONBI4yUKADS6msbBN7uZxuJhUJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(396003)(136003)(86362001)(66476007)(66946007)(66556008)(316002)(6916009)(54906003)(478600001)(83380400001)(38100700002)(2906002)(38350700002)(186003)(36756003)(5660300002)(1076003)(6512007)(8936002)(6506007)(2616005)(956004)(6666004)(4326008)(44832011)(52116002)(6486002)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?axGpIntOp2CAlxE7ZSjcESQXISKPffVnwrIMkvi18UyUp4FFFUCcLjGZB+ZQ?=
 =?us-ascii?Q?lli72Hiy7J/Kv8USKBTjXTC6y0DsifM/BkTNEuEhGPrJY9NRMN8Hhwc5l6I+?=
 =?us-ascii?Q?5GSpxlUmNlGOMlR4Aq7eOPE3mEHYlAmu1WAvogqHjos0RZPJO3lqTa92bPLs?=
 =?us-ascii?Q?vtwHuBsfvuM1jYEvkquPAq99LfAiYo7Rmq+RRHs431cwXYtEHWYlOar9bGaW?=
 =?us-ascii?Q?5UaXEOcVzmNERMNMStv7n7T1DrMZSbPpPLGkvX0slNlagepUMKXca2nQc66S?=
 =?us-ascii?Q?KKVsKS09S1ifVcT0bV9ug4CYdjUqDlTmqyOjRamWoWbklwLdnoWjTZUVUvgZ?=
 =?us-ascii?Q?X/ul24O2oO9MxYIHWlJt05BVUtFn/2nf3bYcHZQfoZBR/leAIpvbbR2nCCHg?=
 =?us-ascii?Q?geeduzJaI9Ll7oeU55LqKa7ZAlg4RoRYh+edSGUOmn6yAVmx8i9ZUbEUs9H3?=
 =?us-ascii?Q?ENm8lv6HrrT+whVVfNcEgfsbNEUW0+u7tGQj4k1kmJe4Donqg8PanrWzijGw?=
 =?us-ascii?Q?W2iI9diSLF0Rf5bdOpMRGS0w6D337l8YOok673rjeCbbzNSMh4GVCFKZKnL9?=
 =?us-ascii?Q?bPBR68WsHE6ka9YSJmIwVPFE39mnLFIVOPn3tSawEK88xh5WxzpheG/vAYu+?=
 =?us-ascii?Q?10Dk8hVRBhkoAvt/A/7LxwlOTK7WTDd3QZcguAvU3qaLP9LAuhHQtz7IEYIo?=
 =?us-ascii?Q?YEe1o6r0jXZPZW28vteYVengPKr3pCqgGh4vwtQiZxaUpkFeLWdfaCe8YcHl?=
 =?us-ascii?Q?b8yZ62iPDBa2uIy3aaE6663TW8Q6CNA/Apazy0101xoQKjRzOtvkBe2NnPVz?=
 =?us-ascii?Q?swJkiFIW4SULp8jtGm1zRFvNnMjacqKqPpu1SWiztuCLiU+l1om6vwXn290/?=
 =?us-ascii?Q?IO8xozFYQqU5cfbBh5sbqz8luiQSexvOvlBSNInTdT1bCUtOYDg+F+IDCZgY?=
 =?us-ascii?Q?yhEk3L6uuIY+4IC5i5Ke8eaDsKFM7+biQ+u4/0F16SRh2sE4+BdgL0FxLCNb?=
 =?us-ascii?Q?pDx8+rgJYiYH3Zxn4IO1u5F3OI7IgEwdPXjUGY07FBMtPsipT6n8KNFsGuud?=
 =?us-ascii?Q?LETtzVGjQLNaUm7NycBH3/c2EK42eeM9y5TlJN+hVnQX9UkGNaPqj8SEvjxI?=
 =?us-ascii?Q?XTFmWVMypEgSYvVsvKMrpCOFTRAEqxrmgu5Xi8jSxKBZxgn7yN9S9ythU+px?=
 =?us-ascii?Q?CFiB3VhxIjEeEY2zzQzdhQ6kAiqpZomPtnCeUJCWhlW45QxweIDeCWzZI9+Y?=
 =?us-ascii?Q?e7qf/5X1gSy02TF4J009oNQSClBCAvWKos5hi8GgFDy2U722eqSo6CWMTiGP?=
 =?us-ascii?Q?RIk5oKAABxs6YiqUeezJIi+3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee573cd1-7701-474e-91a6-08d9667c3921
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:23:17.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ig3ftxqg06IGD8LnfOaWVHOXvq2gQ5j3ySzd6baH2ELAYKWNqk0nsH4bRkeE1MskjhAWmpX+CFEknuQLj7Ik+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in commit e358bef7c392 ("net: dsa: Give drivers the chance
to veto certain upper devices"), the hellcreek driver uses some tricks
to comply with the network stack expectations: it enforces port
separation in standalone mode using VLANs. For untagged traffic,
bridging between ports is prevented by using different PVIDs, and for
VLAN-tagged traffic, it never accepts 8021q uppers with the same VID on
two ports, so packets with one VLAN cannot leak from one port to another.

That is almost fine*, and has worked because hellcreek relied on an
implicit behavior of the DSA core that was changed by the previous
patch: the standalone ports declare the 'rx-vlan-filter' feature as 'on
[fixed]'. Since most of the DSA drivers are actually VLAN-unaware in
standalone mode, that feature was actually incorrectly reflecting the
hardware/driver state, so there was a desire to fix it. This leaves the
hellcreek driver in a situation where it has to explicitly request this
behavior from the DSA framework.

We configure the ports as follows:

- Standalone: 'rx-vlan-filter' is on. An 8021q upper on top of a
  standalone hellcreek port will go through dsa_slave_vlan_rx_add_vid
  and will add a VLAN to the hardware tables, giving the driver the
  opportunity to refuse it through .port_prechangeupper.

- Bridged with vlan_filtering=0: 'rx-vlan-filter' is off. An 8021q upper
  on top of a bridged hellcreek port will not go through
  dsa_slave_vlan_rx_add_vid, because there will not be any attempt to
  offload this VLAN. The driver already disables VLAN awareness, so that
  upper should receive the traffic it needs.

- Bridged with vlan_filtering=1: 'rx-vlan-filter' is on. An 8021q upper
  on top of a bridged hellcreek port will call dsa_slave_vlan_rx_add_vid,
  and can again be vetoed through .port_prechangeupper.

*It is not actually completely fine, because if I follow through
correctly, we can have the following situation:

ip link add br0 type bridge vlan_filtering 0
ip link set lan0 master br0 # lan0 now becomes VLAN-unaware
ip link set lan0 nomaster # lan0 fails to become VLAN-aware again, therefore breaking isolation

This patch fixes that corner case by extending the DSA core logic, based
on this requested attribute, to change the VLAN awareness state of the
switch (port) when it leaves the bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: put back the "ds" variable in dsa_slave_setup_tagger

 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 +++
 net/dsa/slave.c                        | 12 ++++++++----
 net/dsa/switch.c                       | 21 ++++++++++++++++-----
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 5c54ae1be62c..3faff95fd49f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1345,6 +1345,7 @@ static int hellcreek_setup(struct dsa_switch *ds)
 	 * filtering setups are not supported.
 	 */
 	ds->vlan_filtering_is_global = true;
+	ds->needs_standalone_vlan_filtering = true;
 
 	/* Intercept _all_ PTP multicast traffic */
 	ret = hellcreek_setup_fdb(hellcreek);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index c7ea0f61056f..f9a17145255a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -363,6 +363,9 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering_is_global;
 
+	/* Keep VLAN filtering enabled on ports not offloading any upper. */
+	bool			needs_standalone_vlan_filtering;
+
 	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
 	 * that have vlan_filtering=0. All drivers should ideally set this (and
 	 * then the option would get removed), but it is unknown whether this
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f71d31d3aab4..662ff531d4e2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1435,11 +1435,12 @@ static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
  * To summarize, a DSA switch port offloads:
  *
  * - If standalone (this includes software bridge, software LAG):
- *     - if ds->vlan_filtering_is_global = true AND there are bridges spanning
- *       this switch chip which have vlan_filtering=1:
+ *     - if ds->needs_standalone_vlan_filtering = true, OR if
+ *       (ds->vlan_filtering_is_global = true AND there are bridges spanning
+ *       this switch chip which have vlan_filtering=1)
  *         - the 8021q upper VLANs
- *     - else (VLAN filtering is not global, or it is, but no port is under a
- *       VLAN-aware bridge):
+ *     - else (standalone VLAN filtering is not needed, VLAN filtering is not
+ *       global, or it is, but no port is under a VLAN-aware bridge):
  *         - no VLAN (any 8021q upper is a software VLAN)
  *
  * - If under a vlan_filtering=0 bridge which it offload:
@@ -1871,6 +1872,7 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	struct dsa_slave_priv *p = netdev_priv(slave);
 	const struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct net_device *master = cpu_dp->master;
+	const struct dsa_switch *ds = dp->ds;
 
 	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
 	slave->needed_tailroom = cpu_dp->tag_ops->needed_tailroom;
@@ -1888,6 +1890,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
 		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+	if (ds->needs_standalone_vlan_filtering)
+		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index dd042fd7f800..1c797ec8e2c2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -116,9 +116,10 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
-	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
+	bool change_vlan_filtering = false;
+	bool vlan_filtering;
 	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
@@ -131,6 +132,15 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->br);
 
+	if (ds->needs_standalone_vlan_filtering && !br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = true;
+	} else if (!ds->needs_standalone_vlan_filtering &&
+		   br_vlan_enabled(info->br)) {
+		change_vlan_filtering = true;
+		vlan_filtering = false;
+	}
+
 	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
 	 * event for changing vlan_filtering setting upon slave ports leaving
 	 * it. That is a good thing, because that lets us handle it and also
@@ -139,21 +149,22 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * vlan_filtering callback is only when the last port leaves the last
 	 * VLAN-aware bridge.
 	 */
-	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
+	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
 		for (port = 0; port < ds->num_ports; port++) {
 			struct net_device *bridge_dev;
 
 			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
 
 			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
-				unset_vlan_filtering = false;
+				change_vlan_filtering = false;
 				break;
 			}
 		}
 	}
-	if (unset_vlan_filtering) {
+
+	if (change_vlan_filtering) {
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false, &extack);
+					      vlan_filtering, &extack);
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-- 
2.25.1

