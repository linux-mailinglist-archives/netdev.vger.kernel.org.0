Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB2502C79
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbiDOPWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354955AbiDOPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:22:33 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2702AC76
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eloMDmIY+OV16hB7IoCSCJYhaeyw32s6L0eSbwLkq8elkirAKNqmiGxc86wxMKYaFjIv+qSg6t1lGvfUz0LiQIIr/UEKyWiwcjJjAaYZhi0moo+LafOQ9a7sDcOG3IMayhcbCirtjXPVRYKuDBagoSHh+G00DyRcN/HTSgCouepzZ+6+1tbX57GKziS56+2LhWXcitiB4l9tcyfRockQhWMB7iCXGjgEjq6/G+gEyVxNLL5NUCblcQ/9e3VfG1y7hLbKCP7MV2YdA8NvIoace4gyvki22dyWtRIOeM9l2Jj+cqUFxU4li/p/u3iNFasYTai0BoIieoXQvMkEHKwRIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkkCP1Z1OuWRZSRGLTLOWXvXcZh0j0x7fYOwhfVgxVw=;
 b=chf6NzlHWK02muOk2t2fL77wNqArKgLCwpDOky4jcLduiN7234pSO+ViDSsM0T0E6ey5/1pBljn8nCxBe79qjEK6sk5qKteBoabqlkcef0zWx4kyxrnN6S+rb5E+XYhrYXDimkzXDDKwv1YhsGlhllJdona154koIlwiBWR4CdCwwXawF6m7NatOy1LuaYc0p7XT8KjSUNI1OZ/jYmb2yPZ7ddIlSvffPpSykRHH8Og3YOoLqYkKKCFMMasVuvt2VEFM3/sy314lQ1BwjrrDwEN3CPsP2BDnxEmYhtsOAD5+25z14TG48JWorm3U29rRxy01sg/BQgzEwEYayzae7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkkCP1Z1OuWRZSRGLTLOWXvXcZh0j0x7fYOwhfVgxVw=;
 b=b0fNGl/UKAJytYa082Wn4COqkbcAI5b0TvdrlYcP7gDxQ6RabzcQxaKzmuU4BpHknIqN2CFqdeY8IVvsqrjbjIGtRV8QAlxV8xg/ynx6SSDvfPs1NLaxOdzyn2CdoriyYPBOyBOxNbFviOgXCeezmN6DuXY92XvAN16nRuqb/oY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:20:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:20:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: fix broken IP multicast flooding
