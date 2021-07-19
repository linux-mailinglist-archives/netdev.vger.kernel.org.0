Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3938E3CE835
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353015AbhGSQjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:11 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355265AbhGSQgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACVdvv1VDfJfDZIDkA5uPXpVKOxnaFMgI0zEKfEaRDImjPojJjJ1Enupb8ofHn3PmX7eyBwsZpPLid4OsYBphw68BXkkbD7T1oxjiKLbH1HDU6FsPsrGJpq+5fDvU/rRPIDDna21xz+7PTXH/LE/dzQWQ0ZuO/nlLLEjqPW83OGqVk/YoSAuhegzX0IRxzFzi5wdQhOa8uikecPtznJx6gVu5jBmiQ4+aYy7gdAC/zzHFVppVFHJIMaYjOL2v4C9zXmINgQF84qe6cIz8HZawm9fe7R0ogx5+AdgEygaaBB3cFgK+eSGV4YiSd5tg9Eo2MtjbCpbsCDx8Bf6ZaX1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFWAd7URMzP1E1EM5i4l3cFxVBKvqqlzoEPrjJijpRk=;
 b=OR1MHFoNuL30K2w9s/RtfB0kWOKZuzrlfQG4NsXH/gYCFNDFTmLKiOmcW5TrsyGjt6onlp0knqozicVa8EF1VaOSUYHSONFRR/wnekmtVC53GBQr7lm9wsNwfI+py2FWLNVqTqWrrJdnTkR7SmufZ4MIWG8GQfvEt+nmnISOgPKnicEpDI6wAU5jQCIdWtMWryT3C+oYddZt1grht+ThfnFveNDcEp7SjdJIG+w1aSad0P3y3TLVsvF4dcC4neUIY+E1Q4+IBidg1a833AYtCX6+bMiYmz30up7YKZUiXwFZw0TbbBhYC6kBhy6Wg3DXBz2HQN+AkcXu9BcOyyUFsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFWAd7URMzP1E1EM5i4l3cFxVBKvqqlzoEPrjJijpRk=;
 b=BLVY9LGtXBTEBQrtl098zTTnU+sPpZGieqRXJcZcBJ9gFqW4/RsiCxEPAG48+GcdStrA5WtVtXJ4GWeMQ3OAeBDmy2oZ5/UujMRa3xQ27ZzkS+03mVEhCf1mrUCF+8Q45Hp2dRVymoWaAZIRfRjWrWScRjULkwV9N2/P4XYGMYE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 11/11] net: dsa: tag_8021q: add proper cross-chip notifier support
