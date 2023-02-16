Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5113069A24B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBPXX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjBPXXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:23:05 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2075.outbound.protection.outlook.com [40.107.104.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE27753831;
        Thu, 16 Feb 2023 15:22:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ow/NQrWjRf1QSurYhU28BMuBglGv/TDRulpVEgjkHBR9TjHpGCsLxUsfsRAFcK6h8fsNvNkCGq0dHNsZC89Ey5PjMTx71hixfnLfe8MUStSOfyyjBlgUpExO6kpxKDulaU5qPECPOGpOS9+klIXocG+rbHPrbeaMYYBSLTMqAGyJrp16jPUGegrAvR8R0//0sK3zFUnk9B42u+wkrvgwiiWEWRUb93EIUWvkqE4Szcbyo1/PkAI3Rca49MTOLi500YaEYLs1gWps52A3NKyEEwJ3T5S3x8crOMdD7wS/Gvfslax+unJUmWFBtG5uT+leJ881ay0HQTpXR7fJ7b4TLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8wagc4X+3+nBvx9IXv7O389xaHEKXmbQE+WmjvfWgY=;
 b=nZt+H2GUy1BLrPw2mAQV5Dawy9zoLHlstr3fC9S+MnIQ1ZQMo7rIiCCj42Lb/qrFa+Dz8asbYHUu3+m7UYCZD9msYmEqEyzWvHckb7E17ey2ezhRBMnGm6kPuy9fU9tSsxOWwUJgUiA0sG+GLpIbtzMw5R1VQOE+HPSATVK99vDHSiti4NtHdttvqDa/Ndchc9nmPb0NJTovfda8O4KXE7wLnRTSI8GYk1Lp+4TDwTkRmmL/5h3iVUoDdAEGbVXp/qMxvktJ7isIerhv4Hp3CuoEytZP+IWpYjOflCmsb877/+zDNjRkvPr2F1rvfjIVJnfGocG13MuwT6OO35NSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8wagc4X+3+nBvx9IXv7O389xaHEKXmbQE+WmjvfWgY=;
 b=rJ1hrilZwGUkwB0RWsuNXZDucGsGZ7rQ+4XvprMmCNIL0meDP+oHLRq/Yti1+wFMPDHJC93c+/Qtp5351aI8qHsKBirqIlX39FW5sS20rJfB6cFVbQhEKMtlDcOuK0KOntdfGOxUrTfvK4SWVf4d/Ce290LpsJV2dDw/npvR7v8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/12] net: mscc: ocelot: add support for preemptible traffic classes
