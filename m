Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC1F6E32BD
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjDORGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjDORGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0021F30FF;
        Sat, 15 Apr 2023 10:06:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEOU9ahuddSxx8jCAGjAVMJBNAXtPrXKBC6isK3YxbEjfMS6iVEU7jZ/OY/pv5PrkhfzUUZhygELcBHJlfWUG1585Ajp45e0XwWcv/RK+4PUHEyX6izqJ3oCV1bYD+L3X50hboDeSdQeoBr14i2hj2F/qa6IQXTRceMcBDFJk0Wd5/FI6MmS6fK4+q2MhCm0YhVyL15WVqMgASaE96NeqRz3jyM9caVM2vailNkljKzyZ+UEUuOOONd+JtNtJ2EHSDflOUAhlk8ZMNAKcVu1LiOSUy1Fqdd8EkLNsH7kbr39Yxk6R8llwT/1Mj1Su/1hgjjU9b/jRmaw6AcI/gzT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKKvJOlM4rnzpUvjC+Fbg4PE+j+tCBd+KEfJqGHZHFE=;
 b=SRk22bf9wK8HECI+rbDFa3rTmcZWFZ4a/PtJMf1KMrhIgtqhQaSq2yjUwSqNM4DeW6PJR4wCPUgTKrxtg/PgAEaPHvLRCz/NBTxbn+Al96kx8W1e3DXj/B92Hg9LfyN5hL000Sak+6HKPnEcn59kYbGisEebNDX2rJFqRu7G0uDOp24zLxLGzQANSIX4MvNtmnHhRNvIfWs38LFkp06CFjCogJfScsSCxHWvfRsXrAcDyliOUeqsqspOoR4z2Z3nGQDaLMstx+Me687EnTUt53vff1049kp4tQ4afqq+Eepf6gKfffAhNgrwqUU6trhYVJDckzlA3Fgsz3EYAT9SDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKKvJOlM4rnzpUvjC+Fbg4PE+j+tCBd+KEfJqGHZHFE=;
 b=afcuN0V8rDRlZTiefXKHUOhwF1ZXfRHbRj5oyLY4sz1f4T8s2OYizkJY4rtVf/5eQxQk62hWyRCztW8LPKqmIqRJHJb5ZM3KlQCZP58cfuFq8Pn2xIEV1BsyS1J3rtRIXXK+0Lg5h4+VW2CLJai86ZIOG/YHhO2N5CVPrleSKzU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 7/7] net: mscc: ocelot: add support for preemptible traffic classes
