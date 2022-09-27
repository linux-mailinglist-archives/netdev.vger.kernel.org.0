Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1655ED13A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiI0Xsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiI0Xse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B16F1C4590;
        Tue, 27 Sep 2022 16:48:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Weqx4Tm+c1BnWMRN3ZDgbpZie+xt40oV0pWo3BTnncquRmHosiCw4MZHE/bXnIq0rArM3mQL1Yf6HSysTSpVlxB5wY0KoRSfTyTqhFFFpkQox2YZ+x/cijeIXtQ2aPotM8sA1Yqn+5CKB4Pl4N/oCs7bn0hwTrIJ0PKWD+Ou6Xthsn3RBcrYS56zoHVq0aO0qsV38HGVbDKkKXD2g9PrhgEk8WFUwOAH0CEg/iCWjw9lNV8773y/QkYgHdReMl0X874O6e3zBJtFJzUr78h0IMLoLwkhYeoRJG3+YZZG4uSQhYYsAanFTayDTNvqGFUSdaQkVwPnuZnDu+VjVNNW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWo4937FpvHkygxm7c+sgGfY1H3LCN13U8eA7eqLtEA=;
 b=oKnktyGXQrqyh5RtP0Ok4xGKKY51STCO8r21RQTNvLdXr85uokuj/dLbmlMvsTlpPzkfDV7xc19OpxMIPSDnSUwtMr0yCWHoY4kCdI7u1jj+ASl2vJisOHLtCUr+3ypQCZWAdHZoA0GlbDdmrTkhhWjKCbgafptv74tGnY2mUznchiG3YpRUFpfD7Z7FPwSSldX4HRr6Ld/2ePUofR6HrQgwpFSrCFDLbtgqQHT4h4OqquaiV+fbLjolkQI/U933V8Mt0aN3VCyRv79y/bwAceJLPjfbzege0xomcYsqJ8oofpq/44h7ES3I+lOFEWopur2KYGvmyZMnE9xcPT/T9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWo4937FpvHkygxm7c+sgGfY1H3LCN13U8eA7eqLtEA=;
 b=F5/3xM4rAOpaP7opBQEQYyo11z9kkSjoEgCDidO2eBADNiuqgOcRH9sHf/3gjDzTf4AymvFY6jA0R9/0hGA1x0uLiDIqUnl9X0o/9Tl8Cv8EY/BuYbfy2olWkJ7KuK1FU9N5GabgTaKmLekHnN5s9UtXylvpTHY+IB2q6s8r3eI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 5/8] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 02:47:43 +0300