Date:   Fri, 17 Feb 2023 01:21:25 +0200
Message-Id: <20230216232126.3402975-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6c4637-8a38-4939-df56-08db10749637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: heM1h6pzKeg66La1ZvMxliPZ6Fn/8owrRQ8eo9UtF+CFsXeFRY0PridKP4b2i1x9HnKgocGjwdlmCPnxHIlgJCWEQSNa2b2AeK8HihAvIbSjwVYJJYVj98KT15EcaVE4FvSzGb/kneiPuLFGXluHytv1HgZEa+VMts2dxKb96JU4NMOR5Kq5bbcKpgvZMJUybj8G6VVVrocS5fCaRIEgMgUEzgT7HyWRZwcFCv5o3Nqwt15B6SphJXA9WqXzUe+GjPTlGmU3whJhQHL8uSR5fVprzq5bWW77wHqwKg9wMZv5VArRk72o91x2AZh0BmX2G43RCbz9755YpfajOsSXX62BqqiWq0FFfkzJPkLnI0oXmGdOMWFU/KvWkorKre1v8rMKk4hNaFtANnn3J4xtTbJDcrEy7GlwyuyfsbKrgDrGDH15NBh4Exhc1FtlilUEYYQiGIEIq6JfmL3uGmopMHOpFyGQZ422rl0Y9l/beJpRWMQKwPTbZOTUsGDc9ELWerRkm7iYQN3fc29ZcxqYggp+gKsfBA68Ge9rJV2fqfdxzEiEYfBCDZvf52R5PrEWYJQeXnPxQ6Z8UpefptYXszytu59gAOTzcKoU4n3P7RREGNzN79PqfXgI4kRBlNur4te3lh1uG64rxyhcNVha2BaH6AGcSaxIpSo/lOBzC3YWqRAJfuydr/kZa00+HyZsA1b2Qyez/AS8Aj+2vSNIAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zIfZHMCW0kIbDYd8DULdnrfWGMLLi6tLpEJcg1E4XCytYq3M0M7OfmFPf7B2?=
 =?us-ascii?Q?/SDX7CAfsKilTaJlmTOy4gulE0u2RrjupYCmf5YZ/U5pjAdGzOAECFJZ4j6d?=
 =?us-ascii?Q?ozEMbLqFEaFOwhyUmXUXHVabba0wv+/xETOiqwg/kcPvUmlhLi0cbwtppECW?=
 =?us-ascii?Q?3wxs6HTLx8tZUPb3yEhpgW5TLaFI2gBINdmbgXIHhwp8QzKA/G5yot75PdjI?=
 =?us-ascii?Q?XCTYZYnXaIUBc+8cHf6ObUbGBZiI3ih14y73WQUBYyreyQh9uWWJeCTEWYTA?=
 =?us-ascii?Q?fY/CC87rGh+hCMuCGOFEg9CtF1W+nEWhGQYNZ+LuzdvLhlS2973g2jQDQXyi?=
 =?us-ascii?Q?Bw/XBVRHyf8VBAUnmPyKoHpBHqx9J4IHl4l94O6A2o0dxsMveEVJNEIgN7Er?=
 =?us-ascii?Q?5AKODURFgs4m1NzWShliTNnixPMS4CHcbOi6qCOAjpe52aY0LS1m8otjR1p0?=
 =?us-ascii?Q?rW3DmHHxUTrFi+MZWFRtbXSvxpSEZ8XnNWEfA+oTKE15oNSx8rxJKwNQVokl?=
 =?us-ascii?Q?oqhB0w2YdWU90B0NDyt3ALBgn2o34lPpo0fmV4cgeW/8FaPAIM/aLJ+DjwZQ?=
 =?us-ascii?Q?znl3SkwNZQJ5nTldKQtYWqLzLPHI7W1A7lUxncQNspb4noM3VQX2HBxx1iX1?=
 =?us-ascii?Q?wkMjFlEmDESVN//DPNNj8GO4FHIBXBiR48KsLRT6U414xFzELA/7EL9Nv1/s?=
 =?us-ascii?Q?B5QUOSk9YTwV1A1uYJ7c8oCrtjJF7tTzKnzVNgAKokr05mBEBPV57WFt64t5?=
 =?us-ascii?Q?TXtgMaI4/r5gvWjvP3NYXk34ElHpGizSe68N7VdSM0dig/gFlOcIyupqHO6A?=
 =?us-ascii?Q?bCZMtLeFAIsdAJi0Z3y17EDYENm/ZbGuvGgVV/ivwlPl/pFZAjdrznw9OP8y?=
 =?us-ascii?Q?1UvYckICNm80sCl+oKS/hugmd+dbIL8Eci0IEo48YfzEglcvcblNVlkhoqfx?=
 =?us-ascii?Q?Q1vLbkPJFDiBaFLgvAooZVkb7+CIpV/lPNxljTuHPppkll6a3PH+nq1ChgW2?=
 =?us-ascii?Q?IReFLD6sk8aHMn9iuoqEqjDLX5NOexZO5FagB/h/48/rksvhRlxL0L76QjRz?=
 =?us-ascii?Q?s1uWVYGFEW//1pLfrBKupHkuFCGFgte8jTXx5eeqqZCOio3o4qNBKcPOdr46?=
 =?us-ascii?Q?bGGVpjyWhljHL6dHTWxB3Ntc36Bs80Vejlv4eqzulKX6xBp9XTwlsrUMQ1+J?=
 =?us-ascii?Q?0RHDKuUku6mPF7c9n/5KxBlD/EB098MY7V66uEVJGAiWxeMKnM4XwbIlS9S+?=
 =?us-ascii?Q?N5TuvMrPzZPM6QzK3STbZQyZzRjOdLaj1E0ng6JzGfENLGrvLO7rwQN2Xpcw?=
 =?us-ascii?Q?PZPxfqI3zaJ+mT6F6iD2IYOEkywuJ6TvovvQEdNuhv/Fba8lJifrnotRpTWJ?=
 =?us-ascii?Q?a56/xxYLdlVW3NROZIXNy3NABGcUxCJbiBKEy3Bevjmu2S8u0iMTdRyIqvxu?=
 =?us-ascii?Q?ttI9Wi8CLi1OTPTiBGF5iIqiAdJn2K6k4i2h63LJp7Xvi5Twh7CIYse0GTTr?=
 =?us-ascii?Q?wE4VISaX869PUV1V157ReItW5lFVS/G9JBJRB0Nh852PO0Pt29MJH0IKS0c2?=
 =?us-ascii?Q?03Qg647grVn/jquSCbulAGrvYETp7kEL9pWBvNYm9wO5YBmZaySkVw2vHqWp?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6c4637-8a38-4939-df56-08db10749637
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:52.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EjbJ4cKGK+UO7zYU82IKRTydnpuG07MQj24BgNjwS8ViGovEmtlxfWlRVdWezYT7A0Y2KVBDjEEo4ZFwxs0bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 13 +++++-
 drivers/net/ethernet/mscc/ocelot.c     |  3 ++
 drivers/net/ethernet/mscc/ocelot.h     |  2 +
 drivers/net/ethernet/mscc/ocelot_mm.c  | 56 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  2 +
 5 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 81fcdccacd8b..c6a5cf57dcc6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1343,6 +1343,7 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
 	u8 tas_speed;
 
 	switch (speed) {
@@ -1374,6 +1375,11 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		vsc9959_tas_guard_bands_update(ocelot, port);
 
 	mutex_unlock(&ocelot->tas_lock);
+
+	/* Workaround for hardware bug */
+	mutex_lock(&mm->lock);
+	ocelot_port_update_preemptible_tcs(ocelot, port);
+	mutex_unlock(&mm->lock);
 }
 
 static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
