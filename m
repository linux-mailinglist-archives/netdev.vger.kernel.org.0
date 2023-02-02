Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24B68726C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBBAht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjBBAhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:19 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6506D74487
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT8XuBQx+sHBJ3ig3yeO5Yh0tfZ0BMWytiQfFm5OTjb1waSvd/EM3vS8rKNuiYlrQ1WdHa2AnUNdShJcUk85aYKDu5c5r65VfADUbR7XFS0asFIa4Ir0I3op33ngzbnhFhHuYL+a1DbvPt1AlTjV/UvOkuLB6xOukCtzruQuNN3f8ANI+zCzpu3cLH/AErZPRR8PpVPtSy9gJ51PrW1C6A4JXHaF8cqNRPv1ggqheczXG2KiIuL6Fn3xETJpVoFl7orSgUKQILnJ5+63kRbOU8+kSL+FbX8ztA3icot414LndCMwJhxkUqo3AiAgAW+IHO7kaYlzuNWw3890MTnx6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4imiyEOBQrJSL3KAuggZVYeoW53b3ulHUGh/+5d7CIY=;
 b=atABAZcU+C6EaVJQWOTKUVBMrQw3UdG4r7jAw/cuRNRK2loD6VPOw+pUyH79RLPK+oTWSX8nwGq1FoYkxFlez6wAGXsmC8P7fEaCvBRlv2hLl8U9Pq4lNAo+5S2ELCjs/O8snZrd01RpHm4IT+EtX4fgbZFfSAJQchfv6Y6iwfcMOhGMb9iHiw0AKXZub588xIt6TSiTX7nPY112zDzt2RY95P9Rj9FpnAY7tirwQSfWzit/zGU/6vRI+/pvIAbKnEVFLzal9MRpL5VLbyaJP8p4GCfBWBMyYxbNPcICG20v+TJ4Jcd4BqsLIWCGhSUEEVYZ1dwpFF2Wq05wgd+59A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4imiyEOBQrJSL3KAuggZVYeoW53b3ulHUGh/+5d7CIY=;
 b=NS0IHVsNUuelGqSTnQQyFKl7nCmFDiAOOcYflopXqOWFfoatQZtxqo8qE+K/7lj5sNTXHwLXPJwDiifxr8iDNCOjrbErFg8ozwPBinKImcXpLnd3zzCpMO0RGNBkqmCUmXy2w7AEvNq+l1JWhfMufXeDDLpv/kGX7xBe7HR2zqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:37:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:37:02 +0000
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
        Simon Horman <simon.horman@corigine.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH v5 net-next 14/17] net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac and tsnep
