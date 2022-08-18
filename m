Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBBE5984E8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbiHRNzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245420AbiHRNy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:26 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76B03AB18
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StJZ2lwLx3qtblxkPiK+8URrjmaR31p2XtgaRHV8BguIhyBKblK9o7rmS3LueDvW96MePEzSjpVW7kbMiDfWFReBpZazELOMixlQQ2BKQbV+BvyPFJ5zf1QHQfVJkKu+AzQ4sNSxXo6FGVzoEixLgOO2x3lbde+jML8EIbDMOume9GXe0fMMVaXabQs+HxCgS7/up99WP7zqJQPzz/o0hJ6QX/ihLrV/hiNHotKChCHZcapmy6FJn22s8pBNHGCsazJmrGzPEfHxjuc7p/RHx25NXbpkuHgibnEWu0eGtGB/+9qkOROmbwXyhwxdAe7vlPg9qVIj99ivaDDVvynO0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANSisbRKbNjcr608A70yOMROhEYEJ+uTHLwZgXz4UDk=;
 b=l4Zn5d+MLMdOogP5Z7FleigkgEZlFjYQ3vUW3MUxR5zgvZtjhCOsJPUzYAiSdpZjhew/Yy1KfPmVnq76VpK4W2pHfaDReYsPYVBlw6tBe8fNNoPn8d5YTIZJmKWR8qNhs9YBctXmwiM82t0pE1Oe61Wy9VQKh74AqhCq7lJPdZSSJBwT0K9Um77uxvCjdV4KZO2vonMSUohs5RWWwCob4mxslaYCWpzmI3YEA70I9+7apxZidwuhGlx+nXESH1x8P7ztIC0qlm6rla0D+jtNRlmNbZzxrH2PaMNHkpGHUs030lWGstRv8l4PqT0J7C2e5DFaT8MEgYx/qXf0AmjNcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANSisbRKbNjcr608A70yOMROhEYEJ+uTHLwZgXz4UDk=;
 b=qLou+gOPeYJ2lYFemsSb71li32Fow4VJFiAK+KnBrrwOAMbLfWxDOwirQjD3XELfcBTj4GQyDO3TT8Oz5KrNlfxSlMfPDEsnCvBHVb0OfzQBN+6RAk5/IOW/p4UFqdmtNgLGdBUEq0taf+UtTqvIYdSww6Nqs5ckfUVgRlx+XZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 6/9] net: dsa: all DSA masters must be down when changing the tagging protocol
