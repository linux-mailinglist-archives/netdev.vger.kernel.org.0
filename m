Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80C473A63
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhLNBp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:45:58 -0500
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:7390
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLNBpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 20:45:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExiYYgAX1cfm3oKvocnqllBGPYnbtKOKCCaXYdNXrj0T4UC2d8hL1AA90vTBkp0yWjxdO1FLuGZgnJ+Uz4ULGVQGfcONsY6DtkShwliMbbTvUZKhZ6GYBDhSidpfQbP0Fzu7S5H2GOqWKddrX5Y61o8nrnLIWBPcjjAk9SUT4OSV30/LWHhNHFSte+JHmNDDPOH9HGWTzf3bcLEKJyn2nxMjyIUXEFSZywulMBpRqtnC2GRe1Yi1T4YrXxtvXNxqT8OYiRaaGtsHRYoZuzVklQ8FYo0wjw1+BHhLmudAxIlqm0OlJTQd2bYh5n9J/4Ld59fTTQpTsxSkQOvYzCW4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3t+kChBZlQrbkCPeNc6cbgKgCfF19xZWzn/vx09XBU=;
 b=C4hVoB+c3ecW/pZ0bkPXNyDPM8PE5GQplJ5PM+tb9qjERsNR93u0v2QlGCeFjNeIu70+uQX47O5+IZmbxwm1+Po18HUPV2v6I06HVvKRs60AqGQo9yqdSi/KVplzhW3S48zjV9cNkq9ezDwPujJKp1OnMwiTIgreudTUydD9FI6kc3s4pCbFan4SiD74QjYc3BlJzZuIOYb2sSxnyQM1TZMDZzYPMttYi0f2gXsLiNQlxkl/S8p8Y9SRdQ1fRvFuq43aeapGZGbnvQrDDAt3/or45WGzXpbwy5sn+rE7whEge+qAJ0yasymjKFa0wcQrFDsgw0noOW7kd7BwTwsIkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3t+kChBZlQrbkCPeNc6cbgKgCfF19xZWzn/vx09XBU=;
 b=sTHunciBogr9iCa4ScLYwSzdy5uS2qPFT+PksYOs41frGXa5TGmM6A8SpFL7GRPCdj1BdqZyX1K0SNtyPTzsAjJisMKUa7QI+oiS4+PPrjJKKmC5WjmtP9O6gZeo5goPmipSzQ8NIkdFcH3j10LBuvkLA6h55M8wODw+L+1ZXm4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 01:45:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 01:45:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: make tagging protocols connect to individual switches from a tree
