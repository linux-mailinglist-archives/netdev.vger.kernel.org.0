Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2B67CB54
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbjAZMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbjAZMyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90F16C577
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCrn2AwVz4IIB238GJEbqQBKEMmv7d32eInqvVT/5NpkYi9Nhx5vWMgPF0lqSKbBerLJxPEa9CSeg5OvyTW5s7/NgXpGONqbplRN6WEA9EtkLGy3Py2J+G4AlQzLebecAlTz6+mEONNXCgt3pgWa98HHk7R37iuIIMwZVf/1ktviv9kD+m/dLwAC+B/hrWoVdZ3m8ZEYNNgHbF3bbVDr0Cx/aJD6JhH57+NNF1tbrnsedD/q4E93t39rUeNb4o+nBRBFe+SI6iUneCyLwCj5Wn1QAWG5n1pKbeE6ZSZxzW9pQ8OpuIs6L71rFeyHMVqhgkxMQ0hnZAkB+VCjYsK4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOSgI9aWKqvGsBBf6w8BNbyfFyDIJPakgMYzm3KlRa4=;
 b=d8PovV2eqKhdHYrztjGA/175natwK193979R7hdI0g++UBcHuWdBu6kiXuH4fvDWhFBLlE+t8rfxEaq4WFviQLHvlm9RmKCav3n85gUpO+OY6ZEOJbjIGjUrbW0TFrlSAvU0EsobtqFnwbgtg7ic0f8WEHzZYMDaZq9HhyapBDUKCaYoGC/Ccm2v3QGb/c1Kspbbq3DMZ/i23emM24W75ZL5vCzIv/qmHr//DKhV/6uPKkbRWlMHfefc+ss7ML+5jl9v/RSKZ4vJFUwxkhQk+NpoQbk1ZpvyjfUbhSZzkBOQ0bTJR1ZHF+0xeoWM8SkP+S41MkKPPaT6wrXQpObS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOSgI9aWKqvGsBBf6w8BNbyfFyDIJPakgMYzm3KlRa4=;
 b=lhNraUq7uJVCY/MnLSoUFyUYwI9J7sp5AG/9A4wcui043sATQ8cFF1zYSLkHsuBqFG+fXFF8XmqfO9t3cLRVHnNWvBTWdnpPoYsyiCJo4fwcCiipR5kTCa3rSEqVn3FwfhkDs5HgAt4WSmqFGrIVTjslew7RbfH8+Afl3+c0Bjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 12:53:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 11/15] net: enetc: act upon the requested mqprio queue configuration
