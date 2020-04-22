Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1E91B4ADB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgDVQtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:49:17 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:29032
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbgDVQtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0UlwGKtLFKQddnW3DZXGmtiWdU3MfeOcobbRvckBmwx9ymqaR1vPrDDcPKYM396XGf9Q9yXSn41ybhnwR1JFdrxqG+tZAPCbnlxZ9+a6XFg7oE/K02LkXjQpSc0X+Ru4BQNLhbU5yPHEp2q/eTd9g5wYmKWqYjapyO/qj3w3F9YUhXQWL0V56UK1qW2N129i1ll+JKzLFspklejVMSXQ2f48xDDOn0DPGLbHaAK0IxlCeGkl/QJaTdCapmCXmQnYkZqFzRoKaUko97Lc8rlRWgXoKYE7q8i0Bhb5BTp3LvhKjxvm4KDG8Vhz2vVTffzQ1CbCEyza5lSfpwkCsZI6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly04HwKhQA8u1QHPjAQqApGh35AHt4uX6tMFcvQl3Z4=;
 b=lZiLgjxFYjw04lJWL9DJv47Ve1+jFxVZeSq9t4kctmqr8AX+k7FHlqlSDdtxHQRHJouUtuDqvczmLDoH4fbLOn3XD0vcQ6w8zLRAdIUGH8am9nXqZbYWX9dcJV47zFVLD/a2G+cuGEbD25HAfry5oImeQnziINAk2P0aml+xpDN+2ED2AwInFcAnhe6c8DpiBFid9KSSdiDIa+eQF1/EwFzUhMEGJHU17sqzf/Mn+DVevgWWyP1WIsGy1BAOncGtZD9zMlWzO2FwlvJp91PERvpOOyHDIxz2z0/eejn3sBe8I7f4S0BPcw60sBT9nezfdmccGKxvSyvoiyP8zLNd+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ly04HwKhQA8u1QHPjAQqApGh35AHt4uX6tMFcvQl3Z4=;
 b=RNbbH8NcI9hLYoruaEcvw/y2eQ0/66O1lwOCK7fgTvQiPyi4mmra0TQoapcsd4CfZYwcnNPO6SKNPglDDA6NGF+bCtjG8IavV8Y6QIPuZuKWUIBuKFBOQt7O5kyosQmJV9jb5IpitHXNEVIGgMToXTqYiSKUQU6h2t/uAPGpEjg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3498.eurprd05.prod.outlook.com (2603:10a6:7:33::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Wed, 22 Apr 2020 16:49:08 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 16:49:08 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, davem@davemloft.net,
        kuba@kernel.org, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 2/2] selftests: tc-testing: Add a TDC test for pedit munge ip6 dsfield
Date:   Wed, 22 Apr 2020 19:48:30 +0300
Message-Id: <20200422164830.19339-3-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422164830.19339-1-petrm@mellanox.com>
References: <20200422164830.19339-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::23) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 16:49:07 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77b84e0d-1b92-46c3-70b0-08d7e6dd1311
X-MS-TrafficTypeDiagnostic: HE1PR05MB3498:|HE1PR05MB3498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3498334CD672FD7CD666C167DBD20@HE1PR05MB3498.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(8936002)(66476007)(6512007)(6486002)(52116002)(54906003)(498600001)(36756003)(1076003)(6506007)(8676002)(81156014)(6916009)(66946007)(86362001)(956004)(2616005)(26005)(66556008)(5660300002)(6666004)(4326008)(186003)(16526019)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zM9Uji4z8Lq5qWFyVHUuNsD0w+0vZau03O/yw0kNYx+8SgA6dFPWmpU0ZU3eqMbPvsAQZ+b08mdgwLQBdIG9YBl3n1X2FTvGu9SaI3V0wlUzE9TOBS2cdIuQYhi1CJDIWZgWTmJZZVOUPRaU7qfIlVLy940Ak+P3XKuxOq6gSWarzfAgi8WX4lxKuDArwur7V7emMGKRWxkPUHkjz4v9YIt2w6C4U+5k5R/gG/OUnY81vhmkLeJkpw39EdlO48RbjE+QOsYix9lI+YBVPDX1c9+LveAViUfrsixNUEs4KY66hCSXQLwO2KJL1WKk9hvNYHxt8vtD2UuPEzwdKwrvB8R4ew2EAZETYME9hxbG2WXo8uOWzOW5olGeg+x1bSvF8X+OVBy78mCBbiLkBh2QJqR0ujW+f5I62oovn/oJ8VuAfyY+TGq7vLJZAXIMtOjY
X-MS-Exchange-AntiSpam-MessageData: C9yj/ZGqTb/OQ1QRwvqVvWpxmMAGPpywN+NMaZVcYsAYQLBe/fF3V8pJNeiuLEU6Y7vhfDcCNR+vCnVKuPMnTXUtCqpOh5AZDmUB3Yy/3uCJVjADRA9SdA5hrltPvuiJPA8KofSBaVQ7cON85QCr4A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b84e0d-1b92-46c3-70b0-08d7e6dd1311
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 16:49:08.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +itje1xwtmL6TLWs8Eyhk5fq5LtXFHiluyO3rBT1HNrWFfWZG3js9hXRfd3fW3BG69Ci/i5HDjkRwdJsW+D3Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3498
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a self-test for the IPv6 dsfield munge that iproute2 will support.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../tc-testing/tc-tests/actions/pedit.json    | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index f8ea6f5fa8e9..72cdc3c800a5 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -1471,6 +1471,31 @@
             "$TC actions flush action pedit"
         ]
     },
+    {
+        "id": "94bb",
+        "name": "Add pedit action with LAYERED_OP ip6 traffic_class",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge ip6 traffic_class set 0x40 continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "ipv6\\+0: val 04000000 mask f00fffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
     {
         "id": "6f5e",
         "name": "Add pedit action with LAYERED_OP ip6 flow_lbl",
-- 
2.20.1

