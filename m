Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709B63DE04C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhHBTwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:52:00 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:40369
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229537AbhHBTv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:51:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j90HCoxcxuXpWonXKAaIgGIxS33yYRcIkCZerfzRHri9IhrBoXB2P4GWdmEh1tc8ywjvEs2TcEm+rLpHWY70OWi7q2TwFxjMDxSfn3QhrshkZ2U+YmZA+8JHP+ySB9f4BiM49cKyli0JgozAq+imZ7IpGN5DwMJLOJsIUZCCycAWaa54D7vMz3MI8Vmc5a49UicTGWtJAESkR+6fuAkIX/oagHrX5sGwgTToiFgR+BZ0X0IC+5HG9t/FzD/rM5860bc5r3/uxunu/K2MYn/ekG0vlrR2Wrp42p55ad7TR8mV+lh3m0G7sFXbAHfNUmy6hiyqjB4SrO2kv8aFusQaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxSxykIrFPBgbcywZ8aOxCytAe0BwdJW8icElz9U6Z8=;
 b=NtLsB1lzzIzPCaFV3On5s9pnKLOnSg87aAzFRki1V+VvFjIGNshehuXA0aNrNYujDzU5Y7oOeh5x9+qpt9ADdxmNOhIu6mdh09DkLT80y+5f7HeOYOH0yRCuX5SUrNmwwAzlKcGXfW65EiVpvtpXH64uErqIddanvI1qbbfY6wzLWgUYqjCPc9bUi/Oog68li/YbXyZVPU68XH/IHgnK8N8dOlPUg71GPUn1rwF8ydxUmxYrLBdgg83EVKmrR1EwmEiT76hE9TESvizuLAVO458/E2XIW2t1P+vJ7CPwGyjWsqi6murN+d2tybKJZjGfXDIPB5vJUcC8ZvZxn3j71w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxSxykIrFPBgbcywZ8aOxCytAe0BwdJW8icElz9U6Z8=;
 b=FfsJFxNuef5RRf9C+05i62wtYGMta5Aq83clwTqbDWAyFZpYAGmqQ/uD0hQPNit444NLqi1s+lD5PO1/0XaH3hCN5Hecjd2r7L1w+CCXq4ie65l9LtVdwmdr/OtfbsT48y1v3loDsr0RHsxXxUmN3Rk0etI72x8UgRXFd6XTYxs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 19:51:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 19:51:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] net: dsa: tag_sja1105: consistently fail with arbitrary input