Date:   Tue, 14 Dec 2021 03:45:36 +0200
Message-Id: <20211214014536.2715578-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 01:45:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b7ce18d-8db6-4118-50db-08d9bea374ec
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800F4EF3D76744228EC8D32E0759@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/h3DNr4vKGzLrRvQUFeYnALDz/xFxNmFgqy8tOJesiKSnqpxs+Uw61wN7irDfiMFQktTARLuUd1/HJfDn336pjfxW9xbDvz/dJrGnGwcAkOf2tSzF7N/fG+aDaJ/YdDQRtP9CKa1UHYji/pp3NEp52gQSDHB+eVbPvrAYAfge0tgVGe3bHWDUttYP1ows2AG1DlhGcmgb1kIMf9cXp0iCY6uJ0CK7AzUshXsoN0mbMtxx0PcQT6SMEAhOfvivzU85KfSCFdc4rw1k41YZzb+CuGCy0Esfg0lzHDRfkA8P65qIQYdHDh1eKx8/WAC0/uwYIsVun5hHiDCfAzhkb/P+ThVG44KYpfEYzeHL8UlHldByYCPicsgfSQSX0cC6OIyUt2tJogcFNnQYV+BiOfcBlvbhLY5c0RwWNQJ33TAufyXYauZK/y/9YM8Y9dXPaYyFcsFB+/mCqdVBwjnMhiLKkOdCslZOT0TnGonIcZ82ptcsM6Xp3AELJaYUcPlRXTa13YJ1AqqOwwMqIKjNp2ztHmZ+BT0qrYaHE2rCN4xJ/C5zSa8Wy3qoWWU1XdaTA85UvQM8KBnAG3k/jpSfYaH2zLnMs825ASctcYAzA1I1ag1B6gDUXV8ZqYJMXzbZ6RqwHRQYKmwd5tDkrr7O6s3g41SRDXYNLumnaX9yaX8xXmts8sL9XzOGZIILUXgRtiPcN0LszwbFvlzOlMMIjeBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52116002)(26005)(36756003)(956004)(2616005)(4326008)(508600001)(44832011)(186003)(6916009)(54906003)(83380400001)(86362001)(1076003)(8936002)(6666004)(2906002)(6512007)(38100700002)(38350700002)(5660300002)(316002)(66946007)(6486002)(30864003)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jXC6Le27by0agdKMF5Bw3VsK0tXy4qWzfQZZpUpw4c2yBcxyGL5JqC4vwkP0?=
 =?us-ascii?Q?VFR2yRmjOjDkVLwRE6jKuTZyWJUiiVgE0m1LEqV8tJlkpGVv4On6+sWGQTdE?=
 =?us-ascii?Q?MNhSunn/wma4zMo51+XciUn3T53Ogo+iRvxb7PWVkmsKYYjuLrO0wjH0cE1x?=
 =?us-ascii?Q?X3VLsD5Xo/PIoPyyLKjD38jGQikEgNPQ+hXpD13CDKg5WFqGMrlyv3BN4h2x?=
 =?us-ascii?Q?a8TeH/q+jGr9Te8lXcxdzwF66DNQbq7LLdwK55Jo5Y2nFVwqoeTySiyZedGT?=
 =?us-ascii?Q?APIWOXSHzLUJgadBbqeDXy2atrfcGE1X3i7OTPOaEerj+siLuwy8t/b3PpKn?=
 =?us-ascii?Q?6fsa9yUF34Jr/3qFnvULENc5OSMBl9jT0kKcYLPIrt+Tri8QboBzTnjpbN3Q?=
 =?us-ascii?Q?cHgyDm3g16e9ryADhm83qIdwYEbJ3Gfqtr/11Pf66FGXuu1BxRVEubSZadC5?=
 =?us-ascii?Q?RpWVKj3jLdlhY4uhWTE/6Nm8H+vH9DJhhwTHJb2QUOG7lClNgupnYHPC62wf?=
 =?us-ascii?Q?E81WPmdi1JYnv58+Z83cghTdjLWWywJ5p7fH0xaTj+towsP9TbDUQ2iA2YlT?=
 =?us-ascii?Q?SIUrBvosyvQCwH6527ZvphOps2KpJymA3lHB6+Zub+AsgrLbLSCefwOOziS5?=
 =?us-ascii?Q?aaFAg0LqqSoHBR5bzH4PgIPtrNvUrMoif3ber0A/IzP+eKVvoDAmozuQkWdg?=
 =?us-ascii?Q?oeSiIlQtkA3LjKkgQ5ubht2RQKsmAU6XwXi+2nJFtQTnTFrQiGu26WihQ689?=
 =?us-ascii?Q?yuIyLkTCptxqehxVk3zH0kAx2vtkNlnP5PHAkNdru4AO+YdHeHHd8xlcD6RB?=
 =?us-ascii?Q?mXh8O1kgYa4s3BhB1ioygwpr75L7JpjA6Xxeo0fB4z3eRqZlw7j7leI4gB4n?=
 =?us-ascii?Q?oDkbpngq4KHcsWMHagTlsOs2Vth5lzq0FyKqc8MfLMrRbSBTzxNCfRJnAmh3?=
 =?us-ascii?Q?RhqmCypf710rTw+POE1WdydoMO6D29DJb8NQXhPGGQBwcGNaFB5MqXAys0kb?=
 =?us-ascii?Q?wA4evv8CsbL2Yo7Ja8BaRhrLWQw24Ab96CJl2e8ekUrrWEeMF0xp5qfMayBS?=
 =?us-ascii?Q?L/0g8qwu/BdPgLJMk2kzvc5glFY7RY56AgVmOHww1CQ2Yb4A1XKAQiX3HlFj?=
 =?us-ascii?Q?Zis4UdrlwKhBo8an+xL1zVXWWDb5tC8wTMjeaMeS4pT5FtxLRrmQVYX7hggJ?=
 =?us-ascii?Q?L/C04ZztKDdasvTaagCXrJDMbkElaThvWe2UQOFOL2aNtpEQvYzcZd2V5lS6?=
 =?us-ascii?Q?Qbxee20xaqJ3rwmvkVkjVBKsnGq4ZrM7ohtF9mZ9c88oGgOnn8YcE6KiZXM4?=
 =?us-ascii?Q?v6GX3vFTxQ6rMuhCeHxpDCGby8ZEVT0kfwZbWKOUiGuYXLVjPnoIqEHv7Tci?=
 =?us-ascii?Q?22o0BxnvWbVaujxuirHcNldmlIcdjM+aug0W7CCbCiMBr+DujA1jDKX0VyKE?=
 =?us-ascii?Q?FGBMF/bGTNp/4cofYpXvvcd+h1jKGSD2Z4Wd9A9u9X4Ayt8pNoeHQKKXF2X5?=
 =?us-ascii?Q?i73ReZrJ91RixH/1ykrkTC8lP4xh3nGIP0lNgJxdTDHkhXSBZ7pVTpaaqtxX?=
 =?us-ascii?Q?gAJs+v2UJENEbYKsduaKxYe7wfttndcGnOiIf6H2f04rWZR/VGRIeuJajhov?=
 =?us-ascii?Q?kpOXHqE8k6o+1izVg7VWnBs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7ce18d-8db6-4118-50db-08d9bea374ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:45:50.1164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHrfQSraUqhZDtvMQqAT9PvDOBe5dOK2874BVFQtjsSrsjLndDAvlar5cLHNS28LZi+XpjYn5anMwbrrK7HDug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the NXP Bluebox 3 board which uses a multi-switch setup with sja1105,
