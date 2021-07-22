Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494633D2720
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhGVPPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:41 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:4577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232702AbhGVPPe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmBtcLXDUWQLwwBwKchJhHIF51Ot/bWGa58EZ0zhQu92bbdWLX1QBSfeSwkVbsuAGKl5wRGKy5tDIXpa0Sg6lgHP3CDnUtkqUQuOC+4iy/zc88rixgi24Q1phtz85KjbsPMwZLaPTICixuB589oljcUHtgi2JI+/oXRXR8cVJARBmyf91JltTwVSaDiReTh1eGGQsQmumK06Hp42KSDobQTAywPrHYykDLM1ygGjo4YpmY04PV314rczs9iP3dsCy57u2S96Ry16FL6u/h/FiXVo2pmdDgmuRgEqdVt3gcySzziif72Vtm2zWbeDvi+laMlfdhgkH7shEjExBC4Dzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIyOdgOJmzR2/wDE+ObKRA/618GSd4mK0KWd8UjTGS0=;
 b=Q/jJMB5UFxAq8nxP23Vo66tWk5Bl24+jhw+8uy8NdIiTnreWlLg94inRtuVWVpqSkWg9GNLO+3ODeQuFadZ9pWCyBLfZFzu0/OWRKmJV6QAL/OeFqPS9eMDlPbl04q2LE3hz8tJL4tPIu2ab+REDk6+A//FCDmhYBokNASHLDK/DJ/OUHfxZjYqDthlWr5kaSpXAW0PpSZI8rQj0H1iezxCVLxAUsXqS6mnSaMYz7FUHvuk0x5NI6QcwyNysaEUShuC5ALIPyvYbvJuwQ01+vVoMCCzVapZD8JFVxqPRkrFKaOuwxVFvy0EU8Lngq5maa7yuC55UGSltLHPUYYYVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIyOdgOJmzR2/wDE+ObKRA/618GSd4mK0KWd8UjTGS0=;
 b=JaIniru+1ysTrkV4bra6cE3NeKSXfo6hAbUcY6xOAB9Cl09AaYZhfN3GQApWbsRmAXMd9yvAWs/hr4bUEUWBf50B46i5u11XfA6lWC1RLfevdLQFPcjCWr2QIkzkzj0irxJzyVUDtnWU8eUk+BiBSob6HdUKoYOLPhkV77wxEGk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3966.eurprd04.prod.outlook.com (2603:10a6:803:4e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 15:56:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:06 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 3/5] net: dsa: add support for bridge TX forwarding offload
