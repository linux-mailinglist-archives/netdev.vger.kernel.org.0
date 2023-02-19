Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516C269C087
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjBSN4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjBSN4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:56:34 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on0605.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA45612072;
        Sun, 19 Feb 2023 05:55:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLLs+lBEzVx8X2p2Pe0slQT9HbigeL2dA+wke1N5H5u+DrZBKzcsjGTIhunxRvjy9xcYege4HK9V1OV+a7fp0M3T4fAibYHupVh0stB826RgbLGS7dKahEmexzLn9+LxkHuq54oEcOY/6ckLRaFmwRPC7TMjQIMEBFvAKWe7GPkKjx4vLLA745vAGt58QDv9eCTYWcyIS1jrjjyMQ5It2cWTMp7dvvdZ+G2hsaF0RYBaULloHpvyc4LHQzELzaiiBjYEtuitVpMjQT1phXRUk/4TnhEllEUzbeGB7W324nm5oLfYN8RKgOrZsSyBbTYuazSOwmlhCbWuHKKoQvQbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QokfDUKT/Riqy8XY66MoD5yTl/4NzMa1ubloe2YxCI=;
 b=EphQUbhZxMYI9A27Q2fznVkkOWzsv3s2GchO4xXEYqZNmZyUEWygkK/pfps61tiQGxECKgpQoLdGIXybOczknHtBsVxdfvJ7fnaMmBqWZ1MdUrpbxLFs0XY2Q2/cXx7FgFQFprgb8CrqzRPIK9D+2sVeb2uJWjWZwRqXHg5NtJTSa/ZetPJDkVmQLnk4vTckQ6d8wev8HHpm9TcXCVSO2JmmrCJYOedziojl81Vg3dpjsTxprmh4dvlGHF77nBhrD60OuRA2XC/HS0Lgc7ZdsBLZ4Ae2H4xzFxoxipdUUl1M1gs3DxBHmTxKVLij5kIiwrJBzyZmiAoNFlqajK1FKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QokfDUKT/Riqy8XY66MoD5yTl/4NzMa1ubloe2YxCI=;
 b=MpZRL/qGXQcS0765yuzvQ2SRtYZdg184y3rspssGVMWVTslvlz8g1f/B3saRTJoa/nU45/JQZTtmO92CJPp5rIrJhK9NPLq6ANzwmXJsmjgIqMg8wOZLv1+kY4A62GoPsaE5/nlWMhGjTKYdU3BIbJ6Ey1p7cejf0cRs5ITWyis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:59 +0000
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 11/12] net: mscc: ocelot: add support for preemptible traffic classes
Date:   Sun, 19 Feb 2023 15:53:07 +0200
Message-Id: <20230219135309.594188-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5a327f-3f56-401c-5723-08db1280c00c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJnoAQpSyKSS1fDGmhXZnajvpPnndwhRsKrBjdPy4oHV5PYrbTw2vmFezfAxXEEw/hxPERliSz0rQnMZ/TN8gSv2B6vG35LG439CQXMNhGO2yOzmm5Z3eL/JFjlNSdnbYJ86sxoEKU7tNoC2vQIteNj5dq2fuxN7JWSVQF/K418EzNusIIxLXc9LngTJ2O242kHe+gkT94IsFgnQqGqEEKUV37IeZbYPQ/SBeKBrhoGnwoJkm5M6IJi0uU2TqWWf3pPi1bDMNDOFumfOawm1Ykquithr0UTu7HAwJoQq5kSOfeBSbLPbI70lnzi5b10HB9hTfQycIsVDQGZBKJT/i6Z/gBWJsR8SN09RZRZiJmBC+O9y7GaW30D0KvF18GieFhNYZ/rNu5Hn7u42pAbIa2biKsx62JFM6se0DjPYg+xjsm55KegKtvMmjWhWD2604/j6UKknfY/z/Uzu0seMbaRIbb4ZKrq5saoqgoKYm3umiHG+DR8FCoqulAaoRKcODtpb1xfpeVH81CDXEivxxeAy+RbyPotAQ+DT7zSFqB/ZEWlZBw9q9s9S5asBtNMFuVIvZir3g86eparIRaw7dPft95PSJRrHgYSou2Exdd3c6tN+6L6UMP0mLFL5SmnRQ5SSFF0Q7CUNozjXxdLplWbxm4BGroeoXENuFQ7m1sSKRpWcKzyGCvPoq4r3d0Wmwk+YNg5jCelGJYN/Q3cQ3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gA/DRg6ml6gJiSMEMb5p+D/jDOCwptfzZIMivGnyaumAd7oW9LpSbskp2Rii?=
 =?us-ascii?Q?y7kz7fW16Tab32ejqlqgumJbB+eQ5odTun8TK+sBAUvp5F/3a7ibZDJnyGeT?=
 =?us-ascii?Q?lrKiud8pN3uboDWSfCdefcPQ5dqEWKKTjOKuM4cFb92MtZTXK9io/csEVPku?=
 =?us-ascii?Q?RnkMiYgEBuN3c0gsT6rVZzLYiM6/zQmuS6HRHg8u+8zaWNvyPHYb+TpJcDvF?=
 =?us-ascii?Q?b6HuvYdspiIQ6yC4E4Mh+Ih5XrQsF+flWm2UW9dU3iErkJqmIqN+nN/jv/Hm?=
 =?us-ascii?Q?Xvr5PquGBJUfcybc79GlJbAZKTNFPCxbqUaAx6zXLGf+3bO5aKHgNgUGWrYl?=
 =?us-ascii?Q?BU4SGTO/D+uLES3LIf/ZTd813wkNYlhUKU4mntJ9BygzAB+wheLSm60wq7nF?=
 =?us-ascii?Q?i8E0i6rQs1xdGSFJCFiibWH3l898cGVnw7bxc51c0AR0OMSif00YnRDih0DH?=
 =?us-ascii?Q?ePc28P2nNI1g52a4xNt6YsxC4l7XQVUY5f1h24P7ivm3fec8YUkA53IyO3tY?=
 =?us-ascii?Q?MY+v0ugkbppAJx+/1ZAD4K/uloNUkTHdt8wiOyct0SiOjZao+RYFbVULd5em?=
 =?us-ascii?Q?reSbzxdgIisjv2Lvyq1AYEbs3MMp6RzfXUzOWDHW63JARikLfqhC/t74cnkp?=
 =?us-ascii?Q?QMnVZWZfwlZQeOecWxQ8ZeGjcnROCeZoMzosPV+J3h2Pn5kol1+472QCj69u?=
 =?us-ascii?Q?s6jSeRuXIz6OC8wYOwlqExoUqFNtIPwsOgglXj4atHkOw6IX9IpwfQxuWs9G?=
 =?us-ascii?Q?GrpCYloemUHKk3mRAqS6NlLnRxNzzvLU/1tA/TVP3zwZ4bi2qhjrCaknIHVR?=
 =?us-ascii?Q?HHFo17tn6inCq9NdY90xdnvRvfRcynDcEWVPemIUYYk+0ygQjdRiEJKQ+Mqh?=
 =?us-ascii?Q?5+c0+hUotTkF7nsNH0wvGoKngx6ow+iTG2dbuj2qSpXlfR2D05ySvXav+ucV?=
 =?us-ascii?Q?VBsUiz1WEhYJN+oa2UDsaC5G4aMIeEyv+tzHTWUJVB4iOzZAO7w9ZLXKdpf2?=
 =?us-ascii?Q?LP59QaNj3w2F4xXC3gzLF2sgA/36cbQoIVmARulMvZDWJaUjbBHzWrLdMSAD?=
 =?us-ascii?Q?2x3YuNdCqPR37nVGGgz7gt+99g73lDMOtrwKMmYVd0moSv561Np2KlQFyYgZ?=
 =?us-ascii?Q?JgRjVknrP/tqIQboojlArzF0F0l80LU2emoalxDY00Ex3r+IavDVzjjAFCou?=
 =?us-ascii?Q?GW+hKB92/t/jq0SkeS6f7HqAPRU6cPfRMq0UqSqKoM5Pd+HHxvbsftxNZWFr?=
 =?us-ascii?Q?8jhE7+4Bi4weyG0nxmtFyTJ65YJcV/Zrkm9J9KzcM8FxQFgUCuhZoWG1IEfK?=
 =?us-ascii?Q?bNoqkYoqO/rkPMeH1T8nED1sU0Ewkk1Cc9R9gsO6wRnMyC4kkm9qvc2zV8Tr?=
 =?us-ascii?Q?uPvmkUukb9oTVAIGbj3GI31PaRSm3GJuhIScJQah8YEu5PDWSyHZwXbi0geV?=
 =?us-ascii?Q?PX92IdZDE34qNo7R6sDTe8Ug0hwo7Aq8reJ0sTjeFQQLAJ83lnmnMdVDUEWF?=
 =?us-ascii?Q?ngsN3y5YcgiJq4hizyBGiICLK1NWW9ql+f0OzwL0xYQGvEf4HO86RsLILsE9?=
 =?us-ascii?Q?2aIQHqfD+upanXRn/uD3rXAFp0nREUn+yD6q8u40WU+OQs6VQtAGqu32QbYm?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5a327f-3f56-401c-5723-08db1280c00c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:59.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbUCXQKa+OoV+ERtagPAYIA8J/Iq2wWKFx8UPcpfT/LMBwih0qhNm+Td1a5kJPHjYMLfd3OnpGM1QR11+do/PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
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
v1->v2: none

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

