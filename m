Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4327C55E832
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347416AbiF1OxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbiF1OxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:53:01 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30051.outbound.protection.outlook.com [40.107.3.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8B6326DD;
        Tue, 28 Jun 2022 07:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfP0qAGE9hgqk42vodZbTytKzukEkZc/GsLcK0Vij2WBygddZG0MYdLd5YuEkpOTWqacXSNruVBcOYL75+wRWWGQEHyiX1f5/J0O5gQpv5o00Cxk4PZ2mV45+UTQv4Mc5lC/LUjIvnaMeUN2magTfgow0FSU3h+hftruTtksFDppX9exW/q3gekfy5yCk9TH7fUPzuQqW90pKdOc5IKvZOJLuEy1V++iT4QiSlXPs2T4CPVax1hZNnVJT5hAl4Y3xNAcEemf+N4JaxOzucbfrhtMqxajeVoM0TDAQraAgJBX10DPKyUuKMZ9PCn3OZzqYmUD2OYCqBcXf/6nGRX3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmLBoKNeINzsXLr7nlnE3iJlHMzIIU90dWna5z0GasQ=;
 b=gmitkTw5oTdnHBLkAzCa/qsbRSpIftsVzEv/KxBH9H5QjDT38446HpSV7vJceH04WyBV5kor7jCkxs3JgmjTcEV3p9jnCQgjoScMKoFjPWUgIYyXwMXlnKcpV6GzZMX4vTwJNMEkjHJEZf9R9l9cBQSOu877iN2q907omUK0WceeTbQsWr8wNzNEwUOlEWev7MgF4SWsRG5m6K28NXm3Kru17TlSUqZXNyqKipinvuOGedn6jL5NoJ0RjD5lmywcYrX30f/ZeGm5A557aQOVmRckxx6sWgnpXrnlgzbAFlvGtcli00RCSddOhGZM2syaY7k+MkMO5LHjFJhDEE4rVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmLBoKNeINzsXLr7nlnE3iJlHMzIIU90dWna5z0GasQ=;
 b=UcJkk/2Ao6/zxiB3Jt3iSLgJQTv1bVY7LETSSYzbfT/bPRnLGYNu8P4nMB+Y6DXL6QRc0anlKyBekySR483i/p6MsLqSLf1w17SDqZYskNlC5SE/6/X0jxzi7m70TEz9i6FhtQi2RPczUdygJyBdKfEPfkdlRrbW8aEoTjxLm0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3810.eurprd04.prod.outlook.com (2603:10a6:208:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 14:52:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 14:52:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/4] net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
Date:   Tue, 28 Jun 2022 17:52:37 +0300
Message-Id: <20220628145238.3247853-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b3221b4-a95b-4fe3-44d7-08da5915e38c
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IX+T5RT10ItYyzgCkRAr7jJRiAcTrE7Uc0YjRbZYGqOfpFhwfCmsxshUQfer/xO9679f2CmdNH3RcQQHXROlna5plKzfKMhZPTALyTRM9Ww3kE9JfE7vr8wH/scjIsqiuKyltQOgw7dcDr09ohq+KWUcw6i6mSWiQkDpRqH3u0pajwL2w3p6Y1n+R8003JYla2tFC+Ah1caDDQQ/OwzFBGX0mFqYQcyT4dCbLetHecmLELVzjx0DpVjWxL0CKu3VJIWNoE50S7LoQZ2rrF92SIY0++nsSkc1VdMEiSRT8JiHi0L8hv4PEmaHLKTNnVi493JFQZFi3vF/o3+3UAFjmg5nl5IOlqmaiHaPNIiLA2Val4ktDTiPe+FDHV+9WAdA85PHCv1xWcdNkYf+eVv2d92y1MCUhnugQ/N5KgLPK1tmsENjXO5k+B9bNJ7SQtFrVYoDD0WWcCZkyMoCxs2nnuy3ABbdjyRg6vr975FwDx00jZ2obPIX46pZJUaigpP4kUQj7xsC4oFTLkM4evYki7iPXA2XYFNQNoI+gCDRJBv5KwEpVMO2d8haRIW8LBPGGkF2HjNwj2y/pHjSpzVkoS+vJkDnB7WnXLuZHmG8pneNX2kyMXLOAiAQSTG2VKcLAQ9Ip/E72gIcyF4aQKHd7wfoDHSkYPVu7RhulbnumTtFqXlQFTgIGVWnLG2GxWJNDW2zyHPcWZsLnUGWx0EfvnrHA48C5p4kZJTBo32uKE0UbLB+2RQKYNxdfwWkwgnIfqGvTUF6DQmYL7kvx94deaCUhxiBT+qj2jFrz1yXla4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(38350700002)(38100700002)(41300700001)(54906003)(316002)(7416002)(44832011)(1076003)(26005)(66946007)(66476007)(6916009)(66556008)(8676002)(36756003)(4326008)(6486002)(86362001)(6512007)(2906002)(186003)(52116002)(8936002)(6666004)(478600001)(83380400001)(5660300002)(6506007)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pfuelfM7mjUWhr3uGZITT6yIKcEkNHjCj00miCTzNJ/bMRdOq7ql8lp9RWWZ?=
 =?us-ascii?Q?lVQ+si8eio5+WuQwbSOTIh2Q1SkGpwcpp4k6Q+fRVuOKKcYv6IgAgLooHI5t?=
 =?us-ascii?Q?EVk3AQ+LO/GXYx9XzCHrLXOhkf1ySWs8dzm7YpSo8y1rbRV0kL1jaUwVqMb4?=
 =?us-ascii?Q?3FYpAoBamBzHejp+zN9mt9cyXce7ufHHyQL7JrI859+7h/Cc6GB8r/8J6FAs?=
 =?us-ascii?Q?Eo2+8TuE8Zic4xFEy3b2ahrQe/5lCkT4vzYETApvau7u0b8da7V6011+XSs3?=
 =?us-ascii?Q?YfjCwXDKro0w51vr06u3wzWB9D9v/RWL9Ar35TFPMjp/AdMcIacTaJw/kQhY?=
 =?us-ascii?Q?fX0NyXqftLdS5oqKBAHFMSomU+MR+CuPfaN6giF04niwdUoGhJHtQa1/V+sn?=
 =?us-ascii?Q?/Tyz9pFb2P8WHAF7RBTw1yGXaLoFo5Ts8ZzQUtu9Ij1x7XqRaGKBf0jhAZXu?=
 =?us-ascii?Q?mXSN+JMjgnGDFqPEHBJ5PARiAa7JWq7er7rxMosDG0JOnh2SLKPAzUp7jdmf?=
 =?us-ascii?Q?2iO7s8/8c9LRviHXjTNxgFBaiLqqlEgDwuDWrVSG3X3qUTq9clW357IWRwM0?=
 =?us-ascii?Q?rD/Kq6tAhQKBADIyjA7vQgRx6jmw1v4E3UxoeKqlVmjhtQHnITqnVSvdnFW/?=
 =?us-ascii?Q?71CjMjv40B/MG50cYHDHbmCj6g+BdIEmGs8jIg0MnkDdO8wNKi/3eWhLocJM?=
 =?us-ascii?Q?i/QdqaJCCOYRw/XUxJimZBeOrJ7JiskSulOhHZos1G2eLmOO54QoWIn9DWpo?=
 =?us-ascii?Q?QH9nHHSrw+vMcIlrV2GSfQ/UDyEgV0M14n8eExtYKe6NYDF+UIB9Ky8DQI9y?=
 =?us-ascii?Q?aH6TH3aC6xtCNKQir6v3QTalvUU6S4VOy0ai4oQZBrbM+z0gn1WBaI3Efpvq?=
 =?us-ascii?Q?B5SF8wdbFfWWpGbTwvmtP4vZOcbAW7CKFUne96mWGRxTTX22BsOgZC0HRbA9?=
 =?us-ascii?Q?KbM+5S1N0gMk/XOhjaZVogrH+XL9GJUPvcpCZL91p5vvyA2QVTCpJ1jZj+lf?=
 =?us-ascii?Q?NYcLdhPym6PoYkxvYOAxT0pZBDLTW/AqIForyjTP+Pwg9nZ3DYinq9nPdBle?=
 =?us-ascii?Q?8UVLlomJX/l5PojoGEvvEPkSDOXjVs04qxGPAbZuEjZ7JX4mzs7Q2DcaVuNK?=
 =?us-ascii?Q?fo0yGjp/A1QXThLZao8bwoQQTCSxUyWKM8lYifDJs+zP+PX9XetY1LFZl3Ev?=
 =?us-ascii?Q?EP/8BYcibNCtDsrolGuygWE7q4PjcImPpdIvJVSgMzHrcZ06bFktIgfHvUz1?=
 =?us-ascii?Q?YCJqDv8F2UXh5wp14kkZy+/m/BKUQGmmjX2W0avKxMbrP7BAoHkwYhclo/ao?=
 =?us-ascii?Q?y/65rq3o7QyARUUcM5XON9APehCxr64q3XHlofzFU+Rrl3vD5DdQLOrgUZKz?=
 =?us-ascii?Q?Vf+0tEQ1S/bNqrp/Xrmp8T8ywHAK8mt4+8JHnQxUT6BhgfGRcFwhziTeYOX5?=
 =?us-ascii?Q?NaZ7cR2YWTMRc+OPRvOUxgSgdOqBCxge8o1FZXkgfRbBXyQWMJEWlotLmI8o?=
 =?us-ascii?Q?u9/1w7vmKJ9429EbEHReTcm2U8AJQ0xm0rCGxOMza1truhV6V8h46uwk5ZpI?=
 =?us-ascii?Q?ep0mcCcCh3+tqAyY0VMRttO0IUNWkxbfxSeqiRPARGoDVA8GZNuK8J4cZ5mU?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3221b4-a95b-4fe3-44d7-08da5915e38c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 14:52:57.4714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALEAH5LC89btdT56yA3x0x+K8bVkE7EfKXLPILSDcO7ClDww6TwQEo+RJVqnIvphujCDjIu75Sr7Qoe3qbeFTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, sending a packet into a time gate too small for it (or always
closed) causes the queue system to hold the frame forever. Even worse,
this frame isn't subject to aging either, because for that to happen, it
needs to be scheduled for transmission in the first place. But the frame
will consume buffer memory and frame references while it is forever held
in the queue system.

Before commit a4ae997adcbd ("net: mscc: ocelot: initialize watermarks to
sane defaults"), this behavior was somewhat subtle, as the switch had a
more intricately tuned default watermark configuration out of reset,
which did not allow any single port and tc to consume the entire switch
buffer space. Nonetheless, the held frames are still there, and they
reduce the total backplane capacity of the switch.

However, after the aforementioned commit, the behavior can be very
clearly seen, since we deliberately allow each {port, tc} to consume the
entire shared buffer of the switch minus the reservations (and we
disable all reservations by default). That is to say, we allow a
permanently closed tc-taprio gate to hang the entire switch.

A careful inspection of the documentation shows that the QSYS:Q_MAX_SDU
per-port-tc registers serve 2 purposes: one is for guard band calculation
(when zero, this falls back to QSYS:PORT_MAX_SDU), and the other is to
enable oversized frame dropping (when non-zero).

Currently the QSYS:Q_MAX_SDU registers are all zero, so oversized frame
dropping is disabled. The goal of the change is to enable it seamlessly.
For that, we need to hook into the MTU change, tc-taprio change, and
port link speed change procedures, since we depend on these variables.

Frames are not dropped on egress due to a queue system oversize
condition, instead that egress port is simply excluded from the mask of
valid destination ports for the packet. If there are no destination
ports at all, the ingress counter that increments is the generic
"drop_tail" in ethtool -S.

The issue exists in various forms since the tc-taprio offload was introduced.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- reword commit message regarding "drop_tail" counter
- hardcode 1000 rather than PSEC_PER_NSEC to eliminate dependency on
  include/linux/time64.h change (to be fixed up later)

 drivers/net/dsa/ocelot/felix.c         |   9 ++
 drivers/net/dsa/ocelot/felix.h         |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 201 +++++++++++++++++++++++++
 3 files changed, 211 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e07dc39007a..859196898a7d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1553,9 +1553,18 @@ static void felix_txtstamp(struct dsa_switch *ds, int port,
 static int felix_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct felix *felix = ocelot_to_felix(ocelot);
 
 	ocelot_port_set_maxlen(ocelot, port, new_mtu);
 
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio && felix->info->tas_guard_bands_update)
+		felix->info->tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9e07eb7ee28d..deb8dde1fc19 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -53,6 +53,7 @@ struct felix_info {
 				    struct phylink_link_state *state);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
+	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7573254274b3..27d8b56cc21c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1127,9 +1127,199 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_free(felix->imdio);
 }
 
+/* Extract shortest continuous gate open intervals in ns for each traffic class
+ * of a cyclic tc-taprio schedule. If a gate is always open, the duration is
+ * considered U64_MAX. If the gate is always closed, it is considered 0.
+ */
+static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
+					 u64 min_gate_len[OCELOT_NUM_TC])
+{
+	struct tc_taprio_sched_entry *entry;
+	u64 gate_len[OCELOT_NUM_TC];
+	int tc, i, n;
+
+	/* Initialize arrays */
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		min_gate_len[tc] = U64_MAX;
+		gate_len[tc] = 0;
+	}
+
+	/* If we don't have taprio, consider all gates as permanently open */
+	if (!taprio)
+		return;
+
+	n = taprio->num_entries;
+
+	/* Walk through the gate list twice to determine the length
+	 * of consecutively open gates for a traffic class, including
+	 * open gates that wrap around. We are just interested in the
+	 * minimum window size, and this doesn't change what the
+	 * minimum is (if the gate never closes, min_gate_len will
+	 * remain U64_MAX).
+	 */
+	for (i = 0; i < 2 * n; i++) {
+		entry = &taprio->entries[i % n];
+
+		for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+			if (entry->gate_mask & BIT(tc)) {
+				gate_len[tc] += entry->interval;
+			} else {
+				/* Gate closes now, record a potential new
+				 * minimum and reinitialize length
+				 */
+				if (min_gate_len[tc] > gate_len[tc])
+					min_gate_len[tc] = gate_len[tc];
+				gate_len[tc] = 0;
+			}
+		}
+	}
+}
+
+/* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
+ * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
+ * values (the default value is 1518). Also, for traffic class windows smaller
+ * than one MTU sized frame, update QSYS_QMAXSDU_CFG to enable oversized frame
+ * dropping, such that these won't hang the port, as they will never be sent.
+ */
+static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u64 min_gate_len[OCELOT_NUM_TC];
+	int speed, picos_per_byte;
+	u64 needed_bit_time_ps;
+	u32 val, maxlen;
+	u8 tas_speed;
+	int tc;
+
+	lockdep_assert_held(&ocelot->tas_lock);
+
+	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
+	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
+
+	switch (tas_speed) {
+	case OCELOT_SPEED_10:
+		speed = SPEED_10;
+		break;
+	case OCELOT_SPEED_100:
+		speed = SPEED_100;
+		break;
+	case OCELOT_SPEED_1000:
+		speed = SPEED_1000;
+		break;
+	case OCELOT_SPEED_2500:
+		speed = SPEED_2500;
+		break;
+	default:
+		return;
+	}
+
+	picos_per_byte = (USEC_PER_SEC * 8) / speed;
+
+	val = ocelot_port_readl(ocelot_port, DEV_MAC_MAXLEN_CFG);
+	/* MAXLEN_CFG accounts automatically for VLAN. We need to include it
+	 * manually in the bit time calculation, plus the preamble and SFD.
+	 */
+	maxlen = val + 2 * VLAN_HLEN;
+	/* Consider the standard Ethernet overhead of 8 octets preamble+SFD,
+	 * 4 octets FCS, 12 octets IFG.
+	 */
+	needed_bit_time_ps = (maxlen + 24) * picos_per_byte;
+
+	dev_dbg(ocelot->dev,
+		"port %d: max frame size %d needs %llu ps at speed %d\n",
+		port, maxlen, needed_bit_time_ps, speed);
+
+	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 max_sdu;
+
+		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
+		    min_gate_len[tc] * 1000 > needed_bit_time_ps) {
+			/* Setting QMAXSDU_CFG to 0 disables oversized frame
+			 * dropping.
+			 */
+			max_sdu = 0;
+			dev_dbg(ocelot->dev,
+				"port %d tc %d min gate len %llu"
+				", sending all frames\n",
+				port, tc, min_gate_len[tc]);
+		} else {
+			/* If traffic class doesn't support a full MTU sized
+			 * frame, make sure to enable oversize frame dropping
+			 * for frames larger than the smallest that would fit.
+			 */
+			max_sdu = div_u64(min_gate_len[tc] * 1000,
+					  picos_per_byte);
+			/* A TC gate may be completely closed, which is a
+			 * special case where all packets are oversized.
+			 * Any limit smaller than 64 octets accomplishes this
+			 */
+			if (!max_sdu)
+				max_sdu = 1;
+			/* Take L1 overhead into account, but just don't allow
+			 * max_sdu to go negative or to 0. Here we use 20
+			 * because QSYS_MAXSDU_CFG_* already counts the 4 FCS
+			 * octets as part of packet size.
+			 */
+			if (max_sdu > 20)
+				max_sdu -= 20;
+			dev_info(ocelot->dev,
+				 "port %d tc %d min gate length %llu"
+				 " ns not enough for max frame size %d at %d"
+				 " Mbps, dropping frames over %d"
+				 " octets including FCS\n",
+				 port, tc, min_gate_len[tc], maxlen, speed,
+				 max_sdu);
+		}
+
+		/* ocelot_write_rix is a macro that concatenates
+		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
+		 * the writes to each traffic class
+		 */
+		switch (tc) {
+		case 0:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+					 port);
+			break;
+		case 1:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+					 port);
+			break;
+		case 2:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+					 port);
+			break;
+		case 3:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+					 port);
+			break;
+		case 4:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+					 port);
+			break;
+		case 5:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+					 port);
+			break;
+		case 6:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+					 port);
+			break;
+		case 7:
+			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+					 port);
+			break;
+		}
+	}
+
+	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+}
+
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 tas_speed;
 
 	switch (speed) {
@@ -1154,6 +1344,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
+
+	mutex_lock(&ocelot->tas_lock);
+
+	if (ocelot_port->taprio)
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
+	mutex_unlock(&ocelot->tas_lock);
 }
 
 static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
@@ -1210,6 +1407,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		taprio_offload_free(ocelot_port->taprio);
 		ocelot_port->taprio = NULL;
 
+		vsc9959_tas_guard_bands_update(ocelot, port);
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1284,6 +1483,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		goto err;
 
 	ocelot_port->taprio = taprio_offload_get(taprio);
+	vsc9959_tas_guard_bands_update(ocelot, port);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -2303,6 +2503,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_modes		= vsc9959_port_modes,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
 	.init_regmap		= ocelot_regmap_init,
 };
 
-- 
2.25.1