Date:   Sat, 15 Apr 2023 20:05:51 +0300
Message-Id: <20230415170551.3939607-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5367ed-2f33-4946-b9f3-08db3dd3b5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prWAJPNuX2LPBjoIVogSxxjAexwEa7fB3rXR6P9+9ufYf09LYDU6L/7msElNGi3LW+tCCoXMtSBSfVMX1A5HonYp6BYMPFfrvNH+rn4LWBfIetldIYXb1DPZC5EVZRuEdVs/oWvXSzYh1pWcyRtFk3wOde6bmbLD3ekSHjNT1/n0EMMSleRt4KiqQmhs2gW8gjfmycKQE6vmH5zTdaAwTHPmefYpQ3nBf91cwUwtyksxJY15pYnL/CNfLmEdQX4v6K7wFWz5if2TPOXQzjpZBRfEgouom4wa/tnGbV9W8cmX2GMYT4sEzHqFEawMnK9WkzxidMNuxGJrqxFjEi0TdCTuc+RxxAp7J+OjXibSELtHCHqHupisvRny72jtO4e3sFnUlMkvnq8W5Br5I5n3C8S+FS7P5O8NAzyH2tbl+dJFB26GdikR5RlXLbRTpGwlbmFycj1KVwq6L1FRjO+C0NBqTXLeDqgj8Y7uZ6eD7mY+LXnFluv3TbtGJMvDvuZcqh4VKXjioJcKTS9MGZNBPS1Ya2KDe+ONCQJ69rWJT6WDJgleEPPhnsDVYtEjhy3ixrwVq3nar/hAvqVlzCHtzkpjJ93fxPdmtpxR2vXEScQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(966005)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eAiFeqHdHB0CUfSw0qwMExFRRfLeqjQb2ODhLIm5Xa8ROdRH0XVpRd7uE49+?=
 =?us-ascii?Q?tDjChpreX85b6eoFwffHqwNB0tz5Fq3B3Y1B5JLMH3rYIOBU2EP0URiIH0CF?=
 =?us-ascii?Q?kGTkd8ezlaoIy5c6u7Gk826/H2aCMnJPKn5f0M6CQpc2TTnfndrCH6wyBJZe?=
 =?us-ascii?Q?WezpA5Lmb0jiYqbqE6t/qzxt0Mlym1M4sUnQHDQ4qton+/P4P9dfhB8UHHwC?=
 =?us-ascii?Q?znZdsa5jClzgeRrbsdOB6S+EIOSdU4Ml8vZw7W7O64UKBXZOoFcoeyRXllj1?=
 =?us-ascii?Q?Nn0AVZN5/gFEhVY2egNQi5nESJWem+mGuCTFL5WDGUELQepY7GWVHKCgi7Lu?=
 =?us-ascii?Q?d/gUTTG/sXGjNxOEwVp1ZhTidW2qsQyY4P8ccrz12czCNXYrNZ5/51yeJ69q?=
 =?us-ascii?Q?083L5fcCpBSabHuh5vRBpMU4sGK1ysJu9CkOcbezezTbNzzzPcazcYwKyuaM?=
 =?us-ascii?Q?7wJ5XgkmjDc4Za16pV9oLxfK3lUWf/jib1jXb+tWhNUUdgihqSHPKl9cP3Wk?=
 =?us-ascii?Q?uj+cKdwNIDxY1J+wC+/LipAhdL3f6KZUMOEqiswGdil6s1LDn6W6Qx0IOh9H?=
 =?us-ascii?Q?v8alFcDd7lPIisj+j6LBc5+qWXFzO+EAJVGxaZ8A77C3FJ894P185hAs0PW1?=
 =?us-ascii?Q?lr/p4G3jCgmA0n6F39sCRYKe4X2fqcquxQ2kTdWM+ISBt47sb69ZynTPo5RW?=
 =?us-ascii?Q?cxmG2hVBDkxyA1Z5mE8R4+ha+IPOT3zozQLTyIgvOPUP/ZOlCIKPNzVPTf/O?=
 =?us-ascii?Q?cjlvJ20Q23k2UnzFo8IYWomZhhOSXIcF6pcLgpzzK+TPqFm3Oz7iiOhnqXPX?=
 =?us-ascii?Q?32H39YKQs4h0VVUGwbJ/nPRRBZdmcjEpjb5ix5RwWhfWtzzd593c9dGyqbY+?=
 =?us-ascii?Q?lP+F8ODDtOkJivDi5Y9l8biniSMXkMtiW3GXvr4LE/CWGOsZH1G1FS4Xi6gR?=
 =?us-ascii?Q?mFPara6l+U8nu/7LbCukCOr6+XFxuqWJ4AIkZ5OkCL4mltMZTAww0LsxElUL?=
 =?us-ascii?Q?/HAgm7/7fZIU4vg51rIptK4aUQfx1vPYaODXmUpQ1zlNUl6w1hDEpL6gsudX?=
 =?us-ascii?Q?MEU5B+2H4Caj1g061OwfX9MM/R9OkwA48ZQ9v1oKDihPCnHVFuOtqIp4vTEr?=
 =?us-ascii?Q?kiM9hkSSMaDkNZJjwTJU252oIfGelyeksSqHqDKAc2VSBHi1vWOrjNvgLXI/?=
 =?us-ascii?Q?twAC/KjtdMSMMe7FWbxm0scgXpcML55S6kfG1h9SJ3VlLJ2h3zqy/j6mW0ld?=
 =?us-ascii?Q?C9K19HIzbcYrZ7ADbar2rv6/tF6+yZvJORP/fwbS/zENMTbRelmmeVj+gSmw?=
 =?us-ascii?Q?BJ8OWcG0huYttE4uz4i/8yiExOsIgkdrIgtgsG37xowDjCn74RYpjxU2oItm?=
 =?us-ascii?Q?MkFBWJYHzhpTr5nFU73YkMwjbyqsWmU31rTsfhyNiJRSF9TQFZkF+G5f6Nx9?=
 =?us-ascii?Q?i51K51i/UKtyARl2drLCwiilT3OPTC+0ohYomOyReTimeK2h+sZSRiP5X1oW?=
 =?us-ascii?Q?UxIy9CCgYh4F9pVM+ZZqgBTJqWSQ1Cf15oA6PVlvR+/LP0zOGlH6sNqWjvb3?=
 =?us-ascii?Q?ZY8H8jCRixR2/DiS9qP+skrHn1wAR1QCYezA41Z25QrGB/W6OJiU2d3/QtJc?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5367ed-2f33-4946-b9f3-08db3dd3b5e1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:10.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhjfJH8F0cbKoyLJF1XGeaR/skwdxo8duJ1u1cEUx4RG58Pcpb743+NWTIte51gelfen9+d4LDiSUAkQYwyH8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to not transmit (preemptible) frames which will be received by