Date:   Mon, 19 Jul 2021 20:14:52 +0300
Message-Id: <20210719171452.463775-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 845a0b97-1745-40df-c9bc-08d94ad8e9ab
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407EB0A6FEB58CAEB388592E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezVr9xIhJmYBhnbcoGf7b3qJ7ePOPZhS+UwFTlJj4JQVu0DtzfWd+TZZTrSEinvel+YFt+CIAAM7YEv/1WkeIZ1QfYbdTnEPCN51nSBk0f2gAQyUWXIZ2/jDeTM7xqdkCS3HfNHMENA6CZa0fAeNiiZXZpv8ADfgqfajsv5S4ci2k6iTHZAc2CguUPBrpuo68kRSmLYkQm3MqjqWtkKakzCnNLscWUlly2zdrkP05rnCyG6BInQ/JDrPE28hPvYz2HNvcoJ3Ikvq5chWQp0zQVvNUoX7MKzvdi5U6Zr7jsSfTBES3GFJctd8JTXo7QCXuZji62+ljsb2Y6FYYvUyByRR//RzU8KZZAhZR39RhVj/KInpTt2b216QPKQylelTOF2c78qIUD7lfnGT9YHQTYXlf/QILaJsP+sdhDZ1+KWGiYDbeWGl+Dd8BTqYuhmiN9dieyM41ANmG/AAW5oam3zM4BIXkMU9aG5Sn3Y4ZrM8swLOLrQwxW2p9SYO+z8KvFMJ6kFwnqsHFmLABsS23H9xl58GAEwaX+pDiAQjSXvMYiQ10qd9JnCC37XDLxl4lZttP0CT9pzX5lEPfV9oK/Y73Fy7cCuFt8ZEEPmvBMlWnJ1wSnjSRJBeE2kIE78y7YLDuBhpG3KjVBAxINPvD9DGKaGU9dxLiFxup1NYz3riKGPXZUzws//HDOaykD/aLsKW5UL+HOYSBwN0IkYEAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(30864003)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4CgsltRRNLj6McME2qMmXK1E0SFHNWLDbHvnazf4RELeDCtiVhooY5om32S?=
 =?us-ascii?Q?zgaSaJJwBH9T5yVCgsavKW3rgV1h6VkLKcUNIBAj7bGOKJHLmmiqbp3sPhDB?=
 =?us-ascii?Q?cGn7RkaNuyj+LniqSjqDzFW6Y0XOUQrMnt06tIVJRfK3Xu2GZwBs1fdTrRFA?=
 =?us-ascii?Q?47/zvt+hpQY6q167pAEyZWI4T9LGICxH3+A1IL8PB76ZvVy5OMFwDFCsCg8d?=
 =?us-ascii?Q?w1tLPt6xBx1L9/FIpg6q8DZ57yg2kIQLK69urErPJTurdG7jVdAmj2v08kIc?=
 =?us-ascii?Q?nfUWnkNRhzdR0fRc2Yz2WWS3b4utNRJ2Ik6VEAhD0d65fr/O+uhOvzSxMkeI?=
 =?us-ascii?Q?qKbbsZ1cSQ4hlrah21FG26cbQpEPQHeNMAJL4QgIYr/JS5zrqLiJIiM9zhzT?=
 =?us-ascii?Q?D3wHk3rqDeN77jhkQWRsKIcTNtH/9BWhB7AnXmEVRJILw2ZIqzHvE1cSQjEu?=
 =?us-ascii?Q?zLPm4F+Y3TnaKRWUBgCv7ODsxE+++Cll81uxZ4fYzGzuETvL0pwSJs5xGmPN?=
 =?us-ascii?Q?iZiMrwq727HfU3Fh2p96EtqrdmY/Bb0mBoE8Yw5zd9h4imkndMXhrtLPrRot?=
 =?us-ascii?Q?waD5GFWZ3HBlIay+pf19l0awhP9EERGdrUHwJJoEK8yhG9EmOuzcaTtCJ77Z?=
 =?us-ascii?Q?BJzn7I1ttjSQV/rmvop6HVtTZ0f3KWMlt9yeiwMV7HuV6dXnszummwC9ADle?=
 =?us-ascii?Q?x0o5bubUKXP/MDWBeUdpYLEb+r8C7PeuJFXBkJhhHxS/g4EdGwz7LjtmLCUj?=
 =?us-ascii?Q?rbJXieZqUuz47nHSRQS7X0eo8EL3PmBDz3/r+i3M/CH4uRwxa4bm/d+Hjnpn?=
 =?us-ascii?Q?xFKO3mm+CfXMWWylORmXLWd6gQXsJ8URpqmLuRqpfkJBJ++QuXbaecdIJQb8?=
 =?us-ascii?Q?cT94n7u7QdqZDgfEDglH8O1APE8PvYr9NGPwSOUXb5yUZ5FSgGzrSYTD3R3k?=
 =?us-ascii?Q?A8TGwnCe3wq5sbqEufueHQpbAGeRr7/eeZWB5EswHGc7N2ADWfM0J8vI1K4d?=
 =?us-ascii?Q?4o00z6HWuXI+w/5kCrG7IGwuQHr6gzKJTzTeejAOC5mtLFdG/cgCCL4IbNwK?=
 =?us-ascii?Q?qk2x70VjET2ILHcJ1h1uyJEXH2SOVH39Zd/d/XZcTZvmuyKcewHmGv+C9/IE?=
 =?us-ascii?Q?RveqzmHciLL28sA5lEGGWGnHNg17UKFyaMZnXQP9sMgYvDYCzrqgK8f+eubm?=
 =?us-ascii?Q?Cg8e3mIOkOdKQQV5Ajni+foIbtLzJymBcIjzNl5+QRqgpgA8QcwuNEHBedhk?=
 =?us-ascii?Q?EAXYtC2sCRk7NbkCrYK+N8ML0dW6/mA0YQLj2klohygLEOqCcU2gROyiHAWB?=
 =?us-ascii?Q?rupP/zaPylrdcaL5FSkXlHiu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845a0b97-1745-40df-c9bc-08d94ad8e9ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:14.5915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajVCvIMRx4PzsRY9ZrRQ47KSHCmaGeyinbPmX976yL1sDVFXH6p+tpVI0oOly6Uf4iRpD0xiLUCxzOwCcHNunQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The big problem which mandates cross-chip notifiers for tag_8021q is
