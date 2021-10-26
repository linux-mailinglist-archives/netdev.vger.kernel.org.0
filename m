Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF9043B71F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhJZQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:19 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:5664
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234743AbhJZQ3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeGopP0FfvH3XSFRr2d5RG5kdbOcvMp7IWmblYunK2cKh7TAubM1c3rHrOCYYSsTxkIdn0v05ML/JBZZ8gLJTZygCuKD37XxcKOGWBjh/p5hjGgfJXP3zsSfCtgDBZt1ZyrbJZEhBCDBuNwhZk2lInxwSAgYIexfW5u/yRaTixNGTeAF5MW6qMxjSY/4B9jIpm+69dq/Sv+Z98eT3iDo/KYQd59MD6qXf0VuuA1Y4Z1we5mOfyvNLu0Mvi1bBulyDwqUk5bwVUnLmWT0vtHakrAjCvf6VFJkZGDgRaPsguBvv8IKH6+umFAYI9rZD8IfomCxj2JKS+8pa9TDYU4r4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lx1ahPQMjYIMarWJjOS/bQydSyG+NRrB9xZu5kZjFA0=;
 b=KAE26hxo247RR3e/mRjubRxK+msKOeAKx4ZgL7ftOHCCbJVrZVdtbtMPIP1lv7HoC3e4JqH1ro7OcIoa7D+Qy/lll45JXMXlcvSHWoR8ARbc+JbpC/4X4BGXuHiG9rNGL1Gkj+EnGgqPmQMEltYeuPOVXt13dsYEegTdiBbyc2wEf3JiD36SuA/8yhnCxfXe45/mGrQXEzEDfZXmy0Qfw4dJ6CtKV19PT7eQH9Ut4MDUj2ATYYCBWgmrraeS28xdpPUDcg5Pl52L5PTUKSgZpLWTMzrKSrhB6Yf54HXe58/9ktn3vjCR7I1urHYtYz3O6g179j7N8khUxIHUSXbP9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx1ahPQMjYIMarWJjOS/bQydSyG+NRrB9xZu5kZjFA0=;
 b=Uun750ViaxcSBteQ/keugdoEtFsTuQGm09N0hogIhZRM5i3CYayMzFVBZcSAWhLT7f0JQSM9DZoeVh1rWPq7TyDQOlKk2u74ACuu0oWDwCSaDiIGeb2ExdRzQz/MOUK6Yes0HanorUNuAC3pkbqMx8VaKx7DNYj+gAKWob13++Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 1/6] net: dsa: make dp->bridge_num one-based
