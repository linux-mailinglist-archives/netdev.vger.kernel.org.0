Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5796CECA9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjC2PTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjC2PTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:19:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C2146AC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exMLXdGfbCBCK/d723nYhzBJfUXjP1QWUUm+VTmRcqKlnh+g1UB7bEqC18pcx9p2L3iAJ5HqPHQgRhFp6Og/9Ywyp5L4orbMiYSky5MxDSUtwM9DTHNDUoWfdYJgLZw59/sweXP80xBDocnhzhCO3RgwByk883qbGP2bnZGzXB98mX969XEFc5sDokgQ4MSgV9g/4IkN8hLh62zxgO5KiEwHtAazaonhPbuiQa5jQ79vRr0D2/v6v/M+iHEi//UgtqWe7a6QPyrYkTsM3pEnFQ68zmGwD0GIsU6o/FCzpi7R4PiL1MFoKWqqdt0yB6EHU4dJP1b+l7lIEBKc3lPtyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTeh17rRYSLyK97Qr1ZAx1Pr1egOywNN7DB5Bvdn2RA=;
 b=h0OKLHAi7AfuALz59APhiChh+hIr6TmxBqr0XAgZXu/AaNYQPKx7WwTFnyYC+ocyZj/T6XnXDPztyHcXejXOzb6XWNxkiEOSCmfmcnfbcJsYjAUq9fNHpw1gShym0kF3sN0xV5tL6ZJtsC9PylvcjXdFcr8Z3fZ7rj0XE0GcfaV76Ngt7d8FezgPLl4RX/8m15bR1KrGcAEL0PbdQL41mPlK4UmfGVxTsUHVCRIOzuD9p3xebWrJ5/Ou2vFBCRO2xEqi2d/5ksYwmuDID5iLTtr7AoOxLfLXl8YHI4iPWhN3aLwhlGWIGGcgbgYfkezNGLcZQ2pqYUP8LVKInDEJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTeh17rRYSLyK97Qr1ZAx1Pr1egOywNN7DB5Bvdn2RA=;
 b=YHe2YqC2JsftogHBWyjPtwQFUFcxdFScPvkpw4DyicjHBJLiqSEoMQPCIipCt8QAnsCtYtxApUgom4mh4e32oiUu0Xvo1M648u0Wo45Tr23PfjIuWgqAVbHjPfr3lEas0kf7pLkPJtwPYdfmatS48twihtSzR1z+GZpyq0vm6wE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8342.eurprd04.prod.outlook.com (2603:10a6:20b:3fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 15:18:51 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 15:18:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] net: dsa: sync unicast and multicast addresses for VLAN filters too
