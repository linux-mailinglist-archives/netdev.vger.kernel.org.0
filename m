Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237D8181F8F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgCKRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:33 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730458AbgCKRec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJb0KrlsbsP9rjH4OJJJ7WRxBIhcXRVzQBzp6zMe3zPkw6a1IJNmjPwYb4YkU4u7e8kBkQIar5SDZ7f3++KM5vzJDcUkLstsyo5ogLSy0IeLgceSl3o/MtH3OU/IcgEJc1LymXERvMYjhgytYGU61xwkV4JJ+lMPZq+vbv1oTjEVy87iTrF3ArxS51XApsVMHi59wARiZX0lX5C2cMXz9htJFr1wXuC0ejgoR0p4Z/uJldA6Byv19SyuYD9PmbeiZSSObEhO9HjL9/8MT65lhlUhPbHarcmt7xVwxWHgE2GPFXMCswBwJ1cOqrx64cwwYW0RzCkR8AxsuVwYV/n+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOykC8nD/iaUzxsdZ35xdEzrhggWwtcc6h1Fs1Jl/UI=;
 b=WpRvucQLm8HlbIQsU1Ger5b1f9ER9ZmoM2qFRKowzmL2D/VVoidO7cCfal17T57jAxGGCWyU/tsa/1FaVYUERvlv92Vr2J8ggpeQkwbMAtF4v/3CrxIivgnpz8jjhhkpfHT0Az56lTnkuowSsEPdJycVj7lnHQfKejbxdxL1VkVhDg3/L9fH+0GG23Bpd4d0w0m748MWTMtGBehtkqmTbH9EImNV/paVVHUDaQkaMa2TVuaoM0o/gKEzt8O9dAC/cx+K1YaKDQ184diEl7F0qNNHsShmEaEJZbbvciGsHbPqTmjafGeWwIWF0j9twONbhkqg31xjZXRprUKsaIXQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOykC8nD/iaUzxsdZ35xdEzrhggWwtcc6h1Fs1Jl/UI=;
 b=U1yJdgzu4RG/HwnkFAwxINdDx0WiCsjMBTgmuAHw3O3nNEvXVH41qqBzzMXh6+OSZCCvetHS70W7J0VQR1izkLppovdK/D2CioIzCJBlSvb5tZ+6I66P3J2h+k+9bxvU5jF/+ARmarDpT9xCXR2xMfqHOdoalirIs85yNoiJwRM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:28 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:28 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v2 1/6] selftests: qdiscs: Add TDC test for RED
Date:   Wed, 11 Mar 2020 19:33:51 +0200
Message-Id: <20200311173356.38181-2-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:27 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82e471b4-a33e-46d4-72a5-08d7c5e27347
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34498D3FB39B6961EE00E4E7DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SYRcVIaGkKz765HPqUkiL6ttZ7o6ZtRGFdLHGCIAAHUL62djy3afsnSCPoxsDrSaaXMBGax9oypRMfJTHXF2D+ft4eXL9fU4RyORLKeP2Y9PPbzTM7uT1JXV7c+Oo4Yd1pTKtcS0ZlQFM1E+MISFFU9Gl0ZOY4DAgmOT/g10VD93Glsd2fxp575v0wSxmRoEmqIu0Dybr9QKWjnKsQTdk6loYYJmgL39JWF4wMrqxMBecTDLeATxbMXZ3rUTPa3R4YLI3A4Okwq33JFZ1n9v/6OgtTL0TBIeJ/YQRd6U0ik3CUz4GJbrwC+F2L8buJprqx0DDnQhSWwOjqm9YncvWZiVTSFDqZ8cbIPKDcM5PNLXUy+tX3SEtrXy0wZ6znc8CPlrSJnyz8TLK2Fe66bX9Xx7uhspCBCLOKczLijJQf0wZNN4Wx30mcrEFObaqOTH
X-MS-Exchange-AntiSpam-MessageData: B5Jlf5pu8lHfuUqgsOI2ZBIubQqot0mCb4UIFp9I4jObl1GNYMSEacjjTC5Wn5QUGhYgSlOy/HQcXLHiO9VBS5QfDUqNDCe0mOGBXrPz82psqeYCwTaV7lhYW6tKiejvKwbsPIjQacWfworsNbLKTg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e471b4-a33e-46d4-72a5-08d7c5e27347
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:28.5846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3cgYPNv8y1RbQbr8kfUsW/Zi91s5nJmeNrg4x957bTWUZ60DG+7wD7JWW+QB+QKlxOmLOpU6/u4L+58uqqWIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a handful of tests for creating RED with different flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
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

