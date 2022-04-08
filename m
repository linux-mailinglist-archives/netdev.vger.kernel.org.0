Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FEC4F9DF2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiDHUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiDHUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:12 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEA734ECB6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cu3xS8L9wLZqVEuRDbKk4tiI8vg9PxINwmI7bPHbtuTcTr2X9wwaeVOAVfeZD/WRschcd/gyJWGthHTS0yVKzHQ0Mt/BzafbQb/SkbTXpPw2ntiF20egGHBYZXEln2hiW5TkpjPIGnMZ60gbk8SdlbJ68+z2g/cnBByjyMkH0w/aa/vZKMQusz2GflzxNntWsw4UwkTPWPphwkYWgg9wLxHLKeetE79aK3lWLf3ltM2Pkf+IZA9NNDjwnpksNLCqqYsmNJHMtNwnQNstGPCMTThbmQfZlWKfLki72Y1Gamgf5X6dMXGarNuWmkVi7DM0yaUx6+s3v2iIoBkf0eQzHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5vdUE34JDPmeRLw1nvqZya0SayDOmA5JXcUE4/w+hs=;
 b=CrajW7CwYswR+BtaM0wOjjQB/ljwfiBaCUmVjyC59j+F6eCEJuXo4awwIBK+3EHPaUoDVEnKFjO3hTpnKhA3JVtjbcyMRl8L8mGg3LaQLjFTKsfTpE8UTcaTSsiA7sgRuLijuCA4sWHNsgwMtXewbMsGGmAGe486kk8Tjg2hRfHqWOhLPj2KllACEFjlRi2UdzhUQmQvcPXcfx6AgIwqWLGUaegi5EQ83WPaBrMUvhiFsEX/GQKsmEEtK0k/VJ9MThSpWq/cdw+yznjbWCzHYWEy53Bg7hE3+CHc5jT1epD9QoQW2jvGE55j/ZSLXjzLcKGgrPRubxBW1Kdlbwo3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5vdUE34JDPmeRLw1nvqZya0SayDOmA5JXcUE4/w+hs=;
 b=d83CGiZY/LMp9iHiaUmlcpn4E8LPdP2zridInU9RnFhXdbHQtB0VtiHcDhKBsokNiyRutgrzMplDmMPxOHmz+X7B1W8MhCF4uvP029fWHei+EeebHFN/ikgCswy55b2X7umi/xoKxppUEU9/y6Mt5BxQRbeOXZo19uwBpcyPs6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:05:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:05:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 6/6] net: bridge: avoid uselessly making offloaded ports promiscuous
