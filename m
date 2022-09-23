Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911345E7FE3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiIWQeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiIWQdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:51 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC09013F291;
        Fri, 23 Sep 2022 09:33:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isOYOL81tN/6AogACX3MN5Wyij6fD7UFEuuTOp8NqlWp/+K4+TAnvfrFHQTv/8L7h1H121LVjslFjUCHlZEsZ6Li8AhhDRvkQkeCpEjaL2MYd//jfoclygivqqJZE6TnFbklrPGlMKArTAIsRxwnuQHYaYitlvT9lBz3zVOEuGmCp2+NoNQO8j+SoqJqe4A6z8HAPMBpoOaYVp9NxwlxwMPrJM95qttxlmttZif7YY2DcIHGwtTtNA3TQfAz2WOPgf6dbH/34kimgkpHwPyN8CaWdXwAAtKYu0rKkLZtPoli3499fBHRXzI+5IbZuEXP3IxxVfgXOw/Bk4PyQqFshw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0RcaQxoGdsJlvWT4bgEmWkgrK1BjFHKDo/TpUXrvIg=;
 b=UYq7krPnp1dKkAVl/r1ktIhnayhq19h92alEz0H04RanQQkJzeVxTXV4A4cBop0bYH1dcBSzE5YnRdRn9jZ7qy91PpgJPIAHlL+uu67I1FNfPWlfRdnI9AOIUBCPeak+BFmmkt7uZxutCSbrL2esAH0zYP6/plKpGvmIEOufo+2fEVVJOrV//XAYOVr15O8AohR5GC8adDaSCJtaPSLqMW2IQtedyv463OKMBsr50nA1ppanKXlj4EnwPtkDtbtE/+KmuYGM2WAZ1wl9rIEyLItChwf0oo7vdvxhiX5kjpMNQZPFPjuzQoMDKKtr73jVolgVLLnX04dVFwF1d7LKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0RcaQxoGdsJlvWT4bgEmWkgrK1BjFHKDo/TpUXrvIg=;
 b=MMA/qpqvqmHLsr8QrDoDda4E0SmzxpvSdtbxTEGD4qixYWd0GIFb83RC8xw31wgpCncZe1Vupe862M9jM1VQIIno4USqqBUpk+pcDzA47647zERU6nUFnbitEvh+Sd+oeYvh1gxcZm9URWiHYQK2g1LMprwZG1kC0s40C656DZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:45 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 08/12] net: dsa: felix: offload per-tc max SDU from tc-taprio
