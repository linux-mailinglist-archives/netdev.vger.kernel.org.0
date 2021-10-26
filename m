Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD9943B726
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhJZQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:40 -0400
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:18188
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236377AbhJZQ3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxLzfYkhwZHuuMjAb2Jm0kwme/g1lz7iinUCEsy8OXzjemYKLoRRBnU03zCmI4Yb2JQIV5CL40eWziKUJp57pF7GroefkqK4++fG0PaG+1o9tJGopwiGsjYRjIUXkSHd1RkUfvJRg7WKXOPEiGn0UNTMyXa/s2xY0PsJTWEF2N8cou3VOEl/xHLubmnCfKWTumxEIr7tB0LdXaxbNLux9UfeHimKpwMEqhT38K8+RaZJlStouCiY85HbHstpz7ddhORXYNbr9RzR/sleW8s5fFSsxHgDOq8UE7svZCZVbi2W/V4mHlyEmA8BBal6Zbyfo8B6VtV9XZP6jbErXUmHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9itPpzKPjtsqd15DiQDWTml/QfZQ9V1TYKz136i3oM=;
 b=A8mV9gx9teO2cE6o/lBwwFnqenIbdxgNGRsWPmRttutT7Alyj/WTFJiZiqH5yHnf7ZDZRnzLSjoswzX/SlN7mvMucojUurSzMYOcMQW/3fWGRCrC4AKcCupZLP7ITg9EeVhReU++B6tW1eb5/Y75Ii1253odsIrfXd1C/Vvv3BLZQiPoiQH2Qu+8CPRn8i9Dai03OQKEizyvy+QPKUiUYMdVWSacXYJUpqul+yFALMmVldfZ0RuabP5HZ5mFaSwaXV3aDRgtMgBe1QXU0hJOB3MZX3g3YDANTk+j8v799ceNb3v4rH5siAdZTCLAIJpJC5XnoCAatRbd0rC60AQdvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9itPpzKPjtsqd15DiQDWTml/QfZQ9V1TYKz136i3oM=;
 b=kCkJ6Tc4PuUZASd0h94Bb6YVTlEFhRRLkBFYKsBFXPGDQdw9bSJ0NqoQNxgFP6sC8x/yqdCxOw+mg9w6ffk134rhZBdNb0EweibXHlpISLlSsuvSvrddW0Vtc+fmRF8GPYonr/ciPkMFOl+ERsn3le/pfPvwDg+KHhjvlKEUxaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 5/6] net: dsa: keep the bridge_dev and bridge_num as part of the same structure