Date:   Thu, 22 Jul 2021 18:55:40 +0300
Message-Id: <20210722155542.2897921-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:56:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f470829d-e92e-4e85-6850-08d94d293736
X-MS-TrafficTypeDiagnostic: VI1PR04MB3966:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3966D789A44FF0F52F8580A6E0E49@VI1PR04MB3966.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3eiDYtBRbH3E3HAsA4XYmKbmajR3+zqKUQamW8VhfjFtPzTXWd2/QewhRWs9hI1G6Yc46B0JxjC6lkGc1JDshW+aspa7KremZchW7Os2BCC8N1cxSyAkc1IFarOhoVUhc8cVwfOoITQpjov40YdNUihzFr7nj0SqUkE+c0PcvyREWfASYXnrUt8pROh3xxZHKl/fjt9pVu+X0vqA10mQIzswMM9XLZNfBQVIo7URts+G26nWlofDugzGoDeCuNsplWUlaSKjI8duIXkvLPknAcO7FC2orRwx8nMRc1G4OvXO54sddQSgX5Sr6nXEF1w58tX78e2DbS2qLRLiqQuXKko2/1sThVBPzM6h2Tc1UORlGBHn1CilotBGBKcYe7FNzi5q5O7qmSgSTw74DaA8yhusd8ljBvIBOtc7npCgTZ/hDGMlRWwIhtJewyg3Z0f0B4gydBGBtg/IjgPuUFJ+CNqnuMpws/oQXX28eE8t5qxZMqvVq853l/mLvB0qDA+7rPC+0vlAzWXAAsYNetriIjfV71QWvtabb27CCKC5qAaLfj93wzfDswbmwVCneWLqH0ssUJRaiFbx903f5K/6v101iPAJWaWLm9TSDrz6+MfGCJ0e7WB4VB8RpXblxc8FEgZBO/RGkEQ7Ed4ibIydKbo01B75j98o9VgZu2+5UK/Pj2C/VzxUrtqwW3CSaxLg3A+rN/umW5cTog0G2/ShYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(38350700002)(2616005)(7416002)(316002)(508600001)(86362001)(44832011)(66946007)(110136005)(6506007)(8936002)(4326008)(5660300002)(6512007)(8676002)(54906003)(186003)(66556008)(36756003)(1076003)(6486002)(6666004)(66476007)(52116002)(26005)(2906002)(38100700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VNHZ+S3Rz6lyQW77fCvnVBR45Iq18HkOJmX7imRB1I0ZuVccuHpIlGh8IbKE?=
 =?us-ascii?Q?vsFXJ0MTUiIiW0FFjaHNF2NSF2r4hCWT3udALxlYh1XIr0o6Tz1aoCCxk5pI?=
 =?us-ascii?Q?37nAjG9STzx/G/uRMwWJnVhvxbDUF91cchNT0Siz6Fc5z9OFqbOOujpe4d+n?=
 =?us-ascii?Q?RMcuXS8oR05A88sKmv/yvhGBaSCXHFMNj5LhPqzkU3tEJulVyESDZEJs5cr7?=
 =?us-ascii?Q?u8N73FqpaPm5qjY2UiwtizHZDxgmvY3LuMgDy2HWi5Uj8AMeg8YCyCZi/HSF?=
 =?us-ascii?Q?zfCeglsvuDxA18yX7E8kr6aTVj6I7ng76l5Z+trpQdj8gUp4lZ0g3hnBc3C4?=
 =?us-ascii?Q?MK2TNvnQyWLe52pSG3UOfaQadGrzZWvAiRKSxq7UE5F74sQND788Xm9IfpG7?=
 =?us-ascii?Q?NEV/sC9FZSoSgZHIwAyJ9XoLI2Zqk5V1js7FAO27NzQKoTJ2LgMa2Vc0FAx/?=
 =?us-ascii?Q?zPuplIoNChN9r6drRlMKGF6AWao61SkVySAgxx6CU0vII0ZxGdSy6vvTXh7f?=
 =?us-ascii?Q?/GlwR9qBbza0OA1Dn8LLwQXfpM6EBB8jSbgXe7IkWSGVCJqa1lzD1BlyxFgS?=
 =?us-ascii?Q?0BiVx3Ufsrnqx6/sK3Q2AT9OmETsa7bqUYWpVxCuFZEZA7QOU3i/dUH3ZiMJ?=
 =?us-ascii?Q?t1PQIbokuhSniS5EWdYpWQFC0xW2+h1Djifb6ylrFEAGtWp9SK1HRNHolkXX?=
 =?us-ascii?Q?oI3daVg9LS3G41ggnrPUpxLx49kamqKVg/BwK0pTwO1d7ew7aLlxTgWf09QS?=
 =?us-ascii?Q?hAnsEcOmNbddMe65WOITIdR71PpakhePgIbAXqd8ss+aTlXx7mMCFLIPENVg?=
 =?us-ascii?Q?QxLlmz4hay6Sl6Kj9suabTo6G8mBZZclW0llFhuwskgEf1CXOSP/kjjN+htC?=
 =?us-ascii?Q?C9G0IERFWasudHbMOm5hdcJ3uwUkiHJQRRW63trE4tFywHQjzt6sEIDRrD9l?=
 =?us-ascii?Q?02GjaxgY59wFXqvzbQUUmfeqbqqaaeGJqiCSMTNHmXewxFpMmBRGDzcs65BC?=
 =?us-ascii?Q?yq/fQddM+I2FM81XKLUG/jWKxKOtUtY9F6vAA8HboCosmTopaQRUhxjr8nFj?=
 =?us-ascii?Q?DilHauL+Kz6o1QnCFlGh+aoK5COOi629/xHqAFNhUHmFBkWF5kcGEQkT8Wof?=
 =?us-ascii?Q?Mev2xKow8hNXDE4mrIbriiznwNKKqWq+89/d0UEBHrK2bs1KWSszITKZP5gw?=
 =?us-ascii?Q?q9kxFoi62anCUsMq8hjhbPuGUYg+HE8QgJkngMMkvCXO8hIiyssQDCuguIJS?=
 =?us-ascii?Q?7Vc94eZCbFAXPM/IRlu0CU35DA+Dup9GkfHm/1MqMBzFjXuPpSJOwM4WlWB/?=
 =?us-ascii?Q?RKXNLufzNNWJeYuCn946nACC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f470829d-e92e-4e85-6850-08d94d293736
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:06.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4GMHyxbbB5MT2ZrelYtVUWKt/zCp9B4/sIZ3ffRqDTmupsAD6yQvmXvZFZHoqFX/d+Sq3NV9pqH5d/wIx3ybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3966
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a DSA switch, to offload the forwarding process of a bridge device
means to send the packets coming from the software bridge as data plane
packets. This is contrary to everything that DSA has done so far,
because the current taggers only know to send control packets (ones that
target a specific destination port), whereas data plane packets are
supposed to be forwarded according to the FDB lookup, much like packets
ingressing on any regular ingress port. If the FDB lookup process
returns multiple destination ports (flooding, multicast), then
replication is also handled by the switch hardware - the bridge only
sends a single packet and avoids the skb_clone().

DSA keeps for each bridge port a zero-based index (the number of the
bridge). Multiple ports performing TX forwarding offload to the same
bridge have the same dp->bridge_num value, and ports not offloading the
TX data plane of a bridge have dp->bridge_num = -1.

The tagger can check if the packet that is being transmitted on has
skb->offload_fwd_mark = true or not. If it does, it can be sure that the
packet belongs to the data plane of a bridge, further information about
which can be obtained based on dp->bridge_dev and dp->bridge_num.
It can then compose a DSA tag for injecting a data plane packet into
that bridge number.

For the switch driver side, we offer two new dsa_switch_ops methods,
called .port_bridge_fwd_offload_{add,del}, which are modeled after
.port_bridge_{join,leave}.
These methods are provided in case the driver needs to configure the
hardware to treat packets coming from that bridge software interface as
data plane packets. The switchdev <-> bridge interaction happens during
the netdev_master_upper_dev_link() call, so to switch drivers, the
effect is that the .port_bridge_fwd_offload_add() method is called
immediately after .port_bridge_join().

If the bridge number exceeds the number of bridges for which the switch
driver can offload the TX data plane (and this includes the case where
the driver can offload none), DSA falls back to simply returning
tx_fwd_offload = false in the switchdev_bridge_port_offload() call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3:
- signal the offloading capability via switchdev_bridge_port_offload()
- drop "bool bridge_fwd_offload" from the tagger
- drop "struct dsa_bridge_fwd_accel_priv" from struct dsa_port and
  replace it with a simple "int bridge_num"
- drop .crosschip_bridge_fwd_offload_{add,del}()
- drop the DSA_NOTIFIER_BRIDGE_FWD_OFFLOAD_{ADD,DEL} cross-chip notifier
  and call the driver directly on the port
v3->v4:
- use dsa_tree_find_bridge_dev() in the unprepare code path to allow the
  bridge_num to be properly reused when there is no port offloading a
  given bridge anymore
- drop the stray netif_set_real_num_tx_queues() change from v2
- properly call dsa_port_bridge_tx_fwd_unprepare() instead of prepare()
  in dsa_port_pre_bridge_leave()
- fix dp->bridge_num remaining -1 in dsa_port_bridge_tx_fwd_prepare() by
  removing the stray "int bridge_num" declaration which was shadowing
  the variable which had the function-wide scope
v4->v5:
- rename functions for naming consistency
- move dsa_port_bridge_tx_fwd_unoffload to dsa_port_bridge_leave instead
  of pre_leave, so that we won't have the problem with dp->bridge_dev
  still being populated

 include/net/dsa.h  | 18 ++++++++++
 net/dsa/dsa2.c     |  1 +
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 84 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 929bcaec4d41..f8eb2dc3fbef 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -162,6 +162,9 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
+
+	/* Track the bridges with forwarding offload enabled */
+	unsigned long fwd_offloading_bridges;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
@@ -262,6 +265,7 @@ struct dsa_port {
 	bool			vlan_filtering;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
+	int			bridge_num;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -413,6 +417,12 @@ struct dsa_switch {
 	 */
 	unsigned int		num_lag_ids;
 
+	/* Drivers that support bridge forwarding offload should set this to
+	 * the maximum number of bridges spanning the same switch tree that can
+	 * be offloaded.
+	 */
+	unsigned int		num_fwd_offloading_bridges;
+
 	size_t num_ports;
 };
 
@@ -696,6 +706,14 @@ struct dsa_switch_ops {
 				    struct net_device *bridge);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct net_device *bridge);
+	/* Called right after .port_bridge_join() */
+	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
+					      struct net_device *bridge,
+					      int bridge_num);
+	/* Called right before .port_bridge_leave() */
+	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
+						struct net_device *bridge,
+						int bridge_num);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index de5e93ba2a9d..c7fa85fb3086 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1044,6 +1044,7 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 	dp->ds = ds;
 	dp->index = index;
