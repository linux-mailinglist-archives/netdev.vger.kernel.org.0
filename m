Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD8567DA9F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjA0ATS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbjA0ASz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:55 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA947519E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:18:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfF3ppI3w4+QmQ1+wiH+yJcTUgvL+uC1KqScBSrsyPX3FbFCvXzRaVqjKuF6NOQclBs6ZYuzsLr3tjzV7/1HYnx9hDXoVJPAbd3H4FTKpzM0dJ5xWYV0Gleyl3zfyyPMBnytnG4RHH+Se5OWP6Kl3khf6kAKw6MxlV5aYRvc+NZd4tf36TxD4HU3jXuFxswk0C+xCaCs10cOJeJDpkRmRyD/kG/+AwKzmq2cvE3IGkzpFTawVErpEykSi1wx68Da64iTYv/RjfAWgJmOttEyE8Q436nwwUdgp8n/FptITMWOHh8IFhBgwwRe2oRMHARmgIA+87MjCswjaJvBdLMJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ndFIi1U5FPLxNA4whZ6Cc/1FSP3HPP75WQ9jOeXeTo=;
 b=HNJyVAHRnt4rP2VbGiBKdaux2qLXLWFsUQFzbGrrnuEhdO/jLIZDCDJ4QFkM/Edngt+rBEim0e1b88RErK0gCwHvk+zQoXz7fDWiXaq+haFes0dhyFhsGHq1SI/kdKAVa2+CczohEEQYCITTzJRFLRzQ3wgQdN+ZuFYsiWPjv+QnAQx1BxNxn+M5lqDfx5b1hbVFQXSZwQEl9v1+Z5w7BZ5z5r26tV9BYuooAS62tWY5Z5Tddy8PIPGdPi3DTWndz3YODD/gXaSsdyqzyvCG6SPqBO6LCsfZrucsmVRgwWhwWgO1EpHnvy/motMZXa1AYhNTcLK2O6fbSjCxWrtvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ndFIi1U5FPLxNA4whZ6Cc/1FSP3HPP75WQ9jOeXeTo=;
 b=iVpoocjNU3S96sbV0v7tYX2I5NDL1zhI9wNLiibMYWgce4iU0sjc56vcbrkx/tRUm2TzhR/l6sYR/FNJIQZK3T4vLanXXqAIfbx69cnngKlQVrckkbzBLKN0rmiELBbbvX95DDP8MARBi87B5rG8pwbuNaNGWm1xdeQLq+2vO9s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH v3 net-next 15/15] net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac and tsnep