@@ -2519,6 +2525,7 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct ocelot_mm_state *mm = &ocelot->mm[port];
 		int min_speed = ocelot_port->speed;
 		unsigned long mask = 0;
 		u32 tmp, val = 0;
@@ -2559,10 +2566,12 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 
 		/* Enable cut-through forwarding for all traffic classes that
 		 * don't have oversized dropping enabled, since this check is
-		 * bypassed in cut-through mode.
+		 * bypassed in cut-through mode. Also exclude preemptible
+		 * traffic classes, since these would hang the port for some
+		 * reason, if sent as cut-through.
 		 */
 		if (ocelot_port->speed == min_speed) {
-			val = GENMASK(7, 0);
+			val = GENMASK(7, 0) & ~mm->preemptible_tcs;
 
 			for (tc = 0; tc < OCELOT_NUM_TC; tc++)
 				if (vsc9959_port_qmaxsdu_get(ocelot, port, tc))
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 20557a9c46e6..76a7c25744b9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2608,6 +2608,7 @@ static void ocelot_port_reset_mqprio(struct ocelot *ocelot, int port)
 	struct net_device *dev = ocelot->ops->port_to_netdev(ocelot, port);
 
 	netdev_reset_tc(dev);
+	ocelot_port_update_fp(ocelot, port, 0);
 }
 
 int ocelot_port_mqprio(struct ocelot *ocelot, int port,
@@ -2642,6 +2643,8 @@ int ocelot_port_mqprio(struct ocelot *ocelot, int port,
 	if (err)
 		goto err_reset_tc;
 
+	ocelot_port_update_fp(ocelot, port, mqprio->preemptible_tcs);
+
 	return 0;
 
 err_reset_tc:
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e9a0179448bf..fa9b69ba198c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -110,6 +110,8 @@ int ocelot_stats_init(struct ocelot *ocelot);
 void ocelot_stats_deinit(struct ocelot *ocelot);
 
 int ocelot_mm_init(struct ocelot *ocelot);
+void ocelot_port_update_fp(struct ocelot *ocelot, int port,
+			   unsigned long preemptible_tcs);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index 0a8f21ae23f0..21d5656dfc70 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -49,6 +49,61 @@ static enum ethtool_mm_verify_status ocelot_mm_verify_status(u32 val)
 	}
 }
 
