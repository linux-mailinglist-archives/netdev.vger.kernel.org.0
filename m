Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126BB3EEFEE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhHQQFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:05:35 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:20650
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229460AbhHQQFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:05:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd3HMQF8D/+T8fCrNsL28m+GAGvwt8CnBjUWIH2hPHQyd2kY2jGboybwp/tWMGJ0kMx4AJl5yboTXuZPM3Z8UC4FHLONyDX6uKvgt/dDP8/arhXTB0rXi9oYhDgcmod3lWFYipYypQjaD3hATa8qwwDOQrtMkrLtnPk5Zxb4JR3lbLhnh6NF551MACprVm81DEDetYvaotN8JSC1hv1yMqZQXOYd0dCN3e2qmRp3R7kh3bqpVyeNzECefYcRDgrKEPv73BlvSfLfvSOQ7agRusbBU+S2rC2dKkf8J24BPIUDNBsvxrxGOqw0bHhq9/k4aCcECMtOGHO0qiD8tplO6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJCnEm+hhmIYqtLnJ+TKTcYPY3Ta3rYG8GNylduURI8=;
 b=OE3Ural99QfRaGEcC1XSrTKNfWENe0kL/3E1kSDl21pDFYaXUqnbuTCpT7LSbmNS8z18s9OzHeJkeATRLJiTzNbK3cI9XS+lbtamKbQlPrrxfhr9kouRHwVV2DW/3Ls2++0wAfb6LqJmkSSRC6crTq8CMStj4cOv6d1w/iyNUl6+HcTmBd9MYFDKX0oUitI94pO8WF4mBHn+oDaA1j/3Dunr4B5JcAuARAn+sG63sf5fYnNWmXUCK8NUEeZWotviP6fFbrSv7HWylbLOWeA6lPdBQIMC7+2vpT+IyO5B+uB0kkw0AcW55ml0nin9ZXd666njkkj3uZxIRJBo4K68gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJCnEm+hhmIYqtLnJ+TKTcYPY3Ta3rYG8GNylduURI8=;
 b=I/+PZ27QM8tfavm7GrRrna06YzRcwXE4O1R7bstkriAHdOtK2uO6DW86rSwTEghqI5Aec8bFQ3/DryQSqxVMpKYa++8TU8S/ajxoRAN1CuA6//zL+NbXniT/UT0vR+ZhTi4ulGtTqXT+0QsitqHHc3KEkPRs4DDsYo4o93C50wg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 16:04:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 16:04:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: allow forwarding from bridge ports to the tag_8021q CPU port