Date:   Tue, 26 Oct 2021 19:26:24 +0300
Message-Id: <20211026162625.1385035-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48d21806-d6a6-4b0b-76d5-08d9989d6bda
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46864791A0614BE0E74047BBE0849@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAB3YWiB9MbExvF6I+hftJv7i2jWEvObO6Z1euyFaU9mvhoFny1wKUdErjN5ClPCUa2LwepSwTprq5x/qznx+Dx3UPNsIofhpkHyEkDvMc7cKOHOrEXYBEX4pntRyBSrXzZnmECCiQ8s/1lcKcZTxPHZQTvKZmLmXwoEVdqBt9EqX2KOPtwKj0CRDN9JY3x9VkijoBPrVHd6uoKW3FnlCJJfVce/pg8pozrx8DBKmrxOGsKZF8ctwZSfQuLYVFCSqzIxYuiz7jt0wUV2RV4j7CHl4XFgZgKooHC9GsvyP2tOgNiriMYTr3ASJkq7wJx4g00MYIwEvwgvQ4asAryLlAk9FV14rpNoG2OuJnEJAKTJHc4qusxY/fsw7s1Qwyf8GIfJgllSNgJES5Pfix5ckFcDWUs1UpxYBDiu8L6DcbMwn9yDrEwSX6UpOCvd9dgon5VbrkooHk74tFPQY+Rg37Oz2tsefCup4Y37790U908+29601UeacauVqgs2BPqNWqlUtXVEZU3F4NfoSx94Lv8+gfILuZFeKiOOB6eu92zxh7Z2JPqH6uVfwWMdTd8UW0fE0tzlMaijyQrtXhAKVynGpVDQTd27SkLKeZBUbNlzXySIU6tCJhoLCOUAw5e1GSiCAo+TVolTNuDgWKZm+iIYj2NEbux7s+9HNviZaB7vwDPMRvvIsHubkrxS2kN4gBRisFBON1O5cAo0JxRvmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6916009)(956004)(8676002)(66556008)(6506007)(1076003)(2616005)(508600001)(186003)(6512007)(30864003)(38100700002)(26005)(5660300002)(6666004)(66946007)(86362001)(44832011)(6486002)(54906003)(52116002)(38350700002)(2906002)(66476007)(83380400001)(316002)(4326008)(36756003)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?If80z9qNGN7QsSsDEorsmxYSqwP2tznVAu3YvYZv7Gw9xPkBbj9o/HUwxhI+?=
 =?us-ascii?Q?AnDUs6sO1BnOd8OJCqlRiTPOSxcPAOVmcy6DAEaGEWog6J/qGdycx1NQAoNv?=
 =?us-ascii?Q?DICNhalp9e03w6ADSyF7q7xBD95SzzkHAuW/1kwa0Ru+TKTRfwD1PVnHAhnx?=
 =?us-ascii?Q?qzPvxgJhpZT/+kyeN4REJ8/bRMWPy7a65AdFl1mcPNF4SUnFhLqmBH8SwI8p?=
 =?us-ascii?Q?7zusvqSFNPE5PggqHGPqskz6Wu9/aLfARf/YGKJ2tnRz5zlZaSTbr2oej/lo?=
 =?us-ascii?Q?/OlSD6HBsibbTIEWLKAnAeMLMCwYIb56/kvS2D4UdbeYSeWUvKdJAsHlgZKU?=
 =?us-ascii?Q?0fGhm2CP4ItsfNQ1NB5B/fF/xM9e3QLLto0MnkPDUpCgW9CMjt4k5kUzohZP?=
 =?us-ascii?Q?35Vurw2KJaiYcPD46W0PVuAjrEFJig5zsNvDcDJ1sjPU4y/ajzCsTYf2ix2H?=
 =?us-ascii?Q?WfIvi6MUBk860wWnbjati26lPXEi062R4O20sRa1C2sqBtlRkgM1zwdnAzmb?=
 =?us-ascii?Q?cRqLSqoRQE1oviavOnFw4Pwvg1EKKy4mkzIRfrDWm8ukeWYqCdICR5e4xWEU?=
 =?us-ascii?Q?adAT4pCITrKicrJXqpHrY0TPOyQBnExfhgul/XdC0ir+DndRA9ECPPBu8ozQ?=
 =?us-ascii?Q?TXBDJmhC+mMqASSCdA88ppxtfD/k47cOURleENmN6L/0X3YpA4coeJbIQ0wg?=
 =?us-ascii?Q?iBJ9EO8nHtm9LIbFyb/YszF3/uwBu0esQJERjHMg0a3rVwR8bafzMQM9lfXt?=
 =?us-ascii?Q?yGnWbWwaHKwgkpxWnx9jSBJUzU74PPTSScrA3BN1vbqW0Q8nniBGeFsVF0EZ?=
 =?us-ascii?Q?8jTlrtCMmUg0lxpJiMgEO65GaQjt0o0hWNbl8JsgAaR4CWfgo0m9E86RvPG2?=
 =?us-ascii?Q?PuhoL8AWeb7VdHzWUtZwApcqN83lPVzonMTWcwbp1uM6vViy4VKZ1rhjbAth?=
 =?us-ascii?Q?5m8itG2KSFIrr1qpYCmPG2Vp2S3SE8L/u+rSIVJGSQTZjZenQByUjF1rycYe?=
 =?us-ascii?Q?VnQoRADCx4HL2hL1rFlYeistpvZtJjHpAa93AsddD8e9TwxPyoxBfmfXfolR?=
 =?us-ascii?Q?TiVcfcN4ZWuOb82LftjrobacDf7v7O9iUaCMfHvZ1YFjSEw+1l7PLG8BN1Z6?=
 =?us-ascii?Q?S6OlZMWySTaSvPt0iODm/Kjrv1kl7/N6Uz+V0hBOfqmSlzjO8B4HK2u5cTdV?=
 =?us-ascii?Q?0koZSh3DQPzwvSVNiv4XEnKrw+EvoecJmIEOCkBMhUwOkuRUg+13ZBnRPlE4?=
 =?us-ascii?Q?UJq5DO+N24/kAGvj8knFlfZDfXwxIsmBn5eiQjOIuNrZdaJ0r6/Lcp0k5EJR?=
 =?us-ascii?Q?VyK3h7NhqeYP4W4K4orqmFZgHKGU5CVuuPO1UjbEAsefk2ID93ppw0TixF92?=
 =?us-ascii?Q?TaqeWqUmrubLkS7ee389DGAIan7e+Q6t7vymIy8U1xqxAIJa5kvOd22VrH5v?=
 =?us-ascii?Q?pUUzjvjpVe0hrJK8qyUPUVGQfl6AufZ1pnHP+ZBdwKUgzrAbkpH/m76u42kk?=
 =?us-ascii?Q?BhAkfIu2cRQpJiISKNEya+oRpBMw/fVjfcM9XKNJjc+HPdoPMNOcuzz/ySNC?=
 =?us-ascii?Q?kEJLrjXm/vNeSrNSCWsCvzZmpsYJNR/H2ZvbLFack3JwC1tqyKUZYoECpFLe?=
 =?us-ascii?Q?16Yu3RgceGu3URWRX+m/Zhg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d21806-d6a6-4b0b-76d5-08d9989d6bda
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:53.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYUM53QGx4mN96CuKaeJsejtv+582yYW79+aFPsYrrpDkpSzBqYQzNZCaLgKQubrhchrk1A8rlnOklss0W0XUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main desire behind this is to provide coherent bridge information to
the fast path without locking.

