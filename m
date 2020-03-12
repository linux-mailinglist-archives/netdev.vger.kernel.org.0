Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB35183D1A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCLXMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:55 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgCLXMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwTXXZePUVZKGoK+cZIYiqPOdWHl6jsluVDtara0go0u2Y9ZL1khYCF6CVLUOCcwYD0lJtxRMF4bub5tGUciVm58AFM4rpvOyS4JnKUtxGJty2sodU4uhY0OC4RATVMEfZ5zpCXcsDn9Jaoc8nQz0J68J94OxO55jXOYQd6x5mU7cY7NcFixx5VrCbvgasX3hPlS44fIXwgFJtYUbnKLB+x6r/lR4+rlTMvwA1hiuuVNpWzZVI0XINtg6/AuN4Ly1Oi1qy8K9FGsIvD8hgbDmTdGJ5p+nlYfSCdlwUW2u+coexhV2KntVSWNR0M2MNkCD19xlR1358xjaSKU5MaXJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hurPqHZzeFOfCIOQJ9je/dYcj4eufkcFdHYSuYFZeqA=;
 b=bKazEfNExDHn6PnuKro3EbucqaXt402QTMMuT9gZi84epn0nBW9i1sSQqzmJoxNDhWPNKb4GH1RKv4agWV7MiVO+zPw0vrT1xhYdT9OH4YGSpKxmVWB7iQFVbz5FSXq7bLCnSLZjcOgEnRhGw4mrPTpPZRudsuiyU6FhWNpsV07/Y2IbfN2gBaEciS1Cyi48NXe2lt08naEaNy7FThBvVxpeiYKlXfvcOWvVQ94kEfQhuDiHJCJ8BL8qtgKa0zG8sX+eDatu/2mEmxqY0IgunXZWMiGYC5GfgPr9RYNcaJMLkW6mxxnMA6bWVJV+9IzV3jLBHd12++ZACWf0FUTNUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hurPqHZzeFOfCIOQJ9je/dYcj4eufkcFdHYSuYFZeqA=;
 b=eTABX2Fdrs1CiElyiHmRaM/Wks+LK1wNpCw6sD52d93y7KxMUD5IpBbnrQo5KUSjyu+N5eg0dqn1qMiY5UyqdXnzQuJlBuuSGq/o4V+p+DpWW3tekNMQHEGZNgEz/NZwmMc6Hht8us2WrzJq/Tnai9jIAC9C34c26GtsMPulQNU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:44 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:44 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 5/6] selftests: qdiscs: RED: Add nodrop tests
Date:   Fri, 13 Mar 2020 01:10:59 +0200
Message-Id: <20200312231100.37180-6-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312231100.37180-1-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:42 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbaaf41b-c94e-44bf-6e3a-08d7c6dadec7
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194F30D217108015EFE8E73DBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbcsGmciXlnizUWswDXuP9UnSbiWhG0xlrKzhIIwComtlw5HZVCD4hqtvEYjgnbKf/aaFLavtgaKlI4/Q9pTdQIVpJ6qrquxP8XWEwPHMvZo5kyT2QCpE3UGNM8t7rwmJq8Ie6UYSd3j9O5HgI7D42rsfSwUSrGfgrtRy6WVQgHZ0XtJ2lSqOwTGyE5Dmc36U6+3OGMkGS3SlFKRQPSXAUuWTsiToRkgzxIEy7aPzNLQeTfMS5l8/MBG/AlQf9igmSVUXV765PlnCL4zcTbqakoxxWD6c6isBAcgPlgFTX+8cHpFVm5Gq6lJm7444lyuAY4MjGDW+LngjmK4zqVK6iE5TJHzFIOxldYTAOY3waMvd8YrvvdMe+u6iZDhXEMuuhF1HlEgWeeeIZW7d3wAbEhpbTcp0XLnCV87J36dzoP+OeB/CfVJr9W1zQh6ds2H
X-MS-Exchange-AntiSpam-MessageData: 3o0XLG+2jtj/Hlq1T4veb6ux66ugdsHchvEaneKDiYmY9htCMZ2GTYcBF07ftRHRtm1Jg60AmpQ9tyS71Q/57gyy1PyoeG5ooPg9FAQFQuwMoxxMAXs7J2ZDByHzK/V0arYxqcZ6GvUew93AYIHjew==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbaaf41b-c94e-44bf-6e3a-08d7c6dadec7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:44.1515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaxY793jMJIrzKXqJJmxrACdZ49sMoW74nE07YYmdDQ1MTu9+3utDRRHSo5j9aPxQ0I8Rz7wjgbrkNkSJwVhZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
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