this:

                                             |
    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
 [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
                                   |
                                   +---------+
                                             |
    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
 [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
                                   |
                                   +---------+
                                             |
    sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
 [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]

When the user runs:

ip link add br0 type bridge
ip link set sw0p0 master br0
ip link set sw2p0 master br0

It doesn't work.

This is because dsa_8021q_crosschip_bridge_join() assumes that "ds" and
"other_ds" are at most 1 hop away from each other, so it is sufficient
to add the RX VLAN of {ds, port} into {other_ds, other_port} and vice
versa and presto, the cross-chip link works. When there is another
switch in the middle, such as in this case switch 1 with its DSA links
sw1p3 and sw1p4, somebody needs to tell it about these VLANs too.

Which is exactly why the problem is quadratic: when a port joins a
bridge, for each port in the tree that's already in that same bridge we
notify a tag_8021q VLAN addition of that port's RX VLAN to the entire
tree. It is a very complicated web of VLANs.

It must be mentioned that currently we install tag_8021q VLANs on too
many ports (DSA links - to be precise, on all of them). For example,
when sw2p0 joins br0, and assuming sw1p0 was part of br0 too, we add the
RX VLAN of sw2p0 on the DSA links of switch 0 too, even though there
isn't any port of switch 0 that is a member of br0 (at least yet).
In theory we could notify only the switches which sit in between the
port joining the bridge and the port reacting to that bridge_join event.
But in practice that is impossible, because of the way 'link' properties
are described in the device tree. The DSA bindings require DT writers to
list out not only the real/physical DSA links, but in fact the entire
routing table, like for example switch 0 above will have:

	sw0p3: port@3 {
		link = <&sw1p4 &sw2p4>;
	};

This was done because:

/* TODO: ideally DSA ports would have a single dp->link_dp member,
 * and no dst->rtable nor this struct dsa_link would be needed,
 * but this would require some more complex tree walking,
 * so keep it stupid at the moment and list them all.
 */

but it is a perfect example of a situation where too much information is
actively detrimential, because we are now in the position where we
cannot distinguish a real DSA link from one that is put there to avoid
the 'complex tree walking'. And because DT is ABI, there is not much we
can change.

And because we do not know which DSA links are real and which ones
aren't, we can't really know if DSA switch A is in the data path between
switches B and C, in the general case.

So this is why tag_8021q RX VLANs are added on all DSA links, and
probably why it will never change.

On the other hand, at least the number of additions/deletions is well
balanced, and this means that once we implement reference counting at
the cross-chip notifier level a la fdb/mdb, there is absolutely zero
need for a struct dsa_8021q_crosschip_link, it's all self-managing.

In fact, with the tag_8021q notifiers emitted from the bridge join
notifiers, it becomes so generic that sja1105 does not need to do
anything anymore, we can just delete its implementation of the
.crosschip_bridge_{join,leave} methods.

Among other things we can simply delete is the home-grown implementation
of sja1105_notify_crosschip_switches(). The reason why that is wrong is
because it is not quadratic - it only covers remote switches to which we
have a cross-chip bridging link and that does not cover in-between
switches. This deletion is part of the same patch because sja1105 used
to poke deep inside the guts of the tag_8021q context in order to do
that. Because the cross-chip links went away, so needs the sja1105 code.

Last but not least, dsa_8021q_setup_port() is simplified (and also
renamed). Because our TAG_8021Q_VLAN_ADD notifier is designed to react
on the CPU port too, the four dsa_8021q_vid_apply() calls:
- 1 for RX VLAN on user port
- 1 for the user port's RX VLAN on the CPU port
- 1 for TX VLAN on user port
- 1 for the user port's TX VLAN on the CPU port

now get squashed into only 2 notifier calls via
dsa_port_tag_8021q_vlan_add.

And because the notifiers to add and to delete a tag_8021q VLAN are
distinct, now we finally break up the port setup and teardown into
separate functions instead of relying on a "bool enabled" flag which
tells us what to do. Arguably it should have been this way from the
get go.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 132 +-------
 include/linux/dsa/8021q.h              |  16 +-
 net/dsa/dsa_priv.h                     |  16 +
 net/dsa/port.c                         |  28 ++
 net/dsa/switch.c                       |   6 +
 net/dsa/tag_8021q.c                    | 398 ++++++++++++-------------
 6 files changed, 256 insertions(+), 340 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6b56c1ada3ee..6618abba23b3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1990,61 +1990,6 @@ static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 					   &mac[port], true);
 }
 
