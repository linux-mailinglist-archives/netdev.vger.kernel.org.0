Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C244467DA95
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjA0ASa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjA0ASM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:12 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FC974C30
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFCpdl8OWur9fTnAwjI0nXvVXJPFPtQaeuRHMUK7qEmAZnR6eyZEnHdAUwENihJtyxapPhxf6Sia3sGuzvekPpg4E5ANhDNQzQM900RaD0nN+c2IADfZ0FMsbqTtPF4dCizEk69KdhPH6YKmhBc9CJ4jEttcu3et7XwpQEl4fbuHPmBbMAUGLu5PVNoULFVk/mZtGVlzhAZxiLznODNhdygjpTiloiu4YS6F4lsSjDVgdePFDCN83bvTjiEb9ydIbXBZ3WKyuQbYGtyzf0aP4hhBDOtnFow0PBtB3QSJFaUVdD7m0SmHNvw/QY1eZ+FXvdvC3ASQDoFYm8UvMafybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ENeof+qgrlvYsfq3dLIbqq7i5no303xwSZYVrlNinM=;
 b=LlwLlcMQZXxnhYvjFfQrrUpmwGNdg/AbMgqfsS/GK5hjE8lI96VUKd2T0IgXcY22S/RtWyIUmabps96W8dqj0oV/TuyRQEeLReJgvc8NbtQZRqGbb5lPHrrLSJsLXDt44ex8hKle0cIWtycTHDR8DidddtV9D9t9ziC/v1sn9s3XtoJxlvyodfdLA4JZjOHrprW6bgWV4bK6LCvTHtte4aAclAJxexwyeOtbaLZKe5Tt1MijyQaYMHyovFU3BnQ6X50iJeDndom+W09PfBC5fDhcLtlQRG+F+WTqT+uEnjALSj3waryKQ76YMm4COHOzei40xaT5ZyBpJXeQ93ew0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ENeof+qgrlvYsfq3dLIbqq7i5no303xwSZYVrlNinM=;
 b=mRydjXP2/NcmhRe3P9S+jD4PLufB8wCI3Vh4RjRjUpIFMImJAZn6kiNLNww0dnMz8xuxVIX253kZHkNHgSzBRY8YZ5/BFqWGhaP1nKxo7fXXtRvev8aNtRrLz4jWvUHgO+tOq+hWZX/j+Dz0WSe8zax7Ss7tzcTheEMR4F1BqTA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:08 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 11/15] net: enetc: act upon the requested mqprio queue configuration
