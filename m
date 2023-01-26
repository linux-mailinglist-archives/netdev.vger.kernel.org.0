Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63BD67CB55
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbjAZMyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbjAZMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:01 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2065.outbound.protection.outlook.com [40.107.241.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDA5646A4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fduAEcCMK1eG6zDyU2vXxiKPOhpcjzsKXQpsADMURv/T/OunkbFPBwnvzmGFsuNBdB4qxcIug91PgObN3Hh2owsm4Pz9URlaFXQN6yf8onnZ1jpFdaOAMqQr1IX89dDtGG/eJh1bOhpFO59AKWN5Q5ph8CbPYkPzOPLKCRALXgPc2vpk7xo2Z4QMOxlctbMNYlV356Hk2yVMMHml5LESXPaMIu0aaNSz78Bu4O5f8QAzG3ISdYdZlIUvvErBIGN62Vq1JIcm8rWZ5T0JCLSUfQWPzZmb3GI+MUdbyy+GlN+CSU1anIPG6oyTz6/MWI5kZhEBZdqbt6xrEDZdOL3ycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctqKQmYJRYcHp96wZ4uXwLUf7EnmFCDU+K/vQY4detM=;
 b=bg3rOzvllVPJnG7OdMKwB4Y/k6feTTLEpnNVokfvm7it8+KjZCXHUSwmXvGgKxO92Xe7+5eJYO5qHjhFY3+txq1ua8WNoeB50AftiRn9YODFg+u0X6Vhz2Yp31qpnCD4LFF6Qe0mPHtewZfgHYD0D+g+Z1tKnd64+CluxM0QPuNcr522HM73FNVBjLaBL3Gbiv9A+KzsoNwrWv3ZvKJjJeaOwSR9KwOXwjIaDZN2qIRbDbgcbE96vGZPtDy56qku+FaYfNpkb4BmfeFb4IjFhyQzYNR7OGx4CMNWYRDZarAZcmfMM23xFCvw50PCdTihH13/r3UhaQy5XvFePa8zrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctqKQmYJRYcHp96wZ4uXwLUf7EnmFCDU+K/vQY4detM=;
 b=E48eEso1Qypa7BC7y2zhlk8wSRn2iEWMIB3+CgA4SmVtIoE/CucqjPSOH57SEylysFfnjRJl1a3qEFw+/X/RQ7Ud3BeupYtScPB/txk7sjpagW6HA9Y4bh+AeKywZNfyW8SmhByxoC5D7jDfqgVIB+fRRcifawBRFYOdMIlRihU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:45 +0000
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
Subject: [PATCH v2 net-next 08/15] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Thu, 26 Jan 2023 14:53:01 +0200
Message-Id: <20230126125308.1199404-9-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 60c7ca85-a8e8-4def-a492-08daff9c5aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwSycbyduHDzLl5YW+cl5o59NGEizbLChXZhRi1rxGD1iodphq510+VzV4g6y7EcQJ6Ny6dypid10oNrNZzqyRmit8g7kE5K7sIA3MsycrvabaThyPoIvF1WVlwNwNVKMBbAcA6/jwAF3LvTToRovfjzVj8J2Y0MCmJKJesFeNvlWlBT0YLYberYUguhJOoiJIhn4OcV8yhVGaNp7xWsA7TvQpnHX6wK/eVYnkCtVdRCODSyeic64bAgt/hSGRKIOITU0BssKldKHbx1rsc5+gMDC1YlkvdjILm4L2VVYVhkNdGztK7t+UeHndf9Enpc1H4xK1vELenKTIRepSDadd8Ho7Cn3eHvNPnNrVY/t9s60GjoMhgBinIpSqBJ7LusY8M2tBdhbXAPGR11cC/UN5x+rAmXlg2yH9ck3AwG2r0AR4Zs5ioYBNIiMqReraFKMzX4QE0WIS1a5kmyz0Hw+gyY8laDoCmrJAO3WlCm5A9yP3m8nm7HAw67ra4o9LANn5X6NayDn3h3nAcJAEJmIs5c0Aq880wzORuwA6fab6tTjV20nQCWt8kpM64OtapQkUgmk4Eeaw/ERM5liv3kyppdqfqO1n/Ul5mlGKwRTp/817OplH3MJF6V61xFUNTM/WnhdgFUVtsEWMwhKZ0lW+/4LtJo3DH9W6vkVMLIsD9jx9aoxOUFwTds+l68tI+M8NVFVLjtzMDvqy8nLzasEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVbcWpBcnGEqZn5lVj8ujBqcqg4SOOAAUTYcMUoTUmg0w/lyH3j/pvRATTAf?=
 =?us-ascii?Q?qcIskKe+Z0dxRCJseiU8+epZXTGOa0xbzplgwcpG4za0KVZONOD73KMuWOhh?=
 =?us-ascii?Q?mf0vKw32i+nyLrzRHgXyGUYWVjsZ9ksCHK17117GgOZOPt7KbuBp/BCN0Ci6?=
 =?us-ascii?Q?2sBnGuR/TQtK7bqpz6lwTB8FhKWOlN8uynNe9g8sPosx5d1DexvfPAzXyXF/?=
 =?us-ascii?Q?tLcsW84xPoYW+fB2mhW2WmgJCPnNCI8/Xcs7oGrPfMB+1UZG3nNE23NYN34G?=
 =?us-ascii?Q?0CWxd0JIGcYtdCyH3GnxMUL30YhhuCigToyfuh6ZEiv+ZFczCfn2rHmfmcni?=
 =?us-ascii?Q?JstnxR/8MwblNg/Bp1T3MtXrliCnDqZ8LvMOD6b4p7XQyKnTCZ7nDrGDGn05?=
 =?us-ascii?Q?vpSWzh/TTUpkKIuu+cwg5q5hOVl5S2Xp+ItStCR5hPU7lvjnYDHbpKtHE5G7?=
 =?us-ascii?Q?UO/l8lWrVtOtdy35YB3MQhf07XWo6oWsYEzPqtHp6ya98sia5LVhdWHvLBah?=
 =?us-ascii?Q?jnYNjSrpiV6eVVBJImaho/KKjlBdKkoCZ3irpcK6t364C73lSN9abuHr499y?=
 =?us-ascii?Q?tw5n+a6g+IEMkgWt0aHTf0r1zv0hfh0vgPK+b+bHw2GX9ZEDo9tG5V6JTqd0?=
 =?us-ascii?Q?lzTYxcuBKyreDRys2BRkrXuNdSIiXePzVnULyXmCDGDXq+oxUggzG48H4P6q?=
 =?us-ascii?Q?2cA1JH8CJIIDiywwr5jYnQ+1vMQPWvalc/qONNvsc0MHIloaooef+MO2RdVk?=
 =?us-ascii?Q?TRQlBFp3wkcJsfsU48SQ6yd62mIN0wzBUhx/8sa7oVAYBV3sH6G2+CbTDaLH?=
 =?us-ascii?Q?1uE6MflBX1qJlvTk2UWp2fgqOutN5pbKKLvrI2ClH2YMUf+/KfSO8XU7Clcj?=
 =?us-ascii?Q?shGUHKhjgMUsgqIQI7DnJB/kSyWNMo3O8hvME0edVec4/lvdkapr1a2o+Q4q?=
 =?us-ascii?Q?6m7Hb4qFK/GuvVqoPqp1iCzq97CoTAei6Xk4UwwBsYSZh2qxx/ID6V2BeOvF?=
 =?us-ascii?Q?UF/CxlHU1HLkuo5obZBfhzjrfi/lRzEU2mUBWvLq98X9TET9Uv1CmemMYZuq?=
 =?us-ascii?Q?zMUBoyJpK7uyDMmueKwSruWpzKre+hcTHPHwF49bo8A7DHxIjovtrxNmHrQC?=
 =?us-ascii?Q?mW6W+CLhf4yyjK6oq6WamCb35TdT5zqVjDPPs0LCw64d85izEJCrx6jkP4Lg?=
 =?us-ascii?Q?/yL/FAJFsLhe16UycvVRmfnYt6B/IGegKr4V28Z815gRGpLWSOSwJ6L6VnqJ?=
 =?us-ascii?Q?2HUUAMfijM4RRqzEUAnq720EIzNGN2XL06b2iWwM7YDE4qY1BPY4hYamYahZ?=
 =?us-ascii?Q?A/2X4aYt0a+zfg3FZMFWz6Q/ik7/iLBeKYlOO5bDDSND1WD5TcYnUPb7+s8U?=
 =?us-ascii?Q?px5x0zeS7KxHWB+w+VHpL6jRs91A5VIm5+A+9gP17HsVIdur/4qvOb9loP5V?=
 =?us-ascii?Q?7sTE60oWlo1fd68aYZ4rBX+xqJgoZbmDKzQX4QKrwaHWh/zwKEjqkT/uHRg6?=
 =?us-ascii?Q?Ku2MQgi1j6ZVQtdDrwGxn/9HnEQ/YIpsTbGq6gw9qsQvkPYtBYbt5YNvEVpb?=
 =?us-ascii?Q?QDLb756lNLMnpfLcWHHs276hmkO7Ec4S2nYlHuuA4VW8d8ev0MMinZOPmn6O?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c7ca85-a8e8-4def-a492-08daff9c5aca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:43.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiFUFAgpExc6rproRkhViHgtv62S0ffNZUMzMLkwkf+91VeRepR1yFg5Au9H1R9fSecHrSvCNwbb51ufpuKVwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mqprio_parse_opt() proudly has a comment:

	/* If hardware offload is requested we will leave it to the device
	 * to either populate the queue counts itself or to validate the
	 * provided queue counts.
	 */

Unfortunately some device drivers did not get this memo, and don't
validate the queue counts.

Introduce a tc capability, and make mqprio query it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v2: none

 include/net/pkt_sched.h |  4 +++
 net/sched/sch_mqprio.c  | 58 +++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6c5e64e0a0bb..02e3ccfbc7d1 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_caps {
+	bool validate_queue_counts:1;
+};
+
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 3579a64da06e..5fdceab82ea1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,14 +27,50 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+static int mqprio_validate_queue_counts(struct net_device *dev,
+					const struct tc_mqprio_qopt *qopt)
+{
+	int i, j;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		unsigned int last = qopt->offset[i] + qopt->count[i];
+
+		/* Verify the queue count is in tx range being equal to the
+		 * real_num_tx_queues indicates the last queue is in use.
+		 */
+		if (qopt->offset[i] >= dev->real_num_tx_queues ||
+		    !qopt->count[i] ||
+		    last > dev->real_num_tx_queues)
+			return -EINVAL;
+
+		/* Verify that the offset and counts do not overlap */
+		for (j = i + 1; j < qopt->num_tc; j++) {
+			if (last > qopt->offset[j])
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_caps caps;
 	int err, i;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
+	if (caps.validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
+	}
+
 	switch (priv->mode) {
 	case TC_MQPRIO_MODE_DCB:
 		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
@@ -104,7 +140,7 @@ static void mqprio_destroy(struct Qdisc *sch)
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 {
-	int i, j;
+	int i;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -131,25 +167,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
-			return -EINVAL;
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
-				return -EINVAL;
-		}
-	}
-
-	return 0;
+	return mqprio_validate_queue_counts(dev, qopt);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
-- 
2.34.1