Date:   Fri, 27 Jan 2023 02:15:16 +0200
Message-Id: <20230127001516.592984-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f1270f-35e1-4614-0a8d-08dafffbb2b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0BIH7120jpQR96fai5fTp4391Vp4fCvI1kore67vLXaU9/jf2X17L9wx573ZMcckYOLriRlJfGLoKt+BSJ7stCs+qsoW7WVYNITg/DlF9696rYrEu+qAAGKij3qCObH7lBZ40ObZ/IeFNJzna40KrRcqu/S/LMwGc1+LZ5LcQZBgnAvzyJFkFRNVoYjR2COFtiSPQTIesZPPY3qEqDEjkoL3A3gjHt2k9Sd3fQSHCzJGQDTP+KTEfVPTrSLVd5Yr9DfYt5AAYCPiwQDU/dN8kaYXcBuyODAh5+P621iIi4MX+zMlZNIRbLpGfsttXwvT/iMPrRuVmYgBrryL62qebb1pKRXyn9rDP5zw/XjufYkwEe6YwGHvbZpqYiPc9XWuZZdsysvK4XBqkwJ5vkjIO6FqFWZWjZBf3kFljVHVgCnV1aZJ9lhI88Pf4fQ/KPdFhrnoAcRw+icgA/es3UYlAcmb80K0Yf5hUgNChQudqdn6yjPUE8lJj8jsjq+tAOEopGXr4mAhCsTYB/GXzJAyq+RTT/H0HMztgCvi62wZmSN3clNLVsIU0JgqsgGKSf1tKa2UjdHDvvVuYNsmRwEss6+98vWpqTaujzUmZHeYGa20i1+AXnhF7MQfQEuI0MFg0qWHOWdbNIIW0csJa0d5U9Ipd1iGL13ZKKl2E1E/emnPbiuwoPxeE3Qpcpfy9oSRSdT3M0RvAIdsvSo+cdKMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(30864003)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y7BLtEJpL7TIATY56fzdcjIPwh3fXdJQ8YvJp52ea+LhY4iufzTQWNE/IMTL?=
 =?us-ascii?Q?ke9/oxqxRWQwrkWUN2dObHxkhCdmpRuNZxwajOufZXEo1FasEvmLeUDSgAZM?=
 =?us-ascii?Q?RZBLB6fmK6TCppyBtSSq3ZZM6tDBC5XtzltgElMBTvXpZvYdwLiRxvtTYeTU?=
 =?us-ascii?Q?q1KptrEs9iTC38ftCZLQIEhfT4rkbjPXa5iVkrzi7dJ1oQ9joJUeWJTbtMri?=
 =?us-ascii?Q?XQsXXbU8anul7EEWUg9XxkIyQ8yy9zVuzI/Y3N3oJS0uRz6jASjSCXY62Nu7?=
 =?us-ascii?Q?iTzQdWA2qcDuAIOCr980V0cDtBt2BAzPMeXKDAAgx76sL/T+O+tisPPJGBed?=
 =?us-ascii?Q?nmmMTKeSTr4HJWjKeb29l/6arVhxDdiYfgD+DGthAnF5K6xNo4l+8729DTk0?=
 =?us-ascii?Q?HIjA022V2DbPOLArHlUDmh8x0z9jnEUZtxImpPtUEeF6u24KG+C3onQwNzJL?=
 =?us-ascii?Q?SbAZi/pwMs1sJ+z4hfZVHcWea1UzFlM47x5R5GRbgXzX1ShKI70LAMUVDPfm?=
 =?us-ascii?Q?4tKbeHKMxyvkhDhtrjqVqBmEpwuEo9Xxf5FO5wub7dsAP/LYyJQgNDiKSBgh?=
 =?us-ascii?Q?NISgrx0/kKmC4r5OZSCRdToFhpTLZ6pme1PQSHVAT021ZWGWQAjLzArrwumm?=
 =?us-ascii?Q?JlksD8OsNT6QGyvxrjGZ4LEtTrrP3TohcQyJAYJGgML/QJvEmjM2Y/9EJlAD?=
 =?us-ascii?Q?UEv3rL4EBoGSdo4qFEX4fmPu8hLiROmMvY8pBaLbK7MPn6NlNLQMAWYqK1YW?=
 =?us-ascii?Q?6tuaAXBbm9LXPWVdDxrluu6wkkjQ3uSLw/jMNZMm+y0teqZLllBSEKMlElNR?=
 =?us-ascii?Q?2mW3UQrGH9xz1qY//9cArmJ0zy2ntM/tYunwMrfhQpVZnEy4AbAxl5Bh7fw+?=
 =?us-ascii?Q?FBcKDBQXCeaiIb97FWLqmlpguFFz+WhOrT/QF588JAPPuU9910Bl9rwSiup6?=
 =?us-ascii?Q?jheaD/5Nhxls39i54iN7UAj0w54lzy4kO8PhWFTGHoKSPZaj1UkqNkPhGx8q?=
 =?us-ascii?Q?O/wk7Kv19jxreK8kDMLBBs9iOtuh3ltaCmO88pJVS+lxppKCUTBy5D/wZlhA?=
 =?us-ascii?Q?XiK38eREEsHWgBrnHX/NnoBdd1w/q703F879oK4sF7w5MBWekF80JG9qMTs5?=
 =?us-ascii?Q?KSD5vo0/EOHDOMejBLV7Y4+nTDm83Z6m0yUPS5oT++p+gqi4y4LwnoecX0JY?=
 =?us-ascii?Q?I3KIFSi2p5I/kmvRF6oEjOpFnMSj9hUeg4xqZswfFhecwt6cCGGC5K+DIQ5n?=
 =?us-ascii?Q?xF/f/EL+/41ss+0+NIHriODt4vcU6nM1CNEjj1BT5P/mj6o8MrHO5K6kQKvg?=
 =?us-ascii?Q?CIy65u9Aa8sPM0V4ADESFgp01RI/O+7UGQZyVYhs3ywLRw5haivRfr9tmSSk?=
 =?us-ascii?Q?gltuxEV4ZAyeObiVS2JV8w1zOf6B0ONsGfjHZLtbw0gMY+j9gyqyhkkurJ4n?=
 =?us-ascii?Q?3hMtBE8ojFq1UI7s1l0lCoRxPDLwh4966OlO1yZcjLAcdVNG4yB8+H7P8pG/?=
 =?us-ascii?Q?Ro1e5STh7JZXCr7iJYHlcI6nIr4xmzSGR1tnBlRxAdognwgOzVkWF9NszwTs?=
 =?us-ascii?Q?n6K41xPZW7/q1j3+62Tyt9omeaJ+Rx7eecNBcNwvNcCprGFzAdytsHwvQ7UY?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f1270f-35e1-4614-0a8d-08dafffbb2b9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:12.8566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUmjhT/NrBoPttMJx492GknBiIxf+Wos2qnfLJHBUm7kfpu89tYqysNGbooW1RMKvFi3OuIPP3PAayj3yv8+KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 classes of in-tree drivers currently:

- those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
  holds a bit mask of TXQs

- those who act upon the gate_mask as if it holds a bit mask of TCs

When it comes to the standard, IEEE 802.1Q-2018 does say this in the
second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:

| A gate control list associated with each Port contains an ordered list
| of gate operations. Each gate operation changes the transmission gate
| state for the gate associated with each of the Port's traffic class
| queues and allows associated control operations to be scheduled.

In typically obtuse language, it refers to a "traffic class queue"
rather than a "traffic class" or a "queue". But careful reading of
802.1Q clarifies that "traffic class" and "queue" are in fact
synonymous (see 8.6.6 Queuing frames):

