Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C270C67DA9E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjA0ASl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjA0AS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:27 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF515559
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/nFXpL6ZuuAg87U2fxxPh5yfbEHdPJDHF51/IWylLZPNxRjWeQhtnX64a4K9jc4PdxJ/5Ac7nE3ohf6ae2ciilpurbsz5h2/HNV7gyjEhXwHv6Ac+sGlYDFbb/rtcXyPYVmBVz7fNZ0k08xebhLqYKeuZTTKMw8vykOZ0OQ8IwN/uvZZvoe13PmEuPoa+DK8wqiL2MIbt+lGXWqM6ZY/53+V0nJ+LmP8dkdAt9Uv8rdF6bkp8GsG83vMcMoYTssnkjQybzOiozVXnKFjo+JUYwOlIDmWdSk+cBgQRNEcTJ4IzfpTjb/m+MdCkyUlJ+Zvo5orygc3pGf1t274wkeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lclt4dXSUrpKuUcYkd+5UqyN977OdkBTfuhmDT898R8=;
 b=gdV+zE//1xehnaMiI85o+faFos4h3CnaITCfPVGCpsgRjy/E1Rm4/pIDx+gEtAr8tde+5VSTYP0RjeyZ7t3kSjGoaWhYx8feApDJyFMuD+iF7c6nBLJ98zjKYnhTSAs02cUBGEnAl+NODAK6K99kA5g5wHEG0TR0cs/uEIVuHaad4A04b86gKB4ByKwpQlLeAGnOSPMcubRpXxrIrb9j23s0isD7xA6ofRZq5yzbN0QKDBC0bGJ+dwuVHH5UeAB/th1WazNVCtQ+xPww8ordoo53z2FTALSbjAO410wLUM2diOWsax2DHxWslcHMu3dRFPdhnj4zcdlM8tM6UKCrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lclt4dXSUrpKuUcYkd+5UqyN977OdkBTfuhmDT898R8=;
 b=HORJeOZ8wdZcllISFF3icN6yD057uzbd845O2pxV2qOhtX8QaLxazORJJ1fuQ/+gJaD8mVBF+zxw/OPa9xvb1hzk7PXt5ek46vwGGgFHnrDLklnclo/N4k3A90onDEm0S6USk6QyCmr8OQhsBlhPggO6PIq/0UZwaufuMIYDp4M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:09 +0000
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
Subject: [PATCH v3 net-next 12/15] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Fri, 27 Jan 2023 02:15:13 +0200
Message-Id: <20230127001516.592984-13-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: b53ddd24-9c81-44bc-b3a0-08dafffbb0d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyIiIja6XNy3uMX1STmVO1mM+RNSSlSjfSZY20Tr9fxXpTiHwx+d4TFzxQXrvC8+ONQEIbEgUnLjx8UkI48DvDyrJWlAJocgZtALDdOvApG5wN02Mwpx/OGmt+vJX94T9igt7d2FP5w53SZcs2k9UZEoSsKwSf1x5pzechCrJ0qBor6lrrsDA+yEZswe68F8IlAGUWjaToGI5h+6Lh+YTCmjessUnpSqyYEOPosr70E9fK7EszITVO88x66dJQUsExm19d0Hk6xUZYCRkaaNokwUeDMr6ZqdvXQAJSBgr9n5SOxoHUWjEt4izIK7O+gARh9Qi9/0SanB2l9cfafHSzHS38UtHu18akwjLxe1GlQ3z0y2q60eoHYuWGSwYwCQmqatm87WfBQOu3T0/ZHZVXbnm6MlvDSUNNtsMPrJDZJGrsBv0mVU5xbd47LhMm4d9nEL9olSbKboMTo7n/xVKSzIW+kMdtkhwr1HQqpjr3HlN+M+m2TwnEQkz87xPahqZqUti57nGTI2zG4bbOfGsbC6d9tEdGuGmXObjMcsBgOKd4Ko8Z8x3gkSLJRqEdB85cjGc2kmPFg1hJ53UJiUaaf6xxjHgsaeRxb7PLx1DYnYs4AzAsi7e4MYUOYUmTm0sLKmCV0bW7V5QOTeKr4pVZE4xC/dvaN3YWUiJsdpR7JRgbmeciCessUMOS3ctC7cMQFrQ2kNS0O8hdYNmuPUOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PavGmpb+nY1m1/ZVyS0yGDCmxP3pWy/WoVuGBoC++TvlInNll/srw+RaqT7D?=
 =?us-ascii?Q?NYcCLXwcdecMQArBskHqnw1OGAnT0ZD+XqLELhUmMWqk88QuZJxZ5AGVnMu0?=
 =?us-ascii?Q?mfS31786OqEtGpZsjp3goWhYzCBDlGL7QW1KW1YB+NLyCrHCmObqsaSOGcqd?=
 =?us-ascii?Q?xDHu8CewqikABTXiFsRx9NapMla3CpWSnsLKVHb4iDYvxrUncm0m6OIR4hr9?=
 =?us-ascii?Q?5GoqxF4DpxnCHWtTBMaXh1XEjVxuFOv9vnYLJXX+9ekI3/01SZEcginu7ApB?=
 =?us-ascii?Q?5XgLAywZuwxNgtunjw8K6tLJIAGvkoYVsCfltzikQcoEeKExfldAY3t7kici?=
 =?us-ascii?Q?8+LDtFDlbHEkHwlvJGjKmT8N42DS/QTBFM98LahTnq0KLnOSUql8ChEWSq7K?=
 =?us-ascii?Q?HtFrr5bJ2N5NpsU5NZLIS7Y66ld7BkJAUabz1OosZlG3ixUfT0GBjIP4b0oo?=
 =?us-ascii?Q?45/U9kxSAHpXALg+IMgj2MsWDQ4RHbaXoPH+3BV0d/ZKNbCZX57CvkvXoxeX?=
 =?us-ascii?Q?QO+bRMuhA3UpUgD/Mj+j9GIMZZDmFYVo5R2vMnayKbE874qipKuU60jCcjem?=
 =?us-ascii?Q?W9EseNFIoYHtMWNhPpj93MN6w6ntfUlnfJfGeBg7GSz+xMCooLkzfodMH7T9?=
 =?us-ascii?Q?EheNCz8Ztk3Px2DCgwHU2JIgXsrHoA0fC6RF0VwHaBK97BUkP80zCH+uA6Dd?=
 =?us-ascii?Q?4EgDezBUW9k+Y926TRyleCmucccX/7OaFx8wgvWc3xnNrEL4A4FVps5awGhY?=
 =?us-ascii?Q?JBfgUlB6vbmW+GG7CKhJ4baf3WtGUAytIABCrO6dzsz2z20R5MpgEDtJZvQY?=
 =?us-ascii?Q?LZJ9Qrp4O0w2kossEz5o4DcF9c1kgaZSMZWYCPuMOMhJWuCm186lc89+cyFe?=
 =?us-ascii?Q?v5YlkiJ8oW940mUpLr/sEvDfgvw0BcgmEsHYxVdDrP1w7wKIgTuH6NYfXkwE?=
 =?us-ascii?Q?sjOgVLK/C70xXxEYhDGYMvu5avpcpqVtBfRtB0bgmJq+vkygLp50UYwFocUx?=
 =?us-ascii?Q?FU0Nsat6FBnPro4ReOcw7OSf1zBOz5buqaisU9UCxCf6QwLMKqiDw08hZZ62?=
 =?us-ascii?Q?fzuuTptGLc7dWuee27xy2Pchzhr0ZsZ7NXlXIrB7VWOh3KIxUbychIwSDdzU?=
 =?us-ascii?Q?ekF7j7n5vganZTA8Jg0pRYpRPB/tzL5YLwpVWTYbaJ/zh+cIu9Z1SwYJ+qMc?=
 =?us-ascii?Q?SG3Rvm8pvhmNUhNKaC191qKO1y6FxsuCWgXzUQ7INy5NYN4XARnjPTzif45c?=
 =?us-ascii?Q?uANFX+vBwcyxvKDVAHvlmtYvmY0/j+CO7Dvrd4jzTm20AD3w2aFA1tuWbXef?=
 =?us-ascii?Q?jVfxfUsNlVZ0BMPdXh8yG2i1Lyz6MGckcrysx41IC0CepODbBDVaydQz1/xk?=
 =?us-ascii?Q?EeEtFR3mdE5d+P2L8WfHZ/XA4dLbhpaEYkoy7NrM8WFbwAnE7uba0HzhlBOr?=
 =?us-ascii?Q?ALFLitGev2L+j9bCG89AYbeoUWI94BLxYxvQOrW898IjZ8x3M9Y/tdtSV+Zc?=
 =?us-ascii?Q?yrMKYqVcyLqkunqgk0Bi5fF3XsORENTsGAj7HdU/uaRmW08hNkHhubS4/bg+?=
 =?us-ascii?Q?L29dg3Jv1H8TWIj9IHPk39qa0LIbq0PuwDAyzMBB64A+SYZhvCVsxnCBm1NI?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53ddd24-9c81-44bc-b3a0-08dafffbb0d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:09.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9qOGiVpxkcVVtzOfspirAI3ca4xyaT5tvNHXgnzuO9wyON3y8gpps7pqTS887caJDWpfE/m5sXd+4HkptiJRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio offload does not currently pass the mqprio queue configuration