-static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
-					 int tree_index, int sw_index,
-					 int other_port, struct net_device *br)
-{
-	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
-	int port, rc;
-
-	if (other_ds->ops != &sja1105_switch_ops)
-		return 0;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_user_port(ds, port))
-			continue;
-		if (dsa_to_port(ds, port)->bridge_dev != br)
-			continue;
-
-		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
-						     other_port);
-		if (rc)
-			return rc;
-
-		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port,
-						     ds, port);
-		if (rc)
-			return rc;
-	}
-
-	return 0;
-}
-
-static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
-					   int tree_index, int sw_index,
-					   int other_port,
-					   struct net_device *br)
-{
-	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
-	int port;
-
-	if (other_ds->ops != &sja1105_switch_ops)
-		return;
-
-	for (port = 0; port < ds->num_ports; port++) {
-		if (!dsa_is_user_port(ds, port))
-			continue;
-		if (dsa_to_port(ds, port)->bridge_dev != br)
-			continue;
-
-		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds,
-						 other_port);
-
-		dsa_8021q_crosschip_bridge_leave(other_ds, other_port,
-						 ds, port);
-	}
-}
-
 static enum dsa_tag_protocol
 sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 			 enum dsa_tag_protocol mp)
@@ -2135,11 +2080,6 @@ static int sja1105_commit_vlans(struct sja1105_private *priv,
 	return 0;
 }
 
-struct sja1105_crosschip_switch {
-	struct list_head list;
-	struct dsa_8021q_context *other_ctx;
-};
-
 static int sja1105_commit_pvid(struct sja1105_private *priv)
 {
 	struct sja1105_bridge_vlan *v;
@@ -2205,59 +2145,7 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 	return 0;
 }
 
-static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify);
-
-static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
-{
-	struct dsa_8021q_context *ctx = priv->ds->tag_8021q_ctx;
-	struct sja1105_crosschip_switch *s, *pos;
-	struct list_head crosschip_switches;
-	struct dsa_8021q_crosschip_link *c;
-	int rc = 0;
-
-	INIT_LIST_HEAD(&crosschip_switches);
-
-	list_for_each_entry(c, &ctx->crosschip_links, list) {
-		bool already_added = false;
-
-		list_for_each_entry(s, &crosschip_switches, list) {
-			if (s->other_ctx == c->other_ctx) {
-				already_added = true;
-				break;
-			}
-		}
-
-		if (already_added)
-			continue;
-
-		s = kzalloc(sizeof(*s), GFP_KERNEL);
-		if (!s) {
-			dev_err(priv->ds->dev, "Failed to allocate memory\n");
-			rc = -ENOMEM;
-			goto out;
-		}
-		s->other_ctx = c->other_ctx;
-		list_add(&s->list, &crosschip_switches);
-	}
-
-	list_for_each_entry(s, &crosschip_switches, list) {
-		struct sja1105_private *other_priv = s->other_ctx->ds->priv;
-
-		rc = sja1105_build_vlan_table(other_priv, false);
-		if (rc)
-			goto out;
-	}
-
-out:
-	list_for_each_entry_safe(s, pos, &crosschip_switches, list) {
-		list_del(&s->list);
-		kfree(s);
-	}
-
-	return rc;
-}
-
-static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
+static int sja1105_build_vlan_table(struct sja1105_private *priv)
 {
 	struct sja1105_vlan_lookup_entry *new_vlan;
 	struct sja1105_table *table;
@@ -2296,12 +2184,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	if (rc)
 		goto out;
 
-	if (notify) {
-		rc = sja1105_notify_crosschip_switches(priv);
-		if (rc)
-			goto out;
-	}
-
 out:
 	kfree(new_vlan);
 
@@ -2389,7 +2271,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	l2_lookup_params = table->entries;
 	l2_lookup_params->shared_learn = !priv->vlan_aware;
 
-	rc = sja1105_build_vlan_table(priv, false);
+	rc = sja1105_build_vlan_table(priv);
 	if (rc)
 		return rc;
 
@@ -2485,7 +2367,7 @@ static int sja1105_vlan_add(struct dsa_switch *ds, int port,
 	if (!vlan_table_changed)
 		return 0;
 
-	return sja1105_build_vlan_table(priv, true);
+	return sja1105_build_vlan_table(priv);
 }
 
 static int sja1105_vlan_del(struct dsa_switch *ds, int port,
@@ -2502,7 +2384,7 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	if (!vlan_table_changed)
 		return 0;
 
-	return sja1105_build_vlan_table(priv, true);
+	return sja1105_build_vlan_table(priv);
 }
 
 static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
@@ -2515,7 +2397,7 @@ static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
 	if (rc <= 0)
 		return rc;
 
-	return sja1105_build_vlan_table(priv, true);
+	return sja1105_build_vlan_table(priv);
 }
 
 static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
@@ -2527,7 +2409,7 @@ static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 	if (!rc)
 		return 0;
 