| A queue in this context is not necessarily a single FIFO data structure.
| A queue is a record of all frames of a given traffic class awaiting
| transmission on a given Bridge Port. The structure of this record is not
| specified.

i.o.w. their definition of "queue" isn't the Linux TX queue.

The gate_mask really is input into taprio via its UAPI as a mask of
traffic classes, but taprio_sched_to_offload() converts it into a TXQ
mask.

The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:

- hellcreek, felix, sja1105: these are DSA switches, it's not even very
  clear what TXQs correspond to, other than purely software constructs.
  Only the mqprio configuration with 8 TCs and 1 TXQ per TC makes sense.
  So it's fine to convert these to a gate mask per TC.

- enetc: I have the hardware and can confirm that the gate mask is per
  TC, and affects all TXQs (BD rings) configured for that priority.

- igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
  to be per-TXQ.

- tsnep: Gerhard Engleder clarifies that even though this hardware
  supports at most 1 TXQ per TC, the TXQ indices may be different from
  the TC values themselves, and it is the TXQ indices that matter to
  this hardware. So keep it per-TXQ as well.

- stmmac: I have a GMAC datasheet, and in the EST section it does
  specify that the gate events are per TXQ rather than per TC.

- lan966x: again, this is a switch, and while not a DSA one, the way in
  which it implements lan966x_mqprio_add() - by only allowing num_tc ==
  NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
  software construct here as well. They seem to map 1:1 with TCs.

- am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
  impression that the fetch_allow variable is treated like a prio_mask.
  I haven't studied this driver's interpretation of the prio_tc_map, but
  that definitely sounds closer to a per-TC gate mask rather than a
  per-TXQ one.

Based on this breakdown, we have 6 drivers with a gate mask per TC and
3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
opt-in and the gate mask per TC the default.

Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
query the device driver before calling the proper ndo_setup_tc(), and
figure out if it expects one or the other format.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
v2->v3: adjust commit message in light of what Kurt has said
v1->v2:
- rewrite commit message
- also opt in stmmac and tsnep

 drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
 include/net/pkt_sched.h                       |  1 +
 net/sched/sch_taprio.c                        | 11 ++++++---
 7 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
index c4c6e1357317..d083e6684f12 100644
--- a/drivers/net/ethernet/engleder/tsnep_tc.c
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -403,12 +403,33 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
 	return 0;
 }
 
+static int tsnep_tc_query_caps(struct tsnep_adapter *adapter,
+			       struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!adapter->gate_control)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
 		   void *type_data)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return tsnep_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return tsnep_taprio(adapter, type_data);
 	default:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e86b15efaeb8..cce1dea51f76 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6205,12 +6205,35 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tc_query_caps(struct igc_adapter *adapter,
+			     struct tc_query_caps_base *base)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (hw->mac.type != igc_i225)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igc_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 592b4067f9b8..16a7421715cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -567,6 +567,7 @@ struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
 struct tc_taprio_qopt_offload;
 struct tc_etf_qopt_offload;
+struct tc_query_caps_base;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -580,6 +581,8 @@ struct stmmac_tc_ops {
 			    struct tc_taprio_qopt_offload *qopt);
 	int (*setup_etf)(struct stmmac_priv *priv,
 			 struct tc_etf_qopt_offload *qopt);
+	int (*query_caps)(struct stmmac_priv *priv,
+			  struct tc_query_caps_base *base);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -594,6 +597,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_taprio, __args)
 #define stmmac_tc_setup_etf(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_etf, __args)
+#define stmmac_tc_query_caps(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, query_caps, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b7e5af58ab75..17a7ea1cb961 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5991,6 +5991,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return stmmac_tc_query_caps(priv, priv, type_data);
 	case TC_SETUP_BLOCK:
 		return flow_block_cb_setup_simple(type_data,
 						  &stmmac_block_cb_list,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 2cfb18cef1d4..9d55226479b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1107,6 +1107,25 @@ static int tc_setup_etf(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_query_caps(struct stmmac_priv *priv,
+			 struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!priv->dma_cap.estsel)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
@@ -1114,4 +1133,5 @@ const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.setup_cls = tc_setup_cls,
 	.setup_taprio = tc_setup_taprio,
 	.setup_etf = tc_setup_etf,
+	.query_caps = tc_query_caps,
 };
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ace8be520fb0..fd889fc4912b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -176,6 +176,7 @@ struct tc_mqprio_qopt_offload {
 
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
+	bool gate_mask_per_txq:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0415f0dbfcc8..f2c585bb0519 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1217,7 +1217,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    const struct tc_taprio_caps *caps)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1231,7 +1232,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+		if (caps->gate_mask_per_txq)
+			e->gate_mask = tc_map_to_queue_mask(dev,
+							    entry->gate_mask);
+		else
+			e->gate_mask = entry->gate_mask;
 
 		i++;
 	}
@@ -1295,7 +1300,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->enable = 1;
 	taprio_mqprio_qopt_reconstruct(dev, &offload->mqprio);
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