down to the offloading device driver. So the driver cannot act upon the
TXQ counts/offsets per TC, or upon the prio->tc map. It was probably
assumed that the driver only wants to offload num_tc (see
TC_MQPRIO_HW_OFFLOAD_TCS), which it can get from netdev_get_num_tc(),
but there's clearly more to the mqprio configuration than that.

To remedy that, we need to actually reconstruct a struct
tc_mqprio_qopt_offload to pass as part of the tc_taprio_qopt_offload.
The problem is that taprio doesn't keep a persistent reference to the
mqprio queue structure in its own struct taprio_sched, instead it just
applies the contents of that to the netdev state (prio:tc map, per-TC
TXQ counts and offsets, num_tc etc). Maybe it's easier to understand
why, when we look at the size of struct tc_mqprio_qopt_offload: 352
bytes on arm64. Keeping such a large structure would throw off the
memory accesses in struct taprio_sched no matter where we put it.
So we prefer to dynamically reconstruct the mqprio offload structure
based on netdev information, rather than saving a copy of it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: reconstruct the mqprio queue configuration structure

 include/net/pkt_sched.h |  1 +
 net/sched/sch_taprio.c  | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 02e3ccfbc7d1..ace8be520fb0 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -187,6 +187,7 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
+	struct tc_mqprio_qopt_offload mqprio;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9a11a499ea2d..6533200c5962 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1225,6 +1225,25 @@ static void taprio_sched_to_offload(struct net_device *dev,
 	offload->num_entries = i;
 }
 
+static void
+taprio_mqprio_qopt_reconstruct(struct net_device *dev,
+			       struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
+	int num_tc = netdev_get_num_tc(dev);
+	int tc, prio;
+
+	qopt->num_tc = num_tc;
+
+	for (prio = 0; prio <= TC_BITMASK; prio++)
+		qopt->prio_tc_map[prio] = netdev_get_prio_tc_map(dev, prio);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		qopt->count[tc] = dev->tc_to_txq[tc].count;
+		qopt->offset[tc] = dev->tc_to_txq[tc].offset;
+	}
+}
+
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
@@ -1261,6 +1280,7 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	taprio_mqprio_qopt_reconstruct(dev, &offload->mqprio);
 	taprio_sched_to_offload(dev, sched, offload);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
-- 
2.34.1

