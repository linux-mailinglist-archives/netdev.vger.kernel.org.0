Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974115ED97D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbiI1Jwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiI1Jwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70059.outbound.protection.outlook.com [40.107.7.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054B4A74D0;
        Wed, 28 Sep 2022 02:52:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcBKOxLrygTnoQFb2AuZ1AWCqhJDmVLjv14nbwi+jkXF45fUpjpryKvDpj/ZRmwhRbr62ymccH4alVPkjTyn59XRBroiZTFC7kN6Gh8JycqoSQgAPwJewZ9s2vDcntD4mR+HhdBLnZcIxFQE+5uUW4hSHAJINI+KobXZ4qPHbvMIgkvX02B3KclsxlZ7+upq55YN3GnoO52biRhHkS3Lhtqq147pysLhmXqMNgCvar97a+qaTPHwJs0Gfli1740tZirQUF1I2KcnObwKJsHUUhklpxaAb+qoldAXXtLxuC7O4o4GsVDuz08CYkMLiKbhBUmX59WDlCuZToDdrMFS0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ejre59hbPpz0puKCrCdUbHmBZZ812ZiH8mmGQWF6RyQ=;
 b=lGb/CWaM1acF76WaaKf/hOkIgdj96Id0QWD6VbcILbsU4VB+ACGdwBu+eaGvX9S6u4uyCdGqXO/2gUYMjwQkRFVYBIWKgpDkY2gz/xrv5soS2WO1oS08kGXZs9dKtGSWfVWKZVgvllrBC+G4Sl8ezgfUsjLDUfZV9rGYtEvJI17VNHO8kzzzxsYADkvMbU4h9VfOOw/DQ+tccFiMj4dv/xbShFaTVmhpCelo8VbpL0Ch/wBndrHvOKnPcvurqciDra9Oj+aaw8zQMFTl5tpDIMg8J8W5RrXbMIs4Z+P4eS3mum72kH+DHNAB5zb4K/wkSjV6AN2yExIzwPVxx/hRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ejre59hbPpz0puKCrCdUbHmBZZ812ZiH8mmGQWF6RyQ=;
 b=N7HnIr7MS6dA3Dx+/G+Vyd8UHpwv5K0MbPk/b4Z+obpcL8UBXGqAI/sxWBExU4PQIA2/auhrfpsIhK4C8cIoL0gKvo31wMYy/jFyICQPijeSEnSZfUW7hZOe4yvSURwfO98GD4hbBm3PxynUIDMzyHymIZz82o0UY6RuoH3yHPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:23 +0000
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
Subject: [PATCH v4 net-next 3/8] net: dsa: felix: offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 12:51:59 +0300
Message-Id: <20220928095204.2093716-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 5496e680-2c4b-4949-cfa1-08daa1372422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76eRd0XArHAVXia29BBlqQoiK920JS+OPzxMPJF65cDSLwctpcaPuf+yzy0efHSzeeBDum1OyTPrQPSxYk1Ykwrxl5CQXUZUZXgMW0XUjK/s9k89EhoAMrKt8UoAXXnN86PAnDbr9qjgoxZ29He+B4JptP5sDgpYCZqDsmSVWb+mRXvx50LV00lwkqAreYZHx4oJdjqTaI4UfkCNqX52AG8xQXicHE0tyEX50A8A5ssggSvrqK8n0sEZEvIKjQiE/IzHwbnk2XL+wvvycA6NMN63T7rjwCEwphQJ39chMWmT3aGjYnyszvascaWwCTnWBOH9Eq3ilkfQN3FVH1VuVRC6IViYwTZTlYrmDpkOSLUTD9YS5UkGUggehpg8CGOYTpr4CgG6MyzOUIPOxPih9bi6tXQrKmcCS6QGsm7S6TjocAqxWvJBHX3C2aVipFWZTzdIkU57IWTixvuyhU1527t6YPvPp9b7ed2khZm+Ujf4jVgOi8qhCwBF+L1uHaf+8xLXIz5YKlgIZGog8Ou9XXUd/hlmH1CVZEZjvDv8rLcAe8QObDwbC6egMqz17PXW2wOZ03RosX9XmLOyFEuEZ7fQtz/N650CcFD8g7g6zPhxDhiJlIEvvu+DcBQ0YiFeJ7rOexpQY0fmC6iIAFlahpoNnie9Wj9vcKb6qeQcJeyW++y1ZuIRg9NC4iwG+Ww7MtwDlMpHDWJNG3PLC2RmpyJ9yCHDG8WWtKXfFDAuW+bAt5KMmYWwQexiWD/ktDniq8WcV21jK7mSBXgBxS5GYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWm2cQqQcEDHwmJI1UHMvkIfwEyA6MMLvUiEt6hkEqXWS0r0qUowfNcdkS5G?=
 =?us-ascii?Q?/JYGq84pdzddUru2DSptPx2B+vVcb8U3Q3a+S1SAl1RbbcDfjP6GoOdkdkRu?=
 =?us-ascii?Q?7xgj0qpL7iS9JZDVu/qFzh52MnWcVGAh7VGbYdOVirCcsBvfq1ciUVxlvOs/?=
 =?us-ascii?Q?AcEuqRLVGCv7kE1xGTc/k7XvMVI/DZUJB24g0lpZgW+l48pY3DHVKbWa3KAJ?=
 =?us-ascii?Q?cbpmkWdopA0/TD3obnub5sD3wBMKBbXGNbP7Z5ZzrkWFx8dvKfpbLK9rfSKv?=
 =?us-ascii?Q?Sbmg/raSfIdbuQpu9EkudrwCLQMVwCDmuKz6aRmYI/LDbCR8Nax4tujef82P?=
 =?us-ascii?Q?VZMqIokqXhF542phzzj6Rq4Kj1oCVV25HJB3hDelCMNagI4tkyYzOnU/y6Vv?=
 =?us-ascii?Q?zQ+fQY5Uc5HWACo4tXPgkwsJZM00Eb4ngmXkSMg8dn13ucO6b/W/+5FtTz5z?=
 =?us-ascii?Q?6rm074hA25w7hteT6SYCtov1H7EOISwHnE9wu9QKmw2BVd+I6qt0fP7hUgAJ?=
 =?us-ascii?Q?ff8Swz91EKKb9lngWmuHeAu39ieu62eWNW/tSVgWZJjjQVC5Tq6xv8EBrU3I?=
 =?us-ascii?Q?3clFayxVQAWj8s7fx2rBuO/fAM2HllsjYgiCNQ7gnwUwCTbV9vB/AHiGv3Dx?=
 =?us-ascii?Q?QAGBUZMlJYmzVqm4YUPgtWo8cS9qMRrhG2UG6md5U+oWu6t8jDsCtSTzcNKc?=
 =?us-ascii?Q?Gbcf0mUnzUJGYCbENKK5+AM/9C5N93qTOX4jEThhzjuaM09Xnj2OQTdYOhOp?=
 =?us-ascii?Q?EUaJu3abFAJ53dsNOEcnXwD8Agra0yXjR40YQHNXfrCW1KxJKb1gGbj0ft1G?=
 =?us-ascii?Q?BmaG7qWLwm8W6rc6iv1/L0dUZDlimF/pprcztYt9ifBTwZKn8pjywpCZu6a1?=
 =?us-ascii?Q?YnhkayvrjZz6lezjscZdHEffcJxzZrv1p/UAD5KG8c9YbJOlBJuRe3/p7TR/?=
 =?us-ascii?Q?VXMwoB0pz4PxLe4HENrvw6Mm1TsDj2Dg45qtnp0JuWL/lzkErKC2CfOueyqW?=
 =?us-ascii?Q?FPhPhRpdEynYbSPOQaAT/tRBlWXO/H9Tn5+edxY89d4rj9N5YawxcFvnxLd0?=
 =?us-ascii?Q?QAQF1R0JMhLQHx1cqCR2RtB/acOWL9wn8QML3LZcJf2rdytyTTddUOY+T7mZ?=
 =?us-ascii?Q?1RvI7TOv1Ze+07tlni1MMNEXa/UpdTBlALbs+cn7ucMqvzEZvPkGFPE1P9nK?=
 =?us-ascii?Q?TN+hgmxYNR8xEYAAIpJAK6bSY1bSBQKg9zbriKSjZDWYeQJxIANz4gjX4uzH?=
 =?us-ascii?Q?uyolTrsoLy7Np9HrYG/wHXP+TLQJvUxXngrrzuNHMdh/RtAG2hr7idrNzj9Q?=
 =?us-ascii?Q?moa0J4PRHe567DlIKu+CZ24trnIJ6vgpOEBbK/pj/0EAUETUtUT2XcWhBbRN?=
 =?us-ascii?Q?hZOqK0ElprNmrRvZC7M5Cf9yGFKydpX5etVHQVu5mlmoa3Vq8AOHzwm/fo8f?=
 =?us-ascii?Q?7ikzQrLeOYhw/ZOYexYKnAyYIKeD7dv2fXxgFbEGmNtqR5wvZZcbQPIoorBL?=
 =?us-ascii?Q?FPja1x9zm2uaE924YXhKZkXerYd92HK70SLJeROBXv5gLrABynbwVrRscMYq?=
 =?us-ascii?Q?iWcoVWCsp0vqohTJMghXtPwRNrkPzPIJOGpG220WrmIyrEUf7qOyQDinMtHD?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5496e680-2c4b-4949-cfa1-08daa1372422
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:23.0693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGDQKB1x28dU4O+l7A2tyR1u/QJScW3lOi3v4OEJUMydzsgstbFH5QIVHTOrC630a8kakrLLguH1eAQnoap1ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
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
v2->v3: implement TC_QUERY_CAPS for TC_SETUP_QDISC_TAPRIO
v3->v4: fix bogus fall-through in vsc9959_qos_query_caps()

 drivers/net/dsa/ocelot/felix_vsc9959.c | 37 ++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2ec49e42b3f4..c78cef0e2b08 100644
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
@@ -1637,6 +1653,21 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int vsc9959_qos_query_caps(struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->supports_queue_max_sdu = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -1644,6 +1675,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	struct ocelot *ocelot = ds->priv;
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return vsc9959_qos_query_caps(type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
 	case TC_SETUP_QDISC_CBS:
-- 
2.34.1

