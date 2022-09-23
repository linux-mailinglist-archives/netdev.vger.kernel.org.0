Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C565E847A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiIWVAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiIWVAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:45 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94D10C7A5;
        Fri, 23 Sep 2022 14:00:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pc76mq6wxrjq1TVabhZIgN8tq5oHukTtTPCTevg0NeBddylRiMrosF6vYYBhH+tNGXStn9G6hvCqB44pbcbax4L3nDnmNaXV0mDY/Vjy2fksz/GGOUSiGRYwWxXp1EQxPRq6naWERQNb2fThrJ0mT8e6Uryxvrb+MB8wLqcNr45x39kXK/E23LQvipsEi+9zVsh2K2saD2LAzyNado/zDTcYTHBCSTkHX5H/+iO5NtSjcrouOyiIKosxTH6LhQ0zE0Lud82oyKsSdeWBJTAMBVLuJYha1Vq1XFat1oHyfSRMuY0cHHzKdmL33P6upBwsgL27gpZJAcyM6TSxZrBAuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPuEfu4WbWZUtTMVfcpd+QsyVC8RCcxoIjYJCJThDPw=;
 b=L6TiZfxwBi3YoGHFbKhKfk/ITbH0It6f6Smggmc/memv7v5I9unpC0ZEj0n9J7b9HV4ObJONzX0thdkyPWlJXLhDChpSweGZ8I777yPU6YKSmESFys5zMi/LB/j7GCP1+jFw28ULd6B888BV4AdIbwx3FPEZzGQgDRKvoIzPQqwvi01ldHwxcoipH9WND/HmB0CeK5FiYeCDeR+Ll9Km5FnXtki++To8huEQC0Ok1EryuCyiCiePyAZi6aRzUDAfP5G6CjE23Cr8bJwJsi+VYBGLXXXDoKUTRAGQ9V1lSpIL/PXAMliMLkkD53YpOrzzEpkIJoVxQPvrIAfaTK1EuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPuEfu4WbWZUtTMVfcpd+QsyVC8RCcxoIjYJCJThDPw=;
 b=niFVIaFYkRiGjVvBoNiQmrbrG/XmyEXTUpYUvaCHZJ68UvkNOfRk8ZjfneAksQwvb0g+O8PhMgnYlPRh44cxbD8pcSVdQ90bV+jW3ExNv0Elym5Ns75sdRmjTPjAihSFl2F14dTBXmZPfKR2aRdxp2ktENXkmRQT6xeMhFXKBCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 21:00:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 21:00:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] selftests: net: tsn_lib: allow multiple isochron receivers