the mechanism through which the tagger connects to the switch tree is
broken, due to improper DSA code design. At the time when tag_ops->connect()
is called in dsa_port_parse_cpu(), DSA hasn't finished "touching" all
the ports, so it doesn't know how large the tree is and how many ports
it has. It has just seen the first CPU port by this time. As a result,
this function will call the tagger's ->connect method too early, and the
tagger will connect only to the first switch from the tree.

This could be perhaps addressed a bit more simply by just moving the
tag_ops->connect(dst) call a bit later (for example in dsa_tree_setup),
but there is already a design inconsistency at present: on the switch
side, the notification is on a per-switch basis, but on the tagger side,
it is on a per-tree basis. Furthermore, the persistent storage itself is
per switch (ds->tagger_data). And the tagger connect and disconnect
procedures (at least the ones that exist currently) could see a fair bit
of simplification if they didn't have to iterate through the switches of
a tree.

To fix the issue, this change transforms tag_ops->connect(dst) into
tag_ops->connect(ds) and moves it somewhere where we already iterate
over all switches of a tree. That is in dsa_switch_setup_tag_protocol(),
which is a good placement because we already have there the connection
call to the switch side of things.

As for the dsa_tree_bind_tag_proto() method (called from the code path
that changes the tag protocol), things are a bit more complicated
because we receive the tree as argument, yet when we unwind on errors,
it would be nice to not call tag_ops->disconnect(ds) where we didn't
previously call tag_ops->connect(ds). We didn't have this problem before
because the tag_ops connection operations passed the entire dst before,
and this is more fine grained now. To solve the error rewind case using
the new API, we have to create yet one more cross-chip notifier for
disconnection, and stay connected with the old tag protocol to all the
switches in the tree until we've succeeded to connect with the new one
as well. So if something fails half way, the whole tree is still
connected to the old tagger. But there may still be leaks if the tagger
fails to connect to the 2nd out of 3 switches in a tree: somebody needs
to tell the tagger to disconnect from the first switch. Nothing comes
for free, and this was previously handled privately by the tagging
protocol driver before, but now we need to emit a disconnect cross-chip
notifier for that, because DSA has to take care of the unwind path. We
assume that the tagging protocol has connected to a switch if it has set
ds->tagger_data to something, otherwise we avoid calling its
disconnection method in the error rewind path.