-	return sja1105_build_vlan_table(priv, true);
+	return sja1105_build_vlan_table(priv);
 }
 
 /* The programming model for the SJA1105 switch is "all-at-once" via static
@@ -3132,8 +3014,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
 	.cls_flower_stats	= sja1105_cls_flower_stats,
-	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
-	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 	.devlink_info_get	= sja1105_devlink_info_get,
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 9cf2c99eb668..ec5abfcdefd1 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -11,19 +11,17 @@
 struct dsa_switch;
 struct sk_buff;
 struct net_device;
-struct dsa_8021q_context;
 
-struct dsa_8021q_crosschip_link {
+struct dsa_tag_8021q_vlan {
 	struct list_head list;
 	int port;
-	struct dsa_8021q_context *other_ctx;
-	int other_port;
+	u16 vid;
 	refcount_t refcount;
 };
 
 struct dsa_8021q_context {
 	struct dsa_switch *ds;
-	struct list_head crosschip_links;
+	struct list_head vlans;
 	/* EtherType of RX VID, used for filtering on master interface */
 	__be16 proto;
 };
@@ -32,14 +30,6 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds);
 
-int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_switch *other_ds,
-				    int other_port);
-
-int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
-				     struct dsa_switch *other_ds,
-				     int other_port);
-
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 28c4d1107b6d..efd6bca78d2f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -39,6 +39,8 @@ enum {
 	DSA_NOTIFIER_MRP_DEL,
 	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
 	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
+	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
+	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -113,6 +115,14 @@ struct dsa_notifier_mrp_ring_role_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_TAG_8021Q_VLAN_* */
+struct dsa_notifier_tag_8021q_vlan_info {
+	int tree_index;
+	int sw_index;
+	int port;
+	u16 vid;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -253,6 +263,8 @@ int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
+int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid);
+void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
@@ -391,6 +403,10 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 			      struct dsa_notifier_bridge_info *info);
 int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 			       struct dsa_notifier_bridge_info *info);
+int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info);
+int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 28b45b7e66df..982e18771d76 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1217,3 +1217,31 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_HSR_LEAVE\n");
 }
+
+int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid)
+{
+	struct dsa_notifier_tag_8021q_vlan_info info = {
+		.tree_index = dp->ds->dst->index,
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vid = vid,
+	};
+
+	return dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
+}
+
+void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
+{
+	struct dsa_notifier_tag_8021q_vlan_info info = {
+		.tree_index = dp->ds->dst->index,
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vid = vid,
+	};
+	int err;
+
+	err = dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
+	if (err)
+		pr_err("DSA: failed to notify tag_8021q VLAN deletion: %pe\n",
+		       ERR_PTR(err));
+}
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 38560de99b80..fd1a1c6bf9cf 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -734,6 +734,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MRP_DEL_RING_ROLE:
 		err = dsa_switch_mrp_del_ring_role(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
+		err = dsa_switch_tag_8021q_vlan_add(ds, info);
+		break;
+	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
+		err = dsa_switch_tag_8021q_vlan_del(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 0946169033a5..51dcde7db26b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -107,21 +107,152 @@ bool vid_is_dsa_8021q(u16 vid)
 }
 EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
 
-/* If @enabled is true, installs @vid with @flags into the switch port's HW
- * filter.
- * If @enabled is false, deletes @vid (ignores @flags) from the port. Had the
- * user explicitly configured this @vid through the bridge core, then the @vid
- * is installed again, but this time with the flags from the bridge layer.
- */
-static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
-			       u16 flags, bool enabled)
+static struct dsa_tag_8021q_vlan *
+dsa_tag_8021q_vlan_find(struct dsa_8021q_context *ctx, int port, u16 vid)
+{
+	struct dsa_tag_8021q_vlan *v;
+
+	list_for_each_entry(v, &ctx->vlans, list)
+		if (v->vid == vid && v->port == port)
+			return v;
+
+	return NULL;
+}
+
+static int dsa_switch_do_tag_8021q_vlan_add(struct dsa_switch *ds, int port,
+					    u16 vid, u16 flags)
 {
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_tag_8021q_vlan *v;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->tag_8021q_vlan_add(ds, port, vid, flags);
+
+	v = dsa_tag_8021q_vlan_find(ctx, port, vid);
+	if (v) {
+		refcount_inc(&v->refcount);
+		return 0;
+	}
+
+	v = kzalloc(sizeof(*v), GFP_KERNEL);
+	if (!v)
+		return -ENOMEM;
+
+	err = ds->ops->tag_8021q_vlan_add(ds, port, vid, flags);
+	if (err) {
+		kfree(v);
+		return err;
+	}
+
+	v->vid = vid;
+	v->port = port;
+	refcount_set(&v->refcount, 1);
+	list_add_tail(&v->list, &ctx->vlans);
+
+	return 0;
+}
+
+static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
+					    u16 vid)
+{
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_tag_8021q_vlan *v;
+	int err;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->tag_8021q_vlan_del(ds, port, vid);
+
+	v = dsa_tag_8021q_vlan_find(ctx, port, vid);
+	if (!v)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&v->refcount))
+		return 0;
+
+	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
+	if (err) {
+		refcount_inc(&v->refcount);
+		return err;
+	}
+
+	list_del(&v->list);
+	kfree(v);
+
+	return 0;
+}
 
