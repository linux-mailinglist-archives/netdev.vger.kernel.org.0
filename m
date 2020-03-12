Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF57183833
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgCLSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:06:07 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbgCLSGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:06:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwZADkbU1HBwTWnsGDZg0UtKBNHS5dNaBRJNa8vs1xikwMukjEMjSKXrsIDzr/ZqGnQpwIIQkCzqkA2iIlF+CelcuQujPFySr3LylyrwyeljFHZYQiEwmQ4WyUpNfhhJ4AZhoJ+hQoW4Z/HDU5A3OqKW7Z/VQ7zX+OeN1NZbPnloYP6LrayL6qnLVeyJUN5mvf/EuEKtw634+ZKiLBLfNH4onl8nVCJNyJiD/kaknakx2+TcU3zjLVEfu7Fxn6GuQ4xAquVZlZ+EYGYRiq8BUWItIvYxpkFiF/4nvQkYJrBCtAcsKx1sKBacpbJpOq8Sx9gaBPCKZOP0/wjsEv+2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hurPqHZzeFOfCIOQJ9je/dYcj4eufkcFdHYSuYFZeqA=;
 b=ZC6YiqhUeF2Ma97bYjkCEO7Q8mJhCVQP+tVMDf6H0EMjOac5vbZisnz6OIIExr1Te8ABauoLWpbObJjy9omBcwCeBf+MuwnnNOa8wDCfP+vRfGScHGKjt88cwRoGM0L72YmJ01DLOFNlHM61EmkMOvEfjD5on7DTan4zF0abELB2NdDoLAJttFnDUyttpXn6UT+kabBR9qdfkK4rRTw5+1a3EO2o4CSXqSo/KIWlGgwmi2WJ/Tgk7fFqBrFdiKWMm9gQLCU/RQJlZdxk/uarki+V0lzTRBMKx0PyJHYltbG9cUji8Xnivo3s+JjheZmZKe1B+cx1TRYwn9doASMzig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hurPqHZzeFOfCIOQJ9je/dYcj4eufkcFdHYSuYFZeqA=;
 b=qjFfu8S6t8CTnL1LFGRoPNxspQeDnc+0aeOTyhOvkdhGwUNREoBhYvTsgIM08natNTv+AGe/dpWu9/6HEwQfssI+EHreqkaLyAG+yzQRf6EeIdnG8sLLQwMxEN/5gXhHAmRclBVDGj2aXaoN+JKZ4Z0VaN6UrY+AmQMJktdopYs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:46 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:46 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 5/6] selftests: qdiscs: RED: Add nodrop tests
Date:   Thu, 12 Mar 2020 20:05:06 +0200
Message-Id: <20200312180507.6763-6-petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:44 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c54a1500-53dd-4642-8138-08d7c6affcd9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3499F5DC219E33EBCD837BCEDBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HbzVvDcK4shaeoAgE4nkEK5bE02BDCylVelI4QIxA7zMPjL4HMc2p7GXtI/37zHoUE4q1ebzI3sXRxZ740z4urpyyV6JDoeDt+g8Ss/DZsGZbEKN5XYHWsEk5qD8yEv3LSPnmjSi9B3aN3qarbOJVpTXNxviEOCBHlqLJm0YLqQoL18ywDSgqvzOokQUWf3sbYB1e8sEsNg+M2C8kaFygqXHEXsWPNCJ0O+PjrL/qaVBtzKhJih8hdnGHCm3M5JvOjnHHo/SbYx8SoTVivRKlwJSRFu3CF34oRMa47zT31LMFKBBdRkQGGuaMLVyQYvSvYz4bC9ngooLwUL4f6H153QQnfOPHxS9hfa9oSRwlzRvF1G+1Mp4NZZgoWNgo5VrxVjn9Pnw8lKpYpYa2zBQ94KX1UZmrDpqQdd3yxayR7fV46BneGIBmdMiySTXift
X-MS-Exchange-AntiSpam-MessageData: 8WnO4wPVrjlQXjELqqzdrZcM0gxgOoh1ncQ63eq/CArG246UXsW0svM5mMbyhAbkIzhiSHoVaTkytTwLHdb9i/9MvNg4Wz3pDh82F8QAdg2yLxuzKXJQCY26ELnwDYYom/9rIFCtks0Ovgnp7bbIHQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54a1500-53dd-4642-8138-08d7c6affcd9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:46.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzWFynv/hk4k6Im35FMXwT+acnljwO8t4LHCVbvvCoKvsZtXh75jQdOpA+xGZ7Mpemak/FBF3Fu6Xs4m8tAzUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for the new "nodrop" flag.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Rename "taildrop" to "nodrop"
    
    v2:
    - Require nsPlugin in each RED test
    - Match end-of-line to catch cases of more flags reported than
      requested
    - Add a test for creation of non-ECN taildrop, which should fail

 .../tc-testing/tc-tests/qdiscs/red.json       | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
index b70a54464897..0703a2a255eb 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -113,5 +113,73 @@
             "$TC qdisc del dev $DUMMY handle 1: root",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "53e8",
+        "name": "Create RED with flags ECN, nodrop",
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
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn nodrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn nodrop $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "d091",
+        "name": "Fail to create RED with only nodrop flag",
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
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red nodrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "af8e",
+        "name": "Create RED with flags ECN, nodrop, harddrop",
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
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red ecn harddrop nodrop limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc red 1: root .* limit 1Mb min 100Kb max 300Kb ecn harddrop nodrop $",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.20.1