Date:   Fri, 23 Sep 2022 19:33:06 +0300
Message-Id: <20220923163310.3192733-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d5a905-5b7e-4547-4263-08da9d81623c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LK03a+bcQvro+SmSvX1QYGfoJ60stu5xSYzoYZ55PVJ8HaBcvmF8sf+iWz6Yn4RXdfV5mEJbaC/7G7/EGzpgTHs6IwabFG/6TWrWXZvrpAXSpzNKSXtos1ZBw6aSe4+7KdT5zCMHJCmbpmptJ6Dm4SNSGVJgimcoPSJxeXaMfSVQQbIG0w80HcyxyBowMtNphCrMBvM54AK+oz8Bo4k52mN//UX6rIRBzxzF2sNNczVe2jyVxxkBPgix0xaAGrhpJb+Cd/2a5zV5OXYXb2eiOHDI3euOcsOuRA8G8ZpceL6G+Ezz74/K/vfuEvvZazuD97WS+z2zHIs7mznwx/NWPMSM4Vg3QGsq2F7F5lds5IdR8zXc2AE9oeWdx8zGrFQFxwlxiOn3kXFZivrXFV6aPPO7JphezTBPFcxesbNdhVwKmm/nCyPrM4RTOjGXY1G0pB+U/o0c8m2pUqpqDVJqiTKt8FaunGLCH+qLZOYV61kGgwpjV2cAl2sEUSjwX4sTIKQLNPIcMrTq/b5aRT64WkcEzg3K/djSElEq8v3J7NHDCrrrqmGz849Jce1obX3sM5zviBcd+Kmj1q70Xvc7BqByOIMIF7x9eSade0YhX9xHJuF/7gy+nluMUMkXOpZmVqz6CdnWNTJgMYpJWknvGix0iWqemwlcyGE+Htt1MfBsBn+r5yHtyjn/YW4dnckj6cDNfBuIFrr4PT/SPtNNJ4aaWSuIwtkFEZXIe7ah1zt9IXFv/tLu/Vw9bwcfYz5Lk/R9eDQL1VH/Uk3TzA0dYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+Cu2f5Bgd6sshPSEcSYR61rlDxqL7AtNnYMVchA6vcy32XOwlgAqulOI1oF?=
 =?us-ascii?Q?oG2y/e3Bk91A6M9UVUvBCQ9LOzjOS3sP2vMnzO+4vP1bPhIbOjI9abdavh9E?=
 =?us-ascii?Q?D7P668mje06Zjd82LlhDNCJ5C1JOJCHSur0clv1Ht9Nscx5SaxKFvhNPd0/t?=
 =?us-ascii?Q?wQeOrbbi0tIjYQFCbfkiaWrQEi4XZUBHZ1+Ghe7R/lIlMOMcieikh2l7PeKQ?=
 =?us-ascii?Q?hWOeeW6ZaOqSmX1yfbyQ2QjI8pVhZdilSf14Pc3b8AKFJ2AGaGbcmYMYldye?=
 =?us-ascii?Q?fQvhcbrGYE5P2+AZMrJ9gS4zMACQ0fFhALfH0X5MwJgQmP9VDjFfy62mRV6I?=
 =?us-ascii?Q?g8DkLae/aQirQRuzbicYAHthahnXfkWehmvTlPxC4BGTqnFyy1YiapV/AnhE?=
 =?us-ascii?Q?+o4Lefv8uUk/Vj4aBR9sKZJ/m3nns+6CwTyDlGYrXjdO2IZn/Q9nbJ6ctJGd?=
 =?us-ascii?Q?22t3EjG/SF5RSWRZWrwqjJdZMnHzlyMtRMhZy0aqH86KoNLTpGWue0+ZJQxL?=
 =?us-ascii?Q?PYxQblFZoeBoS6htQDX3KXzMiAQKrl07JwMk/qbw2gsXGJpRLoQNBFS+V1h+?=
 =?us-ascii?Q?Y9XCbANG/bt3d0YuKI6OkuuBcx5LIZxtCkcqAGFxq7cRoYucOZaYZE8lPD+j?=
 =?us-ascii?Q?4zkNikb76Fs/FlMZlSW2VoLIyGWqnFcx7Bp95kz0CYa0EwvHtsgw1+WI3BLZ?=
 =?us-ascii?Q?jEPniGqxgHT9w7CJjHWcTYrCGnxITfWhP5wgLARNz/0+gehlRlngB9FSwB7P?=
 =?us-ascii?Q?ljJI+LlcgHriemC68B9aBq8SOzFWbEvfZmyY8OOwFGWi/7/8y0vQPDnvyToX?=
 =?us-ascii?Q?BqfRD+TGe9ZI3DKzKSIy2nSmKJoJ1lm3ieOhK0j139NK9vlDIN9k5ATZvH0A?=
 =?us-ascii?Q?+GjhAeo3XUt7MU0hVi4lKmraV32a8mZ9acJ0j7DS16lasWCisZwl3nNTEvlo?=
 =?us-ascii?Q?/7KwVinwki7Cd20Vn6Y2hgwaBybZfjatNLugF+nOiVdpDBQa/AW9e/lGz9B9?=
 =?us-ascii?Q?m4RRCQcdnbJVLbJes8zlzEfaKp9ihPwCG9FnjZy9YkhZUkYbDvw37Va5pqFF?=
 =?us-ascii?Q?GW9Xr8p0ZLnqA4A7GxTIwzfh4I/C5vGqfzUH9+Oxzw5i3V7jtyCfSzDsVmgy?=
 =?us-ascii?Q?HOvMW5w3zFe7XdK0f3Ty2blxRNXLwa4+f5SVFsFoniwLnrFhJ+mbmSZw7oLH?=
 =?us-ascii?Q?lrA5PEGg/c2ku0ZE0o4OzeVSCOf2LGHI4ZFJ1lpUxoWJGqXLJHuwNxLGBZWY?=
 =?us-ascii?Q?lQ2IdeFBKgtruQG39+7Ywobm+3hqCsS2cqzLIPULfC84ZwOnUPFGAultJamg?=
 =?us-ascii?Q?8AhtXPddw8p55T+CS4MPW7W+WNqYD7AA2hO2QBkuKxq7rYZTo2ASYOu4OTnt?=
 =?us-ascii?Q?9yg8tI6hzqyVnIzG50K6qi6uWns7gVyAH938XlR/huHkZJRoKHMjkeYAOHcO?=
 =?us-ascii?Q?ZLlBnAJ0N62OSBoShd6/bEp6cJRQniyOxPcN3puDk5QnX8oyGWCziUfCKMbG?=
 =?us-ascii?Q?1QPFAKlcANsnw0Sexq9DoqLBc19yJMIxGFdIrwRm806+fNA26pkyUDijmupU?=
 =?us-ascii?Q?IsSA1by7Dvx7vUMbxcbikH7L4Lw1U+VvFn7oQVL9tV0+wZSxiz2CU6Sbwzr/?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d5a905-5b7e-4547-4263-08da9d81623c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:45.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: op3Bugjk+k5J+ZVm+tmMEIbMN6pD0H/fSvQX+2biDABrlKpeSapLPd8jsNO0xYxj1Alk/KkAfe9eJWxJTTtm4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our current vsc9959_tas_guard_bands_update() algorithm has a limitation