Date:   Sat, 24 Sep 2022 00:00:14 +0300
Message-Id: <20220923210016.3406301-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
References: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0270.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ea5b570-cfd9-4879-52c7-08da9da6ac66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f98I1B+VZNIPvQJF9WcwEq+AAbs7dknfzIDxifsQ7pkPhx/bdHtRfUnaAuPvNRjLyri1hF9LgaUfZImqpzcmw69Kxu4TcfDN1xINgVHlJnRIXmaSRJNKRl0I00he1jZFM44efjRD7KVd08xMCnD68WnYgwEchqRecastx2iLoEfqWaNXC31Yltx7SR3DpVfNQ/F9vSGXR3d95H8i6FsnfSklYByq/sLwQJ6zX8XJaRpPA8wGRSXWOC42QygRfY1LRvOHzyg24mt76ZPwY/mFFmCWMSZj8D+NOLzV/wjLp889cptVOPfbGM9izkE6MqP5rZfNeRjvLm4kVjCRRjhrKnINg0Vgt7ybMbrUrM2Uybc59p9nKoKO/T03LjTqUSU0QDgAyHf265Lv6rEPJMLp5vOzh5Ldlk4gtp8xbzlz5oLJd65W5oA5XN2MAxX5YIh4J49E7XX+PIaau0iYlgL6sF7pjc+Q7qlhNBC7ewyYZgWfhgWwlit0A7J2u2tZAG4mZ8FTshYN2jSpXxi24X+YJCVzMKvTlXnSbL6+FhQDpKP+kWcJFA9YcPIaR7apokdHWJYhUp5eewubT+M8aTl+QsG4oGMXvOe5phSqAEsoE4ifM8rhpL5gGnfQ31blL7lfwNsfBqbmNbgloot1Y/kxFHHnw39Rel4Y9Krie5xLlw+bEVfuj2tzsK0H7W/ADuuNePf3sfI68McFd2vb03XhUgwwWokbOtkPbKk3zsHjbKA/quG8qc1LjylVmnr1KIgvxzTgQedIwAFpFL1kr3gUYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kjtbgfB4LiYXfQrPR7ALrHBrl17aAFvl7T8p845VnXpgbe1UTTkyPK+KmhKY?=
 =?us-ascii?Q?FAQB9q1D1vPnFIkzRbHlvDfKVxXLx/z3/Us/JLyt4yT9jO5YWz1GTHQIoBtp?=
 =?us-ascii?Q?ARCT0a9dR6IcV+Tt0KSqFHdJmEuex41kx9TvXRA+1eJLQs31j44raIspo6/Q?=
 =?us-ascii?Q?uJW3F8aPriN6xYzcPJDtMmZnKUEhhYjaHAa19NQYbHd19/aK40m/Ju6J7b2R?=
 =?us-ascii?Q?gHAvVz0XFE8RlUIeSJKJsjf5yfSWCNH7yeR9dqoDNYEn0liWRNReVlX/AsaF?=
 =?us-ascii?Q?8bVJl74/KyjDKC0VcqQCIObW6k6hr1QEh68ZSKr5WZmBf7it4mlpkUGYK5qO?=
 =?us-ascii?Q?10Pby9XpB9rn5kS2GIZjeFsLrIQ6TdvCHWviprcB8XSKZBvMWLmdDiKruQK3?=
 =?us-ascii?Q?ul1TRYQE3+cQGwPCLH4Q6zKuV3hyDeSdphsbFoD4td9ULh1D2SdD4mTghNLf?=
 =?us-ascii?Q?zy7A/JeRLH4nT3SLZqNXmD5Ob7/rCAEPcVnkDwoxWX/lYYJYGWQzOP7lpBbq?=
 =?us-ascii?Q?sbgZp/pCWFkM41iCANVtbyafJFvuRxB+/5JNRNAeNo8dHEfuzydf0yTSuEg9?=
 =?us-ascii?Q?fr5CHqKn4cWq9RSS5CTqdyPJSWOOn1bI24rTqO5UIie5YGLABPBtcUDGm26S?=
 =?us-ascii?Q?NxmiIPBReZtc3GCqINuIg9oKFN1JM9NXgaAqq4TI96cvLPAjoCuR+VPB1Asu?=
 =?us-ascii?Q?xa1KxLKa5agUTyiqgJTfK7b5H8F4vRzzUi6j4/6xFzj+crasIFd7XYmg7hh8?=
 =?us-ascii?Q?vYnCshdkdRWq43T7EP+IaK9854mFR696Tbn79ykrOT7D0RsG+WVG4BaKbQHd?=
 =?us-ascii?Q?cgSL+SDixEPdKDRVBD7SYzXU9ihVX57QfwS8c/mf91FUWiYozI52bGBj0yUB?=
 =?us-ascii?Q?xHqyl/FWFcaHEnPwbtOAfTM+cTKkb2BUvVYbjCB0wf06JLJzYZKuETDwlBm0?=
 =?us-ascii?Q?FNSfrhof6ZKHGW+pgz8XX69fmBIp4e1Ni1+vehNYzz1zsDcxAq1PIVrrHdR1?=
 =?us-ascii?Q?JQdSZ4gxyHcSmJ4+cwZzcDZiNiq84oh25Ewu3SthjNSYSMO3nye2il0GnxOZ?=
 =?us-ascii?Q?OU8GgodpaOQVIN54k/6n4vsmy87FLNPirdrZWLHfck4phG9m2/0lEA7KQ2wn?=
 =?us-ascii?Q?FIdmjLgfM0sCuJICiLtCwmWnlTD6K09mRvGk1xbF7m6F7wicu4OHpdGxyyAh?=
 =?us-ascii?Q?GyU4mdk5pGMZyF+FLhgXqf0udjTr4ohI7gQtZogJM+7WQ7kviyQ2JXojrkv+?=
 =?us-ascii?Q?eX0MPX9aDSXjGOY6fHNGgTqxS2SwastcwvwvBAzYYJbCkHVSCN9uWExV8Eh7?=
 =?us-ascii?Q?e86+g1IZj/00IIjPFNmuApGrUEEZMPWTrT3/clDcN3wtdjWUoo5NHzXhbn0K?=
 =?us-ascii?Q?Uueif9hlPa9SlQi5zksOs1AU4CN2yPamRRIlXaQb/YsNH1xfmfnx/3xLDmTJ?=
 =?us-ascii?Q?NUf0i8XNzK1aRJQY3mlbPeny4k9Vrp0aOqwTu7Jh1Ssfuw9KCT9TL/xgbQuR?=
 =?us-ascii?Q?TPt93mbfmshm3dYEeoe+B9hldQtKMyKZUD5iAFSWpHagZKgDZExiwqBlN6rX?=
 =?us-ascii?Q?qzrC6zAOAKW+ZjGAO3wPsJmTvA40bVARllO8+rBfAyYFKBeuPDiJbDm0cqNc?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea5b570-cfd9-4879-52c7-08da9da6ac66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:41.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Av4nb4pYO/VI1rn0RBufmHDjclP1mq1GwJNDbwndVdqFVbsP3ZZ1ovahVTCAv2mrcWyfDXk35VMZ92iiGADTdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the PID variable for the isochron receiver into a separate
