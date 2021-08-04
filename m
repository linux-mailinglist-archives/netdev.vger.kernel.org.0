Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64073E0285
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhHDNzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:47 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238540AbhHDNzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hM+Q3CFPXmT4atd2vCpBoTK0jQBOUqpsvX4SepLsGsEiTkSKA9WAkSxR2IZAHz/GNvl872+RFR/pcAIPS6kjZw1cwOmVGdKnIoZTlCeawd1uq+Sis4qy5y5M5Yp3GalV3526TJ/ty79M48s2FoTB3ELqNftl5OFCy50EEcywaSzT22FgRplkTVIaOwasEqRx51byRLqnRBtQoBW5gWTCcb81ReB8zjihYyTkuUAU7SKOp89wkGSak3zy7lFPspVMsRJ5PbCe0m16kKY9aitrhDfFbQGkEgnXKe7cqWpozEQaFlN9wEmoXrVx9xpVBthlMq55IMReRwq0QPMp+0FHHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TuMvmJH7L+Vlds5rFAsFSG1+pHMWI8Fb91zoNxYNiQ=;
 b=TId0wJD0lvL8UOpdAyiTRPRTzgkdSakmVF4j+E2nXJSfSFyPncfWVqSiIPgvtFjIRXG6o0jEaDPQFG56wme9d3+juFN4bMxfzDLgL6PVBi3PKPADi6HnaxHHkVVHc3Nx6VAVdZZv8TZz7B/xditAiSSeKj+WrP8Z5xWna47tp1CNIpMzuyt1Bh+F4nogzr234O6+lcWrHUj5KY5auB8ENtZeXc8+Qf5/FB2m7x55G2klv7+7yeXHf7qIkwoK6NV/4TAnq/Xu1S3rxB4bz5WZtOFc2SMwp6DwOgfoWJy5gzlkcnmSliQLTf0kT6X89+etuL229hk5OsvP8bf8gKzEdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TuMvmJH7L+Vlds5rFAsFSG1+pHMWI8Fb91zoNxYNiQ=;
 b=j1rsvBU6SeF4lSLoDfyClB9BJIU9zK3b0Fhqlte6KfDB/P5bxqpEQu0o59rIxujcwh3oyN2eFR8CH8CEhynIOHU78WsIUrchd2I0wsp2V02DfpUdsE4H3kl4MmOGW/VhtZNGEueyYGuFx61d2/H/qmd1v8GKfHfDCDXbup3nNGw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 7/8] net: dsa: sja1105: suppress TX packets from looping back in "H" topologies