Date:   Thu,  2 Feb 2023 02:36:18 +0200
Message-Id: <20230202003621.2679603-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2428ec-8e57-44c3-d17c-08db04b599a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9z/SJRkSLqx47Vcxc0N2iT2g8Fk+HRJ3/a9xhQQ1QgtmfKFCnojQV7EUDeX/FAi3nWVuolbyfrCQEDDHBXVoSykWtIH45pncklzcqEn2aV8z3XN5CG1EV2UmvTSg5P/io8vELfW78OWeXwloh+hfc3EJckzLnh6NX2E6Fb5rhYhpgIOhp20TjCaVR+IwpEe9o1ureP2A31WrzhG8TK3IzZjWHOeHohcDFvLAdoVLK/jWZsUIAEdMISH0g3kNK8D3MWah2voHpBh8T7dYBvjoe3UGLHvGj9eV0m42jhrzxoWIuZt1hQ1DY9bWV1IoC+FF/uLWLUsQYzES3W2WumrkLXqjL11aE+UJAr2u0islJ5Yjtmiu2asmDDd6uc+bxrodWiIpZYRDcLlXoB401zy+lATxYlXALJOxWxpnjHdPSTGUyDuH+zrj5EhnRrC+VDPBhFCIUfEUqb+/p5UpGAWWogDY5yzJoKvQhUoFx4JYQJ0c6CWwWV8/zeXmcI5mlpljmIHSr0HMhhJdGwiaZaQGhv+wxJ350yqxQ0k6iOZHRZOnkAF0JtrJPhK9W2C4zUI8W0kJoQA0yOH5uLRjhiV2HrSWHRHRqTo+8bBS9nK0/G6YDWHzkbIzpTSHJEuIRarmeLJh7qG7/63FEcEfocKq7LUeagGRmkxlL23r45L1CS9BAbNSYx12MIm2AVqS1A8pfigFt3ou+BLCWXbk2lJXuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(30864003)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jy3ouq9t2KigyQyCsjFaH1Af0KnOm87E0Uf6NNsTbxAm40FsJyfAI8HNjK+3?=
 =?us-ascii?Q?BX5rWmG/SEKf6qHfffYEO+KvaDVbJ697UJKJFV9B38t0g2r1okc79DmmoU53?=
 =?us-ascii?Q?S3FoZoJ7dgVQD28UDZoGbIRWwth4JcV6ZDqJ0fDQuBdgA/psMrmsrTW75b9g?=
 =?us-ascii?Q?SUAnOSV8Lkg/VKEwe5nABE8xSn3pNWCJE8g1P33tT4llDnAUdVHODqB3AupL?=
 =?us-ascii?Q?WHoCoWjQigfe3BXEvf7H5YAPCS/6vKx0MZd+pVXmntfpKQ2dnX8m/wWzavpA?=
 =?us-ascii?Q?NjnRJkMlcekZK33GM2qDtVo/s/HhZdNZ5BnJSe9GgywW0nNQFf5MiodmKNkr?=
 =?us-ascii?Q?0debFdIEOAjAhF+VmSYBs0RRzQuE8BU3GfOAR3ZUmxm7+q1dJAk24DD8y8MJ?=
 =?us-ascii?Q?Ac5OmTIS/2sO3A4gkrudBXtAqPe/1EmYX6jzt1bUDH2GPcQYUfUQtiGpryk/?=
 =?us-ascii?Q?wPkyun5uL4s6bsGqf/TKiop5WpF0D4a0h2Rq5h1Rycy2vHvQK7JMUs+tqEab?=
 =?us-ascii?Q?Ua0ASx+dJnZXhasiKSor6A9GspqDHeJvF3kv/q6eTEjOeCzcm4Eq09QDm0RU?=
 =?us-ascii?Q?4W9r99ed4/+VPHclcbjbpiyiKtUVbszZEfG5TWHVq9eytambYD3h0Z8XbAuY?=
 =?us-ascii?Q?9GY+5l1tlg72XzVENDaMPUtb3a+zvkCPAZFg0tjEeoCsN3epNCyOzhcMcni2?=
 =?us-ascii?Q?p50eXgPTl42tgwnDtIK+g7e9e66k3btZCcLzAOOVAHG/iO4+ru2Cfiz8yQtI?=
 =?us-ascii?Q?V50zcf51KKxZjhOni65OpzpsEOuUQYKPGfUsE/7pz43qc06+e5dFgLbH5US5?=
 =?us-ascii?Q?yKBccpYXxJPTvsgvLF2Jt2EzTOAnJMMgDj4/a0JaAhDX/KoenlzdL01CQyfZ?=
 =?us-ascii?Q?WuJpqpfTpI+WYcSP25eCAOpfGL3HZw8nSzX7UzwQ/27rKelf+KEtrC/yOBdg?=
 =?us-ascii?Q?+NynCjwZ3lbA3bvi4Gblm/W1vNOioltXSVpxDyrv8K5/O4mLruFnZ2CCaNlN?=
 =?us-ascii?Q?paI6EwAbK0ilfF5pUoBz3YhpBnH/HnLRn/7GNcJEj8JOX/0IxdNmwn3uOmHO?=
 =?us-ascii?Q?jOYrwZtVw9QEdCFl3kdMel5R35+RQvRslrlKni9CUJ47py5QFV3DDvt1bdDk?=
 =?us-ascii?Q?TU/++Qxqr2D0q0dl/8sipPgwAj2h29ttJw4q5gQvVgXj6iut+8Mt03jCzkyO?=
 =?us-ascii?Q?M+NPT6rVEAjoa07GFyVsN9qgvko8dMbUkgWV4rDot51vR62wzxHXnaItTQRg?=
 =?us-ascii?Q?al1/S77I3R261hHrQpHe9H9UxNDYMp3B3eqpelWYJwe4Nr01w6hMvH/qqedh?=
 =?us-ascii?Q?FGVfujMJ/MNaLraXW095i98lOWrvI+DEaD2PUdnrRyLXPgYswncrlOjdS02Z?=
 =?us-ascii?Q?KKsDelkRHVxQZzQ0vEgyWn7v592VEK61ffnx3TO0ljY2NaWOj6G1NICEMtja?=
 =?us-ascii?Q?GdApN9s6jXrjb2CFBQO8cImYEws31+U9ZOpJ0gGm6GbXaec65YJOJLLS6L2G?=
 =?us-ascii?Q?gp9oJvahsdPWZbrRzxC8B5HbudSQoXVimG5qOYel/p46sYs1yBbMbhzq6Zph?=
 =?us-ascii?Q?a3UD3pBk5dHjrkEbTmmu0+ln6Pn6ddGmiLPP9Ow1EB7nDLy7tw3l30YYPr3R?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2428ec-8e57-44c3-d17c-08db04b599a9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:37:01.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZE+A39eiWPKTMo1LI/mimRbrePn9Gf7KGHPo0veVDAvLLhPa32s7lvEwofcI0uJSbN/Idve4pZehTsDUJCf2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v5: none
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
index aba8a16842c1..1c95785932b9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1170,7 +1170,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    const struct tc_taprio_caps *caps)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1184,7 +1185,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
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
@@ -1229,7 +1234,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->enable = 1;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