-	if (enabled)
-		return ds->ops->tag_8021q_vlan_add(ds, dp->index, vid, flags);
+static bool
+dsa_switch_tag_8021q_vlan_match(struct dsa_switch *ds, int port,
+				struct dsa_notifier_tag_8021q_vlan_info *info)
+{
+	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+		return true;
+
+	if (ds->dst->index == info->tree_index && ds->index == info->sw_index)
+		return port == info->port;
+
+	return false;
+}
+
+int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info)
+{
+	int port, err;
+
+	/* Since we use dsa_broadcast(), there might be other switches in other
+	 * trees which don't support tag_8021q, so don't return an error.
+	 * Or they might even support tag_8021q but have not registered yet to
+	 * use it (maybe they use another tagger currently).
+	 */
+	if (!ds->ops->tag_8021q_vlan_add || !ds->tag_8021q_ctx)
+		return 0;
 
-	return ds->ops->tag_8021q_vlan_del(ds, dp->index, vid);
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
+			u16 flags = 0;
+
+			if (dsa_is_user_port(ds, port))
+				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
+
+			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
+			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
+			    dsa_8021q_rx_source_port(info->vid) == port)
+				flags |= BRIDGE_VLAN_INFO_PVID;
+
+			err = dsa_switch_do_tag_8021q_vlan_add(ds, port,
+							       info->vid,
+							       flags);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info)
+{
+	int port, err;
+
+	if (!ds->ops->tag_8021q_vlan_del || !ds->tag_8021q_ctx)
+		return 0;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
+			err = dsa_switch_do_tag_8021q_vlan_del(ds, port,
+							       info->vid);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
@@ -192,6 +323,7 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 			      struct dsa_notifier_bridge_info *info)
 {
 	struct dsa_switch *targeted_ds;
+	struct dsa_port *targeted_dp;
 	u16 targeted_rx_vid;
 	int err, port;
 
@@ -199,23 +331,23 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 		return 0;
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
+	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
 	for (port = 0; port < ds->num_ports; port++) {
+		struct dsa_port *dp = dsa_to_port(ds, port);
 		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 
 		if (!dsa_tag_8021q_bridge_match(ds, port, info))
 			continue;
 
 		/* Install the RX VID of the targeted port in our VLAN table */
-		err = dsa_8021q_vid_apply(ds, port, targeted_rx_vid,
-					  BRIDGE_VLAN_INFO_UNTAGGED, true);
+		err = dsa_port_tag_8021q_vlan_add(dp, targeted_rx_vid);
 		if (err)
 			return err;
 
 		/* Install our RX VID into the targeted port's VLAN table */
-		err = dsa_8021q_vid_apply(targeted_ds, info->port, rx_vid,
-					  BRIDGE_VLAN_INFO_UNTAGGED, true);
+		err = dsa_port_tag_8021q_vlan_add(targeted_dp, rx_vid);
 		if (err)
 			return err;
 	}
@@ -227,46 +359,39 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 			       struct dsa_notifier_bridge_info *info)
 {
 	struct dsa_switch *targeted_ds;
+	struct dsa_port *targeted_dp;
 	u16 targeted_rx_vid;
-	int err, port;
+	int port;
 
 	if (!ds->tag_8021q_ctx)
 		return 0;
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
+	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
 	for (port = 0; port < ds->num_ports; port++) {
+		struct dsa_port *dp = dsa_to_port(ds, port);
 		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 
 		if (!dsa_tag_8021q_bridge_match(ds, port, info))
 			continue;
 
 		/* Remove the RX VID of the targeted port from our VLAN table */
-		err = dsa_8021q_vid_apply(ds, port, targeted_rx_vid,
-					  BRIDGE_VLAN_INFO_UNTAGGED, false);
-		if (err)
-			dev_err(ds->dev,
-				"port %d failed to delete tag_8021q VLAN: %pe\n",
-				port, ERR_PTR(err));
+		dsa_port_tag_8021q_vlan_del(dp, targeted_rx_vid);
 
 		/* Remove our RX VID from the targeted port's VLAN table */
-		err = dsa_8021q_vid_apply(targeted_ds, info->port, rx_vid,
-					  BRIDGE_VLAN_INFO_UNTAGGED, false);
-		if (err)
-			dev_err(targeted_ds->dev,
-				"port %d failed to delete tag_8021q VLAN: %pe\n",
-				info->port, ERR_PTR(err));
+		dsa_port_tag_8021q_vlan_del(targeted_dp, rx_vid);
 	}
 
 	return 0;
 }
 
 /* Set up a port's tag_8021q RX and TX VLAN for standalone mode operation */
