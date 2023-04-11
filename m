Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200586DE363
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDKSD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjDKSDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:03:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B13A72A0;
        Tue, 11 Apr 2023 11:02:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfVT2pkDNpVIsQBBngvkU2jiMUTXVEjOW6eb5TtwUgxjkD2RLxUODW/b9MgyR+a9A4d3qisPQ5zDt4gHgmNAeEjtbUVf+u0i58qi8/sEyFLXGTXkw52pUduZ/FgwVyCw1QWj4++C+kSTuVWAJSTq1JqxygBPFNXpEccfvSQ3WkXqeYJhwmsCp3Ns4FeTTpvMbgRjGXDyATVMhDxsQWhoC36ZaT57ROMllrd4zlwV9dKkRAUz5MuyFPT+0P6t76gkI7x14rCgdIVz80m8vMKJ7nK+yfJLJneoaMKaQK1KBYikXS8PpqYw/a14cIc4I+l/5B89c+fTBU1Iae0DaMx2lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ibzyDIzyxK8wkd+gwWQcZvSuqbjizmgAVPXOz8zkv8=;
 b=Y1pURlKLQrHL8MBn/SGuyc9cdQIfZicLQmJ9Qw51E7ni3HCWAgHqMOUsDIDg8PRYvuzpjtpqBKQNtVlDzuXmCCCXZS09w6JC9+46ow80O+XaM7BicGKD3FQg2Wom1dn4nVvwwUKe4k2AdBZSILo4YTv7jZkM5fmDjuVBsz511dknzFIcJLv/EDv3lLIf15Fri6RaRGCyvBw+4rFG2/5JhCyKeZYvyJ96NuGQhBJElJpj0DVh+2a8zZiva7fhqHPaOjNw8hCapfSi2m5IEEZhPzz+WEburZ72ojJQBxF2V7Yy7ZwooXzuLDXTjkzdxNEp749abdndL9IqeTNHkhEq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ibzyDIzyxK8wkd+gwWQcZvSuqbjizmgAVPXOz8zkv8=;
 b=Z5MigyqbUbjeOngZWDIVDZX0iuh3EQ3Mk/SX09R/ch6uG4NsgYmHSbnnL7KPUrbJg6ik6dh5ZXbt99TK59+uKnK5pQAMnGwcuY1grllSQTcth0DuTz1+9xjHu0YfzNGJX1yV3+IjcpgiupIWdBRgzUrY55DX+ERzTAsYVOeI9SM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:33 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 8/9] net: enetc: rename "mqprio" to "qopt"
