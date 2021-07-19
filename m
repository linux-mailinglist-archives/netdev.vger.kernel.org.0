Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1C3CD624
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbhGSNM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:12:58 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:65094
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240772AbhGSNMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 09:12:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGAJGX//d6feJMUyYcnwbS8g52+264YWv26js71lJw+niq0KU50pjnkHgOw8YyzQt+i2f+dKP0J9MfZtYna86adHC+Wc0tyaC3uZJF5vbZ9MYv0oifcmdLXmnLjN/11HUEvCNZD+Jo6EBC0Fhg4c9shYqjeO0VA/j3kx4qjXFelGG81k54193xIvM+/AXFHmcovQhUzNgVPy6FlFvn/aDrcYah3SfGIuET+bN2BiuuuL7yhT0/xeDZUyT9EE9s6gdDN+tWgu7enIzQylbvG5fW223mbTeoT6kI7f9MaOnaeae52Kn2EANRQbfRcD7b1XR7NhpfTZPsg73XxlX25daQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLMbPaoN3FMzym7hsZyiIWH3QIQDCDi4v1MvQHkMpNU=;
 b=aR+SPyzdO5l156rUj7ZhnvQbpuG+K4EL525U22VK5BzPc0ANu9mbdwd6W+qyMu6XiSL9NeeE/9XSrmLlukS5yRtrNGs6rruqXgbEpHp5U41PvdM4B1k1IUjlKx9sW8nOho7HSXSYurJaBlh5nnezFHlwOHp5XIpmomaiivjuV/CUYncQpSwMpK+It+iyPfB9ucawuhM9TQVtvMVO9pA4vNgTsgAt2uDtQ4ORzugncx+hHCWMb6OXfSS6ASK18p8fDHx0/yySsSBvyK1KAvlgVm+9bLbgmCiTka0Tg3Jj8w+yotbvDouQstlb7tAB89jHnezUC01USLhdv/g+4YZmXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLMbPaoN3FMzym7hsZyiIWH3QIQDCDi4v1MvQHkMpNU=;
 b=drbKA5HPplGiRW4dHtAxZS8RVBKYSeDOW8zsrtBrSbPEE0k7OME1ZCjt2YiyGqjTi9x57/V4E8TnFvc9FQxJMyS32QwgBTSSoxzS2nBO8Z6z5ZFwMUPOcRj+mqxdv+Jtnve4L0PluHOdpGtty5iEXdCMIr4ISh1V5fj9uVME8xA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 13:52:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 13:52:02 +0000
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
        bridge@lists.linux-foundation.org, DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 2/3] net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