Date:   Fri,  8 Apr 2022 23:03:37 +0300
Message-Id: <20220408200337.718067-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d76c205-0aeb-46d1-1986-08da199b1215
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB42753878C91D26FB02628FC5E0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/Hb6aXhNeGGaYP4I/+lXQzdcjZlPEOZ3BQaCWbrPjkaA+HWXhVPd5oThd8YWse+++ojAeJx+SNLrP5tQQg7qlODslUT+Dg5lPOcXKqbh4gTH5GeFc48BDYqcO5aGViF/owS4KFo/FSbOV7ShPBXcDPagJm0j+0F3FNvs0Ej2rk/U3BxRfXzPr+KphwGU5IKu955tAE/qRowToSlBPWDHN5zDOrzmQIzqT0B/oVMzsziFuhVUmrXFstCmwhy0kqSFhEXhKjw4JqZ/kK5eAITqVMC3+scWD6E0b7FJgPWmZBVB9lMSTcoCGmTViJ+4/gak+jh7xtwKHs1fltPzmyDyGYLJOhGoSHeyNGSA/IoSjMa2PO94Rp6/8DC1wyeTIbHnIdqYAN0MBv+e6t3letLFtsS3sX299aBri2tGQFQnLlb1a7EB7NtJSJxSzg+D2Xhh8Re07PEP0GWFisylCbPwCFehhNMI0uAoEjy3sDSfSiJKNv/k54TAd4MQP8yOc5sT87dSkJLqHQAqM0ybs0fNxk4VOTzVLq4tA4OeOYwdRzOnxs+uSY4sz34C15R6kYHx691RvJqsZpszJ8J7f0rdVOXlN/KlDmgP/pLxy5rUGkwv1EY9DBWba+YF3Hv+BjIzcRNYWpUpsl17ZKe3cp28EOufVvl8uC1nnfVD9av2vI8/OBgopIn0CetogSM5Wykv+cOrN1rjOjbwnzo+hKAXoMacCr3r6OKcP4gSDwVc96VfbJAtPFcVmMsxw+xALje5h8rk02OvJPM/1uTcUCoH1UjJq2a+Ee4lQX65wjEFA4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(966005)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?71mO6WQs453rv1Ctx7yzBAH3MMNAOs/gOx/dJj8AhecgdxkpDwp140SrKiXe?=
 =?us-ascii?Q?Df7WRRnvPdLHzAMgtCpm3MXs2iflmKeooKtHgZUFGgOaTqcSgRIs6YXnSxSD?=
 =?us-ascii?Q?2t65gSSVfstgl6B+KVrmo4gC1NvOS03NQt9RZsqZB3Jyn9PALDX5mYug6Ufe?=
 =?us-ascii?Q?pJ0p8tzFZKJIlnshBOIIVvcT3PWMOaZl/e2xV8jpsssn63taUJwSt30zgehw?=
 =?us-ascii?Q?7wixAsgmG2kvBrb/cdibSe7ogMiO9TR/3cdaqe8qo5G9tm2roSuEiI4MOPMD?=
 =?us-ascii?Q?rzWg+1d22U+f4kHIYpAqkvEu7X0uwQoIHCCgaTl7o7a1vjE6sgQLStcMsvlo?=
 =?us-ascii?Q?Os23sicf9LKY/W1ImkZEArJvuGKk9swj7Mv5G05zkupGPYfn3fX9dBN262KB?=
 =?us-ascii?Q?YWoAeWKsZv3rW8BVwi1A53YCFpAfJGbTX5YHHLW14rIX8cUkG7LsOadUKc+X?=
 =?us-ascii?Q?UjmluIPU9uAOmhnFq6+3++Gdd9Z7jA/yR9wY4sJKHk/7BF/Gox1QDU91Bcq4?=
 =?us-ascii?Q?poOVUzYAAC/IuC1QgfXzpAB/GMMBYYDMYY74Sz0EewNk1N/b0NJwLQWrhYJ0?=
 =?us-ascii?Q?sKp/5nZXwx7TY5/l80xBNuPEaXapD870iU5GZ8gHkX1LlbkW2/rpqOaZcW6O?=
 =?us-ascii?Q?yuN2kXFch5MwaSqKOF+jZE20P57VEIiLz2jKCzDfdPRpNBiIuZuXlZcZ2414?=
 =?us-ascii?Q?X+XmAkqSDIbUlng/UdugtCKlABf1tniKNSqtad47gGboWy2CPAWHcWi2V5Jz?=
 =?us-ascii?Q?SVECq8YRUzsUfeWUBFUJ4WfG5rZXiMc1kdD3XY7ASl4TUbqHn8WazZcJMNj8?=
 =?us-ascii?Q?0JOV9YPLu8DpysrHLnyN0X3inTQQW0AW5Vhs3qBFzqmXc9bub6hpCo7Gp8Ki?=
 =?us-ascii?Q?sMBRjyQKt+kpT9gblt9pXMDWUxvysBzHJlaYGVcnnCwL/S5gAXHwfUj+xVHD?=
 =?us-ascii?Q?dZG3VEk/4IdO8BLsvvOd6Zvvi482N/QmlqbUL87B4yfKAKa1gRg1ve42vhTW?=
 =?us-ascii?Q?xtWq8fNMfo9ozbcYtLyZbS5JLLPXLqmaQnp9nGNYH/fU/Y9AguKTZfidqXRa?=
 =?us-ascii?Q?3LVPKMyLd95/ZxbRp/nJ6JFY2NBUMqjImVB6nMjVUxc5B94MlEWW2laPfFRm?=
 =?us-ascii?Q?VWbZZDNScvsNizthzy4B3SPrBE6hj90fthBf7ayl0wa3+XJMHY1zd6HtJ24S?=
 =?us-ascii?Q?ekkhBVVsoGnYF6vzmIVkmlFZTapOas8DxILFt6N0WFT0DtA4Vhq2PinQNeYA?=
 =?us-ascii?Q?aMzWFtarWJYS7qtjatECJmvFCEIf8hoMWWhAZpVn1KeA0LiKWBpqEz4HsIhv?=
 =?us-ascii?Q?Otj98ZzC4mn5xIDA72WZQfhgyzEOWj4T7ZJVOJBJF9HKGqCY5HznpmmhIC7P?=
 =?us-ascii?Q?nftEfIIxekpxVfcb/envmvgoLUKtDF129ff3mFk+8Z8C8zAV0Qf/ett7o1xR?=
 =?us-ascii?Q?vZ0PbEAsAgQdkAWFuyFj8IH/w6p6yAwlFnUEVe+nasxRk2mrDd+ZOfcsQbnW?=
 =?us-ascii?Q?//tu8docW9jZn6TBmF22iGysmDEy4dS+kt6dpUV8UooqqFZgGj9ZLXYwZEj3?=
 =?us-ascii?Q?s9Hp575WRuuyi6hU+v6AqBqbHCEMXuC1aGHC91U8nc6Nih40lR3PTdRzzmm1?=
 =?us-ascii?Q?0hQcxg1/YisOlxL1EbSBM61pM7iURqYX4td1AgQ20rkXXdi7bKStJgl8LuCs?=
 =?us-ascii?Q?SifYImvQj7tYqL8/IM5KJKsedBYKEXLIuoEru3gYZknbCTBzw58PF9YmLaHF?=
 =?us-ascii?Q?WVJfSrASzBTymhPrYVqadPw5rERjFLo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d76c205-0aeb-46d1-1986-08da199b1215
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:05:04.2375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyg6w22Qo9vrx2kX8Iehc6M69/3SDKE8T7U0QLDvIrCQtIZwJMxrO47Y1+D59hBRQg2jt574jL3TqO0RLkDTHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge driver's intention by making ports promiscuous is to turn off
their RX filters such that these ports receive packets with any MAC DA.