Date:   Tue, 11 Apr 2023 21:01:56 +0300
Message-Id: <20230411180157.1850527-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 592095e7-a8e9-4e14-ba84-08db3ab6ecc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQOGhkdIsljEv4n0JuT/+gLpqHIvFxrIVbkk8s5Jrcigz5kODMAd4/doBItwC95Y/dj/EGL0l/g00x789KC7h0gtb/3OspqlQwe9XoDEmHA8q6r55qFOQ0VEZr+ppjCEm0WXRdKzNZGW67RoT4wlLzSgZA16A/IvVbjABrcWI4gWNJarQbTdP76GI70JZjXMrsyfS3GHDvae6oxpoU/JacB188RxbyM5kCIZWeZHIky1FwJWczKCav6oYqMmtAQJ2d3pPtpXYBJp3ZzyQk0zJAaHoFmL5s5MdeNStukcttnWCCUxgeNoiOVfL1A52kc9OCqbDFK3DM8VZTXcNRcZLs67eqwNZWlgh5F56pPktfiyRz3p8P/EcL5nyJ0tPcigrpCJRzykrfXBsHKoacj/t189nDtxyrIzY5GdS+A8RcSih+ySOg125qPL8qEdXkAei53y0dUsat1lvWHMH5LBhFz0V2JWHE4XMhgVbnooeWN5ZNQwlPyiwYGrq9RBriKj2eqteMhRZ755o95upgm0Z8OQVCDUYN85mQAFIuaMvmBV+fDB+XLSFiVmCnbx/+6p6erJJiqgk2W/htV1Zj1/9m67BdtKk/XZEdGEvufm+Xta3rrjWgUV8tJFBmSlGVdx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qA93SM5FvQsAMd5S/6R6nhgjqXxYxNIbmJ4evwURar+O3YONovDE5m8w7ClY?=
 =?us-ascii?Q?PEslWOsczo7tG8DCGGxRHJqG3dpetMRUnFjW69U9xwV45FaLhdEFEmcTyHjR?=
 =?us-ascii?Q?X9KXjBc0P1pQ11xCqJtJA0nrsFPj+4h+LafQ/RoxDmVG2EiOiRjip3lxEvlx?=
 =?us-ascii?Q?8S5t34SIDn6vRdyprrHDABgN+ErbraLoIhChHDuOz7WMl/ShNiYvCjrbPz4Q?=
 =?us-ascii?Q?dMEO4aALNjsYkiILhTx9fd8F4vAko8bb9y8xEDlXQ3tq3PP4ikHXmSSD4stP?=
 =?us-ascii?Q?je6T1GorSe+Kex/mWEZlmk/w0WHY/C9m3no5UtKqPiu/so0KDlw3oNn7yHEF?=
 =?us-ascii?Q?gArz+evUorA9CyWho54ptKE2QLVqsNSlK8/t/SiZRgJtCeoBe5gXhH3UvbQM?=
 =?us-ascii?Q?Do5g49bL3iTINhlM1OnWjCZPsH0if4LM+J+N/ii+VMNoJhG177dxCGqD3FXL?=
 =?us-ascii?Q?M5fCge6u3Fp34WaG9eineTi3hDR3+BeIv33WQ1MczTjfXtTrCItvRtTDSFYk?=
 =?us-ascii?Q?WFbj8I5XHBFr5Mmf+TqE/v0OTKfqywi19rZKQB2R00TUljQ+5vPUg8RX2B6C?=
 =?us-ascii?Q?isMEBCdcdHeSfHRJ895OKGU0diJjiu9dDARrzJVGRQb242mBPThKV9Q2mwQ+?=
 =?us-ascii?Q?mWg1PdG/3hF5F9E1mG8zeQlUesxVlpzF762AQi9o8UN8uFBYsX1iwfvUr6/u?=
 =?us-ascii?Q?mb8NeAdnM0pNbD2SqS/ksehULsxG3i9HGXb26YPfYpPtPNkCENBVf6r12lbC?=
 =?us-ascii?Q?5Fk74q5BtajR9CQSgyoC/0knC3nnSeR6ugFglA2g1+NUdsIhLRSASuP/kWRP?=
 =?us-ascii?Q?9UAVQgVcj2cc0VwQUs/cuEcRZqqNJ3RZLCtC0rBmQkoa6SNsR/V1lI7hPbB0?=
 =?us-ascii?Q?xNMFOS3LXN1AJtMBZymdkGb68cfd0VPIUl+QSuLjfXpAXurnXgVwG2IeLSoM?=
 =?us-ascii?Q?vxxcytrmaY1RG/RszNo1ONecE43BzkkF3bvqp4OiG4nmQzVuQ1HtpRpXquLb?=
 =?us-ascii?Q?zSsYy8r83m86V5W+YCNR5ZJOpAjl5Z9+scfRfKkIdLWTchehdwNe6aijtzdb?=
 =?us-ascii?Q?2L387XaGuCezhGS6JrUcunZtqUqA78sWPUGDHzSNVCNWK3vPfF8geIQ0s0Co?=
 =?us-ascii?Q?fuPu9S67Lm8tb0J9iIQsOp/IUGDcw8wnLmLLtrhzS7gZYuE6/xYGPD8SqLUD?=
 =?us-ascii?Q?94Ap4IRemYJXMlH+YiQsASoljv5eQlKjWDYCsxW13Ng2cl3wCt6KDETXOOMi?=
 =?us-ascii?Q?Al90Y4ZpaiH4P1cKDqQrIvygCUdDvgDAQPpmgNA6trhIB5ybFKRqwCQ5NUJ2?=
 =?us-ascii?Q?Wr1rgF4JJg2M6MqfZilR4e8geCkrRjCnVHjb9eRGU4tYCTYtW3iL0qDJOw6+?=
 =?us-ascii?Q?GkR8izJA/qOJBS+t2Bphcp39Iidurm4L1n3agfS627s95/8QaLwdS7a8fADy?=
 =?us-ascii?Q?Kmi8SBV/hMN1tlZVfffuPXw6KdrSlWpzXVLMtAAXTMcBZZ0ynu85moG6eNr7?=
 =?us-ascii?Q?Cv//gxjgKQxgkEDKLyk55deP0mi4qCQjdDjOyIquG5eFE0CWWgr3y3QYSaGy?=
 =?us-ascii?Q?vbBOQFXhyYbEFYk1eSal6Vsp2TGN4+Q5ObUNjsp5T/hL+n5TviGAWMNWLtvd?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592095e7-a8e9-4e14-ba84-08db3ab6ecc6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:33.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1py0PjVnpJF5+EvZ9yDGFrTaYsjnZRIO/s6P5l7TNSuDKCk+DMyXB+UlGJZNQhLy/u91Vo3wgMy3hk1g3Ipw4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To gain access to the larger encapsulating structure which has the type
tc_mqprio_qopt_offload, rename just the "qopt" field as "qopt".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v5: none

 drivers/net/ethernet/freescale/enetc/enetc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 2fc712b24d12..e0207b01ddd6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2644,12 +2644,13 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
+	struct tc_mqprio_qopt_offload *mqprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
 	struct enetc_hw *hw = &priv->si->hw;
 	int num_stack_tx_queues = 0;
-	u8 num_tc = mqprio->num_tc;
 	struct enetc_bdr *tx_ring;
+	u8 num_tc = qopt->num_tc;
 	int offset, count;
 	int err, tc, q;
 
@@ -2663,8 +2664,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return err;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		offset = mqprio->offset[tc];
-		count = mqprio->count[tc];
+		offset = qopt->offset[tc];
+		count = qopt->count[tc];
 		num_stack_tx_queues += count;
 
 		err = netdev_set_tc_queue(ndev, tc, count, offset);
-- 
2.34.1