The rest of the changes are in the tagging protocol drivers, and have to
do with the replacement of dst with ds. The iteration is removed and the
error unwind path is simplified, as mentioned above.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h          |  5 ++-
 net/dsa/dsa2.c             | 44 ++++++++++---------------
 net/dsa/dsa_priv.h         |  1 +
 net/dsa/switch.c           | 52 +++++++++++++++++++++++++++--
 net/dsa/tag_ocelot_8021q.c | 53 +++++++++---------------------
 net/dsa/tag_sja1105.c      | 67 +++++++++++++-------------------------
 6 files changed, 109 insertions(+), 113 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 64d71968aa91..f16959444ae1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -82,15 +82,14 @@ enum dsa_tag_protocol {
 };
 
 struct dsa_switch;
-struct dsa_switch_tree;
 
 struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
-	int (*connect)(struct dsa_switch_tree *dst);
-	void (*disconnect)(struct dsa_switch_tree *dst);
+	int (*connect)(struct dsa_switch *ds);
+	void (*disconnect)(struct dsa_switch *ds);
 	unsigned int needed_headroom;
 	unsigned int needed_tailroom;
 	const char *name;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cf6566168620..c18b22c0bf55 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -248,12 +248,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 static void dsa_tree_free(struct dsa_switch_tree *dst)
 {
-	if (dst->tag_ops) {
-		if (dst->tag_ops->disconnect)
-			dst->tag_ops->disconnect(dst);
-
+	if (dst->tag_ops)
 		dsa_tag_driver_put(dst->tag_ops);
-	}
 	list_del(&dst->list);
 	kfree(dst);
 }
@@ -841,17 +837,29 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 	}
 
 connect:
+	if (tag_ops->connect) {
+		err = tag_ops->connect(ds);
+		if (err)
+			return err;
+	}
+
 	if (ds->ops->connect_tag_protocol) {
 		err = ds->ops->connect_tag_protocol(ds, tag_ops->proto);
 		if (err) {
 			dev_err(ds->dev,
 				"Unable to connect to tag protocol \"%s\": %pe\n",
 				tag_ops->name, ERR_PTR(err));
-			return err;
+			goto disconnect;
 		}
 	}
 
 	return 0;
+
+disconnect:
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(ds);
+
+	return err;
 }
 
 static int dsa_switch_setup(struct dsa_switch *ds)
@@ -1160,13 +1168,6 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
 
 	dst->tag_ops = tag_ops;
 
-	/* Notify the new tagger about the connection to this tree */
-	if (tag_ops->connect) {
-		err = tag_ops->connect(dst);
-		if (err)
-			goto out_revert;
-	}
-
 	/* Notify the switches from this tree about the connection
 	 * to the new tagger
 	 */
@@ -1176,16 +1177,14 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
 		goto out_disconnect;
 
 	/* Notify the old tagger about the disconnection from this tree */
-	if (old_tag_ops->disconnect)
-		old_tag_ops->disconnect(dst);
+	info.tag_ops = old_tag_ops;
+	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DISCONNECT, &info);
 
 	return 0;
 
 out_disconnect:
-	/* Revert the new tagger's connection to this tree */
-	if (tag_ops->disconnect)
-		tag_ops->disconnect(dst);
-out_revert:
+	info.tag_ops = tag_ops;
+	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DISCONNECT, &info);
 	dst->tag_ops = old_tag_ops;
 
 	return err;
@@ -1318,7 +1317,6 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 	struct dsa_switch_tree *dst = ds->dst;
 	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