Date:   Mon,  2 Aug 2021 22:51:37 +0300
Message-Id: <20210802195137.303625-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0079.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0079.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 19:51:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ebec442-6fc3-4fc2-be4e-08d955eef670
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343BDD1F1FAF5BAD019CAFCE0EF9@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7SJhh7ePuVmT1bLWIgPV5Mes+KerD2q4AxhOPRfjs3XFElsY8/VQ3Eezmqa7pgG9g1Pqp0eTh16ikuGCXmVocOyvn6w8uZz6ETx+JZL7nP/ttt/lLTQI+o/CObuHvyzoZi39VtBG2m4bMI57mST/0tHYwoxPSAqPZ5IIH4a1DXzAYpkKiSoMWWLQCM4E8Ahv10YG7J+Au5Wv2EopzRy8m94OWLoSql/owuFfyDVXO9kRUJZjDCW8itD5qhgBzY9qtDabUVpA56DN1qr+4h8H13D4GTY25aAj4g2U1ag7ToOfHtuVqqTV+rK285eBpKLs8Z+2oApnCM/SwZGJwZ1Lvskibei/UYw0JXYr7Ph0BQ4+ftoQgvm4L88NTNdGY+MIZ33AEKeWEDIOlXM6QuxpC5qfX7nWA0H1GR3ffFlbvraOdJzC32X4JYKoWxN24vIaXQpV9xlj6LiDQSMKdoY/fr2UN72ZpmKm9AK3E9P13dn5RD4Lg3mSVPrHMhbd7ZzdOdGy/8JrvdagSAsqDpuwPSv1La01qtkA1fpu3OMm41Nf2hkajAvv8KhGnC9LutkyBKMnqobPZteX4amQcs0ESZmqypvE3rOWy+8hmG3zujpz1y7irnrdSeV867fuyvkVqhmQkDZk6AqaU6F3s0A58zt5hWP+bIQDiSDB4/2eIlQME45Wg0g2flTBnz9Kxf9PrDFHm7WOPoul10zUFz72A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(36756003)(186003)(2906002)(5660300002)(2616005)(956004)(6666004)(6512007)(1076003)(26005)(8676002)(6506007)(8936002)(83380400001)(52116002)(86362001)(54906003)(478600001)(316002)(6486002)(44832011)(66476007)(66946007)(38350700002)(110136005)(66556008)(38100700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eI1rJeeK7XaIpELrgs8MkFooONpff0LAxbxgxtwjpjN0ZGlPOfHku2jSSEav?=
 =?us-ascii?Q?kU9de+MfW0XkSoW9fUgcHHNyFZOxCe4WgKDBLdHV8FVj/AfW6YUzbJ1A/z+R?=
 =?us-ascii?Q?cAgRbOfpVutweXQDok693DclpE9uJeO3HDD4baZDZYUqjQrsP/96OoHgB7Nb?=
 =?us-ascii?Q?mvlrwavGM8xZLjXGiLYP7wR9yV+M4QqrePfuxQVE41F0Mn8d1vBR72waGp+5?=
 =?us-ascii?Q?jF07tFUbfDQpksw6Mah5OKADsj/cgIHf7EfzlRznSOIAa0liOHLFCnhA3cZo?=
 =?us-ascii?Q?BpvwKphfkY3gh0G0hHfaYJ+JcZhGUzPY+P1fkoiollmaIl+lV0Cpqzm8zcIe?=
 =?us-ascii?Q?lLOhXN8SUlo+LI/q13cPwYUsFjhost9QylneDd5rAff34nMZzrxGEB8YEkW4?=
 =?us-ascii?Q?n7iz6L0aOZtAQ1cvfapulSts1LOBWj+Zp7uVlIUF1MLcgE5pFu+30dj7lCMB?=
 =?us-ascii?Q?LzBycHxxsJgtjZZwThlJ4GZIeDEtNGnCL6iWHfcie6pV0Bp+i11Bl1+7UMbr?=
 =?us-ascii?Q?MHHlwflSePpL5Wv49uBtmJ1a50qmL6B8Mc/rpTKMyEuXzk8u5eleKmuXGTQQ?=
 =?us-ascii?Q?TZRq8rSdi3M9ppEz2hgM4Zd2yoiODjG4VBD7vCFoiN7JZSKt4qs013aUNT85?=
 =?us-ascii?Q?Li4N3UL3jpfKP2IKy8ElJFHbcbeO9TNFXZN0Jk31GvUVJuzLA5uxscwwO+zS?=
 =?us-ascii?Q?DyR6ryigvM+Qk9IvXyNyG/kip3ohwWV700KT7FJaolf789HiXb/+Yso8T6DG?=
 =?us-ascii?Q?EHWAE/DRYCdkSybCkm7MQA/oqHwF9ModhPxWhBFBrmBjUWtei4800XIUnuJY?=
 =?us-ascii?Q?7Re8h6BgoCbHXjHlOoiy9/QYHlry2li+n/l8Y7Iy8a9AX2M8vhHrfF6bmpSo?=
 =?us-ascii?Q?M/+lKXujMI5hZCT6NLtC1VmAJlrFj+yAXzLOLt88j2KUD9U1v38zscEI6xet?=
 =?us-ascii?Q?viKPmBchNm1RpZdJG8RUFnVBSMYtw0tqD9GoG1Io6qR2cH8gtF6sp1youVur?=
 =?us-ascii?Q?5cU08lAOdJcvAgfGxI81lgElhDMhoeC8yRxlU0236gAw8PFcxtVs1fe7AmKM?=
 =?us-ascii?Q?K+ahOsGhQySVqJHI/GOR9ey/ekV0PMn6hlMh03nO8OskQiI824EO1at+qVCI?=
 =?us-ascii?Q?jHSHhS7Mi9FquPgE4Rz7jRhe6TaRAd2W3RvC50m8ps/JY4wWzgPVWZ8TXR1d?=
 =?us-ascii?Q?SAowskzFVHGAJerTWArjXn+R3uOTSqyGG2IEif0vYYNX1rsi87klgcYxcRNq?=
 =?us-ascii?Q?4jWhfVvguswHcMST+VKU+juBA1F5NXWnu6bhkPSArkj1YwlgjeLqYtMfSwAv?=
 =?us-ascii?Q?2lGOzZoQvg2CxFSgKFIQQjh4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebec442-6fc3-4fc2-be4e-08d955eef670
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 19:51:47.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uORJS4BqgsErg3W1n08cnrfQtMLeDVqcJuZeaNZZNqCBzXKj696gWMaV6kDtMwVNWfJcE5UAJ06B1QH021lq2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter's smatch tests report that the "vid" variable, populated
by sja1105_vlan_rcv when an skb is received by the tagger that has a
VLAN ID which cannot be decoded by tag_8021q, may be uninitialized when
used here:

	if (source_port == -1 || switch_id == -1)
		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);

The sja1105 driver, by construction, sets up the switch in a way that
all data plane packets sent towards the CPU port are VLAN-tagged. So it
is practically impossible, in a functional system, for a packet to be
processed by sja1110_rcv() which is not a control packet and does not
have a VLAN header either.

However, it would be nice if the sja1105 tagging driver could
consistently do something valid, for example fail, even if presented with
packets that do not hold valid sja1105 tags. Currently it is a bit hard
to argue that it does that, given the fact that a data plane packet with
no VLAN tag will trigger a call to dsa_find_designated_bridge_port_by_vid
with a vid argument that is an uninitialized stack variable.

To fix this, we can initialize the u16 vid variable with 0, a value that
can never be a bridge VLAN, so dsa_find_designated_bridge_port_by_vid
will always return a NULL skb->dev.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 21d5d000ef72..90e47e54b61a 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -586,7 +586,7 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 {
 	int source_port = -1, switch_id = -1;
 	bool host_only = false;
-	u16 vid;
+	u16 vid = 0;
 
 	if (sja1110_skb_has_inband_control_extension(skb)) {
 		skb = sja1110_rcv_inband_control_extension(skb, &source_port,
-- 
2.25.1

