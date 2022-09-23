Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6025E847E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiIWVAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiIWVAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:00:43 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D66109634;
        Fri, 23 Sep 2022 14:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2kDUbrM/5kG2GoNU5o+ZgAZNYF4qJvZjwec4mXEEjECTMy1yUCoBwlrhoJM2yly9uzGXigdW0aSfPzPfOOJZ5I6eMYngt3e8tEuq+e1mL2a4hTMQJTAVyL0fXxLavAddNVPaOu/P8PIQL07khD37VnGepfHdjnPecApp0v3CZ9voay1Ntwzh9/RQiQA7M5VRt7CucvBXdaVmGqDTe92WiwcCw7++/sO86RPpHz8tYV7j5L0AUVA1ilyFg9PB2WOUFZ96MIwQNBt2UL8K+PehzTfDfmv8v2ZpwsrsOVhQcXUkodmRu50WtXeyGLvcenF6tEEHkT1A3Mdw94G5Ho41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6Ok2DAR9gtEFzcCYyYpA4RSETBDjf0g9qTKk1gxD10=;
 b=a3BXdYWo2Zedt2gj7XMZQS9r9hxCI8brIrUC1cuuZs0OHNF63oVAflruZzS32p/si8hHbORh5EYVE6Ql9ZK6E82PG2YTyCMWkVlr2h7/bgqRBB46mj1wyhWcxJQSTIsVBOJNKGXtTglr91tDoYzKBQrADlrWDSOoHuMAR0/kDa56DLO4Lh/Q1jfUsYsSy3UTlGLZGCsSeYbgCg93gfn3topbUTz5zCMDqdihmIeWAbPtfSS1N7cO300E7Mfz22a0EAblJmVrPjKnmh54nD2OPZrypMZq/yU+kJynGTQZZt/MmtWQT3PvM7HxXqsCMiHlG3ttoIQm2EHwuAaco6+UNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6Ok2DAR9gtEFzcCYyYpA4RSETBDjf0g9qTKk1gxD10=;
 b=aWMkPs6/N0uUr56BC3PW9M+Ako7+0U+ljUOGBcVEVxmDSpc85LIffUP7gsFot5LIA+luthZBRL/CC5dzgRpisqHCdQ+y8WxlEzNNgmv8e6AwzzWSxgd3n4xxHzA3U6nqK8LY1QkbVd3uWkhXvM1r4W/OMJFXDGQHXRn1TUtMFwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7863.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 21:00:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 21:00:40 +0000
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
Subject: [PATCH net-next 2/4] selftests: net: tsn_lib: allow running ptp4l on multiple interfaces
Date:   Sat, 24 Sep 2022 00:00:13 +0300
Message-Id: <20220923210016.3406301-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: fe2dba6d-3fc4-45e7-d377-08da9da6abc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7D/axMi6TFrbCYmf/wxd8iAJg4BH6LsjTlCG3qRDOcS58TD9u0oRLJQqU2F00/R8MUUGXRT6RPbQ2dmOHGLPiQY9pw6TnLUCNQWM9D8VZpqNKSnj1E8Oy9uhgj+ARq7IxoQQxdLIijVqMD5L49SBal3GpPwDBus51zmrTHsMsHv7CXYo3m8hglkDgwcnioDTgn5xS8oncyrwxG07IU/0HuSMetKD/CyAnkWlDzNwMTYGjTifrRU+l29qEDRjFmZbH/L/4LUEHABgBWtTUUE6aqXtddcrTSElCT+Ue/P8R8hW4AUgG/UgrnkfFCQgNf50YYBBjj7YK86ZTbZDFnAepSPDc2swe6Mw5/7OfVnnT1Whq7RjsOcVjwm5l/wu9iAO+7kV2Oai2JPHhD1E/x1zkUiuof+onIFNmm6uL+h1dJacNFmV0H5xzguDIZMUsxT/718GtqE0sklVL2IPwvkIcCicUN5kjR8t0pLs1p+Ih4tq6q2spQNb0mngd6YDJs1ElINK9oYNP6Vy4c6yWrRyILNFvrF4H36WV5sAt2MftKBPOpmUVrGwodgHlTMl373f4epDofh20HMqqJH9hOfQiAITJ3+qTcnthnjampA1Da8Ll/iCh4/cAKpaMImoYW6X8bZTFLGh2tm38hpmsZFWCFSz1zusW4avyYKwILEX0xREhuFzHQ3McP4i+EA+e61+wrcIe4xyMn5/hNzD9jp5G2Q/YfmpJEQWbuCeMWeTHFnGqQd+82G7wyX6SaAkYaZTu1zCChEa+/TwyoIlsf9l5PhsndxO8ew38XvQc7asYqmJI+f1mC1WSY4KzfgFLymO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(6486002)(38100700002)(66476007)(52116002)(316002)(6916009)(8676002)(4326008)(66556008)(66946007)(6506007)(36756003)(6666004)(1076003)(478600001)(8936002)(5660300002)(54906003)(41300700001)(86362001)(44832011)(2906002)(38350700002)(6512007)(26005)(186003)(2616005)(83380400001)(7416002)(42413004)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jp3+6f1IaKyvoAlFkejZFmI5ShaBsLO1pKPU0SBkEaxn8QJfB00uBXUV4Dfu?=
 =?us-ascii?Q?kQjhgI88RxXsXCBVIjE49R2TFSoesxqpFPiu/+F7YqnYTAQ6EQvacD8q8mbX?=
 =?us-ascii?Q?I2XwFcltVigZH1RQ5CG0uSIbHp2ShjlVzEqjILrCrsEAkwR8/XfUrwOAHSHj?=
 =?us-ascii?Q?wpXvXAPWRKTXf8OJBavhShaaoqSEzwSICaWwlBCQN6Wbdw7CHOlHkbMbgnR5?=
 =?us-ascii?Q?/wG5FiFX9NKJCPfTggPDIRaQhM/kCw9hkH3WQ0REpyuWdE4juCM7CVANGVX1?=
 =?us-ascii?Q?/M1G9OSJ7HinFCl7fW32OAm9QGv1wN1SyBquMukK6h13AX4Zb2Ymi3HM6UI2?=
 =?us-ascii?Q?e3VCBT34rLG+L2k9rYJJXR3WJaVKisojNfhzVzABCs7FVcajMQrRAXGzpOkk?=
 =?us-ascii?Q?B9aAKOiKrHHAL90/3R5pz4oip5TUaAgF1ZPw2D5rkLz1t1Ci6AZ+x1Ln2hhS?=
 =?us-ascii?Q?m5qMNYLa6LUSU2K4WtZ4YGAvGsB0snWIFQHvVTrrcSKaVMSi2x+DjWHPMiNO?=
 =?us-ascii?Q?UWmOxx92S1a1tYaSk6j+6st3vQ0/HT2uGbFRAgwn5xZbtlaGfu8WBXtGEMm9?=
 =?us-ascii?Q?FHGYZ0/QJ+VGmjJv80j4J5l1ZLOOIgJufMpC+/kKD/T3Em6EqETl0td/txrq?=
 =?us-ascii?Q?P15Gnm/OUf/dWeil5Fezv8/JNbhOCESkn4MpgsWH+GlyjoPpFmFZEjVmHwzs?=
 =?us-ascii?Q?LfhiwP16gnHnYkcWh5s7DjZRb7040Kh+xVZLfUA9Pa+0A3N6L2u2dCmBZE2f?=
 =?us-ascii?Q?VV62ve4hm1CfavJI6poqEgQBM3DqgFEzIqyUsC0lu+sBQ1uTCIllJqwYhqYX?=
 =?us-ascii?Q?yhuOe2stwFNghfRpxjmYcE6jdOfpmNR9IL4MLbdPXjKmG5rwwoCPyMsf2min?=
 =?us-ascii?Q?d48oiABDr8caLZXvc9A7PmZUoDYt9XkEDKK6eUn2ashjv9yh6rJ1uEYA9Yrv?=
 =?us-ascii?Q?NAqEp5gDxe4pHvs2fWWRaMIEMKyyZoUu4Z9ojadzRnoI5JchZvznV4c5nfZs?=
 =?us-ascii?Q?qUe5pMTZJ7U2vL0377RYKBdwvAYt+UZSWzRa28B1AfuJN5HdXpd/d01OjY1f?=
 =?us-ascii?Q?c5QAVaqZG7LvxmN6KbAoh6bcRvjucDjijEy/GRQj5EpcqkLRcXsSIMX3M9wj?=
 =?us-ascii?Q?SLXjbUfb5J27yr/3UJH0zZCcJyGYFn+sdb+bcebDbUWxWRNyxMNnxP55qGab?=
 =?us-ascii?Q?HNBzFfN0V2S3Bc7xBfj5YuvzrN7Y9sVK+vH6KwBRgZxlRS0i+9+z1etJVgdG?=
 =?us-ascii?Q?YqjIlCac7YtVJk0SCnCf1TPwTrF0OpS+cSM7Xqiw/5xNGQc7PW+qMPP5yCeO?=
 =?us-ascii?Q?ElEhIaI+YoiidU5B2QnpY+5/HrvxFUFHvA/j1F88/EbqFi32I/Dr+WAOu9nt?=
 =?us-ascii?Q?7ItoWu7yI6it+HcaI2AWFcUSP1f7UWbrEo0bKzSj08SZfYl2dAprn4wy7ea5?=
 =?us-ascii?Q?Dg4PrGupt27R7ZRRpZaM4eGj4+xH1pcUMw0/34GfdNZxjs5Qr8GvzGdUrThV?=
 =?us-ascii?Q?Xfc/YE/vJNeuLA9hYACISWuHDSskkNZr1MtW+Zz7+LIg6/VZmIt7Z5Ido4Ab?=
 =?us-ascii?Q?AM9HV/Oy3Q2jc7vpZxH8titd0d1RFSbB/jI8B6D6OxUrx0GOzNTQH7U9uYjF?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2dba6d-3fc4-45e7-d377-08da9da6abc1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:00:40.1990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0qyp4c2S711y1I2dP5yIyQhnNz4pFb6niS+VS+4l2AEk7Y/j68RWJEvGO8sNKGtPAoAjyTDbdrNvYkpsZm4zQ==
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

