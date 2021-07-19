Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796113CD10B
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhGSI7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:59:01 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:29694
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234756AbhGSI7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:59:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMGqKnb1Z3YaPXWJP4rBmXEPetFq/7/HeqzDqJ92P1lVnYuRSQYvmKir8FQITp3b8DeVQQdM+qjmvu1LvExoQex4yNdi39dfyv75jbsmhF8C992tQpsC/nYN64zUdqjPsH4oYVGjio+CZ0bMlvw0r5zaM7cn3puICWxweuZ34XiAbraDIggp8gNv0ZoTPH6uQBC1Y7ubKDzWBd9paBzd/hAgmRmoNdzRrtPw9HqDmpposi7eT98SF9syIWjG877aXEVWrihea1MpqR4LHfq86c1b+j2A/QzJZ9c8SZ32n5NeQICHKJNf06NaqJynNKtvCDFiruT1POff24mMDTKmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7o9J0S8l6x7vFeL6vC550cfCfB16mSIdMYzy3heZZg=;
 b=VTQHtGGgb9ZSm3WuW0Ct5gXfqNb6eMrjofPTo3u2k1YOGbe0FnCf7m8lKjIaMinvHSNExSkMxa70Pd0S3nnvkrnJ/uijMjJ99YbzotHt6s0WQloMsweSMS4I2IjgkBOMfcM2RETDtJXi0DwjLQfixfqU1ecV1QZ1yv3VD6eOZFdUHvhnqGNJ1kDVfOKR0CchgaBoYtpETWAQr8hIh+q4K7vxUNr24NHa5UwfgVw58Mq6tp16gCOiol9CHvm44Kh8kFDknJJhgjpX89uNSRNbtdLiP3t6MKQyBViStx89fxP9TmicDnM6aF1BMU90pZLXRCXYeIiJ+FIAWmDvtQX1lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7o9J0S8l6x7vFeL6vC550cfCfB16mSIdMYzy3heZZg=;
 b=eBDgd1rBiL0/6p9WrSRSfuE66FnPYQ0kTrBRf7Yci2s5V820egX/jPvgSoQWavza8itXMZaSximwkgTfeKbJe4drfRVTqlWDIt5UHG41mCfIMda1yyamjAlMaQpvOoUT+LOzV6PsjIXJjIyO93j8jpMqFu/ZTxz8ljQYkkFQizo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 09:39:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 09:39:38 +0000
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
        bridge@lists.linux-foundation.org