Message-Id: <20220927234746.1823648-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 262693e8-93ae-4eae-ac30-08daa0e2b972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZaWOoRRpvKSN32n8U4fJec6+luZwqY3fXVttJw2VtNEyTO+NqtCjltHN3fR8kbAKouHvEBBfHjrDmMJQYM/mHBiz9Da9UC9z2Aq7JH1z1idEAko1pvX1ac5PqP5PZ4lIp5tGmFXJ+1jlAN+kRi4pJqxvoiMu8673z/bRXX4p2WSre72GU28fzqDUGixpoP+aN49jooi9LnhwbFXbalZS1Tn1GMTfo8Kkq/zUXTEeQNQYzp+MIQP99lgds4mhYbBzhum2ccES8WuwnWC0Ti7tyD1sDdVXbeowL2lc/JQsigNlCP2Czh4OEOIO2uuKijFDNYYbMcEzz1IF+LW6Dub0MlIaT4CfMam+QAxpaI0F244yQfUAvh/BAj5yyn7sTtSGV6xquL0YWeJESDL6lSBs+Z6xmrlrjLr6j39PdsJ+StU+utA7iemH/Td2yHpc/Q1ZRMRqeiuuS+rEtCzQy5qM5wBSvMuQ/koV/SBg078vfefdiOMMD79Rzr1VaKc587H0VkaGiXemZeneHYPF8n2zhHEalLietfOCO/P7sPLIRhvFNfi9U/anD6BF81NUj/fCIMX5va0jResvTR73+lQ0o7QP26trapxuDDQ0Ldpop0Z0r2a3bSVaOdgn8Y+EaUS6Ckz4FGyhKZ46mrOCMuhdSFT128MhM1LA1Se88Lrk23VdOfH0RS+6KnGQQNNumI4s7bQE7iT6kSJJZShJHvtIWrHW99bAI8rGLs9fCYNMyvugV4PrEt2Aweju1aIng4MJzp4nyl9KLl1QJZxyL07Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/kF25jAHlZWLdaxX6tkrviRBtVgkDtWpqvLPnWbAejKHuneT2AcQ0izDwESZ?=
 =?us-ascii?Q?Datprzt7qmDgwv918Glo/5qngnXPGkh84jbddmVddwID+rGu+bVnYxidh35U?=
 =?us-ascii?Q?ZX+wfzJk/sVBMsMnUU3Oi4QjnI0/fkP7xRRMwobnJPtAk9D/DHi1H3IqDarO?=
 =?us-ascii?Q?JVK5avXlbyg+50H4ac81LVEnIzn8rJ6xSIXNoNfmSIwBXlnI/cQhXAPArgtp?=
 =?us-ascii?Q?6QFwbV3tkAy4706qDPsmCrlDBoFoIR1wxW+bs/VH4kQw4Q4UN7BXa5WA5s+1?=
 =?us-ascii?Q?Mag3A/N0mmZAkC7CcYsmLQ1IdFlieFSYUYUwlc0xDoH+eu0ChPXkjvesI3pz?=
 =?us-ascii?Q?KJqqG335uSI6eYVoxi6Y2H1xG+idzwGwmyyr8GgksWDuU6u8FccAD/mso8th?=
 =?us-ascii?Q?+oPBy9n47m+XVt6NWSDG2TUvabYXvvhBbA0bL/iBFxEZbeG1DX+rWrwcyUs6?=
 =?us-ascii?Q?Hsj3WwY05I+PTgdVFQndshl2wsJldoqx2G1Bn5LwdySN0Vz8N7sJZI2RYTAy?=
 =?us-ascii?Q?ffLltx+3ZTIucnmqEYAgof/fMRrSE9R6DVMS7uJpIsFtIhfUv1zbef2xhFb2?=
 =?us-ascii?Q?srmypRwszU+Uzaf7J6HCdHI6fNaNIGVBnfs7PYmder8iCRrguqGPkIqN3o7d?=
 =?us-ascii?Q?WQAQmsJGY8tOlnk8fNVOB9rjOz+3ydiUjF0cuhLnvpBo+Dhqo5bq3twgPsVP?=
 =?us-ascii?Q?Sz2J1efaBH7hBVoj81U1JErCMrKMwx2YM8MS/UrS2S7uXTsfIaPhhhPFFnOI?=
 =?us-ascii?Q?2+wDrS0JxRkBXgMkLOdrdFjXmu+bvH1lYYuNy8SCY5hOa//B+FudZOVt0cJh?=
 =?us-ascii?Q?rBHeH7KdSVVCM8jeJkVG80Usmwy1T+0+4tOw/rgVBZPMqzOm0wiaIToO342u?=
 =?us-ascii?Q?wY/gN3kih67kcclE+DOtU7nLeZb5Iu/sDbq3+1uiE5kcIiCyXig3c8FPOMQq?=
 =?us-ascii?Q?uImZ3kxFNHRi4gMIwv881Y1IH++CYzSHdS9AX3D2KwYE2X3OCbnPhyxuCpTV?=
 =?us-ascii?Q?LPOYtohtJxIK7TyUpv+ohAOxWWXfkpfSPr9NvXs4Bcdvg0em71U4bNuw8W1J?=
 =?us-ascii?Q?qqnMuTR7Qiw32v+9HiTQxeyuA3spYyf719O5Fh9w+MdgNHFC/qUhBU6igDSl?=
 =?us-ascii?Q?an6Ly7WRMRG3O/jvvYcjfrerfZFDEe2ZlPvtzPWbewTS/GPcwNnTFYV5m0lp?=
 =?us-ascii?Q?2ZW14xWFXCkE7OrpI3bPt4PdS8/H8/ZIlu03neKlvZVlV5EvSJEQpVyu7Xt6?=
 =?us-ascii?Q?/w3IOpMjxWN8ylP4NR8r3RIt3r208BAOnMZJrhaHQwJX2WV2zHQHRtq9LlhA?=
 =?us-ascii?Q?dm7bMbgKu2X3mGvatZaZV34779TuWaHXF6qA8/DWBqhBN++PoykvwURI0syP?=
 =?us-ascii?Q?CpGmi8HqsBWKbLw2ijYw46uKuwbPBgiyKrvhogJWVuagBG8sO5Et2og0JgU8?=
 =?us-ascii?Q?ZcmiuTZfAuCg0y66t73w81Ml1yE30vPXI5atKbha6YqskwmclMjX/13+V4L8?=
 =?us-ascii?Q?qrHduCkD2fvqKAB7WvP9rFtwpS5105NvCZT4J2R5rgLPCledu1OBdeD3aIYI?=
 =?us-ascii?Q?nNB5Mv/HkHMnHnI5va4LBXghTrJ+4lMqjUGu03t3OUyv3Tgsu+v80zJdJVq1?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262693e8-93ae-4eae-ac30-08daa0e2b972
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:06.1949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdJSehkyzowkig6IBl8n03yIJ2TqRE1tVnbKKhfp+qgKfr7mLnSv8fo540yxllt23UmJv3cZRG+ERJDLQUMU2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Add support for configuring the max SDU per priority and per port. If not
specified, keep the default.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: implement TC_QUERY_CAPS for TC_SETUP_QDISC_TAPRIO

 drivers/net/dsa/hirschmann/hellcreek.c | 61 +++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index ab830c8ac1b0..22e52fe1ffb9 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
 	hellcreek_write(hellcreek, val, HR_PSEL);
 }
 