Date:   Tue, 17 Aug 2021 19:04:25 +0300
Message-Id: <20210817160425.3702809-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0011.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0401CA0011.eurprd04.prod.outlook.com (2603:10a6:800:4a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 17 Aug 2021 16:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1748f560-8994-4d2c-9637-08d96198c297
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74710078D8EC960512C9DE1AE0FE9@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KK++n8nZ6rn75vqeN5u1EW+eUfhoE0w+ADS0CmkguJE9OFNFpUhlKDWxod0BE4yg4+btlDNkAEd4cXn2bM716cvsGiRXS/rzMhaR1MilLf53D2OHupSSu+6nG3JJmf7aKBhk1g5DzmJ25aW8YVItUy3VFF1Lol8IA9Ea5D2uBKa1RS3qhuU8aaWXylMFw4lGkPBPwpo9gfJfp8hltih76TRh1gg9UJcOFcaWac73HrIEgPtOA96B+t9+YGGnqykZ+3+oMtl1lNSD/42zwvv50rWyUz6Y/uDLCiT3A0P14tJkveJAztCcq4gfR69OqajOfi2qxEKvq0Qg4Ylpq5Vi6jF6c2vtxgGj47MIHafpJuak9Ujid6FPk+KZ0yVh21Teq1z1zoIHzjgM2IDX9h+tTcMlUKzkcJscVYVQ+gBzTqo4Sc1oV1t4w3h6qAyKEdz3h7SY3mWC3knWldnoNppJaatIxcjGJvUsT0SlYad7ThO3U239OscVrOs+plc23KrknVOSb+35B2Q8B+la/VZ6HBYmjkr5LNpqIfUPRlFEs7OI6CTOD5dqpe4Kmxe1mqFMsAiI7ANxp+XHQ0TqN2yXTCrUeXyqoOLAFemA3cvd5f1bzew0HJR4OaXAULYRTR2mZzRwVQ7mRbLrJJFYpm2c1XoYDwc6iAuKMXPRzQhd3vREtbOcOdHWT3ZvftU9C/IyXxrA/1xmwt6wBXvG5CQZ177SBJmq70JW9vL6Gd6sSerAJkJmxW3cXJf2N3+CZmH8srBneDS8OX6lXU0reVUbhasMHahGMOGXUW42CgXrhs/hi493wPYBZ+6cA6WJGPu0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39850400004)(346002)(110136005)(36756003)(1076003)(52116002)(8676002)(26005)(86362001)(8936002)(54906003)(956004)(2906002)(966005)(186003)(2616005)(6506007)(4326008)(66556008)(66476007)(6512007)(316002)(6666004)(44832011)(478600001)(38350700002)(38100700002)(66946007)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SIruHb/QvGY2TUdtSYYOYR3poXq98MiBFx2peomt1oKpnFte6dOWNIDZsShJ?=
 =?us-ascii?Q?8D2CapoCVA7lWl2iLr/lSw9hs27J55ULRW+/bTfJpPRmvqF2T2Sw2cCjMPML?=
 =?us-ascii?Q?xVQtxyuFE7NjOQBA1WujmoaUpBpgonAVCOP0hCPGv3gMWGfv8SMNSi9xSdLx?=
 =?us-ascii?Q?gkrIXPPclG+LMY+rnfQVhuhZf8jkBe19tIFzLhsWUbbsTZFfMuioJvEgfoFq?=
 =?us-ascii?Q?jizh8dN3TjfFqkgdq1SD22JEPfzmCA66I6Z+bWOMqjyBlhNB4wllp5e7e3pT?=
 =?us-ascii?Q?z48MahApMTBSiDPgZ82eXWRplCoJcYWjNib0nhgvIC124tVcWJo7ZRpR5LLc?=
 =?us-ascii?Q?3x9KU+bRPLXGbLSXcQurjl/Z+FqZeNQz98sEkwkDNE84OailrK8aRZfqC1Pp?=
 =?us-ascii?Q?uZV+4p6fgBQ+IziDYDzoyovKokU/GVT70xj5t5NePH2ctitE6qJs2UNs3IbP?=
 =?us-ascii?Q?wzrEfjpQr8rp+UQYdZrBLl1kxDESkrCIDZEdfZWOQtina2MBYeeLkItKXjDk?=
 =?us-ascii?Q?jVpEqJJzinAC1qs5kdDJT5Tc2s+46SZ3yG6NG49jilOQr8FPIocAZCCm4HKk?=
 =?us-ascii?Q?1KrKtKO81TUVHnOysWIn5+moJxqmbxlKoqaBX612hXINZaTGFxh5N5zXZW+L?=
 =?us-ascii?Q?I+nVyYj0C8Dy/+a/HyoqinvfudggyaADCoD/cNyb6InVEPWzRmjgk4yRK//C?=
 =?us-ascii?Q?At2zaQZFnHQuBMG2GxWW808nyd66HeZKpSO23BwN3qcNjqib91AHramhK0jL?=
 =?us-ascii?Q?ji/aojBscIiLa0uKyVQxrEbo6DiHZSZ2JGwKwG/kcm6vaE079L5BO+uo/ozP?=
 =?us-ascii?Q?VORsE9X9pAh0RWpyg/wlgJreZrGTJL6Uzq0Ari7bjdlYZmM3CJaW6R8yzqQX?=
 =?us-ascii?Q?TVx3S9CQfhV2/px0gQnaBWcylHMjpWCm5lhi7+r6pDUXihG5FuLmxJNMXKJ9?=
 =?us-ascii?Q?Ts2aWnVJOcisBCr/FzEAjD7icssLrPkg7lCGfsHP2d/Sz+Nue+wJk1rUqS2c?=
 =?us-ascii?Q?nbfCujlVHP2yUzHqvoEYjyVoAgadrjKww7cjNsHVe7vIPDkLx4kv2lCdKrsu?=
 =?us-ascii?Q?F90qYTdt8lg7bJIvAc9Z1FtiFDiQJkGmwt9p+d7WCPwHvBsomFNW1dqfB2g+?=
 =?us-ascii?Q?d4eR+Ot+ZFrnvXaihy5T1QEkvZfKQCmFYnU8XXTwLLU21heSndGcwXkNEhTZ?=
 =?us-ascii?Q?bc1GP0F8wmOmUFY9u0THiMop0u+a4M2Q+r1u5kq1NDn7qD3ZQaqreC1QLeoZ?=
 =?us-ascii?Q?08uKUusCxyBr1KmAVRkeiYCv7e/Ad2Qf9xQlg/vzF2zNLmHSMLlXXeS243Vv?=
 =?us-ascii?Q?7RdpJcgyp4hMmbfSrMZtKmmD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1748f560-8994-4d2c-9637-08d96198c297
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 16:04:57.8752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SK0jHIMZNjxjTkcKKInnRvn302S6HP24KcZlYNc+SjZWGQM8ozxnaVW2dZOcHOqe0gter2xchEav0G/uq555aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we are unable to ping a bridge on top of a felix switch which
uses the ocelot-8021q tagger. The packets are dropped on the ingress of
the user port and the 'drop_local' counter increments (the counter which
denotes drops due to no valid destinations).

Dumping the PGID tables, it becomes clear that the PGID_SRC of the user
port is zero, so it has no valid destinations.

But looking at the code, the cpu_fwd_mask (the bit mask of DSA tag_8021q
ports) is clearly missing from the forwarding mask of ports that are
under a bridge. So this has always been broken.

Looking at the version history of the patch, in v7
https://patchwork.kernel.org/project/netdevbpf/patch/20210125220333.1004365-12-olteanv@gmail.com/
the code looked like this:

	/* Standalone ports forward only to DSA tag_8021q CPU ports */
	unsigned long mask = cpu_fwd_mask;

(...)
	} else if (ocelot->bridge_fwd_mask & BIT(port)) {
		mask |= ocelot->bridge_fwd_mask & ~BIT(port);

while in v8 (the merged version)
https://patchwork.kernel.org/project/netdevbpf/patch/20210129010009.3959398-12-olteanv@gmail.com/
it looked like this:

	unsigned long mask;

(...)
	} else if (ocelot->bridge_fwd_mask & BIT(port)) {
		mask = ocelot->bridge_fwd_mask & ~BIT(port);

So the breakage was introduced between v7 and v8 of the patch.

Fixes: e21268efbe26 ("net: dsa: felix: perform switch setup for tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..2948d731a1c1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1334,6 +1334,7 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
 			struct net_device *bond = ocelot_port->bond;
 
 			mask = ocelot_get_bridge_fwd_mask(ocelot, bridge);
+			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
 			if (bond) {
 				mask &= ~ocelot_get_bond_mask(ocelot, bond,
-- 
2.25.1