Date:   Fri, 15 Apr 2022 18:19:50 +0300
Message-Id: <20220415151950.219660-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0046.eurprd02.prod.outlook.com
 (2603:10a6:802:14::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2acd0ab1-f7ad-4f29-63e1-08da1ef368de
X-MS-TrafficTypeDiagnostic: AM9PR04MB8397:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB839761C374E0D5D3B797C590E0EE9@AM9PR04MB8397.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9r5dr8stbhgMlS5lmb11XQdYLPo3mpx/fsWoPftsyAmZTjNUyzwwGII+4qUWoyoyEainAz9DPdj5ZxgP7Kj8ja3ZCYdQnUN25XtagOQ4mP5OSNjXd3HNRvTjcieEcNTw1fdErTIQ5OMjddzUY6tqixiQ8il/p9672hOODwvvXI1biLonyax361Np7IoKUIdBtPOWanZhNCM19qlqTd5ACnJ0QltYYp7dQCx6c32WTdCsq8ShvOMwSjRl2krdV9CNxmnxwI9cetC1mgn/1J/ZM/l1dioaHjB1mOM+jVl94Hq9ta0h8sr2NNZ224C3msPSrJzPeTgVGgw8Rt+IHGxgUBMWTFRh+KqJiBumpBc5hrn+Qd0EORqZml45bDEYcdzwXAbGbatHvi30tmkjWLkCWvIFmsuA9pa8MsULA5k9AT+YvPxG0GQJa7xaTdhMdvMufuf0cxQvil2K3wX7MNq8T+DR646IxvlnKaxzTWe9PsuOY7a4aho6Hp/+5yO2dyy4ZSgApqNXnqz6aIjg+QbZPNmXrXGx5Ud6sN076ClydJWHn291jZukFY66QuyTlwWeUJ+bsKL0HUHZqc9OGesUzz18Uj6SU3CnyEiTZbsSfuHRexKDEv1gbWGU1H/g7tbnPhPr6iL2fq/htN/0CuGLf0rBHhjwRbVTS+8phz33S2dyeMApl3BCmO6tb8dvG19d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(52116002)(6486002)(36756003)(54906003)(8936002)(66556008)(66476007)(4326008)(86362001)(186003)(6666004)(6916009)(2906002)(8676002)(1076003)(316002)(5660300002)(6506007)(2616005)(26005)(6512007)(38100700002)(44832011)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zwbmPh2ZNJpMjXanPsoPBXitDG7PTcvOa6Xl79+xz6Qz2Hp5HQnoLQfDeyFj?=
 =?us-ascii?Q?/arJAtNQm3pjcbAxbdQp6a9EBshdg7J+Y9A2BiNe9YI/m2ODl+c8V4F5MVIM?=
 =?us-ascii?Q?sIcpnadyv51SE5MN+bRTO1d2uYTnvIT35Es+/JBsU7+fupA8eUl5qZotNsGj?=
 =?us-ascii?Q?/ZmLPyZ0Lzwm42raBm+XKwUZCw77udhOxj/7Pkqou+qtYRLCyc+dAiWFkS3h?=
 =?us-ascii?Q?pxie9oZM0BUj4Hj1fGFyQrkY39d8e2H8hysVzHRb/qU3InNu8U7oGruplUwQ?=
 =?us-ascii?Q?I0OW6HCmpXBKa1JViWca966eaKl+c48Da2c1fRCcDEp5cUXN42APjZN4Wfvd?=
 =?us-ascii?Q?Th8mJ8Hgn4TWnGL0rnOtXN4ZxsBZwr4quX1gWDXaJizvER1Ey0VLcZSso5iN?=
 =?us-ascii?Q?0JHhAN5vbuC49GOWLX6wMuAOL1972fSttF2eCgDDkOJFrOFYLpiy59wIicQL?=
 =?us-ascii?Q?aei3SR1QpHKDwYHA9JSJBsMJNKtqKhl1gM5EJBNykBy2QJrnGa/BVkHTpq84?=
 =?us-ascii?Q?lJqDmXA7U4xXrgdp/ARPL3WDoZITtXcPViV/DyIB90pV3e/I75qMUXQgnGSh?=
 =?us-ascii?Q?og35UFghwl5/gxyxu0ItPOtuma5OBP6qznNuTweqmKxenvpOvPMrGiKAuKmC?=
 =?us-ascii?Q?TCaJ75jJnzyy6egYXrhLO0J72OzsfDs0skUa07L0mmzANUI1LyMqtsTgHN6Y?=
 =?us-ascii?Q?U5Io0yy4unoL9Qq6payh+stOqk0inOcy7Y7JEnAhqUmp71LypQHGtO15UrRH?=
 =?us-ascii?Q?W/F7PxPMroiEkrWuFaNWJIR4b6RNJZ877pmVamv/dQzukE+0kV6QrzktFhvP?=
 =?us-ascii?Q?EFbQzSBw8HRNumPi1G68/+KGf3/eDp4CVJfUtBWeGpyysg6fNXT5AjeKEz7P?=
 =?us-ascii?Q?ifKawWJiBAa2gnS401DdQD19TsuGs3zRibDla8sI3ni+mhXGFieZRGHoiXEL?=
 =?us-ascii?Q?tvX2IK59eM5Ao6fRrvyZJFyATHlCMnEVtAXx+NNmzj+1vTbHot98wD4rLwVm?=
 =?us-ascii?Q?WxsGcKri6ZmUeEIpuZJbYMflwYl48u9I4nC627sa64r2JSx+BXP9qvbXwz48?=
 =?us-ascii?Q?YxafgKmctLuefjfsIO2PLJ6vCb0b011KNNR2TQPoJRWIm4xyUfR0YNohUNWU?=
 =?us-ascii?Q?DE4DYRmQD347qobfzcUsL+aaYjnShVemn7QVUh9d/DMLAjSocrXPDNa0r7Ho?=
 =?us-ascii?Q?joUVYWsxcHuBlysM7TMkaKM2b90ZkFhWQfIeRIQJPVu7EO+Hcxy3L4q0VUV3?=
 =?us-ascii?Q?HRgpEimUVtl3sbTd8JUs3BV9bbUsiSVqzQPNLuQRcXgBgun83NtKqunbJwEQ?=
 =?us-ascii?Q?kwYHegBVwIo5ZuR8viue0x+WxLbH7TJfARNJYGVPNhdeogO553E3qi9zp6JB?=
 =?us-ascii?Q?jKgsDASGB4GTgg7EW5S11AwS5QQaNtZ6eode0k25GlUbrV9aCcdf6i+xfS7r?=
 =?us-ascii?Q?Q6wyEJ/SfwJB0YoaLRFkOqvIUXcUPN4sSg2w/wvOAAN6qBXOBt3AxiXOXjuX?=
 =?us-ascii?Q?67faURPYOR6F+898A0emLWHQEWhQGE/rYgEOO8cP6MxXXD+yUJc3GAh3lCEu?=
 =?us-ascii?Q?/Q1U4dYHsTXkLpHbg3lDou1jjpnD99ka2xys47vCELkxT5B14m8We0EJc/XH?=
 =?us-ascii?Q?uqmBAlVRdBiJPHhmpgOYZaIaNV700f3/DdQTqpBbsXH1OZ+s8Vr+lFZANrC9?=
 =?us-ascii?Q?HOKSESze/XHpHSas/I/gYzTICfT/SpgaOdRkeoRBTUCvfn91nolcizBZWKaQ?=
 =?us-ascii?Q?x2Rl2ijQi1xaM2RsWdhCaPPCMHxUjRE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acd0ab1-f7ad-4f29-63e1-08da1ef368de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:20:01.3200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89270DklLtj1lzaaEFze6P8jHI7DGynaKXMoqVVveaObg33zlNxxxQSBN5jD1KZmW96gPAqSN+aNYBAq6dlJQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8397
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user runs:
bridge link set dev $br_port mcast_flood on

this command should affect not only L2 multicast, but also IPv4 and IPv6
multicast.

In the Ocelot switch, unknown multicast gets flooded according to
different PGIDs according to its type, and PGID_MC only handles L2
multicast. Therefore, by leaving PGID_MCIPV4 and PGID_MCIPV6 at their
default value of 0, unknown IP multicast traffic is never flooded.

Fixes: 421741ea5672 ("net: mscc: ocelot: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e443bd8b2d09..ee9c607d62a7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2859,6 +2859,8 @@ static void ocelot_port_set_mcast_flood(struct ocelot *ocelot, int port,
 		val = BIT(port);
 
 	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, val, BIT(port), ANA_PGID_PGID, PGID_MCIPV6);
 }
 
 static void ocelot_port_set_bcast_flood(struct ocelot *ocelot, int port,
-- 
2.25.1