-static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
+static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	int upstream = dsa_upstream_port(ds, port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
 	struct net_device *master;
@@ -275,29 +400,17 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
 	 */
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return 0;
 
-	master = dsa_to_port(ds, port)->cpu_dp->master;
+	master = dp->cpu_dp->master;
 
 	/* Add this user port's RX VID to the membership list of all others
 	 * (including itself). This is so that bridging will not be hindered.
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	err = dsa_8021q_vid_apply(ds, port, rx_vid, BRIDGE_VLAN_INFO_UNTAGGED |
-				  BRIDGE_VLAN_INFO_PVID, enabled);
-	if (err) {
-		dev_err(ds->dev,
-			"Failed to apply RX VID %d to port %d: %pe\n",
-			rx_vid, port, ERR_PTR(err));
-		return err;
-	}
-
-	/* CPU port needs to see this port's RX VID
-	 * as tagged egress.
-	 */
-	err = dsa_8021q_vid_apply(ds, upstream, rx_vid, 0, enabled);
+	err = dsa_port_tag_8021q_vlan_add(dp, rx_vid);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply RX VID %d to port %d: %pe\n",
@@ -306,39 +419,51 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	}
 
 	/* Add @rx_vid to the master's RX filter. */
-	if (enabled)
-		vlan_vid_add(master, ctx->proto, rx_vid);
-	else
-		vlan_vid_del(master, ctx->proto, rx_vid);
+	vlan_vid_add(master, ctx->proto, rx_vid);
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_8021q_vid_apply(ds, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
-				  enabled);
+	err = dsa_port_tag_8021q_vlan_add(dp, tx_vid);
 	if (err) {
 		dev_err(ds->dev,
 			"Failed to apply TX VID %d on port %d: %pe\n",
 			tx_vid, port, ERR_PTR(err));
 		return err;
 	}
-	err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
-	if (err) {
-		dev_err(ds->dev,
-			"Failed to apply TX VID %d on port %d: %pe\n",
-			tx_vid, upstream, ERR_PTR(err));
-		return err;
-	}
 
 	return err;
 }
 