Date:   Thu, 18 Aug 2022 16:52:53 +0300
Message-Id: <20220818135256.2763602-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99de1a97-2b42-4ddd-af76-08da81210122
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMmD3nZ1dGXHqSeRgD/Z+GW2nI8rFE2gUlIH22GGZoi+Bna/4uzN07tpJlftNEjBDlUQtOV3/nLvubEgHiRLfQhDKKzgRykT62zItTZPylmhkK8juQMu/sgk8BIo3PsVJYDyAIqTuIWAFKbN2nxmYB9bSWzb7aCD7JNIwtM85Cn7WnEv6QX8mOqQ9ixlLFYq7loxUAtIa9ec3cd0y5Ry9LuqFpeEwYUJmjRYApARS48VFsV5/saOL17twbriEVWFA7gE8pfTjPtn9joDZUgp8OBc6vETYqSlxx+QCfDq25rIsoQq/QyBgSEKDgPvW2DneRqDkuxLLs1HbWEfB65teBdw+uDxl00zIuhyrtBszlHNcGOk92wfOfu7WK8d9KOrzryBDOaeN4bHDTgds3BzH22fkWIJlerSY99xTJBPLAgsdpIC0eeAAP9dQxXphcSTROdGZIHc7WH/6kS2NXdV2l/4fzExY87dPZNFlOpa9aVwQJWDSMfuu8gGcObBHSeadgwiqRi+J/BRigm9rHorsPfOhFnZkIM+PZVxCUqD+My3bHnSfrKUKPBAx1IDwladKss8nxA++sRvfzDxGs3Navcd4/Fr35DEk/WVZr0/rcV6SegaldULNSMIN3g+wFsGpRDhQ6X2WzNQXWKROaH1IDK4m9s+FIbCTMd9S2YF8U6AYs4aD3wzamVYX9Y6YNSLiE4sjYH49aIfb0RRGZyC1aGeb8a5BGpgWVYDtWEuJGECzqLgGDwGcGjabEdD2JgKlKxDB8l4cn24/3cX5jFNFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CEYqMPZLdTSRe01ERiaFOub1HOdxhzOHGvXXGCUeXr+V/uoTyEvGQHqb8XY6?=
 =?us-ascii?Q?tYdYowveR87r5twZXZ1DJYOiqJUxcktRiS46nJDKYE3X7RQribkVJCl/gVjo?=
 =?us-ascii?Q?McWjayf11RQpBOKgDLYEzpCfIlcoebkb/dsxqfYvMctPILzR679L25zxZsiV?=
 =?us-ascii?Q?8uOnGqNisrlaBxXsVjskSnxZkioDXhSCSdbLfgHAYWXM9nqiFw1FooqCdWnR?=
 =?us-ascii?Q?PKF43CbwG91SDmj8051LmAViNzs+Mxd437Jtxi7PrMOhAfj7r+8rw0C4C2P2?=
 =?us-ascii?Q?3ykKWJtsgJBP5rcjfWLFPmCpyTxu6xx27zvTT0mY8T+sAEaJYvtbPeM0j5e/?=
 =?us-ascii?Q?KwZ857wIbNT5LxMPyB5/ilvsZ/y7ibNDbRTuZP+oWEEjMoM2KRcFMbSNLHrF?=
 =?us-ascii?Q?WW2iBTyHwrq6flexpunOHCBSRRoDWTLIqYYVOs/XWU6mFXYVEfl6RN6RPcL3?=
 =?us-ascii?Q?2cGEXHzjXzA4rA4lREn6ogTgwJSFZWl7QWAVxYzu7wWNXFJ2W2w46EQcez1Y?=
 =?us-ascii?Q?laNT8rZCnJgGJz3IOga1+v62G+MbnQrWJP8MfBypVrp2L7OICeRJBbsYou7y?=
 =?us-ascii?Q?jjWE/UIWZOFDZAuskmTLcaTsfRMC3d7sA7F1TAzSsngAh+nRSQvB2qD5sIfb?=
 =?us-ascii?Q?PMxF+A/uk5N5uTnIqdyYR3qR10ytsYkfn+FgCBHMmJPLWHs5vrFt9TQFSTrB?=
 =?us-ascii?Q?QihqBsKqvQOQ8AlZrUnTWflBGpPNJSnjpVQ63moDcDR7YLi9+dZJ+kHo/Qxo?=
 =?us-ascii?Q?RI/vFZI9fpbptHKfYhkKN1vD1IwYFK5y0+u+loLZ2TIQqhk69Dv4Tiwmj+ee?=
 =?us-ascii?Q?ENhmZNBKGs4v1ilLDO4mm1MagzlZ/aALFMNN1Afkh/XAn/oSdZkwPoYn7Muo?=
 =?us-ascii?Q?lX32Y34racIWnc0jUwYuB3yklGR/b6iruPDFIX1FNs0lropALAfahmUs3xGF?=
 =?us-ascii?Q?gFm5L6hkRdndvmcPviz73MkU6ipWOCh1C+ooFlMNbrS7PX9bX/Nj5USiNhj1?=
 =?us-ascii?Q?9E0akOfYkJ0yVsOoLGiqSi7IxctmsxCyXXeFNmt6NwI2gvKZzsUy54lj+Cqz?=
 =?us-ascii?Q?FvKky+JVCpFAaGOpHaEkMZTR2AVuXSC2c5w5CKAghBh1qktoP863PzBFxL8n?=
 =?us-ascii?Q?l15tcbr/0FxMhF9IXJdIolj7F6PJGTBWCYLZKHn0Alc0tIwZoQPczdj4m6XR?=
 =?us-ascii?Q?7rnO8D0m861clcwQTHolHC8JUJbBaCyHxgktdPcfps10mGQpIzv/HYmB7Jy2?=
 =?us-ascii?Q?buo+hnQx6WV/pi+I96L97pOVZwh5thELlu2Dxf3+ukH+GPeAlgSuuIXKoeFg?=
 =?us-ascii?Q?SPd5cYwKlCoSAssal88yZOYTHLkDCghkjXqSHeB8mMMN/sDqgoGNAZVHGmsa?=
 =?us-ascii?Q?HL7yOvlQSIXdKe4bOE8MwgmjgP6Yy8fv/kAMOAhN+PURF7ML1MU1OksQvQPb?=
 =?us-ascii?Q?1DjZQd2rgOHaYxljsZSPnTGcRSN1LcEhkQK6K30tQXXqa4TP4kOwb1TfYGFz?=
 =?us-ascii?Q?RugAYflr6LBcVViHR5nCWQsbWNwKGM/N192eyfXY2K9wqnQE0C/hYdMgEETR?=
 =?us-ascii?Q?7L/0OtKQpKpfgVyzbu8RPlg9OGXVwDQN0RCE6MvbjjyBp1XBpjWnlxGE7gwS?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99de1a97-2b42-4ddd-af76-08da81210122
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:18.0706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ktderC7sbFkzPi86Ns2kP/pgGYNnuAWpM4T6hY7nwpW83DiqxAjQYJN+0hf+jP7/aqMuY8fS8tzxNgBBxXKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that the tagging protocol is set and queried from the
/sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
the single CPU port days which isn't aging very well now that DSA can
have more than a single CPU port. This is because the tagging protocol
is a switch property, yet in the presence of multiple CPU ports it can
be queried and set from multiple sysfs files, all of which are handled
by the same implementation.

The current logic ensures that the net device whose sysfs file we're
changing the tagging protocol through must be down. That net device is
the DSA master, and this is fine for single DSA master / CPU port setups.

But exactly because the tagging protocol is per switch [ tree, in fact ]
and not per DSA master, this isn't fine any longer with multiple CPU
ports, and we must iterate through the tree and find all DSA masters,
and make sure that all of them are down.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/dsa2.c     | 10 +++-------
 net/dsa/dsa_priv.h |  1 -
 net/dsa/master.c   |  2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..b2fe62bfe8dd 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1238,7 +1238,6 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
  * they would have formed disjoint trees (different "dsa,member" values).
  */
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops)
 {
@@ -1254,14 +1253,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	if (master->flags & IFF_UP)
-		goto out_unlock;
-
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_port_is_user(dp))
-			continue;
+		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+			goto out_unlock;
 
-		if (dp->slave->flags & IFF_UP)
+		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
 			goto out_unlock;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..cc1cc866dc42 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -545,7 +545,6 @@ struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
 void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..32c0a00a8b92 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -307,7 +307,7 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 		 */
 		goto out;
 
-	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, new_tag_ops,
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, new_tag_ops,
 					old_tag_ops);
 	if (err) {
 		/* On failure the old tagger is restored, so we don't need the
-- 
2.34.1

