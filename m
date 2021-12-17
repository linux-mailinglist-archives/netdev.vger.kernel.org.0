Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1F478DB8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhLQOXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:23:10 -0500
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com ([104.47.59.171]:28401
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237287AbhLQOXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:23:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1md+j17gF5T8z5liSM76BxQ66aZ386HhX5qYFlShu9WVc4XcUnrz6pq2sDHSje+aK7AOUD3u2aTlaW+qR9ekCdRpjXR44xniwcJW/COQcQHaL5DQ5FCcWtpFKOTZmIGZVrAje4WdazCmm3FRFTnMKJRyHJwWQEhN9lJw2kuc/SjrEiQNgW1+Pp5X5JpPalf9RSi35Pkj0Py9caxMt9exnzrn4DlHYEMEvGhY8yDdZUKytfzPbiHCkqjsjq0KECp1VJSNYyg8RUgC1eK7mc1i0MmIQGpc94k1+Tpd6v1cCbS06LwSue3zB7Xsmb2CHoHump3wxz9yzbxeCvJe30kLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKllfkqrbcJlJzWlMdm1iJKX8DOQSDXWjvJzsShFQ3c=;
 b=cSIkko14Smln46vKw8ffl0K7yyAfTenvoCmnFtuZPqAxa2buUACwhxrplSDy/SOfbLfa0fgNUKEGiR8Y2JimxgUFGp1vuYDxx6z2YDffK3iahY/E0uCjd9sbFsAFfuYGnMwrqTbaGAH/zRbE638bNAU0JlckfQhW7AfAhZ3B4IY4s1Zk5BPSVFob5EoTVbz+q9EgRFLeWQ4ixM2FhxDYvMnKuvkb5kYuZnNluGzalI1fGEOLepbWPwgBPfpOl3rMvYCOYc+qz/EIuOCCyucmvxqkieZ57R68mYxTrVZyBtSIBJlss2zNFwujg0inUEZEWWwhjUaslOWW58j4LiBmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKllfkqrbcJlJzWlMdm1iJKX8DOQSDXWjvJzsShFQ3c=;
 b=vsZqEJoYnnadRZpKo87S5gWTbwmot/m6J+GNYYswrILRxFIRuHOgoxsnNeqAU0IUkQmREw31vFGvpMD8b/JZctV4VDptG+2/OOnq5FSG5UZjfhTMMmIf1WBbgafQ5kTu8zIy5kFCdKwYz629dORL0qIVO71HZV+0UR/DVUGMUFo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5595.namprd13.prod.outlook.com (2603:10b6:510:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:23:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:23:01 +0000
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
Subject: [PATCH v7 net-next 12/12] selftests: tc-testing: add action offload selftest for action and filter
Date:   Fri, 17 Dec 2021 15:21:50 +0100
Message-Id: <20211217142150.17838-13-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9b6137a-0850-4241-e65a-08d9c168bb44
X-MS-TrafficTypeDiagnostic: PH7PR13MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55950E6AB2B417155C185F15E8789@PH7PR13MB5595.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+jBzW4j6IQj+LXP2JhdlEuXvZ9f3dQ3JclKOW2+xsgRLI4pOcEG+4Z0maM4NPyVq5LQ/dzjlZEItitgv5LGPGPSwqAHxdOecAYdcTpAZPw7eJMCSyUdUVKchJ1A3ftQDaRQXBU4OZL+nihO02XlpYrVT7+F5OHzFIu8ruhbUYsziXfdLras2eBv3azz5EM162RcUtuPbZmCyGWWjTJRPKHMp3OrAiLiDlgdDFoOxI2iZB+Sj6vxnkJQxjClPgRoQyCdD0x+2eFx3baE1Ang2oKmhlLfUDIOIth9zt9+jwkszOX49aufYF+/sV+OSljXvrC78M94kNoUEPJauukje3ASOa3NYEneNTMkkYKp71oE2eBtxYMCR+4pUTJCwqmll/9ZTDdOwjkf7EewIfdx8+SlHwaEIVwIl4/oMPe+9H7aew+U0mDE+P4lu8vaa8nGfjGvDaSF5YsSw8LWgbAe9osXh2xv492ela9uRj88JFjHGB2M2oaVPv/JGolS+OeZ7V+kxbRFUPVjK9tknS3E56+mtpJKzv5WlLnqP8rrxnbxvh15B8tmAQvhXfMlzKTzuGR7sv9+/KhukjgjxOCe01dNzIVniIY08YS4NIo4r0LLXxtunnM/oG+8M4V1iukLL7gBY9d9UgAt+Ut9pGpiBgcf6rOTn4YJutNhvdyzzgbBJcsQ38SkexjdGzh6JPap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(39840400004)(346002)(376002)(136003)(110136005)(8936002)(54906003)(8676002)(316002)(66946007)(66476007)(7416002)(2906002)(66556008)(4326008)(86362001)(38100700002)(107886003)(83380400001)(508600001)(1076003)(6486002)(36756003)(6506007)(2616005)(6666004)(52116002)(5660300002)(44832011)(186003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBF10lni7pnu9U/u8bfv7XJ4BnP5YOeeU1Qy79F42h3HM/FVT3zS7ikFp2N7?=
 =?us-ascii?Q?I5gHFf3Z/lrZ8mC3agF6hPLm9US8q7ZbSNSjD2KGaLS/sp06qZiTlYKLel/l?=
 =?us-ascii?Q?Fc3eWOWcEWOXwCj/R2YEJy99nCnzhHuXZ38nhtJ6Zv/NeGCBNe5AJELke+Cf?=
 =?us-ascii?Q?q+kxCY4OTk1d9r/oLSj+Qy3umnbpVfv9EgF4+2UMXFqeCK2nwONFEGfwRTsJ?=
 =?us-ascii?Q?Q4GggbxA1GgSqFsp+7paqVHQ59gMDIE2+kDp0rs4wdCyjC4QoXuUrfnMPexl?=
 =?us-ascii?Q?fZzrwc2NBWww6kt4Y6IqVaqAu4eNLI1tg9K1ygSLpoD6vL+Vl3XEmCcEnDfk?=
 =?us-ascii?Q?ofMHQ6zauqPNmpx/xgz1dsPtfiT83zbOzA1Ev69tzG0trc0X6LHIvNWyr6A8?=
 =?us-ascii?Q?cpmtjqlqun9EuniXr2z9p1hBuo8wh8fBA1weGCMzlas0noG3LENyrzd68DCG?=
 =?us-ascii?Q?4XecMeijEEmwwhwykodlrSqhKR+R21eoyaQHgV4Cw4J4gknCmsOPf5WvPVC3?=
 =?us-ascii?Q?VpEyCiFmBOt/s0/SWu8yrhkN0chI7HGbeC47I2BY1qg+n+ecZlDPE/TGsYC1?=
 =?us-ascii?Q?qA/hED6qzeO2qyocQFEA4iyW30AjZtlR7yTXctS+h2/wvNkrnu8qFm9nAAWR?=
 =?us-ascii?Q?bFZGru4KZajVb2Qsfk3DZek6D8tSIACc3Hn8LyhEL52cXVS6xCK56rteokmJ?=
 =?us-ascii?Q?cmLDCJOP9v9OyuLdll2+SFVufCn2D6BzP8QP12W4QZuOiwUDelS+fyrLZMoE?=
 =?us-ascii?Q?0PqElttljF/l5VJW3zB7O4EroFAlv+8f+vnjxEBa7gYPEhZjgrIix/Nq+KuI?=
 =?us-ascii?Q?wMJ4iWLbC9l+s7G0kSO7YD+Fm5k/Wng4BaTgV7X8QaNZNkHDq5XOdbtPSpoo?=
 =?us-ascii?Q?7im6BtqjhAhAp6Zrji6v91o/vtFQu+WwQwOkNa6zUlaXnGPUCZ7t7fS6YxoT?=
 =?us-ascii?Q?mlayNluDCqyO6tELMPcxEBQY5crL2RcNNwQUHunMQFIogdFf9gq2W5cUWK+g?=
 =?us-ascii?Q?zNZLQJKmlWs8HAETgCXnWXPZkxj5opFbnCcKxHuHOWPIexD9vT0R4uQRyNJZ?=
 =?us-ascii?Q?XNAMPI1CAzH664SoBiw+ny5HUoh3wyja8ZQfSClaT2fgDLJXKZ8NECzZQgDK?=
 =?us-ascii?Q?zST/UZ9WUhOkfYWqIMaJoDMbhQEiymZKQ9OvSX3alvT2g9BJq1OHOcrERXfE?=
 =?us-ascii?Q?4BXnAeL0unAU2NK6ge6ZqGW4yZZ0OwocR3IxE9t2VxDaGilqeOT4YjQ0ti9z?=
 =?us-ascii?Q?XJn0SGPwW2DATk5/vKxm4ItLL96lqJ2Flg67/i+aBPmS3HXfy94SIy59L0gD?=
 =?us-ascii?Q?GmvvZaqrnBXEN/weJBSOrDKDFlKDoMpHocUSNPD3H4bFon+wqdyJyDZV9Vbm?=
 =?us-ascii?Q?40FyWNDjK7yZlkTp6k8Pvw1zGdtYwIJs3P62HYT8a+PoB41wDjytokMd+W8q?=
 =?us-ascii?Q?gROgILDzVe8D/KJokqwPcZY3uL5b8AmNitGabze4KLO/Od7Jf1qO5AAVXhFt?=
 =?us-ascii?Q?twlnjf6M6oFfK3/ZdTWO9tzddPwuVDvDBqXcmR6VYeMw4ctcr1pcN1x8Rtpd?=
 =?us-ascii?Q?zMawdk2bd+I/urS9pBG2RiXznnru7DhfFCFZLQokvEdYRM6ov6O2Tzr9pntf?=
 =?us-ascii?Q?GeQC6eu/mSD8MVd2rbBP5ZZ8NhA+mTp2wDvxdrNtLS0atd7fwOJZ+l48n6VP?=
 =?us-ascii?Q?czuummQtQxTG4vsBpglgQW5YOlY5RyTDpTmjgz4mgh3IklKOIclnjbkT/50q?=
 =?us-ascii?Q?muPgpUtebA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9b6137a-0850-4241-e65a-08d9c168bb44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:23:01.4042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OnXHmY8sEsiUAa4mpNmPTnpMPWoTXSMqPqKMjP43sILwejQcsAbBD+/jSimNUWJ2ZsVnvkaUYiqvWAPJISKI4tNJrqBxUENi5vy1hRFEpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5595
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