For example, right now we set dp->bridge_dev and dp->bridge_num from
separate code paths, it is theoretically possible for a packet
transmission to read these two port properties consecutively and find a
bridge number which does not correspond with the bridge device.

Another desire is to start passing more complex bridge information to
dsa_switch_ops functions. For example, with FDB isolation, it is
expected that drivers will need to be passed the bridge which requested
an FDB/MDB entry to be offloaded, and along with that bridge_dev, the
associated bridge_num should be passed too, in case the driver might
want to implement an isolation scheme based on that number.

We already pass the {bridge_dev, bridge_num} pair to the TX forwarding
offload switch API, however we'd like to remove that and squash it into
the basic bridge join/leave API. So that means we need to pass this
pair to the bridge join/leave API.

During dsa_port_bridge_leave, first we unset dp->bridge_dev, then we
call the driver's .port_bridge_leave with what used to be our
dp->bridge_dev, but provided as an argument.

When bridge_dev and bridge_num get folded into a single structure, we
need to preserve this behavior in dsa_port_bridge_leave: we need a copy
of what used to be in dp->bridge.

Switch drivers check bridge membership by comparing dp->bridge_dev with
the provided bridge_dev, but now, if we provide the struct dsa_bridge as
a pointer, they cannot keep comparing dp->bridge to the provided
pointer, since this only points to an on-stack copy. To make this
obvious and prevent driver writers from forgetting and doing stupid
things, in this new API, the struct dsa_bridge is provided as a full
structure (not very large, contains an int and a pointer) instead of a
pointer. An explicit comparison function needs to be used to determine
bridge membership: dsa_port_offloads_bridge().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  8 +--
 drivers/net/dsa/b53/b53_priv.h         |  4 +-
 drivers/net/dsa/dsa_loop.c             |  8 +--
 drivers/net/dsa/hirschmann/hellcreek.c |  4 +-
 drivers/net/dsa/lan9303-core.c         |  4 +-
 drivers/net/dsa/lantiq_gswip.c         | 14 +++--
 drivers/net/dsa/microchip/ksz_common.c |  4 +-
 drivers/net/dsa/microchip/ksz_common.h |  4 +-
 drivers/net/dsa/mt7530.c               |  8 +--
 drivers/net/dsa/mv88e6xxx/chip.c       | 26 ++++-----
 drivers/net/dsa/ocelot/felix.c         |  8 +--
 drivers/net/dsa/qca8k.c                | 12 ++--
 drivers/net/dsa/rtl8366rb.c            |  8 +--
 drivers/net/dsa/sja1105/sja1105_main.c | 12 ++--
 drivers/net/dsa/xrs700x/xrs700x.c      | 10 ++--
 include/linux/dsa/8021q.h              |  7 +--
 include/net/dsa.h                      | 77 +++++++++++++++++++++-----
 net/dsa/dsa2.c                         | 35 ++++++++----
 net/dsa/dsa_priv.h                     | 53 ++----------------
 net/dsa/port.c                         | 69 ++++++++++++-----------
 net/dsa/slave.c                        |  2 +-
 net/dsa/switch.c                       | 13 +++--
 net/dsa/tag_8021q.c                    | 12 ++--
 23 files changed, 215 insertions(+), 187 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d5e78f51f42d..4e41b1a63108 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1860,7 +1860,7 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
