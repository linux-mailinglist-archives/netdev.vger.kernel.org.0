Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57526756D8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjATOTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjATOTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:19:10 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12034DCDE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:18:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exi34/EgR7+b5DleO7vru8J1LLSkIuyD+7223TBx9TrGniSwKrtFOrDiaXw/kwY5LJ/FQ1X860hgsjRiFq0IXUWEW9Un3YAre+2yl3Swe/11kfvpJkkYVuAN/nVvTcZjYislBMOWaAtGocvFuO2CUUJel55LsKZoPYxsFpF48UcaSzqBeyUKorXHPdmqVIIRm66ugMqVykCY8w5WXX4C9/MuR2JvQ3aCtTAHvNvo5YsuEmV7uDxrs8EW/mv188UNkPEJmG4O0HC8JerlF1Y2kYI8Q0dXWDph3jvJoa5pNfjOQ0AjaBmjG/IJ5Ivy/w3dGejkIBABVa2+00sa1j65+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qOc++S4sW1AY6NLAs4hYHFqrjw9gEbAvffLXzzzBK8=;
 b=oVW/5XRKa+Dfg2I+988mS1awDykAl9DVodKl/QKxDyuv+3cUB8xK4Erh9BfU5cs+csGjQHQWj+nxNULCFQi2VEc8rnWt7EpWva42MGx6pqZgsq4YaekviIg5XM4vs2IP6Ou5tQrPerUz059TvvHRv896vZQXYbUC6EtpUqR3uEo2trXnk9/wDYy9714sI4+pW58SZlwj4E6ENnNCr16ukURx9nTtuFSGb/g40VO5RG+0aVzGaSMnqWD5xkBVKnDAPtdgre4HUmUkjH9LZI38OnpdVAD3yrG3FNSwLA9JRC0wzToDEuQZBv1VivEJYf8cORRWWEE8LbuTjPXs7Iaodw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qOc++S4sW1AY6NLAs4hYHFqrjw9gEbAvffLXzzzBK8=;
 b=E3v9JRL7pL71LMcmRtYBUzfPtt67RD3m+uHHEtE457AI3P1z7KPLOcxteNVHcG/wh6La5P+2QiaBqNS4FLPW8H9oljiOzaqiUgazFi3uFoqNlSVmdJ3ilfJtVo1tsa+NB946F1CmA8h+5RQJfvQXyq7gribrVrWZKKy0v8JDcak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 07/11] net: enetc: act upon the requested mqprio queue configuration