-	int err;
 
 	/* Find out which protocol the switch would prefer. */
 	default_proto = dsa_get_tag_protocol(dp, master);
@@ -1366,12 +1364,6 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		 */
 		dsa_tag_driver_put(tag_ops);
 	} else {
-		if (tag_ops->connect) {
-			err = tag_ops->connect(dst);
-			if (err)
-				return err;
-		}
-
 		dst->tag_ops = tag_ops;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0db2b26b0c83..edfaae7b5967 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -38,6 +38,7 @@ enum {
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
 	DSA_NOTIFIER_TAG_PROTO_CONNECT,
+	DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
 	DSA_NOTIFIER_MRP_ADD,
 	DSA_NOTIFIER_MRP_DEL,
 	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 06948f536829..393f2d8a860a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -647,15 +647,58 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_switch_connect_tag_proto(struct dsa_switch *ds,
-					struct dsa_notifier_tag_proto_info *info)
+/* We use the same cross-chip notifiers to inform both the tagger side, as well
+ * as the switch side, of connection and disconnection events.
+ * Since ds->tagger_data is owned by the tagger, it isn't a hard error if the
+ * switch side doesn't support connecting to this tagger, and therefore, the
+ * fact that we don't disconnect the tagger side doesn't constitute a memory
+ * leak: the tagger will still operate with persistent per-switch memory, just
+ * with the switch side unconnected to it. What does constitute a hard error is
+ * when the switch side supports connecting but fails.
+ */
+static int
+dsa_switch_connect_tag_proto(struct dsa_switch *ds,
+			     struct dsa_notifier_tag_proto_info *info)
 {
 	const struct dsa_device_ops *tag_ops = info->tag_ops;
+	int err;
+
+	/* Notify the new tagger about the connection to this switch */
+	if (tag_ops->connect) {
+		err = tag_ops->connect(ds);
+		if (err)
+			return err;
+	}
 
 	if (!ds->ops->connect_tag_protocol)
 		return -EOPNOTSUPP;
 
-	return ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+	/* Notify the switch about the connection to the new tagger */
+	err = ds->ops->connect_tag_protocol(ds, tag_ops->proto);
+	if (err) {
+		/* Revert the new tagger's connection to this tree */
+		if (tag_ops->disconnect)
+			tag_ops->disconnect(ds);
+		return err;
+	}
+
+	return 0;
+}
+
+static int
+dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
+				struct dsa_notifier_tag_proto_info *info)
+{
+	const struct dsa_device_ops *tag_ops = info->tag_ops;
+
+	/* Notify the tagger about the disconnection from this switch */
+	if (tag_ops->disconnect && ds->tagger_data)
+		tag_ops->disconnect(ds);
+
+	/* No need to notify the switch, since it shouldn't have any
+	 * resources to tear down
+	 */
+	return 0;
 }
 
 static int dsa_switch_mrp_add(struct dsa_switch *ds,
@@ -780,6 +823,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
 		err = dsa_switch_connect_tag_proto(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
+		err = dsa_switch_disconnect_tag_proto(ds, info);
+		break;
 	case DSA_NOTIFIER_MRP_ADD:
 		err = dsa_switch_mrp_add(ds, info);
 		break;
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index fe451f4de7ba..68982b2789a5 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -81,55 +81,34 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	return skb;
 }
 
-static void ocelot_disconnect(struct dsa_switch_tree *dst)
+static void ocelot_disconnect(struct dsa_switch *ds)
 {
-	struct ocelot_8021q_tagger_private *priv;
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list) {
-		priv = dp->ds->tagger_data;
-
-		if (!priv)
-			continue;
+	struct ocelot_8021q_tagger_private *priv = ds->tagger_data;
 
-		if (priv->xmit_worker)
-			kthread_destroy_worker(priv->xmit_worker);
-
-		kfree(priv);
-		dp->ds->tagger_data = NULL;
-	}
+	kthread_destroy_worker(priv->xmit_worker);
+	kfree(priv);
+	ds->tagger_data = NULL;
 }
 
-static int ocelot_connect(struct dsa_switch_tree *dst)
+static int ocelot_connect(struct dsa_switch *ds)
 {
 	struct ocelot_8021q_tagger_private *priv;
-	struct dsa_port *dp;
 	int err;
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->ds->tagger_data)
-			continue;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (!priv) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		priv->xmit_worker = kthread_create_worker(0, "felix_xmit");
-		if (IS_ERR(priv->xmit_worker)) {
-			err = PTR_ERR(priv->xmit_worker);
-			goto out;
-		}
-
-		dp->ds->tagger_data = priv;
+	priv->xmit_worker = kthread_create_worker(0, "felix_xmit");
+	if (IS_ERR(priv->xmit_worker)) {
+		err = PTR_ERR(priv->xmit_worker);
+		kfree(priv);
+		return err;
 	}
 
-	return 0;
+	ds->tagger_data = priv;
 
-out:
-	ocelot_disconnect(dst);
-	return err;
+	return 0;
 }
 
 static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index b7095a033fc4..72d5e0ef8dcf 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -741,65 +741,44 @@ static void sja1110_flow_dissect(const struct sk_buff *skb, __be16 *proto,
 	*proto = ((__be16 *)skb->data)[(VLAN_HLEN / 2) - 1];
 }
 