@@ -1887,7 +1887,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), &pvlan);
 
 	b53_for_each_port(dev, i) {
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		/* Add this local port to the remote port VLAN control
@@ -1911,7 +1911,7 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 }
 EXPORT_SYMBOL(b53_br_join);
 
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
+void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan *vl = &dev->vlans[0];
@@ -1923,7 +1923,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 
 	b53_for_each_port(dev, i) {
 		/* Don't touch the remaining ports */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		b53_read16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(i), &reg);
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 579da74ada64..ee17f8b516ca 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,8 +324,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge);
-void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
+void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
 int b53_br_flags_pre(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index e638e3eea911..70db3a9aa355 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,19 +167,19 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct net_device *bridge)
+				     struct dsa_bridge bridge)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
-		__func__, port, bridge->name);
+		__func__, port, bridge.dev->name);
 
 	return 0;
 }
 
 static void dsa_loop_port_bridge_leave(struct dsa_switch *ds, int port,
-				       struct net_device *bridge)
+				       struct dsa_bridge bridge)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
-		__func__, port, bridge->name);
+		__func__, port, bridge.dev->name);
 }
 
 static void dsa_loop_port_stp_state_set(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4e0b53d94b52..17c2d13670a9 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,7 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
@@ -691,7 +691,7 @@ static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void hellcreek_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct dsa_bridge bridge)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 1c2bdcde6979..29d909484275 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct net_device *br)
+				    struct dsa_bridge bridge)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1117,7 +1117,7 @@ static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void lan9303_port_bridge_leave(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index c60b1eef3545..6b9b9c712e58 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,16 +1146,17 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct net_device *bridge)
+				  struct dsa_bridge bridge)
 {
+	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
 	/* When the bridge uses VLAN filtering we have to configure VLAN
 	 * specific bridges. No bridge is configured here.
 	 */
-	if (!br_vlan_enabled(bridge)) {
-		err = gswip_vlan_add_unaware(priv, bridge, port);
+	if (!br_vlan_enabled(br)) {
+		err = gswip_vlan_add_unaware(priv, br, port);
 		if (err)
 			return err;
 		priv->port_vlan_filter &= ~BIT(port);
@@ -1166,8 +1167,9 @@ static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
-				    struct net_device *bridge)
+				    struct dsa_bridge bridge)
 {
+	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
 
 	gswip_add_single_port_br(priv, port, true);
@@ -1175,8 +1177,8 @@ static void gswip_port_bridge_leave(struct dsa_switch *ds, int port,
 	/* When the bridge uses VLAN filtering we have to configure VLAN
 	 * specific bridges. No bridge is configured here.
 	 */
-	if (!br_vlan_enabled(bridge))
-		gswip_vlan_remove(priv, bridge, port, 0, true, false);
+	if (!br_vlan_enabled(br))
+		gswip_vlan_remove(priv, br, port, 0, true, false);
 }
 
 static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7c2968a639eb..23784d14a5da 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -173,7 +173,7 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br)
+			 struct dsa_bridge bridge)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -190,7 +190,7 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
 
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br)
+			   struct dsa_bridge bridge)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 1597c63988b4..df953c2bc56e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,9 +159,9 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br);
+			 struct dsa_bridge bridge);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct net_device *br);
+			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 79bde263b06f..85cc5aca7f96 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct net_device *bridge)
+			struct dsa_bridge bridge)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
@@ -1202,7 +1202,7 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 		 * and not being setup until the port becomes enabled.
 		 */
 		if (dsa_port_is_user(other_dp) && i != port) {
-			if (dsa_port_bridge_dev_get(other_dp) != bridge)
+			if (!dsa_port_offloads_bridge(other_dp, &bridge))
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_set(priv, MT7530_PCR_P(i),
@@ -1301,7 +1301,7 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 
 static void
 mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
-			 struct net_device *bridge)
+			 struct dsa_bridge bridge)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int i;
@@ -1316,7 +1316,7 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		 * is kept and not being setup until the port becomes enabled.
 		 */
 		if (dsa_port_is_user(other_dp) && i != port) {
-			if (dsa_port_bridge_dev_get(other_dp) != bridge)
+			if (!dsa_port_offloads_bridge(other_dp, &bridge))
 				continue;
 			if (priv->ports[i].enable)
 				mt7530_clear(priv, MT7530_PCR_P(i),
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b76ce4423ea8..73613a667f6c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2417,7 +2417,7 @@ static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
-				struct net_device *br)
+				struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
@@ -2425,7 +2425,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	int err;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_bridge_dev_get(dp) == br) {
+		if (dsa_port_offloads_bridge(dp, &bridge)) {
 			if (dp->ds == ds) {
 				/* This is a local bridge group member,
 				 * remap its Port VLAN Map.
@@ -2449,14 +2449,14 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct net_device *br)
+				      struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_bridge_map(chip, br);
+	err = mv88e6xxx_bridge_map(chip, bridge);
 	if (err)
 		goto unlock;
 
@@ -2471,14 +2471,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 }
 
 static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
-					struct net_device *br)
+					struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mv88e6xxx_bridge_map(chip, br) ||
+	if (mv88e6xxx_bridge_map(chip, bridge) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
 
@@ -2493,7 +2493,7 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
-					   int port, struct net_device *br)
+					   int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2510,7 +2510,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 					     int tree_index, int sw_index,
-					     int port, struct net_device *br)
+					     int port, struct dsa_bridge bridge)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
@@ -2542,19 +2542,17 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
 }
 
 static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
-	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 }
 
 static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					      struct net_device *br,
-					      unsigned int bridge_num)
+					      struct dsa_bridge bridge)
 {
 	int err;
 
-	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
+	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 	if (err) {
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
 			ERR_PTR(err));
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 83808e7dbdda..8cf82fa91a6b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -698,21 +698,21 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct net_device *br)
+			     struct dsa_bridge bridge)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_join(ocelot, port, br);
+	ocelot_port_bridge_join(ocelot, port, bridge.dev);
 
 	return 0;
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct dsa_bridge bridge)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_leave(ocelot, port, br);
+	ocelot_port_bridge_leave(ocelot, port, bridge.dev);
 }
 
 static int felix_lag_join(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index efe20db287a5..3ae10f22ada9 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1728,8 +1728,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
 }
 
-static int
-qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
+static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+				  struct dsa_bridge bridge)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
@@ -1741,7 +1741,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
@@ -1762,8 +1762,8 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	return ret;
 }
 
-static void
-qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
+static void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+				    struct dsa_bridge bridge)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int cpu_port, i;
@@ -1773,7 +1773,7 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_is_cpu_port(ds, i))
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Remove this port to the portvlan mask of the other ports
 		 * in the bridge
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b6f277a04989..fac2333a3f5e 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1186,7 +1186,7 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
-			   struct net_device *bridge)
+			   struct dsa_bridge bridge)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
@@ -1198,7 +1198,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Join this port to each other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
@@ -1218,7 +1218,7 @@ rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 
 static void
 rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
-			    struct net_device *bridge)
+			    struct dsa_bridge bridge)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
@@ -1230,7 +1230,7 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
 		if (i == port)
 			continue;
 		/* Not on this bridge */
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		/* Remove this port from any other port on the bridge */
 		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5e03eda4c16f..24584fe2e760 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1980,7 +1980,7 @@ static int sja1105_manage_flood_domains(struct sja1105_private *priv)
 }
 
 static int sja1105_bridge_member(struct dsa_switch *ds, int port,
-				 struct net_device *br, bool member)
+				 struct dsa_bridge bridge, bool member)
 {
 	struct sja1105_l2_forwarding_entry *l2_fwd;
 	struct sja1105_private *priv = ds->priv;
@@ -2005,7 +2005,7 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 		 */
 		if (i == port)
 			continue;
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != br)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 		sja1105_port_allow_traffic(l2_fwd, i, port, member);
 		sja1105_port_allow_traffic(l2_fwd, port, i, member);
@@ -2074,15 +2074,15 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *br)
+			       struct dsa_bridge bridge)
 {
-	return sja1105_bridge_member(ds, port, br, true);
+	return sja1105_bridge_member(ds, port, bridge, true);
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *br)
+				 struct dsa_bridge bridge)
 {
-	sja1105_bridge_member(ds, port, br, false);
+	sja1105_bridge_member(ds, port, bridge, false);
 }
 
 #define BYTES_PER_KBIT (1000LL / 8)
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 7c2b6c32242d..ebb55dfd9c4e 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -501,7 +501,7 @@ static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
-				 struct net_device *bridge, bool join)
+				 struct dsa_bridge bridge, bool join)
 {
 	unsigned int i, cpu_mask = 0, mask = 0;
 	struct xrs700x *priv = ds->priv;
@@ -513,14 +513,14 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 
 		cpu_mask |= BIT(i);
 
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) == bridge)
+		if (dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		mask |= BIT(i);
 	}
 
 	for (i = 0; i < ds->num_ports; i++) {
-		if (dsa_port_bridge_dev_get(dsa_to_port(ds, i)) != bridge)
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
 			continue;
 
 		/* 1 = Disable forwarding to the port */
@@ -540,13 +540,13 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *bridge)
+			       struct dsa_bridge bridge)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
 
 static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