Date:   Tue, 26 Oct 2021 19:26:20 +0300
Message-Id: <20211026162625.1385035-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ab512f0-26a0-457d-70da-08d9989d698c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB663759E64B2D21F99CED36EEE0849@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zAIjJur7GcCWmrrZaGdDMxbEoJ44hMMYNQAQovz1jroJf7iZAbIJYhza5cxrI1128s7m33wqdyUUyqUxER10qEtLU2nxNxkuiwKWDBhnIrqM7OOC2ywUQuuSNN6nfk4Rk8hei+oiAhkM1W8TUe1K/45fyFb7D3Vgf9L7BdUCjHdl/uYPs+t6WkXU8eWpONIPmriPgaZBvMak72WxmNlimPcYVCHLxqq9vaQ6r4H97BOkUGzRnnwhzGF8FxdVoqAwo9va202R8n7YJX3+G1aTphPfEiYzriOABQZCnRn2G6120UNSG+TYHWHvn4pGkDY2oUneTpSDMwzVnRudwD192zC5txauzOuoWuBJWwAoCoO5CfFlrvDwlbtFOC4iIpJDgw/uj/Pcf/weNU4BLSNHokvnh2Za4dh+Q52BP1Fqfbkxnjfmz4uGQV6BHLNRUKPGckXn24wNmQZU5vn0ZmRoXA1RPzZVjFLetCvE3I8oB8kWP5GtRAEhCElYxSru4rnh+2Q/lvg/est0YtaF/TDjs6PVYSoXbcVgDI1ghuzhYoQi1GYr0sM3Qc5DFmumPbFvbNyZaI8uXM+w+gqffJYH+4h0qaqjmEUqlEsjA7NHKxeWiqkcs/HFLS1TA8fLOWevbuItjF0BDpHET/gpvo9je6bV6QyaOrbfSnYWhnpj1E/j/i2k5ji1eftTmTayRi244YkwVAqGVOrs+iwm2OxWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(2616005)(1076003)(5660300002)(8676002)(86362001)(66556008)(54906003)(2906002)(38100700002)(316002)(8936002)(83380400001)(6666004)(66946007)(26005)(186003)(508600001)(36756003)(6486002)(6916009)(4326008)(6512007)(66476007)(44832011)(6506007)(956004)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5NiAEbOLD80CF95uweFZ0gy8J6dI5nWJVc3Z0WGzyE+QZQm5d1yOy/Wn9NEW?=
 =?us-ascii?Q?fBZV4LsSV5Eq0CdwFhr+Wjd/PcQYksvNoxgXRF2+pSWh5AraKetXcgz3CJVG?=
 =?us-ascii?Q?ZM8F45BNluGOEX0I+minqBmlSXPwsif9pXmc0ex4Vc2/U0pcoN13rSkwifzz?=
 =?us-ascii?Q?+6GiRYn24KNict4nM6A16MnV8ArL5jv4TMY8fVKWiHqLZmE31VBgbmeJ5HrR?=
 =?us-ascii?Q?Zmvi324GRs8OnpOban15tm2H1AUXB9cwnKLVoX3744EC/WjXFnxtnlP8pyvs?=
 =?us-ascii?Q?XDqP70v0Q50FJ25dsozGGhVQ0GEM6DaeyLULUwqMFnlYqrWszCSLTUlOBUZu?=
 =?us-ascii?Q?wXePdOoJEp15OlL0cxlLOADW04RKLYH+3L5hd6KGkFmrlVg8uAfYc717pxUh?=
 =?us-ascii?Q?wpykBhWAgWogmdFK+UmBCjPRoo+eUTrnm/mvSc28BnhxauzdDf0D0vWSESjx?=
 =?us-ascii?Q?tTGoQuLxRB52RwNKfbXr/V/aZw2NBH+QHONndAtdRCpLqcpGfvmmH7jZsgMW?=
 =?us-ascii?Q?UDXot+NcPJgEZbeQm1+sYlbRuKvA8+5x+pVJdXv0MDDw0TJ4SXpr2yUNEkAN?=
 =?us-ascii?Q?NwLvEn2kIUdgnvLRvHyU8gZ61a8McVyyW0je4OKM0lo3yF+y7/qZIA42vBzA?=
 =?us-ascii?Q?ATyS8aF0iQmB6CYiRWsu7wLSwhduR9f6NujrLlPVAz5pOnvCIAk+3AXuZkjO?=
 =?us-ascii?Q?RbulIAS2SebUHbjKJtPC8/ptjozAZsxCKccvR5iC1WuHySQeTZc+lMwi3jSg?=
 =?us-ascii?Q?+3ix56EI5ITwr+qO1X2pPELVAx/MenvFy0RZ6TGR84oDgQV+VFKAX5WeyACT?=
 =?us-ascii?Q?hyvTn/JbsZRtgUFzVMR8rotEiQdPspQQP+rJY/y/pvTD88vDNSrWihOQpUJq?=
 =?us-ascii?Q?jXpr5wBsyBc2Ix2jLkpfeuMv+tDuDNHJxXJKOIChyL0r2Avdi5h9hwPYz0yR?=
 =?us-ascii?Q?KTWIjvTgoXnjcAFOcRHRlHPzM1QPhbqDoQSyW8cymMGSh/Ocy1ghGjwyEMSC?=
 =?us-ascii?Q?QVDa9TFaiOZHdZaCveIDziv8ARVpeYx6LQkmKIjYnV75cuX0p7+qS+mIP6+5?=
 =?us-ascii?Q?p7zIyRybDfD8ZlQ2E7Fc+h1KWQBsRiwhLD6yK0kufLF2hJjcJgAbII4A/aCe?=
 =?us-ascii?Q?5sMpXkr3Cw/eOio4fUet94s0sSNiZnj8Q4Mha2Z/fbsb2FZQ0FB+zLw+ZvNB?=
 =?us-ascii?Q?LeXsMWj557onr3nzhiuFzmWIFCBrEDh+sBOt3lTsYOm3U3gmSjtB5xwY2g2Q?=
 =?us-ascii?Q?RU45t8+wK+cBFS6X1BdZED/zeJpM23MjBfStpXGPCVcgHKIf0q9SXc0lgspX?=
 =?us-ascii?Q?6eBLsp/qmUTqFjLHSCxUdnRr8vzZruXdOjaBqzTom+hKqtR/Avy4yPTzTw6u?=
 =?us-ascii?Q?nbcD0f/eYoY7ODF/YrZRlrkIeRHekzJhFcCAaL9pp2/IwHRabmedeWKT4MN+?=
 =?us-ascii?Q?ok1ZqJZAYNQl22W6oJvaGWH+FGGfuHlg9stWXfgSqDn04WrNNnlqDgy444zg?=
 =?us-ascii?Q?A+qeikyBAECEfVY7m7vR+mus+m3uOX8TjQoi2jKZGg1tsaojrI6cWvgSsZib?=
 =?us-ascii?Q?uc7VgkuTDs/AOwTNOmCbR+zfLn6ex0ur3yjzmiA+r+wfI2mAp2M52dxq371G?=
 =?us-ascii?Q?lPFDUs9pTGGiwQRh3wH1ieM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab512f0-26a0-457d-70da-08d9989d698c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:49.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCXxyJUl7pRMU1dpj4RK+fP2tAjGw0gUlKO7fY0yHKnMtOK337IAtqzx/8HOYDiFGAwifhtGFHz10Lr2zPVS7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have seen too many bugs already due to the fact that we must encode an
