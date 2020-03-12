Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597E1183D16
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgCLXMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:46 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgCLXMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9c82QaBO7c2zlVXvcYiJeJEO9hTY5wBnSgD3fc2/Fqq6EY8dYfGT9u7bZM/RBMwF5wtKNL16ZiWlpFnnnc9M6hzINTnFBTl2QPVRSne0mdo3rJtmza8rtupjfZ9gAuHqsS34ZaIP37xoLFDiRhp59GsJtTef3jtDqQjoMA0xUBnY78kuMVjtO4fb9QA41wQ2AEjpLJA1gXZbOnJnx+SAwEuNz4ntRZabYROeMHzBbzbNc3KKs6Uu/sQm1R5q+RDhwxo0llqGSDy/VpLzyG+uCv2Za3nH6lylxylR4U0hEhPgZzaFejoNFZ1E5lFKkYXe0X6iymhI/ew5b9M3/ztBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QwULAYUDB36c1ne4+GMANxtC3pAKc3nZ0iTgKUKlC8=;
 b=D45D8goMPXMgmx6KVmYON8ogn3KvNDYigeX/Ia8fyx63jzDkSIP7l4ujCwVgNb4DeBCc5KJ/SlK9KKBYY9TV3H6C2e7MiBiEcqVE/XX6nlJl14fWzEX7HNpvWUV6FFYYocyUv68qYoC71l3Gl1ZQNCivWoStq4JvVtjMjC0bvqqkBi3z1YA2NYJZn0RgcFcWhxtBvaGn5Gv2nk6ee1k4pw2dp7rF9OfGQI2ezKMSgg0mcMQK4oUpbMksmTV8Ok+nQSL5bRjWJ1twWaIGr52/ppV57PxWpl7x6v5IWAvlhjfGuro0IHrJhPiYJc+LHzdKij7Nt09JEZDXRrrqc0wkow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QwULAYUDB36c1ne4+GMANxtC3pAKc3nZ0iTgKUKlC8=;
 b=tNQuu0uJ+jXRZV/fKw+duYw8Nf3y/v9ckLLq4ai7Au2q/IltJuP8mQkvdI8Raz6EiZyDLot6//uEncaqH3wrYTB9ls0HMFFrXDN0V4esmOxdCZYpDUIIt6AWjA0B5f5rkx+ySsxVzHWvLOhp9HLOyIhY7NAxDvGBBLfUUkRlh/0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:37 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:37 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 1/6] selftests: qdiscs: Add TDC test for RED
Date:   Fri, 13 Mar 2020 01:10:55 +0200
Message-Id: <20200312231100.37180-2-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312231100.37180-1-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:35 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d46c5262-22b7-4e75-a23c-08d7c6dadac8
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194CF4FCDEEF3EE31DBA42BDBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5NcQu9Hd1tmVnynYUcirqBSV3XLBkjfbyJ9ES/HuSMbtvTt1hMzWrHnw9GuhxLd0TrzMv1srMfhj8JXGRZuOqtf20dW+T5XTInUX10PFqgiNQczp5FqLyJiAEnYM7XS6EaYkGVwoJqxPFttVkD1O5BwpYhORyM6UEi6gLc/o1uB/Cd+JPjiTuRQNQp/gsag3x7D8LSz2gIJZzzX4RvD5X/cc4Fo6yTrLqME6q6RjEegTjJklCQ4udWCNWFaWEPWbOIey4dEO1v352I+9//utBvdrmdzwXtyTM+zpLzgGrV+6dnP8tRpW3gX+mr9Z6mTsbYKZYIa25GIdWzmehI75pBIC1py0Zc0M0i39Xq48XgTHSoPUnWw634DYYqUWRlKdnQB22GpV3zsPwcotF8nwsbg7926vwtgGsgU/rErcSckk9X5GNXNhOHPTRHg4Ydd
X-MS-Exchange-AntiSpam-MessageData: FgUTbj0oHzgPhicWZe1BDf154yqEasiVwAkXbmyv4b4/8g5rmH3tQEs68rYc5LQhiZopFjc2ufLzkQnj9bSYFkZZ6HjVeXo6vwZsRRrS+DgGTbDHf4fiNPS6WqZx8rfA+T0ACHFlgpml+VNZEtHq7w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46c5262-22b7-4e75-a23c-08d7c6dadac8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:37.4305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M3VQb3a70JBda7DB4tTDNaYBcLbj4mVRiBaWK0WDJ7EG2I8c3GDhGAczQ7fI0P+EWKYMfLGlzUZ0d2EpxtTv9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a handful of tests for creating RED with different flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Roman Mashak <mrv@mojatatu.com>
---

Notes:
    v2:
    - Require nsPlugin in each RED test
    - Match end-of-line to catch cases of more flags reported than
      requested

 .../tc-testing/tc-tests/qdiscs/red.json       | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
new file mode 100644
index 000000000000..b70a54464897
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -0,0 +1,117 @@
+[
+    {
+        "id": "8b6e",
+        "name": "Create RED with no flags",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "342e",
+        "name": "Create RED with adaptive flag",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red adaptive limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb adaptive $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2d4b",
+        "name": "Create RED with ECN flag",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "650f",
+        "name": "Create RED with flags ECN, adaptive",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn adaptive limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn adaptive $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5f15",
+        "name": "Create RED with flags ECN, harddrop",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.20.1