-				 struct net_device *bridge)
+				 struct dsa_bridge bridge)
 {
 	xrs700x_bridge_common(ds, port, bridge, false);
 }
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0af4371fbebb..939a1beaddf7 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -7,6 +7,7 @@
 
 #include <linux/refcount.h>
 #include <linux/types.h>
+#include <net/dsa.h>
 
 struct dsa_switch;
 struct dsa_port;
@@ -37,12 +38,10 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					unsigned int bridge_num);
+					struct dsa_bridge bridge);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num);
+					   struct dsa_bridge bridge);
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 81fd1821a0aa..5e83c64bc96a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -219,6 +219,11 @@ struct dsa_mall_tc_entry {
 	};
 };
 
+struct dsa_bridge {
+	struct net_device *dev;
+	unsigned int num;
+	refcount_t refcount;
+};
 
 struct dsa_port {
 	/* A CPU port is physically connected to a master device.
@@ -256,8 +261,7 @@ struct dsa_port {
 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
 	bool			learning;
 	u8			stp_state;
-	struct net_device	*bridge_dev;
-	unsigned int		bridge_num;
+	struct dsa_bridge	*bridge;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -588,7 +592,7 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		return NULL;
 
 	if (dp->lag_dev)
@@ -601,12 +605,12 @@ struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 
 static inline struct net_device *dsa_port_bridge_dev_get(struct dsa_port *dp)
 {
-	return dp->bridge_dev;
+	return dp->bridge ? dp->bridge->dev : NULL;
 }
 
 static inline unsigned int dsa_port_bridge_num_get(struct dsa_port *dp)
 {
-	return dp->bridge_num;
+	return dp->bridge ? dp->bridge->num : 0;
 }
 
 static inline bool dsa_port_bridge_same(struct dsa_port *a, struct dsa_port *b)
@@ -614,6 +618,55 @@ static inline bool dsa_port_bridge_same(struct dsa_port *a, struct dsa_port *b)
 	return dsa_port_bridge_dev_get(a) == dsa_port_bridge_dev_get(b);
 }
 
+static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
+						 const struct net_device *dev)
+{
+	return dsa_port_to_bridge_port(dp) == dev;
+}
+
+static inline bool
+dsa_port_offloads_bridge_dev(struct dsa_port *dp,
+			     const struct net_device *bridge_dev)
+{
+	/* DSA ports connected to a bridge, and event was emitted
+	 * for the bridge.
+	 */
+	return dsa_port_bridge_dev_get(dp) == bridge_dev;
+}
+
+static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
+					    const struct dsa_bridge *bridge)
+{
+	return dsa_port_bridge_dev_get(dp) == bridge->dev;
+}
+
+/* Returns true if any port of this tree offloads the given net_device */
+static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
+						 const struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_port(dp, dev))
+			return true;
+
+	return false;
+}
+
+/* Returns true if any port of this tree offloads the given bridge */
+static inline bool
+dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
+			     const struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
+			return true;
+
+	return false;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
@@ -761,17 +814,15 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct net_device *bridge);
+				    struct dsa_bridge bridge);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
-				     struct net_device *bridge);
+				     struct dsa_bridge bridge);
 	/* Called right after .port_bridge_join() */
 	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
