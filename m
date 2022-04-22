Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1960350B4CF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446457AbiDVKST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiDVKSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:17 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8241230565
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjJaoOL0tNBwXqEpW7SnB2ee4WsW+vE7jddKITXEXfAlBCetUBQqnw54JHZ+yoxjp2obxbV6JEYBgfWhzyevdkTGaaBKSxABQ8Cmv37bUhBZFWE4pL6IUX4pknGzGOSRMfBAVIPNgvwMBJKdo2+g+U1lAFXfG2Q4yh97PYULF3b7k2AAIhSubz1aLhGUvAOxWaZB1oS9MGdEBVi1FHBakoR04HsmnzYhyConSBHwahg6A6iheKf0CorOgMKoCiV9Min0H+N2KsYDY5SHaaWgaplIuFXAqgWhzaG4ABweFceMWJzwM5ru0KTU0zT0vnHcoVo3XVXiZUujk8OHjxR7LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwUUqbkeVGClDogqqs42Fg+fHMAHK+ayDdIWGI55EBE=;
 b=ROTvhXLXKglglng/xH3qpBr/IHEhhY0uxhxnOSE+LaZDkRAEgATDerVq6kjelsfO6xc/7bM0PW+zwbvxho2MgDgPuVRqYOpRjKh83TJWzEqqOHSkf70zRmeGTyAIuhNBQg/nV0AUhadoq0Kux0k9tjxyy5Pc4DtomHWf7y6PNqXp13clWgOZaXEqdeJesxyhou2P9g9jbZ5oihcGuc6MFq3yk1XWkNz13PUn6D6ZqryVDA16TfQZpujhaAU/M2pNU9YJlUuz7j0sDvxltefPJPftKTKJLIjFtc3iMZU8ksjW3J/h8JfttRD3f15bl2R7mQaulpH0/FUfgp4E/cai/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwUUqbkeVGClDogqqs42Fg+fHMAHK+ayDdIWGI55EBE=;
 b=QyAmJZ/uaaUGu4OIbghWkbA/imX+m59dDkL15zQ+BxT60hWFzi90318N2le9/B15wPOe1ush073abdsAilhkzqguEf5brPVFdTG5jFu5w7JbgyAbvVD9TfALxuLA+cLMJ/xbVoH1leZolb2YGjZPdZThU3R5Ks00z+XnOQBJSQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 2/8] selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