Date:   Mon, 19 Jul 2021 16:51:39 +0300
Message-Id: <20210719135140.278938-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719135140.278938-1-vladimir.oltean@nxp.com>
References: <20210719135140.278938-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 13:52:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60bc141d-b505-4715-b553-08d94abc62bf
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471A8CD6F5B8F7A91425F8FE0E19@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPWME9LVlUbYQSMw1wIohuWmshlQj4wrsycxTDfYl1IUYIeq8jkamYIRb5oWdUZX8uGScwaIUnwWjUR4Xsl1ojXCZ5uOXG0f1hUac3WP9OxpqMyKinLfJGaq4AIgDRmUVWkE3MZ2JsmBvu5XtbtNSiq/LttcPcNjGJixqYuh2Fc+vH4YEN4aqrayt7cVAcLwmLpm3SbraVWU11815iVm8fjy4zhSiiJosBSNdaIbwWgP1RXzZkuw7HMG4i9irDFDupmWrCe0H7GQdKC/8qqaOg09RvHpXFzTUP3nThOFEKRGtINve3+aonwp7EoEIaQ0sOFQL/AooFO7naOaQWLmmFvcjajVPS8RXwrL7muxZqsIts4t4h6jERnXv3iPDR7PZpo5d5te44ey41exMJ3BRxG6ybA9j7bsTL7706D+tkQG66kUyUY/1yUjDodM/ltfi0KsjmVMQ3Qttw9rnPtQahcl+N5eEfUZ8G6OxV9/myN/1mGqudZp8AZ5fSm3lmtbEnKZy+7dvoRLGRwlBmQmrTe9df7BuOxNp0XPN7QmVEb4jD9/wOFZCuz/kXzg1Oyr9SI+DlIfmZHa590xnEk5pVVCo1nbyYsqjkbnUxhE1GxHak+Rq+HvwPq+fVkI1CCvLLrUf0nCokMHFEMMIvriWyPxckD9x10CzehWr2+cIXFBB2WnnmPkClpeS2OyR//ptAB5spSgBCb01rZG9m3aDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(6506007)(8676002)(7416002)(1076003)(44832011)(5660300002)(52116002)(110136005)(30864003)(316002)(54906003)(8936002)(6486002)(66556008)(6666004)(4326008)(6512007)(36756003)(478600001)(83380400001)(186003)(86362001)(2906002)(38100700002)(66476007)(26005)(66946007)(956004)(2616005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kyiR1ILcWnmZeYzgYAA1c44HtM09ClR3c3dxGj30tzBFyxSKhTEFm8MabKPG?=
 =?us-ascii?Q?Gd7P76Yys55Va573c0CSkUFm4Axo7ydET95cCc9ahIhwizgDjooCaiRsfKbF?=
 =?us-ascii?Q?IXJZTmj/R3n/q8vgOxNcXRoPsWRnIrpxxBX20kl30o4vXdRfAzkE03iFo4Tb?=
 =?us-ascii?Q?t91qvBg/MncMebke0JTqQkZ2id+y9bYsF5Hjxa2jTyEaImHVxJsQvtXtyV+i?=
 =?us-ascii?Q?gF0A0KMgvaJbw2FJ9BQlousaxyI+sYVKfoBrinCPL2n++3d5HXJsFH64llOR?=
 =?us-ascii?Q?5DcEwarGiqILA6D/vJ15Ka0Dv2IFsoUrt0MhyQ/VCY38xSsbQTDu7/CXkYB6?=
 =?us-ascii?Q?z9zy6xMx4RpkwVm+jZ9EckpQYeykEehNR6q/5HZ8Oc2CkbpwQ2CeqS3fj3dt?=
 =?us-ascii?Q?B5iHAIM3FlQnEU863+9Kpf+AsRA84kbDaTFGwbvt+PcXHpxKL0fkq+2wsBXP?=
 =?us-ascii?Q?xTAlLn882IhtOsx88tqcmDX6esss3i5jWafTaYeUOWUryItktBn7bYAB9EpS?=
 =?us-ascii?Q?anHVXGENfFJN14ULCWSYl3STiqDd2Y5UevWuxxgcJBJwnlod6RCEVc8T7WHD?=
 =?us-ascii?Q?QNqTL6elA60IG2TgYawkAbdtWZwaJ8zJ4PqGYNOGArxjCFa2OkaJ8lUX+vuw?=
 =?us-ascii?Q?RD6rhTWCVEVF5kHLVJWMc/+BKu20lhqmqwG4/uR8JnS7qtsweIVCX3n84vjw?=
 =?us-ascii?Q?ulzZ35ZelnJpIX8vVIoZGs6PsFbAFMh0AsY6VKde83VJNJY0IBtiypMwvJ4O?=
 =?us-ascii?Q?eWlu5Y601SGfnmy2GpNljPrVX6m+z8Y6pfmdTcLLEVZdaAsOEphd/XPvNg+E?=
 =?us-ascii?Q?sHDJAynPRex3clm/hSGMPXrTjGlPIlSKgM1JmvG6G3NFqRSauCZsme0WLLJi?=
 =?us-ascii?Q?vrrExDMOlImnN+3jBCr0b/h20IsgNwBZiI0ikiq+rdtnyAo/It4mvYUVTEp6?=
 =?us-ascii?Q?/16+8Hv6BGkfKvhUj8k/xNJtIr6+TyLliTSMT/PH7GqZ17bXZBNYqyGGN+cg?=
 =?us-ascii?Q?BjEJmV5lauGRydnoLqr7IgWn+TcIzPNUge2Rd2DJMwJ/dMSGmMNyN8+AS7Gd?=
 =?us-ascii?Q?S7JiDBcrBBaM5BBhBknwE7SXdxavdsdP58DkXw0Aty+LOZUNIN7GBQDM8Bte?=
 =?us-ascii?Q?g3lGhfAis3+0uP6hVufHNC5BOhEEpQDtoXPexaIHs7GHZIFPUN+gfOM7SA4Y?=
 =?us-ascii?Q?0MwT/irQuneDjdP0CqyQfA3XXUIlG74FoeW/HtSXnYVHFrwOFB2YCSTTlCw8?=
 =?us-ascii?Q?NLROYkBik6vOxhDWUyEf4g73GNXg/XM2EAlJTgR6KPkDfsqiv33CF/ZjV7nv?=
 =?us-ascii?Q?K5KXoJCPUNNS2UnxPSrZ5pmn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bc141d-b505-4715-b553-08d94abc62bf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 13:52:02.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLWlpbw3LmyTQznB2ChhBe+hrxXmm6YWrVXVbxJMoxkgM9KxHmg5ZBNsy/YI/wiqIXXwQjmLjxgTRpSxocC14w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA has an issue with FDB entries pointing towards the bridge