-					      struct net_device *bridge,
-					      unsigned int bridge_num);
+					      struct dsa_bridge bridge);
 	/* Called right before .port_bridge_leave() */
 	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
-						struct net_device *bridge,
-						unsigned int bridge_num);
+						struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
@@ -843,10 +894,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
 					 int sw_index, int port,
-					 struct net_device *br);
+					 struct dsa_bridge bridge);
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
-					  struct net_device *br);
+					  struct dsa_bridge bridge);
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9606e56710a5..7c014aeea559 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -129,20 +129,29 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
 	}
 }
 
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_bridge_dev_get(dp) == br)
+			return dp->bridge;
+
+	return NULL;
+}
+
 static int dsa_bridge_num_find(const struct net_device *bridge_dev)
 {
 	struct dsa_switch_tree *dst;
-	struct dsa_port *dp;
 
-	/* When preparing the offload for a port, it will have a valid
-	 * dp->bridge_dev pointer but a not yet valid dp->bridge_num.
-	 * However there might be other ports having the same dp->bridge_dev
-	 * and a valid dp->bridge_num, so just ignore this port.
-	 */
-	list_for_each_entry(dst, &dsa_tree_list, list)
-		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->bridge_dev == bridge_dev && dp->bridge_num)
-				return dp->bridge_num;
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		struct dsa_bridge *bridge;
+
+		bridge = dsa_tree_bridge_find(dst, bridge_dev);
+		if (bridge)
+			return bridge->num;
+	}
 
 	return 0;
 }
