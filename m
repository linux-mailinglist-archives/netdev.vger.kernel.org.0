Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6616A2D8AFB
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgLMCmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:42:16 -0500
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:19174
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727663AbgLMCmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:42:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJUGHQToY6gL6OW1x8Bpy1xC0WGFCTAuzo3wTlPxcnJNiy9/7HNSXMVrU5EoNSZz6eSsMzttjIMBBbHMR88UcoZljQw6C0MApfq7TSc2qfn0Dar7wUF4/oh2V72Fxvy2s/SPU2ZFn0YfPbQtBDR6IRAnzEwqUpcAbqG+an34A+MbMm081nm8zCR+xnOdmRr9uLnNEfPq24TzCS3+t4iZxFxw0jCBejT93X95KTPlAVCOeuwonAjr0lLTMhxPp+B6r9aaoyB9yIGIZQLGa1w+X73dA4pfGiEiMO+wj6iGPJVDQu9Eo9qeV3vsn2xOeMneYN3ec8ru/gtV5qZuk/XAZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8muWUzRgqnVz4j2BlJwsieABk8Lj+UqAR0w2oRjYCM=;
 b=IlaQDL+489BK92k/u4dQ8zGbffQ00H7Fx+KNK0i/1YmVhvi8r2fiT1O6KfYRIRW1xtegIz5/xIExTPGgtq2c3Q3H6crReLyThFYnO3aQVMLhPPkc/wxyt5yiunD3bPCrqZqiaqYvw27rHmuCoGw93jfeM8ihNoIS2h4BvsikNPA1KyY00CQCG2DErjNmGWe+n/9SvO3JPUBf/6onVUw2zHMin9FRVR0nqVGrzHiRYoQDD4SLJyasRcdzcQkEX1MMSQySJ4aumombNi1jkk3EhchfIkYf1yWaTcPrnSIMD8/OInuOp/U2RSpUO0QhrO4CUZxyNRiCW1teVYKRT85e2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8muWUzRgqnVz4j2BlJwsieABk8Lj+UqAR0w2oRjYCM=;
 b=aWWNw4DLyCoLwYd86I6YuRTwJGCOwEX7j9gT557BGGrxnWayqdzcYek7chPhLN0HeUO47YDCCcFCEesszq8EjJWbp7OKrv2HkSloMjjX6CfSJEiKv62tOkBr8xrl2l/SVlwSZ3K4mIBsqar74htvQ65BODF95T7grrgVq14h0S0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of disappearance of old FDB entry upon migration
Date:   Sun, 13 Dec 2020 04:40:13 +0200
Message-Id: <20201213024018.772586-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213024018.772586-1-vladimir.oltean@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5bacbf7c-7fb3-471e-9147-08d89f10893d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407AEAEFA4B975045F55C7AE0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+208McN7ZAIEvj2Z31Zj5Qx+lz+E+jICfd5FlEtfD+zHcELj8UcjhOmzPVt1hrW2TtRyW+rXuiVmfok1v2PRQwDI64sQD5yarvjAVyBBDqXHNnq3zkPo5cfB6nEYgDIKnLTttfaqhKAMCP/9fPPJRh5cPI7YLvXmglhwOYyNitetoeR8jXnEUemJW/NguHa3hPvSUyIF4evBYU+H0sihHDSF1EIOT5yrB40W7ZHQcKK/fL96C3iR3mN3/q/ra2CxLqfHhqZ+623myNrcqXoJZd411E07kww0Hng5UlAAmHtnku3GLXWDbiPRaWceRisTs1zYpM3UVSAXifWawqaGHGOX1//BOURYHd02gl3S4bbW2tEwYzvV7HBKJtcLHMJCdtTKWaHQC/wdOZ7dHbVrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uNl6eHh/AcvfstfIJ7mnpCE7EnvlkmJsf+N+IgIKCvJPqLeMqduvPCmHyXhJ?=
 =?us-ascii?Q?lFvwrzwGt1TeMHtqU6HLOO39I0nnuAOxsy2WK7UXwOnmQ0s8ov9LAzxYLrQo?=
 =?us-ascii?Q?UZCgufx2NVTLu8PlHCz8F1nuTvqpuEjyRJ+6YtTUgFS1tcBN2jrtQDA2jo/O?=
 =?us-ascii?Q?vor5sLitDX5oniNn4cCXf0G+hhtMIumoLIVzwD7AgozcVL0Eejp+0J64rYLC?=
 =?us-ascii?Q?RlWja2ImtwR7fu3/HTkq9htNIdmcrJRcosOiYa9g/zdnAVBlqjcVI6IpEJoH?=
 =?us-ascii?Q?zI46zexKT6cnGQuTYj6bZ0z+9WrdOEduBW+lSA16QVYbxB+ozHrYcigHa9mJ?=
 =?us-ascii?Q?eQEthhyOGtMJ0Gty9S1VLEmCi3q5TTNMWbCrGfv/wjHqy0yiA3DQlv4Kz243?=
 =?us-ascii?Q?YeDLKna780OdN7JeeP+7QOHycRewmFqrSIPY2kvvlalkE6W1bh+iCo4Tb1c5?=
 =?us-ascii?Q?Fz+JYLT2Vxa/D4ZSPPuxYRWbIO74+PZ742lWYP9ho/XV2mvD88LdhDH0MEiB?=
 =?us-ascii?Q?i2GPHWRmVaVBIZ/bW9+Y1GjhpamFuZ31gatqkUj1h/GBMyChLyBw0AudG5mv?=
 =?us-ascii?Q?IjAyHO7Shcj/LCJr9u8AhujZe2lTBblB6qEhBxQACjDWS1gZABVA5lbhyZAs?=
 =?us-ascii?Q?SQy06idE7szuz+TFCTXt0Re1HZErnTEzl0F8pSbn3+6tAl4PgW15y9lOTbG7?=
 =?us-ascii?Q?Ctia5oD+Z/gfxBxvpW2KalV0c3IKH5hlCMyo/fu1iK40Oct1D3QElTp23itH?=
 =?us-ascii?Q?C0L1sSQZJOiXAhhglLlO+G+xF9tMYNXPhtg4YbQkQJujaW7fu/3Zc/LxgCvN?=
 =?us-ascii?Q?Hqhy8Fr6oE2+PTZXTZbMzrHq36E/+E+XgNZQXQyRpPKpSmr+QryN6vMFaFfj?=
 =?us-ascii?Q?qVn97lDjrhHYC8MLwbGHkA1f2giv1gLOnq6Yl1Dw4S88uDjVa1hnwKrRGV5K?=
 =?us-ascii?Q?CEulQKVovcaLHTp2BgszUw4NlW3NcJ0LLaJCB8Cmn50l4YYAbktoBkkrvj6e?=
 =?us-ascii?Q?wqkf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:03.6785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bacbf7c-7fb3-471e-9147-08d89f10893d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jQXrv09dHR51aBlDLSUREgwK5hIAN1GMKxHrojmLeCyQBCuhdo3nLVN4C/6iosJMnQTLQRb23VGjSTJtbbzOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the bridge emits atomic switchdev notifications for