Date:   Wed,  4 Aug 2021 16:54:35 +0300
Message-Id: <20210804135436.1741856-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b48825ec-24ea-46ef-66b2-08d9574f7bb2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26878D10D296D164D6130FDEE0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8S8EvQXyLfWmzryOxTGT7EB1QFT3qeaEBqNx2/8a8p07PI4gbOXPu8GYP6zCXieMd/EYp9E2YCs+0tQfRxfDmxxsf0eZ0MRTGNLJReiiuja41V+5k1pWXLjE5t8L8Il50LUafuc6pfdhk+PmzLRp35AQzlDuF9XyMrSmEkhyZU3jPvAEceblQQ77Y3wFf+4K6NIbAbXijBLwSdxSf1XmVYI16Bs5LTd0S2KpHoyu7XuHmYkZUWxLot7q084pnpd+xndqxh9hwCbqr7kyfRofeUEsqQneZSOxe87CAUxDe9Sn3z0mf81jJWFP0tX9yQ/sT2YQNomD/fg3GnmoDUq6f++jOFAoQDqifk8kUuByCVri1JKmpFsT9/CYwHr+XWMr9j1HfxMZUIWGHATf/7C7+ATl1x5V9sZjBc2QU4g9TkKWUn2JC+ou/Qz6ToLI/V6Ffz5vOq2FMjfd0YN0V06XIOaNiBi/b94B8kjv/7JEkw97Wh1tZr5FnCkCRNkgYG0RkTyMCl3PhpOyH5d0BqAMxz7ZQWL3023y3AOaSLKLwWb75ckDDsTQEyH1kW/L6horlcZYhp9UkJMcj+4zQRbfLRiJDfUvQ5aiVrMPcls93KPRklfa5kpUKnfGk1+4bbQg7oQfdPK56kBZi59e8kkA/v9kX7ZGbhft4C0WpHpl1+A/NpR5fL/OH/0cnu+D19aFx8TZhat6W0Ur1jcTcAaQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OY0Sd4bUiFNGJdvzU9+rpfS7DmCFpwJ8lSoUs5DCnhzHKX25BhydTHXt8QWt?=
 =?us-ascii?Q?JKHVcX7DzHEkcXNg0BNZcjrmUmLhCTIIuCLrVDAORA0MxkXuZxURUP5LWpfP?=
 =?us-ascii?Q?vRrG4ntOVMzU2DXFKwahqjve0fbGKtDyw3Y4VAg+KFhz+CcH1PPVSEugJxq9?=
 =?us-ascii?Q?dU6iztTSky5y2xYf5kYUvJSa2roUdh1EB5mHlUCYjvu6ZRoidvSY45tBlXvX?=
 =?us-ascii?Q?zj+dg2i9Uv2G4PJpHHHAghDpdCovu+7Scs4gsB3miYYR6KYb5JLppbwLomX6?=
 =?us-ascii?Q?93rwd2I8Ono/QJpCpwk63H4W99QKqe7j46/T8gZNRfYF2hW+aOiT09AG9ooX?=
 =?us-ascii?Q?H2b33MUJr66MCJAOZVoLKWshtfQ8HAH1qUiaLuaT4a8bKUo2StVirkGcDxMW?=
 =?us-ascii?Q?rrwDZTxRNqMt7PDlZkye1wL7fYeo5iTNHqs5F1F9QxqZ7qC/5wW/bHlIHfhQ?=
 =?us-ascii?Q?n5WKcIwYwbzKxjOlNupCTrdmiZzg2oGWJjxMjEBd4MExOy9G1N51dkqQED/b?=
 =?us-ascii?Q?4KWeTafqs+CB4oVZz/gvs1JYE4kMxjyFbm6SIRfUHZ53xhn4dawPsGTa7zUB?=
 =?us-ascii?Q?M9jGMbVBeIhI2eCoN3m/+/8uMisuHMRhwWgoXsEIYwNYWYlfOVEcTH7d73nn?=
 =?us-ascii?Q?m0RhExi+Hfy9beRUU9tagEHPoKHJu9ylwP6Ahz779Z8pJ3W0RJayvhkfReK9?=
 =?us-ascii?Q?xAOp2AGQVvyFs0AI4bGJmBj5L2QG6kWG7qYOhVfaNVR2jURgMm2UmrjqkPhc?=
 =?us-ascii?Q?oE2CmbQW4E1OU7cOyL9EnaUPkGjNIUQZG74FkO+jFWagmhSEvv8X7b/s7iY7?=
 =?us-ascii?Q?NfJcWOzG41jOFB1mLDF38+wjdPEn14u9vTJDhEni3myUVPXEswunlyDHpbxL?=
 =?us-ascii?Q?2IZzwKqK6KSARr4XLlpmu/GCvwLrKIM/W+ZCM/VMsBev42f4i8SRNteJmyOv?=
 =?us-ascii?Q?1pOeEvPQR55rmoRzsaz96BWwQNbzO91xHUPad1VABcYyzLzLh/7DS62Vvk3U?=
 =?us-ascii?Q?I+E7g2Z6WnASourK1UzuDprW61uTO4JSeAU2YF/phB6Cy78Cisg1yMnbxaNk?=
 =?us-ascii?Q?HeF7BAiZaWpgdtGnJ1JoguVFWIAvYAUD9BM7Pd7r5byIjFmQbwUi3nYD3hhI?=
 =?us-ascii?Q?BMkiUd4lOX2gHSrpRQgiHeO6H/982lljSHnJDATshPIOVhTcSGcTgXZIxayd?=
 =?us-ascii?Q?G4qyS/AGFZkQcMMaIkmcYsiqHWtVCetJR2sc+pbwe1Zycs59ci7QaL9MR41b?=
 =?us-ascii?Q?ng4inxCCl3XxJA1+C3X9YuK7BIT/8GCGtOR1t9nDFFm+yMuh/RzspxZ6y7hG?=
 =?us-ascii?Q?hRpgTPAib3i9/PbAsmpT8j7V?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48825ec-24ea-46ef-66b2-08d9574f7bb2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:14.0627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVHDu97/5oVm0jwUn1H5u6h2mceBXiBCkdNodOJhYHCPkg95tsQUrgSrrcrDMvANiFLOC9DRX6yNIBGrMYcToA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

