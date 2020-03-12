Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84F18382F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCLSFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:05:54 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726390AbgCLSFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:05:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFk6aLK6s41os0NGAhGfj03ZatCBghLIcq1mDisSNNFDH5W7wC19j2kCj/xTpTRLNg/Ryun0AwguaKXOKIo8K7MWF1qFSjhkUdQuANluFAJ0+Q1B+B+QXkQp0ZgR2Xo3sy7A0hihvkRlhvb3feCLGxpBts8eCmrQDWNTHWxMCZxbXMvOBXuZlI7OBASWlHCc1p2r0LFuLF/bameqmLBLIvNw0W+xspYl6TO1WOFjOjMWNGri2vS/NsJUrT6dBakkiUcc7tNirBer3yiHlv8rsceU5gBSDvsEWmpbgziZmjtXgScJJ2PODsn68gD8rj9r73g6/n46X9cOSfwSYR8dzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QwULAYUDB36c1ne4+GMANxtC3pAKc3nZ0iTgKUKlC8=;
 b=DluXEnLzZHe+Z2Z8oMxvc452+Cd5Cpi280kGNRPTwPZE+CgCkDa+VcV5WjVrqFrrgKTeeX3QrxRGV59l6+hXaj9gdrFZkUjy2LG228RtxMxv754JCti9gX1Niyh1eRoSEGbj5bvHuOcA0aLSYaHk04/OezLb6n29fYH3d5VS9mt10GS4VKSUzjEcDqnGqW6G80ODuU1YPbLfvHFKgUbsS+E/0tqD4EFVLmg+bowjeZg2jr6IHJGH956ksKY8xZm5y3YHgaavlEDB70lpruYaUDC6bDTzZnOQIFbpLCoBXSe0mC+Ckr++szcx8LDTlRZ170itCNbzuoMIjIETo8QnuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2QwULAYUDB36c1ne4+GMANxtC3pAKc3nZ0iTgKUKlC8=;
 b=rCk2oIlBTO9O6nLgQ/59Cf2OyukpiCwv0yj/ydJxm5Bpl3baeUe6Cl3OCBkThfuR5+r2QRHVuW5ViJc98BajRZT5siqNxhtBj1DkGa9/dQunDQ+vHOGjtRQ6hWS5Zz5XwW0aSIKBplDsmS6ilkUJi0HjhtniOaoF3rITWKQktek=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:38 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:38 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 1/6] selftests: qdiscs: Add TDC test for RED
Date:   Thu, 12 Mar 2020 20:05:02 +0200
Message-Id: <20200312180507.6763-2-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312180507.6763-1-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:36 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1bd1063-59dc-41c6-4d57-08d7c6aff82c
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB349912010D79C360496A2F80DBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N1A6fKaH6nmKdGGmgDDohOBN+38Ahw/ktR2F6++sPqgidh/qtM905yW7Tx2wOffzvSES+H7fpjl0Dcie8gs1hpw2z0Bw+Sg8+J2C4XrOWJn9qs2vMIDPVuK3qTEYWxve4u7S+qCeKlVFAG1MRvKMfIIvMrnr1O2xzE4vO6Bwv61I3UFmH4kV8keXNvnQz6tr+qNzKqAk4+FrthHpchoAOv+UHjGAn3gEQ8JppylPchQ5nVu9FGNHNs0JyB2nXj26QCH2nrWBCHfK/1h+Sf1NFz+f8iFAlnDhpC1frZEIk/1QGpS3ctHBbhwGWiHJtCx374IGX3tC6VZAoMNy9MHBaA8zLMm82KLeWzpumDER5IrFZWxE11rtjUEbpkRZ1dL+DDnRm/WfPwDZ1n4WW7+wT/H6bNep/ADV7INqaA0lShn/YVpl51A3CWyMq562nd4F
X-MS-Exchange-AntiSpam-MessageData: yzi3OrhL+PKqLkF/6ljq/9i7rvnIRL3f17xPrhkHYrD4cXG0QiLqq1G79rWJe971IAIJCyXrFrp9YHN2FDqU4PRw1vJoO7sQOEX2Mh75uE8Du+sy/EPAki2LBtv1Ge/+TWmv+W+g37MTA4FjJh4T8A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1bd1063-59dc-41c6-4d57-08d7c6aff82c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:38.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nj2DredJHdQrqwyfMiPedPLSAEPXzjBQ+IyGL6IgEoqgx/dqFjaUwLWvyx0k4pPDIkcWMuIxsy4om5X2KIC1bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
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