-static void sja1105_disconnect(struct dsa_switch_tree *dst)
+static void sja1105_disconnect(struct dsa_switch *ds)
 {
-	struct sja1105_tagger_private *priv;
-	struct dsa_port *dp;
-
-	list_for_each_entry(dp, &dst->ports, list) {
-		priv = dp->ds->tagger_data;
-
-		if (!priv)
-			continue;
+	struct sja1105_tagger_private *priv = ds->tagger_data;
 
-		if (priv->xmit_worker)
-			kthread_destroy_worker(priv->xmit_worker);
-
-		kfree(priv);
-		dp->ds->tagger_data = NULL;
-	}
+	kthread_destroy_worker(priv->xmit_worker);
+	kfree(priv);
+	ds->tagger_data = NULL;
 }
 
-static int sja1105_connect(struct dsa_switch_tree *dst)
+static int sja1105_connect(struct dsa_switch *ds)
 {
 	struct sja1105_tagger_data *tagger_data;
 	struct sja1105_tagger_private *priv;
 	struct kthread_worker *xmit_worker;
-	struct dsa_port *dp;
 	int err;
 
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dp->ds->tagger_data)
-			continue;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
-		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (!priv) {
-			err = -ENOMEM;
-			goto out;
-		}
-
-		spin_lock_init(&priv->meta_lock);
-
-		xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
-						    dst->index, dp->ds->index);
-		if (IS_ERR(xmit_worker)) {
-			err = PTR_ERR(xmit_worker);
-			goto out;
-		}
+	spin_lock_init(&priv->meta_lock);
 
-		priv->xmit_worker = xmit_worker;
-		/* Export functions for switch driver use */
-		tagger_data = &priv->data;
-		tagger_data->rxtstamp_get_state = sja1105_rxtstamp_get_state;
-		tagger_data->rxtstamp_set_state = sja1105_rxtstamp_set_state;
-		dp->ds->tagger_data = priv;
+	xmit_worker = kthread_create_worker(0, "dsa%d:%d_xmit",
+					    ds->dst->index, ds->index);
+	if (IS_ERR(xmit_worker)) {
+		err = PTR_ERR(xmit_worker);
+		kfree(priv);
+		return err;
 	}
 
-	return 0;
+	priv->xmit_worker = xmit_worker;
+	/* Export functions for switch driver use */
+	tagger_data = &priv->data;
+	tagger_data->rxtstamp_get_state = sja1105_rxtstamp_get_state;
+	tagger_data->rxtstamp_set_state = sja1105_rxtstamp_set_state;
+	ds->tagger_data = priv;
 
-out:
-	sja1105_disconnect(dst);
-	return err;
+	return 0;
 }
 
 static const struct dsa_device_ops sja1105_netdev_ops = {
-- 
2.25.1