@@ -151,6 +160,12 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 {
 	unsigned int bridge_num = dsa_bridge_num_find(bridge_dev);
 
+	/* Switches without FDB isolation support don't get unique
+	 * bridge numbering
+	 */
+	if (!max)
+		return 0;
+
 	if (!bridge_num) {
 		/* First port that offloads TX forwarding for this bridge */
 		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index daba10adbd22..489712ead08f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -52,7 +52,7 @@ struct dsa_notifier_ageing_time_info {
 
 /* DSA_NOTIFIER_BRIDGE_* */
 struct dsa_notifier_bridge_info {
-	struct net_device *br;
+	struct dsa_bridge bridge;
 	int tree_index;
 	int sw_index;
 	int port;
@@ -266,49 +266,6 @@ int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
-static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
-						 const struct net_device *dev)
-{
-	return dsa_port_to_bridge_port(dp) == dev;
-}
-
-static inline bool
-dsa_port_offloads_bridge_dev(struct dsa_port *dp,
-			     const struct net_device *bridge_dev)
-{
-	/* DSA ports connected to a bridge, and event was emitted
-	 * for the bridge.
-	 */
-	return dsa_port_bridge_dev_get(dp) == bridge_dev;
-}
-
-/* Returns true if any port of this tree offloads the given net_device */
-static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
-						 const struct net_device *dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_port(dp, dev))
-			return true;
-
-	return false;
-}
-
-/* Returns true if any port of this tree offloads the given bridge */
-static inline bool
-dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
-			     const struct net_device *bridge_dev)
-{
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_offloads_bridge_dev(dp, bridge_dev))
-			return true;
-
-	return false;
-}
-
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 extern struct notifier_block dsa_slave_switchdev_notifier;
@@ -417,7 +374,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 		if (dp->type != DSA_PORT_TYPE_USER)
 			continue;
 
-		if (!dp->bridge_dev)
+		if (!dp->bridge)
 			continue;
 
 		if (dp->stp_state != BR_STATE_LEARNING &&
@@ -446,7 +403,7 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 /* If the ingress port offloads the bridge, we mark the frame as autonomously
  * forwarded by hardware, so the software bridge doesn't forward in twice, back
  * to us, because we already did. However, if we're in fallback mode and we do
- * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * software bridging, we are not offloading it, therefore the dp->bridge
  * pointer is not populated, and flooding needs to be done by software (we are
  * effectively operating in standalone ports mode).
  */
@@ -454,7 +411,7 @@ static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
 {
 	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
 
-	skb->offload_fwd_mark = !!(dp->bridge_dev);
+	skb->offload_fwd_mark = !!(dp->bridge);
 }
 
 /* Helper for removing DSA header tags from packets in the RX path.
@@ -551,6 +508,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index aaa978ee165e..b2e66994f72c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -130,7 +130,7 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 			return err;
 	}
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		dsa_port_set_state_now(dp, BR_STATE_FORWARDING, false);
 
 	if (dp->pl)
@@ -158,7 +158,7 @@ void dsa_port_disable_rt(struct dsa_port *dp)
 	if (dp->pl)
 		phylink_stop(dp->pl);
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		dsa_port_set_state_now(dp, BR_STATE_DISABLED, false);
 
 	if (ds->ops->port_disable)
@@ -271,36 +271,32 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 }
 
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct net_device *bridge_dev,
-					     unsigned int bridge_num)
+					     struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge.num)
 		return;
 
 	/* Notify the chips only once the offload has been deactivated, so
 	 * that they can update their configuration accordingly.
 	 */
-	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge_dev,
-					      bridge_num);
+	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge);
 }
 
 static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct net_device *bridge_dev,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
 	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	/* FDB isolation is required for TX forwarding offload */
-	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge_num)
+	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge.num)
 		return false;
 
 	/* Notify the driver */
-	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge_dev,
-						  bridge_num);
+	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge);
 
 	return err ? false : true;
 }
@@ -310,21 +306,31 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 				  struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
-	unsigned int bridge_num;
+	struct dsa_bridge *bridge;
 