Subject: [PATCH net] net: bridge: do not replay fdb entries pointing towards the bridge twice
Date:   Mon, 19 Jul 2021 12:39:16 +0300
Message-Id: <20210719093916.4099032-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM8P251CA0006.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 09:39:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c279c02-6e10-4528-e1f2-08d94a992030
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119A92AA4C0DD17962B6AF9E0E19@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPmDusD6fhv2YrYvIj3XwrNdAW4kUR79Bh/sCMVtazmYQXprMRrXMG7QHdkmxjajuAt3E3QYGYJVq5MEkklFaJc6fxcmtwp5Vuar/LZhZ7/wp8zuEHyMFj0H/sDvSO2rJstM1H91dz3kMj7Bi2WoOxPXGvxNjj/5QF95821Spn/BSNnSjXnx4YUTtL0YQuZfEYXDjxh8FLAB3GAhDiDn1WrlEpURltRVIljpDMIfetNr/t+rqmg6aa1vR+AeJyU/KtJxPnsll4LL8il0VW9tukMj41CVdCHnwaLcG9vSdMJZkgk6YwmGqHzr+IKKPKeYBhnqv0ffvZEfE9htrmqyJBdinw7dVLeLam8X33PRrnzAo8FWPZn2BNb9wTa+PasKpQp+IsY215hHfcNKYTuo2Ntc9GxQhADUj8FzTvqx/s/IMLlxAUjrFoJB0b/RGhfVlOvab49pfCj61FU1SaU4A7CY6OpuNU6FfVyFIHaEvNAb8C2lCuedMCQX2oj/vlzsmsXCC6ueXDtabOPKi5uUb7eVB8KX7kWXH3U3ztpQOX3bG2zpWqii49tSR8zaikbSzvixSOkOZhtqMtqo+dbv1It/LvJDvqToSv1ssbv8RJIj3ZLw9Jcw0EGzNyGd6U02OUrGYMeOoUAkNnNU6RnvvTg64h6iT69FV4bEwuhZDWGebk30vV3yxo043fX+flIqrh9NeqdM4xivgXCbQJ/G3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(8936002)(8676002)(5660300002)(6512007)(956004)(2616005)(1076003)(2906002)(38100700002)(83380400001)(26005)(6486002)(44832011)(38350700002)(54906003)(186003)(86362001)(66556008)(66476007)(36756003)(316002)(4326008)(66946007)(478600001)(110136005)(52116002)(6506007)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1sabgNNLl5Lgu+vj4Ptl8E0u3QlfMAEsHkMsShDlxd1S0irYiWSXKlQjCNsi?=
 =?us-ascii?Q?EBTtTkh/fBFP80bbIV1lD5EycIbJ/1HU3Vd5oj8sHorFC+PKiEt2JnvAtNOD?=
 =?us-ascii?Q?QVbH3hFwXL0zTPsBfFHBi4BM2qglBQsT4tRwUYIyBiLNoKXW2lPYnp4L0HFm?=
 =?us-ascii?Q?/Vpbp5CeJAv0OPP/wl91ilos9m1jjQWh4i6tnwD09qZsH7tF7uhH90R1860V?=
 =?us-ascii?Q?Ov4LWmrYU/BJPDaYFyI4rABo5003UiE0qIJloQwx0P0hMHTjphw9whCs4A5V?=
 =?us-ascii?Q?AKNUvKAhCHH+ri8WrNkGDxzh99bPvfCj/ZMb52n10m8SGVgFO2q5pRreYokO?=
 =?us-ascii?Q?tzAYGETsWnXJ2cnQveKf6ppgS7sSEOuD7CS6TZHqFzAMF9+KCFnSRIIZVt8N?=
 =?us-ascii?Q?XNxAN6oRF0w+3KQ8s3N7WrNGavyPAFJF9hhdaOqgsUko593opLj5ahUwfMwS?=
 =?us-ascii?Q?ov4V3oGi24ZOZQ07fyCHpubkgSTFYVS6uJ+2rEEmkr9Oxslv8zG9Kcisvh8e?=
 =?us-ascii?Q?Sg7A2jjddylIllbW14OnNzhL3bChu9hBXAP0dtx01Tl7E2WDGvIkksPkhiil?=
 =?us-ascii?Q?oRqTCgjIzI/uw/Fy2gHI42emdhKcNxRIZU5XFcy75fGMvvUEIW5++f8vG5k8?=
 =?us-ascii?Q?TsVLzWQy3IpQTtsLRTCdlQNG1r9D7eiuWZyIOyWmpYkNP7gUXpU2eRZwWHPE?=
 =?us-ascii?Q?EZAVcg4E40gzeXj+ftWmhh0tnv80emw3UkPOdX+8lkYaajUW+ayNESobWtkP?=
 =?us-ascii?Q?6RFTAr8fVwTP0lDhOujGweax2srByJBUPsuLRv13TZwfAQZnl5A1bGks1mK3?=
 =?us-ascii?Q?bIxBIjp7mf0DbOXYFBfxTkiiZrDmHmzYuuDvyS++NxqqdNa4MdoL1T7I2/yh?=
 =?us-ascii?Q?fJsDvcchOJHm2nn7g0XVmIMSpDiQ9pUrvTdtJQ4WxatmjYsTFdAjfmwRz1yx?=
 =?us-ascii?Q?MpcMkYXnQ5OO5uZCmjao2jEqMqCXl2tLXxd6Ztg5ixofnRi99hsPdDo28Wqa?=
 =?us-ascii?Q?U1as7hpt02k089Hk0+QvkzwQt7cG2RK4XkjDpT3tzeXXvSzWa06cd7gq7sFZ?=
 =?us-ascii?Q?Wndx/jyxQh0gL0O/XrjFF/yytsHw/DTO6+8I58avAEt2PvL2S+Tp7ScDppeZ?=
 =?us-ascii?Q?UOMu6ZeTjcwh2vXpj6gFt+hm2XrbteuGUs6XE4leNTbTJr3r/0lxetyolFRM?=
 =?us-ascii?Q?dnmxu/N/yu7V8TEbmUkhWT5VM1w7ToqkmE088+SplXqx6Ae5w1+j89c+ME7v?=
 =?us-ascii?Q?MP5LkgBdSoQYfCEmQAi5iyRqfJvK0G93OQu/t6hW+UBWApT2zWKH8fuCymS3?=
 =?us-ascii?Q?DXm+KyiCnTI/x3o3Tt8uH8ux?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c279c02-6e10-4528-e1f2-08d94a992030
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 09:39:38.2050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aM248aI07gOmL3Q1cSUM1LG7NhzyA6fi0BWuSEyXYNDsBb+7zp7x2JJ7MKLQgnuk1ceHYqbpGfyplmM8u4wrpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This simple script:

ip link add br0 type bridge
ip link set swp2 master br0
ip link set br0 address 00:01:02:03:04:05
ip link del br0

produces this result on a DSA switch:

[  421.306399] br0: port 1(swp2) entered blocking state
[  421.311445] br0: port 1(swp2) entered disabled state
[  421.472553] device swp2 entered promiscuous mode
[  421.488986] device swp2 left promiscuous mode
[  421.493508] br0: port 1(swp2) entered disabled state
[  421.886107] sja1105 spi0.1: port 1 failed to delete 00:01:02:03:04:05 vid 1 from fdb: -ENOENT
[  421.894374] sja1105 spi0.1: port 1 failed to delete 00:01:02:03:04:05 vid 0 from fdb: -ENOENT
[  421.943982] br0: port 1(swp2) entered blocking state
[  421.949030] br0: port 1(swp2) entered disabled state
[  422.112504] device swp2 entered promiscuous mode

A very simplified view of what happens is:

(1) the bridge port is created, and the bridge device inherits its MAC
    address

(2) when joining, the bridge port (DSA) requests a replay of the
    addition of all FDB entries towards this bridge port and towards the
    bridge device itself. In fact, DSA calls br_fdb_replay() twice:

	br_fdb_replay(br, brport_dev);
	br_fdb_replay(br, br);

    DSA uses reference counting for the FDB entries. So the MAC address
    of the bridge is simply kept with refcount 2. When the bridge port
    leaves under normal circumstances, everything cancels out since the
    replay of the FDB entry deletion is also done twice per VLAN.

(3) when the bridge MAC address changes, switchdev is notified of the
    deletion of the old address and of the insertion of the new one.
    But the old address does not really go away, since it had refcount
    2, and the new address is added "only" with refcount 1.

(4) when the bridge port leaves now, it will replay a deletion of the
    FDB entries pointing towards the bridge twice. Then DSA will
    complain that it can't delete something that no longer exists.

It is clear that the problem is that the FDB entries towards the bridge
are replayed too many times, so let's fix that problem.

Fixes: 63c51453c82c ("net: dsa: replay the local bridge FDB entries pointing to the bridge dev too")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Reverting the blamed commit would have worked just as fine, but I prefer
to do it this way to avoid conflicts between "net" and "net-next".

 net/bridge/br_fdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2b862cffc03a..a16191dcaed1 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -780,7 +780,7 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 		struct net_device *dst_dev;
 
 		dst_dev = dst ? dst->dev : br->dev;
-		if (dst_dev != br_dev && dst_dev != dev)
+		if (dst_dev && dst_dev != dev)
 			continue;
 
 		err = br_fdb_replay_one(nb, fdb, dst_dev, action, ctx);
-- 
2.25.1

