Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A9B5ED985
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiI1JxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiI1Jww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:52 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8525A9270;
        Wed, 28 Sep 2022 02:52:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gva6BAtusOHHEP926uB1GecW7R60Yds1NcFUNhZbLbFltYfLJkZiFrF2MZNOVCNxYMKN5GFjCElDOp0NjQQ6PuTNVlkbZNP3C+TKABbsTbaUkK9tiaOjo2kJLsq6OyLVLq/4wtt4/3svylSlDgkTUq9dQOhXCu/Gqu7g+WXErxpGBLI/6pAY+3tf1ZYoALcuSdxohJWnp95b9PU7hw8DJ1pZMQ+FZZ9fbVcYc20HSQWKwv98hcss8IDYfStCOB24M0+ed7rTS5bhpmdY1ayTuDyIFaAnhotZ9Ruu46b8AT7BQ45AFDCTJ3b6xRXUEM4lXB+jHMKoWXpRChgt6CMnGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6XTZSsa/AeBC+NBWke02dJCKk9KKP4wn8oLCWcDCro=;
 b=BaXWHk1syKmnZ+T/CoOXVNS4xExxPETA2TetWbe/7h7Z/5Hd9H3H+/6RqB91KKf5WNVHZMOgyqFC4r3do5HKV3QXEslCh7DQXnHV5aEEdEBXirIkjgyyN7pknv7WIXEUp+A9sd8liu8vBo1azBvHl0gvue5/8KorafAnUl4/FapXgpE1owAADYsVIyh8z//lLjnuBKZpz4Kmwj+yZ99MygOfZNL2bSpT7Ud7N9h/nM6rvL3HMYBrho52TNK8p7DL4x0UrhS4jHZixQTCYmiusX6HqMs+BeOZR8cW4NZX8Pes3Dp/OfYd60oTHThPwYOUnIuPN8Vr5Ld/6ZfmqrBHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6XTZSsa/AeBC+NBWke02dJCKk9KKP4wn8oLCWcDCro=;
 b=e4jc8BU8yLdtru2UPJR28Zpkd8uysyGG6bcFPd2+GJyr9PHvGdyckIABI9AkoMIWL0WQyzLW40+ELEfMF8Qv6lZ5g7ID6sMuTAyjhamIPE791p4X+lvaA4RaBTCOnqWJFc3ncslRd0UTF75Fm4BqmJNDF/PkfOchIjOwb3FnXTU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:25 +0000
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
Subject: [PATCH v4 net-next 5/8] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 12:52:01 +0300
Message-Id: <20220928095204.2093716-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: b5076e4b-e839-43ef-b3ce-08daa13725d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnOMUHAXM8uVEVC24KCffKZ+KNMvKw0yLlqsCCQMI1yAOvTClqhgrCzBBd3ALvpPr0CHWvIUM5De71tpfjlyOTUou+6VlBb+iDqTZf3H5SsM2VJ0mY4xYY3D9Oe22nxWVB6+P3xpC3gobBMjiKYSyvJOaWjTuQrm32HoMzp58W7b7zPTnNAxCvb5BUICOD0fnbE4rlbnNVHFTZy76iMiV4YFypRu308oTuI1jhkTegfMAOxQQOGztGojmXvzt8j319CabeXkzA2Aa8nFpfMJkOnMe4DVAMbrDx4pQmRQgM1Y76bzXR2Z9x5T6g8IGXBO7u+RRjPcb3LRg0caCz4RyHi5Ghjs3EHCnlNHBoEcRmExbKy7ovUNQb9de+qqx2rKYofRL/kY4lvEeFSPTAOMidaTTjLTRfMT+nhGY0d+h8tPEWyAX2X9ePdcjm57g9vL2veSFie4dBRD1d0rvyzm88fmZWKOq9qSZ7OjTk2U792SKJi2t6BUCcHgpEgz3v1puQyYeGYSD4Xd4ncHyavNdrOuEFb4E/d6y4G0MeyrFTDzL1a8uHs8ohwGOPmGEhWqRGpK/kI3KYQGhkpBa9ipyD8Wn4OuELpWRtolZhjdsETSUzTfntBIKqucjZAwCR0cq3C2Z1GJ6eO0ebBBJXls/JLbS5xyRZvbNncCKKCR8YhzD39pACP++Kq9F00/KiC52BBYkrkvO5BZtc0cbrEDr6nEO1cuXT31tJAEcUgosAbTyPbMl/Lb81xqkzxCKXeQqJtvrKfMoWY/9ztTqCEYaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BinGS7FC5CW4y3W9LSA6XnuP15CiL10BSp3SzU74t44yvPBPLAyVPkLlH95K?=
 =?us-ascii?Q?oGN/x8KeGWXHXDHxe44wO5pXb/FYvxpVe5jXiS1xJ+zNBoVLl6lsTHJuo0sa?=
 =?us-ascii?Q?ShootRHaa7p9xzbDc8fGyuxUYTpwncZuoQ/gPEpDcasKN/bQYWoOkmNg0+8p?=
 =?us-ascii?Q?5FJXN66pHQyAGaSR7MSbYuoQ905miz52TQnY1R9iIuCMYZrGwxFM9BSoC94Z?=
 =?us-ascii?Q?SCT6NzpBAhJo24m8/fyIvpXEGPs+51VhgW5Ac1yKv2HzCEY6fCaTkxvm99Lm?=
 =?us-ascii?Q?nnVuyVD/xfQKclkfI3Ox/rIIvxZFJbcaLfi/HPkgd1Q2zx9leXr0Z4hSfzIQ?=
 =?us-ascii?Q?Z/37C8zigMgeLQQRVXhp76Fbq8Q6KfqzwxCFrORgSZmUdApql5QzZkRZizO8?=
 =?us-ascii?Q?jD5NjGRNcHyA2n4HQBqB1qgtD7YNCeQLvSaccg2qlqKHvW3ti7PRGyOvCYLU?=
 =?us-ascii?Q?UsbCJ7yV1EXyDdRmQAlmmCuXSn+dLfeSijZeQGkKNnl370shQAtOkmN0Qc2x?=
 =?us-ascii?Q?J8ANEz9q97XA1vxkcaVZF9vmubUv06cThm3EkC0uoybhIDeelmlRbKn/1AHm?=
 =?us-ascii?Q?3ML6SIXaumJYrf8qkKF6ly9k0o7LNLQpAAb3g8CKW+PNBy4Z4Iz4oLrA0Vqs?=
 =?us-ascii?Q?xlwWSStK/7aeyhDsY6OWaM2ZBV/3ELG2Ct4/SYwAJEY30zHy3rng4eyRMQ3F?=
 =?us-ascii?Q?j49OO2fiPA2Bd9ZxyQU5HALEZKTC1FVkl01slLUUCxSgH9/57DF0Zgg9LEm+?=
 =?us-ascii?Q?90DmkweCJNr2ML0rnt2NkzCeuRsqJZZtlocdQaQYsXLltp5ZBcVRhVXAks2J?=
 =?us-ascii?Q?RnKex/efNRnXFtGplGMBTo/1t8RD3PdQuUTRCnuo0xWKVc+IWHEmVklxtklb?=
 =?us-ascii?Q?1IBmZy9XfOtR5JtBFMDUnQICmoNW8QS47WhxnemOPx6wlENQzML0FiBD76ao?=
 =?us-ascii?Q?Jsw4jlCJj4BlT0YIOqQnj5AL3e/UxZWS9s0CB9Ywksg/pN0mWiqsc/8UP/qh?=
 =?us-ascii?Q?7kQhdmvDG7vp31G5gKhJY6RSqAF2MO5qPzrcTxLGCLArIy4g9tAqQCFNRpP/?=
 =?us-ascii?Q?SlSumnD7lkhnZaiRlqmsZCDnbGscScmUNGDlz9jjEpbuJ5cbYzAzaN9H5NZ6?=
 =?us-ascii?Q?HpKEqlTtoPbLP8UEYduVh+G5L1V6KVcVhfNcI47D2SlHS2/opzyxORsADWa3?=
 =?us-ascii?Q?1WICgmygqSl9vf3BK6VNWIcCJeV5iDz3wmQeX1wao783ZHzECC9QWf9Nibgf?=
 =?us-ascii?Q?IYkJj6gdyVAEiuOPVpIs6zU7xdId6JnYe2olhwoAJhqILrZ+dB+G/kGsDPYX?=
 =?us-ascii?Q?fsWzY15rEH/LOZvy1SdQjFOyQIo83VeXpxT4EHpHERcLavRoQ4FU8/akw5nF?=
 =?us-ascii?Q?kTQpV8Wn9Sm+HieMgpLSHFERQY1qMuZYAPaX5QtaJSDNBjrgYPLb+uZzTGlT?=
 =?us-ascii?Q?GgtoMT+/mGqmB+6DA3yKamMjVrvgH3PN2lMlhEeoj66nPBihi4BUv5ATXXMd?=
 =?us-ascii?Q?2RKG8tPvyBFMBe5jcZUm/YrcEIHy1FwBLy/iPj9L5tmKsI7jri5vucr9qDpm?=
 =?us-ascii?Q?G6LvSezQ3tgx4HwX17msdqIETphBz2Ztugp/iWYG/nwtte0crSi8TC6qalSz?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5076e4b-e839-43ef-b3ce-08daa13725d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:25.8972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I825FTYyB7+oUGvaubu2b8NO+HSNBiw+GFNfqHK1HNk9fBiufRLYV0sX6TyFJ2cp1kpv25TDCwJLlTCFaOyKgw==
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

From: Kurt Kanzenbach <kurt@linutronix.de>

Add support for configuring the max SDU per priority and per port. If not
specified, keep the default.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- implement TC_QUERY_CAPS for TC_SETUP_QDISC_TAPRIO
v3->v4:
- fix broken patch splitting
- fix bogus fall-through in hellcreek_tc_query_caps()

 drivers/net/dsa/hirschmann/hellcreek.c | 76 +++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 19e61d4112b3..951f7935c872 100644
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
@@ -1809,12 +1864,29 @@ static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
 	return true;
 }
 
+static int hellcreek_tc_query_caps(struct tc_query_caps_base *base)
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
 static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 				   enum tc_setup_type type, void *type_data)
 {
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