the link partner as corrupted (because it doesn't support FP), the
hardware requires the driver to program the QSYS_PREEMPTION_CFG_P_QUEUES
register only after the MAC Merge layer becomes active (verification
succeeds, or was disabled).

There are some cases when FP is known (through experimentation) to be
broken. Give priority to FP over cut-through switching, and disable FP
for known broken link modes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Diff vs
https://lore.kernel.org/netdev/20230220122343.1156614-13-vladimir.oltean@nxp.com/:
- keep track of active_preemptible_tcs separately from preemptible_tcs
- simplified locking, now using just ocelot->fwd_domain_lock
- updating active preemptable TCs directly based on mm->tx_active rather
  than based on verification state
- added some debugging prints

 drivers/net/dsa/ocelot/felix_vsc9959.c |  7 +++-
 drivers/net/ethernet/mscc/ocelot.c     | 10 ++++-
 drivers/net/ethernet/mscc/ocelot.h     |  3 ++
 drivers/net/ethernet/mscc/ocelot_mm.c  | 54 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  3 ++
 5 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e055b3980ccc..cfb3faeaa5bf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2519,6 +2519,7 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct ocelot_mm_state *mm = &ocelot->mm[port];
 		int min_speed = ocelot_port->speed;
 		unsigned long mask = 0;
 		u32 tmp, val = 0;
@@ -2559,10 +2560,12 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 
 		/* Enable cut-through forwarding for all traffic classes that
 		 * don't have oversized dropping enabled, since this check is
-		 * bypassed in cut-through mode.
+		 * bypassed in cut-through mode. Also exclude preemptible
+		 * traffic classes, since these would hang the port for some
+		 * reason, if sent as cut-through.
 		 */
 		if (ocelot_port->speed == min_speed) {
-			val = GENMASK(7, 0);
+			val = GENMASK(7, 0) & ~mm->active_preemptible_tcs;
 
 			for (tc = 0; tc < OCELOT_NUM_TC; tc++)
 				if (vsc9959_port_qmaxsdu_get(ocelot, port, tc))
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8dc5fb1bc61b..1f5f00b30441 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1006,7 +1006,12 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	 */
 	if (ocelot->ops->cut_through_fwd) {
 		mutex_lock(&ocelot->fwd_domain_lock);
-		ocelot->ops->cut_through_fwd(ocelot);
+		/* Workaround for hardware bug - FP doesn't work
+		 * at all link speeds for all PHY modes. The function
+		 * below also calls ocelot->ops->cut_through_fwd(),
+		 * so we don't need to do it twice.
+		 */
+		ocelot_port_update_active_preemptible_tcs(ocelot, port);
 		mutex_unlock(&ocelot->fwd_domain_lock);
 	}
 
@@ -2705,6 +2710,7 @@ static void ocelot_port_reset_mqprio(struct ocelot *ocelot, int port)
 	struct net_device *dev = ocelot->ops->port_to_netdev(ocelot, port);
 
 	netdev_reset_tc(dev);
+	ocelot_port_change_fp(ocelot, port, 0);
 }
 
 int ocelot_port_mqprio(struct ocelot *ocelot, int port,
@@ -2741,6 +2747,8 @@ int ocelot_port_mqprio(struct ocelot *ocelot, int port,
 	if (err)
 		goto err_reset_tc;
 
+	ocelot_port_change_fp(ocelot, port, mqprio->preemptible_tcs);
+
 	return 0;
 
 err_reset_tc:
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index d920ca930690..14440a3b04c3 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -119,6 +119,9 @@ int ocelot_stats_init(struct ocelot *ocelot);
 void ocelot_stats_deinit(struct ocelot *ocelot);
 
 int ocelot_mm_init(struct ocelot *ocelot);
+void ocelot_port_change_fp(struct ocelot *ocelot, int port,
+			   unsigned long preemptible_tcs);
+void ocelot_port_update_active_preemptible_tcs(struct ocelot *ocelot, int port);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index 3e458f72f645..fb3145118d68 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -49,6 +49,59 @@ static enum ethtool_mm_verify_status ocelot_mm_verify_status(u32 val)
 	}
 }
 
+void ocelot_port_update_active_preemptible_tcs(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
+	u32 val = 0;
+
+	lockdep_assert_held(&ocelot->fwd_domain_lock);
+
+	/* Only commit preemptible TCs when MAC Merge is active.
+	 * On NXP LS1028A, when using QSGMII, the port hangs if transmitting
+	 * preemptible frames at any other link speed than gigabit, so avoid
+	 * preemption at lower speeds in this PHY mode.
+	 */
+	if ((ocelot_port->phy_mode != PHY_INTERFACE_MODE_QSGMII ||
+	     ocelot_port->speed == SPEED_1000) && mm->tx_active)
+		val = mm->preemptible_tcs;
+
+	/* Cut through switching doesn't work for preemptible priorities,
+	 * so first make sure it is disabled.
+	 */
+	mm->active_preemptible_tcs = val;
+	ocelot->ops->cut_through_fwd(ocelot);
+
+	dev_dbg(ocelot->dev,
+		"port %d %s/%s, MM TX %s, preemptible TCs 0x%x, active 0x%x\n",
+		port, phy_modes(ocelot_port->phy_mode),
+		phy_speed_to_str(ocelot_port->speed),
+		mm->tx_active ? "active" : "inactive", mm->preemptible_tcs,
+		mm->active_preemptible_tcs);
+
+	ocelot_rmw_rix(ocelot, QSYS_PREEMPTION_CFG_P_QUEUES(val),
+		       QSYS_PREEMPTION_CFG_P_QUEUES_M,
+		       QSYS_PREEMPTION_CFG, port);
+}
+
+void ocelot_port_change_fp(struct ocelot *ocelot, int port,
+			   unsigned long preemptible_tcs)
+{
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
+
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	if (mm->preemptible_tcs == preemptible_tcs)
+		goto out_unlock;
+
+	mm->preemptible_tcs = preemptible_tcs;
+
+	ocelot_port_update_active_preemptible_tcs(ocelot, port);
+
+out_unlock:
+	mutex_unlock(&ocelot->fwd_domain_lock);
+}
+
 static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -74,6 +127,7 @@ static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 
 		dev_dbg(ocelot->dev, "Port %d TX preemption %s\n",
 			port, mm->tx_active ? "active" : "inactive");
+		ocelot_port_update_active_preemptible_tcs(ocelot, port);
 
 		ack |= DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY;
 	}
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9596c79e9223..cb8fbb241879 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -749,6 +749,8 @@ struct ocelot_mm_state {
 	enum ethtool_mm_verify_status verify_status;
 	bool tx_enabled;
 	bool tx_active;
+	u8 preemptible_tcs;
+	u8 active_preemptible_tcs;
 };
 
 struct ocelot_port;
@@ -1158,6 +1160,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_state *state);
 int ocelot_port_mqprio(struct ocelot *ocelot, int port,
 		       struct tc_mqprio_qopt_offload *mqprio);
+void ocelot_port_update_preemptible_tcs(struct ocelot *ocelot, int port);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.34.1