invalid dp->bridge_num as a negative value, because the natural tendency
is to check that invalid value using (!dp->bridge_num). Latest example
can be seen in commit 1bec0f05062c ("net: dsa: fix bridge_num not
getting cleared after ports leaving the bridge").

Convert the existing users to assume that dp->bridge_num == 0 is the
encoding for invalid, and valid bridge numbers start from 1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 ++++++------
 include/linux/dsa/8021q.h        |  6 +++---
 include/net/dsa.h                |  6 +++---
 net/dsa/dsa2.c                   | 24 ++++++++++++------------
 net/dsa/dsa_priv.h               |  5 +++--
 net/dsa/port.c                   | 11 ++++++-----
 net/dsa/tag_8021q.c              | 12 +++++++-----
 net/dsa/tag_dsa.c                |  2 +-
 8 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 14c678a9e41b..0d0ccb7f8ccd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1247,10 +1247,10 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	/* dev is a virtual bridge */
 	} else {
 		list_for_each_entry(dp, &dst->ports, list) {
-			if (dp->bridge_num < 0)
+			if (!dp->bridge_num)
 				continue;
 
-			if (dp->bridge_num + 1 + dst->last_switch != dev)
+			if (dp->bridge_num + dst->last_switch != dev)
 				continue;
 
 			br = dp->bridge_dev;
@@ -2524,9 +2524,9 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
  * physical switches, so start from beyond that range.
  */
 static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
-					       int bridge_num)
+					       unsigned int bridge_num)
 {
-	u8 dev = bridge_num + ds->dst->last_switch + 1;
+	u8 dev = bridge_num + ds->dst->last_switch;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
@@ -2539,14 +2539,14 @@ static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
 
 static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num)
+					   unsigned int bridge_num)
 {
 	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge_num);
 }
 
 static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					      struct net_device *br,
-					      int bridge_num)
+					      unsigned int bridge_num)
 {
 	int err;
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 254b165f2b44..0af4371fbebb 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -38,13 +38,13 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					struct net_device *br,
-					int bridge_num);
+					unsigned int bridge_num);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num);
+					   unsigned int bridge_num);
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
 u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index badd214f7470..56a90f05df49 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -257,7 +257,7 @@ struct dsa_port {
 	bool			learning;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
-	int			bridge_num;
+	unsigned int		bridge_num;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
 	struct phylink		*pl;
@@ -752,11 +752,11 @@ struct dsa_switch_ops {
 	/* Called right after .port_bridge_join() */
 	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
 					      struct net_device *bridge,
-					      int bridge_num);
+					      unsigned int bridge_num);
 	/* Called right before .port_bridge_leave() */
 	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
 						struct net_device *bridge,