+	dp->bridge_num = -1;
 
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 78c70f5bdab5..b1d9aa4d313c 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -14,6 +14,8 @@
 #include <net/dsa.h>
 #include <net/gro_cells.h>
 
+#define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
+
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f2704f101ccf..7b9bf45a76b6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -230,6 +230,83 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
+static int dsa_tree_find_bridge_num(struct dsa_switch_tree *dst,
+				    struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	/* When preparing the offload for a port, it will have a valid
+	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
+	 * However there might be other ports having the same dp->bridge_dev
+	 * and a valid dp->bridge_num, so just ignore this port.
+	 */
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->bridge_dev == bridge_dev && dp->bridge_num != -1)
+			return dp->bridge_num;
+
+	return -1;
+}
+
+static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
+					     struct net_device *bridge_dev)
+{
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	int bridge_num = dp->bridge_num;
+	struct dsa_switch *ds = dp->ds;
+
+	/* No bridge TX forwarding offload => do nothing */
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || dp->bridge_num == -1)
+		return;
+
+	dp->bridge_num = -1;
+
+	/* Check if the bridge is still in use, otherwise it is time
+	 * to clean it up so we can reuse this bridge_num later.
+	 */
+	if (!dsa_tree_find_bridge_num(dst, bridge_dev))
+		clear_bit(bridge_num, &dst->fwd_offloading_bridges);
+
+	/* Notify the chips only once the offload has been deactivated, so
+	 * that they can update their configuration accordingly.
+	 */
+	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge_dev,
+					      bridge_num);
+}
+
+static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
+					   struct net_device *bridge_dev)
+{
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct dsa_switch *ds = dp->ds;
+	int bridge_num, err;
+
+	if (!ds->ops->port_bridge_tx_fwd_offload)
+		return false;
+
+	bridge_num = dsa_tree_find_bridge_num(dst, bridge_dev);
+	if (bridge_num < 0) {
+		/* First port that offloads TX forwarding for this bridge */
+		bridge_num = find_first_zero_bit(&dst->fwd_offloading_bridges,
+						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		if (bridge_num >= ds->num_fwd_offloading_bridges)
+			return false;
+
+		set_bit(bridge_num, &dst->fwd_offloading_bridges);
+	}
+
+	dp->bridge_num = bridge_num;
+
+	/* Notify the driver */
+	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
+						  bridge_num);
+	if (err) {
+		dsa_port_bridge_tx_fwd_unoffload(dp, bridge_dev);
+		return false;
+	}
+
+	return true;
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
@@ -241,6 +318,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
+	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -254,10 +332,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br);
+
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    false, extack);
+					    tx_fwd_offload, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
@@ -302,6 +382,8 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dp->bridge_dev = NULL;
 
+	dsa_port_bridge_tx_fwd_unoffload(dp, br);
+
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
-- 
2.25.1