Date:   Fri, 27 Jan 2023 02:15:12 +0200
Message-Id: <20230127001516.592984-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0b803341-1605-49ae-1fdd-08dafffbb03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bviNtSNKpcwwU3yae3AwkEVVlFe4nxtw8q8xfzGoIGh/G35/tzxirV+OliQSlEKYcZy/nIWo0EJ++UEtTwpbNvyu54YofcnWR/ostUvDG2UgLbg/HfyZJMID4yt0QQa00iCH4u/nE2XViDTAzNVXnWQzRo8ygvLZyOfnhLR1nzyOMchdcVgbfE3Gt939oO01o1yhpU2bPUuxG+OuLrAVg70ibzXvuXEV53glzmeFEWTa4m6KjmVQl3EevDH9o/dLvayzBObTYbzDqhp86e1N+TFRDsSeWer0YxpBK39WuF/hNDMGCAHu5rGrBD8KUb4/oHFHH+tnHFmjBoqV+jJJC299duF8sM5cKQyZVuZcaP1coGO5k6d7fVbbvQH2h414+mPzxcYO0hmJmusp6GkwLu59yATE2jDeqw6LMM3rvWtPW4PCqm5Tww3waakKcmNYTibme6MnTHVwSjSDIWuHJgn8uFJxB4kwNiIezfTnaCtCHwYE2feM87tft1EKL6j39YGTPt/fGna38/5mP9GGxJzk3IyZFFRPsvTECb9sk8AS26ns1orlVDKwOT5BFI3qAiUKPsfaln5vz0H5bqvayCduftDe3lfbPaIzJrn7gpCQpDK3KKYUXL+lWeNcqaXuaJfNVpTNbJ3q6tzcIpxJU9R5Y1eRkAG/9V6hVdpBTA6aTQ1NoHKdX1lyAvUJXGLMysy28k4Q7cytpIWsjzmynw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VskdiO7mLyBOd+qMkQU+PP+KJmR6Jex5PAJGYYuqVOS0xIVL3NWBPiFkzd4k?=
 =?us-ascii?Q?RWhbjXo0pK2cjW71s6JZwR7B/m5lj9Ro0HH0zKxd/CjEPrQZrY1BvQBsnu6s?=
 =?us-ascii?Q?DJl137PKXu/23rc8lc4wrROlS/M/734hvyc8lwV/oozIYFIpEAVmiv8QNA56?=
 =?us-ascii?Q?icN71bSGCmml3phl0GB4ZBMg60vDPTrYngrKowkpVQl/SmvwQI9hUOIPiPNg?=
 =?us-ascii?Q?kS9lN3R6ygFfkysCP9TsK48hNxWwHt8N/mvDPMhcTaPFvzUBd0I+WgkmcUa+?=
 =?us-ascii?Q?7Up0B/OUUfyzObL5gLG6b155UNMghslsnx0yLVJqAH2RlhT1QzTWV3HtC9GR?=
 =?us-ascii?Q?Dky9ja9l9YZJFilbExQjgZ4FZcgqUW5JXrQajzr67qGAUDcCjo/FApR5bTQS?=
 =?us-ascii?Q?DgQkOecEqwU0rd2EwjA2yOyF3D7Wa41n4ESAvz+G4/h0ULL/KHVJnYx7ykhk?=
 =?us-ascii?Q?MToOW2U6xPzCCD+T5Zp7zS016frAJge+zK9hWzCvE0EFyZmVBrHOjdhoPM1V?=
 =?us-ascii?Q?Q+udsMfkqndbnE0WE470C15I7VM5sJ/XcxisfgvKfQ6TTjEUuO1jlTZqsA8C?=
 =?us-ascii?Q?+0tFyeT4BxZMBsQxXJJgC7iFyHh8mpuqhizCNoJb+7rU1FJ4sPaNbs/itrvd?=
 =?us-ascii?Q?joQZnwl2/snjVnFHvmyh1gTJXt36RpFupupoijvmNuq390Zu0nOD+xswEo8l?=
 =?us-ascii?Q?kafIL+2CG66Uc2LIpsKfLKCGSFZ9k/iM4bd15ZcSlpwbdYeLaeVogdtU9niC?=
 =?us-ascii?Q?ZxfqJ8Id+LRjnLwkPdNkcO3NRsd5OsPw39QeHT+VBmX2q+XuP43NaAj0Xb/m?=
 =?us-ascii?Q?j0Qjz9lTSrFXzQo+cZRxOS3JP26hhCwdXrZ5RX20vnwUejNVsPLVe73D++Vg?=
 =?us-ascii?Q?oCa4GyCt38JArNnRncap8cuX7S1WHxAwgHsDENwUy6RoH+wyJhe2Ji6LoZBb?=
 =?us-ascii?Q?hzRyZay/X/J3fJ5TjrEf/ekQW7PxVKt1vxhC8eKN3GPruvP9XSQJsJU4GtYm?=
 =?us-ascii?Q?ILlvXrmB3H6PkYpsYTlm5SAB4nw0qYLCjbz3WEAKLa2B/0M9TejYGokjjLym?=
 =?us-ascii?Q?kaFCiDpPtdmGPMMI15OqvuM2CdD91b7cOPec7Mi9F/vpYB2YzgyMnJAQ0Vxz?=
 =?us-ascii?Q?jNJFg/8SQAJVO9ENe3NU9qT4ke52CLP4dWOlrNzh7d9K8wBjoKJG8nSESBl2?=
 =?us-ascii?Q?wXTBSjIWzpEiQ/9p5Ncg6oWOnrjDLPIj7bgJor5PrwWoAqTW+/HugNain/04?=
 =?us-ascii?Q?8LdHDxs3V1bH90MXro/xPkH5PeICzoEX1CeDrxjdQRBd44aoXOadjH2Md8Sc?=
 =?us-ascii?Q?HN07ynZlittslpYR3BHrKjcYiP7T3KkOoAFJT+vA4MQFPvBl1q8+BlfJOcsQ?=
 =?us-ascii?Q?ypdYe2/TKdq37WLe8oyKVMCoOYqnb6S/c5n+d5UhQ3tGXTjpQiEEVtdx6g/v?=
 =?us-ascii?Q?xHA/Xk6EC/ezubkqpK7y1Vt9T/ZHFDeZ5NSxETl0Ht6uGFl4qqJztvKAhwJA?=
 =?us-ascii?Q?B3K9OXQ0vEd15Px0gAeTfC+tv4dL8qagnGy5W7fIMjLveTlcPQb/Iq5spEHX?=
 =?us-ascii?Q?WfZh6rUAKsZh3AzW85b39gjjmBdWbXw9/NUmlJ/eX9ztMlImlrQHWSkMjWgc?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b803341-1605-49ae-1fdd-08dafffbb03a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:08.6538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKnUAqB2np3nl9tK+BQwEiKPZserFTpDN156s+bHN8Aluwd1cBgRwplB0ltIUtWC5Rqkf3YHhOIjcoA+qum8kw==
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