in the presence of br_fdb_replay() being called at port join and leave
time.

In particular, each bridge port will ask for a replay for the FDB
entries pointing towards the bridge when it joins, and for another
replay when it leaves.

This means that for example, a bridge with 4 switch ports will notify
DSA 4 times of the bridge MAC address.

But if the MAC address of the bridge changes during the normal runtime
of the system, the bridge notifies switchdev [ once ] of the deletion of
the old MAC address as a local FDB towards the bridge, and of the
insertion [ again once ] of the new MAC address as a local FDB.

This is a problem, because DSA keeps the old MAC address as a host FDB
entry with refcount 4 (4 ports asked for it using br_fdb_replay). So the
old MAC address will not be deleted. Additionally, the new MAC address
will only be installed with refcount 1, and when the first switch port
leaves the bridge (leaving 3 others as still members), it will delete
with it the new MAC address of the bridge from the local FDB entries
kept by DSA (because the br_fdb_replay call on deletion will bring the
entry's refcount from 1 to 0).

So the problem, really, is that the number of br_fdb_replay() calls is
not matched with the refcount that a host FDB is offloaded to DSA during
normal runtime.

An elegant way to solve the problem would be to make the switchdev
notification emitted by br_fdb_change_mac_address() result in a host FDB
kept by DSA which has a refcount exactly equal to the number of ports
under that bridge. Then, no matter how many DSA ports join or leave that
bridge, the host FDB entry will always be deleted when there are exactly
zero remaining DSA switch ports members of the bridge.

To implement the proposed solution, we remember that the switchdev
objects and port attributes have some helpers provided by switchdev,
which can be optionally called by drivers:
switchdev_handle_port_obj_{add,del} and switchdev_handle_port_attr_set.
These helpers:
- fan out a switchdev object/attribute emitted for the bridge towards
  all the lower interfaces that pass the check_cb().
- fan out a switchdev object/attribute emitted for a bridge port that is
  a LAG towards all the lower interfaces that pass the check_cb().

In other words, this is the model we need for the FDB events too:
something that will keep an FDB entry emitted towards a physical port as
it is, but translate an FDB entry emitted towards the bridge into N FDB
entries, one per physical port.

Of course, there are many differences between fanning out a switchdev
object (VLAN) on 3 lower interfaces of a LAG and fanning out an FDB
entry on 3 lower interfaces of a LAG. Intuitively, an FDB entry towards
a LAG should be treated specially, because FDB entries are unicast, we
can't just install the same address towards 3 destinations. It is
imaginable that drivers might want to treat this case specifically, so
create some methods for this case and do not recurse into the LAG lower
ports, just the bridge ports.

DSA also listens for FDB entries on "foreign" interfaces, aka interfaces
bridged with us which are not part of our hardware domain: think an
Ethernet switch bridged with a Wi-Fi AP. For those addresses, DSA
installs host FDB entries. However, there we have the same problem
(those host FDB entries are installed with a refcount of only 1) and an
even bigger one which we did not have with FDB entries towards the
bridge:

br_fdb_replay() is currently not called for FDB entries on foreign
interfaces, just for the physical port and for the bridge itself.

So when DSA sniffs an address learned by the software bridge towards a
foreign interface like an e1000 port, and then that e1000 leaves the
bridge, DSA remains with the dangling host FDB address. That will be
fixed separately by replaying all FDB entries and not just the ones
towards the port and the bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   |  56 +++++++++++
 net/switchdev/switchdev.c | 190 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 745eb25fb8c4..6f57eb2e89cc 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -272,6 +272,30 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
 				 bool joining);
 
+int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*add_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_add_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info));
+
+int switchdev_handle_fdb_del_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*del_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_del_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info));
+
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
@@ -355,6 +379,38 @@ call_switchdev_blocking_notifiers(unsigned long val,
 	return NOTIFY_DONE;
 }
 
+static inline int
+switchdev_handle_fdb_add_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*add_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_add_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info))
+{
+	return 0;
+}
+
+static inline int
+switchdev_handle_fdb_del_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*del_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_del_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info));
+{
+	return 0;
+}
+
 static inline int
 switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 070698dd19bc..82dd4e4e86f5 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -378,6 +378,196 @@ int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 