-	dp->bridge_dev = br;
-
-	if (!ds->max_num_bridges)
+	bridge = dsa_tree_bridge_find(ds->dst, br);
+	if (bridge) {
+		refcount_inc(&bridge->refcount);
+		dp->bridge = bridge;
 		return 0;
+	}
+
+	bridge = kzalloc(sizeof(*bridge), GFP_KERNEL);
+	if (!bridge)
+		return -ENOMEM;
+
+	refcount_set(&bridge->refcount, 1);
+
+	bridge->dev = br;
 
-	bridge_num = dsa_bridge_num_get(br, ds->max_num_bridges);
-	if (!bridge_num) {
+	bridge->num = dsa_bridge_num_get(br, ds->max_num_bridges);
+	if (ds->max_num_bridges && !bridge->num) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Range of offloadable bridges exceeded");
 		return -EOPNOTSUPP;
 	}
 
-	dp->bridge_num = bridge_num;
+	dp->bridge = bridge;
 
 	return 0;
 }
@@ -332,16 +338,17 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 static void dsa_port_bridge_destroy(struct dsa_port *dp,
 				    const struct net_device *br)
 {
-	struct dsa_switch *ds = dp->ds;
+	struct dsa_bridge *bridge = dp->bridge;
+
+	dp->bridge = NULL;
 
-	dp->bridge_dev = NULL;
+	if (!refcount_dec_and_test(&bridge->refcount))
+		return;
 
-	if (ds->max_num_bridges) {
-		int bridge_num = dp->bridge_num;
+	if (bridge->num)
+		dsa_bridge_num_put(br, bridge->num);
 
-		dp->bridge_num = 0;
-		dsa_bridge_num_put(br, bridge_num);
-	}
+	kfree(bridge);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -351,7 +358,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.br = br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
@@ -367,12 +373,12 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 
 	brport_dev = dsa_port_to_bridge_port(dp);
 
+	info.bridge = *dp->bridge;
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, br,
-							dsa_port_bridge_num_get(dp));
+	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, info.bridge);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
@@ -415,12 +421,11 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
-	unsigned int bridge_num = dsa_port_bridge_num_get(dp);
 	struct dsa_notifier_bridge_info info = {
 		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.br = br,
+		.bridge = *dp->bridge,
 	};
 	int err;
 
@@ -429,7 +434,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, br, bridge_num);
+	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 98fd5e972d28..a2918232bad6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1564,7 +1564,7 @@ static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 	if (!dp->ds->mtu_enforcement_ingress)
 		return;
 
-	if (!dp->bridge_dev)
+	if (!dp->bridge)
 		return;
 
 	INIT_LIST_HEAD(&hw_port_list);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 7993192fe769..cd0630dd5417 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->br);
+		err = ds->ops->port_bridge_join(ds, info->port, info->bridge);
 		if (err)
 			return err;
 	}
@@ -104,7 +104,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	    ds->ops->crosschip_bridge_join) {
 		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
 						     info->sw_index,
-						     info->port, info->br);
+						     info->port, info->bridge);
 		if (err)
 			return err;
 	}
@@ -124,19 +124,20 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->br);
+		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
 	    ds->ops->crosschip_bridge_leave)
 		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
 						info->sw_index, info->port,
-						info->br);
+						info->bridge);
 
-	if (ds->needs_standalone_vlan_filtering && !br_vlan_enabled(info->br)) {
+	if (ds->needs_standalone_vlan_filtering &&
+	    !br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
 		vlan_filtering = true;
 	} else if (!ds->needs_standalone_vlan_filtering &&
-		   br_vlan_enabled(info->br)) {
+		   br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
 		vlan_filtering = false;
 	}
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index e9d5e566973c..27712a81c967 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -337,7 +337,7 @@ dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
 		return false;
 
 	if (dsa_port_is_user(dp))
-		return dsa_port_bridge_dev_get(dp) == info->br;
+		return dsa_port_offloads_bridge(dp, &info->bridge);
 
 	return false;
 }
@@ -410,10 +410,9 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 }
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					struct net_device *br,
-					unsigned int bridge_num)
+					struct dsa_bridge bridge)
 {
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	return dsa_port_tag_8021q_vlan_add(dsa_to_port(ds, port), tx_vid,
 					   true);
@@ -421,10 +420,9 @@ int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					   struct net_device *br,
-					   unsigned int bridge_num)
+					   struct dsa_bridge bridge)
 {
-	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
 
 	dsa_port_tag_8021q_vlan_del(dsa_to_port(ds, port), tx_vid, true);
 }
-- 
2.25.1