Date:   Wed, 29 Mar 2023 18:18:21 +0300
Message-Id: <20230329151821.745752-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0144.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8342:EE_
X-MS-Office365-Filtering-Correlation-Id: af01e9a7-a63a-4400-6b2e-08db3068e70c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSNejpjJZAXjnunp10CUVhn4prGOnhI9PwFR5V69Rc38mFETtXJEOrtOPwAsKh97d52zlhREE4DoNiBji5qywEFDHHs1tbWk8V6YINnfDSt8KBYQOYHNT2t60B/bE3OLSCrVOpF9ozICL+AzrB7LFw8h5DEojp1Ppvl/e+IO8B7j42IfHcBCHjvX97Q4UZep2V/ymW51mko+54aKFZDK2W+bf53J01J6cT9K2/hdiPlu1wScNyZm6gfOnQVF6M8IBBY26nsKneuX9fW9uz6664gjfIQkkwxKGZ5rTs8mvmDHbbfK4kvxmpmkS/U9bPHSx8LxuvgP9AnVIJK8R1bJGdGOclFgJ21O1zL6MI3zxXaOIOpa1fi2TMNZ/ds51dA8vkf9BG8UZCs4kH3sLrNdJNmcRuYpV6XLgUsZ9+owd3IA4iRZ6JpWJqU0N11nK8PF3/mouMJCc7ECCtdu+2cV8HnKoe/zpFUlug0GYkxuDcY7eOrnq+vYqCWBQWwRKqbCBaetnJF2A+K4WAkak59NhBKFeJ+7Mewot0VQNhNhIgdvfxr2dGOhtB2tFBjfMZ9npqbfrBb4uIxDJMNQLy8cZyutq1GgAj2vBWN7+RP55THsllIogmyd2dSh5iA2Skgs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199021)(6666004)(6506007)(26005)(1076003)(6486002)(38350700002)(38100700002)(2616005)(44832011)(186003)(2906002)(5660300002)(8936002)(6512007)(54906003)(36756003)(478600001)(316002)(52116002)(41300700001)(6916009)(4326008)(86362001)(8676002)(66946007)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/2W/jw/wsnXCumBDWyh9lT2uMx3wfpHz7qYZMjRTfhyV68PFJEEiNQnMOhr?=
 =?us-ascii?Q?JIu6wZDg4v8zEZfZ4qOZGFJVp0Gqd9wkqpaz8OXSqsZ1zXq5NEpSIagbtUkU?=
 =?us-ascii?Q?zFUQB5pBGMsI9NQhJinXD/bFrlPpv+OPuUGnuxNor0OsTaFK6pmx/sKxbxW7?=
 =?us-ascii?Q?OqA6vb1SXjVwv/3vUb1N25kjSRTW3jZ1dSX8Q31Ctxnl2LGyf5Iwck+jxMes?=
 =?us-ascii?Q?myZMELxtb/W9GekYhkWSqzI11AkMdYw2ROD3lLUCaTApv2+bHJ02lS/xDXGn?=
 =?us-ascii?Q?J4iRBEP+LRT1ObhIcmqkubgPz1gPRYCYrJh4EEkUrRCwNSTd4p4zcMyzPhXF?=
 =?us-ascii?Q?9ibeL4C4mBThNHsE0RUED/cMb7wjGTzgGl/3thgYhnvbGoHHv6tA92hspG6i?=
 =?us-ascii?Q?ao7m51x6klnf2tHrw/EEfyJNC3+dEyen/mP60bjNcNrtZZUIL+OwwvgLFi68?=
 =?us-ascii?Q?zuwoUmEqbvWo5XnXLmnfUfomSUTWpvC+lgabS6PogHq7SaT+YI75XrDfdAt+?=
 =?us-ascii?Q?wgs5kp6Ulyl0l1222g2mr1xhpK3X7Cd9PT9fPNh5O/V2OHdkKekYCbrAu5F3?=
 =?us-ascii?Q?C0G1deIGRtInnDovtulerbS7r+ObqsCox3hvTb3endzSEI6PxKJpDlbR3U8i?=
 =?us-ascii?Q?1b90Yja/mrU5D+S4YG8dDqvBuIyrXsJk8PbOcEE6OY5ygmaDBqvna/ygvOjn?=
 =?us-ascii?Q?o+KhGsJpWbg7NuTTPVJ9QREg9IFgkJdgej+i29ADiDcTOg/IHzt8DcCHNOUi?=
 =?us-ascii?Q?42p1scQyeVZcc2FbbCQE99qz2SEgpAoyZyj9r2HGDNZ38wPu5r9FlbedVlJd?=
 =?us-ascii?Q?4ZzO5T1MWYctnfeI/xTQmPyucmPL/2ZmfEtjHnZEwerLa4y9OeumtEHhBtAp?=
 =?us-ascii?Q?ZEqRJ3TosEf1lIK4C38WchjenMJDDR5x0UVwUrdIpkZ4/EvPRNlixNXrdXc5?=
 =?us-ascii?Q?dLhLAThRK7AT69nitrKyoFc0d575PwaZ6WhuSVgsHI4NdHrsb+xNAItcQHCH?=
 =?us-ascii?Q?As1ueIP/KUtPOkYr43jh5/0xkghB7s5pnTco9fTrhXcKwKnLKFAqORXgjvHH?=
 =?us-ascii?Q?ogHLtlnc9DU9fJQY0XK1Aq+HrEptV6yRCImB9W4WynidumrGIuJyUkxZ9iv6?=
 =?us-ascii?Q?xJuLXE8ewVLYa+2JMCgjrMu2wC0mcpvOdK+TKnPIwUtTiw367mqa1lDzOhAp?=
 =?us-ascii?Q?6aeNM9SeWnxlUqpYmBVPYIxlp6cvplBYdMkElp4qFCJ4y0vi6FIFRwW2sygF?=
 =?us-ascii?Q?sVCMpdWjBrkvE2cE8xgMQqesOqU8Me0m5ybROJie86pAgjPkXP0PJggg0aZH?=
 =?us-ascii?Q?3JzObptah14Bb9NdOrHjZSglNHKQPpRkHslEZT/XT6FVuO/Fbww7/TPLmcE2?=
 =?us-ascii?Q?NyXH1SHpdqCO654xYvLYZ0EIcW1vGdEgOyakoomX29skEQtMptZ2MeYzqotB?=
 =?us-ascii?Q?bAoFRx99x7XcPtjPOF2PkYtIpe/PbJYQrP2Na6GmjXF/u8ZJAFSPX7dLjNr4?=
 =?us-ascii?Q?kcmwHah3hPno4T01zFDNTGm2xAwoeiF5V4xeQ7XSW6nmu15St4G/a/wrcq5a?=
 =?us-ascii?Q?14t2WtcFyyk6rPx/iAwO/wfEqN3i5QZucoNltoaoKYj8Z5S1c8k85mlo1xnS?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af01e9a7-a63a-4400-6b2e-08db3068e70c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 15:18:51.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYshDox0A39YDp52sUc1Hu5PDJuXGIVkKebeLrVz+B5LVhBigoqTwlrdIrhAL+K+kYP6Wt1rBFV7mqS3w/+LWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8342
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If certain conditions are met, DSA can install all necessary MAC
addresses on the CPU ports as FDB entries and disable flooding towards
the CPU (we call this RX filtering).