Date:   Fri, 22 Apr 2022 13:14:58 +0300
Message-Id: <20220422101504.3729309-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03a4d46d-fda8-4355-7b0e-08da24490210
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB683693F5B6F9B87E5A05F5E1E0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NH7+zovFd7+jbu4UH0gLdkK4S6RwSoQKvEO/EzHYjfKVh9uZK6/WLZGZtlOnufBonO3u5H2NBffKsQiFvv1b722n7CrJOTbNUxZFz5N/Fj7yETsoVzfXvxlGiOLGQapkANWWc1U4lU1/9pZkfJrDVNsopLZWi6jjgScpTmkSKor8e4KG9agFcpKlrUymX3ERn4Bj9PfDYgJpRWF3oDHWHtPXrFdic/DaZL81PFhWqOcYe00h/2V1mvmpc0xTtxw1g17TG9SNQNOJe9CxfNKylMN/6iNfif3qwVhO4XSRP9AbMl8eB38N56bl9Tajdj6bThe+uf/oE2yAjHxQz7DTWMhlpXTqfUNrsmz45ARhNHW7Jb5KbKTcGnmX8rcQWjmb9ZqsGAGD4F+RDQTUGQ0PKECHGO995305gellGBmjGC1H0Ht4kjE9tSrQGDzVAdZuVK2dkorNu0aAFbtWUEep+eEYXT8X3T1SMybWfRXBCp0tty4M6qjfM7DNHQSdABSyMJnh6WIBCnnRC7ccIEDVf8p292DnKD581McY7bLvjqzP2lPNo0TMhM57HTzbX0D9BcwG5MN6+fGUft1m8Pkd/zYYHUOP5jNxL3hTgTYg8FU5UwK8hcfzry4x43oMNx2uk8N5dAvR1rF/Rl5GYEIkinxiE5DkyD7T/qFDEuxksx2kbSqxN8TMrLB1OuSc9WBz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(2616005)(52116002)(83380400001)(44832011)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lsu23ukriD92FjILJDWZxwpy/rvI953p3I4UONNCfAiM8cjtigkUf1Hkg0AZ?=
 =?us-ascii?Q?kwR6u2no5q+L6MQGRzgu+34grJSB8uGoxqFYxP6GceiZXkM+lxsIxL2qihwT?=
 =?us-ascii?Q?lShBy6Zdr0el0de7nYmk7GTL3cKwVFTnKDlbTUEmZdbedmSloXsPU8WM+Sa9?=
 =?us-ascii?Q?S2x9ZJRu38nCswBxkPEsxzqcefQcSK+Vb1yxhCUN59ITbm0cYnDW7srpczQJ?=
 =?us-ascii?Q?uo7lEyPz3Ul8iCAE+tcTBvMabt4F1afVDV/NEJFvfUt+YWqkUfLlotfiZOLR?=
 =?us-ascii?Q?S7bXyUyGxO52nqnz8BptgJfygo7rmgfBFoEovDeqkc0h/zJvrY1sNg9Umpha?=
 =?us-ascii?Q?1W2LYF1CRimV7ZfJyPAW2HSBbIe+IqcTMQV25qebIgv51ZlJXC5dyclzPwM2?=
 =?us-ascii?Q?Fck+m2PGQJSofC09ThWymZQ5KmSYxseZdZxqHTp/Bxq2fLXH3ovKutx18KV8?=
 =?us-ascii?Q?KP6Ox3pjCmEjQxGVIQ5PIkAi9I9iSNkSL3WM16FkJdiTJCZson4XGOrEKs/9?=
 =?us-ascii?Q?zRyQtjAyyiDg3TCH/ZmAEnlYXApPTDjmHB2/GGeO8V0MXWbXGG2nPPHDzGUR?=
 =?us-ascii?Q?wrZ0wG3lr5oMOcFfriuD/7DqEme5YHBf/BI+oi1YmB309YemFDJLDvFK/BmO?=
 =?us-ascii?Q?BY6+G1mz+A3O2yrhNA/E6ZrOHa+O7yNSJ8NN6/86IQu+iZ7kPhjdlxqri9Ln?=
 =?us-ascii?Q?E8J1xpHUwUmaIf/3unr1o0AAY8f7+zkaYDX9VcWN4sxBQrLG/xADwi0EKbjj?=
 =?us-ascii?Q?kEuVBOG9xkoeTPR245AwKOgsSAnpDAOiZcllgg/R+X8bqtU5yUdsPRHMgtOC?=
 =?us-ascii?Q?2qRtqKciXyt9SzXPKrVOiv7V1/UTZEQVnW2sTLhg5a8SIriJBrqtxv6jzBZR?=
 =?us-ascii?Q?4m/amsVnom5I3aotgpxdanPBk6JMIiXG88xdxVdpJ7YQGdS9GdAa4+BhnpFt?=
 =?us-ascii?Q?VQgOCMwZ+TbfLxV8gdQa47ZmXuIDEdgfC43Xj3oYnuLXS8q+ywfVr2cJIXln?=
 =?us-ascii?Q?Biz15SAUUYd0Ro3GzBjuKLO2mNndykvboIDJ6YN8jGEKP2PtXXVqb1ILET9A?=
 =?us-ascii?Q?l+HQw9Aj4S0lj861L2TOSX0O5+uL70ZXjKUGVxFZunCGlDHt3vngaYoFZC0U?=
 =?us-ascii?Q?/iMFeSsFyxZGkHIxNOnbooPk/BoQPC4orNwmL4n7X/TF88GOakwU1/stgZ5L?=
 =?us-ascii?Q?jCxQjK282UW9LHwzTYAFqg2cxGSctayKs2LFhNIlcT8sYQ3Me1vjQArRMQL7?=
 =?us-ascii?Q?p+mnDjnpkjLBhB6zhypKPIes4Zh/AG3dN2EQ+aFwR868wVOpdTxmm1xCkr9I?=
 =?us-ascii?Q?Id6Hh3U5m4aB4rrS5j181YRepLla2VJ4i2/HdIxxgfojN6x+Wr+3tXWfEBbN?=
 =?us-ascii?Q?Mlvs6VHm1jAljnq44c876nLUVRzkB3IQiSPUqmyYny3t2p7GdVOi8g4yDBi7?=
 =?us-ascii?Q?mwSRAQuFSzP2cxi758TufoP9nyNHm+4Q8z2cT8t4CF1ftugK8awvtGQvxWsP?=
 =?us-ascii?Q?vArWdTN0wi+SG6gzBnnKy0atBCStSuChYHahsu6eD1zEp6A4tebuqN9wRAk2?=
 =?us-ascii?Q?N1JW0MGxhV/3Hkzmu90jHtoQaJ0ouQH6sSkQqniwSzENe/AjUyLXNCsvyVvi?=
 =?us-ascii?Q?qt/0fezo6bdyHMnFKMjClAZ2fmlSKqrEXDXJNQRIgcmqkYdfBhI3W11JL2dE?=
 =?us-ascii?Q?ARbQGQbXH3xMx6Uca66YInXvZLTYgrAPu+L8Jvpsv5gK03mcygsrkbbtH6V3?=
 =?us-ascii?Q?wIzPBsFYH96PNOAtX8pUSpzvmdV/qho=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a4d46d-fda8-4355-7b0e-08da24490210
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:21.4068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvVpI2wMnVjptbs2faQ+iH2DT4he5ju9Ct9m/SZpN/Txn2BF3KJq69FViVvS0CZ4ChJ+MvOwqJrpCV0RwiJ/yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joachim Wiberg <troglobit@gmail.com>

For some use-cases we may want to change the tcpdump flags used in
tcpdump_start().  For instance, observing interfaces without the PROMISC
flag, e.g. to see what's really being forwarded to the bridge interface.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
old mode 100644
new mode 100755
index e3b3cdef3170..de10451d7671
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -28,6 +28,7 @@ LOW_AGEING_TIME=${LOW_AGEING_TIME:=1000}
 REQUIRE_JQ=${REQUIRE_JQ:=yes}
 REQUIRE_MZ=${REQUIRE_MZ:=yes}
 STABLE_MAC_ADDRS=${STABLE_MAC_ADDRS:=no}
+TCPDUMP_EXTRA_FLAGS=${TCPDUMP_EXTRA_FLAGS:=}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -1405,7 +1406,7 @@ tcpdump_start()
 		capuser="-Z $SUDO_USER"
 	fi
 
-	$ns_cmd tcpdump -e -n -Q in -i $if_name \
+	$ns_cmd tcpdump $TCPDUMP_EXTRA_FLAGS -e -n -Q in -i $if_name \
 		-s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
 	cappid=$!
 
-- 
2.25.1

