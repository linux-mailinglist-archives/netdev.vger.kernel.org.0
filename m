Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54F4793E1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbhLQSSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:18:44 -0500
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com ([104.47.55.174]:6485
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240302AbhLQSSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:18:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PojvSjO7noz5ytLnJ0ZRPeWrZYo5JTwf5qX1DEW2R0kbu1xPdpUkcnZbOA25soBbtmTrrvVx6CEYR1Gqjyu1+FUzglOW0xIDviOkTa4xMFJ+B9Ybr/gDU7t2o5eb6wbpYT5sL77Vv5Gw6RD1MA7o/LlUA9/NPL4XY600VXpkcqSepiWtVXlEioiIKr+dLigEMFwjI6xNhMziLV+WGQEZShmGdmDY6JeB1chE3wnUg0sqcLUbE2erQAf6WDPlt5s11PnAcb6/wZpMFb+kxJj6xbRYJWGvdfkqsnEV+qh/0chRNLaC3Gclmp5EmmEj31kg8uiuzOoIEur4XK3a52Slnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKllfkqrbcJlJzWlMdm1iJKX8DOQSDXWjvJzsShFQ3c=;
 b=oVWkFgG/FkMeYMYbSQUwunxMFy/J+mtlqBccoXQtvOh82zNcfW4fGgXpK+7gYqE3AS5vM1d7WqQFUd83ih2UJkyGZF8PwcLtBafoKXtYyjUvpAjtLU3oAy+JcIuJA/RtSSB+Dqfh6CXpER0gFyGW0tXQjG3USQ8w6z16sUgxwogqfnZ590oE4qAPzaJpkNhOOJD9qEmV7P2cI/qjZhh8LObS9+9cCYS3WmxVLj4MBwMOQql2kzC4wPT/4dKXv0HQXJ3Xdj0a6LOn8dW+OZlilrSE0uz1C9jBGQOchRSEkuv/+mat0YURQLJGmgFwMCXGlW1OItlgzj/Gphzd94rOuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKllfkqrbcJlJzWlMdm1iJKX8DOQSDXWjvJzsShFQ3c=;
 b=DA/FxhIwYfs8nJjveIcAwDx8JX0QfTjzrwMnHDLVZNXDU5niBy20EfpIvPb1GY+qvnyMPUG57h9CZjc0vWvKnB2siIgWWVGcAWt2ewozt+mECckRr731ntjyKEBRevSAifuJ3Fk2XmRxb7z/90hA911ASv8MrmKyN0FJdWWZuac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5502.namprd13.prod.outlook.com (2603:10b6:510:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7; Fri, 17 Dec
 2021 18:18:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:18:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 13/13] selftests: tc-testing: add action offload selftest for action and filter
Date:   Fri, 17 Dec 2021 19:16:29 +0100
Message-Id: <20211217181629.28081-14-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91df205b-7957-4c89-4428-08d9c1899340
X-MS-TrafficTypeDiagnostic: PH7PR13MB5502:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5502FF08AE511BD763D7309DE8789@PH7PR13MB5502.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqxGgkzqs/UobMYCakOPiGGTETkRtxA1hpEZsOGJk3gV/jUXHB5UKnGDedwt3G6F8c2GUp0pEao1VVw64I4hCnl/pCC8846oM9CXfkraPK+y3Irh099KOTOHv9uVcb+FVzYcSc8YBz8UMYgOPF3XMqQ70qQT75c/nlT28eTTb4CHpJDPvV1vptBj5NF0ZGKttFfipN0SBSzhGmXknlerFm/NnnaybANo49E44oVB0vmxePGTx9Wxd58gAMppCwhcBLIEQ27WFzaupVATh7QgUWUlFv615u09VFGpe7E5ujNpdctPr94SJ2a+yazUQ5tFplLRumUCvh3YkVMeV6d1yl+pnqPUB/mucDgRKXTb1/8TjAVwR91V6IKlMOy/c90UYsthwo+9UTYFU5NHH9ysDCuh8p9TW7kFxmp09i20Eawc2K7ipVwQ3jwTIEjPCmZYcJQhIEynPayQzDrsPTEvPCyQxSkWSYnnXWBoF4Ry2LHNUb6RnWWbABvp6z5bvXxm9d83DFUeWEdiOSgCwwub2R0YrHidjMIxg6aF58dI6vUmeC2TO1JjVmvIMDd9a5hIu21I/4i7f3M+kBfSAcxEz+96Hz20C/PWkEJ5kc6rqvmwMPQcZ3C0WkpHvsSn/l7FZm3lT9Crox06qfLdKOOd/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(39840400004)(366004)(376002)(346002)(44832011)(54906003)(66946007)(316002)(110136005)(6506007)(2906002)(36756003)(38100700002)(7416002)(4326008)(8936002)(5660300002)(66476007)(8676002)(66556008)(86362001)(107886003)(52116002)(6666004)(508600001)(2616005)(6486002)(6512007)(83380400001)(186003)(1076003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y3+TNviyoo3rt3poJU+qk69J0q7m33tRGxtncMwfyjSVAXqPxyVszMG63xbN?=
 =?us-ascii?Q?fMo9yvXXQdaKsKzBAGgQdyL3YoTLYLaOMVs7lD25btikNTJdBLCGl45FGzNi?=
 =?us-ascii?Q?iDvgZsQRGg/0rDErzHlWsM22sM5L1ediZbKdJuGlcq0ElxpJ4Yk3Ho3A6mU3?=
 =?us-ascii?Q?RHXQcGFzmdDGBo0Vl1me9KBSy/lBqsrIqYxGG+17Ijt1EwCwJ6/YmV0C+t9D?=
 =?us-ascii?Q?8wBVh+JUHLjKftBnYyuiLBUEiJuKQ1u226kcuDTPhA4Z4Z+FMwruXfXJO8Ou?=
 =?us-ascii?Q?gRpaPJyYNcg0/cHxQL+/wBHFVL3qEUG7PThP+iA9+B23OFpPzqkzj5gHtdP+?=
 =?us-ascii?Q?kH6Xyzv158IseyFPc1/flWE+IIGl/2WGrC4oAyUlGjjDLLpqnYWJRfo9JFHk?=
 =?us-ascii?Q?QqQM92zk2yBYcnJmAOTNg1dY7wVA3grXSLF5wIqVADdaFLVk/ZOt+reVTawC?=
 =?us-ascii?Q?6LYWc+7dZk6agpMFzjygl7QTT2llkK3LWLgKWF6sjTc/UOmninweDzGC7CEc?=
 =?us-ascii?Q?NZpAvUc1aGpSzcfSREanxpuD2okFp7sIDR1/TmpDinoHZoaegX9PeWqLnKFM?=
 =?us-ascii?Q?gSjfT+o/AzyqSl+eBb6L3V1ZBwMStYdQMRvDZFKJ1wAz8szy4F3l7WqP/NU9?=
 =?us-ascii?Q?u0DxjY0VG6naarbqF+LyBylS2ZJU0kE2lvSx6sFmfTE263kZHn7oe8UqKUvQ?=
 =?us-ascii?Q?8yHrrgHFULyEEra95MZU1gUbsPEykaoeaw6gpPRgCpYhPwltUxcCSh5JBkEC?=
 =?us-ascii?Q?euPtW7jlvAL1E2SFmz6z4VUmuMajEN8+iqlL8bdTTQlKWloeABQsvAQ9EzSK?=
 =?us-ascii?Q?g5Hf50p/se7OdBZp3kY68rajHqII9vSlAra0Xre6OO7zMjHFbwQhX/yKVrzo?=
 =?us-ascii?Q?beOy/XftPTbDjuvQ6KkBs8PuZJRwEV4mJuKG2tVyczz58nZDtmXZFwfA4RJ+?=
 =?us-ascii?Q?2qMbg3q+2iwPX2d0AE0qhKHp8e3oDDHVkIYRooNB0dENywk+WNPlP4tzU+3g?=
 =?us-ascii?Q?+z7+CMBLfTtF01quGR4fnAEBhYJAhAKsu5ZrQ+Hi3Tc0X7F5NwK+cGD+5j1L?=
 =?us-ascii?Q?6lmYKIsx0peXRb+jHHCk48PcWs7lg1nsKsphSjAK+QsKbcUCRnLShlbb+EXX?=
 =?us-ascii?Q?UWdBkeXiOQTuyrmi/whUR2GPkeXzJ9K5h0PjqYdFr7b7FGobOOEW/2hhbrXz?=
 =?us-ascii?Q?BzXltkIUQrCtoFFp57O1U+b9/IlLbrQziuA/FDq9eWBQ2HiElV/Lfuo6CHh1?=
 =?us-ascii?Q?yDAalN3YLcYiwIE90u2KxagEpDAcKsCzUX8PyEW5jNQ0Dn3wqwJR3fBWvfMg?=
 =?us-ascii?Q?sYW3Ziyy8rgost0AYGhwKx3Bvjon79alWJhyC9IdxjHynsAANlLMfh7Pw0zq?=
 =?us-ascii?Q?Oq9IqHl8E31dNx3Me1SMbc0RWEZCtIJf3ry6AqvUkra/19U+AZ05BjW8u9vS?=
 =?us-ascii?Q?53Q9fowR/BT147kyUDNH6VVkGog+6tJL4LtCJWDixN7yyh0wHv6rypcttMjP?=
 =?us-ascii?Q?8ixCl7mjkizhWgblVkdRgHRqIiKpH3bJYmzzERd9xOsH0dvx4aJAEXIAUM6m?=
 =?us-ascii?Q?h7xBbGDpNPWgVqEhgZ0Uqootwff3m5vSbtXWmVV/SmgKKP2bKzxqsqoDAg1B?=
 =?us-ascii?Q?YL4iJ+Fe1KaD6a4actp1TvSok+ua9F44BhlfEJvK0v9u2bWg1NC0J/SnZsuD?=
 =?us-ascii?Q?YNxvOx2zYmWeqiGBW54I2RmoDrFbzC4vUmhCW6DUDghRrmaHnkHrZAtbNola?=
 =?us-ascii?Q?8245Jjq9Jg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91df205b-7957-4c89-4428-08d9c1899340
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:18:07.6511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nD9ZIKRGTuuD0panOvMYNBeLIJpsyXQK6Z4e8FcfDZ/wI/tFYz3dsZFgN7pR/thak9qRoT9lBqBsiaJPY1uXZ1cgBTjJ1M+M0BO1Ykp3bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add selftest cases in action police with skip_hw.
Add selftest case to validate flags of filter and action.
These tests depend on corresponding iproute2 command support.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../tc-testing/tc-tests/actions/police.json   | 24 +++++++
 .../tc-testing/tc-tests/filters/matchall.json | 72 +++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
index 8e45792703ed..b7205a069534 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
@@ -812,5 +812,29 @@
         "teardown": [
             "$TC actions flush action police"
         ]
+    },
+    {
+        "id": "7d64",
+        "name": "Add police action with skip_hw option",
+        "category": [
+            "actions",
+            "police"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action police",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k index 100 skip_hw",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions ls action police | grep skip_hw",
+        "matchPattern": "skip_hw",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action police"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
index 51799874a972..2df68017dfb8 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
@@ -387,5 +387,77 @@
             "$TC qdisc del dev $DUMMY ingress",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "3329",
+        "name": "Validate flags of the matchall filter with skip_sw and police action with skip_hw",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions flush action police",
+            "$TC actions add action police rate 1mbit burst 100k index 199 skip_hw"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 matchall skip_sw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions del action police index 199"
+        ]
+    },
+    {
+        "id": "0eeb",
+        "name": "Validate flags of the matchall filter with skip_hw and police action",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions flush action police",
+            "$TC actions add action police rate 1mbit burst 100k index 199"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 matchall skip_hw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions del action police index 199"
+        ]
+    },
+    {
+        "id": "eee4",
+        "name": "Validate flags of the matchall filter with skip_sw and police action",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions flush action police",
+            "$TC actions add action police rate 1mbit burst 100k index 199"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 matchall skip_sw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions del action police index 199"
+        ]
     }
 ]
-- 
2.20.1