There is one corner case where this does not work.

ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
ip link set swp0 master br0 && ip link set swp0 up
ip link add link swp0 name swp0.100 type vlan id 100
ip link set swp0.100 up && ip addr add 192.168.100.1/24 dev swp0.100

Traffic through swp0.100 is broken, because the bridge turns on VLAN
filtering in the swp0 port (causing RX packets to be classified to the
FDB database corresponding to the VID from their 802.1Q header), and
although the 8021q module does call dev_uc_add() towards the real
device, that API is VLAN-unaware, so it only contains the MAC address,
not the VID; and DSA's current implementation of ndo_set_rx_mode() is
only for VID 0 (corresponding to FDB entries which are installed in an
FDB database which is only hit when the port is VLAN-unaware).

It's interesting to understand why the bridge does not turn on
IFF_PROMISC for its swp0 bridge port, and it may appear at first glance
that this is a regression caused by the logic in commit 2796d0c648c9
("bridge: Automatically manage port promiscuous mode."). After all,
a bridge port needs to have IFF_PROMISC by its very nature - it needs to
receive and forward frames with a MAC DA different from the bridge
ports' MAC addresses.

While that may be true, when the bridge is VLAN-aware *and* it has a
single port, there is no real reason to enable promiscuity even if that
is an automatic port, with flooding and learning (there is nowhere for
packets to go except to the BR_FDB_LOCAL entries), and this is how the
corner case appears. Adding a second automatic interface to the bridge
would make swp0 promisc as well, and would mask the corner case.

Given the dev_uc_add() / ndo_set_rx_mode() API is what it is (it doesn't
pass a VLAN ID), the only way to address that problem is to install host
FDB entries for the cartesian product of RX filtering MAC addresses and
VLAN RX filters.

Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index cac17183589f..165bb2cb8431 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -57,6 +57,12 @@ struct dsa_standalone_event_work {
 	u16 vid;
 };
 