+static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
+		const struct net_device *orig_dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*add_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_add_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info))
+{
+	const struct switchdev_notifier_info *info = &fdb_info->info;
+	struct net_device *lower_dev;
+	struct list_head *iter;
+	int err = -EOPNOTSUPP;
+
+	if (check_cb(dev)) {
+		/* Handle FDB entries on foreign interfaces as FDB entries
+		 * towards the software bridge.
+		 */
+		if (foreign_dev_check_cb && foreign_dev_check_cb(dev, orig_dev)) {
+			struct net_device *br = netdev_master_upper_dev_get_rcu(dev);
+
+			if (!br || !netif_is_bridge_master(br))
+				return 0;
+
+			/* No point in handling FDB entries on a foreign bridge */
+			if (foreign_dev_check_cb(dev, br))
+				return 0;
+
+			return __switchdev_handle_fdb_add_to_device(br, orig_dev,
+								    fdb_info, check_cb,
+								    foreign_dev_check_cb,
+								    add_cb, lag_add_cb);
+		}
+
+		return add_cb(dev, orig_dev, info->ctx, fdb_info);
+	}
+
+	/* If we passed over the foreign check, it means that the LAG interface
+	 * is offloaded.
+	 */
+	if (netif_is_lag_master(dev)) {
+		if (!lag_add_cb)
+			return -EOPNOTSUPP;
+
+		return lag_add_cb(dev, orig_dev, info->ctx, fdb_info);
+	}
+
+	/* Recurse through lower interfaces in case the FDB entry is pointing
+	 * towards a bridge device.
+	 */
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		/* Do not propagate FDB entries across bridges */
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
+		err = __switchdev_handle_fdb_add_to_device(lower_dev, orig_dev,
+							   fdb_info, check_cb,
+							   foreign_dev_check_cb,
+							   add_cb, lag_add_cb);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	return err;
+}
+
+int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*add_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_add_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info))
+{
+	int err;
+
+	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
+						   check_cb,
+						   foreign_dev_check_cb,
+						   add_cb, lag_add_cb);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(switchdev_handle_fdb_add_to_device);
+
+static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
+		const struct net_device *orig_dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*del_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_del_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info))
+{
+	const struct switchdev_notifier_info *info = &fdb_info->info;
+	struct net_device *lower_dev;
+	struct list_head *iter;
+	int err = -EOPNOTSUPP;
+
+	if (check_cb(dev)) {
+		/* Handle FDB entries on foreign interfaces as FDB entries
+		 * towards the software bridge.
+		 */
+		if (foreign_dev_check_cb && foreign_dev_check_cb(dev, orig_dev)) {
+			struct net_device *br = netdev_master_upper_dev_get_rcu(dev);
+
+			if (!br || !netif_is_bridge_master(br))
+				return 0;
+
+			/* No point in handling FDB entries on a foreign bridge */
+			if (foreign_dev_check_cb(dev, br))
+				return 0;
+
+			return __switchdev_handle_fdb_del_to_device(br, orig_dev,
+								    fdb_info, check_cb,
+								    foreign_dev_check_cb,
+								    del_cb, lag_del_cb);
+		}
+
+		return del_cb(dev, orig_dev, info->ctx, fdb_info);
+	}
+
+	/* If we passed over the foreign check, it means that the LAG interface
+	 * is offloaded.
+	 */
+	if (netif_is_lag_master(dev)) {
+		if (!lag_del_cb)
+			return -EOPNOTSUPP;
+
+		return lag_del_cb(dev, orig_dev, info->ctx, fdb_info);
+	}
+
+	/* Recurse through lower interfaces in case the FDB entry is pointing
+	 * towards a bridge device.
+	 */
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		/* Do not propagate FDB entries across bridges */
+		if (netif_is_bridge_master(lower_dev))
+			continue;
+
+		err = switchdev_handle_fdb_del_to_device(lower_dev, fdb_info,
+							 check_cb,
+							 foreign_dev_check_cb,
+							 del_cb, lag_del_cb);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	return err;
+}
+
+int switchdev_handle_fdb_del_to_device(struct net_device *dev,
+		const struct switchdev_notifier_fdb_info *fdb_info,
+		bool (*check_cb)(const struct net_device *dev),
+		bool (*foreign_dev_check_cb)(const struct net_device *dev,
+					     const struct net_device *foreign_dev),
+		int (*del_cb)(struct net_device *dev,
+			      const struct net_device *orig_dev, const void *ctx,
+			      const struct switchdev_notifier_fdb_info *fdb_info),
+		int (*lag_del_cb)(struct net_device *dev,
+				  const struct net_device *orig_dev, const void *ctx,
+				  const struct switchdev_notifier_fdb_info *fdb_info))
+{
+	int err;
+
+	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
+						   check_cb,
+						   foreign_dev_check_cb,
+						   del_cb, lag_del_cb);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(switchdev_handle_fdb_del_to_device);
+
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-- 
2.25.1