Switch ports will want to act as Boundary Clocks, which are configured
using ptp4l by specifying the "-i" argument multiple times.

Since we track a log file and a pid file for each ptp4l instance, and we
want to be compatible with the existing single-port callers of
ptp4l_start and ptp4l_stop, pass the interface list as a single string
of space-separated values. Based on this, we create a label for each
ptp4l instance, where the spaces are replaced with underscores
(ptp4l_start "eth0 eth1" generates "ptp4l_pid_eth0_eth1").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../selftests/net/forwarding/tsn_lib.sh       | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tsn_lib.sh b/tools/testing/selftests/net/forwarding/tsn_lib.sh
index 1c8e36c56f32..ace9c4f06805 100644
--- a/tools/testing/selftests/net/forwarding/tsn_lib.sh
+++ b/tools/testing/selftests/net/forwarding/tsn_lib.sh
@@ -53,15 +53,27 @@ phc2sys_stop()
 	rm "${phc2sys_log}" 2> /dev/null
 }
 
+# Replace space separators from interface list with underscores
+if_names_to_label()
+{
+	local if_name_list="$1"
+
+	echo "${if_name_list/ /_}"
+}
+
 ptp4l_start()
 {
-	local if_name=$1
+	local if_names="$1"
 	local slave_only=$2
 	local uds_address=$3
-	local log="ptp4l_log_${if_name}"
-	local pid="ptp4l_pid_${if_name}"
+	local log="ptp4l_log_$(if_names_to_label ${if_names})"
+	local pid="ptp4l_pid_$(if_names_to_label ${if_names})"
 	local extra_args=""
 
+	for if_name in ${if_names}; do
+		extra_args="${extra_args} -i ${if_name}"
+	done
+
 	if [ "${slave_only}" = true ]; then
 		extra_args="${extra_args} -s"
 	fi
@@ -71,7 +83,6 @@ ptp4l_start()
 	declare -g "${log}=$(mktemp)"
 
 	chrt -f 10 ptp4l -m -2 -P \
-		-i ${if_name} \
 		--step_threshold 0.00002 \
 		--first_step_threshold 0.00002 \
 		--tx_timestamp_timeout 100 \
@@ -80,16 +91,16 @@ ptp4l_start()
 		> "${!log}" 2>&1 &
 	declare -g "${pid}=$!"
 
-	echo "ptp4l for interface ${if_name} logs to ${!log} and has pid ${!pid}"
+	echo "ptp4l for interfaces ${if_names} logs to ${!log} and has pid ${!pid}"
 
 	sleep 1
 }
 
 ptp4l_stop()
 {
-	local if_name=$1
-	local log="ptp4l_log_${if_name}"
-	local pid="ptp4l_pid_${if_name}"
+	local if_names="$1"
+	local log="ptp4l_log_$(if_names_to_label ${if_names})"
+	local pid="ptp4l_pid_$(if_names_to_label ${if_names})"
 
 	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
 	rm "${!log}" 2> /dev/null
-- 
2.34.1