+struct dsa_host_vlan_rx_filtering_ctx {
+	struct net_device *dev;
+	const unsigned char *addr;
+	enum dsa_standalone_event event;
+};
+
 static bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
 {
 	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
@@ -155,18 +161,37 @@ static int dsa_slave_schedule_standalone_work(struct net_device *dev,
 	return 0;
 }
 
+static int dsa_slave_host_vlan_rx_filtering(struct net_device *vdev, int vid,
+					    void *arg)
+{
+	struct dsa_host_vlan_rx_filtering_ctx *ctx = arg;
+
+	return dsa_slave_schedule_standalone_work(ctx->dev, ctx->event,
+						  ctx->addr, vid);
+}
+
 static int dsa_slave_sync_uc(struct net_device *dev,
 			     const unsigned char *addr)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_UC_ADD,
+	};
+	int err;
 
 	dev_uc_add(master, addr);
 
 	if (!dsa_switch_supports_uc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_unsync_uc(struct net_device *dev,
@@ -174,13 +199,23 @@ static int dsa_slave_unsync_uc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_UC_DEL,
+	};
+	int err;
 
 	dev_uc_del(master, addr);
 
 	if (!dsa_switch_supports_uc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_sync_mc(struct net_device *dev,
@@ -188,13 +223,23 @@ static int dsa_slave_sync_mc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_MC_ADD,
+	};
+	int err;
 
 	dev_mc_add(master, addr);
 
 	if (!dsa_switch_supports_mc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 static int dsa_slave_unsync_mc(struct net_device *dev,
@@ -202,13 +247,23 @@ static int dsa_slave_unsync_mc(struct net_device *dev,
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_host_vlan_rx_filtering_ctx ctx = {
+		.dev = dev,
+		.addr = addr,
+		.event = DSA_MC_DEL,
+	};
+	int err;
 
 	dev_mc_del(master, addr);
 
 	if (!dsa_switch_supports_mc_filtering(dp->ds))
 		return 0;
 
-	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
+	err = dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
+	if (err)
+		return err;
+
+	return vlan_for_each(dev, dsa_slave_host_vlan_rx_filtering, &ctx);
 }
 
 void dsa_slave_sync_ha(struct net_device *dev)
@@ -1702,6 +1757,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		.flags = 0,
 	};
 	struct netlink_ext_ack extack = {0};
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
 	int ret;
 
 	/* User port... */
@@ -1721,6 +1778,30 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
+	if (!dsa_switch_supports_uc_filtering(ds) &&
+	    !dsa_switch_supports_mc_filtering(ds))
+		return 0;
+
+	netif_addr_lock_bh(dev);
+
+	if (dsa_switch_supports_mc_filtering(ds)) {
+		netdev_for_each_synced_mc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD,
+							   ha->addr, vid);
+		}
+	}
+
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		netdev_for_each_synced_uc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD,
+							   ha->addr, vid);
+		}
+	}
+
+	netif_addr_unlock_bh(dev);
+
+	dsa_flush_workqueue();
+
 	return 0;
 }
 
@@ -1733,13 +1814,43 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
 	int err;
 
 	err = dsa_port_vlan_del(dp, &vlan);
 	if (err)
 		return err;
 
-	return dsa_port_host_vlan_del(dp, &vlan);
+	err = dsa_port_host_vlan_del(dp, &vlan);
+	if (err)
+		return err;
+
+	if (!dsa_switch_supports_uc_filtering(ds) &&
+	    !dsa_switch_supports_mc_filtering(ds))
+		return 0;
+
+	netif_addr_lock_bh(dev);
+
+	if (dsa_switch_supports_mc_filtering(ds)) {
+		netdev_for_each_synced_mc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL,
+							   ha->addr, vid);
+		}
+	}
+
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		netdev_for_each_synced_uc_addr(ha, dev) {
+			dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL,
+							   ha->addr, vid);
+		}
+	}
+
+	netif_addr_unlock_bh(dev);
+
+	dsa_flush_workqueue();
+
+	return 0;
 }
 
 static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
-- 
2.34.1

