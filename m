Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D56756D6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjATOTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjATOTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:19:02 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2056.outbound.protection.outlook.com [40.107.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1714FC20
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:18:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dfnwebsc8j6PktRO6o4uEl6sXCz7Dr7fw0RWm1/adhjILt6VZMi/gYy5Yvj5DLPgn+TxssqIRX8wzXbOL21xvewaXGsTAM89OI4jGigqpu6HQQeR+sO37FBQfFFKzZvFyIx9aZcK584YEebXB35QWXvjkCoLr2rT9mhyQi7J/sfIFuVFsfp7FRgHiHLLfQyBg5XtyeEyuUJvFewacFyCVKOwnVw5lbUzmN0MAHstjzbiERKVjcq64cMlxpXpjsLy/FS7stPwBKmsCNtPoFbeawy7waO252WH0p2dVX7nWM+Nshn3ZDPc0y5U8hZ+ODEQ8+fnSfaSdFb+MC62GiFfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8swCsT6oWpsX5AiMEscNsDdLiImplPEVzUZxLe5Mx4=;
 b=BYTaF5/o9eGigC+9jGA2ithK8bfIqn2luTRTm3N1xP6pBNqgbgNePdsN+/7eNiAScGq+fAHnX1kINLvCLTOn0mGbsxnhBUHm1efTDjyUVHKs1fu8e3uUjQNlUXWrgZAZFwoGmkPneEba5nCKlBvzYfRRDMLZ/AaG0zclqHqc5jjDRn+elHhrsLxnt+9140ucmi6eqMm2BkUdnL0UvUBwA0K7KLd1v6JSA9SCnjmsCsMqq0YiNX4qOEjuCKcVhDlnIYa7dsfdyKlyYstqiya4qu1FokfCee8uZI536EqgqQHe42cKa7v61yRX7LCkYJdNoAvUYLa5+OBWWvOE1JOWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8swCsT6oWpsX5AiMEscNsDdLiImplPEVzUZxLe5Mx4=;
 b=WiiSn25KkCqF7vMbF5MSlckWKcVD6+zc7sLob5rIYsY/Yu2TekqsajPJj1x3/gCsRZhwehVj9A6i1CL1QcodV4HCYELU/RVK7m+BO7l+i+9z7coanxIYn4FN1fjC5zankpkzSH3xVwUpHwt0yMerbgfbOFkM39eWFEaH+qGjcxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:55 +0000
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
Subject: [RFC PATCH net-next 03/11] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Fri, 20 Jan 2023 16:15:29 +0200
Message-Id: <20230120141537.1350744-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ebd93946-dfbf-46f8-5d75-08dafaf0d7e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjmyFkfD+zjhdHhIJvWkYKheUZQml8C+mMF7UM06Cal78ec6DbCi+ubRYXKtgfL7i2CEvtTSia+b8ZgWmHCScu/fsBTdD38qNmXzVras2o8JMbNdppDzxIsm+IWjQaBJhXJY9Hbzyd0B669wj8cq26Z2E7q7TEq5lFGmSPEYI3Qxi/UE/vgRyGXZX2WmZyT790eyCTdn/jZ87zwx7sDSGrXsX0XyTsaa/K9s62FKT99nawOq5dpwcUlNmn5fg2xVPKwXo+u8nWdpYgPlk3G8PsjYDeWvm8paim7khcgBH7voZGhKvnc0DWnxTHRGZHCPWiLdDJhOgBaA2ZBvSNRxgvruP62VtS1eQoLDmS7/KLvb2nHFR/UeluJFsGhfoOKB8HhxihgLxQuqERo5Ej9xqCGw+S9b4rdgyHuQQQDQLpNemNA5pknQNL6OgrvVKLq/7kDddGD6zHSFmIj0M1hWKZOZnDfmSuQrXG2vfoYJZc93vb0o8kH6+HisNWeE2KGmRyh8EVl+wqMiVLCt/ZzdMpFvtoyEMpRrisBUxJ9YK40jO/tuY969YJmHS7XQ71NXTZHhlsu/okubmsMupxyznbAGRD6zNoR4BUiKFktzZRC7luBg0/NDWGsvJFZ4Tvfo85b3pB+zNF8DBbrOdzJKw9YfGaNJBDlrLC7KypxlYVR0eCY0+gVoHt5m2c6CkMeJdCxXcGOT8+Jom7w4YHAzvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kVUFJdgFEbAkbjRiAfnO8RkirvdIOu4rVfHmRiVzuWAEC+u1HMtAH2IQ0gKf?=
 =?us-ascii?Q?mvIpBX4lZHoaxWHv82VmGeYQncSlASL+01cy7/fV748KMuQoPZGEYgwe1ZmO?=
 =?us-ascii?Q?7mLEEHJftmW2Lm0sTGJiCk5VnCpOyXoOrEb0zO+11hK3TYByUGY3JZYvSf4z?=
 =?us-ascii?Q?GXcCWcLUirLQrScZEzQk/b0MukJ8JxBFO0x5ZSrbDMll4jQvSkATAyaHvypQ?=
 =?us-ascii?Q?pSYqqE9Wfpybp5bkO2N7cVbM6gVRJcKvqLhOOIzH3rezCG0USZsec2EWZB4D?=
 =?us-ascii?Q?76sF6KYgIgNg+qIrtEMc9kJcST6sNiUrPdgPD3J6u9pTRNP5JQ44fBLmwYxg?=
 =?us-ascii?Q?KZSw7sn/IdoFLOZy43s1vWqouWrEACNFmGLbOqo2IHeU2uzoxYpaQHuau1Uk?=
 =?us-ascii?Q?+J/9cQa8EQDwN89d+qUE3OS3sW5sAQIt6wasRLPao44SVHfcJA0ElehkZnVG?=
 =?us-ascii?Q?ed+JCFjkfsW05YvXUNo95yImK3TAzAACK2fgnfPeeuK2e0sFiLntyqIZ8BgP?=
 =?us-ascii?Q?OjDkan8+2d6K8eYcoYR1kiG/PgPY0c+lYfFju5H0WDdKldJhtG5OygKtLZpc?=
 =?us-ascii?Q?VIjWGNgeeJjg8VPyHc+3D/GkIziazxhV/3z7p3fu8nFwKIwEKvoK2YkgR1db?=
 =?us-ascii?Q?XP7Cm0gXVjO/LutkThoAlQFF5ikiUDEWUm88god1raTIFWtP+THt/83S/aHF?=
 =?us-ascii?Q?C476Bz134Vs012gBAVDfYV8sXzmMxLNXDAcvJttRDBdQY0B8+t4kKcvUdWpM?=
 =?us-ascii?Q?W3wmpXFRSXN2fkTzDuKKPihdJYUKObn4NPiVJpwDQwfzCDhxtnfpcF7egWeS?=
 =?us-ascii?Q?+ba93ys3vqIFscYdvfyVcedXobL2FnN74Wzcl1cVVDQgcqy6uKSW+jQgaeP6?=
 =?us-ascii?Q?d5Nop1eHERjMM6blRbhiyxIeYjpIGghdu4qRg22zyXeSjKfbyiaKd+GsKqla?=
 =?us-ascii?Q?tX0HEjTkDHYe/Ea7yYRPTKQkwepCsDyO6IPy2JtnA+yqqw8TrLhklYVix7vl?=
 =?us-ascii?Q?1zzIt4LeBbfaiWmLyXwADcXXVwA/uIAQUoqT9cTLdyyfauxsPBgQN5D8hB4D?=
 =?us-ascii?Q?WBR5wlRsR9OlqQ5HwocWf1r/hMTkEmHd/szsTEWa+Bur+M9j0rANUTM81WRX?=
 =?us-ascii?Q?2pKtkkLRufnt3C0vYdiHnhAbva7k6yEryr67WjKQcfIiIwPQ2nX8uK9u9Kim?=
 =?us-ascii?Q?tNTkqsD2XU5P9EOtBNYYCeRFKJjSm01ynSLM+tu0EdEVQwWPdpIFTu87IP7J?=
 =?us-ascii?Q?LdiKiWsv1NoHQ4X6s70+Qtgc76RhYxMCh4HwOmLzOcgQL1yjnEOO2SHWyLQt?=
 =?us-ascii?Q?LJTrgDG8xvBSlChXzIZeWE4kPtDKvjHvKRw0fU4LEe65l3yynNFEXqW9p9TW?=
 =?us-ascii?Q?5c07xWm3oiB5TRUvnJk0/wj1tNJULncpBLOWDtGdeSfhUdnYHTWnMCYkam1F?=
 =?us-ascii?Q?bSs7RGESexpHKzBaT81i5TgGGTHe7a/hb25nhFkxZkgua2nlQwy9Q602w05z?=
 =?us-ascii?Q?o2p0cesv0La4V0Iqev62GKS3VuHDoDK9LRckAuj2Fr/c24S7IEmvWodgg/xw?=
 =?us-ascii?Q?PZTLJcW1Hipk8gLn28J4VGC4yfAVvRSE3eTRb91DQ+P1jGfglkUJVd3jw4cy?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd93946-dfbf-46f8-5d75-08dafaf0d7e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:54.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8mAZ984QPdN5AaMCjgZIBrJcqqwH9/CYchPsnnoGbh3LWbkTyKunkgYhgjoTx8bilygadupVeAqQrzpJ0IxPA==
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

Since taprio is a scheduler and not a classifier, move its offload
structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_cls.h   | 10 ----------
 include/net/pkt_sched.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..cd410a87517b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -788,16 +788,6 @@ struct tc_cls_bpf_offload {
 	bool exts_integrated;
 };
 
-struct tc_mqprio_qopt_offload {
-	/* struct tc_mqprio_qopt must always be the first element */
-	struct tc_mqprio_qopt qopt;
-	u16 mode;
-	u16 shaper;
-	u32 flags;
-	u64 min_rate[TC_QOPT_MAX_QUEUE];
-	u64 max_rate[TC_QOPT_MAX_QUEUE];
-};
-
 /* This structure holds cookie structure that is passed from user
  * to the kernel for actions and classifiers
  */
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 38207873eda6..6c5e64e0a0bb 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,16 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_qopt_offload {
+	/* struct tc_mqprio_qopt must always be the first element */
+	struct tc_mqprio_qopt qopt;
+	u16 mode;
+	u16 shaper;
+	u32 flags;
+	u64 min_rate[TC_QOPT_MAX_QUEUE];
+	u64 max_rate[TC_QOPT_MAX_QUEUE];
+};
+
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
 };
-- 
2.34.1