Date:   Fri, 20 Jan 2023 16:15:33 +0200
Message-Id: <20230120141537.1350744-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 5463cefe-c426-4f96-5c98-08dafaf0da59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSqc1JqS6h8XS+DRi+RivvnQxvF9Bskypr4qSuT5l6vcQ7b49czzlZtMhYTKi2nmXQC7sAPuYF3fP5ne6zYO4k041d3/gz1QNZQzSqbYLYT8FQ9hZSL/MZtQld5bZ4LPQFEA1ScobXT3heRTe9fkmaq4zFErUKK4N3i8d0BVBenH3Z5gqYRgKk51HmOtqJPVDNrwhF5zcaFqXFg7tY+S0c7NQM6zFdSWZX6OfKoBUFt0PPD/Pp2oKKCJx/DBVYD6apjNhCexm+SLnukZjPD0X3c1cLRIUuxKnXbXWXTyJ02sEv8mUKD9YjaNfkqLijrFxwnfaewfeN93Ud8mz5fbPQDwhWihVyCAr4ImYuojW8yXDl14toyGqnjT1b3TWl3KT0WVP2Z5Q1h2VRSUTBMklKPOxawZCj1rPvNKuE91nWfHPd3Qeho0BHzW8paWVstTfBOGOLXphS05QSe4OgHz6QVzuqHUxvgfkiqgKg//0hBp4Kw5URkCzhTND5LugdODErO0zK0Q0Qw4G7WGAB6Sd9NygTzCYBru4cigY01VHsK5hO0hX8L2bhxFDg0/Ws93CmHqsQWyg9NPHC4zXtckL8biamA6DsSdngXNTN97VmzSBstEn3+Mwqs0+1aqAuN5LL54e1z9oF3YJD0UwZKfR1tzzPKsvWDHGdUCtHkSc5SmXlY9K+WeG2nQiwaAspz69TzQ82dmTUeY/G5za2jC1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Nt0t81yC/o5nKP8Z7oR5+r0EMut/t2Qb7eYid5wvL/BCea9lVVzDtBFQJSW?=
 =?us-ascii?Q?6KaTIAkWlPetE5c4H4jsZCwNOlsk+Lj8migGW53N54EPCcmunzW5iwfCpKEs?=
 =?us-ascii?Q?UZjccpd34Fj+M123g5bCPXbR7fptMxIbzS3gzImD8cOt2hjPMYkb4xGGHf7d?=
 =?us-ascii?Q?8SmnmGR0OM+xy6CBiGL1Kzl3g/iY/feBojExp9pZFjxLt6bBR2k9qJZIYqv/?=
 =?us-ascii?Q?jOnU8u78Q/y4gDhoqzcPchtdRxMtaFg34Qk57ormU9Rq9S2qnesLalHuoY/G?=
 =?us-ascii?Q?wnmXWKNbHCTeZ5gwaki7gmrjjnbHNgdYpZy21QNpwQbniSTtSLmWtOMYlP08?=
 =?us-ascii?Q?JeqLUYTpW/ygEoaWnySP+bkMvqBjIKKGwp4dAI8oJeiDvMhHkKIHkHuGKjyX?=
 =?us-ascii?Q?J9BG2PSi+GJT708ZgeBQV4rvaE5rqa+zpFCDemooTR71x2IjhZlEd2jflSxx?=
 =?us-ascii?Q?zIFYFvkeTIqbB0Qo6PuHsFT9GVfdUr1/7798LZV9VhWqC1JUKeHVswEYTXgH?=
 =?us-ascii?Q?BZ2n9vy8QVfjbYa8vL9t2ucJhoqbrMXMV4ZKzxyOpAWTaIAwL5a+oWc32U5E?=
 =?us-ascii?Q?ZWPRbtzDQhfIGQ0HUdrKfdB23n1SZ//Po4cMIw1Ad81aEZ9MBnjwCYEBAnqp?=
 =?us-ascii?Q?VEKqJNzDth1lkwAgy+7jBlRfiYA7qU/M5v/ZMyJ3oR7so+1Grw+x1m9FlQjX?=
 =?us-ascii?Q?RyzhW7Y2PktKhXJRokhZyVCloxI2JiLGRqKIFYXkcUvOatt/GN1BRE29Ttnp?=
 =?us-ascii?Q?qc8+ZlI31v44gA27rQVMmSP6pIghdgWL0vruRQEi73d67hnabrWMDb6KOYfz?=
 =?us-ascii?Q?/1R/uAs+AyMLw/JX7mEpOHjX3ox9XMdqKjAF+bHw9Ek+oiiRn9UsxS9/7Yo/?=
 =?us-ascii?Q?ihVwiaw7/4pmzvnGK9oq04mItLgszX8/q2mYCzUapQqLg2HSI5L3GkkokVae?=
 =?us-ascii?Q?xLSOPdyb1qDAiyAhru+2B1p6ufX/VlnKasSk37FRSDopKuQwnoF/6XDCzZPZ?=
 =?us-ascii?Q?70J+TCZAQcPLmCOCXX6wNgsWa0lpxLzPLp3/MrYO4oCcXQIFaGHj1W79SFkf?=
 =?us-ascii?Q?PlSw2eBInPaR5seoAmiLYLoJKQrydyJ9SZFD4Q9CXIWSQ9OpnDt3YSEAwTEC?=
 =?us-ascii?Q?PKveO89faiKydJLS4Am7kWc4i1thOQ9QVSaJRDG8yDi2U7AqGGc7SlaGDryy?=
 =?us-ascii?Q?u8bgrb7cMgAszIbrfS5bFKRHx2a/6iLbcMVH7gRUQESRlDcsmmMYUyH7i9H1?=
 =?us-ascii?Q?h/FejbYYuF/8tWgNg0zmKnsWwHXETsxvHIcTipAyOSjEFYLlMSzmpbFYvtNi?=
 =?us-ascii?Q?d4cbT5+xEc/b7DqnHiitLpE6rJ3rnuVyYvv940BtcPyh3hTPVHmPqLweYQkR?=
 =?us-ascii?Q?WeStaG0MkR/OUKwT3vOsEl9FDWlV/YE+Ydi6Y02I6b1BPBeAIf49nKH5/j7z?=
 =?us-ascii?Q?zCpYFxC76H03yNLV1vC0u6IU30y//xqPiC9oIpiTokU8Y9qF+1g+4NR0jIKK?=
 =?us-ascii?Q?kbxUHvUY0HQMXvr2t/k7EW6/BQBf8iWn2TjBUb+12+pswHWRCtzhlgzenjJo?=
 =?us-ascii?Q?7hxfbR9SmbS3DFaj27eUJk4mqVUa0V1/qekDZ8S4i+nFq2qku4QlAzRoWWa7?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5463cefe-c426-4f96-5c98-08dafaf0da59
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:59.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1iMusI8TYYNCp995lHvIi2y07e+8eHe6+CN3tz2UbDREbQsx0qPAewoOt+z8821rXKTR3d8/ET8e4T0eiiyrQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 67 +++++++++++++-------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ef21d6baed24..062a0ba6c959 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2614,6 +2614,15 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	return err;
 }
 
+static void enetc_debug_tx_ring_prios(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		netdev_dbg(priv->ndev, "TX ring %d prio %d\n", i,
+			   priv->tx_ring[i]->prio);
+}
+
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -2621,8 +2630,10 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
+	int offset, count;
+	int tc, i, q;
 	u8 num_tc;
-	int i;
+	int err;
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
@@ -2639,34 +2650,46 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 		}
 
+		enetc_debug_tx_ring_prios(priv);
+
 		return 0;
 	}
 
-	/* Check if we have enough BD rings available to accommodate all TCs */
-	if (num_tc > num_stack_tx_queues) {
-		netdev_err(ndev, "Max %d traffic classes supported\n",
-			   priv->num_tx_rings);
-		return -EINVAL;
-	}
+	err = netdev_set_num_tc(ndev, num_tc);
+	if (err)
+		return err;
 
-	/* For the moment, we use only one BD ring per TC.
-	 *
-	 * Configure num_tc BD rings with increasing priorities.
-	 */
-	for (i = 0; i < num_tc; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = i;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	num_stack_tx_queues = 0;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		offset = mqprio->offset[tc];
+		count = mqprio->count[tc];
 
-	/* Reset the number of netdev queues based on the TC count */
-	netif_set_real_num_tx_queues(ndev, num_tc);
+		err = netdev_set_tc_queue(ndev, tc, count, offset);
+		if (err)
+			return err;
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
 
-	netdev_set_num_tc(ndev, num_tc);
+			num_stack_tx_queues++;
+		}
+	}
+
+	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	if (err)
+		return err;
 
-	/* Each TC is associated with one netdev queue */
-	for (i = 0; i < num_tc; i++)
-		netdev_set_tc_queue(ndev, i, 1, i);
+	enetc_debug_tx_ring_prios(priv);
 
 	return 0;
 }
-- 
2.34.1