dynamically learnt FDB entries. Monitoring these notifications works
wonders for switchdev drivers that want to keep their hardware FDB in
sync with the bridge's FDB.

For example station A wants to talk to station B in the diagram below,
and we are concerned with the behavior of the bridge on the DUT device:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
                                  |
                              Station B

Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
the following property: frames injected from its control interface bypass
the internal address analyzer logic, and therefore, this hardware does
not learn from the source address of packets transmitted by the network
stack through it. So, since bridging between eth0 (where Station B is
attached) and swp0 (where Station A is attached) is done in software,
the switchdev hardware will never learn the source address of Station B.
So the traffic towards that destination will be treated as unknown, i.e.
flooded.

This is where the bridge notifications come in handy. When br0 on the
DUT sees frames with Station B's MAC address on eth0, the switchdev
driver gets these notifications and can install a rule to send frames
towards Station B's address that are incoming from swp0, swp1, swp2,
only towards the control interface. This is all switchdev driver private
business, which the notification makes possible.

All is fine until someone unplugs Station B's cable and moves it to the
other switch:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
               |
           Station B

Luckily for the use cases we care about, Station B is noisy enough that
the DUT hears it (on swp1 this time). swp1 receives the frames and
delivers them to the bridge, who enters the unlikely path in br_fdb_update
of updating an existing entry. It moves the entry in the software bridge
to swp1 and emits an addition notification towards that.

As far as the switchdev driver is concerned, all that it needs to ensure
is that traffic between Station A and Station B is not forever broken.
If it does nothing, then the stale rule to send frames for Station B
towards the control interface remains in place. But Station B is no
longer reachable via the control interface, but via a port that can
offload the bridge port learning attribute. It's just that the port is
prevented from learning this address, since the rule overrides FDB
updates. So the rule needs to go. The question is via what mechanism.

It sure would be possible for this switchdev driver to keep track of all
addresses which are sent to the control interface, and then also listen
for bridge notifier events on its own ports, searching for the ones that
have a MAC address which was previously sent to the control interface.
But this is cumbersome and inefficient. Instead, with one small change,
the bridge could notify of the address deletion from the old port, in a
symmetrical manner with how it did for the insertion. Then the switchdev
driver would not be required to monitor learn/forget events for its own
ports. It could just delete the rule towards the control interface upon
bridge entry migration. This would make hardware address learning be
possible again. Then it would take a few more packets until the hardware
and software FDB would be in sync again.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 net/bridge/br_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 32ac8343b0ba..b7490237f3fc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -602,6 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
+				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-- 
2.25.1

