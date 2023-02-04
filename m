Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8068AA6B
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbjBDNyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbjBDNx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:58 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E285314EBA
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2ZxljniJVG4/z05zcdq2wqsHj9ljpMV1Slp+dID45z52broZR+CTImhrej/V0GBh3kvUNO/kQQDRpL7X/bE2eimJSkfT3KGRoup73OmN5fTrqXlsfZ1p8TrMFgzpxKckRB37yBzbKbaMZHfp3PD268+1TmJ7M/a7BcwNL91G399xfKbScP+kV9oasNfRwhcjpvBOaNUjakRcprfBDlqPUiaGCA6WGIPdw3NfMExn3pJxIg/oWK4NeQJ8uxMu62DmX2/6e1CC2txRs44QilF0hr/gXaB0CdkbUyBr8ODdLnu2VAt6DLMbvFJ858DVkegM3ykgtNW3UoRlRTRWufZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlR235Q8kefiM7iSzRPZA1RXbKfnUPLCCrHtnLNCIH8=;
 b=dzoIemcash3C6Mp2TkN07tza5hzU4MxYmqJwJ7fR0hV3DfRvlB//9ZbFNx1BqDdM0Sd41sIdLM8d9GgQExEFT1n98vqQqwcXh6u9WKN1/OFObSU3ORv0cq9hJVGvLHRLU8sGTp0av2iHHrAj5u0fRKXjI6JT2FfL8XpEFrOIsdEL2lAZyC7hz7IB6oKdHAWYZ/kV7kqOCiHgFGLISpbSjSJ/SRjw0h0XnqkQ9CdthewP79pJNqXj/lqqRpIBZ0ieME64+VZwl36x3sN5wAM+ZGxhnvhCznIZPGOHqGjey43uI61lbTbBcaGeYbbMsFaRiirgMTtJNK+KJNkD1rcMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlR235Q8kefiM7iSzRPZA1RXbKfnUPLCCrHtnLNCIH8=;
 b=EQ3yot2NTvdbth7/UDUjMJ5w6cOg4lo6z9lj+GU//bgwKq6km8/fYV/o6wjiplwh9fHjDXkKIj91fAHoAW3nTx0w6xQxYenz/piXtA1I4ecRlCYYR3r9NP+CdXqSCRe8+1k1rCetAIis7nK/NvoISUyNjn2K8mTt1hgjX1ISaoI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9047.eurprd04.prod.outlook.com (2603:10a6:20b:442::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:40 +0000
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
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 12/13] net: enetc: act upon the requested mqprio queue configuration
Date:   Sat,  4 Feb 2023 15:53:06 +0200
Message-Id: <20230204135307.1036988-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 82efffaf-7aa3-471f-58f8-08db06b738a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smLjEKVjnGOXByPx+31kxqwE5TD1ZBHfk8IwYRDatKGGgHvtAThqcknCmL/JTUzV8ZVcwgM9fCI3CkervxdQMFEySjPx4IV6gwg63aLqBRa0XZMFH+b3vecELY2ATDiX2fVnX+OdbmKPxG89yMGQEXGTtfAlh0IKRZ3WwHJEs64jJcJsrFlWBDMZAJ+W2vbd/ZDOMJozNgIuXdXuMMA+BQKLw/EQFIIRppOaSMBburE1yyGWuVNZRFXtCpqrDKLRUBRb0ugFmzLuVwgH4GaSNmCLopirQTsfF+r1vRId7kmg+BeUVx/Kziiok/TFddPFzj/ZVn8qlnjHWLTYQbR+l+drHWsvmPnXjlCS6LA+COzuTM6SNWrD0c40c0kgVXACGlfBpCk91q7dLS3wnco7o8Bjb/x8rTxfmGSAmi58BHUzIFnSpxwWThLuuwHn3SI3DFfgBEYIjmQTpwKFUX3AeJGoJiY0plpvIkNPQ4l9J/2VWdJoMAiowJbU8h2OgSaEXJ1FEwfIHjk0IR0vnvfzxLbqnFTLCqw2NGd87k8R0BY82LgdflpOSK/tYBB42ULtIYVaJmjtIsOtl7Xn7Cd2HfQDxgu6hU/wsrUiHlpccVzkfxetNCqnax1ic8Rrwcrx2jJTewahxFQR7TX9BHFceu4l/GCbEGfxFEAsy+NptWN/cCIFWdGAiny7ikpFVjOOedX+heBLav0xHzhiMOVTCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(7416002)(41300700001)(4326008)(8676002)(5660300002)(8936002)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(52116002)(186003)(26005)(6512007)(6666004)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a82uHlQF4dyRuy8cPLqe6nO9Tx1ttBHCtNgLMFawg29R8Yhxp8GKynLC1ABA?=
 =?us-ascii?Q?Qki2NG9y3C2gekidYaQdj5QoRlhBGvkm/M6I99XPAgD5dz06Uqa64efujHHc?=
 =?us-ascii?Q?Ka8J28XywS8HLblcrLXy0QODnFqKplUQfDwatzmach1Jz2/OyUyTnZr7Df2Q?=
 =?us-ascii?Q?MHCKdIqMjhH7eabhJ0hwv9Ybknvsp3jvQW1RAQMrYkK7mq7ei3Uu/nrdU4cY?=
 =?us-ascii?Q?E//YXo6wMt4whuNQTOD+nVOnBlj7NAjMUjgZk8L7ocKSlrua79mRbMm4sQ3C?=
 =?us-ascii?Q?DpuU3CMg434PQjfJToNN3sFGx6pz7PyJJZ631uKV9fcTzrcAxMILAiM+kxea?=
 =?us-ascii?Q?VVGA4DmLOCmoQyAYQJfQZvauHVFF0g3mCi/I76I5JzJ8xNXmpoASicOPw7HC?=
 =?us-ascii?Q?L6ZuHzObt1SJZmhStgMNzB910nBzeJA5+G20B62VGU/LAloUCvdTDYOmwrCJ?=
 =?us-ascii?Q?JCgQ4BxMOijS/Eq0Gp/I3NZqrSMm65kTZWoitN+gsdbB0Q8Byb4LUbuDdEiB?=
 =?us-ascii?Q?qbrgT/4dsi7p25RIxM/zS+VTOAclFPOOQjxqlA03lv9mj5j029KIxbATGSCe?=
 =?us-ascii?Q?BRCCDn5fsdVU/NXe1vTZ8Hdkl59MHv6VvbC10HSPyPpkwULrZ6Ce1eIoFyq2?=
 =?us-ascii?Q?E4DM5sYvYkyMmKJ8jolPajuhN7UeFtrdK8GD/gWU/KDYFNG3m6HyJGB3TZWD?=
 =?us-ascii?Q?xohuOfP2Ksx+PuM5B70nVe35FNxzEDuiLdxSAYerK52BzIUcDey3f0jvb1OZ?=
 =?us-ascii?Q?5esWtrxj8I7zTFXScUdR6rd/5jNJ2tFKnnyfNDlc1qnjbOQWDq8q+Fe26XMB?=
 =?us-ascii?Q?YLBvyNKew7IZhdYnONz4v0H33NgXMmW/nm3r6K4Iu87y+Wr6rzCzv4P/71kQ?=
 =?us-ascii?Q?rZWA38eGcZMiX9MInllaaL/WprOkWKfQy4wD+uZfhior6mzIbRkpexQDdeAG?=
 =?us-ascii?Q?EDvsB4CnhYM2kseKjbez/Ld9qEx92+e/gDk2HzJ1y2ea+WdAwd4noHwwfFbF?=
 =?us-ascii?Q?FbLjwJ5mvJgi+KhVhCmGnmAPPJ4bujZ6sN+lcwhw3HaYd70Tote3UMlOEts2?=
 =?us-ascii?Q?2MI6xJ9/4vwMJxMNWtGlAfNzXTxge2YZkNWf7g7bM6nn+FB+fii59MeiXLGs?=
 =?us-ascii?Q?ECBimJlg+ZKXpjV+bNQ/TFsxDbguvGBpE4qUcBBtMvCMIq1lc52+Wrcmu0jA?=
 =?us-ascii?Q?DqXI2Dcwia0EDr4SNktHI0eOP7MwVwYF9wNLp452LvnKZYyTpUyLmuSnQMGm?=
 =?us-ascii?Q?I9KS29novXM8G2/JfloLwNQJIAuN1NYA9t4g6OZVH3/E2uOqJfMLlKtiW5gI?=
 =?us-ascii?Q?V4tHisPLHJHHwkRwEWgEDMRe6g2EEwcjHINIC+yr/qin8aG8pA5gR6I/aQxh?=
 =?us-ascii?Q?dqnq2daLJfYAdRLLTxhLzQvKNE4m89tlyC76XiPvGD/VOiHiyRtF7ymvo8JJ?=
 =?us-ascii?Q?KD+Lw1vwjip1Lr0otrQKKhQcMA5Lhvd8jbdyHsXgoftI+ICjk3kv+XeydgBn?=
 =?us-ascii?Q?wDU/ZmMFuFtO4wNJoawBUwcfriCl2Qdt58uZcLn7QmhmTd3ea7EJIylXINsz?=
 =?us-ascii?Q?pBwxeACyGSZIQD7D+hgJdgDB5TFFnowkNcLC/tA5t2k/ugLa/J3rPXe3ZAe6?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82efffaf-7aa3-471f-58f8-08db06b738a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:40.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhrN1jv5KwJY4KytFg615S/G7zfPGqt3CMMaWFiehS7Q/Qys+BZIsm8Rge7Sz/Od0JaFYBnv3/2QXMHQEnHblQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

which is what enetc was doing up until now (and no longer is; we offload
queue counts too), remove that assignment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: none
v4->v5:
- slightly reword commit message
- increment num_stack_tx_queues by "count" at a time, not by 1
v2->v4: none
v1->v2: move the mqprio teardown to enetc_reset_tc_mqprio(), and also
        call it on the error path

 drivers/net/ethernet/freescale/enetc/enetc.c | 101 +++++++++++++------
 1 file changed, 70 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e4718b50cf31..2fc712b24d12 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2609,56 +2609,95 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
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
+
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
+		num_stack_tx_queues += count;
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