Date:   Thu, 26 Jan 2023 14:53:04 +0200
Message-Id: <20230126125308.1199404-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: ec46bffd-b69f-4117-764a-08daff9c5c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2L2p5p0F7m1x0XzMIdwU1v6UuaA2S0op7JOZNSUVOUso1wq6RKz0JLrXbkLh3W7VAQ3l+laXbhVB6FeVxIE7kUqZeWYm+U11yZ0wRq/e0+JRItOYiUbdTtindo6zKqBBQL8cgWN0UGvJpWcBR8KeyoUQVirnhwW6qMJo795kHUQKVOl2crxTLV0rHfoNtPHv9r0YTnTO7ouu5cK3XRriiL5/uNjlYU8F8RuGXj/FVmtHtbIcT9bqqx+PTM2Az5GDi1bpX/5jzgFXqUdg9q07KNWbn8KnOpk05J2J0W9Mw/exbuyRevyjsLyazYcWkds5BCAf53MiSo0dKif94KfCFZw5mW6+/FnwsBdYcnxZzX+XstMt43htZwJzq9/5PTd1URU2gwIVT2JzLDZ8FAbGTkM1+GlMpnVjBFToOr294Eb4zjS5fTEDLPhQGXbpOYGaII4NwjHVdxpRl+SLlaF0/4WxRmHq9R6MUgtlaaEmn4M/xEuX3ha31FUYxSSN398a3ualUFotyA1U21jo3Sd1DRoy9SgXWQBzs1IACcX304aR2tL+6UgzTuEwrpmMz1NKSObqteb01tw77gtcwgwVqNPYWR4AlYQecVAi1m79a7wSYLrjX9c7pIP8xeC7ppRbqqJje11v8abXYozJBpn2o5RBAI6bGbrhfGOE/HLQkwZl64PFV52GDxfREsukj8uImpm3VvuLzocaFK0bxy9Umg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(2906002)(41300700001)(86362001)(6506007)(8936002)(4326008)(44832011)(6666004)(316002)(186003)(6512007)(66476007)(66556008)(8676002)(2616005)(478600001)(54906003)(6916009)(36756003)(66946007)(6486002)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?897rSylUfQudNkksyF6ULE9hEbjKgU+TaObSYm7lni3tLdY3yoOmTlkIQs1J?=
 =?us-ascii?Q?LDSIQQPEOVeXTJ5gM6hehrJFEK3gPhwozy6sVuKlFYv9QpD0nEYcRljhzpDF?=
 =?us-ascii?Q?Xhs4Vy8fZLxa6019+AQ6ooCF/3Q4kWmih1byVpAdfscXHLZThKteT4FS+N+B?=
 =?us-ascii?Q?+3JhiPXsphMIjI6DtsY1QZRvBwPjmQKDhwziO9xbWFV00fA8fr/hViupv5yu?=
 =?us-ascii?Q?4VDkYZJSIvGpGxj2VD3/zlDkBZr9SSb09KZmhCEMB9qWWOT65KvyMyCdcvUO?=
 =?us-ascii?Q?765fgdb4TgttiGA37KM0vs50ohnlSkdB1BCLeBiAl8akqs8bTAAWQ17PXTg9?=
 =?us-ascii?Q?4ASJunurUH0tUjXCd/omr6fMThavFrk3BHFYGonysM4sj5hHZ42HjdOpR6K9?=
 =?us-ascii?Q?lg7O87dfRF3FXEXVOxn0gSPhaFJKzq7dLXUoYzRj06HqarLQxcBhhGSEBbOF?=
 =?us-ascii?Q?xfQgIZZD064AYER5qbIunEertsxsHsL+tbGxM8rZEv1eRaszmvudUJEgxH10?=
 =?us-ascii?Q?ESBS5EN7WKvc73hCXJ9bYKIL4qLOBAWFd/s+F2RbTR0VD39L28AIRPfD2IJp?=
 =?us-ascii?Q?Bb+lkhS8iPoVp7ggEbxBY6XXHwKAHhC+14E7MLUuKMOAsBDJiSxNcs3K5g97?=
 =?us-ascii?Q?7dR7FTMPsAKqnSMkRdciODbjzbUj1RN24epKf7BWkFEBvl2vzAt7utmoFHLE?=
 =?us-ascii?Q?64k9gHPeNQV/H3oj4ofheAShGqeDCHzXeYVpk+wVKHgLiUsc5z4AJ2l0XHlL?=
 =?us-ascii?Q?WHDXkyx5jpXFJGFbX/X7lUSpdb+wgJU5YH0gGWhHF4cVcLIgTKvIH73hl7BK?=
 =?us-ascii?Q?o9UExZM4Y1RuK/YI0uS8E0bHf1rccWa7TJn+JwyPfFBKjBSDx0IID4HDeC8s?=
 =?us-ascii?Q?twM3iA+vUfRiSQnp5rGNtjuIUmdx2xM+S3A0XO+DHN4KRKbmn7fqO+7E2Xv7?=
 =?us-ascii?Q?UlKw+ZRSRsyUjZqnHEZPKJNS4G8xrtyODe0NWLS67tWZvX+w/qptblf3w1Vn?=
 =?us-ascii?Q?elqdWNm5ftEujeh5C0xrYA2hu+i5zNnB9gvKYPZTLejkuynKA07mkEqCXY4m?=
 =?us-ascii?Q?+UB9gHaNJvJ9ECIcWKV7yOmYxTMIRS95QAsujBHl9wo3tGeaDRaMj5CZQEit?=
 =?us-ascii?Q?3ACUWuV44Yzv+0rKI9FTPCc2kLsy/jCdg8ULy/kybC+MrNCJ3f+OpbgFUOv0?=
 =?us-ascii?Q?sMj2oZ6s/zv7xTUvGGv8wKINIl745OL6NZQE7agt4P2Xz0qMWBc2ytxRZcIJ?=
 =?us-ascii?Q?S/iVUCs2R40agOoV98epqmz/VC428Sh6F0bt54uMENUTJDSHS7yz5uPt9hiu?=
 =?us-ascii?Q?6KuDlU3GLjZhXi76pG4g06ozpejlBj7Q4hVXcZDVlXVKdh5mcm9jEqm3uhSG?=
 =?us-ascii?Q?DRWHETJFV/O2KUCkDo3Ykj9QJMPBZKyMSl2Gj+DebBhH86fvfF6+ydRybs+w?=
 =?us-ascii?Q?PuPGWBQugzvKbRiXbT+uOiFHzR5AJKoNN6F3+IZXXfvA7XeTnmIhIxW8wEre?=
 =?us-ascii?Q?rak+yWFjZzVwCDcequG8U9tvl+Fnst6hKQ7PXZqxQ0Sy64Zu8HR+3tqmVd/f?=
 =?us-ascii?Q?GUm7h2NRy2yAHRm0LM9AmWfRpccwjGz+BaoCHucfHQnmddALRoyoc6xSigvn?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec46bffd-b69f-4117-764a-08daff9c5c69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:45.9242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAcI8yfj+wQeqFEkz0j0QKIumLjBGX1n1FNvgfR4EjT8DrWD7W/DbejpkHN7e56rcOcU7MtnrdAWxU+tpOUSOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
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

but I'm not sure who even looks at this field. Anyway, since this is
basically what enetc was doing up until now (and no longer is; we
offload queue counts too), remove that assignment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