+void ocelot_port_update_preemptible_tcs(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
+	u32 val = 0;
+
+	lockdep_assert_held(&mm->lock);
+
+	/* On NXP LS1028A, when using QSGMII, the port hangs if transmitting
+	 * preemptible frames at any other link speed than gigabit
+	 */
+	if (ocelot_port->phy_mode != PHY_INTERFACE_MODE_QSGMII ||
+	    ocelot_port->speed == SPEED_1000) {
+		/* Only commit preemptible TCs when MAC Merge is active */
+		switch (mm->verify_status) {
+		case ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+		case ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+			val = mm->preemptible_tcs;
+			break;
+		default:
+		}
+	}
+
+	ocelot_rmw_rix(ocelot, QSYS_PREEMPTION_CFG_P_QUEUES(val),
+		       QSYS_PREEMPTION_CFG_P_QUEUES_M,
+		       QSYS_PREEMPTION_CFG, port);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_update_preemptible_tcs);
+
+void ocelot_port_update_fp(struct ocelot *ocelot, int port,
+			   unsigned long preemptible_tcs)
+{
+	struct ocelot_mm_state *mm = &ocelot->mm[port];
+
+	mutex_lock(&mm->lock);
+
+	if (mm->preemptible_tcs == preemptible_tcs)
+		goto out_unlock;
+
+	mm->preemptible_tcs = preemptible_tcs;
+
+	/* Cut through switching doesn't work for preemptible priorities,
+	 * so disable it.
+	 */
+	mutex_lock(&ocelot->fwd_domain_lock);
+	ocelot->ops->cut_through_fwd(ocelot);
+	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	ocelot_port_update_preemptible_tcs(ocelot, port);
+
+out_unlock:
+	mutex_unlock(&mm->lock);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_update_fp);
+
 void ocelot_port_mm_irq(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -66,6 +121,7 @@ void ocelot_port_mm_irq(struct ocelot *ocelot, int port)
 			"Port %d MAC Merge verification state %s\n",
 			port, mm_verify_state_to_string(verify_status));
 		mm->verify_status = verify_status;
+		ocelot_port_update_preemptible_tcs(ocelot, port);
 	}
 
 	if (val & DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY) {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 27ff770a6c53..7ee7a29e7c51 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -748,6 +748,7 @@ struct ocelot_mm_state {
 	struct mutex lock;
 	enum ethtool_mm_verify_status verify_status;
 	bool tx_active;
+	u8 preemptible_tcs;
 };
 
 struct ocelot_port;
@@ -1149,6 +1150,7 @@ int ocelot_port_get_mm(struct ocelot *ocelot, int port,
 		       struct ethtool_mm_state *state);
 int ocelot_port_mqprio(struct ocelot *ocelot, int port,
 		       struct tc_mqprio_qopt_offload *mqprio);
+void ocelot_port_update_preemptible_tcs(struct ocelot *ocelot, int port);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.34.1