Regardless of the requested queue count per traffic class, the enetc
driver allocates a number of TX rings equal to the number of TCs, and
hardcodes a queue configuration of "1@0 1@1 ... 1@max-tc". Other
configurations are silently ignored and treated the same.

Improve that by allowing what the user requests to be actually
fulfilled. This allows more than one TX ring per traffic class.
For example:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 4 \
	map 0 0 1 1 2 2 3 3 queues 2@0 2@2 2@4 2@6
[  146.267648] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  146.273451] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  146.283280] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 1
[  146.293987] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 1
[  146.300467] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 2
[  146.306866] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 2
[  146.313261] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 3
[  146.319622] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 3
$ tc qdisc del dev eno0 root
[  178.238418] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  178.244369] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  178.251486] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 0
[  178.258006] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 0
[  178.265038] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 0
[  178.271557] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 0
[  178.277910] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 0
[  178.284281] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 0
$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
[  186.113162] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  186.118764] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 1
[  186.124374] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 2
[  186.130765] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 3
[  186.136404] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 4
[  186.142049] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 5
[  186.147674] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 6
[  186.153305] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 7

The driver used to set TC_MQPRIO_HW_OFFLOAD_TCS, near which there is
this comment in the UAPI header:

        TC_MQPRIO_HW_OFFLOAD_TCS,       /* offload TCs, no queue counts */

but I'm not sure who even looks at this field. Anyway, since this is
basically what enetc was doing up until now (and no longer is; we
offload queue counts too), remove that assignment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: move the mqprio teardown to enetc_reset_tc_mqprio(), and also
        call it on the error path

 drivers/net/ethernet/freescale/enetc/enetc.c | 102 +++++++++++++------
 1 file changed, 71 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e4718b50cf31..2d87deec6e77 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2609,56 +2609,96 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	return err;
 }
 
-int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+static void enetc_debug_tx_ring_prios(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		netdev_dbg(priv->ndev, "TX ring %d prio %d\n", i,
+			   priv->tx_ring[i]->prio);
+}
+
+static void enetc_reset_tc_mqprio(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
 	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
-	u8 num_tc;
 	int i;
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
-	num_tc = mqprio->num_tc;
 
-	if (!num_tc) {
-		netdev_reset_tc(ndev);
-		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-		priv->min_num_stack_tx_queues = num_possible_cpus();
-
-		/* Reset all ring priorities to 0 */
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = 0;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+	netdev_reset_tc(ndev);
+	netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	priv->min_num_stack_tx_queues = num_possible_cpus();
+
+	/* Reset all ring priorities to 0 */
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
+
+	enetc_debug_tx_ring_prios(priv);
+}
+
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
+	int num_stack_tx_queues = 0;
+	u8 num_tc = mqprio->num_tc;
+	struct enetc_bdr *tx_ring;
+	int offset, count;
+	int err, tc, q;
 
+	if (!num_tc) {
+		enetc_reset_tc_mqprio(ndev);
 		return 0;
 	}
 
-	/* For the moment, we use only one BD ring per TC.
-	 *
-	 * Configure num_tc BD rings with increasing priorities.
-	 */
-	for (i = 0; i < num_tc; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = i;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	err = netdev_set_num_tc(ndev, num_tc);
+	if (err)
+		return err;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		offset = mqprio->offset[tc];
+		count = mqprio->count[tc];
+
+		err = netdev_set_tc_queue(ndev, tc, count, offset);
+		if (err)
+			goto err_reset_tc;
+
+		for (q = offset; q < offset + count; q++) {
+			tx_ring = priv->tx_ring[q];
+			/* The prio_tc_map is skb_tx_hash()'s way of selecting
+			 * between TX queues based on skb->priority. As such,
+			 * there's nothing to offload based on it.
+			 * Make the mqprio "traffic class" be the priority of
+			 * this ring group, and leave the Tx IPV to traffic
+			 * class mapping as its default mapping value of 1:1.
+			 */
+			tx_ring->prio = tc;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+
+			num_stack_tx_queues++;
+		}
 	}
 
-	/* Reset the number of netdev queues based on the TC count */
-	netif_set_real_num_tx_queues(ndev, num_tc);
-	priv->min_num_stack_tx_queues = num_tc;
+	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	if (err)
+		goto err_reset_tc;
 
-	netdev_set_num_tc(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_stack_tx_queues;
 
-	/* Each TC is associated with one netdev queue */
-	for (i = 0; i < num_tc; i++)
-		netdev_set_tc_queue(ndev, i, 1, i);
+	enetc_debug_tx_ring_prios(priv);
 
 	return 0;
+
+err_reset_tc:
+	enetc_reset_tc_mqprio(ndev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 
-- 
2.34.1