imposed by the hardware design. To avoid packet overruns between one
gate interval and the next (which would add jitter for scheduled traffic
in the next gate), we configure the switch to use guard bands. These are
as large as the largest packet which is possible to be transmitted.

The problem is that at tc-taprio intervals of sizes comparable to a
guard band, there isn't an obvious place in which to split the interval
between the useful portion (for scheduling) and the guard band portion
(where scheduling is blocked).

For example, a 10 us interval at 1Gbps allows 1225 octets to be
transmitted. We currently split the interval between the bare minimum of
33 ns useful time (required to schedule a single packet) and the rest as
guard band.

But 33 ns of useful scheduling time will only allow a single packet to
be sent, be that packet 1200 octets in size, or 60 octets in size. It is
impossible to send 2 60 octets frames in the 10 us window. Except that
if we reduced the guard band (and therefore the maximum allowable SDU
size) to 5 us, the useful time for scheduling is now also 5 us, so more
packets could be scheduled.

The hardware inflexibility of not scheduling according to individual
packet lengths must unfortunately propagate to the user, who needs to
tune the queueMaxSDU values if he wants to fit more small packets into a
10 us interval, rather than one large packet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2ec49e42b3f4..aeb52c5c68d9 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1248,6 +1248,14 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 	}
 }
 
+static u32 vsc9959_tas_tc_max_sdu(struct tc_taprio_qopt_offload *taprio, int tc)
+{
+	if (!taprio || !taprio->max_sdu[tc])
+		return 0;
+
+	return taprio->max_sdu[tc] + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1257,6 +1265,7 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct tc_taprio_qopt_offload *taprio;
 	u64 min_gate_len[OCELOT_NUM_TC];
 	int speed, picos_per_byte;
 	u64 needed_bit_time_ps;
@@ -1266,6 +1275,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	lockdep_assert_held(&ocelot->tas_lock);
 
+	taprio = ocelot_port->taprio;
+
 	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
 	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
 
@@ -1302,11 +1313,12 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		"port %d: max frame size %d needs %llu ps at speed %d\n",
 		port, maxlen, needed_bit_time_ps, speed);
 
-	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+	vsc9959_tas_min_gate_lengths(taprio, min_gate_len);
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 requested_max_sdu = vsc9959_tas_tc_max_sdu(taprio, tc);
 		u64 remaining_gate_len_ps;
 		u32 max_sdu;
 
@@ -1317,7 +1329,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
-			max_sdu = 0;
+			max_sdu = requested_max_sdu;
 			dev_dbg(ocelot->dev,
 				"port %d tc %d min gate len %llu"
 				", sending all frames\n",
@@ -1348,6 +1360,10 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			 */
 			if (max_sdu > 20)
 				max_sdu -= 20;
+
+			if (requested_max_sdu && requested_max_sdu < max_sdu)
+				max_sdu = requested_max_sdu;
+
 			dev_info(ocelot->dev,
 				 "port %d tc %d min gate length %llu"
 				 " ns not enough for max frame size %d at %d"
-- 
2.34.1