-						int bridge_num);
+						unsigned int bridge_num);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 826957b6442b..9606e56710a5 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -141,23 +141,23 @@ static int dsa_bridge_num_find(const struct net_device *bridge_dev)
 	 */
 	list_for_each_entry(dst, &dsa_tree_list, list)
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->bridge_dev == bridge_dev &&
-			    dp->bridge_num != -1)
+			if (dp->bridge_dev == bridge_dev && dp->bridge_num)
 				return dp->bridge_num;
 
-	return -1;
+	return 0;
 }
 
-int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
+unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 {
-	int bridge_num = dsa_bridge_num_find(bridge_dev);
+	unsigned int bridge_num = dsa_bridge_num_find(bridge_dev);
 
-	if (bridge_num < 0) {
+	if (!bridge_num) {
 		/* First port that offloads TX forwarding for this bridge */
-		bridge_num = find_first_zero_bit(&dsa_fwd_offloading_bridges,
-						 DSA_MAX_NUM_OFFLOADING_BRIDGES);
+		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
+						DSA_MAX_NUM_OFFLOADING_BRIDGES,
+						1);
 		if (bridge_num >= max)
-			return -1;
+			return 0;
 
 		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
 	}
@@ -165,12 +165,13 @@ int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 	return bridge_num;
 }
 
-void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
+void dsa_bridge_num_put(const struct net_device *bridge_dev,
+			unsigned int bridge_num)
 {
 	/* Check if the bridge is still in use, otherwise it is time
 	 * to clean it up so we can reuse this bridge_num later.
 	 */
-	if (dsa_bridge_num_find(bridge_dev) < 0)
+	if (!dsa_bridge_num_find(bridge_dev))
 		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
@@ -1184,7 +1185,6 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 
 	dp->ds = ds;
 	dp->index = index;
-	dp->bridge_num = -1;
 
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a5c9bc7b66c6..2a64c41813bf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -546,8 +546,9 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
-int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
-void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num);
+unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
+void dsa_bridge_num_put(const struct net_device *bridge_dev,
+			unsigned int bridge_num);
 
 /* tag_8021q.c */
 int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c0e630f7f0bd..1772817a1214 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -273,14 +273,14 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
 					     struct net_device *bridge_dev)
 {
-	int bridge_num = dp->bridge_num;
+	unsigned int bridge_num = dp->bridge_num;
 	struct dsa_switch *ds = dp->ds;
 
 	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || dp->bridge_num == -1)
+	if (!ds->ops->port_bridge_tx_fwd_unoffload || !dp->bridge_num)
 		return;
 
-	dp->bridge_num = -1;
+	dp->bridge_num = 0;
 
 	dsa_bridge_num_put(bridge_dev, bridge_num);
 
@@ -295,14 +295,15 @@ static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
 					   struct net_device *bridge_dev)
 {
 	struct dsa_switch *ds = dp->ds;
-	int bridge_num, err;
+	unsigned int bridge_num;
+	int err;
 
 	if (!ds->ops->port_bridge_tx_fwd_offload)
 		return false;
 
 	bridge_num = dsa_bridge_num_get(bridge_dev,
 					ds->num_fwd_offloading_bridges);
-	if (bridge_num < 0)
+	if (!bridge_num)
 		return false;
 
 	dp->bridge_num = bridge_num;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 72cac2c0af7b..df59f16436a5 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -67,10 +67,12 @@
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num)
+u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num)
 {
-	/* The VBID value of 0 is reserved for precise TX */
-	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num + 1);
+	/* The VBID value of 0 is reserved for precise TX, but it is also
+	 * reserved/invalid for the bridge_num, so all is well.
+	 */
+	return DSA_8021Q_DIR_TX | DSA_8021Q_VBID(bridge_num);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 
@@ -409,7 +411,7 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 
 int dsa_tag_8021q_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
 					struct net_device *br,
-					int bridge_num)
+					unsigned int bridge_num)
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
@@ -420,7 +422,7 @@ EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_tx_fwd_offload);
 
 void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 					   struct net_device *br,
-					   int bridge_num)
+					   unsigned int bridge_num)
 {
 	u16 tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
 
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index b3da4b2ea11c..a7d70ae7cc97 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -140,7 +140,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		 * packets on behalf of a virtual switch device with an index
 		 * past the physical switches.
 		 */
-		tag_dev = dst->last_switch + 1 + dp->bridge_num;
+		tag_dev = dst->last_switch + dp->bridge_num;
 		tag_port = 0;
 	} else {
 		cmd = DSA_CMD_FROM_CPU;
-- 
2.25.1

