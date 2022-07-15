Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23589576444
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiGOPRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbiGOPRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:17:19 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C2622533
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:17:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9R/r6qmzvZVayjTAD5woVUtts+XpHc1W5k1oDIqaHrIWoLOxn6trc3VFbaOlvwCZn3emAEI0+x+YTkDs350/AQDGKuS5wsNP+FDHGlJeOaExzPtdDQSGgFGQ+HlgZSeaXAzdjJP61Y6whMsqD6PaxxKtJnaQDIW6pjEgd6oyQnCVy6ZpTiMUaEW6u3P3IozfZfvpQwtKH30VfQKGB7hijTDj0EAPPmUSIeoASxEnA0AoraBkhgISbJB7/3De60KqCZ5MXzQuLdoBx0xA5+on5nziFGmEk4UFSdmdgg+owsMM2SVuZV/DdpwQoPNDCVPSOmCSh+qbjdFEfcPzJJyaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0uGQBeoZO831YWV0grJ2vzzLi78pGVg/BCN4VIqZxE=;
 b=C4Z66W49nTbp/OD4BeN5ncgRWoswNDc8iDFFc5uwOEbGDee5YccUjSICrrlS/jf92hs5yYTcyO55RD8bPQNmKkJKzFapAVdI96Ut9sAFVK218WXKdLUOixOkRDbN1lkpLJIgG0fHWmM7U75eu6v9Q7FtwgzFPDgDailOx8HGCyFh/zKQ7EJWRb8ttKAVrJKsihEaPDsxZIUEQ5BF2bsSWH6kmpSYnltJFJj4IR9WVA0zOstIp5H78jBzZt6Q7xhvP5ycSPsITTbjIA9WDu+Gd8OhAky8gsNLAoZ1yt+t7BftPBbwG0oRR/690JzqxNuvT8PBnTUs1krtjjwJ1ct+HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0uGQBeoZO831YWV0grJ2vzzLi78pGVg/BCN4VIqZxE=;
 b=l4M9vthTXJ8qyM12ygMDLs/mDgt13JvLoqD/ZI9MNWgbt5p3RhayeNMqZhExdNtgzZSbXE4WXFuYnEaBTHRgwcP5lwSQQaa7zLCPHw9uzlISY1apVtweCWCSbgDU9DSgM0y4j3uOcs/q3SwwaO+C5+joQ+uvZp6HB7n2kkXvrT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4192.eurprd04.prod.outlook.com (2603:10a6:803:4c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 15:17:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 15:17:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lucian Banu <Lucian.Banu@westermo.com>
Subject: [PATCH net 2/2] net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering
Date:   Fri, 15 Jul 2022 18:16:59 +0300
Message-Id: <20220715151659.780544-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220715151659.780544-1-vladimir.oltean@nxp.com>
References: <20220715151659.780544-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ba4d138-b6ce-4661-8c3f-08da667518a3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4192:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9xmn4YExuBvWaO+FqTTmKzJQUxWaZoM934jeWexkJfLHRQDPeIc8ojifqaT/oezmhqZjNYTCSCm30Av3fRYB+Z+OGsWHwn386cb2TpMZOUzk+IKZEnt4wukPgZp6oBvSpmfeQ/O5Mqa8D1FRnIDpEccWD/kXyvTH59JggcsKIFcZ2whhRNhnGidI8H90kP/NawvrOvM0h55n0MP1slJbwn0v7sZQbyr5Vxy2blvgu+5abRCTHAUKNrQMwRiesa11DY+yoP54jXhTyZmVEdE803kRxv05kohyalaztZmBsvP1MW5wEI+4yrAA4Pj7AAYz4EpBQ0uaN7Z/SUE6F9zoDwPVOtvwEaInxEwniTkP42lYluLqd0pdgjFP3Wme9fbVuczR9fBkF49skwpUIJPD6oGuNPgxsL1cnbJf+MLWcRzbLi+6+uME9SyEFMuMp0J5OgFHnS6qbNEmOUWjenQ8ZZwQUqDnabXTimnnfZnDP7hGd8ohVF6NwI1NYFGytx2iacQhLg8tvC1CZbwTjetXeVoa+l01rZ7xojUWC8OJvOuVqe30zBq4gXhAKmq+IWNqlmp54bs3S5qy1/YDENAZCS0IvlK50zeNJvlQENpOdimqKTr+MxNEJeTc/HT7V+ZkOSI8sW3i/cgl4W3U3LUJJtUYJbeBL9hiRXiEZLtVAfaYK/dJeh5CdbF744bIE4hwtdnY04/rtlGbLwQKURCBEUN+GceqMDka2dBVorpFAmsRCxWATIQuoy83n2CpE4ck0/lvEY6tu1cXxxVbxCwdnTAVnBXO+C0J3mKwO1CYJ6pAOO6VBtNblWhBXTuvjacw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(478600001)(52116002)(6506007)(44832011)(186003)(6486002)(38350700002)(26005)(6512007)(38100700002)(86362001)(6916009)(316002)(54906003)(1076003)(8676002)(66946007)(41300700001)(8936002)(66476007)(66556008)(5660300002)(4326008)(6666004)(2616005)(2906002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BYaQ1z+KeXSdcpwbSyFYRNq2JkLCts3Cg8JRstBquCVKGDLqHSS+wiZrl1/4?=
 =?us-ascii?Q?a+N/tkWwH9Qsnux5w52SCeifY/v7uJnv7/EYdO+rooDI74VGbs1WycnYv+jJ?=
 =?us-ascii?Q?CrRorzKhSLfws0i8/0MhsahGnLiLQqOgcFF4uvhKGB9IKgKTyfopuxIiCOyO?=
 =?us-ascii?Q?DtuXA8NovHK7/fznwhfk7iSA42Gq4DC/HHP9WvTby/YaTkImQ/A3UckjUS/X?=
 =?us-ascii?Q?2aePcTLAgclU1IY1NtiT0xSkb3Tg6dnkA+CjKxJyaYzY5irJu5SwN8mJUq76?=
 =?us-ascii?Q?UjnQ3P4E1KzOiPPCdLoXkCtWD3Ya8i9Any1l1haFlXWCalEg4LDrWYS+hrQo?=
 =?us-ascii?Q?3QdQy5JHQDr5odia3uVU1C8efjl4iMEji1EE2x2tg9YRvBCz8LviTIyvOcNx?=
 =?us-ascii?Q?WbGbsclPW0MvhNTiI5HN5OKxzAnwm13/YCbKbfXxzl0X71HhHflMSb4Gwot4?=
 =?us-ascii?Q?V7tDn9mTo6plfwjgTZGgdf5O7ysnS7lrnytTcz5zFfykpY2WR2h5EdTcWXFV?=
 =?us-ascii?Q?RY2Yswdo+kyR9OOwoEK2DKBUm2Ivi8Qn+p7RjlcI/flBjxrIR9Oiub47wL7e?=
 =?us-ascii?Q?N8Ayb39C/12iXEtz5Cg0Nb5pRMcYxV4izoT7W/rTcBPYjWNHxWYpaAzYAXqO?=
 =?us-ascii?Q?knm/DX3Ye0YFL7vdSw/4OrsCtjthHPdPmVxVLYKHLxscq653fJQXl8RgCGJX?=
 =?us-ascii?Q?DmY+Vs2fW4aRVul+caJlhxtCNbjMUQXhuSijjKL4s9aL8QRYDu2xIECrT/WJ?=
 =?us-ascii?Q?bnmrw9C4/RWnVAecyViPQpB4IELyc4tlXc9rqu4Ct+1bCGOU/VVJxZhZF0zm?=
 =?us-ascii?Q?7IyVOCPiSoN7327a9u/wS0aCXIwEhePXSj/NmqPZiK1i9R6gAq7OVqnuomEF?=
 =?us-ascii?Q?9tw7i/tR1QQfJvfRs4pAFghJRkN+iUmu7FnAp3p+elbtx+flekwTkA6826rV?=
 =?us-ascii?Q?3GMiYLcHrbyjazQ5jUZqTbr0QUdag14A65QWXhT1iMh9KOqOUxP3Ar1Dds4W?=
 =?us-ascii?Q?KyNLJ373hGBQrAVWlSBrZ5rf1G4SAZkRljTBf1bolrEugKkhnTLEhCpIXyLx?=
 =?us-ascii?Q?Rn3IJk6wYF6d8YchGYThSpI0ARc0fB84UUAKBE3L+LPM7TPqJuFIrKOIgroL?=
 =?us-ascii?Q?gyQtDDPIsQHF0fpo8JkWWItPZa1WL+SUJM9dTUvY2Q8ugjhQ2OpKJ8vLLj8C?=
 =?us-ascii?Q?7Aea+xmqjS4JNPCcuJ8gIVU/Ey0I5itohrywIeitVQpCqBDQOPmFfxz0nCsq?=
 =?us-ascii?Q?jET9xhNv0zQPSBSSw8+lCdfFkdcfkwBCZKbhoEZd8xSFFGaLefQSb3d2pFVI?=
 =?us-ascii?Q?/RAD1QUfiUJ7NyJ/NP4aKCdUfI2iFS2KLO/qBEgapRNnzczHusKL5Ppy2V4I?=
 =?us-ascii?Q?RASTLe6j/MF+5UXRANPBAwDOsYrI9MnHebo5V9+NeZMXNYDLie7hjW/2se5S?=
 =?us-ascii?Q?8qta8O/p+6mxRMPTEJC9O5NSltBkfqLlnyNq0Gz1EzJfVpL0ANG1WVvqAoAK?=
 =?us-ascii?Q?Gjh4ECwaoHOYSn3Qr0SCFDCjuwGPTX+qzKsBPZTsNLDGH6VDu7zSu1Nb2wM9?=
 =?us-ascii?Q?fsYltNTBnRGTICc7wEXJeJ9qFsaZTh3bgvYxmte/8q9YSM3OPVM2BA2PRMga?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba4d138-b6ce-4661-8c3f-08da667518a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 15:17:13.8799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ve4dCKNnVrAabsagj44RtiBaZ3PBwxRDEqzy6V+k7oF0SpnS64ympmpy+HcJsMrQHudai60ewogMog0nJMGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4192
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ds" iterator variable used in dsa_port_reset_vlan_filtering() ->
dsa_switch_for_each_port() overwrites the "dp" received as argument,
which is later used to call dsa_port_vlan_filtering() proper.

As a result, switches which do enter that code path (the ones with
vlan_filtering_is_global=true) will dereference an invalid dp in
dsa_port_reset_vlan_filtering() after leaving a VLAN-aware bridge.

Use a dedicated "other_dp" iterator variable to avoid this from
happening.

Fixes: d0004a020bb5 ("net: dsa: remove the "dsa_to_port in a loop" antipattern from the core")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index a4052174ac50..2dd76eb1621c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -248,6 +248,7 @@ static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
 	struct netlink_ext_ack extack = {0};
 	bool change_vlan_filtering = false;
 	struct dsa_switch *ds = dp->ds;
+	struct dsa_port *other_dp;
 	bool vlan_filtering;
 	int err;
 
@@ -270,8 +271,8 @@ static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
 	 * VLAN-aware bridge.
 	 */
 	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *br = dsa_port_bridge_dev_get(dp);
+		dsa_switch_for_each_port(other_dp, ds) {
+			struct net_device *br = dsa_port_bridge_dev_get(other_dp);
 
 			if (br && br_vlan_enabled(br)) {
 				change_vlan_filtering = false;
-- 
2.34.1