-static int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
+static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
+{
+	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	struct net_device *master;
+
+	/* The CPU port is implicitly configured by
+	 * configuring the front-panel ports
+	 */
+	if (!dsa_port_is_user(dp))
+		return;
+
+	master = dp->cpu_dp->master;
+
+	dsa_port_tag_8021q_vlan_del(dp, rx_vid);
+
+	vlan_vid_del(master, ctx->proto, rx_vid);
+
+	dsa_port_tag_8021q_vlan_del(dp, tx_vid);
+}
+
+static int dsa_tag_8021q_setup(struct dsa_switch *ds)
 {
 	int err, port;
 
 	ASSERT_RTNL();
 
 	for (port = 0; port < ds->num_ports; port++) {
-		err = dsa_8021q_setup_port(ds, port, enabled);
+		err = dsa_tag_8021q_port_setup(ds, port);
 		if (err < 0) {
 			dev_err(ds->dev,
 				"Failed to setup VLAN tagging for port %d: %pe\n",
@@ -350,140 +475,15 @@ static int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 	return 0;
 }
 
-static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
-					  struct dsa_switch *other_ds,
-					  int other_port, bool enabled)
+static void dsa_tag_8021q_teardown(struct dsa_switch *ds)
 {
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	int port;
 
-	/* @rx_vid of local @ds port @port goes to @other_port of
-	 * @other_ds
-	 */
-	return dsa_8021q_vid_apply(other_ds, other_port, rx_vid,
-				   BRIDGE_VLAN_INFO_UNTAGGED, enabled);
-}
-
-static int dsa_8021q_crosschip_link_add(struct dsa_switch *ds, int port,
-					struct dsa_switch *other_ds,
-					int other_port)
-{
-	struct dsa_8021q_context *other_ctx = other_ds->tag_8021q_ctx;
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_8021q_crosschip_link *c;
-
-	list_for_each_entry(c, &ctx->crosschip_links, list) {
-		if (c->port == port && c->other_ctx == other_ctx &&
-		    c->other_port == other_port) {
-			refcount_inc(&c->refcount);
-			return 0;
-		}
-	}
-
-	dev_dbg(ds->dev,
-		"adding crosschip link from port %d to %s port %d\n",
-		port, dev_name(other_ds->dev), other_port);
-
-	c = kzalloc(sizeof(*c), GFP_KERNEL);
-	if (!c)
-		return -ENOMEM;
-
-	c->port = port;
-	c->other_ctx = other_ctx;
-	c->other_port = other_port;
-	refcount_set(&c->refcount, 1);
-
-	list_add(&c->list, &ctx->crosschip_links);
-
-	return 0;
-}
-
-static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
-					 struct dsa_8021q_crosschip_link *c,
-					 bool *keep)
-{
-	*keep = !refcount_dec_and_test(&c->refcount);
-
-	if (*keep)
-		return;
-
-	dev_dbg(ds->dev,
-		"deleting crosschip link from port %d to %s port %d\n",
-		c->port, dev_name(c->other_ctx->ds->dev), c->other_port);
-
-	list_del(&c->list);
-	kfree(c);
-}
-
-/* Make traffic from local port @port be received by remote port @other_port.
- * This means that our @rx_vid needs to be installed on @other_ds's upstream
- * and user ports. The user ports should be egress-untagged so that they can
- * pop the dsa_8021q VLAN. But the @other_upstream can be either egress-tagged
- * or untagged: it doesn't matter, since it should never egress a frame having
- * our @rx_vid.
- */
-int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_switch *other_ds,
-				    int other_port)
-{
-	/* @other_upstream is how @other_ds reaches us. If we are part
-	 * of disjoint trees, then we are probably connected through
-	 * our CPU ports. If we're part of the same tree though, we should
-	 * probably use dsa_towards_port.
-	 */
-	int other_upstream = dsa_upstream_port(other_ds, other_port);
-	int err;
-
-	err = dsa_8021q_crosschip_link_add(ds, port, other_ds, other_port);
-	if (err)
-		return err;
-
-	err = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
-					     other_port, true);
-	if (err)
-		return err;
-
-	err = dsa_8021q_crosschip_link_add(ds, port, other_ds, other_upstream);
-	if (err)
-		return err;
-
-	return dsa_8021q_crosschip_link_apply(ds, port, other_ds,
-					      other_upstream, true);
-}
-EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_join);
-
-int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
-				     struct dsa_switch *other_ds,
-				     int other_port)
-{
-	struct dsa_8021q_context *other_ctx = other_ds->tag_8021q_ctx;
-	int other_upstream = dsa_upstream_port(other_ds, other_port);
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_8021q_crosschip_link *c, *n;
-
-	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
-		if (c->port == port && c->other_ctx == other_ctx &&
-		    (c->other_port == other_port ||
-		     c->other_port == other_upstream)) {
-			int other_port = c->other_port;
-			bool keep;
-			int err;
-
-			dsa_8021q_crosschip_link_del(ds, c, &keep);
-			if (keep)
-				continue;
-
-			err = dsa_8021q_crosschip_link_apply(ds, port,
-							     other_ds,
-							     other_port,
-							     false);
-			if (err)
-				return err;
-		}
-	}
+	ASSERT_RTNL();
 
-	return 0;
+	for (port = 0; port < ds->num_ports; port++)
+		dsa_tag_8021q_port_teardown(ds, port);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_leave);
 
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 {
@@ -496,28 +496,24 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 	ctx->proto = proto;
 	ctx->ds = ds;
 
-	INIT_LIST_HEAD(&ctx->crosschip_links);
+	INIT_LIST_HEAD(&ctx->vlans);
 
 	ds->tag_8021q_ctx = ctx;
 
-	return dsa_8021q_setup(ds, true);
+	return dsa_tag_8021q_setup(ds);
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
 void dsa_tag_8021q_unregister(struct dsa_switch *ds)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_8021q_crosschip_link *c, *n;
-	int err;
+	struct dsa_tag_8021q_vlan *v, *n;
 
-	err = dsa_8021q_setup(ds, false);
-	if (err)
-		dev_err(ds->dev, "failed to tear down tag_8021q VLANs: %pe\n",
-			ERR_PTR(err));
+	dsa_tag_8021q_teardown(ds);
 
-	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
-		list_del(&c->list);
-		kfree(c);
+	list_for_each_entry_safe(v, n, &ctx->vlans, list) {
+		list_del(&v->list);
+		kfree(v);
 	}
 
 	ds->tag_8021q_ctx = NULL;
-- 
2.25.1