A quick survey of the kernel drivers that call
switchdev_bridge_port_offload() shows that either these do not implement
ndo_change_rx_flags() at all, or they explicitly ignore changes to
IFF_PROMISC (am65_cpsw_slave_set_promisc, cpsw_set_promiscious,
ocelot_set_rx_mode).

This makes sense, because hardware that is purpose-built to do L2
forwarding generally already knows it should accept any MAC DA on its
ports.

That is not to say that IFF_PROMISC makes no sense for switchdev drivers.
For example, DSA has the concept of multiple address databases (this is
achieved by effectively partitioning the FDB: reserve a database - FID -
for each port operating as standalone, a FID for each VLAN-unaware
bridge, a FID for each bridge VLAN). The address database of a
standalone port is managed through the standard dev->uc and dev->uc
lists and is used to filter towards the hosts the addresses required for
local termination. The bridge-related address databases are managed
using switchdev (SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE).

IFF_PROMISC is intrinsically connected to dev->uc and dev->mc (see the
implementation of __dev_set_rx_mode which puts the interface in
promiscuous mode if the unicast list isn't empty but the device doesn't
support IFF_UNICAST_FLT), and therefore to what DSA implements as the
standalone port address database (there, an entry in dev->uc means
"forward it to CPU", the absence of it means "drop it", and promiscuity
means "put the CPU in the flood mask of packets with unknown MAC DA").

Whereas there is no IFF_PROMISC equivalent to the FDB entries notified
through switchdev (therefore to the bridge-related address databases),
because none is needed.

In this model, the bridge driver, which is only trying to secure its
reception of packets, is in fact overstepping, because it manages
something which is outside of its competence: the host flooding of the
standalone port database, when in fact that database will not be the one
used by packets handled by the bridging service.

In turn, this prevents further optimizations from being applied in
particular to DSA, and in general to any switchdev driver. A desirable
goal is to eliminate host flooding of packets which are known to be
unnecessary and only dropped later in software [1].

In an ideal world with ideal hardware:
(a) flooding would be controlled per FID rather than per port
(b) egress flooding towards a certain port can be controlled
    independently depending on the actual port ingress port, rather than
    globally, regardless of ingress port