+static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int port,
+				       int prio)
+{
+	u16 val = port << HR_PSEL_PTWSEL_SHIFT;
+
+	val |= prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
 static void hellcreek_select_counter(struct hellcreek *hellcreek, int counter)
 {
 	u16 val = counter << HR_CSEL_SHIFT;
@@ -1537,6 +1547,45 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int port,
+				   const struct tc_taprio_qopt_offload *schedule)
+{
+	int tc;
+
+	for (tc = 0; tc < 8; ++tc) {
+		u32 max_sdu = schedule->max_sdu[tc] + VLAN_ETH_HLEN - ETH_FCS_LEN;
+		u16 val;
+
+		if (!schedule->max_sdu[tc])
+			continue;
+
+		dev_dbg(hellcreek->dev, "Configure max-sdu %u for tc %d on port %d\n",
+			max_sdu, tc, port);
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val = (max_sdu & HR_PTPRTCCFG_MAXSDU_MASK) << HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
+static void hellcreek_reset_maxsdu(struct hellcreek *hellcreek, int port)
+{
+	int tc;
+
+	for (tc = 0; tc < 8; ++tc) {
+		u16 val;
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val = (HELLCREEK_DEFAULT_MAX_SDU & HR_PTPRTCCFG_MAXSDU_MASK)
+			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
 static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 				const struct tc_taprio_qopt_offload *schedule)
 {
@@ -1720,7 +1769,10 @@ static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
 	}
 	hellcreek_port->current_schedule = taprio_offload_get(taprio);
 
-	/* Then select port */
+	/* Configure max sdu */
+	hellcreek_setup_maxsdu(hellcreek, port, hellcreek_port->current_schedule);
+
+	/* Select tdg */
 	hellcreek_select_tgd(hellcreek, port);
 
 	/* Enable gating and keep defaults */
@@ -1772,7 +1824,10 @@ static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
 		hellcreek_port->current_schedule = NULL;
 	}
 
-	/* Then select port */
+	/* Reset max sdu */
+	hellcreek_reset_maxsdu(hellcreek, port);
+
+	/* Select tgd */
 	hellcreek_select_tgd(hellcreek, port);
 
 	/* Disable gating and return to regular switching flow */
@@ -1828,6 +1883,8 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 	struct hellcreek *hellcreek = ds->priv;
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return hellcreek_tc_query_caps(type_data);
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_qopt_offload *taprio = type_data;
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 9e303b8ab13c..4a678f7d61ae 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -37,6 +37,7 @@
 #define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
 #define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
 #define HELLCREEK_NUM_EGRESS_QUEUES	8
+#define HELLCREEK_DEFAULT_MAX_SDU	1536
 
 /* Register definitions */
 #define HR_MODID_C			(0 * 2)
@@ -72,6 +73,12 @@
 #define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
 #define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
 
+#define HR_PTPRTCCFG			(0xa9 * 2)
+#define HR_PTPRTCCFG_SET_QTRACK		BIT(15)
+#define HR_PTPRTCCFG_REJECT		BIT(14)
+#define HR_PTPRTCCFG_MAXSDU_SHIFT	0
+#define HR_PTPRTCCFG_MAXSDU_MASK	GENMASK(10, 0)
+
 #define HR_CSEL				(0x8d * 2)
 #define HR_CSEL_SHIFT			0
 #define HR_CSEL_MASK			GENMASK(7, 0)
-- 
2.34.1

