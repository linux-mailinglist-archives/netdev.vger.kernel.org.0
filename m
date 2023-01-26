Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F79E67CB57
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbjAZMyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbjAZMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:02 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E256C560
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6OtdbILEv1UM0/d49rU7zyRX4zt2uHJog+4LGuXBtpJf5LPKcO2Gu/C75u0JIRCgDaAttWBXBAfrOc0taTK70eGr6YjSoTUKWjW6MtDYaO53Wiriv+tYDNBkpNejdctB+klAIpAiyB09vYd8JDqm2MXcLixf0Xh4/PbFaqmSc7UeT+pUd4BwQuCBHBUbFn5vMRb6JXfsdQaX324uRQHEoZ+9E2WS6zsRFLW1/57f7jqb1trufc8eZ8Z3HZ+3kHxhVXVyOzoZu6USSqJWZviWn/Q8PTINqaoYh3n2qCMv1MHkY41N0w0DQjQFeQ38WXr1x80lN0eh0NkeBxfZjuIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CaD5XlntFq9WMomqPylglYJL/ySGkYGfYJrW9UxT+cc=;
 b=fWuhkSewBDkjC0yblN8dK+oUr0pF8JtQFmZTHiFE/whtKR88VZ79IqPBh8vezsfF4cOa5JEDjFbQL0C16Sz/1r1kZyatqJEIxyxtv84w5dYIoiuwqTixomqkh/SX0N2OKvfCPjQDqie6mbgj/FhIOdlEyfz3AIQlCyue9sL+EwNqARUyXX07VQmbGNBOlOM89aCF/2yZZzZmzk6YointhArvQlC96yZSQ8Ip/DN2A+4iuDvNgdHGSCjjhwcOA1m1v0LpaGdaNq3/Jr4kpRzC/bgppK54IS1jVmZHjVZ+fCdRsaxSHXypfGWaQUY150EGcH1F3Qg3PnciD3xWh9qT7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CaD5XlntFq9WMomqPylglYJL/ySGkYGfYJrW9UxT+cc=;
 b=OAbviCI7C+mnCmARu6OFMc9yxpTr+XSamXLbxgHqAhGi3Xjrod3juOvb0VKGUrOoPUzRnCesiNOMVrn9G2P30BYBRPr3T4aYvg/vjj3frQoX3tWII0AIpX6IF/PvHY6sGS6QJczMBQ9oMU/bM+dx6TRLPp8Sc81Ix4pfmRVcKec=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 12:53:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:47 +0000
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
Subject: [PATCH v2 net-next 12/15] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Thu, 26 Jan 2023 14:53:05 +0200
Message-Id: <20230126125308.1199404-13-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2d0991b4-aa28-4103-e31c-08daff9c5cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwSO6xOEhthe8MmPBq9hMpJrnL1H1z5secwEeTxvB2xPbas1wCJPnzwK44GQR898qA765jLCHcKEQh8VN/su3WIAUYSmUpGtNHrfUIG4ED5BynfIFUUVNrHkXsftviOwdLKTJdek4fYAlR0w1wxyE2QFg959XeiHVyt/WN8SXhktoKDPXR4JpnaatHoR1lTqzObgqlNqZt51UE40mc51hSPDe9x+juAC2Jvt5gJIGw2NounXLc3YEiEY1FMNOpjRorDMIChhqZGkH+3wg5/HuXUzmdhnDyrJDw/DFZy/trJnSHEH6LnEwU9X/5QfrDqgBH5KYUXwZhEKDDge0zYzVskJ/ohvYeGvBZbQ78NltplvWfyqhZRJIxdlbIw6oHGUQOZOyoOsbinMR5LHJvRmOzwBbh1veE2dAsop4dwwRCI/k6yhNDNn1OgF1zcqS9uxGSmlHQ2XvOv65DDvn/YzekxF+3WAb4gglNLTIpn8yCTcFaFkhEItwztzoLMHE1B5O5Qx4tiPpfXTSakz0Q/+0elU3xcSejql4gqo/M9AolbIofVICIeBQaEu7oo3xMiEM6LT8BnwjaY5IzR0WA6b8s6Y2ekzmukzMyvND+l6C76oJQ8swnStv7h0YfNg7bCPsUNQ1SJqYc3jayljtSRdd+34ox/B+oXPrTZa+QCjc9R2wxLfJNdjUqxF+1xmgjs1CD5epkmtm9pb4xEGCHU75A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(2906002)(41300700001)(86362001)(6506007)(8936002)(4326008)(44832011)(6666004)(316002)(186003)(6512007)(66476007)(66556008)(8676002)(2616005)(478600001)(54906003)(6916009)(36756003)(66946007)(6486002)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wtTHi4CBXXomPNvgyaR+F1a9D7wMAZ+hcaiBagh086SiADSv4J2OVAdy7uj?=
 =?us-ascii?Q?Gx4CFGM7WX8MuWdcIs0uFH7Txh2LwWP1hJDS2Pvx5/lYefBnlFUJxkbwCWVQ?=
 =?us-ascii?Q?EeNZqlwzpbwVBIYASA+GlRv8iETyCCXtPAI6FL0bjXn7QfRKKpudlExRxcqc?=
 =?us-ascii?Q?JgIZi5hL1iJa4lVrw+443IK2WAokmLYxLWv7r/KLffUO008sZQYceM2H5eVS?=
 =?us-ascii?Q?y0Bl1csnaMDXkgCFRx7xq27ROXfTKzkGAz3TfcWh9bu/CJQoAb/rQn3dVamD?=
 =?us-ascii?Q?+f+f7BdsDt9sYXEFvd5tRJ4D1tTQRH66ABbB3E9Ik4fEmxj3tamBX7xIe8eN?=
 =?us-ascii?Q?nXGPdDi87xNmFBYCtyL6ssFtEABRumhAviv79yuWDlmVT7F8iiaiYlGQl52N?=
 =?us-ascii?Q?zshIoRgbEshnNGK6gk8KDNVFmsYlnewQdK8jR6PE3i6fKwEAsRFskqMaCIsP?=
 =?us-ascii?Q?AE5iByoyfZtpV64mm5rXgmi3F/Gg1oUCsCGjEzANz1tqUkj2Tys9VvXSkkil?=
 =?us-ascii?Q?3TzDaN0ZipVR6euBoAvafx266NxpXRQAWHKWO3SSh/5VFIwCLVJ01j5tbJP9?=
 =?us-ascii?Q?pXrPwSytIcdvUdyAqTZauXDGl442FtDbiZdUyRSTumTlwR9Uvh81Sw1Q/rg5?=
 =?us-ascii?Q?FsZ6JET4BkbRYCLThFl9+WhX3AB9icKQEr9j4OSKkCeL0miQCX4DsjP/WX/a?=
 =?us-ascii?Q?RcgVEOmaZp49N/sy18hK7PJkT0NFsffnuP1tS2c2rh3UvCLq873uE+R8ijp7?=
 =?us-ascii?Q?3Scxc+Ru21CEHH9saWQTb49v7DrnddXja3OYa5EpHtbrBn4kHJpCB8MoSBGV?=
 =?us-ascii?Q?janiiGMNTi2y3RJ9hSgK3uS+gg5mH8LsSZUEcwUE0Nw1/v8+SWIT4gV7ZZoD?=
 =?us-ascii?Q?IldK3AsbUa2pD2t7lhyX7QvASFdekW/C84fbH9Vb1/mXM+bepCRnnZxqQOWT?=
 =?us-ascii?Q?jciKLS8YjR9l9x94oxP65ARzGXTmBgTqJmbjohyqN4TZ4FGHa6qqC1VOW0no?=
 =?us-ascii?Q?IRQl7QW0otSmyDm07WxBkA0rbADeV/OKqrAurt80m9ToQBp9HC/98yWyGtZJ?=
 =?us-ascii?Q?V8tzCjE9j2SbWqq8EmlQZn2w5f9Fs5u7OwXAnF6HRW38/ReqI/pXnQ9JpEiN?=
 =?us-ascii?Q?v2rPxRgqifz44s1k38h3EYe6WG1zERpJ73tcZifZmVrAvPsWaXMYv/FYcPgQ?=
 =?us-ascii?Q?0kHULw1/got3G0J6DOTeEmVeutChRuquQZ+AQhXYoOovMeH083B2yU/MzwRI?=
 =?us-ascii?Q?1s2Ml41zrAqBo6tU7ClzFkHBLeq8/ba4bcmnlbG1dtjgabmSExnQBU1YAGPk?=
 =?us-ascii?Q?Mu0L4e/hqFqnpPeVxYGxWhlOKiQ/MBrRewJ/3NIK031C+kwN9pjSTYeM6m7Y?=
 =?us-ascii?Q?SfXr9nAaFt9Sn4vuIxyWA7cRbgm6AK6rVkPpMxDVZunDDGPUxTnvdv3+Z5+z?=
 =?us-ascii?Q?7guMd9R4BloeNwJtcfX0UhaTz2HtjIGB5ZsMeayudQoVO8LVM6IhypbKhqy4?=
 =?us-ascii?Q?IfEqizN/0vOv8FlFHR5pj2rp2IPsNkqkCx6KxjLh4v6oywZdTpZXsHBynGG7?=
 =?us-ascii?Q?861FV8z8Axz1M9wFIcF8pndgDgOktFG/xdMgIcDLkqmECE3wCBvS2vXN394W?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0991b4-aa28-4103-e31c-08daff9c5cfa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:46.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vgH20OHRjxbNsPY5DFIOFN+KOQ8YqiACnNLKYiFXung9nHTGEfjzc6vR20dY0LwnPN+rCYolYJM/KyCqdF+tg==
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