When (a) does not hold true, the bridge will force the port to keep host
flooding enabled, even if this is not otherwise needed (there is no
station behind a "foreign interface" that requires software forwarding;
the only packets sent by the accelerator to the CPU are for termination
purposes).

When (b) does not hold true, it means that a 4-port switch where 1 port
is standalone and 3 are bridged (again with no foreign interface) will
have host flooding enabled for all 4 ports (including the standalone
port, because the bridge is keeping host flooding enabled, and all ports
are serviced by the same CPU port).

Since DSA is a framework and not just a driver for a single device,
these nonidealities do hold true, and the bridge unnecessarily setting
IFF_PROMISC on its ports is a real roadblock towards disabling host
flooding in practical scenarios.

The proposed solution is to make the bridge driver stop touching port
promiscuity for offloaded switchdev ports, and let them manage
promiscuity by themselves as they see fit. It can achieve this by
looking at net_bridge_port :: offload_count, which is updated
voluntarily by switchdev drivers using switchdev_bridge_port_offload().

br_manage_promisc() is already called by nbp_update_port_count() on a
port join/leave, and the implicit assumption is that
switchdev_bridge_port_offload() has already been called by that time
(from netdev_master_upper_dev_link).

[1] https://www.youtube.com/watch?v=B1HhxEcU7Jg

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c | 63 ++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 55f47cadb114..6ac5313e1cb8 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -135,34 +135,49 @@ static void br_port_clear_promisc(struct net_bridge_port *p)
 void br_manage_promisc(struct net_bridge *br)
 {
 	struct net_bridge_port *p;
-	bool set_all = false;
-
-	/* If vlan filtering is disabled or bridge interface is placed
-	 * into promiscuous mode, place all ports in promiscuous mode.
-	 */
-	if ((br->dev->flags & IFF_PROMISC) || !br_vlan_enabled(br->dev))
-		set_all = true;
 
 	list_for_each_entry(p, &br->port_list, list) {
-		if (set_all) {
+		/* Offloaded ports have a separate address database for
+		 * forwarding, which is managed through switchdev and not
+		 * through dev_uc_add(), so the promiscuous concept makes no
+		 * sense for them. Avoid updating promiscuity in that case.
+		 */
+		if (p->offload_count) {
+			br_port_clear_promisc(p);
+			continue;
+		}
+
+		/* If bridge is promiscuous, unconditionally place all ports
+		 * in promiscuous mode too. This allows the bridge device to
+		 * locally receive all unknown traffic.
+		 */
+		if (br->dev->flags & IFF_PROMISC) {
+			br_port_set_promisc(p);
+			continue;
+		}
+
+		/* If vlan filtering is disabled, place all ports in
+		 * promiscuous mode.
+		 */
+		if (!br_vlan_enabled(br->dev)) {
 			br_port_set_promisc(p);
-		} else {
-			/* If the number of auto-ports is <= 1, then all other
-			 * ports will have their output configuration
-			 * statically specified through fdbs.  Since ingress
-			 * on the auto-port becomes forwarding/egress to other
-			 * ports and egress configuration is statically known,
-			 * we can say that ingress configuration of the
-			 * auto-port is also statically known.
-			 * This lets us disable promiscuous mode and write
-			 * this config to hw.
-			 */
-			if (br->auto_cnt == 0 ||
-			    (br->auto_cnt == 1 && br_auto_port(p)))
-				br_port_clear_promisc(p);
-			else
-				br_port_set_promisc(p);
+			continue;
 		}
+
+		/* If the number of auto-ports is <= 1, then all other ports
+		 * will have their output configuration statically specified
+		 * through fdbs. Since ingress on the auto-port becomes
+		 * forwarding/egress to other ports and egress configuration is
+		 * statically known, we can say that ingress configuration of
+		 * the auto-port is also statically known.
+		 * This lets us disable promiscuous mode and write this config
+		 * to hw.
+		 */
+		if (br->auto_cnt == 0 ||
+		    (br->auto_cnt == 1 && br_auto_port(p)))
+			br_port_clear_promisc(p);
+		else
+			br_port_set_promisc(p);
 	}
 }
 
-- 
2.25.1