namespace per stats port, to allow multiple receivers (and/or
orchestration daemons) to be instantiated by the same script.

Preserve the existing behavior by making isochron_do() use the default
stats TCP port of 5000.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../testing/selftests/net/forwarding/tsn_lib.sh  | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
index ace9c4f06805..20c2b411ba36 100644
--- a/tools/testing/selftests/net/forwarding/tsn_lib.sh
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -147,7 +147,9 @@ isochron_recv_start()
 {
 	local if_name=$1
 	local uds=$2
-	local extra_args=$3
+	local stats_port=$3
+	local extra_args=$4
+	local pid="isochron_pid_${stats_port}"
 
 	if ! [ -z "${uds}" ]; then
 		extra_args="${extra_args} --unix-domain-socket ${uds}"
@@ -158,16 +160,20 @@ isochron_recv_start()
 		--sched-priority 98 \
 		--sched-fifo \
 		--utc-tai-offset ${UTC_TAI_OFFSET} \
+		--stats-port ${stats_port} \
 		--quiet \
 		${extra_args} & \
-	isochron_pid=$!
+	declare -g "${pid}=$!"
 
 	sleep 1
 }
 
 isochron_recv_stop()
 {
-	{ kill ${isochron_pid} && wait ${isochron_pid}; } 2> /dev/null
+	local stats_port=$1
+	local pid="isochron_pid_${stats_port}"
+
+	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
 }
 
 isochron_do()
@@ -219,7 +225,7 @@ isochron_do()
 
 	cpufreq_max ${ISOCHRON_CPU}
 
-	isochron_recv_start "${h2}" "${receiver_uds}" "${receiver_extra_args}"
+	isochron_recv_start "${h2}" "${receiver_uds}" 5000 "${receiver_extra_args}"
 
 	isochron send \
 		--interface ${sender_if_name} \
@@ -240,7 +246,7 @@ isochron_do()
 		${extra_args} \
 		--quiet
 
-	isochron_recv_stop
+	isochron_recv_stop 5000
 
 	cpufreq_restore ${ISOCHRON_CPU}
 }
-- 
2.34.1