H topologies like this one have a problem:

         eth0                                                     eth1
          |                                                        |
       CPU port                                                CPU port
          |                        DSA link                        |
 sw0p0  sw0p1  sw0p2  sw0p3  sw0p4 -------- sw1p4  sw1p3  sw1p2  sw1p1  sw1p0
   |             |      |                            |      |             |
 user          user   user                         user   user          user
 port          port   port                         port   port          port

Basically any packet sent by the eth0 DSA master can be flooded on the
interconnecting DSA link sw0p4 <-> sw1p4 and it will be received by the
eth1 DSA master too. Basically we are talking to ourselves.

In VLAN-unaware mode, these packets are encoded using a tag_8021q TX
VLAN, which dsa_8021q_rcv() rightfully cannot decode and complains.
Whereas in VLAN-aware mode, the packets are encoded with a bridge VLAN
which _can_ be decoded by the tagger running on eth1, so it will attempt
to reinject that packet into the network stack (the bridge, if there is
any port under eth1 that is under a bridge). In the case where the ports
under eth1 are under the same cross-chip bridge as the ports under eth0,
the TX packets will even be learned as RX packets. The only thing that
will prevent loops with the software bridging path, and therefore
disaster, is that the source port and the destination port are in the
same hardware domain, and the bridge will receive packets from the
driver with skb->offload_fwd_mark = true and will not forward between
the two.

The proper solution to this problem is to detect H topologies and
enforce that all packets are received through the local switch and we do
not attempt to receive packets on our CPU port from switches that have
their own. This is a viable solution which works thanks to the fact that
MAC addresses which should be filtered towards the host are installed by
DSA as static MAC addresses towards the CPU port of each switch.

TX from a CPU port towards the DSA port continues to be allowed, this is
because sja1105 supports bridge TX forwarding offload, and the skb->dev
used initially for xmit does not have any direct correlation with where
the station that will respond to that packet is connected. It may very
well happen that when we send a ping through a br0 interface that spans
all switch ports, the xmit packet will exit the system through a DSA
switch interface under eth1 (say sw1p2), but the destination station is
connected to a switch port under eth0, like sw0p0. So the switch under
eth1 needs to communicate on TX with the switch under eth0. The
response, however, will not follow the same path, but instead, this
patch enforces that the response is sent by the first switch directly to
its DSA master which is eth0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fffcaef6b148..b3b5ae3ef408 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -474,7 +474,9 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_entry *l2fwd;
 	struct dsa_switch *ds = priv->ds;
+	struct dsa_switch_tree *dst;
 	struct sja1105_table *table;
+	struct dsa_link *dl;
 	int port, tc;
 	int from, to;
 
@@ -547,6 +549,33 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		}
 	}
 
+	/* In odd topologies ("H" connections where there is a DSA link to
+	 * another switch which also has its own CPU port), TX packets can loop
+	 * back into the system (they are flooded from CPU port 1 to the DSA
+	 * link, and from there to CPU port 2). Prevent this from happening by
+	 * cutting RX from DSA links towards our CPU port, if the remote switch
+	 * has its own CPU port and therefore doesn't need ours for network
+	 * stack termination.
+	 */
+	dst = ds->dst;
+
+	list_for_each_entry(dl, &dst->rtable, list) {
+		if (dl->dp->ds != ds || dl->link_dp->cpu_dp == dl->dp->cpu_dp)
+			continue;
+
+		from = dl->dp->index;
+		to = dsa_upstream_port(ds, from);
+
+		dev_warn(ds->dev,
+			 "H topology detected, cutting RX from DSA link %d to CPU port %d to prevent TX packet loops\n",
+			 from, to);
+
+		sja1105_port_allow_traffic(l2fwd, from, to, false);
+
+		l2fwd[from].bc_domain &= ~BIT(to);
+		l2fwd[from].fl_domain &= ~BIT(to);
+	}
+
 	/* Finally, manage the egress flooding domain. All ports start up with
 	 * flooding enabled, including the CPU port and DSA links.
 	 */
-- 
2.25.1

